-- Function: gpUpdate_MovementDate_Message()

DROP FUNCTION IF EXISTS gpUpdate_MovementDate_Message (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementDate_Message(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
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

     -- сохранили свойство
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Message(), inMovementId, CURRENT_TIMESTAMP);

  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.09.22                                        *
*/


-- тест
-- SELECT * FROM gpUpdate_MovementDate_Message (ioId:= 275079, inSession:= '2')
