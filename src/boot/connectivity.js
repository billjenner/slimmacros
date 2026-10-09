import { boot } from 'quasar/wrappers'
import { useUsersStore } from 'stores/users'

// Mirrors the browser's online/offline state into the users store so the UI
// (OfflineConnectionCard) reacts to connection changes.
export default boot(() => {
  if (typeof window === 'undefined') {
    return
  }

  const usersStore = useUsersStore()
  usersStore.isOffline = !navigator.onLine

  window.addEventListener('offline', () => {
    usersStore.isOffline = true
  })
  window.addEventListener('online', () => {
    usersStore.isOffline = false
  })
})
