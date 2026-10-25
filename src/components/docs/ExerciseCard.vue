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
          <div class="text-h4">Exercise</div>
        </q-item-section>
      </template>
      <div class="row q-col-gutter-md q-pa-md">
        <div class="col-12 flex justify-center">
          <q-card style="width: 95%">
            <q-card-section class="bg-secondary text-white text-center"> Beginner </q-card-section>

            <q-expansion-item
              expand-icon="keyboard_arrow_down"
              expanded-icon="keyboard_arrow_up"
              transition-show="jump-down"
              transition-hide="jump-up"
            >
              <template v-slot:header>
                <q-chip>Weekly Schedule</q-chip>
              </template>

              <q-card-section>
                <q-markup-table flat bordered>
                  <thead>
                    <tr>
                      <th class="text-center">Sunday</th>
                      <th class="text-center">Monday</th>
                      <th class="text-center">Tuesday</th>
                      <th class="text-center">Wednesday</th>
                      <th class="text-center">Thursday</th>
                      <th class="text-center">Friday</th>
                      <th class="text-center">Saturday</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td class="text-center">-</td>
                      <td class="text-center"><strong>Walk</strong> - Cardio - anaerobic</td>
                      <td class="text-center">
                        <strong>Warm up & Stretch</strong>
                      </td>
                      <td class="text-center"><strong>HIIT</strong> - Training Exercises</td>
                      <td class="text-center">
                        <strong>Warm up & Stretch</strong>
                      </td>
                      <td class="text-center"><strong>Walk</strong> - Cardio - anaerobic</td>
                      <td class="text-center">-</td>
                    </tr>
                  </tbody>
                </q-markup-table>
              </q-card-section>
            </q-expansion-item>

            <q-expansion-item
              expand-icon="keyboard_arrow_down"
              expanded-icon="keyboard_arrow_up"
              transition-show="jump-down"
              transition-hide="jump-up"
            >
              <template v-slot:header>
                <q-chip><strong>HIIT</strong> Training Exercises</q-chip>
              </template>

              <q-card-section>
                <div style="padding: 12px; border-bottom: 1px solid #eee">
                  <strong>Beginner routine using 40 seconds work / 20 seconds rest:</strong><br />
                </div>
                <div style="padding: 12px; border-bottom: 1px solid #eee">
                  <ul style="margin: 8px 0 0 20px; padding: 0">
                    <li>Bodyweight squats</li>
                    <li>Knee push-ups</li>
                    <li>Standing knee raises</li>
                    <li>Glute bridges</li>
                    <li>Mountain climbers</li>
                    <li>Plank</li>
                  </ul>
                </div>
                <div style="padding: 12px; border-bottom: 1px solid #eee">
                  <strong>Phase & Time:</strong><br />
                  <ul style="margin: 8px 0 0 20px; padding: 0">
                    <li>Warm-up — 5 minutes</li>
                    <li>HIIT Round 1 — 5 minutes</li>
                    <li>Rest between rounds — 1–2 minutes</li>
                    <li>HIIT Round 2 — 5 minutes</li>
                    <li>Cool-down — 3–5 minutes</li>
                    <li><strong>Total — 19–22 minutes</strong></li>
                  </ul>
                </div>
              </q-card-section>
            </q-expansion-item>
          </q-card>
        </div>
      </div>

      <div class="row q-col-gutter-md q-pa-md">
        <div class="col-12 flex justify-center">
          <q-card style="width: 95%">
            <q-card-section class="bg-secondary text-white text-center">
              Full schedule Exercises
            </q-card-section>

            <q-expansion-item
              expand-icon="keyboard_arrow_down"
              expanded-icon="keyboard_arrow_up"
              transition-show="jump-down"
              transition-hide="jump-up"
            >
              <template v-slot:header>
                <q-chip>Weekly Schedule</q-chip>
              </template>

              <q-card-section>
                <q-markup-table flat bordered>
                  <thead>
                    <tr>
                      <th class="text-center">Sunday</th>
                      <th class="text-center">Monday</th>
                      <th class="text-center">Tuesday</th>
                      <th class="text-center">Wednesday</th>
                      <th class="text-center">Thursday</th>
                      <th class="text-center">Friday</th>
                      <th class="text-center">Saturday</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td class="text-center">-</td>
                      <td class="text-center"><strong>FB</strong> Workout 1</td>
                      <td class="text-center">
                        <strong>RUN</strong> - Cardio - aerobic &amp; Legs
                      </td>
                      <td class="text-center"><strong>Walk</strong> - Cardio - anaerobic</td>
                      <td class="text-center">
                        <strong>RUN</strong> - Cardio - aerobic &amp; Legs
                      </td>
                      <td class="text-center"><strong>FB</strong> Workout 2</td>
                      <td class="text-center">-</td>
                    </tr>
                  </tbody>
                </q-markup-table>
              </q-card-section>
            </q-expansion-item>
          </q-card>
        </div>
      </div>

      <div class="row q-col-gutter-md q-pa-md">
        <div class="col-12 flex justify-center">
          <q-card style="width: 95%">
            <q-card-section class="bg-secondary text-white text-center">
              Exercise Sets
            </q-card-section>

            <q-expansion-item
              expand-icon="keyboard_arrow_down"
              expanded-icon="keyboard_arrow_up"
              transition-show="jump-down"
              transition-hide="jump-up"
            >
              <template v-slot:header>
                <q-chip><strong>Warm up</strong></q-chip>
              </template>

              <q-card-section> Open up Lymph node movements </q-card-section>
            </q-expansion-item>

            <q-expansion-item
              expand-icon="keyboard_arrow_down"
              expanded-icon="keyboard_arrow_up"
              transition-show="jump-down"
              transition-hide="jump-up"
            >
              <template v-slot:header>
                <q-chip><strong>Stretch</strong></q-chip>
              </template>

              <q-card-section>
                <q-markup-table flat bordered>
                  <thead>
                    <tr>
                      <th class="text-left">Exercise</th>
                      <th class="text-center">Reps / Sets</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>Kneel position, one leg forward, one leg back, rock back and forth</td>
                      <td class="text-center">25 x 1</td>
                    </tr>
                    <tr>
                      <td>Alternate Legs</td>
                      <td class="text-center">25 x 1</td>
                    </tr>
                    <tr>
                      <td>Cat-cow stretch</td>
                      <td class="text-center">-</td>
                    </tr>
                    <tr>
                      <td>Thoracic Twist</td>
                      <td class="text-center">-</td>
                    </tr>
                    <tr>
                      <td>Puppy Pose → Upward Dog → Child Pose</td>
                      <td class="text-center">-</td>
                    </tr>
                  </tbody>
                </q-markup-table>
                <div style="padding: 24px; border-bottom: 1px solid #eee">
                  <strong>Ref:</strong>
                  <a
                    href="https://www.youtube.com/watch?v=KCjIz9xurqk&t=898s"
                    target="_blank"
                    rel="noopener noreferrer"
                  >
                    https://www.youtube.com/watch?v=KCjIz9xurqk&amp;t=898s
                  </a>
                </div>
              </q-card-section>
            </q-expansion-item>

            <q-expansion-item
              expand-icon="keyboard_arrow_down"
              expanded-icon="keyboard_arrow_up"
              transition-show="jump-down"
              transition-hide="jump-up"
            >
              <template v-slot:header>
                <q-chip><strong>FB</strong> Workout Set #1</q-chip>
              </template>

              <q-card-section>
                <q-markup-table flat bordered>
                  <thead>
                    <tr>
                      <th class="text-left">Exercise</th>
                      <th class="text-center">Reps</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>Warm Up &amp; Stretch</td>
                      <td class="text-center">-</td>
                    </tr>
                    <tr>
                      <td>Kneel, Arm back and forth</td>
                      <td class="text-center">25 x 15 x 4</td>
                    </tr>
                    <tr>
                      <td>Hip thrust double hand</td>
                      <td class="text-center">35 x 25 x 3</td>
                    </tr>
                    <tr>
                      <td>Clean (ground other side to sky)</td>
                      <td class="text-center">35 x 25 x 1</td>
                    </tr>
                    <tr>
                      <td>Halos</td>
                      <td class="text-center">20 x 25 x 3</td>
                    </tr>
                    <tr>
                      <td>Pull downs</td>
                      <td class="text-center">110 x 10 x 3</td>
                    </tr>
                    <tr>
                      <td>180 degree rotations</td>
                      <td class="text-center">20 x 25 x 3</td>
                    </tr>
                    <tr>
                      <td>KB Curl → KB overhead</td>
                      <td class="text-center">35 x 15 x 3</td>
                    </tr>
                  </tbody>
                </q-markup-table>
              </q-card-section>
            </q-expansion-item>

            <q-expansion-item
              expand-icon="keyboard_arrow_down"
              expanded-icon="keyboard_arrow_up"
              transition-show="jump-down"
              transition-hide="jump-up"
            >
              <template v-slot:header>
                <q-chip><strong>FB</strong> - Workout Set #2</q-chip>
              </template>

              <q-card-section>
                <q-markup-table flat bordered>
                  <thead>
                    <tr>
                      <th class="text-left">Exercise</th>
                      <th class="text-center">Reps</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>Warm Up &amp; Stretch</td>
                      <td class="text-center">-</td>
                    </tr>
                    <tr>
                      <td>Fly</td>
                      <td class="text-center">15 x 10 x 3</td>
                    </tr>
                    <tr>
                      <td>Hip thrust single hand alternate</td>
                      <td class="text-center">35 x 25 x 3</td>
                    </tr>
                    <tr>
                      <td>Shovels</td>
                      <td class="text-center">-</td>
                    </tr>
                    <tr>
                      <td>Around the world</td>
                      <td class="text-center">35 x 15 x 3</td>
                    </tr>
                    <tr>
                      <td>Back Rows</td>
                      <td class="text-center">110 x 10 x 3</td>
                    </tr>
                    <tr>
                      <td>V rotations</td>
                      <td class="text-center">20 x 25 x 3</td>
                    </tr>
                    <tr>
                      <td>KB tricepts</td>
                      <td class="text-center">35 x 15 x 3</td>
                    </tr>
                  </tbody>
                </q-markup-table>
              </q-card-section>
            </q-expansion-item>

            <q-expansion-item
              expand-icon="keyboard_arrow_down"
              expanded-icon="keyboard_arrow_up"
              transition-show="jump-down"
              transition-hide="jump-up"
            >
              <template v-slot:header>
                <q-chip><strong>Run</strong> - Cardio (aerobic) & Legs</q-chip>
              </template>

              <q-card-section>
                <q-markup-table flat bordered>
                  <thead>
                    <tr>
                      <th class="text-left">Exercise</th>
                      <th class="text-center">Reps</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>Run 15 minutes</td>
                      <td class="text-center">-</td>
                    </tr>
                    <tr>
                      <td>Leg Lifts outside</td>
                      <td class="text-center">25 x 1</td>
                    </tr>
                    <tr>
                      <td>Leg Lifts inside</td>
                      <td class="text-center">25 x 1</td>
                    </tr>
                    <tr>
                      <td>Body weight squat</td>
                      <td class="text-center">25 x 3</td>
                    </tr>
                    <tr>
                      <td>Body weight squat, stretch to left side</td>
                      <td class="text-center">25 x 1</td>
                    </tr>
                    <tr>
                      <td>Body weight squat, stretch to right side</td>
                      <td class="text-center">25 x 1</td>
                    </tr>
                  </tbody>
                </q-markup-table>
              </q-card-section>
            </q-expansion-item>

            <q-expansion-item
              expand-icon="keyboard_arrow_down"
              expanded-icon="keyboard_arrow_up"
              transition-show="jump-down"
              transition-hide="jump-up"
            >
              <template v-slot:header>
                <q-chip><strong>Walk</strong> - Cardio (anaerobic)</q-chip>
              </template>

              <q-card-section>
                <div style="padding: 12px; border-bottom: 1px solid #eee">
                  <strong>Walk 2 miles</strong><br />
                </div>
                <div style="padding: 12px; border-bottom: 1px solid #eee">
                  Maintain a walking pace faster than 3 mph and complete the 2-mile course in 40
                  minutes or less.
                </div>
              </q-card-section>
            </q-expansion-item>
          </q-card>
        </div>
      </div>
    </q-expansion-item>
  </q-card>
</template>
