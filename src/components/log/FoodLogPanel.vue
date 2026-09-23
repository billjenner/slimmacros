<template>
  <div>
    <q-banner v-if="foodLogsStore.error" class="bg-negative text-white q-mb-md" rounded>
      {{ foodLogsStore.error }}
    </q-banner>

    <q-banner v-else-if="!usersStore.currentUser" class="bg-warning text-dark q-mb-md" rounded>
      Sign in to record food consumption.
    </q-banner>

    <q-form @submit.prevent="submitFoodLog" class="q-gutter-md">
      <q-card flat bordered class="q-pa-md bg-grey-1">
        <div class="row items-center q-mb-sm">
          <q-btn
            flat
            round
            dense
            type="button"
            :icon="isFoodLogExpanded ? 'expand_more' : 'chevron_right'"
            @click="isFoodLogExpanded = !isFoodLogExpanded"
          />
          <div class="text-subtitle1">Log Food</div>
        </div>

        <div v-show="isFoodLogExpanded">
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

            <div class="col-12 col-md-3">
              <q-input
                :model-value="selectedFood?.serving_size ?? 1"
                label="Serving size"
                readonly
                filled
                dense
              />
            </div>

            <div class="col-12 col-md-3">
              <q-input
                :model-value="selectedFood?.serving_unit || 'unit'"
                label="Serving unit"
                readonly
                filled
                dense
              />
            </div>

            <div class="col-12 col-md-3">
              <q-input
                :model-value="selectedFoodCalories"
                label="Calories per serving"
                readonly
                filled
                dense
              />
            </div>

            <div class="col-12 col-md-3">
              <q-input
                :model-value="entryTotalCalories"
                label="Total calories"
                readonly
                filled
                dense
              />
            </div>
          </div>

          <div class="row items-center justify-between q-mt-md">
            <q-toggle
              v-model="includeSharedFood"
              label="Include shared food"
              :disable="!usersStore.currentUser"
            />
            <q-btn
              type="submit"
              color="primary"
              label="Add to log"
              :loading="foodLogsStore.loading"
              :disable="!usersStore.currentUser"
            />
          </div>
        </div>
      </q-card>
    </q-form>

    <q-card flat bordered class="q-pa-md bg-grey-1 q-mt-md">
      <div class="row items-center q-mb-sm">
        <q-btn
          flat
          round
          dense
          type="button"
          :icon="isChartBudgetExpanded ? 'expand_more' : 'chevron_right'"
          @click="isChartBudgetExpanded = !isChartBudgetExpanded"
        />
        <div class="text-subtitle1">Daily Chart Budget</div>
      </div>

      <div v-show="isChartBudgetExpanded">
        <div class="row items-center q-px-md q-py-sm">
          <div class="col text-subtitle2 text-center">{{ selectedFoodLogDayOfWeek }}</div>
          <div class="row items-center no-wrap q-gutter-xs">
            <q-btn flat dense type="button" label="<" @click="goToPreviousFoodLogDate" />
            <q-input
              v-model="selectedFoodLogDate"
              type="date"
              filled
              dense
              style="max-width: 220px"
            />
            <q-btn flat dense type="button" label=">" @click="goToNextFoodLogDate" />
          </div>
        </div>
        <q-markup-table flat bordered dense separator="horizontal">
          <tbody>
            <tr>
              <td style="width: 84%">
                <q-linear-progress :value="foodLogProgress" color="brown" size="18px" rounded />
              </td>
              <td style="width: 16%">
                <q-chip dense color="secondary" text-color="white" square>
                  Calories: {{ Math.round(totalLoggedCalories) }} /
                  {{ Math.round(totalCaloriesForPerson || 2000) }}
                </q-chip>
              </td>
            </tr>
            <tr>
              <td>
                <q-linear-progress :value="foodProteinProgress" color="green" size="10px" rounded />
              </td>
              <td>
                <q-chip dense color="secondary" text-color="white" square>
                  Protein: {{ Math.round(totalProteinLoggedToday) }} /
                  {{ Math.round(totalProteinBudgetForToday) }}
                </q-chip>
              </td>
            </tr>
            <tr>
              <td>
                <q-linear-progress :value="foodCarbProgress" color="yellow" size="10px" rounded />
              </td>
              <td>
                <q-chip dense color="secondary" text-color="white" square>
                  Carbs: {{ Math.round(totalCarbsLoggedToday) }} /
                  {{ Math.round(totalCarbBudgetForToday) }}
                </q-chip>
              </td>
            </tr>
            <tr>
              <td>
                <q-linear-progress :value="foodFatProgress" color="blue" size="10px" rounded />
              </td>
              <td>
                <q-chip dense color="secondary" text-color="white" square>
                  Fat: {{ Math.round(totalFatLoggedToday) }} /
                  {{ Math.round(totalFatBudgetForToday) }}
                </q-chip>
              </td>
            </tr>
          </tbody>
        </q-markup-table>
      </div>
    </q-card>

    <q-card flat bordered class="q-pa-none bg-grey-1 q-mt-md">
      <div class="row items-center justify-between q-px-md q-py-sm">
        <div class="text-subtitle1">Logged Food</div>
        <q-chip :color="weightChangeChip.color" text-color="white" square>
          {{ weightChangeChip.label }}
        </q-chip>
      </div>

      <q-table
        :rows="foodTableRows"
        :columns="columns"
        :pagination="{ rowsPerPage: 50 }"
        :rows-per-page-options="[20, 50, 200, 0]"
        row-key="food_log_id"
        flat
        bordered
        dense
        hide-header
        square
        class="full-width no-border"
        :loading="foodLogsStore.loading"
        no-data-label="No food log records yet."
      >
        <template #top-row>
          <q-tr
            class="bg-accent text-white tehttp://localhost:9000/#/goodsxt-caption text-weight-medium"
          >
            <q-td colspan="1" class="text-left text-white" style="font-size: 9px"
              >DESCRIPTION | SERVINGS | SERV. SIZE | CALORIES | TIME</q-td
            >
          </q-tr>
        </template>

        <template #body="props">
          <q-tr :props="props" :style="!props.row.isToday ? 'background-color: #E8E8E8' : ''">
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
  </div>
