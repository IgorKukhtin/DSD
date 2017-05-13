DO $$ 
    BEGIN

      IF NOT (EXISTS (SELECT table_name From INFORMATION_SCHEMA.tables WHERE Table_Name = lower ('LockUnique'))) THEN
         CREATE TABLE LockUnique
         (
          KeyData      TVarChar  NOT NULL UNIQUE,
          UserId       Integer   NOT NULL,
          OperDate     TDateTime NOT NULL
         )
         WITH (
             OIDS=FALSE
         );
         -- Права
         ALTER TABLE LockUnique OWNER TO postgres;
         -- Индексы
         CREATE INDEX idx_LockUnique_KeyData   ON LockUnique (KeyData);
         CREATE INDEX idx_LockUnique_OperDate  ON LockUnique (OperDate);
         -- !!! CLUSTER !!!
         CLUSTER idx_LockUnique_KeyData ON LockUnique;
      END IF;


    END;
$$;
