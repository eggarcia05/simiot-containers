--
-- PostgreSQL database dump
--

-- Dumped from database version 14.5 (Debian 14.5-1.pgdg110+1)
-- Dumped by pg_dump version 14.5 (Debian 14.5-1.pgdg110+1)

-- Started on 2022-09-23 03:42:05 UTC

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
    id character varying DEFAULT gen_random_uuid() NOT NULL,
    dis character varying NOT NULL,
    tags jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    "siteRef" character varying NOT NULL
);


ALTER TABLE public.equip OWNER TO postgres;

--
-- TOC entry 3393 (class 0 OID 0)
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
-- TOC entry 3394 (class 0 OID 0)
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
-- TOC entry 3395 (class 0 OID 0)
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
-- TOC entry 3396 (class 0 OID 0)
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
-- TOC entry 3397 (class 0 OID 0)
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
-- TOC entry 3398 (class 0 OID 0)
-- Dependencies: 218
-- Name: TABLE usuarios; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.usuarios IS 'usuarios que pueden ingresar a los datos';


--
-- TOC entry 3207 (class 2604 OID 16634)
-- Name: etiquetas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.etiquetas ALTER COLUMN id SET DEFAULT nextval('public.etiquetas_id_seq'::regclass);


--
-- TOC entry 3379 (class 0 OID 16530)
-- Dependencies: 210
-- Data for Name: entidades; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.entidades (id, nombre, tipo) FROM stdin;
9a794c3b-2715-454f-ab81-791232cfc4b1	Equipo	equip
2d0de53e-30d1-4db5-8668-ec32cf01fcc6	Sitio	site
9709a027-9e88-4837-a7ad-5968d95d9d71	Punto	point
\.


--
-- TOC entry 3380 (class 0 OID 16536)
-- Dependencies: 211
-- Data for Name: equip; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.equip (id, dis, tags, created_at, updated_at, "siteRef") FROM stdin;
\.


--
-- TOC entry 3381 (class 0 OID 16543)
-- Dependencies: 212
-- Data for Name: etiquetas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.etiquetas (id, tag, descripcion, entidad_id, nombre, requerido, orden) FROM stdin;
19	equipRef	Id que referencia al equipo que contiene al sensor	9709a027-9e88-4837-a7ad-5968d95d9d71	Equipo	t	P2
11	dis	Nombre a mostrar del punto	9709a027-9e88-4837-a7ad-5968d95d9d71	Descripción	t	P4
13	air	La lectura proviente de la mezcla de gases que rodea la tierra	9709a027-9e88-4837-a7ad-5968d95d9d71	\N	\N	\N
14	humidity	El sensor mide la humedad del ambiente	9709a027-9e88-4837-a7ad-5968d95d9d71	\N	\N	\N
17	airQuality	Concentración de contaminantes en el aire	9709a027-9e88-4837-a7ad-5968d95d9d71	\N	\N	\N
18	co2	Presencia de dióxido de carbono	9709a027-9e88-4837-a7ad-5968d95d9d71	\N	\N	\N
16	unit	Unidad de medidad del sensor	9709a027-9e88-4837-a7ad-5968d95d9d71	Unidad	\N	\N
2	tz	zona horaria del sitio	2d0de53e-30d1-4db5-8668-ec32cf01fcc6	Zona Horaria	\N	S6
1	dis	Nombre a mostrar del sitio	2d0de53e-30d1-4db5-8668-ec32cf01fcc6	Descripción	t	S2
5	coord	Coordenadas geográficas del sitio	2d0de53e-30d1-4db5-8668-ec32cf01fcc6	Coordenadas	\N	S5
3	area	Dimensión del área en donde se encuentra el sitio	2d0de53e-30d1-4db5-8668-ec32cf01fcc6	Area	\N	S4
4	geoAddr	Dirección geográfica del sitio	2d0de53e-30d1-4db5-8668-ec32cf01fcc6	Dirección	t	S3
7	siteRef	id que referencia al Sitio donde se encuentra el equipo	9a794c3b-2715-454f-ab81-791232cfc4b1	Sitio	t	E1
8	id	identificador del equipo	9a794c3b-2715-454f-ab81-791232cfc4b1	Identificador	\N	E2
6	dis	Nombre a mostrar del equipo	9a794c3b-2715-454f-ab81-791232cfc4b1	Descripción	t	E3
20	siteRef	Id que referencia al sitio donde se encuentra el sensor	9709a027-9e88-4837-a7ad-5968d95d9d71	Sitio	t	P1
15	kind	Tipo de dato retornado por el sensor	9709a027-9e88-4837-a7ad-5968d95d9d71	Tipo de Dato	t	P5
9	id	Identificador del Sitio	2d0de53e-30d1-4db5-8668-ec32cf01fcc6	Identificador	t	S1
10	id	Identificador del punto	9709a027-9e88-4837-a7ad-5968d95d9d71	Identificador	\N	P3
21	volt	Tensión eléctrica, diferencia de potencial	9709a027-9e88-4837-a7ad-5968d95d9d71	\N	\N	\N
22	power	Energía consumida por unidad de tiempo	9709a027-9e88-4837-a7ad-5968d95d9d71	\N	\N	\N
23	pf	Factor de potencia eléctrica	9709a027-9e88-4837-a7ad-5968d95d9d71	\N	\N	\N
24	elec	Asociado a la electricidad, la carga eléctrica	9709a027-9e88-4837-a7ad-5968d95d9d71	\N	\N	\N
25	run	Punto de conexión/desconexión principal de un equipo	9709a027-9e88-4837-a7ad-5968d95d9d71	\N	\N	\N
26	actuator	Mover o controlar un mecanismo	9709a027-9e88-4837-a7ad-5968d95d9d71	\N	\N	\N
12	temp	El punto mide la temperatura	9709a027-9e88-4837-a7ad-5968d95d9d71	\N	\N	\N
\.


