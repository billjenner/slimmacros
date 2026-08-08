<template>
  <q-page class="q-pa-md">
    <div class="row justify-center">
      <div class="col-12 col-md-10 col-lg-8">
        <q-card flat bordered class="q-pa-md">
          <div class="text-h5 q-mb-md">Profiles</div>

          <q-banner v-if="store.error" class="bg-negative text-white q-mb-md" rounded>
            {{ store.error }}
          </q-banner>

          <q-banner
            v-else-if="!usersStore.currentUser"
            class="bg-warning text-dark q-mb-md"
            rounded
          >
            Sign in to create or edit a profile.
          </q-banner>

          <q-form @submit.prevent="saveProfile" class="q-gutter-md">
            <q-card flat bordered class="q-pa-md bg-grey-1">
              <div class="text-subtitle1 q-mb-sm">User details</div>
              <div class="row q-col-gutter-md">
                <div class="col-12 col-md-4">
                  <q-input v-model="profile.fname" label="First name" readonly filled dense />
                </div>

                <div class="col-12 col-md-4">
                  <q-input v-model="profile.lname" label="Last name" readonly filled dense />
                </div>

                <div class="col-12 col-md-4">
                  <q-input v-model="profile.sex" label="Sex" readonly filled dense />
                </div>
              </div>
            </q-card>

            <q-card flat bordered class="q-pa-md bg-grey-1">
              <div class="text-subtitle1 q-mb-sm">Body</div>
              <div class="row q-col-gutter-md">
                <div class="col-12 col-md-6">
                  <q-input
                    v-model="profile.weight"
                    type="number"
                    label="Weight (lbs)"
                    min="0"
                    step="0.01"
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
                    step="0.01"
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
                    step="0.01"
                    filled
                    dense
                  />
                </div>

                <div class="col-12 col-md-6">
                  <q-select
                    v-model="profile.activity_level"
                    :options="activityLevelOptions"
                    label="Activity level"
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
                    v-model="profile.daily_calorie_deficit"
                    type="number"
                    label="Daily calorie deficit"
                    min="0"
                    filled
                    dense
                    :rules="[(value) => value !== '' || 'Daily calorie deficit is required']"
                  />
                </div>

                <div class="col-12 col-md-6">
                  <q-select
                    v-model="profile.diet_type"
                    :options="dietTypeOptions"
                    label="Diet type"
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
              <div class="row items-center justify-between q-mb-sm">
                <div class="text-subtitle1">Macro split by day</div>
                <q-btn
                  label="Load template"
                  color="secondary"
                  flat
                  :disable="!profile.diet_type"
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
                      step="0.01"
                      :label="field.label"
                      filled
                      dense
                      hint="0 to 100"
                    />
                  </div>
                </div>
              </div>
            </q-card>

            <q-input v-model="profile.is_active" type="hidden" />

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
                label="Save profile"
                :loading="loading"
                :disable="!usersStore.currentUser"
              />
            </div>
          </q-form>
        </q-card>
      </div>
    </div>
  </q-page>
</template>

<script setup>
import { computed, onMounted, reactive, ref, watch } from 'vue'
import { useUsersStore } from 'stores/users'
import { useProfilesStore } from 'stores/profiles'
import { calculateBodyMassIndex, calculateTotalDailyCalories } from '../utils/rules'
import macroTemplates from '../components/macros.json'

const usersStore = useUsersStore()
const store = useProfilesStore()
const loading = ref(false)

const dietTypeOptions = [
  { label: 'Balanced', value: 'Balanced' },
  { label: 'Low Carb', value: 'Low Carb' },
  { label: 'High Protein', value: 'High Protein' },
  { label: 'High Metabolic', value: 'High Metabolic' },
]

const activityLevelOptions = [
  { label: 'Low', value: 'Low' },
  { label: 'Medium', value: 'Medium' },
  { label: 'High', value: 'High' },
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
  weight: null,
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

const totalDailyCalories = computed(() => {
  const calories = calculateTotalDailyCalories({
    weight: profile.weight,
    height: profile.height,
    age: usersStore.currentUser?.age,
    sex: usersStore.currentUser?.sex,
    activityLevel: profile.activity_level,
  })

  return calories ?? ''
})

const bodyMassIndex = computed(() => {
  const bmi = calculateBodyMassIndex({
    weight: profile.weight,
    height: profile.height,
  })

  return bmi ?? ''
})

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
  syncUserDetails()

  if (!currentUserId.value) {
    store.currentProfile = null
    profile.weight = null
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

  loading.value = true
  const data = await store.loadCurrentProfile(currentUserId.value)
  profile.weight = data?.weight ?? null
  profile.goal_weight = data?.goal_weight ?? null
  profile.height = data?.height ?? null
  profile.activity_level = data?.activity_level ?? null
  profile.daily_calorie_deficit = data?.daily_calorie_deficit ?? 0
  profile.diet_type = data?.diet_type ?? null
  dayGroups.forEach((day) => {
    day.fields.forEach((field) => {
      profile[field.key] = data?.[field.key] ?? null
    })
  })
  loading.value = false
}

async function saveProfile() {
  if (!currentUserId.value) {
    return
  }

  loading.value = true
  await store.saveProfile(currentUserId.value, {
    weight: profile.weight,
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
}

watch(
  () => usersStore.currentUser,
  () => {
    syncUserDetails()
  },
  { deep: true },
)

onMounted(() => {
  loadProfile()
})
</script>
