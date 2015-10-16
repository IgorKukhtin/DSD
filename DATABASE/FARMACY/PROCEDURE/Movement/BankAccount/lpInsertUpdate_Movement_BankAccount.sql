-- Function: lpComplete_Movement_BankAccount (Integer, Boolean)

DROP FUNCTION IF EXISTS lpinsertupdate_movement_bankaccount(integer, tvarchar, tdatetime, tfloat, tfloat, tfloat, integer, tvarchar, integer, integer, integer, integer, integer, integer, tfloat, tfloat, tfloat, tfloat, integer, integer, integer);

CREATE OR REPLACE FUNCTION lpinsertupdate_movement_bankaccount(INOUT ioid integer, IN ininvnumber tvarchar, IN inoperdate tdatetime, IN inamount tfloat, IN inamountsumm tfloat, IN inamountcurrency tfloat, IN inbankaccountid integer, IN incomment tvarchar, IN inmoneyplaceid integer, IN inincomemovementid integer, IN incontractid integer, IN ininfomoneyid integer, IN inunitid integer, IN incurrencyid integer, IN incurrencyvalue tfloat, IN inparvalue tfloat, IN incurrencypartnervalue tfloat, IN inparpartnervalue tfloat, IN inparentid integer, IN inbankaccountpartnerid integer, IN inuserid integer)
  RETURNS integer AS
$BODY$
   DECLARE vbMovementItemId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

     -- проверка (для юр.лица только)
--     IF COALESCE (inContractId, 0) = 0 AND EXISTS (SELECT Id FROM Object WHERE Id = inMoneyPlaceId AND DescId = zc_Object_Juridical())
  --   THEN
    --    RAISE EXCEPTION 'Ошибка.Не выбрано значение <№ договора>.';
   --  END IF;

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
     -- -- проверка
     -- IF /*inCurrencyId = zc_Enum_Currency_Basis() AND */ inAmount > 0 AND inInfoMoneyId IN (SELECT InfoMoneyId FROM Object_InfoMoney_View WHERE InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_41000())  -- Покупка/продажа валюты
        -- AND COALESCE (inAmountSumm, 0) = 0
     -- THEN
        -- RAISE EXCEPTION 'Ошибка.Для <%> не введено значение <Cумма грн, обмен>.', lfGet_Object_ValueData (inInfoMoneyId);
     -- END IF;
     -- -- проверка
     -- IF NOT (/*inCurrencyId = zc_Enum_Currency_Basis() AND */inAmount > 0 AND inInfoMoneyId IN (SELECT InfoMoneyId FROM Object_InfoMoney_View WHERE InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_41000()))  -- Покупка/продажа валюты
        -- AND inAmountSumm > 0
     -- THEN
        -- RAISE EXCEPTION 'Ошибка.Для <%> в валюту <%> значение <Cумма грн, обмен> должно быть равно нулю.', lfGet_Object_ValueData (inInfoMoneyId), lfGet_Object_ValueData (inCurrencyId);
     -- END IF;



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
     -- ссылка на документ прихода
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Child(), ioId, inIncomeMovementId);
     
     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpinsertupdate_movement_bankaccount(integer, tvarchar, tdatetime, tfloat, tfloat, tfloat, integer, tvarchar, integer, integer, integer, integer, integer, integer, tfloat, tfloat, tfloat, tfloat, integer, integer, integer)
  OWNER TO postgres;
