<template>
  <q-page class="column items-center q-px-md q-py-lg" style="min-height: 100vh">
    <img
      src="/SlimMacros.png"
      alt="Slim Macros"
      style="
        border-radius: 12px;
        max-width: 100%;
        width: 25%;
        margin-top: 16px;
        margin-bottom: 16px;
      "
    />

    <h5
      style="
        max-width: 720px;
        width: 75%;
        margin: 12px auto 16px;
        text-align: justify;
        font-size: 1.05rem;
        line-height: 1.6;
      "
    >
      Track your food, macros, workouts, supplements, weight, and BMI—all in one place.
    </h5>

    <h5
      style="
        max-width: 720px;
        width: 75%;
        margin: 12px auto 16px;
        text-align: justify;
        font-size: 0.8rem;
        line-height: 1.6;
      "
    >
      Automatically calculate your daily calorie and macro budgets, monitor your consumption against
      your goals, and see how you’re tracking throughout the day. Discover patterns, gain insights
      into your habits, make informed decisions, and take meaningful steps toward a healthier, more
      balanced you.
    </h5>

    <div class="q-pa-md text-center" style="max-width: 720px; width: 100%">
      <q-btn color="secondary" label="Let's Go!" to="/food-log" style="margin-top: 8px" />
    </div>
  </q-page>
</template>

<script setup></script>
