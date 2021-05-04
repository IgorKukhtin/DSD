-- Function: gpUpdate_OH_PriceListItem_Currency (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_OH_PriceListItem_Currency (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_OH_PriceListItem_Currency (Integer, Integer, Integer, Integer, TDateTime, TFloat, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_OH_PriceListItem_Currency(
    IN inId                     Integer,    -- ключ объекта <Элемент ИСТОРИИ>
    IN inCurrencyId             Integer,    -- Валюта
    IN inPriceListId            Integer,    -- Прайс-лист
    IN inGoodsId                Integer,    -- Товар
    IN inOperDate               TDateTime,  -- Дата действия цены
   OUT outStartDate             TDateTime,  -- Дата действия цены
   OUT outEndDate               TDateTime,  -- Дата действия цены
 INOUT ioValue                  TFloat,     -- Цена
    IN inIsLast                 Boolean,    -- 
    IN inisChangePrice          Boolean,    -- Корректировка цены Да/Нет
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

   -- Сохранили ВАЛЮТУ
 --PERFORM lpInsertUpdate_ObjectHistoryLink (zc_ObjectHistoryLink_PriceListItem_Currency(), OH_PriceListItem.Id, inCurrencyId)
   PERFORM lpInsertUpdate_ObjectHistoryLink (zc_ObjectHistoryLink_PriceListItem_Currency(), OH_PriceListItem_find.Id, inCurrencyId)
   FROM ObjectHistory AS OH_PriceListItem
        INNER JOIN ObjectHistory AS OH_PriceListItem_find
                                 ON OH_PriceListItem_find.ObjectId = OH_PriceListItem.ObjectId
   WHERE OH_PriceListItem.Id = inId
  ;

   -- изменили во Всех партиях Товара
   PERFORM lpUpdate_Object_PartionGoods_OperPriceList (inGoodsId:= ObjectLink_PriceListItem_Goods.ChildObjectId, inUserId:= vbUserId)
   FROM ObjectHistory AS OH_PriceListItem
        LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                             ON ObjectLink_PriceListItem_Goods.ObjectId = OH_PriceListItem.ObjectId
                            AND ObjectLink_PriceListItem_Goods.DescId   = zc_ObjectLink_PriceListItem_Goods()
   WHERE OH_PriceListItem.Id = inId
  ;


  -- если проставлен режим изменения цены ДАТА
  IF COALESCE (inisChangePrice,FALSE) = TRUE
  THEN
      SELECT tmp.outStartDate, tmp.outEndDate
     INTO outStartDate, outEndDate
      FROM gpInsertUpdate_ObjectHistory_PriceListItemLast(ioId          := inId          ::Integer    -- ключ объекта <Элемент ИСТОРИИ>
                                                        , inPriceListId := inPriceListId ::Integer    -- Прайс-лист
                                                        , inGoodsId     := inGoodsId     ::Integer    -- Товар
                                                        , inOperDate    := inOperDate    ::TDateTime  -- Дата действия цены
                                                        , inValue       := ioValue       ::TFloat     -- Цена
                                                        , inIsLast      := inIsLast      ::Boolean    -- 
                                                        , inSession     := inSession     ::TVarChar    -- сессия пользователя
                                                        ) AS tmp;
  ELSE
     -- вернули тек значения
    
     -- Поиск <Элемент цены>
     vbPriceListItemId := lpGetInsert_Object_PriceListItem (inPriceListId, inGoodsId, vbUserId);
 
     SELECT ObjectHistory.StartDate, ObjectHistory.EndDate, ObjectHistoryFloat_Value.ValueData
    INTO outStartDate, outEndDate, ioValue
     FROM ObjectHistory
          LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                       ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory.Id
                                      AND ObjectHistoryFloat_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
     WHERE ObjectHistory.DescId = zc_ObjectHistory_PriceListItem()
       AND ObjectHistory.ObjectId = vbPriceListItemId
       AND ObjectHistory.StartDate <= inOperDate
       AND ObjectHistory.EndDate >= inOperDate
     ;

  END IF;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.04.21         *
 25.02.20         *
*/

-- тест
--