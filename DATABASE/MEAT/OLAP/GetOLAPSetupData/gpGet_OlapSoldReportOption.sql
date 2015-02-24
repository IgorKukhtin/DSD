-- Function: gpSelect_Object_GoodsByGoodsKind1CLink (TVarChar)

DROP FUNCTION IF EXISTS gpGet_OlapSoldReportOption (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_OlapSoldReportOption(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (SortField integer, FieldType TVarChar, Caption TVarChar, FieldName TVarChar,  DisplayFormat TVarChar
             , TableName TVarChar, TableSyn TVarChar, ConnectFieldName TVarChar
             , VisibleFieldName TVarChar, SummaryType TVarChar)
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsByGoodsKind1CLink());
   
     -- Результат
     RETURN QUERY 
     SELECT * FROM 
     (
         SELECT 101, 'data'::TVarChar, 'Кол.вес продажа' :: TVarChar, 'Sale_AmountPartner_Weight'::TVarChar, ',0.###'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   -- UNION SELECT 102, 'data'::TVarChar, 'Кол.шт. продано' :: TVarChar, 'Sale_Amount_Sh'::TVarChar, ',0.###'::TVarChar, 
   --              ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 103, 'data'::TVarChar, 'Сумма продажа' :: TVarChar, 'Sale_Summ'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 104, 'data'::TVarChar, 'С\с продажа' :: TVarChar, 'Sale_SummCost'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar

   UNION SELECT 111, 'data'::TVarChar, 'Кол.вес возврат' :: TVarChar, 'Return_AmountPartner_Weight'::TVarChar, ',0.###'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   -- UNION SELECT 112, 'data'::TVarChar, 'Кол.шт. возврат' :: TVarChar, 'Return_Amount_Sh'::TVarChar, ',0.###'::TVarChar, 
   --               ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 113, 'data'::TVarChar, 'Сумма возврат'::TVarChar, 'Return_Summ' :: TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 114, 'data'::TVarChar, 'С\с возврат'::TVarChar, 'Return_SummCost' :: TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar

   UNION SELECT 121, 'data'::TVarChar, 'Кол.вес продажа-возврат' :: TVarChar, 'SaleReturn_Amount_Weight'::TVarChar, ',0.###'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   -- UNION SELECT 122, 'data'::TVarChar, 'Кол.шт. продажа-возврат' :: TVarChar, 'SaleReturn_Amount_Sh'::TVarChar, ',0.###'::TVarChar, 
   --               ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 123, 'data'::TVarChar, 'Сумма продажа-возврат' :: TVarChar, 'SaleReturn_summ'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 124, 'data'::TVarChar, 'С\с продажа-возврат' :: TVarChar, 'SaleReturn_SummCost'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar

   UNION SELECT 131, 'data'::TVarChar, 'Сумма скидки' :: TVarChar, 'SaleReturn_Summ_10300'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 132, 'data'::TVarChar, 'Сумма скидки (на весе)' :: TVarChar, 'Sale_SummCost_10500'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar

   UNION SELECT 133, 'data'::TVarChar, 'Сумма бонус (прямой)' :: TVarChar, 'BonusBasis'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 134, 'data'::TVarChar, 'Сумма бонус (другой)' :: TVarChar, 'Bonus'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   -- UNION SELECT 132, 'data'::TVarChar, 'Сумма продажа-бонус' :: TVarChar, 'SaleBonus'::TVarChar, ',0.00'::TVarChar, 
   --               ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar

   UNION SELECT 141, 'data'::TVarChar, 'Прибыль продажа' :: TVarChar, 'Sale_Profit'::TVarChar, ',0.0'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 142, 'data'::TVarChar, 'Прибыль продажа-бонус' :: TVarChar, 'SaleBonus_Profit'::TVarChar, ',0.0'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 143, 'data'::TVarChar, 'Прибыль продажа-возврат' :: TVarChar, 'SaleReturn_Profit'::TVarChar, ',0.0'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 144, 'data'::TVarChar, 'Прибыль продажа-возврат-бонус' :: TVarChar, 'SaleReturnBonus_Profit'::TVarChar, ',0.0'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar

   UNION SELECT 151, 'data'::TVarChar, '% рент. продажа' :: TVarChar, 'Sale_Percent'::TVarChar, ',0.0'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,
                'Sale_SummCost,Sale_Profit'::TVarChar,
                'CASE WHEN SUM(Sale_SummCost) = 0 THEN 0 ELSE SUM(Sale_Profit) / SUM(Sale_SummCost) * 100 END'::TVarChar,
                'stPercent'::TVarChar
   UNION SELECT 152, 'data'::TVarChar, '% рент. продажа-бонус'::TVarChar, 'SaleBonus_Percent'::TVarChar, ',0.0'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,
                 'Sale_SummCost,SaleBonus_Profit'::TVarChar,
                 'CASE WHEN SUM(Sale_SummCost) = 0 THEN 0 ELSE SUM(SaleBonus_Profit) / SUM(Sale_SummCost) * 100 END'::TVarChar,
                 'stPercent'::TVarChar
   UNION SELECT 153, 'data'::TVarChar, '% рент. продажа-возврат' :: TVarChar, 'SaleReturn_Percent'::TVarChar, ',0.0'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,
                 'Sale_SummCost,SaleReturn_Profit'::TVarChar,
                 'CASE WHEN SUM(Sale_SummCost) = 0 THEN 0 ELSE SUM(SaleReturn_Profit) / SUM(Sale_SummCost) * 100 END'::TVarChar,
                 'stPercent'::TVarChar
   UNION SELECT 154, 'data'::TVarChar, '% рент. продажа-возврат-бонус'::TVarChar, 'SaleReturnBonus_Percent'::TVarChar, ',0.0'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,
                 'Sale_SummCost,SaleReturnBonus_Profit'::TVarChar,
                 'CASE WHEN SUM(Sale_SummCost) = 0 THEN 0 ELSE SUM(SaleReturnBonus_Profit) / SUM(Sale_SummCost) * 100 END'::TVarChar,
                 'stPercent'::TVarChar

   UNION SELECT 161, 'data'::TVarChar, 'План кол.вес'::TVarChar, 'Plan_Weight'::TVarChar, ',0.###'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 162, 'data'::TVarChar, 'План сумма'::TVarChar, 'Plan_Summ'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 163, 'data'::TVarChar, '% выполнения план кол.вес'::TVarChar, 'Plan_Percent'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,
                 'Plan_Weight,Sale_AmountPartner_Weight'::TVarChar,
                 'CASE WHEN SUM(Plan_Weight) = 0 THEN 0 ELSE SUM(Sale_AmountPartner_Weight) / SUM(Plan_Weight) * 100 - 100 END'::TVarChar,
                 'stPercent'::TVarChar

   UNION SELECT 161, 'data'::TVarChar, 'Акции кг'::TVarChar, 'Actions_Weight'::TVarChar, ',0.###'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 162, 'data'::TVarChar, 'Акции сумма'::TVarChar, 'Actions_Summ'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar

   UNION SELECT 171, 'data'::TVarChar, 'Оплата сумма'::TVarChar, 'Money_Summ' :: TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 172, 'data'::TVarChar, 'Вз-зачет сумма'::TVarChar, 'SendDebt_Summ' :: TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 173, 'data'::TVarChar, 'Оплата и Вз-зачет'::TVarChar, 'Money_SendDebt_Summ' :: TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar

   UNION SELECT 11, 'dimension'::TVarChar, 'Форма оплаты'::TVarChar, 'PaidKindName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectPaidKind'::TVarChar, 'PaidKindId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 12, 'dimension'::TVarChar, 'Филиал'::TVarChar, 'BranchName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectBranch'::TVarChar, 'BranchId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 13, 'dimension'::TVarChar, 'Регион'::TVarChar, 'AreaName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectArea'::TVarChar, 'AreaId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 14, 'dimension'::TVarChar, 'Торговая сеть'::TVarChar, 'RetailName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectRetail'::TVarChar, 'RetailId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 15, 'dimension'::TVarChar, 'Юридическое лицо'::TVarChar, 'JuridicalName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectJuridical'::TVarChar, 'JuridicalId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 16, 'dimension'::TVarChar, 'Контрагент'::TVarChar, 'PartnerName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectPartner'::TVarChar, 'PartnerId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 17, 'dimension'::TVarChar, 'Признак торговой точки'::TVarChar, 'PartnerTagName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectPartnerTag'::TVarChar, 'PartnerTagId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 18, 'dimension'::TVarChar, 'Группа признак договора'::TVarChar, 'ContractTagGroupName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectContractTagGroup'::TVarChar, 'ContractTagGroupId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 19, 'dimension'::TVarChar, 'Признак договора'::TVarChar, 'ContractTagName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectContractTag'::TVarChar, 'ContractTagId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 20, 'dimension'::TVarChar, 'УП статья'::TVarChar, 'InfoMoneyName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectInfoMoney'::TVarChar, 'InfoMoneyId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar

   UNION SELECT 31, 'dimension'::TVarChar, 'ФИО (супервайзер)'::TVarChar, 'PersonalName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectPersonal'::TVarChar, 'PersonalId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 32, 'dimension'::TVarChar, 'ФИО (ТП)'::TVarChar, 'PersonalTradeName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectPersonalTrade'::TVarChar, 'PersonalTradeId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 33, 'dimension'::TVarChar, 'Филиал (супервайзер)'::TVarChar, 'BranchPersonalName'::TVarChar, ''::TVarChar,
                 'Object'::TVarChar, 'ObjectBranchPersonal'::TVarChar, 'BranchId_Personal'::TVarChar, 'ValueData'::TVarChar,''::TVarChar

   UNION SELECT 40, 'dimension'::TVarChar, 'Адрес'::TVarChar, 'Address'::TVarChar, ''::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 41, 'dimension'::TVarChar, 'Область'::TVarChar, 'RegionName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectRegion'::TVarChar, 'RegionId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 42, 'dimension'::TVarChar, 'Район'::TVarChar, 'ProvinceName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectProvince'::TVarChar, 'ProvinceId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 43, 'dimension'::TVarChar, 'Вид н.п.'::TVarChar, 'CityKindName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectCityKind'::TVarChar, 'CityKindId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 44, 'dimension'::TVarChar, 'Населенный пункт'::TVarChar, 'CityName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectCity'::TVarChar, 'CityId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 45, 'dimension'::TVarChar, 'Микрорайон'::TVarChar, 'ProvinceCityName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectProvinceCity'::TVarChar, 'ProvinceCityId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 46, 'dimension'::TVarChar, 'Вид ул.'::TVarChar, 'StreetKindName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectStreetKind'::TVarChar, 'StreetKindId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 47, 'dimension'::TVarChar, 'Улица'::TVarChar, 'StreetName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectStreet'::TVarChar, 'StreetId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar

   UNION SELECT 51, 'dimension'::TVarChar, 'Торговая марка' :: TVarChar, 'TradeMarkName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectTradeMark'::TVarChar, 'TradeMarkId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 52, 'dimension'::TVarChar, 'Группа аналитики' :: TVarChar, 'GoodsGroupAnalystName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectGoodsGroupAnalyst'::TVarChar, 'GoodsGroupAnalystId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 53, 'dimension'::TVarChar, 'Признак товара' :: TVarChar, 'GoodsTagName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectGoodsTag'::TVarChar, 'GoodsTagId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 54, 'dimension'::TVarChar, 'Товар'::TVarChar, 'GoodsName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectGoods'::TVarChar, 'GoodsId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 55, 'dimension'::TVarChar, 'Вид товара'::TVarChar, 'GoodsKindName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectGoodsKind'::TVarChar, 'GoodsKindId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 56, 'dimension'::TVarChar, 'Ед. изм.' :: TVarChar, 'MeasureName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectMeasure'::TVarChar, 'MeasureId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
     )
                 AS SetupData ORDER BY 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_OlapSoldReportOption (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 12.01.15                                        * all
 21.11.14                        * 
*/

-- тест
-- SELECT * FROM gpGet_OlapSoldReportOption (zfCalc_UserAdmin())
