DO $$ 
    BEGIN
        -- !!!PeriodClose!!!
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('PeriodClose') AND Column_Name = lower('Name'))) THEN
            ALTER TABLE PeriodClose ADD COLUMN UserByGroupId_excl Integer;
        END IF;
    END;
$$;
