-- Function: gpUpdateMovement_Close()

DROP FUNCTION IF EXISTS gpUpdateMovement_SheetWorkTimeClose_CloseAll (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_SheetWorkTimeClose_CloseAll(
    IN ioId                  Integer   , -- Ключ объекта <Документ>
 INOUT inisClosedAll         Boolean   , -- Все табеля закрыты
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Boolean 
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_SheetWorkTimeClose_CloseAll());

     -- определили признак
     inisClosedAll:= NOT inisClosedAll;

     -- сохранили свойство
    -- PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_ClosedAll(), ioId, inisClosedAll);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.02.24         * 
*/


-- тест
-- SELECT * FROM gpUpdateMovement_SheetWorkTimeClose_CloseAll (ioId:= 275079, inClose:= 'False', inSession:= '2')
