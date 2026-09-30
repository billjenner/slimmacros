<template>
  <q-card flat bordered class="q-mb-md">
    <q-expansion-item
      label="Food Calories"
      expand-icon="keyboard_arrow_down"
      expanded-icon="keyboard_arrow_up"
      transition-show="jump-down"
      transition-hide="jump-up"
      @after-show="renderFoodChart"
    >
      <q-card-section>
        <q-banner v-if="foodLogsStore.error" class="bg-negative text-white" rounded>
          {{ foodLogsStore.error }}
        </q-banner>
        <q-banner v-else-if="!usersStore.currentUser" class="bg-warning text-dark" rounded>
          Sign in to view your food calories.
        </q-banner>
        <q-banner v-else-if="!foodLogsStore.loading && !foodCaloriesByDay.length" class="bg-grey-2">
          Add food entries to see your daily macro calories.
        </q-banner>
        <div v-else>
          <div class="food-calories-chart q-mb-md">
            <canvas ref="foodCaloriesChart"></canvas>
          </div>
          <hr />
          <div class="row justify-between items-center q-mt-md">
            <q-chip class="resize-chip" color="secondary" text-color="white" square>
              1 year ave: {{ aveCalories1Year }} | deficit: {{ aveCalorieDeficit1Year }}
            </q-chip>
            <q-chip class="resize-chip" color="secondary" text-color="white" square>
              30 days ave: {{ aveCalories30Days }} | deficit: {{ aveCalorieDeficit30Days }}
            </q-chip>
            <q-chip class="resize-chip" color="secondary" text-color="white" square>
              7 days ave: {{ aveCalories7Days }} | deficit: {{ aveCalorieDeficit7Days }}
            </q-chip>
          </div>
        </div>
      </q-card-section>
    </q-expansion-item>
  </q-card>
</template>

<script setup>
import { Chart } from 'chart.js/auto'
import { computed, nextTick, onBeforeUnmount, ref, watch } from 'vue'
import { useFoodLogsStore } from 'stores/food-logs'
import { useProfileStore } from 'stores/profile'
import { useUsersStore } from 'stores/users'
import { useWeightLogsStore } from 'stores/weight-logs'
import { useWorkoutLogsStore } from 'stores/workout-logs'
import { calculateTotalCaloriesForPerson, calculateTotalDailyCalories } from '../../utils/rules'

const foodLogsStore = useFoodLogsStore()
const usersStore = useUsersStore()
const profileStore = useProfileStore()
const weightLogsStore = useWeightLogsStore()
const workoutLogsStore = useWorkoutLogsStore()
const foodCaloriesChart = ref(null)
let foodChart = null

const currentProfile = computed(() => profileStore.currentProfile || null)

const weightLogsSortedByDate = computed(() => {
  return [...(weightLogsStore.logs || [])]
    .filter((log) => Number.isFinite(Number(log?.weight)) && Number(log?.weight) > 0)
    .sort((leftLog, rightLog) => {
      const leftKey = String(leftLog?.date || '').slice(0, 10)
      const rightKey = String(rightLog?.date || '').slice(0, 10)

      return leftKey.localeCompare(rightKey)
    })
})

const foodCaloriesByDay = computed(() => {
  const caloriesByDay = (foodLogsStore.logs || []).reduce((totals, log) => {
    const date = getLocalDateKey(log?.datetime)
    const servings = Number(log?.servings)
    const food = log?.food || {}

    if (!date || !Number.isFinite(servings) || servings <= 0) {
      return totals
    }

    if (!totals[date]) {
      totals[date] = { proteinCalories: 0, carbCalories: 0, fatCalories: 0, entryCount: 0 }
    }

    totals[date].entryCount += 1
    totals[date].proteinCalories += (Number(food.protein) || 0) * servings * 4
    totals[date].carbCalories += (Number(food.carb) || 0) * servings * 4
    totals[date].fatCalories += (Number(food.fat) || 0) * servings * 9
    return totals
  }, {})

  return Object.entries(caloriesByDay)
    .map(([date, calories]) => ({ date, ...calories }))
    .filter((day) => day.entryCount >= 3)
    .sort((leftDay, rightDay) => leftDay.date.localeCompare(rightDay.date))
})

