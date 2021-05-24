-- Function: gpUpdate_MovementBoolean_Document()

DROP FUNCTION IF EXISTS gpUpdate_MovementBoolean_Document (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementBoolean_Document(
    IN ioId                  Integer   , -- Ключ объекта <Документ>
 INOUT inDocument             Boolean   , -- Проверен
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
     inDocument:= NOT inDocument;

     -- сохранили свойство
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Document(), ioId, inDocument);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 18.08.14                                        * add lpInsert_MovementProtocol
*/


-- тест
-- SELECT * FROM gpUpdate_MovementBoolean_Document (ioId:= 275079, inDocument:= 'False', inSession:= '2')