</template>

<script setup>
import { computed, onMounted, reactive, ref, watch } from 'vue'
import { useQuasar } from 'quasar'
import { useUsersStore } from 'stores/users'
import { useFoodStore } from 'stores/food'
import { useFoodLogsStore } from 'stores/food-logs'
import { useProfileStore } from 'stores/profile'
import { useWorkoutsStore } from 'stores/workouts'
import { useWorkoutLogsStore } from 'stores/workout-logs'
import { useWeightLogsStore } from 'stores/weight-logs'
import {
  calculateFoodCalories,
  calculateTotalCaloriesForPerson,
  calculateTotalDailyCalories,
} from '../../utils/rules'
import { notifySuccess } from '../../utils/notify'

const $q = useQuasar()

const isFoodLogExpanded = ref(true)
const isChartBudgetExpanded = ref(false)
const confirmDeleteOpen = ref(false)
const pendingDeleteRow = ref(null)
const includeSharedFood = ref(false)
const selectedFoodLogDate = ref(getCurrentLocalDate())
const usersStore = useUsersStore()
const foodStore = useFoodStore()
const foodLogsStore = useFoodLogsStore()
const profileStore = useProfileStore()
const workoutsStore = useWorkoutsStore()
const workoutLogsStore = useWorkoutLogsStore()
const weightLogsStore = useWeightLogsStore()

const columns = [
  {
    name: 'summary',
    label: 'Summary',
    field: 'summary',
    align: 'right',
  },
]

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

    foodStore.food = []
    foodLogsStore.logs = []
    profileStore.currentProfile = null
    workoutsStore.workouts = []
    workoutLogsStore.logs = []
    weightLogsStore.logs = []
  },
)

const currentProfile = computed(() => profileStore.currentProfile || null)

function getCurrentLocalDate() {
  const now = new Date()
  const year = now.getFullYear()
  const month = String(now.getMonth() + 1).padStart(2, '0')
  const day = String(now.getDate()).padStart(2, '0')

  return `${year}-${month}-${day}`
}

