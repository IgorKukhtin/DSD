-- Добавить у проводок тип документа
DO $$ 
    BEGIN
      IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('MovementItemContainer') AND Column_Name = lower('MovementDescId'))) THEN
         ALTER TABLE MovementItemContainer ADD COLUMN MovementDescId integer REFERENCES MovementDesc;
      END IF;
      IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('MovementItemReport') AND Column_Name = lower('MovementDescId'))) THEN
         ALTER TABLE MovementItemReport ADD COLUMN MovementDescId integer REFERENCES MovementDesc;
      END IF;
    END;
$$;