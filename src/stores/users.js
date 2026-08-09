import { defineStore, acceptHMRUpdate } from 'pinia'
import { supabase } from '../lib/supabase'

const CURRENT_USER_STORAGE_KEY = 'slimbelly.currentUser'

function getPersistedCurrentUser() {
  if (typeof window === 'undefined') {
    return null
  }

  try {
    const storedUser = window.localStorage.getItem(CURRENT_USER_STORAGE_KEY)
    return storedUser ? JSON.parse(storedUser) : null
  } catch {
    return null
  }
}

function persistCurrentUser(user) {
  if (typeof window === 'undefined') {
    return
  }

  try {
    if (user) {
      window.localStorage.setItem(CURRENT_USER_STORAGE_KEY, JSON.stringify(user))
    } else {
      window.localStorage.removeItem(CURRENT_USER_STORAGE_KEY)
    }
  } catch {
    // Ignore storage failures and keep the in-memory session active.
  }
}

function sanitizeCurrentUser(user) {
  if (!user) {
    return null
  }

  const safeUser = { ...user }
  delete safeUser.password
  return safeUser
}

export const useUsersStore = defineStore('Users', {
  state: () => ({
    users: [],
    currentUser: getPersistedCurrentUser(),
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

      const savedUser = sanitizeCurrentUser(data)

      this.users = this.users.filter((user) => user.email !== normalizedEmail)
      this.users.push(savedUser)
      this.currentUser = savedUser
      persistCurrentUser(savedUser)
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

      const savedUser = sanitizeCurrentUser(data)

      this.currentUser = savedUser
      this.users = this.users.filter((u) => u.email !== normalizedEmail)
      this.users.push(savedUser)
      persistCurrentUser(savedUser)
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
      const payload = {
        email: this.currentUser.email,
        room: answers?.room || '',
        cube: answers?.cube || '',
        ladder: answers?.ladder || '',
        horse: answers?.horse || '',
        window: answers?.window || '',
        storm: answers?.storm || '',
        flowers: answers?.flowers || '',
        date_time: currentTime,
      }

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
      const targetDateTime = this.activeAnswerDateTime || currentTime
      const payload = {
        email: this.currentUser.email,
        room: answers?.room || '',
        cube: answers?.cube || '',
        ladder: answers?.ladder || '',
        horse: answers?.horse || '',
        window: answers?.window || '',
        storm: answers?.storm || '',
        flowers: answers?.flowers || '',
        date_time: targetDateTime,
      }

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
      persistCurrentUser(null)
    },
  },
})

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useUsersStore, import.meta.hot))
}
