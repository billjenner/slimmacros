import { defineStore, acceptHMRUpdate } from 'pinia'
import { supabase } from '../lib/supabase'

export const useFoodsStore = defineStore('Foods', {
  state: () => ({
    foods: [],
    currentFood: null,
    error: null,
    loading: false,
  }),

  actions: {
    toNumber(value) {
      if (value === null || value === undefined || value === '') {
        return 0
      }

      const numericValue = Number(value)
      return Number.isNaN(numericValue) ? 0 : numericValue
    },

    buildFoodPayload(userId, food = {}) {
      return {
        user_id: userId,
        description: food.description?.trim() || '',
        protein: this.toNumber(food.protein),
        carb: this.toNumber(food.carb),
        fat: this.toNumber(food.fat),
        calories_extra: this.toNumber(food.calories_extra),
        my_food: food.my_food !== false,
        favorite_food: Boolean(food.favorite_food),
        share_with_others: Boolean(food.share_with_others),
        serving_size: this.toNumber(food.serving_size) || 1,
        serving_unit: food.serving_unit || 'unit',
        is_active: food.is_active !== false,
      }
    },

    async createFood(userId, food = {}) {
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

        const payload = this.buildFoodPayload(userId, food)
        const { data, error } = await supabase.from('food').insert(payload).select().single()

        if (error) {
          this.error = error.message
          return null
        }

        this.currentFood = data
        this.foods = [data, ...this.foods]
        return data
      } finally {
        this.loading = false
      }
    },

    async loadFoods(userId) {
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
          .from('food')
          .select('*')
          .eq('user_id', userId)
          .order('created_at', { ascending: false })

        if (error) {
          this.error = error.message
          return []
        }

        this.foods = data || []
        return this.foods
      } finally {
        this.loading = false
      }
    },
  },
})

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useFoodsStore, import.meta.hot))
}
