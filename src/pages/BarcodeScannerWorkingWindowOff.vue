<template>
  <div class="scanner-container">
    <!-- FIX 1: Appended the video-canvas-target class to hook up your scoped CSS deep overrides -->
    <div id="qr-reader" ref="videoRef" class="video-canvas-target"></div>

    <div v-if="scanning" class="scanner-overlay-wrapper">
      <div class="focus-window-box">
        <div class="corner-bracket top-left"></div>
        <div class="corner-bracket top-right"></div>
        <div class="corner-bracket bottom-left"></div>
        <div class="corner-bracket bottom-right"></div>

        <div class="aiming-laser-line"></div>
      </div>

      <p class="scan-instruction-text">Align barcode horizontally within the box</p>
    </div>
  </div>
</template>

<script setup>
import { ref, onBeforeUnmount, nextTick, onMounted } from 'vue'
import { Html5Qrcode, Html5QrcodeSupportedFormats } from 'html5-qrcode'

// ============================================================
// EVENTS
// ============================================================
const emit = defineEmits(['detected', 'product-found', 'product-not-found', 'error'])

// ============================================================
// REFS / STATE
// ============================================================
const videoRef = ref(null) // HTML element where stream will mount

const cameras = ref([])
const selectedCameraId = ref('')

const scanning = ref(false)
const lookingUp = ref(false)

const product = ref(null)
const productNotFound = ref(false)

const scannedBarcode = ref('')

const errorMessage = ref('')
const statusMessage = ref('')
const statusType = ref('')

//const nutritionBasis = ref('serving')

// html5-qrcode scanner instance reference
let html5QrcodeInstance = null

// Used to prevent multiple simultaneous requests
let processingBarcode = false
let lookupController = null

// ============================================================
// CAMERA DISCOVERY
// ============================================================
async function getCameras() {
  try {
    const devices = await Html5Qrcode.getCameras()
    cameras.value = devices

    if (devices && devices.length > 0) {
      // Isolate the rear camera array for food product scanning
      const rearCamera = devices.find((camera) => {
        const label = camera.label?.toLowerCase() || ''
        return label.includes('back') || label.includes('rear') || label.includes('environment')
      })

      selectedCameraId.value = rearCamera?.deviceId || devices[0].deviceId
    } else {
      // Explicitly reset if empty array is returned due to initial permission lockouts
      selectedCameraId.value = ''
    }
  } catch (error) {
    console.warn('Camera discovery fallback enabled:', error.message || error)
    selectedCameraId.value = '' // Fall back to facingMode constraint logic below
  }
}

// ============================================================
// START SCANNER
// ============================================================
async function startScanner() {
  errorMessage.value = ''
  product.value = null
  productNotFound.value = false
  scannedBarcode.value = ''
  processingBarcode = false

  try {
    if (!cameras.value.length) {
      await getCameras()
    }

    scanning.value = true
    statusMessage.value = 'Position food barcode inside the frame...'
    statusType.value = 'info'

    await nextTick()

    const elementId = videoRef.value?.id || 'qr-reader'
    if (!elementId) {
      throw new Error('Target container wrapper element was missing an ID string attribute.')
    }

    if (!html5QrcodeInstance) {
      html5QrcodeInstance = new Html5Qrcode(elementId, { verbose: false })
    }

    /*
     * FIX 1: Isolate the Camera Selector to EXACTLY 1 object key
     * html5-qrcode strictly mandates that this object only holds deviceId OR facingMode.
     */
    const cameraSelector = { facingMode: 'environment' }

    /*
     * FIX 2: Move resolution modifiers to videoConstraints
     * Advanced hardware dimensions go inside the global config object,
     * which safely delivers them down to the browser's getUserMedia engine.
     */
    const config = {
      fps: 20,
      useBarCodeDetectorIfSupported: true,

      qrbox: (videoWidth, videoHeight) => {
        return {
          width: Math.floor(videoWidth * 0.8),
          height: Math.floor(videoHeight * 0.4),
        }
      },
      formatsToSupport: [
        Html5QrcodeSupportedFormats.UPC_A,
        Html5QrcodeSupportedFormats.EAN_13,
        Html5QrcodeSupportedFormats.UPC_E,
        Html5QrcodeSupportedFormats.EAN_8,
      ],
      videoConstraints: {
        facingMode: { ideal: 'environment' },
        width: { min: 1280, ideal: 1920 },
        height: { min: 720, ideal: 1080 },
      },
    }

    // Fire up the hardware engine loop with separated inputs
    await html5QrcodeInstance.start(
      cameraSelector, // Argument 1: Strictly selection identifiers (1 key max)
      config, // Argument 2: All resolutions, bounds, and engine settings
      (decodedText, decodedResult) => {
        if (!processingBarcode) {
          const standardFormat = decodedResult?.result?.format?.formatName || 'UNKNOWN'
          processBarcode(decodedText, standardFormat)
        }
      },
      () => {
        // FRAME FAILURE HANDLER: Ignored intentionally to avoid log flood
      },
    )

    console.log('✅ html5-qrcode pipeline attached and actively parsing video layers.')
  } catch (error) {
    console.error('❌ Failed to establish scanning pipeline:', error)
    scanning.value = false
    errorMessage.value = error.message || 'Camera stream failed to load.'
    emit('error', error)
  }
}

