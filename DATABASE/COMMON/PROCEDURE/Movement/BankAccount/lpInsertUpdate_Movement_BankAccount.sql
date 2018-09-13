-- Function: gpInsertUpdate_Movement_BankAccount()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_BankAccount (Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_BankAccount (Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_BankAccount(
 INOUT ioId                    Integer   , -- Ключ объекта <Документ>
    IN inInvNumber             TVarChar  , -- Номер документа
    IN inOperDate              TDateTime , -- Дата документа
    IN inAmount                TFloat    , -- Сумма операции 
    IN inAmountSumm            TFloat    , -- Cумма грн, обмен
    IN inAmountCurrency        TFloat    , -- Сумма в валюте
    IN inBankAccountId         Integer   , -- Расчетный счет 	
    IN inComment               TVarChar  , -- Комментарий 
    IN inMoneyPlaceId          Integer   , -- Юр лицо, счет, касса  	
    IN inContractId            Integer   , -- Договора
    IN inInfoMoneyId           Integer   , -- Статьи назначения 
    IN inUnitId                Integer   , -- Подразделение
    IN inMovementId_Invoice    Integer   , -- документ счет
    IN inCurrencyId            Integer   , -- Валюта 
    IN inCurrencyValue         TFloat    , -- Курс для перевода в валюту баланса
    IN inParValue              TFloat    , -- Номинал для перевода в валюту баланса
    IN inCurrencyPartnerValue  TFloat    , -- Курс для расчета суммы операции
    IN inParPartnerValue       TFloat    , -- Номинал для расчета суммы операции
    IN inParentId              Integer   , -- 
    IN inBankAccountPartnerId  Integer   , -- С какого счета нам платили
    IN inUserId                Integer     -- Пользователь
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbMovementItemId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

     -- проверка
     IF COALESCE (inMovementId_Invoice, 0) = 0 AND EXISTS (SELECT 1 FROM Object_InfoMoney_View AS View_InfoMoney WHERE View_InfoMoney.InfoMoneyId = inInfoMoneyId AND View_InfoMoney.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000()) -- Инвестиции
     THEN
        RAISE EXCEPTION 'Ошибка.Для УП статьи <%> необходимо заполнить значение <№ док. Счет>.', lfGet_Object_ValueData (inInfoMoneyId);
     END IF;
     -- проверка что счет НЕ оплачен
     IF COALESCE (ioId, 0) = 0 AND EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId_Invoice AND MB.DescId = zc_MovementBoolean_Closed() AND MB.ValueData = TRUE)
     THEN
        RAISE EXCEPTION 'Ошибка.Счет № <%> от <%> уже полность оплачен.Выберите другой.', (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId_Invoice), DATE ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId_Invoice));
     END IF;


     -- проверка (для юр.лица только)
     IF COALESCE (inContractId, 0) = 0 AND EXISTS (SELECT Id FROM Object WHERE Id = inMoneyPlaceId AND DescId = zc_Object_Juridical())
     THEN
        RAISE EXCEPTION 'Ошибка.Не выбрано значение <№ договора>.';
     END IF;

     -- проверка
     IF COALESCE (inCurrencyId, 0) = 0
     THEN
        RAISE EXCEPTION 'Ошибка.Не выбрано значение <Валюта>.';
     END IF;

     -- проверка
     IF inAmountSumm < 0
     THEN
        RAISE EXCEPTION 'Ошибка.Неверное значение <Cумма грн, обмен>.';
     END IF;
     -- проверка
     IF /*inCurrencyId = zc_Enum_Currency_Basis() AND */ inAmount > 0 AND inInfoMoneyId IN (SELECT InfoMoneyId FROM Object_InfoMoney_View WHERE InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_41000())  -- Покупка/продажа валюты
        AND COALESCE (inAmountSumm, 0) = 0
     THEN
        RAISE EXCEPTION 'Ошибка.Для <%> не введено значение <Cумма грн, обмен>.', lfGet_Object_ValueData (inInfoMoneyId);
     END IF;
     -- проверка
     IF NOT (/*inCurrencyId = zc_Enum_Currency_Basis() AND */inAmount > 0 AND inInfoMoneyId IN (SELECT InfoMoneyId FROM Object_InfoMoney_View WHERE InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_41000()))  -- Покупка/продажа валюты
        AND inAmountSumm > 0
     THEN
        RAISE EXCEPTION 'Ошибка.Для <%> в валюту <%> значение <Cумма грн, обмен> должно быть равно нулю.', lfGet_Object_ValueData (inInfoMoneyId), lfGet_Object_ValueData (inCurrencyId);
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

                                                                                                                                 , zc_Enum_InfoMoneyDestination_41000() -- Покупка/продажа валюты
                                                                                                                                 , zc_Enum_InfoMoneyDestination_41100() -- Банковская гарантия
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

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (vbMovementItemId, 0) = 0;

     -- сохранили <Элемент документа>
     vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), inBankAccountId, ioId, inAmount, NULL);

     -- сохранили связь с <Объект>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_MoneyPlace(), vbMovementItemId, inMoneyPlaceId);
    
     -- Cумма грн, обмен
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Amount(), ioId, inAmountSumm);
     -- Сумма в валюте
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountCurrency(), ioId, inAmountCurrency);
     -- Курс для перевода в валюту баланса
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyValue(), ioId, inCurrencyValue);
     -- Номинал для перевода в валюту баланса
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParValue(), ioId, inParValue);
     -- Курс для расчета суммы операции
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyPartnerValue(), ioId, inCurrencyPartnerValue);
     -- Номинал для расчета суммы операции
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParPartnerValue(), ioId, inParPartnerValue);

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
     -- 
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_BankAccount(), vbMovementItemId, inBankAccountPartnerId);
     
     -- сохранили связь с документом <Счет>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Invoice(), ioId, inMovementId_Invoice);


     -- данные по ЗП
     IF EXISTS (SELECT Object.Id FROM Object WHERE Object.Id = inMoneyPlaceId AND Object.DescId = zc_Object_PersonalServiceList())
     THEN
         -- сохранили свойство <Месяц начислений> - 1-ое число месяца
         IF EXTRACT (DAY FROM CURRENT_DATE) < 17
         THEN
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_ServiceDate(), ioId, DATE_TRUNC ('MONTH', inOperDate - INTERVAL '1 MONTH'));
         ELSE
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_ServiceDate(), ioId, DATE_TRUNC ('MONTH', inOperDate));
         END IF;

     ELSE
          -- обнулили связь с документом <Начисление зарплаты>
          PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Child(), ioId, NULL);
          -- обнулили свойство <Месяц начислений>
          PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_ServiceDate(), ioId, NULL);
          --
          IF EXISTS (SELECT MovementItem.MovementId FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Child() AND MovementItem.isErased = FALSE)
          THEN
              -- удаление т.к. это теперь не ЗП
              PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id
                                              , inUserId        := inUserId
                                               )
              FROM MovementItem
              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.DescId = zc_MI_Child()
                AND MovementItem.isErased = FALSE;

          END IF;
     END IF;

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 21.07.16         *
 10.05.14                                        * add lpInsert_MovementItemProtocol
 07.03.14                                        * add zc_Enum_InfoMoney_21419
 13.03.14                                        * add lpInsert_MovementProtocol
 13.03.14                                        * err inParentId NOT NULL
 13.03.14                                        * add Проверка установки значений
 15.01.14                         *
 06.12.13                         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_BankAccount (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
