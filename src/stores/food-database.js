import { defineStore, acceptHMRUpdate } from 'pinia'
import { supabase } from '../lib/supabase'

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
        if (!supabase) {
          this.error = 'Supabase client is not configured.'
          return []
        }

        // Strip characters that have meaning in LIKE patterns.
        const term = String(text || '')
          .trim()
          .replace(/[%_\\]/g, '')

        let query = supabase
          .from('food_database')
          .select(
            'food_db_id, description, serving_size, serving_unit, protein, carb, fat, calories_extra',
          )
          .eq('is_active', true)
          .order('description', { ascending: true })
          .limit(limit)

        if (term) {
          query = query.ilike('description', `%${term}%`)
        }

        const { data, error } = await query

        if (error) {
          this.error = error.message
          return []
        }

        return data || []
      } finally {
        this.loading = false
      }
    },
  },
})

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useFoodDatabaseStore, import.meta.hot))
}
