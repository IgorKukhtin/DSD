-- Function: gpUpdate_Movement_ReportUnLiquid_Comment()

DROP FUNCTION IF EXISTS gpUpdate_Movement_ReportUnLiquid_Comment (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_ReportUnLiquid_Comment (
    IN inId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inComment             TVarChar  , -- Примечание
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ReportUnLiquid());
     vbUserId := inSession;

     -- Примечание
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), inId, inComment);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.11.18         *
*/

-- тест
--