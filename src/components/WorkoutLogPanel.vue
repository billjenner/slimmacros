<template>
  <div>
    <q-banner v-if="workoutLogsStore.error" class="bg-negative text-white q-mb-md" rounded>{{
      workoutLogsStore.error
    }}</q-banner>
    <q-banner v-else-if="!usersStore.currentUser" class="bg-warning text-dark q-mb-md" rounded
      >Sign in to record workouts.</q-banner
    >
    <q-form @submit.prevent="submitWorkoutLog" class="q-gutter-md">
      <q-card flat bordered class="q-pa-md bg-grey-1">
        <div class="text-subtitle1 q-mb-sm">Log Workout</div>
        <div class="row q-col-gutter-md">
          <div class="col-12 col-md-6">
            <q-select
              v-model="workoutLog.workout_id"
              :options="workoutOptions"
              label="Workout"
              filled
              dense
              emit-value
              map-options
              :disable="!usersStore.currentUser"
              :rules="[(value) => !!value || 'Workout is required']"
            />
          </div>
          <div class="col-12 col-md-3">
            <q-input
              v-model="workoutLog.workout_time"
              type="number"
              label="Workout time (min)"
              min="0"
              step="1"
              filled
              dense
              :disable="!usersStore.currentUser"
              :rules="[
                (value) => value === '' || Number(value) >= 0 || 'Time must be 0 or greater',
              ]"
            />
          </div>
          <div class="col-12 col-md-3">
            <q-input
              v-model="workoutLog.date"
              type="date"
              label="Date"
              filled
              dense
              :disable="!usersStore.currentUser"
            />
          </div>
          <div class="col-12 col-md-6">
            <q-input
              :model-value="workoutTotalCaloriesBurned"
              label="Calories burned"
              filled
              dense
              readonly
            />
          </div>
        </div>
        <div class="row items-center justify-between q-mt-md">
          <q-toggle
            v-model="includeSharedWorkouts"
            label="Include shared workouts"
            :disable="!usersStore.currentUser"
          />
          <q-btn
            type="submit"
            color="primary"
            label="Add to log"
            :loading="workoutLogsStore.loading"
            :disable="!usersStore.currentUser"
          />
        </div>
      </q-card>
    </q-form>
    <q-card flat bordered class="q-pa-none bg-grey-1 q-mt-md">
      <div class="row items-center justify-between q-px-md q-py-sm">
        <div class="text-subtitle1">Logged workouts</div>
        <div class="row items-center no-wrap q-gutter-xs" style="justify-content: center; flex: 1">
          <q-btn flat dense type="button" label="<" @click="shiftDate(-1)" />
          <q-input
            v-model="selectedWorkoutLogDate"
            type="date"
            filled
            dense
            style="max-width: 220px"
          />
          <q-btn flat dense type="button" label=">" @click="shiftDate(1)" />
        </div>
        <q-chip color="secondary" text-color="white" square
          >Calories burned: {{ Math.round(totalCaloriesBurned) }}</q-chip
        >
      </div>
      <q-table
        :rows="workoutTableRows"
        :columns="columns"
        :pagination="{ rowsPerPage: 50 }"
        :rows-per-page-options="[20, 50, 200, 0]"
        row-key="workout_log_id"
        flat
        bordered
        dense
        hide-header
        square
        class="full-width no-border"
        :loading="workoutLogsStore.loading"
        no-data-label="No workout log records yet."
      >
        <template #body="props"
          ><q-tr :props="props" :style="props.row.isSelected ? 'background-color: #D0D0D0' : ''"
            ><q-td key="summary" :props="props"
              ><div class="row items-end full-width no-wrap q-col-gutter-sm">
                <div class="col text-left">
                  <p class="q-ma-none">{{ props.row.summary.split('\n')[0] }}</p>
                  <p class="q-ma-none">{{ props.row.summary.split('\n')[1] || '' }}</p>
                </div>
                <div class="col-auto self-end">
                  <q-btn
                    flat
                    dense
                    size="sm"
                    color="negative"
                    label="Delete"
                    @click="requestDelete(props.row)"
                  />
                </div></div></q-td></q-tr
        ></template>
      </q-table>
    </q-card>
    <q-dialog v-model="confirmDeleteOpen"
      ><q-card style="min-width: 320px"
        ><q-card-section class="text-h6">Delete workout log entry?</q-card-section
        ><q-card-section
          >Delete {{ pendingDeleteRow?.description || 'this entry' }} from your workout
          log?</q-card-section
        ><q-card-actions align="right"
          ><q-btn flat label="No" color="primary" @click="cancelDelete" /><q-btn
            label="Yes"
            color="negative"
            @click="confirmDelete" /></q-card-actions></q-card
    ></q-dialog>
  </div>
</template>

<script setup>
import { computed, reactive, ref, watch } from 'vue'
import { useQuasar } from 'quasar'
import { useUsersStore } from 'stores/users'
import { useWorkoutsStore } from 'stores/workouts'
import { useWorkoutLogsStore } from 'stores/workout-logs'
import { notifySuccess } from '../utils/notify'

