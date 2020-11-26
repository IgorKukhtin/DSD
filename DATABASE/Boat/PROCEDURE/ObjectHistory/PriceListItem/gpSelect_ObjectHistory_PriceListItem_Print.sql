-- Function: gpSelect_ObjectHistory_PriceListItem_Print ()


DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_PriceListItem_Print (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectHistory_PriceListItem_Print(
    IN inPriceListId        Integer   , -- ключ
    IN inOperDate           TDateTime , -- Дата действия
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer , ObjectId Integer
                , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsGroupNameFull TVarChar
                , MeasureName TVarChar
                , ValuePrice TFloat, ValuePriceWithVAT TFloat
               )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPriceWithVAT Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- Определили
     vbPriceWithVAT:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = inPriceListId AND ObjectBoolean.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT());

     -- Выбираем данные
     RETURN QUERY
       SELECT
             ObjectHistory_PriceListItem.Id
           , ObjectHistory_PriceListItem.ObjectId

           , ObjectLink_PriceListItem_Goods.ChildObjectId AS GoodsId
           , Object_Goods.ObjectCode                      AS GoodsCode
           , Object_Goods.ValueData                       AS GoodsName
           
           , ObjectString_Goods_GoodsGroupFull.ValueData  AS GoodsGroupNameFull
           , Object_Measure.ValueData                     AS MeasureName

             -- расчет цены без НДС, до 2 знаков
           , CASE WHEN vbPriceWithVAT = FALSE
                  THEN COALESCE (ObjectHistoryFloat_PriceListItem_Value.ValueData, 0)
                  ELSE CAST (COALESCE (ObjectHistoryFloat_PriceListItem_Value.ValueData, 0) * ( 1 - COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
             END ::TFloat  AS ValuePrice

             -- расчет цены с НДС, до 2 знаков
           , CASE WHEN vbPriceWithVAT = FALSE
                  THEN CAST (COALESCE (ObjectHistoryFloat_PriceListItem_Value.ValueData, 0) * ( 1 + COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                  ELSE COALESCE (ObjectHistoryFloat_PriceListItem_Value.ValueData, 0)
             END ::TFloat  AS ValuePriceWithVAT
             
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

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_TaxKind
                                 ON ObjectLink_Goods_TaxKind.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_TaxKind.DescId = zc_ObjectLink_Goods_TaxKind()
            --LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = ObjectLink_Goods_TaxKind.ChildObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                  ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_Goods_TaxKind.ChildObjectId
                                 AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()

       WHERE ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
         AND ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListId
         AND (ObjectHistoryFloat_PriceListItem_Value.ValueData <> 0 ) --OR ObjectHistory_PriceListItem.StartDate <> zc_DateStart())
         AND Object_Goods.isErased = FAlSE
       ;

   END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.11.20         *
*/

-- тест
-- SELECT * FROM gpSelect_ObjectHistory_PriceListItem_Print (zc_PriceList_ProductionSeparate(), CURRENT_TIMESTAMP, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_ObjectHistory_PriceListItem_Print (zc_PriceList_Basis(), CURRENT_TIMESTAMP, inSession:= zfCalc_UserAdmin())
