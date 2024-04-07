-- Function: lpDelete_ObjectHistory(Integer, tvarchar)

DROP FUNCTION IF EXISTS lpDelete_ObjectHistory (Integer, tvarchar);
DROP FUNCTION IF EXISTS lpDelete_ObjectHistory (Integer, Integer);

CREATE OR REPLACE FUNCTION lpDelete_ObjectHistory(
    IN inId         Integer, 
    IN inUserId     Integer
)
RETURNS VOID
AS
$BODY$
DECLARE
  lEndDate TDateTime;
  lStartDate TDateTime;
  lDescId Integer;
  lObjectId Integer;
  vbId_find Integer;
BEGIN
   -- параметры 
   SELECT EndDate, StartDate, DescId, ObjectId 
          INTO lEndDate, lStartDate, lDescId, lObjectId
   FROM ObjectHistory WHERE Id = inId;


   -- !!!Только просмотр Аудитор!!!
   PERFORM lpCheckPeriodClose_auditor (NULL, NULL, NULL, NULL, lObjectId, inUserId);


   -- нашли ПЕРВЫЙ ранний элемент, потом поставим ему EndDate = EndDate удаляемого элемента
   vbId_find:= (SELECT Id FROM ObjectHistory 
                WHERE ObjectHistory.DescId = lDescId 
                  AND ObjectHistory.ObjectId = lObjectId
                  AND ObjectHistory.StartDate < lStartDate
                ORDER BY ObjectHistory.StartDate DESC
                LIMIT 1);
   -- проверка
   IF COALESCE (vbId_find, 0) = 0 AND 1=0
   THEN
       RAISE EXCEPTION 'Ошибка.Элемент не найден.';
   END IF;


   -- сохранили протокол - "удаление"
   PERFORM lpInsert_ObjectHistoryProtocol (ObjectHistory.ObjectId, inUserId, ObjectHistory.StartDate, ObjectHistory.EndDate, ObjectHistoryFloat_Value.ValueData, '', TRUE, TRUE)
   FROM ObjectHistory
        LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                     ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory.Id
                                    AND ObjectHistoryFloat_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
   WHERE ObjectHistory.Id = inId;

   -- удаление
   DELETE FROM ObjectHistoryLink WHERE ObjectHistoryId = inId;
   DELETE FROM ObjectHistoryString WHERE ObjectHistoryId = inId;
   DELETE FROM ObjectHistoryFloat WHERE ObjectHistoryId = inId;
   -- удаление
   DELETE FROM ObjectHistory WHERE Id = inId;


   -- Изменили для этого раннего элемента поставили EndDate = EndDate удаляемого элемента
   UPDATE ObjectHistory SET EndDate = lEndDate 
   WHERE Id = vbId_find;

   -- сохранили протокол - "изменение EndDate"
   PERFORM lpInsert_ObjectHistoryProtocol (ObjectHistory.ObjectId, inUserId, StartDate, EndDate, ObjectHistoryFloat_Value.ValueData)
   FROM ObjectHistory
        LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                     ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory.Id
                                    AND ObjectHistoryFloat_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
   WHERE ObjectHistory.Id = vbId_find;
   
   
   

   -- проверка
   IF inUserId = zfCalc_UserAdmin() :: Integer 
   THEN
       RAISE EXCEPTION 'Ошибка.Admin.';
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.08.15         *
*/

