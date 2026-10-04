<template>
  <component :is="embedded ? 'div' : 'q-page'" :class="!embedded ? 'q-pa-md' : ''">
    <div :class="!embedded ? 'row justify-center' : ''">
      <div :class="!embedded ? 'col-12 col-md-10 col-lg-8' : ''">
        <component
          :is="embedded ? 'div' : 'q-card'"
          :flat="!embedded"
          :bordered="!embedded"
          :class="!embedded ? 'q-pa-md' : ''"
        >
          <div class="row items-center justify-between q-mx-md q-mb-md">
            <div class="text-h5">Food</div>
            <q-btn
              color="primary"
              class="q-mb-sm"
              unelevated
              :label="showFoodForm ? 'Hide Form' : 'Add Food'"
              @click="showFoodForm = !showFoodForm"
            />
          </div>

          <q-banner v-if="store.error" class="bg-negative text-white q-mb-md" rounded>
            {{ store.error }}
          </q-banner>

          <q-banner
            v-else-if="!usersStore.currentUser"
            class="bg-warning text-dark q-mb-md"
            rounded
          >
            Sign in to create a food entry.
          </q-banner>

          <transition name="form-slide" mode="out-in">
            <q-form
              v-if="showFoodForm"
              key="food-form"
              @submit.prevent="submitFood"
              class="q-gutter-md"
            >
              <q-card flat bordered class="q-pa-md bg-grey-1">
                <div class="row items-center q-mb-sm">
                  <div class="text-subtitle1 q-mb-sm">Food details</div>
                  <div class="row q-gutter-sm q-ml-auto">
                    <q-btn
                      type="button"
                      color="secondary"
                      label="Scan Code"
                      class="food-action-btn"
                      @click="openBarcodeScanner"
                    />
                    <q-btn
                      type="button"
                      color="secondary"
                      label="Get Food"
                      class="food-action-btn"
                      :disable="store.loading"
                      @click="getFoodOpen = true"
                    />
                  </div>
                </div>
                <div class="row q-col-gutter-md">
                  <div class="col-12">
                    <q-input
                      v-model="food.description"
                      label="Description"
                      filled
                      dense
                      :rules="[(value) => !!value?.trim() || 'Description is required']"
                    />
                  </div>
                </div>
              </q-card>

              <q-card flat bordered class="q-pa-md bg-grey-1">
                <div class="row items-center q-mb-sm">
                  <div class="text-subtitle1">Serving information</div>
                  <!-- <q-btn
                    type="button"
                    color="secondary"
                    label="Get Macros"
                    :loading="isGettingMacros"
                    :disable="!canGetMacros || store.loading"
                    @click="getMacrosFromAi"
                  />
                  />-->
                </div>
                <div class="row q-col-gutter-md">
                  <div class="col-12 col-md-6">
                    <q-input
                      v-model="food.serving_size"
                      type="number"
                      label="Serving size"
                      min="0.01"
                      step="0.01"
                      filled
                      dense
                    />
                  </div>

                  <div class="col-12 col-md-6">
                    <q-select
                      v-model="food.serving_unit"
                      :options="servingUnitOptions"
                      label="Serving unit"
                      filled
                      dense
                      emit-value
                      map-options
                    />
                  </div>
                </div>
              </q-card>

              <q-card flat bordered class="q-pa-md bg-grey-1">
                <div class="text-subtitle1 q-mb-sm">Nutrition information</div>
                <div class="row q-col-gutter-md">
                  <div class="col-12 col-md-6">
                    <q-input
                      v-model="food.protein"
                      type="number"
                      label="Protein"
                      min="0"
                      step="0.01"
                      filled
                      dense
                    />
                  </div>

                  <div class="col-12 col-md-6">
                    <q-input
                      v-model="food.carb"
                      type="number"
                      label="Carbs"
                      min="0"
                      step="0.01"
                      filled
                      dense
                    />
                  </div>

                  <div class="col-12 col-md-6">
                    <q-input
                      v-model="food.fat"
                      type="number"
                      label="Fat"
                      min="0"
                      step="0.01"
                      filled
                      dense
                    />
                  </div>

                  <div class="col-12 col-md-6">
                    <q-input
                      v-model="food.calories_extra"
                      type="number"
                      label="Extra calories"
                      min="0"
                      step="0.01"
                      filled
                      dense
                    />
                  </div>
                </div>
              </q-card>

              <div class="row items-end no-wrap q-pr-md" style="gap: 16px">
                <div class="col">
                  <q-card flat bordered class="q-pa-md bg-grey-1">
                    <div class="text-subtitle1 q-mb-sm">Preferences</div>
                    <div class="row q-col-gutter-md">
                      <div class="col-12 col-md-4">
                        <q-toggle v-model="food.favorite_food" label="Favorite" />
                      </div>

                      <div class="col-12 col-md-4">
                        <q-toggle v-model="food.share_with_others" label="Share with others" />
                      </div>
                    </div>
                  </q-card>
                </div>

                <q-btn
                  type="submit"
                  color="primary"
                  :label="editingFoodId ? 'Update food' : 'Save food'"
                  :loading="store.loading"
                />
              </div>
            </q-form>
          </transition>

          <FoodDatabaseDialog v-model="getFoodOpen" @use-food="applyDatabaseFood" />

          <q-dialog v-model="confirmDeleteOpen">
            <q-card style="min-width: 320px">
              <q-card-section class="text-h6">Delete food?</q-card-section>
              <q-card-section>
                Are you sure you want to delete food {{ pendingDeleteFood?.description || '' }}?
              </q-card-section>
              <q-card-actions align="right">
                <q-btn flat label="No" color="primary" @click="cancelDeleteFood" />
                <q-btn label="Yes" color="negative" @click="confirmDeleteFood" />
              </q-card-actions>
            </q-card>
          </q-dialog>

          <q-card flat bordered class="q-pa-none bg-grey-1 q-mt-md">
            <div class="row items-center justify-between q-px-md q-py-sm">
              <div class="text-subtitle1">Saved food</div>
              <q-toggle v-model="showSharedFood" label="Show shared food" />
            </div>

            <q-table
              :rows="foodRows"
              :columns="foodColumns"
              :pagination="{ rowsPerPage: 50 }"
              :rows-per-page-options="[20, 50, 200, 0]"
              row-key="food_id"
              flat
              bordered
              dense
              hide-header
              square
              class="full-width no-border"
              :loading="store.loading"
              no-data-label="No food records yet."
            >
              <template #body="props">
                <!-- Main row -->
                <q-tr :props="props" :class="sharedRowClass(props.row)">
                  <q-td key="description" :props="props">
                    <div class="row items-center full-width">
                      <q-btn
                        size="sm"
                        color="secondary"
                        dense
                        round
                        :icon="isExpanded(props.row) ? 'remove' : 'add'"
                        @click="toggleExpanded(props.row)"
                      />

                      <span class="q-ml-lg">
                        {{ formatFoodRowSummary(props.row) }}
                      </span>

                      <q-chip
                        v-if="!isOwnedByCurrentUser(props.row)"
                        dense
                        color="secondary"
                        text-color="white"
                        class="q-ml-sm"
                      >
                        Shared
                      </q-chip>

                      <!-- Push buttons to right -->
                      <div
                        v-if="isOwnedByCurrentUser(props.row)"
                        class="row items-center q-gutter-xs q-ml-auto"
                      >
                        <q-btn
                          flat
                          dense
                          size="sm"
                          color="negative"
                          label="Edit"
                          @click="editFood(props.row)"
                        />

                        <q-btn
                          flat
                          dense
                          size="sm"
                          color="negative"
                          label="Delete"
                          @click="requestDeleteFood(props.row)"
                        />
                      </div>
                    </div>
                  </q-td>
                </q-tr>

                <!-- Expanded row -->
                <q-tr
                  v-if="isExpanded(props.row)"
                  :props="props"
                  :class="sharedRowClass(props.row)"
                >
                  <q-td
                    :colspan="foodColumns.length"
                    :class="isOwnedByCurrentUser(props.row) ? 'bg-grey-2' : ''"
                  >
                    <div class="row q-col-gutter-md q-mt-md q-mb-xl">
                      <div class="col-6 column items-center">
                        <div class="text-caption text-grey-7 text-center q-mb-sm">
                          Macro Profile
                        </div>
                        <div style="width: 100%; max-width: 360px; height: 300px">
                          <Pie :data="getMacroChartData(props.row)" :options="macroChartOptions" />
                        </div>
                      </div>

                      <div class="col-6 column items-center">
                        <div class="text-caption text-grey-7 text-center q-mb-sm">
                          Calories vs Daily Budget
                        </div>
                        <div style="width: 100%; max-width: 360px; height: 300px">
                          <Pie
                            :data="getCalorieBudgetChartData(props.row)"
                            :options="macroChartOptions"
                          />
                        </div>
                      </div>
                    </div>
                    <div class="row q-col-gutter-sm q-py-sm">
                      <div class="col-3">
                        <div class="text-caption text-grey-7">Protein</div>
                        <div class="text-body2">{{ props.row.protein ?? 0 }}</div>
                      </div>
                      <div class="col-3">
                        <div class="text-caption text-grey-7">Carbs</div>
                        <div class="text-body2">{{ props.row.carb ?? 0 }}</div>
                      </div>
                      <div class="col-3">
                        <div class="text-caption text-grey-7">Fat</div>
                        <div class="text-body2">{{ props.row.fat ?? 0 }}</div>
                      </div>
                      <div class="col-3">
                        <div class="text-caption text-grey-7">Extra calories</div>
                        <div class="text-body2">{{ props.row.calories_extra ?? 0 }}</div>
                      </div>
                      <div class="col-3">
                        <div class="text-caption text-grey-7">Serving size</div>
                        <div class="text-body2">{{ props.row.serving_size ?? 1 }}</div>
                      </div>
                      <div class="col-3">
                        <div class="text-caption text-grey-7">Serving unit</div>
                        <div class="text-body2">{{ props.row.serving_unit || 'unit' }}</div>
                      </div>
                      <!-- <div class="col-3">
                        <div class="text-caption text-grey-7">My food</div>
                        <div class="text-body2">{{ props.row.my_food ? 'Yes' : 'No' }}</div>
                      </div> -->
                      <div class="col-3">
                        <div class="text-caption text-grey-7">Favorite</div>
                        <div class="text-body2">{{ props.row.favorite_food ? 'Yes' : 'No' }}</div>
                      </div>
                      <div class="col-3">
                        <div class="text-caption text-grey-7">Share with others</div>
                        <div class="text-body2">
                          {{ props.row.share_with_others ? 'Yes' : 'No' }}
                        </div>
                      </div>
                    </div>
                  </q-td>
                </q-tr>
              </template>
            </q-table>
          </q-card>
        </component>
      </div>
    </div>
  </component>
