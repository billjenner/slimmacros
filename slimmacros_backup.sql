--
-- PostgreSQL database dump
--

\restrict 26UsSiDdqrOksUpP8iFXWKThjNCCYNZbQJKjfjeEa2kwdgZSBx6iWE3ybbg6JId

-- Dumped from database version 17.6
-- Dumped by pg_dump version 18.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO supabase_admin;

--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA extensions;


ALTER SCHEMA extensions OWNER TO postgres;

--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql;


ALTER SCHEMA graphql OWNER TO supabase_admin;

--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql_public;


ALTER SCHEMA graphql_public OWNER TO supabase_admin;

--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: pgbouncer
--

CREATE SCHEMA pgbouncer;


ALTER SCHEMA pgbouncer OWNER TO pgbouncer;

--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO supabase_admin;

--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA storage;


ALTER SCHEMA storage OWNER TO supabase_admin;

--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA vault;


ALTER SCHEMA vault OWNER TO supabase_admin;

--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


ALTER TYPE auth.aal_level OWNER TO supabase_auth_admin;

--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


ALTER TYPE auth.code_challenge_method OWNER TO supabase_auth_admin;

--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


ALTER TYPE auth.factor_status OWNER TO supabase_auth_admin;

--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


ALTER TYPE auth.factor_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_authorization_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_authorization_status AS ENUM (
    'pending',
    'approved',
    'denied',
    'expired'
);


ALTER TYPE auth.oauth_authorization_status OWNER TO supabase_auth_admin;

--
-- Name: oauth_client_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_client_type AS ENUM (
    'public',
    'confidential'
);


ALTER TYPE auth.oauth_client_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_registration_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_registration_type AS ENUM (
    'dynamic',
    'manual'
);


ALTER TYPE auth.oauth_registration_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_response_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_response_type AS ENUM (
    'code'
);


ALTER TYPE auth.oauth_response_type OWNER TO supabase_auth_admin;

--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


ALTER TYPE auth.one_time_token_type OWNER TO supabase_auth_admin;

--
-- Name: activity_level; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.activity_level AS ENUM (
    'Sedentary',
    'LightlyActive',
    'ModeratelyActive',
    'VeryActive',
    'ExtremelyActive'
);


ALTER TYPE public.activity_level OWNER TO postgres;

--
-- Name: activity_level_new; Type: TYPE; Schema: public; Owner: postgres
--

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


ALTER TYPE public.activity_level_new OWNER TO postgres;

--
-- Name: diet_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.diet_type AS ENUM (
    'Balanced',
    'Low Carb',
    'High Protein',
    'High Metabolic',
    'Custom'
);


ALTER TYPE public.diet_type OWNER TO postgres;

--
-- Name: food_serving_unit; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.food_serving_unit AS ENUM (
    'oz',
    'gram',
    'cup',
    'scoop',
    'bar',
    'can',
    'count',
    'item',
    'piece',
    'pinch',
    'serving',
    'slice',
    'tab',
    'tbsp',
    'tsp'
);


ALTER TYPE public.food_serving_unit OWNER TO postgres;

--
-- Name: food_serving_unit_new; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.food_serving_unit_new AS ENUM (
    'oz',
    'gram',
    'grams',
    'cup',
    'scoop',
    'bar',
    'can',
    'count',
    'item',
    'piece',
    'pinch',
    'serving',
    'unit',
    'slice',
    'tab',
    'tbsp',
    'tsp'
);


ALTER TYPE public.food_serving_unit_new OWNER TO postgres;

--
-- Name: supplement_serving_unit; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.supplement_serving_unit AS ENUM (
    'pills',
    'oz',
    'scoop',
    'glasses',
    'other'
);


ALTER TYPE public.supplement_serving_unit OWNER TO postgres;

--
-- Name: action; Type: TYPE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


ALTER TYPE realtime.action OWNER TO supabase_realtime_admin;

--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in',
    'like',
    'ilike',
    'is',
    'match',
    'imatch',
    'isdistinct'
);


ALTER TYPE realtime.equality_op OWNER TO supabase_realtime_admin;

--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text,
	negate boolean
);


ALTER TYPE realtime.user_defined_filter OWNER TO supabase_realtime_admin;

--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


ALTER TYPE realtime.wal_column OWNER TO supabase_realtime_admin;

--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


ALTER TYPE realtime.wal_rls OWNER TO supabase_realtime_admin;

--
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS',
    'VECTOR'
);


ALTER TYPE storage.buckettype OWNER TO supabase_storage_admin;

--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


ALTER FUNCTION auth.email() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO supabase_auth_admin;

--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


ALTER FUNCTION auth.role() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


ALTER FUNCTION auth.uid() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
    revoke trigger on cron.job_run_details from postgres;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $_$
begin
    if not exists (
        select 1
        from pg_catalog.pg_event_trigger_ddl_commands() ev
        join pg_catalog.pg_extension e on ev.objid = e.oid
        where e.extname = 'pg_graphql'
    ) then
        return;
    end if;

    drop function if exists graphql_public.graphql;
    create or replace function graphql_public.graphql(
        "operationName" text default null,
        query text default null,
        variables jsonb default null,
        extensions jsonb default null
    )
        returns jsonb
        language sql
    as $$
        select graphql.resolve(
            query := query,
            variables := coalesce(variables, '{}'),
            "operationName" := "operationName",
            extensions := extensions
        );
    $$;

    -- Attach the wrapper to the extension so DROP EXTENSION cascades to it,
    -- which in turn triggers set_graphql_placeholder to reinstall the "not enabled" stub.
    alter extension pg_graphql add function graphql_public.graphql(text, text, jsonb, jsonb);

    grant usage on schema graphql to postgres, anon, authenticated, service_role;
    grant execute on function graphql.resolve to postgres, anon, authenticated, service_role;
    grant usage on schema graphql to postgres with grant option;
    grant usage on schema graphql_public to postgres with grant option;
end;
$_$;


ALTER FUNCTION extensions.grant_pg_graphql_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    IF EXISTS (
      SELECT FROM pg_extension
      WHERE extname = 'pg_net'
      -- all versions in use on existing projects as of 2025-02-20
      -- version 0.12.0 onwards don't need these applied
      AND extversion IN ('0.2', '0.6', '0.7', '0.7.1', '0.8.0', '0.10.0', '0.11.0')
    ) THEN
      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

      REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
      REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

      GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
      GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    END IF;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO supabase_admin;

--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
            set search_path to ''
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


ALTER FUNCTION extensions.set_graphql_placeholder() OWNER TO supabase_admin;

--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: graphql(text, text, jsonb, jsonb); Type: FUNCTION; Schema: graphql_public; Owner: supabase_admin
--

CREATE FUNCTION graphql_public.graphql("operationName" text DEFAULT NULL::text, query text DEFAULT NULL::text, variables jsonb DEFAULT NULL::jsonb, extensions jsonb DEFAULT NULL::jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;


ALTER FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) OWNER TO supabase_admin;

--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: supabase_admin
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $_$
  BEGIN
      RAISE DEBUG 'PgBouncer auth request: %', p_usename;

      RETURN QUERY
      SELECT
          rolname::text,
          CASE WHEN rolvaliduntil < now()
              THEN null
              ELSE rolpassword::text
          END
      FROM pg_authid
      WHERE rolname=$1 and rolcanlogin;
  END;
  $_$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO supabase_admin;

--
-- Name: handle_new_user(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.handle_new_user() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
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


ALTER FUNCTION public.handle_new_user() OWNER TO postgres;

--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
    -- Regclass of the table e.g. public.notes
    entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

    -- I, U, D, T: insert, update ...
    action realtime.action = (
        case wal ->> 'action'
            when 'I' then 'INSERT'
            when 'U' then 'UPDATE'
            when 'D' then 'DELETE'
            else 'ERROR'
        end
    );

    -- Is row level security enabled for the table
    is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

    subscriptions realtime.subscription[] = array_agg(subs)
        from
            realtime.subscription subs
        where
            subs.entity = entity_
            -- Filter by action early - only get subscriptions interested in this action
            -- action_filter column can be: '*' (all), 'INSERT', 'UPDATE', or 'DELETE'
            and (subs.action_filter = '*' or subs.action_filter = action::text);

    -- Subscription vars
    working_role regrole;
    working_selected_columns text[];
    claimed_role regrole;
    claims jsonb;

    subscription_id uuid;
    subscription_has_access bool;
    visible_to_subscription_ids uuid[] = '{}';

    -- structured info for wal's columns
    columns realtime.wal_column[];
    -- previous identity values for update/delete
    old_columns realtime.wal_column[];

    error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

    -- Primary jsonb output for record
    output jsonb;

    -- Loop record for iterating unique roles (outer loop)
    role_record record;
    -- Loop record for iterating unique selected_columns within a role (inner loop)
    cols_record record;
    -- Subscription ids visible at the role level (before fanning out by selected_columns)
    visible_role_sub_ids uuid[] = '{}';

begin
    perform set_config('role', null, true);

    columns =
        array_agg(
            (
                x->>'name',
                x->>'type',
                x->>'typeoid',
                realtime.cast(
                    (x->'value') #>> '{}',
                    coalesce(
                        (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                        (x->>'type')::regtype
                    )
                ),
                (pks ->> 'name') is not null,
                true
            )::realtime.wal_column
        )
        from
            jsonb_array_elements(wal -> 'columns') x
            left join jsonb_array_elements(wal -> 'pk') pks
                on (x ->> 'name') = (pks ->> 'name');

    old_columns =
        array_agg(
            (
                x->>'name',
                x->>'type',
                x->>'typeoid',
                realtime.cast(
                    (x->'value') #>> '{}',
                    coalesce(
                        (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                        (x->>'type')::regtype
                    )
                ),
                (pks ->> 'name') is not null,
                true
            )::realtime.wal_column
        )
        from
            jsonb_array_elements(wal -> 'identity') x
            left join jsonb_array_elements(wal -> 'pk') pks
                on (x ->> 'name') = (pks ->> 'name');

    for role_record in
        select claims_role
        from (select distinct claims_role from unnest(subscriptions)) t
        order by claims_role::text
    loop
        working_role := role_record.claims_role;

        -- Update `is_selectable` for columns and old_columns (once per role)
        columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(columns) c;

        old_columns =
                array_agg(
                    (
                        c.name,
                        c.type_name,
                        c.type_oid,
                        c.value,
                        c.is_pkey,
                        pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                    )::realtime.wal_column
                )
                from
                    unnest(old_columns) c;

        if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
            -- Fan out 400 error per distinct selected_columns for this role
            for cols_record in
                select selected_columns
                from (select distinct selected_columns from unnest(subscriptions) s where s.claims_role = working_role) t
                order by coalesce(array_to_string(selected_columns, ','), '')
            loop
                working_selected_columns := cols_record.selected_columns;
                return next (
                    jsonb_build_object(
                        'schema', wal ->> 'schema',
                        'table', wal ->> 'table',
                        'type', action
                    ),
                    is_rls_enabled,
                    (select array_agg(s.subscription_id) from unnest(subscriptions) as s where s.claims_role = working_role and (s.selected_columns is not distinct from working_selected_columns)),
                    array['Error 400: Bad Request, no primary key']
                )::realtime.wal_rls;
            end loop;

        -- The claims role does not have SELECT permission to the primary key of entity
        elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
            -- Fan out 401 error per distinct selected_columns for this role
            for cols_record in
                select selected_columns
                from (select distinct selected_columns from unnest(subscriptions) s where s.claims_role = working_role) t
                order by coalesce(array_to_string(selected_columns, ','), '')
            loop
                working_selected_columns := cols_record.selected_columns;
                return next (
                    jsonb_build_object(
                        'schema', wal ->> 'schema',
                        'table', wal ->> 'table',
                        'type', action
                    ),
                    is_rls_enabled,
                    (select array_agg(s.subscription_id) from unnest(subscriptions) as s where s.claims_role = working_role and (s.selected_columns is not distinct from working_selected_columns)),
                    array['Error 401: Unauthorized']
                )::realtime.wal_rls;
            end loop;

        else
            -- Create the prepared statement (once per role)
            if is_rls_enabled and action <> 'DELETE' then
                if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                    deallocate walrus_rls_stmt;
                end if;
                execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
            end if;

            -- Collect all visible subscription IDs for this role (filter check + RLS check)
            visible_role_sub_ids = '{}';

            for subscription_id, claims in (
                    select
                        subs.subscription_id,
                        subs.claims
                    from
                        unnest(subscriptions) subs
                    where
                        subs.entity = entity_
                        and subs.claims_role = working_role
                        and (
                            realtime.is_visible_through_filters(columns, subs.filters)
                            or (
                              action = 'DELETE'
                              and realtime.is_visible_through_filters(old_columns, subs.filters)
                            )
                        )
            ) loop

                if not is_rls_enabled or action = 'DELETE' then
                    visible_role_sub_ids = visible_role_sub_ids || subscription_id;
                else
                    -- Check if RLS allows the role to see the record
                    perform
                        -- Trim leading and trailing quotes from working_role because set_config
                        -- doesn't recognize the role as valid if they are included
                        set_config('role', trim(both '"' from working_role::text), true),
                        set_config('request.jwt.claims', claims::text, true);

                    execute 'execute walrus_rls_stmt' into subscription_has_access;

                    -- Reset the role on every FOR..LOOP batch execution.
                    -- The first batch of 10 rows is pre-fetched using the current connection role (PG internal behaviour)
                    -- then we have to reset it again otherwise it would use the role defined in the `set_config` above
                    -- to fetch the remaining rows when rows>10, which could be a user-defined role that lacks execution grants.
                    -- The flow is:
                    --   1. run batch with conn role
                    --   2. set_config working_role
                    --   3. execute walrus
                    --   4. reset role (revert)
                    --   5. repeat
                    perform set_config('role', null, true);

                    if subscription_has_access then
                        visible_role_sub_ids = visible_role_sub_ids || subscription_id;
                    end if;
                end if;
            end loop;

            perform set_config('role', null, true);

            -- Inner loop: per distinct selected_columns for this role
            for cols_record in
                select selected_columns
                from (select distinct selected_columns from unnest(subscriptions) s where s.claims_role = working_role) t
                order by coalesce(array_to_string(selected_columns, ','), '')
            loop
                working_selected_columns := cols_record.selected_columns;

                output = jsonb_build_object(
                    'schema', wal ->> 'schema',
                    'table', wal ->> 'table',
                    'type', action,
                    'commit_timestamp', to_char(
                        ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                        'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
                    ),
                    'columns', (
                        select
                            jsonb_agg(
                                jsonb_build_object(
                                    'name', pa.attname,
                                    'type', pt.typname
                                )
                                order by pa.attnum asc
                            )
                        from
                            pg_attribute pa
                            join pg_type pt
                                on pa.atttypid = pt.oid
                            left join (
                                select unnest(conkey) as pkey_attnum
                                from pg_constraint
                                where conrelid = entity_ and contype = 'p'
                            ) pk on pk.pkey_attnum = pa.attnum
                        where
                            attrelid = entity_
                            and attnum > 0
                            and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
                            and (working_selected_columns is null or pa.attname = any(working_selected_columns) or pk.pkey_attnum is not null)
                    )
                )
                -- Add "record" key for insert and update
                || case
                    when action in ('INSERT', 'UPDATE') then
                        jsonb_build_object(
                            'record',
                            (
                                select
                                    jsonb_object_agg(
                                        -- if unchanged toast, get column name and value from old record
                                        coalesce((c).name, (oc).name),
                                        case
                                            when (c).name is null then (oc).value
                                            else (c).value
                                        end
                                    )
                                from
                                    unnest(columns) c
                                    full outer join unnest(old_columns) oc
                                        on (c).name = (oc).name
                                where
                                    coalesce((c).is_selectable, (oc).is_selectable)
                                    and (working_selected_columns is null or coalesce((c).name, (oc).name) = any(working_selected_columns) or coalesce((c).is_pkey, (oc).is_pkey))
                                    and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            )
                        )
                    else '{}'::jsonb
                end
                -- Add "old_record" key for update and delete
                || case
                    when action = 'UPDATE' then
                        jsonb_build_object(
                                'old_record',
                                (
                                    select jsonb_object_agg((c).name, (c).value)
                                    from unnest(old_columns) c
                                    where
                                        (c).is_selectable
                                        and (working_selected_columns is null or (c).name = any(working_selected_columns) or (c).is_pkey)
                                        and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                                )
                            )
                    when action = 'DELETE' then
                        jsonb_build_object(
                            'old_record',
                            (
                                select jsonb_object_agg((c).name, (c).value)
                                from unnest(old_columns) c
                                where
                                    (c).is_selectable
                                    and (working_selected_columns is null or (c).name = any(working_selected_columns) or (c).is_pkey)
                                    and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                                    and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                            )
                        )
                    else '{}'::jsonb
                end;

                -- Filter visible_role_sub_ids to those matching the current selected_columns group
                visible_to_subscription_ids = coalesce(
                    (
                        select array_agg(s.subscription_id)
                        from unnest(subscriptions) s
                        where s.claims_role = working_role
                          and (s.selected_columns is not distinct from working_selected_columns)
                          and s.subscription_id = any(visible_role_sub_ids)
                    ),
                    '{}'::uuid[]
                );

                return next (
                    output,
                    is_rls_enabled,
                    visible_to_subscription_ids,
                    case
                        when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                        else '{}'
                    end
                )::realtime.wal_rls;
            end loop;

        end if;
    end loop;

    perform set_config('role', null, true);
end;
$$;


ALTER FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) OWNER TO supabase_realtime_admin;

--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


ALTER FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) OWNER TO supabase_realtime_admin;

--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


ALTER FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) OWNER TO supabase_realtime_admin;

--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
declare
  res jsonb;
begin
  if type_::text = 'bytea' then
    return to_jsonb(val);
  end if;
  execute format('select to_jsonb(%L::'|| type_::text || ')', val) into res;
  return res;
end
$$;


ALTER FUNCTION realtime."cast"(val text, type_ regtype) OWNER TO supabase_realtime_admin;

--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
/*
Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
*/
declare
    op_symbol text = (
        case
            when op = 'eq' then '='
            when op = 'neq' then '!='
            when op = 'lt' then '<'
            when op = 'lte' then '<='
            when op = 'gt' then '>'
            when op = 'gte' then '>='
            when op = 'in' then '= any'
            else 'UNKNOWN OP'
        end
    );
    res boolean;
begin
    execute format(
        'select %L::'|| type_::text || ' ' || op_symbol
        || ' ( %L::'
        || (
            case
                when op = 'in' then type_::text || '[]'
                else type_::text end
        )
        || ')', val_1, val_2) into res;
    return res;
end;
$$;


ALTER FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) OWNER TO supabase_realtime_admin;

--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean) RETURNS boolean
    LANGUAGE plpgsql STABLE
    AS $$
declare
    op_symbol text;
    res boolean;
begin
    -- IS DISTINCT FROM / IS NOT DISTINCT FROM: infix, both sides typed literals
    if op = 'isdistinct' then
        execute format(
            'select %L::%s %s %L::%s',
            val_1,
            type_::text,
            case when negate then 'IS NOT DISTINCT FROM' else 'IS DISTINCT FROM' end,
            val_2,
            type_::text
        ) into res;
        return res;
    end if;

    -- IS requires a keyword RHS (NULL, TRUE, FALSE, UNKNOWN), not a typed literal
    if op = 'is' then
        if val_2 not in ('null', 'true', 'false', 'unknown') then
            raise exception 'invalid value for is filter: must be null, true, false, or unknown';
        end if;
        execute format(
            'select %L::%s %s %s',
            val_1,
            type_::text,
            case when negate then 'IS NOT' else 'IS' end,
            upper(val_2)
        ) into res;
        return res;
    end if;

    op_symbol = case
        when op = 'eq'    then '='
        when op = 'neq'   then '!='
        when op = 'lt'    then '<'
        when op = 'lte'   then '<='
        when op = 'gt'    then '>'
        when op = 'gte'   then '>='
        when op = 'in'    then '= any'
        when op = 'like'   then 'LIKE'
        when op = 'ilike'  then 'ILIKE'
        when op = 'match'  then '~'
        when op = 'imatch' then '~*'
        else null
    end;

    if op_symbol is null then
        raise exception 'unsupported equality operator: %', op::text;
    end if;

    execute format(
        'select %L::%s %s (%L::%s)',
        val_1,
        type_::text,
        op_symbol,
        val_2,
        case when op = 'in' then type_::text || '[]' else type_::text end
    ) into res;

    return case when negate then not res else res end;
end;
$$;


ALTER FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean) OWNER TO supabase_realtime_admin;

--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
    select
        filters is null
        or array_length(filters, 1) is null
        or coalesce(
            count(col.name) = count(1)
            and sum(
                realtime.check_equality_op(
                    op:=f.op,
                    type_:=coalesce(col.type_oid::regtype, col.type_name::regtype),
                    val_1:=col.value #>> '{}',
                    val_2:=f.value,
                    negate:=coalesce(f.negate, false)
                )::int
            ) filter (where col.name is not null) = count(col.name),
            false
        )
    from
        unnest(filters) f
        left join unnest(columns) col
            on f.column_name = col.name;
$$;


ALTER FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) OWNER TO supabase_realtime_admin;

--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS TABLE(wal jsonb, is_rls_enabled boolean, subscription_ids uuid[], errors text[], slot_changes_count bigint)
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
  WITH pub AS (
    SELECT
      concat_ws(
        ',',
        CASE WHEN bool_or(pubinsert) THEN 'insert' ELSE NULL END,
        CASE WHEN bool_or(pubupdate) THEN 'update' ELSE NULL END,
        CASE WHEN bool_or(pubdelete) THEN 'delete' ELSE NULL END
      ) AS w2j_actions,
      coalesce(
        string_agg(
          realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
          ','
        ) filter (WHERE ppt.tablename IS NOT NULL),
        ''
      ) AS w2j_add_tables
    FROM pg_publication pp
    LEFT JOIN pg_publication_tables ppt ON pp.pubname = ppt.pubname
    WHERE pp.pubname = publication
    GROUP BY pp.pubname
    LIMIT 1
  ),
  -- MATERIALIZED ensures pg_logical_slot_get_changes is called exactly once
  w2j AS MATERIALIZED (
    SELECT x.*, pub.w2j_add_tables
    FROM pub,
         pg_logical_slot_get_changes(
           slot_name, null, max_changes,
           'include-pk', 'true',
           'include-transaction', 'false',
           'include-timestamp', 'true',
           'include-type-oids', 'true',
           'format-version', '2',
           'actions', pub.w2j_actions,
           'add-tables', pub.w2j_add_tables
         ) x
  ),
  slot_count AS (
    SELECT count(*)::bigint AS cnt
    FROM w2j
    WHERE w2j.w2j_add_tables <> ''
  ),
  rls_filtered AS (
    SELECT xyz.wal, xyz.is_rls_enabled, xyz.subscription_ids, xyz.errors
    FROM w2j,
         realtime.apply_rls(
           wal := w2j.data::jsonb,
           max_record_bytes := max_record_bytes
         ) xyz(wal, is_rls_enabled, subscription_ids, errors)
    WHERE w2j.w2j_add_tables <> ''
      AND xyz.subscription_ids[1] IS NOT NULL
  )
  SELECT rf.wal, rf.is_rls_enabled, rf.subscription_ids, rf.errors, sc.cnt
  FROM rls_filtered rf, slot_count sc

  UNION ALL

  SELECT null, null, null, null, sc.cnt
  FROM slot_count sc
  WHERE NOT EXISTS (SELECT 1 FROM rls_filtered)
