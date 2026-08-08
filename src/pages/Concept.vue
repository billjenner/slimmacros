<template>
  <q-page padding>
    <div class="text-h4 q-mb-lg text-center">Concept</div>

    <div
      class="row q-col-gutter-md"
      style="background-color: #fdecec; padding-bottom: 16px; padding-right: 16px"
    >
      <div class="col-12 col-sm-6 col-md-4 col-lg-4 flex justify-center">
        <q-card style="width: 60%">
          <q-expansion-item
            expand-icon="keyboard_arrow_down"
            expanded-icon="keyboard_arrow_up"
            transition-show="jump-down"
            transition-hide="jump-up"
          >
            <template v-slot:header>
              <q-chip>Room</q-chip>
            </template>

            <q-card-section>
              <p class="text-center text-weight-bold q-mb-sm" style="font-size: 1.05rem">
                Your Inner World and How You Perceive Yourself.
              </p>
              <br />
              Reflects the landscape within you—the way you see yourself, understand your place in
              the world, and experience the life unfolding around you.
            </q-card-section>
          </q-expansion-item>
          <q-card-section>
            <img src="/Room.jpg" alt="Cube" style="max-width: 100%; height: auto; display: block" />
          </q-card-section>
        </q-card>
      </div>

      <div class="col-12 col-sm-6 col-md-4 col-lg-4 flex justify-center">
        <q-card style="width: 60%">
          <q-expansion-item
            expand-icon="keyboard_arrow_down"
            expanded-icon="keyboard_arrow_up"
            transition-show="jump-down"
            transition-hide="jump-up"
          >
            <template v-slot:header>
              <q-chip>Cube</q-chip>
            </template>

            <q-card-section>
              <p class="text-center text-weight-bold q-mb-sm" style="font-size: 1.05rem">
                Your Sense of Self and Identity.
              </p>
              <br />
              The cube symbolizes the inner image you carry of yourself—the shape of your identity,
              the strength of your confidence, the presence you project, and the reflection of who
              you believe you are in the eyes of others.
            </q-card-section>
          </q-expansion-item>
          <q-card-section>
            <img src="/Cube.jpg" alt="Cube" style="max-width: 100%; height: auto; display: block" />
          </q-card-section>
        </q-card>
      </div>

      <!-- Watermelon -->

      <div class="col-12 col-sm-6 col-md-4 col-lg-4 flex justify-center">
        <q-card style="width: 60%">
          <q-expansion-item
            expand-icon="keyboard_arrow_down"
            expanded-icon="keyboard_arrow_up"
            transition-show="jump-down"
            transition-hide="jump-up"
          >
            <template v-slot:header>
              <q-chip>Ladder</q-chip>
            </template>
            <q-card-section>
              <p class="text-center text-weight-bold q-mb-sm" style="font-size: 1.05rem">
                Your Goals, Ambitions, and Personal Growth.
              </p>
              <br />
              The ladder symbolizes the journey upward—the aspirations that call you higher, the
              steps you take toward becoming who you wish to be, and the effort, courage, and
              persistence required to reach each new height.
            </q-card-section>
          </q-expansion-item>
          <q-card-section>
            <img
              src="/Ladder.jpg"
              alt="Ladder"
              style="max-width: 100%; height: auto; display: block"
            />
          </q-card-section>
        </q-card>
      </div>

      <!-- Grapes -->

      <div class="col-12 col-sm-6 col-md-4 col-lg-4 flex justify-center">
        <q-card style="width: 60%">
          <q-expansion-item
            expand-icon="keyboard_arrow_down"
            expanded-icon="keyboard_arrow_up"
            transition-show="jump-down"
            transition-hide="jump-up"
          >
            <template v-slot:header>
              <q-chip>Horse</q-chip>
            </template>
            <q-card-section>
              <p class="text-center text-weight-bold q-mb-sm" style="font-size: 1.05rem">
                Your Soulmate, Romantic Partner, and Intimate Relationships.
              </p>
              <br />
              The horse symbolizes the spirit of partnership—the qualities you are drawn to in
              another, the freedom and trust you share in intimate connection, and the depth of
              love, companionship, and devotion you hope to experience.
            </q-card-section>
          </q-expansion-item>
          <q-card-section>
            <img
              src="/Horse.jpg"
              alt="Horse"
              style="max-width: 100%; height: auto; display: block"
            />
          </q-card-section>
        </q-card>
      </div>

      <!-- Kiwi -->

      <div class="col-12 col-sm-6 col-md-4 col-lg-4 flex justify-center">
        <q-card style="width: 60%">
          <q-expansion-item
            expand-icon="keyboard_arrow_down"
            expanded-icon="keyboard_arrow_up"
            transition-show="jump-down"
            transition-hide="jump-up"
          >
            <template v-slot:header>
              <q-chip>Storm</q-chip>
            </template>
            <q-card-section>
              <p class="text-center text-weight-bold q-mb-sm" style="font-size: 1.05rem">
                Challenges, Stress, and Emotional Turbulence.
              </p>
              <br />
              The storm symbolizes the trials that move through your life—the uncertainty, conflict,
              pressure, and emotional turbulence you encounter, and the way you respond when life
              becomes difficult or overwhelming.
            </q-card-section>
          </q-expansion-item>
          <q-card-section>
            <img
              src="/Storm.jpg"
              alt="Storm"
              style="max-width: 100%; height: auto; display: block"
            />
          </q-card-section>
        </q-card>
      </div>

      <div class="col-12 col-sm-6 col-md-4 col-lg-4 flex justify-center">
        <q-card style="width: 60%">
          <q-expansion-item
            expand-icon="keyboard_arrow_down"
            expanded-icon="keyboard_arrow_up"
            transition-show="jump-down"
            transition-hide="jump-up"
          >
            <template v-slot:header>
              <q-chip>Flowers</q-chip>
            </template>
            <q-card-section>
              <p class="text-center text-weight-bold q-mb-sm" style="font-size: 1.05rem">
                Friends, Friendship, and Social Connections
              </p>
              <br />
              The flowers symbolize the people who bring color and meaning to your life—the
              friendships you nurture, the connections you cultivate, and the ways you give and
              receive companionship, trust, and belonging.
            </q-card-section>
          </q-expansion-item>
          <q-card-section>
            <img
              src="/Flowers.jpg"
              alt="Flowers"
              style="max-width: 100%; height: auto; display: block"
            />
          </q-card-section>
        </q-card>
      </div>
    </div>
    <div
      class="row q-col-gutter-md"
      style="background-color: #e96b67; margin-top: 4px; padding-right: 16px; padding-bottom: 24px"
    >
      <div class="col-12 col-md-4">
        <q-card flat bordered style="width: 90%; max-width: 90%; margin: 0 auto">
          <q-card-section>
            <p>Room → Your inner environment</p>
            <p>Cube → Your identity</p>
            <p>Ladder → Your ambitions</p>
            <p>Horse → Your relationships and desires</p>
            <p>Window → Your view of the world</p>
            <p>Storm → How you handle adversity</p>
            <p>Flowers → What you nurture and value</p>
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
              <div class="text-weight-bold">Teal Swan Article</div>
              <a
                href="https://tealswan.com/resources/articles/the-cube-test-r450/"
                target="_blank"
                rel="noopener noreferrer"
              >
                Read the Cube Test article
              </a>
            </q-card-section>
            <q-card-section>
              <div class="text-weight-bold">Neil Strauss</div>
              <a
                href="https://youtu.be/quZzZykpOPA?si=GW60pebYnSbc7iB5"
                target="_blank"
                rel="noopener noreferrer"
              >
                The Cube - A Psychology Game - performed by Neil Strauss
              </a>
            </q-card-section>

            <q-card-section>
              <div class="text-weight-bold">The Cube Psychology Test to Attract Girls</div>
              <a
                href="https://youtu.be/XS35MbPh31Q?si=05krSDVnI1ofqGMa"
                target="_blank"
                rel="noopener noreferrer"
              >
                The Cube Psychology Test to Attract Girls
              </a>
            </q-card-section>
          </q-expansion-item>
        </q-card>
      </div>
      <div class="col-12 col-md-4">
        <q-card style="width: 90%; max-width: 90%; margin: 0 auto">
          <q-card-section>
            <q-chip>The Cube</q-chip>
          </q-card-section>
          <div style="width: 100%; max-width: 100%">
            <q-video
              src="https://www.youtube.com/embed/5FIPIuw5KXY?si=o6BYI5lLmV9AH4YU"
              :ratio="16 / 9"
            />
          </div>
        </q-card>
      </div>
    </div>
  </q-page>
</template>

<script>
export default {
  name: 'DefinitionsPage',
}
</script>
