import { boot } from 'quasar/wrappers'
import { useUsersStore } from 'stores/users'

// Relays the offline/online status computed by the service worker (based on
// Cache Storage, the source of truth) into the app so the UI can react to it.
export default boot(() => {
  if (typeof navigator === 'undefined' || !navigator.serviceWorker) {
    return
  }

  navigator.serviceWorker.addEventListener('message', (event) => {
    if (event.data?.type !== 'connectivity-status') {
      return
    }

    const usersStore = useUsersStore()
    usersStore.isOffline = Boolean(event.data.isOffline)
  })

  navigator.serviceWorker.ready.then((registration) => {
    registration.active?.postMessage({ type: 'request-connectivity-status' })
  })
})
