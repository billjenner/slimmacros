-- ============================================================ 
-- ENUM TYPES 
-- ============================================================ 
DROP TYPE IF EXISTS public.diet_type;
CREATE TYPE public.diet_type AS ENUM ( 'Balanced', 'Low Carb', 'High Protein', 'High Metabolic' ); 
CREATE TYPE public.food_serving_unit AS ENUM ( 'oz', 'gram', 'cup', 'scoop', 'bar', 'can', 'count',
'item', 'piece', 'pinch', 'serving', 'slice', 'tab', 'tbsp', 'tsp' ); 

DROP TYPE IF EXISTS public.supplement_serving_unit;
CREATE TYPE public.supplement_serving_unit AS ENUM ( 'pills', 'oz', 'scoop', 'glasses', 'other' );


-- ============================================================ 
-- USERS 
-- ============================================================

CREATE TABLE public.users (
  user_id uuid NOT NULL DEFAULT gen_random_uuid(),
  email text NOT NULL UNIQUE,
  password text NOT NULL,
  fname text NOT NULL DEFAULT '',
  lname text NOT NULL DEFAULT '',
  sex text NOT NULL DEFAULT '',
  age integer CHECK (age IS NULL OR age >= 0),
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT users_pkey PRIMARY KEY (user_id)
);

-- ============================================================ 
-- PROFILES
-- ============================================================


CREATE TYPE public.activity_level AS ENUM ( 'Low', 'Medium', 'High', 'Sedentary', 'LightlyActive', 'VeryActive', 'ExtremelyActive' );
CREATE TYPE public.activity_level_new AS ENUM (
  'Low', 
  'Medium', 
  'High', 
  'Sedentary',
  'LightlyActive',
  'ModeratelyActive',
  'VeryActive',
  'ExtremelyActive'
);

ALTER TABLE public.profile
ALTER COLUMN activity_level
TYPE public.activity_level_new
USING activity_level::text::public.activity_level_new;

Update profile
  set activity_level = 'LightlyActive'
where activity_level = 'Low'

Update profile
  set activity_level = 'ModeratelyActive'
where activity_level = 'Medium'

DROP TYPE IF EXISTS public.activity_level;

CREATE TYPE public.activity_level AS ENUM ( 'Sedentary', 'LightlyActive', 'ModeratelyActive', 'VeryActive', 'ExtremelyActive' );

ALTER TABLE public.profile
ALTER COLUMN activity_level
TYPE public.activity_level
USING activity_level::text::public.activity_level;



CREATE TABLE public.profile (
    profile_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    user_id uuid NOT NULL UNIQUE,

    start_weight numeric(6,2) CHECK (start_weight >= 0), 

    goal_weight numeric(6,2) CHECK (goal_weight >= 0),

    height numeric(6,2) CHECK (height >= 0), 

		activity_level public.activity_level,	

    daily_calorie_deficit integer NOT NULL DEFAULT 0
        CHECK (daily_calorie_deficit >= 0),

    diet_type public.diet_type,

    sunday_protein numeric(5,2) CHECK (sunday_protein >= 0 AND sunday_protein <= 100),
    sunday_carbs   numeric(5,2) CHECK (sunday_carbs   >= 0 AND sunday_carbs   <= 100),
    sunday_fat     numeric(5,2) CHECK (sunday_fat     >= 0 AND sunday_fat     <= 100),

    monday_protein numeric(5,2) CHECK (monday_protein >= 0 AND monday_protein <= 100),
    monday_carbs   numeric(5,2) CHECK (monday_carbs   >= 0 AND monday_carbs   <= 100),
    monday_fat     numeric(5,2) CHECK (monday_fat     >= 0 AND monday_fat     <= 100),

    tuesday_protein numeric(5,2) CHECK (tuesday_protein >= 0 AND tuesday_protein <= 100),
    tuesday_carbs   numeric(5,2) CHECK (tuesday_carbs   >= 0 AND tuesday_carbs   <= 100),
    tuesday_fat     numeric(5,2) CHECK (tuesday_fat     >= 0 AND tuesday_fat     <= 100),

    wednesday_protein numeric(5,2) CHECK (wednesday_protein >= 0 AND wednesday_protein <= 100),
    wednesday_carbs   numeric(5,2) CHECK (wednesday_carbs   >= 0 AND wednesday_carbs   <= 100),
    wednesday_fat     numeric(5,2) CHECK (wednesday_fat     >= 0 AND wednesday_fat     <= 100),

    thursday_protein numeric(5,2) CHECK (thursday_protein >= 0 AND thursday_protein <= 100),
    thursday_carbs   numeric(5,2) CHECK (thursday_carbs   >= 0 AND thursday_carbs   <= 100),
    thursday_fat     numeric(5,2) CHECK (thursday_fat     >= 0 AND thursday_fat     <= 100),

    friday_protein numeric(5,2) CHECK (friday_protein >= 0 AND friday_protein <= 100),
    friday_carbs   numeric(5,2) CHECK (friday_carbs   >= 0 AND friday_carbs   <= 100),
    friday_fat     numeric(5,2) CHECK (friday_fat     >= 0 AND friday_fat     <= 100),

    saturday_protein numeric(5,2) CHECK (saturday_protein >= 0 AND saturday_protein <= 100),
    saturday_carbs   numeric(5,2) CHECK (saturday_carbs   >= 0 AND saturday_carbs   <= 100),
    saturday_fat     numeric(5,2) CHECK (saturday_fat     >= 0 AND saturday_fat     <= 100),
	
    is_active boolean NOT NULL DEFAULT true,

	created_at timestamptz NOT NULL DEFAULT now(),

    CONSTRAINT profile_user_fk
        FOREIGN KEY (user_id)
        REFERENCES public.users(user_id)
        ON DELETE CASCADE
);

