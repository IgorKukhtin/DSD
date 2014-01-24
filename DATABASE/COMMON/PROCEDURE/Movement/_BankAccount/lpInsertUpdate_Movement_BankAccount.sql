-- Function: gpInsertUpdate_Movement_BankAccount()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_BankAccount(Integer, TVarChar, TDateTime, TFloat, Integer,
                      Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_BankAccount(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inAmount              TFloat    , -- Сумма операции 

    IN inBankAccountId       Integer   , -- Расчетный счет 	
    IN inComment             TVarChar  , -- Комментарий 
    IN inMoneyPlaceId        Integer   , -- Юр лицо, счет, касса  	
    IN inContractId          Integer   , -- Договора
    IN inInfoMoneyId         Integer   , -- Статьи назначения 
    IN inUnitId              Integer   , -- Подразделение
    IN inCurrencyId          Integer   , -- Валюта 
    IN inParentId            Integer   DEFAULT  NULL
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbMovementItemId Integer;
BEGIN

     -- проверка (для юр.лица только)
     IF COALESCE (inContractId, 0) = 0 AND EXISTS (SELECT Id FROM Object WHERE Id = inMoneyPlaceId AND DescId = zc_Object_Juridical())
     THEN
        RAISE EXCEPTION 'Ошибка.<№ договора> не выбран.';
     END IF;

     -- проверка
     IF COALESCE (inInfoMoneyId, 0) = 0
     THEN
        RAISE EXCEPTION 'Ошибка.<УП статья назначения> не выбранр.';
     END IF;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_BankAccount(), inInvNumber, inOperDate, inParentId);

     -- определяем <Элемент документа>
     SELECT MovementItem.Id INTO vbMovementItemId FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Master();

     -- сохранили <Элемент документа>
     vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), inBankAccountId, ioId, inAmount, NULL);

     -- сохранили связь с <Объект>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_MoneyPlace(), vbMovementItemId, inMoneyPlaceId);
    
     -- Комментарий
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), vbMovementItemId, inComment);

     -- сохранили связь с <Управленческие статьи>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), vbMovementItemId, inInfoMoneyId);
     -- сохранили связь с <Договора>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), vbMovementItemId, inContractId);
     -- сохранили связь с <Подразделением>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), vbMovementItemId, inUnitId);
     -- сохранили связь с <Валютой>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Currency(), vbMovementItemId, inCurrencyId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 15.01.14                         *
 06.12.13                         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_BankAccount (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
