<template>
  <q-page class="q-pa-md">
    <div class="row justify-center">
      <div class="col-12 col-md-10 col-lg-8">
        <q-card flat bordered class="q-pa-md">
          <div class="text-h5 q-mb-md">Goods</div>

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
            <q-tab name="profiles" label="Profiles" />
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
            <q-tab-panel name="profiles" class="q-pa-none">
              <profiles-page embedded />
            </q-tab-panel>
          </q-tab-panels>
        </q-card>
      </div>
    </div>
  </q-page>
</template>

<script setup>
import { ref } from 'vue'
import FoodPage from 'pages/Food.vue'
import ProfilesPage from 'pages/Profiles.vue'
import SupplementsPage from 'pages/Supplements.vue'
import WorkoutsPage from 'pages/Workouts.vue'

const activeTab = ref('food')
</script>
