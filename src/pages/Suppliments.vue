<template>
  <q-page class="q-pa-md">
    <div class="row justify-center">
      <div class="col-12 col-md-10 col-lg-8">
        <q-card flat bordered class="q-pa-md">
          <div class="row items-center justify-between q-mb-md">
            <div class="text-h5">Suppliments</div>
            <q-btn
              color="primary"
              class="q-mb-sm"
              unelevated
              :label="showSupplimentForm ? 'Hide Form' : 'Add Suppliment'"
              @click="showSupplimentForm = !showSupplimentForm"
            />
          </div>

          <q-banner v-if="store.error" class="bg-negative text-white q-mb-md" rounded>
            {{ store.error }}
          </q-banner>

          <q-banner
            v-else-if="!usersStore.currentUser"
            class="bg-warning text-dark q-mb-md"
            rounded
          >
            Sign in to create a suppliment log entry.
          </q-banner>

          <transition name="form-slide" mode="out-in">
            <q-form
              v-if="showSupplimentForm"
              key="suppliment-form"
              @submit.prevent="submitSuppliment"
              class="q-gutter-md"
            >
              <q-card flat bordered class="q-pa-md bg-grey-1">
                <div class="text-subtitle1 q-mb-sm">Suppliment log details</div>
                <div class="row q-col-gutter-md">
                  <div class="col-12 col-md-3">
                    <q-input
                      v-model="suppliment.description"
                      label="Suppliment"
                      filled
                      dense
                      :disable="!usersStore.currentUser"
                      :rules="[(value) => !!value?.trim() || 'Suppliment is required']"
                    />
                  </div>

                  <div class="col-12 col-md-3">
                    <q-input
                      v-model="suppliment.servings"
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
                      v-model="suppliment.serving_unit"
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
                      v-model="suppliment.date"
                      type="date"
                      label="Date"
                      filled
                      dense
                      :disable="!usersStore.currentUser"
                    />
                  </div>
                </div>
              </q-card>

              <q-card flat bordered class="q-pa-md bg-grey-1">
                <div class="text-subtitle1 q-mb-sm">Preferences</div>
                <div class="row q-col-gutter-md">
                  <div class="col-12 col-md-4">
                    <q-toggle v-model="suppliment.share_with_others" label="Share with others" />
                  </div>
                </div>
              </q-card>

              <div class="row justify-end q-gutter-sm">
                <q-btn
                  type="submit"
                  color="primary"
                  :label="editingSupplimentLogId ? 'Update suppliment' : 'Save suppliment'"
                  :loading="store.loading"
                />
              </div>
            </q-form>
          </transition>

          <q-dialog v-model="confirmDeleteOpen">
            <q-card style="min-width: 320px">
              <q-card-section class="text-h6">Delete suppliment log?</q-card-section>
              <q-card-section>
                Are you sure you want to delete this suppliment log entry?
              </q-card-section>
              <q-card-actions align="right">
                <q-btn flat label="No" color="primary" @click="cancelDeleteSuppliment" />
                <q-btn label="Yes" color="negative" @click="confirmDeleteSuppliment" />
              </q-card-actions>
            </q-card>
          </q-dialog>

          <q-card flat bordered class="q-pa-md bg-grey-1 q-mt-md">
            <div class="text-subtitle1 q-mb-sm">Saved suppliments</div>

            <q-table
              :rows="supplimentRows"
              :columns="supplimentColumns"
              row-key="supplement_log_id"
              flat
              bordered
              dense
              hide-header
              :loading="store.loading"
              no-data-label="No suppliment records yet."
            >
              <template #body="props">
                <q-tr :props="props" :class="sharedRowClass(props.row)">
                  <q-td key="summary" :props="props">
                    <div class="row items-center full-width">
                      <q-btn
                        size="sm"
                        color="secondary"
                        dense
                        round
                        :icon="isExpanded(props.row) ? 'remove' : 'add'"
                        @click="toggleExpanded(props.row)"
                      />

                      <span class="q-ml-lg">
                        {{ props.row.summary }}
                      </span>

                      <q-chip
                        v-if="!isOwnedByCurrentUser(props.row)"
                        dense
                        color="secondary"
                        text-color="white"
                        class="q-ml-sm"
                      >
                        Shared
                      </q-chip>

                      <div class="row items-center q-gutter-xs q-ml-auto">
                        <q-btn
                          flat
                          dense
                          size="sm"
                          color="negative"
                          label="Edit"
                          :disable="!isOwnedByCurrentUser(props.row)"
                          @click="editSuppliment(props.row)"
                        />

                        <q-btn
                          flat
                          dense
                          size="sm"
                          color="negative"
                          label="Delete"
                          :disable="!isOwnedByCurrentUser(props.row)"
                          @click="requestDeleteSuppliment(props.row)"
                        />
                      </div>
                    </div>
                  </q-td>
                </q-tr>

                <q-tr
                  v-if="isExpanded(props.row)"
                  :props="props"
                  :class="sharedRowClass(props.row)"
                >
                  <q-td
                    :colspan="supplimentColumns.length"
                    :class="isOwnedByCurrentUser(props.row) ? 'bg-grey-2' : ''"
                  >
                    <div class="row q-col-gutter-sm q-py-sm">
                      <div class="col-12 col-sm-6 col-md-4">
                        <div class="text-caption text-grey-7">Suppliment</div>
                        <div class="text-body2">{{ props.row.supplementLabel }}</div>
                      </div>
                      <div class="col-12 col-sm-6 col-md-4">
                        <div class="text-caption text-grey-7">Servings</div>
                        <div class="text-body2">{{ props.row.servingsLabel }}</div>
                      </div>
                      <div class="col-12 col-sm-6 col-md-4">
                        <div class="text-caption text-grey-7">Date</div>
                        <div class="text-body2">{{ props.row.date || 'N/A' }}</div>
                      </div>
                      <div class="col-12 col-sm-6 col-md-4">
                        <div class="text-caption text-grey-7">Serving unit</div>
                        <div class="text-body2">{{ props.row.servingUnitLabel }}</div>
                      </div>
                      <div class="col-12 col-sm-6 col-md-4">
                        <div class="text-caption text-grey-7">Serving size</div>
                        <div class="text-body2">{{ props.row.servingSizeLabel }}</div>
                      </div>
                    </div>
                  </q-td>
                </q-tr>
              </template>
            </q-table>
          </q-card>
        </q-card>
      </div>
    </div>
  </q-page>
