// Small helper for posting messages to the active service worker, used to
// keep its Cache Storage state (connectivity, login status) in sync with the app.
export function postToServiceWorker(message) {
  if (typeof navigator === 'undefined' || !navigator.serviceWorker?.controller) {
    return
  }

  navigator.serviceWorker.controller.postMessage(message)
}

export function setServiceWorkerLoginStatus(loggedIn, user) {
  postToServiceWorker({ type: 'set-login-status', loggedIn, user: loggedIn ? user : null })
}
