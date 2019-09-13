DO $$ 
BEGIN

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
              datname              TVarChar,  -- 
              usename              TVarChar,  -- 
              client_addr           TVarChar,  -- 
              state                 TVarChar,  -- 
              wait_event_type       TVarChar,  -- 
              wait_event            TVarChar,  -- 
              query                 TBlob,     -- проц.

              CONSTRAINT pk_ResourseItemProtocol PRIMARY KEY (Id)
           );

           CREATE INDEX idx_ResourseItemProtocol_ParentId ON ResourseItemProtocol (ParentId);
      END IF;

END;
$$;
