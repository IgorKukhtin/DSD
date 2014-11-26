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
         SELECT 101, 'data'::TVarChar, 'Сумма реализации'::TVarChar, 'sale_summ'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 102, 'data'::TVarChar, 'С\с реализации'::TVarChar, 'Sale_SummCost'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 103, 'data'::TVarChar, 'Вес реализации'::TVarChar, 'Sale_Amount_Weight'::TVarChar, ',0.###'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 104, 'data'::TVarChar, 'Штуки реализации'::TVarChar, 'Sale_Amount_Sh'::TVarChar, ',0.###'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 105, 'data'::TVarChar, '% рентабельности реализация'::TVarChar, 'SalePercent'::TVarChar, ',0.###'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,'Sale_SummCost,sale_summ'::TVarChar,''::TVarChar,'stPercent'::TVarChar
   UNION SELECT 111, 'data'::TVarChar, 'Сумма возврата'::TVarChar, 'Return_summ'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 112, 'data'::TVarChar, 'С\с возврата'::TVarChar, 'Return_SummCost'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 113, 'data'::TVarChar, 'Вес возврата'::TVarChar, 'Return_Amount_Weight'::TVarChar, ',0.###'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 114, 'data'::TVarChar, 'Штуки возврата'::TVarChar, 'Return_Amount_Sh'::TVarChar, ',0.###'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 121, 'data'::TVarChar, 'Сумма реализация-возврат'::TVarChar, 'SaleReturn_summ'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 122, 'data'::TVarChar, 'С\с реализация-возврат'::TVarChar, 'SaleReturn_SummCost'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 123, 'data'::TVarChar, 'Вес реализация-возврат'::TVarChar, 'SaleReturn_Amount_Weight'::TVarChar, ',0.###'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 124, 'data'::TVarChar, 'Штуки реализация-возврат'::TVarChar, 'SaleReturn_Amount_Sh'::TVarChar, ',0.###'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 125, 'data'::TVarChar, '% рентабельности реализация-возврат'::TVarChar, 'SaleReturnPercent'::TVarChar, ',0.###'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,'SaleReturn_SummCost,saleReturn_summ'::TVarChar,''::TVarChar,'stPercent'::TVarChar

   UNION SELECT 131, 'data'::TVarChar, 'Бонус'::TVarChar, 'Bonus'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 132, 'data'::TVarChar, 'Реализация - бонус'::TVarChar, 'SaleBonus'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 133, 'data'::TVarChar, '% рентабельности реализация - бонус'::TVarChar, 'SaleBonusPercent'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,'Sale_SummCost,SaleBonus'::TVarChar,''::TVarChar,'stPercent'::TVarChar

   UNION SELECT 141, 'data'::TVarChar, 'План кг'::TVarChar, 'Plan_Weight'::TVarChar, ',0.###'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 142, 'data'::TVarChar, 'План сумма'::TVarChar, 'Plan_Summ'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 143, 'data'::TVarChar, '% выполнения плана кг'::TVarChar, 'Plan_WeightPercent'::TVarChar, ',0.###'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,'Plan_Weight,SaleReturn_Amount_Weight'::TVarChar,''::TVarChar,'stPercent'::TVarChar
 
   UNION SELECT 151, 'data'::TVarChar, 'Акции кг'::TVarChar, 'Actions_Weight'::TVarChar, ',0.###'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 152, 'data'::TVarChar, 'Акции сумма'::TVarChar, 'Actions_Summ'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar

   UNION SELECT 6, 'dimension'::TVarChar, 'Форма оплаты'::TVarChar, 'PaidKindName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectPaidKind'::TVarChar, 'PaidKindId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 7, 'dimension'::TVarChar, 'Юр. лицо'::TVarChar, 'JuridicalName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectJuridical'::TVarChar, 'JuridicalId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 8, 'dimension'::TVarChar, 'Регион'::TVarChar, 'AreaName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectArea'::TVarChar, 'AreaId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 9, 'dimension'::TVarChar, 'Признак торговой точки'::TVarChar, 'PartnerTagName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectPartnerTag'::TVarChar, 'PartnerTagId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 10, 'dimension'::TVarChar, 'Область'::TVarChar, 'RegionName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectRegion'::TVarChar, 'RegionId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 11, 'dimension'::TVarChar, 'Район'::TVarChar, 'ProvinceName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectProvince'::TVarChar, 'ProvinceId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 12, 'dimension'::TVarChar, 'Вид населенного пункта'::TVarChar, 'CityKindName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectCityKind'::TVarChar, 'CityKindId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 13, 'dimension'::TVarChar, 'Населенный пункт'::TVarChar, 'CityName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectCity'::TVarChar, 'CityId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 14, 'dimension'::TVarChar, 'Район города'::TVarChar, 'ProvinceCityName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectProvinceCity'::TVarChar, 'ProvinceCityId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 15, 'dimension'::TVarChar, 'Вид улицы'::TVarChar, 'StreetKindName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectStreetKind'::TVarChar, 'StreetKindId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 16, 'dimension'::TVarChar, 'Улица'::TVarChar, 'StreetName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectStreet'::TVarChar, 'StreetId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 17, 'dimension'::TVarChar, 'Партнер'::TVarChar, 'PartnerName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectPartner'::TVarChar, 'PartnerId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 18, 'dimension'::TVarChar, 'Договор'::TVarChar, 'ContractName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectContract'::TVarChar, 'ContractId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 19, 'dimension'::TVarChar, 'Статья'::TVarChar, 'InfoMoneyName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectInfoMoney'::TVarChar, 'InfoMoneyId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 20, 'dimension'::TVarChar, 'Филиал'::TVarChar, 'BranchName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectBranch'::TVarChar, 'BranchId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 21, 'dimension'::TVarChar, 'Товар'::TVarChar, 'GoodsName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectGoods'::TVarChar, 'GoodsId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 22, 'dimension'::TVarChar, 'Вид товара'::TVarChar, 'GoodsKindName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectGoodsKind'::TVarChar, 'GoodsKindId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
     
     )
                 AS SetupData ORDER BY 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_OlapSoldReportOption (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 21.11.14                        * 
*/

-- тест
-- SELECT * FROM gpGet_OlapSoldReportOption (zfCalc_UserAdmin()) 