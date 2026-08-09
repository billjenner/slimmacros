<template>
  <q-page padding>
    <div class="text-h4 q-mb-lg text-center">Resources</div>

    <div
      class="row q-col-gutter-md"
      style="background-color: #fdecec; padding-bottom: 16px; padding-right: 16px"
    >
      <div class="col-12 col-sm-6 col-md-6 col-lg-6 flex justify-center">
        <q-card style="width: 95%">
          <q-card-section class="bg-accent text-center">
            Start your journey to a healthier lifestyle here.
          </q-card-section>
          <q-expansion-item
            expand-icon="keyboard_arrow_down"
            expanded-icon="keyboard_arrow_up"
            transition-show="jump-down"
            transition-hide="jump-up"
          >
            <template v-slot:header>
              <q-chip>Slim-Belly Quick Start</q-chip>
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
                    <td style="padding: 10px; border-bottom: 1px solid #eee">Add Foods you like</td>
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
              <q-chip>Over all Plan</q-chip>
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
                      <strong>Fiber-rich foods</strong>
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
                </tbody>
              </table>
            </q-card-section>
          </q-expansion-item>
        </q-card>
      </div>

      <div class="col-12 col-sm-6 col-md-6 col-lg-6 flex justify-center">
        <q-card style="width: 95%">
          <q-card-section class="bg-accent text-center"> Suppliments </q-card-section>

          <q-expansion-item
            expand-icon="keyboard_arrow_down"
            expanded-icon="keyboard_arrow_up"
            transition-show="jump-down"
            transition-hide="jump-up"
          >
            <template v-slot:header>
              <q-chip>Suppliment Recomendations</q-chip>
            </template>

            <q-card-section>
              <table style="width: 100%; border-collapse: collapse">
                <thead>
                  <tr>
                    <th style="text-align: left; padding: 12px; border-bottom: 2px solid #ccc">
                      Supplement
                    </th>
                    <th style="text-align: left; padding: 12px; border-bottom: 2px solid #ccc">
                      Recommendation
                    </th>
                    <th style="text-align: left; padding: 12px; border-bottom: 2px solid #ccc">
                      Purpose / Benefits
                    </th>
                  </tr>
                </thead>

                <tbody>
                  <tr>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">
                      <strong>Water</strong>
                    </td>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">64 oz minimum/day</td>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">
                      Breaking down stored fat requires several biochemical reactions that occur in
                      a hydrated environment.
                    </td>
                  </tr>

                  <tr>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">
                      <strong>Protein Powder</strong>
                    </td>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">20–40 g/serving</td>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">
                      Makes it easier to reach your protein target while dieting.
                    </td>
                  </tr>

                  <tr>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">
                      <strong>Creatine Monohydrate</strong>
                    </td>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">5 g/day</td>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">
                      Helps maintain strength and muscle during a calorie deficit.
                    </td>
                  </tr>

                  <tr>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">
                      <strong>Omega-3 (Fish Oil)</strong>
                    </td>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">2 g/day EPA + DHA</td>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">
                      Provides EPA and DHA; useful when you're not eating fish.
                    </td>
                  </tr>

                  <tr>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">
                      <strong>Krill Oil</strong><br />
                      <span style="color: #666">(Ocean crustaceans)</span>
                    </td>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">500 mg/day</td>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">
                      EPA + DHA, antioxidant properties, and phospholipids that help form cell
                      membranes and transport fats.
                    </td>
                  </tr>

                  <tr>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">
                      <strong>Multivitamin</strong><br />
                      <span style="color: #666">(AG1 recommended)</span>
                    </td>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">1 daily serving</td>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">
                      AG1 combines a large number of ingredients into one daily serving.
                      <ul style="margin: 8px 0 0 20px; padding: 0">
                        <li>Vitamins &amp; minerals — nutritional support</li>
                        <li>Prebiotics &amp; probiotics — digestive/gut support</li>
                        <li>Plant extracts and greens — various phytonutrients</li>
                        <li>Antioxidant compounds</li>
                        <li>Adaptogen-type ingredients</li>
                        <li>Digestive enzymes</li>
                      </ul>
                    </td>
                  </tr>

                  <tr>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">
                      <strong>D3 + K2</strong><br />
                      <span style="color: #666">D3 (cholecalciferol)</span>
                    </td>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">500 UI, 100 MCG</td>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">
                      <ul style="margin: 8px 0 0 20px; padding: 0">
                        <li>D3 &amp; increases calcium absorption</li>
                        <li>K2 &amp; helps activate calcium-regulating proteins</li>
                      </ul>
                    </td>
                  </tr>

                  <tr>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">
                      <strong>Magnesium</strong><br />
                      <span style="color: #666">(Magnesium glycinate)</span>
                    </td>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">200-400 mg/day</td>
                    <td style="padding: 12px; border-bottom: 1px solid #eee">
                      <ul style="margin: 8px 0 0 20px; padding: 0">
                        <li>Supports muscle and nerve function</li>
                        <li>Helps produce energy and helps with recovery</li>
                        <li>Supports muscle contraction and relaxation</li>
                        <li>Helps maintain electrolyte balance</li>
                      </ul>
                    </td>
                  </tr>

                  <tr>
                    <td style="padding: 12px">
                      <strong>Electrolytes</strong>
                    </td>
                    <td style="padding: 12px">As needed</td>
                    <td style="padding: 12px">
                      Maintain fluid balance, nerve function, muscle function, and blood pressure.
                      <br /><br />

                      <strong>
                        Avoid electrolytes with Sucralose, Aspartame, and even Stevia.
                      </strong>
                      These not only fool your tongue but also your body and increase cortisol and
                      make you hungrier.
                      <br /><br />

                      <strong>Some options:</strong>
                      Redmond Re-Lyte Unflavored, Hydrant Unflavored, SALTT Clean Slate
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
              <q-chip>Fat Burning Morning Drink</q-chip>
            </template>

            <q-card-section>
              <ul>
                <li>Bragg's Apple Cider Vinegar (ACV) — 2 Tbsp</li>
                <li>Cayenne pepper</li>
                <li>Turmeric — ¼ tsp</li>
                <li>Lemon juice — ¼ tsp</li>
                <li>Ginger — ¼ tsp</li>
                <li>Water — 2 cups</li>
                <li>
                  Optional:
                  <ul>
                    <li>Cinnamon</li>
                    <li>A small amount of honey</li>
                  </ul>
                </li>
              </ul>
            </q-card-section>
          </q-expansion-item>
          <q-expansion-item
            expand-icon="keyboard_arrow_down"
            expanded-icon="keyboard_arrow_up"
            transition-show="jump-down"
            transition-hide="jump-up"
          >
            <template v-slot:header>
              <q-chip>Coconut Oil</q-chip>
            </template>

            <q-card-section>
              <ul>
                <li>Useful when fasting Useful on a empty stomic.</li>
                <li>Useful taken in the morning on an empty stomach before coffee or water</li>
              </ul>
              <p style="padding-left: 1.5rem">
                Up to 1 tablespoon coconut oil Why: MCTs are rapidly delivered to and metabolized by
                the liver, where they can be converted to energy and ketones. In moderation, they
                will not trigger Cortisol.
              </p>
              <p style="padding-left: 1.5rem">
                One tablespoon has approximately 120 calories, so use cautiously with in your
                calorie budget.
              </p>
            </q-card-section>
          </q-expansion-item>
        </q-card>
      </div>

      <div class="col-12 col-md-4">
        <q-card flat bordered style="width: 90%; max-width: 90%; margin: 0 auto">
          <q-card-section>
            <p>HITT Training Exercises</p>
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
