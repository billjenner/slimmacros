<template>
  <component :is="embedded ? 'div' : 'q-page'" :class="!embedded ? 'q-pa-md' : ''">
    <div :class="!embedded ? 'row justify-center' : ''">
      <div :class="!embedded ? 'col-12 col-md-10 col-lg-8' : ''">
        <component
          :is="embedded ? 'div' : 'q-card'"
          :flat="!embedded"
          :bordered="!embedded"
          :class="!embedded ? 'q-pa-md' : ''"
        >
          <div class="row items-center justify-between q-mx-md q-mb-md">
            <div class="text-h5">Profile</div>
            <q-btn to="/change-password" label="Change Password" color="secondary" flat />
          </div>

          <q-banner v-if="store.error" class="bg-negative text-white q-mb-md" rounded>
            {{ store.error }}
          </q-banner>

          <q-banner
            v-else-if="!usersStore.currentUser"
            class="bg-warning text-dark q-mb-md"
            rounded
          >
          </q-banner>

          <q-form @submit.prevent="saveProfile" class="q-gutter-md">
            <q-card flat bordered class="q-pa-md bg-grey-1">
              <div class="text-subtitle1 q-mb-sm">User details</div>
              <div class="row q-col-gutter-md">
                <div class="col-12 col-md-4">
                  <q-input v-model="profile.fname" label="First name" filled dense />
                </div>

                <div class="col-12 col-md-4">
                  <q-input v-model="profile.lname" label="Last name" filled dense />
                </div>

                <div class="col-12 col-md-4">
                  <q-select
                    v-model="profile.sex"
                    label="Sex"
                    :options="sexOptions"
                    :class="{ 'required-field-warning': !profile.sex }"
                    :rules="[(value) => !!value || 'Sex is required']"
                    lazy-rules="ondemand"
                    emit-value
                    map-options
                    filled
                    dense
                  />
                </div>

                <div class="col-12 col-md-4">
                  <q-input
                    v-model="profile.age"
                    type="number"
                    label="Age"
                    min="0"
                    :class="{ 'required-field-warning': !isValidProfileNumber(profile.age) }"
                    :rules="[
                      (value) => hasValue(value) || 'Age is required',
                      (value) => isValidProfileNumber(value) || 'Enter a non-negative whole number',
                    ]"
                    lazy-rules="ondemand"
                    filled
                    dense
                  />
                </div>
              </div>
            </q-card>

            <q-card flat bordered class="q-pa-md bg-grey-1">
              <div class="text-subtitle1 q-mb-sm">Body</div>
              <div class="row q-col-gutter-md">
                <div class="col-12 col-md-6">
                  <q-input
                    v-model="profile.start_weight"
                    type="number"
                    label="Start weight (lbs)"
                    min="0"
                    step="0.1"
                    :class="{
                      'required-field-warning': !isValidProfileNumber(profile.start_weight, 1),
                    }"
                    :rules="[
                      (value) => hasValue(value) || 'Start weight is required',
                      (value) =>
                        isValidProfileNumber(value, 1) ||
                        'Enter a non-negative number in 0.1 increments',
                    ]"
                    lazy-rules="ondemand"
                    filled
                    dense
                  />
                </div>

                <div class="col-12 col-md-6">
                  <q-input
                    v-model="profile.goal_weight"
                    type="number"
                    label="Goal weight (lbs)"
                    min="0"
                    step="1.0"
                    :class="{
                      'required-field-warning': !isValidProfileNumber(profile.goal_weight),
                    }"
                    :rules="[
                      (value) => hasValue(value) || 'Goal weight is required',
                      (value) => isValidProfileNumber(value) || 'Enter a non-negative whole number',
                    ]"
                    lazy-rules="ondemand"
                    filled
                    dense
                  />
                </div>

                <div class="col-12 col-md-6">
                  <q-input
                    v-model="profile.height"
                    type="number"
                    label="Height (inches)"
                    min="0"
                    step="1.0"
                    :class="{ 'required-field-warning': !isValidProfileNumber(profile.height) }"
                    :rules="[
                      (value) => hasValue(value) || 'Height is required',
                      (value) => isValidProfileNumber(value) || 'Enter a non-negative whole number',
                    ]"
                    lazy-rules="ondemand"
                    filled
                    dense
                  />
                </div>

                <div class="col-12 col-md-6">
                  <q-select
                    v-model="profile.activity_level"
                    :options="activityLevelOptions"
                    label="Activity level"
                    :class="{ 'required-field-warning': !profile.activity_level }"
                    :rules="[(value) => !!value || 'Activity level is required']"
                    lazy-rules="ondemand"
                    filled
                    dense
                    emit-value
                    map-options
                    clearable
                  />
                </div>
              </div>
            </q-card>

            <q-card flat bordered class="q-pa-md bg-grey-1">
              <div class="text-subtitle1 q-mb-sm">Nutrition targets</div>
              <div v-if="!nutritionEnabled && !loading" class="text-caption q-mb-sm">
                Complete the required User details and Body fields to edit nutrition.
              </div>
              <div class="row q-col-gutter-md">
                <div class="col-12 col-md-6">
                  <q-input
                    :model-value="totalDailyCalories"
                    label="Total daily calories"
                    filled
                    dense
                    readonly
                  />
                </div>

                <div class="col-12 col-md-6">
                  <q-input :model-value="bodyMassIndex" label="BMI" filled dense readonly />
                </div>

                <div class="col-12 col-md-6">
                  <q-input
                    ref="dailyCalorieDeficitInput"
                    v-model="profile.daily_calorie_deficit"
                    type="number"
                    label="Daily calorie deficit"
                    min="0"
                    :class="{
                      'required-field-warning':
                        nutritionEnabled && !isValidProfileNumber(profile.daily_calorie_deficit),
                    }"
                    :rules="[
                      (value) => hasValue(value) || 'Daily calorie deficit is required',
                      (value) => isValidProfileNumber(value) || 'Enter a non-negative whole number',
                    ]"
                    lazy-rules="ondemand"
                    filled
                    dense
                    :disable="!nutritionEnabled"
                  />
                </div>

                <div class="col-12 col-md-6">
                  <q-select
                    v-model="profile.diet_type"
                    :options="dietTypeOptions"
                    label="Diet type"
                    :class="{ 'required-field-warning': nutritionEnabled && !profile.diet_type }"
                    :rules="[(value) => !!value || 'Diet type is required']"
                    lazy-rules="ondemand"
                    filled
                    dense
                    emit-value
                    map-options
                    clearable
                    :disable="!nutritionEnabled"
                    @update:model-value="onDietTypeChange"
                  />
                </div>
              </div>
            </q-card>

            <q-card flat bordered class="q-pa-md bg-grey-1">
              <div class="row items-center justify-between q-mb-sm">
                <div class="text-subtitle1">
                  Nutrition Budget Plan - Macros split by day of the week
                </div>
                <q-btn
                  label="Load template"
                  :color="highlightLoadTemplate ? 'warning' : 'secondary'"
                  :text-color="highlightLoadTemplate ? 'primary' : undefined"
                  :flat="!highlightLoadTemplate"
                  :disable="!nutritionEnabled || !profile.diet_type"
                  @click="loadMacroTemplate"
                />
              </div>
              <div v-for="day in dayGroups" :key="day.key" class="q-mb-md">
                <div class="text-weight-medium q-mb-sm">{{ day.label }}</div>
                <div class="row q-col-gutter-md">
                  <div v-for="field in day.fields" :key="field.key" class="col-12 col-md-4">
                    <q-input
                      v-model="profile[field.key]"
                      type="number"
                      min="0"
                      max="100"
                      step="1"
                      :label="field.label"
                      filled
                      dense
                      hint="0 to 100"
                      :disable="!nutritionEnabled"
                    />
                  </div>
                </div>
              </div>
            </q-card>

            <div class="row justify-end q-gutter-sm">
              <q-btn
                flat
                label="Reload"
                color="secondary"
                :loading="loading"
                @click="loadProfile"
              />
              <q-btn
                type="submit"
                color="primary"
                class="q-mr-md q-mb-md"
                label="Save profile"
                :loading="loading"
                :disable="!usersStore.currentUser"
              />
            </div>
          </q-form>
          <q-dialog v-model="showDietTypeDialog">
            <q-card>
              <q-card-section class="text-h6">Load Template</q-card-section>
              <q-card-section>
                <div>
                  <strong>Load Template</strong> will update your macro values for each day of the
                  week based on "{{ selectedDietType }}".
                </div>
                <div class="q-mt-md">You can always adjust the values manually if needed.</div>
              </q-card-section>
              <q-card-actions align="right">
                <q-btn v-close-popup flat label="OK" color="primary" />
              </q-card-actions>
            </q-card>
          </q-dialog>
        </component>
      </div>
    </div>
  </component>