--
-- TOC entry 3383 (class 0 OID 16549)
-- Dependencies: 214
-- Data for Name: haystack_tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.haystack_tags (tag, descripcion) FROM stdin;
absorption	Proceso de enfriamiento utilizando energía de la fuente de calor, como el agua caliente
ac	Relacionado con la electricidad de corriente alterna
accumulate	Acumular el valor de la etiqueta durante la herencia y defx
active	Trabajo, operativo, efectivo
ahu	Unidad de tratamiento de aire
ahuZoneDelivery	Método de entrega de AHU de aire acondicionado a la zona
airCooling	Enfriando disipando el calor en el aire circundante
airHandlingEquip	Equipo de HVAC que condiciona y entrega aire a través de uno o más ventiladores
airQualityZonePoints	Entidad con agrupación lógica de puntos de calidad del aire de zona
airRef	El aire fluye del referente a esta entidad
airTerminalUnit	Equipo en sistemas de distribución de aire que terminan en el espacio
airVolumeAdjustability	Capacidad del equipo de manejo de aire para ajustar el volumen del flujo de aire
alarm	Notificación de una condición que requiere atención
angle	Medición de la diferencia relativa de dirección entre dos vectores o fasores
apparent	Cantidad percibida
association	Las asociaciones modelan relaciones ontológicas entre definiciones
ates	Sistema de almacenamiento de energía térmica del acuífero
atesClosedLoop	El ATES utiliza tuberías cerradas para transportar una mezcla de agua/glicol a través del suelo
atesDesign	Tipo de diseño del sistema subterráneo ATES
atesDoublet	El ates tiene uno o más pares de un pozo cálido y fresco separados
atesDoubletPaired	El ates es como un doblete, pero con pozos cálidos y fríos específicos vinculados juntos
atesMono	El ates solo tiene un pozo físico
atesUnidirectional	Similar a un doblete, pero el agua siempre fluye en la misma dirección desde la extracción hasta el pozo de infiltración
atmospheric	Relacionado con la atmósfera de la tierra
avg	Promedio
bacnet	Protocolo de automatización y control de edificios Ashrae
barometric	Relacionar la presión atmosférica
baseUri	URI base para normalizar URI relativos
battery	Equipo utilizado para almacenar energía eléctrica
biomass	Material de planta o animal utilizado como combustible para producir electricidad o calor
biomassHeating	Calefacción por la combustión de biomasa
blowdown	Eliminación del contenedor o tubería
blowdownWaterRef	El agua de la explotación fluye del referente a esta entidad
bluetooth	Protocolo de comunicación inalámbrica de corto alcance
boiler	Equipo para generar agua caliente o vapor para calentar
bool	Valor booleano verdadero o falso
bypass	Tubería utilizada para evitar un equipo
cav	Unidad de terminal de volumen de aire constante
centrifugal	Compresión a través de un flujo continuo de fluido a través de un impulsor
ch2o	Formaldehído (Ch₂o)
ch4	Metano (CH₄)
children	Lista de prototipos contenidos por esta entidad
childrenFlatten	Lista de aspectos para aplanar en prototipos de niños
chilled	La sustancia se enfría utilizando el proceso de enfriamiento
chilledBeam	Condiciona a un espacio que usa un intercambiador de calor integrado en el techo
chilledBeamZone	AHU suministra aire a unidades de terminal de haz refrigerado
chilledWaterCooling	Enfriamiento usando la transferencia de calor al agua fría
chilledWaterRef	El agua fría fluye del referente a esta entidad
chiller	Equipo para eliminar el fuego de un líquido
chillerMechanism	Mecanismo primario de enfriador
choice	Elección especifica una selección de marcadores exclusivo
circ	Tubería utilizada para circular el fluido a través de un equipo o sistema
circuit	Circuito eléctrico y sus componentes asociados, como interruptores
cloudage	Porcentaje de cielo oscurecido por las nubes
cmd	El punto es un comando, actuador, ao/bo
co	Monóxido de carbono (CO)
co2e	Dióxido de carbono equivalente
coal	Roca sedimentaria combustible
coalHeating	Calefacción por la combustión del carbón
coap	Protocolo de aplicación restringido
coil	Intercambiador de calor utilizado para calentar o enfriar aire
cold	Tener un bajo grado de calor
coldDeck	Conducto lleva aire para enfriar
computed	Indica una definición que se calcula
computer	Computadora de propósito general
concentration	Abundancia de sustancia en el volumen total de una mezcla
condensate	Fase líquida producida por la condensación de vapor u otro gas
condensateRef	Los flujos de condensado del referente a esta entidad
condenser	Dispositivo o relacionado con el proceso de condensación
condenserClosedLoop	El fluido de trabajo se mantiene separado del fluido utilizado para la transferencia de calor a la atmósfera
condenserCooling	Eliminación del calor a través del proceso de condensación de agua
condenserLoop	Circuito abierto o cerrado para el fluido de trabajo del condensador
condenserOpenLoop	Utiliza el fluido de trabajo en sí para evaporar en la atmósfera
condenserWaterRef	El agua del condensador fluye del referente a esta entidad
conduit	Conducto, tubería o cable para transmitir una sustancia o fenómeno
constantAirVolume	Ofrece un volumen constante de flujo de aire
containedBy	La entidad está lógicamente contenida por el referente
contains	Entidades lógicamente contenidas por esta entidad
controller	Dispositivo basado en microprocesador utilizado en un sistema de control
controls	Asociado con el sistema de control para un proceso industrial
airQuality	Concentración de contaminantes en el aire
area	Dimensión del área en donde se encuentra el sitio
co2	Presencia de dióxido de carbono
cool	Asociado con procesos de baja temperatura o enfriamiento
cooling	Modo de enfriamiento o proceso
coolingCapacity	Medición de una capacidad de enfriador para eliminar el calor medido
coolingCoil	Bobina utilizada para enfriar el aire
coolingOnly	Equipo sin calefacción
coolingProcess	Procesado utilizado para enfriar una sustancia
coolingTower	Equipo para transferir el calor de los residuos a la atmósfera
crac	Aire acondicionado de la sala de computadoras
cur	Admite el valor actual
curErr	Descripción del error Cuando Curstatus indica la condición de error
curStatus	Estado de la lectura del valor actual de Point
curVal	Valor actual de un punto
current	Movimiento de fluido o electricidad
dali	Protocolo de interfaz de iluminación digital direccionable para iluminación
damper	Equipo amortiguador o punto de control
dataCenter	Espacio utilizado para albergar equipos de redes y redes
date	ISO 8601 Fecha como año, mes, día
dateTime	ISO 8601 marca de tiempo seguido de identificador de zona horaria
daytime	Tiempo entre el amanecer y el atardecer
dc	Relacionado con la electricidad de corriente continua
deadband	El rango en un proceso en el que no se realizan cambios en la producción
def	Crear una nueva definición vinculada al símbolo dado
defx	Extiende la definición dada con metaetics adicionales
delta	Diferencial de fluido entre los sensores de entrada y salida
demand	Tasa requerida para un proceso
depends	Lista de las dependencias de esta biblioteca
deprecated	Obsoleto
design	Datos relacionados con el diseño previsto y las condiciones de funcionamiento
dessicantDehumidifier	Disminuye la humedad del aire usando una sustancia que absorbe la humedad
device	Dispositivo de hardware basado en microprocesador
deviceRef	Dispositivo que controla un monitorea esta entidad
dewPoint	Temperatura del punto de rocío a la cual el vapor de agua formará rocío
dict	Mapa de pares de etiquetas de nombre/valor
diesel	Combustible líquido diseñado específicamente para su uso en motores diesel
directZone	AHU suministra aire directamente a la zona
direction	Dirección de brújulas medida en grados
discharge	Conducto para el aire saliendo de un equipo
diverting	Válvula de tres vías que ingresa una tubería y desvía entre dos tuberías de salida
doas	Sistema de aire exterior dedicado
doc	Documentación en sabor simplificado de Markdown
docAssociations	Genere una sección en los documentos para esta asociación
docTaxonomy	Generar un árbol de taxonomía para este término en el DocumentationIndex
domestic	Para uso humano
domesticWaterRef	El agua doméstica fluye del referente a esta entidad
dualDuct	Dos conductos
duct	Conducto utilizado para transmitir aire para HVAC
ductArea	Punto de configuración en un vav para el área del conducto medido en ft² o m²
ductConfig	Configuración de conductos
ductDeck	Cubierta fría, caliente o neutral
ductSection	Sección de equipos de conductos
duration	Número con una unidad de tiempo
dxCooling	Enfriamiento utilizando la expansión directa de un vapor de refrigerante
dxHeating	Calefacción utilizando la expansión directa de un vapor de refrigerante
economizer	Conducto para acceder al aire libre recién salido solo para economizar, no de ventilación
economizing	Modo de reducción de energía que aumenta el calentamiento/enfriamiento con aire exterior
effective	Punto de ajuste de control actual en efecto teniendo en cuenta otros factores
efficiency	Punto de eficiencia de un enfriador medido en "COP" o "KW/TON"
elecHeating	Calentamiento mediante la conversión de energía eléctrica
elecRef	La electricidad fluye del referente a esta entidad
elevator	Recinto utilizado para mover a las personas entre pisos
emission	Cantidad de una sustancia descargada en el aire
enable	Punto secundario de encendido/apagado de un equipo especialmente utilizado con un VFD
energy	Medida de la capacidad de hacer el trabajo
entering	La tubería transmite fluido a un equipo
enthalpy	Contenido total de calor de un sistema
entity	Dictos de nivel superior con un identificador único
enum	Define una eumeración de nombres de teclas de cadena
equip	Activo de equipo
escalator	Moving Staircase solía mover a las personas entre pisos
evaporator	Mecanismo utilizado para convertir un refrigerante de su líquido a estado gaseoso
exhaust	Conducto solía expulsar el aire hacia afuera
export	Suministrado fuera de un sistema
extraction	Sacar una sustancia de otra sustancia
faceBypass	El punto de un AHU que indica el flujo de aire es transmitir las bobinas de calefacción/enfriamiento
fan	Equipo de ventilador o punto de control
fanPowered	Dispositivo con ventilador
fcu	Unidad de bobina del ventilador
feature	Espacio de nombres de características de las definiciones formateadas como característica: Nombre
feelsLike	La temperatura aparente percibida al considerar la humedad, la frío del viento y el índice de calor
fileExt	Extensión del nombre de archivo como "CSV"
filetype	Definición de tipo de formato de archivo
filter	Relacionado con un filtro de aire o fluido
filterStr	Cadena de filtro de henoStack
floor	Piso de un edificio
dis	Nombre a mostrar de la entidad
floorNum	Entero sin unidad que indica la distancia del piso desde el nivel del suelo
flow	Medida del flujo volumétrico de fluido
flowInverter	Sistema para cambiar la dirección del flujo de sustancias
flue	Conducto para una combustión agotadora
fluid	Líquido o gas
flux	Medición a través de una superficie dada
freezeStat	Un punto booleano de un AHU que indica una condición de congelación
freq	Ocurrencias por unidad de tiempo
ftp	Protocolo de transferencia de archivos
fuelOil	Aceite a base de petróleo quemado por energía
fuelOilHeating	Calefacción por la combustión de combustible
fuelOilRef	El aceite de combustible fluye del referente a esta entidad
fumeHood	Equipo de ventilación para limitar la exposición a humos peligrosos
gas	Sustancia sin volumen ni forma definido
gasoline	Líquido derivado de petróleo utilizado como fuente de combustible
gasolineRef	La gasolina fluye del referente a esta entidad
geoCity	Nombre de la ciudad o localidad geográfica
geoCoord	Coordenada geográfica como C (latitud, longitud)
geoCountry	País geográfico como ISO 3166-1 Código de dos letras
geoCounty	Subdivisión geográfica del estado estadounidense
geoElevation	Elevación sobre el nivel del mar de la ubicación
geoPlace	Lugar geográfico
geoPostalCode	Código postal geográfico
geoState	Nombre del estado o provincia
geoStreet	Dirección y nombre de la calle geográfica
grid	Tabla de dos dimensiones de columnas y filas
ground	Relacionado con la superficie de la tierra
haystack	Protocolo HTTP de Haystack para intercambiar datos etiquetados
header	Tubería utilizada como conexión central o colector para otras carreras de tuberías
heat	Asociado con un proceso de calefacción
heatExchanger	Equipo para transferir calor entre dos fluidos de trabajo
heatPump	Bomba de calor
heatWheel	Punto booleano que indica el estado de comando de la rueda de calor de Ahu
heating	Modo de calefacción o proceso
heatingCoil	Bobina utilizada para calentar el aire
heatingOnly	Equipo sin enfriamiento
heatingProcess	Procesado utilizado para calentar una sustancia
hfc	Hidrofluorocarbonos
his	Admite la historización de datos
hisErr	Descripción del error Cuando Hisstatus indica la condición de error
hisMode	Indica la forma en que se recopilan los datos del historial para un punto
hisStatus	Estado de la colección o sincronización del historial de Point
hisTotalized	Indica valores que son un flujo continuo de totalización
hot	Tener un alto grado de calor
hotDeck	Conducto lleva aire para calentar
hotWaterHeating	Calefacción con energía de agua caliente
hotWaterRef	El agua caliente fluye del referente a esta entidad
http	Protocolo de transferencia de hipertexto que es la base de la web
humidifier	Agregar humedad al aire
hvac	Calefacción, ventilación y aire acondicionado
hvacMode	Modo operativo para equipos HVAC
hvacZonePoints	Entidad con agrupación lógica de los puntos aéreos de la zona HVAC
ice	Agua en su forma sólida
illuminance	Flujo luminoso que golpea el interior de la esfera en un punto específico
imap	Protocolo de acceso a mensajes de Internet para recuperar el correo electrónico
imbalance	Falta de equilibrio
import	Recibido en un sistema
infiltration	Pregimiento de una sustancia en otra sustancia
inlet	Conducto con aire que ingresa a un equipo
input	Entidad ingresa una sustancia que fluye de otra entidad
inputs	La entidad ingresa una sustancia del referente
int	Número entero sin unidad
intensity	Medida de un campo electromagnético
irradiance	Energía recibida en una superficie por área
is	Define uno o más supertipos de una relación subtitutética
isolation	Actuador utilizado para aislar un equipo de una tubería o sistema de conductos
knx	Protocolo KNX comúnmente utilizado para sistemas de iluminación
laptop	Computadora portátil portátil
leaving	La tubería transmite fluido fuera de un equipo
level	Varía del 0% al 100%
lib	Módulo de biblioteca de definiciones simbólicas
light	Radiación electromagnética en el espectro visible
lighting	Sistemas asociados con la iluminación en el entorno construido
lightingZonePoints	Entidad con agrupación lógica de puntos de iluminación
liquid	Sustancia con volumen definitivo pero toma la forma de su contenedor
list	Lista ordenada de cero o más valores
load	El enfriador apunta a comandar o medir la carga del enfriador como un porcentaje de "0%" a "100%"
luminaire	Luz de luz utilizando electricidad para proporcionar iluminación
luminance	Energía de la luz en una dirección dada
luminous	Relacionado con la luz como percibido por el ojo
magnitude	Tamaño o extensión
makeup	Restaurar algo perdido o perdido
makeupWaterRef	El agua de maquillaje fluye del referente a esta entidad
mandatory	Requiere que el marcador se aplique a los dicts que usan los subtipos del marcador
marker	Marcador etiqueta un dict con información de escritura
mau	Unidad de aire de composición
max	Máximo
maxVal	Máximo inclusivo para un valor numérico
meter	Equipo para medir una sustancia o fenómeno
meterScope	Clasifica un medidor como un medidor o subméter del sitio principal
mime	Tipo de MIME formateado como tipo/subtipo
min	Mínimo
minVal	Mínimo inclusivo para un valor numérico
mixed	Conducto donde se mezcla el aire libre y el aire de retorno
mixing	Válvula de tres vías que ingresa dos tuberías y emite una mezcla entre los dos y una sola tubería de salida
mobile	Relacionado con teléfonos móviles, computadoras de mano y tecnología similar
modbus	Protocolo de comunicación basado en registros utilizado con dispositivos industriales
motor	Equipo que convierte la energía eléctrica en energía mecánica
movingWalkway	Transportador para mover a las personas a través de un plano horizontal o inclinado
mqtt	Protocolo de publicación/suscripción de la telemetría de colas de mensajes
multiZone	El aire de descarga de ahu se divide en un conducto por zona
n2o	Óxido nitroso (N₂O)
na	No disponible para indicar datos no válidos o faltantes
naturalGas	Fuente de energía de combustible fósil que consiste en gran parte de metano y otros hidrocarburos
naturalGasHeating	Calentamiento por la combustión del gas natural
naturalGasRef	El gas natural fluye del referente a esta entidad
net	Diferencia entre importación y exportación
network	Red de comunicaciones lógicas entre dos o más dispositivos
networkRef	Asocia un dispositivo que se comunica en una red específica
networking	Relacionado con las redes de comunicación de datos
neutralDeck	El conducto lleva aire que pasa por alto tanto las bobinas de calefacción como de enfriamiento
nf3	Trifluoruro de nitrógeno (NF₃)
nh3	Amoníaco (NH₃)
no2	Dióxido de nitrógeno (NO₂)
noSideEffects	Marca una función u operación que no tiene efectos secundarios
nodoc	Indocumentado y no compatible oficial
nosrc	No incluya el código fuente en la documentación
notInherited	Marcador aplicado a un DEF para indicar que no se hereda en definiciones de subtipo
number	Números enteros o de punto flotante anotados con una unidad opcional
o2	Oxígeno (O₂) - La alotrape de dioxígeno común en el aire
o3	Ozono (o₃)
obix	Protocolo de intercambio de información de construcción abierta basado en XML
occ	Modo ocupado de un espacio
occupancy	Número de ocupantes en un espacio
occupants	Personas que usan el entorno construido
occupied	Punto de ajuste o sensor que indica la ocupación de un espacio
of	Tipo de valor esperado de una colección, referencia o elección
op	Operación para la API HTTP
openEnum	Aplicar a las etiquetas STR enum donde el rango de enumeración está abierto
output	La entidad emite una sustancia con flujos a otras entidades
outputs	La entidad emite una sustancia al referente
outside	Conducto para acceder al aire exterior fresco para la ventilación y el economizador
panel	Recinto para equipos eléctricos y de control
parallel	Circuito con múltiples rutas de flujo
perimeterHeat	Puntos de calefacción auxiliares asociados con un VAV
pfc	Perfluorocarbons
phase	Medición de fase en un sistema eléctrico trifásico
phenomenon	Aspecto del interés científico con cantidades medibles
phone	Teléfono utilizado para telecomunicaciones de voz
pipe	Conducto utilizado para transmitir un fluido
pipeFluid	Tipo de fluido transmitido por tuberías
pipeSection	Sección de equipos de tuberías
plant	Planta central utilizada para generar una sustancia para un proceso
plantLoop	Bucle de tuberías de plantas
pm01	Partícula 0.1
pm10	Partícula 10
pm25	Partícula 2.5
point	Punto de datos como un sensor o actuador
pointFunction	Clasifica el punto como sensor, comando o punto de ajuste
pointGroup	Agrupación de puntos para niños utilizados por espacios y equipos
pointQuantity	Cantidad el punto siente o controla
pointSubject	Lo que el punto siente o controla
pop3	Protocolo de correos Versión 3 para recuperar el correo electrónico
precipitation	Cantidad de vapor de agua atmosférica caída, incluida lluvia, aguanieve, nieve y granizo
prefUnit	Define una unidad preferida que se utilizará con una cantidad
pressure	Medida de fuerza aplicada
pressureDependent	VAV Damper modula para controlar la temperatura del espacio
pressureIndependent	VAV Damper o una válvula de control que se modula para mantener el punto de ajuste de flujo deseado
primaryFunction	Función principal de la construcción como la tecla de estrella de energía de EE. UU.
primaryLoop	Pipework que circula más cercano a la fuente de energía
process	Proceso industrial o de HVAC
propane	Subproducto del procesamiento de gas natural y refinación de petróleo (C₃H₈)
propaneHeating	Calefacción por la combustión de propano
protocol	Protocolo de comunicación utilizado para dispositivos en una red
pump	Equipo de bomba o punto de control
purge	Asociado con un proceso de limpieza para eliminar contaminantes
quality	Cantidad medida contra la métrica estándar
quantities	Cantidades utilizadas para medir este fenómeno
quantity	Propiedad medible de una sustancia o fenómeno
quantityOf	Asociado la cantidad como medición de un fenómeno
rack	Recinto o chasis utilizado para montar la computadora y el equipo de redes
radiantEquip	Equipo HVAC que condiciona un espacio sin aire forzado
radiantFloor	Calienta un espacio con tuberías o cables incrustados debajo del piso
radiator	Calienta un espacio usando tuberías o bobinas expuestas
rated	Datos especificados por un fabricante o organización de calificación
reactive	Relativo a la reactancia
reciprocal	Compresor de pistón impulsado por un cigüeñal
reciprocalOf	Especifica lo inverso de una asociación o relaciones
ref	Referencia a una entidad
refrig	Fluido utilizado en refrigeración e intercambio de calor
refrigRef	El refrigerante fluye del referente a esta entidad
reheat	Punto de comando para el proceso de recalentamiento
relationship	Etiquetas de referencia utilizadas para modelar relaciones de entidad a entidad
remove	Singleton para eliminar la operación
return	Conducto que devuelve el aire de regreso al equipo
roof	Sobre cubriendo la parte superior de un edificio
room	Habitación cerrada de un edificio
rotaryScrew	Compresión de tornillo rotativo
router	Dispositivo utilizado para enrutar paquetes de datos
rtu	Unidad de techo
scalar	Scalar es un valor atómico
secondaryLoop	Tuberías que circulan más cerca del edificio o uso final
sensor	El punto es un sensor, entrada, AI/BI
series	Circuito con ruta única de flujo
server	Hardware o software que proporciona servicios para otros programas o dispositivos
sf6	Hexafluoruro de azufre (SF₆)
singleDuct	Un solo conducto
site	El sitio es una ubicación geográfica del entorno construido
siteMeter	Medidor principal para el sitio asociado
smtp	Protocolo de transferencia de correo simple para enviar correo electrónico
snmp	Protocolo simple de gestión de redes para administrar dispositivos IP
solar	Relacionado con la energía del sol
solid	Sustancia con forma y volumen definidos
sox	Protocolo de comunicación basado en UDP marco de Sedona
sp	El punto es un punto de ajuste, punto suave, variable de control interno, programación
space	El espacio es un volumen tridimensional en el entorno construido
spaceRef	Referencia al espacio que contiene esta entidad
span	El tramo de tiempo modelado codificado como XSTR
speed	Distancia por unidad de tiempo
stage	Número de etapa de operación de equipos escenificados como bobina o bomba
standby	Modo de preparación de un espacio
steam	Agua en su forma de gas
steamHeating	Calefacción con energía de vapor
steamRef	El vapor fluye del referente a esta entidad
str	Cadena de caracteres unicode
submeter	Los submeters miden el uso de un subsistema o equipo dentro de un sitio
submeterOf	Referencia al medidor principal que está inmediatamente aguas arriba de este medidor
substance	Materia en uno de los tres estados sólidos, líquidos o de gas
subterranean	Debajo de la superficie de la tierra
switch	Dispositivo para alternar el estado o los datos de enrutamiento
symbol	Símbolo a un def
tablet	Dispositivo móvil con pantalla táctil para la entrada del usuario
tagOn	Esta etiqueta se usa en la entidad dada
tags	Etiquetas utilizadas con esta entidad
tank	Tanque utilizado para almacenar una sustancia para una tenencia temporal
tankSubstance	Sustancia almacenada por un tanque
temp	Temperatura: medida de calor y frío
tertiaryLoop	Tuberías que circulan dentro del edificio
thd	Distorsión armónica total
thermal	Relacionado con la energía del calor
thermostat	Sentidos y controla la temperatura del espacio en el sistema HVAC
time	ISO 8601 tiempo como hora, minuto, segundos
total	Completo o absoluto
transient	Indica una etiqueta de valor que no debe persistirse
transitive	Este marcador se aplica a una relación para indicar que es transitivo
tripleDuct	Tres conductos
tvoc	Compuesto orgánico volátil total (TVOC)
unitVent	Ventilador unitario
unocc	Modo desocupado de un espacio
ups	Fuente de poder ininterrumpible
uri	Identificador de recursos universales
val	Tipo de valor de datos
valve	Equipo de válvula o punto de control
variableAirVolume	Ofrece un volumen variable de flujo de aire
vav	Unidad de terminal de volumen de aire variable
vavAirCircuit	¿Cómo se pone el vav en aire?
vavModulation	¿Cómo modula VAV la temperatura basada en la presión del conducto?
vavZone	AHU suministra aire a las unidades de terminal VAV
velocity	Velocidad en una dirección dada
ventilation	Conducto para acceder al aire libre recién salido solo para la ventilación, no economizar
version	Cadena de versión formateada como enteros decimales separados por un punto
verticalTransport	Equipo para mover humanos y materiales
vfd	Unidad de frecuencia variable
visibility	Distancia a la que la luz se puede discernir claramente
volume	Espacio tridimensional ocupado por una sustancia
warm	Relativamente cálido en comparación con otra sustancia, sin ser calentado activamente
water	Agua en su forma líquida
waterCooling	Enfriamiento usando la transferencia de calor al agua que no se enfría explícitamente
weather	Asociado con el aire o el fenómeno atmosférico
weatherCond	Enumeración de condiciones climáticas
weatherStation	Estación meteorológica lógica y sus puntos de medición
weatherStationRef	Referencia a la estación meteorológica para usar esta entidad
well	Un pozo es una fuente de agua subterránea y energía potencialmente térmica
wetBulb	Temperatura del aire de bulbo húmedo
wikipedia	Hipervínculo a la página del sujeto en Wikipedia
wind	Flujo de aire en la superficie de la tierra
wire	Cableado utilizado para transmitir electricidad o datos
writable	Admite escribir datos
writeErr	Descripción del error Cuando WriteStatus indica la condición de error
writeLevel	Nivel de prioridad actual para WriteVal como número entre 1 y 17
writeStatus	Estado actual de una salida de punto de escritura
writeVal	Valor actual deseado para escribir en la salida
xstr	Cadena extendida: tipo de nombre de nombre y valor de cadena
yearBuilt	Año original de construcción como un año de cuatro dígitos, como 1980
zigbee	Protocolo de comunicación inalámbrica de baja potencia para la automatización del hogar
zone	Relacionado con espacios desde una perspectiva del sistema
zwave	Protocolo de comunicación inalámbrica de baja potencia para la automatización del hogar
actuator	Mover o controlar un mecanismo
air	La lectura proviente de la mezcla de gases que rodea la tierra\r\nConcentración de contaminantes en el aire\r\nDimensión del área en donde se encuentra el sitio\r\nPresencia de dióxido de carbono\r\nCoordenadas geográficas del sitio\r\nNombre a mostrar del equipo\r\nNombre a mostrar del sitio\r\nNombre a mostrar del punto\r\nAsociado a la electricidad, la carga eléctrica\r\nId que referencia al equipo que contiene al sensor\r\nDirección geográfica del sitio\r\nEl sensor mide la humedad del ambiente\r\nIdentificador del punto\r\nIdentificador del Sitio\r\nidentificador del equipo\r\nTipo de dato retornado por el sensor\r\nFactor de potencia eléctrica\r\nEnergía consumida por unidad de tiempo\r\nPunto de conexión/desconexión principal de un equipo\r\nId que referencia al sitio donde se encuentra el sensor\r\nid que referencia al Sitio donde se encuentra el equipo\r\nzona horaria del sitio\r\nUnidad de medidad del sensor\r\nTensión eléctrica, diferencia de potencial
coord	Coordenadas geográficas del sitio
elec	Asociado a la electricidad, la carga eléctrica
equipRef	Id que referencia al equipo que contiene al sensor
geoAddr	Dirección geográfica del sitio
humidity	El sensor mide la humedad del ambiente
id	Identificador de entidad
kind	Tipo de dato retornado por el sensor
pf	Factor de potencia eléctrica
power	Energía consumida por unidad de tiempo
run	Punto de conexión/desconexión principal de un equipo
siteRef	id que referencia al Sitio donde se encuentra el equipo
tz	zona horaria del sitio
unit	Unidad de medidad del sensor
volt	Tensión eléctrica, diferencia de potencial
\.


