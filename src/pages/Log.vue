<template>
  <q-page class="q-pa-md">
    <div class="row justify-center">
      <div class="col-12 col-md-10 col-lg-8">
        <q-card flat bordered class="q-pa-md">
          <div class="text-h5 q-mb-md">Log</div>

          <q-tabs
            v-model="activeTab"
            align="left"
            dense
            class="text-primary"
            indicator-color="accent"
          >
            <q-tab name="food" label="Food" />
            <q-tab name="workouts" label="Workouts" />
            <q-tab name="suppliments" label="Suppliments" />
            <q-tab name="weight" label="Weight" />
          </q-tabs>

          <q-separator class="q-my-md" />

          <q-tab-panels v-model="activeTab" animated>
            <q-tab-panel name="food" class="q-pa-none">
              <q-banner v-if="foodLogsStore.error" class="bg-negative text-white q-mb-md" rounded>
                {{ foodLogsStore.error }}
              </q-banner>

              <q-banner
                v-else-if="!usersStore.currentUser"
                class="bg-warning text-dark q-mb-md"
                rounded
              >
                Sign in to record food consumption.
              </q-banner>

              <q-form @submit.prevent="submitFoodLog" class="q-gutter-md">
                <q-card flat bordered class="q-pa-md bg-grey-1">
                  <div class="row items-center q-mb-sm">
                    <q-btn
                      flat
                      round
                      dense
                      type="button"
                      :icon="isFoodLogExpanded ? 'expand_more' : 'chevron_right'"
                      @click="isFoodLogExpanded = !isFoodLogExpanded"
                    />
                    <div class="text-subtitle1">Log Food</div>
                  </div>

                  <div v-show="isFoodLogExpanded">
                    <div class="row q-col-gutter-md">
                      <div class="col-12 col-md-6">
                        <q-select
                          v-model="foodLog.food_id"
                          :options="foodOptions"
                          label="Food"
                          filled
                          dense
                          emit-value
                          map-options
                          :disable="!usersStore.currentUser"
                          :rules="[(value) => !!value || 'Food is required']"
                        />
                      </div>

                      <div class="col-12 col-md-3">
                        <q-input
                          v-model="foodLog.servings"
                          type="number"
                          label="Servings"
                          min="0.01"
                          step="0.01"
                          filled
                          dense
                          :disable="!usersStore.currentUser"
                          :rules="[
                            (value) => Number(value) > 0 || 'Servings must be greater than 0',
                          ]"
                        />
                      </div>

                      <div class="col-12 col-md-3">
                        <q-input
                          v-model="foodLog.datetime"
                          type="datetime-local"
                          label="Date and time"
                          filled
                          dense
                          :disable="!usersStore.currentUser"
                        />
                      </div>

                      <div class="col-12 col-md-6">
                        <q-input
                          :model-value="selectedFoodCalories"
                          label="Calories per serving"
                          readonly
                          filled
                          dense
                        />
                      </div>

                      <div class="col-12 col-md-6">
                        <q-input
                          :model-value="entryTotalCalories"
                          label="Total calories"
                          readonly
                          filled
                          dense
                        />
                      </div>
                    </div>

                    <div class="row items-center justify-between q-mt-md">
                      <q-toggle
                        v-model="includeSharedFoods"
                        label="Include shared foods"
                        :disable="!usersStore.currentUser"
                      />
                      <q-btn
                        type="submit"
                        color="primary"
                        label="Add to log"
                        :loading="foodLogsStore.loading"
                        :disable="!usersStore.currentUser"
                      />
                    </div>
                  </div>
                </q-card>
              </q-form>

              <q-card flat bordered class="q-pa-md bg-grey-1 q-mt-md">
                <div class="row items-center q-mb-sm">
                  <div class="col text-subtitle2 text-center">{{ selectedFoodLogDayOfWeek }}</div>
                  <div class="row items-center no-wrap q-gutter-xs">
                    <q-btn flat dense type="button" label="<" @click="goToPreviousFoodLogDate" />
                    <q-input
                      v-model="selectedFoodLogDate"
                      type="date"
                      filled
                      dense
                      style="max-width: 220px"
                    />
                    <q-btn flat dense type="button" label=">" @click="goToNextFoodLogDate" />
                  </div>
                </div>
                <q-markup-table flat bordered dense separator="horizontal">
                  <tbody>
                    <tr>
                      <td style="width: 84%">
                        <q-linear-progress
                          :value="foodLogProgress"
                          color="accent"
                          size="10px"
                          rounded
                        />
                      </td>
                      <td style="width: 16%">
                        <q-chip color="secondary" text-color="white" square>
                          Calories: {{ Math.round(totalLoggedCalories) }} /
                          {{ Math.round(totalCaloriesForPerson || 2000) }}
                        </q-chip>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <q-linear-progress
                          :value="foodProteinProgress"
                          color="green"
                          size="10px"
                          rounded
                        />
                      </td>
                      <td>
                        <q-chip color="secondary" text-color="white" square>
                          Protein: {{ Math.round(totalProteinLoggedToday) }} /
                          {{ Math.round(totalProteinBudgetForToday) }}
                        </q-chip>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <q-linear-progress
                          :value="foodCarbProgress"
                          color="yellow"
                          size="10px"
                          rounded
                        />
                      </td>
                      <td>
                        <q-chip color="secondary" text-color="white" square>
                          Carbs: {{ Math.round(totalCarbsLoggedToday) }} /
                          {{ Math.round(totalCarbBudgetForToday) }}
                        </q-chip>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <q-linear-progress
                          :value="foodFatProgress"
                          color="blue"
                          size="10px"
                          rounded
                        />
                      </td>
                      <td>
                        <q-chip color="secondary" text-color="white" square>
                          Fat: {{ Math.round(totalFatLoggedToday) }} /
                          {{ Math.round(totalFatBudgetForToday) }}
                        </q-chip>
                      </td>
                    </tr>
                  </tbody>
                </q-markup-table>
              </q-card>

              <q-card flat bordered class="q-pa-md bg-grey-1 q-mt-md">
                <div class="row items-center justify-between q-mb-sm">
                  <div class="text-subtitle1">Logged foods</div>
                  <q-chip color="secondary" text-color="white" square>
                    Total logged calories today: {{ Math.round(totalLoggedCalories) }}
                  </q-chip>
                </div>

                <q-table
                  :rows="tableRows"
                  :columns="columns"
                  :pagination="{ rowsPerPage: 50 }"
                  :rows-per-page-options="[20, 50, 200, 0]"
                  row-key="food_log_id"
                  flat
                  bordered
                  dense
                  hide-header
                  :loading="foodLogsStore.loading"
                  no-data-label="No food log records yet."
                >
                  <template #body="props">
                    <q-tr
                      :props="props"
                      :style="!props.row.isToday ? 'background-color: #E8E8E8' : ''"
                    >
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
                  <q-card-section class="text-h6">Delete log entry?</q-card-section>
                  <q-card-section>
                    Delete {{ pendingDeleteRow?.description || 'this entry' }} from your food log?
                  </q-card-section>
                  <q-card-actions align="right">
                    <q-btn flat label="No" color="primary" @click="cancelDelete" />
                    <q-btn label="Yes" color="negative" @click="confirmDelete" />
                  </q-card-actions>
                </q-card>
              </q-dialog>
            </q-tab-panel>

            <q-tab-panel name="workouts" class="q-pa-none">
              <q-banner
                v-if="workoutLogsStore.error"
                class="bg-negative text-white q-mb-md"
                rounded
              >
                {{ workoutLogsStore.error }}
              </q-banner>

              <q-banner
                v-else-if="!usersStore.currentUser"
                class="bg-warning text-dark q-mb-md"
                rounded
              >
                Sign in to record workouts.
              </q-banner>

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
                          (value) =>
                            value === '' || Number(value) >= 0 || 'Time must be 0 or greater',
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

              <q-card flat bordered class="q-pa-md bg-grey-1 q-mt-md">
                <div class="row items-center justify-between q-mb-sm">
                  <div class="text-subtitle1">Logged workouts</div>
                  <q-chip color="secondary" text-color="white" square>
                    Today's calories burned: {{ Math.round(totalWorkoutCaloriesBurnedToday) }}
                  </q-chip>
                </div>

                <q-table
                  :rows="workoutTableRows"
                  :columns="workoutColumns"
                  :pagination="{ rowsPerPage: 50 }"
                  :rows-per-page-options="[20, 50, 200, 0]"
                  row-key="workout_log_id"
                  flat
                  bordered
                  dense
                  hide-header
                  :loading="workoutLogsStore.loading"
                  no-data-label="No workout log records yet."
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
                              @click="requestDeleteWorkoutLog(props.row)"
                            />
                          </div>
                        </div>
                      </q-td>
                    </q-tr>
                  </template>
                </q-table>
              </q-card>

              <q-dialog v-model="confirmDeleteWorkoutLogOpen">
                <q-card style="min-width: 320px">
                  <q-card-section class="text-h6">Delete workout log entry?</q-card-section>
                  <q-card-section>
                    Delete {{ pendingDeleteWorkoutRow?.description || 'this entry' }} from your
                    workout log?
                  </q-card-section>
                  <q-card-actions align="right">
                    <q-btn flat label="No" color="primary" @click="cancelDeleteWorkoutLog" />
                    <q-btn label="Yes" color="negative" @click="confirmDeleteWorkoutLog" />
                  </q-card-actions>
                </q-card>
              </q-dialog>
            </q-tab-panel>

            <q-tab-panel name="suppliments" class="q-pa-none">
              <q-banner
                v-if="supplementLogsStore.error"
                class="bg-negative text-white q-mb-md"
                rounded
              >
                {{ supplementLogsStore.error }}
              </q-banner>

              <q-banner
                v-else-if="!usersStore.currentUser"
                class="bg-warning text-dark q-mb-md"
                rounded
              >
                Sign in to record suppliments.
              </q-banner>

              <q-form @submit.prevent="submitSupplementLog" class="q-gutter-md">
                <q-card flat bordered class="q-pa-md bg-grey-1">
                  <div class="text-subtitle1 q-mb-sm">Log Suppliment</div>
                  <div class="row q-col-gutter-md">
                    <div class="col-12 col-md-6">
                      <q-select
                        v-model="supplementLog.supplement_id"
                        :options="supplementOptions"
                        label="Suppliment"
                        filled
                        dense
                        emit-value
                        map-options
                        :disable="!usersStore.currentUser"
                        :rules="[(value) => !!value || 'Suppliment is required']"
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
                      v-model="includeSharedSuppliments"
                      label="Include shared suppliments"
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

              <q-card flat bordered class="q-pa-md bg-grey-1 q-mt-md">
                <div class="text-subtitle1 q-mb-sm">Logged suppliments</div>

                <q-table
                  :rows="supplementTableRows"
                  :columns="supplementColumns"
                  :pagination="{ rowsPerPage: 50 }"
                  :rows-per-page-options="[20, 50, 200, 0]"
                  row-key="supplement_log_id"
                  flat
                  bordered
                  dense
                  hide-header
                  :loading="supplementLogsStore.loading"
                  no-data-label="No suppliment log records yet."
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
                              @click="requestDeleteSupplementLog(props.row)"
                            />
                          </div>
                        </div>
                      </q-td>
                    </q-tr>
                  </template>
                </q-table>
              </q-card>

              <q-dialog v-model="confirmDeleteSupplementLogOpen">
                <q-card style="min-width: 320px">
                  <q-card-section class="text-h6">Delete suppliment log entry?</q-card-section>
                  <q-card-section>
                    Delete {{ pendingDeleteSupplementRow?.description || 'this entry' }} from your
                    suppliment log?
                  </q-card-section>
                  <q-card-actions align="right">
                    <q-btn flat label="No" color="primary" @click="cancelDeleteSupplementLog" />
                    <q-btn label="Yes" color="negative" @click="confirmDeleteSupplementLog" />
                  </q-card-actions>
                </q-card>
              </q-dialog>
            </q-tab-panel>

            <q-tab-panel name="weight" class="q-pa-none">
              <q-banner v-if="weightLogsStore.error" class="bg-negative text-white q-mb-md" rounded>
                {{ weightLogsStore.error }}
              </q-banner>

              <q-banner
                v-else-if="!usersStore.currentUser"
                class="bg-warning text-dark q-mb-md"
                rounded
              >
                Sign in to record weight.
              </q-banner>

              <q-form @submit.prevent="submitWeightLog" class="q-gutter-md">
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
                          (value) =>
                            value === '' || Number(value) > 0 || 'Weight must be greater than 0',
                        ]"
                      />
                    </div>

                    <div class="col-12 col-md-4">
                      <q-input
                        :model-value="weightLogBodyMassIndex"
                        label="BMI"
                        filled
                        dense
                        readonly
                      />
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

              <q-card flat bordered class="q-pa-md bg-grey-1 q-mt-md">
                <div class="row items-center justify-between q-mb-sm">
                  <div class="text-subtitle1">Weight progress</div>
                  <div class="row items-center q-gutter-sm">
                    <q-chip color="secondary" text-color="white" square>
                      {{ Math.round(weightProgressCurrentValue ?? 0) }} /
                      {{ Math.round(weightProgressGoalValue ?? 0) }}
                    </q-chip>
                    <q-chip color="secondary" text-color="white" square>
                      {{ projectedGoalDateLabel }}
                    </q-chip>
                  </div>
                </div>

                <q-linear-progress
                  :value="weightProgressValue"
                  color="accent"
                  size="10px"
                  rounded
                />
              </q-card>

              <q-card flat bordered class="q-pa-md bg-grey-1 q-mt-md">
                <div class="text-subtitle1 q-mb-sm">Logged weight</div>

                <q-table
                  :rows="weightTableRows"
                  :columns="weightColumns"
                  :pagination="{ rowsPerPage: 50 }"
                  :rows-per-page-options="[20, 50, 200, 0]"
                  row-key="weight_log_id"
                  flat
                  bordered
                  dense
                  hide-header
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
                              @click="requestDeleteWeightLog(props.row)"
                            />
                          </div>
                        </div>
                      </q-td>
                    </q-tr>
                  </template>
                </q-table>
              </q-card>

              <q-dialog v-model="confirmDeleteWeightLogOpen">
                <q-card style="min-width: 320px">
                  <q-card-section class="text-h6">Delete weight log entry?</q-card-section>
                  <q-card-section>
                    Delete {{ pendingDeleteWeightRow?.description || 'this entry' }} from your
                    weight log?
                  </q-card-section>
                  <q-card-actions align="right">
                    <q-btn flat label="No" color="primary" @click="cancelDeleteWeightLog" />
                    <q-btn label="Yes" color="negative" @click="confirmDeleteWeightLog" />
                  </q-card-actions>
                </q-card>
              </q-dialog>
            </q-tab-panel>
          </q-tab-panels>
        </q-card>
      </div>
    </div>
  </q-page>
