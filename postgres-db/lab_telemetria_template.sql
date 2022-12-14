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

COMMENT ON TABLE public.equip IS 'equipo f??sico o l??gico dentro de un sitio';


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

COMMENT ON TABLE public.site IS 'un solo edificio con su propia direcci??n';


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
11	dis	Nombre a mostrar del punto	9709a027-9e88-4837-a7ad-5968d95d9d71	Descripci??n	t	P4
13	air	La lectura proviente de la mezcla de gases que rodea la tierra	9709a027-9e88-4837-a7ad-5968d95d9d71	\N	\N	\N
14	humidity	El sensor mide la humedad del ambiente	9709a027-9e88-4837-a7ad-5968d95d9d71	\N	\N	\N
17	airQuality	Concentraci??n de contaminantes en el aire	9709a027-9e88-4837-a7ad-5968d95d9d71	\N	\N	\N
18	co2	Presencia de di??xido de carbono	9709a027-9e88-4837-a7ad-5968d95d9d71	\N	\N	\N
16	unit	Unidad de medidad del sensor	9709a027-9e88-4837-a7ad-5968d95d9d71	Unidad	\N	\N
2	tz	zona horaria del sitio	2d0de53e-30d1-4db5-8668-ec32cf01fcc6	Zona Horaria	\N	S6
1	dis	Nombre a mostrar del sitio	2d0de53e-30d1-4db5-8668-ec32cf01fcc6	Descripci??n	t	S2
5	coord	Coordenadas geogr??ficas del sitio	2d0de53e-30d1-4db5-8668-ec32cf01fcc6	Coordenadas	\N	S5
3	area	Dimensi??n del ??rea en donde se encuentra el sitio	2d0de53e-30d1-4db5-8668-ec32cf01fcc6	Area	\N	S4
4	geoAddr	Direcci??n geogr??fica del sitio	2d0de53e-30d1-4db5-8668-ec32cf01fcc6	Direcci??n	t	S3
7	siteRef	id que referencia al Sitio donde se encuentra el equipo	9a794c3b-2715-454f-ab81-791232cfc4b1	Sitio	t	E1
8	id	identificador del equipo	9a794c3b-2715-454f-ab81-791232cfc4b1	Identificador	\N	E2
6	dis	Nombre a mostrar del equipo	9a794c3b-2715-454f-ab81-791232cfc4b1	Descripci??n	t	E3
20	siteRef	Id que referencia al sitio donde se encuentra el sensor	9709a027-9e88-4837-a7ad-5968d95d9d71	Sitio	t	P1
15	kind	Tipo de dato retornado por el sensor	9709a027-9e88-4837-a7ad-5968d95d9d71	Tipo de Dato	t	P5
9	id	Identificador del Sitio	2d0de53e-30d1-4db5-8668-ec32cf01fcc6	Identificador	t	S1
10	id	Identificador del punto	9709a027-9e88-4837-a7ad-5968d95d9d71	Identificador	\N	P3
21	volt	Tensi??n el??ctrica, diferencia de potencial	9709a027-9e88-4837-a7ad-5968d95d9d71	\N	\N	\N
22	power	Energ??a consumida por unidad de tiempo	9709a027-9e88-4837-a7ad-5968d95d9d71	\N	\N	\N
23	pf	Factor de potencia el??ctrica	9709a027-9e88-4837-a7ad-5968d95d9d71	\N	\N	\N
24	elec	Asociado a la electricidad, la carga el??ctrica	9709a027-9e88-4837-a7ad-5968d95d9d71	\N	\N	\N
25	run	Punto de conexi??n/desconexi??n principal de un equipo	9709a027-9e88-4837-a7ad-5968d95d9d71	\N	\N	\N
26	actuator	Mover o controlar un mecanismo	9709a027-9e88-4837-a7ad-5968d95d9d71	\N	\N	\N
12	temp	El punto mide la temperatura	9709a027-9e88-4837-a7ad-5968d95d9d71	\N	\N	\N
\.


