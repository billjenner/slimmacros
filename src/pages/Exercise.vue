<template>
  <q-page class="flex flex-center q-pa-md">
    <q-card class="q-pa-lg" style="width: min(100%, 640px)">
      <div class="text-h5 text-center q-mb-md">Exercises</div>

      <q-form ref="formRef" class="q-gutter-md q-mb-lg" @submit.prevent="save">
        <div class="text-subtitle1">{{ editingId ? 'Edit exercise' : 'Add exercise' }}</div>
        <q-input
          v-model="form.name"
          label="Name"
          outlined
          dense
          lazy-rules="ondemand"
          :rules="[(v) => !!(v && v.trim()) || 'Name is required']"
        />
        <q-file
          v-model="mediaFile"
          label="Video or image (PNG, JPEG, GIF)"
          accept="video/*,image/png,image/jpeg,image/gif"
          outlined
          dense
          clearable
          :hint="editingId && currentMediaPath ? `Current: ${currentMediaPath}` : ''"
        >
          <template #prepend><q-icon name="upload" /></template>
        </q-file>
        <div class="row q-gutter-sm">
          <q-btn
            type="submit"
            color="primary"
            :label="editingId ? 'Update' : 'Add'"
            :loading="saving"
          />
          <q-btn v-if="editingId" flat label="Cancel" @click="resetForm" />
        </div>
      </q-form>

      <div v-if="error" class="text-negative q-mb-sm">{{ error }}</div>

      <div v-if="!rows.length && !loading" class="text-center text-grey-7">No exercises yet.</div>

      <q-list v-else bordered separator class="rounded-borders">
        <q-item v-for="row in rows" :key="row.exercise_id">
          <q-item-section>
            <q-item-label>{{ row.name }}</q-item-label>
            <q-item-label caption>{{ row.video_path || row.image_path }}</q-item-label>
          </q-item-section>
          <q-item-section side>
            <div class="row q-gutter-xs">
              <q-btn
                v-if="row.video_path || row.image_path"
                flat
                round
                dense
                :icon="row.video_path ? 'play_circle' : 'image'"
                :aria-label="row.video_path ? 'Preview video' : 'Preview image'"
                @click="preview(row)"
              />
              <q-btn
                flat
                round
                dense
                icon="edit"
                aria-label="Edit"
                @click="startEdit(row)"
              />
              <q-btn
                flat
                round
                dense
                color="negative"
                icon="delete"
                aria-label="Delete"
                @click="confirmDelete(row)"
              />
            </div>
          </q-item-section>
        </q-item>
      </q-list>

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
    </q-card>
  </q-page>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { useQuasar } from 'quasar'
import { supabase } from 'src/lib/supabase'
import { notifySuccess } from 'src/utils/notify'

const BUCKET = 'exercise-videos'

const $q = useQuasar()
const rows = ref([])
const loading = ref(false)
const saving = ref(false)
const error = ref('')
const formRef = ref(null)
const editingId = ref(null)
const form = ref({ name: '', video_path: null, image_path: null })
const mediaFile = ref(null)
const showPreview = ref(false)
const previewUrl = ref('')
const previewType = ref('')
const currentMediaPath = computed(() => form.value.video_path || form.value.image_path)

function resetForm() {
  editingId.value = null
  form.value = { name: '', video_path: null, image_path: null }
  mediaFile.value = null
  formRef.value?.resetValidation()
}

async function load() {
  if (!supabase) {
    error.value = 'Supabase is not configured.'
    return
  }
  loading.value = true
  const { data, error: err } = await supabase.from('exercise').select('*').order('name')
  loading.value = false
  if (err) {
    error.value = err.message
    return
  }
  error.value = ''
  rows.value = data || []
}

function startEdit(row) {
  editingId.value = row.exercise_id
  form.value = {
    name: row.name,
    video_path: row.video_path,
    image_path: row.image_path,
  }
  mediaFile.value = null
}

async function uploadMedia(file) {
  const allowedType = file.type.startsWith('video/') || ['image/png', 'image/jpeg', 'image/gif'].includes(file.type)
  if (!allowedType) throw new Error('Choose a video or a PNG, JPEG, or GIF image.')

  const ext = (file.name.split('.').pop() || (file.type === 'image/jpeg' ? 'jpg' : 'mp4')).toLowerCase()
  const base = form.value.name
    .trim()
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
  const path = `${base || 'exercise'}-${Date.now()}.${ext}`
  const { error: err } = await supabase.storage
    .from(BUCKET)
    .upload(path, file, { contentType: file.type, upsert: false })
  if (err) throw err
  return path
}

async function removeMedia(path) {
  if (path) await supabase.storage.from(BUCKET).remove([path])
}

async function save() {
  error.value = ''
  if (!editingId.value && !mediaFile.value) {
    error.value = 'Please choose a video or image to upload.'
    return
  }
  saving.value = true
  try {
    const oldPath = currentMediaPath.value
    let videoPath = form.value.video_path
    let imagePath = form.value.image_path
    let newPath = null
    if (mediaFile.value) {
      newPath = await uploadMedia(mediaFile.value)
      if (mediaFile.value.type.startsWith('video/')) {
        videoPath = newPath
        imagePath = null
      } else {
        videoPath = null
        imagePath = newPath
      }
    }

    const payload = { name: form.value.name.trim(), video_path: videoPath, image_path: imagePath }
    const query = editingId.value
      ? supabase.from('exercise').update(payload).eq('exercise_id', editingId.value)
      : supabase.from('exercise').insert(payload)
    const { error: err } = await query
    if (err) {
      if (newPath) await removeMedia(newPath)
      throw err
    }
    if (editingId.value && newPath && oldPath !== newPath) await removeMedia(oldPath)

    notifySuccess($q, editingId.value ? 'Exercise updated' : 'Exercise added')
    resetForm()
    await load()
  } catch (e) {
    error.value = e.message || String(e)
  } finally {
    saving.value = false
  }
}

function confirmDelete(row) {
  $q.dialog({
    title: 'Delete exercise',
    message: `Delete "${row.name}" and its media?`,
    cancel: true,
    ok: { label: 'OK', color: 'primary', textColor: 'white', unelevated: true },
    persistent: true,
  }).onOk(async () => {
    const { error: err } = await supabase
      .from('exercise')
      .delete()
      .eq('exercise_id', row.exercise_id)
    if (err) {
      error.value = err.message
      return
    }
    await removeMedia(row.video_path)
    await removeMedia(row.image_path)
    if (editingId.value === row.exercise_id) resetForm()
    notifySuccess($q, 'Exercise deleted')
    await load()
  })
}

async function preview(row) {
  const path = row.video_path || row.image_path
  const isVideo = !!row.video_path
  const { data, error: err } = await supabase.storage
    .from(BUCKET)
    .createSignedUrl(path, 3600)
  if (err) {
    error.value = err.message
    return
  }
  previewUrl.value = data.signedUrl
  previewType.value = isVideo ? 'video' : 'image'
  showPreview.value = true
}

onMounted(load)
</script>
