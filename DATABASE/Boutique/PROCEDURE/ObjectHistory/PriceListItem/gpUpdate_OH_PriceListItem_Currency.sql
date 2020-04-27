-- Function: gpUpdate_OH_PriceListItem_Currency (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_OH_PriceListItem_Currency (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_OH_PriceListItem_Currency(
    IN inId                     Integer,    -- ключ объекта <Элемент ИСТОРИИ>
    IN inCurrencyId             Integer,    -- Валюта
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
DECLARE
   DECLARE vbUserId Integer;
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

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.02.20         *
*/

-- тест
--