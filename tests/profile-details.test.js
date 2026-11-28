import assert from 'node:assert/strict'
import test from 'node:test'
import {
  hasMissingMacroFields,
  hasRequiredProfileDetails,
  isValidProfileNumber,
  shouldHighlightLoadTemplate,
} from '../src/utils/rules.js'

test('nutrition editing requires every User details and Body field', () => {
  const profile = {
    sex: 'F',
    age: '30',
    start_weight: '150',
    goal_weight: '140',
    height: '65',
    activity_level: 'Sedentary',
  }
  assert.equal(hasRequiredProfileDetails(profile), true)
  for (const field of Object.keys(profile)) {
    assert.equal(hasRequiredProfileDetails({ ...profile, [field]: null }), false, field)
    assert.equal(hasRequiredProfileDetails({ ...profile, [field]: '' }), false, field)
  }
})

test('zero remains a filled numeric value', () => {
  assert.equal(
    hasRequiredProfileDetails({
      sex: 'M',
      age: 0,
      start_weight: 0,
      goal_weight: '0',
      height: 0,
      activity_level: 'Sedentary',
    }),
    true,
  )
})

test('nutrition editing stays locked for values outside the existing number constraints', () => {
  const profile = {
    sex: 'F',
    age: '30',
    start_weight: '150.5',
    goal_weight: '140',
    height: '65',
    activity_level: 'Sedentary',
  }
  assert.equal(hasRequiredProfileDetails(profile), true)
  for (const [field, value] of [
    ['age', -1],
    ['age', 1.5],
    ['start_weight', '150.55'],
    ['goal_weight', '-1'],
    ['height', '65.5'],
  ]) {
    assert.equal(hasRequiredProfileDetails({ ...profile, [field]: value }), false, field)
  }
})

test('daily calorie deficit accepts zero but rejects missing or invalid values', () => {
  for (const value of [0, '0', '250']) assert.equal(isValidProfileNumber(value), true)
  for (const value of [null, undefined, '', '-1', '1.5']) {
    assert.equal(isValidProfileNumber(value), false)
  }
})

test('detects missing daily macros without treating zero as empty', () => {
  const fields = [{ key: 'protein' }, { key: 'carbs' }, { key: 'fat' }]
  const values = { protein: 0, carbs: '0', fat: 100 }
  assert.equal(hasMissingMacroFields(values, fields), false)
  for (const field of fields) {
    for (const value of [null, undefined, '']) {
      assert.equal(hasMissingMacroFields({ ...values, [field.key]: value }, fields), true)
    }
  }
})

test('highlights Load template only with a diet and a missing macro on any day', () => {
  const days = [
    { fields: [{ key: 'sunProtein' }, { key: 'sunCarbs' }, { key: 'sunFat' }] },
    { fields: [{ key: 'monProtein' }, { key: 'monCarbs' }, { key: 'monFat' }] },
  ]
  const values = {
    diet_type: 'Balanced',
    sunProtein: 30,
    sunCarbs: 30,
    sunFat: 40,
    monProtein: 0,
    monCarbs: 30,
    monFat: 70,
  }
  assert.equal(shouldHighlightLoadTemplate(values, days), false)
  assert.equal(shouldHighlightLoadTemplate({ ...values, monFat: '' }, days), true)
  assert.equal(shouldHighlightLoadTemplate({ ...values, sunProtein: null }, days), true)
  assert.equal(shouldHighlightLoadTemplate({ ...values, diet_type: null, monFat: '' }, days), false)
})
