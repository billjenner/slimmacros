<template>
  <div>
    <q-banner v-if="supplementLogsStore.error" class="bg-negative text-white q-mb-md" rounded>
      {{ supplementLogsStore.error }}
    </q-banner>

    <q-banner v-else-if="!usersStore.currentUser" class="bg-warning text-dark q-mb-md" rounded>
      Sign in to record supplements.
    </q-banner>

    <q-form @submit.prevent="submitSupplementLog" class="q-gutter-md">
      <q-card flat bordered class="q-pa-md bg-grey-1">
        <div class="text-subtitle1 q-mb-sm">Log supplement</div>
        <div class="row q-col-gutter-md">
          <div class="col-12 col-md-6">
            <q-select
              v-model="supplementLog.supplement_id"
              :options="supplementOptions"
              label="supplement"
              filled
              dense
              emit-value
              map-options
              :disable="!usersStore.currentUser"
              :rules="[(value) => !!value || 'supplement is required']"
            />
          </div>

          <div class="col-12 col-md-3">
            <q-input
              v-model="supplementLog.servings"
              type="number"
              label="Servings"
              min="0.01"
              step="0.01"
              filled
              dense
              :disable="!usersStore.currentUser"
              :rules="[(value) => Number(value) > 0 || 'Servings must be greater than 0']"
            />
          </div>

          <div class="col-12 col-md-3">
            <q-select
              v-model="supplementLog.serving_unit"
              :options="servingUnitOptions"
              label="Serving type"
              filled
              dense
              emit-value
              map-options
              :disable="!usersStore.currentUser"
            />
          </div>

          <div class="col-12 col-md-3">
            <q-input
              v-model="supplementLog.date"
              type="date"
              label="Date"
              filled
              dense
              :disable="!usersStore.currentUser"
            />
          </div>
        </div>

        <div class="row items-center justify-between q-mt-md">
          <q-toggle
            v-model="includeSharedSupplements"
            label="Include shared supplements"
            :disable="!usersStore.currentUser"
          />
          <q-btn
            type="submit"
            color="primary"
            label="Add to log"
            :loading="supplementLogsStore.loading"
            :disable="!usersStore.currentUser"
          />
        </div>
      </q-card>
    </q-form>

    <q-card flat bordered class="q-pa-none bg-grey-1 q-mt-md">
      <div class="row items-center justify-between q-px-md q-py-sm">
        <div class="text-subtitle1">Logged supplements</div>
        <div class="row items-center no-wrap q-gutter-xs" style="justify-content: center; flex: 1">
          <q-btn flat dense type="button" label="<" @click="shiftDate(-1)" />
          <q-input
            v-model="selectedSupplementLogDate"
            type="date"
            filled
            dense
            style="max-width: 220px"
          />
          <q-btn flat dense type="button" label=">" @click="shiftDate(1)" />
        </div>
        <q-chip color="secondary" text-color="white" square>
          Supp. Count: {{ supplementCountForSelectedDate }}
        </q-chip>
      </div>

      <q-table
        :rows="supplementTableRows"
        :columns="columns"
        :pagination="{ rowsPerPage: 50 }"
        :rows-per-page-options="[20, 50, 200, 0]"
        row-key="supplement_log_id"
        flat
        bordered
        dense
        hide-header
        square
        class="full-width no-border"
        :loading="supplementLogsStore.loading"
        no-data-label="No supplement log records yet."
      >
        <template #body="props">
          <q-tr :props="props" :style="props.row.isSelected ? 'background-color: #D0D0D0' : ''">
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
        <q-card-section class="text-h6">Delete supplement log entry?</q-card-section>
        <q-card-section>
          Delete {{ pendingDeleteRow?.description || 'this entry' }} from your supplement log?
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
import { computed, reactive, ref, watch } from 'vue'
import { usesupplementsLogStore } from 'stores/supplements_log'
import { usesupplementsStore } from 'stores/supplements'
import { useUsersStore } from 'stores/users'

const usersStore = useUsersStore()
const supplementsStore = usesupplementsStore()
const supplementLogsStore = usesupplementsLogStore()
const includeSharedSupplements = ref(false)
const selectedSupplementLogDate = ref(currentDate())
const confirmDeleteOpen = ref(false)
const pendingDeleteRow = ref(null)
const supplementLog = reactive({
  supplement_id: null,
  servings: 1,
  serving_unit: 'other',
  date: currentDate(),
})
const columns = [{ name: 'summary', label: 'Summary', field: 'summary', align: 'right' }]
const servingUnitOptions = [
  { label: 'Pills', value: 'pills' },
  { label: 'Oz', value: 'oz' },
  { label: 'Scoop', value: 'scoop' },
  { label: 'Glasses', value: 'glasses' },
  { label: 'Other', value: 'other' },
]

