-- Function: gpSelect_ObjectHistory_PriceListGoodsItem ()

DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_PriceListGoodsItem (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectHistory_PriceListGoodsItem(
    IN inPriceListId        Integer   , -- Прайс-Лист 
    IN inGoodsId            Integer   , -- Товар
    IN inSession            TVarChar    -- сессия пользователя
)                              
RETURNS TABLE (Id Integer, StartDate TDateTime, EndDate TDateTime
             , ValuePrice TFloat, isErased Boolean)
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
         --RAISE EXCEPTION 'Ошибка. Нет прав на Просмотр прайса <%>', lfGet_Object_ValueData (inPriceListId);
         RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка. Нет прав на Просмотр прайса <%>'     :: TVarChar
                                               , inProcedureName := 'gpInsertUpdate_ObjectHistory_PriceListTax'   :: TVarChar
                                               , inUserId        := vbUserId
                                               , inParam1        := lfGet_Object_ValueData (inPriceListId)        :: TVarChar
                                               );
     END IF;*/

/*
     -- Ограничение - если роль Начисления транспорт-меню
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = 78489 AND UserId = vbUserId)
        AND COALESCE (inPriceListId, 0) NOT IN (zc_PriceList_Fuel()
                                               )
     THEN
         --RAISE EXCEPTION 'Ошибка. Нет прав на Просмотр прайса <%>', lfGet_Object_ValueData (inPriceListId);
         RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка. Нет прав на Просмотр прайса <%>'     :: TVarChar
                                               , inProcedureName := 'gpInsertUpdate_ObjectHistory_PriceListTax'   :: TVarChar
                                               , inUserId        := vbUserId
                                               , inParam1        := lfGet_Object_ValueData (inPriceListId)        :: TVarChar
                                               );
     END IF;
*/

     -- Выбираем данные
     
       RETURN QUERY 
       SELECT
             ObjectHistory_PriceListItem.Id

           , ObjectHistory_PriceListItem.StartDate
           , ObjectHistory_PriceListItem.EndDate
           , ObjectHistoryFloat_PriceListItem_Value.ValueData AS ValuePrice
           , False AS isErased
       FROM ObjectLink AS ObjectLink_PriceListItem_PriceList
            LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                 ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()

            LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                    ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                   AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                         ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                        AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()

       WHERE ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
         AND ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListId
         AND ObjectLink_PriceListItem_Goods.ChildObjectId = inGoodsId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.11.20         *
*/

-- тест
-- SELECT * FROM gpSelect_ObjectHistory_PriceListGoodsItem (zc_PriceList_ProductionSeparate(), 0, zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_ObjectHistory_PriceListGoodsItem (zc_PriceList_Basis(), 0, zfCalc_UserAdmin())
