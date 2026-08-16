<template>
  <q-page>
    <q-card flat bordered class="q-ma-md">
      <q-card-section>
        <div class="text-h6">Weight and BMI progress</div>
      </q-card-section>
      <q-card-section>
        <q-banner v-if="weightLogsStore.error" class="bg-negative text-white" rounded>
          {{ weightLogsStore.error }}
        </q-banner>
        <q-banner v-else-if="!usersStore.currentUser" class="bg-warning text-dark" rounded>
          Sign in to view your weight and BMI progress.
        </q-banner>
        <q-banner v-else-if="!weightLogsStore.loading && !chartLogs.length" class="bg-grey-2">
          Add weight entries to see your progress chart.
        </q-banner>
        <div v-else class="weight-log-chart">
          <canvas ref="weightLogChart"></canvas>
        </div>
      </q-card-section>
    </q-card>

    <q-card flat bordered class="q-ma-md">
      <q-card-section>
        <div class="text-h6">Workout calories burned</div>
      </q-card-section>
      <q-card-section>
        <q-banner v-if="workoutLogsStore.error" class="bg-negative text-white" rounded>
          {{ workoutLogsStore.error }}
        </q-banner>
        <q-banner v-else-if="!usersStore.currentUser" class="bg-warning text-dark" rounded>
          Sign in to view your workout calories.
        </q-banner>
        <q-banner
          v-else-if="!workoutLogsStore.loading && !workoutCaloriesByDay.length"
          class="bg-grey-2"
        >
          Add workout entries to see your daily calories burned.
        </q-banner>
        <div v-else class="workout-calories-chart">
          <canvas ref="workoutCaloriesChart"></canvas>
        </div>
      </q-card-section>
    </q-card>

    <div class="text-h4 q-mb-lg text-center">Resources</div>

    <div
      class="row q-col-gutter-md"
      style="background-color: #fdecec; padding-bottom: 16px; padding-right: 16px"
    >
      <div class="col-12 col-sm-6 col-md-6 col-lg-6 flex justify-center">
        <q-card style="width: 95%">
          <q-card-section class="bg-accent text-center">
            Start your journey to a healthier lifestyle here.
          </q-card-section>
          <q-expansion-item
            expand-icon="keyboard_arrow_down"
            expanded-icon="keyboard_arrow_up"
            transition-show="jump-down"
            transition-hide="jump-up"
          >
            <template v-slot:header>
              <q-chip>Slim-Belly Quick Start</q-chip>
            </template>

            <q-card-section>
              <p class="text-center text-weight-bold q-mb-sm" style="font-size: 1.05rem">
                Steps to Perfection
              </p>
              <br />
              <table style="width: 100%; border-collapse: collapse">
                <thead>
                  <tr>
                    <th style="text-align: left; padding: 10px; border-bottom: 2px solid #ddd">
                      Step
                    </th>
                    <th style="text-align: left; padding: 10px; border-bottom: 2px solid #ddd">
                      Description
                    </th>
                  </tr>
                </thead>

                <tbody>
                  <tr>
                    <td style="padding: 10px; border-bottom: 1px solid #eee">1</td>
                    <td style="padding: 10px; border-bottom: 1px solid #eee">Create a Profile</td>
                  </tr>

                  <tr>
                    <td style="padding: 10px; border-bottom: 1px solid #eee">2</td>
                    <td style="padding: 10px; border-bottom: 1px solid #eee">Add Foods you like</td>
                  </tr>

                  <tr>
                    <td style="padding: 10px; border-bottom: 1px solid #eee">3</td>
                    <td style="padding: 10px; border-bottom: 1px solid #eee">
                      Add Workouts you like
                    </td>
                  </tr>

                  <tr>
                    <td style="padding: 10px; border-bottom: 1px solid #eee">4</td>
                    <td style="padding: 10px; border-bottom: 1px solid #eee">
                      Add Supplements you take
                    </td>
                  </tr>

                  <tr>
                    <td style="padding: 10px; border-bottom: 1px solid #eee">5</td>
                    <td style="padding: 10px; border-bottom: 1px solid #eee">
                      Log your daily food consumption
                    </td>
                  </tr>

                  <tr>
                    <td style="padding: 10px; border-bottom: 1px solid #eee">6</td>
                    <td style="padding: 10px; border-bottom: 1px solid #eee">
                      Log your daily workouts
                    </td>
                  </tr>

                  <tr>
                    <td style="padding: 10px; border-bottom: 1px solid #eee">7</td>
                    <td style="padding: 10px; border-bottom: 1px solid #eee">
                      Log your daily supplements
                    </td>
                  </tr>

                  <tr>
                    <td style="padding: 10px; border-bottom: 1px solid #eee">8</td>
                    <td style="padding: 10px; border-bottom: 1px solid #eee">
                      Log your weight periodically
                    </td>
                  </tr>

                  <tr>
                    <td style="padding: 10px"></td>
                    <td style="padding: 10px"><strong>→ Track your progress</strong></td>
                  </tr>
                </tbody>
              </table>
            </q-card-section>
          </q-expansion-item>

          <q-expansion-item
            expand-icon="keyboard_arrow_down"
            expanded-icon="keyboard_arrow_up"
            transition-show="jump-down"
            transition-hide="jump-up"
          >
            <template v-slot:header>
              <q-chip>Over All Plan</q-chip>
            </template>

            <q-card-section>
              <table style="width: 100%; border-collapse: collapse">
                <thead>
                  <tr>
                    <th style="text-align: left; padding: 10px; border-bottom: 2px solid #ddd">
                      Strategy
                    </th>
                    <th style="text-align: left; padding: 10px; border-bottom: 2px solid #ddd">
                      Purpose
                    </th>
                  </tr>
                </thead>

                <tbody>
                  <tr>
                    <td style="padding: 10px; border-bottom: 1px solid #eee">
                      <strong>Calorie deficit</strong>
                    </td>
                    <td style="padding: 10px; border-bottom: 1px solid #eee; color: #666">
                      Drives fat loss
                    </td>
                  </tr>

                  <tr>
                    <td style="padding: 10px; border-bottom: 1px solid #eee">
                      <strong>Adequate protein</strong>
                    </td>
                    <td style="padding: 10px; border-bottom: 1px solid #eee; color: #666">
                      Protects muscle
                    </td>
                  </tr>

                  <tr>
                    <td style="padding: 10px; border-bottom: 1px solid #eee">
                      <strong>Resistance training</strong>
                    </td>
                    <td style="padding: 10px; border-bottom: 1px solid #eee; color: #666">
                      Preserves/builds muscle
                    </td>
                  </tr>

                  <tr>
                    <td style="padding: 10px; border-bottom: 1px solid #eee">
                      <strong>Stretching</strong>
                    </td>
                    <td style="padding: 10px; border-bottom: 1px solid #eee; color: #666">
                      Improves movement quality, becomes increasingly useful as you age.
                    </td>
                  </tr>

                  <tr>
                    <td style="padding: 10px; border-bottom: 1px solid #eee">
                      <strong>Fiber-rich foods</strong>
                    </td>
                    <td style="padding: 10px; border-bottom: 1px solid #eee; color: #666">
                      Improves fullness
                    </td>
                  </tr>

                  <tr>
                    <td style="padding: 10px; border-bottom: 1px solid #eee">
                      <strong>Sleep + hydration</strong>
                    </td>
                    <td style="padding: 10px; border-bottom: 1px solid #eee; color: #666">
                      Supports adherence and performance
                    </td>
                  </tr>

                  <tr>
                    <td style="padding: 10px">
                      <strong>Supplements</strong>
                    </td>
                    <td style="padding: 10px; color: #666">Fill specific nutritional gaps</td>
                  </tr>
                  <tr>
                    <td style="padding: 10px">
                      <strong>Log daily</strong>
                    </td>
                    <td style="padding: 10px; color: #666">
                      Track nutrition, exercise, and habits. Monitor progress regularly and make
                      adjustments as needed.
                    </td>
                  </tr>
                </tbody>
              </table>
            </q-card-section>
          </q-expansion-item>
        </q-card>
      </div>

      <div class="col-12 col-sm-6 col-md-6 col-lg-6 flex justify-center">
        <q-card style="width: 95%">
          <q-card-section class="bg-accent text-center"> Suppliments </q-card-section>

          <q-expansion-item
            expand-icon="keyboard_arrow_down"
            expanded-icon="keyboard_arrow_up"
            transition-show="jump-down"
            transition-hide="jump-up"
          >
            <template v-slot:header>
              <q-chip>Suppliment Recomendations</q-chip>
            </template>

            <q-card-section>
              <table style="width: 100%; border-collapse: collapse">
                <thead>
                  <tr>
                    <th style="text-align: left; padding: 12px; border-bottom: 2px solid #ccc">
                      Supplement
                    </th>
                    <th style="text-align: left; padding: 12px; border-bottom: 2px solid #ccc">
                      Recommendation
                    </th>
                    <th style="text-align: left; padding: 12px; border-bottom: 2px solid #ccc">
                      Purpose / Benefits
                    </th>
                  </tr>
                </thead>

                <tbody>
                  <tr>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">
                      <strong>Water</strong>
                    </td>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">64 oz minimum/day</td>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">
                      Breaking down stored fat requires several biochemical reactions that occur in
                      a hydrated environment.
                    </td>
                  </tr>

                  <tr>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">
                      <strong>Protein Powder</strong>
                    </td>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">20–40 g/serving</td>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">
                      Makes it easier to reach your protein target while dieting.
                    </td>
                  </tr>

                  <tr>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">
                      <strong>Creatine Monohydrate</strong>
                    </td>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">5 g/day</td>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">
                      Helps maintain strength and muscle during a calorie deficit.
                    </td>
                  </tr>

                  <tr>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">
                      <strong>Omega-3 (Fish Oil)</strong>
                    </td>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">2 g/day EPA + DHA</td>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">
                      Provides EPA and DHA; useful when you're not eating fish.
                    </td>
                  </tr>

                  <tr>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">
                      <strong>Krill Oil</strong><br />
                      <span style="color: #666">(Ocean crustaceans)</span>
                    </td>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">500 mg/day</td>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">
                      EPA + DHA, antioxidant properties, and phospholipids that help form cell
                      membranes and transport fats.
                    </td>
                  </tr>

                  <tr>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">
                      <strong>Multivitamin</strong><br />
                      <span style="color: #666">(AG1 recommended)</span>
                    </td>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">1 daily serving</td>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">
                      AG1 combines a large number of ingredients into one daily serving.
                      <ul style="margin: 8px 0 0 20px; padding: 0">
                        <li>Vitamins &amp; minerals — nutritional support</li>
                        <li>Prebiotics &amp; probiotics — digestive/gut support</li>
                        <li>Plant extracts and greens — various phytonutrients</li>
                        <li>Antioxidant compounds</li>
                        <li>Adaptogen-type ingredients</li>
                        <li>Digestive enzymes</li>
                      </ul>
                    </td>
                  </tr>

                  <tr>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">
                      <strong>D3 + K2</strong><br />
                      <span style="color: #666">D3 (cholecalciferol)</span>
                    </td>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">500 UI, 100 MCG</td>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">
                      <ul style="margin: 8px 0 0 20px; padding: 0">
                        <li>D3 &amp; increases calcium absorption</li>
                        <li>K2 &amp; helps activate calcium-regulating proteins</li>
                      </ul>
                    </td>
                  </tr>

                  <tr>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">
                      <strong>Magnesium</strong><br />
                      <span style="color: #666">(Magnesium glycinate)</span>
                    </td>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">200-400 mg/day</td>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">
                      <ul style="margin: 8px 0 0 20px; padding: 0">
                        <li>Supports muscle and nerve function</li>
                        <li>Helps produce energy and helps with recovery</li>
                        <li>Supports muscle contraction and relaxation</li>
                        <li>Helps maintain electrolyte balance</li>
                      </ul>
                    </td>
                  </tr>

                  <tr>
                    <td style="padding: 12px">
                      <strong>Electrolytes</strong>
                    </td>
                    <td style="padding: 12px">As needed</td>
                    <td style="padding: 12px">
                      Maintain fluid balance, nerve function, muscle function, and blood pressure.
                      <br /><br />

                      <strong>
                        Avoid electrolytes with Sucralose, Aspartame, and even Stevia.
                      </strong>
                      These not only fool your tongue but also your body and increase cortisol and
                      make you hungrier.
                      <br /><br />

                      <strong>Some options:</strong>
                      Redmond Re-Lyte Unflavored, Hydrant Unflavored, SALTT Clean Slate
                    </td>
                  </tr>
                </tbody>
              </table>
            </q-card-section>
          </q-expansion-item>
          <q-expansion-item
            expand-icon="keyboard_arrow_down"
            expanded-icon="keyboard_arrow_up"
            transition-show="jump-down"
            transition-hide="jump-up"
          >
            <template v-slot:header>
              <q-chip>Fat Burning Morning Drink</q-chip>
            </template>

            <q-card-section>
              <ul>
                <li>Bragg's Apple Cider Vinegar (ACV) — 2 Tbsp</li>
                <li>Cayenne pepper</li>
                <li>Turmeric — ¼ tsp</li>
                <li>Lemon juice — ¼ tsp</li>
                <li>Ginger — ¼ tsp</li>
                <li>Water — 2 cups</li>
                <li>
                  Optional:
                  <ul>
                    <li>Cinnamon</li>
                    <li>A small amount of honey</li>
                  </ul>
                </li>
              </ul>
            </q-card-section>
          </q-expansion-item>
          <q-expansion-item
            expand-icon="keyboard_arrow_down"
            expanded-icon="keyboard_arrow_up"
            transition-show="jump-down"
            transition-hide="jump-up"
          >
            <template v-slot:header>
              <q-chip>Coconut Oil</q-chip>
            </template>

            <q-card-section>
              <ul>
                <li>Useful when fasting Useful on a empty stomic.</li>
                <li>Useful taken in the morning on an empty stomach before coffee or water</li>
              </ul>
              <p style="padding-left: 1.5rem">
                Up to 1 tablespoon coconut oil Why: MCTs are rapidly delivered to and metabolized by
                the liver, where they can be converted to energy and ketones. In moderation, they
                will not trigger Cortisol.
              </p>
              <p style="padding-left: 1.5rem">
                One tablespoon has approximately 120 calories, so use cautiously with in your
                calorie budget.
              </p>
            </q-card-section>
          </q-expansion-item>
        </q-card>
      </div>

      <div class="col-12 col-sm-6 col-md-6 col-lg-6 flex justify-center">
        <q-card style="width: 95%">
          <q-card-section class="bg-accent text-center"> HIIT Training Exercises </q-card-section>

          <q-expansion-item
            expand-icon="keyboard_arrow_down"
            expanded-icon="keyboard_arrow_up"
            transition-show="jump-down"
            transition-hide="jump-up"
          >
            <template v-slot:header>
              <q-chip>Beginner</q-chip>
            </template>

            <q-card-section>
              <div style="padding: 12px; border-bottom: 1px solid #eee">
                <strong>Beginner routine using 40 seconds work / 20 seconds rest:</strong><br />
              </div>
              <div style="padding: 12px; border-bottom: 1px solid #eee">
                <ul style="margin: 8px 0 0 20px; padding: 0">
                  <li>Bodyweight squats</li>
                  <li>Knee push-ups</li>
                  <li>Standing knee raises</li>
                  <li>Glute bridges</li>
                  <li>Mountain climbers</li>
                  <li>Plank</li>
                </ul>
              </div>
              <div style="padding: 12px; border-bottom: 1px solid #eee">
                <strong>Phase & Time:</strong><br />
                <ul style="margin: 8px 0 0 20px; padding: 0">
                  <li>Warm-up — 5 minutes</li>
                  <li>HIIT Round 1 — 5 minutes</li>
                  <li>Rest between rounds — 1–2 minutes</li>
                  <li>HIIT Round 2 — 5 minutes</li>
                  <li>Cool-down — 3–5 minutes</li>
                  <li><strong>Total — 19–22 minutes</strong></li>
                </ul>
              </div>
            </q-card-section>
          </q-expansion-item>
        </q-card>
      </div>

      <div class="col-12 col-md-4">
        <q-card flat bordered style="width: 90%; max-width: 90%; margin: 0 auto">
          <q-expansion-item
            expand-icon="keyboard_arrow_down"
            expanded-icon="keyboard_arrow_up"
            transition-show="jump-down"
            transition-hide="jump-up"
          >
            <template v-slot:header>
              <q-chip>Related Resources</q-chip>
            </template>
            <q-card-section>
              <div class="text-weight-bold">More to come here</div>
              <a href="https://google.com" target="_blank" rel="noopener noreferrer"> Google </a>
            </q-card-section>
          </q-expansion-item>
        </q-card>
      </div>
    </div>
  </q-page>
