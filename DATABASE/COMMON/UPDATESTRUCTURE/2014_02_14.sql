-- Добавить у проводок тип документа
DO $$ 
    BEGIN
      IF NOT (EXISTS(Select table_name From INFORMATION_SCHEMA.tables Where Table_Name = lower('MovementItemProtocol'))) THEN
         CREATE TABLE MovementItemProtocol(
                      Id                    SERIAL NOT NULL PRIMARY KEY, 
                      MovementItemId        INTEGER,
                      UserId                INTEGER,
                      OperDate              TDateTime,
                      ProtocolData          TBlob, 
                      isInsert              Boolean,
                      CONSTRAINT fk_MovementItemProtocol_MovementItemId FOREIGN KEY(MovementItemId) REFERENCES MovementItem(Id),
                      CONSTRAINT fk_MovementItemProtocol_UserId FOREIGN KEY(UserId) REFERENCES Object(Id)
          );


          CREATE INDEX idx_MovementItemProtocol_MovementItemId ON MovementItemProtocol (MovementItemId);
          CREATE INDEX idx_MovementItemProtocol_UserId ON MovementItemProtocol (UserId);
          CREATE INDEX idx_MovementItemProtocol_OperDate ON MovementItemProtocol (OperDate);

      END IF;
      IF NOT (EXISTS(Select table_name From INFORMATION_SCHEMA.tables Where Table_Name = lower('UserProtocol'))) THEN
          CREATE TABLE UserProtocol(
                 Id                    SERIAL NOT NULL PRIMARY KEY, 
                 UserId                INTEGER,
                 OperDate              TDateTime,
                 ProtocolData          TBlob, 

                 CONSTRAINT fk_UserProtocol_UserId FOREIGN KEY(UserId) REFERENCES Object(Id)
               );


          CREATE INDEX idx_UserProtocol_UserId ON UserProtocol (UserId);
          CREATE INDEX idx_UserProtocol_OperDate ON UserProtocol (OperDate);

      END IF;
    END;
$$;