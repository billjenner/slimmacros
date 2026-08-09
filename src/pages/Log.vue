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
              <q-banner
                v-if="workoutLogsStore.error"
                class="bg-negative text-white q-mb-md"
                rounded
              >
                {{ workoutLogsStore.error }}
              </q-banner>

              <q-banner
                v-else-if="!usersStore.currentUser"
                class="bg-warning text-dark q-mb-md"
                rounded
              >
                Sign in to record workouts.
              </q-banner>

              <q-form @submit.prevent="submitWorkoutLog" class="q-gutter-md">
                <q-card flat bordered class="q-pa-md bg-grey-1">
                  <div class="text-subtitle1 q-mb-sm">Workout log entry</div>
                  <div class="row q-col-gutter-md">
                    <div class="col-12 col-md-6">
                      <q-select
                        v-model="workoutLog.workout_id"
                        :options="workoutOptions"
                        label="Workout"
                        filled
                        dense
                        emit-value
                        map-options
                        :disable="!usersStore.currentUser"
                        :rules="[(value) => !!value || 'Workout is required']"
                      />
                    </div>

                    <div class="col-12 col-md-3">
                      <q-input
                        v-model="workoutLog.workout_time"
                        type="number"
                        label="Workout time (min)"
                        min="0"
                        step="1"
                        filled
                        dense
                        :disable="!usersStore.currentUser"
                        :rules="[
                          (value) =>
                            value === '' || Number(value) >= 0 || 'Time must be 0 or greater',
                        ]"
                      />
                    </div>

                    <div class="col-12 col-md-3">
                      <q-input
                        v-model="workoutLog.date"
                        type="date"
                        label="Date"
                        filled
                        dense
                        :disable="!usersStore.currentUser"
                      />
                    </div>

                    <div class="col-12 col-md-6">
                      <q-input
                        :model-value="workoutTotalCaloriesBurned"
                        label="Total calories burned"
                        filled
                        dense
                        readonly
                      />
                    </div>
                  </div>

                  <div class="row justify-end q-mt-md">
                    <q-btn
                      type="submit"
                      color="primary"
                      label="Add to log"
                      :loading="workoutLogsStore.loading"
                      :disable="!usersStore.currentUser"
                    />
                  </div>
                </q-card>
              </q-form>

              <q-card flat bordered class="q-pa-md bg-grey-1 q-mt-md">
                <div class="text-subtitle1 q-mb-sm">Logged workouts</div>

                <q-table
                  :rows="workoutTableRows"
                  :columns="workoutColumns"
                  row-key="workout_log_id"
                  flat
                  bordered
                  dense
                  hide-header
                  :loading="workoutLogsStore.loading"
                  no-data-label="No workout log records yet."
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
                              @click="requestDeleteWorkoutLog(props.row)"
                            />
                          </div>
                        </div>
                      </q-td>
                    </q-tr>
                  </template>
                </q-table>
              </q-card>

              <q-dialog v-model="confirmDeleteWorkoutLogOpen">
                <q-card style="min-width: 320px">
                  <q-card-section class="text-h6">Delete workout log entry?</q-card-section>
                  <q-card-section>
                    Delete {{ pendingDeleteWorkoutRow?.description || 'this entry' }} from your
                    workout log?
                  </q-card-section>
                  <q-card-actions align="right">
                    <q-btn flat label="No" color="primary" @click="cancelDeleteWorkoutLog" />
                    <q-btn label="Yes" color="negative" @click="confirmDeleteWorkoutLog" />
                  </q-card-actions>
                </q-card>
              </q-dialog>
            </q-tab-panel>

            <q-tab-panel name="suplliments" class="q-pa-none">
              <q-banner
                v-if="supplementLogsStore.error"
                class="bg-negative text-white q-mb-md"
                rounded
              >
                {{ supplementLogsStore.error }}
              </q-banner>

              <q-banner
                v-else-if="!usersStore.currentUser"
                class="bg-warning text-dark q-mb-md"
                rounded
              >
                Sign in to record suppliments.
              </q-banner>

              <q-form @submit.prevent="submitSupplementLog" class="q-gutter-md">
                <q-card flat bordered class="q-pa-md bg-grey-1">
                  <div class="text-subtitle1 q-mb-sm">Suppliment log entry</div>
                  <div class="row q-col-gutter-md">
                    <div class="col-12 col-md-6">
                      <q-select
                        v-model="supplementLog.supplement_id"
                        :options="supplementOptions"
                        label="Suppliment"
                        filled
                        dense
                        emit-value
                        map-options
                        :disable="!usersStore.currentUser"
                        :rules="[(value) => !!value || 'Suppliment is required']"
                      />
                    </div>

                    <div class="col-12 col-md-3">
                      <q-input
                        v-model="supplementLog.servings"
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
                        v-model="supplementLog.date"
                        type="date"
                        label="Date"
                        filled
                        dense
                        :disable="!usersStore.currentUser"
                      />
                    </div>
                  </div>

                  <div class="row justify-end q-mt-md">
                    <q-btn
                      type="submit"
                      color="primary"
                      label="Add to log"
                      :loading="supplementLogsStore.loading"
                      :disable="!usersStore.currentUser"
                    />
                  </div>
                </q-card>
              </q-form>

              <q-card flat bordered class="q-pa-md bg-grey-1 q-mt-md">
                <div class="text-subtitle1 q-mb-sm">Logged suppliments</div>

                <q-table
                  :rows="supplementTableRows"
                  :columns="supplementColumns"
                  row-key="supplement_log_id"
                  flat
                  bordered
                  dense
                  hide-header
                  :loading="supplementLogsStore.loading"
                  no-data-label="No suppliment log records yet."
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
                              @click="requestDeleteSupplementLog(props.row)"
                            />
                          </div>
                        </div>
                      </q-td>
                    </q-tr>
                  </template>
                </q-table>
              </q-card>

              <q-dialog v-model="confirmDeleteSupplementLogOpen">
                <q-card style="min-width: 320px">
                  <q-card-section class="text-h6">Delete suppliment log entry?</q-card-section>
                  <q-card-section>
                    Delete {{ pendingDeleteSupplementRow?.description || 'this entry' }} from your
                    suppliment log?
                  </q-card-section>
                  <q-card-actions align="right">
                    <q-btn flat label="No" color="primary" @click="cancelDeleteSupplementLog" />
                    <q-btn label="Yes" color="negative" @click="confirmDeleteSupplementLog" />
                  </q-card-actions>
                </q-card>
              </q-dialog>
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
import { useWorkoutsStore } from 'stores/workouts'
import { useWorkoutLogsStore } from 'stores/workout-logs'
import { useSupplementLogsStore } from 'stores/supplement-logs'
import { calculateFoodCalories } from '../utils/rules'