</template>

<script setup>
import { computed, onMounted, reactive, ref, watch } from 'vue'
import { useUsersStore } from 'stores/users'
import { useSupplementLogsStore } from 'stores/supplement-logs'

const usersStore = useUsersStore()
const store = useSupplementLogsStore()

function getCurrentLocalDate() {
  const now = new Date()
  const year = now.getFullYear()
  const month = String(now.getMonth() + 1).padStart(2, '0')
  const day = String(now.getDate()).padStart(2, '0')
  return `${year}-${month}-${day}`
}

const suppliment = reactive({
  description: '',
  servings: 1,
  date: getCurrentLocalDate(),
  serving_unit: 'other',
  share_with_others: false,
})

const servingUnitOptions = [
  { label: 'Pills', value: 'pills' },
  { label: 'Oz', value: 'oz' },
  { label: 'Scoop', value: 'scoop' },
  { label: 'Glasses', value: 'glasses' },
  { label: 'Other', value: 'other' },
]

const supplimentColumns = [
  {
    name: 'summary',
    label: 'Summary',
    field: 'summary',
    align: 'left',
    sortable: true,
  },
]

const supplimentRows = computed(() => {
  return (store.logs || []).map((log) => {
    const supplement = log.supplement || {}
    const servings = Number(log.servings) || 0
    const supplementLabel = supplement.description || `Suppliment #${log.supplement_id}`

    return {
      ...log,
      supplementLabel,
      servingsLabel: servings.toFixed(2),
      servingUnitLabel: supplement.serving_unit || 'other',
      servingSizeLabel: supplement.serving_size ?? 1,
      summary: `${supplementLabel} | ${servings.toFixed(2)} | ${supplement.serving_unit || 'other'} | ${log.date || ''}`,
    }
  })
})

const showSupplimentForm = ref(false)
const confirmDeleteOpen = ref(false)
const pendingDeleteSuppliment = ref(null)
const expandedSupplimentIds = ref([])
const editingSupplimentLogId = ref(null)

onMounted(() => {
  if (usersStore.currentUser?.user_id) {
    loadDataForCurrentUser(usersStore.currentUser.user_id)
  }
})

watch(
  () => usersStore.currentUser?.user_id,
  (userId) => {
    if (userId) {
      loadDataForCurrentUser(userId)
    } else {
      store.logs = []
      store.supplements = []
    }
  },
)

