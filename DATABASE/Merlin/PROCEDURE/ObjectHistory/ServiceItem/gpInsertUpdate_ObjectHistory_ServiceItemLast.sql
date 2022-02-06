-- Function: gpInsertUpdate_ObjectHistory_ServiceItemLast (Integer, Integer, Integer, TDateTime, TFloat, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_ServiceItemLast (Integer, Integer, Integer,Integer, TDateTime, TFloat, TFloat, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_ServiceItemLast(
 INOUT ioId                     Integer,    -- ключ объекта <Элемент ИСТОРИИ>
    IN inUnitId                 Integer,    -- 
    IN inInfoMoneyId            Integer,    -- 
    IN inCommentInfoMoneyId     Integer,    -- 
    IN inOperDate               TDateTime,  -- Дата действия цены
   OUT outStartDate             TDateTime,  -- Дата действия цены
   OUT outEndDate               TDateTime,  -- Дата действия цены
    IN inArea                   TFloat,     -- площадь
    IN inPrice                  TFloat,     -- цена за кв.м.
    IN inValue                  TFloat,     -- Сумма
    IN inIsLast                 Boolean,    -- 
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
DECLARE
   DECLARE vbUserId Integer;
   DECLARE vbServiceItemId Integer;
   DECLARE vbDiscountPeriodItemId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_ObjectHistory_ServiceItem());

   -- !!!меняем значение!!!
   IF inIsLast = TRUE THEN ioId:= 0; END IF;

   IF COALESCE (inUnitId,0) = 0
   THEN 
       RAISE EXCEPTION 'Ошибка.Не выбран элемент справочника Отделы.';
   END IF;

   -- Сохранили историю
   ioId := lpInsertUpdate_ObjectHistory (ioId, zc_ObjectHistory_ServiceItem(), inUnitId, inOperDate, vbUserId);

   -- Сохранили 
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_ServiceItem_Area(), ioId, inArea);
   -- Сохранили 
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_ServiceItem_Price(), ioId, inPrice);
   -- Сохранили 
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_ServiceItem_Value(), ioId, inValue);


   -- Сохранили статью
   PERFORM lpInsertUpdate_ObjectHistoryLink (zc_ObjectHistoryLink_ServiceItem_InfoMoney(), ioId, inInfoMoneyId);
   -- Сохранили примечание
   PERFORM lpInsertUpdate_ObjectHistoryLink (zc_ObjectHistoryLink_ServiceItem_CommentInfoMoney(), ioId, inCommentInfoMoneyId);
   
   --
   IF inIsLast = TRUE AND EXISTS (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_ServiceItem() AND ObjectId = inUnitId AND StartDate > inOperDate)
   THEN
         -- сохранили протокол - "удаление"
         PERFORM lpInsert_ObjectHistoryProtocol (ObjectHistory.ObjectId, vbUserId, ObjectHistory.StartDate, ObjectHistory.EndDate, ObjectHistoryFloat_Value.ValueData, TRUE, TRUE)
         FROM ObjectHistory
              LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                           ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory.Id
                                          AND ObjectHistoryFloat_Value.DescId = zc_ObjectHistoryFloat_ServiceItem_Value()
         WHERE ObjectHistory.DescId = zc_ObjectHistory_ServiceItem() AND ObjectHistory.ObjectId = inUnitId AND ObjectHistory.StartDate > inOperDate;

         -- удалили
         DELETE FROM ObjectHistoryDate WHERE ObjectHistoryId IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_ServiceItem() AND ObjectId = inUnitId AND StartDate > inOperDate);
         DELETE FROM ObjectHistoryFloat WHERE ObjectHistoryId IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_ServiceItem() AND ObjectId = inUnitId AND StartDate > inOperDate);
         DELETE FROM ObjectHistoryString WHERE ObjectHistoryId IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_ServiceItem() AND ObjectId = inUnitId AND StartDate > inOperDate);
         DELETE FROM ObjectHistoryLink WHERE ObjectHistoryId IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_ServiceItem() AND ObjectId = inUnitId AND StartDate > inOperDate);
         DELETE FROM ObjectHistory WHERE Id IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_ServiceItem() AND ObjectId = inUnitId AND StartDate > inOperDate);
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

   -- сохранили протокол
   PERFORM lpInsert_ObjectHistoryProtocol (inObjectId:= inUnitId, inUserId:= vbUserId, inStartDate:= outStartDate, inEndDate:= outEndDate, inPrice:= inValue, inIsUpdate:= TRUE, inIsErased:= FALSE);

  /* IF vbUserId :: TVarChar = zfCalc_UserAdmin()
   THEN
       RAISE EXCEPTION 'Error.Admin test - ok';
   END IF;
*/

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.01.22         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_ObjectHistory_ServiceItemLast (ioId := 0, inUnitId:= 4788, inInfoMoneyId := 120766, inOperDate = '26.03.2015', inValue := 59, inIsLast:= TRUE, inSession := zc_User_Sybase() :: TVarChar);
