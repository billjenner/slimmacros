<template>
  <q-page class="flex flex-center q-pa-md">
    <q-card class="q-pa-lg" style="width: min(100%, 460px)">
      <div class="text-h5 text-center q-mb-md">Forgot Password</div>

      <q-form @submit.prevent="handleSubmit" class="q-gutter-md">
        <q-input
          v-model="email"
          label="Enter email"
          type="email"
          outlined
          dense
          autocomplete="email"
          :rules="[(val) => !!val || 'Email is required']"
        />

        <q-btn color="primary" label="Send Password" type="submit" class="full-width" />
      </q-form>

      <div v-if="message" class="q-mt-md text-center" :class="messageClass">
        {{ message }}
      </div>
    </q-card>
  </q-page>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useQuasar } from 'quasar'
import { useUsersStore } from 'stores/users'

const router = useRouter()
const store = useUsersStore()
const $q = useQuasar()

const email = ref('')
const message = ref('')
const messageClass = ref('text-positive')

const formSubmitUrl =
  import.meta.env.VITE_FORMSUBMIT_URL || `https://formsubmit.co/bill.jenner@gmail.com`

async function handleSubmit() {
  if (!email.value.trim()) {
    message.value = 'Please enter your email.'
    messageClass.value = 'text-negative'
    return
  }

  try {
    const result = await store.recoverPassword(email.value)

    if (!result) {
      throw new Error(store.error || 'No account found for that email.')
    }

    const response = await fetch(formSubmitUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Accept: 'application/json',
      },
      body: JSON.stringify({
        email: result.email,
        password: result.password,
        _subject: 'Your Cube Game password',
        _captcha: 'false',
      }),
    })

    if (!response.ok) {
      throw new Error('Unable to send password email right now.')
    }

    $q.notify({
      color: 'accent',
      textColor: 'white',
      message: `Your password was sent to ${result.email}`,
      timeout: 30000,
      actions: [
        {
          label: 'X',
          color: 'white',
          handler: () => {},
        },
      ],
    })
    setTimeout(() => router.push('/login'), 3000)
  } catch (error) {
    console.error('Forgot password email failed:', error)
    const errorMessage = error?.message || 'Unknown error'
    message.value = `Unable to send password email right now: ${errorMessage}`
    messageClass.value = 'text-negative text-body1'
  }
}
</script>
