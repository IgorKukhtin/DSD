-- Function: gpInsertUpdate_Object_Print ()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Print (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Print(
    IN inId            Integer,      --
    IN inAmount        Integer ,      --
    IN inSession       TVarChar      -- сессия пользователя
)
RETURNS void
AS
$BODY$
  DECLARE vbUserId      Integer;
  DECLARE vbInsertDate  TDateTime;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);

   -- !!!СНАЧАЛА удаляем данные ВСЕХ Пользователей БОЛЬШЕ чем за 7 дней!!!
   --DELETE FROM ObjectPrint WHERE InsertDate < CURRENT_DATE - INTERVAL '7 DAY';
   
   -- Создаем с текущей Дата/время
   vbInsertDate := CURRENT_TIMESTAMP;
   
   IF NOT EXISTS (SELECT 1 
                  FROM ObjectPrint 
                  WHERE (ObjectPrint.UserId = vbUserId) 
                    AND ObjectPrint.ObjectId = inId)
   THEN
       -- добавили элемент
       INSERT INTO ObjectPrint (ObjectId, UserId, Amount, InsertDate)
                        VALUES (inId, vbUserId, inAmount, vbInsertDate);
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.05.20         *
*/

-- тест
--