function getCurrentLocalDateTime() {
  const now = new Date()
  const year = now.getFullYear()
  const month = String(now.getMonth() + 1).padStart(2, '0')
  const day = String(now.getDate()).padStart(2, '0')
  const hours = String(now.getHours()).padStart(2, '0')
  const minutes = String(now.getMinutes()).padStart(2, '0')

  return `${year}-${month}-${day}T${hours}:${minutes}`
}

function shiftLocalDate(dateKey, dayDelta) {
  const [yearString, monthString, dayString] = String(dateKey || '').split('-')
  const year = Number(yearString)
  const month = Number(monthString)
  const day = Number(dayString)

  if (!year || !month || !day) {
    return getCurrentLocalDate()
  }

  const shiftedDate = new Date(year, month - 1, day + dayDelta)
  const shiftedYear = shiftedDate.getFullYear()
  const shiftedMonth = String(shiftedDate.getMonth() + 1).padStart(2, '0')
  const shiftedDay = String(shiftedDate.getDate()).padStart(2, '0')

  return `${shiftedYear}-${shiftedMonth}-${shiftedDay}`
}

function goToPreviousFoodLogDate() {
  selectedFoodLogDate.value = shiftLocalDate(selectedFoodLogDate.value, -1)
}

function goToNextFoodLogDate() {
  selectedFoodLogDate.value = shiftLocalDate(selectedFoodLogDate.value, 1)
}

const selectedFoodLogDayOfWeek = computed(() => {
  const [yearString, monthString, dayString] = String(selectedFoodLogDate.value || '').split('-')
  const year = Number(yearString)
  const month = Number(monthString)
  const day = Number(dayString)

  if (!year || !month || !day) {
    return ''
  }

  const selectedDate = new Date(year, month - 1, day)

  if (Number.isNaN(selectedDate.getTime())) {
    return ''
  }

  return selectedDate.toLocaleDateString(undefined, { weekday: 'long' })
})

function getDaysBetween(dateString1, dateString2) {
  if (!dateString1 || !dateString2) return 0
  const [y1, m1, d1] = String(dateString1).slice(0, 10).split('-').map(Number)
  const [y2, m2, d2] = String(dateString2).slice(0, 10).split('-').map(Number)
  if (!y1 || !m1 || !d1 || !y2 || !m2 || !d2) return 0
  const date1 = Date.UTC(y1, m1 - 1, d1)
  const date2 = Date.UTC(y2, m2 - 1, d2)
  return Math.round(Math.abs(date2 - date1) / (1000 * 60 * 60 * 24))
}

const weightLogsSortedByDate = computed(() => {
  return [...(weightLogsStore.logs || [])]
    .filter((log) => Number.isFinite(Number(log?.weight)) && Number(log?.weight) > 0)
    .sort((leftLog, rightLog) => {
      const leftKey = String(leftLog?.date || '').slice(0, 10)
      const rightKey = String(rightLog?.date || '').slice(0, 10)

      return leftKey.localeCompare(rightKey)
    })
})

const previousWeightLogForSelectedFoodDate = computed(() => {
  const selectedDateKey = String(selectedFoodLogDate.value || '').slice(0, 10)

  return (
    [...weightLogsSortedByDate.value].reverse().find((log) => {
      const dateKey = String(log?.date || '').slice(0, 10)
      return dateKey <= selectedDateKey
    }) || null
  )
})

const previousWeightForSelectedFoodDate = computed(() => {
  const priorWeightLog = previousWeightLogForSelectedFoodDate.value

  if (priorWeightLog) {
    return Number(priorWeightLog.weight)
  }

  const profileStartWeight = Number(currentProfile.value?.start_weight)
  return Number.isFinite(profileStartWeight) && profileStartWeight > 0 ? profileStartWeight : null
})

const nextWeightLogForSelectedFoodDate = computed(() => {
  const selectedDateKey = String(selectedFoodLogDate.value || '').slice(0, 10)

  return (
    weightLogsSortedByDate.value.find((log) => {
      const dateKey = String(log?.date || '').slice(0, 10)
      return dateKey > selectedDateKey
    }) || null
  )
})

