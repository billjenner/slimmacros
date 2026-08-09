import { createClient } from 'npm:@supabase/supabase-js@2'

type SessionAction = 'restore' | 'login' | 'logout'

type SessionRow = {
  id: number
  users_email: string
  public_ip: string
  is_logged_in: boolean
  date: string
}

const supabaseUrl = Deno.env.get('SUPABASE_URL')
const supabaseServiceRoleKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')

if (!supabaseUrl || !supabaseServiceRoleKey) {
  throw new Error('Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY')
}

const supabase = createClient(supabaseUrl, supabaseServiceRoleKey, {
  auth: {
    persistSession: false,
    autoRefreshToken: false,
  },
})

function jsonResponse(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: {
      'Content-Type': 'application/json',
    },
  })
}

function getRequestIp(request: Request) {
  const headers = request.headers
  const candidates = [
    headers.get('x-forwarded-for'),
    headers.get('x-real-ip'),
    headers.get('cf-connecting-ip'),
    headers.get('true-client-ip'),
  ]

  for (const candidate of candidates) {
    if (!candidate) {
      continue
    }

    const [firstIp] = candidate
      .split(',')
      .map((part) => part.trim())
      .filter(Boolean)
    if (firstIp) {
      return firstIp
    }
  }

  return null
}

function getTodayDate() {
  return new Date().toISOString().slice(0, 10)
}

async function fetchSessionByEmail(usersEmail: string) {
  const { data, error } = await supabase
    .from('users_logged_in')
    .select('id, users_email, public_ip, is_logged_in, date')
    .eq('users_email', usersEmail)
    .maybeSingle<SessionRow>()

  if (error) {
    throw error
  }

  return data || null
}

async function fetchSessionByIp(publicIp: string) {
  const { data, error } = await supabase
    .from('users_logged_in')
    .select('id, users_email, public_ip, is_logged_in, date')
    .eq('public_ip', publicIp)
    .maybeSingle<SessionRow>()

  if (error) {
    throw error
  }

  return data || null
}

async function upsertSession(usersEmail: string, publicIp: string, isLoggedIn: boolean) {
  const today = getTodayDate()
  const sessionByEmail = await fetchSessionByEmail(usersEmail)
  const sessionByIp = await fetchSessionByIp(publicIp)

  if (sessionByEmail?.id && sessionByIp?.id && sessionByEmail.id !== sessionByIp.id) {
    const { error: deleteError } = await supabase
      .from('users_logged_in')
      .delete()
      .eq('id', sessionByIp.id)

    if (deleteError) {
      throw deleteError
    }
  }

  const targetId = sessionByEmail?.id || sessionByIp?.id
  const payload = {
    users_email: usersEmail,
    public_ip: publicIp,
    is_logged_in: isLoggedIn,
    date: today,
  }

  if (targetId) {
    const { data, error } = await supabase
      .from('users_logged_in')
      .update(payload)
      .eq('id', targetId)
      .select('id, users_email, public_ip, is_logged_in, date')
      .single<SessionRow>()

    if (error) {
      throw error
    }

    return data
  }

  const { data, error } = await supabase
    .from('users_logged_in')
    .insert(payload)
    .select('id, users_email, public_ip, is_logged_in, date')
    .single<SessionRow>()

  if (error) {
    throw error
  }

  return data
}

Deno.serve(async (request) => {
  if (request.method !== 'POST') {
    return jsonResponse({ error: 'Method not allowed' }, 405)
  }

  const body = (await request.json().catch(() => ({}))) as {
    action?: SessionAction
    email?: string
  }

  const action = body.action || 'restore'
  const publicIp = getRequestIp(request)

  if (!publicIp) {
    return jsonResponse({ error: 'Unable to determine the public IP address.' }, 400)
  }

  try {
    if (action === 'restore') {
      const sessionRow = await fetchSessionByIp(publicIp)

      if (!sessionRow || !sessionRow.is_logged_in) {
        return jsonResponse({
          public_ip: publicIp,
          users_email: null,
          is_logged_in: false,
          date: null,
        })
      }

      const today = getTodayDate()
      const { error } = await supabase
        .from('users_logged_in')
        .update({ date: today })
        .eq('id', sessionRow.id)

      if (error) {
        throw error
      }

      return jsonResponse({
        public_ip: publicIp,
        users_email: sessionRow.users_email,
        is_logged_in: true,
        date: today,
      })
    }

    const usersEmail = String(body.email || '')
      .trim()
      .toLowerCase()
    if (!usersEmail) {
      return jsonResponse({ error: 'Email is required for login and logout actions.' }, 400)
    }

    const sessionRow = await upsertSession(usersEmail, publicIp, action === 'login')

    return jsonResponse({
      public_ip: sessionRow.public_ip,
      users_email: sessionRow.users_email,
      is_logged_in: sessionRow.is_logged_in,
      date: sessionRow.date,
    })
  } catch (error) {
    return jsonResponse(
      {
        error: error instanceof Error ? error.message : 'Unexpected error while syncing session.',
      },
      500,
    )
  }
})
