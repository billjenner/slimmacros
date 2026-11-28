import assert from 'node:assert/strict'
import test from 'node:test'
import { availableWorkoutExercises, workoutExercisePayload } from '../src/utils/workoutExercises.js'

test('offers active own and system exercises, plus shared exercises when enabled', () => {
  const exercises = [
    { exercise_id: 1, user_id: 'me', is_active: true },
    { exercise_id: 2, user_id: 'other', is_active: true, system_defined: true },
    { exercise_id: 3, user_id: 'other', is_active: true, share_with_others: true },
    { exercise_id: 4, user_id: 'other', is_active: true },
    { exercise_id: 5, user_id: 'me', is_active: false },
    { exercise_id: 6, user_id: 'other', is_active: false, share_with_others: true },
  ]
  const ids = (includeShared) =>
    availableWorkoutExercises(exercises, 'me', includeShared).map((row) => row.exercise_id)
  assert.deepEqual(ids(false), [1, 2])
  assert.deepEqual(ids(true), [1, 2, 3])
})

test('serializes selected exercises in display order and preserves zero and blank values', () => {
  const payload = workoutExercisePayload([
    { exercise_id: 9, weight: '0', reps: '12', sets: '', duration: null },
    { exercise_id: 7, weight: '25', reps: null, sets: '3', duration: '60' },
    { exercise_id: null },
  ])
  assert.deepEqual(payload, [
    { exercise_id: 9, sort_order: 1, weight: 0, reps: 12, sets: null, duration: null },
    { exercise_id: 7, sort_order: 2, weight: 25, reps: null, sets: 3, duration: 60 },
  ])
  assert.equal(workoutExercisePayload([{ exercise_id: 7 }, { exercise_id: null }])[0].sort_order, 1)
})
