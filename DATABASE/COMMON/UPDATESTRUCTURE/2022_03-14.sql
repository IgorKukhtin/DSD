DO $$ 
    BEGIN

        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('SoldTable') AND Column_Name = lower('Sale_SummIn_pav'))) THEN
            ALTER TABLE SoldTable ADD COLUMN Sale_SummIn_pav TFloat;
        END IF;

        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('SoldTable') AND Column_Name = lower('ReturnIn_SummIn_pav'))) THEN
            ALTER TABLE SoldTable ADD COLUMN ReturnIn_SummIn_pav TFloat;
        END IF;

    END;
$$;


