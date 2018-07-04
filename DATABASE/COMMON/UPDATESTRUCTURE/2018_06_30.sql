DO $$ 
BEGIN

      IF NOT (EXISTS (SELECT table_name FROM INFORMATION_SCHEMA.tables WHERE table_name = lower ('ReplObject'))) 
      THEN
           CREATE TABLE ReplObject (
              Id                    BIGSERIAL NOT NULL, 
              ObjectId              Integer,
              DescId                Integer,
              UserId_last           Integer,
              OperDate_last         TDateTime,
              OperDate              TDateTime,
              SessionGUID           TVarChar
             );

           CREATE UNIQUE INDEX idx_ReplObject_ObjectId_SessionGUID ON ReplObject (ObjectId, SessionGUID);
           CREATE INDEX idx_ReplObject_SessionGUID ON ReplObject (SessionGUID);
           CREATE INDEX idx_ReplObject_OperDate ON ReplObject (OperDate DESC);
      END IF;

END;
$$;
