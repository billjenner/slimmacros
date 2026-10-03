<template>
  <div class="scanner-page">
    <!-- =====================================================
         HEADER
    ====================================================== -->

    <header class="page-header">
      <h1>Food Scanner</h1>
      <p>Scan a food barcode to view nutrition information.</p>
    </header>

    <!-- =====================================================
         SCANNER
    ====================================================== -->

    <section class="scanner-card">
      <div class="scanner-container">
        <video ref="videoRef" class="scanner-video" autoplay muted playsinline></video>

        <!-- Dark overlay -->
        <div v-if="scanning" class="scanner-overlay">
          <div class="scan-box">
            <span class="corner top-left"></span>
            <span class="corner top-right"></span>
            <span class="corner bottom-left"></span>
            <span class="corner bottom-right"></span>

            <div class="scan-line"></div>
          </div>

          <div class="scan-instructions">Place the barcode inside the box</div>
        </div>

        <!-- Camera not running -->
        <div v-if="!scanning && !lookingUp" class="camera-placeholder">
          <div class="camera-icon">📷</div>

          <p>Press <strong>Start Scanner</strong> to begin.</p>
        </div>

        <!-- Looking up product -->
        <div v-if="lookingUp" class="lookup-overlay">
          <div class="spinner"></div>

          <p>Looking up product...</p>
        </div>
      </div>

      <!-- =================================================
           CAMERA SELECTION
      ================================================== -->

      <div v-if="cameras.length > 1" class="camera-selection">
        <label for="camera"> Camera </label>

        <select id="camera" v-model="selectedCameraId" :disabled="scanning || lookingUp">
          <option v-for="camera in cameras" :key="camera.deviceId" :value="camera.deviceId">
            {{ camera.label || 'Camera' }}
          </option>
        </select>
      </div>

      <!-- =================================================
           CONTROLS
      ================================================== -->

      <div class="controls">
        <button
          v-if="!scanning && !lookingUp"
          type="button"
          class="button button-start"
          @click="startScanner"
        >
          Start Scanner
        </button>

        <button v-if="scanning" type="button" class="button button-stop" @click="stopScanner">
          Stop Scanner
        </button>

        <button
          v-if="lookingUp"
          type="button"
          class="button button-secondary"
          @click="cancelLookup"
        >
          Cancel
        </button>
      </div>

      <!-- =================================================
           SCAN STATUS
      ================================================== -->

      <div v-if="statusMessage" class="status-message" :class="statusType">
        {{ statusMessage }}
      </div>

      <!-- =================================================
           ERROR
      ================================================== -->

      <div v-if="errorMessage" class="error-message">
        <strong>Something went wrong</strong>

        <p>{{ errorMessage }}</p>

        <button type="button" class="retry-button" @click="clearError">Dismiss</button>
      </div>
    </section>

    <!-- =====================================================
         PRODUCT RESULT
    ====================================================== -->

    <section v-if="product" class="product-card">
      <!-- Product header -->
      <div class="product-header">
        <div v-if="product.image_front_url" class="product-image-wrapper">
          <img :src="product.image_front_url" :alt="productName" class="product-image" />
        </div>

        <div class="product-title">
          <div v-if="product.brands" class="brand">
            {{ product.brands }}
          </div>

          <h2>
            {{ productName }}
          </h2>

          <p v-if="product.generic_name" class="generic-name">
            {{ product.generic_name }}
          </p>

          <p class="barcode">Barcode: {{ scannedBarcode }}</p>
        </div>
      </div>

      <!-- =================================================
           SERVING INFORMATION
      ================================================== -->

      <div class="serving-info">
        <div>
          <span class="label">Serving size</span>

          <strong>
            {{ product.serving_size || 'Not available' }}
          </strong>
        </div>

        <div>
          <span class="label">Data source</span>

          <strong> Open Food Facts </strong>
        </div>
      </div>

      <!-- =================================================
           NUTRITION
      ================================================== -->

      <div class="nutrition-section">
        <div class="section-title-row">
          <h3>Nutrition</h3>

          <div class="nutrition-toggle">
            <button
              type="button"
              :class="{ active: nutritionBasis === 'serving' }"
              @click="nutritionBasis = 'serving'"
            >
              Per serving
            </button>

            <button
              type="button"
              :class="{ active: nutritionBasis === '100g' }"
              @click="nutritionBasis = '100g'"
            >
              Per 100g
            </button>
          </div>
        </div>

        <!-- Calories -->
        <div class="calories-card">
          <div>
            <span>Calories</span>
          </div>

          <strong>
            {{ formatNumber(nutrition.calories) }}
            <small>kcal</small>
          </strong>
        </div>

        <!-- Macros -->
        <div class="macro-grid">
          <!-- Protein -->
          <div class="macro-card protein">
            <span class="macro-label"> Protein </span>

            <strong>
              {{ formatNumber(nutrition.protein) }}
              <small>g</small>
            </strong>
          </div>

          <!-- Carbs -->
          <div class="macro-card carbs">
            <span class="macro-label"> Carbs </span>

            <strong>
              {{ formatNumber(nutrition.carbs) }}
              <small>g</small>
            </strong>
          </div>

          <!-- Fat -->
          <div class="macro-card fat">
            <span class="macro-label"> Fat </span>

            <strong>
              {{ formatNumber(nutrition.fat) }}
              <small>g</small>
            </strong>
          </div>
        </div>

        <!-- Additional nutrients -->
        <div class="nutrition-list">
          <div class="nutrition-row">
            <span>Fiber</span>

            <strong>
              {{ formatNumber(nutrition.fiber) }}
              <small>g</small>
            </strong>
          </div>

          <div class="nutrition-row">
            <span>Sugars</span>

            <strong>
              {{ formatNumber(nutrition.sugar) }}
              <small>g</small>
            </strong>
          </div>

          <div class="nutrition-row">
            <span>Saturated fat</span>

            <strong>
              {{ formatNumber(nutrition.saturatedFat) }}
              <small>g</small>
            </strong>
          </div>

          <div class="nutrition-row">
            <span>Sodium</span>

            <strong>
              {{ formatNumber(nutrition.sodium) }}
              <small>mg</small>
            </strong>
          </div>
        </div>
      </div>

      <!-- =================================================
           NUTRI-SCORE
      ================================================== -->

      <div v-if="product.nutriscore_grade" class="nutriscore-section">
        <span> Nutri-Score </span>

        <span class="nutriscore" :class="`score-${product.nutriscore_grade.toLowerCase()}`">
          {{ product.nutriscore_grade.toUpperCase() }}
        </span>
      </div>

      <!-- =================================================
           INGREDIENTS
      ================================================== -->

      <div v-if="product.ingredients_text" class="info-section">
        <h3>Ingredients</h3>

        <p>
          {{ product.ingredients_text }}
        </p>
      </div>

      <!-- =================================================
           ALLERGENS
      ================================================== -->

      <div v-if="product.allergens" class="info-section">
        <h3>Allergens</h3>

        <p>
          {{ product.allergens }}
        </p>
      </div>

      <!-- =================================================
           SCAN ANOTHER
      ================================================== -->

      <button type="button" class="button button-start scan-another" @click="scanAnother">
        Scan Another Product
      </button>
    </section>

    <!-- =====================================================
         PRODUCT NOT FOUND
    ====================================================== -->

    <section v-if="productNotFound" class="not-found-card">
      <div class="not-found-icon">🔎</div>

      <h2>Product Not Found</h2>

      <p>
        We scanned barcode
        <strong>{{ scannedBarcode }}</strong
        >, but Open Food Facts does not have a product matching that barcode.
      </p>

      <p class="hint">
        You can try scanning the barcode again or manually verify that the barcode is correct.
      </p>

      <button type="button" class="button button-start" @click="scanAnother">
        Scan Another Product
      </button>
    </section>
  </div>