</template>

<script setup>
import { computed, onMounted, reactive, ref, watch } from 'vue'
import { useQuasar } from 'quasar'
import { useRoute, useRouter } from 'vue-router'
import { Pie } from 'vue-chartjs'
import { Chart as ChartJS, ArcElement, Tooltip, Legend } from 'chart.js'
import { useUsersStore } from 'stores/users'
import { useFoodStore } from 'stores/food'
import { calculateFoodCalories, calculateTotalCaloriesForPerson } from '../utils/rules'
import { notifySuccess } from '../utils/notify'
import { fetchOpenFoodFactsProduct, mapProductToFood } from '../utils/openFoodFacts'
import FoodDatabaseDialog from 'components/dashboard/Items/FoodDatabaseDialog.vue'

ChartJS.register(ArcElement, Tooltip, Legend)

defineProps({
  embedded: {
    type: Boolean,
    default: false,
  },
})

const usersStore = useUsersStore()
const store = useFoodStore()
const $q = useQuasar()
const route = useRoute()
const router = useRouter()

const servingUnitOptions = [
  { label: 'Ounce', value: 'oz' },
  { label: 'Gram', value: 'gram' },
  { label: 'Cup', value: 'cup' },
  { label: 'Scoop', value: 'scoop' },
  { label: 'Bar', value: 'bar' },
  { label: 'Can', value: 'can' },
  { label: 'Count', value: 'count' },
  { label: 'Item', value: 'item' },
  { label: 'Piece', value: 'piece' },
  { label: 'Pinch', value: 'pinch' },
  { label: 'Serving', value: 'serving' },
  { label: 'Slice', value: 'slice' },
  { label: 'Tab', value: 'tab' },
  { label: 'Tablespoon', value: 'tbsp' },
  { label: 'Teaspoon', value: 'tsp' },
  { label: 'Teaspoon', value: 'tsp' },
]

