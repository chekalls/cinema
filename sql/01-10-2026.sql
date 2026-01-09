-- Table: public.referenciel

-- DROP TABLE IF EXISTS public.referenciel;

CREATE TABLE IF NOT EXISTS public.referentiel
(
    id integer NOT NULL DEFAULT nextval('referenciel_id_seq'::regclass),
    categorie character varying(50) COLLATE pg_catalog."default" NOT NULL,
    nom character varying(200) COLLATE pg_catalog."default" NOT NULL,
    code character varying(15) COLLATE pg_catalog."default" NOT NULL,
    desce text COLLATE pg_catalog."default",
    CONSTRAINT referenciel_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.referentiel
    OWNER to postgres;



-- Genres
INSERT INTO referentiel (categorie, nom, code, desce)
VALUES
('GENRE_FILM', 'Action',     'ACTION',    'Films caractérisés par des scènes dynamiques, combats, poursuites et explosions'),
('GENRE_FILM', 'Aventure',   'AVENTURE',  'Films centrés sur le voyage, la découverte et les quêtes'),
('GENRE_FILM', 'Comédie',    'COMEDIE',   'Films destinés à provoquer le rire et le divertissement'),
('GENRE_FILM', 'Drame',      'DRAME',     'Films axés sur des situations émotionnelles et réalistes'),
('GENRE_FILM', 'Romance',    'ROMANCE',   'Films mettant en avant des relations amoureuses'),
('GENRE_FILM', 'Thriller',   'THRILLER',  'Films à suspense jouant sur la tension psychologique'),
('GENRE_FILM', 'Horreur',    'HORREUR',   'Films destinés à effrayer ou choquer le spectateur'),
('GENRE_FILM', 'Science-fiction', 'SCI-FI', 'Films basés sur des concepts scientifiques ou futuristes'),
('GENRE_FILM', 'Fantasy',    'FANTASY',   'Films mettant en scène des univers imaginaires et magiques'),
('GENRE_FILM', 'Policier',   'POLICIER',  'Films centrés sur des enquêtes criminelles'),
('GENRE_FILM', 'Documentaire','DOCU',      'Films présentant des faits réels ou éducatifs'),
('GENRE_FILM', 'Animation',  'ANIMATION', 'Films réalisés à partir de techniques d’animation'),
('GENRE_FILM', 'Historique', 'HISTORIQUE','Films inspirés d’événements historiques'),
('GENRE_FILM', 'Biopic',     'BIOPIC',    'Films retraçant la vie d’une personnalité réelle');


-- Formats
INSERT INTO referentiel (categorie, nom, code, desce)
VALUES
('FORMAT_PROJECTION', '2D',           '2D',      'Projection standard en deux dimensions'),
('FORMAT_PROJECTION', '3D',           '3D',      'Projection en trois dimensions nécessitant des lunettes spéciales'),
('FORMAT_PROJECTION', 'IMAX 2D',      'IMAX_2D', 'Projection IMAX en 2D avec grand écran et meilleure qualité sonore'),
('FORMAT_PROJECTION', 'IMAX 3D',      'IMAX_3D', 'Projection IMAX en 3D avec grand écran et effets immersifs'),
('FORMAT_PROJECTION', '4DX',          '4DX',     'Projection 3D avec sièges dynamiques et effets environnementaux (vent, odeur, eau)'),
('FORMAT_PROJECTION', 'D-BOX',        'D-BOX',   'Projection 3D avec sièges motion pour ressentir le mouvement du film'),
('FORMAT_PROJECTION', 'Dolby Cinema', 'DOLBY',   'Projection avec Dolby Vision HDR et Dolby Atmos pour son et image premium'),
('FORMAT_PROJECTION', 'ScreenX',      'SCREENX', 'Projection panoramique sur trois écrans latéraux pour immersion totale');

ALTER TABLE IF EXISTS public.l_genre_film DROP CONSTRAINT IF EXISTS l_genre_film_genre_id_fkey;

ALTER TABLE IF EXISTS public.l_genre_film
    ADD FOREIGN KEY (genre_id)
    REFERENCES public.referentiel (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

ALTER TABLE IF EXISTS public.sceance DROP CONSTRAINT IF EXISTS sceance_film_id_fkey;

ALTER TABLE IF EXISTS public.sceance DROP CONSTRAINT IF EXISTS sceance_format_id_fkey;

ALTER TABLE IF EXISTS public.sceance DROP CONSTRAINT IF EXISTS sceance_salle_id_fkey;

ALTER TABLE IF EXISTS public.sceance
    ADD FOREIGN KEY (film_id)
    REFERENCES public.film (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

ALTER TABLE IF EXISTS public.sceance
    ADD FOREIGN KEY (salle_id)
    REFERENCES public.salle (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

ALTER TABLE IF EXISTS public.sceance
    ADD FOREIGN KEY (format_id)
    REFERENCES public.referentiel (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


CREATE TABLE IF NOT EXISTS public.place
(
    id integer NOT NULL DEFAULT nextval('place_id_seq'::regclass),
    rang integer NOT NULL,
    col integer NOT NULL,
    type_place_id integer,
    statut integer,
    salle_id integer,
    CONSTRAINT place_pkey PRIMARY KEY (id),
    CONSTRAINT place_salle_id_fkey FOREIGN KEY (salle_id)
        REFERENCES public.salle (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT place_type_place_id_fkey FOREIGN KEY (type_place_id)
        REFERENCES public.referentiel (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.place
    OWNER to postgres;

INSERT INTO referentiel (categorie, code, nom, desce) VALUES
    ('TYPE_PLACE', 'STD',  'Standard',                  'Place standard'),
    ('TYPE_PLACE', 'PMR',  'Accessible PMR',            'Place réservée PMR'),
    ('TYPE_PLACE', 'VIP',  'VIP / Premium',             'Place en zone privilégiée'),
    ('TYPE_PLACE', 'DUO',  'Duo / Couple',              'Siège duo sans accoudoir');

CREATE TABLE IF NOT EXISTS public.statut
(
    id integer NOT NULL DEFAULT nextval('statut_id_seq'::regclass),
    code character varying(20) COLLATE pg_catalog."default" NOT NULL,
    nom character varying(100) COLLATE pg_catalog."default" NOT NULL,
    categorie character varying(20) COLLATE pg_catalog."default",
    desce text COLLATE pg_catalog."default",
    ordre smallint DEFAULT 0,
    CONSTRAINT statut_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.statut
    OWNER to postgres;


-- Statuts conseillés pour démarrer un projet cinéma sérieux
INSERT INTO statut (code, nom, categorie, desce, ordre) VALUES
    -- Global
    ('ACTIF',     'Actif',          NULL,        NULL, 10),
    ('INACTIF',   'Inactif',        NULL,        NULL, 20),
    ('SUPPRIME',  'Supprimé',       NULL,        NULL, 90),

    -- Places (le plus important)
    ('DISPO',     'Disponible',     'PLACE',     NULL, 10),
    ('SELECTION', 'En sélection',   'PLACE',     NULL, 15),
    ('RESERVEE',  'Réservée',       'PLACE',     NULL, 20),
    ('VENDUE',    'Vendue',         'PLACE',     NULL, 30),
    ('BLOQUEE',   'Bloquée',        'PLACE',     NULL, 40),

    -- Séances
    ('PLANIFIEE', 'Planifiée',      'SEANCE',    NULL, 10),
    ('OUVERTE',   'Billetterie ouverte', 'SEANCE', NULL, 20),
    ('EN_COURS',  'En cours',       'SEANCE',    NULL, 30),
    ('TERMINEE',  'Terminée',       'SEANCE',    NULL, 40),

    -- Réservations
    ('PANIER',    'Panier',         'RESERVATION',NULL, 10),
    ('PAYEE',     'Payée',          'RESERVATION',NULL, 30),
    ('ANNULEE',   'Annulée',        'RESERVATION',NULL, 90);