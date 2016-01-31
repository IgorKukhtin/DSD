-- Function: gpUpdateMovement_isDocument()

DROP FUNCTION IF EXISTS gpUpdateMovement_isDocument (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_isDocument(
    IN ioId                  Integer   , -- Ключ объекта <Документ>
 INOUT inisDocument             Boolean   , -- Проверен
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Boolean 
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= inSession;  

     -- определили признак
     inisDocument:= NOT inisDocument;

     -- сохранили свойство
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Document(), ioId, inisDocument);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
  30.01.16        * 
*/


-- тест
-- SELECT * FROM gpUpdateMovement_isDocument (ioId:= 275079, inisDocument:= 'False', inSession:= '2')
