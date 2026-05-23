--
-- PostgreSQL database dump
--

\restrict JRKu8WqLygOaVfGz7nBhd7JbrpRkobQpVkiaxAFbNWVLMpIAJg7d8g9lgILeTMV

-- Dumped from database version 17.7 (Debian 17.7-3.pgdg13+1)
-- Dumped by pg_dump version 17.9 (Debian 17.9-0+deb13u1)

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
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: jour_semaine; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.jour_semaine AS ENUM (
    'lundi',
    'mardi',
    'mercredi',
    'jeudi',
    'vendredi',
    'samedi',
    'dimanche'
);


ALTER TYPE public.jour_semaine OWNER TO postgres;

--
-- Name: statut_absence; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.statut_absence AS ENUM (
    'absent',
    'retard',
    'exclue'
);


ALTER TYPE public.statut_absence OWNER TO postgres;

--
-- Name: type_evaluation; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.type_evaluation AS ENUM (
    'controle',
    'examen',
    'devoir',
    'tp'
);


ALTER TYPE public.type_evaluation OWNER TO postgres;

--
-- PostgreSQL database dump complete
--

\unrestrict JRKu8WqLygOaVfGz7nBhd7JbrpRkobQpVkiaxAFbNWVLMpIAJg7d8g9lgILeTMV

