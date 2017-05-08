-- Function: gpInsertUpdate_ObjectHistory_DiscountPeriodItemLast (Integer, Integer, Integer, TDateTime, TFloat, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_DiscountPeriodItemLast (Integer, Integer, Integer, TDateTime, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_DiscountPeriodItemLast(
 INOUT ioId                     Integer,    -- ключ объекта <Элемент сезонных скидок>
    IN inUnitId                 Integer,    -- Подразделение
    IN inGoodsId                Integer,    -- Товар
    IN inOperDate               TDateTime,  -- Дата действия % скидки
   OUT outStartDate             TDateTime,  -- Дата действия % скидки
   OUT outEndDate               TDateTime,  -- Дата действия % скидки
    IN inValue                  TFloat,     -- Значение цены
    IN inIsLast                 Boolean,    -- 
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
DECLARE
   DECLARE vbUserId Integer;
   DECLARE vbDiscountPeriodItemId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectHistory_DiscountPeriodItem());

   -- !!!определяется!!!
   IF inIsLast = TRUE THEN ioId:= 0; END IF;

   -- Получаем ссылку на объект % скидки
   vbDiscountPeriodItemId := lpGetInsert_Object_DiscountPeriodItem (inUnitId, inGoodsId, vbUserId);
 
   -- Вставляем или меняем объект % скидки
   ioId := lpInsertUpdate_ObjectHistory (ioId, zc_ObjectHistory_DiscountPeriodItem(), vbDiscountPeriodItemId, inOperDate, vbUserId);
   -- Устанавливаем цену
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_DiscountPeriodItem_Value(), ioId, inValue);

   --
   IF inIsLast = TRUE AND EXISTS (SELECT Id 
                                  FROM ObjectHistory 
                                  WHERE DescId = zc_ObjectHistory_DiscountPeriodItem()
                                    AND ObjectId = vbDiscountPeriodItemId 
                                    AND StartDate > inOperDate)
   THEN
         -- сохранили протокол - "удаление"
         PERFORM lpInsert_ObjectHistoryProtocol (ObjectHistory.ObjectId, vbUserId, ObjectHistory.StartDate, ObjectHistory.EndDate, ObjectHistoryFloat_Value.ValueData, TRUE, TRUE)
         FROM ObjectHistory
              LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                           ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory.Id
                                          AND ObjectHistoryFloat_Value.DescId = zc_ObjectHistoryFloat_DiscountPeriodItem_Value()
         WHERE ObjectHistory.DescId = zc_ObjectHistory_DiscountPeriodItem() AND ObjectHistory.ObjectId = vbDiscountPeriodItemId AND ObjectHistory.StartDate > inOperDate;

         -- удалили
         DELETE FROM ObjectHistoryDate WHERE ObjectHistoryId IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_DiscountPeriodItem() AND ObjectId = vbDiscountPeriodItemId AND StartDate > inOperDate);
         DELETE FROM ObjectHistoryFloat WHERE ObjectHistoryId IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_DiscountPeriodItem() AND ObjectId = vbDiscountPeriodItemId AND StartDate > inOperDate);
         DELETE FROM ObjectHistoryString WHERE ObjectHistoryId IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_DiscountPeriodItem() AND ObjectId = vbDiscountPeriodItemId AND StartDate > inOperDate);
         DELETE FROM ObjectHistoryLink WHERE ObjectHistoryId IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_DiscountPeriodItem() AND ObjectId = vbDiscountPeriodItemId AND StartDate > inOperDate);
         DELETE FROM ObjectHistory WHERE Id IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_DiscountPeriodItem() AND ObjectId = vbDiscountPeriodItemId AND StartDate > inOperDate);
         -- Здесь надо изменить св-во EndDate
         UPDATE ObjectHistory SET EndDate = zc_DateEnd() WHERE Id = ioId;
   END IF;


   -- вернули значения
   SELECT StartDate, EndDate INTO outStartDate, outEndDate FROM ObjectHistory WHERE Id = ioId;

   -- сохранили протокол
   PERFORM lpInsert_ObjectHistoryProtocol (inObjectId:= vbDiscountPeriodItemId, inUserId:= vbUserId, inStartDate:= outStartDate, inEndDate:= outEndDate, inPrice:= inValue, inIsUpdate:= TRUE, inIsErased:= FALSE);


END;$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 28.04.17         * 
*/

--test
--select * from gpInsertUpdate_ObjectHistory_DiscountPeriodItemLast(ioId := 0 , inUnitId := 311 , inGoodsId := 271 , inOperDate := ('08.05.2017')::TDateTime , inValue := 0 , inIsLast := 'False' ,  inSession := '2');