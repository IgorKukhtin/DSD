-- Function: gpSelect_Object_Fuel()

DROP FUNCTION IF EXISTS gpSelect_Object_Fuel (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Fuel(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , Ratio TFloat
             , RateFuelKindId Integer, RateFuelKindCode Integer, RateFuelKindName TVarChar
             , ValuePrice TVarChar
             , isErased boolean
              )
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Fuel());

     RETURN QUERY 
       WITH tmpPrice AS (WITH tmpPriceList AS (SELECT zc_PriceList_Fuel() AS PriceListId
                                              UNION
                                               SELECT DISTINCT ObjectLink_Contract_PriceList.ChildObjectId
                                               FROM ObjectLink AS ObjectLink_Contract_InfoMoney
                                                    INNER JOIN ObjectLink AS ObjectLink_Contract_PriceList
                                                                          ON ObjectLink_Contract_PriceList.ObjectId      = ObjectLink_Contract_InfoMoney.ObjectId
                                                                         AND ObjectLink_Contract_PriceList.DescId        = zc_ObjectLink_Contract_PriceList()
                                                                         AND ObjectLink_Contract_PriceList.ChildObjectId > 0
                                               WHERE ObjectLink_Contract_InfoMoney.DescId        = zc_ObjectLink_Contract_InfoMoney()
                                                 AND ObjectLink_Contract_InfoMoney.ChildObjectId = zc_Enum_InfoMoney_20401() -- ГСМ
                                              UNION
                                               SELECT DISTINCT ObjectLink_Juridical_PriceList.ChildObjectId
                                               FROM ObjectLink AS ObjectLink_CardFuel_Juridical
                                                    INNER JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                                                                          ON ObjectLink_Juridical_PriceList.ObjectId      = ObjectLink_CardFuel_Juridical.ObjectId
                                                                         AND ObjectLink_Juridical_PriceList.DescId        = zc_ObjectLink_Juridical_PriceList()
                                                                         AND ObjectLink_Juridical_PriceList.ChildObjectId > 0
                                               WHERE ObjectLink_CardFuel_Juridical.ObjectId > 0
                                                 AND ObjectLink_CardFuel_Juridical.DescId   = zc_ObjectLink_CardFuel_Juridical()
                                              )
                                 , tmpData AS (SELECT ObjectLink_PriceList.ChildObjectId                     AS PriceListId
                                                    , ObjectLink_Goods_Fuel.ChildObjectId                    AS FuelId
                                                    , MAX (COALESCE (ObjectHistoryFloat_Value.ValueData, 0)) AS ValuePrice
                                               FROM ObjectLink AS ObjectLink_Goods_Fuel
                                                    INNER JOIN ObjectLink AS ObjectLink_Goods
                                                                          ON ObjectLink_Goods.ChildObjectId = ObjectLink_Goods_Fuel.ObjectId
                                                                         AND ObjectLink_Goods.DescId        = zc_ObjectLink_PriceListItem_Goods()
                                                    INNER JOIN ObjectLink AS ObjectLink_PriceList
                                                                          ON ObjectLink_PriceList.ObjectId      = ObjectLink_Goods.ObjectId
                                                                         -- AND ObjectLink_PriceList.ChildObjectId = zc_PriceList_Fuel()
                                                                         AND ObjectLink_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()
                                                    INNER JOIN tmpPriceList ON tmpPriceList.PriceListId = ObjectLink_PriceList.ChildObjectId
                                                    INNER JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                                             ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_Goods.ObjectId
                                                                            AND ObjectHistory_PriceListItem.DescId   = zc_ObjectHistory_PriceListItem()
                                                                            AND ObjectHistory_PriceListItem.EndDate  = zc_DateEnd()
                                                    LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                                                                 ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                                                AND ObjectHistoryFloat_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                                               WHERE ObjectLink_Goods_Fuel.DescId        = zc_ObjectLink_Goods_Fuel()
                                                 AND ObjectLink_Goods_Fuel.ChildObjectId > 0
                                               GROUP BY ObjectLink_PriceList.ChildObjectId, ObjectLink_Goods_Fuel.ChildObjectId
                                              )
                                 , tmpFuel AS (SELECT Object_Fuel.Id AS FuelId FROM Object AS Object_Fuel WHERE Object_Fuel.DescId = zc_Object_Fuel())
                         -- Результат
                         SELECT tmp.FuelId, STRING_AGG (zfConvert_FloatToString (tmp.ValuePrice), ' ; ') AS ValuePrice
                         FROM (SELECT tmpPriceList.PriceListId, tmpPriceList.FuelId, COALESCE (tmpData.ValuePrice, 0) AS ValuePrice
                               FROM (SELECT tmpFuel.FuelId, tmpPriceList.PriceListId
                                     FROM tmpPriceList
                                          CROSS JOIN tmpFuel
                                    ) AS tmpPriceList
                                    LEFT JOIN tmpData ON tmpData.PriceListId = tmpPriceList.PriceListId
                                                     AND tmpData.FuelId      = tmpPriceList.FuelId
                               ORDER BY tmpPriceList.PriceListId
                              ) AS tmp
                         GROUP BY tmp.FuelId
                        )
       -- Результат
       SELECT 
             Object_Fuel.Id          AS Id
           , Object_Fuel.ObjectCode  AS Code
           , Object_Fuel.ValueData   AS Name
           
           , ObjectFloat_Ratio.ValueData AS Ratio
           
           , Object_RateFuelKind.Id          AS RateFuelKindId
           , Object_RateFuelKind.ObjectCode  AS RateFuelKindCode
           , Object_RateFuelKind.ValueData   AS RateFuelKindName
           
           , tmpPrice.ValuePrice :: TVarChar AS ValuePrice
          
           , Object_Fuel.isErased AS isErased
           
       FROM Object AS Object_Fuel
           LEFT JOIN tmpPrice ON tmpPrice.FuelId = Object_Fuel.Id 
       
           LEFT JOIN ObjectFloat AS ObjectFloat_Ratio ON ObjectFloat_Ratio.ObjectId = Object_Fuel.Id 
                                                     AND ObjectFloat_Ratio.DescId = zc_ObjectFloat_Fuel_Ratio()
           LEFT JOIN ObjectLink AS ObjectLink_Fuel_RateFuelKind ON ObjectLink_Fuel_RateFuelKind.ObjectId = Object_Fuel.Id 
                                                               AND ObjectLink_Fuel_RateFuelKind.DescId = zc_ObjectLink_Fuel_RateFuelKind()
           LEFT JOIN Object AS Object_RateFuelKind ON Object_RateFuelKind.Id = ObjectLink_Fuel_RateFuelKind.ChildObjectId              

     WHERE Object_Fuel.DescId = zc_Object_Fuel();
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Fuel(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.09.13         * add RateFuelKind             
 24.09.13         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Fuel (zfCalc_UserAdmin())
