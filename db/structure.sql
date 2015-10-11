--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: activity_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE activity_type AS ENUM (
    'daily_fact',
    'warmup',
    'lesson',
    'work_time',
    'homework'
);


--
-- Name: status_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE status_type AS ENUM (
    'pending',
    'current',
    'graduated'
);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: activities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE activities (
    id integer NOT NULL,
    activity_type activity_type,
    title text,
    content text,
    date date,
    start time without time zone,
    finish time without time zone,
    groups text
);


--
-- Name: activities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE activities_id_seq OWNED BY activities.id;


--
-- Name: activities_to_cohorts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE activities_to_cohorts (
    id integer NOT NULL,
    activity_id integer,
    cohort_id integer
);


--
-- Name: activities_to_cohorts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE activities_to_cohorts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activities_to_cohorts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE activities_to_cohorts_id_seq OWNED BY activities_to_cohorts.id;


--
-- Name: activities_to_instructors; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE activities_to_instructors (
    id integer NOT NULL,
    activity_id integer,
    instructor_id integer
);


--
-- Name: activities_to_instructors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE activities_to_instructors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activities_to_instructors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE activities_to_instructors_id_seq OWNED BY activities_to_instructors.id;


--
-- Name: activities_to_locations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE activities_to_locations (
    id integer NOT NULL,
    activity_id integer,
    location_id integer
);


--
-- Name: activities_to_locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE activities_to_locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activities_to_locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE activities_to_locations_id_seq OWNED BY activities_to_locations.id;


--
-- Name: cohorts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cohorts (
    id integer NOT NULL,
    name character varying(255),
    status status_type
);


--
-- Name: cohorts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cohorts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cohorts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cohorts_id_seq OWNED BY cohorts.id;


--
-- Name: instructors; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE instructors (
    id integer NOT NULL,
    name character varying(255)
);


--
-- Name: instructors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE instructors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: instructors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE instructors_id_seq OWNED BY instructors.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE locations (
    id integer NOT NULL,
    name character varying(255),
    activity_id integer
);


--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE locations_id_seq OWNED BY locations.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY activities ALTER COLUMN id SET DEFAULT nextval('activities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY activities_to_cohorts ALTER COLUMN id SET DEFAULT nextval('activities_to_cohorts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY activities_to_instructors ALTER COLUMN id SET DEFAULT nextval('activities_to_instructors_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY activities_to_locations ALTER COLUMN id SET DEFAULT nextval('activities_to_locations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cohorts ALTER COLUMN id SET DEFAULT nextval('cohorts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY instructors ALTER COLUMN id SET DEFAULT nextval('instructors_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY locations ALTER COLUMN id SET DEFAULT nextval('locations_id_seq'::regclass);


--
-- Name: activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (id);


--
-- Name: activities_to_cohorts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY activities_to_cohorts
    ADD CONSTRAINT activities_to_cohorts_pkey PRIMARY KEY (id);


--
-- Name: activities_to_instructors_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY activities_to_instructors
    ADD CONSTRAINT activities_to_instructors_pkey PRIMARY KEY (id);


--
-- Name: activities_to_locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY activities_to_locations
    ADD CONSTRAINT activities_to_locations_pkey PRIMARY KEY (id);


--
-- Name: cohorts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cohorts
    ADD CONSTRAINT cohorts_pkey PRIMARY KEY (id);


--
-- Name: instructors_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY instructors
    ADD CONSTRAINT instructors_pkey PRIMARY KEY (id);


--
-- Name: locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20151005203248');

