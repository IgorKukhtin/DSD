-- Function: gpDelete_Object_Print_byUser ()

DROP FUNCTION IF EXISTS gpDelete_Object_Print_byUser (TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_Object_Print_byUser(
    IN inSession           TVarChar      -- сессия пользователя
)
RETURNS void
AS
$BODY$
  DECLARE vbUserId      Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);

   --
   DELETE FROM Object_Print WHERE UserId = vbUserId;
   
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