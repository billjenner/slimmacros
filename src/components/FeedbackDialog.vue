<template>
  <div class="feedback-link">
    <q-btn flat no-caps label="Give Feedback" @click="showFeedbackDialog = true" />
  </div>

  <q-dialog v-model="showFeedbackDialog" persistent>
    <q-card style="min-width: 320px; max-width: 1024px; width: 90vw">
      <template v-slot:header>
        <q-item-section class="text-center">
          <div class="text-h4">Contact</div>
        </q-item-section>
      </template>
      <div class="row q-col-gutter-md q-pa-md">
        <div class="col-12 flex justify-center">
          <q-card style="width: 100%">
            <q-card-section class="bg-secondary text-white text-center"> Feedback </q-card-section>

            <q-card-section>
              <q-banner v-if="!usersStore.currentUser?.email" class="bg-warning text-white q-mb-md">
                Please log in to submit feedback.
              </q-banner>

              <q-banner v-if="submitLimitReached" class="bg-warning text-white q-mb-md">
                You've reached the limit of {{ RECENT_SUBMISSION_LIMIT }} feedback submissions in
                the last {{ RECENT_SUBMISSION_WINDOW_DAYS }} days. Please try again later.
              </q-banner>

              <q-form
                ref="feedbackFormRef"
                greedy
                class="q-gutter-md"
                @submit.prevent="handleFeedbackSubmit"
              >
                <q-select
                  v-model="feedbackForm.feedback_type"
                  :options="feedbackTypeOptions"
                  label="Feedback Type"
                  multiple
                  outlined
                  dense
                  use-chips
                  lazy-rules="ondemand"
                  :rules="[(val) => (val && val.length > 0) || 'Select at least one type']"
                />

                <q-input
                  v-model="feedbackForm.subject"
                  label="Subject"
                  outlined
                  dense
                  lazy-rules="ondemand"
                  :rules="[(val) => !!val?.trim() || 'Subject is required']"
                />

                <q-input
                  v-model="feedbackForm.description"
                  label="Description"
                  type="textarea"
                  outlined
                  dense
                  lazy-rules="ondemand"
                  :rules="[(val) => !!val?.trim() || 'Description is required']"
                />

                <q-input v-model="feedbackForm.contact" label="Contact (optional)" outlined dense />

                <q-input
                  v-model="feedbackForm.email"
                  label="Email (optional)"
                  type="email"
                  outlined
                  dense
                />

                <q-checkbox
                  v-model="feedbackForm.allow_contact"
                  label="You may contact me about this feedback"
                />

                <div class="row justify-between q-gutter-sm">
                  <q-btn
                    color="primary"
                    label="Cancel"
                    type="button"
                    :disable="submitting"
                    @click="showFeedbackDialog = false"
                  />
                  <q-btn
                    color="primary"
                    label="Submit Feedback"
                    type="submit"
                    :disable="!usersStore.currentUser?.email || submitLimitReached || submitting"
                    :loading="submitting"
                  />
                </div>
              </q-form>
            </q-card-section>
          </q-card>
        </div>
      </div>
    </q-card>
  </q-dialog>
</template>

<script setup>
import { reactive, ref, watch } from 'vue'
import { useQuasar } from 'quasar'
import { useUsersStore } from 'stores/users'
import { useFeedbackStore } from 'stores/feedback'
import { sanitizeInput } from '../utils/sanitize'
import { notifySuccess } from '../utils/notify'

const RECENT_SUBMISSION_LIMIT = 3
const RECENT_SUBMISSION_WINDOW_DAYS = 7

const feedbackTypeOptions = [
  'Bug',
  'Feature Request',
  'Suggestion',
  'Question',
  'Compliment',
  'Other',
]

const $q = useQuasar()
const usersStore = useUsersStore()
const feedbackStore = useFeedbackStore()

const feedbackFormRef = ref(null)
const submitting = ref(false)
const submitLimitReached = ref(false)
const showFeedbackDialog = ref(false)

const feedbackForm = reactive({
  feedback_type: [],
  subject: '',
  description: '',
  contact: '',
  email: '',
  allow_contact: false,
})

function resetFeedbackForm() {
  feedbackForm.feedback_type = []
  feedbackForm.subject = ''
  feedbackForm.description = ''
  feedbackForm.contact = ''
  feedbackForm.email = ''
  feedbackForm.allow_contact = false
}

watch(
  () => usersStore.currentUser?.user_id,
  async (userId) => {
    submitLimitReached.value = userId
      ? await feedbackStore.hasReachedRecentSubmissionLimit(userId)
      : false
  },
  { immediate: true },
)

async function sendFeedbackEmail(feedback) {
  const formSubmitRecipient = import.meta.env.VITE_FORMSUBMIT_RECIPIENT || 'bill.jenner@gmail.com'
  const formSubmitUrl =
    import.meta.env.VITE_FORMSUBMIT_URL || `https://formsubmit.co/ajax/${formSubmitRecipient}`

  await fetch(formSubmitUrl, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Accept: 'application/json',
    },
    body: JSON.stringify({
      feedback_type: feedback.feedback_type,
      subject: feedback.subject,
      description: feedback.description,
      contact: feedback.contact,
      email: feedback.email,
      allow_contact: feedback.allow_contact,
      _subject: `Slim Macros Feedback: ${feedback.subject}`,
      _captcha: 'false',
    }),
  })
}

async function handleFeedbackSubmit() {
  const userId = usersStore.currentUser?.user_id

  if (!userId) {
    $q.notify({ color: 'negative', message: 'Please log in to submit feedback.' })
    return
  }

  submitting.value = true

  try {
    submitLimitReached.value = await feedbackStore.hasReachedRecentSubmissionLimit(userId)
    if (submitLimitReached.value) {
      $q.notify({
        color: 'negative',
        message: `You've reached the limit of ${RECENT_SUBMISSION_LIMIT} feedback submissions in the last ${RECENT_SUBMISSION_WINDOW_DAYS} days.`,
      })
      return
    }

    const sanitizedFeedback = {
      feedback_type: feedbackForm.feedback_type.join(', '),
      subject: sanitizeInput(feedbackForm.subject),
      description: sanitizeInput(feedbackForm.description),
      contact: sanitizeInput(feedbackForm.contact),
      email: sanitizeInput(feedbackForm.email),
      allow_contact: feedbackForm.allow_contact,
    }

    const result = await feedbackStore.createFeedback(userId, sanitizedFeedback)

    if (!result) {
      throw new Error(feedbackStore.error || 'Unable to submit feedback right now.')
    }

    try {
      await sendFeedbackEmail(sanitizedFeedback)
    } catch (emailError) {
      console.error('Feedback email notification failed:', emailError)
    }

    notifySuccess($q, 'Thank you for your feedback!')
    resetFeedbackForm()
    feedbackFormRef.value?.resetValidation()
    submitLimitReached.value = await feedbackStore.hasReachedRecentSubmissionLimit(userId)
  } catch (error) {
    console.error('Feedback submission failed:', error)
    $q.notify({ color: 'negative', message: error?.message || 'Unable to submit feedback.' })
  } finally {
    showFeedbackDialog.value = false
    submitting.value = false
  }
}
</script>

<style scoped>
.feedback-link {
  margin-top: auto;
  padding: 24px;
  text-align: center;
}
</style>