</template>

<script setup>
import { computed, onMounted, reactive, ref, watch } from 'vue'
import { useUsersStore } from 'stores/users'
import { useFoodsStore } from 'stores/foods'
import { useFoodLogsStore } from 'stores/food-logs'
import { useProfilesStore } from 'stores/profiles'
import { useWorkoutsStore } from 'stores/workouts'
import { useWorkoutLogsStore } from 'stores/workout-logs'
import { useSupplimentsStore } from 'stores/suppliments'
import { useSupplimentsLogStore } from 'stores/suppliments_log'
import { useWeightLogsStore } from 'stores/weight-logs'
import {
  calculateBodyMassIndex,
  calculateFoodCalories,
  calculateTotalCaloriesForPerson,
  calculateTotalDailyCalories,
} from '../utils/rules'

const usersStore = useUsersStore()
const foodsStore = useFoodsStore()
const foodLogsStore = useFoodLogsStore()
const profilesStore = useProfilesStore()
const workoutsStore = useWorkoutsStore()
const workoutLogsStore = useWorkoutLogsStore()
const supplimentsStore = useSupplimentsStore()
const supplementLogsStore = useSupplimentsLogStore()
const weightLogsStore = useWeightLogsStore()
const activeTab = ref('food')
const isFoodLogExpanded = ref(false)
const includeSharedFoods = ref(false)
const includeSharedWorkouts = ref(false)
const includeSharedSuppliments = ref(false)
const selectedFoodLogDate = ref(getCurrentLocalDate())

