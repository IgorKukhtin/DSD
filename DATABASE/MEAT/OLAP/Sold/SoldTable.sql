/*
  Создание 
    - таблицы SoldTable (таблица продаж)
    - связей
    - индексов
*/


-- DROP TABLE SoldTable;

/*-------------------------------------------------------------------------------*/
CREATE TABLE SoldTable
(

   JuridicalId Integer
 , PartnerId Integer
 , ContractId Integer 
 , InfoMoneyId Integer
 , PaidKindId Integer
 , BranchId Integer

 , GoodsId Integer
 , GoodsKindId Integer
 , OperDate TDateTime
 , InvNumber TVarChar

 , AreaId                Integer
 , PartnerTagId          Integer
 , RegionId              Integer
 , ProvinceId            Integer
 , CityKindId            Integer
 , CityId                Integer
 , ProvinceCityId        Integer
 , StreetKindId          Integer
 , StreetId              Integer
                           
 , Sale_Summ             TFloat  
 , Sale_SummCost         TFloat
 , Sale_Profit           TFloat
 , Sale_Amount_Weight    TFloat  
 , Sale_Amount_Sh        TFloat  

 , Return_Summ           TFloat  
 , Return_SummCost       TFloat
 , Return_Amount_Weight  TFloat  
 , Return_Amount_Sh      TFloat  

 , SaleReturn_Summ       TFloat
 , SaleReturn_SummCost   TFloat
 , SaleReturn_Profit     TFloat
 , SaleReturn_Amount_Weight TFloat
 , SaleReturn_Amount_Sh  TFloat

 , Bonus                 TFloat
 , SaleBonus             TFloat
 , SaleBonusProfit       TFloat
 , Plan_Weight           TFloat
 , Plan_Summ             TFloat
 
 , Actions_Weight        TFloat
 , Actions_Summ          TFloat

 , Sale_AmountPartner_Weight     TFloat  
 , Sale_AmountPartner_Sh         TFloat  
 , Return_AmountPartner_Weight   TFloat  
 , Return_AmountPartner_Sh       TFloat  
)
WITH (
  OIDS=FALSE
);

ALTER TABLE SoldTable
  OWNER TO postgres;
GRANT ALL ON ALL TABLES IN SCHEMA public TO project;

/*                                  Индексы                                      */

CREATE INDEX idx_SoldTable_OperDate ON SoldTable(OperDate);
CREATE INDEX idx_SoldTable_JuridicalId ON SoldTable(JuridicalId);
CREATE INDEX idx_SoldTable_PartnerId ON SoldTable(PartnerId);
CREATE INDEX idx_SoldTable_ContractId ON SoldTable(ContractId);
CREATE INDEX idx_SoldTable_InfoMoneyId ON SoldTable(InfoMoneyId);
CREATE INDEX idx_SoldTable_BranchId ON SoldTable(BranchId);
CREATE INDEX idx_SoldTable_GoodsId ON SoldTable(GoodsId);
CREATE INDEX idx_SoldTable_GoodsKindId ON SoldTable(GoodsKindId);
CREATE INDEX idx_SoldTable_AreaId ON SoldTable(AreaId);
CREATE INDEX idx_SoldTable_PartnerTagId ON SoldTable(PartnerTagId);
CREATE INDEX idx_SoldTable_RegionId ON SoldTable(RegionId);
CREATE INDEX idx_SoldTable_ProvinceId ON SoldTable(ProvinceId);
CREATE INDEX idx_SoldTable_CityKindId ON SoldTable(CityKindId);
CREATE INDEX idx_SoldTable_CityId ON SoldTable(CityId);
CREATE INDEX idx_SoldTable_ProvinceCityId ON SoldTable(ProvinceCityId);
CREATE INDEX idx_SoldTable_StreetKindId ON SoldTable(StreetKindId);
CREATE INDEX idx_SoldTable_StreetId ON SoldTable(StreetId);

/*-------------------------------------------------------------------------------*/



/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
*/
