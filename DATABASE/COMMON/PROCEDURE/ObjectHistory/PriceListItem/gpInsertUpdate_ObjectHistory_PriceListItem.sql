-- Function: gpInsertUpdate_ObjectHistory_PriceListItem()

-- DROP FUNCTION gpInsertUpdate_ObjectHistory_PriceListItem();

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_PriceListItem(
 INOUT ioId                     Integer,    -- ключ объекта <Элемент прайс-листа>
    IN inPriceListId            Integer,    -- Прайс-лист
    IN inGoodsId                Integer,    -- Товар
    IN inOperDate               TDateTime,  -- Дата действия прайс-листа
    IN inValue                  TFloat,     -- Значение цены
    IN inSession                TVarChar    -- сессия пользователя
)
  RETURNS integer AS
$BODY$
DECLARE
  PriceListItemId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Account());

   -- Получаем ссылку на объект цен
   PriceListItemId := lpGetInsert_Object_PriceListItem(inPriceListId, inGoodsId);
 
   -- Вставляем или меняем объект историю цен
   ioId := lpInsertUpdate_ObjectHistory(ioId, zc_ObjectHistory_PriceListItem(), PriceListItemId, inOperDate);
   -- Устанавливаем цену
   PERFORM lpInsertUpdate_ObjectHistoryFloat(zc_ObjectHistoryFloat_PriceListItem_Value(), ioId, inValue);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.06.13                        *

*/
