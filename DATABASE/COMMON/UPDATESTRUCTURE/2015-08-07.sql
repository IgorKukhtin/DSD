DO $$ 
    BEGIN

        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('HistoryCost') AND Column_Name = lower('MovementItemId_diff'))) THEN
            ALTER TABLE HistoryCost ADD COLUMN MovementItemId_diff Integer;
            ALTER TABLE HistoryCost ADD COLUMN Summ_diff TFloat;
        END IF;

    END;
$$;
