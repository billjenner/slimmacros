<template>
  <q-page class="flex flex-center q-pa-md">
    <q-card class="q-pa-lg" style="width: min(100%, 460px)">
      <div class="text-h5 text-center q-mb-md">Create User</div>

      <q-form @submit.prevent="handleSubmit" class="q-gutter-y-md full-width">
        <q-input
          v-model="fname"
          label="First Name"
          outlined
          dense
          :rules="[(val) => !!val || 'First name is required']"
        />

        <q-input
          v-model="lname"
          label="Last Name"
          outlined
          dense
          :rules="[(val) => !!val || 'Last name is required']"
        />

        <q-select
          v-model="sex"
          label="Sex"
          :options="['Male', 'Female']"
          outlined
          dense
          :rules="[(val) => !!val || 'Sex is required']"
        />

        <q-input
          v-model.number="age"
          label="Age"
          type="number"
          outlined
          dense
          :rules="[
            (val) => (val !== null && val !== '') || 'Age is required',
            (val) => val >= 0 || 'Age must be 0 or greater',
          ]"
        />

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
          autocomplete="off"
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
          <q-btn color="primary" label="Create User" type="submit" class="full-width" />
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

const router = useRouter()
const store = useUsersStore()

const fname = ref('')
const lname = ref('')
const sex = ref('')
const age = ref(null)
const email = ref('')
const password = ref('')
const showPassword = ref(false)
const message = ref('')
const messageClass = ref('text-positive')

async function handleSubmit() {
  if (
    !fname.value.trim() ||
    !lname.value.trim() ||
    !sex.value ||
    age.value === null ||
    age.value === '' ||
    !email.value.trim() ||
    !password.value
  ) {
    message.value = 'Please fill in all required fields.'
    messageClass.value = 'text-negative'
    return
  }

  const result = await store.saveUser(
    email.value,
    password.value,
    fname.value,
    lname.value,
    sex.value,
    age.value,
  )

  if (result) {
    message.value = `User created for ${store.currentUser?.email}`
    messageClass.value = 'text-positive'
    router.push('/users')
  } else {
    message.value = store.error || 'Unable to save user.'
    messageClass.value = 'text-negative'
  }
}
</script>
