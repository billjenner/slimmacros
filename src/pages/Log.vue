<template>
  <q-page class="q-pa-md">
    <div class="row justify-center">
      <div class="col-12 col-md-10 col-lg-8">
        <q-card flat bordered class="q-pa-md">
          <div class="text-h5 q-mb-md">Log</div>

          <q-tabs
            v-model="activeTab"
            align="left"
            dense
            class="text-primary"
            indicator-color="accent"
          >
            <q-tab name="food" label="Food" />
            <q-tab name="workouts" label="Workouts" />
            <q-tab name="suplliments" label="Suplliments" />
            <q-tab name="weight" label="Weight" />
          </q-tabs>

          <q-separator class="q-my-md" />

          <q-tab-panels v-model="activeTab" animated>
            <q-tab-panel name="food" class="q-pa-none">
              <q-banner v-if="foodLogsStore.error" class="bg-negative text-white q-mb-md" rounded>
                {{ foodLogsStore.error }}
              </q-banner>

              <q-banner
                v-else-if="!usersStore.currentUser"
                class="bg-warning text-dark q-mb-md"
                rounded
              >
                Sign in to record food consumption.
              </q-banner>

              <q-form @submit.prevent="submitFoodLog" class="q-gutter-md">
                <q-card flat bordered class="q-pa-md bg-grey-1">
                  <div class="text-subtitle1 q-mb-sm">Log entry</div>
                  <div class="row q-col-gutter-md">
                    <div class="col-12 col-md-6">
                      <q-select
                        v-model="foodLog.food_id"
                        :options="foodOptions"
                        label="Food"
                        filled
                        dense
                        emit-value
                        map-options
                        :disable="!usersStore.currentUser"
                        :rules="[(value) => !!value || 'Food is required']"
                      />
                    </div>

                    <div class="col-12 col-md-3">
                      <q-input
                        v-model="foodLog.servings"
                        type="number"
                        label="Servings"
                        min="0.01"
                        step="0.01"
                        filled
                        dense
                        :disable="!usersStore.currentUser"
                        :rules="[(value) => Number(value) > 0 || 'Servings must be greater than 0']"
                      />
                    </div>

                    <div class="col-12 col-md-3">
                      <q-input
                        v-model="foodLog.datetime"
                        type="datetime-local"
                        label="Date and time"
                        filled
                        dense
                        :disable="!usersStore.currentUser"
                      />
                    </div>

                    <div class="col-12 col-md-6">
                      <q-input
                        :model-value="selectedFoodCalories"
                        label="Calories per serving"
                        readonly
                        filled
                        dense
                      />
                    </div>

                    <div class="col-12 col-md-6">
                      <q-input
                        :model-value="entryTotalCalories"
                        label="Total calories"
                        readonly
                        filled
                        dense
                      />
                    </div>
                  </div>

                  <div class="row justify-end q-mt-md">
                    <q-btn
                      type="submit"
                      color="primary"
                      label="Add to log"
                      :loading="foodLogsStore.loading"
                      :disable="!usersStore.currentUser"
                    />
                  </div>
                </q-card>
              </q-form>

              <q-card flat bordered class="q-pa-md bg-grey-1 q-mt-md">
                <div class="row items-center justify-between q-mb-sm">
                  <div class="text-subtitle1">Logged foods</div>
                  <q-chip color="secondary" text-color="white" square>
                    Total logged calories: {{ totalLoggedCalories }}
                  </q-chip>
                </div>

                <q-table
                  :rows="tableRows"
                  :columns="columns"
                  row-key="food_log_id"
                  flat
                  bordered
                  dense
                  hide-header
                  :loading="foodLogsStore.loading"
                  no-data-label="No food log records yet."
                >
                  <template #body="props">
                    <q-tr :props="props">
                      <q-td key="summary" :props="props">
                        <div class="row items-center full-width">
                          <span>{{ props.row.summary }}</span>
                          <div class="q-ml-auto">
                            <q-btn
                              flat
                              dense
                              size="sm"
                              color="negative"
                              label="Delete"
                              @click="requestDelete(props.row)"
                            />
                          </div>
                        </div>
                      </q-td>
                    </q-tr>
                  </template>
                </q-table>
              </q-card>

              <q-dialog v-model="confirmDeleteOpen">
                <q-card style="min-width: 320px">
                  <q-card-section class="text-h6">Delete log entry?</q-card-section>
                  <q-card-section>
                    Delete {{ pendingDeleteRow?.description || 'this entry' }} from your food log?
                  </q-card-section>
                  <q-card-actions align="right">
                    <q-btn flat label="No" color="primary" @click="cancelDelete" />
                    <q-btn label="Yes" color="negative" @click="confirmDelete" />
                  </q-card-actions>
                </q-card>
              </q-dialog>
            </q-tab-panel>

            <q-tab-panel name="workouts" class="q-pa-none">
              <q-card flat bordered class="q-pa-md bg-grey-1">
                <div class="text-subtitle1">Workouts log coming soon</div>
              </q-card>
            </q-tab-panel>

            <q-tab-panel name="suplliments" class="q-pa-none">
              <q-card flat bordered class="q-pa-md bg-grey-1">
                <div class="text-subtitle1">Suplliments log coming soon</div>
              </q-card>
            </q-tab-panel>

            <q-tab-panel name="weight" class="q-pa-none">
              <q-card flat bordered class="q-pa-md bg-grey-1">
                <div class="text-subtitle1">Weight log coming soon</div>
              </q-card>
            </q-tab-panel>
          </q-tab-panels>
        </q-card>
      </div>
    </div>
  </q-page>