--
-- TOC entry 3383 (class 0 OID 16549)
-- Dependencies: 214
-- Data for Name: haystack_tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.haystack_tags (tag, descripcion) FROM stdin;
absorption	Proceso de enfriamiento utilizando energ??a de la fuente de calor, como el agua caliente
ac	Relacionado con la electricidad de corriente alterna
accumulate	Acumular el valor de la etiqueta durante la herencia y defx
active	Trabajo, operativo, efectivo
ahu	Unidad de tratamiento de aire
ahuZoneDelivery	M??todo de entrega de AHU de aire acondicionado a la zona
airCooling	Enfriando disipando el calor en el aire circundante
airHandlingEquip	Equipo de HVAC que condiciona y entrega aire a trav??s de uno o m??s ventiladores
airQualityZonePoints	Entidad con agrupaci??n l??gica de puntos de calidad del aire de zona
airRef	El aire fluye del referente a esta entidad
airTerminalUnit	Equipo en sistemas de distribuci??n de aire que terminan en el espacio
airVolumeAdjustability	Capacidad del equipo de manejo de aire para ajustar el volumen del flujo de aire
alarm	Notificaci??n de una condici??n que requiere atenci??n
angle	Medici??n de la diferencia relativa de direcci??n entre dos vectores o fasores
apparent	Cantidad percibida
association	Las asociaciones modelan relaciones ontol??gicas entre definiciones
ates	Sistema de almacenamiento de energ??a t??rmica del acu??fero
atesClosedLoop	El ATES utiliza tuber??as cerradas para transportar una mezcla de agua/glicol a trav??s del suelo
atesDesign	Tipo de dise??o del sistema subterr??neo ATES
atesDoublet	El ates tiene uno o m??s pares de un pozo c??lido y fresco separados
atesDoubletPaired	El ates es como un doblete, pero con pozos c??lidos y fr??os espec??ficos vinculados juntos
atesMono	El ates solo tiene un pozo f??sico
atesUnidirectional	Similar a un doblete, pero el agua siempre fluye en la misma direcci??n desde la extracci??n hasta el pozo de infiltraci??n
atmospheric	Relacionado con la atm??sfera de la tierra
avg	Promedio
bacnet	Protocolo de automatizaci??n y control de edificios Ashrae
barometric	Relacionar la presi??n atmosf??rica
baseUri	URI base para normalizar URI relativos
battery	Equipo utilizado para almacenar energ??a el??ctrica
biomass	Material de planta o animal utilizado como combustible para producir electricidad o calor
biomassHeating	Calefacci??n por la combusti??n de biomasa
blowdown	Eliminaci??n del contenedor o tuber??a
blowdownWaterRef	El agua de la explotaci??n fluye del referente a esta entidad
bluetooth	Protocolo de comunicaci??n inal??mbrica de corto alcance
boiler	Equipo para generar agua caliente o vapor para calentar
bool	Valor booleano verdadero o falso
bypass	Tuber??a utilizada para evitar un equipo
cav	Unidad de terminal de volumen de aire constante
centrifugal	Compresi??n a trav??s de un flujo continuo de fluido a trav??s de un impulsor
ch2o	Formaldeh??do (Ch???o)
ch4	Metano (CH???)
children	Lista de prototipos contenidos por esta entidad
childrenFlatten	Lista de aspectos para aplanar en prototipos de ni??os
chilled	La sustancia se enfr??a utilizando el proceso de enfriamiento
chilledBeam	Condiciona a un espacio que usa un intercambiador de calor integrado en el techo
chilledBeamZone	AHU suministra aire a unidades de terminal de haz refrigerado
chilledWaterCooling	Enfriamiento usando la transferencia de calor al agua fr??a
chilledWaterRef	El agua fr??a fluye del referente a esta entidad
chiller	Equipo para eliminar el fuego de un l??quido
chillerMechanism	Mecanismo primario de enfriador
choice	Elecci??n especifica una selecci??n de marcadores exclusivo
circ	Tuber??a utilizada para circular el fluido a trav??s de un equipo o sistema
circuit	Circuito el??ctrico y sus componentes asociados, como interruptores
cloudage	Porcentaje de cielo oscurecido por las nubes
cmd	El punto es un comando, actuador, ao/bo
co	Mon??xido de carbono (CO)
co2e	Di??xido de carbono equivalente
coal	Roca sedimentaria combustible
coalHeating	Calefacci??n por la combusti??n del carb??n
coap	Protocolo de aplicaci??n restringido
coil	Intercambiador de calor utilizado para calentar o enfriar aire
cold	Tener un bajo grado de calor
coldDeck	Conducto lleva aire para enfriar
computed	Indica una definici??n que se calcula
computer	Computadora de prop??sito general
concentration	Abundancia de sustancia en el volumen total de una mezcla
condensate	Fase l??quida producida por la condensaci??n de vapor u otro gas
condensateRef	Los flujos de condensado del referente a esta entidad
condenser	Dispositivo o relacionado con el proceso de condensaci??n
condenserClosedLoop	El fluido de trabajo se mantiene separado del fluido utilizado para la transferencia de calor a la atm??sfera
condenserCooling	Eliminaci??n del calor a trav??s del proceso de condensaci??n de agua
condenserLoop	Circuito abierto o cerrado para el fluido de trabajo del condensador
condenserOpenLoop	Utiliza el fluido de trabajo en s?? para evaporar en la atm??sfera
condenserWaterRef	El agua del condensador fluye del referente a esta entidad
conduit	Conducto, tuber??a o cable para transmitir una sustancia o fen??meno
constantAirVolume	Ofrece un volumen constante de flujo de aire
containedBy	La entidad est?? l??gicamente contenida por el referente
contains	Entidades l??gicamente contenidas por esta entidad
controller	Dispositivo basado en microprocesador utilizado en un sistema de control
controls	Asociado con el sistema de control para un proceso industrial
airQuality	Concentraci??n de contaminantes en el aire
area	Dimensi??n del ??rea en donde se encuentra el sitio
co2	Presencia de di??xido de carbono
cool	Asociado con procesos de baja temperatura o enfriamiento
cooling	Modo de enfriamiento o proceso
coolingCapacity	Medici??n de una capacidad de enfriador para eliminar el calor medido
coolingCoil	Bobina utilizada para enfriar el aire
coolingOnly	Equipo sin calefacci??n
coolingProcess	Procesado utilizado para enfriar una sustancia
coolingTower	Equipo para transferir el calor de los residuos a la atm??sfera
crac	Aire acondicionado de la sala de computadoras
cur	Admite el valor actual
curErr	Descripci??n del error Cuando Curstatus indica la condici??n de error
curStatus	Estado de la lectura del valor actual de Point
curVal	Valor actual de un punto
current	Movimiento de fluido o electricidad
dali	Protocolo de interfaz de iluminaci??n digital direccionable para iluminaci??n
damper	Equipo amortiguador o punto de control
dataCenter	Espacio utilizado para albergar equipos de redes y redes
date	ISO 8601 Fecha como a??o, mes, d??a
dateTime	ISO 8601 marca de tiempo seguido de identificador de zona horaria
daytime	Tiempo entre el amanecer y el atardecer
dc	Relacionado con la electricidad de corriente continua
deadband	El rango en un proceso en el que no se realizan cambios en la producci??n
def	Crear una nueva definici??n vinculada al s??mbolo dado
defx	Extiende la definici??n dada con metaetics adicionales
delta	Diferencial de fluido entre los sensores de entrada y salida
demand	Tasa requerida para un proceso
depends	Lista de las dependencias de esta biblioteca
deprecated	Obsoleto
design	Datos relacionados con el dise??o previsto y las condiciones de funcionamiento
dessicantDehumidifier	Disminuye la humedad del aire usando una sustancia que absorbe la humedad
device	Dispositivo de hardware basado en microprocesador
deviceRef	Dispositivo que controla un monitorea esta entidad
dewPoint	Temperatura del punto de roc??o a la cual el vapor de agua formar?? roc??o
dict	Mapa de pares de etiquetas de nombre/valor
diesel	Combustible l??quido dise??ado espec??ficamente para su uso en motores diesel
directZone	AHU suministra aire directamente a la zona
direction	Direcci??n de br??julas medida en grados
discharge	Conducto para el aire saliendo de un equipo
diverting	V??lvula de tres v??as que ingresa una tuber??a y desv??a entre dos tuber??as de salida
doas	Sistema de aire exterior dedicado
doc	Documentaci??n en sabor simplificado de Markdown
docAssociations	Genere una secci??n en los documentos para esta asociaci??n
docTaxonomy	Generar un ??rbol de taxonom??a para este t??rmino en el DocumentationIndex
domestic	Para uso humano
domesticWaterRef	El agua dom??stica fluye del referente a esta entidad
dualDuct	Dos conductos
duct	Conducto utilizado para transmitir aire para HVAC
ductArea	Punto de configuraci??n en un vav para el ??rea del conducto medido en ft?? o m??
ductConfig	Configuraci??n de conductos
ductDeck	Cubierta fr??a, caliente o neutral
ductSection	Secci??n de equipos de conductos
duration	N??mero con una unidad de tiempo
dxCooling	Enfriamiento utilizando la expansi??n directa de un vapor de refrigerante
dxHeating	Calefacci??n utilizando la expansi??n directa de un vapor de refrigerante
economizer	Conducto para acceder al aire libre reci??n salido solo para economizar, no de ventilaci??n
economizing	Modo de reducci??n de energ??a que aumenta el calentamiento/enfriamiento con aire exterior
effective	Punto de ajuste de control actual en efecto teniendo en cuenta otros factores
efficiency	Punto de eficiencia de un enfriador medido en "COP" o "KW/TON"
elecHeating	Calentamiento mediante la conversi??n de energ??a el??ctrica
elecRef	La electricidad fluye del referente a esta entidad
elevator	Recinto utilizado para mover a las personas entre pisos
emission	Cantidad de una sustancia descargada en el aire
enable	Punto secundario de encendido/apagado de un equipo especialmente utilizado con un VFD
energy	Medida de la capacidad de hacer el trabajo
entering	La tuber??a transmite fluido a un equipo
enthalpy	Contenido total de calor de un sistema
entity	Dictos de nivel superior con un identificador ??nico
enum	Define una eumeraci??n de nombres de teclas de cadena
equip	Activo de equipo
escalator	Moving Staircase sol??a mover a las personas entre pisos
evaporator	Mecanismo utilizado para convertir un refrigerante de su l??quido a estado gaseoso
exhaust	Conducto sol??a expulsar el aire hacia afuera
export	Suministrado fuera de un sistema
extraction	Sacar una sustancia de otra sustancia
faceBypass	El punto de un AHU que indica el flujo de aire es transmitir las bobinas de calefacci??n/enfriamiento
fan	Equipo de ventilador o punto de control
fanPowered	Dispositivo con ventilador
fcu	Unidad de bobina del ventilador
feature	Espacio de nombres de caracter??sticas de las definiciones formateadas como caracter??stica: Nombre
feelsLike	La temperatura aparente percibida al considerar la humedad, la fr??o del viento y el ??ndice de calor
fileExt	Extensi??n del nombre de archivo como "CSV"
filetype	Definici??n de tipo de formato de archivo
filter	Relacionado con un filtro de aire o fluido
filterStr	Cadena de filtro de henoStack
floor	Piso de un edificio
dis	Nombre a mostrar de la entidad
floorNum	Entero sin unidad que indica la distancia del piso desde el nivel del suelo
flow	Medida del flujo volum??trico de fluido
flowInverter	Sistema para cambiar la direcci??n del flujo de sustancias
flue	Conducto para una combusti??n agotadora
fluid	L??quido o gas
flux	Medici??n a trav??s de una superficie dada
freezeStat	Un punto booleano de un AHU que indica una condici??n de congelaci??n
freq	Ocurrencias por unidad de tiempo
ftp	Protocolo de transferencia de archivos
fuelOil	Aceite a base de petr??leo quemado por energ??a
fuelOilHeating	Calefacci??n por la combusti??n de combustible
fuelOilRef	El aceite de combustible fluye del referente a esta entidad
fumeHood	Equipo de ventilaci??n para limitar la exposici??n a humos peligrosos
gas	Sustancia sin volumen ni forma definido
gasoline	L??quido derivado de petr??leo utilizado como fuente de combustible
gasolineRef	La gasolina fluye del referente a esta entidad
geoCity	Nombre de la ciudad o localidad geogr??fica
geoCoord	Coordenada geogr??fica como C (latitud, longitud)
geoCountry	Pa??s geogr??fico como ISO 3166-1 C??digo de dos letras
geoCounty	Subdivisi??n geogr??fica del estado estadounidense
geoElevation	Elevaci??n sobre el nivel del mar de la ubicaci??n
geoPlace	Lugar geogr??fico
geoPostalCode	C??digo postal geogr??fico
geoState	Nombre del estado o provincia
geoStreet	Direcci??n y nombre de la calle geogr??fica
grid	Tabla de dos dimensiones de columnas y filas
ground	Relacionado con la superficie de la tierra
haystack	Protocolo HTTP de Haystack para intercambiar datos etiquetados
header	Tuber??a utilizada como conexi??n central o colector para otras carreras de tuber??as
heat	Asociado con un proceso de calefacci??n
heatExchanger	Equipo para transferir calor entre dos fluidos de trabajo
heatPump	Bomba de calor
heatWheel	Punto booleano que indica el estado de comando de la rueda de calor de Ahu
heating	Modo de calefacci??n o proceso
heatingCoil	Bobina utilizada para calentar el aire
heatingOnly	Equipo sin enfriamiento
heatingProcess	Procesado utilizado para calentar una sustancia
hfc	Hidrofluorocarbonos
his	Admite la historizaci??n de datos
hisErr	Descripci??n del error Cuando Hisstatus indica la condici??n de error
hisMode	Indica la forma en que se recopilan los datos del historial para un punto
hisStatus	Estado de la colecci??n o sincronizaci??n del historial de Point
hisTotalized	Indica valores que son un flujo continuo de totalizaci??n
hot	Tener un alto grado de calor
hotDeck	Conducto lleva aire para calentar
hotWaterHeating	Calefacci??n con energ??a de agua caliente
hotWaterRef	El agua caliente fluye del referente a esta entidad
http	Protocolo de transferencia de hipertexto que es la base de la web
humidifier	Agregar humedad al aire
hvac	Calefacci??n, ventilaci??n y aire acondicionado
hvacMode	Modo operativo para equipos HVAC
hvacZonePoints	Entidad con agrupaci??n l??gica de los puntos a??reos de la zona HVAC
ice	Agua en su forma s??lida
illuminance	Flujo luminoso que golpea el interior de la esfera en un punto espec??fico
imap	Protocolo de acceso a mensajes de Internet para recuperar el correo electr??nico
imbalance	Falta de equilibrio
import	Recibido en un sistema
infiltration	Pregimiento de una sustancia en otra sustancia
inlet	Conducto con aire que ingresa a un equipo
input	Entidad ingresa una sustancia que fluye de otra entidad
inputs	La entidad ingresa una sustancia del referente
int	N??mero entero sin unidad
intensity	Medida de un campo electromagn??tico
irradiance	Energ??a recibida en una superficie por ??rea
is	Define uno o m??s supertipos de una relaci??n subtitut??tica
isolation	Actuador utilizado para aislar un equipo de una tuber??a o sistema de conductos
knx	Protocolo KNX com??nmente utilizado para sistemas de iluminaci??n
laptop	Computadora port??til port??til
leaving	La tuber??a transmite fluido fuera de un equipo
level	Var??a del 0% al 100%
lib	M??dulo de biblioteca de definiciones simb??licas
light	Radiaci??n electromagn??tica en el espectro visible
lighting	Sistemas asociados con la iluminaci??n en el entorno construido
lightingZonePoints	Entidad con agrupaci??n l??gica de puntos de iluminaci??n
liquid	Sustancia con volumen definitivo pero toma la forma de su contenedor
list	Lista ordenada de cero o m??s valores
load	El enfriador apunta a comandar o medir la carga del enfriador como un porcentaje de "0%" a "100%"
luminaire	Luz de luz utilizando electricidad para proporcionar iluminaci??n
luminance	Energ??a de la luz en una direcci??n dada
luminous	Relacionado con la luz como percibido por el ojo
magnitude	Tama??o o extensi??n
makeup	Restaurar algo perdido o perdido
makeupWaterRef	El agua de maquillaje fluye del referente a esta entidad
mandatory	Requiere que el marcador se aplique a los dicts que usan los subtipos del marcador
marker	Marcador etiqueta un dict con informaci??n de escritura
mau	Unidad de aire de composici??n
max	M??ximo
maxVal	M??ximo inclusivo para un valor num??rico
meter	Equipo para medir una sustancia o fen??meno
meterScope	Clasifica un medidor como un medidor o subm??ter del sitio principal
mime	Tipo de MIME formateado como tipo/subtipo
min	M??nimo
minVal	M??nimo inclusivo para un valor num??rico
mixed	Conducto donde se mezcla el aire libre y el aire de retorno
mixing	V??lvula de tres v??as que ingresa dos tuber??as y emite una mezcla entre los dos y una sola tuber??a de salida
mobile	Relacionado con tel??fonos m??viles, computadoras de mano y tecnolog??a similar
modbus	Protocolo de comunicaci??n basado en registros utilizado con dispositivos industriales
motor	Equipo que convierte la energ??a el??ctrica en energ??a mec??nica
movingWalkway	Transportador para mover a las personas a trav??s de un plano horizontal o inclinado
mqtt	Protocolo de publicaci??n/suscripci??n de la telemetr??a de colas de mensajes
multiZone	El aire de descarga de ahu se divide en un conducto por zona
n2o	??xido nitroso (N???O)
na	No disponible para indicar datos no v??lidos o faltantes
naturalGas	Fuente de energ??a de combustible f??sil que consiste en gran parte de metano y otros hidrocarburos
naturalGasHeating	Calentamiento por la combusti??n del gas natural
naturalGasRef	El gas natural fluye del referente a esta entidad
net	Diferencia entre importaci??n y exportaci??n
network	Red de comunicaciones l??gicas entre dos o m??s dispositivos
networkRef	Asocia un dispositivo que se comunica en una red espec??fica
networking	Relacionado con las redes de comunicaci??n de datos
neutralDeck	El conducto lleva aire que pasa por alto tanto las bobinas de calefacci??n como de enfriamiento
nf3	Trifluoruro de nitr??geno (NF???)
nh3	Amon??aco (NH???)
no2	Di??xido de nitr??geno (NO???)
noSideEffects	Marca una funci??n u operaci??n que no tiene efectos secundarios
nodoc	Indocumentado y no compatible oficial
nosrc	No incluya el c??digo fuente en la documentaci??n
notInherited	Marcador aplicado a un DEF para indicar que no se hereda en definiciones de subtipo
number	N??meros enteros o de punto flotante anotados con una unidad opcional
o2	Ox??geno (O???) - La alotrape de diox??geno com??n en el aire
o3	Ozono (o???)
obix	Protocolo de intercambio de informaci??n de construcci??n abierta basado en XML
occ	Modo ocupado de un espacio
occupancy	N??mero de ocupantes en un espacio
occupants	Personas que usan el entorno construido
occupied	Punto de ajuste o sensor que indica la ocupaci??n de un espacio
of	Tipo de valor esperado de una colecci??n, referencia o elecci??n
op	Operaci??n para la API HTTP
openEnum	Aplicar a las etiquetas STR enum donde el rango de enumeraci??n est?? abierto
output	La entidad emite una sustancia con flujos a otras entidades
outputs	La entidad emite una sustancia al referente
outside	Conducto para acceder al aire exterior fresco para la ventilaci??n y el economizador
panel	Recinto para equipos el??ctricos y de control
parallel	Circuito con m??ltiples rutas de flujo
perimeterHeat	Puntos de calefacci??n auxiliares asociados con un VAV
pfc	Perfluorocarbons
phase	Medici??n de fase en un sistema el??ctrico trif??sico
phenomenon	Aspecto del inter??s cient??fico con cantidades medibles
phone	Tel??fono utilizado para telecomunicaciones de voz
pipe	Conducto utilizado para transmitir un fluido
pipeFluid	Tipo de fluido transmitido por tuber??as
pipeSection	Secci??n de equipos de tuber??as
plant	Planta central utilizada para generar una sustancia para un proceso
plantLoop	Bucle de tuber??as de plantas
pm01	Part??cula 0.1
pm10	Part??cula 10
pm25	Part??cula 2.5
point	Punto de datos como un sensor o actuador
pointFunction	Clasifica el punto como sensor, comando o punto de ajuste
pointGroup	Agrupaci??n de puntos para ni??os utilizados por espacios y equipos
pointQuantity	Cantidad el punto siente o controla
pointSubject	Lo que el punto siente o controla
pop3	Protocolo de correos Versi??n 3 para recuperar el correo electr??nico
precipitation	Cantidad de vapor de agua atmosf??rica ca??da, incluida lluvia, aguanieve, nieve y granizo
prefUnit	Define una unidad preferida que se utilizar?? con una cantidad
pressure	Medida de fuerza aplicada
pressureDependent	VAV Damper modula para controlar la temperatura del espacio
pressureIndependent	VAV Damper o una v??lvula de control que se modula para mantener el punto de ajuste de flujo deseado
primaryFunction	Funci??n principal de la construcci??n como la tecla de estrella de energ??a de EE. UU.
primaryLoop	Pipework que circula m??s cercano a la fuente de energ??a
process	Proceso industrial o de HVAC
propane	Subproducto del procesamiento de gas natural y refinaci??n de petr??leo (C???H???)
propaneHeating	Calefacci??n por la combusti??n de propano
protocol	Protocolo de comunicaci??n utilizado para dispositivos en una red
pump	Equipo de bomba o punto de control
purge	Asociado con un proceso de limpieza para eliminar contaminantes
quality	Cantidad medida contra la m??trica est??ndar
quantities	Cantidades utilizadas para medir este fen??meno
quantity	Propiedad medible de una sustancia o fen??meno
quantityOf	Asociado la cantidad como medici??n de un fen??meno
rack	Recinto o chasis utilizado para montar la computadora y el equipo de redes
radiantEquip	Equipo HVAC que condiciona un espacio sin aire forzado
radiantFloor	Calienta un espacio con tuber??as o cables incrustados debajo del piso
radiator	Calienta un espacio usando tuber??as o bobinas expuestas
rated	Datos especificados por un fabricante o organizaci??n de calificaci??n
reactive	Relativo a la reactancia
reciprocal	Compresor de pist??n impulsado por un cig??e??al
reciprocalOf	Especifica lo inverso de una asociaci??n o relaciones
ref	Referencia a una entidad
refrig	Fluido utilizado en refrigeraci??n e intercambio de calor
refrigRef	El refrigerante fluye del referente a esta entidad
reheat	Punto de comando para el proceso de recalentamiento
relationship	Etiquetas de referencia utilizadas para modelar relaciones de entidad a entidad
remove	Singleton para eliminar la operaci??n
return	Conducto que devuelve el aire de regreso al equipo
roof	Sobre cubriendo la parte superior de un edificio
room	Habitaci??n cerrada de un edificio
rotaryScrew	Compresi??n de tornillo rotativo
router	Dispositivo utilizado para enrutar paquetes de datos
rtu	Unidad de techo
scalar	Scalar es un valor at??mico
secondaryLoop	Tuber??as que circulan m??s cerca del edificio o uso final
sensor	El punto es un sensor, entrada, AI/BI
series	Circuito con ruta ??nica de flujo
server	Hardware o software que proporciona servicios para otros programas o dispositivos
sf6	Hexafluoruro de azufre (SF???)
singleDuct	Un solo conducto
site	El sitio es una ubicaci??n geogr??fica del entorno construido
siteMeter	Medidor principal para el sitio asociado
smtp	Protocolo de transferencia de correo simple para enviar correo electr??nico
snmp	Protocolo simple de gesti??n de redes para administrar dispositivos IP
solar	Relacionado con la energ??a del sol
solid	Sustancia con forma y volumen definidos
sox	Protocolo de comunicaci??n basado en UDP marco de Sedona
sp	El punto es un punto de ajuste, punto suave, variable de control interno, programaci??n
space	El espacio es un volumen tridimensional en el entorno construido
spaceRef	Referencia al espacio que contiene esta entidad
span	El tramo de tiempo modelado codificado como XSTR
speed	Distancia por unidad de tiempo
stage	N??mero de etapa de operaci??n de equipos escenificados como bobina o bomba
standby	Modo de preparaci??n de un espacio
steam	Agua en su forma de gas
steamHeating	Calefacci??n con energ??a de vapor
steamRef	El vapor fluye del referente a esta entidad
str	Cadena de caracteres unicode
submeter	Los submeters miden el uso de un subsistema o equipo dentro de un sitio
submeterOf	Referencia al medidor principal que est?? inmediatamente aguas arriba de este medidor
substance	Materia en uno de los tres estados s??lidos, l??quidos o de gas
subterranean	Debajo de la superficie de la tierra
switch	Dispositivo para alternar el estado o los datos de enrutamiento
symbol	S??mbolo a un def
tablet	Dispositivo m??vil con pantalla t??ctil para la entrada del usuario
tagOn	Esta etiqueta se usa en la entidad dada
tags	Etiquetas utilizadas con esta entidad
tank	Tanque utilizado para almacenar una sustancia para una tenencia temporal
tankSubstance	Sustancia almacenada por un tanque
temp	Temperatura: medida de calor y fr??o
tertiaryLoop	Tuber??as que circulan dentro del edificio
thd	Distorsi??n arm??nica total
thermal	Relacionado con la energ??a del calor
thermostat	Sentidos y controla la temperatura del espacio en el sistema HVAC
time	ISO 8601 tiempo como hora, minuto, segundos
total	Completo o absoluto
transient	Indica una etiqueta de valor que no debe persistirse
transitive	Este marcador se aplica a una relaci??n para indicar que es transitivo
tripleDuct	Tres conductos
tvoc	Compuesto org??nico vol??til total (TVOC)
unitVent	Ventilador unitario
unocc	Modo desocupado de un espacio
ups	Fuente de poder ininterrumpible
uri	Identificador de recursos universales
val	Tipo de valor de datos
valve	Equipo de v??lvula o punto de control
variableAirVolume	Ofrece un volumen variable de flujo de aire
vav	Unidad de terminal de volumen de aire variable
vavAirCircuit	??C??mo se pone el vav en aire?
vavModulation	??C??mo modula VAV la temperatura basada en la presi??n del conducto?
vavZone	AHU suministra aire a las unidades de terminal VAV
velocity	Velocidad en una direcci??n dada
ventilation	Conducto para acceder al aire libre reci??n salido solo para la ventilaci??n, no economizar
version	Cadena de versi??n formateada como enteros decimales separados por un punto
verticalTransport	Equipo para mover humanos y materiales
vfd	Unidad de frecuencia variable
visibility	Distancia a la que la luz se puede discernir claramente
volume	Espacio tridimensional ocupado por una sustancia
warm	Relativamente c??lido en comparaci??n con otra sustancia, sin ser calentado activamente
water	Agua en su forma l??quida
waterCooling	Enfriamiento usando la transferencia de calor al agua que no se enfr??a expl??citamente
weather	Asociado con el aire o el fen??meno atmosf??rico
weatherCond	Enumeraci??n de condiciones clim??ticas
weatherStation	Estaci??n meteorol??gica l??gica y sus puntos de medici??n
weatherStationRef	Referencia a la estaci??n meteorol??gica para usar esta entidad
well	Un pozo es una fuente de agua subterr??nea y energ??a potencialmente t??rmica
wetBulb	Temperatura del aire de bulbo h??medo
wikipedia	Hiperv??nculo a la p??gina del sujeto en Wikipedia
wind	Flujo de aire en la superficie de la tierra
wire	Cableado utilizado para transmitir electricidad o datos
writable	Admite escribir datos
writeErr	Descripci??n del error Cuando WriteStatus indica la condici??n de error
writeLevel	Nivel de prioridad actual para WriteVal como n??mero entre 1 y 17
writeStatus	Estado actual de una salida de punto de escritura
writeVal	Valor actual deseado para escribir en la salida
xstr	Cadena extendida: tipo de nombre de nombre y valor de cadena
yearBuilt	A??o original de construcci??n como un a??o de cuatro d??gitos, como 1980
zigbee	Protocolo de comunicaci??n inal??mbrica de baja potencia para la automatizaci??n del hogar
zone	Relacionado con espacios desde una perspectiva del sistema
zwave	Protocolo de comunicaci??n inal??mbrica de baja potencia para la automatizaci??n del hogar
actuator	Mover o controlar un mecanismo
air	La lectura proviente de la mezcla de gases que rodea la tierra\r\nConcentraci??n de contaminantes en el aire\r\nDimensi??n del ??rea en donde se encuentra el sitio\r\nPresencia de di??xido de carbono\r\nCoordenadas geogr??ficas del sitio\r\nNombre a mostrar del equipo\r\nNombre a mostrar del sitio\r\nNombre a mostrar del punto\r\nAsociado a la electricidad, la carga el??ctrica\r\nId que referencia al equipo que contiene al sensor\r\nDirecci??n geogr??fica del sitio\r\nEl sensor mide la humedad del ambiente\r\nIdentificador del punto\r\nIdentificador del Sitio\r\nidentificador del equipo\r\nTipo de dato retornado por el sensor\r\nFactor de potencia el??ctrica\r\nEnerg??a consumida por unidad de tiempo\r\nPunto de conexi??n/desconexi??n principal de un equipo\r\nId que referencia al sitio donde se encuentra el sensor\r\nid que referencia al Sitio donde se encuentra el equipo\r\nzona horaria del sitio\r\nUnidad de medidad del sensor\r\nTensi??n el??ctrica, diferencia de potencial
coord	Coordenadas geogr??ficas del sitio
elec	Asociado a la electricidad, la carga el??ctrica
equipRef	Id que referencia al equipo que contiene al sensor
geoAddr	Direcci??n geogr??fica del sitio
humidity	El sensor mide la humedad del ambiente
id	Identificador de entidad
kind	Tipo de dato retornado por el sensor
pf	Factor de potencia el??ctrica
power	Energ??a consumida por unidad de tiempo
run	Punto de conexi??n/desconexi??n principal de un equipo
siteRef	id que referencia al Sitio donde se encuentra el equipo
tz	zona horaria del sitio
unit	Unidad de medidad del sensor
volt	Tensi??n el??ctrica, diferencia de potencial
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

