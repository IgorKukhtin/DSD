-- Function: gpSelect_ObjectHistory_PriceListGoodsItem ()

DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_PriceListGoodsItem (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectHistory_PriceListGoodsItem(
    IN inPriceListId        Integer   , -- Прайс-Лист 
    IN inGoodsId            Integer   , -- Товар
    IN inSession            TVarChar    -- сессия пользователя
)                              
RETURNS TABLE (Id Integer
             , CurrencyId Integer, CurrencyName TVarChar
             , StartDate TDateTime, EndDate TDateTime
             , ValuePrice TFloat
             , isDiscount Boolean
             , isErased Boolean)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_OH_PriceListGoodsItem());
    --vbUserId:= lpGetUserBySession (inSession);

     -- Выбираем данные
     RETURN QUERY 
       SELECT
             ObjectHistory_PriceListItem.Id
           , Object_Currency.Id                 AS CurrencyId
           , Object_Currency.ValueData          AS CurrencyName
           , CASE WHEN ObjectHistory_PriceListItem.StartDate = zc_DateStart() OR ObjectHistory_PriceListItem.StartDate < '01.01.1980' THEN NULL ELSE ObjectHistory_PriceListItem.StartDate END :: TDateTime AS StartDate
           , CASE WHEN ObjectHistory_PriceListItem.EndDate   = zc_DateEnd() THEN NULL ELSE ObjectHistory_PriceListItem.EndDate END :: TDateTime AS EndDate
           , ObjectHistoryFloat_Value.ValueData AS ValuePrice

           , CASE WHEN COALESCE (ObjectHistoryFloat_isDiscount.ValueData, 1) = 1 THEN FALSE ELSE TRUE END AS isDiscount

           , FALSE AS isErased
       FROM ObjectLink AS ObjectLink_PriceList
            INNER JOIN ObjectLink AS ObjectLink_Goods
                                  ON ObjectLink_Goods.ObjectId      = ObjectLink_PriceList.ObjectId
                                 AND ObjectLink_Goods.DescId        = zc_ObjectLink_PriceListItem_Goods()
                                 AND ObjectLink_Goods.ChildObjectId = inGoodsId

            LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                    ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceList.ObjectId
                                   AND ObjectHistory_PriceListItem.DescId   = zc_ObjectHistory_PriceListItem()
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                         ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                        AND ObjectHistoryFloat_Value.DescId          = zc_ObjectHistoryFloat_PriceListItem_Value()

            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_isDiscount
                                         ON ObjectHistoryFloat_isDiscount.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                        AND ObjectHistoryFloat_isDiscount.DescId          = zc_ObjectHistoryFloat_PriceListItem_isDiscount()

            LEFT JOIN ObjectHistoryLink AS ObjectHistoryLink_Currency
                                        ON ObjectHistoryLink_Currency.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                       AND ObjectHistoryLink_Currency.DescId          = zc_ObjectHistoryLink_PriceListItem_Currency()
            LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = ObjectHistoryLink_Currency.ObjectId

       WHERE ObjectLink_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()
         AND ObjectLink_PriceList.ChildObjectId = inPriceListId
         -- AND ObjectHistoryFloat_Value.ValueData <> 0
         ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.02.20         * add Currency
 25.07.13                        *
*/

-- тест
-- SELECT * FROM gpSelect_ObjectHistory_PriceListGoodsItem (inPriceListId:= 372, inGoodsId:= 406, inSession:= zfCalc_UserAdmin());
