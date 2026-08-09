import { defineStore, acceptHMRUpdate } from 'pinia'
import { supabase } from '../lib/supabase'

export const useFoodLogsStore = defineStore('FoodLogs', {
  state: () => ({
    logs: [],
    currentLog: null,
    error: null,
    loading: false,
  }),

  actions: {
    toPositiveNumber(value) {
      if (value === null || value === undefined || value === '') {
        return null
      }

      const numericValue = Number(value)
      if (Number.isNaN(numericValue) || numericValue <= 0) {
        return null
      }

      return numericValue
    },

    buildFoodLogPayload(userId, foodLog = {}) {
      const servings = this.toPositiveNumber(foodLog.servings) ?? 1
      const payload = {
        user_id: userId,
        food_id: foodLog.food_id,
        servings,
      }

      if (foodLog.datetime) {
        payload.datetime = foodLog.datetime
      }

      return payload
    },

    async createFoodLog(userId, foodLog = {}) {
      this.error = null
      this.loading = true

      try {
        if (!supabase) {
          this.error = 'Supabase client is not configured.'
          return null
        }

        if (!userId) {
          this.error = 'No current user is available.'
          return null
        }

        if (!foodLog.food_id) {
          this.error = 'Please select a food.'
          return null
        }

        const payload = this.buildFoodLogPayload(userId, foodLog)
        const { data, error } = await supabase.from('food_log').insert(payload).select().single()

        if (error) {
          this.error = error.message
          return null
        }

        this.currentLog = data
        this.logs = [data, ...this.logs]
        return data
      } finally {
        this.loading = false
      }
    },

    async loadFoodLogs(userId) {
      this.error = null
      this.loading = true

      try {
        if (!supabase) {
          this.error = 'Supabase client is not configured.'
          return []
        }

        if (!userId) {
          this.error = 'No current user is available.'
          return []
        }

        const { data, error } = await supabase
          .from('food_log')
          .select(
            `
              food_log_id,
              food_id,
              user_id,
              servings,
              datetime,
              food:food_id (
                food_id,
                description,
                protein,
                carb,
                fat,
                calories_extra,
                serving_size,
                serving_unit
              )
            `,
          )
          .eq('user_id', userId)
          .order('datetime', { ascending: false })

        if (error) {
          this.error = error.message
          return []
        }

        this.logs = data || []
        return this.logs
      } finally {
        this.loading = false
      }
    },

    async deleteFoodLog(userId, foodLogId) {
      this.error = null
      this.loading = true

      try {
        if (!supabase) {
          this.error = 'Supabase client is not configured.'
          return { error: this.error }
        }

        if (!userId || !foodLogId) {
          this.error = 'No current user is available.'
          return { error: this.error }
        }

        const { error } = await supabase
          .from('food_log')
          .delete()
          .eq('food_log_id', foodLogId)
          .eq('user_id', userId)

        if (error) {
          this.error = error.message
          return { error: this.error }
        }

        this.logs = this.logs.filter((log) => log.food_log_id !== foodLogId)
        return { error: null }
      } finally {
        this.loading = false
      }
    },
  },
})

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useFoodLogsStore, import.meta.hot))
}
