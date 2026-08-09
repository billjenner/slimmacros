import { defineStore, acceptHMRUpdate } from 'pinia'
import { supabase } from '../lib/supabase'

export const useSupplimentsStore = defineStore('Suppliments', {
  state: () => ({
    supplements: [],
    currentSupplement: null,
    error: null,
    loading: false,
  }),

  actions: {
    toPositiveNumber(value, fallback = null) {
      if (value === null || value === undefined || value === '') {
        return fallback
      }

      const numericValue = Number(value)
      if (!Number.isFinite(numericValue) || numericValue <= 0) {
        return fallback
      }

      return numericValue
    },

    sortByDescription(items = []) {
      return [...items].sort((a, b) => {
        const aDescription = String(a?.description ?? '').toLowerCase()
        const bDescription = String(b?.description ?? '').toLowerCase()
        return aDescription.localeCompare(bDescription)
      })
    },

    buildSupplementPayload(userId, supplement = {}) {
      return {
        user_id: userId,
        description: String(supplement.description || '').trim(),
        serving_size: this.toPositiveNumber(supplement.serving_size, 1),
        serving_unit: supplement.serving_unit || 'other',
        share_with_others: Boolean(supplement.share_with_others),
        is_active: supplement.is_active !== false,
      }
    },

    async createSupplement(userId, supplement = {}) {
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

        const payload = this.buildSupplementPayload(userId, supplement)

        if (!payload.description) {
          this.error = 'Suppliment description is required.'
          return null
        }

        const { data, error } = await supabase.from('supplement').insert(payload).select().single()

        if (error) {
          this.error = error.message
          return null
        }

        this.currentSupplement = data
        this.supplements = [data, ...this.supplements]
        return data
      } finally {
        this.loading = false
      }
    },

    async updateSupplement(userId, supplementId, supplement = {}) {
      this.error = null
      this.loading = true

      try {
        if (!supabase) {
          this.error = 'Supabase client is not configured.'
          return null
        }

        if (!userId || !supplementId) {
          this.error = 'No current user is available.'
          return null
        }

        const payload = this.buildSupplementPayload(userId, supplement)
        delete payload.user_id

        if (!payload.description) {
          this.error = 'Suppliment description is required.'
          return null
        }

        const { data, error } = await supabase
          .from('supplement')
          .update(payload)
          .eq('supplement_id', supplementId)
          .eq('user_id', userId)
          .select()
          .single()

        if (error) {
          this.error = error.message
          return null
        }

        this.currentSupplement = data
        this.supplements = this.supplements.map((item) =>
          item.supplement_id === supplementId ? data : item,
        )
        return data
      } finally {
        this.loading = false
      }
    },

    async loadSupplements(userId) {
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

        const { data: ownSupplements, error: ownError } = await supabase
          .from('supplement')
          .select('*')
          .eq('user_id', userId)
          .eq('is_active', true)
          .order('created_at', { ascending: false })

        if (ownError) {
          this.error = ownError.message
          return []
        }

        const { data: sharedSupplements, error: sharedError } = await supabase
          .from('supplement')
          .select('*')
          .neq('user_id', userId)
          .eq('share_with_others', true)
          .eq('is_active', true)
          .order('created_at', { ascending: false })

        if (sharedError) {
          this.error = sharedError.message
          return []
        }

        const sortedOwnSupplements = this.sortByDescription(ownSupplements || [])
        const sortedSharedSupplements = this.sortByDescription(sharedSupplements || [])

        this.supplements = [...sortedOwnSupplements, ...sortedSharedSupplements]
        return this.supplements
      } finally {
        this.loading = false
      }
    },

    async deactivateSupplement(userId, supplementId) {
      this.error = null
      this.loading = true

      try {
        if (!supabase) {
          this.error = 'Supabase client is not configured.'
          return { error: this.error }
        }

        if (!userId || !supplementId) {
          this.error = 'No current user is available.'
          return { error: this.error }
        }

        const { error } = await supabase
          .from('supplement')
          .update({ is_active: false })
          .eq('supplement_id', supplementId)
          .eq('user_id', userId)

        if (error) {
          this.error = error.message
          return { error: this.error }
        }

        this.supplements = this.supplements.filter((item) => item.supplement_id !== supplementId)
        return { error: null }
      } finally {
        this.loading = false
      }
    },
  },
})

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useSupplimentsStore, import.meta.hot))
}
