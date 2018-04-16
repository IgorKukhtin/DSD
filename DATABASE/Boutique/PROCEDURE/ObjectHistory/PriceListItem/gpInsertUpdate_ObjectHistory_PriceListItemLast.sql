-- Function: gpInsertUpdate_ObjectHistory_PriceListItemLast (Integer, Integer, Integer, TDateTime, TFloat, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceListItemLast (Integer, Integer, Integer, TDateTime, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_PriceListItemLast(
 INOUT ioId                     Integer,    -- ключ объекта <Элемент ИСТОРИИ>
    IN inPriceListId            Integer,    -- Прайс-лист
    IN inGoodsId                Integer,    -- Товар
    IN inOperDate               TDateTime,  -- Дата действия цены
   OUT outStartDate             TDateTime,  -- Дата действия цены
   OUT outEndDate               TDateTime,  -- Дата действия цены
    IN inValue                  TFloat,     -- Цена
    IN inIsLast                 Boolean,    -- 
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
DECLARE
   DECLARE vbUserId Integer;
   DECLARE vbPriceListItemId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectHistory_PriceListItem());

   -- !!!меняем значение!!!
   IF inIsLast = TRUE THEN ioId:= 0; END IF;

   -- Поиск <Элемент цены>
   vbPriceListItemId := lpGetInsert_Object_PriceListItem (inPriceListId, inGoodsId, vbUserId);
 
   -- Сохранили историю
   ioId := lpInsertUpdate_ObjectHistory (ioId, zc_ObjectHistory_PriceListItem(), vbPriceListItemId, inOperDate, vbUserId);
   -- Сохранили цену
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_PriceListItem_Value(), ioId, inValue);


   --
   IF inIsLast = TRUE AND EXISTS (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_PriceListItem() AND ObjectId = vbPriceListItemId AND StartDate > inOperDate)
   THEN
         -- сохранили протокол - "удаление"
         PERFORM lpInsert_ObjectHistoryProtocol (ObjectHistory.ObjectId, vbUserId, ObjectHistory.StartDate, ObjectHistory.EndDate, ObjectHistoryFloat_Value.ValueData, TRUE, TRUE)
         FROM ObjectHistory
              LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                           ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory.Id
                                          AND ObjectHistoryFloat_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
         WHERE ObjectHistory.DescId = zc_ObjectHistory_PriceListItem() AND ObjectHistory.ObjectId = vbPriceListItemId AND ObjectHistory.StartDate > inOperDate;

         -- удалили
         DELETE FROM ObjectHistoryDate WHERE ObjectHistoryId IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_PriceListItem() AND ObjectId = vbPriceListItemId AND StartDate > inOperDate);
         DELETE FROM ObjectHistoryFloat WHERE ObjectHistoryId IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_PriceListItem() AND ObjectId = vbPriceListItemId AND StartDate > inOperDate);
         DELETE FROM ObjectHistoryString WHERE ObjectHistoryId IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_PriceListItem() AND ObjectId = vbPriceListItemId AND StartDate > inOperDate);
         DELETE FROM ObjectHistoryLink WHERE ObjectHistoryId IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_PriceListItem() AND ObjectId = vbPriceListItemId AND StartDate > inOperDate);
         DELETE FROM ObjectHistory WHERE Id IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_PriceListItem() AND ObjectId = vbPriceListItemId AND StartDate > inOperDate);
         -- Здесь надо изменить св-во EndDate
         UPDATE ObjectHistory SET EndDate = zc_DateEnd() WHERE Id = ioId;
   END IF;


   -- вернули значения
   SELECT StartDate, EndDate INTO outStartDate, outEndDate FROM ObjectHistory WHERE Id = ioId;

   -- Проверка
   IF inIsLast = TRUE AND COALESCE (outEndDate, zc_DateStart()) <> zc_DateEnd()
   THEN
       RAISE EXCEPTION 'Ошибка. inIsLast = TRUE AND outEndDate = <%>', outEndDate;
   END IF;
   

   -- !!!не забыли - cохранили Последнюю Цену в ПАРТИЯХ!!!
   IF inPriceListId = zc_PriceList_Basis()
   THEN
       PERFORM lpUpdate_Object_PartionGoods_OperPriceList (inGoodsId:= inGoodsId, inUserId:= vbUserId);
   END IF;


   -- сохранили протокол
   PERFORM lpInsert_ObjectHistoryProtocol (inObjectId:= vbPriceListItemId, inUserId:= vbUserId, inStartDate:= outStartDate, inEndDate:= outEndDate, inPrice:= inValue, inIsUpdate:= TRUE, inIsErased:= FALSE);


END;$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 20.08.15         * lpInsert_ObjectHistoryProtocol
 09.12.14                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_ObjectHistory_PriceListItemLast (ioId := 0, inPriceListId:= 4788, inGoodsId := 120766, inOperDate = '26.03.2015', inValue := 59, inIsLast:= TRUE, inSession := zc_User_Sybase() :: TVarChar);
