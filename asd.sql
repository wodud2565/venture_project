--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3
-- Dumped by pg_dump version 16.3

-- Started on 2024-09-04 15:40:56

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
-- TOC entry 223 (class 1259 OID 24589)
-- Name: comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comments (
    id integer NOT NULL,
    post_id integer NOT NULL,
    parent_id integer,
    content text NOT NULL,
    author character varying(100) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    is_edited boolean DEFAULT false,
    like_count integer DEFAULT 0
);


ALTER TABLE public.comments OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 24588)
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.comments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.comments_id_seq OWNER TO postgres;

--
-- TOC entry 4895 (class 0 OID 0)
-- Dependencies: 222
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;


--
-- TOC entry 225 (class 1259 OID 24611)
-- Name: likes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.likes (
    id integer NOT NULL,
    post_id integer NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.likes OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 24610)
-- Name: likes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.likes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.likes_id_seq OWNER TO postgres;

--
-- TOC entry 4896 (class 0 OID 0)
-- Dependencies: 224
-- Name: likes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.likes_id_seq OWNED BY public.likes.id;


--
-- TOC entry 221 (class 1259 OID 24577)
-- Name: posts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.posts (
    id integer NOT NULL,
    title character varying(100) NOT NULL,
    content text NOT NULL,
    author character varying(100) NOT NULL,
    category character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    is_edited boolean DEFAULT false,
    like_count integer DEFAULT 0,
    views integer DEFAULT 0
);


ALTER TABLE public.posts OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 24576)
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.posts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.posts_id_seq OWNER TO postgres;

--
-- TOC entry 4897 (class 0 OID 0)
-- Dependencies: 220
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;


--
-- TOC entry 219 (class 1259 OID 16437)
-- Name: session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.session (
    sid character varying NOT NULL,
    sess json NOT NULL,
    expire timestamp with time zone NOT NULL
);


ALTER TABLE public.session OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16427)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying(100) NOT NULL,
    nickname character varying(12) NOT NULL,
    is_social boolean DEFAULT false NOT NULL,
    password character varying(255),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16426)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 4898 (class 0 OID 0)
-- Dependencies: 217
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 216 (class 1259 OID 16408)
-- Name: vehicle; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vehicle (
    "제조국" character(5),
    "브랜드" character(15),
    "이름" character varying(50),
    "최소가격" integer,
    "최대가격" integer,
    "차종" character varying(10),
    "엔진" character varying(30),
    "최소연비" double precision,
    "최대연비" double precision,
    "최소출력" double precision,
    "최대출력" double precision,
    "출시년도" integer,
    "사진번호" integer NOT NULL
);


ALTER TABLE public.vehicle OWNER TO postgres;

--
-- TOC entry 4714 (class 2604 OID 24592)
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


--
-- TOC entry 4718 (class 2604 OID 24614)
-- Name: likes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.likes ALTER COLUMN id SET DEFAULT nextval('public.likes_id_seq'::regclass);


--
-- TOC entry 4709 (class 2604 OID 24580)
-- Name: posts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);


--
-- TOC entry 4706 (class 2604 OID 16430)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 4887 (class 0 OID 24589)
-- Dependencies: 223
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comments (id, post_id, parent_id, content, author, created_at, is_edited, like_count) FROM stdin;
3	24	\N	ㅁㅁㅁㅁㅁㅁ	email	2024-08-19 22:20:03.443956	f	0
4	24	\N	ㅋㅋㅋㅋㅋㅋㅋ	email	2024-08-21 18:09:03.562638	f	0
7	24	3	ㅇㅇㅇㅇㅇㅇ	email	2024-08-22 21:19:35.166852	f	0
8	24	3	안녕하세요	email	2024-08-22 22:03:08.271968	f	0
9	24	\N	ㅇ안녕ㅇ하하세세요요	email	2024-08-22 22:05:10.555242	f	0
10	24	\N	ㅋㅋㅋㅋㅋㅋ	email	2024-08-22 22:07:18.899121	f	0
11	24	9	ㅋㅋㅋㅋㅋㅋㅋ	email	2024-08-22 22:07:28.051843	f	0
12	24	\N		email	2024-08-22 22:41:52.653714	f	0
13	24	10	ㅁㄴㅇㅁㄴㅇ	email	2024-08-22 22:48:45.440554	f	0
14	23	\N	ㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁ	email	2024-08-22 22:49:28.026131	f	0
15	24	\N	ㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁ	email	2024-08-22 22:50:25.371929	f	0
16	23	14	ㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴ	email	2024-08-22 22:50:43.882722	f	0
17	24	15	 	email	2024-08-22 22:56:45.614969	f	0
\.


--
-- TOC entry 4889 (class 0 OID 24611)
-- Dependencies: 225
-- Data for Name: likes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.likes (id, post_id, user_id, created_at) FROM stdin;
\.


--
-- TOC entry 4885 (class 0 OID 24577)
-- Dependencies: 221
-- Data for Name: posts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.posts (id, title, content, author, category, created_at, is_edited, like_count, views) FROM stdin;
2	두 번째 게  시글	<p>ㅋㅋㅋㅋ</p>	email	질문	2024-08-16 01:35:34.353469	f	0	0
4	페이징 테스트	<p>ㅋㅋ</p>	email	자유	2024-08-16 17:38:30.013277	f	0	0
5	페이징 테스트	<p>ㅋㅋ</p>	email	자유	2024-08-16 17:38:31.238212	f	0	0
6	페이징 테스트	<p>ㅋㅋ</p>	email	자유	2024-08-16 17:38:31.924375	f	0	0
7	페이징 테스트	<p>ㅋㅋ</p>	email	자유	2024-08-16 17:38:32.551436	f	0	0
8	페이징 테스트	<p>ㅋㅋ</p>	email	자유	2024-08-16 17:38:33.256958	f	0	0
9	페이징 테스트	<p>ㅋㅋ</p>	email	자유	2024-08-16 17:38:33.952016	f	0	0
10	페이징 테스트	<p>ㅋㅋ</p>	email	자유	2024-08-16 17:38:34.610166	f	0	0
11	페이징 테스트	<p>ㅋㅋ</p>	email	자유	2024-08-16 17:38:35.261745	f	0	0
12	페이징 테스트	<p>ㅋㅋ</p>	email	자유	2024-08-16 17:38:35.888268	f	0	0
13	페이징 테스트	<p>ㅋㅋ</p>	email	자유	2024-08-16 17:38:36.510241	f	0	0
14	페이징 테스트	<p>ㅋㅋ</p>	email	자유	2024-08-16 17:38:37.159336	f	0	0
15	페이징 테스트	<p>ㅋㅋ</p>	email	자유	2024-08-16 17:38:37.787198	f	0	0
16	페이징 테스트	<p>ㅋㅋ</p>	email	자유	2024-08-16 17:38:38.435007	f	0	0
17	페이징 테스트	<p>ㅋㅋ</p>	email	자유	2024-08-16 17:38:39.065919	f	0	0
18	페이징 테스트	<p>ㅋㅋ</p>	email	자유	2024-08-16 17:38:39.694046	f	0	0
19	페이징 테스트	<p>ㅋㅋ</p>	email	자유	2024-08-16 17:38:40.278044	f	0	0
20	페이징 테스트	<p>ㅋㅋ</p>	email	자유	2024-08-16 17:38:40.872465	f	0	0
21	페이징 테스트	<p>ㅋㅋ</p>	email	자유	2024-08-16 17:38:41.558471	f	0	2
24	ㅁㅁㅁㅁㅁ	<p>ㅁㅁㅁㅁㅁㅁ</p>	email	자유	2024-08-18 21:53:34.362108	f	0	9
22	페이징 테스트	<p>ㅋㅋ</p>	email	자유	2024-08-16 17:38:42.186652	f	0	1
23	페이징 테스트	<p>ㅋㅋ</p>	email	자유	2024-08-16 17:38:42.79191	t	0	65
3	세 번째 게  시글	<p>ㅋㅋㅋㅋㅁㅁㅁㅁㅁㅁ<span style="color: rgb(230, 0, 0);">ㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁ</span><span style="color: rgb(230, 0, 0); background-color: rgb(255, 153, 0);">ㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㄴㄴㄴ</span></p><h1 class="ql-indent-1"><span style="color: rgb(230, 0, 0); background-color: rgb(255, 153, 0);">ㅁㄴㅇㅇㅁㄴㅇㅁㄴㅇ</span><sub style="color: rgb(230, 0, 0); background-color: rgb(255, 153, 0);">ㅁㄴㅇㅇ</sub><sup style="color: rgb(230, 0, 0); background-color: rgb(255, 153, 0);">ㅁㄴㅇㅁㄴㅇㅇ</sup></h1>	email	질문	2024-08-16 01:36:13.52387	f	0	3
1	ㅁㅁㅁㅁㅁㅁ	<p>ㅁㄴㅇㅁㄴㅇ</p>	email	자유	2024-08-16 01:33:57.290571	f	0	2
\.


