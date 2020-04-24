-- Function: gpInsertUpdate_Movement_Send_Order()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Send_Order (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Send_Order(
    IN inId                      Integer   , -- Ключ объекта <Документ Перемещение>
    IN inMovementId_Order        Integer   , -- заявка
    IN inSession                 TVarChar    -- сессия пользователя
)
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Send());

     -- сохранили связь с документом <Заявки сторонние>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Order(), inId, inMovementId_Order);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.04.20         *
*/

-- тест
-- 