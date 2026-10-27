import { supabase } from 'src/lib/supabase'

const BUCKET = 'exercise-videos'
const COMMIT = process.env.APP_COMMIT || 'dev'
const MAP_KEY = 'exercise-video-paths'

function readMap() {
  try {
    return JSON.parse(localStorage.getItem(MAP_KEY) || '{}')
  } catch {
    return {}
  }
}

// The name -> video_path lookup is remembered per app commit so the same commit needs no network.
async function resolveVideoPath(name) {
  const map = readMap()
  const saved = map[name]
  if (saved && saved.commit === COMMIT) return saved.path

  if (!supabase) {
    if (saved) return saved.path
    throw new Error('Supabase is not configured.')
  }
  const { data, error } = await supabase
    .from('exercise')
    .select('video_path')
    .eq('name', name)
    .maybeSingle()
  if (error) {
    if (saved) return saved.path
    throw error
  }
  if (!data?.video_path) throw new Error(`No video found for ${name}.`)
  map[name] = { commit: COMMIT, path: data.video_path }
  localStorage.setItem(MAP_KEY, JSON.stringify(map))
  return data.video_path
}

async function createSignedUrl(path) {
  if (!supabase) return ''
  try {
    const { data, error } = await supabase.storage.from(BUCKET).createSignedUrl(path, 3600)
    return error ? '' : data.signedUrl
  } catch {
    return ''
  }
}

// Returns a URL playable in a <video>. Uses the service worker cache (versioned by app commit)
// when a service worker controls the page; otherwise falls back to a signed URL.
export async function getExerciseVideoUrl(name) {
  const path = await resolveVideoPath(name)
  const swReady = 'serviceWorker' in navigator && navigator.serviceWorker.controller

  if (!swReady) {
    const signed = await createSignedUrl(path)
    if (!signed) throw new Error('Unable to load the video.')
    return signed
  }

  const cacheUrl = `/exercise-video/${encodeURIComponent(path)}?v=${encodeURIComponent(COMMIT)}`
  const toBlobUrl = async (res) => URL.createObjectURL(await res.blob())

  // 1) Same commit: served from cache without touching the network.
  let res = await fetch(cacheUrl)
  if (res.ok) return toBlobUrl(res)

  // 2) Cache miss (first play or new commit): network first via the service worker.
  const signed = await createSignedUrl(path)
  const headers = signed ? { 'X-Source-Url': signed } : { 'X-Allow-Stale': '1' }
  res = await fetch(cacheUrl, { headers })
  if (res.ok) return toBlobUrl(res)

  if (signed) {
    return signed
  }
  throw new Error('Video is not available offline yet.')
}