--
-- TOC entry 4883 (class 0 OID 16437)
-- Dependencies: 219
-- Data for Name: session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.session (sid, sess, expire) FROM stdin;
\.


--
-- TOC entry 4882 (class 0 OID 16427)
-- Dependencies: 218
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, nickname, is_social, password, created_at) FROM stdin;
1	wa@a.a	asd	f	$2b$10$FPc8tCa/sHkgpOlmfg7.OO6DiPyMSi9Wq796P0.OQtx2C.JJI6zKe	2024-07-17 18:35:21.393865+09
2	wang@a.a	asdd	f	$2b$10$nxvSLENGMohUJwJ8ZZcTaOQGOlg/e.IrrUtBgRIT2OvyBH3ZicNui	2024-07-17 18:38:36.985691+09
3	wanghj2574@gmail.com	주르를르륵	t	\N	2024-07-18 16:17:22.144948+09
4	wanghj99@naver.com	현준	f	$2b$10$uj.Pj1MsaAW4qrr/XkMenezdjxKiCf0/DraSSq38/L7N1tms8uQR6	2024-07-21 17:22:22.641576+09
\.


--
-- TOC entry 4880 (class 0 OID 16408)
-- Dependencies: 216
-- Data for Name: vehicle; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vehicle ("제조국", "브랜드", "이름", "최소가격", "최대가격", "차종", "엔진", "최소연비", "최대연비", "최소출력", "최대출력", "출시년도", "사진번호") FROM stdin;
한국   	현대             	포터2	1719	2546	화물	LPG, 디젤	6.3	7	138	159	2024	1204
한국   	기아             	봉고3 트럭	1659	2631	화물	디젤, LPG	6.5	9.9	133	159	2020	1234
유럽   	벤츠             	S-Class	22760	22760	대형	가솔린	7.3	11	286	612	2021	1322
유럽   	마세라티           	Ghibli	13600	20200	중형	가솔린, 하이브리드	6.5	8.9	330	580	2023	1369
유럽   	랜드로버           	Range Rover Velar	9810	11990	중형 SUV	가솔린	8.6	8.6	250	250	2020	1493
유럽   	포르쉐            	718 Boxster	9630	13530	스포츠카	가솔린	9.3	9.3	300	300	2023	1496
유럽   	포르쉐            	718 Cayman	9160	13050	스포츠카	가솔린	8.4	8.4	407	407	2024	1497
유럽   	페라리            	812 Superfast	46900	46900	스포츠카	가솔린	5.4	5.4	800	800	2017	1502
유럽   	마세라티           	Quattroporte	17810	31200	대형	가솔린	6	7.4	350	580	2023	1513
유럽   	마세라티           	Levante	12400	24500	대형 SUV	가솔린, 하이브리드	5.8	7.9	330	580	2023	1517
유럽   	롤스로이스          	Phantom	63000	75000	대형	가솔린	5.8	5.8	563	563	2023	1544
유럽   	롤스로이스          	Wraith	40000	40000	대형	가솔린	6	6	632	632	2021	1546
일본   	토요타            	Prius Prime	4934	4934	준중형	하이브리드	21.4	21.4	98	98	2022	1550
일본   	렉서스            	NX	5830	6770	소형 SUV	가솔린, 하이브리드	9.3	12	152	238	2021	1563
유럽   	랜드로버           	New Range Rover Sport	13117	18007	중형 SUV	가솔린, 디젤	10.5	10.5	300	300	2020	1619
유럽   	랜드로버           	New Range Rover	17197	20657	대형 SUV	디젤, 가솔린	9.5	9.5	350	350	2022	1621
미국   	포드             	New Mustang	5155	7335	스포츠카	가솔린	7.5	9.4	291	446	2023	1626
유럽   	페라리            	Portofino	28000	28000	스포츠카	가솔린	8.1	8.1	600	600	2018	1628
유럽   	재규어            	I-Pace	11690	12850	중형 SUV	전기(여기까지 완료)	3.5	3.5	394	394	2023	1644
유럽   	볼보             	V90 Cross Country	7100	8070	대형	하이브리드	11	11	250	250	2024	1649
유럽   	볼보             	XC60	6014	8213	중형 SUV	하이브리드	9.8	9.8	250	250	2020	1650
유럽   	BMW            	X3	8510	8510	중형 SUV	디젤	9.5	13.6	184	292	2021	1654
한국   	현대             	넥쏘	7320	7320	소형 SUV	수소	93.7	96.2	154	154	2024	1657
유럽   	볼보             	The New XC40	4609	5063	소형 SUV	하이브리드	10.5	10.6	197	197	2024	1947
유럽   	롤스로이스          	Cullinan	46900	63700	대형 SUV	가솔린	5.4	5.6	600	600	2024	1957
미국   	지프             	All New Wrangler	6990	10130	중형 SUV	가솔린, 하이브리드	7.4	9.2	272	272	2023	2061
유럽   	시트로엥           	New C4 Cactus	3280	3280	소형 SUV	디젤	15.5	15.5	120	120	2021	2100
유럽   	벤츠             	The New CLS-Class	12680	12760	준대형	가솔린	9.1	13	245	435	2021	2116
유럽   	벤츠             	New C-Class	6450	10090	중형	가솔린	8	14.4	194	510	2023	2186
유럽   	BMW            	The All New X5	11250	13250	대형 SUV	가솔린, 디젤, 하이브리드	8	11.4	265	400	2023	2194
유럽   	BMW            	X2	5570	6010	소형 SUV	가솔린	9.8	13.6	150	231	2023	2197
유럽   	폭스바겐           	Arteon	5324	6114	중형	디젤	15.2	15.2	190	190	2020	2220
일본   	혼다             	New Pilot	6050	6050	대형 SUV	가솔린	8.4	8.4	284	284	2022	2228
유럽   	푸조             	New 508	4590	5390	중형	디젤	17.2	17.2	130	130	2023	2255
유럽   	람보르기니          	Urus	25513	25513	대형 SUV	가솔린	6.3	6.3	666	666	2023	2257
유럽   	시트로엥           	Grand C4 Spacetourer	4280	4640	RV/MPV	디젤	14.5	14.5	131	131	2021	2314
한국   	KG모빌리티         	리스펙 코란도	2445	3060	중형 SUV	가솔린	10.5	14.3	136	170	2022	2360
유럽   	볼보             	The New V60 Cross Country	5530	6260	중형	하이브리드	10.4	10.4	250	250	2024	2388
유럽   	BMW            	All New Z4	6440	9110	스포츠카	가솔린	10.2	10.7	197	197	2022	2444
유럽   	포르쉐            	The New Cayenne	11720	24680	중형 SUV	가솔린, 하이브리드	7.8	7.8	347	347	2023	2470
일본   	렉서스            	UX	5090	5870	소형 SUV	하이브리드	15	16.7	183	183	2025	2636
유럽   	시트로엥           	C5 Aircross	4130	4630	소형 SUV	디젤	12.7	15.8	131	177	2022	2742
유럽   	랜드로버           	New Range Rover Evoque	6880	7840	준중형 SUV	가솔린	13.6	13.6	180	180	2018	2817
유럽   	DS             	DS7 Crossback	5090	5590	중형 SUV	가솔린	11.8	11.8	131	131	2022	2878
유럽   	BMW            	7 Series	13870	23340	대형	가솔린, 디젤, 하이브리드	6	14.2	265	609	2022	2938
일본   	토요타            	Prius	3397	3712	준중형	하이브리드	20.9	22.4	151	152	2022	2951
미국   	지프             	Renegade	3810	4840	소형 SUV	가솔린	9.2	10.4	173	175	2023	3112
유럽   	시트로엥           	C3 Aircross	3258	3300	소형 SUV	디젤	14.1	14.1	120	120	2024	3114
한국   	현대             	베뉴	1642	2413	소형 SUV	가솔린	13.3	13.7	123	123	2023	3290
유럽   	볼보             	The New S60	5610	5640	중형	가솔린	11.8	11.8	250	250	2024	3685
한국   	현대             	쏠라티	6451	7144	승합	디젤	12.2	12.2	170	170	2023	3932
한국   	현대             	마이티	5084	9886	화물	디젤	7.3	7.3	150	170	2023	4407
유럽   	벤츠             	G-Class	17400	29700	대형 SUV	가솔린, 디젤	5.2	8.4	330	585	2024	4471
한국   	기아             	모하비 더 마스터	5054	6097	대형 SUV	디젤	9.3	9.4	260	260	2020	4512
유럽   	벤츠             	The GLE-Class	10300	19690	대형 SUV	가솔린, 디젤, 하이브리드	8.3	11.4	211	367	2023	4720
유럽   	벤츠             	The New A-Class	4110	7310	소형	가솔린, 디젤	9	16.1	150	387	2023	4766
유럽   	포르쉐            	The New 911	17110	32600	스포츠카	가솔린	6.8	6.8	662	662	2024	5086
유럽   	BMW            	3 Series	5020	8270	중형	가솔린, 디젤, 하이브리드	9.9	14.3	184	387	2022	5109
한국   	기아             	봉고3 특장차	2122	4115	화물	디젤, LPG	6.1	8.7	133	138	2024	5398
한국   	현대             	포터2 특장차	2199	8725	화물	LPG, 디젤	6	9.9	133	135	2024	5432
유럽   	아우디            	The New A6	6872	17550	준대형	가솔린, 디젤	10.7	15	204	286	2023	5625
유럽   	BMW            	8 Series	13440	13860	대형	가솔린, 디젤	9.4	12.8	320	340	2022	5767
미국   	포드             	All New Explorer	6765	8195	대형 SUV	가솔린, 하이브리드	8.3	10.4	304	405	2023	5918
유럽   	미니             	The New Clubman	3970	6340	소형	가솔린	10.6	10.6	192	192	2024	6059
유럽   	벤츠             	EQC	9560	9590	중형 SUV	전기	3.2	3.2	408	408	2021	6248
유럽   	볼보             	The New XC90	8580	9650	대형 SUV	하이브리드	9.1	9.1	300	300	2024	6340
유럽   	아우디            	The New A8	20548	20842	대형	가솔린	11.4	11.4	286	286	2023	6398
유럽   	DS             	DS3 Crossback	3980	4374	소형 SUV	디젤	15.6	15.6	131	131	2022	6654
한국   	현대             	포터2 Electric	4375	5006	화물	전기	2.7	3.1	184	184	2024	6659
유럽   	BMW            	New X6	12020	13720	대형 SUV	가솔린, 디젤	7.6	10.9	286	400	2023	6830
유럽   	BMW            	New 1 Series	4600	5140	소형	가솔린	11	14.3	150	192	2024	7434
한국   	기아             	봉고3 EV	4185	6198	화물	전기	3.1	3.1	184	184	2024	7440
유럽   	벤츠             	GLC-Class	7050	14000	중형 SUV	가솔린, 디젤, 하이브리드	7	12.4	194	510	2023	7508
한국   	제네시스           	GV80	6478	7645	대형 SUV	가솔린, 디젤	7.9	9.3	304	380	2024	7519
한국   	쉐보레            	트레일블레이저	2589	2999	소형 SUV	가솔린	11.6	13	139	156	2023	7520
미국   	링컨             	All New Aviator	9145	10755	대형 SUV	가솔린	8.1	9.3	405	405	2020	7523
유럽   	랜드로버           	New Discovery Sport	6440	7200	중형 SUV	가솔린	8.2	8.2	249	249	2024	7648
일본   	토요타            	GR Supra	7980	7980	스포츠카	가솔린	10.2	10.2	382	382	2024	7684
한국   	기아             	신형 쏘렌토 4세대	3024	4543	중형 SUV	가솔린, 디젤	9.7	14.3	194	281	2023	8101
일본   	렉서스            	New RX	8120	9760	중형 SUV	가솔린, 하이브리드	8.9	12.8	262	313	2020	8105
유럽   	BMW            	2 Series 그란쿠페	4680	5220	준중형	가솔린	11.2	14.3	150	192	2024	8128
유럽   	벤츠             	CLA-Class	5630	8950	중형	가솔린	9	11.5	224	421	2023	8152
한국   	르노코리아          	XM3	2023	2914	소형 SUV	가솔린	13.2	13.8	123	152	2025	8157
미국   	테슬라            	Model 3	5999	9418	준중형	전기	4.7	5.8	287	480	2022	8198
일본   	토요타            	Prius C Crossover	2590	2590	소형	하이브리드	18.6	18.6	72	72	2021	8729
미국   	캐딜락            	XT6	8540	8640	대형 SUV	가솔린	8	8.3	314	314	2020	8781
한국   	르노코리아          	뉴 마스터	3685	3845	승합	디젤	9.5	11.1	150	163	2024	8797
유럽   	아우디            	The New A7	9356	18180	준대형	가솔린, 하이브리드, 디젤	9.5	11.9	286	340	2024	8833
유럽   	아우디            	The New Q7	9897	12987	대형 SUV	가솔린, 디젤	8.4	11	231	340	2025	9029
유럽   	아우디            	Q8	10142	18450	대형 SUV	가솔린, 디젤	8.2	10.2	231	340	2024	9039
한국   	제네시스           	디 올 뉴 G80	5548	6860	준대형	가솔린	8.3	14.4	210	380	2023	9067
미국   	캐딜락            	XT5	6910	7710	중형 SUV	가솔린	8	8	314	314	2023	9190
미국   	링컨             	All New Corsair	5930	5930	소형 SUV	가솔린	9.2	9.2	238	238	2022	9693
유럽   	페라리            	812 GTS	51500	51500	스포츠카	가솔린	5.3	5.3	800	800	2020	10189
유럽   	페라리            	F8 Spider	39700	39700	스포츠카	가솔린	6.4	6.4	720	720	2020	10201
유럽   	페라리            	F8 Tributo	36000	36000	스포츠카	가솔린	6.6	6.6	720	720	2019	10203
유럽   	페라리            	Roma	32000	32000	스포츠카	가솔린	7.4	7.4	620	620	2023	10205
유럽   	람보르기니          	Huracan EVO	32890	43500	스포츠카	가솔린	6	6.1	610	640	2020	10213
유럽   	벤츠             	The New GLS-Class	14300	18080	대형 SUV	가솔린, 디젤	7.3	9.8	330	489	2023	10283
유럽   	아우디            	Q3	4966	6001	준중형 SUV	가솔린, 디젤	9.9	9.9	186	186	2024	10304
유럽   	랜드로버           	New Defender	9960	14730	대형 SUV	가솔린, 디젤	6.9	9.8	249	400	2024	10615
유럽   	푸조             	All-New 2008	3700	4000	소형 SUV	디젤	17.1	17.1	130	131	2024	10753
유럽   	포르쉐            	Taycan	12380	24740	스포츠카	전기	2.8	2.9	350	500	2024	10795
한국   	현대             	더 뉴 싼타페	3277	4546	중형 SUV	가솔린, 디젤	9.7	11	281	281	2024	10978
미국   	캐딜락            	CT4	4935	4935	중형	가솔린	10.6	10.6	240	240	2020	11163
미국   	캐딜락            	CT5	5640	14000	대형	가솔린	6.1	10.2	240	477	2020	11165
일본   	혼다             	New CR-V	3900	4850	중형 SUV	가솔린, 하이브리드	11.5	14.5	145	193	2022	11217
유럽   	벤틀리            	New Continental	32890	46310	대형	가솔린	7.4	7.4	550	550	2024	11244
한국   	기아             	신형 쏘렌토 HEV 4세대	3773	4795	중형 SUV	하이브리드	13.2	15.3	180	180	2023	11303
유럽   	푸조             	All-New e-208	4900	5300	소형	전기	4.4	5.4	100	136	2023	11365
유럽   	볼보             	The New S90	6350	7400	대형	가솔린	10.2	11.7	250	300	2024	11406
한국   	르노코리아          	더 뉴 SM6	2871	3708	중형	가솔린, LPG	9.2	13.6	140	225	2024	11439
유럽   	푸조             	All-New e-2008	5290	5490	소형 SUV	전기	4.9	4.9	100	136	2023	11552
한국   	현대             	카운티 일렉트릭	19984	20994	승합	전기	5.9	5.9	184	338	2024	11904
유럽   	벤츠             	AMG GT	18260	25360	스포츠카	가솔린	7	7	476	585	2021	11940
유럽   	DS             	DS3 Crossback E-Tense	5690	5790	소형 SUV	전기	4.9	4.9	100	100	2022	12077
한국   	기아             	모닝 어반	1175	1540	경형	가솔린	15.7	15.7	76	76	2020	12263
한국   	쉐보레            	리얼 뉴 콜로라도	4050	4889	화물	가솔린	7.9	8.3	312	312	2022	12480
미국   	지프             	Gladiator	7990	7990	화물	가솔린	6.2	6.5	284	284	2023	12737
유럽   	벤츠             	GLB-Class	5560	7500	소형 SUV	가솔린, 디젤	9	14.2	150	306	2023	12755
유럽   	벤츠             	GLA-Class	6090	8320	준중형 SUV	가솔린	8.6	11.5	190	387	2023	12808
한국   	현대             	디 올 뉴 투싼	2603	3822	준중형 SUV	가솔린, 디젤	11	14.8	180	184	2024	12966
유럽   	벤츠             	The New E-Class	6780	12980	준대형	가솔린, 디젤, 하이브리드	9.1	13.7	194	435	2023	13063
한국   	현대             	디 올 뉴 투싼 HEV	3170	4143	준중형 SUV	하이브리드	14.7	16.2	180	180	2023	13185
유럽   	BMW            	The New 5 Series	6660	8840	준대형	가솔린, 디젤, 하이브리드	7.9	17.5	184	530	2023	13324
유럽   	BMW            	New 6 Series	8410	11610	준대형	가솔린, 디젤	9.3	13.5	190	340	2024	13559
유럽   	미니             	The New Countryman	4770	6550	소형 SUV	가솔린	11.6	11.6	136	136	2024	13571
한국   	현대             	더 뉴 코나 HEV	2724	3255	소형 SUV	하이브리드	17.4	19.3	105	105	2022	13582
유럽   	폭스바겐           	The New Jetta	2950	3285	준중형	가솔린	13.4	13.4	150	150	2021	13676
한국   	제네시스           	더 뉴 G70	4347	5326	준대형	가솔린	8.8	11.2	304	370	2023	13710
유럽   	롤스로이스          	New Ghost	47100	60400	대형	가솔린	5.6	5.6	600	600	2022	13799
유럽   	벤틀리            	All New Flying Spur	32920	34700	대형	가솔린	6.8	6.8	550	550	2024	13830
유럽   	폭스바겐           	The New Passat GT	4313	5322	중형	디젤	15.7	15.7	190	190	2020	14955
일본   	혼다             	New Accord	3790	4650	준대형	가솔린, 하이브리드	13.9	17.5	145	194	2022	15473
유럽   	재규어            	The New F-Type	10351	11001	스포츠카	가솔린	8	9.8	300	575	2021	15683
유럽   	벤틀리            	New Bentayga	29600	39390	대형 SUV	가솔린	6.7	6.7	550	550	2024	15929
유럽   	BMW            	New 4 Series	5860	7630	중형	가솔린, 디젤	10.4	15	184	387	2024	16090
유럽   	아우디            	The New R8	25757	25757	스포츠카	가솔린	6	6	610	610	2022	16092
유럽   	벤츠             	The New S-Class	14180	29900	대형	가솔린, 디젤, 하이브리드	7.5	12.6	286	612	2024	16096
유럽   	포르쉐            	Panamera	15030	31780	스포츠카	가솔린, 하이브리드	7.1	8	336	642	2022	16153
미국   	테슬라            	Model Y	5299	8535	중형 SUV	전기	4.8	5.4	476	490	2024	16205
미국   	캐딜락            	XT4	5920	5920	준중형 SUV	가솔린	10	10	238	238	2023	16253
일본   	렉서스            	New LS	13383	17830	대형	가솔린, 하이브리드	9.6	9.6	539	539	2024	16261
미국   	테슬라            	New Model X	12875	16852	대형 SUV	전기	4.1	4.3	476	613	2023	16304
미국   	테슬라            	New Model S	11525	16999	준대형	전기	4.1	4.5	423	1020	2023	16308
한국   	현대             	아이오닉 5	5272	6495	중형 SUV	전기	4.4	5.2	170	325	2024	16333
일본   	혼다             	New Odyssey	6050	6050	RV/MPV	가솔린	9	9	284	284	2023	16338
유럽   	벤츠             	Maybach GLS-Class	26000	29900	대형 SUV	가솔린	6.6	6.6	557	557	2023	16481
일본   	토요타            	Sienna	7050	7060	RV/MPV	하이브리드	13.7	14.5	246	246	2023	16512
한국   	기아             	K8	2910	4624	준대형	가솔린, LPG	7.7	12	198	300	2024	16824
한국   	기아             	K8 HEV	3910	4788	준대형	하이브리드	17.1	18	180	230	2024	16827
한국   	현대             	스타리아	2596	7401	승합	디젤, LPG	6.5	12.3	177	240	2024	16862
한국   	기아             	EV6	5130	6635	중형 SUV	전기	4.6	5.6	170	584	2024	16914
유럽   	재규어            	New XF	6800	7200	준대형	가솔린	5.5	8.6	201	296	2021	17033
유럽   	재규어            	New F-Pace	7790	8320	중형 SUV	가솔린	12.8	12.8	204	204	2021	17037
한국   	기아             	더 뉴 K3	1765	2507	준중형	가솔린	14.1	15.2	123	123	2024	17572
한국   	기아             	더 뉴 K3 GT	2745	2784	준중형	가솔린	12.1	12.1	204	204	2024	17573
유럽   	맥라렌            	GT	29700	29700	스포츠카	가솔린	11.9	11.9	626	626	2024	17745
유럽   	맥라렌            	600LT	29900	31500	스포츠카	가솔린	8.5	8.5	600	600	2019	17747
유럽   	애스턴마틴          	Vantage	19800	25900	스포츠카	가솔린	9.7	9.7	503	503	2023	17761
유럽   	벤츠             	AMG GT 4door Coupe	13760	24160	스포츠카	가솔린	7.2	8.8	389	639	2021	17768
유럽   	애스턴마틴          	DB11	26400	29500	스포츠카	가솔린	10	10	535	535	2023	17773
유럽   	애스턴마틴          	DBS	36900	41900	스포츠카	가솔린	8	8	720	720	2022	17776
유럽   	애스턴마틴          	DBX	24800	25600	대형 SUV	가솔린	7	7	550	550	2022	17779
유럽   	맥라렌            	570S	26500	28400	스포츠카	가솔린	10.8	10.8	570	570	2016	17788
유럽   	맥라렌            	720S	35900	38500	스포츠카	가솔린	9.3	9.3	740	740	2023	17798
일본   	렉서스            	LC	17460	19240	중형	가솔린, 하이브리드	7.7	7.7	477	477	2024	17822
유럽   	랜드로버           	All New Discovery	9090	12760	중형 SUV	가솔린 디젤	7.5	10.8	249	360	2023	17907
유럽   	푸조             	New 3008	4220	5050	RV/MPV	가솔린, 디젤	12.2	15.8	130	130	2024	18129
유럽   	벤츠             	The New Maybach S-Class	27300	59000	대형	가솔린	5.8	8.1	503	630	2024	18143
유럽   	아우디            	e-tron	11650	14310	대형 SUV	전기	2.9	3	308	402	2023	18369
일본   	토요타            	New Camry	3900	4520	중형	하이브리드	12.3	12.3	207	207	2023	18414
유럽   	푸조             	New 5008	4600	5100	중형 SUV	가솔린, 디젤	12.1	14.9	130	130	2023	18751
한국   	기아             	더 뉴 K9	5815	8685	대형	가솔린	8.1	9	315	370	2024	18805
유럽   	아우디            	The New Q5	7043	10241	중형 SUV	가솔린, 디젤	10.5	12.8	204	265	2023	19003
미국   	캐딜락            	Escalade	15500	16900	대형 SUV	가솔린	6.5	7	426	426	2023	19030
한국   	현대             	파비스	7935	18238	화물	디젤	6	6	280	325	2023	19317
한국   	현대             	더 뉴 싼타페 HEV	3710	4762	중형 SUV	하이브리드	14	15.5	180	235	2024	19462
한국   	기아             	디 올 뉴 스포티지	2492	3892	준중형 SUV	가솔린, 디젤, LPG	8.9	14.5	146	180	2024	19585
한국   	제네시스           	Electrified G80	8821	8821	준대형	전기	4.3	4.3	370	370	2024	19642
유럽   	미니             	New Convertible	4700	5930	소형	가솔린	12.1	12.1	136	136	2024	19662
유럽   	미니             	New Hatch	3660	5500	소형	가솔린	11.4	11.4	231	231	2024	19664
유럽   	아우디            	The New A5	6096	12808	중형	가솔린, 디젤	10.9	10.9	265	265	2023	19747
유럽   	페라리            	SF90 Stradale	64000	64000	스포츠카	하이브리드	7.3	7.3	1016	1016	2024	19838
유럽   	폭스바겐           	The New Tiguan	4390	4990	중형 SUV	디젤	15.6	15.6	201	262	2024	20162
한국   	기아             	디 올 뉴 스포티지 HEV	3331	4197	준중형 SUV	하이브리드	8.8	14.1	146	184	2024	21196
일본   	렉서스            	New ES	6360	7410	중형	하이브리드	16.8	17.2	218	218	2025	21218
한국   	현대             	캐스퍼	1375	1960	경형 SUV	가솔린	12.3	14.3	76	100	2023	21604
유럽   	맥라렌            	Artura	29900	29900	스포츠카	하이브리드	4.8	4.8	691	691	2024	21645
한국   	제네시스           	GV60	6776	7749	준중형 SUV	전기	4.1	5.1	228	435	2024	22018
유럽   	볼보             	The New XC60	6290	7400	중형 SUV	하이브리드	9.4	10.1	250	300	2024	22095
유럽   	폭스바겐           	T-Roc	3241	3830	소형 SUV	디젤	16.2	16.2	150	150	2022	22899
유럽   	BMW            	The New X3	6650	9060	중형 SUV	가솔린, 하이브리드, 디젤	9.8	13.6	184	292	2024	23232
유럽   	BMW            	The All New X4	6870	8600	중형 SUV	가솔린, 디젤	9.9	12.3	184	190	2024	23255
유럽   	벤츠             	EQS	15700	19000	대형	전기	3.5	4	292.4	360.4	2023	23395
한국   	스마트 EV         	EV Z	2750	2750	경형	전기	5.8	5.8	46	46	2020	23475
한국   	스마트 EV         	D2C	1980	1980	화물	전기	5.2	5.2	13.6	13.6	2020	23487
한국   	스마트 EV         	D2P	1980	1980	화물	전기	5.2	5.2	13.6	13.6	2020	23489
유럽   	BMW            	iX	14420	15360	중형 SUV	전기	3.6	3.9	326	523	2024	23537
미국   	지프             	All New Grand Cherokee L	8910	9880	대형 SUV	가솔린	7.7	7.7	286	286	2023	23553
유럽   	아우디            	The New A4	5454	8801	중형	가솔린, 디젤	10.6	16.9	163	265	2023	23663
유럽   	마세라티           	MC20	31000	33700	스포츠카	가솔린	7	7	630	630	2023	23683
유럽   	벤츠             	The New CLS-Class	9500	14040	준대형	가솔린, 디젤	9.1	13.9	265	435	2023	23819
유럽   	랜드로버           	The New Range Rover	18820	32660	대형 SUV	가솔린, 하이브리드, 디젤	7.8	7.8	530	530	2023	24105
유럽   	포르쉐            	The New Macan	10300	12700	중형 SUV	가솔린	7.8	7.8	375	375	2024	24180
유럽   	아우디            	e-tron GT	14332	20820	스포츠카	전기	3.7	3.7	523	523	2022	24209
한국   	제네시스           	신형 G90	9445	17610	대형	가솔린	8.2	9.3	380	415	2024	24221
유럽   	폭스바겐           	The Golf 8	3840	4140	준중형	디젤	17.8	17.8	150	150	2024	24874
유럽   	폭스바겐           	The New Arteon	5870	6370	중형	디젤	13.8	15.5	200	200	2023	24882
한국   	KG모빌리티         	코란도 이모션	4057	4590	중형 SUV	전기	4.9	4.9	190	190	2022	25097
한국   	쉐보레            	타호	9390	9500	대형 SUV	가솔린	6.4	6.4	426	426	2023	25170
미국   	링컨             	New Nautilus	7470	7470	대형 SUV	가솔린	8.8	8.8	335	335	2022	25208
한국   	기아             	디 올 뉴 니로 HEV	2856	3519	준중형 SUV	하이브리드	18.8	20.8	105	105	2024	25290
한국   	쉐보레            	트래버스	5640	6615	대형 SUV	가솔린	8.3	8.3	310	310	2023	25766
유럽   	볼보             	C40 Recharge	6790	6865	중형 SUV	전기	4.6	4.6	402	402	2024	26347
한국   	현대             	카운티	7173	9412	승합	디젤	7.8	7.8	170	170	2024	26375
한국   	제네시스           	Electrified GV70	7723	7802	중형 SUV	전기	4.3	4.6	435	435	2024	26649
한국   	쎄보모빌리티         	CEVO-C SE	1570	1690	경형	전기	6.3	6.3	20.2	20.2	2024	26725
유럽   	벤츠             	The New C-Class	6200	7701	중형	가솔린	11.1	11.8	204	258	2024	27105
유럽   	미니             	The New Electric	5140	5350	소형	전기	4.5	4.5	184	184	2022	27191
유럽   	폴스타            	폴스타 2	5490	5990	중형	전기	3.8	4.8	220	310	2024	27288
유럽   	벤츠             	The New AMG GT 4door Coupe	14450	24740	스포츠카	가솔린	6.7	8.6	367	639	2024	27457
유럽   	BMW            	i4	7550	8480	중형	전기	4.6	4.6	340	340	2024	27858
유럽   	맥라렌            	765LT	49300	49300	스포츠카	가솔린	6.8	6.8	755	755	2021	28313
유럽   	볼보             	XC60 Recharge	8590	8640	중형 SUV	하이브리드	16.8	16.8	317	317	2024	28567
유럽   	볼보             	XC90 Recharge	11470	11520	대형 SUV	하이브리드	15.5	15.5	317	317	2024	28571
유럽   	볼보             	S90 Recharge	8647	8790	중형	하이브리드	18.2	18.2	317	317	2023	28580
일본   	토요타            	New Generation RAV4	4430	5700	중형 SUV	하이브리드	15.1	16.1	218	222	2024	28590
한국   	기아             	디 올 뉴 니로 EV	5114	5393	준중형 SUV	전기	5.3	5.3	204	204	2024	29179
일본   	토요타            	GR 86	4090	4770	스포츠카	가솔린	9.5	9.5	231	231	2024	29652
한국   	현대             	더 뉴 팰리세이드	3896	5491	대형 SUV	가솔린, 디젤	8.5	12.4	202	295	2024	29760
한국   	기아             	니로 플러스	4600	5108	준중형 SUV	전기	5.3	5.3	204	204	2024	30176
한국   	쉐보레            	더 넥스트 이쿼녹스	3145	4145	중형 SUV	가솔린	10.6	11.5	172	172	2022	30292
일본   	렉서스            	UX 300e	5490	5490	소형 SUV	전기	4.7	4.7	204	204	2022	30433
한국   	KG모빌리티         	토레스	2627	3753	중형 SUV	가솔린, LPG	10.2	11.2	165	170	2024	30571
일본   	렉서스            	New Generation NX	6670	8300	소형 SUV	하이브리드	14	14.4	182	189	2022	30688
유럽   	푸조             	New 308	3650	4350	준중형	디젤	17.2	17.2	131	131	2023	30873
한국   	제네시스           	G70 슈팅 브레이크	4545	5128	준대형	가솔린	10.1	10.9	304	304	2023	31048
유럽   	벤츠             	EQB	6900	8200	중형 SUV	전기	4.1	4.1	228.4	228.4	2024	31076
유럽   	DS             	DS4	4460	5160	중형 SUV	디젤	16.2	16.5	130	130	2022	31109
유럽   	아우디            	New A3	4233	6137	준중형	가솔린	13	13	150	150	2024	31759
유럽   	애스턴마틴          	DBX707	31700	31700	대형 SUV	가솔린	7	7	707	707	2024	31938
한국   	기아             	더 뉴 셀토스	2087	2903	소형 SUV	가솔린	10.8	12.9	149	198	2024	32119
유럽   	BMW            	New 2 Series 액티브 투어러	4400	5270	준중형	가솔린, 디젤	12.2	15.8	150	204	2024	32708
유럽   	폭스바겐           	The new Tiguan Allspace	4890	5480	중형 SUV	가솔린, 디젤	10.1	10.1	186	186	2024	32734
유럽   	페라리            	SF90 Spider	69357	69357	스포츠카	하이브리드	2.6	7.2	1016	1016	2024	33025
유럽   	볼보             	XC40 Recharge	6690	6769	소형 SUV	전기	4.4	4.4	402	402	2024	33041
유럽   	볼보             	The New XC40	4840	5430	소형 SUV	하이브리드	10.1	10.1	197	197	2022	33046
한국   	현대             	아이오닉 6	5267	6768	준대형	전기	4.8	6.2	111	239	2023	33159
미국   	포드             	New Expedition	11270	11270	대형 SUV	가솔린	7.4	7.4	405	405	2022	33270
유럽   	BMW            	New X7	14720	15820	대형 SUV	하이브리드, 디젤	7.8	10	340	381	2024	33317
한국   	기아             	더 뉴 레이 PE	1330	1865	경형	가솔린	12.7	13	76	76	2024	33452
유럽   	아우디            	Q4 e-tron	5970	7289	중형 SUV	전기	4.7	4.7	201	201	2023	33765
유럽   	폭스바겐           	ID.4	5490	5990	중형 SUV	전기	4.9	4.9	201	201	2023	33941
유럽   	BMW            	The New 7 Series	14730	22600	대형	가솔린, 디젤, 하이브리드	10.4	15	299	489	2024	34088
유럽   	BMW            	The New i7	16690	24050	대형	전기	3.7	3.8	455	544	2024	34092
유럽   	벤츠             	EQE	9210	10990	준대형	전기	4	4.3	245	292	2024	34220
한국   	기아             	EV6 GT	7584	7605	중형 SUV	전기	4.2	4.2	585	585	2023	34365
유럽   	아우디            	The New A8 F/L	14038	21630	대형	가솔린, 디젤	11.4	11.4	286	286	2023	34800
유럽   	폭스바겐           	The New Jetta F/L	3290	3810	준중형	가솔린	14.1	14.1	160	160	2023	34910
미국   	링컨             	New Navigator	15200	15200	대형 SUV	가솔린	7.2	7.2	446	446	2023	35276
유럽   	페라리            	296 GTB	39800	41500	스포츠카	하이브리드	15.6	15.6	830	830	2022	35688
유럽   	페라리            	296 GTS	46100	46100	스포츠카	하이브리드	7.7	7.7	830	830	2022	35695
유럽   	BMW            	3 Series F/L	5590	7110	중형	가솔린, 디젤, 하이브리드	10.8	15.7	184	293	2024	35853
유럽   	벤츠             	EQS AMG	21440	21600	대형	전기	3.2	3.2	658.2	658.2	2023	35996
유럽   	랜드로버           	All New Range Rover Sport	14140	28520	중형 SUV	가솔린, 하이브리드, 디젤	7.1	10.4	296	635	2024	36018
유럽   	람보르기니          	Urus S	29000	29000	대형 SUV	가솔린	6.4	6.4	666	666	2023	36070
한국   	현대             	디 올 뉴 그랜저	3743	5315	준대형	가솔린, LPG	7.8	11.7	198	300	2025	36078
한국   	현대             	디 올 뉴 그랜저 HEV	4409	5516	준대형	하이브리드	15.7	18	180	230	2025	36086
유럽   	마세라티           	Grecale	9900	16900	중형 SUV	가솔린	8	9.9	300	530	2023	36324
미국   	지프             	All New Grand Cherokee	7690	11190	대형 SUV	가솔린, 하이브리드	7.4	11.1	272	286	2023	36396
유럽   	롤스로이스          	Phantom II	71200	82600	대형	가솔린	5.8	5.8	571	571	2023	36492
유럽   	폭스바겐           	The Golf GTI	4790	4970	준중형	가솔린	11.5	11.5	245	245	2023	36640
유럽   	람보르기니          	Urus Performante	32890	32890	대형 SUV	가솔린	6.3	6.3	666	666	2023	36820
미국   	포드             	Next Generation Ranger	6350	7990	화물	디젤	10.1	10.1	205	205	2023	38423
유럽   	아우디            	The New Q2	4090	4440	소형 SUV	디젤	16.7	16.7	150	150	2023	38426
한국   	현대             	디 올 뉴 코나	2446	3422	소형 SUV	가솔린	11.2	13.6	149	198	2024	38525
한국   	현대             	디 올 뉴 코나 HEV	3102	3737	소형 SUV	하이브리드	18.1	19.8	105	105	2024	38532
유럽   	BMW            	iX1	6690	6960	소형 SUV	전기	4.2	4.2	313	313	2024	38637
유럽   	벤츠             	EQS SUV	15410	18680	대형 SUV	전기	3.5	3.6	360	544	2023	38822
한국   	GMC            	Sierra	9330	9550	화물	가솔린	6.6	6.9	426	426	2024	39193
유럽   	벤츠             	The new SL-Class	23500	26300	스포츠카	가솔린	6.3	6.5	585	585	2024	39205
한국   	르노코리아          	XM3 E-TECH	2938	3660	소형 SUV	하이브리드	17	17.4	86	86	2025	39363
유럽   	폭스바겐           	The Touareg	8990	10590	대형 SUV	디젤	10.8	10.8	286	286	2023	39419
한국   	제이스 모빌리티       	이티밴	3120	3990	화물	전기	4.4	4.4	81.6	81.6	2024	39512
유럽   	BMW            	The XM	22330	26840	대형 SUV	하이브리드	10	10	489	653	2024	39561
한국   	마이브            	M1	1892	1892	경형	전기	5.5	5.5	17.67	17.67	2022	39565
한국   	대창모터스          	다니고 카고	3290	3880	화물	전기	3.1	3.4	81.5	81.5	2023	39764
한국   	대창모터스          	다니고 특장	4310	5780	화물	전기	2.9	3.5	81.5	81.6	2023	39849
한국   	르노코리아          	더 뉴 QM6	2840	3793	중형 SUV	가솔린, LPG 	8.6	12	140	144	2025	40149
유럽   	BMW            	The New Z4	7330	9880	스포츠카	가솔린	10.2	10.7	197	387	2025	40543
한국   	현대             	더 뉴 아반떼 HEV	2597	3304	준중형	하이브리드	18.5	21.1	105	141	2025	40597
한국   	쉐보레            	트랙스 크로스오버	2188	2880	소형 SUV	가솔린	12	12.7	139	139	2025	41061
유럽   	벤츠             	EQA	5990	7450	중형 SUV	전기	4	4.9	190	190	2024	41286
유럽   	BMW            	The New X1	5820	6690	소형 SUV	가솔린, 디젤	10.7	14.6	150	204	2024	41347
한국   	KG모빌리티         	토레스 EVX	4438	5287	중형 SUV	전기	4.8	5	207	207	2024	41432
유럽   	마세라티           	MC20 Cielo	38300	38300	스포츠카	가솔린	7.1	7.1	630	630	2023	41584
일본   	혼다             	All New CR-V	4260	5590	중형 SUV	가솔린, 하이브리드	12.1	15.1	147	190	2023	41964
한국   	현대             	디 올 뉴 코나 EV	4584	5363	소형 SUV	전기	4.7	5.5	134	204	2024	42065
유럽   	푸조             	New 408	4290	4690	중형 SUV	가솔린	12.9	12.9	131	131	2024	42232
유럽   	벤츠             	EQE AMG	14520	14520	준대형	전기	3.3	3.3	625.6	625.6	2023	42272
한국   	현대             	쏘나타 디 엣지	2546	3917	중형	가솔린, LPG	9.4	13.5	146	290	2024	42319
한국   	현대             	쏘나타 디 엣지 HEV	3330	4064	중형	하이브리드	17.1	19.4	152	152	2024	42343
한국   	EVKMC          	마사다 밴	3780	3980	화물	전기	3.8	3.8	81.6	81.6	2023	42595
한국   	EVKMC          	마사다 픽업	3779	3779	화물	전기	4.5	4.5	81.6	81.6	2023	42598
한국   	기아             	EV9	7728	9124	대형 SUV	전기	3.8	4.2	204	384.8	2024	42793
한국   	KG모빌리티         	렉스턴 뉴 아레나	4010	5255	대형 SUV	디젤	10.6	11.1	202	202	2024	42877
한국   	KG모빌리티         	렉스턴 스포츠	2827	3974	화물	디젤	10.4	10.4	202	202	2024	42923
한국   	KG모빌리티         	렉스턴 스포츠 칸	3088	4469	화물	디젤	10.2	10.3	202	202	2024	42930
한국   	KG모빌리티         	렉스턴 스포츠 칸 쿨멘	3140	4246	화물	디젤	10.2	10.3	202	202	2024	42936
한국   	KG모빌리티         	렉스턴 스포츠 쿨멘	2879	4031	화물	디젤	10.4	10.4	202	202	2024	42961
유럽   	포르쉐            	The New Cayenne	13310	26700	중형 SUV	가솔린, 하이브리드	7.5	7.5	355	355	2024	43316
한국   	KG모빌리티         	더 뉴 티볼리	1898	2807	소형 SUV	가솔린	10.8	10.2	126	163	2024	44283
한국   	KG모빌리티         	더 뉴 티볼리 에어	2312	2719	소형 SUV	가솔린	11.9	12	163	163	2024	44318
일본   	토요타            	Crown	5810	6940	준대형	하이브리드	12.4	12.4	245	245	2021	44413
유럽   	롤스로이스          	Spectre	62200	62200	대형	전기	3.2	3.2	430	430	2023	45069
일본   	렉서스            	New Generation RX	9870	11703	중형 SUV	하이브리드	10	17.8	249	371	2023	45083
일본   	렉서스            	RZ	8490	9300	중형 SUV	전기	5.4	5.4	312	312	2023	45137
일본   	토요타            	Highlander	6660	7470	중형 SUV	하이브리드	13.8	13.8	246	246	2023	45323
한국   	기아             	더 뉴 모닝	1290	1820	경형	가솔린	15.1	15.1	76	76	2023	45793
유럽   	BMW            	New M2	8990	9490	스포츠카	가솔린	8.5	8.5	460	460	2024	45839
유럽   	BMW            	New X5	11610	14360	대형 SUV	가솔린, 디젤, 하이브리드	9.2	12	286	381	2024	45989
유럽   	BMW            	New X6	12580	13770	대형 SUV	가솔린, 디젤	9.5	11.9	286	381	2024	45994
유럽   	페라리            	Portofino M	38830	38830	스포츠카	가솔린	7.6	7.6	620	620	2020	46015
유럽   	BMW            	New X5 M	15800	19020	중형 SUV	가솔린	6.9	7.5	530	625	2024	46031
유럽   	BMW            	New X6 M	15910	19420	대형 SUV	가솔린	7	7.8	530	625	2024	46034
유럽   	벤츠             	The New EQE SUV	10990	13400	중형 SUV	전기	3.8	3.9	292.4	408	2024	46235
한국   	쉐보레            	더 뉴 트레일블레이저	2699	3339	소형 SUV	가솔린	11.6	12.9	156	156	2025	46597
유럽   	아우디            	The New RS3	7691	7770	중형	가솔린	8.8	8.8	401	407	2021	46760
한국   	기아             	더 뉴 쏘렌토	3506	4682	중형 SUV	가솔린, 디젤	9.3	14.3	194	281	2024	46824
한국   	기아             	더 뉴 쏘렌토 HEV	3929	4915	중형 SUV	하이브리드	13.8	15.7	180	180	2024	46827
한국   	현대             	더 뉴 아반떼 N	3352	3568	준중형	가솔린	10.4	10.6	280	280	2025	46877
일본   	토요타            	Alphard	9920	9920	RV/MPV	하이브리드	13.5	13.5	250	250	2024	47756
일본   	혼다             	All New Pilot	6940	6940	대형 SUV	가솔린	8.4	8.4	289	289	2024	47843
한국   	기아             	더 레이 EV	2735	2955	경형	전기	5.1	5.1	87.4	87.4	2024	47863
한국   	모빌리티네트웍스       	SE-A	3980	3980	화물	전기	4.4	4.4	136	136	2023	47955
유럽   	벤츠             	The New GLE-Class	11300	16060	대형 SUV	가솔린, 디젤, 하이브리드	8	11.4	269	435	2024	48086
한국   	현대             	아이오닉 5 N	8005	8005	중형 SUV	전기	3.7	3.7	641	641	2023	48471
한국   	르노코리아          	QM6 Quest	2495	3220	화물	LPG	8.7	8.7	140	140	2025	48525
유럽   	BMW            	The New 5 Series	6880	9540	준대형	가솔린, 디젤, 하이브리드	11.1	15.9	190	299	2024	48640
유럽   	BMW            	i5	9290	10170	준대형	전기	4.1	4.1	340	340	2024	48659
유럽   	BMW            	i5 M	13490	13890	준대형	전기	3.8	3.8	601	601	2024	48677
유럽   	BMW            	New iX3	7850	8260	중형 SUV	전기	4.1	4.1	286	286	2024	60971
일본   	혼다             	All New Accord	4390	5340	준대형	가솔린, 하이브리드	12.9	16.7	147	190	2024	62911
한국   	제네시스           	GV80 F/L	6930	8080	대형 SUV	가솔린	7.9	9.3	304	380	2024	67498
한국   	제네시스           	GV80 Coupe	8255	9190	대형 SUV	가솔린	7.8	8.3	304	415	2024	67501
한국   	EVKMC          	마사다 QQ밴	1950	1950	경형	전기	4.5	4.5	19.04	19.04	2023	102427
한국   	현대             	더 뉴 아반떼	1975	2826	준중형	가솔린, LPG	10.3	15	120	123	2025	109403
한국   	기아             	더 뉴 K5	2435	3526	중형	가솔린, LPG	9.4	16.1	141	180	2018	109423
한국   	기아             	더 뉴 K5 HEV	3326	3954	중형	하이브리드	17.1	19.8	152	152	2024	109456
유럽   	폴스타            	폴스타 2 F/L	5490	6389	중형	전기	3.8	4.8	299	299	2024	109549
유럽   	벤츠             	The New EQA	6790	7360	중형 SUV	전기	4.9	4.9	190	190	2025	109648
유럽   	벤츠             	The New EQB	7660	8200	중형 SUV	전기	4.1	4.1	228.4	228.4	2025	109657
미국   	포드             	Bronco	8160	8160	중형 SUV	가솔린	8.2	8.2	314	314	2022	112067
유럽   	BMW            	i7 M	23180	26340	대형	전기	3.3	3.3	659	659	2024	112231
한국   	기아             	더 뉴 카니발	3470	9200	RV/MPV	가솔린, 디젤 	8.2	11.4	202	280	2019	112755
한국   	기아             	더 뉴 카니발 HEV	3925	9650	RV/MPV	하이브리드	12.4	14	180	180	2024	112757
유럽   	벤츠             	The New GLS-Class F/L	16160	18150	대형 SUV	가솔린, 디젤	6	10.4	367	557	2024	112955
한국   	현대             	디 올 뉴 싼타페	3546	4700	중형 SUV	가솔린	9.4	11	281	281	2024	113046
한국   	현대             	디 올 뉴 싼타페 HEV	4031	5140	중형 SUV	하이브리드	13	15.5	180	180	2024	113048
미국   	링컨             	All New Nautilus	7740	7740	대형 SUV	가솔린	9	9	252	252	2024	113598
유럽   	벤츠             	The New A-Class F/L	4710	6650	소형	가솔린	10.6	12.2	190	306	2024	113653
유럽   	볼보             	EX30	4945	5516	소형 SUV	전기	5.5	5.5	200	200	2024	113983
한국   	현대             	더 뉴 투싼	2771	4004	준중형 SUV	가솔린, 디젤	11.2	14.3	180	184	2024	114604
한국   	현대             	더 뉴 투싼 HEV	3356	4304	준중형 SUV	하이브리드	14.3	16.2	180	180	2024	114607
유럽   	포르쉐            	The New Panamera	17670	30910	스포츠카	가솔린, 하이브리드	8	8	360	360	2024	114755
일본   	토요타            	Prius	3990	4990	준중형	하이브리드	19.4	19.4	223	223	2024	115102
유럽   	벤츠             	GLB-Class F/L	6210	7710	소형 SUV	가솔린, 디젤	9	14.2	150	306	2024	116410
유럽   	벤츠             	GLA-Class F/L	6790	6860	준중형 SUV	가솔린	10.8	10.8	224	224	2025	116423
유럽   	벤츠             	The New CLA-Class	6250	6320	중형	가솔린	11.9	11.9	224	224	2025	116430
한국   	제네시스           	디 올 뉴 G80 F/L	5890	7390	준대형	가솔린	8.2	10.6	304	380	2024	116448
유럽   	랜드로버           	New Range Rover Velar	9010	12420	중형 SUV	가솔린, 하이브리드	9.1	9.1	404	404	2024	117021
유럽   	랜드로버           	New Range Rover Evoque F/L	7400	8030	준중형 SUV	가솔린	8.9	8.9	249	249	2024	117033
유럽   	랜드로버           	New Discovery Sport F/L	7290	7660	중형 SUV	가솔린	8.2	8.2	249	249	2024	117046
유럽   	아우디            	SQ7	14758	14800	대형 SUV	가솔린	6.7	6.7	507	507	2024	117227
미국   	지프             	The New Wrangler	6970	9990	중형 SUV	가솔린, 하이브리드	7.5	11	272	272	2024	117267
미국   	포드             	All New Mustang	5990	8600	스포츠카	가솔린	7.2	9.6	319	493	2024	117861
유럽   	벤츠             	The New E-Class	7390	12300	준대형	가솔린, 디젤	11.6	15.4	197	381	2024	118250
유럽   	벤츠             	Maybach GLS-Class F/L	27900	31900	대형 SUV	가솔린	6.1	6.1	557	557	2024	118456
유럽   	BMW            	New X1 M	7150	7580	중형 SUV	가솔린	10.2	10.2	317	317	2024	119046
유럽   	벤츠             	The All New CLE	7270	10080	중형	가솔린	10.9	12.1	204	381	2024	119396
한국   	현대             	스타리아 HEV	3433	4614	승합	하이브리드	12.4	13	180	180	2024	119946
한국   	현대             	더 뉴 아이오닉 5	5519	6562	중형 SUV	전기	4.4	5.2	229	325	2024	120080
한국   	KG모빌리티         	렉스턴 써밋	6050	6050	대형 SUV	디젤	10.6	11.1	202	202	2024	120360
한국   	디피코            	포트로 P350	3245	3333	경형	전기	4	4	58.4	58.4	2023	121269
한국   	디피코            	포트로 P250	2233	2288	경형	전기	4.2	4.2	20.4	20.4	2024	121340
한국   	르노코리아          	Arkana	2285	2914	소형 SUV	가솔린	13.2	13.6	123	152	2025	121835
한국   	르노코리아          	Arkana E-TECH	2988	3310	소형 SUV	하이브리드	17	17.4	86	86	2025	121848
미국   	테슬라            	Upgraded Model 3	5199	6939	준중형	전기	4.8	5.7	283	283	2024	121870
유럽   	BMW            	New X2	6830	6830	준중형 SUV	가솔린	10.8	10.8	204	204	2024	122043
한국   	현대             	ST1	5980	7195	화물	전기	3.4	3.6	160	214	2024	122788
미국   	캐딜락            	New XT4	6120	6120	준중형 SUV	가솔린	10.3	10.3	238	238	2024	123346
한국   	제네시스           	GV70	5040	6565	중형 SUV	가솔린, 디젤	8.5	10.2	304	380	2025	123495
한국   	KG모빌리티         	더 뉴 토레스	2666	3761	중형 SUV	가솔린, LPG	8.9	11.2	165	170	2025	123551
한국   	기아             	더 뉴 EV6	5540	6602	중형 SUV	전기	4.6	5.2	229	325	2025	123870
미국   	캐딜락            	Lyriq	10696	10696	중형 SUV	전기	3.9	3.9	493	493	2024	124616
유럽   	벤츠             	The new GLC-Class	7680	10400	중형 SUV	가솔린, 디젤	8.3	14.1	197	421	2024	125003
일본   	렉서스            	LM	14800	19600	화물	하이브리드	13.5	13.5	371	371	2025	125112
한국   	기아             	EV3	4208	5108	준중형 SUV	전기	5.1	5.4	204	204	2025	125230
한국   	KG모빌리티         	코란도 EV	4243	4786	준중형 SUV	전기	4.8	4.8	207	207	2025	125247
유럽   	아우디            	SQ8 e-tron	15460	15460	대형 SUV	전기	2.6	2.6	496	496	2022	125737
유럽   	아우디            	Q8 e-tron	10860	13560	대형 SUV	전기	3	3	335	402	2024	125749
유럽   	미니             	The New Countryman 3세대	4990	6700	소형 SUV	가솔린	10.8	10.8	204	204	2024	125784
유럽   	미니             	The New Mini	4810	4810	소형	가솔린	12.7	12.7	204	204	2025	126693
유럽   	BMW            	M	6080	24940	스포츠카	전기, 가솔린, 하이브리드	4.1	12.5	306	625	2024	14168
\.


