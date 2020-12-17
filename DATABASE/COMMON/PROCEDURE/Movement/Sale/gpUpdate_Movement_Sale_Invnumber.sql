-- Function: gpUpdate_Movement_Sale_Invnumber()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Sale_Invnumber (Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Movement_Sale_Invnumber(
    IN inId                    Integer    , -- Ключ объекта <Документ>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId_Tax Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Sale_Invnumber());

     -- сохранили <>
     UPDATE Movement SET InvNumber = inInvNumber WHERE Id = inId;

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.12.20         *
*/
-- тест
--