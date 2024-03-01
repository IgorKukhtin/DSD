-- Function: gpUpdate_Movement_SheetWorkTimeClose_Unit()

DROP FUNCTION IF EXISTS gpUpdate_Movement_SheetWorkTimeClose_Unit (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_SheetWorkTimeClose_Unit(
    IN inId                  Integer   , -- Ключ объекта <Документ>
    IN inUnitId              Integer   , -- Подразделение(Исключение)
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_SheetWorkTimeClose());

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), inId, inUnitId);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.02.24         *
*/

-- тест
--