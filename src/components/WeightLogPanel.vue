<template>
  <div>
    <q-banner v-if="weightLogsStore.error" class="bg-negative text-white q-mb-md" rounded>
      {{ weightLogsStore.error }}
    </q-banner>
    <q-banner v-else-if="!usersStore.currentUser" class="bg-warning text-dark q-mb-md" rounded>
      Sign in to record weight.
    </q-banner>

    <q-card flat bordered class="q-pa-none bg-grey-1 q-mt-md">
      <div class="row items-center q-px-md q-py-sm no-wrap q-gutter-sm">
        <q-chip color="secondary" text-color="white" square>
          {{ Math.round(currentProfile?.start_weight ?? 0) }}
        </q-chip>
        <div class="col text-subtitle1 text-center">Weight progress</div>
        <q-chip color="secondary" text-color="white" square>
          {{ Math.round(weightProgressGoalValue ?? 0) }}
        </q-chip>
      </div>
      <div class="row items-center no-wrap q-gutter-sm q-px-md q-pb-md">
        <q-linear-progress
          class="col"
          :value="weightProgressValue"
          color="accent"
          size="12px"
          rounded
        />
        <q-chip dense color="accent" text-color="white" square>{{ projectedGoalDateLabel }}</q-chip>
      </div>
    </q-card>

    <q-form @submit.prevent="submitWeightLog" class="q-mt-md">
      <q-card flat bordered class="q-pa-md bg-grey-1">
        <div class="text-subtitle1 q-mb-sm">Log Weight</div>
        <div class="row q-col-gutter-md">
          <div class="col-12 col-md-4">
            <q-input
              v-model="weightLog.weight"
              type="number"
              label="Weight"
              min="0.01"
              step="0.01"
              filled
              dense
              :disable="!usersStore.currentUser"
              :rules="[
                (value) => value === '' || Number(value) > 0 || 'Weight must be greater than 0',
              ]"
            />
          </div>
          <div class="col-12 col-md-4">
            <q-input :model-value="weightLogBodyMassIndex" label="BMI" filled dense readonly />
          </div>
          <div class="col-12 col-md-4">
            <q-input
              v-model="weightLog.date"
              type="date"
              label="Date"
              filled
              dense
              :disable="!usersStore.currentUser"
            />
          </div>
        </div>
        <div class="row justify-end q-mt-md">
          <q-btn
            type="submit"
            color="primary"
            label="Add to log"
            :loading="weightLogsStore.loading"
            :disable="!usersStore.currentUser"
          />
        </div>
      </q-card>
    </q-form>

    <q-card flat bordered class="q-pa-none bg-grey-1 q-mt-md">
      <div class="text-subtitle1 q-px-md q-pt-md q-pb-sm">Logged weight</div>
      <q-table
        :rows="weightTableRows"
        :columns="columns"
        :pagination="{ rowsPerPage: 50 }"
        :rows-per-page-options="[20, 50, 200, 0]"
        row-key="weight_log_id"
        flat
        bordered
        dense
        hide-header
        square
        class="full-width no-border"
        :loading="weightLogsStore.loading"
        no-data-label="No weight log records yet."
      >
        <template #body="props">
          <q-tr :props="props">
            <q-td key="summary" :props="props">
              <div class="row items-center full-width">
                <span>{{ props.row.summary }}</span>
                <div class="q-ml-auto">
                  <q-btn
                    flat
                    dense
                    size="sm"
                    color="negative"
                    label="Delete"
                    @click="requestDelete(props.row)"
                  />
                </div>
              </div>
            </q-td>
          </q-tr>
        </template>
      </q-table>
    </q-card>

    <q-dialog v-model="confirmDeleteOpen">
      <q-card style="min-width: 320px">
        <q-card-section class="text-h6">Delete weight log entry?</q-card-section>
        <q-card-section>
          Delete {{ pendingDeleteRow?.description || 'this entry' }} from your weight log?
        </q-card-section>
        <q-card-actions align="right">
          <q-btn flat label="No" color="primary" @click="cancelDelete" />
          <q-btn label="Yes" color="negative" @click="confirmDelete" />
        </q-card-actions>
      </q-card>
    </q-dialog>
  </div>
</template>

<script setup>
import { computed, reactive, ref } from 'vue'
import { useProfilesStore } from 'stores/profiles'
import { useUsersStore } from 'stores/users'
import { useWeightLogsStore } from 'stores/weight-logs'
import { calculateBodyMassIndex } from '../utils/rules'

const usersStore = useUsersStore()
const profilesStore = useProfilesStore()
const weightLogsStore = useWeightLogsStore()
const weightLog = reactive({ weight: '', date: currentDate() })
const confirmDeleteOpen = ref(false)
const pendingDeleteRow = ref(null)
const columns = [{ name: 'summary', label: 'Summary', field: 'summary', align: 'right' }]

function currentDate() {
  const now = new Date()
  return `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`
}

const currentProfile = computed(() => profilesStore.currentProfile || null)

const weightLogsSortedByDate = computed(() => {
  return [...(weightLogsStore.logs || [])]
    .filter((log) => Number.isFinite(Number(log?.weight)) && Number(log?.weight) > 0)
    .sort((leftLog, rightLog) =>
      String(leftLog?.date || '').localeCompare(String(rightLog?.date || '')),
    )
})

