-- Function: gpUpdateMovement_Invoice()

DROP FUNCTION IF EXISTS gpUpdateMovement_Invoice (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_Invoice(
    IN inId                   Integer   , -- Ключ объекта <Документ>
    IN inMovementId_Invoice   Integer   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Void 
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UpdateMovement_Invoice());

     -- сохранили связь с документом <Счет>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Invoice(), inId, inMovementId_Invoice);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 22.07.16         * 
*/

-- тест
-- SELECT * FROM gpUpdateMovement_Invoice (ioId:= 275079, inInvoice:= 'False', inSession:= '2')
