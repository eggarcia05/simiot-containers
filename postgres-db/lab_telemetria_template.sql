--
-- PostgreSQL database dump
--

-- Dumped from database version 14.5 (Debian 14.5-1.pgdg110+1)
-- Dumped by pg_dump version 14.5 (Ubuntu 14.5-1.pgdg20.04+1)

-- Started on 2022-09-18 12:20:34 -05

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
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
-- TOC entry 209 (class 1259 OID 16521)
-- Name: registros_sensores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.registros_sensores (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    point_id character varying NOT NULL,
    timestamp_registro timestamp without time zone DEFAULT now() NOT NULL,
    registro jsonb DEFAULT '{}'::jsonb NOT NULL
);


ALTER TABLE public.registros_sensores OWNER TO postgres;

--
-- TOC entry 222 (class 1255 OID 16529)
-- Name: estado_filtro(public.registros_sensores, text, anyelement, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.estado_filtro(registros_sensores_row public.registros_sensores, filter_condition text, value anyelement, parametro text) RETURNS boolean
    LANGUAGE plpgsql STABLE
    AS $$ declare ids text[];
parametro_jsonb_row text;
type_value regtype;
begin 
	parametro_jsonb_row  := registros_sensores_row.registro->parametro;
	type_value := pg_typeof(value);
	return (
		select 
			case 
				when type_value::text = 'numeric' or type_value::text = 'integer' then value::numeric = parametro_jsonb_row::numeric
				when type_value::text = 'boolean' then value::boolean = parametro_jsonb_row::boolean
				else value::text = parametro_jsonb_row::text
			end 
	);
--	case 
--		when filter_condition = '='
--			then select ()
--			
--	foreach id_i in array ids loop return QUERY
--	select
--		*
--	from
--		nom_test nt
--	where
--		nt.id::text = id_i ;
--	end loop;
	end;
$$;


ALTER FUNCTION public.estado_filtro(registros_sensores_row public.registros_sensores, filter_condition text, value anyelement, parametro text) OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 16530)
-- Name: entidades; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.entidades (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nombre character varying NOT NULL,
    tipo character varying NOT NULL
);


ALTER TABLE public.entidades OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 16536)
-- Name: equip; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.equip (
    id character varying NOT NULL,
    dis character varying NOT NULL,
    tags jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    "siteRef" character varying NOT NULL
);


ALTER TABLE public.equip OWNER TO postgres;

--
-- TOC entry 3382 (class 0 OID 0)
-- Dependencies: 211
-- Name: TABLE equip; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.equip IS 'equipo físico o lógico dentro de un sitio';


--
-- TOC entry 212 (class 1259 OID 16543)
-- Name: etiquetas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.etiquetas (
    id bigint NOT NULL,
    tag character varying NOT NULL,
    descripcion character varying NOT NULL,
    entidad_id uuid NOT NULL,
    nombre character varying,
    requerido boolean,
    orden character varying
);


ALTER TABLE public.etiquetas OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 16548)
-- Name: etiquetas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.etiquetas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.etiquetas_id_seq OWNER TO postgres;

--
-- TOC entry 3383 (class 0 OID 0)
-- Dependencies: 213
-- Name: etiquetas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.etiquetas_id_seq OWNED BY public.etiquetas.id;


--
-- TOC entry 214 (class 1259 OID 16549)
-- Name: haystack_tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.haystack_tags (
    tag character varying NOT NULL,
    descripcion character varying
);


ALTER TABLE public.haystack_tags OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16554)
-- Name: point; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.point (
    id character varying DEFAULT gen_random_uuid() NOT NULL,
    dis character varying NOT NULL,
    tags jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    "siteRef" character varying,
    "equipRef" character varying,
    clave_esperada character varying
);


ALTER TABLE public.point OWNER TO postgres;

--
-- TOC entry 3384 (class 0 OID 0)
-- Dependencies: 215
-- Name: TABLE point; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.point IS 'sensor, actuador';


--
-- TOC entry 216 (class 1259 OID 16563)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    rol character varying NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 3385 (class 0 OID 0)
-- Dependencies: 216
-- Name: TABLE roles; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.roles IS 'roles permitidos para los usuarios';


