--DROP FUNCTION lpInsertUpdate_ObjectHistory(integer, integer, integer, TDateTime);

CREATE OR REPLACE FUNCTION lpInsertUpdate_ObjectHistory(
INOUT ioId integer, 
IN inDescId integer, 
IN inObjectId integer, 
IN inOperDate TDateTime)
 AS
$BODY$
DECLARE
  lEndDate TDateTime;
  lStartDate TDateTime;
  PriorId Integer;
BEGIN
  -- Ищем ioId, если оно равно 0.
  IF ioId = 0 THEN
     SELECT ObjectHistory.Id INTO ioId
       FROM ObjectHistory
      WHERE ObjectHistory.DescId = inDescId 
        AND ObjectHistory.ObjectId = inObjectId
        AND ObjectHistory.StartDate = inOperDate;
      -- Если нашли запись такую, то ее и будем менять
      IF COALESCE(ioId, 0) <> 0 THEN
         RETURN;
      END IF;
  END IF;

  -- Здесь надо изменить св-во EndDate у нового предыдущего итема. 
  UPDATE ObjectHistory SET EndDate = inOperDate
   WHERE Id = (SELECT Id FROM ObjectHistory 
                WHERE ObjectHistory.DescId = inDescId 
                  AND ObjectHistory.ObjectId = inObjectId
                  AND ObjectHistory.StartDate < inOperDate
             ORDER BY ObjectHistory.StartDate DESC
                LIMIT 1);

  -- Если меняется запись, то надо запомнить предыдущий ИД
  IF ioId <> 0 THEN
     SELECT StartDate INTO lStartDate FROM ObjectHistory WHERE Id = ioId;
     SELECT Id, StartDate INTO PriorId, lStartDate
     FROM ObjectHistory 
    WHERE ObjectHistory.DescId = inDescId 
      AND ObjectHistory.ObjectId = inObjectId
      AND ObjectHistory.StartDate < lStartDate
 ORDER BY ObjectHistory.StartDate DESC
    LIMIT 1;
  END IF;

  lEndDate := NULL;

   -- Устанавливаем EndDate. Для этого ищем или ближайшую запись и берем оттуда StartDate или максимальную дату
  SELECT MIN(StartDate) INTO lEndDate
    FROM ObjectHistory
   WHERE ObjectHistory.DescId = inDescId 
     AND ObjectHistory.ObjectId = inObjectId
     AND ObjectHistory.StartDate > inOperDate;

  lEndDate := COALESCE(lEndDate, zc_DateEnd());

  IF COALESCE(ioId, 0) = 0 THEN
     /* вставить <ключ класса объекта> , <код объекта> , <данные>
        и вернуть значение <ключа> */
     INSERT INTO ObjectHistory (DescId, ObjectId, StartDate, EndDate)
            VALUES (inDescId, inObjectId, inOperDate, lEndDate) RETURNING Id INTO ioId;
  ELSE
     /* изменить <код объекта> и <данные> по значению <ключа> */
     UPDATE ObjectHistory SET StartDate = inOperDate, EndDate = lEndDate WHERE Id = ioId;
     IF NOT found THEN
       /* вставить <ключ класса объекта> , <код объекта> , <данные> со значением <ключа> */
       INSERT INTO ObjectHistory (Id, DescId, ObjectId, StartDate, EndDate)
                    VALUES (ioId, inDescId, inObjectId, inOperDate, lEndDate);
     END IF;
  END IF;

  IF COALESCE(PriorId, 0) <> 0 THEN
     UPDATE ObjectHistory SET EndDate = COALESCE((SELECT MAX(StartDate)     
                                           FROM ObjectHistory
                                          WHERE ObjectHistory.DescId = inDescId 
                                            AND ObjectHistory.ObjectId = inObjectId
                                            AND ObjectHistory.StartDate > lStartDate), zc_DateEnd()) 
     WHERE Id = PriorId;
  END IF;



END;           
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpInsertUpdate_ObjectHistory(integer, integer, integer, TDateTime)
  OWNER TO postgres; 