</template>

<script setup>
import { computed, onMounted, reactive, ref, watch } from 'vue'
import { useUsersStore } from 'stores/users'
import { useFoodsStore } from 'stores/foods'
import { useFoodLogsStore } from 'stores/food-logs'
import { calculateFoodCalories } from '../utils/rules'

const usersStore = useUsersStore()
const foodsStore = useFoodsStore()
const foodLogsStore = useFoodLogsStore()
const activeTab = ref('food')

function getCurrentLocalDateTime() {
  const now = new Date()
  const year = now.getFullYear()
  const month = String(now.getMonth() + 1).padStart(2, '0')
  const day = String(now.getDate()).padStart(2, '0')
  const hours = String(now.getHours()).padStart(2, '0')
  const minutes = String(now.getMinutes()).padStart(2, '0')

  return `${year}-${month}-${day}T${hours}:${minutes}`
}

const foodLog = reactive({
  food_id: null,
  servings: 1,
  datetime: getCurrentLocalDateTime(),
})

const confirmDeleteOpen = ref(false)
const pendingDeleteRow = ref(null)

const columns = [
  {
    name: 'summary',
    label: 'Summary',
    field: 'summary',
    align: 'right',
  },
]

const foodOptions = computed(() => {
  return (foodsStore.foods || []).map((food) => ({
    label: food.description,
    value: food.food_id,
  }))
})

const selectedFood = computed(() => {
  return (foodsStore.foods || []).find((food) => food.food_id === foodLog.food_id) || null
})

const selectedFoodCalories = computed(() => {
  if (!selectedFood.value) {
    return 0
  }

  return calculateFoodCalories({
    carbs: selectedFood.value.carb,
    protein: selectedFood.value.protein,
    fat: selectedFood.value.fat,
    extraCalories: selectedFood.value.calories_extra,
  })
})

const entryTotalCalories = computed(() => {
  const servings = Number(foodLog.servings)
  if (!Number.isFinite(servings) || servings <= 0) {
    return 0
  }

  return Math.round(selectedFoodCalories.value * servings)
})

const tableRows = computed(() => {
  return (foodLogsStore.logs || []).map((log) => {
    const food = log.food || {}
    const perServingCalories = calculateFoodCalories({
      carbs: food.carb,
      protein: food.protein,
      fat: food.fat,
      extraCalories: food.calories_extra,
    })

    const servings = Number(log.servings) || 0
    return {
      ...log,
      description: food.description || `Food #${log.food_id}`,
      servingsLabel: servings.toFixed(2),
      totalCalories: Math.round(perServingCalories * servings),
      summary: `${food.description || `Food #${log.food_id}`} | ${servings.toFixed(2)} | ${Math.round(perServingCalories * servings)}`,
    }
  })
})

const totalLoggedCalories = computed(() => {
  return tableRows.value.reduce((sum, row) => sum + (Number(row.totalCalories) || 0), 0)
})

onMounted(() => {
  if (usersStore.currentUser?.user_id) {
    loadDataForUser(usersStore.currentUser.user_id)
  }
})

watch(
  () => usersStore.currentUser?.user_id,
  (userId) => {
    if (userId) {
      loadDataForUser(userId)
      return
    }

    foodsStore.foods = []
    foodLogsStore.logs = []
  },
)

async function loadDataForUser(userId) {
  if (!userId) {
    return
  }

  await Promise.all([foodsStore.loadFoods(userId), foodLogsStore.loadFoodLogs(userId)])
}

function toIsoDateTime(localDateTime) {
  if (!localDateTime) {
    return null
  }

  const parsed = new Date(localDateTime)
  if (Number.isNaN(parsed.getTime())) {
    return null
  }

  return parsed.toISOString()
}

async function submitFoodLog() {
  if (!usersStore.currentUser?.user_id) {
    foodLogsStore.error = 'No current user is available.'
    return
  }

  const payload = {
    food_id: foodLog.food_id,
    servings: foodLog.servings,
  }

  const isoDateTime = toIsoDateTime(foodLog.datetime)
  if (foodLog.datetime && !isoDateTime) {
    foodLogsStore.error = 'Please enter a valid date and time.'
    return
  }

  if (isoDateTime) {
    payload.datetime = isoDateTime
  }

  const saved = await foodLogsStore.createFoodLog(usersStore.currentUser.user_id, payload)
  if (saved) {
    foodLog.servings = 1
    foodLog.datetime = getCurrentLocalDateTime()
    await foodLogsStore.loadFoodLogs(usersStore.currentUser.user_id)
  }
}

function requestDelete(row) {
  pendingDeleteRow.value = row
  confirmDeleteOpen.value = true
}

function cancelDelete() {
  pendingDeleteRow.value = null
  confirmDeleteOpen.value = false
}

async function confirmDelete() {
  const row = pendingDeleteRow.value
  pendingDeleteRow.value = null
  confirmDeleteOpen.value = false

  if (!usersStore.currentUser?.user_id || !row?.food_log_id) {
    foodLogsStore.error = 'No current user is available.'
    return
  }

  const { error } = await foodLogsStore.deleteFoodLog(
    usersStore.currentUser.user_id,
    row.food_log_id,
  )
  if (!error) {
    await foodLogsStore.loadFoodLogs(usersStore.currentUser.user_id)
  }
}
</script>
