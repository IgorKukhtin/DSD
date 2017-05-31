DO $$ 
BEGIN

      IF NOT (EXISTS (SELECT table_name FROM INFORMATION_SCHEMA.tables WHERE table_name = lower ('ReportProtocol'))) 
      THEN
           CREATE TABLE ReportProtocol (
              Id                    SERIAL NOT NULL, 
              UserId                INTEGER,
              OperDate              TDateTime,
              ProtocolData          TBlob, 

              CONSTRAINT pk_ReportProtocol PRIMARY KEY (Id),
              CONSTRAINT fk_ReportProtocol_UserId FOREIGN KEY(UserId) REFERENCES Object (Id)
           );

           CREATE INDEX idx_ReportProtocol_UserId ON ReportProtocol (UserId);
           CREATE INDEX idx_ReportProtocol_OperDate ON ReportProtocol (OperDate DESC);
      END IF;

END;
$$;
