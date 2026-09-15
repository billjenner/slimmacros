-- Check for a public.users row whose email matches an auth.users account
-- but whose user_id doesn't (this would make the trigger's INSERT violate
-- the UNIQUE constraint on email and fail the whole signup with a 500).
SELECT pu.*
FROM public.users pu
WHERE pu.email = 'PUT_THE_TEST_EMAIL_HERE';