</template>

<script setup>
import { ref, computed, onBeforeUnmount } from 'vue'

import { BrowserMultiFormatReader } from '@zxing/browser'
import { BarcodeFormat, DecodeHintType } from '@zxing/library'

// ============================================================
// EVENTS
// ============================================================

const emit = defineEmits(['detected', 'product-found', 'product-not-found', 'error'])

// ============================================================
// REFS / STATE
// ============================================================

const videoRef = ref(null)

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

const nutritionBasis = ref('serving')

// ZXing reader
let reader = null
let controls = null

// Used to prevent multiple scans while processing
let processingBarcode = false

// Used if user cancels an in-progress lookup
let lookupController = null

// ============================================================
// ZXING FORMATS
// ============================================================

const hints = new Map()

hints.set(DecodeHintType.POSSIBLE_FORMATS, [
  // Food product barcodes
  BarcodeFormat.EAN_13,
  BarcodeFormat.EAN_8,
  BarcodeFormat.UPC_A,
  BarcodeFormat.UPC_E,

  // Keep QR support
  BarcodeFormat.QR_CODE,
])

// ============================================================
// PRODUCT NAME
// ============================================================

const productName = computed(() => {
  if (!product.value) {
    return ''
  }

  return product.value.product_name || product.value.product_name_en || 'Unknown Product'
})

