-- Apply after workout, exercise, and workout_exercise have been created.
-- The workout and its exercise rows are saved in one transaction.
create or replace function public.save_workout_with_exercises(
  p_workout_id bigint,
  p_workout jsonb,
  p_exercises jsonb
)
returns public.workout
language plpgsql
security invoker
set search_path = public
as $$
declare
  saved_workout public.workout;
  current_user_id uuid := auth.uid();
begin
  if current_user_id is null or (p_workout->>'user_id')::uuid is distinct from current_user_id then
    raise exception 'No current user is available.';
  end if;

  if jsonb_typeof(p_exercises) is distinct from 'array' then
    raise exception 'Exercises must be an array.';
  end if;

  if p_workout_id is null then
    insert into public.workout (
      user_id, type, average_workout_time, calories_burned, share_with_others, is_active
    ) values (
      current_user_id, p_workout->>'type', (p_workout->>'average_workout_time')::integer,
      (p_workout->>'calories_burned')::integer, (p_workout->>'share_with_others')::boolean,
      (p_workout->>'is_active')::boolean
    )
    returning * into saved_workout;
  else
    update public.workout
    set type = p_workout->>'type',
        average_workout_time = (p_workout->>'average_workout_time')::integer,
        calories_burned = (p_workout->>'calories_burned')::integer,
        share_with_others = (p_workout->>'share_with_others')::boolean,
        is_active = (p_workout->>'is_active')::boolean
    where workout_id = p_workout_id and user_id = current_user_id
    returning * into saved_workout;

    if not found then
      raise exception 'Workout not found or not owned by the current user.';
    end if;

    delete from public.workout_exercise where workout_id = p_workout_id;
  end if;

  insert into public.workout_exercise (
    workout_id, exercise_id, sort_order, weight, reps, sets, duration
  )
  select saved_workout.workout_id, (entry->>'exercise_id')::bigint, position::integer,
         (entry->>'weight')::integer, (entry->>'reps')::integer,
         (entry->>'sets')::integer, (entry->>'duration')::integer
  from jsonb_array_elements(p_exercises) with ordinality as entries(entry, position);

  return saved_workout;
end;
$$;

revoke all on function public.save_workout_with_exercises(bigint, jsonb, jsonb) from public;
grant execute on function public.save_workout_with_exercises(bigint, jsonb, jsonb) to authenticated;
