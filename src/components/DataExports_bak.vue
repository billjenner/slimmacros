<!-- <template>
  <q-card flat bordered class="q-ma-md">
    <q-expansion-item
      label="DataExports"
      expand-icon="keyboard_arrow_down"
      expanded-icon="keyboard_arrow_up"
      transition-show="jump-down"
      transition-hide="jump-up"
      @after-show="renderSupplementChart"
    >
      <q-card-section>
        <q-banner v-if="!usersStore.currentUser" class="bg-warning text-dark" rounded>
          Your data exports will be available once you sign in.
        </q-banner>

        <template v-else>
          <div class="row q-col-gutter-md">
            <div class="col-12 col-md-6">
              <q-input v-model="startDate" type="date" label="Start Date" filled dense />
            </div>
            <div class="col-12 col-md-6">
              <q-input v-model="endDate" type="date" label="End Date" filled dense />
            </div>
          </div>

          <div class="row items-center justify-between q-mt-md">
            <q-checkbox v-model="includeSupplementLog" label="Supplement Log" />
            <div class="row q-gutter-sm">
              <q-btn
                color="primary"
                label="Export CSV"
                :loading="exporting"
                :disable="!includeSupplementLog"
                @click="exportCsv"
              />

              <q-btn
                color="secondary"
                label="Export PDF"
                :loading="exporting"
                :disable="!includeSupplementLog"
                @click="exportPdf"
              />
            </div>
          </div>
        </template>
      </q-card-section>
    </q-expansion-item>
  </q-card>
</template>

<script setup>
import jsPDF from 'jspdf'
import autoTable from 'jspdf-autotable'
import { ref } from 'vue'
import { useQuasar } from 'quasar'
import { useProfileStore } from 'stores/profile'
import { usesupplementsLogStore } from 'stores/supplements_log'
import { useUsersStore } from 'stores/users'

const profileStore = useProfileStore()
const supplementLogsStore = usesupplementsLogStore()
const usersStore = useUsersStore()
const $q = useQuasar()

const includeSupplementLog = ref(true)
const exporting = ref(false)

function currentDate() {
  const now = new Date()
  return `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`
}

const startDate = ref(currentDate())
const endDate = ref(currentDate())

function properCase(value) {
  const text = String(value || '').trim()
  return text ? text.charAt(0).toUpperCase() + text.slice(1).toLowerCase() : ''
}

function timestampForFilename() {
  const now = new Date()
  const pad = (value) => String(value).padStart(2, '0')
  return `${now.getFullYear()}-${pad(now.getMonth() + 1)}-${pad(now.getDate())}-${pad(now.getHours())}-${pad(now.getMinutes())}`
}

// Quotes fields that contain a comma, quote, or newline per CSV rules.
function toCsvField(value) {
  const text = String(value ?? '')
  return /[",\n]/.test(text) ? `"${text.replace(/"/g, '""')}"` : text
}

function buildSupplementLogCsv(rows) {
  const lines = ['DESCRIPTION, SERVINGS, SERV. TYPE, DATE']

  for (const row of rows) {
    const description = row.supplement?.description || ''
    const servings = Number(row.servings) || 0
    const servingUnit = row.supplement?.serving_unit || ''
    lines.push(
      [
        toCsvField(description),
        toCsvField(servings.toFixed(2)),
        toCsvField(servingUnit),
        toCsvField(row.date || ''),
      ].join(','),
    )
  }

  return lines.join('\n')
}

function downloadCsv(filename, content) {
  const blob = new Blob([content], { type: 'text/csv;charset=utf-8;' })
  const url = URL.createObjectURL(blob)
  const link = document.createElement('a')
  link.href = url
  link.download = filename
  link.click()
  URL.revokeObjectURL(url)
}

async function exportCsv() {
  if (!usersStore.currentUser?.user_id) {
    $q.notify({ color: 'negative', textColor: 'white', message: 'No current user is available.' })
    return
  }

  if (!includeSupplementLog.value) {
    return
  }

  exporting.value = true

  try {
    const rows = await supplementLogsStore.fetchSupplementLogsForExport(
      usersStore.currentUser.user_id,
      startDate.value,
      endDate.value,
    )

    if (supplementLogsStore.error) {
      $q.notify({ color: 'negative', textColor: 'white', message: supplementLogsStore.error })
      return
    }

    const fname = properCase(profileStore.currentProfile?.fname)
    const lname = properCase(profileStore.currentProfile?.lname)
    const filename = `${fname}${lname}_SupplementLogs_${timestampForFilename()}.csv`

    downloadCsv(filename, buildSupplementLogCsv(rows))
  } finally {
    exporting.value = false
  }
}

function buildSupplementLogPdf(rows) {
  const doc = new jsPDF({
    orientation: 'portrait',
    unit: 'mm',
    format: 'letter',
  })

  const fname = properCase(profileStore.currentProfile?.fname)
  const lname = properCase(profileStore.currentProfile?.lname)

  // Title
  doc.setFontSize(16)
  doc.setFont('helvetica', 'bold')
  doc.text(`${fname} ${lname}`, 14, 18)

  doc.setFontSize(12)
  doc.setFont('helvetica', 'normal')
  doc.text('Supplement Log', 14, 26)

  // Date range
  doc.setFontSize(10)
  doc.text(`Date Range: ${startDate.value} through ${endDate.value}`, 14, 33)

  const tableRows = rows.map((row) => {
    const description = row.supplement?.description || ''
    const servings = Number(row.servings) || 0
    const servingUnit = row.supplement?.serving_unit || ''
    const date = row.date || ''

    return [description, servings.toFixed(2), servingUnit, date]
  })

  autoTable(doc, {
    startY: 40,

    head: [['DESCRIPTION', 'SERVINGS', 'SERV. TYPE', 'DATE']],

    body: tableRows,

    theme: 'grid',

    styles: {
      fontSize: 9,
      cellPadding: 3,
    },

    headStyles: {
      fillColor: [25, 118, 210],
      textColor: 255,
      fontStyle: 'bold',
    },

    columnStyles: {
      0: { cellWidth: 75 },
      1: { cellWidth: 25, halign: 'right' },
      2: { cellWidth: 35 },
      3: { cellWidth: 40 },
    },

    margin: {
      left: 14,
      right: 14,
    },
  })

  return doc
}
</script> -->
