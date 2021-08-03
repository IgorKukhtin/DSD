-- gpUpdate_Movement_Tax_DisableNPP_auto()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Tax_DisableNPP_auto (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Tax_DisableNPP_auto (
    IN inId                  Integer   , -- Ключ объекта <Документ Перемещение>
 INOUT ioIsDisableNPP_auto   Boolean   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Movement_Tax());

     -- Проверка
     IF NOT EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inId AND Movement.StatusId = zc_Enum_Status_UnComplete())
     THEN
          RAISE EXCEPTION 'Ошибка.Документ в статусе <%>.', lfGet_Object_ValueData_sh ((SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inId));
     END IF;
     
     -- 
     ioIsDisableNPP_auto := NOT ioIsDisableNPP_auto;

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_DisableNPP_auto(), inId, ioIsDisableNPP_auto);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.08.21                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_Movement_Tax_DisableNPP_auto (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inDateRegistered:= '01.01.2013', inRegistered:= FALSE, inContractId:= 1, inSession:= '2')
