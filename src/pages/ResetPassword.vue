<template>
  <q-page class="flex flex-center q-pa-md">
    <q-card class="q-pa-lg" style="width: min(100%, 420px)">
      <div class="text-h5 text-center q-mb-md">Set a new password</div>

      <q-form @submit.prevent="handleSubmit" class="q-gutter-y-md full-width">
        <q-input
          v-model="password"
          label="New Password"
          :type="showPassword ? 'text' : 'password'"
          outlined
          dense
          autocomplete="new-password"
          :rules="[(val) => !!val || 'Password is required']"
        >
          <template #append>
            <q-icon
              :name="showPassword ? 'visibility_off' : 'visibility'"
              class="cursor-pointer"
              @click="showPassword = !showPassword"
            />
          </template>
        </q-input>

        <div class="full-width">
          <q-btn color="primary" label="Update Password" type="submit" class="full-width" />
        </div>
      </q-form>

      <div v-if="message" class="q-mt-md text-center text-caption" :class="messageClass">
        {{ message }}
      </div>
    </q-card>
  </q-page>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { supabase } from '../lib/supabase'

const router = useRouter()

const password = ref('')
const showPassword = ref(false)
const message = ref('')
const messageClass = ref('text-positive')

async function handleSubmit() {
  if (!password.value) {
    message.value = 'Please enter a new password.'
    messageClass.value = 'text-negative'
    return
  }

  if (!supabase) {
    message.value = 'Supabase client is not configured.'
    messageClass.value = 'text-negative'
    return
  }

  // The reset-password link from Supabase Auth signs the browser in with a
  // recovery session before landing here, so updateUser() applies to that user.
  const { error } = await supabase.auth.updateUser({ password: password.value })

  if (error) {
    message.value = error.message
    messageClass.value = 'text-negative'
    return
  }

  message.value = 'Password updated. Please log in.'
  messageClass.value = 'text-positive'
  setTimeout(() => router.push('/login'), 1500)
}
</script>
