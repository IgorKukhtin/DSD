DO $$ 
    BEGIN
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('LoadPriceListItem') AND Column_Name = lower('PriceOriginal'))) THEN
            ALTER TABLE LoadPriceListItem ADD COLUMN PriceOriginal TFloat;
        END IF;
    END;
$$;