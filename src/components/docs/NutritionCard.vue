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
          <div class="text-h4">Nutrition</div>
        </q-item-section>
      </template>
      <div class="row q-py-md">
        <div class="col-12 flex justify-center">
          <q-card style="width: 100%">
            <q-card-section class="bg-secondary text-white text-center">
              Supplements
            </q-card-section>

            <q-expansion-item
              expand-icon="keyboard_arrow_down"
              expanded-icon="keyboard_arrow_up"
              transition-show="jump-down"
              transition-hide="jump-up"
            >
              <template v-slot:header>
                <q-chip>Supplement Suggestions</q-chip>
              </template>

              <q-card-section>
                <td style="padding: 20px">
                  <p>
                    <strong>NOTE -</strong> These Supplement Suggestions are not based on medical
                    advice and should be used at your own discretion. Please consult with a
                    healthcare professional before starting any new supplement regimen.
                  </p>
                </td>
                <table style="width: 100%; border-collapse: collapse">
                  <thead>
                    <tr>
                      <th style="text-align: left; padding: 12px; border-bottom: 2px solid #ccc">
                        Supplement
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
                        <p><span style="color: #666">64 oz minimum/day</span></p>
                      </td>
                      <td style="padding: 12px; border-bottom: 1px solid #eee">
                        Breaking down stored fat requires several biochemical reactions that occur
                        in a hydrated environment.
                      </td>
                    </tr>

                    <tr>
                      <td style="padding: 12px; border-bottom: 1px solid #eee">
                        <strong>Protein Powder</strong>
                        <p><span style="color: #666">As needed to keep protein up.</span></p>
                      </td>
                      <td style="padding: 12px; border-bottom: 1px solid #eee">
                        Makes it easier to reach your protein target while dieting.
                      </td>
                    </tr>

                    <tr>
                      <td style="padding: 12px; border-bottom: 1px solid #eee">
                        <strong>Creatine Monohydrate</strong>
                        <p><span style="color: #666">5 g/day</span></p>
                      </td>
                      <td style="padding: 12px; border-bottom: 1px solid #eee">
                        Helps maintain strength and muscle during a calorie deficit.
                      </td>
                    </tr>

                    <tr>
                      <td style="padding: 12px; border-bottom: 1px solid #eee">
                        <strong>Omega-3 (Fish Oil)</strong>
                        <p><span style="color: #666">2 g/day EPA + DHA</span></p>
                      </td>
                      <td style="padding: 12px; border-bottom: 1px solid #eee">
                        Provides EPA and DHA; useful when you're not eating fish.
                      </td>
                    </tr>

                    <tr>
                      <td style="padding: 12px; border-bottom: 1px solid #eee">
                        <strong>Krill Oil</strong><br />
                        <p><span style="color: #666">500 mg/day</span></p>
                        <span style="color: #666">(Ocean crustaceans)</span>
                      </td>
                      <td style="padding: 12px; border-bottom: 1px solid #eee">
                        EPA + DHA, antioxidant properties, and phospholipids that help form cell
                        membranes and transport fats.
                      </td>
                    </tr>

                    <tr>
                      <td style="padding: 12px; border-bottom: 1px solid #eee">
                        <strong>Multivitamin</strong><br />
                      </td>
                      <td style="padding: 12px; border-bottom: 1px solid #eee">
                        Some popular multivitamin options include:
                        <ul style="margin: 8px 0 0 20px; padding: 0">
                          <li>AG1</li>
                          <li>Huel Daily Greens</li>
                          <li>Live It Up Super Greenst</li>
                          <li>Thorne Daily Greens Plus</li>
                          <li>IM8 Daily Essentials</li>
                          <li>Amazing Grass Greens Blend</li>
                          <li>Nested Naturals Super Greens</li>
                        </ul>
                        <hr />
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
                        <p><span style="color: #666">D3 (cholecalciferol)</span></p>
                        <p><span style="color: #666">500 UI, 100 MCG</span></p>
                      </td>
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
                <td style="padding: 20px">
                  <p>
                    <strong>NOTE -</strong> These Supplement Suggestions are not based on medical
                    advice and should be used at your own discretion. Please consult with a
                    healthcare professional before starting any new supplement regimen.
                  </p>
                </td>
                <q-chip color="accent" text-color="white"
                  >Apple Cider Vinegar Fat-Burning Drink (Spicy).</q-chip
                >
                <ul>
                  <li>Best first thing in the morningin the morning.</li>
                </ul>
                <ul>
                  <li>Apple Cider Vinegar (ACV) — 2 Tbsp (Bragg's or other unfiltered brands)</li>
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
                <q-chip>Fasting Supplements</q-chip>
              </template>

              <q-card-section>
                <td style="padding: 20px">
                  <p>
                    <strong>NOTE -</strong> These Supplement Suggestions are not based on medical
                    advice and should be used at your own discretion. Please consult with a
                    healthcare professional before starting any new supplement regimen.
                  </p>
                </td>
                <q-chip color="accent" text-color="white">Bone Broth</q-chip>
                <ul>
                  <li>
                    Fluid and electrolytes — sodium, potassium, and sometimes magnesium can help
                    with headaches, weakness, and that “flat” feeling during fasting.
                  </li>
                  <li>
                    Some protein — collagen/gelatin can reduce hunger and may make a longer fast
                    more comfortable.
                  </li>
                  <li>
                    Warmth and satiety — a cup of broth can psychologically make a fast much easier
                    to stick with.
                  </li>
                  <li>
                    Very few calories — depending on the broth, often roughly 30–60 calories per
                    cup.
                  </li>
                </ul>
                <hr />
                <q-chip color="accent" text-color="white">Coconut Oil</q-chip>
                <p style="padding: 20px">
                  Coconut oil is almost entirely fat, particularly medium-chain triglycerides
                  (MCTs). MCTs are rapidly absorbed and can increase ketone production, which may:
                  Reduce hunger for some people, Provide readily available energy, reduce the “low
                  energy” feeling, and make it easier to fast longer.
                </p>
                <ul>
                  <li>Useful when fasting Useful on a empty stomic.</li>
                  <li>Useful taken in the morning on an empty stomach before coffee or water</li>
                  <li>May make it easier to sleep if taken before bed while fasting.</li>
                </ul>
                <p style="padding-left: 1.5rem">
                  Up to 1 tablespoon coconut oil Why: MCTs are rapidly delivered to and metabolized
                  by the liver, where they can be converted to energy and ketones. In moderation,
                  they will not trigger Cortisol.
                </p>
                <p style="padding-left: 1.5rem">
                  One tablespoon has approximately 120 calories, so use cautiously with in your
                  calorie budget.
                </p>
              </q-card-section>
            </q-expansion-item>
          </q-card>
        </div>
      </div>
    </q-expansion-item>
  </q-card>
</template>
