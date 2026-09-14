<template>
  <q-page class="flex flex-center q-pa-md">
    <q-card class="q-pa-lg" style="width: min(100%, 560px)">
      <div class="text-h5 text-center q-mb-md">Users</div>

      <div class="text-center q-mb-sm">
        <q-btn color="primary" label="Load users" @click="loadUsers" />
      </div>

      <div v-if="store.error" class="text-center text-primary q-mb-sm">
        {{ store.error }}
      </div>

      <div v-if="!store.users.length" class="text-center text-grey-7">
        No users yet. Create one from the login page or click Load users.
      </div>

      <q-list v-else bordered separator class="rounded-borders">
        <q-item v-for="user in store.users" :key="user.email" clickable>
          <q-item-section>
            <q-item-label caption>
              {{ getProfile(user)?.fname }} {{ getProfile(user)?.lname }} | {{ user.email }} |
              {{ getProfile(user)?.sex }} | {{ getProfile(user)?.age }} |
              {{ roundWeight(getProfile(user)?.start_weight) }} |
              {{ roundWeight(getProfile(user)?.goal_weight) }} |
              {{ formatDate(getProfile(user)?.created_at) }}
            </q-item-label>
          </q-item-section>
        </q-item>
      </q-list>

      <div v-if="store.currentUser" class="q-mt-md text-center text-caption text-positive">
        Current user: {{ store.currentUser.email }}
      </div>
    </q-card>
  </q-page>
</template>

<script setup>
import { onMounted } from 'vue'
import { useUsersStore } from 'stores/users'
import { useProfilesStore } from 'stores/profiles'

const store = useUsersStore()
const profilesStore = useProfilesStore()

function loadUsers() {
  store.loadUsers()
  profilesStore.loadProfiles()
}

function getProfile(user) {
  return profilesStore.profiles.find((profile) => profile.user_id === user.id)
}

function roundWeight(value) {
  return value === null || value === undefined ? '' : Math.round(value)
}

function formatDate(value) {
  if (!value) {
    return ''
  }
  return new Date(value).toISOString().slice(0, 10)
}

onMounted(() => {
  loadUsers()
})
</script>
