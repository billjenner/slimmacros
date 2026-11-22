import assert from 'node:assert/strict'
import test from 'node:test'
import { createMemoryHistory, createRouter } from 'vue-router'
import { getLoginPath, getStartPath } from '../src/utils/getting-started.js'

const router = createRouter({
  history: createMemoryHistory(),
  routes: [
    { path: '/log', component: {} },
    { path: '/items', component: {} },
  ],
})

test('chooses a start page from the current user food logs', async () => {
  const store = {
    error: null,
    async loadFoodLogs(userId) {
      assert.equal(userId, 'user-1')
      return this.logs
    },
    logs: [],
  }

  assert.equal(await getStartPath(store, 'user-1'), '/getting-started')
  store.logs = [{ food_log_id: 1 }]
  assert.equal(await getStartPath(store, 'user-1'), '/log')
})

test('does not choose a page when food logs cannot be loaded', async () => {
  const store = {
    error: 'Unable to load food logs.',
    async loadFoodLogs() {
      return []
    },
  }

  await assert.rejects(getStartPath(store, 'user-1'), /Unable to load food logs/)
})

test('checks food logs before honoring a login redirect to Log', async () => {
  const store = {
    error: null,
    logs: [],
    async loadFoodLogs(userId) {
      assert.equal(userId, 'user-1')
      return this.logs
    },
  }

  assert.equal(await getLoginPath(store, 'user-1', '/log', router), '/getting-started')
  assert.equal(await getLoginPath(store, 'user-1', null, router), '/getting-started')
  assert.equal(await getLoginPath(store, 'user-1', '/log?tab=workouts', router), '/getting-started')
  store.logs = [{ food_log_id: 1 }]
  assert.equal(await getLoginPath(store, 'user-1', null, router), '/log')
  assert.equal(
    await getLoginPath(store, 'user-1', '/log?tab=workouts', router),
    '/log?tab=workouts',
  )
})

test('does not follow a Log redirect when food log lookup fails', async () => {
  const store = {
    error: 'Unable to load food logs.',
    async loadFoodLogs() {
      return []
    },
  }

  await assert.rejects(getLoginPath(store, 'user-1', '/log', router), /Unable to load food logs/)
})

test('preserves non-Log login redirects without loading food logs', async () => {
  const store = {
    async loadFoodLogs() {
      assert.fail('Unexpected food log lookup')
    },
  }

  assert.equal(
    await getLoginPath(store, 'user-1', '/items?tab=profile', router),
    '/items?tab=profile',
  )
})
