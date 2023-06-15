DO $$ 
BEGIN

      IF NOT (EXISTS (SELECT table_name FROM INFORMATION_SCHEMA.tables WHERE table_name ILIKE ('_RecalcPG_log'))) 
      THEN
         --DROP TABLE _RecalcPG_log
           CREATE TABLE _RecalcPG_log (
              Id                    BIGSERIAL NOT NULL,
              GroupId               Integer NOT NULL,
              OperDate              TDateTime NOT NULL,
              CONSTRAINT pk_RecalcPG_log PRIMARY KEY (GroupId)
           );

      END IF;

END;
$$;

