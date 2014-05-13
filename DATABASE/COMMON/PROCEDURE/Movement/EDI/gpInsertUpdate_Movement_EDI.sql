-- Function: gpInsertUpdate_Movement_EDI()

-- DROP FUNCTION gpInsertUpdate_Movement_EDI (Integer, TVarChar, TDateTime, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_EDI(
   OUT outId                 Integer   , -- Ключ объекта <Документ Перемещение>
    IN inOrderInvNumber      TVarChar  , -- Номер документа
    IN inOrderOperDate       TDateTime , -- Дата документа
    IN inSaleInvNumber       TVarChar  , -- Номер документа
    IN inSaleOperDate        TDateTime , -- Дата документа


    IN inGLN                 TVarChar   , -- От кого (в документе)
    IN inOKPO                TVarChar   , -- От кого (в документе)
 
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EDI());
     vbUserId := inSession;

     SELECT Id INTO outId 
       FROM Movement WHERE DescId = zc_Movement_EDI() AND OperDate = inOrderOperDate AND InvNumber = inOrderInvNumber;

     -- сохранили <Документ>
     IF COALESCE(outId, 0) = 0 THEN
        outId := lpInsertUpdate_Movement (outId, zc_Movement_EDI(), inOrderInvNumber, inOrderOperDate, NULL);
     END IF;

     -- сохранили связь с <От кого (в документе)>
--     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- сохранили связь с <Кому (в документе)>
  --   PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);

     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.05.14                         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_EDI (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inFromId:= 1, inToId:= 2, inSession:= '2')
