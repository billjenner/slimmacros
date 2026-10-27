// Imported by the generated service worker (see quasar.config.js importScripts).
// Serves exercise videos from a cache that is versioned by the exerciseVersion (?v=<version>).
const VIDEO_CACHE_PREFIX = 'exercise-video-'
const VIDEO_PATH_PREFIX = '/exercise-video/'

self.addEventListener('fetch', (event) => {
  const url = new URL(event.request.url)
  if (url.origin !== self.location.origin || !url.pathname.startsWith(VIDEO_PATH_PREFIX)) return
  event.respondWith(handleVideoRequest(event.request, url))
})

async function handleVideoRequest(request, url) {
  const version = url.searchParams.get('v') || 'unknown'
  const cacheName = VIDEO_CACHE_PREFIX + version
  const key = url.origin + url.pathname
  const cache = await caches.open(cacheName)

  // Same version: use the cache and never touch the network.
  const hit = await cache.match(key)
  if (hit) return hit

  const sourceUrl = request.headers.get('X-Source-Url')
  if (!sourceUrl) {
    // Page has not provided a network source yet (or is offline and allows stale copies).
    if (request.headers.get('X-Allow-Stale') === '1') {
      const stale = await findInOtherVersions(cacheName, key)
      if (stale) return stale
    }
    return new Response('', { status: 404, headers: { 'X-Video-Cache': 'miss' } })
  }

  // New version (or first play): network first, fall back to an older cached copy.
  try {
    const networkResponse = await fetch(sourceUrl)
    if (!networkResponse.ok) throw new Error(`HTTP ${networkResponse.status}`)
    await cache.put(key, networkResponse.clone())
    await deleteOtherVersions(cacheName, key)
    return networkResponse
  } catch (err) {
    const stale = await findInOtherVersions(cacheName, key)
    if (stale) return stale
    return new Response(String(err), { status: 504 })
  }
}

async function findInOtherVersions(currentName, key) {
  const names = (await caches.keys()).filter(
    (n) => n.startsWith(VIDEO_CACHE_PREFIX) && n !== currentName,
  )
  for (const name of names) {
    const match = await (await caches.open(name)).match(key)
    if (match) return match
  }
  return null
}

// Remove this video's stale copies from older-commit caches; empty old caches are dropped.
async function deleteOtherVersions(currentName, key) {
  const old = (await caches.keys()).filter(
    (n) => n.startsWith(VIDEO_CACHE_PREFIX) && n !== currentName,
  )
  for (const name of old) {
    const c = await caches.open(name)
    await c.delete(key)
    if (!(await c.keys()).length) await caches.delete(name)
  }
}
