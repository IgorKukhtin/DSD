-- Function: zfSelect_Word_Split

DROP FUNCTION IF EXISTS zfSelect_DiscountSaleKind (TDateTime, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION zfSelect_DiscountSaleKind(
    IN inOperDate           TDateTime , -- Дата действия
    IN inUnitId             Integer   , -- подразделение 
    IN inGoodsId            Integer   , -- Товар
    IN inClientId           Integer   , -- ключ 
    IN inUserId             Integer        -- пользователь
)
RETURNS TABLE (ChangePercent Tfloat, DiscountSaleKindId Integer, DiscountSaleKindName TVarChar
              )
AS
$BODY$
BEGIN
   
     -- Результат
     RETURN QUERY
             SELECT tmp1.Tax, tmp1.DiscountSaleKindId, Object.ValueData
      FROM (
            SELECT tmp.Tax, tmp.DiscountSaleKindId
                 , ROW_NUMBER() OVER ( ORDER BY tmp.Tax desc) AS Num
            FROM (
                  SELECT tmp.ValuePrice AS Tax, zc_Enum_DiscountSaleKind_Period() AS DiscountSaleKindId -- сезонная
                  FROM gpGet_ObjectHistory_DiscountPeriodItem(inOperDate,inUnitId:= inUnitId, inGoodsId:= inGoodsId, inSession:='2') as tmp
                UNION
                  SELECT ObjectFloat_DiscountTax.ValueData AS Tax, zc_Enum_DiscountSaleKind_Client() AS DiscountSaleKindId -- клиента 
                  FROM ObjectFloat AS ObjectFloat_DiscountTax 
                  WHERE ObjectFloat_DiscountTax.DescId = zc_ObjectFloat_Client_DiscountTax()
                    AND ObjectFloat_DiscountTax.ObjectId =  inClientId --459     -- Object_To.Id клиент
                UNION
                  SELECT  ObjectFloat_DiscountTax.ValueData AS Tax, zc_Enum_DiscountSaleKind_Outlet() AS DiscountSaleKindId -- клиента 
                  FROM ObjectFloat AS ObjectFloat_DiscountTax 
                  WHERE ObjectFloat_DiscountTax.DescId = zc_ObjectFloat_Unit_DiscountTax()
                    AND ObjectFloat_DiscountTax.ObjectId =  inUnitId --230     --inUnitId
                 ) AS tmp
            ) AS tmp1
            LEFT JOIN Object ON Object.Id = tmp1.DiscountSaleKindId
            WHERE tmp1.Num = 1 ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 12.05.17         *
*/

-- тест
-- SELECT * FROM zfSelect_DiscountSaleKind (inOperDate:='03.05.2017' ::TDateTime, inUnitId:= 230,  inGoodsId:=406 , inClientId:=459 ,inUserId:= zfCalc_UserAdmin() :: Integer);