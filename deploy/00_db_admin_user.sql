CREATE ROLE enargit_quartz WITH
    LOGIN
    SUPERUSER
    CREATEDB
    CREATEROLE
    INHERIT
    REPLICATION
    BYPASSRLS
    CONNECTION LIMIT -1
    PASSWORD 'enargit_quartz';


CREATE ROLE enargit_quartz_anon WITH
    NOLOGIN
    NOSUPERUSER
    INHERIT
    NOCREATEDB
    NOCREATEROLE
    NOREPLICATION
    NOBYPASSRLS;

CREATE DATABASE enargit_quartz
    WITH
    OWNER = enargit_quartz
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.utf8'
    LC_CTYPE = 'en_US.utf8'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;


ALTER DATABASE enargit SET timezone = 'Europe/Berlin';


