DO $$ 
BEGIN

/*
INSERT INT ResourseProtocol_arc     SELECT * FROM ResourseProtocol;
INSERT INT ResourseItemProtocol_arc SELECT * FROM ResourseItemProtocol;
TRUNCATE TABLE ResourseProtocol;
TRUNCATE TABLE ResourseItemProtocol;
*/
      IF NOT (EXISTS (SELECT table_name FROM INFORMATION_SCHEMA.tables WHERE table_name = lower ('ResourseProtocol'))) 
      THEN
           CREATE TABLE ResourseProtocol (
              Id                    SERIAL NOT NULL, 
              UserId                INTEGER,
              OperDate              TDateTime, -- во сколько началась выполняться
              Value1                INTEGER,   -- сколько всего активных процессов
              Value2                INTEGER,   -- сколько всего процессов
              Value3                INTEGER,   -- сколько процессов группы1
              Value4                INTEGER,   -- сколько процессов группы2
              Value5                INTEGER,   -- сколько процессов группы3
              Time1                 INTERVAL,  -- сколько всего выполнялась проц
              Time2                 INTERVAL,  -- сколько выполнялась до точки1
              Time3                 INTERVAL,  -- сколько выполнялась до точки2
              Time4                 INTERVAL,  -- сколько выполнялась до точки3
              Time5                 TDateTime, -- во сколько закончилась
              ProcName              TVarChar,  -- какую проц. тестим
              ProtocolData          TBlob,     -- параметры проц.

              CONSTRAINT pk_ResourseProtocol PRIMARY KEY (Id)
           );

           CREATE INDEX idx_ResourseProtocol_UserId ON ResourseProtocol (UserId);
           CREATE INDEX idx_ResourseProtocol_OperDate ON ResourseProtocol (OperDate DESC);
      END IF;

      IF NOT (EXISTS (SELECT table_name FROM INFORMATION_SCHEMA.tables WHERE table_name = lower ('ResourseItemProtocol'))) 
      THEN
           CREATE TABLE ResourseItemProtocol (
              Id                    SERIAL NOT NULL, 
              ParentId              INTEGER,
              pid                   INTEGER,   -- pid процесса
              query_start           TDateTime, -- во сколько началcя выполняться процесс
              datname               TVarChar,  -- 
              usename               TVarChar,  -- 
              client_addr           TVarChar,  -- 
              state                 TVarChar,  -- 
              wait_event_type       TVarChar,  -- 
              wait_event            TVarChar,  -- 
              query                 TBlob,     -- проц.

              CONSTRAINT pk_ResourseItemProtocol PRIMARY KEY (Id)
           );

           CREATE INDEX idx_ResourseItemProtocol_ParentId ON ResourseItemProtocol (ParentId);
      END IF;


      -- arc - 1
      IF NOT (EXISTS (SELECT table_name FROM INFORMATION_SCHEMA.tables WHERE table_name = lower ('ResourseProtocol_arc'))) 
      THEN
           CREATE TABLE ResourseProtocol_arc (
              Id                    SERIAL NOT NULL, 
              UserId                INTEGER,
              OperDate              TDateTime, -- во сколько началась выполняться
              Value1                INTEGER,   -- сколько всего активных процессов
              Value2                INTEGER,   -- сколько всего процессов
              Value3                INTEGER,   -- сколько процессов группы1
              Value4                INTEGER,   -- сколько процессов группы2
              Value5                INTEGER,   -- сколько процессов группы3
              Time1                 INTERVAL,  -- сколько всего выполнялась проц
              Time2                 INTERVAL,  -- сколько выполнялась до точки1
              Time3                 INTERVAL,  -- сколько выполнялась до точки2
              Time4                 INTERVAL,  -- сколько выполнялась до точки3
              Time5                 TDateTime, -- во сколько закончилась
              ProcName              TVarChar,  -- какую проц. тестим
              ProtocolData          TBlob,     -- параметры проц.

              CONSTRAINT pk_ResourseProtocol_arc PRIMARY KEY (Id)
           );

           CREATE INDEX idx_ResourseProtocol_arc_UserId   ON ResourseProtocol_arc (UserId);
           CREATE INDEX idx_ResourseProtocol_arc_OperDate ON ResourseProtocol_arc (OperDate DESC);
      END IF;

      -- arc - 2
      IF NOT (EXISTS (SELECT table_name FROM INFORMATION_SCHEMA.tables WHERE table_name = lower ('ResourseItemProtocol_arc'))) 
      THEN
           CREATE TABLE ResourseItemProtocol_arc (
              Id                    SERIAL NOT NULL, 
              ParentId              INTEGER,
              pid                   INTEGER,   -- pid процесса
              query_start           TDateTime, -- во сколько началcя выполняться процесс
              datname               TVarChar,  -- 
              usename               TVarChar,  -- 
              client_addr           TVarChar,  -- 
              state                 TVarChar,  -- 
              wait_event_type       TVarChar,  -- 
              wait_event            TVarChar,  -- 
              query                 TBlob,     -- проц.

              CONSTRAINT pk_ResourseItemProtocol_arc PRIMARY KEY (Id)
           );

           CREATE INDEX idx_ResourseItemProtocol_arc_ParentId ON ResourseItemProtocol_arc (ParentId);
      END IF;
