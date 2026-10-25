<template>
  <q-page class="docs-page">
    <div class="docs-content">
      <InstructionsCard />
      <NutritionCard />
      <ExerciseCard />
    </div>

    <FeedbackDialog />
  </q-page>
</template>

<script setup>
import ExerciseCard from '../components/docs/ExerciseCard.vue'
import FeedbackDialog from '../components/FeedbackDialog.vue'
import InstructionsCard from '../components/docs/InstructionsCard.vue'
import NutritionCard from '../components/docs/NutritionCard.vue'
</script>

<style scoped>
.docs-page {
  display: flex;
  flex-direction: column;
  padding: 2px;
}

.docs-content {
  flex: 1 0 auto;
}
</style>
