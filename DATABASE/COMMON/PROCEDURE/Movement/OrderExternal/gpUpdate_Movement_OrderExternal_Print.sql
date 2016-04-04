-- Function: gpUpdate_Movement_OrderExternal_Print()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderExternal_Print (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderExternal_Print (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderExternal_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_OrderExternal_Print(
    IN inId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inNewPrinted          Boolean   , --
   OUT outPrinted            Boolean   , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderExternal());
     vbUserId:= lpGetUserBySession (inSession);

     -- определили признак
--     inChecked:= NOT inChecked;
--     IF COALESCE(ioPrinted, True) THEN ioPrinted := True; ELSE ioPrinted:= False; END IF;
     outPrinted := inNewPrinted;

     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Print(), inId, inNewPrinted);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 06.02.15                                                       *
 05.02.15                                                       *
 04.02.15                                                       *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_OrderExternal_Print (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inOperDateMark:= '01.01.2013', inInvNumberPartner:= 'xxx', inFromId:= 1, inPersonalId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')