import { defineStore, acceptHMRUpdate } from 'pinia'
import { supabase } from '../lib/supabase'

const CURRENT_USER_STORAGE_KEY = 'slimmacros.currentUser'
const USERS_LOGGED_IN_FUNCTION = 'users-logged-in'

function normalizeEmail(email) {
  return String(email || '')
    .trim()
    .toLowerCase()
}

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

function formatAuthUser(authUser) {
  if (!authUser) {
    return null
  }

  const id = authUser.id

  return {
    id,
    user_id: id,
    email: authUser.email || '',
    created_at: authUser.created_at,
    user_metadata: authUser.user_metadata || {},
  }
}

export const useUsersStore = defineStore('Users', {
  state: () => ({
    users: [],
    currentUser: getPersistedCurrentUser(),
    answers: [],
    error: null,
  }),

  actions: {
    async registerUser(email, password) {
      this.error = null

      if (!supabase) {
        this.error = 'Supabase client is not configured.'
        return null
      }

      const normalizedEmail = normalizeEmail(email)

      const { data: signUpData, error: signUpError } = await supabase.auth.signUp({
        email: normalizedEmail,
        password,
      })

      if (signUpError) {
        this.error = signUpError.message
        return null
      }

      if (!signUpData?.session && !signUpData?.user) {
        this.error = 'Account created, but email confirmation is required before logging in.'
        return null
      }

      const authUser = signUpData.user
      if (!authUser) {
        this.error = 'Unable to complete user registration.'
        return null
      }

      const savedUser = formatAuthUser(authUser)
      this.users = this.users.filter((user) => user.email !== normalizedEmail)
      this.users.push(savedUser)
      this.currentUser = savedUser
      persistCurrentUser(savedUser)
      await this.syncLoggedInSession(normalizedEmail, true)
      return savedUser
    },

    async recoverPassword(email) {
      this.error = null

      if (!supabase) {
        this.error = 'Supabase client is not configured.'
        return null
      }

      const normalizedEmail = normalizeEmail(email)
      // Path doesn't matter here: the app uses hash routing, so Supabase's own
      // "#access_token=..." fragment would collide with a "/#/reset-password"
      // route. The auth-redirect boot file routes to /reset-password once the
      // PASSWORD_RECOVERY event fires.
      const redirectTo = typeof window !== 'undefined' ? window.location.origin : undefined

      // Supabase Auth hashes passwords, so we can no longer recover/email the
      // original password. This sends a password-reset link instead.
      const { error } = await supabase.auth.resetPasswordForEmail(normalizedEmail, { redirectTo })

      if (error) {
        this.error = error.message
        return null
      }

      return { email: normalizedEmail }
    },

    async loginUser(email, password) {
      this.error = null

      if (!supabase) {
        this.error = 'Supabase client is not configured.'
        return null
      }

      const normalizedEmail = normalizeEmail(email)
      const { data: signInData, error: signInError } = await supabase.auth.signInWithPassword({
        email: normalizedEmail,
        password,
      })

      if (signInError) {
        this.error = signInError.message
        return null
      }

      const authUser = signInData?.user
      if (!authUser) {
        this.error = 'No account found for that email.'
        return null
      }

      const savedUser = formatAuthUser(authUser)
      this.currentUser = savedUser
      this.users = this.users.filter((u) => u.email !== normalizedEmail)
      this.users.push(savedUser)
      persistCurrentUser(savedUser)
      await this.syncLoggedInSession(normalizedEmail, true)
      return savedUser
    },

    async restoreSessionFromAuth() {
      if (!supabase) {
        return null
      }

      const {
        data: { session },
      } = await supabase.auth.getSession()

      if (!session?.user) {
        return null
      }

      const savedUser = formatAuthUser(session.user)
      this.currentUser = savedUser
      this.users = this.users.filter((u) => u.email !== savedUser.email)
      this.users.push(savedUser)
      persistCurrentUser(savedUser)
      return savedUser
    },

    async logoutUser() {
      if (supabase) {
        let { error } = await supabase.auth.signOut()
        if (error) {
          this.error = error.message
          return null
        }
      }
      await this.clearCurrentUser()
    },

    async getUserByEmail(email) {
      this.error = null

      if (!supabase) {
        this.error = 'Supabase client is not configured.'
        return null
      }

      const normalizedEmail = normalizeEmail(email)
      if (!normalizedEmail) {
        return null
      }

      const {
        data: { user },
        error,
      } = await supabase.auth.getUser()

      if (error || !user) {
        if (error) this.error = error.message
        return null
      }

      if (user.email && normalizeEmail(user.email) === normalizedEmail) {
        return formatAuthUser(user)
      }

      return null
    },

    async syncLoggedInSession(email, isLoggedIn) {
      if (!supabase) {
        return false
      }

      const normalizedEmail = normalizeEmail(email)
      if (!normalizedEmail) {
        return false
      }

      const { data, error } = await supabase.functions.invoke(USERS_LOGGED_IN_FUNCTION, {
        body: {
          action: isLoggedIn ? 'login' : 'logout',
          email: normalizedEmail,
        },
      })

      if (error) {
        console.error('[users-logged-in] sync failed:', error.message, data)
      }

      return !error
    },

    async loadUsers() {
      this.error = null

      if (!supabase) {
        this.error = 'Supabase client is not configured.'
        return []
      }

      const {
        data: { user },
        error,
      } = await supabase.auth.getUser()

      if (error) {
        this.error = error.message
        return []
      }

      if (user) {
        const formatted = formatAuthUser(user)
        this.users = [formatted]
        return this.users
      }

      this.users = []
      return []
    },

    async clearCurrentUser() {
      const currentEmail = this.currentUser?.email
      if (currentEmail) {
        await this.syncLoggedInSession(currentEmail, false)
      }

      this.currentUser = null
      persistCurrentUser(null)
    },
  },
})

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useUsersStore, import.meta.hot))
}
