-- Re-create the trigger that was missing (confirmed via pg_trigger query).
-- Safe to re-run: CREATE OR REPLACE + DROP TRIGGER IF EXISTS.
-- public.users was removed; public.profile.user_id now points straight at
-- auth.users(id), and the trigger populates fname/lname/sex/age there instead.
ALTER TABLE public.profile DROP CONSTRAINT IF EXISTS profile_user_fk;
ALTER TABLE public.profile
  ADD CONSTRAINT profile_user_fk FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.profile (user_id, fname, lname, sex, age)
  VALUES (
    new.id,
    COALESCE(new.raw_user_meta_data ->> 'fname', ''),
    COALESCE(new.raw_user_meta_data ->> 'lname', ''),
    COALESCE(new.raw_user_meta_data ->> 'sex', 'M'),
    NULLIF(new.raw_user_meta_data ->> 'age', '')::integer
  )
  -- Client-side profileStore.saveProfile() upserts real values right after
  -- signup, so just leave any existing row alone on conflict.
  ON CONFLICT (user_id) DO NOTHING;
  RETURN new;
END;
$$;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

