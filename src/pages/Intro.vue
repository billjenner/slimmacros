<template>
  <q-page class="column items-center q-px-md q-py-lg">
    <img
      src="/SlimMacros.png"
      alt="Slim Macros"
      style="
        border-radius: 12px;
        max-width: 100%;
        width: 25%;
        margin-top: 16px;
        margin-bottom: 16px;
      "
    />

    <h5
      style="
        max-width: 720px;
        width: 75%;
        margin: 12px auto 16px;
        text-align: justify;
        font-size: 1.05rem;
        line-height: 1.6;
      "
    >
      Your daily companion for smarter nutrition, healthier habits, and measurable progress.
    </h5>

    <h5
      style="
        max-width: 720px;
        width: 75%;
        margin: 12px auto 16px;
        text-align: justify;
        font-size: 0.8rem;
        line-height: 1.6;
      "
    >
      Track your food, macros, workouts, supplements, weight, and BMI—all in one place.
      Automatically calculate your daily calorie and macro budgets, monitor your intake against your
      goals, and track your progress throughout the day. With integrated exercise and
      nutrition‑supplement information, you can uncover patterns, gain insights into your habits,
      make informed decisions, and take meaningful steps toward a healthier, more balanced
      lifestyle.
    </h5>

    <div class="q-pa-md text-center" style="max-width: 720px; width: 100%">
      <q-btn
        color="secondary"
        label="Let's Go!"
        :loading="routing"
        style="margin-top: 8px"
        @click="letsGo"
      />
    </div>
  </q-page>
</template>

<script setup>
import { ref } from 'vue'
import { useQuasar } from 'quasar'
import { useRouter } from 'vue-router'
import { useUsersStore } from '../stores/users'
import { useFoodLogsStore } from '../stores/food-logs'

const $q = useQuasar()
const router = useRouter()
const usersStore = useUsersStore()
const foodLogsStore = useFoodLogsStore()
const routing = ref(false)

async function letsGo() {
  routing.value = true
  try {
    const user = await usersStore.restoreSessionFromAuth()
    const userId = user?.user_id || usersStore.currentUser?.user_id

    if (!userId) {
      await router.push('/log')
      return
    }

    let logs
    try {
      logs = await foodLogsStore.loadFoodLogs(userId)
    } catch (error) {
      console.error('Unable to check food logs:', error)
      $q.notify({ type: 'negative', message: 'Unable to check your food log status.' })
      return
    }

    if (foodLogsStore.error) {
      $q.notify({ type: 'negative', message: foodLogsStore.error })
      return
    }

    await router.push(logs.length ? '/log' : '/getting-started')
  } finally {
    routing.value = false
  }
}
</script>
