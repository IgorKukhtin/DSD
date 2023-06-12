DO $$ 
BEGIN

      IF NOT (EXISTS (SELECT table_name FROM INFORMATION_SCHEMA.tables WHERE table_name ILIKE ('_RecalcPG_log'))) 
      THEN
         --DROP TABLE ResourseItemProtocol
           CREATE TABLE _RecalcPG_log (
              Id                    BIGSERIAL NOT NULL,
              GroupId               Integer,
              OperDate              TDateTime,
              CONSTRAINT pk_RecalcPG_log PRIMARY KEY (Id)
           );

      END IF;

END;
$$;

