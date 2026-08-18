<template>
  <q-page class="q-pa-md">
    <div class="row justify-center">
      <div class="col-12 col-md-10 col-lg-8">
        <q-card flat bordered class="q-pa-md">
          <div class="row items-center justify-between q-mb-md">
            <div class="text-h5">supplements</div>
            <q-btn
              color="primary"
              class="q-mb-sm"
              unelevated
              :label="showsupplementForm ? 'Hide Form' : 'Add supplement'"
              @click="showsupplementForm = !showsupplementForm"
            />
          </div>
          // TODO - remove
          <q-banner v-if="store.error" class="bg-negative text-white q-mb-md" rounded>
            {{ store.error }}
          </q-banner>

          <q-banner
            v-else-if="!usersStore.currentUser"
            class="bg-warning text-dark q-mb-md"
            rounded
          >
            Sign in to manage supplements.
          </q-banner>

          <transition name="form-slide" mode="out-in">
            <q-form
              v-if="showsupplementForm"
              key="supplement-form"
              @submit.prevent="submitsupplement"
              class="q-gutter-md"
            >
              <q-card flat bordered class="q-pa-md bg-grey-1">
                <div class="text-subtitle1 q-mb-sm">supplement details</div>
                <div class="row q-col-gutter-md">
                  <div class="col-12 col-md-6">
                    <q-input
                      v-model="supplement.description"
                      label="supplement"
                      filled
                      dense
                      :disable="!usersStore.currentUser"
                      :rules="[(value) => !!value?.trim() || 'supplement is required']"
                    />
                  </div>

                  <div class="col-12 col-md-3">
                    <q-input
                      v-model="supplement.serving_size"
                      type="number"
                      label="Serving size"
                      min="0.01"
                      step="0.01"
                      filled
                      dense
                      :disable="!usersStore.currentUser"
                      :rules="[
                        (value) => Number(value) > 0 || 'Serving size must be greater than 0',
                      ]"
                    />
                  </div>

                  <div class="col-12 col-md-3">
                    <q-select
                      v-model="supplement.serving_unit"
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
                    <q-toggle v-model="supplement.share_with_others" label="Share with others" />
                  </div>
                </div>
              </q-card>

              <div class="row justify-end q-gutter-sm">
                <q-btn
                  type="submit"
                  color="primary"
                  :label="editingsupplementId ? 'Update supplement' : 'Save supplement'"
                  :loading="store.loading"
                />
              </div>
            </q-form>
          </transition>

          <q-dialog v-model="confirmDeleteOpen">
            <q-card style="min-width: 320px">
              <q-card-section class="text-h6">Delete supplement?</q-card-section>
              <q-card-section> Are you sure you want to delete this supplement? </q-card-section>
              <q-card-actions align="right">
                <q-btn flat label="No" color="primary" @click="cancelDeletesupplement" />
                <q-btn label="Yes" color="negative" @click="confirmDeletesupplement" />
              </q-card-actions>
            </q-card>
          </q-dialog>

          <q-card flat bordered class="q-pa-none bg-grey-1 q-mt-md">
            <div class="row items-center justify-between q-px-md q-py-sm">
              <div class="text-subtitle1">Saved supplements</div>
              <q-toggle v-model="showSharedsupplements" label="Show shared supplements" />
            </div>

            <q-table
              :rows="supplementRows"
              :columns="supplementColumns"
              :pagination="{ rowsPerPage: 50 }"
              :rows-per-page-options="[20, 50, 200, 0]"
              row-key="supplement_id"
              flat
              bordered
              dense
              hide-header
              square
              class="full-width no-border"
              :loading="store.loading"
              no-data-label="No supplements yet."
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

                      <div
                        v-if="isOwnedByCurrentUser(props.row)"
                        class="row items-center q-gutter-xs q-ml-auto no-wrap"
                      >
                        <q-btn
                          flat
                          dense
                          size="sm"
                          color="negative"
                          label="Edit"
                          @click="editsupplement(props.row)"
                        />

                        <q-btn
                          flat
                          dense
                          size="sm"
                          color="negative"
                          label="Delete"
                          @click="requestDeletesupplement(props.row)"
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
                    :colspan="supplementColumns.length"
                    :class="isOwnedByCurrentUser(props.row) ? 'bg-grey-2' : ''"
                  >
                    <div class="row q-col-gutter-sm q-py-sm">
                      <div class="col-12 col-sm-6 col-md-4">
                        <div class="text-caption text-grey-7">supplement</div>
                        <div class="text-body2">{{ props.row.description }}</div>
                      </div>
                      <div class="col-12 col-sm-6 col-md-4">
                        <div class="text-caption text-grey-7">Serving size</div>
                        <div class="text-body2">{{ props.row.servingSizeLabel }}</div>
                      </div>
                      <div class="col-12 col-sm-6 col-md-4">
                        <div class="text-caption text-grey-7">Serving type</div>
                        <div class="text-body2">{{ props.row.servingUnitLabel }}</div>
                      </div>
                      <div class="col-12 col-sm-6 col-md-4">
                        <div class="text-caption text-grey-7">Share with others</div>
                        <div class="text-body2">
                          {{ props.row.share_with_others ? 'Yes' : 'No' }}
                        </div>
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
import { usesupplementsStore } from 'stores/supplements'

