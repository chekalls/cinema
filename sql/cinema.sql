--
-- PostgreSQL database dump
--

\restrict hnBUtUfkK5hfUXJdJcJDdDHeaHaERkCMobIZKRfSU3yC0JPbu7jYoq0AvyQ80A9

-- Dumped from database version 17.6 (Debian 17.6-0+deb13u1)
-- Dumped by pg_dump version 17.6 (Debian 17.6-0+deb13u1)

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
    tarif_id integer NOT NULL,
    prix_reel numeric(15,3) NOT NULL,
    date_utilisation timestamp without time zone,
    statut integer,
    date_achat timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    reservation_id integer
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
-- Name: type_place; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.type_place (
    id integer NOT NULL,
    nom character varying(200) NOT NULL,
    code character varying(15),
    desce text
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
-- Name: place id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.place ALTER COLUMN id SET DEFAULT nextval('public.place_id_seq'::regclass);


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
-- Name: type_place id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.type_place ALTER COLUMN id SET DEFAULT nextval('public.type_place_id_seq'::regclass);


--
-- Data for Name: billet; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.billet (id, seance_id, place_id, tarif_id, prix_reel, date_utilisation, statut, date_achat, reservation_id) FROM stdin;
12	3	1	1	11.500	\N	17	2026-01-10 19:08:00	1
13	3	2	1	11.500	\N	17	2026-01-10 19:08:00	1
14	3	3	1	11.500	\N	17	2026-01-10 19:08:00	1
15	3	4	1	11.500	\N	17	2026-01-10 19:08:00	1
16	3	5	1	11.500	\N	17	2026-01-10 19:08:00	1
17	3	6	1	11.500	\N	17	2026-01-10 21:20:00	2
18	3	7	1	11.500	\N	17	2026-01-10 21:20:00	2
19	3	8	1	11.500	\N	17	2026-01-10 21:20:00	2
20	3	9	1	11.500	\N	17	2026-01-10 21:20:00	2
21	3	10	1	11.500	\N	17	2026-01-10 21:20:00	2
22	3	11	1	11.500	\N	17	2026-01-10 21:20:00	2
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
\.


--
-- Data for Name: historique; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.historique (id, table_name, cle_primaire, statut, date_modification) FROM stdin;
1	billet                                                                                              	12	16	2026-01-10 19:08:14.821219
2	place                                                                                               	1	5	2026-01-10 19:08:14.821219
3	billet                                                                                              	13	16	2026-01-10 19:08:14.821219
4	place                                                                                               	2	5	2026-01-10 19:08:14.821219
5	billet                                                                                              	14	16	2026-01-10 19:08:14.821219
6	place                                                                                               	3	5	2026-01-10 19:08:14.821219
7	billet                                                                                              	15	16	2026-01-10 19:08:14.821219
8	place                                                                                               	4	5	2026-01-10 19:08:14.821219
9	billet                                                                                              	16	16	2026-01-10 19:08:14.821219
10	place                                                                                               	5	5	2026-01-10 19:08:14.821219
16	billet                                                                                              	12	17	2026-01-10 21:18:44.78175
17	billet                                                                                              	13	17	2026-01-10 21:18:44.782527
18	billet                                                                                              	14	17	2026-01-10 21:18:44.782981
19	billet                                                                                              	15	17	2026-01-10 21:18:44.783333
20	billet                                                                                              	16	17	2026-01-10 21:18:44.783586
21	billet                                                                                              	17	16	2026-01-10 21:20:21.738379
22	place                                                                                               	6	5	2026-01-10 21:20:21.738379
23	billet                                                                                              	18	16	2026-01-10 21:20:21.738379
24	place                                                                                               	7	5	2026-01-10 21:20:21.738379
25	billet                                                                                              	19	16	2026-01-10 21:20:21.738379
26	place                                                                                               	8	5	2026-01-10 21:20:21.738379
27	billet                                                                                              	20	16	2026-01-10 21:20:21.738379
28	place                                                                                               	9	5	2026-01-10 21:20:21.738379
29	billet                                                                                              	21	16	2026-01-10 21:20:21.738379
30	place                                                                                               	10	5	2026-01-10 21:20:21.738379
31	billet                                                                                              	22	16	2026-01-10 21:20:21.738379
32	place                                                                                               	11	5	2026-01-10 21:20:21.738379
33	billet                                                                                              	17	17	2026-01-10 21:20:57.868706
34	billet                                                                                              	18	17	2026-01-10 21:20:57.868706
35	billet                                                                                              	19	17	2026-01-10 21:20:57.868706
36	billet                                                                                              	20	17	2026-01-10 21:20:57.868706
37	billet                                                                                              	21	17	2026-01-10 21:20:57.868706
38	billet                                                                                              	22	17	2026-01-10 21:20:57.868706
39	reservation                                                                                         	2	14	2026-01-10 21:20:57.868706
\.


--
-- Data for Name: l_genre_film; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.l_genre_film (film_id, genre_id) FROM stdin;
2	11
2	12
2	13
\.


--
-- Data for Name: place; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.place (id, rang, col, type_place_id, statut, salle_id, date_modification) FROM stdin;
12	2	4	\N	4	4	\N
13	2	5	\N	4	4	\N
14	2	6	\N	4	4	\N
15	2	7	\N	4	4	\N
16	2	8	\N	4	4	\N
17	3	1	\N	4	4	\N
18	3	2	\N	4	4	\N
19	3	3	\N	4	4	\N
20	3	4	\N	4	4	\N
21	3	5	\N	4	4	\N
22	3	6	\N	4	4	\N
23	3	7	\N	4	4	\N
24	3	8	\N	4	4	\N
25	4	1	\N	4	4	\N
26	4	2	\N	4	4	\N
27	4	3	\N	4	4	\N
28	4	4	\N	4	4	\N
29	4	5	\N	4	4	\N
30	4	6	\N	4	4	\N
31	4	7	\N	4	4	\N
32	4	8	\N	4	4	\N
33	5	1	\N	4	4	\N
34	5	2	\N	4	4	\N
35	5	3	\N	4	4	\N
36	5	4	\N	4	4	\N
37	5	5	\N	4	4	\N
38	5	6	\N	4	4	\N
39	5	7	\N	4	4	\N
40	5	8	\N	4	4	\N
41	6	1	\N	4	4	\N
42	6	2	\N	4	4	\N
43	6	3	\N	4	4	\N
44	6	4	\N	4	4	\N
45	6	5	\N	4	4	\N
46	6	6	\N	4	4	\N
47	6	7	\N	4	4	\N
48	6	8	\N	4	4	\N
49	7	1	\N	4	4	\N
50	7	2	\N	4	4	\N
51	7	3	\N	4	4	\N
52	7	4	\N	4	4	\N
53	7	5	\N	4	4	\N
54	7	6	\N	4	4	\N
55	7	7	\N	4	4	\N
56	7	8	\N	4	4	\N
57	8	1	\N	4	4	\N
58	8	2	\N	4	4	\N
59	8	3	\N	4	4	\N
60	8	4	\N	4	4	\N
61	8	5	\N	4	4	\N
62	8	6	\N	4	4	\N
63	8	7	\N	4	4	\N
64	8	8	\N	4	4	\N
65	9	1	\N	4	4	\N
66	9	2	\N	4	4	\N
67	9	3	\N	4	4	\N
68	9	4	\N	4	4	\N
69	9	5	\N	4	4	\N
70	9	6	\N	4	4	\N
71	9	7	\N	4	4	\N
72	9	8	\N	4	4	\N
73	10	1	\N	4	4	\N
74	10	2	\N	4	4	\N
75	10	3	\N	4	4	\N
76	10	4	\N	4	4	\N
77	10	5	\N	4	4	\N
78	10	6	\N	4	4	\N
79	10	7	\N	4	4	\N
80	10	8	\N	4	4	\N
1	1	1	\N	5	4	\N
2	1	2	\N	5	4	\N
3	1	3	\N	5	4	\N
4	1	4	\N	5	4	\N
5	1	5	\N	5	4	\N
6	1	6	\N	5	4	\N
7	1	7	\N	5	4	\N
8	1	8	\N	5	4	\N
9	2	1	\N	5	4	\N
10	2	2	\N	5	4	\N
11	2	3	\N	5	4	\N
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
4	S01	salle1	80	1	10	8
\.


--
-- Data for Name: seance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.seance (id, film_id, salle_id, debut, fin, format_id) FROM stdin;
3	1	4	2026-01-15 09:00:00	2026-01-15 11:00:00	\N
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
-- Data for Name: type_place; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.type_place (id, nom, code, desce) FROM stdin;
\.


--
-- Name: billet_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.billet_id_seq', 22, true);


--
-- Name: cinema_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cinema_id_seq', 1, true);


--
-- Name: film_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.film_id_seq', 2, true);


--
-- Name: historique_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.historique_id_seq', 39, true);


--
-- Name: place_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.place_id_seq', 80, true);


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

SELECT pg_catalog.setval('public.sceance_id_seq', 3, true);


--
-- Name: statut_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.statut_id_seq', 19, true);


--
-- Name: tarif_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tarif_id_seq', 3, true);


--
-- Name: type_place_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.type_place_id_seq', 1, false);


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
-- Name: place place_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.place
    ADD CONSTRAINT place_pkey PRIMARY KEY (id);


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
-- Name: type_place type_place_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.type_place
    ADD CONSTRAINT type_place_pkey PRIMARY KEY (id);


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
-- PostgreSQL database dump complete
--

\unrestrict hnBUtUfkK5hfUXJdJcJDdDHeaHaERkCMobIZKRfSU3yC0JPbu7jYoq0AvyQ80A9

