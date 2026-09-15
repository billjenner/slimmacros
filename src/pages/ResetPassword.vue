<template>
  <q-page class="flex flex-center q-pa-md">
    <q-card class="q-pa-lg" style="width: min(100%, 460px)">
      <div class="text-h5 text-center q-mb-md">Reset Password</div>

      <!-- -------------------------------------------------
           Verifying reset link
           ------------------------------------------------- -->
      <div v-if="isLoading" class="text-center q-pa-md">
        <q-spinner color="primary" size="40px" />

        <div class="q-mt-md">Verifying password reset link...</div>
      </div>

      <!-- -------------------------------------------------
           Invalid / expired reset link
           ------------------------------------------------- -->
      <div v-else-if="errorText" class="text-center">
        <div class="text-negative q-mb-md">
          {{ errorText }}
        </div>

        <q-btn
          color="primary"
          label="Request New Reset Link"
          @click="router.push('/forgot-password')"
        />
      </div>

      <!-- -------------------------------------------------
           Password reset form
           ------------------------------------------------- -->
      <q-form v-else-if="isReady" @submit.prevent="handleReset" class="q-gutter-md">
        <q-input
          v-model="newPassword"
          label="New password"
          type="password"
          outlined
          dense
          autocomplete="new-password"
          :rules="[
            (val) => !!val || 'Password is required',
            (val) => val.length >= 8 || 'Password must be at least 8 characters',
          ]"
        />

        <q-input
          v-model="confirmPassword"
          label="Confirm password"
          type="password"
          outlined
          dense
          autocomplete="new-password"
          :rules="[
            (val) => !!val || 'Please confirm your password',
            (val) => val === newPassword || 'Passwords do not match',
          ]"
        />

        <q-btn
          color="primary"
          label="Reset Password"
          type="submit"
          class="full-width"
          :loading="isSaving"
        />
      </q-form>

      <!-- -------------------------------------------------
           Status message
           ------------------------------------------------- -->
      <div v-if="statusText" class="q-mt-md text-center" :class="statusClass">
        {{ statusText }}
      </div>
    </q-card>
  </q-page>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue'

import { useRouter } from 'vue-router'
import { useQuasar } from 'quasar'
import { supabase } from '../lib/supabase'

const router = useRouter()
const $q = useQuasar()

// --------------------------------------------------
// State
// --------------------------------------------------

const isLoading = ref(true)
const isSaving = ref(false)
const isReady = ref(false)

const newPassword = ref('')
const confirmPassword = ref('')

const errorText = ref('')
const statusText = ref('')
const statusClass = ref('text-positive')

let authSubscription = null
let timeoutId = null

// --------------------------------------------------
// Process Supabase password recovery
// --------------------------------------------------

onMounted(async () => {
  console.log('[ResetPassword] mounted')
  console.log('[ResetPassword] URL:', window.location.href)

  try {
    // ------------------------------------------------
    // Listen for Supabase authentication events.
    //
    // PASSWORD_RECOVERY is fired by Supabase when
    // the password recovery link has been processed.
    // ------------------------------------------------

    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange((event, session) => {
      console.log('[ResetPassword] Supabase auth event:', event)

      if (event === 'PASSWORD_RECOVERY') {
        console.log('[ResetPassword] PASSWORD_RECOVERY received')

        console.log('[ResetPassword] Recovery session:', !!session)

        if (!session) {
          errorText.value = 'The password reset session could not be established.'

          isLoading.value = false
          return
        }

        // Recovery session is valid.
        isReady.value = true
        isLoading.value = false

        // Cancel the fallback timeout.
        if (timeoutId) {
          clearTimeout(timeoutId)
          timeoutId = null
        }
      }
    })

    authSubscription = subscription

    // ------------------------------------------------
    // Check whether Supabase already has a session.
    //
    // This can happen if Supabase processed the URL
    // before this Vue component mounted.
    // ------------------------------------------------

    const {
      data: { session },
      error: sessionError,
    } = await supabase.auth.getSession()

    if (sessionError) {
      throw sessionError
    }

    console.log('[ResetPassword] Existing session:', !!session)

    if (session) {
      console.log('[ResetPassword] Existing Supabase session found')

      isReady.value = true
      isLoading.value = false

      if (timeoutId) {
        clearTimeout(timeoutId)
        timeoutId = null
      }

      return
    }

    // ------------------------------------------------
    // Give Supabase time to process the recovery URL.
    // ------------------------------------------------

    timeoutId = setTimeout(() => {
      if (!isReady.value) {
        console.error('[ResetPassword] No recovery session was established')

        errorText.value =
          'The password reset link could not be verified. Please request a new reset link.'

        isLoading.value = false
      }
    }, 5000)
  } catch (err) {
    console.error('[ResetPassword] Recovery initialization failed:', err)

    errorText.value = err?.message || 'Unable to verify the password reset link.'

    isLoading.value = false
  }
})

// --------------------------------------------------
// Cleanup
// --------------------------------------------------

onBeforeUnmount(() => {
  if (authSubscription) {
    authSubscription.unsubscribe()
    authSubscription = null
  }

  if (timeoutId) {
    clearTimeout(timeoutId)
    timeoutId = null
  }
})

// --------------------------------------------------
// Update password
// --------------------------------------------------

async function handleReset() {
  statusText.value = ''

  // ------------------------------------------------
  // Validate password
  // ------------------------------------------------

  if (!newPassword.value) {
    statusText.value = 'Please enter a new password.'

    statusClass.value = 'text-negative'
    return
  }

  if (newPassword.value.length < 8) {
    statusText.value = 'Password must be at least 8 characters.'

    statusClass.value = 'text-negative'
    return
  }

  if (newPassword.value !== confirmPassword.value) {
    statusText.value = 'Passwords do not match.'

    statusClass.value = 'text-negative'
    return
  }

  // ------------------------------------------------
  // Update password
  // ------------------------------------------------

  isSaving.value = true

  try {
    console.log('[ResetPassword] Updating password...')

    const { error: updateError } = await supabase.auth.updateUser({
      password: newPassword.value,
    })

    if (updateError) {
      throw updateError
    }

    console.log('[ResetPassword] Password updated successfully')

    statusText.value = 'Your password has been successfully reset.'

    statusClass.value = 'text-positive'

    $q.notify({
      type: 'positive',
      message: 'Password reset successfully!',
    })

    // ------------------------------------------------
    // Return to login.
    // ------------------------------------------------

    setTimeout(() => {
      router.push('/login')
    }, 1500)
  } catch (err) {
    console.error('[ResetPassword] Password update failed:', err)

    statusText.value =
      err?.message || 'Unable to reset your password. Please request a new reset link.'

    statusClass.value = 'text-negative'
  } finally {
    isSaving.value = false
  }
}
</script>