-- ============================================================ 
-- FOOD 
-- ============================================================ 

SET DEFAULT 'serving'::public.food_serving_unit_new;

ALTER TABLE public.food
ALTER COLUMN serving_unit
TYPE public.food_serving_unit
USING serving_unit::text::public.food_serving_unit;

ALTER TABLE public.food
  ALTER COLUMN serving_unit DROP DEFAULT;


  select * from food

update food
  set serving_unit = 'serving'
where serving_unit = 'unit'

update food
  set serving_unit = 'gram'
where serving_unit = 'grams'

ALTER TABLE public.food
ALTER COLUMN serving_unit
SET DEFAULT 'serving';

CREATE TABLE public.food ( 
	food_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
	user_id uuid NOT NULL REFERENCES public.users(user_id) ON DELETE CASCADE, 
	description text NOT NULL, protein numeric(8,2) NOT NULL DEFAULT 0 CHECK (protein >= 0), 
	fat numeric(8,2) NOT NULL DEFAULT 0 CHECK (fat >= 0), 
	carb numeric(8,2) NOT NULL DEFAULT 0 CHECK (carb >= 0), 
	calories_extra numeric(8,2) NOT NULL DEFAULT 0 CHECK (calories_extra >= 0), 
	my_food boolean NOT NULL DEFAULT true, 
	favorite_food boolean NOT NULL DEFAULT false, 
	share_with_others boolean NOT NULL DEFAULT false, 
	serving_size numeric(8,2) NOT NULL DEFAULT 1 CHECK (serving_size > 0), 
	serving_unit public.food_serving_unit NOT NULL DEFAULT 'unit', 
	is_active boolean NOT NULL DEFAULT true, 
	created_at timestamptz NOT NULL DEFAULT now() 
);

-- ============================================================ 
-- FOOD LOG 
-- ============================================================ 
CREATE TABLE public.food_log ( 
	food_log_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
	food_id bigint NOT NULL REFERENCES public.food(food_id) ON DELETE CASCADE, 
	user_id uuid NOT NULL REFERENCES public.users(user_id) ON DELETE CASCADE, 
	servings numeric(8,2) NOT NULL DEFAULT 1 CHECK (servings > 0), 
	datetime timestamptz NOT NULL DEFAULT now() 
);
	
-- ============================================================ 
-- SUPPLEMENT 
-- ============================================================ 
-- 
-- user_id was added here so each supplement can belong 
-- to a specific user, consistent with Food and Workout. 
-- ============================================================ 
DROP TABLE IF EXISTS public.supplement;

CREATE TABLE public.supplement ( 
	supplement_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
	user_id uuid NOT NULL REFERENCES public.users(user_id) ON DELETE CASCADE, 
	description text NOT NULL, serving_size numeric(8,2) NOT NULL DEFAULT 1 CHECK (serving_size > 0), 
	serving_unit public.supplement_serving_unit NOT NULL DEFAULT 'other', 
	share_with_others boolean NOT NULL DEFAULT false, 
	is_active boolean NOT NULL DEFAULT true, 
	created_at timestamptz NOT NULL DEFAULT now() 
);

-- ============================================================ 
-- SUPPLEMENT LOG 
-- ============================================================ 
DROP TABLE IF EXISTS public.supplement_log;

