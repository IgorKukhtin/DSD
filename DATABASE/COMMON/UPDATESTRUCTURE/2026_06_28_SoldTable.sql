DO $$ 
    BEGIN

        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('SoldTable') AND Column_Name = lower('Actions_Weight_NotBudg'))) THEN
            ALTER TABLE SoldTable ADD COLUMN Actions_Weight_NotBudg TFloat;
        END IF;

        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('SoldTable') AND Column_Name = lower('Actions_Sh_NotBudg'))) THEN
            ALTER TABLE SoldTable ADD COLUMN Actions_Sh_NotBudg TFloat;
        END IF;

        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('SoldTable') AND Column_Name = lower('Actions_Summ_NotBudg'))) THEN
            ALTER TABLE SoldTable ADD COLUMN Actions_Summ_NotBudg TFloat;
        END IF;

        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('SoldTable') AND Column_Name = lower('Actions_SummCost_NotBudg'))) THEN
            ALTER TABLE SoldTable ADD COLUMN Actions_SummCost_NotBudg TFloat;
        END IF;

    END;
$$;