const nextWeightForSelectedFoodDate = computed(() => {
  const nextWeightLog = nextWeightLogForSelectedFoodDate.value
  return nextWeightLog ? Number(nextWeightLog.weight) : null
})

const daysWeightLoss = computed(() => {
  const previousWeight = previousWeightForSelectedFoodDate.value
  const nextWeight = nextWeightForSelectedFoodDate.value

  if (previousWeight === null || nextWeight === null) {
    return null
  }

  const prevLog = previousWeightLogForSelectedFoodDate.value
  const nextLog = nextWeightLogForSelectedFoodDate.value

  if (prevLog?.date && nextLog?.date) {
    const selectedDateKey = String(selectedFoodLogDate.value || '').slice(0, 10)
    const prevDateKey = String(prevLog.date || '').slice(0, 10)
    const nextDateKey = String(nextLog.date || '').slice(0, 10)

    const daysFromSelectedToNext = getDaysBetween(selectedDateKey, nextDateKey)
    const daysFromPrevToSelected = getDaysBetween(prevDateKey, selectedDateKey)
    const daysBetweenPrevAndNext = getDaysBetween(prevDateKey, nextDateKey)

    if (
      Math.abs(daysFromSelectedToNext - daysFromPrevToSelected) > 1 &&
      daysBetweenPrevAndNext > 0
    ) {
      return Number(((nextWeight - previousWeight) / daysBetweenPrevAndNext).toFixed(2))
    }
  }

  return Number((nextWeight - previousWeight).toFixed(2))
})

const weightChangeChip = computed(() => {
  const change = daysWeightLoss.value

  if (change === null || Number.isNaN(change)) {
    return { label: '----', color: 'grey' }
  }

  if (change === 0) {
    return { label: '-- 0 --', color: 'grey' }
  }

  const absoluteChange = Math.abs(change)
  const roundedChange = Number(absoluteChange.toFixed(2))

  if (change < 0) {
    return { label: `lost ${roundedChange}`, color: 'green' }
  }

  return { label: `gain ${roundedChange}`, color: 'red' }
})

function getCurrentDayOfWeekKey() {
  const dateKey = selectedFoodLogDate.value || getCurrentLocalDate()
  const [yearString, monthString, dayString] = String(dateKey).split('-')
  const year = Number(yearString)
  const month = Number(monthString)
  const day = Number(dayString)

  if (!year || !month || !day) {
    return 'sunday'
  }

  const dayNames = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday']
  const selectedDate = new Date(year, month - 1, day)

  return dayNames[selectedDate.getDay()] || 'sunday'
}

function getLocalDateKey(value) {
  if (!value) {
    return ''
  }

  const dateValue = new Date(value)
  if (Number.isNaN(dateValue.getTime())) {
    return ''
  }

  const year = dateValue.getFullYear()
  const month = String(dateValue.getMonth() + 1).padStart(2, '0')
  const day = String(dateValue.getDate()).padStart(2, '0')

  return `${year}-${month}-${day}`
}

function formatLocalDateTimeLabel(value) {
  if (!value) {
    return ''
  }

  const dateValue = new Date(value)
  if (Number.isNaN(dateValue.getTime())) {
    return ''
  }

  //const year = dateValue.getFullYear()
  //const month = String(dateValue.getMonth() + 1).padStart(2, '0')
  //const day = String(dateValue.getDate()).padStart(2, '0')
  const hours = String(dateValue.getHours()).padStart(2, '0')
  const minutes = String(dateValue.getMinutes()).padStart(2, '0')

  return `${hours}:${minutes}`
}

const foodLog = reactive({
  food_id: null,
  servings: 1,
  datetime: getCurrentLocalDateTime(),
})

function sortFoodForOptionList(food = []) {
  return [...food].sort((leftFood, rightFood) => {
    const leftIsFavorite = Boolean(leftFood?.favorite_food)
    const rightIsFavorite = Boolean(rightFood?.favorite_food)

    if (leftIsFavorite !== rightIsFavorite) {
      return Number(rightIsFavorite) - Number(leftIsFavorite)
    }

    return String(leftFood?.description || '').localeCompare(String(rightFood?.description || ''))
  })
}

