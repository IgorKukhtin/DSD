DO $$ 
    BEGIN
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('LoadPriceList') AND Column_Name = lower('AreaId'))) THEN
            ALTER TABLE LoadPriceList ADD COLUMN AreaId Integer;
        END IF;
    END;

$$;