</template>

<script setup>
import { Chart } from 'chart.js/auto'
import { computed, nextTick, onBeforeUnmount, ref, watch } from 'vue'
import { useUsersStore } from 'stores/users'
import { useProfilesStore } from 'stores/profiles'
import { useWorkoutLogsStore } from 'stores/workout-logs'
import { useWeightLogsStore } from 'stores/weight-logs'

const usersStore = useUsersStore()
const profilesStore = useProfilesStore()
const workoutLogsStore = useWorkoutLogsStore()
const weightLogsStore = useWeightLogsStore()
const weightLogChart = ref(null)
const workoutCaloriesChart = ref(null)
let chart = null
let workoutChart = null

const chartLogs = computed(() => {
  return [...(weightLogsStore.logs || [])]
    .filter((log) => log?.date && Number.isFinite(Number(log?.weight)))
    .sort((leftLog, rightLog) => String(leftLog.date).localeCompare(String(rightLog.date)))
})

const workoutCaloriesByDay = computed(() => {
  const caloriesByDay = (workoutLogsStore.logs || []).reduce((totals, log) => {
    const date = String(log?.date || '').slice(0, 10)
    const caloriesBurned = Number(log?.calories_burned)

    if (!date || !Number.isFinite(caloriesBurned)) {
      return totals
    }

    totals[date] = (totals[date] || 0) + caloriesBurned
    return totals
  }, {})

  return Object.entries(caloriesByDay)
    .map(([date, caloriesBurned]) => ({ date, caloriesBurned }))
    .sort((leftDay, rightDay) => leftDay.date.localeCompare(rightDay.date))
})

