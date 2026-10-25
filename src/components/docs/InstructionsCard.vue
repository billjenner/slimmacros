<template>
  <q-card flat bordered class="q-mb-md">
    <q-expansion-item
      expand-icon="keyboard_arrow_down"
      expanded-icon="keyboard_arrow_up"
      transition-show="jump-down"
      transition-hide="jump-up"
    >
      <template v-slot:header>
        <q-item-section class="text-center">
          <div class="text-h4">Instructions</div>
        </q-item-section>
      </template>
      <div class="row q-col-gutter-md q-pa-md">
        <div class="col-12 col-sm-6 col-md-6 col-lg-6 flex justify-center">
          <q-card style="width: 95%">
            <q-card-section class="bg-secondary text-white text-center">
              Start your journey to a healthier lifestyle here.
            </q-card-section>
            <q-expansion-item
              expand-icon="keyboard_arrow_down"
              expanded-icon="keyboard_arrow_up"
              transition-show="jump-down"
              transition-hide="jump-up"
            >
              <template v-slot:header>
                <q-chip>Slim-Macro Quick Start</q-chip>
              </template>

              <q-card-section>
                <p class="text-center text-weight-bold q-mb-sm" style="font-size: 1.05rem">
                  Steps to Perfection
                </p>
                <br />
                <table style="width: 100%; border-collapse: collapse">
                  <thead>
                    <tr>
                      <th style="text-align: left; padding: 10px; border-bottom: 2px solid #ddd">
                        Step
                      </th>
                      <th style="text-align: left; padding: 10px; border-bottom: 2px solid #ddd">
                        Description
                      </th>
                    </tr>
                  </thead>

                  <tbody>
                    <tr>
                      <td style="padding: 10px; border-bottom: 1px solid #eee">1</td>
                      <td style="padding: 10px; border-bottom: 1px solid #eee">Create a Profile</td>
                    </tr>

                    <tr>
                      <td style="padding: 10px; border-bottom: 1px solid #eee">2</td>
                      <td style="padding: 10px; border-bottom: 1px solid #eee">
                        Add Food you like
                      </td>
                    </tr>

                    <tr>
                      <td style="padding: 10px; border-bottom: 1px solid #eee">3</td>
                      <td style="padding: 10px; border-bottom: 1px solid #eee">
                        Add Workouts you like
                      </td>
                    </tr>

                    <tr>
                      <td style="padding: 10px; border-bottom: 1px solid #eee">4</td>
                      <td style="padding: 10px; border-bottom: 1px solid #eee">
                        Add Supplements you take
                      </td>
                    </tr>

                    <tr>
                      <td style="padding: 10px; border-bottom: 1px solid #eee">5</td>
                      <td style="padding: 10px; border-bottom: 1px solid #eee">
                        Log your daily food consumption
                      </td>
                    </tr>

                    <tr>
                      <td style="padding: 10px; border-bottom: 1px solid #eee">6</td>
                      <td style="padding: 10px; border-bottom: 1px solid #eee">
                        Log your daily workouts
                      </td>
                    </tr>

                    <tr>
                      <td style="padding: 10px; border-bottom: 1px solid #eee">7</td>
                      <td style="padding: 10px; border-bottom: 1px solid #eee">
                        Log your daily supplements
                      </td>
                    </tr>

                    <tr>
                      <td style="padding: 10px; border-bottom: 1px solid #eee">8</td>
                      <td style="padding: 10px; border-bottom: 1px solid #eee">
                        Log your weight periodically
                      </td>
                    </tr>

                    <tr>
                      <td style="padding: 10px"></td>
                      <td style="padding: 10px"><strong>→ Track your progress</strong></td>
                    </tr>
                  </tbody>
                </table>
              </q-card-section>
            </q-expansion-item>

            <q-expansion-item
              expand-icon="keyboard_arrow_down"
              expanded-icon="keyboard_arrow_up"
              transition-show="jump-down"
              transition-hide="jump-up"
            >
              <template v-slot:header>
                <q-chip>Over All Plan</q-chip>
              </template>

              <q-card-section>
                <table style="width: 100%; border-collapse: collapse">
                  <thead>
                    <tr>
                      <th style="text-align: left; padding: 10px; border-bottom: 2px solid #ddd">
                        Strategy
                      </th>
                      <th style="text-align: left; padding: 10px; border-bottom: 2px solid #ddd">
                        Purpose
                      </th>
                    </tr>
                  </thead>

                  <tbody>
                    <tr>
                      <td style="padding: 10px; border-bottom: 1px solid #eee">
                        <strong>Calorie deficit</strong>
                      </td>
                      <td style="padding: 10px; border-bottom: 1px solid #eee; color: #666">
                        Drives fat loss
                      </td>
                    </tr>

                    <tr>
                      <td style="padding: 10px; border-bottom: 1px solid #eee">
                        <strong>Adequate protein</strong>
                      </td>
                      <td style="padding: 10px; border-bottom: 1px solid #eee; color: #666">
                        Protects muscle
                      </td>
                    </tr>

                    <tr>
                      <td style="padding: 10px; border-bottom: 1px solid #eee">
                        <strong>Resistance training</strong>
                      </td>
                      <td style="padding: 10px; border-bottom: 1px solid #eee; color: #666">
                        Preserves/builds muscle
                      </td>
                    </tr>

                    <tr>
                      <td style="padding: 10px; border-bottom: 1px solid #eee">
                        <strong>Stretching</strong>
                      </td>
                      <td style="padding: 10px; border-bottom: 1px solid #eee; color: #666">
                        Improves movement quality, becomes increasingly useful as you age.
                      </td>
                    </tr>

                    <tr>
                      <td style="padding: 10px; border-bottom: 1px solid #eee">
                        <strong>Fiber-rich food</strong>
                      </td>
                      <td style="padding: 10px; border-bottom: 1px solid #eee; color: #666">
                        Improves fullness
                      </td>
                    </tr>

                    <tr>
                      <td style="padding: 10px; border-bottom: 1px solid #eee">
                        <strong>Sleep + hydration</strong>
                      </td>
                      <td style="padding: 10px; border-bottom: 1px solid #eee; color: #666">
                        Supports adherence and performance
                      </td>
                    </tr>

                    <tr>
                      <td style="padding: 10px">
                        <strong>Supplements</strong>
                      </td>
                      <td style="padding: 10px; color: #666">Fill specific nutritional gaps</td>
                    </tr>
                    <tr>
                      <td style="padding: 10px">
                        <strong>Log daily</strong>
                      </td>
                      <td style="padding: 10px; color: #666">
                        Track nutrition, exercise, and habits. Monitor progress regularly and make
                        adjustments as needed.
                      </td>
                    </tr>
                  </tbody>
                </table>
              </q-card-section>
            </q-expansion-item>

            <q-expansion-item
              expand-icon="keyboard_arrow_down"
              expanded-icon="keyboard_arrow_up"
              transition-show="jump-down"
              transition-hide="jump-up"
            >
              <template v-slot:header>
                <q-chip>Nutrition Budget Plan</q-chip>
              </template>

              <q-card-section>
                <p>
                  The Nutrition Budget Plan helps you allocate your daily calories across different
                  macronutrients to support your fitness goals.
                </p>
                <p>
                  Each plan provides allocates a certain percentage of your daily calories to
                  protein, carbohydrates, and fats. The exact distribution can be adjusted based on
                  your individual goals and dietary preferences.
                </p>
                <p>
                  There are several pre-built templates to choose from. Select one of these or
                  customize your own.
                </p>
                <table style="width: 100%; border-collapse: collapse">
                  <thead>
                    <tr>
                      <th style="text-align: left; padding: 10px; border-bottom: 2px solid #ddd">
                        Plan
                      </th>
                      <th style="text-align: left; padding: 10px; border-bottom: 2px solid #ddd">
                        Purpose
                      </th>
                    </tr>
                  </thead>

                  <tbody>
                    <tr>
                      <td style="padding: 10px; border-bottom: 1px solid #eee">
                        <strong>Balanced</strong>
                      </td>
                      <td style="padding: 10px; border-bottom: 1px solid #eee; color: #666">
                        This plan provides a balanced distribution of macronutrients.
                      </td>
                    </tr>

                    <tr>
                      <td style="padding: 10px; border-bottom: 1px solid #eee">
                        <strong>Low Carb</strong>
                      </td>
                      <td style="padding: 10px; border-bottom: 1px solid #eee; color: #666">
                        This plan reduces carbohydrate intake and increases fat and protein
                        consumption.
                      </td>
                    </tr>

                    <tr>
                      <td style="padding: 10px; border-bottom: 1px solid #eee">
                        <strong>High Protein</strong>
                      </td>
                      <td style="padding: 10px; border-bottom: 1px solid #eee; color: #666">
                        This plan increases protein intake to support muscle preservation and
                        growth.
                      </td>
                    </tr>

                    <tr>
                      <td style="padding: 10px; border-bottom: 1px solid #eee">
                        <strong>High Metabolic</strong>
                      </td>
                      <td style="padding: 10px; border-bottom: 1px solid #eee; color: #666">
                        This plan includes days with lower calorie intake to help with fat loss,
                        while other days focus on higher calorie intake to boost metabolism.
                      </td>
                    </tr>

                    <tr>
                      <td style="padding: 10px; border-bottom: 1px solid #eee">
                        <strong>Custom</strong>
                      </td>
                      <td style="padding: 10px; border-bottom: 1px solid #eee; color: #666">
                        Your preferences.
                      </td>
                    </tr>
                  </tbody>
                </table>
              </q-card-section>
            </q-expansion-item>
          </q-card>
        </div>
      </div>
    </q-expansion-item>
  </q-card>
</template>
