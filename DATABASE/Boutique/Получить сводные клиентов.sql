-- Скрипты загрузки из  Profimanager применять на постгресе с предустановленным типом tvarchar
-- Результат будет в файле Result.csv 
-- Все таблицы удалятся после работы скрипта
-- Изменение кодировок не нужно

-- 01
DROP TABLE  IF EXISTS  mm;
create table mm
(
	Name tvarchar,
	Coment tvarchar,
	ReplId integer,
	DbId integer,
        Date Tdatetime,
        suma Tfloat
);

COPY mm
    FROM  'd:\Profimanager\01mm.dat'
     WITH
           DELIMITER  AS  ','
           CSV
                QUOTE  AS  ''''
           ENCODING 'WIN866'
;

-- 02
DROP TABLE  IF EXISTS  TL;
create table TL
(
	Name tvarchar,
	Coment tvarchar,
	ReplId integer,
	DbId integer,
        Date Tdatetime,
        suma Tfloat
);

COPY TL
    FROM  'd:\Profimanager\02TL.dat'
     WITH
           DELIMITER  AS  ','
           CSV
                QUOTE  AS  ''''
           ENCODING 'WIN1251'
;
-- 03
DROP TABLE  IF EXISTS  Elem;
create table Elem
(
	Name tvarchar,
	Coment tvarchar,
	ReplId integer,
	DbId integer,
        Date Tdatetime,
        suma Tfloat
);

COPY Elem
    FROM  'd:\Profimanager\3Elem.dat'
     WITH
           DELIMITER  AS  ','
           CSV
                QUOTE  AS  ''''
          ENCODING 'WIN1251'
;


-- 04
DROP TABLE  IF EXISTS  chado;
create table chado
(
	Name tvarchar,
	Coment tvarchar,
	ReplId integer,
	DbId integer,
        Date Tdatetime,
        suma Tfloat
);

COPY chado
    FROM  'd:\Profimanager\04chado.dat'
     WITH
           DELIMITER  AS  ','
           CSV
                QUOTE  AS  ''''
           ENCODING 'WIN1251'
;
-- 05
DROP TABLE  IF EXISTS  sav;
create table sav
(
	Name tvarchar,
	Coment tvarchar,
	ReplId integer,
	DbId integer,
        Date Tdatetime,
        suma Tfloat
);

COPY sav
    FROM  'd:\Profimanager\05sav.dat'
     WITH
           DELIMITER  AS  ','
           CSV
                QUOTE  AS  ''''
           ENCODING 'WIN1251'
;
-- 06
DROP TABLE  IF EXISTS  ter_Vin;
create table ter_Vin
(
	Name tvarchar,
	Coment tvarchar,
	ReplId integer,
	DbId integer,
        Date Tdatetime,
        suma Tfloat
);

COPY ter_Vin
    FROM  'd:\Profimanager\06ter_Vin.dat'
     WITH
           DELIMITER  AS  ','
           CSV
                QUOTE  AS  ''''
           ENCODING 'WIN866'
;

-- 07
DROP TABLE  IF EXISTS  Vintag;
create table Vintag
(
	Name tvarchar,
	Coment tvarchar,
	ReplId integer,
	DbId integer,
        Date Tdatetime,
        suma Tfloat
);

COPY Vintag
    FROM  'd:\Profimanager\07Vintag.dat'
     WITH
           DELIMITER  AS  ','
           CSV
                QUOTE  AS  ''''
           ENCODING 'WIN1251'
;


-- 08
DROP TABLE  IF EXISTS  escada;
create table escada
(
	Name tvarchar,
	Coment tvarchar,
	ReplId integer,
	DbId integer,
        Date Tdatetime,
        suma Tfloat
);

COPY escada
    FROM  'd:\Profimanager\08escada.dat'
     WITH
           DELIMITER  AS  ','
           CSV
                QUOTE  AS  ''''
           ENCODING 'WIN866'
;

-- 09
DROP TABLE  IF EXISTS  sv_vintag;
create table sv_vintag
(
	Name tvarchar,
	Coment tvarchar,
	ReplId integer,
	DbId integer,
        Date Tdatetime,
        suma Tfloat
);

COPY sv_vintag
    FROM  'd:\Profimanager\09sv_vintag.dat'
     WITH
           DELIMITER  AS  ','
           CSV
                QUOTE  AS  ''''
           ENCODING 'WIN866'
;

--  10
DROP TABLE  IF EXISTS  sopra;
create table sopra
(
	Name tvarchar,
	Coment tvarchar,
	ReplId integer,
	DbId integer,
        Date Tdatetime,
        suma Tfloat
);

COPY sopra
    FROM  'd:\Profimanager\10sopra.dat'
     WITH
           DELIMITER  AS  ','
           CSV
                QUOTE  AS  ''''
           ENCODING 'WIN1251'
;

-- выгрузка

