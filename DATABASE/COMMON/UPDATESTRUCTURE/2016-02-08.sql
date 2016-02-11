DO $$ 
    BEGIN

        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('SoldTable') AND Column_Name = lower('Sale_Summ_10200'))) THEN
            ALTER TABLE SoldTable ADD COLUMN Sale_Summ_10200 TFloat;
        END IF;
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('SoldTable') AND Column_Name = lower('Sale_Summ_10250'))) THEN
            ALTER TABLE SoldTable ADD COLUMN Sale_Summ_10250 TFloat;
        END IF;
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('SoldTable') AND Column_Name = lower('Actions_SummCost'))) THEN
            ALTER TABLE SoldTable ADD COLUMN Actions_SummCost TFloat;
        END IF;
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('SoldTable') AND Column_Name = lower('Actions_Sh'))) THEN
            ALTER TABLE SoldTable ADD COLUMN Actions_Sh TFloat;
        END IF;

        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('SoldTable') AND Column_Name = lower('GoodsPlatformId'))) THEN
            ALTER TABLE SoldTable ADD COLUMN GoodsPlatformId Integer;
        END IF;
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('SoldTable') AND Column_Name = lower('GoodsGroupStatId'))) THEN
            ALTER TABLE SoldTable ADD COLUMN GoodsGroupStatId Integer;
        END IF;
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('SoldTable') AND Column_Name = lower('JuridicalGroupId'))) THEN
            ALTER TABLE SoldTable ADD COLUMN JuridicalGroupId Integer;
        END IF;
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('SoldTable') AND Column_Name = lower('RetailReportId'))) THEN
            ALTER TABLE SoldTable ADD COLUMN RetailReportId Integer;
        END IF;
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('SoldTable') AND Column_Name = lower('UnitId_Personal'))) THEN
            ALTER TABLE SoldTable ADD COLUMN UnitId_Personal Integer;
        END IF;
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('SoldTable') AND Column_Name = lower('UnitId_PersonalTrade'))) THEN
            ALTER TABLE SoldTable ADD COLUMN UnitId_PersonalTrade Integer;
        END IF;

    END;
$$;
