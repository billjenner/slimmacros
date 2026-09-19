import { defineStore, acceptHMRUpdate } from 'pinia'
import { supabase } from '../lib/supabase'
import { isConnectionError } from '../utils/connection'

const CURRENT_USER_STORAGE_KEY = 'slimmacros.currentUser'
const USERS_LOGGED_IN_FUNCTION = 'users-logged-in'
const appUrl = import.meta.env.VITE_APP_URL

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
    isOffline: false,
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
      const xxx = `${appUrl}/#/reset-password`
      console.log('[recoverPassword1] import.meta.env.PROD:', xxx)
      // Use the production URL when deployed.
      // Use localhost when running the development server.
      const redirectTo = import.meta.env.PROD
        ? `${appUrl}/#/reset-password`
        : `${window.location.origin}/#/reset-password`

      console.log('[recoverPassword] redirectTo:', redirectTo)

      const { error } = await supabase.auth.resetPasswordForEmail(normalizedEmail, {
        redirectTo,
      })

      if (error) {
        this.error = error.message
        return null
      }

      return {
        email: normalizedEmail,
      }
    },

    async loginUser(email, password) {
      this.error = null

      if (!supabase) {
        this.error = 'Supabase client is not configured.'
        this.isOffline = true
        return null
      }

      try {
        const normalizedEmail = normalizeEmail(email)
        const { data: signInData, error: signInError } = await supabase.auth.signInWithPassword({
          email: normalizedEmail,
          password,
        })

        if (signInError) {
          this.error = signInError.message
          this.isOffline = isConnectionError(signInError)
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
        this.isOffline = false
        await this.syncLoggedInSession(normalizedEmail, true)
        return savedUser
      } catch (error) {
        this.error = isConnectionError(error) ? 'Unable to connect to Supabase.' : error?.message
        this.isOffline = isConnectionError(error)
        return null
      }
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
        this.isOffline = true
        return []
      }

      try {
        const {
          data: { user },
          error,
        } = await supabase.auth.getUser()

        if (error) {
          this.error = error.message
          this.isOffline = true
          return []
        }

        this.isOffline = false

        if (user) {
          const formatted = formatAuthUser(user)
          this.users = [formatted]
          return this.users
        }

        this.users = []
        return []
      } catch (error) {
        this.error = error?.message || 'Unable to connect to Supabase.'
        this.isOffline = true
        return []
      }
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
