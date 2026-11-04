<template>
  <q-card flat bordered>
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
      <div class="row q-py-md">
        <div class="col-12 flex justify-center">
          <q-card style="width: 100%">
            <q-card-section class="bg-secondary text-white text-center">
              Fundamentals of Slim-Macro
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
                <q-chip>Comprehensive Plan</q-chip>
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
                <q-chip>Profile - Diet Types</q-chip>
              </template>

              <q-card-section>
                <p>
                  These diet types helps you allocate your daily calories across different
                  macronutrients to support your personal wellness goals.
                </p>
                <p>
                  Each type provides allocates a certain percentage of your daily calories to
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
                        Diet Type
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
                        This diet type provides a balanced distribution of macronutrients.
                      </td>
                    </tr>

                    <tr>
                      <td style="padding: 10px; border-bottom: 1px solid #eee">
                        <strong>Low Carb</strong>
                      </td>
                      <td style="padding: 10px; border-bottom: 1px solid #eee; color: #666">
                        This diet type reduces carbohydrate intake and increases fat and protein
                        consumption.
                      </td>
                    </tr>

                    <tr>
                      <td style="padding: 10px; border-bottom: 1px solid #eee">
                        <strong>High Protein</strong>
                      </td>
                      <td style="padding: 10px; border-bottom: 1px solid #eee; color: #666">
                        This diet type increases protein intake to support muscle preservation and
                        growth.
                      </td>
                    </tr>

                    <tr>
                      <td style="padding: 10px; border-bottom: 1px solid #eee">
                        <strong>Carb Cycling</strong>
                      </td>
                      <td style="padding: 10px; border-bottom: 1px solid #eee; color: #666">
                        This diet type uses calorie cycling to protect your metabolism. By
                        alternating lower-calorie fat-loss days with higher-calorie days, you
                        prevent your body from entering "energy conservation mode." The
                        higher-calorie days naturally restore your metabolic rate to keep fat
                        burning efficient.
                        <q-chip color="warning" text-color="white"
                          >Recommended for max fat loss</q-chip
                        >
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

      <div class="row q-py-md">
        <div class="col-12 flex justify-center">
          <q-card style="width: 100%">
            <q-card-section class="bg-secondary text-white text-center"> How to </q-card-section>

            <q-expansion-item
              expand-icon="keyboard_arrow_down"
              expanded-icon="keyboard_arrow_up"
              transition-show="jump-down"
              transition-hide="jump-up"
            >
              <template v-slot:header>
                <q-chip> How do I setup my profile</q-chip>
              </template>

              <q-card-section>
                <p class="text-weight-bold q-mb-sm">Steps</p>
                > Items > Profile <br />
                > FName > LName > Sex > Age <br />
                > Start Weight > Goal Weight <br />
                > Height > Activity Level <br />
                > Daily calorie deficit <br />
                > Diet Type <br />
                > Load Template (High metabolic/carb cycling - achieves best results) <br />
                -> Review the information <br />
                > Save Profile
              </q-card-section>
            </q-expansion-item>

            <q-expansion-item
              expand-icon="keyboard_arrow_down"
              expanded-icon="keyboard_arrow_up"
              transition-show="jump-down"
              transition-hide="jump-up"
            >
              <template v-slot:header>
                <q-chip> How do I add food to my list</q-chip>
              </template>

              <q-card-section>
                <p class="text-weight-bold q-mb-sm">Steps</p>
                > Items > Food > Add Food <br />
                > Description <br />
                > Serving size > Serving Unit <br />
                > Protein > Carbs > Fat > Extra Calories <br />
                > Save Food
              </q-card-section>
            </q-expansion-item>

            <q-expansion-item
              expand-icon="keyboard_arrow_down"
              expanded-icon="keyboard_arrow_up"
              transition-show="jump-down"
              transition-hide="jump-up"
            >
              <template v-slot:header>
                <q-chip> How do I add food using Bar Code Scanner</q-chip>
              </template>

              <q-card-section>
                <p class="text-weight-bold q-mb-sm">Steps</p>
                > Items > Food > Add Food <br />
                > Scan Code <br />
                > Point phone camera on box or package bar code symbol <br />
                > Allow camera to scan code and retrieve macro information <br />
                -> Review the information <br />
                > Change information to your liking <br />
                > Save Food
              </q-card-section>
            </q-expansion-item>

            <q-expansion-item
              expand-icon="keyboard_arrow_down"
              expanded-icon="keyboard_arrow_up"
              transition-show="jump-down"
              transition-hide="jump-up"
            >
              <template v-slot:header>
                <q-chip> How do I add food from the Nutrition Database</q-chip>
              </template>

              <q-card-section>
                <p>
                  Search for foods with pre-defined macros instantly.
                  <strong>A local database of 1500 common foods</strong> sourced from the USFDA food
                  nutritional database with full macros included, our type-ahead search bar makes
                  finding your food quick and easy.
                </p>
                <p class="text-weight-bold q-mb-sm">Steps</p>
                > Items > Food > Add Food <br />
                > Get Food <br />
                > Enter search criteria <br />
                > Select food from list of options <br />
                > Use Food Selected <br />
                -> Review the information <br />
                > Save Food
              </q-card-section>
            </q-expansion-item>

            <q-expansion-item
              expand-icon="keyboard_arrow_down"
              expanded-icon="keyboard_arrow_up"
              transition-show="jump-down"
              transition-hide="jump-up"
            >
              <template v-slot:header>
                <q-chip> How do I track food I consumed</q-chip>
              </template>

              <q-card-section>
                <p class="text-weight-bold q-mb-sm">Steps</p>
                > Log > Food <br />
                > Enter search criteria <br />
                > Select food from list of options <br />
                > Select servings (consumed) <br />
                > Add to Log
              </q-card-section>
            </q-expansion-item>

            <q-expansion-item
              expand-icon="keyboard_arrow_down"
              expanded-icon="keyboard_arrow_up"
              transition-show="jump-down"
              transition-hide="jump-up"
            >
              <template v-slot:header>
                <q-chip> How do I review my Daily Food Budget</q-chip>
              </template>

              <q-card-section>
                <p class="text-weight-bold q-mb-sm">Steps</p>
                > Log > Food <br />
                > Expand "Daily Food Budget" <br />
                -> Review : Calories (consumed/budget), <br />
                Protein (consumed/budget), <br />
                Carbs (consumed/budget), <br />
                Fat (consumed/budget)
              </q-card-section>
            </q-expansion-item>

            <q-expansion-item
              expand-icon="keyboard_arrow_down"
              expanded-icon="keyboard_arrow_up"
              transition-show="jump-down"
              transition-hide="jump-up"
            >
              <template v-slot:header>
                <q-chip> How do I review my Daily Food Budget (previous day)</q-chip>
              </template>

              <q-card-section>
                <p class="text-weight-bold q-mb-sm">Steps</p>
                > Log > Food <br />
                > Expand "Daily Food Budget" <br />
                > Select date of interest from calendar control
              </q-card-section>
            </q-expansion-item>

            <q-expansion-item
              expand-icon="keyboard_arrow_down"
              expanded-icon="keyboard_arrow_up"
              transition-show="jump-down"
              transition-hide="jump-up"
            >
              <template v-slot:header>
                <q-chip> How do I see a chart of my food intake?</q-chip>
              </template>

              <q-card-section>
                <p class="text-weight-bold q-mb-sm">Steps</p>
                > Dashboard > Food Calories
              </q-card-section>
            </q-expansion-item>

            <q-expansion-item
              expand-icon="keyboard_arrow_down"
              expanded-icon="keyboard_arrow_up"
              transition-show="jump-down"
              transition-hide="jump-up"
            >
              <template v-slot:header>
                <q-chip> How do I log my weight</q-chip>
              </template>

              <q-card-section>
                <p class="text-weight-bold q-mb-sm">Steps</p>
                > Log > Weight <br />
                > Weight > Date <br />
                > Add to Log
              </q-card-section>
            </q-expansion-item>

            <q-expansion-item
              expand-icon="keyboard_arrow_down"
              expanded-icon="keyboard_arrow_up"
              transition-show="jump-down"
              transition-hide="jump-up"
            >
              <template v-slot:header>
                <q-chip> How do I see my weight log progress and project goal date?</q-chip>
              </template>

              <q-card-section>
                <p class="text-weight-bold q-mb-sm">Steps</p>
                > Log > Weight <br />
                -> Review Weight Progress chart
              </q-card-section>
            </q-expansion-item>

            <q-expansion-item
              expand-icon="keyboard_arrow_down"
              expanded-icon="keyboard_arrow_up"
              transition-show="jump-down"
              transition-hide="jump-up"
            >
              <template v-slot:header>
                <q-chip> How do I review my weight progress over time</q-chip>
              </template>

              <q-card-section>
                <p class="text-weight-bold q-mb-sm">Steps</p>
                > Dashboard > Weight and BMI progress
              </q-card-section>
            </q-expansion-item>
          </q-card>
        </div>
      </div>
    </q-expansion-item>
  </q-card>
</template>
