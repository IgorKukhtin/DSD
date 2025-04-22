-- Function: gpUnComplete_Movement_StatusId_next (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_StatusId_next (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_StatusId_next(
    IN inMovementId                Integer  , -- ключ объекта <Документ>
    IN inSession                   TVarChar   -- текущий пользователь
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_UnComplete_Movement());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!выход!!!
     IF EXISTS (SELECT 1 FROM Movement WHERE Id = inMovementId AND StatusId_next = zc_Enum_Status_UnComplete() /*AND StatusId = zc_Enum_Status_Complete()*/) THEN RETURN; END IF;


     -- 1.1. теперь он Не проведен
     UPDATE Movement SET StatusId = zc_Enum_Status_UnComplete() /*, StatusId_next = zc_Enum_Status_UnComplete()*/ WHERE Movement.Id = inMovementId;
     -- 1.2. Удаляем все проводки
     PERFORM lpDelete_MovementItemContainer (inMovementId);
     -- 1.3. Удаляем все проводки для отчета
     PERFORM lpDelete_MovementItemReport (inMovementId);

     -- 2. сохранили протокол
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.04.25                                        *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement_StatusId_next (inMovementId:= 55, inSession:= '5')
