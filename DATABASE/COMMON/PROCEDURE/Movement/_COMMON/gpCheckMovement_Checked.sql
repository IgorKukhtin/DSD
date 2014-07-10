-- Function: gpInsertUpdate_Movement_Sale()

DROP FUNCTION IF EXISTS gpCheckMovement_Checked (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpCheckMovement_Checked(
 INout ioId                  Integer   , -- Ключ объекта <Документ>
    IN inChecked             Boolean   , -- Проверен
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer 
AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbUserId Integer;
BEGIN
     -- проверка
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= inSession;  -- lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale());

  
     -- определяем признак проверки
     IF inChecked = True
     THEN
         -- меняем свойство <Проверен> на ложь
         PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), ioId, False);

            
     ELSE
         -- меняем свойство <Проверен> на правду
         PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), ioId, True);
         
     END IF;

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 09.07.14         * 
*/


-- тест
-- SELECT * FROM gpCheckMovement_Checked (ioId:= 275079, inChecked:= 'False', inSession:= '2')
