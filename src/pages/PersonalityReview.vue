<template>
  <q-page class="q-pa-md review-page">
    <div class="q-mx-auto" style="max-width: 96vw; width: 96%">
      <div class="text-h5 text-center q-mb-md">Personality Review</div>

      <q-card>
        <q-card-section>
          <div
            :class="
              isNarrowScreen
                ? 'column items-stretch q-gutter-sm q-mb-sm'
                : 'row items-center justify-between q-mb-sm'
            "
          >
            <div class="text-subtitle1">Saved responses</div>
          </div>

          <q-table
            :rows="rows"
            :columns="columns"
            :visible-columns="visibleColumns"
            row-key="id"
            flat
            bordered
            :dense="isNarrowScreen"
            :rows-per-page-options="[10, 50]"
          >
            <template #body="props">
              <q-tr :props="props">
                <q-td auto-width>
                  <q-btn
                    size="sm"
                    color="secondary"
                    dense
                    round
                    :icon="isExpanded(props.row) ? 'remove' : 'add'"
                    @click="toggleExpanded(props.row)"
                  />
                </q-td>
                <q-td
                  v-for="col in props.cols.filter((col) => col.name !== 'expand')"
                  :key="col.name"
                  :props="props"
                  :class="['wrap-content', `${col.name}-col`]"
                  style="white-space: normal; word-break: break-word"
                >
                  {{ col.value }}
                </q-td>
              </q-tr>
              <q-tr v-if="isDetailVisible(props.row)" :props="props" class="detail-row">
                <q-td colspan="100%" class="detail-cell">
                  <transition
                    :css="false"
                    @before-enter="prepareExpand"
                    @enter="runExpand"
                    @before-leave="prepareCollapse"
                    @leave="runCollapse"
                    @after-leave="finishCollapse(props.row.id)"
                  >
                    <div v-if="isExpanded(props.row)" class="detail-panel">
                      <q-card flat bordered class="bg-grey-1">
                        <q-card-section>
                          <div class="text-subtitle2 q-mb-sm">Answer details</div>
                          <div class="column q-gutter-sm">
                            <div
                              v-for="field in detailFields"
                              :key="field.key"
                              class="q-pa-sm rounded-borders"
                              :class="
                                field.key.includes('explanation')
                                  ? 'bg-accent text-white'
                                  : 'bg-white'
                              "
                              :style="
                                field.key.includes('explanation')
                                  ? 'margin-top: 8px; padding: 14px;'
                                  : ''
                              "
                            >
                              <div
                                v-if="!field.key.includes('explanation')"
                                class="text-subtitle2 text-grey-7"
                              >
                                {{ field.label }}
                              </div>
                              <div
                                class="text-body2 q-mt-xs mt-10"
                                :class="field.key.includes('explanation') ? 'text-white' : ''"
                                style="white-space: normal; word-break: break-word"
                              >
                                {{ props.row[field.key] || '—' }}
                              </div>
                            </div>
                          </div>
                        </q-card-section>
                      </q-card>
                    </div>
                  </transition>
                </q-td>
              </q-tr>
            </template>
          </q-table>
        </q-card-section>
      </q-card>
    </div>
  </q-page>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { supabase } from '../lib/supabase'
import { useUsersStore } from 'stores/users'
import { generateAnswerExplanation } from '../utils/interpretAnswers'
import { useRouter } from 'vue-router'
import { useQuasar } from 'quasar'

const store = useUsersStore()
const rows = ref([])
const router = useRouter()
const $q = useQuasar()
const isNarrowScreen = computed(() => $q.screen.width <= 412)
const visibleColumns = ['expand', 'name', 'date_time']

const columns = [
  { name: 'expand', label: '', field: 'expand', sortable: false, align: 'left' },
  { name: 'name', label: 'Name', field: 'name', sortable: true },
  { name: 'date_time', label: 'Date / time', field: 'date_time', sortable: true },
]

const detailFields = [
  { key: 'room', label: 'Room' },
  { key: 'room_explanation', label: 'Explanation' },
  { key: 'cube', label: 'Cube' },
  { key: 'cube_explanation', label: 'Explanation' },
  { key: 'ladder', label: 'Ladder' },
  { key: 'ladder_explanation', label: 'Ladder Explanation' },
  { key: 'horse', label: 'Horse' },
  { key: 'horse_explanation', label: 'Horse Explanation' },
  { key: 'window', label: 'Window' },
  { key: 'window_explanation', label: 'Window Explanation' },
  { key: 'storm', label: 'Storm' },
  { key: 'storm_explanation', label: 'Storm Explanation' },
  { key: 'flowers', label: 'Flowers' },
  { key: 'flowers_explanation', label: 'Flowers Explanation' },
]

const expandedRows = ref([])
const collapsingRows = ref([])

function isExpanded(row) {
  return expandedRows.value.includes(row.id)
}

function isCollapsing(row) {
  return collapsingRows.value.includes(row.id)
}

function isDetailVisible(row) {
  return isExpanded(row) || isCollapsing(row)
}

function toggleExpanded(row) {
  if (isExpanded(row)) {
    expandedRows.value = expandedRows.value.filter((id) => id !== row.id)
    if (!isCollapsing(row)) {
      collapsingRows.value.push(row.id)
    }
  } else {
    collapsingRows.value = collapsingRows.value.filter((id) => id !== row.id)
    expandedRows.value.push(row.id)
  }
}

