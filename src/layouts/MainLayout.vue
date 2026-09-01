<template>
  <q-layout view="lHh Lpr lFf">
    <q-header elevated color="primary">
      <q-toolbar>
        <q-btn
          v-if="$q.screen.lt.md"
          flat
          dense
          round
          icon="menu"
          @click="leftDrawerOpen = !leftDrawerOpen"
        />
        <q-toolbar-title>
          <router-link to="/" class="brand-link row items-center no-wrap">
            <q-img
              src="/icons/icon-192x192.png"
              alt="Slim Belly"
              class="q-mr-sm"
              style="width: 32px; height: 32px; border-radius: 4px"
            />
            <span>Slim Belly</span>
          </router-link>
        </q-toolbar-title>

        <template v-if="!$q.screen.lt.md">
          <q-btn
            flat
            label="Log"
            to="/food-log"
            class="q-mx-sm"
            style="min-width: 126px"
            :style="buttonStyle('/food-log')"
            @mouseover="hoveredPath = '/food-log'"
            @mouseleave="hoveredPath = null"
          />
          <q-btn
            flat
            label="Goods"
            to="/goods"
            class="q-mx-sm"
            style="min-width: 126px"
            :style="buttonStyle('/goods')"
            @mouseover="hoveredPath = '/goods'"
            @mouseleave="hoveredPath = null"
          />

          <q-btn
            flat
            label="Foods"
            to="/foods"
            class="q-mx-sm"
            style="min-width: 126px"
            :style="buttonStyle('/foods')"
            @mouseover="hoveredPath = '/foods'"
            @mouseleave="hoveredPath = null"
          />
          <q-btn
            flat
            label="Workouts"
            to="/workouts"
            class="q-mx-sm"
            style="min-width: 126px"
            :style="buttonStyle('/workouts')"
            @mouseover="hoveredPath = '/workouts'"
            @mouseleave="hoveredPath = null"
          />
          <q-btn
            flat
            label="supplements"
            to="/supplements"
            class="q-mx-sm"
            style="min-width: 126px"
            :style="buttonStyle('/supplements')"
            @mouseover="hoveredPath = '/supplements'"
            @mouseleave="hoveredPath = null"
          />
          <q-btn
            flat
            label="Profiles"
            to="/profiles"
            class="q-mx-sm"
            style="min-width: 126px"
            :style="buttonStyle('/profiles')"
            @mouseover="hoveredPath = '/profiles'"
            @mouseleave="hoveredPath = null"
          />

          <q-btn
            flat
            label="Hub"
            to="/hub"
            class="q-mx-sm"
            style="min-width: 126px"
            :style="buttonStyle('/hub')"
            @mouseover="hoveredPath = '/hub'"
            @mouseleave="hoveredPath = null"
          />
          <q-btn
            v-if="!(usersStore.currentUser && usersStore.currentUser.email)"
            flat
            label="LOGIN"
            to="/login"
            class="q-mx-sm"
            style="min-width: 126px"
            :style="buttonStyle('/login')"
            @mouseover="hoveredPath = '/login'"
            @mouseleave="hoveredPath = null"
          />
          <q-btn
            v-else
            flat
            round
            :label="userInitials"
            aria-label="Log off"
            class="q-mx-sm user-initials-button"
            @click="logOff"
          >
            <q-tooltip>Log off</q-tooltip>
          </q-btn>
        </template>
      </q-toolbar>
    </q-header>

    <q-drawer v-model="leftDrawerOpen" side="left" bordered overlay>
      <q-list padding>
        <q-item clickable v-ripple @click="navigateAndClose('/')">
          <q-item-section>Intro</q-item-section>
        </q-item>
        <q-item clickable v-ripple @click="navigateAndClose('/resources')">
          <q-item-section>Resources</q-item-section>
        </q-item>
        <q-item clickable v-ripple @click="navigateAndClose('/goods')">
          <q-item-section>Goods</q-item-section>
        </q-item>
        <q-item clickable v-ripple @click="navigateAndClose('/profiles')">
          <q-item-section>Profiles</q-item-section>
        </q-item>
        <q-item clickable v-ripple @click="navigateAndClose('/foods')">
          <q-item-section>Foods</q-item-section>
        </q-item>
        <q-item clickable v-ripple @click="navigateAndClose('/workouts')">
          <q-item-section>Workouts</q-item-section>
        </q-item>
        <q-item clickable v-ripple @click="navigateAndClose('/supplements')">
          <q-item-section>supplements</q-item-section>
        </q-item>
        <q-item clickable v-ripple @click="navigateAndClose('/food-log')">
          <q-item-section>Log</q-item-section>
        </q-item>
        <q-item
          v-if="!(usersStore.currentUser && usersStore.currentUser.email)"
          clickable
          v-ripple
          @click="navigateAndClose('/login')"
        >
          <q-item-section>Login</q-item-section>
        </q-item>
        <q-item v-else clickable v-ripple @click="logOffAndClose()">
          <q-item-section>Log Off</q-item-section>
        </q-item>
      </q-list>
    </q-drawer>

    <q-page-container>
      <router-view v-slot="{ Component, route: currentRoute }">
        <transition name="screen-fade" mode="out-in">
          <component :is="Component" :key="currentRoute.fullPath" />
        </transition>
      </router-view>
    </q-page-container>
    <q-footer class="bg-primary text-white q-pa-sm">
      <div class="row items-center justify-end">
        <div v-if="usersStore.currentUser && usersStore.currentUser.email">
          Current User: {{ usersStore.currentUser.fname }} {{ usersStore.currentUser.lname }} -
          {{ usersStore.currentUser.email }}
        </div>
        <div v-else class="text-caption">Not logged in</div>
      </div>
    </q-footer>

    <q-dialog v-model="showInstallDialog" persistent>
      <q-card style="min-width: 320px; max-width: 420px">
        <q-card-section>
          <div class="text-h6">Install Slim Belly App?</div>
        </q-card-section>

        <q-card-section>
          Install this app on your device for a faster, full-screen experience.
        </q-card-section>

        <q-card-actions align="right">
          <q-btn flat color="negative" label="Not now" @click="dismissInstallDialog" />
          <q-btn color="secondary" label="Install" @click="promptInstall" />
        </q-card-actions>
      </q-card>
    </q-dialog>
  </q-layout>
