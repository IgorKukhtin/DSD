-- Function: gpInsertUpdate_Movement_BankAccount()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_BankAccount(Integer, TVarChar, TDateTime, TFloat, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_BankAccount(Integer, TVarChar, TDateTime, TFloat, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);

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
    IN inParentId            Integer   , -- 
    IN inUserId              Integer     -- Пользователь
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

     -- Проверка установки значений
     IF NOT EXISTS (SELECT InfoMoneyId FROM Object_InfoMoney_View WHERE InfoMoneyId = inInfoMoneyId AND (InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_21500() -- Маркетинг

                                                                                                                                 , zc_Enum_InfoMoneyDestination_30500() -- Прочие доходы

                                                                                                                                 , zc_Enum_InfoMoneyDestination_40100() -- Кредиты банков
                                                                                                                                 , zc_Enum_InfoMoneyDestination_40200() -- Прочие кредиты
                                                                                                                                 , zc_Enum_InfoMoneyDestination_40300() -- Овердрафт
                                                                                                                                 , zc_Enum_InfoMoneyDestination_40400() -- проценты по кредитам
                                                                                                                                 -- , zc_Enum_InfoMoneyDestination_40500() -- Ссуды
                                                                                                                                 , zc_Enum_InfoMoneyDestination_40600() -- Депозиты
                                                                                                                                 , zc_Enum_InfoMoneyDestination_40700() -- Лиол
                                                                                                                                 , zc_Enum_InfoMoneyDestination_40800() -- Внутренний оборот
                                                                                                                                 , zc_Enum_InfoMoneyDestination_40900() -- Финансовая помощь

                                                                                                                                 , zc_Enum_InfoMoneyDestination_50100() -- Налоговые платежи по ЗП
                                                                                                                                 , zc_Enum_InfoMoneyDestination_50200() -- Налоговые платежи
                                                                                                                                 , zc_Enum_InfoMoneyDestination_50300() -- Налоговые платежи (прочие)
                                                                                                                                 , zc_Enum_InfoMoneyDestination_50400() -- штрафы в бюджет
                                                                                                                                  )
                                                                                                         OR InfoMoneyId = zc_Enum_InfoMoney_21419() -- Штрафы за недовоз
                                                                                                        )
                    )
        -- AND EXISTS (SELECT Id FROM gpGet_Movement_BankStatementItem (inMovementId:= ioId, inSession:= inSession) WHERE ContractId = inContractId)
        AND NOT EXISTS (SELECT ContractId FROM Object_Contract_View WHERE ContractId = inContractId AND InfoMoneyId = inInfoMoneyId)
        AND NOT EXISTS (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = inMoneyPlaceId AND DescId = zc_ObjectLink_Juridical_InfoMoney() AND ChildObjectId IN (zc_Enum_InfoMoney_20801(), zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_21001(), zc_Enum_InfoMoney_21101())) -- Алан + Ирна + Чапли + Дворкин
        AND inContractId > 0
     THEN
         RAISE EXCEPTION 'Ошибка.Для <№ договора> = <%> неверное значение <УП статья назначения> = <%>.', (SELECT InvNumber FROM Object_Contract_InvNumber_View WHERE ContractId = inContractId), lfGet_Object_ValueData (inInfoMoneyId);
     END IF;

     -- проверка
     IF COALESCE (inInfoMoneyId, 0) = 0
     THEN
        RAISE EXCEPTION 'Ошибка.<УП статья назначения> не выбрана.';
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

     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (ioId, inUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 07.03.14                                        * add zc_Enum_InfoMoney_21419
 13.03.14                                        * add lpInsert_MovementProtocol
 13.03.14                                        * err inParentId NOT NULL
 13.03.14                                        * add Проверка установки значений
 15.01.14                         *
 06.12.13                         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_BankAccount (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
