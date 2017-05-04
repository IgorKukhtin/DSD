-- Function: gpSelect_ObjectHistory_PriceListItem_Print ()


DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_PriceListItem_Print (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectHistory_PriceListItem_Print(
    IN inPriceListId        Integer   , -- ключ 
    IN inOperDate           TDateTime , -- Дата действия
    IN inSession            TVarChar    -- сессия пользователя
)                              
RETURNS TABLE (Id Integer , ObjectId Integer
                , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsGroupNameFull TVarChar
                , ValuePrice TFloat
               )
AS
$BODY$
   DECLARE vbPriceWithVAT_pl Boolean;
   DECLARE vbVATPercent_pl TFloat;
BEGIN

     -- Выбираем данные
     RETURN QUERY 
              
       SELECT
             ObjectHistory_PriceListItem.Id
           , ObjectHistory_PriceListItem.ObjectId

           , ObjectLink_PriceListItem_Goods.ChildObjectId AS GoodsId
           , Object_Goods.ObjectCode AS GoodsCode
           , Object_Goods.ValueData  AS GoodsName
                    
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , COALESCE (ObjectHistoryFloat_PriceListItem_Value.ValueData, 0):: TFloat  AS ValuePrice

           
       FROM ObjectLink AS ObjectLink_PriceListItem_PriceList
                                   
            LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                 ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
            LEFT JOIN Object AS Object_Goods
                             ON Object_Goods.Id = ObjectLink_PriceListItem_Goods.ChildObjectId

            LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                    ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                   AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                   AND inOperDate >= ObjectHistory_PriceListItem.StartDate AND inOperDate < ObjectHistory_PriceListItem.EndDate
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                         ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                        AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()


       WHERE ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
         AND ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListId
         AND (ObjectHistoryFloat_PriceListItem_Value.ValueData <> 0 )
         AND Object_Goods.isErased = FAlSE
       ;
       
   END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.12.15         * 
*/

-- тест
-- SELECT * FROM gpSelect_ObjectHistory_PriceListItem_Print (zc_PriceList_ProductionSeparate(), CURRENT_TIMESTAMP, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_ObjectHistory_PriceListItem_Print (zc_PriceList_Basis(), CURRENT_TIMESTAMP, inSession:= zfCalc_UserAdmin())

--select * from gpSelect_ObjectHistory_PriceListItem_Print(inPriceListId := 18879 , inOperDate := '11.11.2015' ,  inSession := '5');
