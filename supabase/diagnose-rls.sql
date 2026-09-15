-- 1) Does the handle_new_user trigger actually exist?
SELECT tgname, tgrelid::regclass, tgenabled
FROM pg_trigger
WHERE tgname = 'on_auth_user_created';

-- 2) Is RLS enabled on public.users, and what policies exist?
SELECT relname, relrowsecurity, relforcerowsecurity
FROM pg_class
WHERE relname = 'users' AND relnamespace = 'public'::regnamespace;

SELECT policyname, cmd, qual, with_check
FROM pg_policies
WHERE schemaname = 'public' AND tablename = 'users';

-- 3) For a specific email, compare the auth.users id to the public.users row
--    (run as postgres/service role in the SQL editor so RLS doesn't hide it).
--    Replace the email below with the one you're testing.
SELECT au.id AS auth_user_id, au.email AS auth_email, pu.user_id AS public_user_id, pu.email AS public_email
FROM auth.users au
LEFT JOIN public.users pu ON pu.user_id = au.id
WHERE au.email = 'fredjenner1@gmail.com';
