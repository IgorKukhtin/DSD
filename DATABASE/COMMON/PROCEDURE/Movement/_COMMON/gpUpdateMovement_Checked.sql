-- Function: gpInsertUpdate_Movement_Sale()

DROP FUNCTION IF EXISTS gpUpdateMovement_Checked (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_Checked(
    IN ioId                  Integer   , -- Ключ объекта <Документ>
    IN inChecked             Boolean   , -- Проверен
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS void 
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= inSession;  --  lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale());

  
     -- определяем признак проверки
     IF inChecked = True
     THEN
         -- меняем свойство <Проверен> на ложь
         PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), ioId, False);

            
     ELSE
         -- меняем свойство <Проверен> на правду
         PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), ioId, True);
         
     END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 09.07.14         * 
*/


-- тест
-- SELECT * FROM gpUpdateMovement_Checked (ioId:= 275079, inChecked:= 'False', inSession:= '2')