const foodOptions = computed(() => {
  const allFood = foodStore.food || []
  const currentUserId = usersStore.currentUser?.user_id
  const ownFood = sortFoodForOptionList(
    allFood.filter((food) => String(food?.user_id || '') === String(currentUserId || '')),
  )

  if (!includeSharedFood.value) {
    return ownFood.map((food) => ({
      label: `${food.description}${food.favorite_food ? ' | *' : ''}`,
      value: food.food_id,
    }))
  }

  const sharedFood = sortFoodForOptionList(
    allFood.filter((food) => String(food?.user_id || '') !== String(currentUserId || '')),
  )

  return [...ownFood, ...sharedFood].map((food) => ({
    label: `${food.description}${food.favorite_food ? ' | *' : ''}`,
    value: food.food_id,
  }))
})

const selectedFood = computed(() => {
  return (foodStore.food || []).find((food) => food.food_id === foodLog.food_id) || null
})

const totalDailyCalories = computed(() => {
  const selectedDateKey = selectedFoodLogDate.value || getCurrentLocalDate()

  const latestWeightLogForSelectedFoodDate = (weightLogsStore.logs || []).reduce(
    (latestLog, log) => {
      const dateKey = String(log?.date || '').slice(0, 10)
      const weight = Number(log?.weight)

      if (!dateKey || !Number.isFinite(weight) || weight <= 0 || dateKey > selectedDateKey) {
        return latestLog
      }

      if (!latestLog) {
        return log
      }

      const latestDateKey = String(latestLog?.date || '').slice(0, 10)
      const latestWeightLogId = Number(latestLog?.weight_log_id) || 0
      const currentWeightLogId = Number(log?.weight_log_id) || 0

      if (dateKey > latestDateKey) {
        return log
      }

      if (dateKey === latestDateKey && currentWeightLogId > latestWeightLogId) {
        return log
      }

      return latestLog
    },
    null,
  )

  const resolvedWeight = Number(latestWeightLogForSelectedFoodDate?.weight)
  const weight =
    Number.isFinite(resolvedWeight) && resolvedWeight > 0
      ? resolvedWeight
      : Number(currentProfile.value?.start_weight)

  const calories = calculateTotalDailyCalories({
    weight: Number.isFinite(weight) && weight > 0 ? weight : null,
    height: currentProfile.value?.height,
    age: usersStore.currentUser?.age,
    sex: usersStore.currentUser?.sex,
    activityLevel: currentProfile.value?.activity_level,
  })

  return calories ?? null
})

const totalCaloriesForPerson = computed(() => {
  return calculateTotalCaloriesForPerson({
    totalDailyCalories: totalDailyCalories.value,
    dailyCalorieDeficit: currentProfile.value?.daily_calorie_deficit,
    totalWorkoutCaloriesBurnedbyFoodDay: totalWorkoutCaloriesBurnedbyFoodDay.value,
  })
})

const carbBudgetPercentForToday = computed(() => {
  const dayKey = getCurrentDayOfWeekKey()
  return Number(currentProfile.value?.[`${dayKey}_carbs`]) || 175
})

const totalWorkoutCaloriesBurnedbyFoodDay = computed(() => {
  const selectedDateKey = selectedFoodLogDate.value || getCurrentLocalDate()

  return (workoutLogsStore.logs || []).reduce((sum, log) => {
    const logDate = String(log?.date || '').slice(0, 10)
    if (logDate !== selectedDateKey) {
      return sum
    }

    return sum + (Number(log?.calories_burned) || 0)
  }, 0)
})

// 503
const totalCarbsLoggedToday = computed(() => {
  return (foodTableRows.value || []).reduce((sum, row) => {
    const food = row.food || {}
    const carbsPerServing = Number(food.carb) || 0
    const servings = Number(row.servings) || 0

    return sum + carbsPerServing * servings
  }, 0)
})

// 527
const totalProteinLoggedToday = computed(() => {
  return (foodTableRows.value || []).reduce((sum, row) => {
    const food = row.food || {}
    const proteinPerServing = Number(food.protein) || 0
    const servings = Number(row.servings) || 0

    return sum + proteinPerServing * servings
  }, 0)
})

const totalCarbBudgetForToday = computed(() => {
  return (totalCaloriesForPerson.value * carbBudgetPercentForToday.value) / 100 / 4
})

