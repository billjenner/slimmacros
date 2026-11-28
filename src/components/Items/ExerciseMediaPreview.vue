<template>
  <q-btn
    v-if="exercise?.video_path || exercise?.image_path"
    flat
    round
    dense
    :icon="exercise.video_path ? 'play_circle' : 'image'"
    :aria-label="exercise.video_path ? 'Preview video' : 'Preview image'"
    :loading="loading"
    @click.stop="preview"
  />

  <q-dialog v-model="showPreview">
    <q-card style="width: min(100%, 560px)">
      <video
        v-if="previewType === 'video'"
        :src="previewUrl"
        controls
        autoplay
        style="width: 100%"
      />
      <q-img v-else-if="previewUrl" :src="previewUrl" fit="contain" />
    </q-card>
  </q-dialog>
</template>

<script setup>
import { ref } from 'vue'
import { supabase } from 'src/lib/supabase'

const props = defineProps({
  exercise: {
    type: Object,
    default: null,
  },
})
const emit = defineEmits(['error'])
const showPreview = ref(false)
const previewUrl = ref('')
const previewType = ref('')
const loading = ref(false)

async function preview() {
  if (!supabase) {
    emit('error', 'Supabase is not configured.')
    return
  }

  const exercise = props.exercise
  loading.value = true
  try {
    const { data, error } = await supabase.storage
      .from('exercise-videos')
      .createSignedUrl(exercise.video_path || exercise.image_path, 3600)
    if (error) {
      emit('error', error.message)
      return
    }
    if (props.exercise !== exercise) return
    previewUrl.value = data.signedUrl
    previewType.value = exercise.video_path ? 'video' : 'image'
    showPreview.value = true
  } catch (error) {
    emit('error', error.message || String(error))
  } finally {
    loading.value = false
  }
}
</script>
