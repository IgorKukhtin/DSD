-- Function: gpInsertUpdate_Object_Print_byGrid ()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Print_byGrid (Integer, Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Print_byGrid(

    IN inMovementId        Integer,
    IN inGoodsId           Integer,
    IN inGoodsKindId       Integer, 
    IN inPartionGoodsDate  TDateTime,
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
                    AND Object_Print.ObjectId = inMovementId)
   THEN
       -- добавили элемент
       INSERT INTO Object_Print (ObjectId, ReportKindId, UserId, ValueDate, InsertDate)
                        VALUES (inMovementId
                              , inGoodsId
                              , vbUserId 
                              , inPartionGoodsDate
                              , vbInsertDate);
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.09.24         *
*/

-- тест
--