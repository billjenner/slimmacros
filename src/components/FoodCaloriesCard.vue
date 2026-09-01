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
        <div v-else class="food-calories-chart">
          <canvas ref="foodCaloriesChart"></canvas>
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
