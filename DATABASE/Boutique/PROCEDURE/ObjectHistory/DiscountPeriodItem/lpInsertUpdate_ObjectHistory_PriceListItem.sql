-- Function: lpInsertUpdate_ObjectHistory_DiscountPeriodItem()

DROP FUNCTION IF EXISTS lpInsertUpdate_ObjectHistory_DiscountPeriodItem (Integer,Integer,Integer,TDateTime,TFloat,Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_ObjectHistory_DiscountPeriodItem(
 INOUT ioId                     Integer,    -- ключ объекта <Элемент>
    IN inUnitId                 Integer,    -- 
    IN inGoodsId                Integer,    -- Товар
    IN inOperDate               TDateTime,  -- Дата действия 
    IN inValue                  TFloat,     -- Значение цены
    IN inUserId                 Integer    -- сессия пользователя
)
  RETURNS integer AS
$BODY$
DECLARE
   DECLARE vbDiscountPeriodItemId Integer;
BEGIN

   THEN
       RAISE EXCEPTION 'Ошибка. Нет прав корректировать прайс <%>', lfGet_Object_ValueData (inUnitId);
   END IF;

   -- Получаем ссылку на объект цен
   vbDiscountPeriodItemId := lpGetInsert_Object_DiscountPeriodItem (inUnitId, inGoodsId, inUserId);
 
   -- Вставляем или меняем объект историю цен
   ioId := lpInsertUpdate_ObjectHistory (ioId, zc_ObjectHistory_DiscountPeriodItem(), vbDiscountPeriodItemId, inOperDate, inUserId);
   -- Устанавливаем цену
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_DiscountPeriodItem_Value(), ioId, inValue);

   -- сохранили протокол
   PERFORM lpInsert_ObjectHistoryProtocol (inObjectId:= ObjectHistory.ObjectId, inUserId:= inUserId, inStartDate:= StartDate, inEndDate:= EndDate, inPrice:= inValue, inIsUpdate:= TRUE, inIsErased:= FALSE)
   FROM ObjectHistory WHERE Id = ioId;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 21.08.15         *
*/
