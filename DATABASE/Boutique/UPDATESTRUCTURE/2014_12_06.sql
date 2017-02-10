DO $$ 
    BEGIN
        -- !!!MovementItemContainer!!!
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('MovementItemContainer') AND Column_Name = lower('AnalyzerId'))) THEN
            ALTER TABLE MovementItemContainer ADD COLUMN AnalyzerId Integer;
        END IF;
    END;
$$;