<template>
  <q-card flat bordered class="q-ma-md">
    <q-expansion-item
      label="Daily Supplements"
      expand-icon="keyboard_arrow_down"
      expanded-icon="keyboard_arrow_up"
      transition-show="jump-down"
      transition-hide="jump-up"
      @after-show="renderSupplementChart"
    >
      <q-card-section>
        <q-banner v-if="supplementLogsStore.error" class="bg-negative text-white" rounded>
          {{ supplementLogsStore.error }}
        </q-banner>
        <q-banner v-else-if="!usersStore.currentUser" class="bg-warning text-dark" rounded>
          Sign in to view your daily supplements.
        </q-banner>
        <q-banner
          v-else-if="!supplementLogsStore.loading && !supplementCountsByDay.length"
          class="bg-grey-2"
        >
          Add supplement entries to see your daily supplement count.
        </q-banner>
        <div v-else class="supplement-count-chart">
          <canvas ref="supplementCountChart"></canvas>
        </div>
      </q-card-section>
    </q-expansion-item>
  </q-card>
</template>

<script setup>
import { Chart } from 'chart.js/auto'
import { computed, nextTick, onBeforeUnmount, ref, watch } from 'vue'
import { useProfilesStore } from 'stores/profiles'
import { usesupplementsLogStore } from 'stores/supplements_log'
import { useUsersStore } from 'stores/users'

const profilesStore = useProfilesStore()
const supplementLogsStore = usesupplementsLogStore()
const usersStore = useUsersStore()
const supplementCountChart = ref(null)
let supplementChart = null

const supplementCountsByDay = computed(() => {
  const countsByDay = (supplementLogsStore.logs || []).reduce((counts, log) => {
    const date = String(log?.date || '').slice(0, 10)

    if (!date || !log?.supplement_log_id) {
      return counts
    }

    counts[date] = (counts[date] || 0) + 1
    return counts
  }, {})

  return Object.entries(countsByDay)
    .map(([date, supplementCount]) => ({ date, supplementCount }))
    .sort((leftDay, rightDay) => leftDay.date.localeCompare(rightDay.date))
})

function destroySupplementChart() {
  supplementChart?.destroy()
  supplementChart = null
}

async function renderSupplementChart() {
  await nextTick()
  destroySupplementChart()

  if (!supplementCountChart.value || !supplementCountsByDay.value.length) {
    return
  }

  const supplementByDate = Object.fromEntries(
    supplementCountsByDay.value.map((day) => [day.date, day.supplementCount]),
  )
  const firstDate = new Date(profilesStore.currentProfile?.created_at)

  if (Number.isNaN(firstDate.getTime())) {
    console.error('Invalid profile creation date:', profilesStore.currentProfile?.created_at)
    return
  }

  firstDate.setHours(0, 0, 0, 0)

  const today = new Date()
  today.setHours(0, 0, 0, 0)

  const labels = []
  const data = []
  const currentDate = new Date(firstDate)

  while (currentDate <= today) {
    const year = currentDate.getFullYear()
    const month = String(currentDate.getMonth() + 1).padStart(2, '0')
    const day = String(currentDate.getDate()).padStart(2, '0')
    const dateKey = `${year}-${month}-${day}`

    labels.push(dateKey)
    data.push(supplementByDate[dateKey] || 0)
    currentDate.setDate(currentDate.getDate() + 1)
  }

  supplementChart = new Chart(supplementCountChart.value, {
    type: 'bar',
    data: {
      labels,
      datasets: [
        {
          label: 'Supplement Count',
          data,
          backgroundColor: 'rgba(153, 102, 255, 0.7)',
          borderColor: 'rgba(153, 102, 255, 1)',
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
          ticks: {
            precision: 0,
          },
          title: {
            display: true,
            text: 'Supplement Count',
          },
        },
      },
    },
  })
}

watch(supplementCountsByDay, renderSupplementChart)

onBeforeUnmount(destroySupplementChart)
</script>

<style scoped>
.supplement-count-chart {
  height: 320px;
}
</style>
