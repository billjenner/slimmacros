-- One-time cleanup for public.users rows whose user_id no longer exists in
-- auth.users (e.g. left behind by manually deleting an auth user). These stale
-- rows collide on the email UNIQUE constraint and silently block
-- handle_new_user() from creating a row for a re-signed-up account, which in
-- turn blocks public.profile inserts (FK to public.users.user_id).

-- 1. Inspect what's orphaned before deleting anything.
SELECT u.*
FROM public.users u
LEFT JOIN auth.users au ON au.id = u.user_id
WHERE au.id IS NULL;

-- 2. Delete the orphaned rows (cascades to profile/food/etc. via ON DELETE CASCADE).
DELETE FROM public.users u
WHERE NOT EXISTS (SELECT 1 FROM auth.users au WHERE au.id = u.user_id);