// ============================================================
// NUTRITION DATA
// ============================================================

const nutrition = computed(() => {
  if (!product.value?.nutriments) {
    return {
      calories: null,
      protein: null,
      carbs: null,
      fat: null,
      fiber: null,
      sugar: null,
      saturatedFat: null,
      sodium: null,
    }
  }

  const n = product.value.nutriments

  if (nutritionBasis.value === 'serving') {
    return {
      calories: n['energy-kcal_serving'],
      protein: n['proteins_serving'],
      carbs: n['carbohydrates_serving'],
      fat: n['fat_serving'],
      fiber: n['fiber_serving'],
      sugar: n['sugars_serving'],
      saturatedFat: n['saturated-fat_serving'],

      // Open Food Facts normally reports sodium in grams.
      // Convert to mg for display.
      sodium: gramsToMilligrams(n['sodium_serving']),
    }
  }

  return {
    calories: n['energy-kcal_100g'],
    protein: n['proteins_100g'],
    carbs: n['carbohydrates_100g'],
    fat: n['fat_100g'],
    fiber: n['fiber_100g'],
    sugar: n['sugars_100g'],
    saturatedFat: n['saturated-fat_100g'],

    sodium: gramsToMilligrams(n['sodium_100g']),
  }
})

// ============================================================
// CAMERA DISCOVERY
// ============================================================

async function getCameras() {
  try {
    const devices = await BrowserMultiFormatReader.listVideoInputDevices()

    cameras.value = devices

    if (!devices.length) {
      throw new Error('No camera was found.')
    }

    /*
     * Prefer a rear/environment camera.
     *
     * Camera labels aren't always available until the user
     * grants permission, so we fall back to the first camera.
     */
    const rearCamera = devices.find((camera) => {
      const label = camera.label?.toLowerCase() || ''

      return label.includes('back') || label.includes('rear') || label.includes('environment')
    })

    selectedCameraId.value = rearCamera?.deviceId || devices[0].deviceId
  } catch (error) {
    console.error(error)

    throw new Error('Unable to access the camera. Please make sure camera permission is enabled.')
  }
}