function getCurrentLocalDateTime() {
  const now = new Date()
  const year = now.getFullYear()
  const month = String(now.getMonth() + 1).padStart(2, '0')
  const day = String(now.getDate()).padStart(2, '0')
  const hours = String(now.getHours()).padStart(2, '0')
  const minutes = String(now.getMinutes()).padStart(2, '0')

  return `${year}-${month}-${day}T${hours}:${minutes}`
}

function getCurrentLocalDate() {
  const now = new Date()
  const year = now.getFullYear()
  const month = String(now.getMonth() + 1).padStart(2, '0')
  const day = String(now.getDate()).padStart(2, '0')

  return `${year}-${month}-${day}`
}

function shiftLocalDate(dateKey, dayDelta) {
  const [yearString, monthString, dayString] = String(dateKey || '').split('-')
  const year = Number(yearString)
  const month = Number(monthString)
  const day = Number(dayString)

  if (!year || !month || !day) {
    return getCurrentLocalDate()
  }

  const shiftedDate = new Date(year, month - 1, day + dayDelta)
  const shiftedYear = shiftedDate.getFullYear()
  const shiftedMonth = String(shiftedDate.getMonth() + 1).padStart(2, '0')
  const shiftedDay = String(shiftedDate.getDate()).padStart(2, '0')

  return `${shiftedYear}-${shiftedMonth}-${shiftedDay}`
}

