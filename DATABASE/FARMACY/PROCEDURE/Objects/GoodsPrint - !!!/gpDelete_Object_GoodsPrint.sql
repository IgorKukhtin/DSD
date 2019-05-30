-- Function: gpDelete_Object_GoodsPrint (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpDelete_Object_GoodsPrint (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_Object_GoodsPrint(
    IN inUnitId            Integer,
    IN inSession           TVarChar      -- сессия пользователя
)
RETURNS Void
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);


   -- !!!СНАЧАЛА удаляем данные ВСЕХ Пользователей БОЛЬШЕ чем за 7 дней!!!
   --DELETE FROM Object_GoodsPrint 
   --WHERE InsertDate < CURRENT_DATE - INTERVAL '7 DAY';


   -- удаляем все элементы для текущего пользователя
   DELETE 
   FROM Object_GoodsPrint 
   WHERE Object_GoodsPrint.UserId = vbUserId
     AND (Object_GoodsPrint.UnitId = inUnitId OR inUnitId = 0);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
27.05.19          *
*/

-- тест
--