// ============================================================
// PROCESS BARCODE
// ============================================================
async function processBarcode(barcode, format) {
  if (processingBarcode) return
  processingBarcode = true

  console.log('🔎 LOOKING UP PRODUCT', { barcode, format })
  scannedBarcode.value = barcode

  emit('detected', { barcode, format })

  // FIX 1: Safely teardown the camera state before executing remote API calls
  await stopScanner(false)

  lookingUp.value = true
  statusMessage.value = 'Looking up product info...'
  statusType.value = 'info'

  try {
    const result = await lookupFood(barcode)

    if (!result) {
      product.value = null
      productNotFound.value = true
      statusMessage.value = ''
      statusType.value = ''
      emit('product-not-found', barcode)
      return
    }

    product.value = result
    productNotFound.value = false
    statusMessage.value = 'Product found.'
    statusType.value = 'success'
    emit('product-found', result)
  } catch (error) {
    if (error.name === 'AbortError') return

    console.error('Open Food Facts API request error:', error)
    errorMessage.value = 'We could not retrieve product information. Please retry.'
    emit('error', error)
  } finally {
    lookingUp.value = false
    processingBarcode = false
  }
}

// ============================================================
// STOP SCANNER
// ============================================================
async function stopScanner(clearStatus = true) {
  scanning.value = false

  if (html5QrcodeInstance) {
    /*
     * FIX 2: Defer Execution Hook
     * Wrapping this in a small Promise delay pushes the stop action to the next event loop tick,
     * resolving the library's internal state collision.
     */
    await new Promise((resolve) => setTimeout(resolve, 100))

    try {
      if (html5QrcodeInstance.isScanning) {
        await html5QrcodeInstance.stop()
      }
      html5QrcodeInstance = null
    } catch (err) {
      console.warn('Bypassed minor state warning safely:', err.message || err)
    }
  }

  if (clearStatus) {
    statusMessage.value = ''
    statusType.value = ''
  }
}

// ============================================================
// OPEN FOOD FACTS LOOKUP
// ============================================================
async function lookupFood(barcode) {
  lookupController = new AbortController()

  const fields = [
    'code',
    'product_name',
    'product_name_en',
    'generic_name',
    'brands',
    'image_front_url',
    'serving_size',
    'nutriments',
    'nutriscore_grade',
    'nutrition_grades',
    'ingredients_text',
    'allergens',
  ].join(',')

  /*
   * FIX 3: Re-structured string literal sequence with mandatory slashes.
   * This prevents your browser from misinterpreting the numbers as part of the domain name.
   */

  const cleanBarcode = encodeURIComponent(barcode.trim())

  const url =
    `https://openfoodfacts.net` + `${cleanBarcode}.json` + `?fields=${encodeURIComponent(fields)}`

  const response = await fetch(url, {
    method: 'GET',
    signal: lookupController.signal,
    headers: { Accept: 'application/json' },
  })

  if (!response.ok) {
    throw new Error(`Open Food Facts API Error HTTP: ${response.status}`)
  }

  const data = await response.json()
  return data.status === 1 ? data.product : null
}