const food = reactive({
  description: '',
  protein: 0,
  carb: 0,
  fat: 0,
  calories_extra: 0,
  my_food: true,
  favorite_food: false,
  share_with_others: false,
  serving_size: 1,
  serving_unit: 'serving',
  is_active: true,
})

const foodColumns = [
  {
    name: 'description',
    label: 'Description',
    field: 'description',
    align: 'left',
    sortable: true,
  },
]

const foodRows = computed(() => {
  const allRows = store.food || []
  const currentUserId = usersStore.currentUser?.user_id
  const rowsWithoutShared = showSharedFood.value
    ? allRows
    : allRows.filter((row) => row?.user_id === currentUserId)
  const searchText = String(food.description || '')
    .trim()
    .toLowerCase()

  const filteredRows = !searchText
    ? rowsWithoutShared
    : rowsWithoutShared.filter((row) =>
        String(row?.description || '')
          .toLowerCase()
          .includes(searchText),
      )

  return [...filteredRows].sort((leftRow, rightRow) => {
    return String(leftRow?.description || '').localeCompare(String(rightRow?.description || ''))
  })
})

const showFoodForm = ref(false)
const showSharedFood = ref(false)
const confirmDeleteOpen = ref(false)
const pendingDeleteFood = ref(null)
const expandedFoodIds = ref([])
const editingFoodId = ref(null)
//const isGettingMacros = ref(false)
const getFoodOpen = ref(false)

