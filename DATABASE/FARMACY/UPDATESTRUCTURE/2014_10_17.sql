DO $$ 
    BEGIN
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('LoadPriceListItem') AND Column_Name = lower('BarCode'))) THEN
            ALTER TABLE LoadPriceListItem ADD COLUMN BarCode TVarChar;
            CREATE INDEX idx_LoadPriceListItem_LoadPriceListId_BarCode ON LoadPriceListItem(LoadPriceListId, BarCode);
        END IF;
    END;
$$;