function goToPreviousFoodLogDate() {
  selectedFoodLogDate.value = shiftLocalDate(selectedFoodLogDate.value, -1)
}

function goToNextFoodLogDate() {
  selectedFoodLogDate.value = shiftLocalDate(selectedFoodLogDate.value, 1)
}

const selectedFoodLogDayOfWeek = computed(() => {
  const [yearString, monthString, dayString] = String(selectedFoodLogDate.value || '').split('-')
  const year = Number(yearString)
  const month = Number(monthString)
  const day = Number(dayString)

  if (!year || !month || !day) {
    return ''
  }

  const selectedDate = new Date(year, month - 1, day)

  if (Number.isNaN(selectedDate.getTime())) {
    return ''
  }

  return selectedDate.toLocaleDateString(undefined, { weekday: 'long' })
})

function getCurrentDayOfWeekKey() {
  const dateKey = selectedFoodLogDate.value || getCurrentLocalDate()
  const [yearString, monthString, dayString] = String(dateKey).split('-')
  const year = Number(yearString)
  const month = Number(monthString)
  const day = Number(dayString)

  if (!year || !month || !day) {
    return 'sunday'
  }

  const dayNames = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday']
  const selectedDate = new Date(year, month - 1, day)

  return dayNames[selectedDate.getDay()] || 'sunday'
}

function getLocalDateKey(value) {
  if (!value) {
    return ''
  }

  const dateValue = new Date(value)
  if (Number.isNaN(dateValue.getTime())) {
    return ''
  }

  const year = dateValue.getFullYear()
  const month = String(dateValue.getMonth() + 1).padStart(2, '0')
  const day = String(dateValue.getDate()).padStart(2, '0')

  return `${year}-${month}-${day}`
}

function formatLocalDateTimeLabel(value) {
  if (!value) {
    return ''
  }

  const dateValue = new Date(value)
  if (Number.isNaN(dateValue.getTime())) {
    return ''
  }

  const year = dateValue.getFullYear()
  const month = String(dateValue.getMonth() + 1).padStart(2, '0')
  const day = String(dateValue.getDate()).padStart(2, '0')
  const hours = String(dateValue.getHours()).padStart(2, '0')
  const minutes = String(dateValue.getMinutes()).padStart(2, '0')

  return `${year}-${month}-${day}   ${hours}:${minutes}`
}

const foodLog = reactive({
  food_id: null,
  servings: 1,
  datetime: getCurrentLocalDateTime(),
})

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

const weightLog = reactive({
  weight: '',
  date: getCurrentLocalDate(),
})

const confirmDeleteOpen = ref(false)
const pendingDeleteRow = ref(null)
const confirmDeleteWorkoutLogOpen = ref(false)
const pendingDeleteWorkoutRow = ref(null)
const confirmDeleteSupplementLogOpen = ref(false)
const pendingDeleteSupplementRow = ref(null)
const confirmDeleteWeightLogOpen = ref(false)
const pendingDeleteWeightRow = ref(null)

const columns = [
  {
    name: 'summary',
    label: 'Summary',
    field: 'summary',
    align: 'right',
  },
]

const workoutColumns = [
  {
    name: 'summary',
    label: 'Summary',
    field: 'summary',
    align: 'right',
  },
]

const supplementColumns = [
  {
    name: 'summary',
    label: 'Summary',
    field: 'summary',
    align: 'right',
  },
]

const weightColumns = [
  {
    name: 'summary',
    label: 'Summary',
    field: 'summary',
    align: 'right',
  },
]

function sortFoodsForOptionList(foods = []) {
  return [...foods].sort((leftFood, rightFood) => {
    const leftIsFavorite = leftFood?.favorite_food ? 1 : 0
    const rightIsFavorite = rightFood?.favorite_food ? 1 : 0

    if (leftIsFavorite !== rightIsFavorite) {
      return rightIsFavorite - leftIsFavorite
    }

    const leftCreatedAt = new Date(leftFood?.created_at || 0).getTime()
    const rightCreatedAt = new Date(rightFood?.created_at || 0).getTime()

    if (leftCreatedAt !== rightCreatedAt) {
      return rightCreatedAt - leftCreatedAt
    }

    return String(leftFood?.description || '').localeCompare(String(rightFood?.description || ''))
  })
}

const foodOptions = computed(() => {
  const allFoods = foodsStore.foods || []
  const currentUserId = usersStore.currentUser?.user_id
  const ownFoods = sortFoodsForOptionList(
    allFoods.filter((food) => String(food?.user_id || '') === String(currentUserId || '')),
  )

  if (!includeSharedFoods.value) {
    return ownFoods.map((food) => ({
      label: food.description,
      value: food.food_id,
    }))
  }

  const sharedFoods = sortFoodsForOptionList(
    allFoods.filter((food) => String(food?.user_id || '') !== String(currentUserId || '')),
  )

  return [...ownFoods, ...sharedFoods].map((food) => ({
    label: food.description,
    value: food.food_id,
  }))
})

const workoutOptions = computed(() => {
  const allWorkouts = workoutsStore.workouts || []
  const currentUserId = usersStore.currentUser?.user_id
  const ownWorkouts = allWorkouts.filter(
    (workout) => String(workout?.user_id || '') === String(currentUserId || ''),
  )

  if (!includeSharedWorkouts.value) {
    return ownWorkouts.map((workout) => ({
      label: workout.type,
      value: workout.workout_id,
    }))
  }

  const sharedWorkouts = allWorkouts.filter(
    (workout) => String(workout?.user_id || '') !== String(currentUserId || ''),
  )

  return [...ownWorkouts, ...sharedWorkouts].map((workout) => ({
    label: workout.type,
    value: workout.workout_id,
  }))
})