function applyDatabaseFood(selectedFood) {
  Object.assign(food, {
    description: selectedFood.description,
    serving_size: selectedFood.serving_size,
    serving_unit: selectedFood.serving_unit,
    protein: selectedFood.protein,
    carb: selectedFood.carb,
    fat: selectedFood.fat,
    calories_extra: selectedFood.calories_extra,
  })
}

function openBarcodeScanner() {
  getFoodOpen.value = false
  router.push('/barcode-scanner')
}

//const canGetMacros = computed(() => {
//   const description = String(food.description || '').trim()
//   const servingSize = Number(food.serving_size)
//   const servingUnit = String(food.serving_unit || '').trim()

//   return Boolean(description && Number.isFinite(servingSize) && servingSize > 0 && servingUnit)
// })

async function applyScannedBarcode(barcode) {
  const failMessage = `Barcode lookup failed for ${barcode}.`
  try {
    const product = await fetchOpenFoodFactsProduct(barcode)
    const mapped = product ? mapProductToFood(product) : null
    if (!mapped?.description) {
      $q.notify({ type: 'negative', message: failMessage })
      return
    }
    Object.assign(food, mapped)
  } catch (err) {
    console.error('Open Food Facts lookup failed:', err)
    $q.notify({ type: 'negative', message: failMessage })
  }
}

watch(
  () => [route.query.barcode, route.query.showFoodForm],
  ([scannedBarcode, shouldShowFoodForm]) => {
    if (typeof scannedBarcode === 'string' && scannedBarcode.trim()) {
      applyScannedBarcode(scannedBarcode.trim())
    }

    if (scannedBarcode || shouldShowFoodForm === 'true') {
      showFoodForm.value = true
      router.replace({
        path: route.path,
        query: { ...route.query, barcode: undefined, showFoodForm: undefined },
      })
    }
  },
  { immediate: true },
)

onMounted(() => {
  if (usersStore.currentUser?.user_id) {
    loadFoodForCurrentUser(usersStore.currentUser.user_id)
  }
})

watch(
  () => usersStore.currentUser?.user_id,
  (userId) => {
    if (userId) {
      loadFoodForCurrentUser(userId)
    } else {
      store.food = []
    }
  },
)

async function loadFoodForCurrentUser(userId) {
  if (!userId) {
    return
  }

  await store.loadFood(userId)
}

function isOwnedByCurrentUser(row) {
  return Boolean(usersStore.currentUser?.user_id && row?.user_id === usersStore.currentUser.user_id)
}

function formatFoodRowSummary(row) {
  const description = String(row?.description || '').trim()
  const servingSize = Number(row?.serving_size) || 1
  const servingUnit = String(row?.serving_unit || 'unit').trim() || 'unit'
  const favoriteMarker = row?.favorite_food ? ' | *' : ''

  return `${description || 'Food'} | ${servingSize
    .toFixed(2)
    .replace(/\.00$/, '')
    .replace(/(\.\d)0$/, '$1')} | ${servingUnit}${favoriteMarker}`
}

