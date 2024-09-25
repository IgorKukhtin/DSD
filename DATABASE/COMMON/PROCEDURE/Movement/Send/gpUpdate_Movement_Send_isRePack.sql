-- Function: gpUpdate_Movement_Send_isRePack()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Send_isRePack (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Send_isRePack(
    IN inId                      Integer   , -- Ключ объекта <Документ Перемещение>
    IN inisRePack                Boolean   , -- 
   OUT outisRePack               Boolean   , -- 
    IN inSession                 TVarChar    -- сессия пользователя
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Send_isRePack());

     outisRePack := NOT inisRePack;
     -- сохранили связь с документом <Заявки сторонние>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isRePack(), inId, outisRePack);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.09.24         *
*/

-- тест
-- 