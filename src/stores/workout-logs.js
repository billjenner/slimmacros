import { defineStore, acceptHMRUpdate } from 'pinia'
import { supabase } from '../lib/supabase'

export const useWorkoutLogsStore = defineStore('WorkoutLogs', {
  state: () => ({
    logs: [],
    currentLog: null,
    error: null,
    loading: false,
  }),

  actions: {
    toNullableNonNegativeInteger(value) {
      if (value === null || value === undefined || value === '') {
        return null
      }

      const numericValue = Number(value)
      if (!Number.isFinite(numericValue) || numericValue < 0) {
        return null
      }

      return Math.trunc(numericValue)
    },

    buildWorkoutLogPayload(userId, workoutLog = {}) {
      const payload = {
        user_id: userId,
        workout_id: workoutLog.workout_id,
        workout_time: this.toNullableNonNegativeInteger(workoutLog.workout_time),
      }

      if (workoutLog.date) {
        payload.date = workoutLog.date
      }

      return payload
    },

    async createWorkoutLog(userId, workoutLog = {}) {
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

        if (!workoutLog.workout_id) {
          this.error = 'Please select a workout.'
          return null
        }

        const payload = this.buildWorkoutLogPayload(userId, workoutLog)
        const { data, error } = await supabase.from('workout_log').insert(payload).select().single()

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

    async loadWorkoutLogs(userId) {
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
          .from('workout_log')
          .select(
            `
              workout_log_id,
              workout_id,
              user_id,
              workout_time,
              date,
              workout:workout_id (
                workout_id,
                type,
                average_workout_time,
                calories_burned
              )
            `,
          )
          .eq('user_id', userId)
          .order('date', { ascending: false })
          .order('workout_log_id', { ascending: false })

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

    async deleteWorkoutLog(userId, workoutLogId) {
      this.error = null
      this.loading = true

      try {
        if (!supabase) {
          this.error = 'Supabase client is not configured.'
          return { error: this.error }
        }

        if (!userId || !workoutLogId) {
          this.error = 'No current user is available.'
          return { error: this.error }
        }

        const { error } = await supabase
          .from('workout_log')
          .delete()
          .eq('workout_log_id', workoutLogId)
          .eq('user_id', userId)

        if (error) {
          this.error = error.message
          return { error: this.error }
        }

        this.logs = this.logs.filter((log) => log.workout_log_id !== workoutLogId)
        return { error: null }
      } finally {
        this.loading = false
      }
    },
  },
})

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useWorkoutLogsStore, import.meta.hot))
}
