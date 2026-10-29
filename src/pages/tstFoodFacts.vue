<template>
  <q-page class="q-pa-md" style="max-width: 600px; margin: 0 auto">
    <q-input v-model="barcode" label="Barcode" outlined inputmode="numeric" @keyup.enter="lookup" />
    <q-btn
      class="q-mt-md"
      color="primary"
      label="Look up"
      :loading="loading"
      :disable="!barcode.trim()"
      @click="lookup"
    />

    <q-banner v-if="error" class="bg-negative text-white q-mt-md">{{ error }}</q-banner>
    <q-banner v-else-if="notFound" class="bg-warning q-mt-md">Product not found.</q-banner>

    <div v-if="product" class="q-mt-md">
      <q-img
        v-if="product.image_front_url"
        :src="product.image_front_url"
        style="max-width: 200px"
      />
      <div class="text-h6">{{ product.product_name || product.product_name_en }}</div>
      <div>Brand: {{ product.brands }}</div>
      <div>Serving size: {{ product.serving_size }}</div>
      <div>Calories (100g): {{ product.nutriments?.['energy-kcal_100g'] }}</div>
      <div>Protein (100g): {{ product.nutriments?.proteins_100g }}</div>
      <div>Carbs (100g): {{ product.nutriments?.carbohydrates_100g }}</div>
      <div>Fat (100g): {{ product.nutriments?.fat_100g }}</div>
      <pre class="q-mt-md" style="white-space: pre-wrap">{{
        JSON.stringify(product, null, 2)
      }}</pre>
    </div>
  </q-page>
</template>

<script setup>
import { ref } from 'vue'
import { fetchOpenFoodFactsProduct } from '../utils/openFoodFacts'

const barcode = ref('857111004195')
const product = ref(null)
const notFound = ref(false)
const error = ref('')
const loading = ref(false)

async function lookupFood(code) {
  return fetchOpenFoodFactsProduct(code)
}

async function lookup() {
  if (!barcode.value.trim()) return
  loading.value = true
  error.value = ''
  notFound.value = false
  product.value = null
  try {
    const result = await lookupFood(barcode.value)
    if (result) product.value = result
    else notFound.value = true
  } catch (err) {
    error.value = err.message || 'Lookup failed.'
  } finally {
    loading.value = false
  }
}
</script>