function getDaysBetween(dateString1, dateString2) {
  if (!dateString1 || !dateString2) return 0
  const [y1, m1, d1] = String(dateString1).slice(0, 10).split('-').map(Number)
  const [y2, m2, d2] = String(dateString2).slice(0, 10).split('-').map(Number)
  if (!y1 || !m1 || !d1 || !y2 || !m2 || !d2) return 0
  const date1 = Date.UTC(y1, m1 - 1, d1)
  const date2 = Date.UTC(y2, m2 - 1, d2)
  return Math.round((date2 - date1) / (1000 * 60 * 60 * 24))
}

function getCurrentLocalDateString() {
  const now = new Date()
  const year = now.getFullYear()
  const month = String(now.getMonth() + 1).padStart(2, '0')
  const day = String(now.getDate()).padStart(2, '0')
  return `${year}-${month}-${day}`
}

function getWeightForDate(dateKey) {
  const latestWeightLog = weightLogsSortedByDate.value.reduce((latestLog, log) => {
    const logDateKey = String(log?.date || '').slice(0, 10)

    if (logDateKey > dateKey) {
      return latestLog
    }

    if (!latestLog) {
      return log
    }

    const latestDateKey = String(latestLog?.date || '').slice(0, 10)
    const latestWeightLogId = Number(latestLog?.weight_log_id) || 0
    const currentWeightLogId = Number(log?.weight_log_id) || 0

    if (logDateKey > latestDateKey) {
      return log
    }

    if (logDateKey === latestDateKey && currentWeightLogId > latestWeightLogId) {
      return log
    }

    return latestLog
  }, null)

  const resolvedWeight = Number(latestWeightLog?.weight)
  if (Number.isFinite(resolvedWeight) && resolvedWeight > 0) {
    return resolvedWeight
  }

  const profileStartWeight = Number(currentProfile.value?.start_weight)
  return Number.isFinite(profileStartWeight) && profileStartWeight > 0 ? profileStartWeight : null
}

function getWorkoutCaloriesBurnedForDate(dateKey) {
  return (workoutLogsStore.logs || []).reduce((sum, log) => {
    const logDate = String(log?.date || '').slice(0, 10)
    if (logDate !== dateKey) {
      return sum
    }

    return sum + (Number(log?.calories_burned) || 0)
  }, 0)
}

function calculateCalorieGoalForDate(dateKey) {
  const totalDailyCalories = calculateTotalDailyCalories({
    weight: getWeightForDate(dateKey),
    height: currentProfile.value?.height,
    age: currentProfile.value?.age,
    sex: currentProfile.value?.sex,
    activityLevel: currentProfile.value?.activity_level,
  })

  return calculateTotalCaloriesForPerson({
    totalDailyCalories,
    dailyCalorieDeficit: currentProfile.value?.daily_calorie_deficit,
    totalWorkoutCaloriesBurnedbyFoodDay: getWorkoutCaloriesBurnedForDate(dateKey),
  })
}

const calorieGoalByDay = computed(() => {
  return foodCaloriesByDay.value.map((day) => calculateCalorieGoalForDate(day.date))
})

function calculateAveCalories(daysBack) {
  const days = foodCaloriesByDay.value
  if (!days || !days.length) {
    return '----'
  }

  const todayStr = getCurrentLocalDateString()

  const periodDays = days.filter((day) => {
    const dayDateStr = String(day.date).slice(0, 10)
    const daysFromToday = getDaysBetween(dayDateStr, todayStr)
    return daysFromToday >= 0 && daysFromToday <= daysBack
  })

  if (!periodDays.length) {
    return '----'
  }

  const totalCaloriesSum = periodDays.reduce((sum, day) => {
    const dailyTotal =
      (Number(day.proteinCalories) || 0) +
      (Number(day.carbCalories) || 0) +
      (Number(day.fatCalories) || 0)
    return sum + dailyTotal
  }, 0)

  const avg = totalCaloriesSum / periodDays.length
  return Math.round(avg)
}