</template>

<script setup>
import { computed, nextTick, onMounted, reactive, ref, watch } from 'vue'
import { useQuasar } from 'quasar'
import { useUsersStore } from 'stores/users'
import { useProfileStore } from 'stores/profile'
import {
  calculateBodyMassIndex,
  calculateTotalDailyCalories,
  hasMissingMacroFields,
  hasRequiredProfileDetails,
  hasValue,
  isValidProfileNumber,
  shouldHighlightLoadTemplate,
} from '../utils/rules'
import { notifySuccess } from '../utils/notify'
import macroTemplates from '../components/macros.json'

defineProps({
  embedded: {
    type: Boolean,
    default: false,
  },
})

const usersStore = useUsersStore()
const store = useProfileStore()
const $q = useQuasar()
const loading = ref(false)
const dailyCalorieDeficitInput = ref(null)
const showDietTypeDialog = ref(false)
const selectedDietType = ref('')

const dietTypeOptions = [
  { label: 'Balanced', value: 'Balanced' },
  { label: 'Low Carb', value: 'Low Carb' },
  { label: 'High Protein', value: 'High Protein' },
  { label: 'Carb Cycling', value: 'Carb Cycling' },
  { label: 'Custom', value: 'Custom' },
]

const activityLevelOptions = [
  { label: 'Sedentary', value: 'Sedentary' },
  { label: 'Lightly active', value: 'LightlyActive' },
  { label: 'Moderately active', value: 'ModeratelyActive' },
  { label: 'Very active', value: 'VeryActive' },
  { label: 'Extremely active', value: 'ExtremelyActive' },
]