--
-- TOC entry 4899 (class 0 OID 0)
-- Dependencies: 222
-- Name: comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comments_id_seq', 17, true);


--
-- TOC entry 4900 (class 0 OID 0)
-- Dependencies: 224
-- Name: likes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.likes_id_seq', 1, false);


--
-- TOC entry 4901 (class 0 OID 0)
-- Dependencies: 220
-- Name: posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.posts_id_seq', 24, true);


--
-- TOC entry 4902 (class 0 OID 0)
-- Dependencies: 217
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 4, true);


--
-- TOC entry 4731 (class 2606 OID 24599)
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- TOC entry 4733 (class 2606 OID 24617)
-- Name: likes likes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.likes
    ADD CONSTRAINT likes_pkey PRIMARY KEY (id);


--
-- TOC entry 4729 (class 2606 OID 24587)
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- TOC entry 4727 (class 2606 OID 16443)
-- Name: session session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session
    ADD CONSTRAINT session_pkey PRIMARY KEY (sid);


--
-- TOC entry 4723 (class 2606 OID 16436)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 4725 (class 2606 OID 16434)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4721 (class 2606 OID 16412)
-- Name: vehicle 차량db_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicle
    ADD CONSTRAINT "차량db_pkey" PRIMARY KEY ("사진번호");


--
-- TOC entry 4734 (class 2606 OID 24605)
-- Name: comments comments_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.comments(id) ON DELETE CASCADE;


--
-- TOC entry 4735 (class 2606 OID 24600)
-- Name: comments comments_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(id) ON DELETE CASCADE;


--
-- TOC entry 4736 (class 2606 OID 24618)
-- Name: likes likes_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.likes
    ADD CONSTRAINT likes_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(id) ON DELETE CASCADE;


-- Completed on 2024-09-04 15:40:56

--
-- PostgreSQL database dump complete
--

