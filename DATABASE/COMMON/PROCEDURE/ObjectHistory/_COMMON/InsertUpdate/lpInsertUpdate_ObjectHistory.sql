-- DROP FUNCTION lpInsertUpdate_ObjectHistory (Integer, Integer, Integer, TDateTime);

DROP FUNCTION IF EXISTS lpInsertUpdate_ObjectHistory (Integer, Integer, Integer, TDateTime);
DROP FUNCTION IF EXISTS lpInsertUpdate_ObjectHistory (Integer, Integer, Integer, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_ObjectHistory(
 INOUT ioId         Integer, 
    IN inDescId     Integer, 
    IN inObjectId   Integer, 
    IN inOperDate   TDateTime,
    IN inUserId     Integer
)
AS
$BODY$
DECLARE
  lEndDate   TDateTime;
  lStartDate TDateTime;
  PriorId    Integer;
  findId     Integer;
  tmpId      Integer;
BEGIN
   -- !!!������ �������� �������!!!
   PERFORM lpCheckPeriodClose_auditor (NULL, NULL, NULL, NULL, inObjectId, inUserId);


   -- !!!��������!!!
   ioId:= COALESCE (ioId, 0);
   -- !!!��������� ����!!!
   inOperDate:= DATE_TRUNC ('SECOND', inOperDate);

   IF COALESCE (inObjectId, 0) = 0 
   THEN
       RAISE EXCEPTION 'Error. inObjectId = %', inObjectId;
   END IF;

  -- ���� ��� ��� - ��������� �����
  IF ioId = 0 THEN

     -- ���� ioId - �� ��� �� ����, �.�. StartDate = inOperDate
     ioId:= (SELECT ObjectHistory.Id FROM ObjectHistory WHERE ObjectHistory.DescId = inDescId AND ObjectHistory.ObjectId = inObjectId AND ObjectHistory.StartDate = inOperDate);

     -- !!!��������!!!
     ioId:= COALESCE (ioId, 0);

     -- ���� ����� ������ �����, �� �� � ����� ������
     IF COALESCE (ioId, 0) <> 0 THEN
        RETURN;
     END IF;

  ELSE
     -- ���� ����� Id, ���� �� ���������� � ��� �� ����
     findId:= (SELECT ObjectHistory.Id
               FROM ObjectHistory
               WHERE ObjectHistory.DescId = inDescId 
                 AND ObjectHistory.ObjectId = inObjectId
                 AND ObjectHistory.StartDate = inOperDate);
     -- ���� ��� "������" �������
     IF findId > 0 AND findId <> ioId
     THEN
         -- ��������� �������� - "��������"
         PERFORM lpInsert_ObjectHistoryProtocol (ObjectHistory.ObjectId, inUserId, ObjectHistory.StartDate, ObjectHistory.EndDate, ObjectHistoryFloat_Value.ValueData, '', TRUE, TRUE)
         FROM ObjectHistory
              LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                           ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory.Id
                                          AND ObjectHistoryFloat_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
         WHERE ObjectHistory.Id = findId;

         -- ������� "������" ������� �.�. � ���� ����� �� ���������
         DELETE FROM ObjectHistoryDate WHERE ObjectHistoryId = findId;
         DELETE FROM ObjectHistoryFloat WHERE ObjectHistoryId = findId;
         DELETE FROM ObjectHistoryString WHERE ObjectHistoryId = findId;
         DELETE FROM ObjectHistoryLink WHERE ObjectHistoryId = findId;
         DELETE FROM ObjectHistory WHERE Id = findId;
     END IF;
  END IF;


   -- ����� ����������� �������� ������������ inOperDate
   tmpId:= (SELECT Id FROM ObjectHistory 
            WHERE ObjectHistory.DescId = inDescId 
              AND ObjectHistory.ObjectId = inObjectId
              AND ObjectHistory.StartDate < inOperDate
            ORDER BY ObjectHistory.StartDate DESC
            LIMIT 1);
   -- ����� ���� �������� ��-�� EndDate � ����������� �������� ������������ inOperDate
   UPDATE ObjectHistory SET EndDate = inOperDate WHERE Id = tmpId;

   -- ��������� �������� - "��������� EndDate"
   PERFORM lpInsert_ObjectHistoryProtocol (ObjectHistory.ObjectId, inUserId, StartDate, EndDate, ObjectHistoryFloat_Value.ValueData)
   FROM ObjectHistory
        LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                     ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory.Id
                                    AND ObjectHistoryFloat_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
   WHERE ObjectHistory.Id = tmpId;


  -- ���� �������� ������, �� ���� ��������� ���������� ��
  IF ioId <> 0 THEN
     -- �������� ���� �������� ��������
     SELECT StartDate INTO lStartDate FROM ObjectHistory WHERE Id = ioId;
     -- ��������� ����������� �������� ������������ ioId
     SELECT Id, StartDate INTO PriorId, lStartDate
     FROM ObjectHistory
     WHERE ObjectHistory.DescId = inDescId
       AND ObjectHistory.ObjectId = inObjectId
       AND ObjectHistory.StartDate < lStartDate
     ORDER BY ObjectHistory.StartDate DESC
     LIMIT 1;
  END IF;

  lEndDate := NULL;

  -- ��������� ���� ���������� �������� ������������ inOperDate
  SELECT MIN (StartDate) INTO lEndDate
  FROM ObjectHistory
  WHERE ObjectHistory.DescId = inDescId
    AND ObjectHistory.ObjectId = inObjectId
    AND ObjectHistory.StartDate > inOperDate
    AND ObjectHistory.Id <> ioId;

  -- ������ EndDate ��� �������� ��������: ��� ��������� ���� ���������� �������� ������������ inOperDate ��� ������������ ����
  lEndDate := COALESCE (lEndDate, zc_DateEnd());

  IF COALESCE(ioId, 0) = 0
  THEN
     -- �������� ������� �������: <���� ������ �������> , <��� �������> , <������> � ������� �������� <�����>
     INSERT INTO ObjectHistory (DescId, ObjectId, StartDate, EndDate)
            VALUES (inDescId, inObjectId, inOperDate, lEndDate) RETURNING Id INTO ioId;
  ELSE
     -- �������� ������� ������� �� �������� <�����>: <��� �������>, <������>
     UPDATE ObjectHistory SET StartDate = inOperDate, EndDate = lEndDate, ObjectId = inObjectId  WHERE Id = ioId;
     IF NOT found THEN
       -- �������� ������� �������: <���� ������ �������>, <��� �������> , <������> �� ��������� <�����>
       INSERT INTO ObjectHistory (Id, DescId, ObjectId, StartDate, EndDate)
                    VALUES (ioId, inDescId, inObjectId, inOperDate, lEndDate);
     END IF;
  END IF;


  -- ���� ����� ������� ��� ������
  IF COALESCE (PriorId, 0) <> 0
  THEN
     -- �������� EndDate � ����������� �������� ������������ ioId
     UPDATE ObjectHistory SET EndDate = COALESCE((SELECT MIN (StartDate)     
                                                  FROM ObjectHistory
                                                  WHERE ObjectHistory.DescId = inDescId 
                                                    AND ObjectHistory.ObjectId = inObjectId
                                                    AND ObjectHistory.StartDate > lStartDate
                                                 ), zc_DateEnd())  
     WHERE Id = PriorId;
     -- ��������� �������� - "��������� EndDate"
     PERFORM lpInsert_ObjectHistoryProtocol (ObjectHistory.ObjectId, inUserId, StartDate, EndDate, ObjectHistoryFloat_Value.ValueData)
     FROM ObjectHistory
          LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                       ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory.Id
                                      AND ObjectHistoryFloat_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
      WHERE ObjectHistory.Id = PriorId;
  END IF;

END;           
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 19.10.15                                        * add ��������� ��������
 19.10.15                                        * add inUserId
 07.12.14                                        * add ������� "������" ������� �.�. � ���� ����� �� ���������
 01.01.13                        *
*/
