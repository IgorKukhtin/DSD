-- Function: gpInsertUpdate_Object_PrintGrid ()
--универсально, что б можно было использовать  для всех форм
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PrintGrid (Integer, Integer, TFloat, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PrintGrid(
    IN inObjectId          Integer,
    IN inReportKindId      Integer,
    IN inValue             TFloat ,
    IN inValueDate         TDateTime,
    IN inSession           TVarChar      -- сессия пользователя
)
RETURNS void
AS
$BODY$
  DECLARE vbUserId      Integer;
  DECLARE vbInsertDate  TDateTime;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);

   -- !!!СНАЧАЛА удаляем данные по Пользователю БОЛЬШЕ чем за 7 дней!!!
   --DELETE FROM Object_Print WHERE UserId = vbUserId;
   
   -- Создаем с текущей Дата/время
   vbInsertDate := CURRENT_TIMESTAMP;
   
   IF NOT EXISTS (SELECT 1 
                  FROM Object_Print 
                  WHERE (Object_Print.UserId = vbUserId) 
                    AND Object_Print.ObjectId = inObjectId)
   THEN
       -- добавили элемент
       INSERT INTO Object_Print (ObjectId, ReportKindId, UserId, Value, ValueDate, InsertDate)
                        VALUES (inObjectId
                              , inReportKindId
                              , vbUserId 
                              , inValue     ::TFloat
                              , inValueDate ::TDateTime
                              , vbInsertDate);
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.09.24         *
*/

-- тест
--