function sharedRowClass(row) {
  return isOwnedByCurrentUser(row) ? '' : 'bg-info text-white'
}

function isExpanded(row) {
  return expandedFoodIds.value.includes(row?.food_id)
}

function getMacroBreakdown(row) {
  const proteinCalories = (Number(row?.protein) || 0) * 4
  const carbCalories = (Number(row?.carb) || 0) * 4
  const fatCalories = (Number(row?.fat) || 0) * 9
  const totalCalories = proteinCalories + carbCalories + fatCalories

  return {
    proteinCalories,
    carbCalories,
    fatCalories,
    totalCalories,
  }
}

function getMacroChartData(row) {
  const { proteinCalories, carbCalories, fatCalories } = getMacroBreakdown(row)

  return {
    labels: ['Protein', 'Carbs', 'Fat'],
    datasets: [
      {
        data: [proteinCalories, carbCalories, fatCalories],
        backgroundColor: ['#21BA45', '#F2C037', '#1976D2'],
        borderWidth: 2,
        borderColor: '#fff',
      },
    ],
  }
}

function getCalorieBudgetChartData(row) {
  const calories =
    calculateFoodCalories({
      carbs: row?.carb,
      protein: row?.protein,
      fat: row?.fat,
      extraCalories: row?.calories_extra,
    }) || 0
  const budget =
    calculateTotalCaloriesForPerson({
      totalDailyCalories: 2000,
      dailyCalorieDeficit: 0,
    }) || 1
  const consumedCalories = Math.max(0, calories)

  return {
    labels: ['Calories', 'Remaining'],
    datasets: [
      {
        data: [Math.min(consumedCalories, budget), Math.max(0, budget - consumedCalories)],
        backgroundColor: ['#f44336', '#E0E0E0'],
        borderWidth: 2,
        borderColor: '#fff',
      },
    ],
  }
}

const macroChartOptions = {
  responsive: true,
  maintainAspectRatio: false,
  animation: { duration: 3000, easing: 'easeOutQuart' },
  plugins: {
    legend: { position: 'bottom' },
    tooltip: {
      callbacks: {
        label: (context) => `${context.label}: ${context.raw} calories`,
      },
    },
  },
}

function toggleExpanded(row) {
  if (!row?.food_id) {
    return
  }

  if (isExpanded(row)) {
    expandedFoodIds.value = expandedFoodIds.value.filter((foodId) => foodId !== row.food_id)
  } else {
    expandedFoodIds.value = [...expandedFoodIds.value, row.food_id]
  }
}

function editFood(row) {
  editingFoodId.value = row.food_id

  Object.assign(food, {
    description: row.description || '',
    protein: row.protein ?? 0,
    carb: row.carb ?? 0,
    fat: row.fat ?? 0,
    calories_extra: row.calories_extra ?? 0,
    my_food: row.my_food !== false,
    favorite_food: Boolean(row.favorite_food),
    share_with_others: Boolean(row.share_with_others),
    serving_size: row.serving_size ?? 1,
    serving_unit: row.serving_unit || 'serving',
    is_active: row.is_active !== false,
  })

  showFoodForm.value = true
}

function resetFoodForm() {
  Object.assign(food, {
    description: '',
    protein: 0,
    carb: 0,
    fat: 0,
    calories_extra: 0,
    my_food: true,
    favorite_food: false,
    share_with_others: false,
    serving_size: 1,
    serving_unit: 'serving',
    is_active: true,
  })

  editingFoodId.value = null
}

// Get key from here: https://auth.openai.com/log-in/password
// function normalizeMacroValue(value) {
//   const numericValue = Number(value)
//   if (!Number.isFinite(numericValue) || numericValue < 0) {
//     return 0
//   }

//   return Math.round(numericValue * 100) / 100
// }

// function parseMacroPayload(content) {
//   if (!content) {
//     return null
//   }

//   const trimmed = String(content).trim()
//   const withoutFence = trimmed
//     .replace(/^```json\s*/i, '')
//     .replace(/^```\s*/i, '')
//     .replace(/```$/i, '')
//     .trim()

