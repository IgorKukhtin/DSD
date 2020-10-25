/*
  Создание 
    - таблицы SoldTable (таблица продаж)
    - связей
    - индексов
*/

-- DROP TABLE SoldTable;
-- ALTER TABLE SoldTable DROP COLUMN InvNumber;

/*-------------------------------------------------------------------------------*/
CREATE TABLE SoldTable
(
   Id                  BIGSERIAL NOT NULL PRIMARY KEY 
 , OperDate           TDateTime
--  , InvNumber          TVarChar
 , AccountId          Integer -- ***

 , BranchId           Integer
 , JuridicalGroupId   Integer -- ***
 , JuridicalId        Integer
 , PartnerId          Integer
 , InfoMoneyId        Integer
 , PaidKindId         Integer
 , RetailId           Integer
 , RetailReportId     Integer -- ***
 , AreaId             Integer
 , PartnerTagId       Integer
 , ContractId         Integer 
 , ContractTagId      Integer 
 , ContractTagGroupId Integer 

 , PersonalId             Integer
 , UnitId_Personal        Integer -- ***
 , BranchId_Personal      Integer
 , PersonalTradeId        Integer
 , UnitId_PersonalTrade   Integer -- ***

 , BusinessId          Integer -- ***
 , GoodsPlatformId     Integer -- ***
 , TradeMarkId         Integer
 , GoodsGroupAnalystId Integer
 , GoodsTagId          Integer
 , GoodsGroupId        Integer
 , GoodsGroupStatId    Integer -- ***
 , GoodsId             Integer
 , GoodsKindId         Integer
 , MeasureId           Integer
 
 , RegionId              Integer
 , ProvinceId            Integer
 , CityKindId            Integer
 , CityId                Integer
 , ProvinceCityId        Integer
 , StreetKindId          Integer
 , StreetId              Integer
                           
 , Sale_Summ                 TFloat
 , Sale_Summ_10200           TFloat -- ***
 , Sale_Summ_10250           TFloat -- ***
 , Sale_Summ_10300           TFloat
 , Sale_SummCost             TFloat
 , Sale_SummCost_10500       TFloat
 , Sale_SummCost_40200       TFloat
 , Sale_Amount_Weight        TFloat
 , Sale_Amount_Sh            TFloat
 , Sale_AmountPartner_Weight TFloat  
 , Sale_AmountPartner_Sh     TFloat  
 , Sale_Amount_10500_Weight  TFloat
 , Sale_Amount_40200_Weight  TFloat

 , Actions_Weight            TFloat
 , Actions_Sh                TFloat -- ***
 , Actions_SummCost          TFloat -- ***
 , Actions_Summ              TFloat

 , Return_Summ                 TFloat
 , Return_Summ_10300           TFloat
 , Return_Summ_10700           TFloat
 , Return_SummCost             TFloat
 , Return_SummCost_40200       TFloat
 , Return_Amount_Weight        TFloat
 , Return_Amount_Sh            TFloat
 , Return_AmountPartner_Weight TFloat  
 , Return_AmountPartner_Sh     TFloat  
 , Return_Amount_40200_Weight  TFloat

 , SaleReturn_Summ           TFloat
 , SaleReturn_Summ_10300     TFloat
 , SaleReturn_SummCost       TFloat
 , SaleReturn_SummCost_40200 TFloat
 , SaleReturn_Amount_Weight  TFloat
 , SaleReturn_Amount_Sh      TFloat

 , BonusBasis            TFloat
 , Bonus                 TFloat
 , Plan_Weight           TFloat
 , Plan_Summ             TFloat
 
 , Money_Summ             TFloat
 , SendDebt_Summ          TFloat
 , Money_SendDebt_Summ    TFloat

 , Sale_Profit            TFloat
 , SaleBonus_Profit       TFloat
 , SaleReturn_Profit      TFloat
 , SaleReturnBonus_Profit TFloat

-- , Address TVarChar
)
WITH (
  OIDS=FALSE
);

