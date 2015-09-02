-- gpUpdate_Movement_Income_Transport()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Income_Transport (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Income_Transport (
    IN inId                            Integer   , -- Ключ объекта <Документ>
    IN inMovementId_Transport          Integer   , -- 
    IN inSession                       TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Income_Transport());

     -- сохранили связь с документом <Транспорт>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Transport(), inId, inMovementId_Transport);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 01.09.15         * 
*/

-- тест
-- SELECT * FROM gpUpdate_Movement_Income_Transport (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inDateRegistered:= '01.01.2013', inRegistered:= FALSE, inContractId:= 1, inSession:= '2')
