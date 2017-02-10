DO $$ 
    BEGIN

        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('SoldTable') AND Column_Name = lower('Return_Summ_10700'))) THEN
            ALTER TABLE SoldTable ADD COLUMN Return_Summ_10700 TFloat;
            UPDATE SoldTable SET Return_Summ_10700 = 0;
        END IF;

    END;
$$;


