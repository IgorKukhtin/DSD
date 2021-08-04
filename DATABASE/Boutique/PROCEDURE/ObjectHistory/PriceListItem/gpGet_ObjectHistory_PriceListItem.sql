-- Function: gpGet_ObjectHistory_PriceListItem ()

DROP FUNCTION IF EXISTS gpGet_ObjectHistory_PriceListItem (TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_ObjectHistory_PriceListItem (TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_ObjectHistory_PriceListItem(
    IN inOperDate           TDateTime , -- Дата действия
    IN inId                 Integer   , -- 
    IN inPriceListId        Integer   , -- ключ 
    IN inGoodsId            Integer   , -- Товар
    IN inSession            TVarChar    -- сессия пользователя
)                              
RETURNS TABLE (Id Integer
             , CurrencyId Integer, CurrencyName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsNameFull TVarChar
             , StartDate TDateTime, EndDate TDateTime
             , ValuePrice TFloat
             , isDiscount Boolean)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_Get_OH_PriceListItem());
    --vbUserId:= lpGetUserBySession (inSession);
    
     -- Выбираем данные
     RETURN QUERY 
       SELECT
             ObjectHistory_PriceListItem.Id
           , Object_Currency.Id                           AS CurrencyId
           , Object_Currency.ValueData                    AS CurrencyName
           , ObjectLink_PriceListItem_Goods.ChildObjectId AS GoodsId
           , Object_Goods.ObjectCode                      AS GoodsCode
           , Object_Goods.ValueData                       AS GoodsName

           , (Object_GroupNameFull.ValueData ||' - '||Object_Label.ValueData||' - '||Object_Goods.ObjectCode||' - ' || Object_Goods.ValueData) ::TVarChar  AS GoodsNameFull
           
           , CASE WHEN COALESCE (inId,0) = 0 THEN CURRENT_DATE ELSE ObjectHistory_PriceListItem.StartDate END :: TDateTime AS StartDate
           , ObjectHistory_PriceListItem.EndDate
           , ObjectHistoryFloat_PriceListItem_Value.ValueData AS ValuePrice
           , CASE WHEN COALESCE (ObjectHistoryFloat_isDiscount.ValueData, 0) = 0 THEN TRUE ELSE FALSE END AS isDiscount

       FROM ObjectLink AS ObjectLink_PriceListItem_PriceList
            LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                 ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_PriceListItem_Goods.ChildObjectId

            LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                    ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                   AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                   AND COALESCE (inOperDate, zc_DateStart()) >= ObjectHistory_PriceListItem.StartDate AND COALESCE (inOperDate, zc_DateStart()) < ObjectHistory_PriceListItem.EndDate
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                         ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                        AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()

            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_isDiscount
                                         ON ObjectHistoryFloat_isDiscount.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                        AND ObjectHistoryFloat_isDiscount.DescId          = zc_ObjectHistoryFloat_PriceListItem_isDiscount()

            LEFT JOIN ObjectHistoryLink AS ObjectHistoryLink_Currency
                                        ON ObjectHistoryLink_Currency.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                       AND ObjectHistoryLink_Currency.DescId          = zc_ObjectHistoryLink_PriceListItem_Currency()
            LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = ObjectHistoryLink_Currency.ObjectId

            LEFT JOIN ObjectString AS Object_GroupNameFull
                                   ON Object_GroupNameFull.ObjectId = Object_Goods.Id
                                  AND Object_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Label
                                 ON ObjectLink_Goods_Label.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Label.DescId = zc_ObjectLink_Goods_Label()
            LEFT JOIN Object AS Object_Label ON Object_Label.Id = ObjectLink_Goods_Label.ChildObjectId

       WHERE ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
         AND ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListId
         AND ObjectLink_PriceListItem_Goods.ChildObjectId = inGoodsId
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 25.02.20         * add Currency
 26.04.18         * add inId, GoodsNameFull
 27.01.15                                        *
*/

-- тест
-- select * from gpGet_ObjectHistory_PriceListItem(inOperDate := ('01.09.2015')::TDateTime , inId:=0, inPriceListId := 372 , inGoodsId := 406 ,  inSession := '2');