const sexOptions = [
  { label: 'Male', value: 'M' },
  { label: 'Female', value: 'F' },
]

const dayGroups = [
  {
    key: 'sunday',
    label: 'Sunday',
    fields: [
      { key: 'sunday_protein', label: 'Protein %' },
      { key: 'sunday_carbs', label: 'Carbs %' },
      { key: 'sunday_fat', label: 'Fat %' },
    ],
  },
  {
    key: 'monday',
    label: 'Monday',
    fields: [
      { key: 'monday_protein', label: 'Protein %' },
      { key: 'monday_carbs', label: 'Carbs %' },
      { key: 'monday_fat', label: 'Fat %' },
    ],
  },
  {
    key: 'tuesday',
    label: 'Tuesday',
    fields: [
      { key: 'tuesday_protein', label: 'Protein %' },
      { key: 'tuesday_carbs', label: 'Carbs %' },
      { key: 'tuesday_fat', label: 'Fat %' },
    ],
  },
  {
    key: 'wednesday',
    label: 'Wednesday',
    fields: [
      { key: 'wednesday_protein', label: 'Protein %' },
      { key: 'wednesday_carbs', label: 'Carbs %' },
      { key: 'wednesday_fat', label: 'Fat %' },
    ],
  },
  {
    key: 'thursday',
    label: 'Thursday',
    fields: [
      { key: 'thursday_protein', label: 'Protein %' },
      { key: 'thursday_carbs', label: 'Carbs %' },
      { key: 'thursday_fat', label: 'Fat %' },
    ],
  },
  {
    key: 'friday',
    label: 'Friday',
    fields: [
      { key: 'friday_protein', label: 'Protein %' },
      { key: 'friday_carbs', label: 'Carbs %' },
      { key: 'friday_fat', label: 'Fat %' },
    ],
  },
  {
    key: 'saturday',
    label: 'Saturday',
    fields: [
      { key: 'saturday_protein', label: 'Protein %' },
      { key: 'saturday_carbs', label: 'Carbs %' },
      { key: 'saturday_fat', label: 'Fat %' },
    ],
  },
]

