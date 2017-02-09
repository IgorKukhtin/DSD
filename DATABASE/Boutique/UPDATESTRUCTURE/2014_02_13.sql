-- Добавить у проводок тип документа
DO $$ 
    BEGIN
      IF NOT (EXISTS(Select table_name From INFORMATION_SCHEMA.tables Where Table_Name = lower('MovementProtocol'))) THEN
         CREATE TABLE MovementProtocol(
                      Id                    SERIAL NOT NULL PRIMARY KEY, 
                      MovementId            INTEGER,
                      UserId                INTEGER,
                      OperDate              TDateTime,
                      ProtocolData          TBlob, 
                      isInsert              Boolean,
                      CONSTRAINT fk_MovementProtocol_MovementId FOREIGN KEY(MovementId) REFERENCES Movement(Id),
                      CONSTRAINT fk_MovementProtocol_UserId FOREIGN KEY(UserId) REFERENCES Object(Id)
          );


          CREATE INDEX idx_MovementProtocol_MovementId ON MovementProtocol (MovementId);
          CREATE INDEX idx_MovementProtocol_UserId ON MovementProtocol (UserId);
          CREATE INDEX idx_MovementProtocol_OperDate ON MovementProtocol (OperDate);

      END IF;
      IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('ObjectProtocol') AND Column_Name = lower('isInsert'))) THEN
         ALTER TABLE ObjectProtocol ADD COLUMN isInsert Boolean;
         UPDATE ObjectProtocol SET isInsert = false;
         UPDATE ObjectProtocol SET isInsert = true
                FROM (SELECT MIN(OperDate) AS OperDate, ObjectId FROM ObjectProtocol GROUP BY ObjectId) AS DD
               WHERE DD.objectid = ObjectProtocol.objectid AND DD.operdate = ObjectProtocol.operdate;
      END IF;
    END;
$$;