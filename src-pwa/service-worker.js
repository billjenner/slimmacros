/*
 * This file (which will be your service worker)
 * is picked up by the build system ONLY if
 * quasar.config file > pwa > workboxMode is set to "InjectManifest"
 */

import { clientsClaim } from 'workbox-core'
import {
  precacheAndRoute,
  cleanupOutdatedCaches,
  createHandlerBoundToURL,
} from 'workbox-precaching'
import { registerRoute, NavigationRoute } from 'workbox-routing'

self.skipWaiting()
clientsClaim()

// Use with precache injection
precacheAndRoute(self.__WB_MANIFEST)

cleanupOutdatedCaches()

// Cache Storage is the source of truth for connectivity: every runtime GET is
// attempted over the network first, falling back to whatever was last cached.
// The result of that attempt (success/failure) is what drives the offline flag.
const CONNECTIVITY_CACHE_NAME = 'connectivity-status'
const CONNECTIVITY_CACHE_URL = 'https://slimmacros.internal/connectivity-status'
let lastKnownOffline = null

async function readConnectivityStatus() {
  const cache = await caches.open(CONNECTIVITY_CACHE_NAME)
  const cached = await cache.match(CONNECTIVITY_CACHE_URL)
  if (!cached) {
    return null
  }
  const { isOffline } = await cached.json()
  return isOffline
}

async function broadcastConnectivityStatus(isOffline) {
  const clientsList = await self.clients.matchAll({ type: 'window', includeUncontrolled: true })
  for (const client of clientsList) {
    client.postMessage({ type: 'connectivity-status', isOffline })
  }
}

async function setConnectivityStatus(isOffline) {
  const cache = await caches.open(CONNECTIVITY_CACHE_NAME)
  await cache.put(
    CONNECTIVITY_CACHE_URL,
    new Response(JSON.stringify({ isOffline }), {
      headers: { 'Content-Type': 'application/json' },
    }),
  )

  if (lastKnownOffline === isOffline) {
    return
  }
  lastKnownOffline = isOffline
  await broadcastConnectivityStatus(isOffline)
}

// Report the last known status to a client as soon as it asks (e.g. on boot).
self.addEventListener('message', (event) => {
  if (event.data?.type !== 'request-connectivity-status') {
    return
  }

  event.waitUntil(
    (async () => {
      const isOffline = (await readConnectivityStatus()) ?? false
      event.source?.postMessage({ type: 'connectivity-status', isOffline })
    })(),
  )
})

// Runtime network requests (API calls, XHR/fetch), excluding navigations and
// the precached app shell, decide connectivity: cache the response on success
// and fall back to it while flagging offline when the network fetch fails.
registerRoute(
  ({ request }) => request.method === 'GET' && request.mode !== 'navigate',
  async ({ request }) => {
    const cache = await caches.open(CONNECTIVITY_CACHE_NAME)

    try {
      const response = await fetch(request.clone())
      await setConnectivityStatus(false)
      if (response.ok) {
        cache.put(request, response.clone()).catch(() => {})
      }
      return response
    } catch (error) {
      await setConnectivityStatus(true)
      const cachedResponse = await caches.match(request)
      if (cachedResponse) {
        return cachedResponse
      }
      throw error
    }
  },
)

// Non-SSR fallbacks to index.html
// Production SSR fallbacks to offline.html (except for dev)
registerRoute(
  new NavigationRoute(createHandlerBoundToURL(process.env.PWA_FALLBACK_HTML), {
    denylist: [new RegExp(process.env.PWA_SERVICE_WORKER_REGEX), /workbox-(.)*\.js$/],
  }),
)
