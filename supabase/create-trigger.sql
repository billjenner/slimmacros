-- Re-create the trigger that was missing (confirmed via pg_trigger query).
-- Safe to re-run: CREATE OR REPLACE + DROP TRIGGER IF EXISTS.
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.users (user_id, email, fname, lname, sex, age)
  VALUES (
    new.id,
    new.email,
    COALESCE(new.raw_user_meta_data ->> 'fname', ''),
    COALESCE(new.raw_user_meta_data ->> 'lname', ''),
    COALESCE(new.raw_user_meta_data ->> 'sex', ''),
    NULLIF(new.raw_user_meta_data ->> 'age', '')::integer
  );
  RETURN new;
EXCEPTION
  -- A stale public.users row with the same email (different user_id) from
  -- earlier testing/backfills would otherwise fail the whole signup with a 500.
  WHEN unique_violation THEN
    RETURN new;
END;
$$;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
