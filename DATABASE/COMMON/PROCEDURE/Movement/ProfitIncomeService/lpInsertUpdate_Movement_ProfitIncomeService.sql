-- Function: lpInsertUpdate_Movement_ProfitIncomeService()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ProfitIncomeService (Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TVarChar
                                                                   , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_ProfitIncomeService(
 INOUT ioId                       Integer   , -- Ключ объекта <Документ>
    IN inInvNumber                TVarChar  , -- Номер документа
    IN inOperDate                 TDateTime , -- Дата документа
    IN inAmountIn                 TFloat    , -- Сумма операции
    IN inAmountOut                TFloat    , -- Сумма операции
    IN inBonusValue               TFloat    , -- % бонуса
    IN inComment                  TVarChar  , -- Комментарий
    IN inContractId               Integer   , -- Договор
    IN inContractMasterId         Integer   , -- Договор(условия)
    IN inContractChildId          Integer   , -- Договор(база)
    IN inInfoMoneyId              Integer   , -- Статьи назначения
    IN inJuridicalId              Integer   , -- Юр. лицо
    IN inPaidKindId               Integer   , -- Виды форм оплаты
    IN inContractConditionKindId  Integer   , -- Типы условий договоров
    IN inBonusKindId              Integer   , -- Виды бонусов
    IN inBranchId                 Integer   , -- филиал
    IN inIsLoad                   Boolean   , -- Сформирован автоматически (по отчету)
    IN inUserId                   Integer     -- Пользователь
)
RETURNS Integer AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbMovementItemId Integer;
   DECLARE vbAmount TFloat;
   DECLARE vbBranchId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- определяем ключ доступа
    --vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_ProfitIncomeService());

     -- проверка
     IF (COALESCE(inAmountIn, 0) = 0) AND (COALESCE(inAmountOut, 0) = 0) THEN
        RAISE EXCEPTION 'Введите сумму.';
     END IF;

     -- проверка
     IF (COALESCE(inAmountIn, 0) <> 0) AND (COALESCE(inAmountOut, 0) <> 0) THEN
        RAISE EXCEPTION 'Должна быть введена только одна сумма: <Дебет> или <Кредит>.';
     END IF;

     -- Распроводим Документ
     IF ioId <> 0 THEN
        PERFORM lpUnComplete_Movement (inMovementId := ioId
                                     , inUserId     := inUserId);
     END IF;

     -- расчет
     IF inAmountIn <> 0 THEN
        vbAmount := inAmountIn;
     ELSE
        vbAmount := -1 * inAmountOut;
     END IF;

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_ProfitIncomeService(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- определяем <Элемент документа>
     SELECT MovementItem.Id INTO vbMovementItemId FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Master();

     -- сохранили <Элемент документа>
     vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), inJuridicalId, ioId, vbAmount, NULL);

     -- % бонуса 
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_BonusValue(), vbMovementItemId, inBonusValue);
     -- Комментарий
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), vbMovementItemId, inComment);

     -- сохранили связь с <Виды форм оплаты>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PaidKind(), vbMovementItemId, inPaidKindId);
     -- сохранили связь с <Управленческие статьи>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), vbMovementItemId, inInfoMoneyId);
     -- сохранили связь с <Договора>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), vbMovementItemId, inContractId);
     -- сохранили связь с <Договора условия >
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ContractMaster(), vbMovementItemId, inContractMasterId);
     -- сохранили связь с <Договора база>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ContractChild(), vbMovementItemId, inContractChildId);

     -- сохранили связь с <Типы условий договоров>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ContractConditionKind(), vbMovementItemId, inContractConditionKindId);
     -- сохранили связь с <Виды бонусов>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_BonusKind(), vbMovementItemId, inBonusKindId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Branch(), vbMovementItemId, inBranchId);

     IF vbIsInsert = TRUE
     THEN
         -- сохранили свойство <сформирован автоматически да/нет>
         PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isLoad(), ioId, inIsLoad);
     END IF;

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);
     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, inUserId, vbIsInsert);

     -- 5.3. проводим Документ
     PERFORM lpComplete_Movement_Service (inMovementId := ioId
                                        , inUserId     := inUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.07.20         *
*/

-- тест
--