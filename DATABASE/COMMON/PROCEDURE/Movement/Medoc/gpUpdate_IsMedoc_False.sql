-- Function: gpInsert_EDIFiles()

DROP FUNCTION IF EXISTS gpUpdate_IsMedoc_False (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_IsMedoc_False(
   OUT onisMedoc             Boolean   , -- Не медок
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inSession             TVarChar     -- Пользователь
)                              
RETURNS Boolean AS --VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EDI());
   vbUserId := lpGetUserBySession(inSession);

   PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_Medoc(), inMovementId, false);
   
   onisMedoc := False;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.02.15         *

*/

-- тест
-- SELECT * FROM gpUpdate_IsMedoc_False (ioId:= 0, inSession:= '2')
