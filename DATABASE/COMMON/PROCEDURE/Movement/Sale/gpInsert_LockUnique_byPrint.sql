-- Function: gpInsert_LockUnique_byPrint()

DROP FUNCTION IF EXISTS gpInsert_LockUnique_byPrint (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_LockUnique_byPrint(
    IN inMovementId      Integer,    -- Id документа
    IN inSession         TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId   Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
      vbUserId:= lpGetUserBySession (inSession);

      -- сохраняем Ид документов  табл. LockUnique
      INSERT INTO LockUnique (KeyData, UserId, OperDate)
             VALUES (inMovementId :: TVarChar, vbUserId, CURRENT_DATE);   --CURRENT_TIMESTAMP

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.12.17         *
*/

-- тест
-- SELECT * FROM gpInsert_LockUnique_byPrint (inMovementId:= 56464, inSession:= '2')
