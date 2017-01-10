DO $$ 
    BEGIN
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('MovementItemContainer') AND Column_Name = lower('Price'))) THEN
            ALTER TABLE MovementItemContainer ADD COLUMN Price TFloat;
        END IF;
        
    END;
$$;