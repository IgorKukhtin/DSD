-- Function: gpUpdateMovement_isList()

DROP FUNCTION IF EXISTS gpUpdateMovement_isList (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_isList(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inIsList              Boolean   , -- Отмечен
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);


     -- сохранили свойство
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_List(), inMovementId, inIsList);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.05.18                                        * 
*/


-- тест
-- SELECT * FROM gpUpdateMovement_isList (inMovementId:= 275079, inisList:= TRUE, inSession:= zfCalc_UserAdmin())
