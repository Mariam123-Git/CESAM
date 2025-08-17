-- Script d'initialisation de la base de données
-- Structure des tables et contraintes

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

-- Créer les utilisateurs et rôles si nécessaire
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'backend_users') THEN
        CREATE ROLE backend_users;
    END IF;
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'maria') THEN
        CREATE ROLE maria;
    END IF;
END
$$;

-- Table: universites
CREATE TABLE IF NOT EXISTS public.universites (
    id integer NOT NULL,
    nom character varying(200) NOT NULL,
    ville character varying(100),
    adresse text
);

CREATE SEQUENCE IF NOT EXISTS public.universites_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.universites_id_seq OWNED BY public.universites.id;
ALTER TABLE ONLY public.universites ALTER COLUMN id SET DEFAULT nextval('public.universites_id_seq'::regclass);
ALTER TABLE ONLY public.universites ADD CONSTRAINT universites_pkey PRIMARY KEY (id);

-- Table: etudiants
CREATE TABLE IF NOT EXISTS public.etudiants (
    id integer NOT NULL,
    nom character varying(100) NOT NULL,
    prenom character varying(100) NOT NULL,
    email character varying(150) NOT NULL,
    mot_de_passe character varying(255) NOT NULL,
    nationalite character varying(50),
    date_naissance date,
    universite_id integer,
    date_inscription timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    role character varying(50) DEFAULT 'etudiant'::character varying
);

CREATE SEQUENCE IF NOT EXISTS public.etudiants_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.etudiants_id_seq OWNED BY public.etudiants.id;
ALTER TABLE ONLY public.etudiants ALTER COLUMN id SET DEFAULT nextval('public.etudiants_id_seq'::regclass);
ALTER TABLE ONLY public.etudiants ADD CONSTRAINT etudiants_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.etudiants ADD CONSTRAINT etudiants_email_key UNIQUE (email);

-- Table: utilisateur
CREATE TABLE IF NOT EXISTS public.utilisateur (
    id_utilisateur integer NOT NULL,
    nom character varying(100),
    prenom character varying(100),
    email character varying(150) NOT NULL,
    mot_de_passe character varying(255) NOT NULL,
    nationalite character varying(100),
    niveau_etudes character varying(100),
    domaine_etudes character varying(100),
    personne_a_prevenir character varying(150),
    numero_tel character varying(50),
    role character varying(50),
    date_inscription date,
    email_verifie boolean DEFAULT false,
    token_validation character varying(255),
    reset_token character varying(255),
    reset_token_expire timestamp without time zone,
    token_version text
);

CREATE SEQUENCE IF NOT EXISTS public.utilisateur_id_utilisateur_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.utilisateur_id_utilisateur_seq OWNED BY public.utilisateur.id_utilisateur;
ALTER TABLE ONLY public.utilisateur ALTER COLUMN id_utilisateur SET DEFAULT nextval('public.utilisateur_id_utilisateur_seq'::regclass);
ALTER TABLE ONLY public.utilisateur ADD CONSTRAINT utilisateur_pkey PRIMARY KEY (id_utilisateur);
ALTER TABLE ONLY public.utilisateur ADD CONSTRAINT utilisateur_email_key UNIQUE (email);

-- Table: notifications
CREATE TABLE IF NOT EXISTS public.notifications (
    id integer NOT NULL,
    id_etudiant integer,
    contenu text NOT NULL,
    date_envoi timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    lu boolean DEFAULT false
);

CREATE SEQUENCE IF NOT EXISTS public.notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;
ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);
ALTER TABLE ONLY public.notifications ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);

-- Table: profil
CREATE TABLE IF NOT EXISTS public.profil (
    id_profil integer NOT NULL,
    id_utilisateur integer,
    cv_url text,
    competences text,
    description text,
    photo_url text
);

CREATE SEQUENCE IF NOT EXISTS public.profil_id_profil_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.profil_id_profil_seq OWNED BY public.profil.id_profil;
ALTER TABLE ONLY public.profil ALTER COLUMN id_profil SET DEFAULT nextval('public.profil_id_profil_seq'::regclass);
ALTER TABLE ONLY public.profil ADD CONSTRAINT profil_pkey PRIMARY KEY (id_profil);

-- Table: paiement
CREATE TABLE IF NOT EXISTS public.paiement (
    id_paiement integer NOT NULL,
    id_utilisateur integer,
    id_association integer,
    montant numeric(10,2),
    date_paiement date,
    moyen_paiement character varying(50),
    statut character varying(50),
    reference character varying(100)
);

CREATE SEQUENCE IF NOT EXISTS public.paiement_id_paiement_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.paiement_id_paiement_seq OWNED BY public.paiement.id_paiement;
ALTER TABLE ONLY public.paiement ALTER COLUMN id_paiement SET DEFAULT nextval('public.paiement_id_paiement_seq'::regclass);
ALTER TABLE ONLY public.paiement ADD CONSTRAINT paiement_pkey PRIMARY KEY (id_paiement);

-- Table: bourse
CREATE TABLE IF NOT EXISTS public.bourse (
    id_bourse integer NOT NULL,
    nom character varying(150),
    description text,
    montant numeric(10,2),
    type character varying(50),
    conditions text,
    date_debut date,
    date_fin date
);

CREATE SEQUENCE IF NOT EXISTS public.bourse_id_bourse_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.bourse_id_bourse_seq OWNED BY public.bourse.id_bourse;
ALTER TABLE ONLY public.bourse ALTER COLUMN id_bourse SET DEFAULT nextval('public.bourse_id_bourse_seq'::regclass);
ALTER TABLE ONLY public.bourse ADD CONSTRAINT bourse_pkey PRIMARY KEY (id_bourse);

