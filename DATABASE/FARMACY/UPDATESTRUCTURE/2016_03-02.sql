DO $$ 
    BEGIN
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('LoadPriceList') AND Column_Name = lower('Date_Insert'))) THEN
            ALTER TABLE LoadPriceList ADD COLUMN Date_Insert TDateTime;
            ALTER TABLE LoadPriceList ADD COLUMN UserId_Insert Integer;
        END IF;

        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('LoadPriceList') AND Column_Name = lower('Date_Update'))) THEN
            ALTER TABLE LoadPriceList ADD COLUMN Date_Update TDateTime;
            ALTER TABLE LoadPriceList ADD COLUMN UserId_Update Integer;
        END IF;
    END;

$$;