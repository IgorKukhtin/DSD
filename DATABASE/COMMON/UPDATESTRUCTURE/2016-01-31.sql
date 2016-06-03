-- 
DO $$ 
    BEGIN
     
      IF NOT (EXISTS(Select table_name From INFORMATION_SCHEMA.tables Where Table_Name = lower ('MovementItemProtocol_arc')))
      THEN
          CREATE TABLE MovementItemProtocol_arc(
             Id                    SERIAL NOT NULL PRIMARY KEY, 
             MovementItemId        INTEGER,
             UserId                INTEGER,
             OperDate              TDateTime,
             ProtocolData          TBlob, 
             isInsert              Boolean,
          
             CONSTRAINT fk_MovementItemProtocol_arc_MovementItemId FOREIGN KEY(MovementItemId) REFERENCES MovementItem(Id),
             CONSTRAINT fk_MovementItemProtocol_arc_UserId FOREIGN KEY(UserId) REFERENCES Object(Id)
          );
          ALTER TABLE MovementItemProtocol_arc OWNER TO postgres;

         -- и еще индекс
         CREATE INDEX idx_MovementItemProtocol_arc_MovementItemId ON MovementItemProtocol_arc (MovementItemId);
         CREATE INDEX idx_MovementItemProtocol_arc_UserId ON MovementItemProtocol_arc (UserId);
         CREATE INDEX idx_MovementItemProtocol_arc_OperDate ON MovementItemProtocol_arc (OperDate);

      END IF;


      IF NOT (EXISTS(Select table_name From INFORMATION_SCHEMA.tables Where Table_Name = lower ('MovementProtocol_arc')))
      THEN
          CREATE TABLE MovementProtocol_arc(
             Id                    SERIAL NOT NULL PRIMARY KEY, 
             MovementId            INTEGER,
             UserId                INTEGER,
             OperDate              TDateTime,
             ProtocolData          TBlob, 
             isInsert              Boolean,

             CONSTRAINT fk_MovementProtocol_arc_MovementId FOREIGN KEY(MovementId) REFERENCES Movement(Id),
             CONSTRAINT fk_MovementProtocol_arc_UserId FOREIGN KEY(UserId) REFERENCES Object(Id)
          );
          ALTER TABLE MovementProtocol_arc OWNER TO postgres;

         -- и еще индекс
         CREATE INDEX idx_MovementProtocol_arc_MovementId ON MovementProtocol_arc (MovementId);
         CREATE INDEX idx_MovementProtocol_arc_UserId ON MovementProtocol_arc (UserId);
         CREATE INDEX idx_MovementProtocol_arc_OperDate ON MovementProtocol_arc (OperDate);

      END IF;

    END;
$$;
/*
DO $$ 
  DECLARE vbTmp Integer;
    BEGIN
            -- select 1, count(*) from movementprotocol union all select 2, count(*) from movementitemprotocol;

                 vbTmp:= (select max (Id) from movementprotocol);	

         insert into movementprotocol_arc
            select * from movementprotocol where Id < vbTmp;
         delete from movementprotocol where Id < vbTmp;

                 vbTmp:= (select max (Id) from movementitemprotocol);	
         insert into movementitemprotocol_arc
            select * from movementitemprotocol where Id < vbTmp;
         delete from movementitemprotocol where Id < vbTmp;

    END;
$$;
*/