COPY (
SELECT Users.dbid
, Users.replid

, mm.Name          as mmName
, mm.Coment        as mmComent
, mm.Date          as mmDate
, mm.Suma          as mmSuma

, TL.Name          as TLName
, TL.Coment        as TLComent
, TL.Date          as TLDate
, TL.Suma          as TLSuma

, Elem.Name        as ElemName
, Elem.Coment      as ElemComent
, Elem.Date        as ElemDate
, Elem.Suma        as ElemSuma

, chado.Name       as chadoName
, chado.Coment     as chadoComent
, chado.Date       as chadoDate
, chado.Suma       as chadoSuma

, sav.Name         as savName
, sav.Coment       as savComent
, sav.Date         as savDate
, sav.Suma         as savSuma

, ter_Vin.Name     as ter_VinName
, ter_Vin.Coment   as ter_VinComent
, ter_Vin.Date     as ter_VinDate
, ter_Vin.Suma     as ter_VinSuma

, Vintag.Name      as VintagName
, Vintag.Coment    as VintagComent
, Vintag.Date      as VintagDate
, Vintag.Suma      as VintagSuma

, escada.Name      as escadaName
, escada.Coment    as escadaComent
, escada.Date      as escadaDate
, escada.Suma      as escadaSuma

, sv_vintag.Name   as sv_vintagName
, sv_vintag.Coment as sv_vintagComent
, sv_vintag.Date   as sv_vintagDate
, sv_vintag.Suma   as sv_vintagSuma

, sopra.Name       as sopraName
, sopra.Coment     as sopraComent
, sopra.Date       as sopraDate
, sopra.Suma       as sopraSuma


from
(
SELECT DISTINCT  a.replid , a.dbid  FROM
(
SELECT *  FROM chado
UNION ALL
SELECT *  FROM escada
UNION ALL
SELECT *  FROM mm
UNION ALL
SELECT *  FROM sav
UNION ALL
SELECT *  FROM sopra
UNION ALL
SELECT *  FROM sv_vintag
UNION ALL
SELECT *  FROM ter_Vin
UNION ALL
SELECT *  FROM TL
UNION ALL
SELECT *  FROM Vintag
UNION ALL
SELECT *  FROM Elem
) a
group by a.replid, a.dbid
ORDER BY  a.replid
) as Users
left join (SELECT * FROM chado) as  chado on chado.replid = users.replid and chado.dbid = users.dbid
left join (SELECT * FROM escada) as  escada on escada.replid = users.replid and escada.dbid = users.dbid
left join (SELECT * FROM mm) as  mm on mm.replid = users.replid and mm.dbid = users.dbid
left join (SELECT * FROM sav) as  sav on sav.replid = users.replid and sav.dbid = users.dbid
left join (SELECT * FROM sopra) as  sopra on sopra.replid = users.replid and sopra.dbid = users.dbid
left join (SELECT * FROM sv_vintag) as  sv_vintag on sv_vintag.replid = users.replid and sv_vintag.dbid = users.dbid
left join (SELECT * FROM ter_Vin) as  ter_Vin on ter_Vin.replid = users.replid and ter_Vin.dbid = users.dbid
left join (SELECT * FROM TL) as  TL on TL.replid = users.replid and TL.dbid = users.dbid
left join (SELECT * FROM Vintag) as  Vintag on Vintag.replid = users.replid and Vintag.dbid = users.dbid
left join (SELECT * FROM Elem) as  Elem on Elem.replid = users.replid and Elem.dbid = users.dbid


ORDER BY 
    Users.dbid, Users.replid,
          case when trim (mm.name) <> '' then mm.name
               when trim (TL.name) <> '' then TL.name
               when trim (Elem.name) <> '' then Elem.name
               when trim (chado.name) <> '' then chado.name
               when trim (sav.name) <> '' then sav.name
               when trim (ter_Vin.name) <> '' then ter_Vin.name
               when trim (Vintag.name) <> '' then Vintag.name
               when trim (escada.name) <> '' then escada.name
               when trim (sv_vintag.name) <> '' then sv_vintag.name
               when trim (sopra.name) <> '' then sopra.name

           else '' end
       

)
    To  'd:\Profimanager\Result.csv'
     WITH
           DELIMITER  AS  ';'
           CSV  HEADER
             --   QUOTE  AS  ''''
                FORCE QUOTE *
           ENCODING 'WIN1251'
;
-- Удаляем таблыцы
DROP TABLE  IF EXISTS  mm;
DROP TABLE  IF EXISTS  TL;
DROP TABLE  IF EXISTS  Elem;
DROP TABLE  IF EXISTS  chado;
DROP TABLE  IF EXISTS  sav;
DROP TABLE  IF EXISTS  ter_Vin;
DROP TABLE  IF EXISTS  Vintag;
DROP TABLE  IF EXISTS  escada;
DROP TABLE  IF EXISTS  sv_vintag;
DROP TABLE  IF EXISTS  sopra;