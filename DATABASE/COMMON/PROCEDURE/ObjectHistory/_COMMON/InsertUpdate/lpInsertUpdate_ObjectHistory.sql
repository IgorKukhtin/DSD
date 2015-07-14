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
     -- Ищем ioId, если он равен 0
     SELECT ObjectHistory.Id INTO ioId
     FROM ObjectHistory
     WHERE ObjectHistory.DescId = inDescId 
       AND ObjectHistory.ObjectId = inObjectId
       AND ObjectHistory.StartDate = inOperDate;
     -- Если нашли запись такую, то ее и будем менять
     IF COALESCE (ioId, 0) <> 0 THEN
        RETURN;
     END IF;
  ELSE
     -- Ищем любой Id, если он начинается с той же даты
     findId:= (SELECT ObjectHistory.Id
               FROM ObjectHistory
               WHERE ObjectHistory.DescId = inDescId 
                 AND ObjectHistory.ObjectId = inObjectId
                 AND ObjectHistory.StartDate = inOperDate);
     -- если это "другой" элемент
     IF findId > 0 AND findId <> ioId
     THEN
         -- удалили "другой" элемент т.к. у него такие же параметры
         DELETE FROM ObjectHistoryDate WHERE ObjectHistoryId = findId;
         DELETE FROM ObjectHistoryFloat WHERE ObjectHistoryId = findId;
         DELETE FROM ObjectHistoryString WHERE ObjectHistoryId = findId;
         DELETE FROM ObjectHistoryLink WHERE ObjectHistoryId = findId;
         DELETE FROM ObjectHistory WHERE Id = findId;
     END IF;
  END IF;


  -- Здесь надо изменить св-во EndDate у предыдущего элемента относительно inOperDate
  UPDATE ObjectHistory SET EndDate = inOperDate
  WHERE Id = (SELECT Id FROM ObjectHistory 
              WHERE ObjectHistory.DescId = inDescId 
                AND ObjectHistory.ObjectId = inObjectId
                AND ObjectHistory.StartDate < inOperDate
              ORDER BY ObjectHistory.StartDate DESC
              LIMIT 1);


  -- Если меняется запись, то надо запомнить предыдущий ИД
  IF ioId <> 0 THEN
     -- получаем дату текущего элемента
     SELECT StartDate INTO lStartDate FROM ObjectHistory WHERE Id = ioId;
     -- параметры предыдущего элемента относительно ioId
     SELECT Id, StartDate INTO PriorId, lStartDate
     FROM ObjectHistory
     WHERE ObjectHistory.DescId = inDescId
       AND ObjectHistory.ObjectId = inObjectId
       AND ObjectHistory.StartDate < lStartDate
     ORDER BY ObjectHistory.StartDate DESC
     LIMIT 1;
  END IF;

  lEndDate := NULL;

  -- начальная дата следующего элемента относительно inOperDate
  SELECT MIN (StartDate) INTO lEndDate
  FROM ObjectHistory
  WHERE ObjectHistory.DescId = inDescId
    AND ObjectHistory.ObjectId = inObjectId
    AND ObjectHistory.StartDate > inOperDate
    AND ObjectHistory.Id <> ioId;

  -- расчет EndDate для текущего элемента: или начальная дата следующего элемента относительно inOperDate или максимальная дату
  lEndDate := COALESCE(lEndDate, zc_DateEnd());

  IF COALESCE(ioId, 0) = 0 THEN
     -- дабавили текущий элемент: <ключ класса объекта> , <код объекта> , <данные> и вернули значение <ключа>
     INSERT INTO ObjectHistory (DescId, ObjectId, StartDate, EndDate)
            VALUES (inDescId, inObjectId, inOperDate, lEndDate) RETURNING Id INTO ioId;
  ELSE
     -- изменили текущий элемент по значению <ключа>: <код объекта>, <данные>
     UPDATE ObjectHistory SET StartDate = inOperDate, EndDate = lEndDate, ObjectId = inObjectId  WHERE Id = ioId;
     IF NOT found THEN
       -- дабавили текущий элемент: <ключ класса объекта>, <код объекта> , <данные> со значением <ключа>
       INSERT INTO ObjectHistory (Id, DescId, ObjectId, StartDate, EndDate)
                    VALUES (ioId, inDescId, inObjectId, inOperDate, lEndDate);
     END IF;
  END IF;


  -- если такой элемент был найден
  IF COALESCE (PriorId, 0) <> 0
  THEN
     -- изменили EndDate у предыдущего элемента относительно ioId
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
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 07.12.14                                        * add удалили "другой" элемент т.к. у него такие же параметры
 01.01.13                        *
*/
