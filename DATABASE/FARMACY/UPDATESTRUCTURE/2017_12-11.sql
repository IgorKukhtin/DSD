DO $$ 
    BEGIN
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('LoadPriceListItem') AND Column_Name = lower('CodeUKTZED'))) THEN
            ALTER TABLE LoadPriceListItem ADD COLUMN CodeUKTZED TVarChar;
            -- ALTER TABLE LoadPriceList DROP COLUMN CodeUKTZED ;
        END IF;
    END;

$$;