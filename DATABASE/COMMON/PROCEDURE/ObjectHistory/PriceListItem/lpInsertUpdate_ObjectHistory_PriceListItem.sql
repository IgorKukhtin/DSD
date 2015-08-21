-- Function: lpInsertUpdate_ObjectHistory_PriceListItem()

DROP FUNCTION IF EXISTS lpInsertUpdate_ObjectHistory_PriceListItem (Integer,Integer,Integer,TDateTime,TFloat,Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_ObjectHistory_PriceListItem(
 INOUT ioId                     Integer,    -- ключ объекта <Элемент прайс-листа>
    IN inPriceListId            Integer,    -- Прайс-лист
    IN inGoodsId                Integer,    -- Товар
    IN inOperDate               TDateTime,  -- Дата действия прайс-листа
    IN inValue                  TFloat,     -- Значение цены
    IN inUserId                 Integer    -- сессия пользователя
)
  RETURNS integer AS
$BODY$
DECLARE
   DECLARE vbPriceListItemId Integer;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate TDateTime;
BEGIN


   -- Получаем ссылку на объект цен
   vbPriceListItemId := lpGetInsert_Object_PriceListItem (inPriceListId, inGoodsId);
 
   -- Вставляем или меняем объект историю цен
   ioId := lpInsertUpdate_ObjectHistory (ioId, zc_ObjectHistory_PriceListItem(), vbPriceListItemId, inOperDate);
   -- Устанавливаем цену
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_PriceListItem_Value(), ioId, inValue);


   SELECT StartDate, EndDate INTO vbStartDate, vbEndDate FROM ObjectHistory WHERE Id = ioId;
   -- сохранили протокол
   PERFORM lpInsert_ObjectHistoryProtocol (vbPriceListItemId, inUserId, vbStartDate ,vbEndDate, inValue);


END;$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 21.08.15         *
*/