// ============================================================
// START SCANNER
async function startScanner() {
  clearMessages()

  product.value = null
  productNotFound.value = false
  scannedBarcode.value = ''

  processingBarcode = false

  try {
    // Discover cameras
    if (!cameras.value.length) {
      await getCameras()
    }

    if (!selectedCameraId.value) {
      throw new Error('No camera is available.')
    }

    // Create reader
    if (!reader) {
      reader = new BrowserMultiFormatReader(hints)
    }

    scanning.value = true

    statusMessage.value = 'Scanning for a food barcode...'
    statusType.value = 'info'

    console.log('==============================')
    console.log('📷 STARTING SCANNER')
    console.log('Camera ID:', selectedCameraId.value)
    console.log('Video element:', videoRef.value)
    console.log('==============================')

    // Start video decoding
    controls = await reader.decodeFromVideoDevice(
      selectedCameraId.value,
      videoRef.value,
      (result, error) => {
        // Barcode found
        if (result) {
          console.log('==============================')
          console.log('✅ BARCODE DETECTED')
          console.log('Text:', result.getText())
          console.log('Format:', result.getBarcodeFormat())
          console.log('error:', error)
          console.log('==============================')

          if (processingBarcode) {
            return
          }

          const barcode = result.getText().trim()

          if (!barcode) {
            return
          }

          processBarcode(barcode, result.getBarcodeFormat())

          return
        }
      },
    )

    console.log('==============================')
    console.log('📷 CAMERA STARTED')
    console.log('Video dimensions:', {
      width: videoRef.value?.videoWidth,
      height: videoRef.value?.videoHeight,
    })
    console.log('==============================')
  } catch (error) {
    console.error('❌ Unable to start scanner:', error)

    scanning.value = false

    errorMessage.value = error.message || 'Unable to start the camera.'

    emit('error', error)
  }
}

// ============================================================
// PROCESS BARCODE
// ============================================================

async function processBarcode(barcode, format) {
  console.log('🔎 LOOKING UP PRODUCT', {
    barcode,
    format,
  })
  if (processingBarcode) {
    return
  }

  processingBarcode = true

  scannedBarcode.value = barcode

  emit('detected', {
    barcode,
    format: formatName(format),
  })

  // Stop camera while looking up product
  stopScanner(false)

  lookingUp.value = true

  statusMessage.value = 'Looking up product...'

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
    /*
     * AbortError is expected if the user cancels.
     */
    if (error.name === 'AbortError') {
      return
    }

    console.error('Open Food Facts lookup failed:', error)

    errorMessage.value = 'We could not retrieve the product information. Please try again.'

    emit('error', error)
  } finally {
    lookingUp.value = false
    processingBarcode = false
  }
}

// ============================================================
// OPEN FOOD FACTS LOOKUP
// ============================================================

async function lookupFood(barcode) {
  lookupController = new AbortController()

  /*
   * fields keeps the response reasonably small while
   * providing everything this component displays.
   *
   * Open Food Facts supports the fields query parameter.
   */
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

  const url =
    `https://world.openfoodfacts.net/api/v2/product/` +
    `${encodeURIComponent(barcode)}.json` +
    `?fields=${encodeURIComponent(fields)}`

  const response = await fetch(url, {
    method: 'GET',

    signal: lookupController.signal,

    headers: {
      /*
       * Don't attempt to set User-Agent here.
       *
       * Browsers prevent web applications from setting
       * the User-Agent header.
       */
      Accept: 'application/json',
    },
  })

  if (!response.ok) {
    throw new Error(`Open Food Facts returned HTTP ${response.status}`)
  }

  const data = await response.json()

  /*
   * Open Food Facts uses:
   *
   * status === 1 -> product found
   * status === 0 -> product not found
   */
  if (data.status !== 1 || !data.product) {
    return null
  }

  return data.product
}

// ============================================================
// STOP SCANNER
// ============================================================

function stopScanner(clearStatus = true) {
  if (controls) {
    controls.stop()
    controls = null
  }

  scanning.value = false

  /*
   * Explicitly stop camera tracks.
   *
   * This makes sure the browser camera light turns off.
   */
  if (videoRef.value?.srcObject) {
    const stream = videoRef.value.srcObject

    stream.getTracks().forEach((track) => {
      track.stop()
    })

    videoRef.value.srcObject = null
  }

  if (clearStatus) {
    statusMessage.value = ''
    statusType.value = ''
  }
}

// ============================================================
// CANCEL LOOKUP
// ============================================================

