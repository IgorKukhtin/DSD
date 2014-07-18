DO $$ 
    BEGIN
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('LoadPriceListItem') AND Column_Name = lower('GoodsNDS'))) THEN
            ALTER TABLE LoadPriceListItem ADD COLUMN GoodsNDS TVarChar;
        END IF;
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('LoadPriceListItem') AND Column_Name = lower('ProducerName'))) THEN
            ALTER TABLE LoadPriceListItem ADD COLUMN ProducerName TVarChar;
        END IF;
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('LoadPriceListItem') AND Column_Name = lower('PackCount'))) THEN
            ALTER TABLE LoadPriceListItem ADD COLUMN PackCount Integer;
        END IF;
    END;
$$;