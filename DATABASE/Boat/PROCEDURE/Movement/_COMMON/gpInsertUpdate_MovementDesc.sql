-- Function: gpInsertUpdate_MovementDesc()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementDesc (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementDesc(
    IN inId                  Integer   , -- Ключ объекта 
    IN inFormId              Integer   , -- Форма
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_DescId());
     vbUserId:= lpGetUserBySession (inSession);

     -- опредили
     IF inFormId = 0 THEN
        inFormId = NULL;
     END IF;

     -- сохранили
     UPDATE MovementDesc SET FormId = inFormId WHERE Id = inId;
     
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 25.05.14                                        * del lpInsert_MovementProtocol
 10.05.14                                        * add lpInsert_MovementProtocol
 24.01.14                          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementDesc (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
