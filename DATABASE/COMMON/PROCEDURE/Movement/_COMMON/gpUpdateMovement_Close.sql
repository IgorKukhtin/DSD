-- Function: gpUpdateMovement_Close()

DROP FUNCTION IF EXISTS gpUpdateMovement_Close (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_Close(
    IN ioId                  Integer   , -- Ключ объекта <Документ>
 INOUT inisClosed            Boolean   , -- Проверен
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Boolean 
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);  --  lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale());

     -- определили признак
     inisClosed:= NOT inisClosed;

     -- сохранили свойство
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Closed(), ioId, inisClosed);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 05.05.17         * 
*/


-- тест
-- SELECT * FROM gpUpdateMovement_Close (ioId:= 275079, inClose:= 'False', inSession:= '2')
