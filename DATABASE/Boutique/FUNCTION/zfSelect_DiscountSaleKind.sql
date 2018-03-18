-- Function: zfSelect_DiscountSaleKind

DROP FUNCTION IF EXISTS zfSelect_DiscountSaleKind (TDateTime, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION zfSelect_DiscountSaleKind(
    IN inOperDate           TDateTime , -- Дата действия
    IN inUnitId             Integer   , -- подразделение
    IN inGoodsId            Integer   , -- Товар
    IN inClientId           Integer   , -- Покупатель
    IN inUserId             Integer     -- Пользователь
)
RETURNS TABLE (ChangePercent TFloat, DiscountSaleKindId Integer, DiscountSaleKindName TVarChar
              )
AS
$BODY$
BEGIN

     -- Результат
     RETURN QUERY
       WITH -- Скидка - outlet
            tmpOutlet AS (SELECT ObjectFloat_DiscountTax.ValueData AS Tax, zc_Enum_DiscountSaleKind_Outlet() AS DiscountSaleKindId
                          FROM ObjectFloat AS ObjectFloat_DiscountTax
                          WHERE ObjectFloat_DiscountTax.DescId    = zc_ObjectFloat_Unit_DiscountTax()
                            AND ObjectFloat_DiscountTax.ObjectId  =  inUnitId
                            AND ObjectFloat_DiscountTax.ValueData <> 0
                         )
       -- Результат
       SELECT -- у некоторых Tax < 0 и это признак outlet
              CASE WHEN tmp.Tax > 0 THEN tmp.Tax ELSE 0 END :: TFloat AS ChangePercent
              -- если это outlet - всегда вернется этот признак
            , Object.Id        AS DiscountSaleKindId
              -- название
            , Object.ValueData AS DiscountSaleKindName

       FROM (SELECT tmp.Tax
                  , tmp.DiscountSaleKindId
                    --  № п/п
                  , ROW_NUMBER() OVER (ORDER BY tmp.Tax DESC, tmp.Num ASC) AS Ord

             FROM (-- Скидка - сезонная
                   SELECT 1 AS Num, COALESCE (tmp.ValuePrice, 0) AS Tax, zc_Enum_DiscountSaleKind_Period() AS DiscountSaleKindId
                   FROM gpGet_ObjectHistory_DiscountPeriodItem (inOperDate:= inOperDate, inUnitId:= inUnitId, inGoodsId:= inGoodsId, inSession:= inUserId :: TVarChar) AS tmp
                   WHERE tmp.ValuePrice > 0
                 UNION ALL
                   -- Скидка - клиента
                   SELECT 2 AS Num, COALESCE (ObjectFloat_DiscountTax.ValueData, 0) AS Tax, zc_Enum_DiscountSaleKind_Client() AS DiscountSaleKindId -- клиента
                   FROM ObjectFloat AS ObjectFloat_DiscountTax
                   WHERE ObjectFloat_DiscountTax.DescId    = zc_ObjectFloat_Client_DiscountTax()
                     AND ObjectFloat_DiscountTax.ObjectId  = inClientId
                     AND ObjectFloat_DiscountTax.ValueData > 0
                 UNION ALL
                   -- Скидка - outlet
                   SELECT 0 AS Num, tmpOutlet.Tax, tmpOutlet.DiscountSaleKindId FROM tmpOutlet
                  ) AS tmp

            ) AS tmp
            LEFT JOIN tmpOutlet ON 1 = 1
            LEFT JOIN Object ON Object.Id = COALESCE (tmpOutlet.DiscountSaleKindId, tmp.DiscountSaleKindId)

       WHERE tmp.Ord = 1 -- !!!выбрали максимальную!!!
      ;

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
