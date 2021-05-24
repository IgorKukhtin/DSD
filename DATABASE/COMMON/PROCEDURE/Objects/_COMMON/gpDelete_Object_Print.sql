-- Function: gpDelete_Object_Print ()

DROP FUNCTION IF EXISTS gpDelete_Object_Print (TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_Object_Print(
    IN inSession       VarChar      -- сессия пользователя
)
RETURNS void
AS
$BODY$
  DECLARE vbUserId      Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);

   -- !!!удаляем данные по текущему пользователю
   DELETE FROM ObjectPrint WHERE ObjectPrint.UserId = vbUserId;
 
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