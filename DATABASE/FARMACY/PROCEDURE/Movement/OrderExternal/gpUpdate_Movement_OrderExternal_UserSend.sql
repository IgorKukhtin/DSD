-- Function: gpUpdate_Movement_OrderExternal_UserSend()

DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderExternal_UserSend (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Movement_OrderExternal_UserSend(
    IN inId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Void AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN

    vbUserId := inSession;

    -- сохранили свойство <Дата корректировки>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), inId, CURRENT_TIMESTAMP);
    -- сохранили свойство <Пользователь (корректировка)>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), inId, vbUserId);
    

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 20.09.16         *
 */

-- тест
-- SELECT * FROM gpUpdate_Movement_OrderExternal_UserSend (inId:= 0, inSession:= '2')