--
-- TOC entry 3384 (class 0 OID 16554)
-- Dependencies: 215
-- Data for Name: point; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.point (id, dis, tags, created_at, updated_at, "siteRef", "equipRef", clave_esperada) FROM stdin;
\.


--
-- TOC entry 3378 (class 0 OID 16521)
-- Dependencies: 209
-- Data for Name: registros_sensores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.registros_sensores (id, point_id, timestamp_registro, registro) FROM stdin;
\.


--
-- TOC entry 3385 (class 0 OID 16563)
-- Dependencies: 216
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, rol) FROM stdin;
5c8a5313-6099-46d8-b95e-fd5f106b4e24	administrador
ad64424d-ea9a-4b28-8e6a-1e910133fbb4	desarrollador
\.


--
-- TOC entry 3386 (class 0 OID 16569)
-- Dependencies: 217
-- Data for Name: site; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.site (id, dis, tags, updated_at, created_at) FROM stdin;
\.


--
-- TOC entry 3387 (class 0 OID 16577)
-- Dependencies: 218
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuarios (id, nombre, correo, role_id) FROM stdin;
\.


--
-- TOC entry 3399 (class 0 OID 0)
-- Dependencies: 213
-- Name: etiquetas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.etiquetas_id_seq', 26, true);


--
-- TOC entry 3220 (class 2606 OID 16585)
-- Name: entidades entidades_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entidades
    ADD CONSTRAINT entidades_pk PRIMARY KEY (id);


