DO $$ 
    BEGIN
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('LoadPriceList') AND Column_Name = lower('isMoved'))) THEN
            ALTER TABLE LoadPriceList ADD COLUMN isMoved Boolean;
            UPDATE LoadPriceList SET isMoved = false;
        END IF;
    END;
$$;