const usersStore = useUsersStore()
const foodsStore = useFoodsStore()
const foodLogsStore = useFoodLogsStore()
const workoutsStore = useWorkoutsStore()
const workoutLogsStore = useWorkoutLogsStore()
const supplementLogsStore = useSupplementLogsStore()
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

function getCurrentLocalDate() {
  const now = new Date()
  const year = now.getFullYear()
  const month = String(now.getMonth() + 1).padStart(2, '0')
  const day = String(now.getDate()).padStart(2, '0')

  return `${year}-${month}-${day}`
}

const foodLog = reactive({
  food_id: null,
  servings: 1,
  datetime: getCurrentLocalDateTime(),
})

const workoutLog = reactive({
  workout_id: null,
  workout_time: null,
  date: getCurrentLocalDate(),
})

const supplementLog = reactive({
  supplement_id: null,
  servings: 1,
  date: getCurrentLocalDate(),
})

const confirmDeleteOpen = ref(false)
const pendingDeleteRow = ref(null)
const confirmDeleteWorkoutLogOpen = ref(false)
const pendingDeleteWorkoutRow = ref(null)
const confirmDeleteSupplementLogOpen = ref(false)
const pendingDeleteSupplementRow = ref(null)

const columns = [
  {
    name: 'summary',
    label: 'Summary',
    field: 'summary',
    align: 'right',
  },
]

const workoutColumns = [
  {
    name: 'summary',
    label: 'Summary',
    field: 'summary',
    align: 'right',
  },
]