--
-- TOC entry 3222 (class 2606 OID 16587)
-- Name: equip equip_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equip
    ADD CONSTRAINT equip_pk PRIMARY KEY (id);


--
-- TOC entry 3224 (class 2606 OID 16589)
-- Name: etiquetas etiquetas_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.etiquetas
    ADD CONSTRAINT etiquetas_pk PRIMARY KEY (id);


--
-- TOC entry 3226 (class 2606 OID 16591)
-- Name: etiquetas etiquetas_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.etiquetas
    ADD CONSTRAINT etiquetas_un UNIQUE (tag, entidad_id);


--
-- TOC entry 3228 (class 2606 OID 16593)
-- Name: haystack_tags haystack_tags_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.haystack_tags
    ADD CONSTRAINT haystack_tags_pk PRIMARY KEY (tag);


--
-- TOC entry 3230 (class 2606 OID 16595)
-- Name: point point_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.point
    ADD CONSTRAINT point_pk PRIMARY KEY (id);


--
-- TOC entry 3218 (class 2606 OID 16597)
-- Name: registros_sensores registros_sensores_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registros_sensores
    ADD CONSTRAINT registros_sensores_pk PRIMARY KEY (id);


--
-- TOC entry 3232 (class 2606 OID 16599)
-- Name: site site_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.site
    ADD CONSTRAINT site_pk PRIMARY KEY (id);


