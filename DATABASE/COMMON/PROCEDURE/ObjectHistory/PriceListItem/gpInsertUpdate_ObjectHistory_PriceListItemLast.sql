-- Function: gpInsertUpdate_ObjectHistory_PriceListItemLast (Integer, Integer, Integer, TDateTime, TFloat, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceListItemLast (Integer, Integer, Integer, TDateTime, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_PriceListItemLast(
 INOUT ioId                     Integer,    -- ключ объекта <Элемент прайс-листа>
    IN inPriceListId            Integer,    -- Прайс-лист
    IN inGoodsId                Integer,    -- Товар
    IN inOperDate               TDateTime,  -- Дата действия цены
   OUT outStartDate             TDateTime,  -- Дата действия цены
   OUT outEndDate               TDateTime,  -- Дата действия цены
    IN inValue                  TFloat,     -- Значение цены
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


   -- !!!определяется!!!
   IF inIsLast = TRUE THEN ioId:= 0; END IF;

   -- Получаем ссылку на объект цен
   vbPriceListItemId := lpGetInsert_Object_PriceListItem (inPriceListId, inGoodsId);
 
   -- Вставляем или меняем объект историю цен
   ioId := lpInsertUpdate_ObjectHistory (ioId, zc_ObjectHistory_PriceListItem(), vbPriceListItemId, inOperDate);
   -- Устанавливаем цену
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_PriceListItem_Value(), ioId, inValue);

   --
   IF inIsLast = TRUE AND EXISTS (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_PriceListItem() AND ObjectId = vbPriceListItemId AND StartDate > inOperDate)
   THEN
         -- удалили
         DELETE FROM ObjectHistoryDate WHERE ObjectHistoryId IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_PriceListItem() AND ObjectId = vbPriceListItemId AND StartDate > inOperDate);
         DELETE FROM ObjectHistoryFloat WHERE ObjectHistoryId IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_PriceListItem() AND ObjectId = vbPriceListItemId AND StartDate > inOperDate);
         DELETE FROM ObjectHistoryString WHERE ObjectHistoryId IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_PriceListItem() AND ObjectId = vbPriceListItemId AND StartDate > inOperDate);
         DELETE FROM ObjectHistoryLink WHERE ObjectHistoryId IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_PriceListItem() AND ObjectId = vbPriceListItemId AND StartDate > inOperDate);
         DELETE FROM ObjectHistory WHERE Id IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_PriceListItem() AND ObjectId = vbPriceListItemId AND StartDate > inOperDate);
         -- Здесь надо изменить св-во EndDate
         UPDATE ObjectHistory SET EndDate = zc_DateEnd() WHERE Id = ioId;
   END IF;

   --
   SELECT StartDate, EndDate INTO outStartDate, outEndDate FROM ObjectHistory WHERE Id = ioId;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 09.12.14                                        *
*/
