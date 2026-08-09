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

    async updateFood(userId, foodId, food = {}) {
      this.error = null
      this.loading = true

      try {
        if (!supabase) {
          this.error = 'Supabase client is not configured.'
          return null
        }

        if (!userId || !foodId) {
          this.error = 'No current user is available.'
          return null
        }

        const payload = this.buildFoodPayload(userId, food)
        delete payload.user_id

        const { data, error } = await supabase
          .from('food')
          .update(payload)
          .eq('food_id', foodId)
          .eq('user_id', userId)
          .select()
          .single()

        if (error) {
          this.error = error.message
          return null
        }

        this.currentFood = data
        this.foods = this.foods.map((item) => (item.food_id === foodId ? data : item))
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
          .eq('is_active', true)
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

    async deactivateFood(userId, foodId) {
      this.error = null
      this.loading = true

      try {
        if (!supabase) {
          this.error = 'Supabase client is not configured.'
          return { error: this.error }
        }

        if (!userId || !foodId) {
          this.error = 'No current user is available.'
          return { error: this.error }
        }

        const { error } = await supabase
          .from('food')
          .update({ is_active: false })
          .eq('food_id', foodId)
          .eq('user_id', userId)

        if (error) {
          this.error = error.message
          return { error: this.error }
        }

        this.foods = this.foods.filter((food) => food.food_id !== foodId)
        return { error: null }
      } finally {
        this.loading = false
      }
    },
  },
})

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useFoodsStore, import.meta.hot))
}
