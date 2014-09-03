-- Function: gpInsertUpdate_1CMoneyLoad()

DROP FUNCTION IF EXISTS gpInsertUpdate_1CMoneyLoad(Integer, TVarChar, TDateTime, 
    Integer, TVarChar, TFloat, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_1CMoneyLoad(
    IN inUnitId Integer, 
    IN inInvNumber TVarChar,
    IN inOperDate TDateTime, 
    IN inClientCode Integer, 
    IN inClientName TVarChar, 
    IN inSummaIn TFloat, 
    IN inSummaOut TFloat,
    IN inBranchId Integer,
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS VOID AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
--     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_BankAccount());
    
     IF inBranchId <> zfGetBranchFromUnitId(inUnitId) THEN
        RAISE EXCEPTION 'Филиал в файле не соответсвует выбранному филиалу';
     END IF;
    
        INSERT INTO Money1C (UnitId, InvNumber, OperDate, ClientCode, ClientName, SummaIn, SummaOut)
             VALUES(inUnitId, inInvNumber, inOperDate, inClientCode, inClientName, inSummaIn, inSummaOut);

     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 01.09.14                        * 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_1CMoneyLoad (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
