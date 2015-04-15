-- Function: gpUpdateMovement_isCopy()

DROP FUNCTION IF EXISTS gpUpdateMovement_isCopy (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_isCopy(
    IN ioId                  Integer   , -- Ключ объекта <Документ>
    IN inIsCopy              Boolean   , -- 
   OUT outIsCopy             Boolean   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Boolean 
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UpdateMovement_isCopy());

     -- определили признак
     outIsCopy:= NOT inIsCopy;

     -- сохранили свойство
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isCopy(), ioId, outIsCopy);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 15.08.14         * 
*/

-- тест
-- SELECT * FROM gpUpdateMovement_isCopy (ioId:= 275079, inIsCopy:= 'False', inSession:= '2')
