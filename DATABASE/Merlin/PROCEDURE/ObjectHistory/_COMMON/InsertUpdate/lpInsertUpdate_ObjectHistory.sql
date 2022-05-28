-- DROP FUNCTION lpInsertUpdate_ObjectHistory (Integer, Integer, Integer, TDateTime);

DROP FUNCTION IF EXISTS lpInsertUpdate_ObjectHistory (Integer, Integer, Integer, TDateTime);
DROP FUNCTION IF EXISTS lpInsertUpdate_ObjectHistory (Integer, Integer, Integer, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_ObjectHistory(
 INOUT ioId         Integer, 
    IN inDescId     Integer, 
    IN inObjectId   Integer,
    IN inEndDate    TDateTime,
    IN inUserId     Integer
)
AS
$BODY$
DECLARE
  lStartDate TDateTime;
  lEndDate   TDateTime;
  vbNextId   Integer;
  findId     Integer;
  tmpId      Integer;
BEGIN
   -- !!!��������!!!
   ioId:= COALESCE (ioId, 0);
   -- !!!��������� ����!!!
   inEndDate:= DATE_TRUNC ('DAY', inEndDate);

   IF COALESCE (inObjectId, 0) = 0 
   THEN
       RAISE EXCEPTION 'Error. inObjectId = %', inObjectId;
   END IF;

   -- ���� ��� ��� - ��������� �����
   IF ioId = 0
   THEN

     -- ���� ioId - �� ��� �� ����, �.�. EndDate = inEndDate
     ioId:= COALESCE ((SELECT ObjectHistory.Id 
                       FROM ObjectHistory 
                       WHERE ObjectHistory.DescId = inDescId AND ObjectHistory.ObjectId = inObjectId AND ObjectHistory.EndDate = inEndDate
                      ), 0);

     -- ���� ����� ������ �����, �� �� � ����� ������
     IF COALESCE (ioId, 0) <> 0 THEN
        RETURN;
     END IF;

   ELSE
     -- ���� ����� Id, ���� �� ������������� ��� �� �����
     findId:= (SELECT ObjectHistory.Id
               FROM ObjectHistory
               WHERE ObjectHistory.DescId   = inDescId 
                 AND ObjectHistory.ObjectId = inObjectId
                 AND ObjectHistory.EndDate  = inEndDate
                
               );
     -- ���� ��� "������" �������
     IF findId > 0 AND findId <> ioId
     THEN
         -- ��������� �������� - "��������"
         PERFORM lpInsert_ObjectHistoryProtocol (ObjectHistory.ObjectId, inUserId, ObjectHistory.StartDate, ObjectHistory.EndDate, ObjectHistoryFloat_Value.ValueData, TRUE, TRUE)
         FROM ObjectHistory
              LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                           ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory.Id
                                          AND ObjectHistoryFloat_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
         WHERE ObjectHistory.Id = findId;

         -- ������� "������" ������� �.�. � ���� ����� �� ���������
         DELETE FROM ObjectHistoryDate   WHERE ObjectHistoryId = findId;
         DELETE FROM ObjectHistoryFloat  WHERE ObjectHistoryId = findId;
         DELETE FROM ObjectHistoryString WHERE ObjectHistoryId = findId;
         DELETE FROM ObjectHistoryLink   WHERE ObjectHistoryId = findId;
         DELETE FROM ObjectHistory       WHERE Id = findId;

     END IF;

  END IF;


   -- ����� ���������� �������� ������������ inEndDate
   tmpId:= (SELECT Id FROM ObjectHistory 
            WHERE ObjectHistory.DescId   = inDescId 
              AND ObjectHistory.ObjectId = inObjectId
              AND ObjectHistory.EndDate  > inEndDate
            -- ������� ������  
            ORDER BY ObjectHistory.EndDate ASC
            LIMIT 1
           );
   -- ����� ���� �������� ��-�� StartDate � ���������� �������� ������������ inEndDate
   UPDATE ObjectHistory SET StartDate = inEndDate + INTERVAL '1 DAY' WHERE Id = tmpId;

   -- ��������� �������� - "��������� StartDate"
   PERFORM lpInsert_ObjectHistoryProtocol (ObjectHistory.ObjectId, inUserId, StartDate, EndDate, ObjectHistoryFloat_Value.ValueData)
   FROM ObjectHistory
        LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                     ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory.Id
                                    AND ObjectHistoryFloat_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
   WHERE ObjectHistory.Id = tmpId;


  -- ���� �������� ������, �� ���� ��������� ��������� �� - � ���� ����� ������� StartDate
  IF ioId <> 0 THEN
     -- �������� ���� �������� ��������
     lEndDate:= (SELECT EndDate FROM ObjectHistory WHERE Id = ioId);
     -- ��������� ���������� �������� ������������ ioId
     SELECT Id, EndDate INTO vbNextId, lEndDate
     FROM ObjectHistory
     WHERE ObjectHistory.DescId    = inDescId
       AND ObjectHistory.ObjectId  = inObjectId
       AND ObjectHistory.EndDate   > lEndDate
     -- ������� ������  
     ORDER BY ObjectHistory.EndDate ASC
     LIMIT 1;
  END IF;

  lStartDate := NULL;

  -- �������� ���� ����������� �������� ������������ inEndDate
  lStartDate:= (SELECT EndDate + INTERVAL '1 DAY'
                FROM ObjectHistory
                WHERE ObjectHistory.DescId   = inDescId
                  AND ObjectHistory.ObjectId = inObjectId
                  AND ObjectHistory.EndDate  < inEndDate
                  AND ObjectHistory.Id       <> ioId
                -- ������� ���������
                ORDER BY ObjectHistory.EndDate DESC
                LIMIT 1
               );

  -- ������ StartDate ��� �������� ��������: ��� �������� ���� + 1 ����������� �������� ������������ inEndDate ��� ����������� ����
  lStartDate := COALESCE (lStartDate, DATE_TRUNC ('YEAR', inEndDate - INTERVAL '5 YEAR'));

  IF COALESCE(ioId, 0) = 0
  THEN
     -- �������� ������� �������: <���� ������ �������> , <��� �������> , <������> � ������� �������� <�����>
     INSERT INTO ObjectHistory (DescId, ObjectId, StartDate, EndDate)
            VALUES (inDescId, inObjectId, lStartDate, inEndDate) RETURNING Id INTO ioId;
  ELSE
     -- �������� ������� ������� �� �������� <�����>: <��� �������>, <������>
     UPDATE ObjectHistory SET StartDate = lStartDate, EndDate = inEndDate, ObjectId = inObjectId  WHERE Id = ioId;
     IF NOT found THEN
       -- �������� ������� �������: <���� ������ �������>, <��� �������> , <������> �� ��������� <�����>
       INSERT INTO ObjectHistory (Id, DescId, ObjectId, StartDate, EndDate)
                    VALUES (ioId, inDescId, inObjectId, lStartDate, inEndDate);
     END IF;
  END IF;


  -- ���� ����� ������� ��� ������
  IF COALESCE (vbNextId, 0) <> 0
  THEN
     -- �������� StartDate � ���������� �������� ������������ ioId
     UPDATE ObjectHistory SET StartDate = COALESCE((SELECT EndDate + INTERVAL '1 DAY'  
                                                    FROM ObjectHistory
                                                    WHERE ObjectHistory.DescId    = inDescId 
                                                      AND ObjectHistory.ObjectId  = inObjectId
                                                      AND ObjectHistory.EndDate   < lEndDate
                                                    -- ������� ���������
                                                    ORDER BY ObjectHistory.EndDate DESC
                                                    LIMIT 1
                                                   ), zc_DateStart())  
     WHERE Id = vbNextId;
     -- ��������� �������� - "��������� StartDate"
     PERFORM lpInsert_ObjectHistoryProtocol (ObjectHistory.ObjectId, inUserId, StartDate, EndDate, ObjectHistoryFloat_Value.ValueData)
     FROM ObjectHistory
          LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                       ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory.Id
                                      AND ObjectHistoryFloat_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
      WHERE ObjectHistory.Id = vbNextId;
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
