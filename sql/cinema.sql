--
-- PostgreSQL database dump
--

\restrict BdzCmAocVkPP5pNXEvAFhMRJW4o9Pun4fA7W2eKuhHL4giqYOT28lZ6Lps8RiyV

-- Dumped from database version 17.7 (Debian 17.7-0+deb13u1)
-- Dumped by pg_dump version 17.7 (Debian 17.7-0+deb13u1)

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
-- Name: generer_numero_reservation(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.generer_numero_reservation() RETURNS character varying
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN 'RES' || to_char(nextval('reservation_num_seq'), 'FM00000000000');
    -- Résultat : RES00000000001 → RES00000065432 etc...
END;
$$;


ALTER FUNCTION public.generer_numero_reservation() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: billet; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.billet (
    id integer NOT NULL,
    seance_id integer NOT NULL,
    place_id integer NOT NULL,
    tarif_id integer,
    prix_reel numeric(15,3) DEFAULT 0 NOT NULL,
    date_utilisation timestamp without time zone,
    statut integer,
    date_achat timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    reservation_id integer,
    type_personne_id integer
);


ALTER TABLE public.billet OWNER TO postgres;

--
-- Name: billet_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.billet_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.billet_id_seq OWNER TO postgres;

--
-- Name: billet_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.billet_id_seq OWNED BY public.billet.id;


--
-- Name: cinema; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cinema (
    id integer NOT NULL,
    nom character varying(200) NOT NULL,
    adresse character varying(200),
    email character varying(200),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.cinema OWNER TO postgres;

--
-- Name: cinema_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cinema_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cinema_id_seq OWNER TO postgres;

--
-- Name: cinema_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cinema_id_seq OWNED BY public.cinema.id;


--
-- Name: film; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.film (
    id integer NOT NULL,
    titre character varying(200) NOT NULL,
    realisateur character varying(200),
    acteurs text,
    duree_minutes integer NOT NULL,
    date_sortie date NOT NULL,
    synopsis text,
    url_affiche character varying(500),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.film OWNER TO postgres;

--
-- Name: film_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.film_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.film_id_seq OWNER TO postgres;

--
-- Name: film_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.film_id_seq OWNED BY public.film.id;


--
-- Name: historique; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.historique (
    id integer NOT NULL,
    table_name character(100) NOT NULL,
    cle_primaire integer NOT NULL,
    statut integer NOT NULL,
    date_modification timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.historique OWNER TO postgres;

--
-- Name: historique_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.historique_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.historique_id_seq OWNER TO postgres;

--
-- Name: historique_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.historique_id_seq OWNED BY public.historique.id;


--
-- Name: l_genre_film; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.l_genre_film (
    film_id integer NOT NULL,
    genre_id integer NOT NULL
);


ALTER TABLE public.l_genre_film OWNER TO postgres;

--
-- Name: paiement; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.paiement (
    id integer NOT NULL,
    reservation_id integer NOT NULL,
    methode_id smallint NOT NULL,
    reference character varying(100),
    montant numeric(15,3) NOT NULL,
    frais numeric(15,3),
    montant_net numeric(15,3),
    statut_id integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    completed_at timestamp without time zone,
    details_json jsonb,
    parent_paiement_id integer
);


ALTER TABLE public.paiement OWNER TO postgres;

--
-- Name: paiement_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.paiement_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.paiement_id_seq OWNER TO postgres;

--
-- Name: paiement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.paiement_id_seq OWNED BY public.paiement.id;


--
-- Name: paiement_methode; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.paiement_methode (
    id smallint NOT NULL,
    code character varying(20) NOT NULL,
    nom character varying(200) NOT NULL,
    actif boolean DEFAULT true,
    frais_pourcent numeric(5,2),
    ordre integer DEFAULT 0
);


ALTER TABLE public.paiement_methode OWNER TO postgres;

--
-- Name: paiement_methode_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.paiement_methode_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.paiement_methode_id_seq OWNER TO postgres;

--
-- Name: paiement_methode_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.paiement_methode_id_seq OWNED BY public.paiement_methode.id;


--
-- Name: place; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.place (
    id integer NOT NULL,
    rang integer NOT NULL,
    col integer NOT NULL,
    type_place_id integer,
    statut integer,
    salle_id integer,
    date_modification timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.place OWNER TO postgres;

--
-- Name: place_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.place_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.place_id_seq OWNER TO postgres;

--
-- Name: place_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.place_id_seq OWNED BY public.place.id;


--
-- Name: prix_billet; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.prix_billet (
    id smallint NOT NULL,
    type_place_id integer NOT NULL,
    type_personne_id integer,
    prix_base numeric(15,3),
    reduction numeric(15,3),
    date_prix timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    prix_reel numeric(15,3),
    actif boolean
);


ALTER TABLE public.prix_billet OWNER TO postgres;

--
-- Name: prix_billet_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.prix_billet_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.prix_billet_id_seq OWNER TO postgres;

--
-- Name: prix_billet_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.prix_billet_id_seq OWNED BY public.prix_billet.id;


--
-- Name: referentiel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.referentiel (
    id integer NOT NULL,
    categorie character varying(50) NOT NULL,
    nom character varying(200) NOT NULL,
    code character varying(15) NOT NULL,
    desce text
);


ALTER TABLE public.referentiel OWNER TO postgres;

--
-- Name: referenciel_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.referenciel_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.referenciel_id_seq OWNER TO postgres;

--
-- Name: referenciel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.referenciel_id_seq OWNED BY public.referentiel.id;


--
-- Name: reservation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reservation (
    id integer NOT NULL,
    numero character varying(15) DEFAULT public.generer_numero_reservation(),
    montant_total numeric(15,3) NOT NULL,
    date_creation timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    date_expiration timestamp without time zone,
    client_id integer,
    statut_id integer
);


ALTER TABLE public.reservation OWNER TO postgres;

--
-- Name: reservation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reservation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reservation_id_seq OWNER TO postgres;

--
-- Name: reservation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reservation_id_seq OWNED BY public.reservation.id;


--
-- Name: reservation_num_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reservation_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 10;


ALTER SEQUENCE public.reservation_num_seq OWNER TO postgres;

--
-- Name: salle; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.salle (
    id integer NOT NULL,
    numero character varying(15) NOT NULL,
    designation character varying(200) NOT NULL,
    capacite_total integer NOT NULL,
    cinema_id integer NOT NULL,
    nb_rangees integer,
    nb_colonnes integer
);


ALTER TABLE public.salle OWNER TO postgres;

--
-- Name: salle_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.salle_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.salle_id_seq OWNER TO postgres;

--
-- Name: salle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.salle_id_seq OWNED BY public.salle.id;


--
-- Name: seance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.seance (
    id integer NOT NULL,
    film_id integer NOT NULL,
    salle_id integer NOT NULL,
    debut timestamp without time zone NOT NULL,
    fin timestamp without time zone NOT NULL,
    format_id integer
);


ALTER TABLE public.seance OWNER TO postgres;

--
-- Name: sceance_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sceance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sceance_id_seq OWNER TO postgres;

--
-- Name: sceance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sceance_id_seq OWNED BY public.seance.id;


--
-- Name: statut; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.statut (
    id integer NOT NULL,
    code character varying(20) NOT NULL,
    nom character varying(100) NOT NULL,
    categorie character varying(20),
    desce text,
    ordre smallint DEFAULT 0
);


ALTER TABLE public.statut OWNER TO postgres;

--
-- Name: statut_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.statut_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.statut_id_seq OWNER TO postgres;

--
-- Name: statut_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.statut_id_seq OWNED BY public.statut.id;


--
-- Name: tarif; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tarif (
    id smallint NOT NULL,
    nom character varying(200) NOT NULL,
    prix_base numeric(15,3) NOT NULL,
    type_tarif_id integer,
    actif boolean
);


ALTER TABLE public.tarif OWNER TO postgres;

--
-- Name: tarif_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tarif_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tarif_id_seq OWNER TO postgres;

--
-- Name: tarif_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tarif_id_seq OWNED BY public.tarif.id;


--
-- Name: type_personne; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.type_personne (
    id integer NOT NULL,
    nom character varying(200) NOT NULL
);


ALTER TABLE public.type_personne OWNER TO postgres;

--
-- Name: type_personne_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.type_personne_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.type_personne_id_seq OWNER TO postgres;

--
-- Name: type_personne_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.type_personne_id_seq OWNED BY public.type_personne.id;


--
-- Name: type_place; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.type_place (
    id integer NOT NULL,
    nom character varying(200) NOT NULL,
    code character varying(15),
    desce text,
    prix numeric(15,3)
);


ALTER TABLE public.type_place OWNER TO postgres;

--
-- Name: type_place_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.type_place_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.type_place_id_seq OWNER TO postgres;

--
-- Name: type_place_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.type_place_id_seq OWNED BY public.type_place.id;


--
-- Name: type_place_prix; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.type_place_prix (
    id integer NOT NULL,
    prix_place numeric NOT NULL,
    type_place_id integer NOT NULL,
    type_personne_id integer NOT NULL,
    parent_id integer,
    reduction numeric(15,3)
);


ALTER TABLE public.type_place_prix OWNER TO postgres;

--
-- Name: type_place_prix_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.type_place_prix_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.type_place_prix_id_seq OWNER TO postgres;

--
-- Name: type_place_prix_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.type_place_prix_id_seq OWNED BY public.type_place_prix.id;


--
-- Name: v_place_billet; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_place_billet AS
 SELECT p.id,
    p.rang,
    p.col,
    p.type_place_id,
    p.statut,
    p.salle_id,
    b.seance_id AS seance,
    b.prix_reel,
    b.date_achat,
    b.date_utilisation,
    s.code AS statut_billet_code,
    s.nom AS statut_billet_nom,
    ps.code AS statut_place_code,
    ps.nom AS statut_place_nom
   FROM (((public.place p
     JOIN public.billet b ON ((p.id = b.place_id)))
     JOIN public.statut s ON ((b.statut = s.id)))
     JOIN public.statut ps ON ((p.statut = ps.id)));


ALTER VIEW public.v_place_billet OWNER TO postgres;

--
-- Name: billet id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billet ALTER COLUMN id SET DEFAULT nextval('public.billet_id_seq'::regclass);


--
-- Name: cinema id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cinema ALTER COLUMN id SET DEFAULT nextval('public.cinema_id_seq'::regclass);


--
-- Name: film id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.film ALTER COLUMN id SET DEFAULT nextval('public.film_id_seq'::regclass);


--
-- Name: historique id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historique ALTER COLUMN id SET DEFAULT nextval('public.historique_id_seq'::regclass);


--
-- Name: paiement id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paiement ALTER COLUMN id SET DEFAULT nextval('public.paiement_id_seq'::regclass);


--
-- Name: paiement_methode id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paiement_methode ALTER COLUMN id SET DEFAULT nextval('public.paiement_methode_id_seq'::regclass);


--
-- Name: place id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.place ALTER COLUMN id SET DEFAULT nextval('public.place_id_seq'::regclass);


--
-- Name: prix_billet id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prix_billet ALTER COLUMN id SET DEFAULT nextval('public.prix_billet_id_seq'::regclass);


--
-- Name: referentiel id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referentiel ALTER COLUMN id SET DEFAULT nextval('public.referenciel_id_seq'::regclass);


--
-- Name: reservation id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservation ALTER COLUMN id SET DEFAULT nextval('public.reservation_id_seq'::regclass);


--
-- Name: salle id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.salle ALTER COLUMN id SET DEFAULT nextval('public.salle_id_seq'::regclass);


--
-- Name: seance id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seance ALTER COLUMN id SET DEFAULT nextval('public.sceance_id_seq'::regclass);


--
-- Name: statut id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statut ALTER COLUMN id SET DEFAULT nextval('public.statut_id_seq'::regclass);


--
-- Name: tarif id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tarif ALTER COLUMN id SET DEFAULT nextval('public.tarif_id_seq'::regclass);


--
-- Name: type_personne id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.type_personne ALTER COLUMN id SET DEFAULT nextval('public.type_personne_id_seq'::regclass);


--
-- Name: type_place id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.type_place ALTER COLUMN id SET DEFAULT nextval('public.type_place_id_seq'::regclass);


--
-- Name: type_place_prix id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.type_place_prix ALTER COLUMN id SET DEFAULT nextval('public.type_place_prix_id_seq'::regclass);


--
-- Data for Name: billet; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.billet (id, seance_id, place_id, tarif_id, prix_reel, date_utilisation, statut, date_achat, reservation_id, type_personne_id) FROM stdin;
164	4	291	\N	25000.000	\N	17	2026-01-22 05:09:28.162128	\N	1
165	4	292	\N	25000.000	\N	17	2026-01-22 05:09:28.162128	\N	1
166	4	293	\N	45000.000	\N	17	2026-01-22 05:09:39.378724	\N	3
167	4	294	\N	45000.000	\N	17	2026-01-22 05:09:39.378724	\N	3
168	4	295	\N	45000.000	\N	17	2026-01-22 05:09:39.378724	\N	3
169	4	296	\N	45000.000	\N	17	2026-01-22 05:09:39.378724	\N	3
170	4	297	\N	45000.000	\N	17	2026-01-22 05:09:39.378724	\N	3
171	4	298	\N	45000.000	\N	17	2026-01-22 05:09:39.378724	\N	3
172	4	299	\N	45000.000	\N	17	2026-01-22 05:09:39.378724	\N	3
173	4	300	\N	45000.000	\N	17	2026-01-22 05:09:39.378724	\N	3
174	4	301	\N	45000.000	\N	17	2026-01-22 05:09:39.378724	\N	3
175	4	302	\N	45000.000	\N	17	2026-01-22 05:09:39.378724	\N	3
176	4	303	\N	50000.000	\N	17	2026-01-22 05:09:49.544789	\N	2
177	4	304	\N	50000.000	\N	17	2026-01-22 05:09:49.544789	\N	2
178	4	305	\N	50000.000	\N	17	2026-01-22 05:09:49.544789	\N	2
179	4	306	\N	50000.000	\N	17	2026-01-22 05:09:49.544789	\N	2
180	4	307	\N	50000.000	\N	17	2026-01-22 05:09:49.544789	\N	2
181	4	261	\N	40000.000	\N	17	2026-01-22 05:10:01.078591	\N	2
182	4	262	\N	40000.000	\N	17	2026-01-22 05:10:01.078591	\N	2
183	4	263	\N	40000.000	\N	17	2026-01-22 05:10:01.078591	\N	2
184	4	264	\N	40000.000	\N	17	2026-01-22 05:10:01.078591	\N	2
185	4	265	\N	40000.000	\N	17	2026-01-22 05:10:01.078591	\N	2
186	4	266	\N	40000.000	\N	17	2026-01-22 05:10:01.078591	\N	2
187	4	267	\N	40000.000	\N	17	2026-01-22 05:10:01.078591	\N	2
188	4	268	\N	40000.000	\N	17	2026-01-22 05:10:01.078591	\N	2
189	4	269	\N	40000.000	\N	17	2026-01-22 05:10:01.078591	\N	2
190	4	270	\N	40000.000	\N	17	2026-01-22 05:10:01.078591	\N	2
191	4	271	\N	30000.000	\N	17	2026-01-22 05:10:12.22443	\N	3
192	4	272	\N	30000.000	\N	17	2026-01-22 05:10:12.22443	\N	3
193	4	273	\N	30000.000	\N	17	2026-01-22 05:10:12.22443	\N	3
194	4	274	\N	30000.000	\N	17	2026-01-22 05:10:12.22443	\N	3
195	4	275	\N	30000.000	\N	17	2026-01-22 05:10:12.22443	\N	3
196	4	276	\N	30000.000	\N	17	2026-01-22 05:10:12.22443	\N	3
197	4	277	\N	30000.000	\N	17	2026-01-22 05:10:12.22443	\N	3
198	4	278	\N	30000.000	\N	17	2026-01-22 05:10:12.22443	\N	3
199	4	279	\N	30000.000	\N	17	2026-01-22 05:10:12.22443	\N	3
200	4	280	\N	30000.000	\N	17	2026-01-22 05:10:12.22443	\N	3
201	4	281	\N	20000.000	\N	17	2026-01-22 05:10:22.90722	\N	1
202	4	282	\N	20000.000	\N	17	2026-01-22 05:10:22.90722	\N	1
203	4	283	\N	20000.000	\N	17	2026-01-22 05:10:22.90722	\N	1
204	4	284	\N	20000.000	\N	17	2026-01-22 05:10:22.90722	\N	1
205	4	181	\N	15000.000	\N	17	2026-01-22 05:10:35.064742	\N	1
206	4	182	\N	15000.000	\N	17	2026-01-22 05:10:35.064742	\N	1
207	4	183	\N	15000.000	\N	17	2026-01-22 05:10:35.064742	\N	1
208	4	184	\N	15000.000	\N	17	2026-01-22 05:10:35.064742	\N	1
209	4	185	\N	15000.000	\N	17	2026-01-22 05:10:35.064742	\N	1
210	4	186	\N	15000.000	\N	17	2026-01-22 05:10:35.064742	\N	1
211	4	187	\N	15000.000	\N	17	2026-01-22 05:10:35.064742	\N	1
212	4	188	\N	15000.000	\N	17	2026-01-22 05:10:35.064742	\N	1
213	4	189	\N	15000.000	\N	17	2026-01-22 05:10:35.064742	\N	1
214	4	190	\N	15000.000	\N	17	2026-01-22 05:10:35.064742	\N	1
215	4	191	\N	20000.000	\N	17	2026-01-22 05:10:45.894757	\N	3
216	4	192	\N	20000.000	\N	17	2026-01-22 05:10:45.894757	\N	3
217	4	193	\N	20000.000	\N	17	2026-01-22 05:10:45.894757	\N	3
218	4	194	\N	20000.000	\N	17	2026-01-22 05:10:45.894757	\N	3
219	4	195	\N	20000.000	\N	17	2026-01-22 05:10:45.894757	\N	3
220	4	196	\N	20000.000	\N	17	2026-01-22 05:10:45.894757	\N	3
221	4	197	\N	20000.000	\N	17	2026-01-22 05:10:45.894757	\N	3
222	4	198	\N	20000.000	\N	17	2026-01-22 05:10:45.894757	\N	3
223	4	199	\N	20000.000	\N	17	2026-01-22 05:10:45.894757	\N	3
224	4	200	\N	20000.000	\N	17	2026-01-22 05:10:45.894757	\N	3
225	4	201	\N	20000.000	\N	17	2026-01-22 05:10:45.894757	\N	3
226	4	202	\N	20000.000	\N	17	2026-01-22 05:10:45.894757	\N	3
227	4	203	\N	20000.000	\N	17	2026-01-22 05:10:45.894757	\N	3
228	4	204	\N	20000.000	\N	17	2026-01-22 05:10:45.894757	\N	3
229	4	205	\N	20000.000	\N	17	2026-01-22 05:10:45.894757	\N	3
230	4	206	\N	20000.000	\N	17	2026-01-22 05:10:45.894757	\N	3
231	4	207	\N	20000.000	\N	17	2026-01-22 05:10:45.894757	\N	3
232	4	208	\N	20000.000	\N	17	2026-01-22 05:10:45.894757	\N	3
233	4	209	\N	20000.000	\N	17	2026-01-22 05:10:45.894757	\N	3
234	4	210	\N	20000.000	\N	17	2026-01-22 05:10:45.894757	\N	3
235	4	211	\N	30000.000	\N	17	2026-01-22 05:10:54.160339	\N	2
236	4	212	\N	30000.000	\N	17	2026-01-22 05:10:54.160339	\N	2
237	4	213	\N	30000.000	\N	17	2026-01-22 05:10:54.160339	\N	2
238	4	214	\N	30000.000	\N	17	2026-01-22 05:10:54.160339	\N	2
239	4	215	\N	30000.000	\N	17	2026-01-22 05:10:54.160339	\N	2
240	4	216	\N	30000.000	\N	17	2026-01-22 05:10:54.160339	\N	2
241	4	217	\N	30000.000	\N	17	2026-01-22 05:10:54.160339	\N	2
242	4	218	\N	30000.000	\N	17	2026-01-22 05:10:54.160339	\N	2
243	4	219	\N	30000.000	\N	17	2026-01-22 05:10:54.160339	\N	2
244	4	220	\N	30000.000	\N	17	2026-01-22 05:10:54.160339	\N	2
245	4	221	\N	30000.000	\N	17	2026-01-22 05:10:54.160339	\N	2
246	4	222	\N	30000.000	\N	17	2026-01-22 05:10:54.160339	\N	2
247	4	223	\N	30000.000	\N	17	2026-01-22 05:10:54.160339	\N	2
248	4	224	\N	30000.000	\N	17	2026-01-22 05:10:54.160339	\N	2
249	4	225	\N	30000.000	\N	17	2026-01-22 05:10:54.160339	\N	2
250	4	226	\N	30000.000	\N	17	2026-01-22 05:10:54.160339	\N	2
251	4	227	\N	30000.000	\N	17	2026-01-22 05:10:54.160339	\N	2
252	4	228	\N	30000.000	\N	17	2026-01-22 05:10:54.160339	\N	2
253	4	229	\N	30000.000	\N	17	2026-01-22 05:10:54.160339	\N	2
254	4	230	\N	30000.000	\N	17	2026-01-22 05:10:54.160339	\N	2
\.


--
-- Data for Name: cinema; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cinema (id, nom, adresse, email, created_at, updated_at) FROM stdin;
1	cinema 1	Antananarivo	cinema1Tana@example.com	2026-01-09 01:02:08.19346	2026-01-09 01:12:14.238548
\.


--
-- Data for Name: film; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.film (id, titre, realisateur, acteurs, duree_minutes, date_sortie, synopsis, url_affiche, created_at) FROM stdin;
1	film test			120	2026-01-01			2026-01-09 04:12:28.647049
2	film 1 			120	2026-01-01			2026-01-09 04:17:49.818966
3	Est eius occaecat co	Aut eaque dolor dolo	Animi itaque except	96	2013-03-14	Quas optio eligendi	Corrupti odit ipsa	2026-01-16 05:35:39.203354
\.


--
-- Data for Name: historique; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.historique (id, table_name, cle_primaire, statut, date_modification) FROM stdin;
354	place                                                                                               	81	4	2026-01-22 05:05:23.467616
78	place                                                                                               	81	7	2026-01-22 04:24:51.123325
355	place                                                                                               	82	4	2026-01-22 05:05:23.468866
80	place                                                                                               	82	7	2026-01-22 04:24:51.123325
456	billet                                                                                              	189	17	2026-01-22 05:10:01.078591
82	place                                                                                               	83	7	2026-01-22 04:25:06.658854
457	place                                                                                               	269	7	2026-01-22 05:10:01.078591
84	place                                                                                               	84	7	2026-01-22 04:25:06.658854
458	billet                                                                                              	190	17	2026-01-22 05:10:01.078591
86	place                                                                                               	85	7	2026-01-22 04:25:06.658854
459	place                                                                                               	270	7	2026-01-22 05:10:01.078591
88	place                                                                                               	86	7	2026-01-22 04:25:06.658854
460	billet                                                                                              	191	17	2026-01-22 05:10:12.22443
90	place                                                                                               	87	7	2026-01-22 04:25:27.34483
461	place                                                                                               	271	7	2026-01-22 05:10:12.22443
92	place                                                                                               	88	7	2026-01-22 04:25:27.34483
462	billet                                                                                              	192	17	2026-01-22 05:10:12.22443
94	place                                                                                               	89	7	2026-01-22 04:25:27.34483
463	place                                                                                               	272	7	2026-01-22 05:10:12.22443
96	place                                                                                               	90	7	2026-01-22 04:25:27.34483
464	billet                                                                                              	193	17	2026-01-22 05:10:12.22443
98	place                                                                                               	91	7	2026-01-22 04:25:27.34483
465	place                                                                                               	273	7	2026-01-22 05:10:12.22443
100	place                                                                                               	92	7	2026-01-22 04:25:27.34483
466	billet                                                                                              	194	17	2026-01-22 05:10:12.22443
102	place                                                                                               	93	7	2026-01-22 04:25:27.34483
467	place                                                                                               	274	7	2026-01-22 05:10:12.22443
104	place                                                                                               	94	7	2026-01-22 04:25:27.34483
468	billet                                                                                              	195	17	2026-01-22 05:10:12.22443
106	place                                                                                               	95	7	2026-01-22 04:25:27.34483
469	place                                                                                               	275	7	2026-01-22 05:10:12.22443
108	place                                                                                               	96	7	2026-01-22 04:25:27.34483
470	billet                                                                                              	196	17	2026-01-22 05:10:12.22443
110	place                                                                                               	97	7	2026-01-22 04:25:47.973816
471	place                                                                                               	276	7	2026-01-22 05:10:12.22443
112	place                                                                                               	98	7	2026-01-22 04:25:47.973816
472	billet                                                                                              	197	17	2026-01-22 05:10:12.22443
114	place                                                                                               	99	7	2026-01-22 04:25:47.973816
473	place                                                                                               	277	7	2026-01-22 05:10:12.22443
116	place                                                                                               	100	7	2026-01-22 04:25:47.973816
474	billet                                                                                              	198	17	2026-01-22 05:10:12.22443
118	place                                                                                               	101	7	2026-01-22 04:25:47.973816
475	place                                                                                               	278	7	2026-01-22 05:10:12.22443
120	place                                                                                               	102	7	2026-01-22 04:25:47.973816
476	billet                                                                                              	199	17	2026-01-22 05:10:12.22443
122	place                                                                                               	103	7	2026-01-22 04:25:47.973816
477	place                                                                                               	279	7	2026-01-22 05:10:12.22443
124	place                                                                                               	104	7	2026-01-22 04:25:47.973816
478	billet                                                                                              	200	17	2026-01-22 05:10:12.22443
126	place                                                                                               	105	7	2026-01-22 04:25:47.973816
479	place                                                                                               	280	7	2026-01-22 05:10:12.22443
128	place                                                                                               	106	7	2026-01-22 04:25:47.973816
356	billet                                                                                              	139	17	2026-01-22 05:05:37.601076
130	place                                                                                               	107	7	2026-01-22 04:26:06.840096
357	place                                                                                               	81	7	2026-01-22 05:05:37.601076
132	place                                                                                               	108	7	2026-01-22 04:26:06.840096
358	billet                                                                                              	140	17	2026-01-22 05:05:37.601076
134	place                                                                                               	109	7	2026-01-22 04:26:06.840096
359	place                                                                                               	171	7	2026-01-22 05:05:37.601076
136	place                                                                                               	110	7	2026-01-22 04:26:06.840096
360	billet                                                                                              	141	17	2026-01-22 05:06:07.65849
138	place                                                                                               	111	7	2026-01-22 04:26:06.840096
361	place                                                                                               	151	7	2026-01-22 05:06:07.65849
140	place                                                                                               	112	7	2026-01-22 04:26:06.840096
362	billet                                                                                              	142	17	2026-01-22 05:06:07.65849
142	place                                                                                               	113	7	2026-01-22 04:26:06.840096
363	place                                                                                               	152	7	2026-01-22 05:06:07.65849
144	place                                                                                               	114	7	2026-01-22 04:26:06.840096
364	billet                                                                                              	143	17	2026-01-22 05:06:07.65849
146	place                                                                                               	115	7	2026-01-22 04:26:06.840096
365	place                                                                                               	153	7	2026-01-22 05:06:07.65849
148	place                                                                                               	116	7	2026-01-22 04:26:06.840096
366	billet                                                                                              	144	17	2026-01-22 05:06:07.65849
150	place                                                                                               	117	7	2026-01-22 04:26:17.910097
367	place                                                                                               	154	7	2026-01-22 05:06:07.65849
152	place                                                                                               	118	7	2026-01-22 04:26:17.910097
368	billet                                                                                              	145	17	2026-01-22 05:06:17.0845
154	place                                                                                               	119	7	2026-01-22 04:26:17.910097
369	place                                                                                               	82	7	2026-01-22 05:06:17.0845
156	place                                                                                               	120	7	2026-01-22 04:26:17.910097
370	billet                                                                                              	146	17	2026-01-22 05:06:17.0845
158	place                                                                                               	121	7	2026-01-22 04:26:17.910097
371	place                                                                                               	83	7	2026-01-22 05:06:17.0845
160	place                                                                                               	122	7	2026-01-22 04:26:17.910097
372	billet                                                                                              	147	17	2026-01-22 05:06:17.0845
162	place                                                                                               	123	7	2026-01-22 04:26:17.910097
373	place                                                                                               	84	7	2026-01-22 05:06:17.0845
164	place                                                                                               	124	7	2026-01-22 04:26:17.910097
374	billet                                                                                              	148	17	2026-01-22 05:06:17.0845
166	place                                                                                               	125	7	2026-01-22 04:26:17.910097
375	place                                                                                               	85	7	2026-01-22 05:06:17.0845
168	place                                                                                               	126	7	2026-01-22 04:26:17.910097
376	billet                                                                                              	149	17	2026-01-22 05:06:17.0845
170	place                                                                                               	127	7	2026-01-22 04:26:17.910097
377	place                                                                                               	86	7	2026-01-22 05:06:17.0845
172	place                                                                                               	128	7	2026-01-22 04:26:17.910097
378	billet                                                                                              	150	17	2026-01-22 05:06:17.0845
174	place                                                                                               	129	7	2026-01-22 04:26:17.910097
379	place                                                                                               	87	7	2026-01-22 05:06:17.0845
176	place                                                                                               	130	7	2026-01-22 04:26:17.910097
380	billet                                                                                              	151	17	2026-01-22 05:06:17.0845
178	place                                                                                               	131	7	2026-01-22 04:26:17.910097
381	place                                                                                               	88	7	2026-01-22 05:06:17.0845
180	place                                                                                               	132	7	2026-01-22 04:26:17.910097
382	billet                                                                                              	152	17	2026-01-22 05:06:17.0845
182	place                                                                                               	133	7	2026-01-22 04:26:17.910097
383	place                                                                                               	89	7	2026-01-22 05:06:17.0845
184	place                                                                                               	134	7	2026-01-22 04:26:17.910097
384	billet                                                                                              	153	17	2026-01-22 05:06:17.0845
186	place                                                                                               	135	7	2026-01-22 04:26:17.910097
385	place                                                                                               	90	7	2026-01-22 05:06:17.0845
188	place                                                                                               	136	7	2026-01-22 04:26:17.910097
386	billet                                                                                              	154	17	2026-01-22 05:06:17.0845
190	place                                                                                               	137	7	2026-01-22 04:26:33.524897
387	place                                                                                               	91	7	2026-01-22 05:06:17.0845
192	place                                                                                               	138	7	2026-01-22 04:26:33.524897
388	billet                                                                                              	155	17	2026-01-22 05:06:50.629068
194	place                                                                                               	139	7	2026-01-22 04:26:33.524897
389	place                                                                                               	172	7	2026-01-22 05:06:50.629068
196	place                                                                                               	140	7	2026-01-22 04:26:33.524897
390	billet                                                                                              	156	17	2026-01-22 05:06:50.629068
198	place                                                                                               	141	7	2026-01-22 04:26:33.524897
391	place                                                                                               	173	7	2026-01-22 05:06:50.629068
200	place                                                                                               	142	7	2026-01-22 04:26:51.824464
392	billet                                                                                              	157	17	2026-01-22 05:06:50.629068
202	place                                                                                               	143	7	2026-01-22 04:26:51.824464
393	place                                                                                               	174	7	2026-01-22 05:06:50.629068
204	place                                                                                               	144	7	2026-01-22 04:26:51.824464
394	billet                                                                                              	158	17	2026-01-22 05:06:50.629068
206	place                                                                                               	145	7	2026-01-22 04:26:51.824464
395	place                                                                                               	175	7	2026-01-22 05:06:50.629068
208	place                                                                                               	146	7	2026-01-22 04:26:51.824464
396	billet                                                                                              	159	17	2026-01-22 05:06:50.629068
210	place                                                                                               	147	7	2026-01-22 04:26:51.824464
397	place                                                                                               	176	7	2026-01-22 05:06:50.629068
212	place                                                                                               	148	7	2026-01-22 04:26:51.824464
398	billet                                                                                              	160	17	2026-01-22 05:06:50.629068
214	place                                                                                               	149	7	2026-01-22 04:26:51.824464
399	place                                                                                               	177	7	2026-01-22 05:06:50.629068
216	place                                                                                               	150	7	2026-01-22 04:26:51.824464
400	billet                                                                                              	161	17	2026-01-22 05:06:50.629068
218	place                                                                                               	151	7	2026-01-22 04:26:51.824464
401	place                                                                                               	178	7	2026-01-22 05:06:50.629068
220	place                                                                                               	152	7	2026-01-22 04:27:10.272691
402	billet                                                                                              	162	17	2026-01-22 05:06:50.629068
222	place                                                                                               	153	7	2026-01-22 04:27:10.272691
403	place                                                                                               	179	7	2026-01-22 05:06:50.629068
224	place                                                                                               	154	7	2026-01-22 04:27:10.272691
404	billet                                                                                              	163	17	2026-01-22 05:06:50.629068
226	place                                                                                               	155	7	2026-01-22 04:27:10.272691
405	place                                                                                               	180	7	2026-01-22 05:06:50.629068
228	place                                                                                               	156	7	2026-01-22 04:27:10.272691
406	billet                                                                                              	164	17	2026-01-22 05:09:28.162128
230	place                                                                                               	157	7	2026-01-22 04:27:10.272691
407	place                                                                                               	291	7	2026-01-22 05:09:28.162128
232	place                                                                                               	158	7	2026-01-22 04:27:10.272691
408	billet                                                                                              	165	17	2026-01-22 05:09:28.162128
234	place                                                                                               	159	7	2026-01-22 04:27:10.272691
409	place                                                                                               	292	7	2026-01-22 05:09:28.162128
236	place                                                                                               	160	7	2026-01-22 04:27:10.272691
410	billet                                                                                              	166	17	2026-01-22 05:09:39.378724
238	place                                                                                               	161	7	2026-01-22 04:27:10.272691
411	place                                                                                               	293	7	2026-01-22 05:09:39.378724
240	place                                                                                               	162	7	2026-01-22 04:27:10.272691
412	billet                                                                                              	167	17	2026-01-22 05:09:39.378724
242	place                                                                                               	163	7	2026-01-22 04:27:10.272691
413	place                                                                                               	294	7	2026-01-22 05:09:39.378724
244	place                                                                                               	164	7	2026-01-22 04:27:10.272691
414	billet                                                                                              	168	17	2026-01-22 05:09:39.378724
246	place                                                                                               	165	7	2026-01-22 04:27:10.272691
415	place                                                                                               	295	7	2026-01-22 05:09:39.378724
248	place                                                                                               	166	7	2026-01-22 04:27:10.272691
416	billet                                                                                              	169	17	2026-01-22 05:09:39.378724
250	place                                                                                               	167	7	2026-01-22 04:27:10.272691
417	place                                                                                               	296	7	2026-01-22 05:09:39.378724
252	place                                                                                               	168	7	2026-01-22 04:27:10.272691
418	billet                                                                                              	170	17	2026-01-22 05:09:39.378724
254	place                                                                                               	169	7	2026-01-22 04:27:10.272691
419	place                                                                                               	297	7	2026-01-22 05:09:39.378724
256	place                                                                                               	170	7	2026-01-22 04:27:10.272691
420	billet                                                                                              	171	17	2026-01-22 05:09:39.378724
258	place                                                                                               	171	7	2026-01-22 04:27:10.272691
259	place                                                                                               	81	4	2026-01-22 05:01:15.335275
260	place                                                                                               	82	4	2026-01-22 05:01:15.337447
261	place                                                                                               	83	4	2026-01-22 05:01:15.338635
262	place                                                                                               	84	4	2026-01-22 05:01:15.33973
263	place                                                                                               	85	4	2026-01-22 05:01:15.340838
264	place                                                                                               	86	4	2026-01-22 05:01:15.342168
265	place                                                                                               	87	4	2026-01-22 05:01:15.34336
266	place                                                                                               	88	4	2026-01-22 05:01:15.344656
267	place                                                                                               	89	4	2026-01-22 05:01:15.345168
268	place                                                                                               	90	4	2026-01-22 05:01:15.345584
269	place                                                                                               	91	4	2026-01-22 05:01:15.345951
270	place                                                                                               	92	4	2026-01-22 05:01:15.346296
271	place                                                                                               	93	4	2026-01-22 05:01:15.346667
272	place                                                                                               	94	4	2026-01-22 05:01:15.347003
273	place                                                                                               	95	4	2026-01-22 05:01:15.347314
274	place                                                                                               	96	4	2026-01-22 05:01:15.347623
275	place                                                                                               	97	4	2026-01-22 05:01:15.348175
276	place                                                                                               	98	4	2026-01-22 05:01:15.348535
277	place                                                                                               	99	4	2026-01-22 05:01:15.349044
278	place                                                                                               	100	4	2026-01-22 05:01:15.349398
279	place                                                                                               	101	4	2026-01-22 05:01:15.349739
280	place                                                                                               	102	4	2026-01-22 05:01:15.350074
281	place                                                                                               	103	4	2026-01-22 05:01:15.350397
282	place                                                                                               	104	4	2026-01-22 05:01:15.350799
283	place                                                                                               	105	4	2026-01-22 05:01:15.35112
284	place                                                                                               	106	4	2026-01-22 05:01:15.351428
285	place                                                                                               	107	4	2026-01-22 05:01:15.351784
286	place                                                                                               	108	4	2026-01-22 05:01:15.352178
287	place                                                                                               	109	4	2026-01-22 05:01:15.352486
288	place                                                                                               	110	4	2026-01-22 05:01:15.352913
289	place                                                                                               	111	4	2026-01-22 05:01:15.353272
290	place                                                                                               	112	4	2026-01-22 05:01:15.353585
291	place                                                                                               	113	4	2026-01-22 05:01:15.353911
292	place                                                                                               	114	4	2026-01-22 05:01:15.354219
293	place                                                                                               	115	4	2026-01-22 05:01:15.354539
294	place                                                                                               	116	4	2026-01-22 05:01:15.35485
295	place                                                                                               	137	4	2026-01-22 05:01:15.355166
296	place                                                                                               	138	4	2026-01-22 05:01:15.355548
297	place                                                                                               	139	4	2026-01-22 05:01:15.356037
298	place                                                                                               	140	4	2026-01-22 05:01:15.35654
299	place                                                                                               	141	4	2026-01-22 05:01:15.357422
300	place                                                                                               	142	4	2026-01-22 05:01:15.357942
301	place                                                                                               	143	4	2026-01-22 05:01:15.358773
302	place                                                                                               	144	4	2026-01-22 05:01:15.359538
303	place                                                                                               	145	4	2026-01-22 05:01:15.360131
304	place                                                                                               	146	4	2026-01-22 05:01:15.360656
305	place                                                                                               	147	4	2026-01-22 05:01:15.361122
306	place                                                                                               	148	4	2026-01-22 05:01:15.36173
307	place                                                                                               	149	4	2026-01-22 05:01:15.362258
308	place                                                                                               	150	4	2026-01-22 05:01:15.362876
309	place                                                                                               	151	4	2026-01-22 05:01:15.363585
310	place                                                                                               	152	4	2026-01-22 05:01:15.364378
311	place                                                                                               	153	4	2026-01-22 05:01:15.36491
312	place                                                                                               	154	4	2026-01-22 05:01:15.365448
313	place                                                                                               	155	4	2026-01-22 05:01:15.365904
314	place                                                                                               	156	4	2026-01-22 05:01:15.366378
315	place                                                                                               	157	4	2026-01-22 05:01:15.366821
316	place                                                                                               	158	4	2026-01-22 05:01:15.402806
317	place                                                                                               	159	4	2026-01-22 05:01:15.405018
318	place                                                                                               	160	4	2026-01-22 05:01:15.406272
319	place                                                                                               	161	4	2026-01-22 05:01:15.407657
320	place                                                                                               	162	4	2026-01-22 05:01:15.409933
321	place                                                                                               	163	4	2026-01-22 05:01:15.413339
322	place                                                                                               	164	4	2026-01-22 05:01:15.415934
323	place                                                                                               	165	4	2026-01-22 05:01:15.417402
324	place                                                                                               	166	4	2026-01-22 05:01:15.418161
325	place                                                                                               	167	4	2026-01-22 05:01:15.418904
326	place                                                                                               	168	4	2026-01-22 05:01:15.4196
327	place                                                                                               	169	4	2026-01-22 05:01:15.420271
328	place                                                                                               	170	4	2026-01-22 05:01:15.420911
329	place                                                                                               	171	4	2026-01-22 05:01:15.421514
330	place                                                                                               	117	4	2026-01-22 05:01:15.422415
331	place                                                                                               	118	4	2026-01-22 05:01:15.423181
332	place                                                                                               	119	4	2026-01-22 05:01:15.423785
333	place                                                                                               	120	4	2026-01-22 05:01:15.424408
334	place                                                                                               	121	4	2026-01-22 05:01:15.425769
335	place                                                                                               	122	4	2026-01-22 05:01:15.427803
336	place                                                                                               	123	4	2026-01-22 05:01:15.430119
337	place                                                                                               	124	4	2026-01-22 05:01:15.431361
338	place                                                                                               	125	4	2026-01-22 05:01:15.431801
339	place                                                                                               	126	4	2026-01-22 05:01:15.432272
340	place                                                                                               	127	4	2026-01-22 05:01:15.432661
341	place                                                                                               	128	4	2026-01-22 05:01:15.432982
342	place                                                                                               	129	4	2026-01-22 05:01:15.433296
343	place                                                                                               	130	4	2026-01-22 05:01:15.433672
344	place                                                                                               	131	4	2026-01-22 05:01:15.43399
345	place                                                                                               	132	4	2026-01-22 05:01:15.434319
346	place                                                                                               	133	4	2026-01-22 05:01:15.434655
347	place                                                                                               	134	4	2026-01-22 05:01:15.434958
348	place                                                                                               	135	4	2026-01-22 05:01:15.43526
349	place                                                                                               	136	4	2026-01-22 05:01:15.435564
351	place                                                                                               	81	7	2026-01-22 05:01:32.371655
353	place                                                                                               	82	7	2026-01-22 05:01:32.371655
421	place                                                                                               	298	7	2026-01-22 05:09:39.378724
422	billet                                                                                              	172	17	2026-01-22 05:09:39.378724
423	place                                                                                               	299	7	2026-01-22 05:09:39.378724
424	billet                                                                                              	173	17	2026-01-22 05:09:39.378724
425	place                                                                                               	300	7	2026-01-22 05:09:39.378724
426	billet                                                                                              	174	17	2026-01-22 05:09:39.378724
427	place                                                                                               	301	7	2026-01-22 05:09:39.378724
428	billet                                                                                              	175	17	2026-01-22 05:09:39.378724
429	place                                                                                               	302	7	2026-01-22 05:09:39.378724
430	billet                                                                                              	176	17	2026-01-22 05:09:49.544789
431	place                                                                                               	303	7	2026-01-22 05:09:49.544789
432	billet                                                                                              	177	17	2026-01-22 05:09:49.544789
433	place                                                                                               	304	7	2026-01-22 05:09:49.544789
434	billet                                                                                              	178	17	2026-01-22 05:09:49.544789
435	place                                                                                               	305	7	2026-01-22 05:09:49.544789
436	billet                                                                                              	179	17	2026-01-22 05:09:49.544789
437	place                                                                                               	306	7	2026-01-22 05:09:49.544789
438	billet                                                                                              	180	17	2026-01-22 05:09:49.544789
439	place                                                                                               	307	7	2026-01-22 05:09:49.544789
440	billet                                                                                              	181	17	2026-01-22 05:10:01.078591
441	place                                                                                               	261	7	2026-01-22 05:10:01.078591
442	billet                                                                                              	182	17	2026-01-22 05:10:01.078591
443	place                                                                                               	262	7	2026-01-22 05:10:01.078591
444	billet                                                                                              	183	17	2026-01-22 05:10:01.078591
445	place                                                                                               	263	7	2026-01-22 05:10:01.078591
446	billet                                                                                              	184	17	2026-01-22 05:10:01.078591
447	place                                                                                               	264	7	2026-01-22 05:10:01.078591
448	billet                                                                                              	185	17	2026-01-22 05:10:01.078591
449	place                                                                                               	265	7	2026-01-22 05:10:01.078591
450	billet                                                                                              	186	17	2026-01-22 05:10:01.078591
451	place                                                                                               	266	7	2026-01-22 05:10:01.078591
452	billet                                                                                              	187	17	2026-01-22 05:10:01.078591
453	place                                                                                               	267	7	2026-01-22 05:10:01.078591
454	billet                                                                                              	188	17	2026-01-22 05:10:01.078591
455	place                                                                                               	268	7	2026-01-22 05:10:01.078591
480	billet                                                                                              	201	17	2026-01-22 05:10:22.90722
481	place                                                                                               	281	7	2026-01-22 05:10:22.90722
482	billet                                                                                              	202	17	2026-01-22 05:10:22.90722
483	place                                                                                               	282	7	2026-01-22 05:10:22.90722
484	billet                                                                                              	203	17	2026-01-22 05:10:22.90722
485	place                                                                                               	283	7	2026-01-22 05:10:22.90722
486	billet                                                                                              	204	17	2026-01-22 05:10:22.90722
487	place                                                                                               	284	7	2026-01-22 05:10:22.90722
488	billet                                                                                              	205	17	2026-01-22 05:10:35.064742
489	place                                                                                               	181	7	2026-01-22 05:10:35.064742
490	billet                                                                                              	206	17	2026-01-22 05:10:35.064742
491	place                                                                                               	182	7	2026-01-22 05:10:35.064742
492	billet                                                                                              	207	17	2026-01-22 05:10:35.064742
493	place                                                                                               	183	7	2026-01-22 05:10:35.064742
494	billet                                                                                              	208	17	2026-01-22 05:10:35.064742
495	place                                                                                               	184	7	2026-01-22 05:10:35.064742
496	billet                                                                                              	209	17	2026-01-22 05:10:35.064742
497	place                                                                                               	185	7	2026-01-22 05:10:35.064742
498	billet                                                                                              	210	17	2026-01-22 05:10:35.064742
499	place                                                                                               	186	7	2026-01-22 05:10:35.064742
500	billet                                                                                              	211	17	2026-01-22 05:10:35.064742
501	place                                                                                               	187	7	2026-01-22 05:10:35.064742
502	billet                                                                                              	212	17	2026-01-22 05:10:35.064742
503	place                                                                                               	188	7	2026-01-22 05:10:35.064742
504	billet                                                                                              	213	17	2026-01-22 05:10:35.064742
505	place                                                                                               	189	7	2026-01-22 05:10:35.064742
506	billet                                                                                              	214	17	2026-01-22 05:10:35.064742
507	place                                                                                               	190	7	2026-01-22 05:10:35.064742
508	billet                                                                                              	215	17	2026-01-22 05:10:45.894757
509	place                                                                                               	191	7	2026-01-22 05:10:45.894757
510	billet                                                                                              	216	17	2026-01-22 05:10:45.894757
511	place                                                                                               	192	7	2026-01-22 05:10:45.894757
512	billet                                                                                              	217	17	2026-01-22 05:10:45.894757
513	place                                                                                               	193	7	2026-01-22 05:10:45.894757
514	billet                                                                                              	218	17	2026-01-22 05:10:45.894757
515	place                                                                                               	194	7	2026-01-22 05:10:45.894757
516	billet                                                                                              	219	17	2026-01-22 05:10:45.894757
517	place                                                                                               	195	7	2026-01-22 05:10:45.894757
518	billet                                                                                              	220	17	2026-01-22 05:10:45.894757
519	place                                                                                               	196	7	2026-01-22 05:10:45.894757
520	billet                                                                                              	221	17	2026-01-22 05:10:45.894757
521	place                                                                                               	197	7	2026-01-22 05:10:45.894757
522	billet                                                                                              	222	17	2026-01-22 05:10:45.894757
523	place                                                                                               	198	7	2026-01-22 05:10:45.894757
524	billet                                                                                              	223	17	2026-01-22 05:10:45.894757
525	place                                                                                               	199	7	2026-01-22 05:10:45.894757
526	billet                                                                                              	224	17	2026-01-22 05:10:45.894757
527	place                                                                                               	200	7	2026-01-22 05:10:45.894757
528	billet                                                                                              	225	17	2026-01-22 05:10:45.894757
529	place                                                                                               	201	7	2026-01-22 05:10:45.894757
530	billet                                                                                              	226	17	2026-01-22 05:10:45.894757
531	place                                                                                               	202	7	2026-01-22 05:10:45.894757
532	billet                                                                                              	227	17	2026-01-22 05:10:45.894757
533	place                                                                                               	203	7	2026-01-22 05:10:45.894757
534	billet                                                                                              	228	17	2026-01-22 05:10:45.894757
535	place                                                                                               	204	7	2026-01-22 05:10:45.894757
536	billet                                                                                              	229	17	2026-01-22 05:10:45.894757
537	place                                                                                               	205	7	2026-01-22 05:10:45.894757
538	billet                                                                                              	230	17	2026-01-22 05:10:45.894757
539	place                                                                                               	206	7	2026-01-22 05:10:45.894757
540	billet                                                                                              	231	17	2026-01-22 05:10:45.894757
541	place                                                                                               	207	7	2026-01-22 05:10:45.894757
542	billet                                                                                              	232	17	2026-01-22 05:10:45.894757
543	place                                                                                               	208	7	2026-01-22 05:10:45.894757
544	billet                                                                                              	233	17	2026-01-22 05:10:45.894757
545	place                                                                                               	209	7	2026-01-22 05:10:45.894757
546	billet                                                                                              	234	17	2026-01-22 05:10:45.894757
547	place                                                                                               	210	7	2026-01-22 05:10:45.894757
548	billet                                                                                              	235	17	2026-01-22 05:10:54.160339
549	place                                                                                               	211	7	2026-01-22 05:10:54.160339
550	billet                                                                                              	236	17	2026-01-22 05:10:54.160339
551	place                                                                                               	212	7	2026-01-22 05:10:54.160339
552	billet                                                                                              	237	17	2026-01-22 05:10:54.160339
553	place                                                                                               	213	7	2026-01-22 05:10:54.160339
554	billet                                                                                              	238	17	2026-01-22 05:10:54.160339
555	place                                                                                               	214	7	2026-01-22 05:10:54.160339
556	billet                                                                                              	239	17	2026-01-22 05:10:54.160339
557	place                                                                                               	215	7	2026-01-22 05:10:54.160339
558	billet                                                                                              	240	17	2026-01-22 05:10:54.160339
559	place                                                                                               	216	7	2026-01-22 05:10:54.160339
560	billet                                                                                              	241	17	2026-01-22 05:10:54.160339
561	place                                                                                               	217	7	2026-01-22 05:10:54.160339
562	billet                                                                                              	242	17	2026-01-22 05:10:54.160339
563	place                                                                                               	218	7	2026-01-22 05:10:54.160339
564	billet                                                                                              	243	17	2026-01-22 05:10:54.160339
565	place                                                                                               	219	7	2026-01-22 05:10:54.160339
566	billet                                                                                              	244	17	2026-01-22 05:10:54.160339
567	place                                                                                               	220	7	2026-01-22 05:10:54.160339
568	billet                                                                                              	245	17	2026-01-22 05:10:54.160339
569	place                                                                                               	221	7	2026-01-22 05:10:54.160339
570	billet                                                                                              	246	17	2026-01-22 05:10:54.160339
571	place                                                                                               	222	7	2026-01-22 05:10:54.160339
572	billet                                                                                              	247	17	2026-01-22 05:10:54.160339
573	place                                                                                               	223	7	2026-01-22 05:10:54.160339
574	billet                                                                                              	248	17	2026-01-22 05:10:54.160339
575	place                                                                                               	224	7	2026-01-22 05:10:54.160339
576	billet                                                                                              	249	17	2026-01-22 05:10:54.160339
577	place                                                                                               	225	7	2026-01-22 05:10:54.160339
578	billet                                                                                              	250	17	2026-01-22 05:10:54.160339
579	place                                                                                               	226	7	2026-01-22 05:10:54.160339
580	billet                                                                                              	251	17	2026-01-22 05:10:54.160339
581	place                                                                                               	227	7	2026-01-22 05:10:54.160339
582	billet                                                                                              	252	17	2026-01-22 05:10:54.160339
583	place                                                                                               	228	7	2026-01-22 05:10:54.160339
584	billet                                                                                              	253	17	2026-01-22 05:10:54.160339
585	place                                                                                               	229	7	2026-01-22 05:10:54.160339
586	billet                                                                                              	254	17	2026-01-22 05:10:54.160339
587	place                                                                                               	230	7	2026-01-22 05:10:54.160339
\.


--
-- Data for Name: l_genre_film; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.l_genre_film (film_id, genre_id) FROM stdin;
2	11
2	12
2	13
3	4
3	5
3	10
3	11
3	13
3	14
\.


--
-- Data for Name: paiement; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.paiement (id, reservation_id, methode_id, reference, montant, frais, montant_net, statut_id, created_at, updated_at, completed_at, details_json, parent_paiement_id) FROM stdin;
\.


--
-- Data for Name: paiement_methode; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.paiement_methode (id, code, nom, actif, frais_pourcent, ordre) FROM stdin;
1	STRIPE	Carte bancaire (Stripe)	t	2.90	10
2	ORANGE_MONEY	Orange Money	t	1.50	20
3	MVOLA	MVola	t	1.00	30
4	ESPECES	Espèces à la caisse	t	0.00	40
\.


--
-- Data for Name: place; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.place (id, rang, col, type_place_id, statut, salle_id, date_modification) FROM stdin;
181	1	1	1	4	4	\N
182	1	2	1	4	4	\N
183	1	3	1	4	4	\N
184	1	4	1	4	4	\N
185	1	5	1	4	4	\N
186	1	6	1	4	4	\N
187	1	7	1	4	4	\N
188	1	8	1	4	4	\N
189	1	9	1	4	4	\N
190	1	10	1	4	4	\N
191	2	1	1	4	4	\N
192	2	2	1	4	4	\N
193	2	3	1	4	4	\N
194	2	4	1	4	4	\N
195	2	5	1	4	4	\N
196	2	6	1	4	4	\N
197	2	7	1	4	4	\N
198	2	8	1	4	4	\N
199	2	9	1	4	4	\N
200	2	10	1	4	4	\N
201	3	1	1	4	4	\N
202	3	2	1	4	4	\N
203	3	3	1	4	4	\N
204	3	4	1	4	4	\N
205	3	5	1	4	4	\N
206	3	6	1	4	4	\N
207	3	7	1	4	4	\N
208	3	8	1	4	4	\N
209	3	9	1	4	4	\N
210	3	10	1	4	4	\N
211	4	1	1	4	4	\N
212	4	2	1	4	4	\N
213	4	3	1	4	4	\N
214	4	4	1	4	4	\N
215	4	5	1	4	4	\N
216	4	6	1	4	4	\N
217	4	7	1	4	4	\N
218	4	8	1	4	4	\N
219	4	9	1	4	4	\N
220	4	10	1	4	4	\N
221	5	1	1	4	4	\N
222	5	2	1	4	4	\N
223	5	3	1	4	4	\N
224	5	4	1	4	4	\N
225	5	5	1	4	4	\N
226	5	6	1	4	4	\N
227	5	7	1	4	4	\N
228	5	8	1	4	4	\N
229	5	9	1	4	4	\N
230	5	10	1	4	4	\N
231	6	1	1	4	4	\N
232	6	2	1	4	4	\N
233	6	3	1	4	4	\N
234	6	4	1	4	4	\N
235	6	5	1	4	4	\N
236	6	6	1	4	4	\N
237	6	7	1	4	4	\N
238	6	8	1	4	4	\N
239	6	9	1	4	4	\N
240	6	10	1	4	4	\N
241	7	1	1	4	4	\N
242	7	2	1	4	4	\N
243	7	3	1	4	4	\N
244	7	4	1	4	4	\N
245	7	5	1	4	4	\N
246	7	6	1	4	4	\N
247	7	7	1	4	4	\N
248	7	8	1	4	4	\N
249	7	9	1	4	4	\N
250	7	10	1	4	4	\N
251	8	1	1	4	4	\N
252	8	2	1	4	4	\N
253	8	3	1	4	4	\N
254	8	4	1	4	4	\N
255	8	5	1	4	4	\N
256	8	6	1	4	4	\N
257	8	7	1	4	4	\N
258	8	8	1	4	4	\N
259	8	9	1	4	4	\N
260	8	10	1	4	4	\N
261	9	1	2	4	4	\N
262	9	2	2	4	4	\N
263	9	3	2	4	4	\N
264	9	4	2	4	4	\N
265	9	5	2	4	4	\N
266	9	6	2	4	4	\N
267	9	7	2	4	4	\N
268	9	8	2	4	4	\N
269	9	9	2	4	4	\N
270	9	10	2	4	4	\N
271	10	1	2	4	4	\N
272	10	2	2	4	4	\N
273	10	3	2	4	4	\N
274	10	4	2	4	4	\N
275	10	5	2	4	4	\N
276	10	6	2	4	4	\N
277	10	7	2	4	4	\N
278	10	8	2	4	4	\N
279	10	9	2	4	4	\N
280	10	10	2	4	4	\N
281	11	1	2	4	4	\N
282	11	2	2	4	4	\N
283	11	3	2	4	4	\N
284	11	4	2	4	4	\N
285	11	5	2	4	4	\N
286	11	6	2	4	4	\N
287	11	7	2	4	4	\N
288	11	8	2	4	4	\N
289	11	9	2	4	4	\N
290	11	10	2	4	4	\N
291	12	1	3	4	4	\N
292	12	2	3	4	4	\N
293	12	3	3	4	4	\N
294	12	4	3	4	4	\N
295	12	5	3	4	4	\N
296	12	6	3	4	4	\N
297	12	7	3	4	4	\N
298	12	8	3	4	4	\N
299	12	9	3	4	4	\N
300	12	10	3	4	4	\N
301	13	1	3	4	4	\N
302	13	2	3	4	4	\N
303	13	3	3	4	4	\N
304	13	4	3	4	4	\N
305	13	5	3	4	4	\N
306	13	6	3	4	4	\N
307	13	7	3	4	4	\N
308	13	8	3	4	4	\N
309	13	9	3	4	4	\N
310	13	10	3	4	4	\N
\.


--
-- Data for Name: prix_billet; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.prix_billet (id, type_place_id, type_personne_id, prix_base, reduction, date_prix, prix_reel, actif) FROM stdin;
\.


--
-- Data for Name: referentiel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.referentiel (id, categorie, nom, code, desce) FROM stdin;
1	GENRE_FILM	Action	ACTION	Films caractérisés par des scènes dynamiques, combats, poursuites et explosions
2	GENRE_FILM	Aventure	AVENTURE	Films centrés sur le voyage, la découverte et les quêtes
3	GENRE_FILM	Comédie	COMEDIE	Films destinés à provoquer le rire et le divertissement
4	GENRE_FILM	Drame	DRAME	Films axés sur des situations émotionnelles et réalistes
5	GENRE_FILM	Romance	ROMANCE	Films mettant en avant des relations amoureuses
6	GENRE_FILM	Thriller	THRILLER	Films à suspense jouant sur la tension psychologique
7	GENRE_FILM	Horreur	HORREUR	Films destinés à effrayer ou choquer le spectateur
8	GENRE_FILM	Science-fiction	SCI-FI	Films basés sur des concepts scientifiques ou futuristes
9	GENRE_FILM	Fantasy	FANTASY	Films mettant en scène des univers imaginaires et magiques
10	GENRE_FILM	Policier	POLICIER	Films centrés sur des enquêtes criminelles
11	GENRE_FILM	Documentaire	DOCU	Films présentant des faits réels ou éducatifs
12	GENRE_FILM	Animation	ANIMATION	Films réalisés à partir de techniques d’animation
13	GENRE_FILM	Historique	HISTORIQUE	Films inspirés d’événements historiques
14	GENRE_FILM	Biopic	BIOPIC	Films retraçant la vie d’une personnalité réelle
15	FORMAT_PROJECTION	2D	2D	Projection standard en deux dimensions
16	FORMAT_PROJECTION	3D	3D	Projection en trois dimensions nécessitant des lunettes spéciales
17	FORMAT_PROJECTION	IMAX 2D	IMAX_2D	Projection IMAX en 2D avec grand écran et meilleure qualité sonore
18	FORMAT_PROJECTION	IMAX 3D	IMAX_3D	Projection IMAX en 3D avec grand écran et effets immersifs
19	FORMAT_PROJECTION	4DX	4DX	Projection 3D avec sièges dynamiques et effets environnementaux (vent, odeur, eau)
20	FORMAT_PROJECTION	D-BOX	D-BOX	Projection 3D avec sièges motion pour ressentir le mouvement du film
21	FORMAT_PROJECTION	Dolby Cinema	DOLBY	Projection avec Dolby Vision HDR et Dolby Atmos pour son et image premium
22	FORMAT_PROJECTION	ScreenX	SCREENX	Projection panoramique sur trois écrans latéraux pour immersion totale
23	TYPE_PLACE	Standard	STD	Place standard
24	TYPE_PLACE	Accessible PMR	PMR	Place réservée PMR
25	TYPE_PLACE	VIP / Premium	VIP	Place en zone privilégiée
26	TYPE_PLACE	Duo / Couple	DUO	Siège duo sans accoudoir
27	TYPE_TARIF	Plein tarif	PLEIN	Tarif adulte standard
28	TYPE_TARIF	Réduit (-26 ans)	REDUIT	Étudiants, apprentis, demandeurs d'emploi, -26 ans
29	TYPE_TARIF	Senior (+60 ans)	SENIOR	Tarif senior
30	TYPE_TARIF	Enfant (-12 ans)	ENFANT	Tarif enfant
31	TYPE_TARIF	Supplément 3D	3D	Supplément obligatoire pour les séances 3D
32	TYPE_TARIF	Abonné / Carte	CARTE	Tarif avantage carte fidélité ou illimitée
\.


--
-- Data for Name: reservation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reservation (id, numero, montant_total, date_creation, date_expiration, client_id, statut_id) FROM stdin;
1	RES00000000011	57.500	2026-01-10 19:08:14.821219	\N	\N	14
2	RES00000000021	69.000	2026-01-10 21:20:21.738379	\N	\N	14
\.


--
-- Data for Name: salle; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.salle (id, numero, designation, capacite_total, cinema_id, nb_rangees, nb_colonnes) FROM stdin;
4	S01	salle1	130	1	13	10
\.


--
-- Data for Name: seance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.seance (id, film_id, salle_id, debut, fin, format_id) FROM stdin;
3	1	4	2026-01-15 09:00:00	2026-01-15 11:00:00	\N
4	1	4	2026-02-01 13:00:00	2026-02-01 15:00:00	\N
\.


--
-- Data for Name: statut; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.statut (id, code, nom, categorie, desce, ordre) FROM stdin;
1	ACTIF	Actif	\N	\N	10
2	INACTIF	Inactif	\N	\N	20
3	SUPPRIME	Supprimé	\N	\N	90
4	DISPO	Disponible	PLACE	\N	10
5	SELECTION	En sélection	PLACE	\N	15
6	RESERVEE	Réservée	PLACE	\N	20
7	VENDUE	Vendue	PLACE	\N	30
8	BLOQUEE	Bloquée	PLACE	\N	40
9	PLANIFIEE	Planifiée	SEANCE	\N	10
10	OUVERTE	Billetterie ouverte	SEANCE	\N	20
11	EN_COURS	En cours	SEANCE	\N	30
12	TERMINEE	Terminée	SEANCE	\N	40
13	PANIER	Panier	RESERVATION	\N	10
14	PAYEE	Payée	RESERVATION	\N	30
15	ANNULEE	Annulée	RESERVATION	\N	90
16	PANIER	Dans le panier	BILLET	Sélection en cours	10
17	PAYE	Payé / Confirmé	BILLET	Billet valide et payé	20
18	UTILISE	Utilisé	BILLET	Spectateur est entré	30
19	ANNULE	Annulé	BILLET	Annulation de la réservation	80
\.


--
-- Data for Name: tarif; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tarif (id, nom, prix_base, type_tarif_id, actif) FROM stdin;
1	Plein tarif	11.500	27	t
2	Tarif réduit	8.500	28	t
3	Enfant / Senior	7.000	29	t
\.


--
-- Data for Name: type_personne; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.type_personne (id, nom) FROM stdin;
1	Enfant
2	Adulte
3	Ado
\.


--
-- Data for Name: type_place; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.type_place (id, nom, code, desce, prix) FROM stdin;
1	standard	STD		20000.000
2	premium	PRM		50000.000
3	VIP	VIP		90000.000
\.


--
-- Data for Name: type_place_prix; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.type_place_prix (id, prix_place, type_place_id, type_personne_id, parent_id, reduction) FROM stdin;
3	40000	2	2	\N	\N
4	30000	1	2	\N	\N
5	45000	3	3	\N	\N
6	30000	2	3	\N	\N
7	20000	1	3	\N	\N
8	0	2	1	3	50.000
2	50000	3	2	\N	\N
1	0	3	1	2	50.000
9	0	1	1	4	50.000
\.


--
-- Name: billet_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.billet_id_seq', 254, true);


--
-- Name: cinema_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cinema_id_seq', 1, true);


--
-- Name: film_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.film_id_seq', 3, true);


--
-- Name: historique_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.historique_id_seq', 587, true);


--
-- Name: paiement_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.paiement_id_seq', 1, false);


--
-- Name: paiement_methode_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.paiement_methode_id_seq', 4, true);


--
-- Name: place_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.place_id_seq', 310, true);


--
-- Name: prix_billet_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.prix_billet_id_seq', 1, false);


--
-- Name: referenciel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.referenciel_id_seq', 32, true);


--
-- Name: reservation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reservation_id_seq', 2, true);


--
-- Name: reservation_num_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reservation_num_seq', 30, true);


--
-- Name: salle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.salle_id_seq', 4, true);


--
-- Name: sceance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sceance_id_seq', 4, true);


--
-- Name: statut_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.statut_id_seq', 19, true);


--
-- Name: tarif_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tarif_id_seq', 3, true);


--
-- Name: type_personne_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.type_personne_id_seq', 3, true);


--
-- Name: type_place_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.type_place_id_seq', 3, true);


--
-- Name: type_place_prix_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.type_place_prix_id_seq', 9, true);


--
-- Name: billet billet_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billet
    ADD CONSTRAINT billet_pkey PRIMARY KEY (id);


--
-- Name: cinema cinema_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cinema
    ADD CONSTRAINT cinema_pkey PRIMARY KEY (id);


--
-- Name: film film_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.film
    ADD CONSTRAINT film_pkey PRIMARY KEY (id);


--
-- Name: historique historique_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historique
    ADD CONSTRAINT historique_pkey PRIMARY KEY (id);


--
-- Name: l_genre_film l_genre_film_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.l_genre_film
    ADD CONSTRAINT l_genre_film_pkey PRIMARY KEY (film_id, genre_id);


--
-- Name: paiement_methode paiement_methode_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paiement_methode
    ADD CONSTRAINT paiement_methode_pkey PRIMARY KEY (id);


--
-- Name: paiement paiement_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paiement
    ADD CONSTRAINT paiement_pkey PRIMARY KEY (id);


--
-- Name: place place_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.place
    ADD CONSTRAINT place_pkey PRIMARY KEY (id);


--
-- Name: prix_billet prix_billet_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prix_billet
    ADD CONSTRAINT prix_billet_pkey PRIMARY KEY (id, type_place_id);


--
-- Name: referentiel referenciel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referentiel
    ADD CONSTRAINT referenciel_pkey PRIMARY KEY (id);


--
-- Name: reservation reservation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_pkey PRIMARY KEY (id);


--
-- Name: salle salle_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.salle
    ADD CONSTRAINT salle_pkey PRIMARY KEY (id);


--
-- Name: seance sceance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seance
    ADD CONSTRAINT sceance_pkey PRIMARY KEY (id);


--
-- Name: statut statut_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statut
    ADD CONSTRAINT statut_pkey PRIMARY KEY (id);


--
-- Name: tarif tarif_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tarif
    ADD CONSTRAINT tarif_pkey PRIMARY KEY (id);


--
-- Name: type_personne type_personne_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.type_personne
    ADD CONSTRAINT type_personne_pkey PRIMARY KEY (id);


--
-- Name: type_place type_place_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.type_place
    ADD CONSTRAINT type_place_pkey PRIMARY KEY (id);


--
-- Name: type_place_prix type_place_prix_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.type_place_prix
    ADD CONSTRAINT type_place_prix_pkey PRIMARY KEY (id);


--
-- Name: billet unique_billet_seance_place; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billet
    ADD CONSTRAINT unique_billet_seance_place UNIQUE (seance_id, place_id);


--
-- Name: idx_billet_reservation_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_billet_reservation_id ON public.billet USING btree (reservation_id);


--
-- Name: idx_billet_seance_place; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_billet_seance_place ON public.billet USING btree (seance_id, place_id);


--
-- Name: idx_billet_seance_statut; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_billet_seance_statut ON public.billet USING btree (seance_id, statut);


--
-- Name: idx_place_salle_statut; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_place_salle_statut ON public.place USING btree (salle_id, statut);


--
-- Name: billet billet_place_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billet
    ADD CONSTRAINT billet_place_id_fkey FOREIGN KEY (place_id) REFERENCES public.place(id) NOT VALID;


--
-- Name: billet billet_reservation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billet
    ADD CONSTRAINT billet_reservation_id_fkey FOREIGN KEY (reservation_id) REFERENCES public.reservation(id) NOT VALID;


--
-- Name: billet billet_seance_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billet
    ADD CONSTRAINT billet_seance_id_fkey FOREIGN KEY (seance_id) REFERENCES public.seance(id) NOT VALID;


--
-- Name: billet billet_tarif_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billet
    ADD CONSTRAINT billet_tarif_id_fkey FOREIGN KEY (tarif_id) REFERENCES public.tarif(id) NOT VALID;


--
-- Name: billet billet_type_personne_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billet
    ADD CONSTRAINT billet_type_personne_id_fkey FOREIGN KEY (type_personne_id) REFERENCES public.type_personne(id) NOT VALID;


--
-- Name: l_genre_film l_genre_film_film_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.l_genre_film
    ADD CONSTRAINT l_genre_film_film_id_fkey FOREIGN KEY (film_id) REFERENCES public.film(id);


--
-- Name: l_genre_film l_genre_film_genre_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.l_genre_film
    ADD CONSTRAINT l_genre_film_genre_id_fkey FOREIGN KEY (genre_id) REFERENCES public.referentiel(id) NOT VALID;


--
-- Name: paiement paiement_methode_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paiement
    ADD CONSTRAINT paiement_methode_id_fkey FOREIGN KEY (methode_id) REFERENCES public.paiement_methode(id);


--
-- Name: paiement paiement_parent_paiement_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paiement
    ADD CONSTRAINT paiement_parent_paiement_id_fkey FOREIGN KEY (parent_paiement_id) REFERENCES public.paiement(id) NOT VALID;


--
-- Name: paiement paiement_reservation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paiement
    ADD CONSTRAINT paiement_reservation_id_fkey FOREIGN KEY (reservation_id) REFERENCES public.reservation(id);


--
-- Name: paiement paiement_statut_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paiement
    ADD CONSTRAINT paiement_statut_id_fkey FOREIGN KEY (statut_id) REFERENCES public.statut(id);


--
-- Name: place place_salle_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.place
    ADD CONSTRAINT place_salle_id_fkey FOREIGN KEY (salle_id) REFERENCES public.salle(id);


--
-- Name: place place_statut_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.place
    ADD CONSTRAINT place_statut_fkey FOREIGN KEY (statut) REFERENCES public.referentiel(id) NOT VALID;


--
-- Name: place place_type_place_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.place
    ADD CONSTRAINT place_type_place_id_fkey FOREIGN KEY (type_place_id) REFERENCES public.referentiel(id) NOT VALID;


--
-- Name: salle salle_cinema_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.salle
    ADD CONSTRAINT salle_cinema_id_fkey FOREIGN KEY (cinema_id) REFERENCES public.cinema(id) NOT VALID;


--
-- Name: seance sceance_film_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seance
    ADD CONSTRAINT sceance_film_id_fkey FOREIGN KEY (film_id) REFERENCES public.film(id) NOT VALID;


--
-- Name: seance sceance_format_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seance
    ADD CONSTRAINT sceance_format_id_fkey FOREIGN KEY (format_id) REFERENCES public.referentiel(id) NOT VALID;


--
-- Name: seance sceance_salle_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seance
    ADD CONSTRAINT sceance_salle_id_fkey FOREIGN KEY (salle_id) REFERENCES public.salle(id) NOT VALID;


--
-- Name: tarif tarif_type_tarif_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tarif
    ADD CONSTRAINT tarif_type_tarif_id_fkey FOREIGN KEY (type_tarif_id) REFERENCES public.referentiel(id);


--
-- Name: type_place_prix type_place_prix_type_personne_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.type_place_prix
    ADD CONSTRAINT type_place_prix_type_personne_id_fkey FOREIGN KEY (type_personne_id) REFERENCES public.type_personne(id);


--
-- Name: type_place_prix type_place_prix_type_place_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.type_place_prix
    ADD CONSTRAINT type_place_prix_type_place_id_fkey FOREIGN KEY (type_place_id) REFERENCES public.type_place(id);


--
-- PostgreSQL database dump complete
--

\unrestrict BdzCmAocVkPP5pNXEvAFhMRJW4o9Pun4fA7W2eKuhHL4giqYOT28lZ6Lps8RiyV

