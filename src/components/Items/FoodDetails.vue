<template>
  <div>
    <div class="row q-col-gutter-md q-mt-md q-mb-xl">
      <div class="col-6 column items-center">
        <div class="text-caption text-grey-7 text-center q-mb-sm">Macro Profile</div>
        <div style="width: 100%; max-width: 360px; height: 300px">
          <Pie :data="macroChartData" :options="macroChartOptions" />
        </div>
      </div>

      <div class="col-6 column items-center">
        <div class="text-caption text-grey-7 text-center q-mb-sm">Calories vs Daily Budget</div>
        <div style="width: 100%; max-width: 360px; height: 300px">
          <Pie :data="calorieBudgetChartData" :options="macroChartOptions" />
        </div>
      </div>
    </div>
    <div class="row q-col-gutter-sm q-py-sm">
      <div class="col-3">
        <div class="text-caption text-grey-7">Protein</div>
        <div class="text-body2">{{ food.protein ?? 0 }}</div>
      </div>
      <div class="col-3">
        <div class="text-caption text-grey-7">Carbs</div>
        <div class="text-body2">{{ food.carb ?? 0 }}</div>
      </div>
      <div class="col-3">
        <div class="text-caption text-grey-7">Fat</div>
        <div class="text-body2">{{ food.fat ?? 0 }}</div>
      </div>
      <div class="col-3">
        <div class="text-caption text-grey-7">Extra calories</div>
        <div class="text-body2">{{ food.calories_extra ?? 0 }}</div>
      </div>
      <div class="col-3">
        <div class="text-caption text-grey-7">Serving size</div>
        <div class="text-body2">{{ food.serving_size ?? 1 }}</div>
      </div>
      <div class="col-3">
        <div class="text-caption text-grey-7">Serving unit</div>
        <div class="text-body2">{{ food.serving_unit || 'unit' }}</div>
      </div>
      <div class="col-3">
        <div class="text-caption text-grey-7">Share with others</div>
        <div class="text-body2">{{ food.share_with_others ? 'Yes' : 'No' }}</div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { Pie } from 'vue-chartjs'
import { Chart as ChartJS, ArcElement, Tooltip, Legend } from 'chart.js'
import { calculateFoodCalories, calculateTotalCaloriesForPerson } from '../../utils/rules'

ChartJS.register(ArcElement, Tooltip, Legend)

const props = defineProps({
  food: {
    type: Object,
    required: true,
  },
  servings: {
    type: Number,
    default: 1,
  },
})

const macroChartData = computed(() => ({
  labels: ['Protein', 'Carbs', 'Fat'],
  datasets: [
    {
      data: [
        (Number(props.food.protein) || 0) * 4,
        (Number(props.food.carb) || 0) * 4,
        (Number(props.food.fat) || 0) * 9,
      ],
      backgroundColor: ['#21BA45', '#F2C037', '#1976D2'],
      borderWidth: 2,
      borderColor: '#fff',
    },
  ],
}))

const calorieBudgetChartData = computed(() => {
  const calories =
    calculateFoodCalories({
      carbs: props.food.carb,
      protein: props.food.protein,
      fat: props.food.fat,
      extraCalories: props.food.calories_extra,
    }) || 0
  const budget =
    calculateTotalCaloriesForPerson({
      totalDailyCalories: 2000,
      dailyCalorieDeficit: 0,
    }) || 1
  const servings = Number(props.servings)
  const consumedCalories = Math.max(
    0,
    Math.round(calories * (Number.isFinite(servings) ? servings : 1)),
  )

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
})

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
</script>