// ============================================================
// LIFECYCLE HOOKS
// ============================================================
onMounted(async () => {
  // Automatically boots up camera track pipelines when the page mounts
  await startScanner()
})

onBeforeUnmount(async () => {
  await stopScanner(true)
  if (lookupController) {
    lookupController.abort()
  }
})
</script>

<style scoped>
/* Main container anchoring everything together */
.scanner-container {
  position: relative;
  width: 100%;
  max-width: 500px;
  margin: 0 auto;
  border-radius: 12px;
  overflow: hidden;
  background-color: #000000;
  aspect-ratio: 4 / 3; /* Matches standard camera video streams */
}

/*
 * CRITICAL FIX: Hide html5-qrcode's auto-generated bounding box frames.
 * This removes their duplicate lines, borders, and empty canvas spaces.
 */
.video-canvas-target :deep(#qr-reader__scan_region) {
  border: none !important;
  background: transparent !important;
}

.video-canvas-target :deep(canvas) {
  display: none !important; /* Hides the library's internal drawing snapshots */
}

/* Ensure html5-qrcode video element scales fluidly to fill container walls */
.video-canvas-target :deep(video) {
  width: 100% !important;
  height: 100% !important;
  object-fit: cover !important;
}

/* Overlay wrapper that masks the camera stream layout */
.scanner-overlay-wrapper {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  pointer-events: none; /* Allows click-to-focus triggers to bypass the overlay layer */
  z-index: 10;
}

/* Targeted Focus Window: Matches the 80% x 40% configuration passed into your JS config */
.focus-window-box {
  position: relative;
  width: 80%;
  height: 40%;
  box-shadow: 0 0 0 9999px rgba(0, 0, 0, 0.55); /* Creates the dark outer mask layer */
  border-radius: 4px;
}

/* Red Laser Beam Guide Line */
.aiming-laser-line {
  position: absolute;
  left: 5%;
  width: 90%;
  height: 2px;
  background-color: #ff3b30; /* High contrast crimson red */
  box-shadow:
    0 0 8px #ff3b30,
    0 0 2px #ff3b30;
  animation: laser-scan-motion 2s ease-in-out infinite;
}

/* Corner bracket targets helping users frame food boxes */
.corner-bracket {
  position: absolute;
  width: 16px;
  height: 16px;
  border: 3px solid #ffffff; /* Sharp white tracking corners */
}
.top-left {
  top: -2px;
  left: -2px;
  border-right: none;
  border-bottom: none;
  border-top-left-radius: 4px;
}
.top-right {
  top: -2px;
  right: -2px;
  border-left: none;
  border-bottom: none;
  border-top-right-radius: 4px;
}
.bottom-left {
  bottom: -2px;
  left: -2px;
  border-right: none;
  border-top: none;
  border-bottom-left-radius: 4px;
}
.bottom-right {
  bottom: -2px;
  right: -2px;
  border-left: none;
  border-top: none;
  border-bottom-right-radius: 4px;
}

/* Instructional text label layout styling */
.scan-instruction-text {
  margin-top: 24px;
  color: #ffffff;
  font-family:
    system-ui,
    -apple-system,
    sans-serif;
  font-size: 14px;
  font-weight: 500;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.8);
  letter-spacing: 0.5px;
  text-align: center;
  padding: 6px 14px;
  background-color: rgba(0, 0, 0, 0.4);
  border-radius: 20px;
}

/* Smooth keyframes bouncing the alignment laser line up and down */
@keyframes laser-scan-motion {
  0% {
    top: 15%;
  }
  50% {
    top: 85%;
  }
  100% {
    top: 15%;
  }
}
</style>
