-- gpInsertUpdate_Movement_Income_Params()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Income_Params (Integer, TVarChar, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Income_Params (
 INOUT ioId                            Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber                     TVarChar  , -- Номер документа
    IN inOperDate                      TDateTime , -- Дата документа
    IN inMovementId_Transport          Integer   , -- Договора
    IN inSession                       TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Income());

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Income(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- сохранили связь с документом <Транспорт>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Transport(), ioId, inMovementId_Transport);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, FALSE);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 01.09.15         * 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Income_Params (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inDateRegistered:= '01.01.2013', inRegistered:= FALSE, inContractId:= 1, inSession:= '2')