const usersStore = useUsersStore()
const workoutsStore = useWorkoutsStore()
const workoutLogsStore = useWorkoutLogsStore()
const $q = useQuasar()
const includeSharedWorkouts = ref(false)
const selectedWorkoutLogDate = ref(currentDate())
const confirmDeleteOpen = ref(false)
const pendingDeleteRow = ref(null)
const workoutLog = reactive({ workout_id: null, workout_time: null, date: currentDate() })
const columns = [{ name: 'summary', label: 'Summary', field: 'summary', align: 'right' }]

function currentDate() {
  const now = new Date()
  return `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`
}
function shiftDate(days) {
  const [year, month, day] = selectedWorkoutLogDate.value.split('-').map(Number)
  const date = new Date(year, month - 1, day + days)
  selectedWorkoutLogDate.value = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`
}
function sameId(left, right) {
  return (
    left !== null &&
    left !== undefined &&
    right !== null &&
    right !== undefined &&
    String(left) === String(right)
  )
}

const workoutOptions = computed(() => {
  const userId = usersStore.currentUser?.user_id
  const own = (workoutsStore.workouts || []).filter(
    (workout) => String(workout?.user_id || '') === String(userId || ''),
  )
  const shared = (workoutsStore.workouts || []).filter(
    (workout) => String(workout?.user_id || '') !== String(userId || ''),
  )
  return (includeSharedWorkouts.value ? [...own, ...shared] : own).map((workout) => ({
    label: workout.type,
    value: workout.workout_id,
  }))
})
const selectedWorkout = computed(() =>
  (workoutsStore.workouts || []).find((workout) =>
    sameId(workout.workout_id, workoutLog.workout_id),
  ),
)
const workoutTotalCaloriesBurned = computed(() => {
  const workoutTime = Number(workoutLog.workout_time)
  const averageTime = Number(selectedWorkout.value?.average_workout_time)
  const calories = Number(selectedWorkout.value?.calories_burned)
  return Number.isFinite(workoutTime) &&
    workoutTime >= 0 &&
    Number.isFinite(averageTime) &&
    averageTime > 0 &&
    Number.isFinite(calories) &&
    calories >= 0
    ? Math.round((workoutTime / averageTime) * calories)
    : 0
})
const workoutTableRows = computed(() =>
  (workoutLogsStore.logs || []).map((log) => {
    const workout = log.workout || {}
    const label = workout.type || `Workout #${log.workout_id}`
    const calories = Number(log.calories_burned) || 0
    return {
      ...log,
      description: label,
      isSelected: String(log?.date || '').slice(0, 10) === selectedWorkoutLogDate.value,
      summary: `${label.trim()} | ${String(log.workout_time ?? workout.average_workout_time ?? 'N/A').trim()} (minutes)\n${calories} (calories burned) | ${log.date || ''}`,
    }
  }),
)
const totalCaloriesBurned = computed(() =>
  (workoutLogsStore.logs || []).reduce(
    (total, log) =>
      String(log?.date || '').slice(0, 10) === selectedWorkoutLogDate.value
        ? total + (Number(log?.calories_burned) || 0)
        : total,
    0,
  ),
)

watch(
  () => workoutLog.workout_id,
  () => {
    workoutLog.workout_time = selectedWorkout.value?.average_workout_time ?? null
  },
)
watch(selectedWorkout, (workout) => {
  if (workout && (workoutLog.workout_time === null || workoutLog.workout_time === ''))
    workoutLog.workout_time = workout.average_workout_time ?? null
})

async function submitWorkoutLog() {
  if (!usersStore.currentUser?.user_id) {
    workoutLogsStore.error = 'No current user is available.'
    return
  }
  const saved = await workoutLogsStore.createWorkoutLog(usersStore.currentUser.user_id, {
    workout_id: workoutLog.workout_id,
    workout_time: workoutLog.workout_time,
    calories_burned: workoutTotalCaloriesBurned.value,
    date: workoutLog.date,
  })
  if (saved) {
    notifySuccess($q, 'Workout added to log successfully.')
    workoutLog.workout_time = selectedWorkout.value?.average_workout_time ?? null
    workoutLog.date = currentDate()
    await workoutLogsStore.loadWorkoutLogs(usersStore.currentUser.user_id)
  }
}
function requestDelete(row) {
  pendingDeleteRow.value = row
  confirmDeleteOpen.value = true
}
function cancelDelete() {
  pendingDeleteRow.value = null
  confirmDeleteOpen.value = false
}
async function confirmDelete() {
  const row = pendingDeleteRow.value
  pendingDeleteRow.value = null
  confirmDeleteOpen.value = false
  if (!usersStore.currentUser?.user_id || !row?.workout_log_id) {
    workoutLogsStore.error = 'No current user is available.'
    return
  }
  const { error } = await workoutLogsStore.deleteWorkoutLog(
    usersStore.currentUser.user_id,
    row.workout_log_id,
  )
  if (!error) {
    notifySuccess($q, 'Workout log entry deleted successfully.', { color: 'negative' })
    await workoutLogsStore.loadWorkoutLogs(usersStore.currentUser.user_id)
  }
}
</script>