async function loadDataForCurrentUser(userId) {
  if (!userId) {
    return
  }

  await Promise.all([store.loadSupplements(userId), store.loadSupplementLogs(userId)])
}

function isOwnedByCurrentUser(row) {
  return Boolean(usersStore.currentUser?.user_id && row?.user_id === usersStore.currentUser.user_id)
}

function sharedRowClass(row) {
  return isOwnedByCurrentUser(row) ? '' : 'bg-info text-white'
}

function isExpanded(row) {
  return expandedSupplimentIds.value.includes(row?.supplement_log_id)
}

function toggleExpanded(row) {
  if (!row?.supplement_log_id) {
    return
  }

  if (isExpanded(row)) {
    expandedSupplimentIds.value = expandedSupplimentIds.value.filter(
      (supplementLogId) => supplementLogId !== row.supplement_log_id,
    )
  } else {
    expandedSupplimentIds.value = [...expandedSupplimentIds.value, row.supplement_log_id]
  }
}

function editSuppliment(row) {
  editingSupplimentLogId.value = row.supplement_log_id

  Object.assign(suppliment, {
    description: row.supplementLabel || '',
    servings: row.servings ?? 1,
    date: row.date || getCurrentLocalDate(),
    serving_unit: row.supplement?.serving_unit || 'other',
    share_with_others: Boolean(row.supplement?.share_with_others),
  })

  showSupplimentForm.value = true
}

function resetSupplimentForm() {
  Object.assign(suppliment, {
    description: '',
    servings: 1,
    date: getCurrentLocalDate(),
    serving_unit: 'other',
    share_with_others: false,
  })

  editingSupplimentLogId.value = null
}

function requestDeleteSuppliment(row) {
  pendingDeleteSuppliment.value = row
  confirmDeleteOpen.value = true
}

function cancelDeleteSuppliment() {
  pendingDeleteSuppliment.value = null
  confirmDeleteOpen.value = false
}

async function confirmDeleteSuppliment() {
  const row = pendingDeleteSuppliment.value
  pendingDeleteSuppliment.value = null
  confirmDeleteOpen.value = false

  if (!usersStore.currentUser?.user_id || !row?.supplement_log_id) {
    store.error = 'No current user is available.'
    return
  }

  const { error } = await store.deleteSupplementLog(
    usersStore.currentUser.user_id,
    row.supplement_log_id,
  )
  if (!error) {
    await store.loadSupplementLogs(usersStore.currentUser.user_id)
  }
}

async function submitSuppliment() {
  if (!usersStore.currentUser?.user_id) {
    store.error = 'No current user is available.'
    return
  }

  const normalizedDescription = String(suppliment.description || '').trim()
  if (!normalizedDescription) {
    store.error = 'Suppliment is required.'
    return
  }

  const existingSupplement = (store.supplements || []).find(
    (supplement) =>
      String(supplement.description || '')
        .trim()
        .toLowerCase() === normalizedDescription.toLowerCase(),
  )

  const resolvedSupplement =
    existingSupplement ||
    (await store.createSupplement(usersStore.currentUser.user_id, {
      description: normalizedDescription,
      serving_size: 1,
      serving_unit: suppliment.serving_unit || 'other',
      share_with_others: Boolean(suppliment.share_with_others),
    }))

  if (!resolvedSupplement?.supplement_id) {
    return
  }

  const payload = {
    supplement_id: resolvedSupplement.supplement_id,
    servings: suppliment.servings,
    date: suppliment.date,
  }

  const savedSuppliment = editingSupplimentLogId.value
    ? await store.updateSupplementLog(
        usersStore.currentUser.user_id,
        editingSupplimentLogId.value,
        payload,
      )
    : await store.createSupplementLog(usersStore.currentUser.user_id, payload)

  if (savedSuppliment) {
    resetSupplimentForm()
    showSupplimentForm.value = false
    await store.loadSupplementLogs(usersStore.currentUser.user_id)
  }
}
</script>

<style scoped>
.form-slide-enter-active,
.form-slide-leave-active {
  transition: all 0.45s ease;
}

.form-slide-enter-from,
.form-slide-leave-to {
  opacity: 0;
  transform: translateY(12px);
}

.form-slide-enter-to,
.form-slide-leave-from {
  opacity: 1;
  transform: translateY(0);
}
</style>
