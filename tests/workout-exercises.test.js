import assert from 'node:assert/strict'
import test from 'node:test'
import {
  availableWorkoutExercises,
  loadWorkoutExercises,
  optionalNonNegativeIntegerRule,
  workoutExercisePayload,
} from '../src/utils/workoutExercises.js'

test('loads workout exercises with their names in saved order and propagates errors', async () => {
  const calls = []
  const result = { data: null, error: { message: 'Load failed' } }
  const query = {
    select(value) {
      calls.push(['select', value])
      return this
    },
    eq(field, value) {
      calls.push(['eq', field, value])
      return this
    },
    order(field) {
      calls.push(['order', field])
      return field === 'workout_exercise_id' ? Promise.resolve(result) : this
    },
  }
  const client = {
    from(table) {
      calls.push(['from', table])
      return query
    },
  }

  assert.equal(await loadWorkoutExercises(client, 42), result)
  assert.deepEqual(calls, [
    ['from', 'workout_exercise'],
    ['select', '*, exercise(*)'],
    ['eq', 'workout_id', 42],
    ['order', 'sort_order'],
    ['order', 'workout_exercise_id'],
  ])
})

test('accepts blank or non-negative integers and rejects negative exercise values', () => {
  for (const value of [null, undefined, '', 0, '0', '12', 2147483647]) {
    assert.equal(optionalNonNegativeIntegerRule(value), true)
  }
  for (const value of [-1, '-1', '-0.5', '1.5', '2147483648']) {
    assert.notEqual(optionalNonNegativeIntegerRule(value), true)
  }
})

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
