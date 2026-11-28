export function availableWorkoutExercises(exercises, userId, includeShared) {
  return exercises.filter(
    (exercise) =>
      exercise.is_active &&
      (exercise.user_id === userId ||
        exercise.system_defined ||
        (includeShared && exercise.share_with_others)),
  )
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
