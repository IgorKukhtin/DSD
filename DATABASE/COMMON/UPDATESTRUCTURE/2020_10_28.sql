DO $$ 
BEGIN

/*
-- select count(*) from ResourseProtocol
-- select count(*) from ResourseItemProtocol
TRUNCATE TABLE ResourseProtocol;
TRUNCATE TABLE ResourseItemProtocol;
*/

      IF NOT (EXISTS (SELECT table_name FROM INFORMATION_SCHEMA.tables WHERE table_name ILIKE ('ResourseItemProtocol'))) 
      THEN
         --DROP TABLE ResourseItemProtocol
           CREATE TABLE ResourseItemProtocol (
              Id                    BIGSERIAL NOT NULL, 
              pid                   BIGINT,    -- pid процесса
              query_start_no_timezone TIMESTAMP WITHOUT TIME ZONE , -- во сколько началcя выполняться процесс
              query_start           TDateTime, -- во сколько началcя выполняться процесс
              datname               TVarChar,  -- 
              usename               TVarChar,  -- 
              client_addr           TVarChar,  -- 
              state                 TVarChar,  -- 
            --wait_event_type       TVarChar,  -- 
              waiting               Boolean,   -- 
              query                 TBlob,     -- проц.
              InsertDate            TDateTime, -- 
              Id_start              Integer,
              Id_end                Integer,
              Last_modified         TIMESTAMP WITHOUT TIME ZONE , -- 
              CONSTRAINT pk_ResourseItemProtocol PRIMARY KEY (Id)
           );

           CREATE INDEX idx_ResourseItemProtocol_InsertDate ON ResourseItemProtocol (InsertDate);
           CREATE INDEX idx_ResourseItemProtocol_Id_start ON ResourseItemProtocol (Id_start);
           CREATE INDEX idx_ResourseItemProtocol_Id_end ON ResourseItemProtocol (Id_end);
      END IF;

END;
$$;

