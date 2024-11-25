-- Function: gpUpdateMovement_Electron()

DROP FUNCTION IF EXISTS gpUpdateMovement_Electron (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_Electron(
    IN ioId                  Integer   , -- Ключ объекта <Документ>
 INOUT inElectron            Boolean   , -- Проверен
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Boolean 
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Tax_Electron());

    -- проверка
     IF COALESCE (ioId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка. Не установлен налоговый документ.';
     END IF;

     -- определили признак
     inElectron:= NOT inElectron;

     -- сохранили свойство
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Electron(), ioId, inElectron);
  
     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, FALSE);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 15.08.14                                        *
*/


-- тест
-- SELECT * FROM gpUpdateMovement_Electron (ioId:= 275079, inElectron:= 'False', inSession:= '2')
