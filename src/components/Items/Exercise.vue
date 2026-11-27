<template>
  <div>
    <div class="row items-center justify-between q-mx-md q-mb-md">
      <div class="text-h5">Exercises</div>
      <q-btn
        color="primary"
        class="q-mb-sm"
        unelevated
        :label="showExerciseForm ? 'Hide Form' : 'Add Exercise'"
        :aria-expanded="showExerciseForm"
        @click="showExerciseForm = !showExerciseForm"
      />
    </div>

    <q-form
      v-if="showExerciseForm"
      ref="formRef"
      class="q-gutter-md q-mb-lg"
      @submit.prevent="save"
    >
      <q-card flat bordered class="q-pa-md bg-grey-1">
        <div class="text-subtitle1 q-mb-sm">Exercise details</div>
        <div class="row q-col-gutter-md">
          <div class="col-12">
            <q-input
              v-model="form.name"
              label="Name"
              filled
              dense
              lazy-rules="ondemand"
              :rules="[(v) => !!(v && v.trim()) || 'Name is required']"
            />
          </div>
          <div class="col-12">
            <q-input
              v-model="form.duration"
              type="number"
              step="1"
              label="Duration"
              filled
              dense
              lazy-rules="ondemand"
              :rules="[optionalIntegerRule]"
            />
          </div>
          <div class="col-4">
            <q-input
              v-model="form.weight"
              type="number"
              step="1"
              label="Weight"
              filled
              dense
              lazy-rules="ondemand"
              :rules="[optionalIntegerRule]"
            />
          </div>
          <div class="col-4">
            <q-input
              v-model="form.reps"
              type="number"
              step="1"
              label="Reps"
              filled
              dense
              lazy-rules="ondemand"
              :rules="[optionalIntegerRule]"
            />
          </div>
          <div class="col-4">
            <q-input
              v-model="form.sets"
              type="number"
              step="1"
              label="Sets"
              filled
              dense
              lazy-rules="ondemand"
              :rules="[optionalIntegerRule]"
            />
          </div>
          <div class="col-12">
            <q-file
              v-model="mediaFile"
              label="Video or image (PNG, JPEG, GIF)"
              accept="video/*,image/png,image/jpeg,image/gif"
              filled
              dense
              clearable
              :hint="editingId && currentMediaPath ? `Current: ${currentMediaPath}` : ''"
            >
              <template #prepend><q-icon name="upload" /></template>
            </q-file>
          </div>
        </div>
      </q-card>

      <q-card flat bordered class="q-pa-md bg-grey-1">
        <div class="text-subtitle1 q-mb-sm">Preferences</div>
        <div class="row q-col-gutter-md">
          <div v-if="isAdmin" class="col-12 col-md-4">
            <q-toggle v-model="form.is_active" label="Active" />
          </div>
          <div v-if="isAdmin" class="col-12 col-md-4">
            <q-toggle v-model="form.system_defined" label="System defined" />
          </div>
          <div class="col-12 col-md-4">
            <q-toggle v-model="form.share_with_others" label="Share with others" />
          </div>
        </div>
      </q-card>
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

    <q-toggle v-model="includeSharedExercises" label="Include shared exercises" />

    <div v-if="!rows.length && !loading" class="text-center text-grey-7">No exercises yet.</div>

    <q-list v-else bordered separator class="rounded-borders">
      <q-item v-for="row in rows" :key="row.exercise_id">
        <q-item-section>
          <q-item-label>{{ row.name }}</q-item-label>
          <q-item-label caption>{{ row.video_path || row.image_path }}</q-item-label>
          <q-item-label caption>
            Weight: {{ row.weight ?? '-' }}, Reps: {{ row.reps ?? '-' }}, Sets:
            {{ row.sets ?? '-' }}, Duration: {{ row.duration ?? '-' }},
            <template v-if="isAdmin">
              Active: {{ row.is_active ? 'Yes' : 'No' }}, System defined:
              {{ row.system_defined ? 'Yes' : 'No' }},
            </template>
            Share with others: {{ row.share_with_others ? 'Yes' : 'No' }}
          </q-item-label>
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
              v-if="isOwnedByCurrentUser(row)"
              flat
              round
              dense
              icon="edit"
              aria-label="Edit"
              @click="startEdit(row)"
            />
            <q-btn
              v-if="isOwnedByCurrentUser(row)"
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
  </div>
</template>

<script setup>
import { computed, ref, watch } from 'vue'
import { useQuasar } from 'quasar'
import { supabase } from 'src/lib/supabase'
import { notifySuccess } from 'src/utils/notify'
import { useUsersStore } from 'stores/users'

const BUCKET = 'exercise-videos'