const profile = reactive({
  fname: '',
  lname: '',
  sex: '',
  age: '0',
  start_weight: null,
  goal_weight: null,
  height: null,
  activity_level: null,
  daily_calorie_deficit: 0,
  diet_type: null,
  is_active: true,
  sunday_protein: null,
  sunday_carbs: null,
  sunday_fat: null,
  monday_protein: null,
  monday_carbs: null,
  monday_fat: null,
  tuesday_protein: null,
  tuesday_carbs: null,
  tuesday_fat: null,
  wednesday_protein: null,
  wednesday_carbs: null,
  wednesday_fat: null,
  thursday_protein: null,
  thursday_carbs: null,
  thursday_fat: null,
  friday_protein: null,
  friday_carbs: null,
  friday_fat: null,
  saturday_protein: null,
  saturday_carbs: null,
  saturday_fat: null,
})

const currentUserId = computed(() => usersStore.currentUser?.user_id || null)
const nutritionEnabled = computed(
  () => Boolean(currentUserId.value) && !loading.value && hasRequiredProfileDetails(profile),
)
const highlightLoadTemplate = computed(() => shouldHighlightLoadTemplate(profile, dayGroups))

watch(
  () => hasRequiredProfileDetails(profile),
  async (complete, wasComplete) => {
    if (!complete || wasComplete || !nutritionEnabled.value) return
    await nextTick()
    if (nutritionEnabled.value) dailyCalorieDeficitInput.value?.focus()
  },
  { flush: 'sync' },
)

const totalDailyCalories = computed(() => {
  const calories = calculateTotalDailyCalories({
    sex: profile.sex,
    age: profile.age,
    weight: profile.start_weight,
    height: profile.height,
    activityLevel: profile.activity_level,
  })

  return calories ?? ''
})

const bodyMassIndex = computed(() => {
  const bmi = calculateBodyMassIndex({
    weight: profile.start_weight,
    height: profile.height,
  })

  return bmi ?? ''
})

function onDietTypeChange(value) {
  if (value) {
    selectedDietType.value = value
    showDietTypeDialog.value = true
  }
}

function loadMacroTemplate() {
  const selectedTemplate = macroTemplates[profile.diet_type]
  if (!selectedTemplate) {
    return
  }

  dayGroups.forEach((day) => {
    const dayTemplate = selectedTemplate[day.label]
    if (!dayTemplate) {
      return
    }

    day.fields.forEach((field) => {
      if (field.key.endsWith('_protein')) {
        profile[field.key] = dayTemplate.Protein ?? null
      } else if (field.key.endsWith('_carbs')) {
        profile[field.key] = dayTemplate.Carbs ?? null
      } else if (field.key.endsWith('_fat')) {
        profile[field.key] = dayTemplate.Fat ?? null
      }
    })
  })
}

function syncUserDetails() {
  profile.fname = usersStore.currentUser?.fname || ''
  profile.lname = usersStore.currentUser?.lname || ''
  profile.sex = usersStore.currentUser?.sex || ''
}

async function loadProfile() {
  if (currentUserId.value) loading.value = true
  syncUserDetails()

  if (!currentUserId.value) {
    store.currentProfile = null
    profile.sex = null
    profile.age = 0
    profile.start_weight = null
    profile.goal_weight = null
    profile.height = null
    profile.activity_level = null
    profile.daily_calorie_deficit = 0
    profile.diet_type = null
    dayGroups.forEach((day) => {
      day.fields.forEach((field) => {
        profile[field.key] = null
      })
    })
    return
  }

  const data = await store.loadCurrentProfile(currentUserId.value)
  profile.fname = data?.fname ?? ''
  profile.lname = data?.lname ?? ''
  profile.sex = data?.sex ?? null
  profile.age = data?.age ?? null
  profile.start_weight = data?.start_weight ?? null
  profile.goal_weight = data?.goal_weight ?? null
  profile.height = data?.height ?? null
  profile.activity_level = data?.activity_level ?? null
  profile.daily_calorie_deficit = data ? data.daily_calorie_deficit : 0
  profile.diet_type = data?.diet_type ?? null
  dayGroups.forEach((day) => {
    day.fields.forEach((field) => {
      profile[field.key] = data?.[field.key] ?? null
    })
  })
  loading.value = false
}

