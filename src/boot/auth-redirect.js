import { boot } from 'quasar/wrappers'
import { supabase } from '../lib/supabase'

// Hash-mode routing means Supabase's own "#access_token=..." recovery link
// collides with vue-router's hash route, so /reset-password never matches.
// Redirect to it manually once supabase-js has parsed the recovery tokens.
export default boot(({ router }) => {
  if (!supabase) {
    return
  }

  supabase.auth.onAuthStateChange((event) => {
    if (event === 'PASSWORD_RECOVERY') {
      router.replace('/reset-password')
    }
  })
})