--
-- TOC entry 3234 (class 2606 OID 16600)
-- Name: equip equip_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equip
    ADD CONSTRAINT equip_fk FOREIGN KEY ("siteRef") REFERENCES public.site(id);


--
-- TOC entry 3235 (class 2606 OID 16605)
-- Name: etiquetas etiquetas_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.etiquetas
    ADD CONSTRAINT etiquetas_fk FOREIGN KEY (entidad_id) REFERENCES public.entidades(id);


--
-- TOC entry 3237 (class 2606 OID 16610)
-- Name: point point_equipRef_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.point
    ADD CONSTRAINT "point_equipRef_fkey" FOREIGN KEY ("equipRef") REFERENCES public.equip(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 3238 (class 2606 OID 16615)
-- Name: point point_siteRef_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.point
    ADD CONSTRAINT "point_siteRef_fkey" FOREIGN KEY ("siteRef") REFERENCES public.site(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 3233 (class 2606 OID 16620)
-- Name: registros_sensores registros_sensores_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registros_sensores
    ADD CONSTRAINT registros_sensores_fk FOREIGN KEY (point_id) REFERENCES public.point(id) ON UPDATE CASCADE;


--
-- TOC entry 3236 (class 2606 OID 16625)
-- Name: etiquetas tags_haystack_etiquetas_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.etiquetas
    ADD CONSTRAINT tags_haystack_etiquetas_fk FOREIGN KEY (tag) REFERENCES public.haystack_tags(tag) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2022-09-23 03:42:05 UTC

--
-- PostgreSQL database dump complete
--