</template>

<script setup>
import { computed, onBeforeUnmount, onMounted, ref } from 'vue'
import { useQuasar } from 'quasar'
import { useRoute, useRouter } from 'vue-router'
import { useUsersStore } from 'stores/users'

const $q = useQuasar()
const route = useRoute()
const hoveredPath = ref(null)
const usersStore = useUsersStore()
const router = useRouter()
const leftDrawerOpen = ref(false)
const deferredInstallPrompt = ref(null)
const showInstallDialog = ref(false)

const userInitials = computed(() => {
  const firstInitial = String(usersStore.currentUser?.fname || '')
    .trim()
    .charAt(0)
  const lastInitial = String(usersStore.currentUser?.lname || '')
    .trim()
    .charAt(0)

  return `${firstInitial}${lastInitial}`.toUpperCase() || 'U'
})

async function navigate(path) {
  router.push(path)
}

async function logOff() {
  await usersStore.clearCurrentUser()
  router.push('/login')
}

async function navigateAndClose(path) {
  leftDrawerOpen.value = false
  if (path === '/login') {
    router.push(path)
    return
  }

  await navigate(path)
}

async function logOffAndClose() {
  leftDrawerOpen.value = false
  await logOff()
}

function buttonStyle(path) {
  if (route.path === path) {
    return { backgroundColor: 'var(--q-secondary)' }
  }

  if (hoveredPath.value === path) {
    return { backgroundColor: 'var(--q-accent)' }
  }

  return { backgroundColor: '#D9433F' }
}

function dismissInstallDialog() {
  showInstallDialog.value = false
}

async function promptInstall() {
  if (!deferredInstallPrompt.value) {
    showInstallDialog.value = false
    return
  }

  deferredInstallPrompt.value.prompt()
  await deferredInstallPrompt.value.userChoice
  deferredInstallPrompt.value = null
  showInstallDialog.value = false
}

function handleBeforeInstallPrompt(event) {
  event.preventDefault()
  deferredInstallPrompt.value = event
  showInstallDialog.value = true
}

function handleAppInstalled() {
  deferredInstallPrompt.value = null
  showInstallDialog.value = false
}

onMounted(() => {
  window.addEventListener('beforeinstallprompt', handleBeforeInstallPrompt)
  window.addEventListener('appinstalled', handleAppInstalled)
})

onBeforeUnmount(() => {
  window.removeEventListener('beforeinstallprompt', handleBeforeInstallPrompt)
  window.removeEventListener('appinstalled', handleAppInstalled)
})
</script>

<style scoped>
.screen-fade-enter-active,
.screen-fade-leave-active {
  transition:
    opacity 200ms ease,
    transform 200ms ease,
    filter 200ms ease;
}

.screen-fade-enter-from,
.screen-fade-leave-to {
  opacity: 0;
  transform: translateY(18px);
  filter: blur(4px);
}

.screen-fade-enter-to,
.screen-fade-leave-from {
  opacity: 1;
  transform: translateY(0);
  filter: blur(0);
}

.brand-link {
  color: inherit;
  text-decoration: none;
}

.user-initials-button {
  background-color: var(--q-secondary);
  min-width: 40px;
  min-height: 40px;
}
</style>
