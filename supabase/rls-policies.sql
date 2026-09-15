-- ============================================================
-- AUTH MIGRATION
-- ============================================================
-- The app used to run its own login (plaintext password stored in
-- public.users, checked client-side with the anon key). RLS policies
-- can only be enforced against auth.uid(), which requires the client
-- to actually authenticate through Supabase Auth. This migration:
--   1. Removes the plaintext password column.
--   2. Makes public.users.user_id equal to the Supabase Auth user id.
--   3. Auto-creates the public.users row via a trigger on auth.users.
-- ============================================================

ALTER TABLE public.users DROP COLUMN IF EXISTS password;

-- Old rows were created by the custom login, not Supabase Auth, so their
-- user_id values don't exist in auth.users. Wipe them (and dependents via
-- ON DELETE CASCADE) before the FK constraint below can be added.
TRUNCATE TABLE public.users CASCADE;

ALTER TABLE public.users ALTER COLUMN user_id DROP DEFAULT;

ALTER TABLE public.users
  ADD CONSTRAINT users_user_id_fkey
  FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;

-- Populates public.users from the auth.users row created by supabase.auth.signUp().
-- SECURITY DEFINER lets this trigger insert even though RLS blocks the client directly.
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
  )
  ON CONFLICT (user_id) DO NOTHING;
  RETURN new;
END;
$$;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ============================================================
-- ROW LEVEL SECURITY
-- ============================================================

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profile ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.food ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.food_log ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.supplement ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.supplement_log ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workout ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workout_log ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.weight_log ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.feedback ENABLE ROW LEVEL SECURITY;

-- ---------------- users ----------------
-- No INSERT policy: rows are only ever created by the handle_new_user trigger.
CREATE POLICY "users_select_own" ON public.users
  FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "users_update_own" ON public.users
  FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- ---------------- profile ----------------
CREATE POLICY "profile_select_own" ON public.profile
  FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "profile_insert_own" ON public.profile
  FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "profile_update_own" ON public.profile
  FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY "profile_delete_own" ON public.profile
  FOR DELETE USING (auth.uid() = user_id);

-- ---------------- food (own rows, plus rows shared by others) ----------------
CREATE POLICY "food_select_own_or_shared" ON public.food
  FOR SELECT USING (auth.uid() = user_id OR share_with_others = true);
CREATE POLICY "food_insert_own" ON public.food
  FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "food_update_own" ON public.food
  FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY "food_delete_own" ON public.food
  FOR DELETE USING (auth.uid() = user_id);

-- ---------------- food_log ----------------
CREATE POLICY "food_log_select_own" ON public.food_log
  FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "food_log_insert_own" ON public.food_log
  FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "food_log_update_own" ON public.food_log
  FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY "food_log_delete_own" ON public.food_log
  FOR DELETE USING (auth.uid() = user_id);

-- ---------------- supplement (own rows, plus rows shared by others) ----------------
CREATE POLICY "supplement_select_own_or_shared" ON public.supplement
  FOR SELECT USING (auth.uid() = user_id OR share_with_others = true);
CREATE POLICY "supplement_insert_own" ON public.supplement
  FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "supplement_update_own" ON public.supplement
  FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY "supplement_delete_own" ON public.supplement
  FOR DELETE USING (auth.uid() = user_id);

-- ---------------- supplement_log ----------------
CREATE POLICY "supplement_log_select_own" ON public.supplement_log
  FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "supplement_log_insert_own" ON public.supplement_log
  FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "supplement_log_update_own" ON public.supplement_log
  FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY "supplement_log_delete_own" ON public.supplement_log
  FOR DELETE USING (auth.uid() = user_id);

-- ---------------- workout (own rows, plus rows shared by others) ----------------
CREATE POLICY "workout_select_own_or_shared" ON public.workout
  FOR SELECT USING (auth.uid() = user_id OR share_with_others = true);
CREATE POLICY "workout_insert_own" ON public.workout
  FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "workout_update_own" ON public.workout
  FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY "workout_delete_own" ON public.workout
  FOR DELETE USING (auth.uid() = user_id);

-- ---------------- workout_log ----------------
CREATE POLICY "workout_log_select_own" ON public.workout_log
  FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "workout_log_insert_own" ON public.workout_log
  FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "workout_log_update_own" ON public.workout_log
  FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY "workout_log_delete_own" ON public.workout_log
  FOR DELETE USING (auth.uid() = user_id);

-- ---------------- weight_log ----------------
CREATE POLICY "weight_log_select_own" ON public.weight_log
  FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "weight_log_insert_own" ON public.weight_log
  FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "weight_log_update_own" ON public.weight_log
  FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY "weight_log_delete_own" ON public.weight_log
  FOR DELETE USING (auth.uid() = user_id);

-- ---------------- feedback ----------------
CREATE POLICY "feedback_select_own" ON public.feedback
  FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "feedback_insert_own" ON public.feedback
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- NOTE: public.users_logged_in has no user_id column and is only ever accessed
-- by the users-logged-in Edge Function using the service_role key, which
-- bypasses RLS. Enable RLS on it too so it isn't left wide open to anon/authenticated:
ALTER TABLE public.users_logged_in ENABLE ROW LEVEL SECURITY;