const latestWeightLogForToday = computed(() => {
  const today = currentDate()
  return (
    [...weightLogsSortedByDate.value]
      .reverse()
      .find((log) => String(log?.date || '').slice(0, 10) <= today) || null
  )
})

const oldestWeightLogForToday = computed(() => {
  const today = currentDate()
  return (
    weightLogsSortedByDate.value.find((log) => String(log?.date || '').slice(0, 10) <= today) ||
    null
  )
})

const weightProgressCurrentValue = computed(() => {
  const loggedWeight = Number(latestWeightLogForToday.value?.weight)
  if (Number.isFinite(loggedWeight) && loggedWeight > 0) return loggedWeight

  const startWeight = Number(currentProfile.value?.start_weight)
  return Number.isFinite(startWeight) && startWeight > 0 ? startWeight : null
})

const weightLogBodyMassIndex = computed(() => {
  const enteredWeight = Number(weightLog.weight)
  const loggedWeight = Number(latestWeightLogForToday.value?.weight)
  const startWeight = Number(currentProfile.value?.start_weight)
  const effectiveWeight =
    Number.isFinite(enteredWeight) && enteredWeight > 0
      ? enteredWeight
      : Number.isFinite(loggedWeight) && loggedWeight > 0
        ? loggedWeight
        : Number.isFinite(startWeight) && startWeight > 0
          ? startWeight
          : null

  return (
    calculateBodyMassIndex({ weight: effectiveWeight, height: currentProfile.value?.height }) ?? ''
  )
})

const weightProgressGoalValue = computed(() => {
  const goalWeight = Number(currentProfile.value?.goal_weight)
  return Number.isFinite(goalWeight) && goalWeight > 0 ? goalWeight : null
})

const weightProgressValue = computed(() => {
  const startWeight = Number(currentProfile.value?.start_weight)
  const goalWeight = weightProgressGoalValue.value
  const currentWeight = weightProgressCurrentValue.value

  if (
    !Number.isFinite(startWeight) ||
    !Number.isFinite(goalWeight) ||
    !Number.isFinite(currentWeight) ||
    startWeight <= 0 ||
    goalWeight <= 0 ||
    startWeight === goalWeight
  )
    return 0

  return Math.min(1, Math.max(0, (currentWeight - startWeight) / (goalWeight - startWeight)))
})

const projectedGoalDateLabel = computed(() => {
  const startWeight = Number(currentProfile.value?.start_weight)
  const goalWeight = Number(weightProgressGoalValue.value)
  const currentWeight = Number(weightProgressCurrentValue.value)
  const oldestDateText = String(oldestWeightLogForToday.value?.date || '').slice(0, 10)
  const latestDateText = String(latestWeightLogForToday.value?.date || '').slice(0, 10)

  if (
    !oldestDateText ||
    !latestDateText ||
    !Number.isFinite(startWeight) ||
    !Number.isFinite(goalWeight) ||
    !Number.isFinite(currentWeight) ||
    startWeight === currentWeight
  )
    return 'N/A'

  const oldestDate = new Date(`${oldestDateText}T00:00:00`)
  const latestDate = new Date(`${latestDateText}T00:00:00`)
  const elapsedDays = (latestDate.getTime() - oldestDate.getTime()) / 86400000
  if (!Number.isFinite(elapsedDays) || elapsedDays < 0) return 'N/A'

  const projectedDays =
    elapsedDays * ((startWeight - goalWeight) / (startWeight - currentWeight)) * 1.41
  if (!Number.isFinite(projectedDays)) return 'N/A'

  const projectedDate = new Date(oldestDate)
  projectedDate.setDate(projectedDate.getDate() + Math.round(projectedDays))
  return `${projectedDate.getFullYear()}-${String(projectedDate.getMonth() + 1).padStart(2, '0')}-${String(projectedDate.getDate()).padStart(2, '0')}`
})

const weightTableRows = computed(() => {
  return [...(weightLogsStore.logs || [])]
    .sort((leftLog, rightLog) => {
      const dateComparison = String(rightLog?.date || '').localeCompare(String(leftLog?.date || ''))
      return dateComparison || Number(rightLog?.weight || 0) - Number(leftLog?.weight || 0)
    })
    .map((log) => {
      const weight = Number(log.weight) || 0
      const bmi = Number(log.bmi)
      return {
        ...log,
        description: weight.toFixed(2),
        summary: `${weight.toFixed(2)} | ${Number.isFinite(bmi) && bmi > 0 ? bmi.toFixed(2) : 'N/A'} | ${log.date || ''}`,
      }
    })
})

async function submitWeightLog() {
  if (!usersStore.currentUser?.user_id) {
    weightLogsStore.error = 'No current user is available.'
    return
  }

  const saved = await weightLogsStore.createWeightLog(usersStore.currentUser.user_id, {
    weight: weightLog.weight,
    bmi: weightLogBodyMassIndex.value,
    date: weightLog.date,
  })

  if (saved) {
    weightLog.weight = ''
    weightLog.date = currentDate()
    await weightLogsStore.loadWeightLogs(usersStore.currentUser.user_id)
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

  if (!usersStore.currentUser?.user_id || !row?.weight_log_id) {
    weightLogsStore.error = 'No current user is available.'
    return
  }

  const { error } = await weightLogsStore.deleteWeightLog(
    usersStore.currentUser.user_id,
    row.weight_log_id,
  )
  if (!error) await weightLogsStore.loadWeightLogs(usersStore.currentUser.user_id)
}
</script>
