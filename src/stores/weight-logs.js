import { defineStore, acceptHMRUpdate } from 'pinia'
import { supabase } from '../lib/supabase'

export const useWeightLogsStore = defineStore('WeightLogs', {
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
      if (!Number.isFinite(numericValue) || numericValue <= 0) {
        return null
      }

      return numericValue
    },

    buildWeightLogPayload(userId, weightLog = {}) {
      const payload = {
        user_id: userId,
        weight: this.toPositiveNumber(weightLog.weight),
      }

      const bmi = this.toPositiveNumber(weightLog.bmi)
      if (bmi !== null) {
        payload.bmi = bmi
      }

      if (weightLog.date) {
        payload.date = weightLog.date
      }

      return payload
    },

    async createWeightLog(userId, weightLog = {}) {
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

        if (this.toPositiveNumber(weightLog.weight) === null) {
          this.error = 'Please enter a valid weight.'
          return null
        }

        const payload = this.buildWeightLogPayload(userId, weightLog)
        const { data, error } = await supabase.from('weight_log').insert(payload).select().single()

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

    async loadWeightLogs(userId) {
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
          .from('weight_log')
          .select(
            `
              weight_log_id,
              user_id,
              weight,
              bmi,
              date
            `,
          )
          .eq('user_id', userId)
          .order('date', { ascending: false })
          .order('weight_log_id', { ascending: false })

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

    async deleteWeightLog(userId, weightLogId) {
      this.error = null
      this.loading = true

      try {
        if (!supabase) {
          this.error = 'Supabase client is not configured.'
          return { error: this.error }
        }

        if (!userId || !weightLogId) {
          this.error = 'No current user is available.'
          return { error: this.error }
        }

        const { error } = await supabase
          .from('weight_log')
          .delete()
          .eq('weight_log_id', weightLogId)
          .eq('user_id', userId)

        if (error) {
          this.error = error.message
          return { error: this.error }
        }

        this.logs = this.logs.filter((log) => log.weight_log_id !== weightLogId)
        return { error: null }
      } finally {
        this.loading = false
      }
    },
  },
})

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useWeightLogsStore, import.meta.hot))
}