const $q = useQuasar()
const usersStore = useUsersStore()
const rows = ref([])
const loading = ref(false)
const includeSharedExercises = ref(false)
const showExerciseForm = ref(false)
const saving = ref(false)
const error = ref('')
const formRef = ref(null)
const editingId = ref(null)
const form = ref(newForm())
const mediaFile = ref(null)
const showPreview = ref(false)
const previewUrl = ref('')
const previewType = ref('')
let loadRequestId = 0
const currentMediaPath = computed(() => form.value.video_path || form.value.image_path)
const isAdmin = computed(() => {
  const adminEmail = String(import.meta.env.VITE_FORMSUBMIT_RECIPIENT || '')
    .trim()
    .toLowerCase()
  const currentEmail = String(usersStore.currentUser?.email || '')
    .trim()
    .toLowerCase()

  return Boolean(adminEmail) && currentEmail === adminEmail
})

function newForm() {
  return {
    name: '',
    video_path: null,
    image_path: null,
    is_active: true,
    system_defined: false,
    share_with_others: false,
    weight: null,
    reps: null,
    sets: null,
    duration: null,
  }
}

function optionalIntegerRule(value) {
  if (value === null || value === '') return true
  const number = Number(value)
  return (
    (Number.isInteger(number) && number >= -2147483648 && number <= 2147483647) ||
    'Enter a whole number between -2147483648 and 2147483647'
  )
}

function nullableNumber(value) {
  return value === null || value === '' ? null : Number(value)
}

function resetForm() {
  editingId.value = null
  form.value = newForm()
  mediaFile.value = null
  formRef.value?.resetValidation()
}

async function load() {
  const requestId = ++loadRequestId
  const userId = usersStore.currentUser?.user_id
  rows.value = []
  loading.value = false
  if (!userId) {
    error.value = 'Please log in to view exercises.'
    return
  }
  if (!supabase) {
    error.value = 'Supabase is not configured.'
    return
  }
  loading.value = true
  const query = supabase.from('exercise').select('*')
  const filteredQuery = includeSharedExercises.value
    ? query.or(`user_id.eq.${userId},share_with_others.eq.true`)
    : query.eq('user_id', userId)
  const { data, error: err } = await filteredQuery.order('name')
  if (requestId !== loadRequestId) return
  loading.value = false
  if (err) {
    error.value = err.message
    return
  }
  error.value = ''
  rows.value = data || []
}

function isOwnedByCurrentUser(row) {
  return Boolean(usersStore.currentUser?.user_id && row.user_id === usersStore.currentUser.user_id)
}

function startEdit(row) {
  editingId.value = row.exercise_id
  showExerciseForm.value = true
  form.value = {
    name: row.name,
    video_path: row.video_path,
    image_path: row.image_path,
    is_active: isAdmin.value ? row.is_active : true,
    system_defined: isAdmin.value && row.system_defined,
    share_with_others: row.share_with_others,
    weight: row.weight,
    reps: row.reps,
    sets: row.sets,
    duration: row.duration,
  }
  mediaFile.value = null
}

async function uploadMedia(file) {
  const allowedType =
    file.type.startsWith('video/') || ['image/png', 'image/jpeg', 'image/gif'].includes(file.type)
  if (!allowedType) throw new Error('Choose a video or a PNG, JPEG, or GIF image.')

  const ext = (
    file.name.split('.').pop() || (file.type === 'image/jpeg' ? 'jpg' : 'mp4')
  ).toLowerCase()
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
  const userId = usersStore.currentUser?.user_id
  if (!editingId.value && !userId) {
    error.value = 'Please log in to add an exercise.'
    return
  }
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

    const payload = {
      name: form.value.name.trim(),
      video_path: videoPath,
      image_path: imagePath,
      is_active: isAdmin.value ? form.value.is_active : true,
      system_defined: isAdmin.value && form.value.system_defined,
      share_with_others: form.value.share_with_others,
      weight: nullableNumber(form.value.weight),
      reps: nullableNumber(form.value.reps),
      sets: nullableNumber(form.value.sets),
      duration: nullableNumber(form.value.duration),
    }
    const query = editingId.value
      ? supabase.from('exercise').update(payload).eq('exercise_id', editingId.value)
      : supabase.from('exercise').insert({ ...payload, user_id: userId })
    const { error: err } = await query
    if (err) {
      if (newPath) await removeMedia(newPath)
      throw err
    }
    if (editingId.value && newPath && oldPath !== newPath) await removeMedia(oldPath)

    notifySuccess($q, editingId.value ? 'Exercise updated' : 'Exercise added')
    resetForm()
    showExerciseForm.value = false
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
  const { data, error: err } = await supabase.storage.from(BUCKET).createSignedUrl(path, 3600)
  if (err) {
    error.value = err.message
    return
  }
  previewUrl.value = data.signedUrl
  previewType.value = isVideo ? 'video' : 'image'
  showPreview.value = true
}

watch(
  [() => usersStore.currentUser?.user_id, includeSharedExercises],
  (current, previous) => {
    if (previous && current[0] !== previous[0]) resetForm()
    load()
  },
  { immediate: true, flush: 'sync' },
)
</script>
