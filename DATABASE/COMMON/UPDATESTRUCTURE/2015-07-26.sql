DO $$ 
    BEGIN

        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('MovementItemContainer') AND Column_Name = lower('ObjectIntId_analyzer'))) THEN
            ALTER TABLE MovementItemContainer ADD COLUMN ObjectIntId_analyzer Integer;
            ALTER TABLE MovementItemContainer ADD COLUMN ObjectExtId_analyzer Integer;
        END IF;

    END;
$$;
