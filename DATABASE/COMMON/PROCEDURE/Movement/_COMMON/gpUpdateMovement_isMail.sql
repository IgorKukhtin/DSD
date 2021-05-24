-- Function: gpUpdateMovement_isMail()

DROP FUNCTION IF EXISTS gpUpdateMovement_isMail (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdateMovement_isMail (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_isMail(
    IN inId                  Integer   , -- Ключ объекта <Документ>
-- INOUT inIsMail              Boolean   , -- Отправлен по почте (да/нет)
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID 
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);  --  lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale());

     -- определили признак
     -- inIsMail:= NOT inIsMail;

     -- сохранили свойство
     -- PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Mail(), inId, inIsMail);
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Mail(), inId, TRUE);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.03.19                                        *
*/


-- тест
-- SELECT * FROM gpUpdateMovement_isMail (inId:= 275079, inIsMail:= FALSE, inSession:= zfCalc_UserAdmin())
