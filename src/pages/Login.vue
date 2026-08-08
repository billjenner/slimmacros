<template>
  <q-page class="flex flex-center q-pa-md">
    <q-card class="q-pa-lg" style="width: min(100%, 420px)">
      <div class="text-h5 text-center q-mb-md">Login</div>

      <q-form @submit.prevent="handleSubmit" class="q-gutter-y-md full-width">
        <q-input
          v-model="email"
          label="Email"
          type="email"
          outlined
          dense
          autocomplete="email"
          :rules="[(val) => !!val || 'Email is required']"
        />

        <q-input
          v-model="password"
          label="Password"
          :type="showPassword ? 'text' : 'password'"
          outlined
          dense
          autocomplete="current-password"
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
          <q-btn color="primary" label="Log In" type="submit" class="full-width" />
        </div>

        <div class="row justify-center q-gutter-sm q-mt-sm full-width">
          <q-btn flat color="secondary" label="Forgot Password" to="/forgot-password" />
          <q-btn flat color="secondary" label="Create User" to="/create-login" />
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
import { useUsersStore } from 'stores/users'

const email = ref('')
const password = ref('')
const showPassword = ref(false)
const message = ref('')
const messageClass = ref('text-positive')

const router = useRouter()
const store = useUsersStore()

async function handleSubmit() {
  if (!email.value.trim() || !password.value) {
    message.value = 'Please enter email and password.'
    messageClass.value = 'text-negative'
    return
  }

  const result = await store.loginUser(email.value, password.value)

  if (result) {
    message.value = `Logged in as ${store.currentUser?.email}`
    messageClass.value = 'text-positive'
    router.push('/')
  } else {
    message.value = store.error || 'Unable to log in.'
    messageClass.value = 'text-negative'
  }
}
</script>