CREATE TABLE public.supplement_log ( 
	supplement_log_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
	supplement_id bigint NOT NULL REFERENCES public.supplement(supplement_id) ON DELETE CASCADE, 
	user_id uuid NOT NULL REFERENCES public.users(user_id) ON DELETE CASCADE, servings numeric(8,2) 
	NOT NULL DEFAULT 1 CHECK (servings > 0), 
	date date NOT NULL DEFAULT CURRENT_DATE 
);

-- ============================================================ 
-- WORKOUT 
-- ============================================================ 
CREATE TABLE public.workout ( 
	workout_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
	user_id uuid NOT NULL REFERENCES public.users(user_id) ON DELETE CASCADE, type text NOT NULL, 
	average_workout_time integer CHECK ( average_workout_time IS NULL OR average_workout_time >= 0 ), 
	calories_burned integer NOT NULL DEFAULT 0 CHECK (calories_burned >= 0), 
	share_with_others boolean NOT NULL DEFAULT false, 
	is_active boolean NOT NULL DEFAULT true, 
	created_at timestamptz NOT NULL DEFAULT now() 
);

-- ============================================================ 
-- WORKOUT LOG 
-- ============================================================ 
DROP TABLE IF EXISTS public.workout_log;

CREATE TABLE public.workout_log ( 
	workout_log_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
	workout_id bigint NOT NULL REFERENCES public.workout(workout_id) ON DELETE CASCADE, 
	user_id uuid NOT NULL REFERENCES public.users(user_id) ON DELETE CASCADE, 
	workout_time integer CHECK ( workout_time IS NULL OR workout_time >= 0 ), 
	calories_burned integer NOT NULL DEFAULT 0 CHECK (calories_burned >= 0), 
	date date NOT NULL DEFAULT CURRENT_DATE 
);

-- ============================================================ 
-- WEIGHT LOG 
-- ============================================================ 
CREATE TABLE public.weight_log ( 
	weight_log_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
	user_id uuid NOT NULL REFERENCES public.users(user_id) ON DELETE CASCADE, 
	weight numeric(8,2) NOT NULL CHECK (weight > 0), 
	bmi numeric(5,2),
	date date NOT NULL DEFAULT CURRENT_DATE 
);

-- ============================================================ 
-- users_logged_in
-- ============================================================ 
DROP TABLE IF EXISTS public.users_logged_in;

CREATE TABLE public.users_logged_in (
  id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  users_email text NOT NULL UNIQUE,
  public_ip text NOT NULL UNIQUE,
  is_logged_in boolean NOT NULL DEFAULT true,
  updated_at timestamp with time zone NOT NULL DEFAULT now()
);

-- ============================================================ 
-- INDEXES 
-- ============================================================ 
-- PROFILE 
CREATE INDEX profile_user_id_idx ON public.profile(user_id); 
-- FOOD 
CREATE INDEX food_user_id_idx ON public.food(user_id); 
CREATE INDEX food_active_idx ON public.food(is_active); 
-- FOOD LOG 
CREATE INDEX food_log_user_id_idx ON public.food_log(user_id); 
CREATE INDEX food_log_food_id_idx ON public.food_log(food_id); 
CREATE INDEX food_log_datetime_idx ON public.food_log(datetime); 
-- SUPPLEMENT 
CREATE INDEX supplement_user_id_idx ON public.supplement(user_id); 
CREATE INDEX supplement_active_idx ON public.supplement(is_active); 
-- SUPPLEMENT LOG 
CREATE INDEX supplement_log_user_id_idx ON public.supplement_log(user_id); 
CREATE INDEX supplement_log_supplement_id_idx ON public.supplement_log(supplement_id); 
CREATE INDEX supplement_log_date_idx ON public.supplement_log(date); 
-- WORKOUT 
CREATE INDEX workout_user_id_idx ON public.workout(user_id); 
CREATE INDEX workout_active_idx ON public.workout(is_active); 
-- WORKOUT LOG 
CREATE INDEX workout_log_user_id_idx ON public.workout_log(user_id); 
CREATE INDEX workout_log_workout_id_idx ON public.workout_log(workout_id); 
CREATE INDEX workout_log_date_idx ON public.workout_log(date); 
-- WEIGHT LOG 
CREATE INDEX weight_log_user_id_idx ON public.weight_log(user_id); 
CREATE INDEX weight_log_date_idx ON public.weight_log(date);

select * from public.ue
select * from public.profile
select * from public.supplement
select * from public.supplement_log
select * from public.workout_log 
select * from public.workout
select * from public.food
select * from public.food_log 
order by datetime desc
select *
from public.food where food_id = 15
select * from public.users_logged_in

SELECT
  column_name,
  data_type,
  udt_name
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'profile'
ORDER BY ordinal_position;
