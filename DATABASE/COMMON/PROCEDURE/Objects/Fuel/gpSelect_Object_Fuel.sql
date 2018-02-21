-- Function: gpSelect_Object_Fuel()

DROP FUNCTION IF EXISTS gpSelect_Object_Fuel (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Fuel(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , Ratio TFloat
             , RateFuelKindId Integer, RateFuelKindCode Integer, RateFuelKindName TVarChar
             , ValuePrice TFloat
             , isErased boolean
              )
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Fuel());

     RETURN QUERY 
       WITH tmpPrice AS (SELECT ObjectLink_Goods_Fuel.ChildObjectId                    AS FuelId
                              , MAX (COALESCE (ObjectHistoryFloat_Value.ValueData, 0)) AS ValuePrice
                         FROM ObjectLink AS ObjectLink_Goods_Fuel
                              INNER JOIN ObjectLink AS ObjectLink_Goods
                                                    ON ObjectLink_Goods.ChildObjectId = ObjectLink_Goods_Fuel.ObjectId
                                                   AND ObjectLink_Goods.DescId        = zc_ObjectLink_PriceListItem_Goods()
                              INNER JOIN ObjectLink AS ObjectLink_PriceList
                                                    ON ObjectLink_PriceList.ObjectId      = ObjectLink_Goods.ObjectId
                                                   AND ObjectLink_PriceList.ChildObjectId = zc_PriceList_Fuel()
                                                   AND ObjectLink_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()
                              INNER JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                       ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_Goods.ObjectId
                                                      AND ObjectHistory_PriceListItem.DescId   = zc_ObjectHistory_PriceListItem()
                                                      AND ObjectHistory_PriceListItem.EndDate  = zc_DateEnd()
                              LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                                           ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                          AND ObjectHistoryFloat_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                         WHERE ObjectLink_Goods_Fuel.DescId        = zc_ObjectLink_Goods_Fuel()
                           AND ObjectLink_Goods_Fuel.ChildObjectId > 0
                         GROUP BY  ObjectLink_Goods_Fuel.ChildObjectId
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
           
           , tmpPrice.ValuePrice :: TFloat AS ValuePrice
          
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
