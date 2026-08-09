export function getCurrentLocalDate() {
  const now = new Date()
  const year = now.getFullYear()
  const month = String(now.getMonth() + 1).padStart(2, '0')
  const day = String(now.getDate()).padStart(2, '0')

  return `${year}-${month}-${day}`
}

export function getLocalDateKey(value) {
  if (!value) {
    return ''
  }

  // Preserve date-only strings exactly to avoid timezone conversion drift.
  if (typeof value === 'string') {
    const dateOnlyMatch = value.trim().match(/^(\d{4}-\d{2}-\d{2})/)
    if (dateOnlyMatch) {
      return dateOnlyMatch[1]
    }
  }

  const dateValue = new Date(value)
  if (Number.isNaN(dateValue.getTime())) {
    return ''
  }

  const year = dateValue.getFullYear()
  const month = String(dateValue.getMonth() + 1).padStart(2, '0')
  const day = String(dateValue.getDate()).padStart(2, '0')

  return `${year}-${month}-${day}`
}
