-- gpUpdate_Movement_ProductionUnion_Order()

DROP FUNCTION IF EXISTS gpUpdate_Movement_ProductionUnion_Order (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_ProductionUnion_Order (
    IN inId                        Integer   , -- Ключ объекта <Документ>
    IN inMovementId_Order          Integer   , -- 
    IN inSession                   TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProductionUnion());

     -- сохранили связь с документом <заявка>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Order(), inId, inMovementId_Order);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 31.05.17         * 
*/

-- тест
-- SELECT * FROM gpUpdate_Movement_ProductionUnion_Order (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inDateRegistered:= '01.01.2013', inRegistered:= FALSE, inContractId:= 1, inSession:= '2')
