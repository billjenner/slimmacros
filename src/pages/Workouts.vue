<template>
  <q-page class="q-pa-md">
    <div class="row justify-center">
      <div class="col-12 col-md-10 col-lg-8">
        <q-card flat bordered class="q-pa-md">
          <div class="row items-center justify-between q-mb-md">
            <div class="text-h5">Workouts</div>
            <q-btn
              color="primary"
              class="q-mb-sm"
              unelevated
              :label="showWorkoutForm ? 'Hide Form' : 'Add Workout'"
              @click="showWorkoutForm = !showWorkoutForm"
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
            Sign in to create a workout entry.
          </q-banner>

          <transition name="form-slide" mode="out-in">
            <q-form
              v-if="showWorkoutForm"
              key="workout-form"
              @submit.prevent="submitWorkout"
              class="q-gutter-md"
            >
              <q-card flat bordered class="q-pa-md bg-grey-1">
                <div class="text-subtitle1 q-mb-sm">Workout details</div>
                <div class="row q-col-gutter-md">
                  <div class="col-12 col-md-6">
                    <q-input
                      v-model="workout.type"
                      label="Type"
                      filled
                      dense
                      :rules="[(value) => !!value?.trim() || 'Type is required']"
                    />
                  </div>

                  <div class="col-12 col-md-3">
                    <q-input
                      v-model="workout.average_workout_time"
                      type="number"
                      label="Average workout time (min)"
                      min="0"
                      step="1"
                      filled
                      dense
                    />
                  </div>

                  <div class="col-12 col-md-3">
                    <q-input
                      v-model="workout.calories_burned"
                      type="number"
                      label="Calories burned"
                      min="0"
                      step="1"
                      filled
                      dense
                    />
                  </div>
                </div>
              </q-card>

              <q-card flat bordered class="q-pa-md bg-grey-1">
                <div class="text-subtitle1 q-mb-sm">Preferences</div>
                <div class="row q-col-gutter-md">
                  <div class="col-12 col-md-4">
                    <q-toggle v-model="workout.share_with_others" label="Share with others" />
                  </div>
                </div>
              </q-card>

              <div class="row justify-end q-gutter-sm">
                <q-btn
                  type="submit"
                  color="primary"
                  :label="editingWorkoutId ? 'Update workout' : 'Save workout'"
                  :loading="store.loading"
                />
              </div>
            </q-form>
          </transition>

          <q-dialog v-model="confirmDeleteOpen">
            <q-card style="min-width: 320px">
              <q-card-section class="text-h6">Delete workout?</q-card-section>
              <q-card-section>
                Are you sure you want to delete workout {{ pendingDeleteWorkout?.type || '' }}?
              </q-card-section>
              <q-card-actions align="right">
                <q-btn flat label="No" color="primary" @click="cancelDeleteWorkout" />
                <q-btn label="Yes" color="negative" @click="confirmDeleteWorkout" />
              </q-card-actions>
            </q-card>
          </q-dialog>

          <q-card flat bordered class="q-pa-md bg-grey-1 q-mt-md">
            <div class="row items-center justify-between q-mb-sm">
              <div class="text-subtitle1">Saved workouts</div>
              <q-toggle v-model="showSharedWorkouts" label="Show shared workouts" />
            </div>

            <q-table
              :rows="workoutRows"
              :columns="workoutColumns"
              :pagination="{ rowsPerPage: 50 }"
              :rows-per-page-options="[20, 50, 200, 0]"
              row-key="workout_id"
              flat
              bordered
              dense
              hide-header
              :loading="store.loading"
              no-data-label="No workout records yet."
            >
              <template #body="props">
                <q-tr :props="props" :class="sharedRowClass(props.row)">
                  <q-td key="type" :props="props">
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
                        {{ props.row.type }}
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
                        class="row items-center q-gutter-xs q-ml-auto"
                      >
                        <q-btn
                          flat
                          dense
                          size="sm"
                          color="negative"
                          label="Edit"
                          @click="editWorkout(props.row)"
                        />

                        <q-btn
                          flat
                          dense
                          size="sm"
                          color="negative"
                          label="Delete"
                          @click="requestDeleteWorkout(props.row)"
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
                    :colspan="workoutColumns.length"
                    :class="isOwnedByCurrentUser(props.row) ? 'bg-grey-2' : ''"
                  >
                    <div class="row q-col-gutter-sm q-py-sm">
                      <div class="col-12 col-sm-6 col-md-4">
                        <div class="text-caption text-grey-7">Average workout time</div>
                        <div class="text-body2">{{ props.row.average_workout_time ?? 'N/A' }}</div>
                      </div>
                      <div class="col-12 col-sm-6 col-md-4">
                        <div class="text-caption text-grey-7">Calories burned</div>
                        <div class="text-body2">{{ props.row.calories_burned ?? 0 }}</div>
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
import { useWorkoutsStore } from 'stores/workouts'

