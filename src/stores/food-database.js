import { defineStore, acceptHMRUpdate } from 'pinia'
import { supabase } from '../lib/supabase'

// The whole food_database table is kept in Cache Storage so searches never wait on the network.
const CACHE_NAME = 'food-database'
const CACHE_URL = 'https://slimmacros.internal/food-database'
const PAGE_SIZE = 1000
const COLUMNS =
  'food_db_id, description, serving_size, serving_unit, protein, carb, fat, calories_extra'

let memoryCache = null
let refreshPromise = null

async function readCache() {
  if (memoryCache) {
    return memoryCache
  }

  if (typeof caches === 'undefined') {
    return null
  }

  const cache = await caches.open(CACHE_NAME)
  const cached = await cache.match(CACHE_URL)
  if (!cached) {
    return null
  }

  memoryCache = await cached.json()
  return memoryCache
}

async function writeCache(payload) {
  memoryCache = payload

  if (typeof caches === 'undefined') {
    return
  }

  const cache = await caches.open(CACHE_NAME)
  await cache.put(
    CACHE_URL,
    new Response(JSON.stringify(payload), { headers: { 'Content-Type': 'application/json' } }),
  )

  // Ask the browser not to evict the cache under storage pressure.
  navigator.storage?.persist?.()
}

async function fetchLatestDate() {
  const { data, error } = await supabase
    .from('food_database')
    .select('date')
    .order('date', { ascending: false })
    .limit(1)
    .maybeSingle()

  if (error) {
    throw error
  }

  return data?.date ?? null
}

async function fetchAllRows() {
  const rows = []

  for (let from = 0; ; from += PAGE_SIZE) {
    const { data, error } = await supabase
      .from('food_database')
      .select(COLUMNS)
      .eq('is_active', true)
      .order('food_db_id', { ascending: true })
      .range(from, from + PAGE_SIZE - 1)

    if (error) {
      throw error
    }

    rows.push(...data)
    if (data.length < PAGE_SIZE) {
      break
    }
  }

  return rows
}

async function downloadAndCache() {
  // Read the date first so a row added mid-download triggers another refresh next time.
  const latestDate = await fetchLatestDate()
  const rows = await fetchAllRows()
  const payload = { latestDate, rows }
  await writeCache(payload)
  return payload
}

// Full download happens only when the database has a newer date than the cache.
function refreshIfNewer() {
  if (!supabase) {
    return Promise.resolve()
  }

  if (!refreshPromise) {
    refreshPromise = (async () => {
      const cached = await readCache()
      const latestDate = await fetchLatestDate()

      if (!cached || (latestDate && (!cached.latestDate || latestDate > cached.latestDate))) {
        await downloadAndCache()
      }
    })().finally(() => {
      refreshPromise = null
    })
  }

  return refreshPromise
}

export const useFoodDatabaseStore = defineStore('FoodDatabase', {
  state: () => ({
    error: null,
    loading: false,
  }),

  actions: {
    async searchFoods(text = '', limit = 50) {
      this.error = null
      this.loading = true

      try {
        let cached = await readCache()

        if (cached) {
          // Secondary step: check for newer data without delaying the result.
          refreshIfNewer().catch((error) => console.warn('Food database refresh failed.', error))
        } else {
          if (!supabase) {
            this.error = 'Supabase client is not configured.'
            return []
          }

          cached = await downloadAndCache()
        }

        const term = String(text || '')
          .trim()
          .toLowerCase()

        const matches = term
          ? cached.rows.filter((row) =>
              String(row.description || '')
                .toLowerCase()
                .includes(term),
            )
          : cached.rows

        return [...matches]
          .sort((a, b) => String(a.description).localeCompare(String(b.description)))
          .slice(0, limit)
      } catch (error) {
        this.error = error?.message || 'Unable to load food database.'
        return []
      } finally {
        this.loading = false
      }
    },
  },
})

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useFoodDatabaseStore, import.meta.hot))
}
