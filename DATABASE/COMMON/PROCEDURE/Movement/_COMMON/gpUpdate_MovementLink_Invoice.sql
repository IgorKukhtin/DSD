-- Function: gpUpdate_MovementLink_Invoice()

DROP FUNCTION IF EXISTS gpUpdate_MovementLink_Invoice (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementLink_Invoice(
    IN inId                   Integer   , -- Ключ объекта <Документ>
    IN inMovementId_Invoice   Integer   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Void 
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     IF inMovementId_Invoice <> 0
     THEN
         -- проверка прав пользователя на вызов процедуры
         vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_MovementLink_Invoice());

         -- сохранили связь с документом <Счет>
         PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Invoice(), inId, inMovementId_Invoice);

         -- сохранили протокол
         PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

     END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 22.07.16         * 
*/

-- тест
-- SELECT * FROM gpUpdate_MovementLink_Invoice (ioId:= 275079, inInvoice:= 'False', inSession:= '2')