function cancelLookup() {
  if (lookupController) {
    lookupController.abort()
    lookupController = null
  }

  lookingUp.value = false
  processingBarcode = false

  statusMessage.value = ''
  statusType.value = ''

  scannedBarcode.value = ''
}

// ============================================================
// SCAN ANOTHER PRODUCT
// ============================================================

async function scanAnother() {
  product.value = null
  productNotFound.value = false

  scannedBarcode.value = ''

  clearMessages()

  processingBarcode = false

  await startScanner()
}

// ============================================================
// CLEAR ERROR
// ============================================================

function clearError() {
  errorMessage.value = ''
}

// ============================================================
// CLEAR MESSAGES
// ============================================================

function clearMessages() {
  errorMessage.value = ''
  statusMessage.value = ''
  statusType.value = ''
}

// ============================================================
// NUMBER FORMATTING
// ============================================================

function formatNumber(value) {
  if (value === undefined || value === null || Number.isNaN(Number(value))) {
    return '—'
  }

  const number = Number(value)

  return number.toLocaleString(undefined, {
    maximumFractionDigits: 1,
  })
}

// ============================================================
// GRAMS -> MILLIGRAMS
// ============================================================

function gramsToMilligrams(value) {
  if (value === undefined || value === null || Number.isNaN(Number(value))) {
    return null
  }

  return Number(value) * 1000
}

// ============================================================
// BARCODE FORMAT
// ============================================================

function formatName(format) {
  switch (format) {
    case BarcodeFormat.QR_CODE:
      return 'QR Code'

    case BarcodeFormat.UPC_A:
      return 'UPC-A'

    case BarcodeFormat.UPC_E:
      return 'UPC-E'

    case BarcodeFormat.EAN_8:
      return 'EAN-8'

    case BarcodeFormat.EAN_13:
      return 'EAN-13'

    default:
      return String(format)
  }
}

// ============================================================
// CLEANUP
// ============================================================

onBeforeUnmount(() => {
  if (lookupController) {
    lookupController.abort()
  }

  stopScanner(false)
})
</script>

<style scoped>
/* ============================================================
   PAGE
============================================================ */

.scanner-page {
  width: 100%;
  max-width: 720px;

  margin: 0 auto;
  padding: 24px;

  box-sizing: border-box;

  font-family:
    Inter,
    system-ui,
    -apple-system,
    BlinkMacSystemFont,
    'Segoe UI',
    sans-serif;

  color: #172033;
}

/* ============================================================
   HEADER
============================================================ */

.page-header {
  text-align: center;
  margin-bottom: 20px;
}

.page-header h1 {
  margin: 0 0 6px;

  font-size: 30px;
  font-weight: 750;
}

.page-header p {
  margin: 0;

  color: #667085;
}

/* ============================================================
   SCANNER CARD
============================================================ */

.scanner-card {
  background: white;

  border: 1px solid #e4e7ec;
  border-radius: 18px;

  padding: 16px;

  box-shadow: 0 8px 30px rgba(16, 24, 40, 0.08);
}

/* ============================================================
   VIDEO
============================================================ */

.scanner-container {
  position: relative;

  width: 100%;

  aspect-ratio: 4 / 3;

  overflow: hidden;

  background: #080b10;

  border-radius: 14px;
}

.scanner-video {
  display: block;

  width: 100%;
  height: 100%;

  object-fit: cover;
}

/* ============================================================
   CAMERA PLACEHOLDER
============================================================ */

