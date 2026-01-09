--
-- PostgreSQL database dump
--

\restrict vX57l15qAx3EOMxKBMHbKMbG5wK5ifUbCTZmjhgN4aHqcv4Bm8RE3WkNGC7N4xf

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

SET default_tablespace = '';

SET default_table_access_method = heap;

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
-- Name: format; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.format (
    id integer NOT NULL,
    nom character varying(200) NOT NULL,
    code character varying(15) NOT NULL,
    desce text
);


ALTER TABLE public.format OWNER TO postgres;

--
-- Name: format_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.format_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.format_id_seq OWNER TO postgres;

--
-- Name: format_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.format_id_seq OWNED BY public.format.id;


--
-- Name: genre_film; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.genre_film (
    id smallint NOT NULL,
    nom character varying(200) NOT NULL,
    code character varying(15),
    desce text
);


ALTER TABLE public.genre_film OWNER TO postgres;

--
-- Name: genre_film_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.genre_film_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.genre_film_id_seq OWNER TO postgres;

--
-- Name: genre_film_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.genre_film_id_seq OWNED BY public.genre_film.id;


--
-- Name: l_genre_film; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.l_genre_film (
    film_id integer NOT NULL,
    genre_id integer NOT NULL
);


ALTER TABLE public.l_genre_film OWNER TO postgres;

--
-- Name: salle; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.salle (
    id integer NOT NULL,
    numero character varying(15) NOT NULL,
    designation character varying(200) NOT NULL,
    capacite_total integer NOT NULL,
    cinema_id integer NOT NULL
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
-- Name: sceance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sceance (
    id integer NOT NULL,
    film_id integer NOT NULL,
    salle_id integer NOT NULL,
    debut timestamp without time zone NOT NULL,
    fin timestamp without time zone NOT NULL,
    format_id integer
);


ALTER TABLE public.sceance OWNER TO postgres;

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

ALTER SEQUENCE public.sceance_id_seq OWNED BY public.sceance.id;


--
-- Name: cinema id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cinema ALTER COLUMN id SET DEFAULT nextval('public.cinema_id_seq'::regclass);


--
-- Name: film id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.film ALTER COLUMN id SET DEFAULT nextval('public.film_id_seq'::regclass);


--
-- Name: format id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.format ALTER COLUMN id SET DEFAULT nextval('public.format_id_seq'::regclass);


--
-- Name: genre_film id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genre_film ALTER COLUMN id SET DEFAULT nextval('public.genre_film_id_seq'::regclass);


--
-- Name: salle id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.salle ALTER COLUMN id SET DEFAULT nextval('public.salle_id_seq'::regclass);


--
-- Name: sceance id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sceance ALTER COLUMN id SET DEFAULT nextval('public.sceance_id_seq'::regclass);


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
-- Data for Name: format; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.format (id, nom, code, desce) FROM stdin;
1	2D	2D	Projection standard en deux dimensions
2	3D	3D	Projection en trois dimensions nécessitant des lunettes spéciales
3	IMAX 2D	IMAX_2D	Projection IMAX en 2D avec grand écran et meilleure qualité sonore
4	IMAX 3D	IMAX_3D	Projection IMAX en 3D avec grand écran et effets immersifs
5	4DX	4DX	Projection 3D avec sièges dynamiques et effets environnementaux (vent, odeur, eau)
6	D-BOX	D-BOX	Projection 3D avec sièges motion pour ressentir le mouvement du film
7	Dolby Cinema	DOLBY	Projection avec Dolby Vision HDR et Dolby Atmos pour son et image premium
8	ScreenX	SCREENX	Projection panoramique sur trois écrans latéraux pour immersion totale
\.


--
-- Data for Name: genre_film; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.genre_film (id, nom, code, desce) FROM stdin;
1	Action	ACTION	Films caractérisés par des scènes dynamiques, combats, poursuites et explosions
2	Aventure	AVENTURE	Films centrés sur le voyage, la découverte et les quêtes
3	Comédie	COMEDIE	Films destinés à provoquer le rire et le divertissement
4	Drame	DRAME	Films axés sur des situations émotionnelles et réalistes
5	Romance	ROMANCE	Films mettant en avant des relations amoureuses
6	Thriller	THRILLER	Films à suspense jouant sur la tension psychologique
7	Horreur	HORREUR	Films destinés à effrayer ou choquer le spectateur
8	Science-fiction	SCI-FI	Films basés sur des concepts scientifiques ou futuristes
9	Fantasy	FANTASY	Films mettant en scène des univers imaginaires et magiques
10	Policier	POLICIER	Films centrés sur des enquêtes criminelles
11	Documentaire	DOCU	Films présentant des faits réels ou éducatifs
12	Animation	ANIMATION	Films réalisés à partir de techniques d’animation
13	Historique	HISTORIQUE	Films inspirés d’événements historiques
14	Biopic	BIOPIC	Films retraçant la vie d’une personnalité réelle
\.


--
-- Data for Name: l_genre_film; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.l_genre_film (film_id, genre_id) FROM stdin;
\.


--
-- Data for Name: salle; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.salle (id, numero, designation, capacite_total, cinema_id) FROM stdin;
1	S01	Salle IMAX	150	1
\.


--
-- Data for Name: sceance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sceance (id, film_id, salle_id, debut, fin, format_id) FROM stdin;
\.


--
-- Name: cinema_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cinema_id_seq', 1, true);


--
-- Name: film_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.film_id_seq', 2, true);


--
-- Name: format_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.format_id_seq', 8, true);


--
-- Name: genre_film_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.genre_film_id_seq', 14, true);


--
-- Name: salle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.salle_id_seq', 1, true);


--
-- Name: sceance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sceance_id_seq', 1, false);


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
-- Name: format format_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.format
    ADD CONSTRAINT format_pkey PRIMARY KEY (id);


--
-- Name: genre_film genre_film_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genre_film
    ADD CONSTRAINT genre_film_pkey PRIMARY KEY (id);


--
-- Name: l_genre_film l_genre_film_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.l_genre_film
    ADD CONSTRAINT l_genre_film_pkey PRIMARY KEY (film_id, genre_id);


--
-- Name: salle salle_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.salle
    ADD CONSTRAINT salle_pkey PRIMARY KEY (id);


--
-- Name: sceance sceance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sceance
    ADD CONSTRAINT sceance_pkey PRIMARY KEY (id);


--
-- Name: l_genre_film l_genre_film_film_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.l_genre_film
    ADD CONSTRAINT l_genre_film_film_id_fkey FOREIGN KEY (film_id) REFERENCES public.film(id);


--
-- Name: l_genre_film l_genre_film_genre_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.l_genre_film
    ADD CONSTRAINT l_genre_film_genre_id_fkey FOREIGN KEY (genre_id) REFERENCES public.genre_film(id);


--
-- Name: salle salle_cinema_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.salle
    ADD CONSTRAINT salle_cinema_id_fkey FOREIGN KEY (cinema_id) REFERENCES public.cinema(id) NOT VALID;


--
-- Name: sceance sceance_format_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sceance
    ADD CONSTRAINT sceance_format_id_fkey FOREIGN KEY (format_id) REFERENCES public.format(id) NOT VALID;


--
-- PostgreSQL database dump complete
--

\unrestrict vX57l15qAx3EOMxKBMHbKMbG5wK5ifUbCTZmjhgN4aHqcv4Bm8RE3WkNGC7N4xf

