const ACTIVITY_LEVEL_MULTIPLIERS = {
  Sedentary: 1.2,
  LightlyActive: 1.27,
  ModeratelyActive: 1.55,
  VeryActive: 1.725,
  ExtremelyActive: 1.9,
}

export function hasValue(value) {
  return value !== null && value !== undefined && value !== ''
}

export function hasMissingMacroFields(profile, fields) {
  return fields.some((field) => !hasValue(profile[field.key]))
}

export function shouldHighlightLoadTemplate(profile, dayGroups) {
  return (
    Boolean(profile.diet_type) &&
    dayGroups.some((day) => hasMissingMacroFields(profile, day.fields))
  )
}

export function isValidProfileNumber(value, decimalPlaces = 0) {
  if (!hasValue(value)) return false
  const number = Number(value)
  const scaled = number * 10 ** decimalPlaces
  return Number.isFinite(number) && number >= 0 && Math.abs(scaled - Math.round(scaled)) < 1e-8
}

export function hasRequiredProfileDetails(profile) {
  return (
    Boolean(profile.sex && profile.activity_level) &&
    isValidProfileNumber(profile.age) &&
    isValidProfileNumber(profile.start_weight, 1) &&
    isValidProfileNumber(profile.goal_weight) &&
    isValidProfileNumber(profile.height)
  )
}

function normalizeSex(sex) {
  return String(sex || '')
    .trim()
    .toLowerCase()
}

function toNumber(value) {
  if (value === null || value === undefined || value === '') {
    return null
  }

  const numericValue = Number(value)
  return Number.isFinite(numericValue) ? numericValue : null
}

export function calculateTotalDailyCalories({ weight, height, age, sex, activityLevel }) {
  const numericWeight = toNumber(weight)
  const numericHeight = toNumber(height)
  const numericAge = toNumber(age)
  const normalizedSex = normalizeSex(sex)
  const activityMultiplier = ACTIVITY_LEVEL_MULTIPLIERS[activityLevel]

  if (
    numericWeight === null ||
    numericHeight === null ||
    numericAge === null ||
    !activityMultiplier
  ) {
    return null
  }

  let bmr = null

  if (normalizedSex === 'male' || normalizedSex === 'm') {
    bmr = 4.536 * numericWeight + 15.875 * numericHeight - 5 * numericAge + 5
  } else if (normalizedSex === 'female' || normalizedSex === 'f') {
    bmr = 4.536 * numericWeight + 15.875 * numericHeight - 5 * numericAge - 161
  }

  if (bmr === null) {
    return null
  }

  return Math.round(bmr * activityMultiplier)
}

export function calculateBodyMassIndex({ weight, height }) {
  const numericWeight = toNumber(weight)
  const numericHeight = toNumber(height)

  if (numericWeight === null || numericHeight === null || numericHeight === 0) {
    return null
  }

  const bmi = (numericWeight * 703) / (numericHeight * numericHeight)
  return Math.round(bmi * 100) / 100
}

export function calculateTotalCaloriesForPerson({
  totalDailyCalories,
  dailyCalorieDeficit,
  totalWorkoutCaloriesBurnedbyFoodDay,
}) {
  const numericTotalDailyCalories = toNumber(totalDailyCalories) ?? 2000
  const numericDailyCalorieDeficit = toNumber(dailyCalorieDeficit) ?? 0
  const numericWorkoutCaloriesBurnedToday = toNumber(totalWorkoutCaloriesBurnedbyFoodDay) ?? 0

  return Math.max(
    0,
    Math.round(
      numericTotalDailyCalories - numericDailyCalorieDeficit + numericWorkoutCaloriesBurnedToday,
    ),
  )
}

export function calculateFoodCalories({ carbs, protein, fat, extraCalories }) {
  const numericCarbs = toNumber(carbs) ?? 0
  const numericProtein = toNumber(protein) ?? 0
  const numericFat = toNumber(fat) ?? 0
  const numericExtraCalories = toNumber(extraCalories) ?? 0

  return Math.round(numericCarbs * 4 + numericProtein * 4 + numericFat * 9 + numericExtraCalories)
}
