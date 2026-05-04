-- Function: gpUpdate_Movement_Send_isKh()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Send_isKh (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Send_isKh(
    IN inId                      Integer   , -- Ключ объекта <Документ Перемещение>
    IN inisKh                    Boolean   , -- Кухня
   OUT outisKh               Boolean   , --
    IN inSession                 TVarChar    -- сессия пользователя
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Send_isKh());

     outisKh := NOT inisKh;
     -- сохранили
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isKh(), inId, outisKh);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.05.26         *
*/

-- тест
--