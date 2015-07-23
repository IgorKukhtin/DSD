DO $$ 
    BEGIN

        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('HistoryCost') AND Column_Name = lower('Price_external'))) THEN
            ALTER TABLE HistoryCost ADD COLUMN Price_external TFloat;
            ALTER TABLE HistoryCost ADD COLUMN CalcCount_external TFloat;
            ALTER TABLE HistoryCost ADD COLUMN CalcSumm_external TFloat;

            UPDATE HistoryCost SET Price_external = Price, CalcCount_external= CalcCount, CalcSumm_external = CalcSumm;

            ALTER TABLE HistoryCost ALTER COLUMN Price_external     SET NOT NULL;
            ALTER TABLE HistoryCost ALTER COLUMN CalcCount_external SET NOT NULL;
            ALTER TABLE HistoryCost ALTER COLUMN CalcSumm_external  SET NOT NULL;
        END IF;

    END;
$$;
