import { getLocalDateKey } from './date'

export function calculateWorkoutLogCaloriesBurned(log) {
  const storedCaloriesBurned = Number(log?.calories_burned)
  if (Number.isFinite(storedCaloriesBurned) && storedCaloriesBurned >= 0) {
    return Math.round(storedCaloriesBurned)
  }

  const workout = log?.workout || {}
  const workoutTime = Number(log?.workout_time ?? workout.average_workout_time)
  const averageWorkoutTime = Number(workout.average_workout_time)
  const caloriesBurned = Number(workout.calories_burned)

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
}

export function sumWorkoutLogCaloriesBurnedForDate(logs, localDateKey) {
  return (logs || [])
    .filter((log) => getLocalDateKey(log?.date) === localDateKey)
    .reduce((sum, log) => sum + Math.max(0, Number(log?.calories_burned) || 0), 0)
}
