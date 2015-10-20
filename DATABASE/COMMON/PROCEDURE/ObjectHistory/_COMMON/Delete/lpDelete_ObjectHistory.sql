-- Function: lpDelete_ObjectHistory(integer, tvarchar)

-- DROP FUNCTION lpDelete_ObjectHistory(integer, tvarchar);

CREATE OR REPLACE FUNCTION lpDelete_ObjectHistory(
IN inId integer, 
IN Session tvarchar)
  RETURNS void AS
$BODY$
DECLARE
  lEndDate TDateTime;
  lStartDate TDateTime;
  lDescId Integer;
  lObjectId Integer;
BEGIN
   -- параметры 
   SELECT EndDate, StartDate, DescId, ObjectId 
          INTO lEndDate, lStartDate, lDescId, lObjectId
   FROM ObjectHistory WHERE Id = inId;

   -- Изменили перед удалением диапазон, для этого у раннего элемента поставили EndDate = EndDate удаляемого элемента
   UPDATE ObjectHistory SET EndDate = lEndDate 
   WHERE Id = (SELECT Id FROM ObjectHistory 
                WHERE ObjectHistory.DescId = lDescId 
                  AND ObjectHistory.ObjectId = lObjectId
                  AND ObjectHistory.StartDate < lStartDate
             ORDER BY ObjectHistory.StartDate DESC
                LIMIT 1);

   -- сохранили протокол - "изменение EndDate"
   PERFORM lpInsert_ObjectHistoryProtocol (ObjectHistory.ObjectId, inUserId, StartDate, EndDate, ObjectHistoryFloat_Value.ValueData)
   FROM ObjectHistory
        LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                     ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory.Id
                                    AND ObjectHistoryFloat_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
   WHERE ObjectHistory.Id = (SELECT Id FROM ObjectHistory 
                             WHERE ObjectHistory.DescId = lDescId 
                               AND ObjectHistory.ObjectId = lObjectId
                               AND ObjectHistory.StartDate < lStartDate
                             ORDER BY ObjectHistory.StartDate DESC
                             LIMIT 1);

   -- сохранили протокол - "удаление"
   PERFORM lpInsert_ObjectHistoryProtocol (ObjectHistory.ObjectId, inUserId, ObjectHistory.StartDate, ObjectHistory.EndDate, ObjectHistoryFloat_Value.ValueData, TRUE, TRUE)
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


END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpDelete_ObjectHistory(integer, tvarchar)
  OWNER TO postgres;