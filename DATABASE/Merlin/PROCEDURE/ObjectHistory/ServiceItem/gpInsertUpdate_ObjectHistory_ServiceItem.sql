-- Function: gpInsertUpdate_ObjectHistory_ServiceItem ()

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_ServiceItem (Integer, Integer, TDateTime, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_ServiceItem(
 INOUT ioId                     Integer,    -- ключ объекта <>
    IN inUnitId                 Integer,    -- 
    IN inOperDate               TDateTime,  -- Дата действия 
    IN inInfoMoneyId            Integer,    -- 
    IN inCommentInfoMoneyId     Integer,    -- 
    IN inValue                  TFloat,   --
    IN inPrice	                TFloat,   -- 
    IN inArea                   TFloat,   -- 
    IN inSession                TVarChar    -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
 DECLARE vbUserId Integer;
 DECLARE vbServiceItemId Integer;
 
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_...());
   vbUserId:= lpGetUserBySession (inSession);

   -- проверка
   IF COALESCE (inUnitId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Не установлен <Отдел>.';
   END IF;
 
   -- Получаем ссылку на ServiceItem ключ inUnitId + inInfoMoneyId
   vbServiceItemId := lpGetInsert_Object_ServiceItem (inUnitId, inInfoMoneyId, vbUserId);

   -- Вставляем или меняем объект историю
   ioId := lpInsertUpdate_ObjectHistory(ioId, zc_ObjectHistory_ServiceItem(), vbServiceItemId, inOperDate, vbUserId);

   -- Статьи Приход/расход
   --PERFORM lpInsertUpdate_ObjectHistoryLink(zc_ObjectHistoryLink_ServiceItem_InfoMoney(), ioId, inInfoMoneyId);
   -- Примечание Приход/расход 	
   PERFORM lpInsertUpdate_ObjectHistoryLink(zc_ObjectHistoryLink_ServiceItem_CommentInfoMoney(), ioId, inCommentInfoMoneyId);
   
   -- 
   PERFORM lpInsertUpdate_ObjectHistoryFloat(zc_ObjectHistoryFloat_ServiceItem_Value(), ioId, inValue);
   -- 
   PERFORM lpInsertUpdate_ObjectHistoryFloat(zc_ObjectHistoryFloat_ServiceItem_Price(), ioId, inPrice);
   -- 
   PERFORM lpInsertUpdate_ObjectHistoryFloat(zc_ObjectHistoryFloat_ServiceItem_Area(), ioId, inArea);

   -- сохранили протокол
   PERFORM lpInsert_ObjectHistoryProtocol (ObjectHistory.ObjectId, vbUserId, ObjectHistory.StartDate, ObjectHistory.EndDate, 0)
   FROM ObjectHistory WHERE Id = ioId;
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.01.22         *
*/