const weightAxisBounds = computed(() => {
  const min = Number(profilesStore.currentProfile?.goal_weight)
  const startWeight = Number(profilesStore.currentProfile?.start_weight)
  const max = startWeight + 5

  if (!Number.isFinite(min) || !Number.isFinite(max) || min >= max) {
    return {}
  }

  return { min, max }
})

function destroyChart() {
  chart?.destroy()
  chart = null
}

function destroyWorkoutChart() {
  workoutChart?.destroy()
  workoutChart = null
}

async function renderChart() {
  await nextTick()
  destroyChart()

  if (!weightLogChart.value || !chartLogs.value.length) {
    return
  }

  chart = new Chart(weightLogChart.value, {
    type: 'line',
    data: {
      labels: chartLogs.value.map((log) => log.date),
      datasets: [
        {
          label: 'Weight',
          data: chartLogs.value.map((log) => Number(log.weight)),
          borderColor: 'rgba(255, 99, 132, 1)',
          backgroundColor: 'rgba(255, 99, 132, 0.2)',
          fill: false,
          tension: 0.3,
          yAxisID: 'yWeight',
        },
        {
          label: 'BMI',
          data: chartLogs.value.map((log) => {
            const bmi = Number(log.bmi)
            return Number.isFinite(bmi) ? bmi : null
          }),
          borderColor: 'rgba(54, 162, 235, 1)',
          backgroundColor: 'rgba(54, 162, 235, 0.2)',
          fill: false,
          tension: 0.3,
          spanGaps: true,
          yAxisID: 'yBMI',
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,

      scales: {
        yWeight: {
          type: 'linear',
          position: 'left',
          ...weightAxisBounds.value,
          title: {
            display: true,
            text: 'Weight (lbs)',
          },
        },

        yBMI: {
          type: 'linear',
          position: 'right',
          title: {
            display: true,
            text: 'BMI',
          },

          // Prevent the BMI grid lines from being drawn over
          // the Weight grid lines.
          grid: {
            drawOnChartArea: false,
          },
        },
      },
    },
  })
}

async function renderWorkoutChart() {
  await nextTick()
  destroyWorkoutChart()

  if (!workoutCaloriesChart.value || !workoutCaloriesByDay.value.length) {
    return
  }

  workoutChart = new Chart(workoutCaloriesChart.value, {
    type: 'bar',
    data: {
      labels: workoutCaloriesByDay.value.map((day) => day.date),
      datasets: [
        {
          label: 'Calories burned',
          data: workoutCaloriesByDay.value.map((day) => day.caloriesBurned),
          backgroundColor: 'rgba(255, 159, 64, 0.55)',
          borderColor: 'rgba(255, 159, 64, 1)',
          borderWidth: 1,
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      scales: {
        y: {
          beginAtZero: true,
          title: {
            display: true,
            text: 'Calories burned',
          },
        },
      },
    },
  })
}

watch(
  () => usersStore.currentUser?.user_id,
  async (userId) => {
    destroyChart()
    destroyWorkoutChart()

    if (!userId) {
      weightLogsStore.logs = []
      workoutLogsStore.logs = []
      profilesStore.currentProfile = null
      return
    }

    await Promise.all([
      weightLogsStore.loadWeightLogs(userId),
      workoutLogsStore.loadWorkoutLogs(userId),
      profilesStore.loadCurrentProfile(userId),
    ])
    await renderChart()
    await renderWorkoutChart()
  },
  { immediate: true },
)

watch(chartLogs, renderChart)
watch(weightAxisBounds, renderChart)
watch(workoutCaloriesByDay, renderWorkoutChart)

onBeforeUnmount(() => {
  destroyChart()
  destroyWorkoutChart()
})
</script>

<style scoped>
.weight-log-chart,
.workout-calories-chart {
  height: 320px;
}
</style>
