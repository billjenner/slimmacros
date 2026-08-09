import { defineStore, acceptHMRUpdate } from 'pinia'
import { supabase } from '../lib/supabase'

export const useSupplementLogsStore = defineStore('SupplementLogs', {
  state: () => ({
    logs: [],
    supplements: [],
    currentLog: null,
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
        const aDescription = String(a?.supplement?.description ?? '').toLowerCase()
        const bDescription = String(b?.supplement?.description ?? '').toLowerCase()
        return aDescription.localeCompare(bDescription)
      })
    },

    isSharedLog(item = {}) {
      return item?.share_with_others === true || item?.supplement?.share_with_others === true
    },

    buildSupplementLogPayload(userId, supplementLog = {}) {
      return {
        user_id: userId,
        supplement_id: supplementLog.supplement_id,
        servings: this.toPositiveNumber(supplementLog.servings, 1),
        date: supplementLog.date || undefined,
      }
    },

    async createSupplement(userId, supplement = {}) {
      this.error = null

      if (!supabase) {
        this.error = 'Supabase client is not configured.'
        return null
      }

      if (!userId) {
        this.error = 'No current user is available.'
        return null
      }

      const description = String(supplement.description || '').trim()
      if (!description) {
        this.error = 'Suppliment description is required.'
        return null
      }

      const payload = {
        user_id: userId,
        description,
        serving_size: this.toPositiveNumber(supplement.serving_size, 1),
        serving_unit: supplement.serving_unit || 'other',
        share_with_others: Boolean(supplement.share_with_others),
        is_active: supplement.is_active !== false,
      }

      const { data, error } = await supabase.from('supplement').insert(payload).select().single()

      if (error) {
        this.error = error.message
        return null
      }

      this.supplements = [data, ...this.supplements]
      return data
    },

    async loadSupplements(userId) {
      this.error = null

      if (!supabase) {
        this.error = 'Supabase client is not configured.'
        return []
      }

      if (!userId) {
        this.error = 'No current user is available.'
        return []
      }

      const { data, error } = await supabase
        .from('supplement')
        .select('supplement_id, description, serving_size, serving_unit, share_with_others')
        .eq('user_id', userId)
        .eq('is_active', true)
        .order('created_at', { ascending: false })

      if (error) {
        this.error = error.message
        return []
      }

      this.supplements = data || []
      return this.supplements
    },

    async createSupplementLog(userId, supplementLog = {}) {
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

        if (!supplementLog.supplement_id) {
          this.error = 'Please select a suppliment.'
          return null
        }

        const payload = this.buildSupplementLogPayload(userId, supplementLog)
        const { data, error } = await supabase
          .from('supplement_log')
          .insert(payload)
          .select()
          .single()

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

    async updateSupplementLog(userId, supplementLogId, supplementLog = {}) {
      this.error = null
      this.loading = true

      try {
        if (!supabase) {
          this.error = 'Supabase client is not configured.'
          return null
        }

        if (!userId || !supplementLogId) {
          this.error = 'No current user is available.'
          return null
        }

        if (!supplementLog.supplement_id) {
          this.error = 'Please select a suppliment.'
          return null
        }

        const payload = this.buildSupplementLogPayload(userId, supplementLog)
        delete payload.user_id

        const { data, error } = await supabase
          .from('supplement_log')
          .update(payload)
          .eq('supplement_log_id', supplementLogId)
          .eq('user_id', userId)
          .select()
          .single()

        if (error) {
          this.error = error.message
          return null
        }

        this.currentLog = data
        this.logs = this.logs.map((item) =>
          item.supplement_log_id === supplementLogId ? data : item,
        )
        return data
      } finally {
        this.loading = false
      }
    },

    async loadSupplementLogs(userId) {
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

        const { data: ownLogs, error: ownError } = await supabase
          .from('supplement_log')
          .select(
            `
              supplement_log_id,
              supplement_id,
              user_id,
              servings,
              date,
              supplement:supplement_id (
                *
              )
            `,
          )
          .eq('user_id', userId)
          .order('date', { ascending: false })
          .order('supplement_log_id', { ascending: false })

        if (ownError) {
          this.error = ownError.message
          return []
        }

        const { data: otherLogs, error: otherError } = await supabase
          .from('supplement_log')
          .select(
            `
              supplement_log_id,
              supplement_id,
              user_id,
              servings,
              date,
              supplement:supplement_id (
                *
              )
            `,
          )
          .neq('user_id', userId)
          .order('date', { ascending: false })
          .order('supplement_log_id', { ascending: false })

        if (otherError) {
          this.error = otherError.message
          return []
        }

        const sharedLogs = (otherLogs || []).filter((item) => this.isSharedLog(item))
        const sortedOwnLogs = this.sortByDescription(ownLogs || [])
        const sortedSharedLogs = this.sortByDescription(sharedLogs)

        this.logs = [...sortedOwnLogs, ...sortedSharedLogs]
        return this.logs
      } finally {
        this.loading = false
      }
    },

    async deleteSupplementLog(userId, supplementLogId) {
      this.error = null
      this.loading = true

      try {
        if (!supabase) {
          this.error = 'Supabase client is not configured.'
          return { error: this.error }
        }

        if (!userId || !supplementLogId) {
          this.error = 'No current user is available.'
          return { error: this.error }
        }

        const { error } = await supabase
          .from('supplement_log')
          .delete()
          .eq('supplement_log_id', supplementLogId)
          .eq('user_id', userId)

        if (error) {
          this.error = error.message
          return { error: this.error }
        }

        this.logs = this.logs.filter((log) => log.supplement_log_id !== supplementLogId)
        return { error: null }
      } finally {
        this.loading = false
      }
    },
  },
})

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useSupplementLogsStore, import.meta.hot))
}
