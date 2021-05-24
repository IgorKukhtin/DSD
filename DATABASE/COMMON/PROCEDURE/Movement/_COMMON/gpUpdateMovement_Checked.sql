-- Function: gpUpdateMovement_Checked()

DROP FUNCTION IF EXISTS gpUpdateMovement_Checked (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_Checked(
    IN ioId                  Integer   , -- Ключ объекта <Документ>
 INOUT inChecked             Boolean   , -- Проверен
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Boolean 
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);  --  lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale());

     -- определили признак
     inChecked:= NOT inChecked;

     -- сохранили свойство
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), ioId, inChecked);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 15.08.14                                        * add lpInsert_MovementProtocol
 20.07.14                                        * all
 09.07.14         * 
*/


-- тест
-- SELECT * FROM gpUpdateMovement_Checked (ioId:= 275079, inChecked:= 'False', inSession:= '2')
