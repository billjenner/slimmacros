import { defineStore, acceptHMRUpdate } from 'pinia'
import { supabase } from '../lib/supabase'
import { generateAnswerExplanation } from '../utils/interpretAnswers'

function trimAnswer(value) {
  return String(value || '').trim()
}

function normalizeAnswers(answers) {
  return {
    room: trimAnswer(answers?.room),
    cube: trimAnswer(answers?.cube),
    ladder: trimAnswer(answers?.ladder),
    horse: trimAnswer(answers?.horse),
    window: trimAnswer(answers?.window),
    storm: trimAnswer(answers?.storm),
    flowers: trimAnswer(answers?.flowers),
  }
}

function buildAnswerPayload(email, answers, explanations, currentTime) {
  return {
    email,
    room: answers.room || '',
    room_explanation: explanations.room || '',
    cube: answers.cube || '',
    cube_explanation: explanations.cube || '',
    ladder: answers.ladder || '',
    ladder_explanation: explanations.ladder || '',
    horse: answers.horse || '',
    horse_explanation: explanations.horse || '',
    window: answers.window || '',
    window_explanation: explanations.window || '',
    storm: answers.storm || '',
    storm_explanation: explanations.storm || '',
    flowers: answers.flowers || '',
    flowers_explanation: explanations.flowers || '',
    date_time: currentTime,
  }
}

export const useUsersStore = defineStore('Users', {
  state: () => ({
    users: [],
    currentUser: null,
    answers: [],
    error: null,
    activeAnswerId: null,
    activeAnswerDateTime: null,
  }),

  actions: {
    async saveUser(email, password, fname = '', lname = '', sex = '', age = null) {
      this.error = null

      if (!supabase) {
        this.error = 'Supabase client is not configured.'
        return null
      }

      const normalizedEmail = email.trim().toLowerCase()
      const user = {
        email: normalizedEmail,
        password,
        fname,
        lname,
        sex,
        age: age !== null && age !== '' ? Number(age) : null,
        is_active: true,
      }

      const { data: existingUser, error: lookupError } = await supabase
        .from('users')
        .select('email')
        .eq('email', normalizedEmail)
        .maybeSingle()

      if (lookupError) {
        this.error = lookupError.message
        return null
      }

      if (existingUser) {
        this.error = 'User already exists'
        return null
      }

      const { data, error } = await supabase
        .from('users')
        .upsert(user, { onConflict: 'email' })
        .select()
        .single()

      if (error) {
        this.error = error.message
        return null
      }

      this.users = this.users.filter((user) => user.email !== normalizedEmail)
      this.users.push(data)
      this.currentUser = data
      return data
    },

    async recoverPassword(email) {
      this.error = null

      if (!supabase) {
        this.error = 'Supabase client is not configured.'
        return null
      }

      const normalizedEmail = email.trim().toLowerCase()
      const { data, error } = await supabase
        .from('users')
        .select('email, password')
        .eq('email', normalizedEmail)
        .maybeSingle()

      if (error) {
        this.error = error.message
        return null
      }

      if (!data) {
        this.error = 'No account found for that email.'
        return null
      }

      return data
    },

    async loginUser(email, password) {
      this.error = null

      if (!supabase) {
        this.error = 'Supabase client is not configured.'
        return null
      }

      const normalizedEmail = email.trim().toLowerCase()
      const { data, error } = await supabase
        .from('users')
        .select('*')
        .eq('email', normalizedEmail)
        .maybeSingle()

      if (error) {
        this.error = error.message
        return null
      }

      if (!data) {
        this.error = 'No account found for that email.'
        return null
      }

      if (data.password !== password) {
        this.error = 'Invalid password.'
        return null
      }

      this.currentUser = data
      this.users = this.users.filter((u) => u.email !== normalizedEmail)
      this.users.push(data)
      return data
    },

    async loadUsers() {
      this.error = null

      if (!supabase) {
        this.error = 'Supabase client is not configured.'
        return []
      }

      const { data, error } = await supabase.from('users').select('*').order('created_at', {
        ascending: false,
      })

      if (error) {
        this.error = error.message
        return []
      }

      this.users = (data || []).map((user) => ({
        ...user,
        name: `${user.fname || ''}   ${user.lname || ''}`.trim(),
      }))
      return this.users
    },

    async saveAnswers(answers) {
      this.error = null

      if (!supabase) {
        this.error = 'Supabase client is not configured.'
        return null
      }

      if (!this.currentUser?.email) {
        this.error = 'No current user is available.'
        return null
      }

      const currentTime = new Date().toISOString()
      const normalizedAnswers = normalizeAnswers(answers)
      const explanations = await generateAnswerExplanation(normalizedAnswers)
      const payload = buildAnswerPayload(
        this.currentUser.email,
        normalizedAnswers,
        explanations,
        currentTime,
      )

      const { data, error } = await supabase.from('answers').insert(payload).select().single()

      if (error) {
        this.error = error.message
        return null
      }

      this.activeAnswerId = data?.ID || null
      this.activeAnswerDateTime = data?.date_time || currentTime

      this.answers = this.answers.filter((item) => item.email !== this.currentUser.email)
      this.answers.push(data)
      return data
    },

    async finishAnswers(answers) {
      this.error = null

      if (!supabase) {
        this.error = 'Supabase client is not configured.'
        return null
      }

      if (!this.currentUser?.email) {
        this.error = 'No current user is available.'
        return null
      }

      const currentTime = new Date().toISOString()
      const normalizedAnswers = normalizeAnswers(answers)
      const explanations = await generateAnswerExplanation(normalizedAnswers)
      const targetDateTime = this.activeAnswerDateTime || currentTime
      const payload = buildAnswerPayload(
        this.currentUser.email,
        normalizedAnswers,
        explanations,
        targetDateTime,
      )

      let data = null
      let error = null

      if (this.activeAnswerId) {
        const updateResult = await supabase
          .from('answers')
          .update(payload)
          .eq('ID', this.activeAnswerId)
          .select()
          .maybeSingle()

        data = updateResult.data
        error = updateResult.error
      }

      if (!data && !error && this.activeAnswerDateTime) {
        const updateResult = await supabase
          .from('answers')
          .update(payload)
          .eq('email', this.currentUser.email)
          .eq('date_time', this.activeAnswerDateTime)
          .select()
          .maybeSingle()

        data = updateResult.data
        error = updateResult.error
      }

      if (!data && !error && this.activeAnswerDateTime) {
        // Fallback update for schemas where date_time comparison may not match exactly.
        const updateByEmailResult = await supabase
          .from('answers')
          .update(payload)
          .eq('email', this.currentUser.email)
          .select()
          .maybeSingle()

        data = updateByEmailResult.data
        error = updateByEmailResult.error
      }

      if (!data && !error && !this.activeAnswerDateTime) {
        const insertResult = await supabase.from('answers').insert(payload).select().single()
        data = insertResult.data
        error = insertResult.error
      }

      if (error) {
        this.error = error.message
        return null
      }

      this.activeAnswerId = data?.ID || this.activeAnswerId
      this.activeAnswerDateTime = data?.date_time || targetDateTime

      this.answers = this.answers.filter((item) => item.email !== this.currentUser.email)
      this.answers.push(data)
      return data
    },

    clearCurrentUser() {
      this.currentUser = null
      this.activeAnswerId = null
      this.activeAnswerDateTime = null
    },
  },
})

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useUsersStore, import.meta.hot))
}
