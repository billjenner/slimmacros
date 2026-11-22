<template>
  <q-page class="q-pa-md">
    <div class="row justify-center">
      <div class="col-12 col-md-10 col-lg-8">
        <q-card flat bordered>
          <div class="q-pa-md">
            <div class="text-h5">Getting Started</div>
            <div class="text-body2 text-grey-7 q-mt-sm">
              Follow these three steps to get started with Slim Macros.
            </div>
          </div>

          <q-banner v-if="!loading && !currentUserId" class="bg-info text-white q-mx-md q-mb-md" rounded>
            Sign in to save your progress and see which steps are complete.
            <template #action>
              <q-btn
                flat
                color="white"
                label="Sign in"
                :to="{ path: '/login', query: { redirect: '/getting-started' } }"
              />
            </template>
          </q-banner>

          <q-banner
            v-if="progressError"
            class="bg-negative text-white q-mx-md q-mb-md"
            rounded
          >
            We couldn't load all of your setup progress. {{ progressError }}
            <template #action>
              <q-btn flat color="white" label="Retry" :loading="loading" @click="loadProgress" />
            </template>
          </q-banner>

          <q-list separator aria-label="Getting started steps">
            <q-item clickable v-ripple to="/items?tab=profile">
              <q-item-section avatar>
                <q-spinner v-if="loading" color="primary" size="24px" />
                <q-icon
                  v-else
                  :name="statusIcon(profileComplete)"
                  :color="statusColor(profileComplete)"
                  size="sm"
                />
              </q-item-section>
              <q-item-section>
                <q-item-label class="text-weight-medium">1. Create a profile</q-item-label>
                <q-item-label caption>
                  Items &gt; Profile &gt; Enter user details &gt; Select a Diet Type &gt; load
                  template &gt; Save Profile
                </q-item-label>
              </q-item-section>
              <q-item-section side>
                <q-icon name="chevron_right" color="grey-6" />
              </q-item-section>
            </q-item>

            <q-item clickable v-ripple to="/items?tab=food">
              <q-item-section avatar>
                <q-spinner v-if="loading" color="primary" size="24px" />
                <q-icon
                  v-else
                  :name="statusIcon(foodComplete)"
                  :color="statusColor(foodComplete)"
                  size="sm"
                />
              </q-item-section>
              <q-item-section>
                <q-item-label class="text-weight-medium">2. Add a food item</q-item-label>
                <q-item-label caption>
                  Items &gt; Food &gt; Add Food &gt; Enter Details &gt; Save Food
                </q-item-label>
              </q-item-section>
              <q-item-section side>
                <q-icon name="chevron_right" color="grey-6" />
              </q-item-section>
            </q-item>

            <q-item clickable v-ripple to="/log?tab=food">
              <q-item-section avatar>
                <q-spinner v-if="loading" color="primary" size="24px" />
                <q-icon
                  v-else
                  :name="statusIcon(foodLogComplete)"
                  :color="statusColor(foodLogComplete)"
                  size="sm"
                />
              </q-item-section>
              <q-item-section>
                <q-item-label class="text-weight-medium">3. Log food consumption</q-item-label>
                <q-item-label caption>
                  Log &gt; Food &gt; Select a Food Item &gt; enter number of servings &gt; Add to Log
                </q-item-label>
              </q-item-section>
              <q-item-section side>
                <q-icon name="chevron_right" color="grey-6" />
              </q-item-section>
            </q-item>
          </q-list>

          <div v-if="foodLogComplete" class="q-pa-md">
            <q-banner
              v-if="workoutLogComplete === false"
              rounded
              class="bg-grey-2 q-mb-sm"
            >
              <template #avatar>
                <q-icon name="fitness_center" color="primary" />
              </template>
              You haven't logged a workout yet. You can log workouts in a similar way to food.
              <template #action>
                <q-btn flat color="primary" label="Log a workout" to="/log?tab=workouts" />
              </template>
            </q-banner>

            <q-banner
              v-if="supplementLogComplete === false"
              rounded
              class="bg-grey-2"
            >
              <template #avatar>
                <q-icon name="medication" color="primary" />
              </template>
              You haven't logged a supplement yet. You can log supplements in a similar way to food
              consumption.
              <template #action>
                <q-btn flat color="primary" label="Log a supplement" to="/log?tab=supplements" />
              </template>
            </q-banner>
          </div>
        </q-card>
      </div>
    </div>
  </q-page>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { useUsersStore } from 'stores/users'
import { useProfileStore } from 'stores/profile'
import { useFoodStore } from 'stores/food'
import { useFoodLogsStore } from 'stores/food-logs'
import { useWorkoutLogsStore } from 'stores/workout-logs'
import { usesupplementsLogStore } from 'stores/supplements_log'

const usersStore = useUsersStore()
const profileStore = useProfileStore()
const foodStore = useFoodStore()
const foodLogsStore = useFoodLogsStore()
const workoutLogsStore = useWorkoutLogsStore()
const supplementLogsStore = usesupplementsLogStore()

const currentUserId = ref(null)
const loading = ref(true)
const progressError = ref('')
const profileComplete = ref(null)
const foodComplete = ref(null)
const foodLogComplete = ref(null)
const workoutLogComplete = ref(null)
const supplementLogComplete = ref(null)

function statusIcon(isComplete) {
  if (isComplete === null) {
    return 'help_outline'
  }

  return isComplete ? 'check_circle' : 'radio_button_unchecked'
}

function statusColor(isComplete) {
  if (isComplete === null) {
    return 'grey-6'
  }

  return isComplete ? 'positive' : 'secondary'
}

async function loadProgress() {
  loading.value = true
  progressError.value = ''
  profileComplete.value = null
  foodComplete.value = null
  foodLogComplete.value = null
  workoutLogComplete.value = null
  supplementLogComplete.value = null

  try {
    const user = await usersStore.restoreSessionFromAuth()
    currentUserId.value = user?.user_id || null

    if (!currentUserId.value) {
      return
    }

    const userId = currentUserId.value
    const [profile, foods, foodLogs, workoutLogs, supplementLogs] = await Promise.all([
      profileStore.loadCurrentProfile(userId),
      foodStore.loadFood(userId),
      foodLogsStore.loadFoodLogs(userId),
      workoutLogsStore.loadWorkoutLogs(userId),
      supplementLogsStore.loadSupplementLogs(userId),
    ])

    if (!profileStore.error) {
      profileComplete.value = Boolean(profile?.diet_type)
    }

    if (!foodStore.error) {
      foodComplete.value = foods.some((food) => String(food?.user_id) === String(userId))
    }

    if (!foodLogsStore.error) {
      foodLogComplete.value = foodLogs.length > 0
    }

    if (!workoutLogsStore.error) {
      workoutLogComplete.value = workoutLogs.length > 0
    }

    if (!supplementLogsStore.error) {
      supplementLogComplete.value = supplementLogs.length > 0
    }

    progressError.value = [
      profileStore.error,
      foodStore.error,
      foodLogsStore.error,
      workoutLogsStore.error,
      supplementLogsStore.error,
    ]
      .filter(Boolean)
      .join(' ')
  } catch (error) {
    progressError.value = error?.message || 'Unable to load setup progress.'
  } finally {
    loading.value = false
  }
}

onMounted(loadProgress)
</script>