//   try {
//     const parsed = JSON.parse(withoutFence)
//     return {
//       protein: normalizeMacroValue(parsed?.protein),
//       carb: normalizeMacroValue(parsed?.carb),
//       fat: normalizeMacroValue(parsed?.fat),
//       calories_extra: normalizeMacroValue(parsed?.calories_extra),
//     }
//   } catch {
//     return null
//   }
// }

// async function getMacrosFromAi() {
//   if (!canGetMacros.value) {
//     store.error = 'Enter description, serving size, and serving unit first.'
//     return
//   }

//   const apiKey = import.meta.env.VITE_OPENAI_API_KEY
//   if (!apiKey) {
//     store.error = 'Missing VITE_OPENAI_API_KEY. Add it to your environment to use Get Macros.'
//     return
//   }

//   isGettingMacros.value = true
//   store.error = ''

//   try {
//     const response = await fetch('https://api.openai.com/v1/chat/completions', {
//       method: 'POST',
//       headers: {
//         'Content-Type': 'application/json',
//         Authorization: `Bearer ${apiKey}`,
//       },
//       body: JSON.stringify({
//         model: 'gpt-4o-mini',
//         temperature: 0,
//         messages: [
//           {
//             role: 'system',
//             content:
//               'You estimate nutrition macros for food. Return only JSON with numeric keys: protein, carb, fat, calories_extra. Protein/carb/fat are grams for the provided serving. calories_extra is non-macro calories for that serving.',
//           },
//           {
//             role: 'user',
//             content: `Food description: ${String(food.description || '').trim()}\nServing size: ${food.serving_size}\nServing unit: ${food.serving_unit}`,
//           },
//         ],
//       }),
//     })

//     if (!response.ok) {
//       throw new Error('AI request failed')
//     }

//     const data = await response.json()
//     const content = data?.choices?.[0]?.message?.content
//     const macros = parseMacroPayload(content)

//     if (!macros) {
//       throw new Error('Could not parse AI macro response')
//     }

//     food.protein = macros.protein
//     food.carb = macros.carb
//     food.fat = macros.fat
//     food.calories_extra = macros.calories_extra
//   } catch (error) {
//     console.warn('Get Macros request failed.', error)
//     store.error = 'Unable to get macros from AI right now. Please enter values manually.'
//   } finally {
//     isGettingMacros.value = false
//   }
// }

function requestDeleteFood(row) {
  pendingDeleteFood.value = row
  confirmDeleteOpen.value = true
}

function cancelDeleteFood() {
  pendingDeleteFood.value = null
  confirmDeleteOpen.value = false
}

async function confirmDeleteFood() {
  const row = pendingDeleteFood.value
  pendingDeleteFood.value = null
  confirmDeleteOpen.value = false

  if (!usersStore.currentUser?.user_id || !row?.food_id) {
    store.error = 'No current user is available.'
    return
  }

  const { error } = await store.deactivateFood(usersStore.currentUser.user_id, row.food_id)
  if (!error) {
    notifySuccess($q, 'Food deleted successfully.', { color: 'negative' })
    await loadFoodForCurrentUser(usersStore.currentUser.user_id)
  }
}

async function submitFood() {
  if (!usersStore.currentUser?.user_id) {
    store.error = 'No current user is available.'
    return
  }

  const savedFood = editingFoodId.value
    ? await store.updateFood(usersStore.currentUser.user_id, editingFoodId.value, food)
    : await store.createFood(usersStore.currentUser.user_id, food)

  if (savedFood) {
    notifySuccess(
      $q,
      editingFoodId.value ? 'Food updated successfully.' : 'Food added successfully.',
      { color: 'positive' },
    )
    resetFoodForm()

    showFoodForm.value = false
    await loadFoodForCurrentUser(usersStore.currentUser.user_id)
  }
}
</script>

<style scoped>
.calorie-budget-bar {
  width: 80%;
  margin-left: auto;
  margin-right: auto;
}

.form-slide-enter-active,
.form-slide-leave-active {
  transition: all 0.45s ease;
}

.form-slide-enter-from,
.form-slide-leave-to {
  opacity: 0;
  transform: translateY(12px);
}

.form-slide-enter-to,
.form-slide-leave-from {
  opacity: 1;
  transform: translateY(0);
}
.text-custom-red {
  color: #f44336;
}
.food-action-btn {
  width: 110px;
}
</style>
