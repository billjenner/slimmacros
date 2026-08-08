import { defineStore, acceptHMRUpdate } from 'pinia'
import { supabase } from '../lib/supabase'

export const useProfilesStore = defineStore('Profiles', {
  state: () => ({
    profiles: [],
    currentProfile: null,
    error: null,
    loading: false,
  }),

  actions: {
    toNullableNumber(value) {
      if (value === null || value === undefined || value === '') {
        return null
      }

      const numericValue = Number(value)
      return Number.isNaN(numericValue) ? null : numericValue
    },

    buildProfilePayload(userId, profile = {}) {
      return {
        user_id: userId,
        weight: this.toNullableNumber(profile.weight),
        goal_weight: this.toNullableNumber(profile.goal_weight),
        activity_level: profile.activity_level || null,
        daily_calorie_deficit: this.toNullableNumber(profile.daily_calorie_deficit) ?? 0,
        diet_type: profile.diet_type || null,
        is_active: true,
        sunday_protein: this.toNullableNumber(profile.sunday_protein),
        sunday_carbs: this.toNullableNumber(profile.sunday_carbs),
        sunday_fat: this.toNullableNumber(profile.sunday_fat),
        monday_protein: this.toNullableNumber(profile.monday_protein),
        monday_carbs: this.toNullableNumber(profile.monday_carbs),
        monday_fat: this.toNullableNumber(profile.monday_fat),
        tuesday_protein: this.toNullableNumber(profile.tuesday_protein),
        tuesday_carbs: this.toNullableNumber(profile.tuesday_carbs),
        tuesday_fat: this.toNullableNumber(profile.tuesday_fat),
        wednesday_protein: this.toNullableNumber(profile.wednesday_protein),
        wednesday_carbs: this.toNullableNumber(profile.wednesday_carbs),
        wednesday_fat: this.toNullableNumber(profile.wednesday_fat),
        thursday_protein: this.toNullableNumber(profile.thursday_protein),
        thursday_carbs: this.toNullableNumber(profile.thursday_carbs),
        thursday_fat: this.toNullableNumber(profile.thursday_fat),
        friday_protein: this.toNullableNumber(profile.friday_protein),
        friday_carbs: this.toNullableNumber(profile.friday_carbs),
        friday_fat: this.toNullableNumber(profile.friday_fat),
        saturday_protein: this.toNullableNumber(profile.saturday_protein),
        saturday_carbs: this.toNullableNumber(profile.saturday_carbs),
        saturday_fat: this.toNullableNumber(profile.saturday_fat),
      }
    },

    async loadProfiles() {
      this.error = null
      this.loading = true

      if (!supabase) {
        this.error = 'Supabase client is not configured.'
        this.loading = false
        return []
      }

      const { data, error } = await supabase.from('profile').select('*').order('created_at', {
        ascending: false,
      })

      if (error) {
        this.error = error.message
        this.loading = false
        return []
      }

      this.profiles = data || []
      this.loading = false
      return this.profiles
    },

    async loadCurrentProfile(userId) {
      this.error = null

      if (!supabase) {
        this.error = 'Supabase client is not configured.'
        return null
      }

      if (!userId) {
        this.error = 'No current user is available.'
        return null
      }

      const { data, error } = await supabase
        .from('profile')
        .select('*')
        .eq('user_id', userId)
        .maybeSingle()

      if (error) {
        this.error = error.message
        return null
      }

      this.currentProfile = data || null
      return this.currentProfile
    },

    async saveProfile(userId, profile = {}) {
      this.error = null

      if (!supabase) {
        this.error = 'Supabase client is not configured.'
        return null
      }

      if (!userId) {
        this.error = 'No current user is available.'
        return null
      }

      const payload = this.buildProfilePayload(userId, profile)
      const { data, error } = await supabase
        .from('profile')
        .upsert(payload, { onConflict: 'user_id' })
        .select()
        .single()

      if (error) {
        this.error = error.message
        return null
      }

      this.currentProfile = data
      this.profiles = this.profiles.filter((item) => item.user_id !== userId)
      this.profiles.unshift(data)
      return data
    },
  },
})

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useProfilesStore, import.meta.hot))
}
