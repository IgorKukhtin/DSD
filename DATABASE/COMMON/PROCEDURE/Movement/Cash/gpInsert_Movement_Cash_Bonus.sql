-- Function: gpInsertUpdate_Movement_Cash()

DROP FUNCTION IF EXISTS gpInsert_Movement_Cash_Bonus (Integer, Integer, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_Movement_Cash_Bonus (Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_Movement_Cash_Bonus (TDateTime, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_Movement_Cash_Bonus (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Cash_Bonus(
    IN inOperDate             TDateTime , --
    IN inCashId               Integer   , -- касса
    IN inCurrencyId           Integer   , -- Валюта
    IN inInfoMoneyId          Integer   , -- Управленческие статьи
    IN inMoneyPlaceId         Integer   , -- Объекты работы с деньгами
    IN inContractId           Integer   , -- Контракт
    IN inBranchId             Integer   , -- филиал
    IN inRemainsToPay         TFloat    , -- Сумма расхода
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId     Integer;
   DECLARE vbMovementItemId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Cash());

     -- 
     IF COALESCE (inRemainsToPay, 0) <= 0 
     THEN
        RETURN;
     END IF;

     -- проверка - 
     IF inInfoMoneyId NOT IN (zc_Enum_InfoMoney_21501(), zc_Enum_InfoMoney_21502(), zc_Enum_InfoMoney_21512()) -- статьи бонусы
     THEN
        RAISE EXCEPTION 'Ошибка.Выбранная статья <%> не является начислением бонусов.', lfGet_Object_ValueData_sh (inInfoMoneyId);
     END IF;

     -- проверка - кассы
     IF COALESCE (inCashId,0) = 0
     THEN
        RAISE EXCEPTION 'Ошибка.Не выбрана касса.';
     END IF;

     -- сохранили
     vbId := lpInsertUpdate_Movement_Cash (ioId                   := 0
                                         , inParentId             := NULL
                                         , inInvNumber            := CAST (NEXTVAL ('Movement_Cash_seq') AS TVarChar)
                                         , inOperDate             := inOperDate --CAST (CURRENT_DATE AS TDateTime)
                                         , inServiceDate          := NULL           :: TDateTime
                                         , inAmountIn             := 0              :: TFloat
                                         , inAmountOut            := inRemainsToPay :: TFloat
                                         , inAmountSumm           := 0              :: TFloat
                                         , inAmountCurrency       := 0           :: TFloat
                                         , inComment              := 'Бонусы'
                                         , inCarId                := 0
                                         , inCashId               := inCashId
                                         , inMoneyPlaceId         := inMoneyPlaceId
                                         , inPositionId           := 0
                                         , inContractId           := inContractId
                                         , inInfoMoneyId          := inInfoMoneyId
                                         , inMemberId             := 0
                                         , inUnitId               := 0
                                         , inCurrencyId           := COALESCE (inCurrencyId, zc_Enum_Currency_Basis())
                                         , inCurrencyValue        := 0
                                         , inParValue             := 0
                                         , inCurrencyPartnerId    := 0
                                         , inCurrencyPartnerValue := 0
                                         , inParPartnerValue      := 0
                                         , inMovementId_Partion   := 0
                                         , inUserId               := vbUserId
                                          );

     -- для бонусов сохраняем Филиал
     -- поиск <Элемент документа>
     SELECT MovementItem.Id INTO vbMovementItemId FROM MovementItem WHERE MovementItem.MovementId = vbId AND MovementItem.DescId = zc_MI_Master();

     -- сохранили связь с <Объект>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Branch (), vbMovementItemId, inBranchId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, vbUserId, False);
    
    
    -- PERFORM lpSetErased_Movement (vbId, vbUserId);

   /*  -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();



     --PERFORM lpSetErased_Movement (vbId, vbUserId);

     -- 5.3. проводим Документ
     IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_Complete_Cash())
     THEN
          PERFORM lpComplete_Movement_Cash (inMovementId := vbId
                                          , inUserId     := vbUserId);
     END IF;
*/
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.08.20         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Cash (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')

/*
WITH tmpMovement AS (select * from Movement

where Movement.OperDate >= '03.08.2020'
and Movement.DescId = zc_Movement_Cash()
and Movement.StatusId <>8
)

, tmpMI AS (
SELECT MovementItem.*
 from tmpMovement AS Movement
Inner join MovementItem ON MovementItem.MovementId = Movement.Id
   AND MovementItem.DescId = zc_MI_Master()
)
WHERE MovementItem.Amount < -0
--where Movement.StatusId <>8
--and MovementItem.Amount = -5014.12

--SELECT zc_Enum_Status_Erased()  9
--SELECT zc_Enum_Status_UnComplete()  7
*/