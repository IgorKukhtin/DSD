-- Function: gpUpdate_Movement_Send_PersonalGroup()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Send_PersonalGroup (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Send_PersonalGroup(
    IN inId                      Integer   , -- Ключ объекта <Документ Перемещение>
    IN inPersonalGroupId         Integer   , -- № бригады
    IN inSession                 TVarChar    -- сессия пользователя
)
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Send_PersonalGroup());

     -- сохранили связь с документом <Заявки сторонние>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalGroup(), inId, inPersonalGroupId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.08.20         *
*/

-- тест
-- 