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

        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('SoldTable') AND Column_Name = lower('AccountId'))) THEN
            ALTER TABLE SoldTable ADD COLUMN AccountId Integer;
        END IF;
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('SoldTable') AND Column_Name = lower('BusinessId'))) THEN
            ALTER TABLE SoldTable ADD COLUMN BusinessId Integer;
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


/*
CREATE INDEX idx_SoldTable_JuridicalGroupId ON SoldTable (JuridicalGroupId); -- ***
CREATE INDEX idx_SoldTable_RetailReportId ON SoldTable (RetailReportId); -- ***
CREATE INDEX idx_SoldTable_UnitId_Personal ON SoldTable (UnitId_Personal); -- ***
CREATE INDEX idx_SoldTable_UnitId_PersonalTrade ON SoldTable (UnitId_PersonalTrade); -- ***
CREATE INDEX idx_SoldTable_GoodsPlatformId ON SoldTable (GoodsPlatformId); -- ***
CREATE INDEX idx_SoldTable_GoodsGroupStatId ON SoldTable (GoodsGroupStatId); -- **
*/
/*
update SoldTable set JuridicalGroupId = ObjectLink_JuridicalGroup.ChildObjectId
                   , RetailReportId = ObjectLink_Juridical_RetailReport.ChildObjectId
from Object
           LEFT JOIN ObjectLink AS ObjectLink_JuridicalGroup
                                ON ObjectLink_JuridicalGroup.ObjectId = Object.Id
                               AND ObjectLink_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
           LEFT JOIN ObjectLink AS ObjectLink_Juridical_RetailReport
                                ON ObjectLink_Juridical_RetailReport.ObjectId = Object.Id
                               AND ObjectLink_Juridical_RetailReport.DescId = zc_ObjectLink_Juridical_RetailReport()
where SoldTable.JuridicalId = Object.Id
  and SoldTable.OperDate < '01.07.2015';


update SoldTable set UnitId_Personal = ObjectLink_Personal_Unit.ChildObjectId
from ObjectLink as ObjectLink_Personal_Unit
where ObjectLink_Personal_Unit.ObjectId = PersonalId
  AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
  -- AND UnitId_Personal <> ObjectLink_Personal_Unit.ChildObjectId
  and SoldTable.OperDate < '01.07.2015';

update SoldTable set UnitId_PersonalTrade = ObjectLink_Personal_Unit.ChildObjectId
from ObjectLink as ObjectLink_Personal_Unit
where ObjectLink_Personal_Unit.ObjectId = PersonalTradeId
  AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
--  AND UnitId_PersonalTrade <> ObjectLink_Personal_Unit.ChildObjectId
  and SoldTable.OperDate < '01.07.2015';


update SoldTable set GoodsPlatformId = ObjectLink_Goods_GoodsPlatform.ChildObjectId
                   , GoodsGroupStatId = ObjectLink_Goods_GoodsGroupStat.ChildObjectId
from Object
           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsPlatform
                                ON ObjectLink_Goods_GoodsPlatform.ObjectId = Object.Id
                               AND ObjectLink_Goods_GoodsPlatform.DescId = zc_ObjectLink_Goods_GoodsPlatform()
           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupStat
                                ON ObjectLink_Goods_GoodsGroupStat.ObjectId = Object.Id
                               AND ObjectLink_Goods_GoodsGroupStat.DescId = zc_ObjectLink_Goods_GoodsGroupStat()
where SoldTable.GoodsId = Object.Id
  and SoldTable.OperDate < '01.07.2015';

update SoldTable set BusinessId = ObjectLink_Goods_Business.ChildObjectId
from Object
           LEFT JOIN ObjectLink AS ObjectLink_Goods_Business
                                ON ObjectLink_Goods_Business.ObjectId = Object.Id
                               AND ObjectLink_Goods_Business.DescId = zc_ObjectLink_Goods_ObjectLink_Goods_Business()
where SoldTable.GoodsId = Object.Id
  and SoldTable.OperDate < '01.07.2015';
*/
