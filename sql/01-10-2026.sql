-- Table: public.referenciel

-- DROP TABLE IF EXISTS public.referenciel;

CREATE TABLE IF NOT EXISTS public.referenciel
(
    id integer NOT NULL DEFAULT nextval('referenciel_id_seq'::regclass),
    categorie character varying(50) COLLATE pg_catalog."default" NOT NULL,
    nom character varying(200) COLLATE pg_catalog."default" NOT NULL,
    code character varying(15) COLLATE pg_catalog."default" NOT NULL,
    desce text COLLATE pg_catalog."default",
    CONSTRAINT referenciel_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.referenciel
    OWNER to postgres;