const proteinBudgetPercentForToday = computed(() => {
  const dayKey = getCurrentDayOfWeekKey()
  return Number(currentProfile.value?.[`${dayKey}_protein`]) || 0
})

const fatBudgetPercentForToday = computed(() => {
  const dayKey = getCurrentDayOfWeekKey()
  return Number(currentProfile.value?.[`${dayKey}_fat`]) || 0
})

const totalProteinBudgetForToday = computed(() => {
  return (totalCaloriesForPerson.value * proteinBudgetPercentForToday.value) / 100 / 4
})

const totalFatBudgetForToday = computed(() => {
  return (totalCaloriesForPerson.value * fatBudgetPercentForToday.value) / 100 / 9
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

const totalFatLoggedToday = computed(() => {
  return (foodTableRows.value || []).reduce((sum, row) => {
    const food = row.food || {}
    const fatPerServing = Number(food.fat) || 0
    const servings = Number(row.servings) || 0

    return sum + fatPerServing * servings
  }, 0)
})

const foodTableRows = computed(() => {
  const selectedDate = selectedFoodLogDate.value || getCurrentLocalDate()

  return (foodLogsStore.logs || [])
    .filter((log) => getLocalDateKey(log.datetime) === selectedDate)
    .map((log) => {
      const food = log.food || {}
      const perServingCalories = calculateFoodCalories({
        carbs: food.carb,
        protein: food.protein,
        fat: food.fat,
        extraCalories: food.calories_extra,
      })

      const servings = Number(log.servings) || 0
      const foodServingSize = Number(food.serving_size) || 1
      const foodServingUnit = food.serving_unit || 'other'
      const logDate = getLocalDateKey(log.datetime)
      const logDateTimeLabel = formatLocalDateTimeLabel(log.datetime)

      return {
        ...log,
        description: food.description || `Food #${log.food_id}`,
        servingsLabel: servings.toFixed(2),
        totalCalories: Math.round(perServingCalories * servings),
        isToday: logDate === selectedDate,
        summary: `${food.description || `Food #${log.food_id}`} | ${servings.toFixed(2)} | ${foodServingSize} ${foodServingUnit} | ${Math.round(perServingCalories * servings)} | ${logDateTimeLabel}`,
      }
    })
})

const entryTotalCalories = computed(() => {
  const servings = Number(foodLog.servings)
  if (!Number.isFinite(servings) || servings <= 0) {
    return 0
  }

  return Math.round(selectedFoodCalories.value * servings)
})

const foodLogProgress = computed(() => {
  if (!totalCaloriesForPerson.value) {
    return 0
  }

  return Math.min(1, totalLoggedCalories.value / totalCaloriesForPerson.value)
})

const foodCarbProgress = computed(() => {
  if (!totalCarbBudgetForToday.value) {
    return 0
  }

  return Math.min(1, totalCarbsLoggedToday.value / totalCarbBudgetForToday.value)
})

const foodProteinProgress = computed(() => {
  if (!totalProteinBudgetForToday.value) {
    return 0
  }

  return Math.min(1, totalProteinLoggedToday.value / totalProteinBudgetForToday.value)
})

const foodFatProgress = computed(() => {
  if (!totalFatBudgetForToday.value) {
    return 0
  }

  return Math.min(1, totalFatLoggedToday.value / totalFatBudgetForToday.value)
})

const totalLoggedCalories = computed(() => {
  return foodTableRows.value.reduce((sum, row) => sum + (Number(row.totalCalories) || 0), 0)
})

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
    notifySuccess($q, 'Food added to log successfully.', { color: 'positive' })
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
    notifySuccess($q, 'Food log entry deleted successfully.', { color: 'negative' })
    await foodLogsStore.loadFoodLogs(usersStore.currentUser.user_id)
  }
}
async function loadDataForUser(userId) {
  if (!userId) {
    return
  }

  await Promise.all([
    foodStore.loadFood(userId),
    foodLogsStore.loadFoodLogs(userId),
    workoutsStore.loadWorkouts(userId),
    profileStore.loadCurrentProfile(userId),
  ])
}
</script>