$$;


ALTER FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) OWNER TO supabase_realtime_admin;

--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
  SELECT
    realtime.wal2json_escape_identifier(nsp.nspname::text)
    || '.'
    || realtime.wal2json_escape_identifier(pc.relname::text)
  FROM pg_class pc
  JOIN pg_namespace nsp ON pc.relnamespace = nsp.oid
  WHERE pc.oid = entity
$$;


ALTER FUNCTION realtime.quote_wal2json(entity regclass) OWNER TO supabase_realtime_admin;

--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  generated_id uuid;
  final_payload jsonb;
BEGIN
  BEGIN
    generated_id := gen_random_uuid();

    -- Check if payload has an 'id' key, if not, add the generated UUID
    IF payload ? 'id' THEN
      final_payload := payload;
    ELSE
      final_payload := jsonb_set(payload, '{id}', to_jsonb(generated_id));
    END IF;

    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    INSERT INTO realtime.messages (id, payload, event, topic, private, extension)
    VALUES (generated_id, final_payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'WarnSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


ALTER FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) OWNER TO supabase_realtime_admin;

--
-- Name: send_binary(bytea, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.send_binary(payload bytea, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  generated_id uuid;
BEGIN
  BEGIN
    generated_id := gen_random_uuid();

    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    INSERT INTO realtime.messages (id, binary_payload, event, topic, private, extension)
    VALUES (generated_id, payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'WarnSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


ALTER FUNCTION realtime.send_binary(payload bytea, event text, topic text, private boolean) OWNER TO supabase_realtime_admin;

--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
    col_names text[] = coalesce(
            array_agg(a.attname order by a.attnum),
            '{}'::text[]
        )
        from
            pg_catalog.pg_attribute a
        where
            a.attrelid = new.entity
            and a.attnum > 0
            and not a.attisdropped
            and pg_catalog.has_column_privilege(
                (new.claims ->> 'role'),
                a.attrelid,
                a.attnum,
                'SELECT'
            );
    filter realtime.user_defined_filter;
    col_type regtype;
    in_val jsonb;
    selected_col text;
begin
    for filter in select * from unnest(new.filters) loop
        if not filter.column_name = any(col_names) then
            raise exception 'invalid column for filter %', filter.column_name;
        end if;

        col_type = (
            select atttypid::regtype
            from pg_catalog.pg_attribute
            where attrelid = new.entity
                  and attname = filter.column_name
        );
        if col_type is null then
            raise exception 'failed to lookup type for column %', filter.column_name;
        end if;

        if filter.op = 'in'::realtime.equality_op then
            in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
            if coalesce(jsonb_array_length(in_val), 0) > 100 then
                raise exception 'too many values for `in` filter. Maximum 100';
            end if;
        elsif filter.op = 'is'::realtime.equality_op then
            -- `is` requires a keyword RHS rather than a typed literal
            if filter.value not in ('null', 'true', 'false', 'unknown') then
                raise exception 'invalid value for is filter: must be null, true, false, or unknown';
            end if;
            -- IS NULL works for any type, but IS TRUE/FALSE/UNKNOWN require a boolean
            -- operand. Reject the non-null keywords on non-boolean columns here so they
            -- don't abort apply_rls at WAL time.
            if filter.value <> 'null' and col_type <> 'boolean'::regtype then
                raise exception 'is % filter requires a boolean column, got %', filter.value, col_type::text;
            end if;
        elsif filter.op in ('like'::realtime.equality_op, 'ilike'::realtime.equality_op) then
            -- like/ilike apply the text pattern operator (~~); reject column types that
            -- have no such operator instead of failing at WAL time
            if not exists (
                select 1 from pg_catalog.pg_operator
                where oprname = '~~' and oprleft = col_type
            ) then
                raise exception 'operator % requires a text-compatible column type, got %', filter.op::text, col_type::text;
            end if;
        elsif filter.op in ('match'::realtime.equality_op, 'imatch'::realtime.equality_op) then
            -- match/imatch apply the regex operators ~ / ~*; reject column types that have
            -- no such operator (e.g. integer) instead of failing at WAL time, mirroring the
            -- like/ilike guard above.
            if not exists (
                select 1 from pg_catalog.pg_operator
                where oprname = case when filter.op = 'imatch'::realtime.equality_op then '~*' else '~' end
                  and oprleft = col_type
                  and oprright = col_type
                  and oprresult = 'boolean'::regtype
            ) then
                raise exception 'operator % requires a text-compatible column type, got %', filter.op::text, col_type::text;
            end if;
            -- validate the regex eagerly so a bad pattern is rejected here, not inside
            -- apply_rls where it would abort the WAL stream for the entity
            begin
                perform '' ~ filter.value;
            exception when others then
                raise exception 'invalid regular expression for % filter: %', filter.op::text, sqlerrm;
            end;
        else
            -- eq/neq/lt/lte/gt/gte: value must be coercable to the type
            perform realtime.cast(filter.value, col_type);
        end if;
    end loop;

    if new.selected_columns is not null then
        for selected_col in select * from unnest(new.selected_columns) loop
            if not selected_col = any(col_names) then
                raise exception 'invalid column for select %', selected_col;
            end if;
        end loop;
    end if;

    -- Apply consistent order to filters so the unique constraint can't be tricked by a
    -- different filter order. negate is part of the sort key.
    new.filters = coalesce(
        array_agg(f order by f.column_name, f.op, f.value, f.negate),
        '{}'
    ) from unnest(new.filters) f;

    new.selected_columns = (
        select array_agg(c order by c)
        from unnest(new.selected_columns) c
    );

    return new;
end;
$$;


ALTER FUNCTION realtime.subscription_check_filters() OWNER TO supabase_realtime_admin;

--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


ALTER FUNCTION realtime.to_regrole(role_name text) OWNER TO supabase_realtime_admin;

--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


ALTER FUNCTION realtime.topic() OWNER TO supabase_realtime_admin;

--
-- Name: wal2json_escape_identifier(text); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.wal2json_escape_identifier(name text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
  -- Prefix `\`, `,`, `.`, and any whitespace with `\`
  SELECT regexp_replace(name, '([\\,.[:space:]])', '\\\1', 'g')
$$;


ALTER FUNCTION realtime.wal2json_escape_identifier(name text) OWNER TO supabase_realtime_admin;

--
-- Name: allow_any_operation(text[]); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.allow_any_operation(expected_operations text[]) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  WITH current_operation AS (
    SELECT storage.operation() AS raw_operation
  ),
  normalized AS (
    SELECT CASE
      WHEN raw_operation LIKE 'storage.%' THEN substr(raw_operation, 9)
      ELSE raw_operation
    END AS current_operation
    FROM current_operation
  )
  SELECT EXISTS (
    SELECT 1
    FROM normalized n
    CROSS JOIN LATERAL unnest(expected_operations) AS expected_operation
    WHERE expected_operation IS NOT NULL
      AND expected_operation <> ''
      AND n.current_operation = CASE
        WHEN expected_operation LIKE 'storage.%' THEN substr(expected_operation, 9)
        ELSE expected_operation
      END
  );
$$;


ALTER FUNCTION storage.allow_any_operation(expected_operations text[]) OWNER TO supabase_storage_admin;

--
-- Name: allow_only_operation(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.allow_only_operation(expected_operation text) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  WITH current_operation AS (
    SELECT storage.operation() AS raw_operation
  ),
  normalized AS (
    SELECT
      CASE
        WHEN raw_operation LIKE 'storage.%' THEN substr(raw_operation, 9)
        ELSE raw_operation
      END AS current_operation,
      CASE
        WHEN expected_operation LIKE 'storage.%' THEN substr(expected_operation, 9)
        ELSE expected_operation
      END AS requested_operation
    FROM current_operation
  )
  SELECT CASE
    WHEN requested_operation IS NULL OR requested_operation = '' THEN FALSE
    ELSE COALESCE(current_operation = requested_operation, FALSE)
  END
  FROM normalized;
$$;


ALTER FUNCTION storage.allow_only_operation(expected_operation text) OWNER TO supabase_storage_admin;

--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


ALTER FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) OWNER TO supabase_storage_admin;

--
-- Name: enforce_bucket_name_length(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.enforce_bucket_name_length() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    if length(new.name) > 100 then
        raise exception 'bucket name "%" is too long (% characters). Max is 100.', new.name, length(new.name);
    end if;
    return new;
end;
$$;


ALTER FUNCTION storage.enforce_bucket_name_length() OWNER TO supabase_storage_admin;

--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
    _filename text;
BEGIN
    -- Split on "/" to get path segments
    SELECT string_to_array(name, '/') INTO _parts;
    -- Get the last path segment (the actual filename)
    SELECT _parts[array_length(_parts, 1)] INTO _filename;
    -- Extract extension: reverse, split on '.', then reverse again
    RETURN reverse(split_part(reverse(_filename), '.', 1));
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO supabase_storage_admin;

--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
BEGIN
    SELECT string_to_array(name, '/') INTO _parts;
    RETURN _parts[array_length(_parts, 1)];
END
$$;


ALTER FUNCTION storage.filename(name text) OWNER TO supabase_storage_admin;

--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
BEGIN
    -- Split on "/" to get path segments
    SELECT string_to_array(name, '/') INTO _parts;
    -- Return everything except the last segment
    RETURN _parts[1 : array_length(_parts,1) - 1];
END
$$;


ALTER FUNCTION storage.foldername(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_common_prefix(text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT CASE
    WHEN position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)) > 0
    THEN left(p_key, length(p_prefix) + position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)))
    ELSE NULL
END;
$$;


ALTER FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) OWNER TO supabase_storage_admin;

--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::bigint)::bigint as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket() OWNER TO supabase_storage_admin;

--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


ALTER FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text) OWNER TO supabase_storage_admin;

--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;

    -- Configuration
    v_is_asc BOOLEAN;
    v_prefix TEXT;
    v_start TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_is_asc := lower(coalesce(sort_order, 'asc')) = 'asc';
    v_prefix := coalesce(prefix_param, '');
    v_start := CASE WHEN coalesce(next_token, '') <> '' THEN next_token ELSE coalesce(start_after, '') END;
    v_file_batch_size := LEAST(GREATEST(max_keys * 2, 100), 1000);

    -- Calculate upper bound for prefix filtering (bytewise, using COLLATE "C")
    IF v_prefix = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix, 1) = delimiter_param THEN
        v_upper_bound := left(v_prefix, -1) || chr(ascii(delimiter_param) + 1);
    ELSE
        v_upper_bound := left(v_prefix, -1) || chr(ascii(right(v_prefix, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'AND o.name COLLATE "C" < $3 ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'AND o.name COLLATE "C" >= $3 ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- ========================================================================
    -- SEEK INITIALIZATION: Determine starting position
    -- ========================================================================
    IF v_start = '' THEN
        IF v_is_asc THEN
            v_next_seek := v_prefix;
        ELSE
            -- DESC without cursor: find the last item in range
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;

            IF v_next_seek IS NOT NULL THEN
                v_next_seek := v_next_seek || delimiter_param;
            ELSE
                RETURN;
            END IF;
        END IF;
    ELSE
        -- Cursor provided: determine if it refers to a folder or leaf
        IF EXISTS (
            SELECT 1 FROM storage.objects o
            WHERE o.bucket_id = _bucket_id
              AND o.name COLLATE "C" LIKE v_start || delimiter_param || '%'
            LIMIT 1
        ) THEN
            -- Cursor refers to a folder
            IF v_is_asc THEN
                v_next_seek := v_start || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_start || delimiter_param;
            END IF;
        ELSE
            -- Cursor refers to a leaf object
            IF v_is_asc THEN
                v_next_seek := v_start || delimiter_param;
            ELSE
                v_next_seek := v_start;
            END IF;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= max_keys;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(v_peek_name, v_prefix, delimiter_param);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Emit and skip to next folder (no heap access needed)
            name := rtrim(v_common_prefix, delimiter_param);
            id := NULL;
            updated_at := NULL;
            created_at := NULL;
            last_accessed_at := NULL;
            metadata := NULL;
            RETURN NEXT;
            v_count := v_count + 1;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := left(v_common_prefix, -1) || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_common_prefix;
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query USING _bucket_id, v_next_seek,
                CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix) ELSE v_prefix END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(v_current.name, v_prefix, delimiter_param);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := v_current.name;
                    EXIT;
                END IF;

                -- Emit file
                name := v_current.name;
                id := v_current.id;
                updated_at := v_current.updated_at;
                created_at := v_current.created_at;
                last_accessed_at := v_current.last_accessed_at;
                metadata := v_current.metadata;
                RETURN NEXT;
                v_count := v_count + 1;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := v_current.name || delimiter_param;
                ELSE
                    v_next_seek := v_current.name;
                END IF;

                EXIT WHEN v_count >= max_keys;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


ALTER FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text, sort_order text) OWNER TO supabase_storage_admin;

--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


ALTER FUNCTION storage.operation() OWNER TO supabase_storage_admin;

--
-- Name: protect_delete(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.protect_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Check if storage.allow_delete_query is set to 'true'
    IF COALESCE(current_setting('storage.allow_delete_query', true), 'false') != 'true' THEN
        RAISE EXCEPTION 'Direct deletion from storage tables is not allowed. Use the Storage API instead.'
            USING HINT = 'This prevents accidental data loss from orphaned objects.',
                  ERRCODE = '42501';
    END IF;
    RETURN NULL;
END;
$$;


ALTER FUNCTION storage.protect_delete() OWNER TO supabase_storage_admin;

--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;
    v_delimiter CONSTANT TEXT := '/';

    -- Configuration
    v_limit INT;
    v_prefix TEXT;
    v_prefix_lower TEXT;
    v_prefix_len INT;
    v_prefix_start INT;
    v_combined_levels INT;
    v_is_asc BOOLEAN;
    v_order_by TEXT;
    v_sort_order TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;
    v_skipped INT := 0;
BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_limit := LEAST(coalesce(limits, 100), 1500);
    v_prefix := coalesce(prefix, '') || coalesce(search, '');
    v_prefix_lower := lower(v_prefix);
    v_prefix_len := length(coalesce(prefix, ''));
    v_prefix_start := coalesce(array_length(string_to_array(coalesce(prefix, ''), v_delimiter), 1), 1);
    v_combined_levels := coalesce(array_length(string_to_array(v_prefix, v_delimiter), 1), 1);
    v_is_asc := lower(coalesce(sortorder, 'asc')) = 'asc';
    v_file_batch_size := LEAST(GREATEST(v_limit * 2, 100), 1000);

    -- Validate sort column
    CASE lower(coalesce(sortcolumn, 'name'))
        WHEN 'name' THEN v_order_by := 'name';
        WHEN 'updated_at' THEN v_order_by := 'updated_at';
        WHEN 'created_at' THEN v_order_by := 'created_at';
        WHEN 'last_accessed_at' THEN v_order_by := 'last_accessed_at';
        ELSE v_order_by := 'name';
    END CASE;

    v_sort_order := CASE WHEN v_is_asc THEN 'asc' ELSE 'desc' END;

    -- ========================================================================
    -- NON-NAME SORTING: Use path_tokens approach
    -- ========================================================================
    IF v_order_by != 'name' THEN
        RETURN QUERY EXECUTE format(
            $sql$
            WITH folders AS (
                SELECT array_to_string(path_tokens[$1:$2], '/') AS folder
                FROM storage.objects
                WHERE objects.name ILIKE $3 || '%%'
                  AND bucket_id = $4
                  AND array_length(objects.path_tokens, 1) <> $2
                GROUP BY folder
                ORDER BY folder %s
            )
            (SELECT folder AS "name",
                   NULL::uuid AS id,
                   NULL::timestamptz AS updated_at,
                   NULL::timestamptz AS created_at,
                   NULL::timestamptz AS last_accessed_at,
                   NULL::jsonb AS metadata FROM folders)
            UNION ALL
            (SELECT array_to_string(path_tokens[$1:$2], '/') AS "name",
                   id, updated_at, created_at, last_accessed_at, metadata
             FROM storage.objects
             WHERE objects.name ILIKE $3 || '%%'
               AND bucket_id = $4
               AND array_length(objects.path_tokens, 1) = $2
             ORDER BY %I %s)
            LIMIT $5 OFFSET $6
            $sql$, v_sort_order, v_order_by, v_sort_order
        ) USING v_prefix_start, v_combined_levels, v_prefix, bucketname, v_limit, offsets;
        RETURN;
    END IF;

    -- ========================================================================
    -- NAME SORTING: Hybrid skip-scan with batch optimization
    -- ========================================================================

    -- Calculate upper bound for prefix filtering
    IF v_prefix_lower = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix_lower, 1) = v_delimiter THEN
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(v_delimiter) + 1);
    ELSE
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(right(v_prefix_lower, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'AND lower(o.name) COLLATE "C" < $3 ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'AND lower(o.name) COLLATE "C" >= $3 ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- Initialize seek position
    IF v_is_asc THEN
        v_next_seek := v_prefix_lower;
    ELSE
        -- DESC: find the last item in range first (static SQL)
        IF v_upper_bound IS NOT NULL THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower AND lower(o.name) COLLATE "C" < v_upper_bound
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSIF v_prefix_lower <> '' THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSE
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        END IF;

        IF v_peek_name IS NOT NULL THEN
            v_next_seek := lower(v_peek_name) || v_delimiter;
        ELSE
            RETURN;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= v_limit;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek AND lower(o.name) COLLATE "C" < v_upper_bound
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix_lower <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(lower(v_peek_name), v_prefix_lower, v_delimiter);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Handle offset, emit if needed, skip to next folder
            IF v_skipped < offsets THEN
                v_skipped := v_skipped + 1;
            ELSE
                name := substring(rtrim(storage.get_common_prefix(v_peek_name, v_prefix, v_delimiter), v_delimiter) from v_prefix_len + 1);
                id := NULL;
                updated_at := NULL;
                created_at := NULL;
                last_accessed_at := NULL;
                metadata := NULL;
                RETURN NEXT;
                v_count := v_count + 1;
            END IF;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := lower(left(v_common_prefix, -1)) || chr(ascii(v_delimiter) + 1);
            ELSE
                v_next_seek := lower(v_common_prefix);
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix_lower is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query
                USING bucketname, v_next_seek,
                    CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix_lower) ELSE v_prefix_lower END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(lower(v_current.name), v_prefix_lower, v_delimiter);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := lower(v_current.name);
                    EXIT;
                END IF;

                -- Handle offset skipping
                IF v_skipped < offsets THEN
                    v_skipped := v_skipped + 1;
                ELSE
                    -- Emit file
                    name := substring(v_current.name from v_prefix_len + 1);
                    id := v_current.id;
                    updated_at := v_current.updated_at;
                    created_at := v_current.created_at;
                    last_accessed_at := v_current.last_accessed_at;
                    metadata := v_current.metadata;
                    RETURN NEXT;
                    v_count := v_count + 1;
                END IF;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := lower(v_current.name) || v_delimiter;
                ELSE
                    v_next_seek := lower(v_current.name);
                END IF;

                EXIT WHEN v_count >= v_limit;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: search_by_timestamp(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_cursor_op text;
    v_query text;
    v_prefix text;
    v_sort_order text;
    v_sort_column text;
BEGIN
    v_prefix := coalesce(p_prefix, '');

    -- Defense-in-depth: this function is independently reachable and must
    -- not trust p_sort_order/p_sort_column to already be validated by a
    -- caller. Normalize to the same strict allow-list storage.search_v2
    -- uses before interpolating anything into dynamic SQL below.
    v_sort_order := lower(coalesce(p_sort_order, 'asc'));
    IF v_sort_order NOT IN ('asc', 'desc') THEN
        v_sort_order := 'asc';
    END IF;

    v_sort_column := lower(coalesce(p_sort_column, 'updated_at'));
    IF v_sort_column NOT IN ('updated_at', 'created_at') THEN
        v_sort_column := 'updated_at';
    END IF;

    IF v_sort_order = 'asc' THEN
        v_cursor_op := '>';
    ELSE
        v_cursor_op := '<';
    END IF;

    v_query := format($sql$
        WITH raw_objects AS (
            SELECT
                o.name AS obj_name,
                o.id AS obj_id,
                o.updated_at AS obj_updated_at,
                o.created_at AS obj_created_at,
                o.last_accessed_at AS obj_last_accessed_at,
                o.metadata AS obj_metadata,
                storage.get_common_prefix(o.name, $1, '/') AS common_prefix
            FROM storage.objects o
            WHERE o.bucket_id = $2
              AND o.name COLLATE "C" LIKE $1 || '%%'
        ),
        -- Aggregate common prefixes (folders)
        -- Both created_at and updated_at use MIN(obj_created_at) to match the old prefixes table behavior
        aggregated_prefixes AS (
            SELECT
                rtrim(common_prefix, '/') AS name,
                NULL::uuid AS id,
                MIN(obj_created_at) AS updated_at,
                MIN(obj_created_at) AS created_at,
                NULL::timestamptz AS last_accessed_at,
                NULL::jsonb AS metadata,
                TRUE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NOT NULL
            GROUP BY common_prefix
        ),
        leaf_objects AS (
            SELECT
                obj_name AS name,
                obj_id AS id,
                obj_updated_at AS updated_at,
                obj_created_at AS created_at,
                obj_last_accessed_at AS last_accessed_at,
                obj_metadata AS metadata,
                FALSE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NULL
        ),
        combined AS (
            SELECT * FROM aggregated_prefixes
            UNION ALL
            SELECT * FROM leaf_objects
        ),
        filtered AS (
            SELECT *
            FROM combined
            WHERE (
                $5 = ''
                OR ROW(
                    date_trunc('milliseconds', %I),
                    name COLLATE "C"
                ) %s ROW(
                    COALESCE(NULLIF($6, '')::timestamptz, 'epoch'::timestamptz),
                    $5
                )
            )
        )
        SELECT
            split_part(name, '/', $3) AS key,
            name,
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
        FROM filtered
        ORDER BY
            COALESCE(date_trunc('milliseconds', %I), 'epoch'::timestamptz) %s,
            name COLLATE "C" %s
        LIMIT $4
    $sql$,
        v_sort_column,
        v_cursor_op,
        v_sort_column,
        v_sort_order,
        v_sort_order
    );

    RETURN QUERY EXECUTE v_query
    USING v_prefix, p_bucket_id, p_level, p_limit, p_start_after, p_sort_column_after;
END;
$_$;


ALTER FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text) OWNER TO supabase_storage_admin;

--
-- Name: search_v2(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer DEFAULT 100, levels integer DEFAULT 1, start_after text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, sort_column text DEFAULT 'name'::text, sort_column_after text DEFAULT ''::text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_sort_col text;
    v_sort_ord text;
    v_limit int;
BEGIN
    -- Cap limit to maximum of 1500 records
    v_limit := LEAST(coalesce(limits, 100), 1500);

    -- Validate and normalize sort_order
    v_sort_ord := lower(coalesce(sort_order, 'asc'));
    IF v_sort_ord NOT IN ('asc', 'desc') THEN
        v_sort_ord := 'asc';
    END IF;

    -- Validate and normalize sort_column
    v_sort_col := lower(coalesce(sort_column, 'name'));
    IF v_sort_col NOT IN ('name', 'updated_at', 'created_at') THEN
        v_sort_col := 'name';
    END IF;

    -- Route to appropriate implementation
    IF v_sort_col = 'name' THEN
        -- Use list_objects_with_delimiter for name sorting (most efficient: O(k * log n))
        RETURN QUERY
        SELECT
            split_part(l.name, '/', levels) AS key,
            l.name AS name,
            l.id,
            l.updated_at,
            l.created_at,
            l.last_accessed_at,
            l.metadata
        FROM storage.list_objects_with_delimiter(
            bucket_name,
            coalesce(prefix, ''),
            '/',
            v_limit,
            start_after,
            '',
            v_sort_ord
        ) l;
    ELSE
        -- Use aggregation approach for timestamp sorting
        -- Not efficient for large datasets but supports correct pagination
        RETURN QUERY SELECT * FROM storage.search_by_timestamp(
            prefix, bucket_name, v_limit, levels, start_after,
            v_sort_ord, v_sort_col, sort_column_after
        );
    END IF;
END;
$$;


ALTER FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer, levels integer, start_after text, sort_order text, sort_column text, sort_column_after text) OWNER TO supabase_storage_admin;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


ALTER FUNCTION storage.update_updated_at_column() OWNER TO supabase_storage_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE auth.audit_log_entries OWNER TO supabase_auth_admin;

--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: custom_oauth_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.custom_oauth_providers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    provider_type text NOT NULL,
    identifier text NOT NULL,
    name text NOT NULL,
    client_id text NOT NULL,
    client_secret text NOT NULL,
    acceptable_client_ids text[] DEFAULT '{}'::text[] NOT NULL,
    scopes text[] DEFAULT '{}'::text[] NOT NULL,
    pkce_enabled boolean DEFAULT true NOT NULL,
    attribute_mapping jsonb DEFAULT '{}'::jsonb NOT NULL,
    authorization_params jsonb DEFAULT '{}'::jsonb NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    email_optional boolean DEFAULT false NOT NULL,
    issuer text,
    discovery_url text,
    skip_nonce_check boolean DEFAULT false NOT NULL,
    cached_discovery jsonb,
    discovery_cached_at timestamp with time zone,
    authorization_url text,
    token_url text,
    userinfo_url text,
    jwks_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    custom_claims_allowlist text[] DEFAULT '{}'::text[] NOT NULL,
    CONSTRAINT custom_oauth_providers_authorization_url_https CHECK (((authorization_url IS NULL) OR (authorization_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_authorization_url_length CHECK (((authorization_url IS NULL) OR (char_length(authorization_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_client_id_length CHECK (((char_length(client_id) >= 1) AND (char_length(client_id) <= 512))),
    CONSTRAINT custom_oauth_providers_discovery_url_length CHECK (((discovery_url IS NULL) OR (char_length(discovery_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_identifier_format CHECK ((identifier ~ '^[a-z0-9][a-z0-9:-]{0,48}[a-z0-9]$'::text)),
    CONSTRAINT custom_oauth_providers_issuer_length CHECK (((issuer IS NULL) OR ((char_length(issuer) >= 1) AND (char_length(issuer) <= 2048)))),
    CONSTRAINT custom_oauth_providers_jwks_uri_https CHECK (((jwks_uri IS NULL) OR (jwks_uri ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_jwks_uri_length CHECK (((jwks_uri IS NULL) OR (char_length(jwks_uri) <= 2048))),
    CONSTRAINT custom_oauth_providers_name_length CHECK (((char_length(name) >= 1) AND (char_length(name) <= 100))),
    CONSTRAINT custom_oauth_providers_oauth2_requires_endpoints CHECK (((provider_type <> 'oauth2'::text) OR ((authorization_url IS NOT NULL) AND (token_url IS NOT NULL) AND (userinfo_url IS NOT NULL)))),
    CONSTRAINT custom_oauth_providers_oidc_discovery_url_https CHECK (((provider_type <> 'oidc'::text) OR (discovery_url IS NULL) OR (discovery_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_issuer_https CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NULL) OR (issuer ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_requires_issuer CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NOT NULL))),
    CONSTRAINT custom_oauth_providers_provider_type_check CHECK ((provider_type = ANY (ARRAY['oauth2'::text, 'oidc'::text]))),
    CONSTRAINT custom_oauth_providers_token_url_https CHECK (((token_url IS NULL) OR (token_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_token_url_length CHECK (((token_url IS NULL) OR (char_length(token_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_userinfo_url_https CHECK (((userinfo_url IS NULL) OR (userinfo_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_userinfo_url_length CHECK (((userinfo_url IS NULL) OR (char_length(userinfo_url) <= 2048)))
);


ALTER TABLE auth.custom_oauth_providers OWNER TO supabase_auth_admin;

--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text,
    code_challenge_method auth.code_challenge_method,
    code_challenge text,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone,
    invite_token text,
    referrer text,
    oauth_client_state_id uuid,
    linking_target_id uuid,
    email_optional boolean DEFAULT false NOT NULL
);


ALTER TABLE auth.flow_state OWNER TO supabase_auth_admin;

--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.flow_state IS 'Stores metadata for all OAuth/SSO login flows';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE auth.identities OWNER TO supabase_auth_admin;

--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.instances OWNER TO supabase_auth_admin;

--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE auth.mfa_amr_claims OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


ALTER TABLE auth.mfa_challenges OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid,
    last_webauthn_challenge_data jsonb
);


ALTER TABLE auth.mfa_factors OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: COLUMN mfa_factors.last_webauthn_challenge_data; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.mfa_factors.last_webauthn_challenge_data IS 'Stores the latest WebAuthn challenge data including attestation/assertion for customer verification';


--
-- Name: oauth_authorizations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_authorizations (
    id uuid NOT NULL,
    authorization_id text NOT NULL,
    client_id uuid NOT NULL,
    user_id uuid,
    redirect_uri text NOT NULL,
    scope text NOT NULL,
    state text,
    resource text,
    code_challenge text,
    code_challenge_method auth.code_challenge_method,
    response_type auth.oauth_response_type DEFAULT 'code'::auth.oauth_response_type NOT NULL,
    status auth.oauth_authorization_status DEFAULT 'pending'::auth.oauth_authorization_status NOT NULL,
    authorization_code text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone DEFAULT (now() + '00:03:00'::interval) NOT NULL,
    approved_at timestamp with time zone,
    nonce text,
    CONSTRAINT oauth_authorizations_authorization_code_length CHECK ((char_length(authorization_code) <= 255)),
    CONSTRAINT oauth_authorizations_code_challenge_length CHECK ((char_length(code_challenge) <= 128)),
    CONSTRAINT oauth_authorizations_expires_at_future CHECK ((expires_at > created_at)),
    CONSTRAINT oauth_authorizations_nonce_length CHECK ((char_length(nonce) <= 255)),
    CONSTRAINT oauth_authorizations_redirect_uri_length CHECK ((char_length(redirect_uri) <= 2048)),
    CONSTRAINT oauth_authorizations_resource_length CHECK ((char_length(resource) <= 2048)),
    CONSTRAINT oauth_authorizations_scope_length CHECK ((char_length(scope) <= 4096)),
    CONSTRAINT oauth_authorizations_state_length CHECK ((char_length(state) <= 4096))
);


ALTER TABLE auth.oauth_authorizations OWNER TO supabase_auth_admin;

--
-- Name: oauth_client_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_client_states (
    id uuid NOT NULL,
    provider_type text NOT NULL,
    code_verifier text,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE auth.oauth_client_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE oauth_client_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.oauth_client_states IS 'Stores OAuth states for third-party provider authentication flows where Supabase acts as the OAuth client.';


--
-- Name: oauth_clients; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_clients (
    id uuid NOT NULL,
    client_secret_hash text,
    registration_type auth.oauth_registration_type NOT NULL,
    redirect_uris text NOT NULL,
    grant_types text NOT NULL,
    client_name text,
    client_uri text,
    logo_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    client_type auth.oauth_client_type DEFAULT 'confidential'::auth.oauth_client_type NOT NULL,
    token_endpoint_auth_method text NOT NULL,
    CONSTRAINT oauth_clients_client_name_length CHECK ((char_length(client_name) <= 1024)),
    CONSTRAINT oauth_clients_client_uri_length CHECK ((char_length(client_uri) <= 2048)),
    CONSTRAINT oauth_clients_logo_uri_length CHECK ((char_length(logo_uri) <= 2048)),
    CONSTRAINT oauth_clients_token_endpoint_auth_method_check CHECK ((token_endpoint_auth_method = ANY (ARRAY['client_secret_basic'::text, 'client_secret_post'::text, 'none'::text])))
);


ALTER TABLE auth.oauth_clients OWNER TO supabase_auth_admin;

--
-- Name: oauth_consents; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_consents (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    client_id uuid NOT NULL,
    scopes text NOT NULL,
    granted_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_at timestamp with time zone,
    CONSTRAINT oauth_consents_revoked_after_granted CHECK (((revoked_at IS NULL) OR (revoked_at >= granted_at))),
    CONSTRAINT oauth_consents_scopes_length CHECK ((char_length(scopes) <= 2048)),
    CONSTRAINT oauth_consents_scopes_not_empty CHECK ((char_length(TRIM(BOTH FROM scopes)) > 0))
);


ALTER TABLE auth.oauth_consents OWNER TO supabase_auth_admin;

--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


ALTER TABLE auth.one_time_tokens OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


ALTER TABLE auth.refresh_tokens OWNER TO supabase_auth_admin;

--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: supabase_auth_admin
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE auth.refresh_tokens_id_seq OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: supabase_auth_admin
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


ALTER TABLE auth.saml_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


ALTER TABLE auth.saml_relay_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO supabase_auth_admin;

--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text,
    oauth_client_id uuid,
    refresh_token_hmac_key text,
    refresh_token_counter bigint,
    scopes text,
    CONSTRAINT sessions_scopes_length CHECK ((char_length(scopes) <= 4096))
);


ALTER TABLE auth.sessions OWNER TO supabase_auth_admin;

--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: COLUMN sessions.refresh_token_hmac_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.refresh_token_hmac_key IS 'Holds a HMAC-SHA256 key used to sign refresh tokens for this session.';


--
-- Name: COLUMN sessions.refresh_token_counter; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.refresh_token_counter IS 'Holds the ID (counter) of the last issued refresh token.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


ALTER TABLE auth.sso_domains OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    disabled boolean,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


ALTER TABLE auth.sso_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


ALTER TABLE auth.users OWNER TO supabase_auth_admin;

--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: webauthn_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.webauthn_challenges (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    challenge_type text NOT NULL,
    session_data jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    CONSTRAINT webauthn_challenges_challenge_type_check CHECK ((challenge_type = ANY (ARRAY['signup'::text, 'registration'::text, 'authentication'::text])))
);


ALTER TABLE auth.webauthn_challenges OWNER TO supabase_auth_admin;

--
-- Name: webauthn_credentials; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.webauthn_credentials (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    credential_id bytea NOT NULL,
    public_key bytea NOT NULL,
    attestation_type text DEFAULT ''::text NOT NULL,
    aaguid uuid,
    sign_count bigint DEFAULT 0 NOT NULL,
    transports jsonb DEFAULT '[]'::jsonb NOT NULL,
    backup_eligible boolean DEFAULT false NOT NULL,
    backed_up boolean DEFAULT false NOT NULL,
    friendly_name text DEFAULT ''::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    last_used_at timestamp with time zone
);


ALTER TABLE auth.webauthn_credentials OWNER TO supabase_auth_admin;

--
-- Name: feedback; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.feedback (
    id bigint NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    feedback_type text NOT NULL,
    subject text NOT NULL,
    description text NOT NULL,
    contact text,
    email text,
    allow_contact boolean DEFAULT false NOT NULL
);


ALTER TABLE public.feedback OWNER TO postgres;

--
-- Name: feedback_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.feedback ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.feedback_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: food; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.food (
    food_id bigint NOT NULL,
    user_id uuid NOT NULL,
    description text NOT NULL,
    protein numeric(8,2) DEFAULT 0 NOT NULL,
    fat numeric(8,2) DEFAULT 0 NOT NULL,
    carb numeric(8,2) DEFAULT 0 NOT NULL,
    calories_extra numeric(8,2) DEFAULT 0 NOT NULL,
    my_food boolean DEFAULT true NOT NULL,
    favorite_food boolean DEFAULT false NOT NULL,
    share_with_others boolean DEFAULT false NOT NULL,
    serving_size numeric(8,2) DEFAULT 1 NOT NULL,
    serving_unit public.food_serving_unit DEFAULT 'serving'::public.food_serving_unit NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT food_calories_extra_check CHECK ((calories_extra >= (0)::numeric)),
    CONSTRAINT food_carb_check CHECK ((carb >= (0)::numeric)),
    CONSTRAINT food_fat_check CHECK ((fat >= (0)::numeric)),
    CONSTRAINT food_protein_check CHECK ((protein >= (0)::numeric)),
    CONSTRAINT food_serving_size_check CHECK ((serving_size > (0)::numeric))
);


ALTER TABLE public.food OWNER TO postgres;

--
-- Name: food_food_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.food ALTER COLUMN food_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.food_food_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: food_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.food_log (
    food_log_id bigint NOT NULL,
    food_id bigint NOT NULL,
    user_id uuid NOT NULL,
    servings numeric(8,2) DEFAULT 1 NOT NULL,
    datetime timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT food_log_servings_check1 CHECK ((servings > (0)::numeric))
);


ALTER TABLE public.food_log OWNER TO postgres;

--
-- Name: food_log_bak; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.food_log_bak (
    food_log_id bigint NOT NULL,
    food_id bigint NOT NULL,
    user_id uuid NOT NULL,
    servings numeric(8,2) DEFAULT 1 NOT NULL,
    datetime timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT food_log_servings_check CHECK ((servings > (0)::numeric))
);


ALTER TABLE public.food_log_bak OWNER TO postgres;

--
-- Name: food_log_food_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.food_log_bak ALTER COLUMN food_log_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.food_log_food_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: food_log_food_log_id_seq1; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.food_log ALTER COLUMN food_log_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.food_log_food_log_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: profile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.profile (
    profile_id bigint NOT NULL,
    user_id uuid NOT NULL,
    start_weight numeric(6,2),
    goal_weight numeric(6,2),
    height numeric(6,2),
    activity_level public.activity_level,
    daily_calorie_deficit integer DEFAULT 0 NOT NULL,
    diet_type public.diet_type,
    sunday_protein numeric(5,2),
    sunday_carbs numeric(5,2),
    sunday_fat numeric(5,2),
    monday_protein numeric(5,2),
    monday_carbs numeric(5,2),
    monday_fat numeric(5,2),
    tuesday_protein numeric(5,2),
    tuesday_carbs numeric(5,2),
    tuesday_fat numeric(5,2),
    wednesday_protein numeric(5,2),
    wednesday_carbs numeric(5,2),
    wednesday_fat numeric(5,2),
    thursday_protein numeric(5,2),
    thursday_carbs numeric(5,2),
    thursday_fat numeric(5,2),
    friday_protein numeric(5,2),
    friday_carbs numeric(5,2),
    friday_fat numeric(5,2),
    saturday_protein numeric(5,2),
    saturday_carbs numeric(5,2),
    saturday_fat numeric(5,2),
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT profile_daily_calorie_deficit_check CHECK ((daily_calorie_deficit >= 0)),
    CONSTRAINT profile_friday_carbs_check CHECK (((friday_carbs >= (0)::numeric) AND (friday_carbs <= (100)::numeric))),
    CONSTRAINT profile_friday_fat_check CHECK (((friday_fat >= (0)::numeric) AND (friday_fat <= (100)::numeric))),
    CONSTRAINT profile_friday_protein_check CHECK (((friday_protein >= (0)::numeric) AND (friday_protein <= (100)::numeric))),
    CONSTRAINT profile_goal_weight_check CHECK ((goal_weight >= (0)::numeric)),
    CONSTRAINT profile_height_check CHECK ((height >= (0)::numeric)),
    CONSTRAINT profile_monday_carbs_check CHECK (((monday_carbs >= (0)::numeric) AND (monday_carbs <= (100)::numeric))),
    CONSTRAINT profile_monday_fat_check CHECK (((monday_fat >= (0)::numeric) AND (monday_fat <= (100)::numeric))),
    CONSTRAINT profile_monday_protein_check CHECK (((monday_protein >= (0)::numeric) AND (monday_protein <= (100)::numeric))),
    CONSTRAINT profile_saturday_carbs_check CHECK (((saturday_carbs >= (0)::numeric) AND (saturday_carbs <= (100)::numeric))),
    CONSTRAINT profile_saturday_fat_check CHECK (((saturday_fat >= (0)::numeric) AND (saturday_fat <= (100)::numeric))),
    CONSTRAINT profile_saturday_protein_check CHECK (((saturday_protein >= (0)::numeric) AND (saturday_protein <= (100)::numeric))),
    CONSTRAINT profile_start_weight_check CHECK ((start_weight >= (0)::numeric)),
    CONSTRAINT profile_sunday_carbs_check CHECK (((sunday_carbs >= (0)::numeric) AND (sunday_carbs <= (100)::numeric))),
    CONSTRAINT profile_sunday_fat_check CHECK (((sunday_fat >= (0)::numeric) AND (sunday_fat <= (100)::numeric))),
    CONSTRAINT profile_sunday_protein_check CHECK (((sunday_protein >= (0)::numeric) AND (sunday_protein <= (100)::numeric))),
    CONSTRAINT profile_thursday_carbs_check CHECK (((thursday_carbs >= (0)::numeric) AND (thursday_carbs <= (100)::numeric))),
    CONSTRAINT profile_thursday_fat_check CHECK (((thursday_fat >= (0)::numeric) AND (thursday_fat <= (100)::numeric))),
    CONSTRAINT profile_thursday_protein_check CHECK (((thursday_protein >= (0)::numeric) AND (thursday_protein <= (100)::numeric))),
    CONSTRAINT profile_tuesday_carbs_check CHECK (((tuesday_carbs >= (0)::numeric) AND (tuesday_carbs <= (100)::numeric))),
    CONSTRAINT profile_tuesday_fat_check CHECK (((tuesday_fat >= (0)::numeric) AND (tuesday_fat <= (100)::numeric))),
    CONSTRAINT profile_tuesday_protein_check CHECK (((tuesday_protein >= (0)::numeric) AND (tuesday_protein <= (100)::numeric))),
    CONSTRAINT profile_wednesday_carbs_check CHECK (((wednesday_carbs >= (0)::numeric) AND (wednesday_carbs <= (100)::numeric))),
    CONSTRAINT profile_wednesday_fat_check CHECK (((wednesday_fat >= (0)::numeric) AND (wednesday_fat <= (100)::numeric))),
    CONSTRAINT profile_wednesday_protein_check CHECK (((wednesday_protein >= (0)::numeric) AND (wednesday_protein <= (100)::numeric)))
);


ALTER TABLE public.profile OWNER TO postgres;

--
-- Name: profile_profile_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.profile ALTER COLUMN profile_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.profile_profile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: supplement; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.supplement (
    supplement_id bigint NOT NULL,
    user_id uuid NOT NULL,
    description text NOT NULL,
    serving_size numeric(8,2) DEFAULT 1 NOT NULL,
    serving_unit public.supplement_serving_unit DEFAULT 'other'::public.supplement_serving_unit NOT NULL,
    share_with_others boolean DEFAULT false NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT supplement_serving_size_check CHECK ((serving_size > (0)::numeric))
);


ALTER TABLE public.supplement OWNER TO postgres;

--
-- Name: supplement_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.supplement_log (
    supplement_log_id bigint NOT NULL,
    supplement_id bigint NOT NULL,
    user_id uuid NOT NULL,
    servings numeric(8,2) DEFAULT 1 NOT NULL,
    date date DEFAULT CURRENT_DATE NOT NULL,
    CONSTRAINT supplement_log_servings_check CHECK ((servings > (0)::numeric))
);


ALTER TABLE public.supplement_log OWNER TO postgres;

--
-- Name: supplement_log_supplement_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.supplement_log ALTER COLUMN supplement_log_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.supplement_log_supplement_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: supplement_supplement_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.supplement ALTER COLUMN supplement_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.supplement_supplement_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id uuid DEFAULT gen_random_uuid() NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    fname text DEFAULT ''::text NOT NULL,
    lname text DEFAULT ''::text NOT NULL,
    sex text DEFAULT ''::text NOT NULL,
    age integer,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT users_age_check CHECK (((age IS NULL) OR (age >= 0)))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_logged_in; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users_logged_in (
    id bigint NOT NULL,
    users_email text NOT NULL,
    public_ip text NOT NULL,
    is_logged_in boolean DEFAULT true NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.users_logged_in OWNER TO postgres;

--
-- Name: users_logged_in_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.users_logged_in ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.users_logged_in_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: weight_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.weight_log (
    weight_log_id bigint NOT NULL,
    user_id uuid NOT NULL,
    weight numeric(8,2) NOT NULL,
    bmi numeric(5,2),
    date date DEFAULT CURRENT_DATE NOT NULL,
    CONSTRAINT weight_log_weight_check1 CHECK ((weight > (0)::numeric))
);


ALTER TABLE public.weight_log OWNER TO postgres;

--
-- Name: weight_log_bak; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.weight_log_bak (
    weight_log_id bigint NOT NULL,
    user_id uuid NOT NULL,
    weight numeric(8,2) NOT NULL,
    date date DEFAULT CURRENT_DATE NOT NULL,
    CONSTRAINT weight_log_weight_check CHECK ((weight > (0)::numeric))
);


ALTER TABLE public.weight_log_bak OWNER TO postgres;

--
-- Name: weight_log_weight_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.weight_log_bak ALTER COLUMN weight_log_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.weight_log_weight_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: weight_log_weight_log_id_seq1; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.weight_log ALTER COLUMN weight_log_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.weight_log_weight_log_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: workout; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workout (
    workout_id bigint NOT NULL,
    user_id uuid NOT NULL,
    type text NOT NULL,
    average_workout_time integer,
    calories_burned integer DEFAULT 0 NOT NULL,
    share_with_others boolean DEFAULT false NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT workout_average_workout_time_check CHECK (((average_workout_time IS NULL) OR (average_workout_time >= 0))),
    CONSTRAINT workout_calories_burned_check CHECK ((calories_burned >= 0))
);


ALTER TABLE public.workout OWNER TO postgres;

--
-- Name: workout_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workout_log (
    workout_log_id bigint NOT NULL,
    workout_id bigint NOT NULL,
    user_id uuid NOT NULL,
    workout_time integer,
    calories_burned integer DEFAULT 0 NOT NULL,
    date date DEFAULT CURRENT_DATE NOT NULL,
    CONSTRAINT workout_log_calories_burned_check CHECK ((calories_burned >= 0)),
    CONSTRAINT workout_log_workout_time_check CHECK (((workout_time IS NULL) OR (workout_time >= 0)))
);


ALTER TABLE public.workout_log OWNER TO postgres;

--
-- Name: workout_log_workout_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.workout_log ALTER COLUMN workout_log_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.workout_log_workout_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: workout_workout_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.workout ALTER COLUMN workout_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.workout_workout_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    binary_payload bytea,
    skip_broadcast boolean DEFAULT false NOT NULL
)
PARTITION BY RANGE (inserted_at);


ALTER TABLE realtime.messages OWNER TO supabase_realtime_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone DEFAULT now()
);


ALTER TABLE realtime.schema_migrations OWNER TO supabase_admin;

--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    action_filter text DEFAULT '*'::text,
    selected_columns text[],
    CONSTRAINT subscription_action_filter_check CHECK ((action_filter = ANY (ARRAY['*'::text, 'INSERT'::text, 'UPDATE'::text, 'DELETE'::text])))
);


ALTER TABLE realtime.subscription OWNER TO supabase_realtime_admin;

--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text,
    type storage.buckettype DEFAULT 'STANDARD'::storage.buckettype NOT NULL,
    versioning_status text DEFAULT 'DISABLED'::text NOT NULL,
    CONSTRAINT buckets_versioning_dark_check CHECK ((versioning_status = 'DISABLED'::text)),
    CONSTRAINT buckets_versioning_standard_only_check CHECK (((type = 'STANDARD'::storage.buckettype) OR (versioning_status = 'DISABLED'::text))),
    CONSTRAINT buckets_versioning_status_check CHECK ((versioning_status = ANY (ARRAY['DISABLED'::text, 'ENABLED'::text, 'SUSPENDED'::text])))
);


ALTER TABLE storage.buckets OWNER TO supabase_storage_admin;

--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: buckets_analytics; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets_analytics (
    name text NOT NULL,
    type storage.buckettype DEFAULT 'ANALYTICS'::storage.buckettype NOT NULL,
    format text DEFAULT 'ICEBERG'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE storage.buckets_analytics OWNER TO supabase_storage_admin;

--
-- Name: buckets_vectors; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets_vectors (
    id text NOT NULL,
    type storage.buckettype DEFAULT 'VECTOR'::storage.buckettype NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.buckets_vectors OWNER TO supabase_storage_admin;

--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE storage.migrations OWNER TO supabase_storage_admin;

--
-- Name: objects; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb,
    archived_at timestamp with time zone,
    is_delete_marker boolean DEFAULT false NOT NULL,
    is_versioned boolean DEFAULT false NOT NULL
);


ALTER TABLE storage.objects OWNER TO supabase_storage_admin;

--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb,
    metadata jsonb
);


ALTER TABLE storage.s3_multipart_uploads OWNER TO supabase_storage_admin;

--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.s3_multipart_uploads_parts OWNER TO supabase_storage_admin;

--
-- Name: vector_indexes; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.vector_indexes (
    id text DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    bucket_id text NOT NULL,
    data_type text NOT NULL,
    dimension integer NOT NULL,
    distance_metric text NOT NULL,
    metadata_configuration jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.vector_indexes OWNER TO supabase_storage_admin;

--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
\.


--
-- Data for Name: custom_oauth_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.custom_oauth_providers (id, provider_type, identifier, name, client_id, client_secret, acceptable_client_ids, scopes, pkce_enabled, attribute_mapping, authorization_params, enabled, email_optional, issuer, discovery_url, skip_nonce_check, cached_discovery, discovery_cached_at, authorization_url, token_url, userinfo_url, jwks_uri, created_at, updated_at, custom_claims_allowlist) FROM stdin;
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at, invite_token, referrer, oauth_client_state_id, linking_target_id, email_optional) FROM stdin;
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid, last_webauthn_challenge_data) FROM stdin;
\.


--
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_authorizations (id, authorization_id, client_id, user_id, redirect_uri, scope, state, resource, code_challenge, code_challenge_method, response_type, status, authorization_code, created_at, expires_at, approved_at, nonce) FROM stdin;
\.


--
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_client_states (id, provider_type, code_verifier, created_at) FROM stdin;
\.


--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_clients (id, client_secret_hash, registration_type, redirect_uris, grant_types, client_name, client_uri, logo_uri, created_at, updated_at, deleted_at, client_type, token_endpoint_auth_method) FROM stdin;
\.


--
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_consents (id, user_id, client_id, scopes, granted_at, revoked_at) FROM stdin;
\.


--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
20250717082212
20250731150234
20250804100000
20250901200500
20250903112500
20250904133000
20250925093508
20251007112900
20251104100000
20251111201300
20251201000000
20260115000000
20260121000000
20260219120000
20260302000000
20260625000000
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag, oauth_client_id, refresh_token_hmac_key, refresh_token_counter, scopes) FROM stdin;
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at, disabled) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
\.


--
-- Data for Name: webauthn_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.webauthn_challenges (id, user_id, challenge_type, session_data, created_at, expires_at) FROM stdin;
\.


--
-- Data for Name: webauthn_credentials; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.webauthn_credentials (id, user_id, credential_id, public_key, attestation_type, aaguid, sign_count, transports, backup_eligible, backed_up, friendly_name, created_at, updated_at, last_used_at) FROM stdin;
\.


--
-- Data for Name: feedback; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.feedback (id, user_id, created_at, feedback_type, subject, description, contact, email, allow_contact) FROM stdin;
\.


--
-- Data for Name: food; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.food (food_id, user_id, description, protein, fat, carb, calories_extra, my_food, favorite_food, share_with_others, serving_size, serving_unit, is_active, created_at) FROM stdin;
7	7dd73c91-5396-440d-9304-3bd3b8af14cd	Cheese Sticks	9.00	10.00	1.00	0.00	t	t	t	1.00	bar	t	2026-08-09 03:31:46.660335+00
4	843d549d-2a3e-4d06-b974-1c59db802208	Bread	1.00	1.00	25.00	0.00	t	f	f	1.00	slice	f	2026-08-08 20:48:19.784657+00
10	843d549d-2a3e-4d06-b974-1c59db802208	Bread (Chocolate Factory)	3.00	1.00	15.00	0.00	t	t	t	1.00	slice	t	2026-08-09 04:58:07.860698+00
22	843d549d-2a3e-4d06-b974-1c59db802208	Dark Chocolate	2.20	12.00	13.00	0.00	t	f	f	1.00	oz	t	2026-08-10 20:32:37.950954+00
31	843d549d-2a3e-4d06-b974-1c59db802208	Pork Rigns	0.00	10.00	0.00	0.00	t	f	t	1.00	oz	f	2026-08-12 05:06:04.618217+00
36	843d549d-2a3e-4d06-b974-1c59db802208	Bone broth	9.00	0.50	0.00	0.00	t	f	f	1.00	cup	t	2026-08-14 00:14:15.057537+00
42	843d549d-2a3e-4d06-b974-1c59db802208	Beef Jerky (Old Trapper)	11.00	0.50	6.00	0.00	t	f	f	1.00	oz	t	2026-08-15 06:50:35.021171+00
2	843d549d-2a3e-4d06-b974-1c59db802208	Brownies	50.00	10.00	0.00	0.00	t	f	f	1.00	serving	f	2026-08-08 20:24:52.33103+00
1	843d549d-2a3e-4d06-b974-1c59db802208	Tuda	50.00	10.00	0.00	0.00	t	f	f	1.00	serving	f	2026-08-08 20:08:08.486064+00
5	843d549d-2a3e-4d06-b974-1c59db802208	Tuna	9.00	10.00	22.00	0.00	t	f	f	1.00	serving	f	2026-08-08 22:10:25.905967+00
6	843d549d-2a3e-4d06-b974-1c59db802208	Tuna2	9.00	10.00	22.00	0.00	t	f	f	1.00	serving	f	2026-08-09 00:50:00.188374+00
8	95f81fb6-468d-49a5-bcbc-bd0d588abcfd	Milk, Blue Berries, and Cinamin	8.40	8.20	20.00	0.00	t	t	t	1.00	serving	t	2026-08-09 04:33:28.495556+00
9	843d549d-2a3e-4d06-b974-1c59db802208	Sardined (Wild Caught)	18.00	11.00	0.00	0.00	t	t	t	1.00	serving	t	2026-08-09 04:56:14.562382+00
3	843d549d-2a3e-4d06-b974-1c59db802208	Tuna	50.00	10.00	0.00	0.00	t	f	t	1.00	serving	f	2026-08-08 20:29:53.776383+00
11	843d549d-2a3e-4d06-b974-1c59db802208	Tortillas (Mission)	4.00	3.00	24.00	0.00	t	t	t	1.00	serving	t	2026-08-09 05:00:45.044936+00
14	843d549d-2a3e-4d06-b974-1c59db802208	Coffee w/ whole milk  (3 oz)	1.50	3.00	3.00	0.00	t	t	f	1.00	serving	t	2026-08-09 18:46:35.399704+00
17	6e0f0843-47e4-482a-92d5-f1b436bce1c7	QA Apple	0.00	0.00	0.00	0.00	t	f	f	1.00	serving	t	2026-08-10 00:51:04.650128+00
26	843d549d-2a3e-4d06-b974-1c59db802208	Yogurt - Oikos	17.00	0.00	7.00	0.00	t	f	f	1.00	serving	t	2026-08-11 15:15:48.599705+00
27	843d549d-2a3e-4d06-b974-1c59db802208	Tuna Albacore (WIld Planet)	33.00	5.00	0.00	0.00	t	f	f	1.00	serving	t	2026-08-11 15:18:59.333521+00
13	843d549d-2a3e-4d06-b974-1c59db802208	Butter (1/2 tab)	0.05	6.00	0.00	0.00	t	t	f	7.00	gram	t	2026-08-09 18:42:27.772761+00
33	843d549d-2a3e-4d06-b974-1c59db802208	Mayo	0.10	10.00	0.80	0.00	t	f	f	14.00	gram	t	2026-08-12 18:27:46.631484+00
37	843d549d-2a3e-4d06-b974-1c59db802208	Prok Rhines	8.00	4.50	0.00	0.00	t	f	f	14.00	gram	t	2026-08-14 00:26:46.472165+00
41	843d549d-2a3e-4d06-b974-1c59db802208	Spagetti + olive oil	14.00	12.00	82.00	0.00	t	f	f	100.00	gram	t	2026-08-15 05:07:08.36889+00
43	843d549d-2a3e-4d06-b974-1c59db802208	Coconut Water	0.00	0.00	13.00	0.00	t	f	f	11.10	oz	t	2026-08-15 20:19:00.373484+00
57	843d549d-2a3e-4d06-b974-1c59db802208	Peanut Butter Cup (Skinny Dipped)	2.00	6.00	6.00	0.00	t	f	f	1.00	piece	t	2026-08-26 00:29:50.334755+00
40	843d549d-2a3e-4d06-b974-1c59db802208	Berries (Three Berry Frozen)	2.00	0.00	16.00	0.00	t	f	f	1.00	cup	t	2026-08-14 21:42:22.608618+00
23	843d549d-2a3e-4d06-b974-1c59db802208	Black Beans	7.00	0.40	19.25	0.00	t	f	f	0.25	can	t	2026-08-10 20:48:39.15192+00
58	843d549d-2a3e-4d06-b974-1c59db802208	RX Bar	12.00	8.00	23.00	0.00	t	f	f	1.00	bar	t	2026-08-26 18:00:49.352737+00
28	843d549d-2a3e-4d06-b974-1c59db802208	Yams	2.25	2.25	31.40	0.00	t	f	f	4.00	oz	t	2026-08-11 15:22:59.733853+00
30	843d549d-2a3e-4d06-b974-1c59db802208	Prunes	1.00	0.00	24.00	0.00	t	f	f	4.00	piece	t	2026-08-12 00:20:33.60669+00
15	843d549d-2a3e-4d06-b974-1c59db802208	Macadamia Nuts	1.10	10.75	1.95	0.00	t	t	f	6.00	count	t	2026-08-09 21:00:43.421676+00
24	843d549d-2a3e-4d06-b974-1c59db802208	Cottage Cheese	13.00	3.00	5.00	0.00	t	f	f	4.00	oz	t	2026-08-10 23:04:10.156105+00
19	843d549d-2a3e-4d06-b974-1c59db802208	Avacado (1/2 medium)	2.00	14.70	8.50	0.00	t	t	f	0.50	serving	t	2026-08-10 04:36:13.587917+00
20	843d549d-2a3e-4d06-b974-1c59db802208	Pepper Jack Cheese	7.00	9.00	0.50	0.00	t	f	f	1.00	oz	t	2026-08-10 04:39:29.271025+00
21	843d549d-2a3e-4d06-b974-1c59db802208	Parmesan Cheese	10.00	7.50	1.00	0.00	t	f	f	1.00	oz	t	2026-08-10 06:19:44.335181+00
18	843d549d-2a3e-4d06-b974-1c59db802208	hamburger	29.00	20.00	0.00	0.00	t	f	f	4.00	oz	t	2026-08-10 04:34:08.876996+00
25	843d549d-2a3e-4d06-b974-1c59db802208	Ribeye	18.00	11.00	0.00	0.00	t	f	f	3.00	oz	t	2026-08-11 02:33:06.17515+00
39	843d549d-2a3e-4d06-b974-1c59db802208	Honey	0.00	0.00	17.00	0.00	t	f	f	1.00	tsp	t	2026-08-14 16:31:29.409779+00
34	843d549d-2a3e-4d06-b974-1c59db802208	Zuchkini (medium)	6.00	1.00	2.00	0.00	t	f	f	1.00	item	t	2026-08-14 00:03:05.416181+00
64	843d549d-2a3e-4d06-b974-1c59db802208	Mayonnaise	0.00	11.50	0.50	0.00	t	f	f	1.00	tbsp	t	2026-08-31 20:45:23.720355+00
12	843d549d-2a3e-4d06-b974-1c59db802208	Eggs (two fried)	12.50	13.00	1.00	0.00	t	t	t	1.00	serving	t	2026-08-09 05:08:19.893974+00
38	843d549d-2a3e-4d06-b974-1c59db802208	Mango	2.00	1.00	50.00	0.00	t	f	f	1.00	serving	t	2026-08-14 01:57:47.860231+00
44	e6430d4a-90fa-437d-9cae-37ca063933dc	Noodle	3.00	1.00	45.00	0.00	t	f	f	1.00	serving	t	2026-08-16 18:04:25.816212+00
45	e6430d4a-90fa-437d-9cae-37ca063933dc	Korean BBQ snack bytes	10.00	3.00	13.00	0.00	t	f	f	1.00	serving	t	2026-08-16 18:09:46.931965+00
32	843d549d-2a3e-4d06-b974-1c59db802208	Hot Dog bun	4.00	1.50	23.00	0.00	t	f	f	1.00	serving	t	2026-08-12 18:24:43.03203+00
47	843d549d-2a3e-4d06-b974-1c59db802208	Squash	1.00	0.50	10.00	0.00	t	f	f	1.00	cup	t	2026-08-17 03:22:58.473776+00
48	843d549d-2a3e-4d06-b974-1c59db802208	Mozzerella Cheese	6.00	6.00	1.00	0.00	t	f	f	1.00	oz	t	2026-08-17 20:30:37.315651+00
59	843d549d-2a3e-4d06-b974-1c59db802208	Oysters (Chicken of the Sea)	18.00	2.50	4.00	0.00	t	f	f	1.00	can	t	2026-08-27 15:31:13.983028+00
49	843d549d-2a3e-4d06-b974-1c59db802208	Pizza Pepperoni (Costco)	34.00	24.00	75.00	0.00	t	f	f	1.00	slice	t	2026-08-19 03:22:17.207375+00
50	843d549d-2a3e-4d06-b974-1c59db802208	Ham	23.90	6.90	1.14	0.00	t	f	f	4.00	oz	t	2026-08-19 19:36:00.952949+00
51	843d549d-2a3e-4d06-b974-1c59db802208	Beef Jerky (world Kitchens)	9.00	2.00	7.00	0.00	t	f	f	1.00	oz	t	2026-08-20 19:14:38.863256+00
52	843d549d-2a3e-4d06-b974-1c59db802208	Meatballs (3)	19.00	15.00	9.00	0.00	t	f	f	85.00	gram	t	2026-08-21 04:14:13.930453+00
53	843d549d-2a3e-4d06-b974-1c59db802208	White Bread	4.50	1.50	27.00	0.00	t	f	f	1.00	slice	t	2026-08-21 04:16:22.900788+00
54	843d549d-2a3e-4d06-b974-1c59db802208	Fish Oil 2g, Krill 0.5g	0.00	2.50	0.00	0.00	t	f	f	1.00	serving	t	2026-08-21 20:21:01.169307+00
46	843d549d-2a3e-4d06-b974-1c59db802208	Chicken Thigh (Boneless, skinless)	22.00	4.50	0.00	0.00	t	f	f	4.00	oz	t	2026-08-16 21:04:37.443646+00
55	843d549d-2a3e-4d06-b974-1c59db802208	Cake (Costco Tuxedo)	3.00	9.00	28.00	0.00	t	f	f	1.00	slice	t	2026-08-22 20:02:51.416846+00
56	843d549d-2a3e-4d06-b974-1c59db802208	Watermelon	11.50	0.20	0.90	0.00	t	f	f	1.00	cup	t	2026-08-23 00:31:24.959344+00
60	843d549d-2a3e-4d06-b974-1c59db802208	Shrimp	27.00	0.32	0.23	0.00	t	f	f	4.00	oz	t	2026-08-28 03:20:05.211425+00
16	843d549d-2a3e-4d06-b974-1c59db802208	Protein Drink (Ascent)	25.00	1.00	2.00	0.00	t	f	f	1.00	scoop	t	2026-08-10 00:00:59.255242+00
29	843d549d-2a3e-4d06-b974-1c59db802208	Protein - Mussel Milk	33.00	1.50	11.00	0.00	t	f	f	1.00	can	t	2026-08-11 15:32:31.853275+00
61	843d549d-2a3e-4d06-b974-1c59db802208	Chicken Breast	35.00	4.00	0.00	0.00	t	f	f	4.00	oz	t	2026-08-29 23:38:46.974623+00
62	843d549d-2a3e-4d06-b974-1c59db802208	Spagetti Noodles	6.50	1.00	35.00	0.00	t	f	f	4.00	oz	t	2026-08-29 23:56:36.514193+00
63	843d549d-2a3e-4d06-b974-1c59db802208	Spagetti Sauce (Victoria)	1.00	2.00	5.00	0.00	t	f	f	4.00	oz	t	2026-08-29 23:58:59.499417+00
35	843d549d-2a3e-4d06-b974-1c59db802208	Rice (raw)	3.75	0.55	43.00	0.00	t	f	f	0.25	cup	t	2026-08-14 00:11:12.552495+00
65	843d549d-2a3e-4d06-b974-1c59db802208	Chicken Breast	5.00	6.00	5.00	0.00	t	f	f	1.00	item	f	2026-09-03 06:09:18.19642+00
66	843d549d-2a3e-4d06-b974-1c59db802208	AAAA	4.00	4.00	4.00	4.00	t	f	f	1.00	oz	f	2026-09-03 06:13:06.891066+00
67	843d549d-2a3e-4d06-b974-1c59db802208	sdadsadsadsa	0.00	0.00	0.00	0.00	t	f	f	1.00	oz	f	2026-09-03 06:31:07.972841+00
68	843d549d-2a3e-4d06-b974-1c59db802208	22222	0.00	0.00	0.00	0.00	t	f	f	1.00	oz	f	2026-09-03 06:51:52.553678+00
69	843d549d-2a3e-4d06-b974-1c59db802208	ddsdssd	0.00	0.00	0.00	0.00	t	f	f	1.00	piece	f	2026-09-03 07:02:58.37203+00
70	843d549d-2a3e-4d06-b974-1c59db802208	dffdsfdfsd	0.00	0.00	0.00	0.00	t	f	f	1.00	oz	f	2026-09-03 07:10:59.114474+00
71	843d549d-2a3e-4d06-b974-1c59db802208	sdffdsdfsdf	0.00	0.00	0.00	0.00	t	f	f	1.00	oz	f	2026-09-03 07:11:41.823325+00
72	843d549d-2a3e-4d06-b974-1c59db802208	dfsfdssfdfds	0.00	0.00	0.00	0.00	t	f	f	1.00	oz	f	2026-09-03 07:12:53.865099+00
73	843d549d-2a3e-4d06-b974-1c59db802208	aaaaxccxzcxcxz	0.00	0.00	0.00	0.00	t	f	f	1.00	serving	f	2026-09-03 07:16:31.642655+00
74	843d549d-2a3e-4d06-b974-1c59db802208	asdasdssd	4.00	4.00	4.00	4.00	t	f	f	1.00	serving	f	2026-09-03 07:16:49.332843+00
75	843d549d-2a3e-4d06-b974-1c59db802208	ddfdfsdfs	0.00	0.00	0.00	0.00	t	f	f	1.00	serving	f	2026-09-03 07:19:43.411293+00
76	843d549d-2a3e-4d06-b974-1c59db802208	Chuck Roast	27.00	21.00	0.00	0.00	t	f	f	4.00	oz	t	2026-09-05 03:05:39.323753+00
77	843d549d-2a3e-4d06-b974-1c59db802208	Suchi California Roll	9.00	7.50	40.00	0.00	t	f	f	6.00	pinch	t	2026-09-05 03:10:19.955426+00
78	843d549d-2a3e-4d06-b974-1c59db802208	Corn Bread	4.00	4.00	24.00	0.00	t	f	f	2.00	oz	t	2026-09-06 00:35:02.132558+00
79	843d549d-2a3e-4d06-b974-1c59db802208	Potatoes	2.25	2.00	23.00	0.00	t	f	f	4.00	oz	t	2026-09-07 18:41:15.447003+00
80	843d549d-2a3e-4d06-b974-1c59db802208	Red Wine (Cab.)	0.00	0.00	4.00	105.00	t	f	f	5.00	oz	t	2026-09-07 18:50:32.556725+00
81	843d549d-2a3e-4d06-b974-1c59db802208	Cookie (Pumpkin)	1.00	6.00	21.00	0.00	t	f	f	1.00	serving	t	2026-09-07 18:54:46.049422+00
82	843d549d-2a3e-4d06-b974-1c59db802208	Ketchup	0.20	0.00	4.20	0.00	t	f	f	1.00	tbsp	t	2026-09-07 22:34:54.714226+00
\.


--
-- Data for Name: food_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.food_log (food_log_id, food_id, user_id, servings, datetime) FROM stdin;
417	13	843d549d-2a3e-4d06-b974-1c59db802208	0.50	2026-09-04 17:42:00+00
419	76	843d549d-2a3e-4d06-b974-1c59db802208	2.00	2026-09-05 03:06:00+00
421	14	843d549d-2a3e-4d06-b974-1c59db802208	2.00	2026-09-05 17:00:00+00
427	16	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-05 17:30:00+00
429	16	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-05 20:18:00+00
431	43	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-06 00:17:00+00
433	76	843d549d-2a3e-4d06-b974-1c59db802208	0.62	2026-09-06 00:18:00+00
435	78	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-06 00:35:00+00
437	14	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-06 16:05:00+00
439	9	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-07 18:30:00+00
441	14	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-06 18:32:00+00
443	13	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-06 18:33:00+00
445	10	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-06 18:34:00+00
447	25	843d549d-2a3e-4d06-b974-1c59db802208	2.67	2026-09-06 18:35:00+00
449	35	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-06 18:43:00+00
453	81	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-06 18:55:00+00
455	14	843d549d-2a3e-4d06-b974-1c59db802208	2.00	2026-09-07 19:01:00+00
457	10	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-07 22:18:00+00
459	82	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-07 22:35:00+00
461	10	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-08 01:41:00+00
463	14	843d549d-2a3e-4d06-b974-1c59db802208	1.01	2026-09-08 15:02:00+00
465	10	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-08 15:59:00+00
467	14	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-08 17:28:00+00
469	16	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-08 18:34:00+00
471	34	843d549d-2a3e-4d06-b974-1c59db802208	3.00	2026-09-08 22:31:00+00
44	22	843d549d-2a3e-4d06-b974-1c59db802208	0.20	2026-08-10 20:32:00+00
45	15	843d549d-2a3e-4d06-b974-1c59db802208	0.20	2026-08-10 20:33:00+00
46	18	843d549d-2a3e-4d06-b974-1c59db802208	0.87	2026-08-10 20:44:00+00
47	7	7dd73c91-5396-440d-9304-3bd3b8af14cd	1.00	2026-08-09 03:33:00+00
48	8	95f81fb6-468d-49a5-bcbc-bd0d588abcfd	1.00	2026-08-09 04:33:00+00
49	23	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-10 20:48:00+00
50	23	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-09 20:48:00+00
51	16	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-10 20:49:00+00
52	24	843d549d-2a3e-4d06-b974-1c59db802208	1.50	2026-08-10 23:04:00+00
53	24	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-10 23:04:00+00
54	25	843d549d-2a3e-4d06-b974-1c59db802208	2.00	2026-08-11 02:33:00+00
55	12	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-09 08:30:00+00
56	26	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-11 15:15:00+00
57	14	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-11 15:16:00+00
58	27	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-11 15:19:00+00
59	10	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-09 18:35:00+00
60	13	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-09 18:42:00+00
61	14	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-09 18:47:00+00
62	15	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-09 21:01:00+00
63	14	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-09 23:53:00+00
64	29	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-11 15:32:00+00
65	28	843d549d-2a3e-4d06-b974-1c59db802208	0.87	2026-08-11 20:10:00+00
66	11	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-11 20:11:00+00
67	25	843d549d-2a3e-4d06-b974-1c59db802208	1.07	2026-08-12 00:14:00+00
68	20	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-12 00:15:00+00
69	30	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-12 00:20:00+00
70	16	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-10 00:09:00+00
71	26	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-11 08:47:00+00
72	26	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-12 16:00:00+00
73	26	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-12 17:39:00+00
74	29	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-12 17:39:00+00
75	14	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-12 17:40:00+00
76	32	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-12 18:27:00+00
77	33	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-12 18:28:00+00
78	27	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-12 18:28:00+00
79	11	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-12 23:51:00+00
80	25	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-12 23:51:00+00
81	20	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-12 23:51:00+00
82	30	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-13 00:13:00+00
83	30	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-13 05:04:00+00
84	20	843d549d-2a3e-4d06-b974-1c59db802208	0.50	2026-08-13 05:06:00+00
85	17	6e0f0843-47e4-482a-92d5-f1b436bce1c7	1.00	2026-08-10 00:51:00+00
86	11	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-13 05:14:00+00
87	14	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-13 14:58:00+00
88	29	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-13 14:58:00+00
89	26	843d549d-2a3e-4d06-b974-1c59db802208	2.00	2026-08-13 14:59:00+00
90	9	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-13 14:59:00+00
91	34	843d549d-2a3e-4d06-b974-1c59db802208	0.25	2026-08-14 00:03:00+00
92	18	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-14 00:14:00+00
93	37	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-14 00:26:00+00
94	37	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-14 00:27:00+00
95	19	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-10 04:36:00+00
96	18	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-10 04:37:00+00
97	20	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-10 04:39:00+00
98	16	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-10 04:39:00+00
99	21	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-10 06:20:00+00
100	14	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-10 07:01:00+00
101	19	843d549d-2a3e-4d06-b974-1c59db802208	0.50	2026-08-10 16:19:00+00
102	16	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-10 16:28:00+00
103	14	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-10 16:33:00+00
104	10	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-10 18:17:00+00
105	12	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-10 18:17:00+00
106	23	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-14 00:37:00+00
107	9	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-10 18:40:00+00
108	19	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-14 04:37:00+00
109	37	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-14 04:38:00+00
110	14	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-14 15:55:00+00
111	39	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-14 16:31:00+00
112	18	843d549d-2a3e-4d06-b974-1c59db802208	1.33	2026-08-14 16:31:00+00
113	23	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-14 16:43:00+00
114	14	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-14 21:36:00+00
115	39	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-14 21:37:00+00
116	16	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-14 21:39:00+00
117	40	843d549d-2a3e-4d06-b974-1c59db802208	0.33	2026-08-14 21:44:00+00
118	12	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-14 22:19:00+00
119	10	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-14 22:20:00+00
120	30	843d549d-2a3e-4d06-b974-1c59db802208	1.50	2026-08-15 03:03:00+00
121	41	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-15 05:07:00+00
122	30	843d549d-2a3e-4d06-b974-1c59db802208	0.50	2026-08-15 06:48:00+00
123	42	843d549d-2a3e-4d06-b974-1c59db802208	5.00	2026-08-15 06:59:00+00
124	10	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-15 15:52:00+00
125	14	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-15 15:58:00+00
126	14	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-15 15:59:00+00
127	16	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-15 15:59:00+00
128	39	843d549d-2a3e-4d06-b974-1c59db802208	0.50	2026-08-15 16:56:00+00
129	43	843d549d-2a3e-4d06-b974-1c59db802208	1.20	2026-08-15 20:19:00+00
130	10	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-15 20:26:00+00
131	42	843d549d-2a3e-4d06-b974-1c59db802208	5.00	2026-08-15 20:28:00+00
132	28	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-15 23:05:00+00
133	28	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-15 23:52:00+00
134	18	843d549d-2a3e-4d06-b974-1c59db802208	1.33	2026-08-15 23:54:00+00
135	23	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-15 23:55:00+00
138	14	843d549d-2a3e-4d06-b974-1c59db802208	2.00	2026-08-16 16:32:00+00
140	44	e6430d4a-90fa-437d-9cae-37ca063933dc	1.00	2026-08-16 18:04:00+00
141	45	e6430d4a-90fa-437d-9cae-37ca063933dc	1.00	2026-08-16 18:10:00+00
142	12	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-16 19:09:00+00
143	10	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-16 19:10:00+00
144	13	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-16 19:10:00+00
145	21	843d549d-2a3e-4d06-b974-1c59db802208	0.50	2026-08-16 20:50:00+00
148	24	843d549d-2a3e-4d06-b974-1c59db802208	1.50	2026-08-16 22:58:00+00
149	46	843d549d-2a3e-4d06-b974-1c59db802208	3.33	2026-08-17 02:52:00+00
150	26	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-17 03:01:00+00
151	47	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-17 03:23:00+00
152	13	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-17 03:23:00+00
154	35	843d549d-2a3e-4d06-b974-1c59db802208	0.25	2026-08-17 04:19:00+00
155	14	843d549d-2a3e-4d06-b974-1c59db802208	2.00	2026-08-17 17:12:00+00
156	39	843d549d-2a3e-4d06-b974-1c59db802208	0.25	2026-08-17 17:12:00+00
157	12	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-17 17:42:00+00
158	21	843d549d-2a3e-4d06-b974-1c59db802208	0.50	2026-08-17 17:42:00+00
159	10	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-17 17:43:00+00
160	18	843d549d-2a3e-4d06-b974-1c59db802208	0.75	2026-08-17 17:43:00+00
161	23	843d549d-2a3e-4d06-b974-1c59db802208	0.75	2026-08-17 20:28:00+00
162	48	843d549d-2a3e-4d06-b974-1c59db802208	1.60	2026-08-17 20:30:00+00
163	37	843d549d-2a3e-4d06-b974-1c59db802208	2.00	2026-08-17 22:21:00+00
165	18	843d549d-2a3e-4d06-b974-1c59db802208	1.33	2026-08-17 22:23:00+00
166	23	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-17 22:23:00+00
167	48	843d549d-2a3e-4d06-b974-1c59db802208	0.80	2026-08-17 23:43:00+00
168	14	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-18 15:23:00+00
170	26	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-18 15:27:00+00
171	26	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-18 15:27:00+00
172	18	843d549d-2a3e-4d06-b974-1c59db802208	1.33	2026-08-18 15:27:00+00
173	23	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-18 15:27:00+00
174	24	843d549d-2a3e-4d06-b974-1c59db802208	1.50	2026-08-18 15:28:00+00
176	29	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-18 16:21:00+00
178	19	843d549d-2a3e-4d06-b974-1c59db802208	2.00	2026-08-19 02:21:00+00
179	49	843d549d-2a3e-4d06-b974-1c59db802208	0.50	2026-08-19 03:22:00+00
180	14	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-19 15:00:00+00
181	26	843d549d-2a3e-4d06-b974-1c59db802208	2.00	2026-08-19 15:01:00+00
182	27	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-19 17:50:00+00
183	32	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-19 17:51:00+00
184	33	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-19 17:51:00+00
185	32	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-19 18:07:00+00
186	50	843d549d-2a3e-4d06-b974-1c59db802208	0.50	2026-08-19 19:38:00+00
187	23	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-19 19:38:00+00
188	29	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-19 19:44:00+00
189	24	843d549d-2a3e-4d06-b974-1c59db802208	0.75	2026-08-19 23:45:00+00
190	9	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-20 02:57:00+00
191	30	843d549d-2a3e-4d06-b974-1c59db802208	0.50	2026-08-20 02:57:00+00
193	14	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-20 16:56:00+00
194	10	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-20 16:56:00+00
195	12	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-20 16:56:00+00
196	21	843d549d-2a3e-4d06-b974-1c59db802208	0.75	2026-08-20 16:56:00+00
197	13	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-20 16:57:00+00
198	51	843d549d-2a3e-4d06-b974-1c59db802208	3.00	2026-08-20 19:14:00+00
199	14	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-20 19:15:00+00
200	16	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-20 19:15:00+00
201	19	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-20 22:21:00+00
202	9	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-20 22:22:00+00
203	52	843d549d-2a3e-4d06-b974-1c59db802208	1.50	2026-08-21 04:16:00+00
204	53	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-21 04:17:00+00
205	13	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-21 04:17:00+00
206	14	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-21 15:46:00+00
207	39	843d549d-2a3e-4d06-b974-1c59db802208	0.50	2026-08-21 15:46:00+00
208	14	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-21 15:47:00+00
209	12	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-21 15:47:00+00
210	10	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-21 15:47:00+00
212	28	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-21 18:59:00+00
213	16	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-21 18:59:00+00
214	24	843d549d-2a3e-4d06-b974-1c59db802208	1.50	2026-08-21 19:01:00+00
215	40	843d549d-2a3e-4d06-b974-1c59db802208	0.33	2026-08-21 20:18:00+00
216	54	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-21 20:21:00+00
217	28	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-21 21:28:00+00
219	46	843d549d-2a3e-4d06-b974-1c59db802208	1.50	2026-08-22 00:05:00+00
221	14	843d549d-2a3e-4d06-b974-1c59db802208	2.00	2026-08-22 17:54:00+00
222	12	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-22 17:54:00+00
223	10	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-22 17:54:00+00
224	28	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-22 17:54:00+00
225	43	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-22 19:58:00+00
226	55	843d549d-2a3e-4d06-b974-1c59db802208	1.50	2026-08-22 20:03:00+00
227	46	843d549d-2a3e-4d06-b974-1c59db802208	1.50	2026-08-22 20:36:00+00
228	30	843d549d-2a3e-4d06-b974-1c59db802208	0.50	2026-08-23 00:28:00+00
230	56	843d549d-2a3e-4d06-b974-1c59db802208	2.00	2026-08-23 00:31:00+00
231	46	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-23 00:32:00+00
232	30	843d549d-2a3e-4d06-b974-1c59db802208	0.75	2026-08-23 00:32:00+00
233	16	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-23 00:33:00+00
234	14	843d549d-2a3e-4d06-b974-1c59db802208	2.00	2026-08-23 18:20:00+00
235	13	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-23 18:21:00+00
236	10	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-23 18:21:00+00
237	12	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-23 18:21:00+00
238	15	843d549d-2a3e-4d06-b974-1c59db802208	2.00	2026-08-23 18:21:00+00
239	54	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-23 18:25:00+00
240	48	843d549d-2a3e-4d06-b974-1c59db802208	2.60	2026-08-23 20:36:00+00
241	24	843d549d-2a3e-4d06-b974-1c59db802208	1.50	2026-08-23 20:37:00+00
242	16	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-23 20:38:00+00
243	18	843d549d-2a3e-4d06-b974-1c59db802208	1.25	2026-08-23 23:36:00+00
244	23	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-23 23:36:00+00
245	15	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-24 03:13:00+00
246	14	843d549d-2a3e-4d06-b974-1c59db802208	2.00	2026-08-24 18:28:00+00
247	12	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-24 18:28:00+00
248	10	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-24 18:29:00+00
249	21	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-24 18:29:00+00
250	18	843d549d-2a3e-4d06-b974-1c59db802208	1.33	2026-08-24 18:29:00+00
251	23	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-24 18:30:00+00
252	16	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-24 20:36:00+00
254	46	843d549d-2a3e-4d06-b974-1c59db802208	0.75	2026-08-25 00:40:00+00
256	26	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-25 00:41:00+00
257	27	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-25 17:23:00+00
258	26	843d549d-2a3e-4d06-b974-1c59db802208	2.00	2026-08-25 17:25:00+00
259	32	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-25 17:25:00+00
260	29	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-25 17:57:00+00
261	24	843d549d-2a3e-4d06-b974-1c59db802208	0.87	2026-08-26 00:14:00+00
264	11	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-26 00:16:00+00
265	57	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-26 00:29:00+00
267	18	843d549d-2a3e-4d06-b974-1c59db802208	0.67	2026-08-26 06:03:00+00
268	19	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-26 06:04:00+00
269	23	843d549d-2a3e-4d06-b974-1c59db802208	0.50	2026-08-26 06:05:00+00
270	42	843d549d-2a3e-4d06-b974-1c59db802208	2.00	2026-08-26 06:14:00+00
271	58	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-26 18:00:00+00
272	26	843d549d-2a3e-4d06-b974-1c59db802208	2.00	2026-08-26 18:01:00+00
273	27	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-26 18:01:00+00
277	39	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-27 01:30:00+00
281	19	843d549d-2a3e-4d06-b974-1c59db802208	2.00	2026-08-27 03:16:00+00
282	11	843d549d-2a3e-4d06-b974-1c59db802208	1.40	2026-08-27 03:16:00+00
285	42	843d549d-2a3e-4d06-b974-1c59db802208	4.00	2026-08-27 03:17:00+00
286	29	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-27 15:28:00+00
287	26	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-27 15:29:00+00
289	59	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-27 15:31:00+00
290	19	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-27 18:41:00+00
291	12	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-27 18:42:00+00
294	14	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-27 18:43:00+00
295	27	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-27 20:25:00+00
296	33	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-27 20:25:00+00
297	13	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-27 20:26:00+00
298	21	843d549d-2a3e-4d06-b974-1c59db802208	2.00	2026-08-28 03:14:00+00
299	60	843d549d-2a3e-4d06-b974-1c59db802208	0.65	2026-08-28 03:20:00+00
302	51	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-28 03:22:00+00
303	14	843d549d-2a3e-4d06-b974-1c59db802208	2.00	2026-08-28 18:18:00+00
304	39	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-28 18:18:00+00
305	12	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-28 18:19:00+00
306	10	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-28 18:19:00+00
307	10	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-28 18:19:00+00
309	16	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-28 18:20:00+00
311	51	843d549d-2a3e-4d06-b974-1c59db802208	4.00	2026-08-28 20:39:00+00
312	10	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-28 22:17:00+00
314	10	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-29 05:18:00+00
315	46	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-29 05:19:00+00
316	14	843d549d-2a3e-4d06-b974-1c59db802208	2.00	2026-08-29 17:50:00+00
317	12	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-29 17:50:00+00
318	10	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-29 17:50:00+00
319	58	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-29 17:51:00+00
320	26	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-29 17:51:00+00
321	30	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-29 17:52:00+00
322	43	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-29 23:35:00+00
323	61	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-29 23:38:00+00
324	62	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-29 23:59:00+00
325	63	843d549d-2a3e-4d06-b974-1c59db802208	0.75	2026-08-29 23:59:00+00
328	16	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-30 00:17:00+00
329	51	843d549d-2a3e-4d06-b974-1c59db802208	3.00	2026-08-30 03:39:00+00
330	40	843d549d-2a3e-4d06-b974-1c59db802208	0.25	2026-08-30 03:40:00+00
331	14	843d549d-2a3e-4d06-b974-1c59db802208	2.00	2026-08-30 17:32:00+00
332	12	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-30 17:32:00+00
333	13	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-30 17:32:00+00
334	10	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-30 17:33:00+00
335	21	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-30 17:33:00+00
337	61	843d549d-2a3e-4d06-b974-1c59db802208	0.33	2026-08-30 18:41:00+00
340	15	843d549d-2a3e-4d06-b974-1c59db802208	2.00	2026-08-30 18:47:00+00
341	37	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-30 21:46:00+00
342	9	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-30 21:47:00+00
343	16	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-30 21:47:00+00
344	46	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-30 21:48:00+00
345	38	843d549d-2a3e-4d06-b974-1c59db802208	0.25	2026-08-30 21:51:00+00
346	51	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-30 23:42:00+00
347	54	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-30 23:43:00+00
348	39	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-31 02:37:00+00
349	12	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-31 16:33:00+00
350	10	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-31 16:33:00+00
351	13	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-31 16:33:00+00
352	21	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-31 16:33:00+00
353	14	843d549d-2a3e-4d06-b974-1c59db802208	2.00	2026-08-31 16:33:00+00
354	9	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-31 16:34:00+00
355	16	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-31 16:35:00+00
356	64	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-31 20:45:00+00
357	18	843d549d-2a3e-4d06-b974-1c59db802208	1.25	2026-08-31 23:31:00+00
359	36	843d549d-2a3e-4d06-b974-1c59db802208	0.15	2026-08-31 23:33:00+00
360	35	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-01 00:59:00+00
361	51	843d549d-2a3e-4d06-b974-1c59db802208	0.50	2026-09-01 01:00:00+00
362	26	843d549d-2a3e-4d06-b974-1c59db802208	2.00	2026-09-01 15:01:00+00
363	18	843d549d-2a3e-4d06-b974-1c59db802208	1.33	2026-09-01 15:01:00+00
364	35	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-01 15:02:00+00
365	14	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-01 15:02:00+00
418	30	843d549d-2a3e-4d06-b974-1c59db802208	0.50	2026-09-04 17:43:00+00
367	36	843d549d-2a3e-4d06-b974-1c59db802208	0.12	2026-09-01 19:29:00+00
368	30	843d549d-2a3e-4d06-b974-1c59db802208	0.25	2026-09-01 19:30:00+00
369	46	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-01 23:44:00+00
370	11	843d549d-2a3e-4d06-b974-1c59db802208	1.40	2026-09-01 23:44:00+00
371	51	843d549d-2a3e-4d06-b974-1c59db802208	4.00	2026-09-02 05:09:00+00
372	30	843d549d-2a3e-4d06-b974-1c59db802208	0.25	2026-09-02 05:21:00+00
373	26	843d549d-2a3e-4d06-b974-1c59db802208	2.00	2026-09-02 15:01:00+00
374	27	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-02 15:02:00+00
375	32	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-02 15:03:00+00
420	77	843d549d-2a3e-4d06-b974-1c59db802208	0.33	2026-09-05 03:10:00+00
377	30	843d549d-2a3e-4d06-b974-1c59db802208	0.25	2026-09-02 18:16:00+00
422	39	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-05 17:00:00+00
379	33	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-02 18:17:00+00
380	46	843d549d-2a3e-4d06-b974-1c59db802208	0.36	2026-09-03 00:19:00+00
381	18	843d549d-2a3e-4d06-b974-1c59db802208	0.30	2026-09-03 00:21:00+00
382	35	843d549d-2a3e-4d06-b974-1c59db802208	0.25	2026-09-03 00:22:00+00
383	11	843d549d-2a3e-4d06-b974-1c59db802208	1.40	2026-09-03 00:23:00+00
384	51	843d549d-2a3e-4d06-b974-1c59db802208	2.00	2026-09-03 01:42:00+00
424	12	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-05 17:30:00+00
425	13	843d549d-2a3e-4d06-b974-1c59db802208	0.50	2026-09-05 17:30:00+00
426	10	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-05 17:30:00+00
428	10	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-05 20:17:00+00
430	30	843d549d-2a3e-4d06-b974-1c59db802208	0.25	2026-09-05 20:27:00+00
432	10	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-06 00:17:00+00
434	16	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-06 00:32:00+00
436	30	843d549d-2a3e-4d06-b974-1c59db802208	0.25	2026-09-06 03:41:00+00
438	15	843d549d-2a3e-4d06-b974-1c59db802208	2.00	2026-09-07 18:30:00+00
440	16	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-07 18:31:00+00
442	12	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-06 18:33:00+00
396	26	843d549d-2a3e-4d06-b974-1c59db802208	2.00	2026-09-03 18:16:00+00
444	21	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-06 18:34:00+00
398	14	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-03 19:06:00+00
446	16	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-06 18:35:00+00
448	79	843d549d-2a3e-4d06-b974-1c59db802208	2.00	2026-09-06 18:41:00+00
402	9	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-03 19:20:00+00
403	19	843d549d-2a3e-4d06-b974-1c59db802208	2.00	2026-09-04 00:20:00+00
404	37	843d549d-2a3e-4d06-b974-1c59db802208	2.00	2026-09-04 00:21:00+00
405	25	843d549d-2a3e-4d06-b974-1c59db802208	2.50	2026-09-04 01:44:00+00
406	30	843d549d-2a3e-4d06-b974-1c59db802208	0.50	2026-09-04 03:23:00+00
407	36	843d549d-2a3e-4d06-b974-1c59db802208	1.25	2026-09-04 03:24:00+00
408	14	843d549d-2a3e-4d06-b974-1c59db802208	2.00	2026-09-04 17:20:00+00
452	80	843d549d-2a3e-4d06-b974-1c59db802208	3.00	2026-09-06 18:51:00+00
454	10	843d549d-2a3e-4d06-b974-1c59db802208	3.00	2026-09-06 18:55:00+00
456	76	843d549d-2a3e-4d06-b974-1c59db802208	1.12	2026-09-07 22:17:00+00
412	11	843d549d-2a3e-4d06-b974-1c59db802208	1.40	2026-09-04 17:21:00+00
413	12	843d549d-2a3e-4d06-b974-1c59db802208	1.50	2026-09-04 17:21:00+00
458	60	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-07 22:31:00+00
416	16	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-04 17:41:00+00
460	14	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-08 01:41:00+00
462	19	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-08 01:41:00+00
464	12	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-08 15:59:00+00
466	13	843d549d-2a3e-4d06-b974-1c59db802208	0.10	2026-09-08 15:59:00+00
468	79	843d549d-2a3e-4d06-b974-1c59db802208	1.50	2026-09-08 18:34:00+00
470	16	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-08 20:44:00+00
472	35	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-08 22:31:00+00
474	30	843d549d-2a3e-4d06-b974-1c59db802208	0.25	2026-09-09 03:23:00+00
476	51	843d549d-2a3e-4d06-b974-1c59db802208	3.00	2026-09-09 05:01:00+00
\.


--
-- Data for Name: food_log_bak; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.food_log_bak (food_log_id, food_id, user_id, servings, datetime) FROM stdin;
79	22	843d549d-2a3e-4d06-b974-1c59db802208	0.20	2026-08-10 20:32:00+00
80	15	843d549d-2a3e-4d06-b974-1c59db802208	0.20	2026-08-10 20:33:00+00
81	18	843d549d-2a3e-4d06-b974-1c59db802208	0.87	2026-08-10 20:44:00+00
4	7	7dd73c91-5396-440d-9304-3bd3b8af14cd	1.00	2026-08-09 03:33:00+00
5	8	95f81fb6-468d-49a5-bcbc-bd0d588abcfd	1.00	2026-08-09 04:33:00+00
82	23	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-10 20:48:00+00
83	23	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-09 20:48:00+00
84	16	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-10 20:49:00+00
85	24	843d549d-2a3e-4d06-b974-1c59db802208	1.50	2026-08-10 23:04:00+00
86	24	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-10 23:04:00+00
87	25	843d549d-2a3e-4d06-b974-1c59db802208	2.00	2026-08-11 02:33:00+00
12	12	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-09 08:30:00+00
88	26	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-11 15:15:00+00
89	14	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-11 15:16:00+00
90	27	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-11 15:19:00+00
16	10	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-09 18:35:00+00
17	13	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-09 18:42:00+00
18	14	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-09 18:47:00+00
19	15	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-09 21:01:00+00
20	14	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-09 23:53:00+00
92	29	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-11 15:32:00+00
93	28	843d549d-2a3e-4d06-b974-1c59db802208	0.87	2026-08-11 20:10:00+00
94	11	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-11 20:11:00+00
96	25	843d549d-2a3e-4d06-b974-1c59db802208	1.07	2026-08-12 00:14:00+00
97	20	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-12 00:15:00+00
99	30	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-12 00:20:00+00
30	16	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-10 00:09:00+00
103	26	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-11 08:47:00+00
104	26	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-12 16:00:00+00
105	26	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-12 17:39:00+00
106	29	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-12 17:39:00+00
107	14	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-12 17:40:00+00
108	32	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-12 18:27:00+00
109	33	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-12 18:28:00+00
110	27	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-12 18:28:00+00
113	11	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-12 23:51:00+00
114	25	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-12 23:51:00+00
115	20	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-12 23:51:00+00
116	30	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-13 00:13:00+00
117	30	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-13 05:04:00+00
118	20	843d549d-2a3e-4d06-b974-1c59db802208	0.50	2026-08-13 05:06:00+00
50	17	6e0f0843-47e4-482a-92d5-f1b436bce1c7	1.00	2026-08-10 00:51:00+00
119	11	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-13 05:14:00+00
120	14	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-13 14:58:00+00
121	29	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-13 14:58:00+00
122	26	843d549d-2a3e-4d06-b974-1c59db802208	2.00	2026-08-13 14:59:00+00
123	9	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-13 14:59:00+00
125	34	843d549d-2a3e-4d06-b974-1c59db802208	0.25	2026-08-14 00:03:00+00
126	18	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-14 00:14:00+00
131	37	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-14 00:26:00+00
132	37	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-14 00:27:00+00
65	19	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-10 04:36:00+00
66	18	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-10 04:37:00+00
67	20	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-10 04:39:00+00
68	16	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-10 04:39:00+00
69	21	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-10 06:20:00+00
70	14	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-10 07:01:00+00
71	19	843d549d-2a3e-4d06-b974-1c59db802208	0.50	2026-08-10 16:19:00+00
72	16	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-10 16:28:00+00
73	14	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-10 16:33:00+00
74	10	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-10 18:17:00+00
75	12	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-10 18:17:00+00
133	23	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-14 00:37:00+00
78	9	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-10 18:40:00+00
135	19	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-14 04:37:00+00
136	37	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-14 04:38:00+00
137	14	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-14 15:55:00+00
138	39	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-14 16:31:00+00
139	18	843d549d-2a3e-4d06-b974-1c59db802208	1.33	2026-08-14 16:31:00+00
140	23	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-14 16:43:00+00
141	14	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-14 21:36:00+00
142	39	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-14 21:37:00+00
143	16	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-14 21:39:00+00
146	40	843d549d-2a3e-4d06-b974-1c59db802208	0.33	2026-08-14 21:44:00+00
147	12	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-14 22:19:00+00
148	10	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-14 22:20:00+00
149	30	843d549d-2a3e-4d06-b974-1c59db802208	1.50	2026-08-15 03:03:00+00
150	41	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-15 05:07:00+00
151	30	843d549d-2a3e-4d06-b974-1c59db802208	0.50	2026-08-15 06:48:00+00
153	42	843d549d-2a3e-4d06-b974-1c59db802208	5.00	2026-08-15 06:59:00+00
154	10	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-15 15:52:00+00
155	14	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-15 15:58:00+00
156	14	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-15 15:59:00+00
157	16	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-15 15:59:00+00
158	39	843d549d-2a3e-4d06-b974-1c59db802208	0.50	2026-08-15 16:56:00+00
159	43	843d549d-2a3e-4d06-b974-1c59db802208	1.20	2026-08-15 20:19:00+00
160	10	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-15 20:26:00+00
161	42	843d549d-2a3e-4d06-b974-1c59db802208	5.00	2026-08-15 20:28:00+00
162	28	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-15 23:05:00+00
163	28	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-15 23:52:00+00
164	18	843d549d-2a3e-4d06-b974-1c59db802208	1.33	2026-08-15 23:54:00+00
165	23	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-15 23:55:00+00
169	14	843d549d-2a3e-4d06-b974-1c59db802208	10.00	2026-08-16 15:33:00+00
170	14	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-16 15:34:00+00
\.


--
-- Data for Name: profile; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.profile (profile_id, user_id, start_weight, goal_weight, height, activity_level, daily_calorie_deficit, diet_type, sunday_protein, sunday_carbs, sunday_fat, monday_protein, monday_carbs, monday_fat, tuesday_protein, tuesday_carbs, tuesday_fat, wednesday_protein, wednesday_carbs, wednesday_fat, thursday_protein, thursday_carbs, thursday_fat, friday_protein, friday_carbs, friday_fat, saturday_protein, saturday_carbs, saturday_fat, is_active, created_at) FROM stdin;
3	95f81fb6-468d-49a5-bcbc-bd0d588abcfd	153.00	152.00	68.00	ModeratelyActive	200	High Metabolic	40.00	10.00	50.00	40.00	10.00	50.00	35.00	35.00	30.00	35.00	45.00	20.00	40.00	10.00	50.00	35.00	35.00	30.00	35.00	45.00	20.00	t	2026-08-09 04:30:05.259679+00
16	e6430d4a-90fa-437d-9cae-37ca063933dc	205.00	180.00	68.00	ModeratelyActive	500	Balanced	30.00	30.00	40.00	30.00	30.00	40.00	30.00	30.00	40.00	30.00	30.00	40.00	30.00	30.00	40.00	30.00	30.00	40.00	30.00	30.00	40.00	t	2026-08-16 18:01:41.319245+00
1	843d549d-2a3e-4d06-b974-1c59db802208	230.00	168.00	69.00	ModeratelyActive	800	High Metabolic	40.00	10.00	50.00	40.00	10.00	50.00	35.00	35.00	30.00	35.00	45.00	20.00	40.00	10.00	50.00	35.00	35.00	30.00	35.00	45.00	20.00	t	2026-08-08 18:48:06.543984+00
2	7dd73c91-5396-440d-9304-3bd3b8af14cd	200.00	175.00	75.00	LightlyActive	300	Balanced	30.00	30.00	40.00	30.00	30.00	40.00	30.00	30.00	40.00	30.00	30.00	40.00	30.00	30.00	40.00	30.00	30.00	40.00	30.00	30.00	40.00	t	2026-08-09 03:29:38.354871+00
\.


--
-- Data for Name: supplement; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.supplement (supplement_id, user_id, description, serving_size, serving_unit, share_with_others, is_active, created_at) FROM stdin;
3	7dd73c91-5396-440d-9304-3bd3b8af14cd	BCAA	1.00	pills	t	t	2026-08-09 03:32:44.277077+00
4	95f81fb6-468d-49a5-bcbc-bd0d588abcfd	Water	8.00	glasses	t	t	2026-08-09 04:44:07.771231+00
5	843d549d-2a3e-4d06-b974-1c59db802208	Magnesium	1.00	pills	t	t	2026-08-10 06:31:05.822866+00
2	843d549d-2a3e-4d06-b974-1c59db802208	Ceatine	1.00	scoop	t	t	2026-08-09 02:27:55.812493+00
1	843d549d-2a3e-4d06-b974-1c59db802208	Water	8.00	glasses	t	t	2026-08-09 02:27:41.609958+00
6	843d549d-2a3e-4d06-b974-1c59db802208	Multi (AG1)	1.00	other	t	t	2026-08-10 16:58:48.18108+00
7	843d549d-2a3e-4d06-b974-1c59db802208	B-Complex	1.00	pills	t	t	2026-08-10 16:59:03.226734+00
8	843d549d-2a3e-4d06-b974-1c59db802208	D3-K2	1.00	pills	t	t	2026-08-10 17:00:19.611935+00
9	843d549d-2a3e-4d06-b974-1c59db802208	Fish Oil 2g, Krill 0.5g	1.00	other	f	t	2026-08-11 03:48:31.475613+00
10	843d549d-2a3e-4d06-b974-1c59db802208	dfsdfsfdfd	1.00	other	f	f	2026-08-16 20:47:55.607541+00
12	843d549d-2a3e-4d06-b974-1c59db802208	Zinc	1.00	pills	f	t	2026-08-22 05:51:10.971597+00
13	843d549d-2a3e-4d06-b974-1c59db802208	sdsdads	1.00	other	f	f	2026-09-03 06:18:14.75641+00
14	843d549d-2a3e-4d06-b974-1c59db802208	dsadsasda	1.00	other	f	f	2026-09-03 06:28:26.892708+00
11	843d549d-2a3e-4d06-b974-1c59db802208	Asheogonda	1.00	pills	f	f	2026-08-22 05:50:56.8758+00
16	843d549d-2a3e-4d06-b974-1c59db802208	2222	1.00	other	f	f	2026-09-03 06:50:27.840862+00
15	843d549d-2a3e-4d06-b974-1c59db802208	dsdsdsdsdsdsdsds	1.00	other	f	f	2026-09-03 06:30:12.629629+00
17	843d549d-2a3e-4d06-b974-1c59db802208	AAAAAAA	1.00	other	f	f	2026-09-06 03:43:04.856749+00
\.


--
-- Data for Name: supplement_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.supplement_log (supplement_log_id, supplement_id, user_id, servings, date) FROM stdin;
5	1	843d549d-2a3e-4d06-b974-1c59db802208	8.00	2026-08-09
6	5	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-09
7	6	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-10
8	8	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-10
9	7	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-10
10	2	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-10
11	6	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-09
12	1	843d549d-2a3e-4d06-b974-1c59db802208	8.00	2026-08-11
13	1	843d549d-2a3e-4d06-b974-1c59db802208	8.00	2026-08-12
14	1	843d549d-2a3e-4d06-b974-1c59db802208	8.00	2026-08-13
15	5	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-13
16	1	843d549d-2a3e-4d06-b974-1c59db802208	8.00	2026-08-14
17	6	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-14
18	2	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-14
19	8	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-14
21	2	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-15
22	8	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-15
23	5	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-14
24	1	843d549d-2a3e-4d06-b974-1c59db802208	8.00	2026-08-15
25	5	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-15
29	1	843d549d-2a3e-4d06-b974-1c59db802208	8.00	2026-08-16
30	8	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-16
31	1	843d549d-2a3e-4d06-b974-1c59db802208	8.00	2026-08-17
32	8	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-17
33	1	843d549d-2a3e-4d06-b974-1c59db802208	8.00	2026-08-18
34	6	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-18
35	1	843d549d-2a3e-4d06-b974-1c59db802208	8.00	2026-08-19
36	6	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-19
37	2	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-20
38	8	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-20
39	1	843d549d-2a3e-4d06-b974-1c59db802208	8.00	2026-08-20
40	8	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-21
41	2	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-21
42	9	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-21
43	1	843d549d-2a3e-4d06-b974-1c59db802208	8.00	2026-08-21
44	5	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-21
45	11	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-21
46	1	843d549d-2a3e-4d06-b974-1c59db802208	8.00	2026-08-23
47	7	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-23
48	8	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-23
49	1	843d549d-2a3e-4d06-b974-1c59db802208	8.00	2026-08-22
50	5	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-22
51	11	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-22
52	2	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-22
53	9	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-22
54	9	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-23
55	2	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-24
56	1	843d549d-2a3e-4d06-b974-1c59db802208	8.00	2026-08-24
57	7	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-28
58	2	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-28
59	8	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-28
60	1	843d549d-2a3e-4d06-b974-1c59db802208	8.00	2026-08-28
61	5	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-28
62	12	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-28
63	2	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-30
64	1	843d549d-2a3e-4d06-b974-1c59db802208	8.00	2026-08-30
65	9	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-30
66	6	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-30
67	2	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-31
68	7	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-31
69	8	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-31
70	9	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-31
71	1	843d549d-2a3e-4d06-b974-1c59db802208	8.00	2026-08-31
72	6	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-08-31
73	1	843d549d-2a3e-4d06-b974-1c59db802208	8.00	2026-09-01
74	1	843d549d-2a3e-4d06-b974-1c59db802208	8.00	2026-09-02
78	5	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-03
79	12	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-03
80	6	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-03
81	1	843d549d-2a3e-4d06-b974-1c59db802208	8.00	2026-09-03
82	2	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-04
83	1	843d549d-2a3e-4d06-b974-1c59db802208	8.00	2026-09-05
84	2	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-05
85	5	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-05
86	12	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-05
88	2	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-07
89	1	843d549d-2a3e-4d06-b974-1c59db802208	8.00	2026-09-07
90	7	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-07
91	8	843d549d-2a3e-4d06-b974-1c59db802208	1.00	2026-09-07
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, email, password, fname, lname, sex, age, is_active, created_at) FROM stdin;
843d549d-2a3e-4d06-b974-1c59db802208	bill.jenner@gmail.com	iforgot	Bill	Jenner	Male	62	t	2026-08-08 16:28:26.018634+00
7dd73c91-5396-440d-9304-3bd3b8af14cd	mark.johnson443433434@gmail.com	iforgot	Mark	Johnson	Male	60	t	2026-08-09 03:03:51.972408+00
95f81fb6-468d-49a5-bcbc-bd0d588abcfd	leslie.jenner@gmail.com	iforgot	Leslie	Jenner	Female	59	t	2026-08-09 04:27:44.781303+00
e6430d4a-90fa-437d-9cae-37ca063933dc	dsipraseuth@gmail.com	MinaS0329	Dewey	Sipraseuth	Male	63	t	2026-08-09 14:34:00.060584+00
6e0f0843-47e4-482a-92d5-f1b436bce1c7	qa+slimbelly-20260809@example.com	pass123	Test	User	Male	30	t	2026-08-10 00:50:53.44517+00
\.


--
-- Data for Name: users_logged_in; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users_logged_in (id, users_email, public_ip, is_logged_in, updated_at) FROM stdin;
3	bill.jenner@gmail.com	73.59.94.112	f	2026-09-09 07:22:11.588+00
\.


--
-- Data for Name: weight_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.weight_log (weight_log_id, user_id, weight, bmi, date) FROM stdin;
81	843d549d-2a3e-4d06-b974-1c59db802208	215.80	31.86	2026-09-03
83	7dd73c91-5396-440d-9304-3bd3b8af14cd	200.00	25.00	2026-09-03
84	843d549d-2a3e-4d06-b974-1c59db802208	217.30	32.09	2026-09-04
7	843d549d-2a3e-4d06-b974-1c59db802208	230.00	33.96	2026-08-08
8	843d549d-2a3e-4d06-b974-1c59db802208	229.00	33.81	2026-08-09
9	843d549d-2a3e-4d06-b974-1c59db802208	225.50	33.30	2026-08-10
85	843d549d-2a3e-4d06-b974-1c59db802208	217.30	32.09	2026-09-05
28	843d549d-2a3e-4d06-b974-1c59db802208	224.30	33.12	2026-08-11
29	843d549d-2a3e-4d06-b974-1c59db802208	224.30	33.12	2026-08-12
31	843d549d-2a3e-4d06-b974-1c59db802208	223.10	32.94	2026-08-13
37	843d549d-2a3e-4d06-b974-1c59db802208	222.00	32.78	2026-08-14
39	843d549d-2a3e-4d06-b974-1c59db802208	222.00	32.78	2026-08-15
40	843d549d-2a3e-4d06-b974-1c59db802208	223.50	33.00	2026-08-16
41	843d549d-2a3e-4d06-b974-1c59db802208	222.30	32.82	2026-08-17
42	843d549d-2a3e-4d06-b974-1c59db802208	221.70	32.74	2026-08-18
48	843d549d-2a3e-4d06-b974-1c59db802208	220.50	32.56	2026-08-19
49	843d549d-2a3e-4d06-b974-1c59db802208	220.20	32.51	2026-08-20
50	843d549d-2a3e-4d06-b974-1c59db802208	220.20	32.51	2026-08-21
51	843d549d-2a3e-4d06-b974-1c59db802208	219.10	32.35	2026-08-22
56	843d549d-2a3e-4d06-b974-1c59db802208	217.30	32.09	2026-08-23
58	843d549d-2a3e-4d06-b974-1c59db802208	218.50	32.26	2026-08-24
59	843d549d-2a3e-4d06-b974-1c59db802208	218.50	32.26	2026-08-25
60	843d549d-2a3e-4d06-b974-1c59db802208	217.20	32.07	2026-08-29
63	843d549d-2a3e-4d06-b974-1c59db802208	216.60	31.98	2026-08-30
65	843d549d-2a3e-4d06-b974-1c59db802208	214.40	31.66	2026-08-31
70	843d549d-2a3e-4d06-b974-1c59db802208	214.60	31.69	2026-09-01
78	843d549d-2a3e-4d06-b974-1c59db802208	215.80	31.86	2026-09-02
\.


--
-- Data for Name: weight_log_bak; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.weight_log_bak (weight_log_id, user_id, weight, date) FROM stdin;
1	843d549d-2a3e-4d06-b974-1c59db802208	230.00	2026-08-08
2	843d549d-2a3e-4d06-b974-1c59db802208	229.00	2026-08-09
3	843d549d-2a3e-4d06-b974-1c59db802208	225.50	2026-08-10
4	843d549d-2a3e-4d06-b974-1c59db802208	224.30	2026-08-11
\.


--
-- Data for Name: workout; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workout (workout_id, user_id, type, average_workout_time, calories_burned, share_with_others, is_active, created_at) FROM stdin;
2	843d549d-2a3e-4d06-b974-1c59db802208	Weights	15	150	f	t	2026-08-09 01:43:25.764035+00
3	7dd73c91-5396-440d-9304-3bd3b8af14cd	Squats	15	200	t	t	2026-08-09 03:32:17.85891+00
4	95f81fb6-468d-49a5-bcbc-bd0d588abcfd	Walking	30	225	t	t	2026-08-09 04:43:39.496655+00
7	843d549d-2a3e-4d06-b974-1c59db802208	Squats (100)	10	80	f	f	2026-08-10 04:12:37.692252+00
6	843d549d-2a3e-4d06-b974-1c59db802208	Squats (50/5 min.)	5	40	f	t	2026-08-09 23:20:53.250917+00
1	843d549d-2a3e-4d06-b974-1c59db802208	Tread Mill (HITT Interval)	15	120	f	t	2026-08-09 01:28:38.090236+00
5	843d549d-2a3e-4d06-b974-1c59db802208	Tread Mill (HITT interval) + Calisthenics	30	270	f	t	2026-08-09 23:19:15.574071+00
9	843d549d-2a3e-4d06-b974-1c59db802208	Walking	30	125	f	t	2026-08-22 20:05:58.859508+00
8	843d549d-2a3e-4d06-b974-1c59db802208	Kettle Ball Swings (20 x 3 sets)	10	40	t	f	2026-08-10 06:13:41.757555+00
10	843d549d-2a3e-4d06-b974-1c59db802208	Kettle Ball (20 × 3 sets)	10	40	f	t	2026-08-31 03:22:50.516824+00
11	843d549d-2a3e-4d06-b974-1c59db802208	aaa	22	22	f	f	2026-09-03 06:15:13.781438+00
12	843d549d-2a3e-4d06-b974-1c59db802208	dsadsdsadsadsadsa	\N	0	f	f	2026-09-03 06:30:29.164819+00
13	843d549d-2a3e-4d06-b974-1c59db802208	fdsfdsfdsfds	11	1111	f	f	2026-09-03 06:45:18.196479+00
14	843d549d-2a3e-4d06-b974-1c59db802208	dsdsadsads	222	222	f	f	2026-09-03 06:45:58.242204+00
15	843d549d-2a3e-4d06-b974-1c59db802208	232232323	22	0	f	f	2026-09-03 06:50:15.013305+00
\.


--
-- Data for Name: workout_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workout_log (workout_log_id, workout_id, user_id, workout_time, calories_burned, date) FROM stdin;
20	6	843d549d-2a3e-4d06-b974-1c59db802208	20	160	2026-08-09
23	8	843d549d-2a3e-4d06-b974-1c59db802208	15	60	2026-08-13
32	8	843d549d-2a3e-4d06-b974-1c59db802208	30	120	2026-08-14
33	8	843d549d-2a3e-4d06-b974-1c59db802208	15	60	2026-08-09
34	1	843d549d-2a3e-4d06-b974-1c59db802208	15	120	2026-08-14
38	8	843d549d-2a3e-4d06-b974-1c59db802208	20	80	2026-08-16
40	5	843d549d-2a3e-4d06-b974-1c59db802208	30	270	2026-08-17
41	8	843d549d-2a3e-4d06-b974-1c59db802208	15	60	2026-08-17
44	8	843d549d-2a3e-4d06-b974-1c59db802208	20	80	2026-08-18
45	6	843d549d-2a3e-4d06-b974-1c59db802208	5	40	2026-08-21
47	8	843d549d-2a3e-4d06-b974-1c59db802208	20	80	2026-08-24
48	5	843d549d-2a3e-4d06-b974-1c59db802208	30	270	2026-08-28
50	9	843d549d-2a3e-4d06-b974-1c59db802208	120	500	2026-08-29
52	9	843d549d-2a3e-4d06-b974-1c59db802208	120	500	2026-08-22
54	9	843d549d-2a3e-4d06-b974-1c59db802208	30	125	2026-08-30
58	10	843d549d-2a3e-4d06-b974-1c59db802208	40	160	2026-08-30
60	9	843d549d-2a3e-4d06-b974-1c59db802208	60	250	2026-08-31
67	10	843d549d-2a3e-4d06-b974-1c59db802208	30	120	2026-09-03
68	9	843d549d-2a3e-4d06-b974-1c59db802208	60	250	2026-09-05
69	5	843d549d-2a3e-4d06-b974-1c59db802208	30	270	2026-09-07
70	10	843d549d-2a3e-4d06-b974-1c59db802208	10	40	2026-09-07
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2026-08-06 03:19:57
20211116045059	2026-08-06 03:19:57
20211116050929	2026-08-06 03:19:57
20211116051442	2026-08-06 03:19:57
20211116212300	2026-08-06 03:19:57
20211116213355	2026-08-06 03:19:57
20211116213934	2026-08-06 03:19:57
20211116214523	2026-08-06 03:19:57
20211122062447	2026-08-06 03:19:57
20211124070109	2026-08-06 03:19:57
20211202204204	2026-08-06 03:19:57
20211202204605	2026-08-06 03:19:57
20211210212804	2026-08-06 03:19:57
20211228014915	2026-08-06 03:19:57
20220107221237	2026-08-06 03:19:57
20220228202821	2026-08-06 03:19:57
20220312004840	2026-08-06 03:19:57
20220603231003	2026-08-06 03:19:57
20220603232444	2026-08-06 03:19:57
20220615214548	2026-08-06 03:19:57
20220712093339	2026-08-06 03:19:57
20220908172859	2026-08-06 03:19:57
20220916233421	2026-08-06 03:19:57
20230119133233	2026-08-06 03:19:57
20230128025114	2026-08-06 03:19:57
20230128025212	2026-08-06 03:19:57
20230227211149	2026-08-06 03:19:57
20230228184745	2026-08-06 03:19:57
20230308225145	2026-08-06 03:19:57
20230328144023	2026-08-06 03:19:57
20231018144023	2026-08-06 03:19:57
20231204144023	2026-08-06 03:19:57
20231204144024	2026-08-06 03:19:57
20231204144025	2026-08-06 03:19:57
20240108234812	2026-08-06 03:19:57
20240109165339	2026-08-06 03:19:57
20240227174441	2026-08-06 03:19:57
20240311171622	2026-08-06 03:19:57
20240321100241	2026-08-06 03:19:57
20240401105812	2026-08-06 03:19:57
20240418121054	2026-08-06 03:19:57
20240523004032	2026-08-06 03:19:57
20240618124746	2026-08-06 03:19:57
20240801235015	2026-08-06 03:19:57
20240805133720	2026-08-06 03:19:57
20240827160934	2026-08-06 03:19:57
20240919163303	2026-08-06 03:19:57
20240919163305	2026-08-06 03:19:57
20241019105805	2026-08-06 03:19:57
20241030150047	2026-08-06 03:19:57
20241108114728	2026-08-06 03:19:57
20241121104152	2026-08-06 03:19:57
20241130184212	2026-08-06 03:19:57
20241220035512	2026-08-06 03:19:57
20241220123912	2026-08-06 03:19:57
20241224161212	2026-08-06 03:19:57
20250107150512	2026-08-06 03:19:57
20250110162412	2026-08-06 03:19:57
20250123174212	2026-08-06 03:19:57
20250128220012	2026-08-06 03:19:57
20250506224012	2026-08-06 03:19:57
20250523164012	2026-08-06 03:19:57
20250714121412	2026-08-06 03:19:57
20250905041441	2026-08-06 03:19:57
20251103001201	2026-08-06 03:19:57
20251120212548	2026-08-06 03:19:57
20251120215549	2026-08-06 03:19:57
20260218120000	2026-08-06 03:19:57
20260326120000	2026-08-06 03:19:57
20260514120000	2026-08-06 03:19:57
20260527120000	2026-08-06 03:19:57
20260528120000	2026-08-06 03:19:57
20260603120000	2026-08-06 03:19:57
20260605120000	2026-08-06 03:19:57
20260606110000	2026-08-06 03:19:57
20260616120000	2026-08-06 03:19:57
20260624120000	2026-08-06 03:19:57
20260626120000	2026-08-06 03:19:57
20260706120000	2026-08-06 03:19:57
20260707120000	2026-08-06 03:19:57
20260709120000	2026-08-06 03:19:57
20260714120000	2026-09-06 03:31:34
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: supabase_realtime_admin
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at, action_filter, selected_columns) FROM stdin;
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id, type, versioning_status) FROM stdin;
\.


--
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets_analytics (name, type, format, created_at, updated_at, id, deleted_at) FROM stdin;
\.


--
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets_vectors (id, type, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2026-08-06 03:19:43.292254
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2026-08-06 03:19:43.32968
2	storage-schema	f6a1fa2c93cbcd16d4e487b362e45fca157a8dbd	2026-08-06 03:19:43.334438
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2026-08-06 03:19:43.359531
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2026-08-06 03:19:43.376262
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2026-08-06 03:19:43.380868
6	change-column-name-in-get-size	ded78e2f1b5d7e616117897e6443a925965b30d2	2026-08-06 03:19:43.386784
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2026-08-06 03:19:43.392202
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2026-08-06 03:19:43.396494
9	fix-search-function	af597a1b590c70519b464a4ab3be54490712796b	2026-08-06 03:19:43.401661
10	search-files-search-function	b595f05e92f7e91211af1bbfe9c6a13bb3391e16	2026-08-06 03:19:43.406313
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2026-08-06 03:19:43.41255
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2026-08-06 03:19:43.41768
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2026-08-06 03:19:43.42263
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2026-08-06 03:19:43.427246
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2026-08-06 03:19:43.458795
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2026-08-06 03:19:43.464224
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2026-08-06 03:19:43.468927
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2026-08-06 03:19:43.474514
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2026-08-06 03:19:43.480936
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2026-08-06 03:19:43.487107
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2026-08-06 03:19:43.493853
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2026-08-06 03:19:43.51278
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2026-08-06 03:19:43.522147
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2026-08-06 03:19:43.526961
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2026-08-06 03:19:43.531476
26	objects-prefixes	215cabcb7f78121892a5a2037a09fedf9a1ae322	2026-08-06 03:19:43.535909
27	search-v2	859ba38092ac96eb3964d83bf53ccc0b141663a6	2026-08-06 03:19:43.540124
28	object-bucket-name-sorting	c73a2b5b5d4041e39705814fd3a1b95502d38ce4	2026-08-06 03:19:43.543871
29	create-prefixes	ad2c1207f76703d11a9f9007f821620017a66c21	2026-08-06 03:19:43.547965
30	update-object-levels	2be814ff05c8252fdfdc7cfb4b7f5c7e17f0bed6	2026-08-06 03:19:43.552398
31	objects-level-index	b40367c14c3440ec75f19bbce2d71e914ddd3da0	2026-08-06 03:19:43.556404
32	backward-compatible-index-on-objects	e0c37182b0f7aee3efd823298fb3c76f1042c0f7	2026-08-06 03:19:43.560415
33	backward-compatible-index-on-prefixes	b480e99ed951e0900f033ec4eb34b5bdcb4e3d49	2026-08-06 03:19:43.564435
34	optimize-search-function-v1	ca80a3dc7bfef894df17108785ce29a7fc8ee456	2026-08-06 03:19:43.568454
35	add-insert-trigger-prefixes	458fe0ffd07ec53f5e3ce9df51bfdf4861929ccc	2026-08-06 03:19:43.57251
36	optimise-existing-functions	6ae5fca6af5c55abe95369cd4f93985d1814ca8f	2026-08-06 03:19:43.576516
37	add-bucket-name-length-trigger	3944135b4e3e8b22d6d4cbb568fe3b0b51df15c1	2026-08-06 03:19:43.580516
38	iceberg-catalog-flag-on-buckets	02716b81ceec9705aed84aa1501657095b32e5c5	2026-08-06 03:19:43.585526
39	add-search-v2-sort-support	6706c5f2928846abee18461279799ad12b279b78	2026-08-06 03:19:43.595844
40	fix-prefix-race-conditions-optimized	7ad69982ae2d372b21f48fc4829ae9752c518f6b	2026-08-06 03:19:43.600403
41	add-object-level-update-trigger	07fcf1a22165849b7a029deed059ffcde08d1ae0	2026-08-06 03:19:43.605426
42	rollback-prefix-triggers	771479077764adc09e2ea2043eb627503c034cd4	2026-08-06 03:19:43.609877
43	fix-object-level	84b35d6caca9d937478ad8a797491f38b8c2979f	2026-08-06 03:19:43.614335
44	vector-bucket-type	99c20c0ffd52bb1ff1f32fb992f3b351e3ef8fb3	2026-08-06 03:19:43.618552
45	vector-buckets	049e27196d77a7cb76497a85afae669d8b230953	2026-08-06 03:19:43.623625
46	buckets-objects-grants	fedeb96d60fefd8e02ab3ded9fbde05632f84aed	2026-08-06 03:19:43.638607
47	iceberg-table-metadata	649df56855c24d8b36dd4cc1aeb8251aa9ad42c2	2026-08-06 03:19:43.644254
48	iceberg-catalog-ids	e0e8b460c609b9999ccd0df9ad14294613eed939	2026-08-06 03:19:43.648905
49	buckets-objects-grants-postgres	072b1195d0d5a2f888af6b2302a1938dd94b8b3d	2026-08-06 03:19:43.69477
50	search-v2-optimised	6323ac4f850aa14e7387eb32102869578b5bd478	2026-08-06 03:19:43.7009
51	index-backward-compatible-search	2ee395d433f76e38bcd3856debaf6e0e5b674011	2026-08-06 03:19:43.76876
52	drop-not-used-indexes-and-functions	5cc44c8696749ac11dd0dc37f2a3802075f3a171	2026-08-06 03:19:43.770542
53	drop-index-lower-name	d0cb18777d9e2a98ebe0bc5cc7a42e57ebe41854	2026-08-06 03:19:43.785321
54	drop-index-object-level	6289e048b1472da17c31a7eba1ded625a6457e67	2026-08-06 03:19:43.787802
55	prevent-direct-deletes	262a4798d5e0f2e7c8970232e03ce8be695d5819	2026-08-06 03:19:43.79001
56	fix-optimized-search-function	b823ed1e418101032fa01374edc9a436e54e3ed4	2026-08-06 03:19:43.809288
57	s3-multipart-uploads-metadata	f127886e00d1b374fadbc7c6b31e09336aad5287	2026-08-06 03:19:43.817088
58	operation-ergonomics	00ca5d483b3fe0d522133d9002ccc5df98365120	2026-08-06 03:19:43.844223
59	drop-unused-functions	38456f13e39691c2bbb4b5151d0d1cdbabd4a8c4	2026-08-06 03:19:43.8624
60	optimize-existing-functions-again	db35e1c91a9201e59f4fef8d972c2f277d68b157	2026-08-06 03:19:43.883299
61	mark-filename-immutable	fe0096517ae9d60aaec1d110172ba9036dc66bb7	2026-08-12 07:30:56.129605
62	object-versioning-core	0b855f00ff3be0bfca91efee02a9858912491a9a	2026-08-28 06:46:15.908107
63	fix-search-name-relative-to-prefix	c7485e417624f795ce8bb2da21927f48e088904d	2026-08-28 06:46:15.938341
64	fix-search-by-timestamp-sqli	0af424ecd388a39bb1645184b222185a12149675	2026-08-28 06:46:15.950667
65	objects-key-version-index	603c1c55658e982d35839001e2c2b59a50703904	2026-09-07 16:15:12.426887
66	objects-current-version-index	191466c93aa2c46a00e36505577c5fcab8d7cb4b	2026-09-07 16:15:12.439308
67	objects-null-version-index	15bfe8c35b66642b6c78ba60060fa8793bd2207a	2026-09-07 16:15:12.447397
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata, archived_at, is_delete_marker, is_versioned) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata, metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.vector_indexes (id, name, bucket_id, data_type, dimension, distance_metric, metadata_configuration, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 23, true);


--
-- Name: feedback_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.feedback_id_seq', 4, true);


--
-- Name: food_food_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.food_food_id_seq', 82, true);


--
-- Name: food_log_food_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.food_log_food_log_id_seq', 170, true);


--
-- Name: food_log_food_log_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.food_log_food_log_id_seq1', 476, true);


--
-- Name: profile_profile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.profile_profile_id_seq', 25, true);


--
-- Name: supplement_log_supplement_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.supplement_log_supplement_log_id_seq', 91, true);


--
-- Name: supplement_supplement_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.supplement_supplement_id_seq', 17, true);


--
-- Name: users_logged_in_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_logged_in_id_seq', 3, true);


--
-- Name: weight_log_weight_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.weight_log_weight_log_id_seq', 5, true);


--
-- Name: weight_log_weight_log_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.weight_log_weight_log_id_seq1', 85, true);


--
-- Name: workout_log_workout_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workout_log_workout_log_id_seq', 70, true);


--
-- Name: workout_workout_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workout_workout_id_seq', 15, true);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: supabase_realtime_admin
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: custom_oauth_providers custom_oauth_providers_identifier_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_identifier_key UNIQUE (identifier);


--
-- Name: custom_oauth_providers custom_oauth_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_code_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_code_key UNIQUE (authorization_code);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_id_key UNIQUE (authorization_id);


--
-- Name: oauth_authorizations oauth_authorizations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_pkey PRIMARY KEY (id);


--
-- Name: oauth_client_states oauth_client_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_client_states
    ADD CONSTRAINT oauth_client_states_pkey PRIMARY KEY (id);


--
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_user_client_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_client_unique UNIQUE (user_id, client_id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: webauthn_challenges webauthn_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_pkey PRIMARY KEY (id);


--
-- Name: webauthn_credentials webauthn_credentials_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_pkey PRIMARY KEY (id);


--
-- Name: feedback feedback_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feedback
    ADD CONSTRAINT feedback_pkey PRIMARY KEY (id);


--
-- Name: food_log_bak food_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_log_bak
    ADD CONSTRAINT food_log_pkey PRIMARY KEY (food_log_id);


--
-- Name: food_log food_log_pkey1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_log
    ADD CONSTRAINT food_log_pkey1 PRIMARY KEY (food_log_id);


--
-- Name: food food_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food
    ADD CONSTRAINT food_pkey PRIMARY KEY (food_id);


--
-- Name: profile profile_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profile
    ADD CONSTRAINT profile_pkey PRIMARY KEY (profile_id);


--
-- Name: profile profile_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profile
    ADD CONSTRAINT profile_user_id_key UNIQUE (user_id);


--
-- Name: supplement_log supplement_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplement_log
    ADD CONSTRAINT supplement_log_pkey PRIMARY KEY (supplement_log_id);


--
-- Name: supplement supplement_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplement
    ADD CONSTRAINT supplement_pkey PRIMARY KEY (supplement_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users_logged_in users_logged_in_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_logged_in
    ADD CONSTRAINT users_logged_in_pkey PRIMARY KEY (id);


--
-- Name: users_logged_in users_logged_in_public_ip_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_logged_in
    ADD CONSTRAINT users_logged_in_public_ip_key UNIQUE (public_ip);


--
-- Name: users_logged_in users_logged_in_users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_logged_in
    ADD CONSTRAINT users_logged_in_users_email_key UNIQUE (users_email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: weight_log_bak weight_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weight_log_bak
    ADD CONSTRAINT weight_log_pkey PRIMARY KEY (weight_log_id);


--
-- Name: weight_log weight_log_pkey1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weight_log
    ADD CONSTRAINT weight_log_pkey1 PRIMARY KEY (weight_log_id);


--
-- Name: workout_log workout_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workout_log
    ADD CONSTRAINT workout_log_pkey PRIMARY KEY (workout_log_id);


--
-- Name: workout workout_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workout
    ADD CONSTRAINT workout_pkey PRIMARY KEY (workout_id);


--
-- Name: messages messages_payload_exclusive; Type: CHECK CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.messages
    ADD CONSTRAINT messages_payload_exclusive CHECK (((payload IS NULL) OR (binary_payload IS NULL))) NOT VALID;


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: buckets_vectors buckets_vectors_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_vectors
    ADD CONSTRAINT buckets_vectors_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: vector_indexes vector_indexes_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_pkey PRIMARY KEY (id);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: custom_oauth_providers_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_created_at_idx ON auth.custom_oauth_providers USING btree (created_at);


--
-- Name: custom_oauth_providers_enabled_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_enabled_idx ON auth.custom_oauth_providers USING btree (enabled);


--
-- Name: custom_oauth_providers_identifier_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_identifier_idx ON auth.custom_oauth_providers USING btree (identifier);


--
-- Name: custom_oauth_providers_provider_type_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_provider_type_idx ON auth.custom_oauth_providers USING btree (provider_type);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_oauth_client_states_created_at; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_oauth_client_states_created_at ON auth.oauth_client_states USING btree (created_at);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: idx_users_created_at_desc; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_users_created_at_desc ON auth.users USING btree (created_at DESC);


--
-- Name: idx_users_email; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_users_email ON auth.users USING btree (email);


--
-- Name: idx_users_last_sign_in_at_desc; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_users_last_sign_in_at_desc ON auth.users USING btree (last_sign_in_at DESC);


--
-- Name: idx_users_name; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_users_name ON auth.users USING btree (((raw_user_meta_data ->> 'name'::text))) WHERE ((raw_user_meta_data ->> 'name'::text) IS NOT NULL);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: oauth_auth_pending_exp_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_auth_pending_exp_idx ON auth.oauth_authorizations USING btree (expires_at) WHERE (status = 'pending'::auth.oauth_authorization_status);


--
-- Name: oauth_clients_deleted_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_clients_deleted_at_idx ON auth.oauth_clients USING btree (deleted_at);


--
-- Name: oauth_consents_active_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_client_idx ON auth.oauth_consents USING btree (client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_active_user_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_user_client_idx ON auth.oauth_consents USING btree (user_id, client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_user_order_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_user_order_idx ON auth.oauth_consents USING btree (user_id, granted_at DESC);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_oauth_client_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_oauth_client_id_idx ON auth.sessions USING btree (oauth_client_id);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: sso_providers_resource_id_pattern_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_providers_resource_id_pattern_idx ON auth.sso_providers USING btree (resource_id text_pattern_ops);


--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: webauthn_challenges_expires_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_challenges_expires_at_idx ON auth.webauthn_challenges USING btree (expires_at);


--
-- Name: webauthn_challenges_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_challenges_user_id_idx ON auth.webauthn_challenges USING btree (user_id);


--
-- Name: webauthn_credentials_credential_id_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX webauthn_credentials_credential_id_key ON auth.webauthn_credentials USING btree (credential_id);


--
-- Name: webauthn_credentials_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_credentials_user_id_idx ON auth.webauthn_credentials USING btree (user_id);


--
-- Name: food_active_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX food_active_idx ON public.food USING btree (is_active);


--
-- Name: food_log_datetime_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX food_log_datetime_idx ON public.food_log_bak USING btree (datetime);


--
-- Name: food_log_food_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX food_log_food_id_idx ON public.food_log_bak USING btree (food_id);


--
-- Name: food_log_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX food_log_user_id_idx ON public.food_log_bak USING btree (user_id);


--
-- Name: food_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX food_user_id_idx ON public.food USING btree (user_id);


--
-- Name: weight_log_date_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX weight_log_date_idx ON public.weight_log_bak USING btree (date);


--
-- Name: weight_log_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX weight_log_user_id_idx ON public.weight_log_bak USING btree (user_id);


--
-- Name: workout_active_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX workout_active_idx ON public.workout USING btree (is_active);


--
-- Name: workout_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX workout_user_id_idx ON public.workout USING btree (user_id);


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: messages_inserted_at_topic_index; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_inserted_at_topic_index ON ONLY realtime.messages USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: subscription_subscription_id_entity_filters_action_filter_selec; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_action_filter_selec ON realtime.subscription USING btree (subscription_id, entity, filters, action_filter, COALESCE(selected_columns, '{}'::text[]));


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: buckets_analytics_unique_name_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX buckets_analytics_unique_name_idx ON storage.buckets_analytics USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: idx_objects_bucket_id_name_lower; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name_lower ON storage.objects USING btree (bucket_id, lower(name) COLLATE "C");


--
-- Name: idx_objects_current_version; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX idx_objects_current_version ON storage.objects USING btree (bucket_id, name COLLATE "C") WHERE (archived_at IS NULL);


--
-- Name: idx_objects_null_version; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX idx_objects_null_version ON storage.objects USING btree (bucket_id, name COLLATE "C") WHERE (NOT is_versioned);


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: objects_bucket_id_name_version_key; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX objects_bucket_id_name_version_key ON storage.objects USING btree (bucket_id, name COLLATE "C", version) NULLS NOT DISTINCT;


--
-- Name: vector_indexes_name_bucket_id_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX vector_indexes_name_bucket_id_idx ON storage.vector_indexes USING btree (name, bucket_id);


--
-- Name: users on_auth_user_created; Type: TRIGGER; Schema: auth; Owner: supabase_auth_admin
--

CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- Name: buckets protect_buckets_delete; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_buckets_delete BEFORE DELETE ON storage.buckets FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects protect_objects_delete; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_objects_delete BEFORE DELETE ON storage.objects FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_oauth_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_oauth_client_id_fkey FOREIGN KEY (oauth_client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: webauthn_challenges webauthn_challenges_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: webauthn_credentials webauthn_credentials_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: feedback feedback_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feedback
    ADD CONSTRAINT feedback_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: food_log_bak food_log_food_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_log_bak
    ADD CONSTRAINT food_log_food_id_fkey FOREIGN KEY (food_id) REFERENCES public.food(food_id) ON DELETE CASCADE;


--
-- Name: food_log food_log_food_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_log
    ADD CONSTRAINT food_log_food_id_fkey1 FOREIGN KEY (food_id) REFERENCES public.food(food_id) ON DELETE CASCADE;


--
-- Name: food_log_bak food_log_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_log_bak
    ADD CONSTRAINT food_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: food_log food_log_user_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_log
    ADD CONSTRAINT food_log_user_id_fkey1 FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: food food_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food
    ADD CONSTRAINT food_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: profile profile_user_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profile
    ADD CONSTRAINT profile_user_fk FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: supplement_log supplement_log_supplement_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplement_log
    ADD CONSTRAINT supplement_log_supplement_id_fkey FOREIGN KEY (supplement_id) REFERENCES public.supplement(supplement_id) ON DELETE CASCADE;


--
-- Name: supplement_log supplement_log_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplement_log
    ADD CONSTRAINT supplement_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: supplement supplement_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplement
    ADD CONSTRAINT supplement_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: weight_log_bak weight_log_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weight_log_bak
    ADD CONSTRAINT weight_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: weight_log weight_log_user_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weight_log
    ADD CONSTRAINT weight_log_user_id_fkey1 FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: workout_log workout_log_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workout_log
    ADD CONSTRAINT workout_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: workout_log workout_log_workout_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workout_log
    ADD CONSTRAINT workout_log_workout_id_fkey FOREIGN KEY (workout_id) REFERENCES public.workout(workout_id) ON DELETE CASCADE;


--
-- Name: workout workout_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workout
    ADD CONSTRAINT workout_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: vector_indexes vector_indexes_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets_vectors(id);


--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- Name: feedback; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.feedback ENABLE ROW LEVEL SECURITY;

--
-- Name: feedback feedback_insert_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY feedback_insert_own ON public.feedback FOR INSERT WITH CHECK ((auth.uid() = user_id));


--
-- Name: feedback feedback_select_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY feedback_select_own ON public.feedback FOR SELECT USING ((auth.uid() = user_id));


--
-- Name: food; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.food ENABLE ROW LEVEL SECURITY;

--
-- Name: food food_delete_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY food_delete_own ON public.food FOR DELETE USING ((auth.uid() = user_id));


--
-- Name: food food_insert_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY food_insert_own ON public.food FOR INSERT WITH CHECK ((auth.uid() = user_id));


--
-- Name: food_log; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.food_log ENABLE ROW LEVEL SECURITY;

--
-- Name: food_log_bak; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.food_log_bak ENABLE ROW LEVEL SECURITY;

--
-- Name: food_log food_log_delete_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY food_log_delete_own ON public.food_log FOR DELETE USING ((auth.uid() = user_id));


--
-- Name: food_log food_log_insert_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY food_log_insert_own ON public.food_log FOR INSERT WITH CHECK ((auth.uid() = user_id));


--
-- Name: food_log food_log_select_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY food_log_select_own ON public.food_log FOR SELECT USING ((auth.uid() = user_id));


--
-- Name: food_log food_log_update_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY food_log_update_own ON public.food_log FOR UPDATE USING ((auth.uid() = user_id)) WITH CHECK ((auth.uid() = user_id));


--
-- Name: food food_select_own_or_shared; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY food_select_own_or_shared ON public.food FOR SELECT USING (((auth.uid() = user_id) OR (share_with_others = true)));


--
-- Name: food food_update_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY food_update_own ON public.food FOR UPDATE USING ((auth.uid() = user_id)) WITH CHECK ((auth.uid() = user_id));


--
-- Name: profile; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.profile ENABLE ROW LEVEL SECURITY;

--
-- Name: profile profile_delete_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY profile_delete_own ON public.profile FOR DELETE USING ((auth.uid() = user_id));


--
-- Name: profile profile_insert_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY profile_insert_own ON public.profile FOR INSERT WITH CHECK ((auth.uid() = user_id));


--
-- Name: profile profile_select_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY profile_select_own ON public.profile FOR SELECT USING ((auth.uid() = user_id));


--
-- Name: profile profile_update_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY profile_update_own ON public.profile FOR UPDATE USING ((auth.uid() = user_id)) WITH CHECK ((auth.uid() = user_id));


--
-- Name: supplement; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.supplement ENABLE ROW LEVEL SECURITY;

--
-- Name: supplement supplement_delete_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY supplement_delete_own ON public.supplement FOR DELETE USING ((auth.uid() = user_id));


--
-- Name: supplement supplement_insert_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY supplement_insert_own ON public.supplement FOR INSERT WITH CHECK ((auth.uid() = user_id));


--
-- Name: supplement_log; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.supplement_log ENABLE ROW LEVEL SECURITY;

--
-- Name: supplement_log supplement_log_delete_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY supplement_log_delete_own ON public.supplement_log FOR DELETE USING ((auth.uid() = user_id));


--
-- Name: supplement_log supplement_log_insert_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY supplement_log_insert_own ON public.supplement_log FOR INSERT WITH CHECK ((auth.uid() = user_id));


--
-- Name: supplement_log supplement_log_select_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY supplement_log_select_own ON public.supplement_log FOR SELECT USING ((auth.uid() = user_id));


--
-- Name: supplement_log supplement_log_update_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY supplement_log_update_own ON public.supplement_log FOR UPDATE USING ((auth.uid() = user_id)) WITH CHECK ((auth.uid() = user_id));


--
-- Name: supplement supplement_select_own_or_shared; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY supplement_select_own_or_shared ON public.supplement FOR SELECT USING (((auth.uid() = user_id) OR (share_with_others = true)));


--
-- Name: supplement supplement_update_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY supplement_update_own ON public.supplement FOR UPDATE USING ((auth.uid() = user_id)) WITH CHECK ((auth.uid() = user_id));


--
-- Name: users; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

--
-- Name: users_logged_in; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.users_logged_in ENABLE ROW LEVEL SECURITY;

--
-- Name: users users_select_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY users_select_own ON public.users FOR SELECT USING ((auth.uid() = user_id));


--
-- Name: users users_update_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY users_update_own ON public.users FOR UPDATE USING ((auth.uid() = user_id)) WITH CHECK ((auth.uid() = user_id));


--
-- Name: weight_log; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.weight_log ENABLE ROW LEVEL SECURITY;

--
-- Name: weight_log_bak; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.weight_log_bak ENABLE ROW LEVEL SECURITY;

--
-- Name: weight_log weight_log_delete_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY weight_log_delete_own ON public.weight_log FOR DELETE USING ((auth.uid() = user_id));


--
-- Name: weight_log weight_log_insert_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY weight_log_insert_own ON public.weight_log FOR INSERT WITH CHECK ((auth.uid() = user_id));


--
-- Name: weight_log weight_log_select_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY weight_log_select_own ON public.weight_log FOR SELECT USING ((auth.uid() = user_id));


--
-- Name: weight_log weight_log_update_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY weight_log_update_own ON public.weight_log FOR UPDATE USING ((auth.uid() = user_id)) WITH CHECK ((auth.uid() = user_id));


--
-- Name: workout; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.workout ENABLE ROW LEVEL SECURITY;

--
-- Name: workout workout_delete_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY workout_delete_own ON public.workout FOR DELETE USING ((auth.uid() = user_id));


--
-- Name: workout workout_insert_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY workout_insert_own ON public.workout FOR INSERT WITH CHECK ((auth.uid() = user_id));


--
-- Name: workout_log; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.workout_log ENABLE ROW LEVEL SECURITY;

--
-- Name: workout_log workout_log_delete_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY workout_log_delete_own ON public.workout_log FOR DELETE USING ((auth.uid() = user_id));


--
-- Name: workout_log workout_log_insert_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY workout_log_insert_own ON public.workout_log FOR INSERT WITH CHECK ((auth.uid() = user_id));


--
-- Name: workout_log workout_log_select_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY workout_log_select_own ON public.workout_log FOR SELECT USING ((auth.uid() = user_id));


--
-- Name: workout_log workout_log_update_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY workout_log_update_own ON public.workout_log FOR UPDATE USING ((auth.uid() = user_id)) WITH CHECK ((auth.uid() = user_id));


--
-- Name: workout workout_select_own_or_shared; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY workout_select_own_or_shared ON public.workout FOR SELECT USING (((auth.uid() = user_id) OR (share_with_others = true)));


--
-- Name: workout workout_update_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY workout_update_own ON public.workout FOR UPDATE USING ((auth.uid() = user_id)) WITH CHECK ((auth.uid() = user_id));


--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_vectors; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_vectors ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: vector_indexes; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.vector_indexes ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: postgres
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO postgres;

--
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL ON SCHEMA auth TO dashboard_user;
GRANT USAGE ON SCHEMA auth TO postgres;


--
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA realtime TO anon;
GRANT USAGE ON SCHEMA realtime TO service_role;
GRANT ALL ON SCHEMA realtime TO supabase_realtime_admin WITH GRANT OPTION;
GRANT USAGE ON SCHEMA realtime TO authenticated;


--
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA storage TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON SCHEMA storage TO dashboard_user;


--
-- Name: SCHEMA vault; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA vault TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA vault TO service_role;


--
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;


--
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.jwt() TO postgres;
GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;


--
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;


--
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;


--
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.armor(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO dashboard_user;


--
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.armor(bytea, text[], text[]) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO dashboard_user;


--
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.crypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.dearmor(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO dashboard_user;


--
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.digest(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.digest(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_random_bytes(integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO dashboard_user;


--
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_random_uuid() FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text, integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO dashboard_user;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_cron_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.grant_pg_graphql_access() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_net_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;


--
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.hmac(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.hmac(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO dashboard_user;


--
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO dashboard_user;


--
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_key_id(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgrst_ddl_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_ddl_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgrst_drop_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_drop_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.set_graphql_placeholder() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1mc() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v4() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_nil() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_dns() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_oid() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_url() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_x500() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;


--
-- Name: FUNCTION graphql("operationName" text, query text, variables jsonb, extensions jsonb); Type: ACL; Schema: graphql_public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO postgres;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO anon;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO authenticated;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO service_role;


--
-- Name: FUNCTION pg_reload_conf(); Type: ACL; Schema: pg_catalog; Owner: supabase_admin
--

GRANT ALL ON FUNCTION pg_catalog.pg_reload_conf() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;


--
-- Name: FUNCTION handle_new_user(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.handle_new_user() TO anon;
GRANT ALL ON FUNCTION public.handle_new_user() TO authenticated;
GRANT ALL ON FUNCTION public.handle_new_user() TO service_role;


--
-- Name: FUNCTION apply_rls(wal jsonb, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO service_role;


--
-- Name: FUNCTION broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO postgres;
GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO dashboard_user;


--
-- Name: FUNCTION build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO postgres;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO anon;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO service_role;


--
-- Name: FUNCTION "cast"(val text, type_ regtype); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO postgres;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO dashboard_user;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO anon;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO authenticated;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO service_role;


--
-- Name: FUNCTION check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO postgres;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO anon;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO authenticated;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO service_role;


--
-- Name: FUNCTION check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean) TO anon;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean) TO authenticated;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean) TO service_role;


--
-- Name: FUNCTION is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO postgres;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO anon;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO service_role;


--
-- Name: FUNCTION list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO dashboard_user;


--
-- Name: FUNCTION quote_wal2json(entity regclass); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO postgres;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO anon;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO authenticated;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO service_role;


--
-- Name: FUNCTION send(payload jsonb, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO dashboard_user;


--
-- Name: FUNCTION send_binary(payload bytea, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.send_binary(payload bytea, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send_binary(payload bytea, event text, topic text, private boolean) TO dashboard_user;


--
-- Name: FUNCTION subscription_check_filters(); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO postgres;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO dashboard_user;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO anon;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO authenticated;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO service_role;


--
-- Name: FUNCTION to_regrole(role_name text); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO postgres;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO anon;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO authenticated;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO service_role;


--
-- Name: FUNCTION topic(); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.topic() TO postgres;
GRANT ALL ON FUNCTION realtime.topic() TO dashboard_user;


--
-- Name: FUNCTION wal2json_escape_identifier(name text); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.wal2json_escape_identifier(name text) TO postgres;
GRANT ALL ON FUNCTION realtime.wal2json_escape_identifier(name text) TO dashboard_user;


--
-- Name: FUNCTION _crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO service_role;


--
-- Name: FUNCTION create_secret(new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: FUNCTION update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.audit_log_entries TO postgres;
GRANT SELECT ON TABLE auth.audit_log_entries TO postgres WITH GRANT OPTION;


--
-- Name: TABLE custom_oauth_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.custom_oauth_providers TO postgres;
GRANT ALL ON TABLE auth.custom_oauth_providers TO dashboard_user;


--
-- Name: TABLE flow_state; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.flow_state TO postgres;
GRANT SELECT ON TABLE auth.flow_state TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.flow_state TO dashboard_user;


--
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.identities TO postgres;
GRANT SELECT ON TABLE auth.identities TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.identities TO dashboard_user;


--
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.instances TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.instances TO postgres;
GRANT SELECT ON TABLE auth.instances TO postgres WITH GRANT OPTION;


--
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_amr_claims TO postgres;
GRANT SELECT ON TABLE auth.mfa_amr_claims TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_amr_claims TO dashboard_user;


--
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_challenges TO postgres;
GRANT SELECT ON TABLE auth.mfa_challenges TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_challenges TO dashboard_user;


--
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_factors TO postgres;
GRANT SELECT ON TABLE auth.mfa_factors TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_factors TO dashboard_user;


--
-- Name: TABLE oauth_authorizations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_authorizations TO postgres;
GRANT ALL ON TABLE auth.oauth_authorizations TO dashboard_user;


--
-- Name: TABLE oauth_client_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_client_states TO postgres;
GRANT ALL ON TABLE auth.oauth_client_states TO dashboard_user;


--
-- Name: TABLE oauth_clients; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_clients TO postgres;
GRANT ALL ON TABLE auth.oauth_clients TO dashboard_user;


--
-- Name: TABLE oauth_consents; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_consents TO postgres;
GRANT ALL ON TABLE auth.oauth_consents TO dashboard_user;


--
-- Name: TABLE one_time_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.one_time_tokens TO postgres;
GRANT SELECT ON TABLE auth.one_time_tokens TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.one_time_tokens TO dashboard_user;


--
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.refresh_tokens TO postgres;
GRANT SELECT ON TABLE auth.refresh_tokens TO postgres WITH GRANT OPTION;


--
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- Name: TABLE saml_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_providers TO postgres;
GRANT SELECT ON TABLE auth.saml_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_providers TO dashboard_user;


--
-- Name: TABLE saml_relay_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_relay_states TO postgres;
GRANT SELECT ON TABLE auth.saml_relay_states TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_relay_states TO dashboard_user;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT SELECT ON TABLE auth.schema_migrations TO postgres WITH GRANT OPTION;


--
-- Name: TABLE sessions; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sessions TO postgres;
GRANT SELECT ON TABLE auth.sessions TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sessions TO dashboard_user;


--
-- Name: TABLE sso_domains; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_domains TO postgres;
GRANT SELECT ON TABLE auth.sso_domains TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_domains TO dashboard_user;


--
-- Name: TABLE sso_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_providers TO postgres;
GRANT SELECT ON TABLE auth.sso_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_providers TO dashboard_user;


--
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.users TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.users TO postgres;
GRANT SELECT ON TABLE auth.users TO postgres WITH GRANT OPTION;


--
-- Name: TABLE webauthn_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.webauthn_challenges TO postgres;
GRANT ALL ON TABLE auth.webauthn_challenges TO dashboard_user;


--
-- Name: TABLE webauthn_credentials; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.webauthn_credentials TO postgres;
GRANT ALL ON TABLE auth.webauthn_credentials TO dashboard_user;


--
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements TO dashboard_user;


--
-- Name: TABLE pg_stat_statements_info; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements_info FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO dashboard_user;


--
-- Name: TABLE feedback; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.feedback TO anon;
GRANT ALL ON TABLE public.feedback TO authenticated;
GRANT ALL ON TABLE public.feedback TO service_role;


--
-- Name: SEQUENCE feedback_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.feedback_id_seq TO anon;
GRANT ALL ON SEQUENCE public.feedback_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.feedback_id_seq TO service_role;


--
-- Name: TABLE food; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.food TO anon;
GRANT ALL ON TABLE public.food TO authenticated;
GRANT ALL ON TABLE public.food TO service_role;


--
-- Name: SEQUENCE food_food_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.food_food_id_seq TO anon;
GRANT ALL ON SEQUENCE public.food_food_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.food_food_id_seq TO service_role;


--
-- Name: TABLE food_log; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.food_log TO anon;
GRANT ALL ON TABLE public.food_log TO authenticated;
GRANT ALL ON TABLE public.food_log TO service_role;


--
-- Name: TABLE food_log_bak; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.food_log_bak TO anon;
GRANT ALL ON TABLE public.food_log_bak TO authenticated;
GRANT ALL ON TABLE public.food_log_bak TO service_role;


--
-- Name: SEQUENCE food_log_food_log_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.food_log_food_log_id_seq TO anon;
GRANT ALL ON SEQUENCE public.food_log_food_log_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.food_log_food_log_id_seq TO service_role;


--
-- Name: SEQUENCE food_log_food_log_id_seq1; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.food_log_food_log_id_seq1 TO anon;
GRANT ALL ON SEQUENCE public.food_log_food_log_id_seq1 TO authenticated;
GRANT ALL ON SEQUENCE public.food_log_food_log_id_seq1 TO service_role;


--
-- Name: TABLE profile; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.profile TO anon;
GRANT ALL ON TABLE public.profile TO authenticated;
GRANT ALL ON TABLE public.profile TO service_role;


--
-- Name: SEQUENCE profile_profile_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.profile_profile_id_seq TO anon;
GRANT ALL ON SEQUENCE public.profile_profile_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.profile_profile_id_seq TO service_role;


--
-- Name: TABLE supplement; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.supplement TO anon;
GRANT ALL ON TABLE public.supplement TO authenticated;
GRANT ALL ON TABLE public.supplement TO service_role;


--
-- Name: TABLE supplement_log; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.supplement_log TO anon;
GRANT ALL ON TABLE public.supplement_log TO authenticated;
GRANT ALL ON TABLE public.supplement_log TO service_role;


--
-- Name: SEQUENCE supplement_log_supplement_log_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.supplement_log_supplement_log_id_seq TO anon;
GRANT ALL ON SEQUENCE public.supplement_log_supplement_log_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.supplement_log_supplement_log_id_seq TO service_role;


--
-- Name: SEQUENCE supplement_supplement_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.supplement_supplement_id_seq TO anon;
GRANT ALL ON SEQUENCE public.supplement_supplement_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.supplement_supplement_id_seq TO service_role;


--
-- Name: TABLE users; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.users TO anon;
GRANT ALL ON TABLE public.users TO authenticated;
GRANT ALL ON TABLE public.users TO service_role;


--
-- Name: TABLE users_logged_in; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.users_logged_in TO anon;
GRANT ALL ON TABLE public.users_logged_in TO authenticated;
GRANT ALL ON TABLE public.users_logged_in TO service_role;


--
-- Name: SEQUENCE users_logged_in_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.users_logged_in_id_seq TO anon;
GRANT ALL ON SEQUENCE public.users_logged_in_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.users_logged_in_id_seq TO service_role;


--
-- Name: TABLE weight_log; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.weight_log TO anon;
GRANT ALL ON TABLE public.weight_log TO authenticated;
GRANT ALL ON TABLE public.weight_log TO service_role;


--
-- Name: TABLE weight_log_bak; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.weight_log_bak TO anon;
GRANT ALL ON TABLE public.weight_log_bak TO authenticated;
GRANT ALL ON TABLE public.weight_log_bak TO service_role;


--
-- Name: SEQUENCE weight_log_weight_log_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.weight_log_weight_log_id_seq TO anon;
GRANT ALL ON SEQUENCE public.weight_log_weight_log_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.weight_log_weight_log_id_seq TO service_role;


--
-- Name: SEQUENCE weight_log_weight_log_id_seq1; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.weight_log_weight_log_id_seq1 TO anon;
GRANT ALL ON SEQUENCE public.weight_log_weight_log_id_seq1 TO authenticated;
GRANT ALL ON SEQUENCE public.weight_log_weight_log_id_seq1 TO service_role;


--
-- Name: TABLE workout; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.workout TO anon;
GRANT ALL ON TABLE public.workout TO authenticated;
GRANT ALL ON TABLE public.workout TO service_role;


--
-- Name: TABLE workout_log; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.workout_log TO anon;
GRANT ALL ON TABLE public.workout_log TO authenticated;
GRANT ALL ON TABLE public.workout_log TO service_role;


--
-- Name: SEQUENCE workout_log_workout_log_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.workout_log_workout_log_id_seq TO anon;
GRANT ALL ON SEQUENCE public.workout_log_workout_log_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.workout_log_workout_log_id_seq TO service_role;


--
-- Name: SEQUENCE workout_workout_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.workout_workout_id_seq TO anon;
GRANT ALL ON SEQUENCE public.workout_workout_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.workout_workout_id_seq TO service_role;


--
-- Name: TABLE messages; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages TO postgres;
GRANT ALL ON TABLE realtime.messages TO dashboard_user;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO anon;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO authenticated;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO service_role;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.schema_migrations TO postgres;
GRANT ALL ON TABLE realtime.schema_migrations TO dashboard_user;


--
-- Name: TABLE subscription; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.subscription TO postgres;
GRANT ALL ON TABLE realtime.subscription TO dashboard_user;
GRANT SELECT ON TABLE realtime.subscription TO anon;
GRANT SELECT ON TABLE realtime.subscription TO authenticated;
GRANT SELECT ON TABLE realtime.subscription TO service_role;


--
-- Name: SEQUENCE subscription_id_seq; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO postgres;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO dashboard_user;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO anon;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO authenticated;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO service_role;


--
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

REVOKE ALL ON TABLE storage.buckets FROM supabase_storage_admin;
GRANT ALL ON TABLE storage.buckets TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON TABLE storage.buckets TO service_role;
GRANT ALL ON TABLE storage.buckets TO authenticated;
GRANT ALL ON TABLE storage.buckets TO anon;
GRANT ALL ON TABLE storage.buckets TO postgres WITH GRANT OPTION;


--
-- Name: TABLE buckets_analytics; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets_analytics TO service_role;
GRANT ALL ON TABLE storage.buckets_analytics TO authenticated;
GRANT ALL ON TABLE storage.buckets_analytics TO anon;


--
-- Name: TABLE buckets_vectors; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.buckets_vectors TO service_role;
GRANT SELECT ON TABLE storage.buckets_vectors TO authenticated;
GRANT SELECT ON TABLE storage.buckets_vectors TO anon;


--
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

REVOKE ALL ON TABLE storage.objects FROM supabase_storage_admin;
GRANT ALL ON TABLE storage.objects TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON TABLE storage.objects TO service_role;
GRANT ALL ON TABLE storage.objects TO authenticated;
GRANT ALL ON TABLE storage.objects TO anon;
GRANT ALL ON TABLE storage.objects TO postgres WITH GRANT OPTION;


--
-- Name: TABLE s3_multipart_uploads; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO anon;


--
-- Name: TABLE s3_multipart_uploads_parts; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads_parts TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO anon;


--
-- Name: TABLE vector_indexes; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.vector_indexes TO service_role;
GRANT SELECT ON TABLE storage.vector_indexes TO authenticated;
GRANT SELECT ON TABLE storage.vector_indexes TO anon;


--
-- Name: TABLE secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.secrets TO service_role;


--
-- Name: TABLE decrypted_secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.decrypted_secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.decrypted_secrets TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON SEQUENCES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON FUNCTIONS TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON TABLES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO service_role;


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO supabase_admin;

--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO supabase_admin;

--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO supabase_admin;

--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO supabase_admin;

--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO supabase_admin;

--
-- PostgreSQL database dump complete
--

\unrestrict 26UsSiDdqrOksUpP8iFXWKThjNCCYNZbQJKjfjeEa2kwdgZSBx6iWE3ybbg6JId

