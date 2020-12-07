-- Function: gpGet_ObjectHistory_PriceListItem ()

DROP FUNCTION IF EXISTS gpGet_ObjectHistory_PriceListItem (TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_ObjectHistory_PriceListItem(
    IN inOperDate           TDateTime , -- Дата действия
    IN inPriceListId        Integer   , -- ключ 
    IN inGoodsId            Integer   , -- Товар
    IN inSession            TVarChar    -- сессия пользователя
)                              
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, Article TVarChar
             , StartDate TDateTime, EndDate TDateTime, ValuePrice TFloat
             , PriceNoVAT TFloat, PriceWVAT TFloat
             )
AS
$BODY$
  DECLARE vbPriceWithVAT Boolean;
BEGIN

     -- Определили
     vbPriceWithVAT:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = inPriceListId AND ObjectBoolean.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT());

     -- Выбираем данные
     RETURN QUERY
       WITH tmpData AS (SELECT ObjectHistory_PriceListItem.Id
                             , ObjectLink_PriceListItem_Goods.ChildObjectId AS GoodsId
                             , Object_Goods.ObjectCode    AS GoodsCode
                             , Object_Goods.ValueData     AS GoodsName
                             , ObjectString_Article.ValueData  ::TVarChar  AS Article
                  
                             , ObjectHistory_PriceListItem.StartDate
                             , ObjectHistory_PriceListItem.EndDate
                             , ObjectHistoryFloat_PriceListItem_Value.ValueData AS ValuePrice
                  
                        FROM ObjectLink AS ObjectLink_PriceListItem_PriceList
                             LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                                  ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                                 AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
                             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_PriceListItem_Goods.ChildObjectId

                             LEFT JOIN ObjectString AS ObjectString_Article
                                                    ON ObjectString_Article.ObjectId = Object_Goods.Id
                                                   AND ObjectString_Article.DescId = zc_ObjectString_Article()

                             LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                     ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                                    AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                                    AND inOperDate >= ObjectHistory_PriceListItem.StartDate AND inOperDate < ObjectHistory_PriceListItem.EndDate
                             LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                          ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                         AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()

                        WHERE ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
                          AND ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListId
                          AND ObjectLink_PriceListItem_Goods.ChildObjectId     = inGoodsId
                       )
       -- Результат
       SELECT tmpData.Id
            , tmpData.GoodsId
            , tmpData.GoodsCode
            , tmpData.GoodsName
            , tmpData.Article
               
            , tmpData.StartDate
            , tmpData.EndDate
            , tmpData.ValuePrice

              -- расчет базовой цены без НДС, до 2 знаков
            , CASE WHEN vbPriceWithVAT = FALSE
                   THEN COALESCE (tmpData.ValuePrice, 0)
                   ELSE CAST (COALESCE (tmpData.ValuePrice, 0) * ( 1 - COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
              END ::TFloat  AS PriceNoVAT

              -- расчет базовой цены с НДС, до 2 знаков
            , CASE WHEN vbPriceWithVAT = FALSE
                   THEN CAST ( COALESCE (tmpData.ValuePrice, 0) * ( 1 + COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                   ELSE COALESCE (tmpData.ValuePrice, 0) 
              END ::TFloat  AS PriceWVAT

       FROM tmpData
           LEFT JOIN ObjectLink AS ObjectLink_Goods_TaxKind
                                ON ObjectLink_Goods_TaxKind.ObjectId = tmpData.GoodsId
                               AND ObjectLink_Goods_TaxKind.DescId = zc_ObjectLink_Goods_TaxKind()

           LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                 ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_Goods_TaxKind.ChildObjectId
                                AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()
      ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.11.20         *
 29.11.19         *
 27.01.15                                        *
*/

-- тест
-- select * from gpGet_ObjectHistory_PriceListItem(inOperDate := ('15.11.2020')::TDateTime , inPriceListId := 2782 , inGoodsId := 2891 ,  inSession := '5');