const supplementOptions = computed(() => {
  const allSuppliments = supplimentsStore.supplements || []
  const currentUserId = usersStore.currentUser?.user_id
  const ownSuppliments = allSuppliments.filter(
    (supplement) => String(supplement?.user_id || '') === String(currentUserId || ''),
  )

  if (!includeSharedSuppliments.value) {
    return ownSuppliments.map((supplement) => ({
      label: `${supplement.description} (${supplement.serving_size ?? 1} ${supplement.serving_unit || 'other'})`,
      value: supplement.supplement_id,
    }))
  }

  const sharedSuppliments = allSuppliments.filter(
    (supplement) => String(supplement?.user_id || '') !== String(currentUserId || ''),
  )

  return [...ownSuppliments, ...sharedSuppliments].map((supplement) => ({
    label: `${supplement.description} (${supplement.serving_size ?? 1} ${supplement.serving_unit || 'other'})`,
    value: supplement.supplement_id,
  }))
})

const servingUnitOptions = [
  { label: 'Pills', value: 'pills' },
  { label: 'Oz', value: 'oz' },
  { label: 'Scoop', value: 'scoop' },
  { label: 'Glasses', value: 'glasses' },
  { label: 'Other', value: 'other' },
]

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

const selectedFood = computed(() => {
  return (foodsStore.foods || []).find((food) => food.food_id === foodLog.food_id) || null
})

const selectedSupplement = computed(() => {
  return (
    (supplimentsStore.supplements || []).find((supplement) =>
      areSameId(supplement.supplement_id, supplementLog.supplement_id),
    ) || null
  )
})

const currentProfile = computed(() => profilesStore.currentProfile || null)

const latestWeightLogForToday = computed(() => {
  const today = getCurrentLocalDate()

  return (weightLogsStore.logs || []).reduce((latestLog, log) => {
    const dateKey = String(log?.date || '').slice(0, 10)
    if (!dateKey || dateKey > today) {
      return latestLog
    }

    const weight = Number(log?.weight)
    if (!Number.isFinite(weight) || weight <= 0) {
      return latestLog
    }

    if (!latestLog) {
      return log
    }

    const latestDateKey = String(latestLog?.date || '').slice(0, 10)
    if (dateKey > latestDateKey) {
      return log
    }

    return latestLog
  }, null)
})

const oldestWeightLogForToday = computed(() => {
  const today = getCurrentLocalDate()

  return (weightLogsStore.logs || []).reduce((oldestLog, log) => {
    const dateKey = String(log?.date || '').slice(0, 10)
    if (!dateKey || dateKey > today) {
      return oldestLog
    }

    const weight = Number(log?.weight)
    if (!Number.isFinite(weight) || weight <= 0) {
      return oldestLog
    }

    if (!oldestLog) {
      return log
    }

    const oldestDateKey = String(oldestLog?.date || '').slice(0, 10)
    if (dateKey < oldestDateKey) {
      return log
    }

    return oldestLog
  }, null)
})

const weightProgressCurrentValue = computed(() => {
  const loggedWeight = Number(latestWeightLogForToday.value?.weight)
  if (Number.isFinite(loggedWeight) && loggedWeight > 0) {
    return loggedWeight
  }

  const startWeight = Number(currentProfile.value?.start_weight)
  if (Number.isFinite(startWeight) && startWeight > 0) {
    return startWeight
  }

  return null
})

const weightLogBodyMassIndex = computed(() => {
  const enteredWeight = Number(weightLog.weight)
  const latestLoggedWeight = Number(latestWeightLogForToday.value?.weight)
  const startWeight = Number(currentProfile.value?.start_weight)

  let effectiveWeight = null
  if (Number.isFinite(enteredWeight) && enteredWeight > 0) {
    effectiveWeight = enteredWeight
  } else if (Number.isFinite(latestLoggedWeight) && latestLoggedWeight > 0) {
    effectiveWeight = latestLoggedWeight
  } else if (Number.isFinite(startWeight) && startWeight > 0) {
    effectiveWeight = startWeight
  }

  const bmi = calculateBodyMassIndex({
    weight: effectiveWeight,
    height: currentProfile.value?.height,
  })

  return bmi ?? ''
})

const weightProgressGoalValue = computed(() => {
  const goalWeight = Number(currentProfile.value?.goal_weight)
  if (Number.isFinite(goalWeight) && goalWeight > 0) {
    return goalWeight
  }

  return null
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
  ) {
    return 0
  }

  const rawProgress = (currentWeight - startWeight) / (goalWeight - startWeight)
  return Math.min(1, Math.max(0, rawProgress))
})

const projectedGoalDateLabel = computed(() => {
  const profileWeight = Number(currentProfile.value?.start_weight)
  const goalWeight = Number(weightProgressGoalValue.value)
  const currentWeight = Number(weightProgressCurrentValue.value)

  const latestDateText = String(latestWeightLogForToday.value?.date || '').slice(0, 10)
  const oldestDateText = String(oldestWeightLogForToday.value?.date || '').slice(0, 10)

  if (!latestDateText || !oldestDateText) {
    return 'N/A'
  }

  const latestDate = new Date(`${latestDateText}T00:00:00`)
  const oldestDate = new Date(`${oldestDateText}T00:00:00`)

  if (Number.isNaN(latestDate.getTime()) || Number.isNaN(oldestDate.getTime())) {
    return 'N/A'
  }

  if (
    !Number.isFinite(profileWeight) ||
    !Number.isFinite(goalWeight) ||
    !Number.isFinite(currentWeight) ||
    profileWeight === currentWeight
  ) {
    return 'N/A'
  }

  const elapsedDays = (latestDate.getTime() - oldestDate.getTime()) / (1000 * 60 * 60 * 24)
  if (!Number.isFinite(elapsedDays) || elapsedDays < 0) {
    return 'N/A'
  }

  const projectedDays =
    elapsedDays * ((profileWeight - goalWeight) / (profileWeight - currentWeight)) * 1.41

  if (!Number.isFinite(projectedDays)) {
    return 'N/A'
  }

  const projectedDate = new Date(oldestDate)
  projectedDate.setDate(projectedDate.getDate() + Math.round(projectedDays))

  const year = projectedDate.getFullYear()
  const month = String(projectedDate.getMonth() + 1).padStart(2, '0')
  const day = String(projectedDate.getDate()).padStart(2, '0')

  return `${year}-${month}-${day}`
})

