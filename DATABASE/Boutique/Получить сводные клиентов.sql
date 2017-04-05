-- Скрипты загрузки из  Profimanager применять на постгресе с предустановленным типом tvarchar
-- Важно все файлы сохранить в UTF - 8 
-- Результат будет в файле Result.csv в кодировке utf-8 
-- Важно. Перед открытием в экселе изменить кодировку файла на win1251 
-- Все таблыци удалятся после работы скрипта

DROP TABLE  IF EXISTS  chado;
create table chado
(
	Name tvarchar,
	Coment tvarchar,
	ReplId integer,
	DbId integer
);

COPY chado
    FROM  'd:\Profimanager\chado.dat'
     WITH
           DELIMITER  AS  ','
           CSV  
                QUOTE  AS  ''''
;

-- 
DROP TABLE  IF EXISTS  escada;
create table escada
(
	Name tvarchar,
	Coment tvarchar,
	ReplId integer,
	DbId integer
);

COPY escada
    FROM  'd:\Profimanager\escada.dat'
     WITH
           DELIMITER  AS  ','
           CSV  
                QUOTE  AS  ''''
;

-- 
DROP TABLE  IF EXISTS  mm;
create table mm
(
	Name tvarchar,
	Coment tvarchar,
	ReplId integer,
	DbId integer
);

COPY mm
    FROM  'd:\Profimanager\mm.dat'
     WITH
           DELIMITER  AS  ','
           CSV  
                QUOTE  AS  ''''
;

-- 
DROP TABLE  IF EXISTS  sav;
create table sav
(
	Name tvarchar,
	Coment tvarchar,
	ReplId integer,
	DbId integer
);

COPY sav
    FROM  'd:\Profimanager\sav.dat'
     WITH
           DELIMITER  AS  ','
           CSV  
                QUOTE  AS  ''''
;
-- 
DROP TABLE  IF EXISTS  sopra;
create table sopra
(
	Name tvarchar,
	Coment tvarchar,
	ReplId integer,
	DbId integer
);

COPY sopra
    FROM  'd:\Profimanager\sopra.dat'
     WITH
           DELIMITER  AS  ','
           CSV  
                QUOTE  AS  ''''
;
-- 
DROP TABLE  IF EXISTS  sv_vintag;
create table sv_vintag
(
	Name tvarchar,
	Coment tvarchar,
	ReplId integer,
	DbId integer
);

COPY sv_vintag
    FROM  'd:\Profimanager\sv_vintag.dat'
     WITH
           DELIMITER  AS  ','
           CSV  
                QUOTE  AS  ''''
;

-- 
DROP TABLE  IF EXISTS  ter_Vin;
create table ter_Vin
(
	Name tvarchar,
	Coment tvarchar,
	ReplId integer,
	DbId integer
);

COPY ter_Vin
    FROM  'd:\Profimanager\ter_Vin.dat'
     WITH
           DELIMITER  AS  ','
           CSV  
                QUOTE  AS  ''''
;

-- 
DROP TABLE  IF EXISTS  TL;
create table TL
(
	Name tvarchar,
	Coment tvarchar,
	ReplId integer,
	DbId integer
);

COPY TL
    FROM  'd:\Profimanager\TL.dat'
     WITH
           DELIMITER  AS  ','
           CSV  
                QUOTE  AS  ''''
;
-- 
DROP TABLE  IF EXISTS  Vintag;
create table Vintag
(
	Name tvarchar,
	Coment tvarchar,
	ReplId integer,
	DbId integer
);

COPY Vintag
    FROM  'd:\Profimanager\Vintag.dat'
     WITH
           DELIMITER  AS  ','
           CSV  
                QUOTE  AS  ''''
;

COPY (
SELECT Users.dbid
, Users.replid
, chado.Name       as chadoName
, chado.Coment     as chadoComent
, escada.name      as escadaName
, escada.Coment    as escadaComent
, mm.name          as mmName
, mm.Coment        as mmComent
, sav.name         as savName
, sav.Coment       as savComent
, sopra.name       as sopraName
, sopra.Coment     as sopraComent
, sv_vintag.name   as sv_vintagName
, sv_vintag.Coment as sv_vintagComent
, ter_Vin.name     as ter_VinName
, ter_Vin.Coment   as ter_VinComent
, TL.name          as TLName
, TL.Coment        as TLComent
, Vintag.name      as VintagName
, Vintag.Coment    as VintagComent


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


ORDER BY  Users.dbid, Users.replid

)
    To  'd:\Profimanager\Result.csv'
     WITH
           DELIMITER  AS  ';'
           CSV  HEADER
             --   QUOTE  AS  ''''
             --   FORCE QUOTE *
;
DROP TABLE  IF EXISTS  chado;
DROP TABLE  IF EXISTS  escada;
DROP TABLE  IF EXISTS  mm;
DROP TABLE  IF EXISTS  sav;
DROP TABLE  IF EXISTS  sopra;
DROP TABLE  IF EXISTS  sv_vintag;
DROP TABLE  IF EXISTS  ter_Vin;
DROP TABLE  IF EXISTS  TL;
DROP TABLE  IF EXISTS  Vintag;