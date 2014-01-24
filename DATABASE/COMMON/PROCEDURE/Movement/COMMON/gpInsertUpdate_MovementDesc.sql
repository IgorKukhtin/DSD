-- Function: gpInsertUpdate_Movement_BankAccount()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementDesc(Integer, TVarChar, TDateTime, TFloat, TFloat, Integer,
                      TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementDesc(
    IN inId                  Integer   , -- Ключ объекта 
    IN inFormId              Integer   , -- Форма
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_BankAccount());
     IF inFormId = 0 THEN
        inFormId = NULL;
     END IF;

     UPDATE MovementDesc sET FormId = inFormId 
      WHERE Id = inId;

     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 24.01.14                          *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_BankAccount (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
