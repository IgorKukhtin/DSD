-- Function: gpInsertUpdate_1CSaleLoad()

DROP FUNCTION IF EXISTS gpDelete_1CSale(TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_1CSale(IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS VOID AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
--     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_BankAccount());

     TRUNCATE TABLE Sale1C;

     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 30.01.14                          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_1CSaleLoad (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