const totalDailyCalories = computed(() => {
  const selectedDateKey = selectedFoodLogDate.value || getCurrentLocalDate()

  const latestWeightLogForSelectedFoodDate = (weightLogsStore.logs || []).reduce(
    (latestLog, log) => {
      const dateKey = String(log?.date || '').slice(0, 10)
      const weight = Number(log?.weight)

      if (!dateKey || !Number.isFinite(weight) || weight <= 0 || dateKey > selectedDateKey) {
        return latestLog
      }

      if (!latestLog) {
        return log
      }

      const latestDateKey = String(latestLog?.date || '').slice(0, 10)
      const latestWeightLogId = Number(latestLog?.weight_log_id) || 0
      const currentWeightLogId = Number(log?.weight_log_id) || 0

      if (dateKey > latestDateKey) {
        return log
      }

      if (dateKey === latestDateKey && currentWeightLogId > latestWeightLogId) {
        return log
      }

      return latestLog
    },
    null,
  )

  const resolvedWeight = Number(latestWeightLogForSelectedFoodDate?.weight)
  const weight =
    Number.isFinite(resolvedWeight) && resolvedWeight > 0
      ? resolvedWeight
      : Number(currentProfile.value?.start_weight)

  const calories = calculateTotalDailyCalories({
    weight: Number.isFinite(weight) && weight > 0 ? weight : null,
    height: currentProfile.value?.height,
    age: usersStore.currentUser?.age,
    sex: usersStore.currentUser?.sex,
    activityLevel: currentProfile.value?.activity_level,
  })

  return calories ?? null
})

const totalCaloriesForPerson = computed(() => {
  return calculateTotalCaloriesForPerson({
    totalDailyCalories: totalDailyCalories.value,
    dailyCalorieDeficit: currentProfile.value?.daily_calorie_deficit,
    totalWorkoutCaloriesBurnedToday: totalWorkoutCaloriesBurnedToday.value,
  })
})

const carbBudgetPercentForToday = computed(() => {
  const dayKey = getCurrentDayOfWeekKey()
  return Number(currentProfile.value?.[`${dayKey}_carbs`]) || 175
})

const totalCarbsLoggedToday = computed(() => {
  return (tableRows.value || []).reduce((sum, row) => {
    const food = row.food || {}
    const carbsPerServing = Number(food.carb) || 0
    const servings = Number(row.servings) || 0

    return sum + carbsPerServing * servings
  }, 0)
})

const totalCarbBudgetForToday = computed(() => {
  return (totalCaloriesForPerson.value * carbBudgetPercentForToday.value) / 100 / 4
})

const proteinBudgetPercentForToday = computed(() => {
  const dayKey = getCurrentDayOfWeekKey()
  return Number(currentProfile.value?.[`${dayKey}_protein`]) || 0
})

const fatBudgetPercentForToday = computed(() => {
  const dayKey = getCurrentDayOfWeekKey()
  return Number(currentProfile.value?.[`${dayKey}_fat`]) || 0
})

const totalProteinLoggedToday = computed(() => {
  return (tableRows.value || []).reduce((sum, row) => {
    const food = row.food || {}
    const proteinPerServing = Number(food.protein) || 0
    const servings = Number(row.servings) || 0

    return sum + proteinPerServing * servings
  }, 0)
})

const totalProteinBudgetForToday = computed(() => {
  return (totalCaloriesForPerson.value * proteinBudgetPercentForToday.value) / 100 / 4
})

const totalFatLoggedToday = computed(() => {
  return (tableRows.value || []).reduce((sum, row) => {
    const food = row.food || {}
    const fatPerServing = Number(food.fat) || 0
    const servings = Number(row.servings) || 0

    return sum + fatPerServing * servings
  }, 0)
})

const totalFatBudgetForToday = computed(() => {
  return (totalCaloriesForPerson.value * fatBudgetPercentForToday.value) / 100 / 9
})

const selectedFoodCalories = computed(() => {
  if (!selectedFood.value) {
    return 0
  }

  return calculateFoodCalories({
    carbs: selectedFood.value.carb,
    protein: selectedFood.value.protein,
    fat: selectedFood.value.fat,
    extraCalories: selectedFood.value.calories_extra,
  })
})

const entryTotalCalories = computed(() => {
  const servings = Number(foodLog.servings)
  if (!Number.isFinite(servings) || servings <= 0) {
    return 0
  }

  return Math.round(selectedFoodCalories.value * servings)
})

const tableRows = computed(() => {
  const selectedDate = selectedFoodLogDate.value || getCurrentLocalDate()

  return (foodLogsStore.logs || [])
    .filter((log) => getLocalDateKey(log.datetime) === selectedDate)
    .map((log) => {
      const food = log.food || {}
      const perServingCalories = calculateFoodCalories({
        carbs: food.carb,
        protein: food.protein,
        fat: food.fat,
        extraCalories: food.calories_extra,
      })

      const servings = Number(log.servings) || 0
      const foodServingSize = Number(food.serving_size) || 1
      const foodServingUnit = food.serving_unit || 'other'
      const logDate = getLocalDateKey(log.datetime)
      const logDateTimeLabel = formatLocalDateTimeLabel(log.datetime)

      return {
        ...log,
        description: food.description || `Food #${log.food_id}`,
        servingsLabel: servings.toFixed(2),
        totalCalories: Math.round(perServingCalories * servings),
        isToday: logDate === selectedDate,
        summary: `${food.description || `Food #${log.food_id}`} | ${foodServingSize} ${foodServingUnit} | ${servings.toFixed(2)} | ${Math.round(perServingCalories * servings)} | ${logDateTimeLabel}`,
      }
    })
})

