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
   DELETE FROM ObjectHistoryLink WHERE ObjectHistoryId = inId;
   DELETE FROM ObjectHistoryString WHERE ObjectHistoryId = inId;
   DELETE FROM ObjectHistoryFloat WHERE ObjectHistoryId = inId;
  
   -- Изменили перед удалением диапазон
   -- Для этого у раннего элемента поставили EndDate = EndDate удаляемого элемента

   SELECT EndDate, StartDate, DescId, ObjectId 
          INTO lEndDate, lStartDate, lDescId, lObjectId
   FROM ObjectHistory WHERE Id = inId;

   UPDATE ObjectHistory SET EndDate = lEndDate 
   WHERE Id = (SELECT Id FROM ObjectHistory 
                WHERE ObjectHistory.DescId = lDescId 
                  AND ObjectHistory.ObjectId = lObjectId
                  AND ObjectHistory.StartDate < lStartDate
             ORDER BY ObjectHistory.StartDate DESC
                LIMIT 1);

   DELETE FROM ObjectHistory WHERE Id = inId;

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpDelete_ObjectHistory(integer, tvarchar)
  OWNER TO postgres;