const usersStore = useUsersStore()
const store = useWorkoutsStore()

const workout = reactive({
  type: '',
  average_workout_time: null,
  calories_burned: 0,
  share_with_others: false,
  is_active: true,
})

const workoutColumns = [
  {
    name: 'type',
    label: 'Type',
    field: 'type',
    align: 'left',
    sortable: true,
  },
]

const workoutRows = computed(() => {
  const allRows = store.workouts || []
  const currentUserId = usersStore.currentUser?.user_id

  if (showSharedWorkouts.value) {
    return allRows
  }

  return allRows.filter((row) => row?.user_id === currentUserId)
})
const showWorkoutForm = ref(false)
const showSharedWorkouts = ref(false)
const confirmDeleteOpen = ref(false)
const pendingDeleteWorkout = ref(null)
const expandedWorkoutIds = ref([])
const editingWorkoutId = ref(null)

onMounted(() => {
  if (usersStore.currentUser?.user_id) {
    loadWorkoutsForCurrentUser(usersStore.currentUser.user_id)
  }
})

watch(
  () => usersStore.currentUser?.user_id,
  (userId) => {
    if (userId) {
      loadWorkoutsForCurrentUser(userId)
    } else {
      store.workouts = []
    }
  },
)

async function loadWorkoutsForCurrentUser(userId) {
  if (!userId) {
    return
  }

  await store.loadWorkouts(userId)
}

function isOwnedByCurrentUser(row) {
  return Boolean(usersStore.currentUser?.user_id && row?.user_id === usersStore.currentUser.user_id)
}

function sharedRowClass(row) {
  return isOwnedByCurrentUser(row) ? '' : 'bg-info text-white'
}

function isExpanded(row) {
  return expandedWorkoutIds.value.includes(row?.workout_id)
}

function toggleExpanded(row) {
  if (!row?.workout_id) {
    return
  }

  if (isExpanded(row)) {
    expandedWorkoutIds.value = expandedWorkoutIds.value.filter(
      (workoutId) => workoutId !== row.workout_id,
    )
  } else {
    expandedWorkoutIds.value = [...expandedWorkoutIds.value, row.workout_id]
  }
}

function editWorkout(row) {
  editingWorkoutId.value = row.workout_id

  Object.assign(workout, {
    type: row.type || '',
    average_workout_time: row.average_workout_time ?? null,
    calories_burned: row.calories_burned ?? 0,
    share_with_others: Boolean(row.share_with_others),
    is_active: row.is_active !== false,
  })

  showWorkoutForm.value = true
}

function resetWorkoutForm() {
  Object.assign(workout, {
    type: '',
    average_workout_time: null,
    calories_burned: 0,
    share_with_others: false,
    is_active: true,
  })

  editingWorkoutId.value = null
}

function requestDeleteWorkout(row) {
  pendingDeleteWorkout.value = row
  confirmDeleteOpen.value = true
}

function cancelDeleteWorkout() {
  pendingDeleteWorkout.value = null
  confirmDeleteOpen.value = false
}

async function confirmDeleteWorkout() {
  const row = pendingDeleteWorkout.value
  pendingDeleteWorkout.value = null
  confirmDeleteOpen.value = false

  if (!usersStore.currentUser?.user_id || !row?.workout_id) {
    store.error = 'No current user is available.'
    return
  }

  const { error } = await store.deactivateWorkout(usersStore.currentUser.user_id, row.workout_id)
  if (!error) {
    await loadWorkoutsForCurrentUser(usersStore.currentUser.user_id)
  }
}

async function submitWorkout() {
  if (!usersStore.currentUser?.user_id) {
    store.error = 'No current user is available.'
    return
  }

  const savedWorkout = editingWorkoutId.value
    ? await store.updateWorkout(usersStore.currentUser.user_id, editingWorkoutId.value, workout)
    : await store.createWorkout(usersStore.currentUser.user_id, workout)

  if (savedWorkout) {
    resetWorkoutForm()

    showWorkoutForm.value = false
    await loadWorkoutsForCurrentUser(usersStore.currentUser.user_id)
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