-- Table: entreprise
CREATE TABLE IF NOT EXISTS public.entreprise (
    id_entreprise integer NOT NULL,
    nom character varying(150),
    secteur character varying(100),
    ville character varying(100),
    contact character varying(100),
    description text,
    site_web text
);

CREATE SEQUENCE IF NOT EXISTS public.entreprise_id_entreprise_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.entreprise_id_entreprise_seq OWNED BY public.entreprise.id_entreprise;
ALTER TABLE ONLY public.entreprise ALTER COLUMN id_entreprise SET DEFAULT nextval('public.entreprise_id_entreprise_seq'::regclass);
ALTER TABLE ONLY public.entreprise ADD CONSTRAINT entreprise_pkey PRIMARY KEY (id_entreprise);

-- Table: offre
CREATE TABLE IF NOT EXISTS public.offre (
    id_offre integer NOT NULL,
    titre character varying(150),
    description text,
    type character varying(50),
    id_entreprise integer,
    date_publication date,
    date_expiration date
);

CREATE SEQUENCE IF NOT EXISTS public.offre_id_offre_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.offre_id_offre_seq OWNED BY public.offre.id_offre;
ALTER TABLE ONLY public.offre ALTER COLUMN id_offre SET DEFAULT nextval('public.offre_id_offre_seq'::regclass);
ALTER TABLE ONLY public.offre ADD CONSTRAINT offre_pkey PRIMARY KEY (id_offre);

-- Table: favori
CREATE TABLE IF NOT EXISTS public.favori (
    id_favori integer NOT NULL,
    id_utilisateur integer,
    type_element character varying(50),
    id_element integer,
    date_ajout date
);

CREATE SEQUENCE IF NOT EXISTS public.favori_id_favori_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.favori_id_favori_seq OWNED BY public.favori.id_favori;
ALTER TABLE ONLY public.favori ALTER COLUMN id_favori SET DEFAULT nextval('public.favori_id_favori_seq'::regclass);
ALTER TABLE ONLY public.favori ADD CONSTRAINT favori_pkey PRIMARY KEY (id_favori);

-- Table: projet
CREATE TABLE IF NOT EXISTS public.projet (
    id_projet integer NOT NULL,
    titre character varying(255) NOT NULL,
    description text,
    type character varying(50),
    id_utilisateu integer,
    id_universite integer,
    domaine character varying(100),
    annee integer,
    url text
);

CREATE SEQUENCE IF NOT EXISTS public.projet_id_projet_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.projet_id_projet_seq OWNED BY public.projet.id_projet;
ALTER TABLE ONLY public.projet ALTER COLUMN id_projet SET DEFAULT nextval('public.projet_id_projet_seq'::regclass);
ALTER TABLE ONLY public.projet ADD CONSTRAINT projet_pkey PRIMARY KEY (id_projet);

-- Table: bourse_sauvegarde
CREATE TABLE IF NOT EXISTS public.bourse_sauvegarde (
    id_utilisateur integer NOT NULL,
    id_bourse integer NOT NULL,
    date_sauvegarde timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE ONLY public.bourse_sauvegarde ADD CONSTRAINT bourse_sauvegarde_pkey PRIMARY KEY (id_utilisateur, id_bourse);

-- CONTRAINTES DE CLÉ ÉTRANGÈRE
ALTER TABLE ONLY public.etudiants ADD CONSTRAINT etudiants_universite_id_fkey FOREIGN KEY (universite_id) REFERENCES public.universites(id);
ALTER TABLE ONLY public.notifications ADD CONSTRAINT notifications_id_etudiant_fkey FOREIGN KEY (id_etudiant) REFERENCES public.etudiants(id);
ALTER TABLE ONLY public.profil ADD CONSTRAINT profil_id_utilisateur_fkey FOREIGN KEY (id_utilisateur) REFERENCES public.utilisateur(id_utilisateur);
ALTER TABLE ONLY public.paiement ADD CONSTRAINT paiement_id_utilisateur_fkey FOREIGN KEY (id_utilisateur) REFERENCES public.utilisateur(id_utilisateur);
ALTER TABLE ONLY public.offre ADD CONSTRAINT offre_id_entreprise_fkey FOREIGN KEY (id_entreprise) REFERENCES public.entreprise(id_entreprise);
ALTER TABLE ONLY public.favori ADD CONSTRAINT favori_id_utilisateur_fkey FOREIGN KEY (id_utilisateur) REFERENCES public.utilisateur(id_utilisateur);
ALTER TABLE ONLY public.projet ADD CONSTRAINT projet_id_universite_fkey FOREIGN KEY (id_universite) REFERENCES public.universites(id);
ALTER TABLE ONLY public.projet ADD CONSTRAINT projet_id_utilisateu_fkey FOREIGN KEY (id_utilisateu) REFERENCES public.utilisateur(id_utilisateur);
ALTER TABLE ONLY public.bourse_sauvegarde ADD CONSTRAINT bourse_sauvegarde_id_bourse_fkey FOREIGN KEY (id_bourse) REFERENCES public.bourse(id_bourse);
ALTER TABLE ONLY public.bourse_sauvegarde ADD CONSTRAINT bourse_sauvegarde_id_utilisateur_fkey FOREIGN KEY (id_utilisateur) REFERENCES public.utilisateur(id_utilisateur);

-- PERMISSIONS
GRANT USAGE ON SCHEMA public TO backend_users;
GRANT SELECT,INSERT,DELETE,UPDATE ON ALL TABLES IN SCHEMA public TO backend_users;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON ALL TABLES IN SCHEMA public TO maria;

-- Permissions par défaut pour les nouvelles tables
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT,INSERT,DELETE,UPDATE ON TABLES TO backend_users;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO maria;