END;
$$;

/*
with a1 as (SELECT * FROM ResourseProtocol where OperDate > CURRENT_DATE)
   , a2 as (SELECT * FROM ResourseItemProtocol where ParentId in (SELECT Id FROM a1 where OperDate > CURRENT_DATE))
   , a21 as (SELECT * FROM a2 where wait_event_type <> '')
   , a22 as (SELECT distinct query_start, pid, query FROM a21)
   , a11 as (SELECT * FROM a1 where Id in (SELECT ParentId FROM a21))
-- все Parent - если есть хоть один wait_event_type <> ''
-- select * from a11 order by id desc
-- все Item - где wait_event_type <> '' - определяем время сколько выполнялся
/*SELECT min (a1.OperDate), min (a1.OperDate) - query_start as diff,  min (a1.Value1) as Value1, min (a1.Value2) as Value2, min (a1.Value3) as Value3, min (a1.Value4) as Value4, max (Time1) as Time1, max (Time2) as Time2
     , query_start, pid, query
FROM a21
     left join a1 on a1.Id = ParentId
group by  query_start, pid, query
order by 2 desc, 1 desc*/
-- все Item - где wait_event_type <> ''
SELECT a1.OperDate, a1.Value1, a1.Value2, a1.Value3, a1.Value4, Time1, Time2, a2.*
FROM a2
     left join a1 on a1.Id = ParentId
-- where wait_event_type <> ''
order by a1.OperDate desc
*/

with a1 as (SELECT * FROM ResourseProtocol where OperDate > CURRENT_DATE)
   , a2 as (SELECT * FROM ResourseItemProtocol where ParentId in (SELECT Id FROM a1 where OperDate > CURRENT_DATE))
   , a21 as (SELECT * FROM a2 where wait_event_type <> '')
   , a22 as (SELECT distinct query_start, pid, query FROM a21)
   , a11 as (SELECT * FROM a1 where Id in (SELECT ParentId FROM a21))
-- все
SELECT * from
(SELECT (select count(*) from  a21 where ParentId = a1.Id) as x1
      , (select pid from  a21 where ParentId = a1.Id order by query_start asc limit 1) as x2_1
      , (select query_start from  a21 where ParentId = a1.Id order by query_start limit 1) as x2_2
      , (select pid from  a21 where ParentId = a1.Id and  pid <> (select pid from  a21 where ParentId = a1.Id order by query_start asc limit 1) 
         order by query_start limit 1) as x3
      , (select query_start from  a21 where ParentId = a1.Id and  pid <> (select pid from  a21 where ParentId = a1.Id order by query_start asc limit 1) 
         order by query_start limit 1) as x3
      , *
FROM a1) as tmp
where x1 > 0 
order by 6 desc
limit 1000