const totalLoggedCalories = computed(() => {
  return tableRows.value.reduce((sum, row) => sum + (Number(row.totalCalories) || 0), 0)
})

const foodLogProgress = computed(() => {
  if (!totalCaloriesForPerson.value) {
    return 0
  }

  return Math.min(1, totalLoggedCalories.value / totalCaloriesForPerson.value)
})

const foodCarbProgress = computed(() => {
  if (!totalCarbBudgetForToday.value) {
    return 0
  }

  return Math.min(1, totalCarbsLoggedToday.value / totalCarbBudgetForToday.value)
})

const foodProteinProgress = computed(() => {
  if (!totalProteinBudgetForToday.value) {
    return 0
  }

  return Math.min(1, totalProteinLoggedToday.value / totalProteinBudgetForToday.value)
})

const foodFatProgress = computed(() => {
  if (!totalFatBudgetForToday.value) {
    return 0
  }

  return Math.min(1, totalFatLoggedToday.value / totalFatBudgetForToday.value)
})

const workoutTableRows = computed(() => {
  return (workoutLogsStore.logs || []).map((log) => {
    const workout = log.workout || {}
    const workoutLabel = workout.type || `Workout #${log.workout_id}`
    const workoutTime = log.workout_time ?? workout.average_workout_time ?? 'N/A'
    const workoutCaloriesBurned = Number(log.calories_burned) || 0

    return {
      ...log,
      description: workoutLabel,
      summary: `${workoutLabel} | ${workoutTime} (minutes) | ${workoutCaloriesBurned} (calories burned) | ${log.date || ''}`,
    }
  })
})

const totalWorkoutCaloriesBurnedToday = computed(() => {
  const today = getCurrentLocalDate()

  return (workoutLogsStore.logs || []).reduce((sum, log) => {
    const logDate = String(log?.date || '').slice(0, 10)
    if (logDate !== today) {
      return sum
    }

    return sum + (Number(log?.calories_burned) || 0)
  }, 0)
})

const workoutTotalCaloriesBurned = computed(() => {
  const selected = selectedWorkout.value
  if (!selected) {
    return 0
  }

  const workoutTime = Number(workoutLog.workout_time)
  const averageWorkoutTime = Number(selected.average_workout_time)
  const caloriesBurned = Number(selected.calories_burned)

  if (
    !Number.isFinite(workoutTime) ||
    workoutTime < 0 ||
    !Number.isFinite(averageWorkoutTime) ||
    averageWorkoutTime <= 0 ||
    !Number.isFinite(caloriesBurned) ||
    caloriesBurned < 0
  ) {
    return 0
  }

  return Math.round((workoutTime / averageWorkoutTime) * caloriesBurned)
})

const supplementTableRows = computed(() => {
  return [...(supplementLogsStore.logs || [])]
    .sort((leftLog, rightLog) => {
      const leftDate = String(leftLog?.date || '')
      const rightDate = String(rightLog?.date || '')

      if (leftDate !== rightDate) {
        return rightDate.localeCompare(leftDate)
      }

      const leftDescription = String(leftLog?.supplement?.description || '').toLowerCase()
      const rightDescription = String(rightLog?.supplement?.description || '').toLowerCase()

      return leftDescription.localeCompare(rightDescription)
    })
    .map((log) => {
      const supplement = log.supplement || {}
      const label = supplement.description || `Suppliment #${log.supplement_id}`
      const servings = Number(log.servings) || 0
      const servingType = supplement.serving_unit || 'other'

      return {
        ...log,
        description: label,
        summary: `${label} | ${servings.toFixed(2)} | ${servingType} | ${log.date || ''}`,
      }
    })
})

const weightTableRows = computed(() => {
  return [...(weightLogsStore.logs || [])]
    .sort((leftLog, rightLog) => {
      const leftDate = String(leftLog?.date || '')
      const rightDate = String(rightLog?.date || '')

      if (leftDate !== rightDate) {
        return rightDate.localeCompare(leftDate)
      }

      const leftWeight = Number(leftLog?.weight) || 0
      const rightWeight = Number(rightLog?.weight) || 0

      return rightWeight - leftWeight
    })
    .map((log) => {
      const weightValue = Number(log.weight) || 0
      const bmiValue = Number(log.bmi)
      const bmiLabel = Number.isFinite(bmiValue) && bmiValue > 0 ? bmiValue.toFixed(2) : 'N/A'

      return {
        ...log,
        description: weightValue.toFixed(2),
        summary: `${weightValue.toFixed(2)} | ${bmiLabel} | ${log.date || ''}`,
      }
    })
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

    foodsStore.foods = []
    foodLogsStore.logs = []
    profilesStore.currentProfile = null
    workoutsStore.workouts = []
    workoutLogsStore.logs = []
    supplimentsStore.supplements = []
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
    foodsStore.loadFoods(userId),
    foodLogsStore.loadFoodLogs(userId),
    profilesStore.loadCurrentProfile(userId),
    workoutsStore.loadWorkouts(userId),
    workoutLogsStore.loadWorkoutLogs(userId),
    supplimentsStore.loadSupplements(userId),
    supplementLogsStore.loadSupplementLogs(userId),
    weightLogsStore.loadWeightLogs(userId),
  ])
}