function getPeriodEntriesWithGoal(daysBack) {
  const days = foodCaloriesByDay.value
  const goals = calorieGoalByDay.value
  if (!days || !days.length) {
    return []
  }

  const todayStr = getCurrentLocalDateString()

  return days
    .map((day, index) => ({ day, goal: Number(goals[index]) || 0 }))
    .filter(({ day }) => {
      const dayDateStr = String(day.date).slice(0, 10)
      const daysFromToday = getDaysBetween(dayDateStr, todayStr)
      return daysFromToday >= 0 && daysFromToday <= daysBack
    })
}

function calculateAveCalorieDeficit(daysBack) {
  const periodEntries = getPeriodEntriesWithGoal(daysBack)
  if (!periodEntries.length) {
    return '----'
  }

  const totalDeficitSum = periodEntries.reduce((sum, { day, goal }) => {
    const dailyTotal =
      (Number(day.proteinCalories) || 0) +
      (Number(day.carbCalories) || 0) +
      (Number(day.fatCalories) || 0)
    return sum + (dailyTotal - goal)
  }, 0)

  return Math.round(totalDeficitSum / periodEntries.length)
}

const aveCalories1Year = computed(() => calculateAveCalories(365))
const aveCalories30Days = computed(() => calculateAveCalories(30))
const aveCalories7Days = computed(() => calculateAveCalories(7))

const aveCalorieDeficit1Year = computed(() => calculateAveCalorieDeficit(365))
const aveCalorieDeficit30Days = computed(() => calculateAveCalorieDeficit(30))
const aveCalorieDeficit7Days = computed(() => calculateAveCalorieDeficit(7))

function destroyFoodChart() {
  foodChart?.destroy()
  foodChart = null
}

async function renderFoodChart() {
  await nextTick()
  destroyFoodChart()

  if (!foodCaloriesChart.value || !foodCaloriesByDay.value.length) {
    return
  }

  foodChart = new Chart(foodCaloriesChart.value, {
    type: 'bar',
    data: {
      labels: foodCaloriesByDay.value.map((day) => day.date),
      datasets: [
        {
          label: 'Protein Calories',
          data: foodCaloriesByDay.value.map((day) => day.proteinCalories),
          backgroundColor: 'rgba(76, 175, 80, 0.5)',
        },
        {
          label: 'Carb Calories',
          data: foodCaloriesByDay.value.map((day) => day.carbCalories),
          backgroundColor: 'rgba(255, 206, 86, 0.5)',
        },
        {
          label: 'Fat Calories',
          data: foodCaloriesByDay.value.map((day) => day.fatCalories),
          backgroundColor: 'rgba(54, 162, 235, 0.5)',
        },
        {
          label: 'Calorie Budget (includes workouts)',
          type: 'line',
          data: calorieGoalByDay.value,
          borderColor: '#f44336',
          borderWidth: 2,
          pointRadius: 0,
          fill: false,
          order: 1,
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      scales: {
        x: {
          stacked: true,
        },
        y: {
          stacked: true,
          beginAtZero: true,
          title: {
            display: true,
            text: 'Calories',
          },
        },
      },
    },
  })
}

function getLocalDateKey(datetime) {
  if (!datetime) return ''

  const date = new Date(datetime)

  if (Number.isNaN(date.getTime())) return ''

  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')

  return `${year}-${month}-${day}`
}

watch([foodCaloriesByDay, calorieGoalByDay], renderFoodChart)

onBeforeUnmount(destroyFoodChart)
</script>

<style scoped>
.food-calories-chart {
  height: 320px;
}

.resize-chip {
  /* normal size */
}

@media (max-width: 780px) {
  .resize-chip {
    /* styles for small screens */
    font-size: 10px;
    line-height: 1.2;
    padding: 0 8px;
    min-height: 22px;
  }
}
</style>
