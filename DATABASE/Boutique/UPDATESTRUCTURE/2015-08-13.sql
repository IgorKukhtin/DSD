DO $$ 
    BEGIN

        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('MovementItemContainer') AND Column_Name = lower('ContainerIntId_analyzer'))) THEN
            ALTER TABLE MovementItemContainer ADD COLUMN ContainerIntId_analyzer Integer;
        END IF;

    END;
$$;