function toIsoDateTime(localDateTime) {
  if (!localDateTime) {
    return null
  }

  const parsed = new Date(localDateTime)
  if (Number.isNaN(parsed.getTime())) {
    return null
  }

  return parsed.toISOString()
}

async function submitFoodLog() {
  if (!usersStore.currentUser?.user_id) {
    foodLogsStore.error = 'No current user is available.'
    return
  }

  const payload = {
    food_id: foodLog.food_id,
    servings: foodLog.servings,
  }

  const isoDateTime = toIsoDateTime(foodLog.datetime)
  if (foodLog.datetime && !isoDateTime) {
    foodLogsStore.error = 'Please enter a valid date and time.'
    return
  }

  if (isoDateTime) {
    payload.datetime = isoDateTime
  }

  const saved = await foodLogsStore.createFoodLog(usersStore.currentUser.user_id, payload)
  if (saved) {
    foodLog.servings = 1
    foodLog.datetime = getCurrentLocalDateTime()
    await foodLogsStore.loadFoodLogs(usersStore.currentUser.user_id)
  }
}

async function submitWorkoutLog() {
  if (!usersStore.currentUser?.user_id) {
    workoutLogsStore.error = 'No current user is available.'
    return
  }

  const payload = {
    workout_id: workoutLog.workout_id,
    workout_time: workoutLog.workout_time,
    calories_burned: workoutTotalCaloriesBurned.value,
    date: workoutLog.date,
  }

  const saved = await workoutLogsStore.createWorkoutLog(usersStore.currentUser.user_id, payload)
  if (saved) {
    workoutLog.workout_time = selectedWorkout.value?.average_workout_time ?? null
    workoutLog.date = getCurrentLocalDate()
    await workoutLogsStore.loadWorkoutLogs(usersStore.currentUser.user_id)
  }
}

async function submitSupplementLog() {
  if (!usersStore.currentUser?.user_id) {
    supplementLogsStore.error = 'No current user is available.'
    return
  }

  const payload = {
    supplement_id: supplementLog.supplement_id,
    servings: supplementLog.servings,
    serving_unit: supplementLog.serving_unit,
    date: supplementLog.date,
  }

  const saved = await supplementLogsStore.createSupplementLog(
    usersStore.currentUser.user_id,
    payload,
  )
  if (saved) {
    supplementLog.servings = 1
    supplementLog.serving_unit = selectedSupplement.value?.serving_unit || 'other'
    supplementLog.date = getCurrentLocalDate()
    await supplementLogsStore.loadSupplementLogs(usersStore.currentUser.user_id)
  }
}

async function submitWeightLog() {
  if (!usersStore.currentUser?.user_id) {
    weightLogsStore.error = 'No current user is available.'
    return
  }

  const payload = {
    weight: weightLog.weight,
    bmi: weightLogBodyMassIndex.value,
    date: weightLog.date,
  }

  const saved = await weightLogsStore.createWeightLog(usersStore.currentUser.user_id, payload)
  if (saved) {
    weightLog.weight = ''
    weightLog.date = getCurrentLocalDate()
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

  if (!usersStore.currentUser?.user_id || !row?.food_log_id) {
    foodLogsStore.error = 'No current user is available.'
    return
  }

  const { error } = await foodLogsStore.deleteFoodLog(
    usersStore.currentUser.user_id,
    row.food_log_id,
  )
  if (!error) {
    await foodLogsStore.loadFoodLogs(usersStore.currentUser.user_id)
  }
}

function requestDeleteWorkoutLog(row) {
  pendingDeleteWorkoutRow.value = row
  confirmDeleteWorkoutLogOpen.value = true
}

function cancelDeleteWorkoutLog() {
  pendingDeleteWorkoutRow.value = null
  confirmDeleteWorkoutLogOpen.value = false
}

async function confirmDeleteWorkoutLog() {
  const row = pendingDeleteWorkoutRow.value
  pendingDeleteWorkoutRow.value = null
  confirmDeleteWorkoutLogOpen.value = false

  if (!usersStore.currentUser?.user_id || !row?.workout_log_id) {
    workoutLogsStore.error = 'No current user is available.'
    return
  }

  const { error } = await workoutLogsStore.deleteWorkoutLog(
    usersStore.currentUser.user_id,
    row.workout_log_id,
  )
  if (!error) {
    await workoutLogsStore.loadWorkoutLogs(usersStore.currentUser.user_id)
  }
}

function requestDeleteSupplementLog(row) {
  pendingDeleteSupplementRow.value = row
  confirmDeleteSupplementLogOpen.value = true
}

function cancelDeleteSupplementLog() {
  pendingDeleteSupplementRow.value = null
  confirmDeleteSupplementLogOpen.value = false
}

async function confirmDeleteSupplementLog() {
  const row = pendingDeleteSupplementRow.value
  pendingDeleteSupplementRow.value = null
  confirmDeleteSupplementLogOpen.value = false

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

function requestDeleteWeightLog(row) {
  pendingDeleteWorkoutRow.value = null
  pendingDeleteSupplementRow.value = null
  pendingDeleteRow.value = null
  pendingDeleteWeightRow.value = row
  confirmDeleteWeightLogOpen.value = true
}

function cancelDeleteWeightLog() {
  pendingDeleteWeightRow.value = null
  confirmDeleteWeightLogOpen.value = false
}

async function confirmDeleteWeightLog() {
  const row = pendingDeleteWeightRow.value
  pendingDeleteWeightRow.value = null
  confirmDeleteWeightLogOpen.value = false

  if (!usersStore.currentUser?.user_id || !row?.weight_log_id) {
    weightLogsStore.error = 'No current user is available.'
    return
  }

  const { error } = await weightLogsStore.deleteWeightLog(
    usersStore.currentUser.user_id,
    row.weight_log_id,
  )

  if (!error) {
    await weightLogsStore.loadWeightLogs(usersStore.currentUser.user_id)
  }
}
</script>
