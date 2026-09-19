import { boot } from 'quasar/wrappers'
import { useUsersStore } from 'stores/users'

// Relays the offline/online status computed by the service worker (based on
// Cache Storage, the source of truth) into the app so the UI can react to it.
export default boot(() => {
  if (typeof navigator === 'undefined' || !navigator.serviceWorker) {
    return
  }

  navigator.serviceWorker.addEventListener('message', (event) => {
    const usersStore = useUsersStore()

    if (event.data?.type === 'connectivity-status') {
      usersStore.isOffline = Boolean(event.data.isOffline)
      return
    }

    if (event.data?.type === 'login-status') {
      // The service worker is the source of truth: once logged in, stay logged
      // in until it reports a log out, even if local state was lost.
      if (event.data.loggedIn && !usersStore.currentUser) {
        usersStore.restoreCurrentUser(event.data.user)
      } else if (!event.data.loggedIn && usersStore.currentUser) {
        usersStore.currentUser = null
      }
    }
  })

  navigator.serviceWorker.ready.then((registration) => {
    registration.active?.postMessage({ type: 'request-connectivity-status' })
    registration.active?.postMessage({ type: 'request-login-status' })
  })
})
