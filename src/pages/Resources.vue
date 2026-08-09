<template>
  <q-page padding>
    <div class="text-h4 q-mb-lg text-center">Resources</div>

    <div
      class="row q-col-gutter-md"
      style="background-color: #fdecec; padding-bottom: 16px; padding-right: 16px"
    >
      <div class="col-12 col-sm-6 col-md-4 col-lg-4 flex justify-center">
        <q-card style="width: 75%">
          <q-card-section class="bg-accent">
            Start your journey to a healthier lifestyle here.
          </q-card-section>
          <q-expansion-item
            expand-icon="keyboard_arrow_down"
            expanded-icon="keyboard_arrow_up"
            transition-show="jump-down"
            transition-hide="jump-up"
          >
            <template v-slot:header>
              <q-chip>Quick Start</q-chip>
            </template>

            <q-card-section>
              <p class="text-center text-weight-bold q-mb-sm" style="font-size: 1.05rem">
                Steps to Perfection
              </p>
              <br />
              <p>→ Create a Profile</p>
              <p>→ Add Foods you like</p>
              <p>→ Add Workouts you like</p>
              <p>→ Add Supplements you take</p>
              <br />
              <p>→ Log your daily food consumption</p>
              <p>→ Log your daily workouts</p>
              <p>→ Log your daily supplements</p>
              <p>→ Log your weight periodically</p>
              <br />
              <p>→ Track your progress</p>
            </q-card-section>
          </q-expansion-item>
        </q-card>
      </div>

      <div class="col-12 col-sm-6 col-md-4 col-lg-4 flex justify-center">
        <q-card style="width: 75%">
          <q-expansion-item
            expand-icon="keyboard_arrow_down"
            expanded-icon="keyboard_arrow_up"
            transition-show="jump-down"
            transition-hide="jump-up"
          >
            <template v-slot:header>
              <q-chip>Slim Belly</q-chip>
            </template>

            <q-card-section>
              <p class="text-justify">Slim Belly</p>
              <br />
              <p>
                Daily diary for your health and wellness. This app is designed to help you track
                your daily habits, monitor your progress, and provide insights into your overall
                well-being. By using this app regularly, you can gain a better understanding of your
                health patterns and make informed decisions to improve your lifestyle.
              </p>
              <p class="text-center text-weight-bold q-mb-sm" style="font-size: 1.05rem">
                Track your meals, exercise routines, and supplements
              </p>
            </q-card-section>
          </q-expansion-item>
          <q-card-section>
            <img
              src="/SlimBelly.jpg"
              alt="Slim Belly"
              style="max-width: 100%; height: auto; display: block"
            />
          </q-card-section>
        </q-card>
      </div>

      <div class="col-12 col-md-4">
        <q-card flat bordered style="width: 90%; max-width: 90%; margin: 0 auto">
          <q-card-section>
            <p>More to come here</p>
          </q-card-section>
        </q-card>
      </div>

      <div class="col-12 col-md-4">
        <q-card flat bordered style="width: 90%; max-width: 90%; margin: 0 auto">
          <q-expansion-item
            expand-icon="keyboard_arrow_down"
            expanded-icon="keyboard_arrow_up"
            transition-show="jump-down"
            transition-hide="jump-up"
          >
            <template v-slot:header>
              <q-chip>Related Resources</q-chip>
            </template>
            <q-card-section>
              <div class="text-weight-bold">More to come here</div>
              <a href="https://google.com" target="_blank" rel="noopener noreferrer"> Google </a>
            </q-card-section>
          </q-expansion-item>
        </q-card>
      </div>
    </div>
  </q-page>
</template>

<script>
export default {
  name: 'ResourcesPage',
}
</script>
