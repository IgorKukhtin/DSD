-- Function: gpDelete_LockUnique_byUnion()

DROP FUNCTION IF EXISTS gpDelete_LockUnique_byUnion (TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_LockUnique_byUnion(
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
 20.10.18         *
*/

-- тест
-- SELECT * FROM gpDelete_LockUnique_byUnion (inSession:= '2')
