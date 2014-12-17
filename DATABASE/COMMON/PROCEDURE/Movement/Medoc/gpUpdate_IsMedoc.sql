-- Function: gpInsert_EDIFiles()

DROP FUNCTION IF EXISTS gpUpdate_IsMedoc(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_IsMedoc(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inSession             TVarChar     -- Пользователь
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EDI());
   vbUserId := lpGetUserBySession(inSession);

   PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_Medoc(), inMovementId, true);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.12.14                         * 

*/

-- тест
-- SELECT * FROM gpUpdate_IsMedoc (ioId:= 0, inSession:= '2')
