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
   -- !!!обнулили!!!
   ioId:= COALESCE (ioId, 0);
   -- !!!Округляем дату!!!
   inEndDate:= DATE_TRUNC ('DAY', inEndDate);

   IF COALESCE (inObjectId, 0) = 0 
   THEN
       RAISE EXCEPTION 'Error. inObjectId = %', inObjectId;
   END IF;

   -- если его нет - попробуем найти
   IF ioId = 0
   THEN

     -- Ищем ioId - за тот же день, т.е. EndDate = inEndDate
     ioId:= COALESCE ((SELECT ObjectHistory.Id 
                       FROM ObjectHistory 
                       WHERE ObjectHistory.DescId = inDescId AND ObjectHistory.ObjectId = inObjectId AND ObjectHistory.EndDate = inEndDate
                      ), 0);

     -- Если такую запись нашли, то ее и будем менять
     IF COALESCE (ioId, 0) <> 0 THEN
        RETURN;
     END IF;

   ELSE
     -- Ищем любой Id, если он заканчмвается той же датой
     findId:= (SELECT ObjectHistory.Id
               FROM ObjectHistory
               WHERE ObjectHistory.DescId   = inDescId 
                 AND ObjectHistory.ObjectId = inObjectId
                 AND ObjectHistory.EndDate  = inEndDate
                
               );
     -- если это "другой" элемент
     IF findId > 0 AND findId <> ioId
     THEN
         -- сохранили протокол - "удаление"
         PERFORM lpInsert_ObjectHistoryProtocol (ObjectHistory.ObjectId, inUserId, ObjectHistory.StartDate, ObjectHistory.EndDate, ObjectHistoryFloat_Value.ValueData, TRUE, TRUE)
         FROM ObjectHistory
              LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                           ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory.Id
                                          AND ObjectHistoryFloat_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
         WHERE ObjectHistory.Id = findId;

         -- удалили "другой" элемент т.к. у него такие же параметры
         DELETE FROM ObjectHistoryDate   WHERE ObjectHistoryId = findId;
         DELETE FROM ObjectHistoryFloat  WHERE ObjectHistoryId = findId;
         DELETE FROM ObjectHistoryString WHERE ObjectHistoryId = findId;
         DELETE FROM ObjectHistoryLink   WHERE ObjectHistoryId = findId;
         DELETE FROM ObjectHistory       WHERE Id = findId;

     END IF;

  END IF;


   -- поиск следующего элемента относительно inEndDate
   tmpId:= (SELECT Id FROM ObjectHistory 
            WHERE ObjectHistory.DescId   = inDescId 
              AND ObjectHistory.ObjectId = inObjectId
              AND ObjectHistory.EndDate  > inEndDate
            -- находим Первый  
            ORDER BY ObjectHistory.EndDate ASC
            LIMIT 1
           );
   -- Здесь надо изменить св-во StartDate у следующего элемента относительно inEndDate
   UPDATE ObjectHistory SET StartDate = inEndDate + INTERVAL '1 DAY' WHERE Id = tmpId;

   -- сохранили протокол - "изменение StartDate"
   PERFORM lpInsert_ObjectHistoryProtocol (ObjectHistory.ObjectId, inUserId, StartDate, EndDate, ObjectHistoryFloat_Value.ValueData)
   FROM ObjectHistory
        LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                     ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory.Id
                                    AND ObjectHistoryFloat_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
   WHERE ObjectHistory.Id = tmpId;


  -- Если меняется запись, то надо запомнить следующий ИД - у него потом изменим StartDate
  IF ioId <> 0 THEN
     -- получаем дату текущего элемента
     lEndDate:= (SELECT EndDate FROM ObjectHistory WHERE Id = ioId);
     -- параметры следующего элемента относительно ioId
     SELECT Id, EndDate INTO vbNextId, lEndDate
     FROM ObjectHistory
     WHERE ObjectHistory.DescId    = inDescId
       AND ObjectHistory.ObjectId  = inObjectId
       AND ObjectHistory.EndDate   > lEndDate
     -- находим Первый  
     ORDER BY ObjectHistory.EndDate ASC
     LIMIT 1;
  END IF;

  lStartDate := NULL;

  -- Конечная дата предыдущего элемента относительно inEndDate
  lStartDate:= (SELECT EndDate + INTERVAL '1 DAY'
                FROM ObjectHistory
                WHERE ObjectHistory.DescId   = inDescId
                  AND ObjectHistory.ObjectId = inObjectId
                  AND ObjectHistory.EndDate  < inEndDate
                  AND ObjectHistory.Id       <> ioId
                -- находим Последний
                ORDER BY ObjectHistory.EndDate DESC
                LIMIT 1
               );

  -- расчет StartDate для текущего элемента: или конечная дата + 1 предыдущего элемента относительно inEndDate или минимальная дата
  lStartDate := COALESCE (lStartDate, DATE_TRUNC ('YEAR', inEndDate - INTERVAL '5 YEAR'));

  IF COALESCE(ioId, 0) = 0
  THEN
     -- дабавили текущий элемент: <ключ класса объекта> , <код объекта> , <данные> и вернули значение <ключа>
     INSERT INTO ObjectHistory (DescId, ObjectId, StartDate, EndDate)
            VALUES (inDescId, inObjectId, lStartDate, inEndDate) RETURNING Id INTO ioId;
  ELSE
     -- изменили текущий элемент по значению <ключа>: <код объекта>, <данные>
     UPDATE ObjectHistory SET StartDate = lStartDate, EndDate = inEndDate, ObjectId = inObjectId  WHERE Id = ioId;
     IF NOT found THEN
       -- дабавили текущий элемент: <ключ класса объекта>, <код объекта> , <данные> со значением <ключа>
       INSERT INTO ObjectHistory (Id, DescId, ObjectId, StartDate, EndDate)
                    VALUES (ioId, inDescId, inObjectId, lStartDate, inEndDate);
     END IF;
  END IF;


  -- если такой элемент был найден
  IF COALESCE (vbNextId, 0) <> 0
  THEN
     -- изменили StartDate у следующего элемента относительно ioId
     UPDATE ObjectHistory SET StartDate = COALESCE((SELECT EndDate + INTERVAL '1 DAY'  
                                                    FROM ObjectHistory
                                                    WHERE ObjectHistory.DescId    = inDescId 
                                                      AND ObjectHistory.ObjectId  = inObjectId
                                                      AND ObjectHistory.EndDate   < lEndDate
                                                    -- находим Последний
                                                    ORDER BY ObjectHistory.EndDate DESC
                                                    LIMIT 1
                                                   ), zc_DateStart())  
     WHERE Id = vbNextId;
     -- сохранили протокол - "изменение StartDate"
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
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 19.10.15                                        * add сохранили протокол
 19.10.15                                        * add inUserId
 07.12.14                                        * add удалили "другой" элемент т.к. у него такие же параметры
 01.01.13                        *
*/