const supplementColumns = [
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

const workoutOptions = computed(() => {
  return (workoutsStore.workouts || []).map((workout) => ({
    label: workout.type,
    value: workout.workout_id,
  }))
})

const supplementOptions = computed(() => {
  return (supplementLogsStore.supplements || []).map((supplement) => ({
    label: `${supplement.description} (${supplement.serving_size ?? 1} ${supplement.serving_unit || 'other'})`,
    value: supplement.supplement_id,
  }))
})

function areSameId(leftId, rightId) {
  if (leftId === null || leftId === undefined || rightId === null || rightId === undefined) {
    return false
  }

  return String(leftId) === String(rightId)
}

const selectedWorkout = computed(() => {
  return (workoutsStore.workouts || []).find((workout) =>
    areSameId(workout.workout_id, workoutLog.workout_id),
  )
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

const workoutTableRows = computed(() => {
  return (workoutLogsStore.logs || []).map((log) => {
    const workout = log.workout || {}
    const workoutLabel = workout.type || `Workout #${log.workout_id}`
    const workoutTime = log.workout_time ?? workout.average_workout_time ?? 'N/A'

    return {
      ...log,
      description: workoutLabel,
      summary: `${workoutLabel} | ${workoutTime} | ${log.date || ''}`,
    }
  })
})

const workoutTotalCaloriesBurned = computed(() => {
  const selected = selectedWorkout.value
  if (!selected) {
    return 0
  }

  const workoutTime = Number(workoutLog.workout_time)
  const averageWorkoutTime = Number(selected.average_workout_time)
  const caloriesBurned = Number(selected.calories_burned)

  if (
    !Number.isFinite(workoutTime) ||
    workoutTime < 0 ||
    !Number.isFinite(averageWorkoutTime) ||
    averageWorkoutTime <= 0 ||
    !Number.isFinite(caloriesBurned) ||
    caloriesBurned < 0
  ) {
    return 0
  }

  return Math.round((workoutTime / averageWorkoutTime) * caloriesBurned)
})

const supplementTableRows = computed(() => {
  return (supplementLogsStore.logs || []).map((log) => {
    const supplement = log.supplement || {}
    const label = supplement.description || `Suppliment #${log.supplement_id}`
    const servings = Number(log.servings) || 0

    return {
      ...log,
      description: label,
      summary: `${label} | ${servings.toFixed(2)} | ${log.date || ''}`,
    }
  })
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
    workoutsStore.workouts = []
    workoutLogsStore.logs = []
    supplementLogsStore.supplements = []
    supplementLogsStore.logs = []
  },
)

watch(
  () => workoutLog.workout_id,
  () => {
    workoutLog.workout_time = selectedWorkout.value?.average_workout_time ?? null
  },
)

watch(
  () => selectedWorkout.value,
  (workout) => {
    if (workout && (workoutLog.workout_time === null || workoutLog.workout_time === '')) {
      workoutLog.workout_time = workout.average_workout_time ?? null
    }
  },
)

async function loadDataForUser(userId) {
  if (!userId) {
    return
  }

  await Promise.all([
    foodsStore.loadFoods(userId),
    foodLogsStore.loadFoodLogs(userId),
    workoutsStore.loadWorkouts(userId),
    workoutLogsStore.loadWorkoutLogs(userId),
    supplementLogsStore.loadSupplements(userId),
    supplementLogsStore.loadSupplementLogs(userId),
  ])
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

async function submitWorkoutLog() {
  if (!usersStore.currentUser?.user_id) {
    workoutLogsStore.error = 'No current user is available.'
    return
  }

  const payload = {
    workout_id: workoutLog.workout_id,
    workout_time: workoutLog.workout_time,
    date: workoutLog.date,
  }

  const saved = await workoutLogsStore.createWorkoutLog(usersStore.currentUser.user_id, payload)
  if (saved) {
    workoutLog.workout_time = selectedWorkout.value?.average_workout_time ?? null
    workoutLog.date = getCurrentLocalDate()
    await workoutLogsStore.loadWorkoutLogs(usersStore.currentUser.user_id)
  }
}

async function submitSupplementLog() {
  if (!usersStore.currentUser?.user_id) {
    supplementLogsStore.error = 'No current user is available.'
    return
  }

  const payload = {
    supplement_id: supplementLog.supplement_id,
    servings: supplementLog.servings,
    date: supplementLog.date,
  }

  const saved = await supplementLogsStore.createSupplementLog(
    usersStore.currentUser.user_id,
    payload,
  )
  if (saved) {
    supplementLog.servings = 1
    supplementLog.date = getCurrentLocalDate()
    await supplementLogsStore.loadSupplementLogs(usersStore.currentUser.user_id)
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

function requestDeleteWorkoutLog(row) {
  pendingDeleteWorkoutRow.value = row
  confirmDeleteWorkoutLogOpen.value = true
}

function cancelDeleteWorkoutLog() {
  pendingDeleteWorkoutRow.value = null
  confirmDeleteWorkoutLogOpen.value = false
}

async function confirmDeleteWorkoutLog() {
  const row = pendingDeleteWorkoutRow.value
  pendingDeleteWorkoutRow.value = null
  confirmDeleteWorkoutLogOpen.value = false

  if (!usersStore.currentUser?.user_id || !row?.workout_log_id) {
    workoutLogsStore.error = 'No current user is available.'
    return
  }

  const { error } = await workoutLogsStore.deleteWorkoutLog(
    usersStore.currentUser.user_id,
    row.workout_log_id,
  )
  if (!error) {
    await workoutLogsStore.loadWorkoutLogs(usersStore.currentUser.user_id)
  }
}

function requestDeleteSupplementLog(row) {
  pendingDeleteSupplementRow.value = row
  confirmDeleteSupplementLogOpen.value = true
}

function cancelDeleteSupplementLog() {
  pendingDeleteSupplementRow.value = null
  confirmDeleteSupplementLogOpen.value = false
}

async function confirmDeleteSupplementLog() {
  const row = pendingDeleteSupplementRow.value
  pendingDeleteSupplementRow.value = null
  confirmDeleteSupplementLogOpen.value = false

  if (!usersStore.currentUser?.user_id || !row?.supplement_log_id) {
    supplementLogsStore.error = 'No current user is available.'
    return
  }

  const { error } = await supplementLogsStore.deleteSupplementLog(
    usersStore.currentUser.user_id,
    row.supplement_log_id,
  )

  if (!error) {
    await supplementLogsStore.loadSupplementLogs(usersStore.currentUser.user_id)
  }
}
</script>
