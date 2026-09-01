<template>
  <q-card flat bordered class="q-ma-md">
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
          <div class="row justify-between items-center q-mt-md">
            <q-chip color="secondary" text-color="white" square>
              1 year ave: {{ aveCalories1Year }}
            </q-chip>
            <q-chip color="secondary" text-color="white" square>
              30 days ave: {{ aveCalories30Days }}
            </q-chip>
            <q-chip color="secondary" text-color="white" square>
              7 days ave: {{ aveCalories7Days }}
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
import { useUsersStore } from 'stores/users'

const foodLogsStore = useFoodLogsStore()
const usersStore = useUsersStore()
const foodCaloriesChart = ref(null)
let foodChart = null

const foodCaloriesByDay = computed(() => {
  const caloriesByDay = (foodLogsStore.logs || []).reduce((totals, log) => {
    const date = getLocalDateKey(log?.datetime)
    const servings = Number(log?.servings)
    const food = log?.food || {}

    if (!date || !Number.isFinite(servings) || servings <= 0) {
      return totals
    }

    if (!totals[date]) {
      totals[date] = { proteinCalories: 0, carbCalories: 0, fatCalories: 0 }
    }

    totals[date].proteinCalories += (Number(food.protein) || 0) * servings * 4
    totals[date].carbCalories += (Number(food.carb) || 0) * servings * 4
    totals[date].fatCalories += (Number(food.fat) || 0) * servings * 9
    return totals
  }, {})

  return Object.entries(caloriesByDay)
    .map(([date, calories]) => ({ date, ...calories }))
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

const aveCalories1Year = computed(() => calculateAveCalories(365))
const aveCalories30Days = computed(() => calculateAveCalories(30))
const aveCalories7Days = computed(() => calculateAveCalories(7))

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
          backgroundColor: 'rgba(76, 175, 80, 0.7)',
        },
        {
          label: 'Carb Calories',
          data: foodCaloriesByDay.value.map((day) => day.carbCalories),
          backgroundColor: 'rgba(255, 206, 86, 0.7)',
        },
        {
          label: 'Fat Calories',
          data: foodCaloriesByDay.value.map((day) => day.fatCalories),
          backgroundColor: 'rgba(54, 162, 235, 0.7)',
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

watch(foodCaloriesByDay, renderFoodChart)

onBeforeUnmount(destroyFoodChart)
</script>

<style scoped>
.food-calories-chart {
  height: 320px;
}
</style>