const usersStore = useUsersStore()
const store = usesupplementsStore()

const supplement = reactive({
  description: '',
  serving_size: 1,
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

const supplementColumns = [
  {
    name: 'summary',
    label: 'Summary',
    field: 'summary',
    align: 'left',
    sortable: true,
  },
]

const supplementRows = computed(() => {
  const allRows = store.supplements || []
  const currentUserId = usersStore.currentUser?.user_id
  const visibleRows = showSharedsupplements.value
    ? allRows
    : allRows.filter((supplement) => supplement?.user_id === currentUserId)

  return visibleRows.map((supplement) => {
    const servingSize = Number(supplement.serving_size) || 0
    const servingUnitLabel = supplement.serving_unit || 'other'
    const summary = `${supplement.description || ''} | ${servingSize.toFixed(2)} | ${servingUnitLabel}`

    return {
      ...supplement,
      servingSizeLabel: servingSize.toFixed(2),
      servingUnitLabel,
      summary,
    }
  })
})

const showsupplementForm = ref(false)
const showSharedsupplements = ref(false)
const confirmDeleteOpen = ref(false)
const pendingDeletesupplement = ref(null)
const editingsupplementId = ref(null)
const expandedsupplementIds = ref([])

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

  await store.loadSupplements(userId)
}

function isOwnedByCurrentUser(row) {
  return Boolean(usersStore.currentUser?.user_id && row?.user_id === usersStore.currentUser.user_id)
}

function sharedRowClass(row) {
  return isOwnedByCurrentUser(row) ? '' : 'bg-info text-white'
}

function isExpanded(row) {
  return expandedsupplementIds.value.includes(row?.supplement_id)
}

function toggleExpanded(row) {
  if (!row?.supplement_id) {
    return
  }

  if (isExpanded(row)) {
    expandedsupplementIds.value = expandedsupplementIds.value.filter(
      (supplementId) => supplementId !== row.supplement_id,
    )
  } else {
    expandedsupplementIds.value = [...expandedsupplementIds.value, row.supplement_id]
  }
}

function editsupplement(row) {
  editingsupplementId.value = row.supplement_id

  Object.assign(supplement, {
    description: row.description || '',
    serving_size: row.serving_size ?? 1,
    serving_unit: row.serving_unit || 'other',
    share_with_others: Boolean(row.share_with_others),
  })

  showsupplementForm.value = true
}

function resetsupplementForm() {
  Object.assign(supplement, {
    description: '',
    serving_size: 1,
    serving_unit: 'other',
    share_with_others: false,
  })

  editingsupplementId.value = null
}

function requestDeletesupplement(row) {
  pendingDeletesupplement.value = row
  confirmDeleteOpen.value = true
}

function cancelDeletesupplement() {
  pendingDeletesupplement.value = null
  confirmDeleteOpen.value = false
}

async function confirmDeletesupplement() {
  const row = pendingDeletesupplement.value
  pendingDeletesupplement.value = null
  confirmDeleteOpen.value = false

  if (!usersStore.currentUser?.user_id || !row?.supplement_id) {
    store.error = 'No current user is available.'
    return
  }

  const { error } = await store.deactivateSupplement(
    usersStore.currentUser.user_id,
    row.supplement_id,
  )
  if (!error) {
    await store.loadSupplements(usersStore.currentUser.user_id)
  }
}

async function submitsupplement() {
  if (!usersStore.currentUser?.user_id) {
    store.error = 'No current user is available.'
    return
  }

  const normalizedDescription = String(supplement.description || '').trim()
  if (!normalizedDescription) {
    store.error = 'supplement is required.'
    return
  }

  const payload = {
    description: normalizedDescription,
    serving_size: supplement.serving_size,
    serving_unit: supplement.serving_unit || 'other',
    share_with_others: Boolean(supplement.share_with_others),
  }

  const savedsupplement = editingsupplementId.value
    ? await store.updateSupplement(
        usersStore.currentUser.user_id,
        editingsupplementId.value,
        payload,
      )
    : await store.createSupplement(usersStore.currentUser.user_id, payload)

  if (savedsupplement) {
    resetsupplementForm()
    showsupplementForm.value = false
    await store.loadSupplements(usersStore.currentUser.user_id)
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
