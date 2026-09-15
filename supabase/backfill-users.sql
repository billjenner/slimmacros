-- One-time backfill for auth.users created before the handle_new_user trigger
-- existed (or created directly in the dashboard), so they never got a
-- matching public.users row.
INSERT INTO public.users (user_id, email, fname, lname, sex, age)
SELECT
  au.id,
  au.email,
  COALESCE(au.raw_user_meta_data ->> 'fname', ''),
  COALESCE(au.raw_user_meta_data ->> 'lname', ''),
  COALESCE(au.raw_user_meta_data ->> 'sex', ''),
  NULLIF(au.raw_user_meta_data ->> 'age', '')::integer
FROM auth.users au
LEFT JOIN public.users pu ON pu.user_id = au.id
WHERE pu.user_id IS NULL;