function finishCollapse(rowId) {
  collapsingRows.value = collapsingRows.value.filter((id) => id !== rowId)
}

function prepareExpand(element) {
  element.style.height = '0px'
  element.style.opacity = '0'
  element.style.transform = 'translateY(-8px)'
  element.style.overflow = 'hidden'
}

function runExpand(element, done) {
  const transition =
    'height 5000ms ease-in-out, opacity 5000ms ease-in-out, transform 5000ms ease-in-out'
  element.style.transition = transition
  requestAnimationFrame(() => {
    element.style.height = `${element.scrollHeight}px`
    element.style.opacity = '1'
    element.style.transform = 'translateY(0)'
  })

  const finish = (event) => {
    if (event.target === element && event.propertyName === 'height') {
      element.removeEventListener('transitionend', finish)
      element.style.height = 'auto'
      done()
    }
  }

  element.addEventListener('transitionend', finish)
}

function prepareCollapse(element) {
  element.style.height = `${element.scrollHeight}px`
  element.style.opacity = '1'
  element.style.transform = 'translateY(0)'
  element.style.overflow = 'hidden'
}

function runCollapse(element, done) {
  const transition = 'height 1800ms ease, opacity 1800ms ease, transform 1800ms ease'
  element.style.transition = transition
  requestAnimationFrame(() => {
    element.style.height = '0px'
    element.style.opacity = '0'
    element.style.transform = 'translateY(-8px)'
  })

  const finish = (event) => {
    if (event.target === element && event.propertyName === 'height') {
      element.removeEventListener('transitionend', finish)
      done()
    }
  }

  element.addEventListener('transitionend', finish)
}

function formatDate(value) {
  if (!value) return '—'
  const date = new Date(value)

  if (Number.isNaN(date.getTime())) {
    return value
  }

  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  const year = String(date.getFullYear()).slice(-2)
  const hours = String(date.getHours()).padStart(2, '0')
  const minutes = String(date.getMinutes()).padStart(2, '0')

  return `${month}-${day}-${year} ${hours}:${minutes}`
}

async function ensureExplanations(answer) {
  const explanations = {}
  const fields = [
    ['room', 'room_explanation'],
    ['cube', 'cube_explanation'],
    ['ladder', 'ladder_explanation'],
    ['horse', 'horse_explanation'],
    ['window', 'window_explanation'],
    ['storm', 'storm_explanation'],
    ['flowers', 'flowers_explanation'],
  ]

  for (const [field, explanationField] of fields) {
    if (answer[explanationField]) {
      explanations[explanationField] = answer[explanationField]
      continue
    }

    const generatedExplanation = await generateAnswerExplanation({
      [field]: answer[field] || '',
    })

    explanations[explanationField] = generatedExplanation[field] || ''

    try {
      await supabase
        .from('answers')
        .update({ [explanationField]: explanations[explanationField] })
        .eq('email', answer.email)
    } catch (error) {
      console.warn(`Unable to persist generated explanation for ${field}.`, error)
    }
  }

  return explanations
}

async function loadAnswers() {
  const { data, error } = await supabase.from('answers').select('*').order('date_time', {
    ascending: false,
  })

  if (error) {
    store.error = error.message
    rows.value = []
    return
  }

  const userMap = new Map((store.users || []).map((user) => [user.email?.toLowerCase(), user]))
  const currentEmail = store.currentUser?.email?.toLowerCase()
  const enrichedRows = []

  for (const answer of data || []) {
    const user = userMap.get(answer.email?.toLowerCase()) || {}
    const isCurrentUserRow = answer.email?.toLowerCase() === currentEmail
    const explanations = await ensureExplanations(answer)

    enrichedRows.push({
      id: `${answer.email}-${answer.date_time}`,
      email: answer.email,
      name: isCurrentUserRow ? user.name || '' : '---',
      expand: false,
      ...answer,
      ...explanations,
      date_time: formatDate(answer.date_time),
    })
  }

  const currentUserRows = enrichedRows.filter((row) => row.email?.toLowerCase() === currentEmail)
  const otherRows = enrichedRows.filter((row) => row.email?.toLowerCase() !== currentEmail)

  rows.value = [...currentUserRows, ...otherRows]
}

onMounted(async () => {
  await store.loadUsers()
  if (!store.currentUser || !store.currentUser.email) {
    router.push('/login')
    return
  }

  await loadAnswers()
})
</script>

<style scoped>
.review-page .detail-row .detail-cell {
  padding: 0;
  border-top: 0;
  border-bottom: 0;
}

.review-page .detail-panel {
  overflow: hidden;
  width: 100%;
  padding: 8px 0 0;
}

@media (max-width: 412px) {
  .review-page .wrap-content {
    max-width: 96px;
    font-size: 0.78rem;
  }

  .review-page .fname-col,
  .review-page .lname-col {
    min-width: 48px;
    max-width: 48px;
    width: 48px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  .review-page .date_time-col {
    min-width: 88px;
    max-width: 88px;
    width: 88px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  .review-page :deep(.q-table th),
  .review-page :deep(.q-table td) {
    padding: 6px 4px;
  }
}
</style>
