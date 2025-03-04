-- Function: gpSelect_ObjectHistory_PriceListGoodsItem ()

--DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_PriceListGoodsItem (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_PriceListGoodsItem (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectHistory_PriceListGoodsItem(
    IN inPriceListId        Integer   , -- Прайс-Лист 
    IN inGoodsId            Integer   , -- Товар
    IN inGoodsKindId        Integer   , -- Вид Товара
    IN inSession            TVarChar    -- сессия пользователя
)                              
RETURNS TABLE (Id Integer
             , StartDate TDateTime, EndDate TDateTime
             , ValuePrice    TFloat
             , PriceListId   Integer
             , PriceListName TVarChar
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- Ограничение - если роль Бухгалтер ПАВИЛЬОНЫ
     /*IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = 80548 AND UserId = vbUserId)
        AND COALESCE (inPriceListId, 0) NOT IN (140208 -- Пав-ны приход
                                              , 140209 -- Пав-ны продажа
                                               )
     THEN
         RAISE EXCEPTION 'Ошибка. Нет прав на Просмотр прайса <%>', lfGet_Object_ValueData (inPriceListId);
     END IF;*/


     -- Ограничение - если роль Начисления транспорт-меню
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = 78489 AND UserId = vbUserId)
        AND NOT EXISTS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId)
        AND COALESCE (inPriceListId, 0) NOT IN (zc_PriceList_Fuel())
        -- Прайс-лист - просмотр БЕЗ ограничений
        AND NOT EXISTS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = 11941188 AND UserId = vbUserId)
     THEN
         RAISE EXCEPTION 'Ошибка. Нет прав на Просмотр прайса <%>', lfGet_Object_ValueData (inPriceListId);
     END IF;


     -- Ограничение - Прайс-лист - просмотр с ограничениями
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = vbUserId AND ObjectLink_UserRole_View.RoleId = 10575455)
        -- Прайс-лист - просмотр БЕЗ ограничений
        AND NOT EXISTS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = 11941188 AND UserId = vbUserId)
     THEN
         -- Ограничение
         IF NOT EXISTS (SELECT 1 AS Id FROM Object_ViewPriceList_View WHERE Object_ViewPriceList_View.UserId = vbUserId AND Object_ViewPriceList_View.PriceListId = inPriceListId)
            -- если установлены
            --AND EXISTS (SELECT 1 FROM Object_ViewPriceList_View WHERE Object_ViewPriceList_View.UserId = vbUserId AND Object_ViewPriceList_View.PriceListId > 0)
         THEN
             IF COALESCE (inPriceListId, 0) = 0
             THEN
                 RETURN;
             ELSE
                 RAISE EXCEPTION 'Ошибка.Нет прав на просмотр прайса <%>.', lfGet_Object_ValueData (inPriceListId);
             END IF;
         END IF;
     END IF;


     -- Выбираем данные
     IF COALESCE (inGoodsKindId,0) > 0 
     THEN 
       RETURN QUERY 
       SELECT
             ObjectHistory_PriceListItem.Id

           , ObjectHistory_PriceListItem.StartDate
           , ObjectHistory_PriceListItem.EndDate
           , ObjectHistoryFloat_PriceListItem_Value.ValueData AS ValuePrice

           , Object_PriceList.Id        AS PriceListId
           , Object_PriceList.ValueData AS PriceListName

           , FALSE AS isErased

       FROM ObjectLink AS ObjectLink_PriceListItem_PriceList
            LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                 ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
            JOIN ObjectLink AS ObjectLink_PriceListItem_GoodsKind
                            ON ObjectLink_PriceListItem_GoodsKind.ObjectId      = ObjectLink_PriceListItem_PriceList.ObjectId
                           AND ObjectLink_PriceListItem_GoodsKind.DescId        = zc_ObjectLink_PriceListItem_GoodsKind()
                           AND ObjectLink_PriceListItem_GoodsKind.ChildObjectId = inGoodsKindId
            LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                    ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                   AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                         ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                        AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()

            LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = ObjectLink_PriceListItem_PriceList.ChildObjectId

       WHERE ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
         AND (ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListId OR inPriceListId = 0)
         -- AND ObjectHistoryFloat_PriceListItem_Value.ValueData <> 0
         AND ObjectLink_PriceListItem_Goods.ChildObjectId = inGoodsId;     
     ELSE
       RETURN QUERY 
       SELECT
             ObjectHistory_PriceListItem.Id

           , ObjectHistory_PriceListItem.StartDate
           , ObjectHistory_PriceListItem.EndDate
           , ObjectHistoryFloat_PriceListItem_Value.ValueData AS ValuePrice

           , Object_PriceList.Id        AS PriceListId
           , Object_PriceList.ValueData AS PriceListName

           , FALSE AS isErased
           
       FROM ObjectLink AS ObjectLink_PriceListItem_PriceList
            LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                 ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
            JOIN ObjectLink AS ObjectLink_PriceListItem_GoodsKind
                            ON ObjectLink_PriceListItem_GoodsKind.ObjectId      = ObjectLink_PriceListItem_PriceList.ObjectId
                           AND ObjectLink_PriceListItem_GoodsKind.DescId        = zc_ObjectLink_PriceListItem_GoodsKind()
                           AND ObjectLink_PriceListItem_GoodsKind.ChildObjectId IS NULL -- = inGoodsKindId

            LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                    ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                   AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                         ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                        AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()

            LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = ObjectLink_PriceListItem_PriceList.ChildObjectId

       WHERE ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
         AND (ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListId OR inPriceListId = 0)
         -- AND ObjectHistoryFloat_PriceListItem_Value.ValueData <> 0
         AND ObjectLink_PriceListItem_Goods.ChildObjectId = inGoodsId;
     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.07.13                        *
*/

-- тест
-- SELECT * FROM gpSelect_ObjectHistory_PriceListGoodsItem (zc_PriceList_ProductionSeparate(), 0, 0, zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_ObjectHistory_PriceListGoodsItem (zc_PriceList_Basis(), 0, 0, zfCalc_UserAdmin())
