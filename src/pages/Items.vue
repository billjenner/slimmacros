<template>
  <q-page>
    <div class="row justify-center">
      <div class="col-12 col-md-10 col-lg-8">
        <q-card flat bordered>
          <div class="text-h5 q-ma-md">Items</div>

          <q-tabs
            v-model="activeTab"
            align="left"
            dense
            class="text-primary"
            indicator-color="accent"
          >
            <q-tab name="food" label="Food" />
            <q-tab name="workouts" label="Workouts" />
            <q-tab name="supplements" label="Supplements" />
            <q-tab name="profile" label="Profile" />
          </q-tabs>

          <q-separator class="q-my-md" />

          <q-tab-panels v-model="activeTab" animated>
            <q-tab-panel name="food" class="q-pa-none">
              <food-page embedded />
            </q-tab-panel>
            <q-tab-panel name="workouts" class="q-pa-none">
              <workouts-page embedded />
            </q-tab-panel>
            <q-tab-panel name="supplements" class="q-pa-none">
              <supplements-page embedded />
            </q-tab-panel>
            <q-tab-panel name="profile" class="q-pa-none">
              <profile-page embedded />
            </q-tab-panel>
          </q-tab-panels>
        </q-card>
      </div>
    </div>
  </q-page>
</template>

<script setup>
import { ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import FoodPage from 'pages/Food.vue'
import ProfilePage from 'src/pages/Profile.vue'
import SupplementsPage from 'pages/Supplements.vue'
import WorkoutsPage from 'pages/Workouts.vue'

const route = useRoute()
const router = useRouter()
const validTabs = ['food', 'workouts', 'supplements', 'profile']
const activeTab = ref(getTabFromQuery(route.query.tab))

function getTabFromQuery(tab) {
  return validTabs.includes(tab) ? tab : 'food'
}

watch(activeTab, (tab) => {
  const nextQuery = { ...route.query }

  if (tab === 'food') {
    delete nextQuery.tab
  } else {
    nextQuery.tab = tab
  }

  if (route.query.tab !== nextQuery.tab) {
    router.replace({ query: nextQuery })
  }
})

watch(
  () => route.query.tab,
  (tab) => {
    const nextTab = getTabFromQuery(tab)
    if (activeTab.value !== nextTab) {
      activeTab.value = nextTab
    }
  },
)
</script>