--
-- TOC entry 217 (class 1259 OID 16569)
-- Name: site; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.site (
    id character varying NOT NULL,
    dis character varying NOT NULL,
    tags jsonb DEFAULT '{}'::jsonb NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.site OWNER TO postgres;

--
-- TOC entry 3386 (class 0 OID 0)
-- Dependencies: 217
-- Name: TABLE site; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.site IS 'un solo edificio con su propia dirección';


--
-- TOC entry 218 (class 1259 OID 16577)
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nombre character varying NOT NULL,
    correo character varying,
    role_id uuid NOT NULL
);


ALTER TABLE public.usuarios OWNER TO postgres;

--
-- TOC entry 3387 (class 0 OID 0)
-- Dependencies: 218
-- Name: TABLE usuarios; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.usuarios IS 'usuarios que pueden ingresar a los datos';


--
-- TOC entry 3206 (class 2604 OID 16583)
-- Name: etiquetas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.etiquetas ALTER COLUMN id SET DEFAULT nextval('public.etiquetas_id_seq'::regclass);


--
-- TOC entry 3219 (class 2606 OID 16585)
-- Name: entidades entidades_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entidades
    ADD CONSTRAINT entidades_pk PRIMARY KEY (id);


--
-- TOC entry 3221 (class 2606 OID 16587)
-- Name: equip equip_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equip
    ADD CONSTRAINT equip_pk PRIMARY KEY (id);


--
-- TOC entry 3223 (class 2606 OID 16589)
-- Name: etiquetas etiquetas_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.etiquetas
    ADD CONSTRAINT etiquetas_pk PRIMARY KEY (id);


--
-- TOC entry 3225 (class 2606 OID 16591)
-- Name: etiquetas etiquetas_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.etiquetas
    ADD CONSTRAINT etiquetas_un UNIQUE (tag, entidad_id);


--
-- TOC entry 3227 (class 2606 OID 16593)
-- Name: haystack_tags haystack_tags_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.haystack_tags
    ADD CONSTRAINT haystack_tags_pk PRIMARY KEY (tag);


--
-- TOC entry 3229 (class 2606 OID 16595)
-- Name: point point_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.point
    ADD CONSTRAINT point_pk PRIMARY KEY (id);


--
-- TOC entry 3217 (class 2606 OID 16597)
-- Name: registros_sensores registros_sensores_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registros_sensores
    ADD CONSTRAINT registros_sensores_pk PRIMARY KEY (id);


--
-- TOC entry 3231 (class 2606 OID 16599)
-- Name: site site_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.site
    ADD CONSTRAINT site_pk PRIMARY KEY (id);


--
-- TOC entry 3233 (class 2606 OID 16600)
-- Name: equip equip_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equip
    ADD CONSTRAINT equip_fk FOREIGN KEY ("siteRef") REFERENCES public.site(id);


--
-- TOC entry 3234 (class 2606 OID 16605)
-- Name: etiquetas etiquetas_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.etiquetas
    ADD CONSTRAINT etiquetas_fk FOREIGN KEY (entidad_id) REFERENCES public.entidades(id);


--
-- TOC entry 3236 (class 2606 OID 16610)
-- Name: point point_equipRef_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.point
    ADD CONSTRAINT "point_equipRef_fkey" FOREIGN KEY ("equipRef") REFERENCES public.equip(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 3237 (class 2606 OID 16615)
-- Name: point point_siteRef_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.point
    ADD CONSTRAINT "point_siteRef_fkey" FOREIGN KEY ("siteRef") REFERENCES public.site(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 3232 (class 2606 OID 16620)
-- Name: registros_sensores registros_sensores_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registros_sensores
    ADD CONSTRAINT registros_sensores_fk FOREIGN KEY (point_id) REFERENCES public.point(id) ON UPDATE CASCADE;


--
-- TOC entry 3235 (class 2606 OID 16625)
-- Name: etiquetas tags_haystack_etiquetas_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.etiquetas
    ADD CONSTRAINT tags_haystack_etiquetas_fk FOREIGN KEY (tag) REFERENCES public.haystack_tags(tag) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2022-09-18 12:20:34 -05

--
-- PostgreSQL database dump complete
--

