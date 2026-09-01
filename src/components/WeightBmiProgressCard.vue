<template>
  <q-card flat bordered class="q-ma-md">
    <q-expansion-item
      label="Weight and BMI progress"
      expand-icon="keyboard_arrow_down"
      expanded-icon="keyboard_arrow_up"
      transition-show="jump-down"
      transition-hide="jump-up"
      @after-show="renderWeightChart"
    >
      <q-card-section>
        <q-banner v-if="weightLogsStore.error" class="bg-negative text-white" rounded>
          {{ weightLogsStore.error }}
        </q-banner>
        <q-banner v-else-if="!usersStore.currentUser" class="bg-warning text-dark" rounded>
          Sign in to view your weight and BMI progress.
        </q-banner>
        <q-banner v-else-if="!weightLogsStore.loading && !weightChartLogs.length" class="bg-grey-2">
          Add weight entries to see your progress chart.
        </q-banner>
        <div v-else class="weight-log-chart">
          <canvas ref="weightLogChart"></canvas>
        </div>
      </q-card-section>
    </q-expansion-item>
  </q-card>
</template>

<script setup>
import { Chart } from 'chart.js/auto'
import { computed, nextTick, onBeforeUnmount, ref, watch } from 'vue'
import { useProfilesStore } from 'stores/profiles'
import { useUsersStore } from 'stores/users'
import { useWeightLogsStore } from 'stores/weight-logs'

const profilesStore = useProfilesStore()
const usersStore = useUsersStore()
const weightLogsStore = useWeightLogsStore()
const weightLogChart = ref(null)
let weightChart = null

const weightChartLogs = computed(() => {
  return [...(weightLogsStore.logs || [])]
    .filter((log) => log?.date && Number.isFinite(Number(log?.weight)))
    .sort((leftLog, rightLog) => String(leftLog.date).localeCompare(String(rightLog.date)))
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

function destroyWeightChart() {
  weightChart?.destroy()
  weightChart = null
}

async function renderWeightChart() {
  await nextTick()
  destroyWeightChart()

  if (!weightLogChart.value || !weightChartLogs.value.length) {
    return
  }

  weightChart = new Chart(weightLogChart.value, {
    type: 'line',
    data: {
      labels: weightChartLogs.value.map((log) => log.date),
      datasets: [
        {
          label: 'Weight',
          data: weightChartLogs.value.map((log) => Number(log.weight)),
          borderColor: 'rgba(255, 99, 132, 1)',
          backgroundColor: 'rgba(255, 99, 132, 0.2)',
          fill: false,
          tension: 0.3,
          yAxisID: 'yWeight',
        },
        {
          label: 'BMI',
          data: weightChartLogs.value.map((log) => {
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
          grid: {
            drawOnChartArea: false,
          },
        },
      },
    },
  })
}

watch(weightChartLogs, renderWeightChart)
watch(weightAxisBounds, renderWeightChart)

onBeforeUnmount(destroyWeightChart)
</script>

<style scoped>
.weight-log-chart {
  height: 320px;
}
</style>