ALTER TABLE SoldTable
  OWNER TO postgres;
GRANT ALL ON ALL TABLES IN SCHEMA public TO project;

/*                                  Индексы                                      */

CREATE INDEX idx_SoldTable_OperDate ON SoldTable (OperDate);
-- CREATE INDEX idx_SoldTable_AccountId ON SoldTable (AccountId); -- ***
CREATE INDEX idx_SoldTable_BranchId ON SoldTable (BranchId);
CREATE INDEX idx_SoldTable_JuridicalGroupId ON SoldTable (JuridicalGroupId); -- ***
CREATE INDEX idx_SoldTable_JuridicalId ON SoldTable (JuridicalId);
CREATE INDEX idx_SoldTable_PartnerId ON SoldTable (PartnerId);
CREATE INDEX idx_SoldTable_InfoMoneyId ON SoldTable (InfoMoneyId);
CREATE INDEX idx_SoldTable_PaidKindId ON SoldTable (PaidKindId);
CREATE INDEX idx_SoldTable_RetailId ON SoldTable (RetailId);
CREATE INDEX idx_SoldTable_RetailReportId ON SoldTable (RetailReportId); -- ***
CREATE INDEX idx_SoldTable_AreaId ON SoldTable (AreaId);
CREATE INDEX idx_SoldTable_PartnerTagId ON SoldTable (PartnerTagId);
CREATE INDEX idx_SoldTable_ContractId ON SoldTable (ContractId);
CREATE INDEX idx_SoldTable_ContractTagId ON SoldTable (ContractTagId);
CREATE INDEX idx_SoldTable_ContractTagGroupId ON SoldTable (ContractTagGroupId);

CREATE INDEX idx_SoldTable_PersonalId ON SoldTable (PersonalId);
CREATE INDEX idx_SoldTable_UnitId_Personal ON SoldTable (UnitId_Personal); -- ***
CREATE INDEX idx_SoldTable_BranchId_Personal ON SoldTable (BranchId_Personal);
CREATE INDEX idx_SoldTable_PersonalTradeId ON SoldTable (PersonalTradeId);
CREATE INDEX idx_SoldTable_UnitId_PersonalTrade ON SoldTable (UnitId_PersonalTrade); -- ***

CREATE INDEX idx_SoldTable_GoodsPlatformId ON SoldTable (GoodsPlatformId); -- ***
CREATE INDEX idx_SoldTable_TradeMarkId ON SoldTable (TradeMarkId);
CREATE INDEX idx_SoldTable_GoodsGroupAnalystId ON SoldTable (GoodsGroupAnalystId);
CREATE INDEX idx_SoldTable_GoodsTagId ON SoldTable (GoodsTagId);
CREATE INDEX idx_SoldTable_GoodsGroupId ON SoldTable (GoodsGroupId);
CREATE INDEX idx_SoldTable_GoodsGroupStatId ON SoldTable (GoodsGroupStatId); -- **
CREATE INDEX idx_SoldTable_GoodsId ON SoldTable (GoodsId);
CREATE INDEX idx_SoldTable_GoodsKindId ON SoldTable (GoodsKindId);
CREATE INDEX idx_SoldTable_MeasureId ON SoldTable (MeasureId);

CREATE INDEX idx_SoldTable_RegionId ON SoldTable (RegionId);
CREATE INDEX idx_SoldTable_ProvinceId ON SoldTable (ProvinceId);
CREATE INDEX idx_SoldTable_CityKindId ON SoldTable (CityKindId);
CREATE INDEX idx_SoldTable_CityId ON SoldTable (CityId);
CREATE INDEX idx_SoldTable_ProvinceCityId ON SoldTable (ProvinceCityId);
CREATE INDEX idx_SoldTable_StreetKindId ON SoldTable (StreetKindId);
CREATE INDEX idx_SoldTable_StreetId ON SoldTable (StreetId);


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 12.01.15                                        * all
*/
