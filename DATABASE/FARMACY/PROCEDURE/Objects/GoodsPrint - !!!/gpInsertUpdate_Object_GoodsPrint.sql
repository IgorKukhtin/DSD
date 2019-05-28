-- Function: gpInsertUpdate_Object_GoodsPrint (Integer, Integer, Integer, Integer, TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsPrint (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsPrint(
    IN inUnitId            Integer,      --
    IN inGoodsId           Integer,      --
    IN inSession           TVarChar      -- сессия пользователя
)
RETURNS void
AS
$BODY$
  DECLARE vbUserId      Integer;
  DECLARE vbInsertDate  TDateTime;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= inSession;

   -- !!!СНАЧАЛА удаляем данные ВСЕХ Пользователей БОЛЬШЕ чем за 7 дней!!!
   --DELETE FROM Object_GoodsPrint WHERE InsertDate < CURRENT_DATE - INTERVAL '7 DAY';
   
   -- Создаем с текущей Дата/время
   vbInsertDate := CURRENT_TIMESTAMP;
   
   IF NOT EXISTS (SELECT 1 
                  FROM Object_GoodsPrint 
                  WHERE (Object_GoodsPrint.UnitId = inUnitId OR inUnitId = 0) 
                    AND Object_GoodsPrint.GoodsId = inGoodsId 
                    AND Object_GoodsPrint.UserId = vbUserId)
   THEN
       -- добавили элемент
       INSERT INTO Object_GoodsPrint (UnitId, GoodsId, UserId, InsertDate)
                              VALUES (inUnitId, inGoodsId, vbUserId, vbInsertDate);
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.05.19         *
*/

-- тест
--