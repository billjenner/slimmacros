export function optionalNonNegativeIntegerRule(value) {
  if (value === null || value === undefined || value === '') return true
  const number = Number(value)
  return (
    (Number.isInteger(number) && number >= 0 && number <= 2147483647) ||
    'Enter a whole number between 0 and 2147483647'
  )
}

export function availableWorkoutExercises(exercises, userId, includeShared) {
  return exercises.filter(
    (exercise) =>
      exercise.is_active &&
      (exercise.user_id === userId ||
        exercise.system_defined ||
        (includeShared && exercise.share_with_others)),
  )
}

export function loadWorkoutExercises(client, workoutId) {
  return client
    .from('workout_exercise')
    .select('*, exercise(*)')
    .eq('workout_id', workoutId)
    .order('sort_order')
    .order('workout_exercise_id')
}

export function workoutExercisePayload(entries) {
  return entries
    .filter((entry) => entry.exercise_id)
    .map((entry, index) => ({
      exercise_id: entry.exercise_id,
      sort_order: index + 1,
      ...Object.fromEntries(
        ['weight', 'reps', 'sets', 'duration'].map((field) => [
          field,
          entry[field] === '' || entry[field] == null ? null : Number(entry[field]),
        ]),
      ),
    }))
}
