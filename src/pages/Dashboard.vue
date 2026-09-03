<template>
  <q-page class="q-pt-md">
    <div class="text-h4 text-center">Dashboard</div>
    <weight-bmi-progress-card />
    <food-calories-card />
    <workout-calories-card />
    <supplement-count-card />
  </q-page>
</template>

<script setup>
import { watch } from 'vue'
import { useUsersStore } from 'stores/users'
import { useFoodLogsStore } from 'stores/food-logs'
import { useProfilesStore } from 'stores/profiles'
import { usesupplementsLogStore } from 'stores/supplements_log'
import { useWorkoutLogsStore } from 'stores/workout-logs'
import { useWeightLogsStore } from 'stores/weight-logs'
import FoodCaloriesCard from 'components/FoodCaloriesCard.vue'
import SupplementCountCard from 'components/SupplementCountCard.vue'
import WeightBmiProgressCard from 'components/WeightBmiProgressCard.vue'
import WorkoutCaloriesCard from 'components/WorkoutCaloriesCard.vue'

const usersStore = useUsersStore()
const foodLogsStore = useFoodLogsStore()
const profilesStore = useProfilesStore()
const supplementLogsStore = usesupplementsLogStore()
const workoutLogsStore = useWorkoutLogsStore()
const weightLogsStore = useWeightLogsStore()

watch(
  () => usersStore.currentUser?.user_id,
  async (userId) => {
    if (!userId) {
      weightLogsStore.logs = []
      foodLogsStore.logs = []
      workoutLogsStore.logs = []
      supplementLogsStore.logs = []
      profilesStore.currentProfile = null
      return
    }

    await Promise.all([
      weightLogsStore.loadWeightLogs(userId),
      foodLogsStore.loadFoodLogs(userId),
      workoutLogsStore.loadWorkoutLogs(userId),
      supplementLogsStore.loadSupplementLogs(userId),
      profilesStore.loadCurrentProfile(userId),
    ])
  },
  { immediate: true },
)
</script>