.camera-placeholder {
  position: absolute;
  inset: 0;

  display: flex;
  flex-direction: column;

  align-items: center;
  justify-content: center;

  color: white;

  background: radial-gradient(circle at center, #202936 0%, #090d13 70%);

  text-align: center;
}

.camera-icon {
  font-size: 48px;
  margin-bottom: 12px;
}

.camera-placeholder p {
  margin: 0;

  color: #d0d5dd;
}

/* ============================================================
   SCANNER OVERLAY
============================================================ */

.scanner-overlay {
  position: absolute;
  inset: 0;

  display: flex;

  align-items: center;
  justify-content: center;

  pointer-events: none;
}

.scan-box {
  position: relative;

  width: 80%;
  max-width: 430px;

  height: 130px;

  border-radius: 8px;

  /*
   * Darken the camera around the scan region.
   */
  box-shadow: 0 0 0 9999px rgba(0, 0, 0, 0.35);
}

/* ============================================================
   CORNERS
============================================================ */

.corner {
  position: absolute;

  width: 28px;
  height: 28px;

  border-color: #22c55e;
  border-style: solid;

  z-index: 3;
}

.top-left {
  top: 0;
  left: 0;

  border-width: 3px 0 0 3px;
}

.top-right {
  top: 0;
  right: 0;

  border-width: 3px 3px 0 0;
}

.bottom-left {
  bottom: 0;
  left: 0;

  border-width: 0 0 3px 3px;
}

.bottom-right {
  bottom: 0;
  right: 0;

  border-width: 0 3px 3px 0;
}

/* ============================================================
   SCAN LINE
============================================================ */

.scan-line {
  position: absolute;

  left: 4%;
  right: 4%;

  top: 50%;

  height: 2px;

  background: #22c55e;

  box-shadow:
    0 0 8px #22c55e,
    0 0 18px #22c55e;

  animation: scan-line 1.8s ease-in-out infinite;
}

@keyframes scan-line {
  0% {
    transform: translateY(-50px);
  }

  50% {
    transform: translateY(50px);
  }

  100% {
    transform: translateY(-50px);
  }
}

/* ============================================================
   SCAN INSTRUCTIONS
============================================================ */

.scan-instructions {
  position: absolute;

  bottom: 24px;

  padding: 8px 14px;

  color: white;

  font-size: 14px;

  background: rgba(0, 0, 0, 0.6);

  border-radius: 20px;
}

/* ============================================================
   LOOKUP OVERLAY
============================================================ */

.lookup-overlay {
  position: absolute;
  inset: 0;

  display: flex;
  flex-direction: column;

  align-items: center;
  justify-content: center;

  color: white;

  background: rgba(0, 0, 0, 0.65);

  backdrop-filter: blur(3px);
}

.lookup-overlay p {
  margin-top: 14px;
}

/* ============================================================
   SPINNER
============================================================ */

.spinner {
  width: 38px;
  height: 38px;

  border: 4px solid rgba(255, 255, 255, 0.3);
  border-top-color: white;

  border-radius: 50%;

  animation: spin 0.8s linear infinite;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

/* ============================================================
   CAMERA SELECT
============================================================ */

.camera-selection {
  margin-top: 16px;
}

.camera-selection label {
  display: block;

  margin-bottom: 6px;

  font-size: 14px;
  font-weight: 600;
}

.camera-selection select {
  width: 100%;

  padding: 12px;

  box-sizing: border-box;

  border: 1px solid #d0d5dd;

  border-radius: 9px;

  background: white;

  font-size: 16px;
}

/* ============================================================
   BUTTONS
============================================================ */

.controls {
  display: flex;

  gap: 10px;

  margin-top: 16px;
}

.button {
  width: 100%;

  padding: 13px 18px;

  border: 0;
  border-radius: 9px;

  font-size: 16px;
  font-weight: 650;

  cursor: pointer;

  transition:
    background 0.15s,
    transform 0.05s;
}

.button:active {
  transform: translateY(1px);
}

.button-start {
  color: white;

  background: #16a34a;
}

.button-start:hover {
  background: #15803d;
}

.button-stop {
  color: white;

  background: #dc2626;
}

.button-stop:hover {
  background: #b91c1c;
}

.button-secondary {
  color: #344054;

  background: #eaecf0;
}

/* ============================================================
   STATUS
============================================================ */

.status-message {
  margin-top: 14px;

  padding: 11px 13px;

  border-radius: 8px;

  text-align: center;

  font-size: 14px;
}

.status-message.info {
  color: #175cd3;
  background: #eff8ff;
}

.status-message.success {
  color: #027a48;
  background: #ecfdf3;
}

/* ============================================================
   ERROR
============================================================ */

.error-message {
  margin-top: 14px;

  padding: 14px;

  color: #b42318;

  background: #fef3f2;

  border: 1px solid #fecdca;

  border-radius: 9px;
}

.error-message p {
  margin: 5px 0 10px;
}

.retry-button {
  padding: 7px 11px;

  color: #b42318;

  background: white;

  border: 1px solid #fecdca;

  border-radius: 6px;

  cursor: pointer;
}

/* ============================================================
   PRODUCT CARD
============================================================ */

.product-card {
  margin-top: 20px;

  padding: 20px;

  background: white;

  border: 1px solid #e4e7ec;

  border-radius: 18px;

  box-shadow: 0 8px 30px rgba(16, 24, 40, 0.08);
}

/* ============================================================
   PRODUCT HEADER
============================================================ */

.product-header {
  display: flex;

  gap: 18px;

  align-items: flex-start;
}

.product-image-wrapper {
  flex: 0 0 110px;

  width: 110px;
  height: 110px;

  overflow: hidden;

  border-radius: 12px;

  background: #f2f4f7;
}

.product-image {
  width: 100%;
  height: 100%;

  object-fit: contain;
}

.product-title {
  min-width: 0;
}

.product-title h2 {
  margin: 3px 0 5px;

  font-size: 23px;
  line-height: 1.2;
}

.brand {
  color: #667085;

  font-size: 14px;
  font-weight: 650;
}

.generic-name {
  margin: 0;

  color: #667085;

  font-size: 14px;
}

.barcode {
  margin: 9px 0 0;

  color: #98a2b3;

  font-family: monospace;
  font-size: 12px;
}

/* ============================================================
   SERVING INFO
============================================================ */

.serving-info {
  display: grid;

  grid-template-columns: repeat(2, 1fr);

  gap: 10px;

  margin-top: 20px;
}

.serving-info > div {
  padding: 12px;

  background: #f9fafb;

  border-radius: 9px;
}

.label {
  display: block;

  margin-bottom: 3px;

  color: #667085;

  font-size: 12px;
}

.serving-info strong {
  font-size: 14px;
}

/* ============================================================
   NUTRITION
============================================================ */

.nutrition-section {
  margin-top: 24px;
}

.section-title-row {
  display: flex;

  align-items: center;
  justify-content: space-between;

  gap: 12px;

  margin-bottom: 12px;
}

.section-title-row h3 {
  margin: 0;

  font-size: 20px;
}

/* ============================================================
   NUTRITION TOGGLE
============================================================ */

.nutrition-toggle {
  display: flex;

  padding: 3px;

  background: #f2f4f7;

  border-radius: 8px;
}

.nutrition-toggle button {
  padding: 7px 10px;

  border: 0;
  border-radius: 6px;

  background: transparent;

  color: #667085;

  font-size: 12px;

  cursor: pointer;
}

.nutrition-toggle button.active {
  background: white;

  color: #101828;

  box-shadow: 0 1px 2px rgba(16, 24, 40, 0.1);
}

/* ============================================================
   CALORIES
============================================================ */

.calories-card {
  display: flex;

  align-items: center;
  justify-content: space-between;

  padding: 18px;

  color: white;

  background: linear-gradient(135deg, #f97316, #ea580c);

  border-radius: 12px;
}

.calories-card span {
  font-size: 15px;
}

.calories-card strong {
  font-size: 28px;
}

.calories-card small {
  font-size: 14px;
  font-weight: 500;
}

/* ============================================================
   MACROS
============================================================ */

.macro-grid {
  display: grid;

  grid-template-columns: repeat(3, 1fr);

  gap: 10px;

  margin-top: 10px;
}

.macro-card {
  padding: 14px;

  border-radius: 10px;
}

.macro-card.protein {
  background: #eff6ff;
  color: #1d4ed8;
}

.macro-card.carbs {
  background: #fefce8;
  color: #a16207;
}

.macro-card.fat {
  background: #fff1f2;
  color: #be123c;
}

.macro-label {
  display: block;

  margin-bottom: 5px;

  font-size: 13px;
}

.macro-card strong {
  font-size: 21px;
}

.macro-card small {
  font-size: 12px;
}

/* ============================================================
   ADDITIONAL NUTRITION
============================================================ */

.nutrition-list {
  margin-top: 10px;

  border-top: 1px solid #eaecf0;
}

.nutrition-row {
  display: flex;

  align-items: center;
  justify-content: space-between;

  padding: 12px 2px;

  border-bottom: 1px solid #eaecf0;
}

.nutrition-row span {
  color: #475467;
}

.nutrition-row strong {
  color: #101828;
}

.nutrition-row small {
  color: #667085;

  font-weight: 400;
}

/* ============================================================
   NUTRI-SCORE
============================================================ */

.nutriscore-section {
  display: flex;

  align-items: center;
  justify-content: space-between;

  margin-top: 22px;
  padding-top: 18px;

  border-top: 1px solid #eaecf0;
}

.nutriscore {
  display: inline-flex;

  align-items: center;
  justify-content: center;

  width: 40px;
  height: 40px;

  color: white;

  border-radius: 8px;

  font-weight: 800;
}

.score-a {
  background: #038141;
}

.score-b {
  background: #85bb2f;
}

.score-c {
  background: #fecb02;
  color: #172033;
}

.score-d {
  background: #ee8100;
}

.score-e {
  background: #e63e11;
}

/* ============================================================
   INFO SECTIONS
============================================================ */

.info-section {
  margin-top: 22px;

  padding-top: 18px;

  border-top: 1px solid #eaecf0;
}

.info-section h3 {
  margin: 0 0 8px;

  font-size: 17px;
}

.info-section p {
  margin: 0;

  color: #475467;

  line-height: 1.55;

  font-size: 14px;
}

/* ============================================================
   SCAN ANOTHER
============================================================ */

.scan-another {
  margin-top: 24px;
}

/* ============================================================
   NOT FOUND
============================================================ */

.not-found-card {
  margin-top: 20px;

  padding: 28px 20px;

  text-align: center;

  background: white;

  border: 1px solid #e4e7ec;

  border-radius: 18px;

  box-shadow: 0 8px 30px rgba(16, 24, 40, 0.08);
}

.not-found-icon {
  font-size: 42px;
}

.not-found-card h2 {
  margin: 10px 0 8px;
}

.not-found-card p {
  color: #475467;

  line-height: 1.5;
}

.not-found-card .hint {
  color: #667085;

  font-size: 14px;
}

.not-found-card .button {
  margin-top: 10px;
}

/* ============================================================
   MOBILE
============================================================ */

@media (max-width: 600px) {
  .scanner-page {
    padding: 12px;
  }

  .page-header h1 {
    font-size: 26px;
  }

  .scanner-card,
  .product-card {
    border-radius: 14px;
    padding: 12px;
  }

  .scanner-container {
    aspect-ratio: 3 / 4;
  }

  .scan-box {
    width: 88%;
    height: 115px;
  }

  .product-header {
    gap: 12px;
  }

  .product-image-wrapper {
    flex-basis: 85px;

    width: 85px;
    height: 85px;
  }

  .product-title h2 {
    font-size: 19px;
  }

  .serving-info {
    grid-template-columns: 1fr;
  }

  .section-title-row {
    align-items: flex-start;

    flex-direction: column;
  }

  .nutrition-toggle {
    width: 100%;
  }

  .nutrition-toggle button {
    flex: 1;
  }

  .macro-card {
    padding: 11px;
  }

  .macro-card strong {
    font-size: 18px;
  }
}
</style>
