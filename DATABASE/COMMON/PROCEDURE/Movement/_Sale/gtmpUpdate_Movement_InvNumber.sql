-- Function: gtmpUpdate_Movement_InvNumber()

-- DROP FUNCTION gtmpUpdate_Movement_InvNumber (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gtmpUpdate_Movement_InvNumber(
    IN inId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     UPDATE Movement SET InvNumber = inInvNumber WHERE Id = inId;
     IF NOT found THEN
       RAISE EXCEPTION 'gtmpUpdate_Movement_InvNumber';
     END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.08.13                                        * эта процка только для Load_PostgreSql

*/

-- тест
-- SELECT * FROM gtmpUpdate_Movement_InvNumber (inId:= 0, inInvNumber:= '-1', inSession:= '2');
