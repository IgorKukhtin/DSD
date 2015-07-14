-- DROP FUNCTION lpInsertUpdate_ObjectHistory (integer, integer, integer, TDateTime);

CREATE OR REPLACE FUNCTION lpInsertUpdate_ObjectHistory(
INOUT ioId integer, 
   IN inDescId integer, 
   IN inObjectId integer, 
   IN inOperDate TDateTime
)
AS
$BODY$
DECLARE
  lEndDate TDateTime;
  lStartDate TDateTime;
  PriorId Integer;
  findId Integer;
BEGIN

   IF COALESCE (inObjectId, 0) = 0 
   THEN
       RAISE EXCEPTION 'Error. inObjectId = %', inObjectId;
   END IF;

  IF ioId = 0 THEN
     -- ���� ioId, ���� �� ����� 0
     SELECT ObjectHistory.Id INTO ioId
     FROM ObjectHistory
     WHERE ObjectHistory.DescId = inDescId 
       AND ObjectHistory.ObjectId = inObjectId
       AND ObjectHistory.StartDate = inOperDate;
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
         -- ������� "������" ������� �.�. � ���� ����� �� ���������
         DELETE FROM ObjectHistoryDate WHERE ObjectHistoryId = findId;
         DELETE FROM ObjectHistoryFloat WHERE ObjectHistoryId = findId;
         DELETE FROM ObjectHistoryString WHERE ObjectHistoryId = findId;
         DELETE FROM ObjectHistoryLink WHERE ObjectHistoryId = findId;
         DELETE FROM ObjectHistory WHERE Id = findId;
     END IF;
  END IF;


  -- ����� ���� �������� ��-�� EndDate � ����������� �������� ������������ inOperDate
  UPDATE ObjectHistory SET EndDate = inOperDate
  WHERE Id = (SELECT Id FROM ObjectHistory 
              WHERE ObjectHistory.DescId = inDescId 
                AND ObjectHistory.ObjectId = inObjectId
                AND ObjectHistory.StartDate < inOperDate
              ORDER BY ObjectHistory.StartDate DESC
              LIMIT 1);


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
  lEndDate := COALESCE(lEndDate, zc_DateEnd());

  IF COALESCE(ioId, 0) = 0 THEN
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
  END IF;

END;           
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 07.12.14                                        * add ������� "������" ������� �.�. � ���� ����� �� ���������
 01.01.13                        *
*/
