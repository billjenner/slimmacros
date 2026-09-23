<template>
  <q-page>
    <div class="row justify-center">
      <div class="col-12 col-md-10 col-lg-8">
        <q-card flat bordered>
          <div class="text-h5 q-ma-md">Log</div>

          <q-tabs
            v-model="activeTab"
            align="left"
            dense
            class="text-primary"
            indicator-color="accent"
          >
            <q-tab name="food" label="Food" />
            <q-tab name="workouts" label="Workouts" />
            <q-tab name="supplements" label="Supplements" />
            <q-tab name="weight" label="Weight" />
          </q-tabs>

          <q-separator class="q-my-md" />

          <q-tab-panels v-model="activeTab" animated>
            <q-tab-panel name="food" class="q-pa-none">
              <food-log-panel />
            </q-tab-panel>
            <q-tab-panel name="workouts" class="q-pa-none">
              <workout-log-panel />
            </q-tab-panel>

            <q-tab-panel name="supplements" class="q-pa-none">
              <supplement-log-panel />
            </q-tab-panel>
            <q-tab-panel name="weight" class="q-pa-none">
              <weight-log-panel />
            </q-tab-panel>
          </q-tab-panels>
        </q-card>
      </div>
    </div>
  </q-page>
</template>

<script setup>
import { computed, onMounted, reactive, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useUsersStore } from 'stores/users'
import { useWorkoutsStore } from 'stores/workouts'
import { useWorkoutLogsStore } from 'stores/workout-logs'
import { usesupplementsStore } from 'stores/supplements'
import { usesupplementsLogStore } from 'stores/supplements_log'
import { useWeightLogsStore } from 'stores/weight-logs'
import FoodLogPanel from 'components/log/FoodLogPanel.vue'
import SupplementLogPanel from 'components/log/SupplementLogPanel.vue'
import WorkoutLogPanel from 'components/log/WorkoutLogPanel.vue'
import WeightLogPanel from 'components/log/WeightLogPanel.vue'

const usersStore = useUsersStore()

const workoutsStore = useWorkoutsStore()
const workoutLogsStore = useWorkoutLogsStore()
const supplementsStore = usesupplementsStore()
const supplementLogsStore = usesupplementsLogStore()
const weightLogsStore = useWeightLogsStore()

const route = useRoute()
const router = useRouter()
const validTabs = ['food', 'workouts', 'supplements', 'weight']
const activeTab = ref(getTabFromQuery(route.query.tab))

function getTabFromQuery(tab) {
  return validTabs.includes(tab) ? tab : 'food'
}

watch(activeTab, (tab) => {
  const nextQuery = { ...route.query }

  if (tab === 'food') {
    delete nextQuery.tab
  } else {
    nextQuery.tab = tab
  }

  if (route.query.tab !== nextQuery.tab) {
    router.replace({ query: nextQuery })
  }
})

watch(
  () => route.query.tab,
  (tab) => {
    const nextTab = getTabFromQuery(tab)
    if (activeTab.value !== nextTab) {
      activeTab.value = nextTab
    }
  },
)

function getCurrentLocalDate() {
  const now = new Date()
  const year = now.getFullYear()
  const month = String(now.getMonth() + 1).padStart(2, '0')
  const day = String(now.getDate()).padStart(2, '0')

  return `${year}-${month}-${day}`
}

const workoutLog = reactive({
  workout_id: null,
  workout_time: null,
  date: getCurrentLocalDate(),
})

const supplementLog = reactive({
  supplement_id: null,
  servings: 1,
  serving_unit: 'other',
  date: getCurrentLocalDate(),
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

const selectedSupplement = computed(() => {
  return (
    (supplementsStore.supplements || []).find((supplement) =>
      areSameId(supplement.supplement_id, supplementLog.supplement_id),
    ) || null
  )
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

    workoutsStore.workouts = []
    workoutLogsStore.logs = []
    supplementsStore.supplements = []
    supplementLogsStore.logs = []
    weightLogsStore.logs = []
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

watch(
  () => supplementLog.supplement_id,
  () => {
    supplementLog.servings = selectedSupplement.value?.serving_size ?? 1
    supplementLog.serving_unit = selectedSupplement.value?.serving_unit || 'other'
  },
)

watch(
  () => selectedSupplement.value,
  (supplement) => {
    if (supplement && (supplementLog.servings === null || supplementLog.servings === '')) {
      supplementLog.servings = supplement.serving_size ?? 1
    }

    if (supplement && !supplementLog.serving_unit) {
      supplementLog.serving_unit = supplement.serving_unit || 'other'
    }
  },
)

async function loadDataForUser(userId) {
  if (!userId) {
    return
  }

  await Promise.all([
    workoutsStore.loadWorkouts(userId),
    workoutLogsStore.loadWorkoutLogs(userId),
    supplementsStore.loadSupplements(userId),
    supplementLogsStore.loadSupplementLogs(userId),
    weightLogsStore.loadWeightLogs(userId),
  ])
}
</script>
