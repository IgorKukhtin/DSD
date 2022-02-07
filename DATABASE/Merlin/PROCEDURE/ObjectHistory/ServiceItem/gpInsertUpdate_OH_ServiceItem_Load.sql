--
DROP FUNCTION IF EXISTS gpInsertUpdate_OH_ServiceItem_Load (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_OH_ServiceItem_Load (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TDateTime, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_OH_ServiceItem_Load(
    IN inId                   Integer,       -- 
    IN inCommentInfoMoneyCode Integer,
    IN inInfoMoneyCode        Integer,
    IN inUnitCode             Integer,
    IN inUserId               Integer,       -- Id пользователя
    IN inValueArea            TFloat,        --
    IN inPrice_byArea         TFloat,        --
    IN inSumma_byArea         TFloat,        --
    IN inStartDate            TDateTime,     -- 
    IN inEndDate              TDateTime,     -- 
    IN inProtocolDate         TDateTime,     -- дата протокола
    IN inSession              TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId           Integer;
  DECLARE vbUserProtocolId   Integer;
  DECLARE vbCommentInfoMoneyId Integer;
  DECLARE vbInfoMoneyId      Integer;
  DECLARE vbUnitId        Integer;
  DECLARE vbMovementId       Integer;
  DECLARE vbMovementItemId   Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);

   vbUserProtocolId := CASE WHEN inUserId = 1 THEN 5
                            WHEN inUserId = 6 THEN 139  -- zfCalc_UserMain_1()
                            WHEN inUserId = 7 THEN 2020 -- zfCalc_UserMain_2()
                            WHEN inUserId = 10 THEN 40561
                            WHEN inUserId = 11 THEN 40562
                       END;

       IF COALESCE (inCommentInfoMoneyCode,0) <> 0
       THEN
           -- поиск в спр. 
           vbCommentInfoMoneyId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_CommentInfoMoney() AND Object.ObjectCode = inCommentInfoMoneyCode);
    
           -- Eсли не нашли ошибка
           IF COALESCE (vbCommentInfoMoneyId,0) = 0
           THEN
               RAISE EXCEPTION 'Ошибка.Не найден элемент справочника Примечание Приход/расход с кодом <%>   .', inCommentInfoMoneyCode;
           END IF;
       END IF;
    
       IF COALESCE (inInfoMoneyCode,0) <> 0
       THEN
           -- поиск в спр.
           vbInfoMoneyId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_InfoMoney() AND Object.ObjectCode = inInfoMoneyCode);
    
           -- Eсли не нашли ошибка
           IF COALESCE (vbInfoMoneyId,0) = 0
           THEN
               RAISE EXCEPTION 'Ошибка.Не найден элемент справочника Статья с кодом <%>   .', inInfoMoneyCode;
           END IF;
       END IF;
    
       IF COALESCE (inUnitCode,0) <> 0
       THEN
           -- поиск в спр.
           vbUnitId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Unit() AND Object.ObjectCode = inUnitCode);
    
           -- Eсли не нашли ошибка
           IF COALESCE (vbUnitId,0) = 0
           THEN
               RAISE EXCEPTION 'Ошибка.Не найден элемент справочника Отделы с кодом <%>   .', inUnitCode;
           END IF;
       END IF; 
       
       --IF NOT EXISTS (SELECT 1 FROM ObjectHistory WHERE ObjectHistory.Id = inId)
       --THEN
          -- Сохранили историю
       --inId := lpInsertUpdate_ObjectHistory (inId, zc_ObjectHistory_ServiceItem(), vbUnitId, inStartDate, vbUserProtocolId);
       INSERT INTO ObjectHistory (Id, DescId, ObjectId, StartDate, EndDate)
                    VALUES (inId, zc_ObjectHistory_ServiceItem(), vbUnitId, inStartDate, inEndDate);
    
       -- Сохранили 
       PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_ServiceItem_Area(), inId, inValueArea);
       -- Сохранили 
       PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_ServiceItem_Price(), inId, inPrice_byArea);
       -- Сохранили 
       PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_ServiceItem_Value(), inId, inSumma_byArea);
    
    
       -- Сохранили статью
       PERFORM lpInsertUpdate_ObjectHistoryLink (zc_ObjectHistoryLink_ServiceItem_InfoMoney(), inId, vbInfoMoneyId);
       -- Сохранили примечание
       PERFORM lpInsertUpdate_ObjectHistoryLink (zc_ObjectHistoryLink_ServiceItem_CommentInfoMoney(), inId, vbCommentInfoMoneyId);

--RAISE EXCEPTION 'Ошибка.Не найден элемент справочника Отделы с кодом <%>   <%>.', inStartDate, inEndDate;

       /*UPDATE ObjectHistory 
       SET StartDate = inStartDate, EndDate = inEndDate
       WHERE Id = inId;
       */
       -- сохранили свойство <Дата создания>
       --PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), inId, inProtocolDate ::TDateTime);
       -- сохранили свойство <Пользователь (создание)>
       --PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), inId, vbUserProtocolId);
       
       --END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.02.21          *
*/

-- тест
--