function validateDailyMacros() {
  for (const day of dayGroups) {
    const [proteinKey, carbsKey, fatKey] = day.fields.map((field) => field.key)
    const protein = profile[proteinKey]
    const carbs = profile[carbsKey]
    const fat = profile[fatKey]

    if (hasMissingMacroFields(profile, day.fields)) {
      return `${day.label}: protein, carbs, and fat are required.`
    }

    const total = Number(protein) + Number(carbs) + Number(fat)
    if (Math.abs(total - 100) > 0.01) {
      return `${day.label}: protein, carbs, and fat must add up to 100% (currently ${total}%).`
    }
  }

  return null
}

async function saveProfile() {
  const userId = currentUserId.value
  if (!userId) {
    return
  }

  const validationError = validateDailyMacros()
  if (validationError) {
    store.error = validationError
    notifySuccess($q, validationError, { color: 'negative' })
    notifySuccess($q, 'If necessary - LOAD TEMPLATE', { color: 'warning', textColor: 'primary' })
    return
  }

  if (Number(profile.daily_calorie_deficit) === 0) {
    const confirmed = await new Promise((resolve) => {
      $q.dialog({
        title: 'Zero calorie deficit',
        message: 'Your daily calorie deficit is 0. Are you sure you want to save?',
        cancel: true,
        ok: { label: 'Save profile', color: 'warning', unelevated: true },
        persistent: true,
      })
        .onOk(() => resolve(true))
        .onCancel(() => resolve(false))
        .onDismiss(() => resolve(false))
    })
    if (!confirmed || currentUserId.value !== userId) return
  }

  store.error = null
  loading.value = true
  const savedProfile = await store.saveProfile(userId, {
    fname: profile.fname,
    lname: profile.lname,
    sex: profile.sex,
    age: profile.age,
    start_weight: profile.start_weight,
    goal_weight: profile.goal_weight,
    height: profile.height,
    activity_level: profile.activity_level,
    daily_calorie_deficit: profile.daily_calorie_deficit,
    diet_type: profile.diet_type,
    is_active: true,
    sunday_protein: profile.sunday_protein,
    sunday_carbs: profile.sunday_carbs,
    sunday_fat: profile.sunday_fat,
    monday_protein: profile.monday_protein,
    monday_carbs: profile.monday_carbs,
    monday_fat: profile.monday_fat,
    tuesday_protein: profile.tuesday_protein,
    tuesday_carbs: profile.tuesday_carbs,
    tuesday_fat: profile.tuesday_fat,
    wednesday_protein: profile.wednesday_protein,
    wednesday_carbs: profile.wednesday_carbs,
    wednesday_fat: profile.wednesday_fat,
    thursday_protein: profile.thursday_protein,
    thursday_carbs: profile.thursday_carbs,
    thursday_fat: profile.thursday_fat,
    friday_protein: profile.friday_protein,
    friday_carbs: profile.friday_carbs,
    friday_fat: profile.friday_fat,
    saturday_protein: profile.saturday_protein,
    saturday_carbs: profile.saturday_carbs,
    saturday_fat: profile.saturday_fat,
  })
  loading.value = false

  if (savedProfile) {
    notifySuccess($q, 'Profile saved successfully.', { color: 'positive' })
  }
}

watch(
  () => usersStore.currentUser?.user_id,
  (userId, previousUserId) => {
    if (userId !== previousUserId) {
      loadProfile()
    }
  },
)

onMounted(() => {
  loadProfile()
})
</script>

<style scoped>
.required-field-warning :deep(.q-field__control) {
  outline: 2px solid var(--q-warning);
  outline-offset: -2px;
}
</style>
