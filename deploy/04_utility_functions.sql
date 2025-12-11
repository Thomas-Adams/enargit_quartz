---------------------------------------------------------
---- Current name from JWT claims
---------------------------------------------------------
create or replace function current_name() returns text
    stable
    language plpgsql
as
$$
BEGIN
RETURN current_setting('request.jwt.claims', true)::json->>'name';
EXCEPTION
    WHEN OTHERS THEN
        RETURN NULL;
END;
$$;

alter function current_name() owner to enargit_quartz;
grant execute on function current_name() to enargit_quartz_anon;

---------------------------------------------------------
---- Current session_id from JWT claims
---------------------------------------------------------
create or replace function current_session_id() returns text
    stable
    language plpgsql
as
$$
BEGIN
RETURN current_setting('request.jwt.claims', true)::json->>'sid';
EXCEPTION
    WHEN OTHERS THEN
        RETURN NULL;
END;
$$;

alter function current_session_id() owner to enargit_quartz;
grant execute on function current_session_id() to enargit_quartz_anon;

---------------------------------------------------------
---- Current user_email from JWT claims
---------------------------------------------------------
create or replace function current_user_email() returns text
    stable
    language plpgsql
as
$$
BEGIN
RETURN current_setting('request.jwt.claims', true)::json->>'email';
EXCEPTION
    WHEN OTHERS THEN
        RETURN NULL;
END;
$$;

alter function current_user_email() owner to enargit_quartz;
grant execute on function current_user_email() to enargit_quartz_anon;
---------------------------------------------------------
---- Current user_roles from JWT claims
---------------------------------------------------------
create or replace function current_user_roles() returns text[]
    stable
    language plpgsql
as
$$
DECLARE
v_claims JSON;
    v_roles JSON;
BEGIN
    v_claims := current_setting('request.jwt.claims', true)::json;
    -- Keycloak stores roles in realm_access.roles
    v_roles := v_claims->'realm_access'->'roles';

    IF v_roles IS NOT NULL THEN
        RETURN ARRAY(SELECT json_array_elements_text(v_roles));
END IF;

RETURN ARRAY[]::TEXT[];
EXCEPTION
    WHEN OTHERS THEN
        RETURN ARRAY[]::TEXT[];
END;
$$;

alter function current_user_roles() owner to enargit_quartz;
grant execute on function current_user_roles() to enargit_quartz_anon;

---------------------------------------------------------
---- Current sub from JWT claims
---------------------------------------------------------
create or replace function current_user_sub() returns text
    stable
    language plpgsql
as
$$
BEGIN
RETURN current_setting('request.jwt.claims', true)::json->>'sub';
EXCEPTION
    WHEN OTHERS THEN
        RETURN NULL;
END;
$$;

alter function current_user_sub() owner to enargit_quartz;
grant execute on function current_user_sub() to enargit_quartz_anon;

---------------------------------------------------------
---- Current username from JWT claims
---------------------------------------------------------
create or replace function current_username() returns text
    stable
    language plpgsql
as
$$
BEGIN
RETURN COALESCE(
        current_setting('request.jwt.claims', true)::json->>'preferred_username',
            current_setting('request.jwt.claims', true)::json->>'email',
            current_setting('request.jwt.claims', true)::json->>'username',
            current_setting('request.jwt.claims', true)::json->>'sub'
           );
EXCEPTION
    WHEN OTHERS THEN
        RETURN NULL;
END;
$$;

alter function current_username() owner to enargit_quartz;
grant execute on function current_username() to enargit_quartz_anon;



---------------------------------------------------------
---- has roles  from JWT claims
---------------------------------------------------------
create or replace function has_role(role_name text) returns boolean
    stable
    language plpgsql
as
$$
BEGIN
RETURN role_name = ANY(current_user_roles());
END;
$$;

alter function has_role(text) owner to enargit_quartz;

grant execute on function has_role(text) to enargit_quartz_anon;