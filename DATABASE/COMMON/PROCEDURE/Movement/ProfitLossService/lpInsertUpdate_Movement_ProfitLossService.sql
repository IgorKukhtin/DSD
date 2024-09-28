-- Function: lpInsertUpdate_Movement_ProfitLossService()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ProfitLossService (Integer, TVarChar, TDateTime, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ProfitLossService (Integer, TVarChar, TDateTime, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ProfitLossService (Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ProfitLossService (Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ProfitLossService (Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ProfitLossService (Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ProfitLossService (Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_ProfitLossService(
 INOUT ioId                       Integer   , -- Ключ объекта <Документ>
    IN inInvNumber                TVarChar  , -- Номер документа
    IN inOperDate                 TDateTime , -- Дата документа
    IN inAmountIn                 TFloat    , -- Сумма операции
    IN inAmountOut                TFloat    , -- Сумма операции
    IN inBonusValue               TFloat    , -- % бонуса
    IN inAmountCurrency           TFloat    , -- сумма начислений (в валюте) 
    IN inInvNumberInvoice         TVarChar  , -- Счет(клиента)
    IN inComment                  TVarChar  , -- Комментарий
    IN inContractId               Integer   , -- Договор
    IN inContractMasterId         Integer   , -- Договор(условия)
    IN inContractChildId          Integer   , -- Договор(база)
    IN inInfoMoneyId              Integer   , -- Статьи назначения
    IN inJuridicalId              Integer   , -- Юр. лицо
    IN inPaidKindId               Integer   , -- Виды форм оплаты
    IN inUnitId                   Integer   , -- Подразделение
    IN inContractConditionKindId  Integer   , -- Типы условий договоров
    IN inBonusKindId              Integer   , -- Виды бонусов
    IN inBranchId                 Integer   , -- филиал
    IN inCurrencyPartnerId        Integer   , -- Валюта Контрагента 
    IN inTradeMarkId              Integer   , --
    IN inMovementId_doc           Integer   , --
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
   DECLARE vbCurrencyPartnerValue TFloat;
   DECLARE vbParPartnerValue TFloat;
BEGIN
     -- определяем ключ доступа
     vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_ProfitLossService());

     -- проверка
   --IF (COALESCE(inAmountIn, 0) = 0) AND (COALESCE(inAmountOut, 0) = 0) THEN
   --   RAISE EXCEPTION 'Введите сумму.';
   --END IF;

     -- проверка
     IF (COALESCE(inAmountIn, 0) <> 0) AND (COALESCE(inAmountOut, 0) <> 0) THEN
        RAISE EXCEPTION 'Должна быть введена только одна сумма: <Дебет> или <Кредит>.';
     END IF;

     IF COALESCE (ioId,0) = 0 
     THEN
          IF inCurrencyPartnerId <> zc_Enum_Currency_Basis()
          THEN 
              SELECT Amount, ParValue
             INTO vbCurrencyPartnerValue, vbParPartnerValue
               FROM lfSelect_Movement_Currency_byDate (inOperDate:= inOperDate, inCurrencyFromId:= zc_Enum_Currency_Basis(), inCurrencyToId:= inCurrencyPartnerId, inPaidKindId:= inPaidKindId);
          ELSE 
               vbCurrencyPartnerValue:= 0;
               vbParPartnerValue:=0;
          END IF;
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
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_ProfitLossService(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- определяем <Элемент документа>
     SELECT MovementItem.Id INTO vbMovementItemId FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Master();

     -- сохранили <Элемент документа>
     vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), inJuridicalId, ioId, vbAmount, NULL);

     -- % бонуса 
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_BonusValue(), vbMovementItemId, inBonusValue);


     -- сохранили
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CurrencyPartner(), ioId, inCurrencyPartnerId);
     -- 
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_TradeMark(), ioId, inTradeMarkId);
     -- 
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Doc(), ioId, inMovementId_doc);
      
     -- 
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyPartnerValue(), ioId, vbCurrencyPartnerValue);
     -- 
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParPartnerValue(), ioId, vbParPartnerValue);
     -- 
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountCurrency(), vbMovementItemId, inAmountCurrency);

     -- счет клиента
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberInvoice(), ioId, inInvNumberInvoice);
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

     -- сохранили связь с <Подразделением>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), vbMovementItemId, inUnitId);
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

     -- !!!отключил это на долго, но временно!!!
     -- !!!распределяются затраты!!!
     -- IF vbIsInsert = TRUE OR NOT EXISTS (SELECT MovementId FROM MovementItem WHERE MovementId = ioId AND DescId = zc_MI_Child() AND isErased = FALSE)
     /*IF EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = zc_Enum_Role_Admin())
        OR EXISTS (SELECT MovementId FROM MovementItem WHERE MovementId = ioId AND DescId = zc_MI_Child() AND isErased = FALSE)
     THEN
         PERFORM lpInsertUpdate_MI_ProfitLossService_AmountPartner (inMovementId:= ioId
                                                                  , inAmount    := -1 * vbAmount
                                                                  , inUserId    := inUserId
                                                                   );
     END IF;*/

     IF inUserId <> 5 OR 1=1
     THEN
     -- 5.3. проводим Документ
     PERFORM gpComplete_Movement_ProfitLossService (inMovementId := ioId
                                                  , inSession    := inUserId :: TVarChar
                                                   );
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 07.08.24         *
 21.05.20         *
 18.02.15         * add ContractMaster, ContractChild
 10.05.14                                        * add lpInsert_MovementItemProtocol
 08.05.14                                        * set lp
 05.04.14                                        * add !!!ДЛЯ ОПТИМИЗАЦИИ!!! : _tmp1___ and _tmp2___
 25.03.14                                        * таблица - !!!ДЛЯ ОПТИМИЗАЦИИ!!!
 06.03.14                                        * add lpComplete_Movement_Service
 19.02.14         * add BonusKind
 18.02.14                                                         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_ProfitLossService (ioId := 0 , inInvNumber := '-1' , inOperDate := '01.01.2013', inAmountIn:= 20 , inAmountOut := 0 , inComment := '' , inContractId :=1 ,      inInfoMoneyId := 0,     inJuridicalId:= 1,       inPaidKindId:= 1,   inUnitId:= 0,   inContractConditionKindId:=0,     inUserId:= zfCalc_UserAdmin())
