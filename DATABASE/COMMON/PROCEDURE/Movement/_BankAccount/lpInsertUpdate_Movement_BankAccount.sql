-- Function: gpInsertUpdate_Movement_BankAccount()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_BankAccount(Integer, TVarChar, TDateTime, TFloat, Integer,
                      Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_BankAccount(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inAmount              TFloat    , -- Сумма операции 

    IN inBankAccountId       Integer   , -- От кого (в документе) -- Юридическое лицо, Расчетный счет 	
    IN inJuridicalId         Integer   , -- Кому (в документе)  -- Юридическое лицо, Расчетный счет 	
    IN inCurrencyId          Integer   , -- Валюта 
    IN inInfoMoneyId         Integer   , -- Статьи назначения 
    IN inBusinessId          Integer   , -- Бизнесс
    IN inContractId          Integer   , -- Договора
    IN inUnitId              Integer   , -- Подразделение
    IN inParentId            Integer   DEFAULT = NULL
)                              
RETURNS Integer AS
$BODY$
BEGIN


     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_BankAccount(), inInvNumber, inOperDate, inParentId);

     -- сохранили свойство <Сумма операции>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Amount(), ioId, inAmount);

     -- сохранили связь с <Банковский счет>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_BankAccount(), ioId, inBankAccountId);
     -- сохранили связь с <Юр лицом>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inJuridicalId);
     -- сохранили связь с <валютой>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inCurrencyId);
     -- сохранили связь с <Статьи назначения>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_InfoMoney(), ioId, inInfoMoneyId);
     -- сохранили связь с <Бизнесом>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Business(), ioId, inBusinessId);
     -- сохранили связь с <Договора>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);
     -- сохранили связь с <Подразделение>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.12.13                         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_BankAccount (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
