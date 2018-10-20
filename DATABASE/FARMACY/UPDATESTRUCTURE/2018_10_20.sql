DO $$ 
BEGIN

      IF NOT (EXISTS (SELECT table_name FROM INFORMATION_SCHEMA.tables WHERE table_name = lower ('ResourseProtocol'))) 
      THEN
           CREATE TABLE ResourseProtocol (
              Id                    SERIAL NOT NULL, 
              UserId                INTEGER,
              OperDate              TDateTime,
              Value1                INTEGER,
              Value2                INTEGER,
              Value3                INTEGER,
              Value4                INTEGER,
              Value5                INTEGER,
              Time1                 INTERVAL,
              Time2                 INTERVAL,
              Time3                 INTERVAL,
              Time4                 INTERVAL,
              Time5                 TDateTime,
              ProcName              TVarChar, 
              ProtocolData          TBlob, 

              CONSTRAINT pk_ResourseProtocol PRIMARY KEY (Id)
           );

           CREATE INDEX idx_ResourseProtocol_UserId ON ResourseProtocol (UserId);
           CREATE INDEX idx_ResourseProtocol_OperDate ON ResourseProtocol (OperDate DESC);
      END IF;

END;
$$;
