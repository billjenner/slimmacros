import { defineStore, acceptHMRUpdate } from 'pinia'
import { supabase } from '../lib/supabase'

export const useWorkoutsStore = defineStore('Workouts', {
  state: () => ({
    workouts: [],
    currentWorkout: null,
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

    toNonNegativeInteger(value) {
      const numericValue = Number(value)
      if (!Number.isFinite(numericValue) || numericValue < 0) {
        return 0
      }

      return Math.trunc(numericValue)
    },

    sortByDescription(workouts = []) {
      return [...workouts].sort((a, b) => {
        const aDescription = String(a?.description ?? a?.type ?? '').toLowerCase()
        const bDescription = String(b?.description ?? b?.type ?? '').toLowerCase()
        return aDescription.localeCompare(bDescription)
      })
    },

    buildWorkoutPayload(userId, workout = {}) {
      return {
        user_id: userId,
        type: workout.type?.trim() || '',
        average_workout_time: this.toNullableNonNegativeInteger(workout.average_workout_time),
        calories_burned: this.toNonNegativeInteger(workout.calories_burned),
        share_with_others: Boolean(workout.share_with_others),
        is_active: workout.is_active !== false,
      }
    },

    async createWorkout(userId, workout = {}) {
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

        const payload = this.buildWorkoutPayload(userId, workout)
        const { data, error } = await supabase.from('workout').insert(payload).select().single()

        if (error) {
          this.error = error.message
          return null
        }

        this.currentWorkout = data
        this.workouts = [data, ...this.workouts]
        return data
      } finally {
        this.loading = false
      }
    },

    async updateWorkout(userId, workoutId, workout = {}) {
      this.error = null
      this.loading = true

      try {
        if (!supabase) {
          this.error = 'Supabase client is not configured.'
          return null
        }

        if (!userId || !workoutId) {
          this.error = 'No current user is available.'
          return null
        }

        const payload = this.buildWorkoutPayload(userId, workout)
        delete payload.user_id

        const { data, error } = await supabase
          .from('workout')
          .update(payload)
          .eq('workout_id', workoutId)
          .eq('user_id', userId)
          .select()
          .single()

        if (error) {
          this.error = error.message
          return null
        }

        this.currentWorkout = data
        this.workouts = this.workouts.map((item) => (item.workout_id === workoutId ? data : item))
        return data
      } finally {
        this.loading = false
      }
    },

    async loadWorkouts(userId) {
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

        const { data: ownWorkouts, error: ownError } = await supabase
          .from('workout')
          .select('*')
          .eq('user_id', userId)
          .eq('is_active', true)
          .order('created_at', { ascending: false })

        if (ownError) {
          this.error = ownError.message
          return []
        }

        const { data: sharedWorkouts, error: sharedError } = await supabase
          .from('workout')
          .select('*')
          .neq('user_id', userId)
          .eq('share_with_others', true)
          .eq('is_active', true)
          .order('created_at', { ascending: false })

        if (sharedError) {
          this.error = sharedError.message
          return []
        }

        const sortedOwnWorkouts = this.sortByDescription(ownWorkouts || [])
        const sortedSharedWorkouts = this.sortByDescription(sharedWorkouts || [])

        this.workouts = [...sortedOwnWorkouts, ...sortedSharedWorkouts]
        return this.workouts
      } finally {
        this.loading = false
      }
    },

    async deactivateWorkout(userId, workoutId) {
      this.error = null
      this.loading = true

      try {
        if (!supabase) {
          this.error = 'Supabase client is not configured.'
          return { error: this.error }
        }

        if (!userId || !workoutId) {
          this.error = 'No current user is available.'
          return { error: this.error }
        }

        const { error } = await supabase
          .from('workout')
          .update({ is_active: false })
          .eq('workout_id', workoutId)
          .eq('user_id', userId)

        if (error) {
          this.error = error.message
          return { error: this.error }
        }

        this.workouts = this.workouts.filter((workout) => workout.workout_id !== workoutId)
        return { error: null }
      } finally {
        this.loading = false
      }
    },
  },
})

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useWorkoutsStore, import.meta.hot))
}
