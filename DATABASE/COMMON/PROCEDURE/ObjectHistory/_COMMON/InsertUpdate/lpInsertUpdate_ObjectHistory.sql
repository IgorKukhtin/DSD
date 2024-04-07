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
   -- !!!Только просмотр Аудитор!!!
   PERFORM lpCheckPeriodClose_auditor (NULL, NULL, NULL, NULL, inObjectId, inUserId);


   -- !!!обнулили!!!
   ioId:= COALESCE (ioId, 0);
   -- !!!Округляем дату!!!
   inOperDate:= DATE_TRUNC ('SECOND', inOperDate);

   IF COALESCE (inObjectId, 0) = 0 
   THEN
       RAISE EXCEPTION 'Error. inObjectId = %', inObjectId;
   END IF;

  -- если его нет - попробуем найти
  IF ioId = 0 THEN

     -- Ищем ioId - за тот же день, т.е. StartDate = inOperDate
     ioId:= (SELECT ObjectHistory.Id FROM ObjectHistory WHERE ObjectHistory.DescId = inDescId AND ObjectHistory.ObjectId = inObjectId AND ObjectHistory.StartDate = inOperDate);

     -- !!!обнулили!!!
     ioId:= COALESCE (ioId, 0);

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
         -- сохранили протокол - "удаление"
         PERFORM lpInsert_ObjectHistoryProtocol (ObjectHistory.ObjectId, inUserId, ObjectHistory.StartDate, ObjectHistory.EndDate, ObjectHistoryFloat_Value.ValueData, '', TRUE, TRUE)
         FROM ObjectHistory
              LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                           ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory.Id
                                          AND ObjectHistoryFloat_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
         WHERE ObjectHistory.Id = findId;

         -- удалили "другой" элемент т.к. у него такие же параметры
         DELETE FROM ObjectHistoryDate WHERE ObjectHistoryId = findId;
         DELETE FROM ObjectHistoryFloat WHERE ObjectHistoryId = findId;
         DELETE FROM ObjectHistoryString WHERE ObjectHistoryId = findId;
         DELETE FROM ObjectHistoryLink WHERE ObjectHistoryId = findId;
         DELETE FROM ObjectHistory WHERE Id = findId;
     END IF;
  END IF;


   -- поиск предыдущего элемента относительно inOperDate
   tmpId:= (SELECT Id FROM ObjectHistory 
            WHERE ObjectHistory.DescId = inDescId 
              AND ObjectHistory.ObjectId = inObjectId
              AND ObjectHistory.StartDate < inOperDate
            ORDER BY ObjectHistory.StartDate DESC
            LIMIT 1);
   -- Здесь надо изменить св-во EndDate у предыдущего элемента относительно inOperDate
   UPDATE ObjectHistory SET EndDate = inOperDate WHERE Id = tmpId;

   -- сохранили протокол - "изменение EndDate"
   PERFORM lpInsert_ObjectHistoryProtocol (ObjectHistory.ObjectId, inUserId, StartDate, EndDate, ObjectHistoryFloat_Value.ValueData)
   FROM ObjectHistory
        LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                     ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory.Id
                                    AND ObjectHistoryFloat_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
   WHERE ObjectHistory.Id = tmpId;


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
  lEndDate := COALESCE (lEndDate, zc_DateEnd());

  IF COALESCE(ioId, 0) = 0
  THEN
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
     -- сохранили протокол - "изменение EndDate"
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
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 19.10.15                                        * add сохранили протокол
 19.10.15                                        * add inUserId
 07.12.14                                        * add удалили "другой" элемент т.к. у него такие же параметры
 01.01.13                        *
*/