function currentDate() {
  const now = new Date()
  return `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`
}

function shiftDate(days) {
  const [year, month, day] = selectedSupplementLogDate.value.split('-').map(Number)
  const date = new Date(year, month - 1, day + days)
  selectedSupplementLogDate.value = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`
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

const supplementOptions = computed(() => {
  const userId = usersStore.currentUser?.user_id
  const own = (supplementsStore.supplements || []).filter(
    (supplement) => String(supplement?.user_id || '') === String(userId || ''),
  )
  const shared = (supplementsStore.supplements || []).filter(
    (supplement) => String(supplement?.user_id || '') !== String(userId || ''),
  )

  return (includeSharedSupplements.value ? [...own, ...shared] : own).map((supplement) => ({
    label: `${supplement.description} (${supplement.serving_size ?? 1} ${supplement.serving_unit || 'other'})`,
    value: supplement.supplement_id,
  }))
})

const selectedSupplement = computed(() => {
  return (
    (supplementsStore.supplements || []).find((supplement) =>
      sameId(supplement.supplement_id, supplementLog.supplement_id),
    ) || null
  )
})

const supplementCountForSelectedDate = computed(() => {
  return (supplementLogsStore.logs || []).reduce((total, log) => {
    return String(log?.date || '').slice(0, 10) === selectedSupplementLogDate.value
      ? total + 1
      : total
  }, 0)
})

const supplementTableRows = computed(() => {
  return [...(supplementLogsStore.logs || [])]
    .sort((leftLog, rightLog) => {
      const dateComparison = String(rightLog?.date || '').localeCompare(String(leftLog?.date || ''))
      if (dateComparison !== 0) return dateComparison

      return String(leftLog?.supplement?.description || '').localeCompare(
        String(rightLog?.supplement?.description || ''),
      )
    })
    .map((log) => {
      const supplement = log.supplement || {}
      const label = supplement.description || `supplement #${log.supplement_id}`
      const servings = Number(log.servings) || 0

      return {
        ...log,
        description: label,
        isSelected: String(log?.date || '').slice(0, 10) === selectedSupplementLogDate.value,
        summary: `${label} | ${servings.toFixed(2)} | ${supplement.serving_unit || 'other'} | ${log.date || ''}`,
      }
    })
})

watch(
  () => supplementLog.supplement_id,
  () => {
    supplementLog.servings = selectedSupplement.value?.serving_size ?? 1
    supplementLog.serving_unit = selectedSupplement.value?.serving_unit || 'other'
  },
)

watch(selectedSupplement, (supplement) => {
  if (supplement && (supplementLog.servings === null || supplementLog.servings === '')) {
    supplementLog.servings = supplement.serving_size ?? 1
  }

  if (supplement && !supplementLog.serving_unit) {
    supplementLog.serving_unit = supplement.serving_unit || 'other'
  }
})

async function submitSupplementLog() {
  if (!usersStore.currentUser?.user_id) {
    supplementLogsStore.error = 'No current user is available.'
    return
  }

  const saved = await supplementLogsStore.createSupplementLog(usersStore.currentUser.user_id, {
    supplement_id: supplementLog.supplement_id,
    servings: supplementLog.servings,
    serving_unit: supplementLog.serving_unit,
    date: supplementLog.date,
  })

  if (saved) {
    supplementLog.servings = 1
    supplementLog.serving_unit = selectedSupplement.value?.serving_unit || 'other'
    supplementLog.date = currentDate()
    await supplementLogsStore.loadSupplementLogs(usersStore.currentUser.user_id)
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

  if (!usersStore.currentUser?.user_id || !row?.supplement_log_id) {
    supplementLogsStore.error = 'No current user is available.'
    return
  }

  const { error } = await supplementLogsStore.deleteSupplementLog(
    usersStore.currentUser.user_id,
    row.supplement_log_id,
  )

  if (!error) {
    await supplementLogsStore.loadSupplementLogs(usersStore.currentUser.user_id)
  }
}
</script>
