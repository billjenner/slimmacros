export function hasCompletedFoodSetup(profileComplete, foodComplete, foodLogComplete) {
  return profileComplete === true && foodComplete === true && foodLogComplete === true
}

export function hasCompletedGettingStarted(userId, profile) {
  return Boolean(
    userId && profile?.user_id === userId && profile.getting_started_completed === true,
  )
}

export async function saveGettingStartedCompletion(client, userId) {
  const { data, error } = await client
    .from('profile')
    .update({ getting_started_completed: true })
    .eq('user_id', userId)
    .select('getting_started_completed')
    .single()

  if (error) throw error
  if (data?.getting_started_completed !== true) {
    throw new Error('Unable to save getting started completion.')
  }
}

export async function getStartPath(foodLogsStore, userId) {
  const logs = await foodLogsStore.loadFoodLogs(userId)

  if (foodLogsStore.error) {
    throw new Error(foodLogsStore.error)
  }

  return logs.length ? '/log' : '/getting-started'
}

export async function getLoginPath(foodLogsStore, userId, redirectPath, router) {
  if (redirectPath && router.resolve(redirectPath).path !== '/log') {
    return redirectPath
  }

  const startPath = await getStartPath(foodLogsStore, userId)
  return startPath === '/log' && redirectPath ? redirectPath : startPath
}
