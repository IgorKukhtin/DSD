-- Function: gpSelect_Object_GoodsByGoodsKind1CLink (TVarChar)

DROP FUNCTION IF EXISTS gpGet_OlapSoldReportOption (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_OlapSoldReportOption(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (SortField integer, FieldType TVarChar, Caption TVarChar, FieldName TVarChar,  DisplayFormat TVarChar
             , TableName TVarChar, TableSyn TVarChar, ConnectFieldName TVarChar
             , VisibleFieldName TVarChar, ShowDateType TVarChar)
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsByGoodsKind1CLink());
   
     -- Результат
     RETURN QUERY 
     SELECT * FROM 
     (
         SELECT 1, 'data'::TVarChar, 'Сумма реализации'::TVarChar, 'sale_summ'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 2, 'data'::TVarChar, 'Вес реализации'::TVarChar, 'Sale_Amount_Weight'::TVarChar, ',0.###'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 3, 'data'::TVarChar, 'Штуки реализации'::TVarChar, 'Sale_Amount_Sh'::TVarChar, ',0.###'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 4, 'data'::TVarChar, 'Сумма возврата'::TVarChar, 'Return_summ'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 5, 'data'::TVarChar, 'Вес возврата'::TVarChar, 'Return_Amount_Weight'::TVarChar, ',0.###'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 6, 'data'::TVarChar, 'Штуки возврата'::TVarChar, 'Return_Amount_Sh'::TVarChar, ',0.###'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
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