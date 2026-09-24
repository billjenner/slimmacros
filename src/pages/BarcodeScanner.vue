<template>
  <div class="barcode-scanner">
    <div class="scanner-header">
      <button class="close-button" @click="close">Cancel</button>

      <span>Scan Barcode</span>
    </div>

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

let scannerStarted = false
let detected = false

// Track repeated detections
const barcodeCandidates = new Map()

let candidateTimer = null

function initScanner() {
  if (!scannerContainer.value) {
    return
  }

  Quagga.init(
    {
      inputStream: {
        type: 'LiveStream',

        target: scannerContainer.value,

        constraints: {
          facingMode: 'environment',

          width: {
            min: 640,
            ideal: 1920,
            max: 2560,
          },

          height: {
            min: 480,
            ideal: 1080,
            max: 1440,
          },
        },

        area: {
          top: '20%',
          right: '10%',
          left: '10%',
          bottom: '20%',
        },
      },

      locator: {
        patchSize: 'medium',
        halfSample: false,
      },

      numOfWorkers: 4,

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

      console.log('Quagga started')

      scannerStarted = true

      Quagga.start()
    },
  )

  Quagga.onDetected(handleDetected)

  // Clear candidate detections periodically
  candidateTimer = setInterval(() => {
    barcodeCandidates.clear()
  }, 2000)
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
  if (count >= 3) {
    confirmBarcode(code)
  }
}

function confirmBarcode(code) {
  if (detected) {
    return
  }

  detected = true

  console.log('CONFIRMED BARCODE:', code)

  stopScanner()

  emit('detected', code)
}

function isValidBarcode(code) {
  const digits = code.split('').map(Number)

  const checkDigit = digits.pop()

  let sum = 0

  // Work backwards from the digit immediately before
  // the check digit.
  for (let i = digits.length - 1; i >= 0; i--) {
    const positionFromRight = digits.length - i

    if (positionFromRight % 2 === 1) {
      sum += digits[i] * 3
    } else {
      sum += digits[i]
    }
  }

  const calculatedCheckDigit = (10 - (sum % 10)) % 10

  return calculatedCheckDigit === checkDigit
}

function stopScanner() {
  if (scannerStarted) {
    Quagga.stop()

    scannerStarted = false
  }
}

function close() {
  stopScanner()

  emit('close')
}

onMounted(() => {
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

  width: 82%;
  max-width: 420px;

  height: 150px;

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
