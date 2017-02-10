-- Добавить у проводок тип документа
DO $$ 
    BEGIN
      IF NOT (EXISTS(Select table_name From INFORMATION_SCHEMA.tables Where Table_Name = lower('MovementLinkMovementDesc'))) THEN
         CREATE TABLE MovementLinkMovementDesc
         (
          Id                    SERIAL NOT NULL PRIMARY KEY, 
          Code                  TVarChar NOT NULL UNIQUE,
          ItemName              TVarChar
         )
         WITH (
             OIDS=FALSE
         );
         ALTER TABLE MovementLinkMovementDesc OWNER TO postgres;
      END IF;

      IF NOT (EXISTS(Select table_name From INFORMATION_SCHEMA.tables Where Table_Name = lower('MovementLinkMovement'))) THEN
         CREATE TABLE MovementLinkMovement
         (
          DescId integer NOT NULL,
          MovementId integer NOT NULL,
          MovementChildId integer,
          CONSTRAINT pk_MovementLinkMovement PRIMARY KEY (MovementId, DescId),
          CONSTRAINT fk_MovementLinkMovement_DescId FOREIGN KEY (DescId) REFERENCES MovementLinkMovementDesc (Id),
          CONSTRAINT fk_MovementLinkMovement_Movement FOREIGN KEY (MovementId) REFERENCES Movement (id),
          CONSTRAINT fk_MovementLinkMovement_MovementChild FOREIGN KEY (MovementChildId) REFERENCES Movement (Id)
         )
        WITH (
             OIDS=FALSE
         );
         ALTER TABLE MovementLinkMovement OWNER TO postgres;
      END IF;
    END;
$$;