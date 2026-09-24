<template>
  <div class="barcode-scanner">
    <div class="scanner-header">
      <button class="close-button" @click="close">Cancel</button>

      <span>Scan Barcode</span>
    </div>

    <div v-if="lastBarcode" class="barcode-result">Last scanned barcode: {{ lastBarcode }}</div>

    <div ref="scannerContainer" class="scanner-container">
      <div class="scanner-overlay">
        <div class="scanner-target">
          <div class="scanner-line"></div>
        </div>
      </div>
    </div>

    <div v-if="error" class="scanner-error">
      {{ error }}
    </div>

    <div class="scanner-instructions">Position the barcode inside the box</div>
  </div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue'
import Quagga from '@ericblade/quagga2'

const emit = defineEmits(['detected', 'close'])

const scannerContainer = ref(null)
const error = ref(null)

const cameras = ref([])
const selectedCamera = ref(null)

let scannerStarted = false
let detected = false
const lastBarcode = ref(null)
// Track repeated detections
const barcodeCandidates = new Map()

let candidateTimer = null

async function getCameras() {
  try {
    const devices = await navigator.mediaDevices.enumerateDevices()

    cameras.value = devices.filter((device) => device.kind === 'videoinput')

    console.log('Available cameras:', cameras.value)

    const rearCamera = cameras.value.find((camera) => /back|rear|environment/i.test(camera.label))

    if (rearCamera) {
      selectedCamera.value = rearCamera.deviceId
    }
  } catch (err) {
    console.error('Unable to enumerate cameras:', err)
  }
}

function initScanner() {
  if (!scannerContainer.value) {
    return
  }

  Quagga.onDetected(handleDetected)

  Quagga.init(
    {
      inputStream: {
        type: 'LiveStream',

        target: scannerContainer.value,

        constraints: {
          facingMode: {
            ideal: 'environment',
          },

          width: {
            min: 640,
            ideal: 1280,
            max: 1920,
          },

          height: {
            min: 480,
            ideal: 720,
            max: 1080,
          },

          aspectRatio: {
            ideal: 16 / 9,
          },
        },
      },

      locator: {
        patchSize: 'medium',
        halfSample: false,
      },

      numOfWorkers: navigator.hardwareConcurrency ? Math.min(navigator.hardwareConcurrency, 4) : 2,

      frequency: 15,

      decoder: {
        readers: ['ean_reader', 'upc_reader'],
      },

      locate: true,
    },

    function (err) {
      if (err) {
        console.error('Quagga initialization error:', err)

        error.value = 'Unable to access the camera. Please check your camera permissions.'

        return
      }

      console.log('Quagga initialized successfully')

      scannerStarted = true

      Quagga.start()

      console.log('Quagga started')

      // Give the camera a moment to initialize,
      // then report the actual video resolution.
      setTimeout(() => {
        const video = scannerContainer.value?.querySelector('video')

        if (video) {
          console.log('Camera resolution:', {
            width: video.videoWidth,
            height: video.videoHeight,
          })

          console.log('Camera element:', video)
        } else {
          console.warn('Quagga started but video element was not found')
        }
      }, 1000)
    },
  )
}

function handleDetected(result) {
  if (detected) {
    return
  }

  const code = result?.codeResult?.code

  if (!code) {
    return
  }

  console.log('Potential barcode:', code)

  // Only allow numeric UPC/EAN values
  if (!/^\d+$/.test(code)) {
    return
  }

  // UPC-A = 12 digits
  // EAN-13 = 13 digits
  if (code.length !== 12 && code.length !== 13) {
    console.log('Ignoring invalid length:', code)
    return
  }

  // Validate check digit
  if (!isValidBarcode(code)) {
    console.log('Ignoring invalid check digit:', code)
    return
  }

  console.log('Valid barcode candidate:', code)

  // Count repeated detections
  const count = (barcodeCandidates.get(code) || 0) + 1

  barcodeCandidates.set(code, count)

  console.log(`Barcode ${code} detected ${count} time(s)`)

  // Require 3 matching detections
  lastBarcode.value = code
  if (count >= 3) {
    confirmBarcode(code)
  }
}

function confirmBarcode(code) {
  if (detected) {
    return
  }

  detected = true

  lastBarcode.value = code

  console.log('CONFIRMED BARCODE:', code)

  stopScanner()

  emit('detected', code)
}

function isValidBarcode(code) {
  const digits = code.split('').map(Number)

  const checkDigit = digits.pop()

  let sum = 0

  // Starting from the rightmost data digit,
  // multiply alternating digits by 3.
  for (let i = digits.length - 1; i >= 0; i--) {
    const position = digits.length - i

    sum += digits[i] * (position % 2 === 1 ? 3 : 1)
  }

  const calculated = (10 - (sum % 10)) % 10

  return calculated === checkDigit
}

function stopScanner() {
  if (scannerStarted) {
    Quagga.stop()

    scannerStarted = false
  }
}

function close() {
  console.log('Closing barcode scanner')

  stopScanner()

  emit('close')
}

onMounted(async () => {
  await getCameras()
  initScanner()
})

onBeforeUnmount(() => {
  Quagga.offDetected(handleDetected)

  stopScanner()

  if (candidateTimer) {
    clearInterval(candidateTimer)
    candidateTimer = null
  }

  barcodeCandidates.clear()
})
</script>

<style scoped>
.barcode-scanner {
  position: fixed;
  inset: 0;
  z-index: 9999;

  background: #000;

  color: #fff;
}

/* Header */

.scanner-header {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;

  z-index: 10;

  height: 60px;

  display: flex;
  align-items: center;
  justify-content: space-between;

  padding: 0 16px;

  background: rgba(0, 0, 0, 0.65);

  font-size: 18px;
  font-weight: 600;
}

.close-button {
  border: none;
  background: transparent;

  color: #fff;

  font-size: 16px;

  cursor: pointer;
}

/* Camera */

.scanner-container {
  width: 100%;
  height: 100%;

  overflow: hidden;
}

.scanner-container :deep(video) {
  width: 100%;
  height: 100%;

  object-fit: cover;
}

.scanner-container :deep(canvas) {
  display: none;
}

/* Overlay */

.scanner-overlay {
  position: absolute;

  inset: 0;

  z-index: 5;

  display: flex;
  align-items: center;
  justify-content: center;

  pointer-events: none;
}

.scanner-target {
  position: relative;

  width: 90%;
  max-width: 500px;

  height: 120px;

  border: 2px solid #22c55e;

  border-radius: 12px;

  box-shadow: 0 0 0 9999px rgba(0, 0, 0, 0.45);
}

/* Scanning animation */

.scanner-line {
  position: absolute;

  left: 0;
  right: 0;

  height: 2px;

  background: #22c55e;

  box-shadow: 0 0 8px #22c55e;

  animation: scan 2s ease-in-out infinite;
}

@keyframes scan {
  0% {
    top: 5px;
  }

  50% {
    top: calc(100% - 5px);
  }

  100% {
    top: 5px;
  }
}

/* Error */

.scanner-error {
  position: absolute;

  bottom: 80px;
  left: 20px;
  right: 20px;

  z-index: 20;

  padding: 16px;

  background: #dc2626;

  border-radius: 8px;

  text-align: center;
}

/* Instructions */

.scanner-instructions {
  position: absolute;

  bottom: 25px;
  left: 0;
  right: 0;

  z-index: 10;

  text-align: center;

  font-size: 14px;

  color: rgba(255, 255, 255, 0.9);
}
</style>
