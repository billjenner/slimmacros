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
