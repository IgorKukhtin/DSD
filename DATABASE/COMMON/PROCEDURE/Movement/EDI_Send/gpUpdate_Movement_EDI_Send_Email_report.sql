-- Function: gpUpdate_Movement_EDI_Send_Email_report()

DROP FUNCTION IF EXISTS gpUpdate_Movement_EDI_Send_Email_report (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_EDI_Send_Email_report(
    IN inMovementId            Integer    , -- Ключ объекта <Документ для отправки в EDI>
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_EDI_Send_Email_report());
     vbUserId:= lpGetUserBySession (inSession);


     -- сохранили свойство <Дата/Время когда отправили Ошибку>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Sent(), inMovementId, CURRENT_TIMESTAMP);


     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 01.08.25                                        *

*/
-- тест
-- SELECT * FROM gpUpdate_Movement_EDI_Send_Email_report (inId:= 0, inSession:= '2')
