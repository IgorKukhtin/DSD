-- Function: gpSelectMobile_Object_PriceListItems_test (Integer, Integer, Integer, TVarChar)

-- DROP FUNCTION IF EXISTS gpSelectMobile_Object_PriceListItems_test (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelectMobile_Object_PriceListItems_test (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_PriceListItems_test (
    IN inPriceListId  Integer  , -- Прайс-лист
    IN inGoodsId      Integer  , -- Товар
    IN inGoodsKindId  Integer  , -- 
    IN inSession      TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id              Integer
             , GoodsId         Integer   -- Товар
             , GoodsKindId     Integer   -- 
             , PriceListId     Integer   -- Прайс-лист
             , ReturnStartDate TDateTime -- Дата с которой действует цена возврата
             , ReturnEndDate   TDateTime -- Дата до которой действует цена возврата
             , ReturnPrice     TFloat    -- Цена возврата
              )
AS 
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbReturnDate TDateTime;
   DECLARE vbIsFind Boolean;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      
      vbReturnDate:= CURRENT_DATE - INTERVAL '14 DAY';

      -- поиск
      vbIsFind:= EXISTS (SELECT 1
                         FROM Object AS Object_PriceListItem
                              JOIN ObjectLink AS ObjectLink_PriceListItem_Goods 
                                              ON ObjectLink_PriceListItem_Goods.ObjectId = Object_PriceListItem.Id
                                             AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
                                             AND ObjectLink_PriceListItem_Goods.ChildObjectId = inGoodsId
                                             
                              JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                              ON ObjectLink_PriceListItem_PriceList.ObjectId = Object_PriceListItem.Id
                                             AND ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
                                             AND ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListId
                              -- Цены возврата
                              INNER JOIN ObjectHistory AS ObjectHistory_PriceListItem_Return
                                                       ON ObjectHistory_PriceListItem_Return.ObjectId = Object_PriceListItem.Id
                                                      AND ObjectHistory_PriceListItem_Return.DescId = zc_ObjectHistory_PriceListItem() 
                                                      AND vbReturnDate >= ObjectHistory_PriceListItem_Return.StartDate AND vbReturnDate < ObjectHistory_PriceListItem_Return.EndDate
                         WHERE Object_PriceListItem.DescId = zc_Object_PriceListItem()
                        );
      -- замена
      IF vbIsFind = FALSE THEN vbReturnDate:= CURRENT_DATE; END IF;


      IF EXISTS (SELECT 1
                 FROM Object AS Object_PriceListItem
                      JOIN ObjectLink AS ObjectLink_PriceListItem_Goods 
                                      ON ObjectLink_PriceListItem_Goods.ObjectId = Object_PriceListItem.Id
                                     AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
                                     AND ObjectLink_PriceListItem_Goods.ChildObjectId = inGoodsId
                                     
                      JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                      ON ObjectLink_PriceListItem_PriceList.ObjectId = Object_PriceListItem.Id
                                     AND ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
                                     AND ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListId
    
                      LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_GoodsKind
                                           ON ObjectLink_PriceListItem_GoodsKind.ObjectId = Object_PriceListItem.Id
                                          AND ObjectLink_PriceListItem_GoodsKind.DescId = zc_ObjectLink_PriceListItem_GoodsKind()
    
                      -- Цены возврата
                      LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem_Return
                                              ON ObjectHistory_PriceListItem_Return.ObjectId = Object_PriceListItem.Id
                                             AND ObjectHistory_PriceListItem_Return.DescId = zc_ObjectHistory_PriceListItem() 
                                             AND vbReturnDate >= ObjectHistory_PriceListItem_Return.StartDate AND vbReturnDate < ObjectHistory_PriceListItem_Return.EndDate
                      LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value_Return
                                                   ON ObjectHistoryFloat_PriceListItem_Value_Return.ObjectHistoryId = ObjectHistory_PriceListItem_Return.Id
                                                  AND ObjectHistoryFloat_PriceListItem_Value_Return.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
    
                 WHERE Object_PriceListItem.DescId = zc_Object_PriceListItem()
                   AND ObjectHistoryFloat_PriceListItem_Value_Return.ValueData <> 0.0
                   AND ObjectLink_PriceListItem_GoodsKind.ChildObjectId = inGoodsKindId
                )
      THEN
           -- Результат
           RETURN QUERY
             SELECT Object_PriceListItem.Id
                  , ObjectLink_PriceListItem_Goods.ChildObjectId            AS GoodsId
                  , ObjectLink_PriceListItem_GoodsKind.ChildObjectId        AS GoodsKindId
                  , ObjectLink_PriceListItem_PriceList.ChildObjectId        AS PriceListId
                  , ObjectHistory_PriceListItem_Return.StartDate            AS ReturnStartDate
                  , ObjectHistory_PriceListItem_Return.EndDate              AS ReturnEndDate
                  , ObjectHistoryFloat_PriceListItem_Value_Return.ValueData AS ReturnPrice
             FROM Object AS Object_PriceListItem
                  JOIN ObjectLink AS ObjectLink_PriceListItem_Goods 
                                  ON ObjectLink_PriceListItem_Goods.ObjectId = Object_PriceListItem.Id
                                 AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
                                 AND ObjectLink_PriceListItem_Goods.ChildObjectId = inGoodsId
                                 
                  JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                  ON ObjectLink_PriceListItem_PriceList.ObjectId = Object_PriceListItem.Id
                                 AND ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
                                 AND ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListId

                  LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_GoodsKind
                                       ON ObjectLink_PriceListItem_GoodsKind.ObjectId = Object_PriceListItem.Id
                                      AND ObjectLink_PriceListItem_GoodsKind.DescId = zc_ObjectLink_PriceListItem_GoodsKind()

                  -- Цены возврата
                  LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem_Return
                                          ON ObjectHistory_PriceListItem_Return.ObjectId = Object_PriceListItem.Id
                                         AND ObjectHistory_PriceListItem_Return.DescId = zc_ObjectHistory_PriceListItem() 
                                         AND vbReturnDate >= ObjectHistory_PriceListItem_Return.StartDate AND vbReturnDate < ObjectHistory_PriceListItem_Return.EndDate
                  LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value_Return
                                               ON ObjectHistoryFloat_PriceListItem_Value_Return.ObjectHistoryId = ObjectHistory_PriceListItem_Return.Id
                                              AND ObjectHistoryFloat_PriceListItem_Value_Return.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()

             WHERE Object_PriceListItem.DescId = zc_Object_PriceListItem()
               AND ObjectHistoryFloat_PriceListItem_Value_Return.ValueData <> 0.0
               AND ObjectLink_PriceListItem_GoodsKind.ChildObjectId = inGoodsKindId
            ;
      ELSE
           -- Результат
           RETURN QUERY
             SELECT DISTINCT 
                    0 :: Integer Id
                  , ObjectLink_PriceListItem_Goods.ChildObjectId            AS GoodsId
                  , COALESCE (ObjectLink_PriceListItem_GoodsKind.ChildObjectId, zc_GoodsKind_Basis())        AS GoodsKindId
                  , ObjectLink_PriceListItem_PriceList.ChildObjectId        AS PriceListId
                  , ObjectHistory_PriceListItem_Return.StartDate            AS ReturnStartDate
                  , ObjectHistory_PriceListItem_Return.EndDate              AS ReturnEndDate
                  , ObjectHistoryFloat_PriceListItem_Value_Return.ValueData AS ReturnPrice
             FROM Object AS Object_PriceListItem
                  JOIN ObjectLink AS ObjectLink_PriceListItem_Goods 
                                  ON ObjectLink_PriceListItem_Goods.ObjectId = Object_PriceListItem.Id
                                 AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
                                 AND ObjectLink_PriceListItem_Goods.ChildObjectId = inGoodsId
                                 
                  JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                  ON ObjectLink_PriceListItem_PriceList.ObjectId = Object_PriceListItem.Id
                                 AND ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
                                 AND ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListId

                  LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_GoodsKind
                                       ON ObjectLink_PriceListItem_GoodsKind.ObjectId = Object_PriceListItem.Id
                                      AND ObjectLink_PriceListItem_GoodsKind.DescId = zc_ObjectLink_PriceListItem_GoodsKind()

                  -- Цены возврата
                  LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem_Return
                                          ON ObjectHistory_PriceListItem_Return.ObjectId = Object_PriceListItem.Id
                                         AND ObjectHistory_PriceListItem_Return.DescId = zc_ObjectHistory_PriceListItem() 
                                         AND vbReturnDate >= ObjectHistory_PriceListItem_Return.StartDate AND vbReturnDate < ObjectHistory_PriceListItem_Return.EndDate
                  LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value_Return
                                               ON ObjectHistoryFloat_PriceListItem_Value_Return.ObjectHistoryId = ObjectHistory_PriceListItem_Return.Id
                                              AND ObjectHistoryFloat_PriceListItem_Value_Return.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()

             WHERE Object_PriceListItem.DescId = zc_Object_PriceListItem()
               AND ObjectHistoryFloat_PriceListItem_Value_Return.ValueData <> 0.0
               AND COALESCE (ObjectLink_PriceListItem_GoodsKind.ChildObjectId, zc_GoodsKind_Basis()) = zc_GoodsKind_Basis()
            ;

      END IF;

END; 
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 17.02.17                                                         *
*/

-- тест
-- SELECT * FROM gpSelectMobile_Object_PriceListItems_test (inSyncDateIn := zc_DateStart(), inSession := '1059546') WHERE GoodsId = 1045379 and PriceListId = zc_PriceList_Basis()
-- SELECT * FROM gpSelectMobile_Object_PriceListItems_test (inSyncDateIn := zc_DateStart(), inSession := zfCalc_UserAdmin())
-- SELECT * FROM gpSelectMobile_Object_PriceListItems_test (inPriceListId:= 18840, ingoodsId:= 2537, inSession := '2845741')
