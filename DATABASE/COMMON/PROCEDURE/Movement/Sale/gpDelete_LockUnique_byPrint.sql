-- Function: gpDelete_LockUnique_byPrint()

DROP FUNCTION IF EXISTS gpDelete_LockUnique_byPrint (TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_LockUnique_byPrint(
    IN inSession         TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId   Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
      vbUserId:= lpGetUserBySession (inSession);

     -- Удаление того что сохранили ранее тек. пользователю
      DELETE FROM LockUnique WHERE UserId = vbUserId;
      
      
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.12.17         *
*/

-- тест
-- SELECT * FROM gpDelete_LockUnique_byPrint (inSession:= '2')
