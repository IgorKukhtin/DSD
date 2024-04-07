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
   -- ��������� 
   SELECT EndDate, StartDate, DescId, ObjectId 
          INTO lEndDate, lStartDate, lDescId, lObjectId
   FROM ObjectHistory WHERE Id = inId;


   -- !!!������ �������� �������!!!
   PERFORM lpCheckPeriodClose_auditor (NULL, NULL, NULL, NULL, lObjectId, inUserId);


   -- ����� ������ ������ �������, ����� �������� ��� EndDate = EndDate ���������� ��������
   vbId_find:= (SELECT Id FROM ObjectHistory 
                WHERE ObjectHistory.DescId = lDescId 
                  AND ObjectHistory.ObjectId = lObjectId
                  AND ObjectHistory.StartDate < lStartDate
                ORDER BY ObjectHistory.StartDate DESC
                LIMIT 1);
   -- ��������
   IF COALESCE (vbId_find, 0) = 0 AND 1=0
   THEN
       RAISE EXCEPTION '������.������� �� ������.';
   END IF;


   -- ��������� �������� - "��������"
   PERFORM lpInsert_ObjectHistoryProtocol (ObjectHistory.ObjectId, inUserId, ObjectHistory.StartDate, ObjectHistory.EndDate, ObjectHistoryFloat_Value.ValueData, '', TRUE, TRUE)
   FROM ObjectHistory
        LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                     ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory.Id
                                    AND ObjectHistoryFloat_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
   WHERE ObjectHistory.Id = inId;

   -- ��������
   DELETE FROM ObjectHistoryLink WHERE ObjectHistoryId = inId;
   DELETE FROM ObjectHistoryString WHERE ObjectHistoryId = inId;
   DELETE FROM ObjectHistoryFloat WHERE ObjectHistoryId = inId;
   -- ��������
   DELETE FROM ObjectHistory WHERE Id = inId;


   -- �������� ��� ����� ������� �������� ��������� EndDate = EndDate ���������� ��������
   UPDATE ObjectHistory SET EndDate = lEndDate 
   WHERE Id = vbId_find;

   -- ��������� �������� - "��������� EndDate"
   PERFORM lpInsert_ObjectHistoryProtocol (ObjectHistory.ObjectId, inUserId, StartDate, EndDate, ObjectHistoryFloat_Value.ValueData)
   FROM ObjectHistory
        LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                     ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory.Id
                                    AND ObjectHistoryFloat_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
   WHERE ObjectHistory.Id = vbId_find;
   
   
   

   -- ��������
   IF inUserId = zfCalc_UserAdmin() :: Integer 
   THEN
       RAISE EXCEPTION '������.Admin.';
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.08.15         *
*/

