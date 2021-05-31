-- Function: gpComplete_Movement_ReturnIn_Cash()

DROP FUNCTION IF EXISTS gpComplete_Movement_ReturnIn_Cash (Integer,Integer, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_ReturnIn_Cash(
    IN inMovementId        Integer              , -- ключ Документа
    IN inPaidType          Integer              , --Тип оплаты 0-деньги, 1-карта, 2-Смешенная
    IN inCashRegister      TVarChar             , --№ кассового аппарата
    IN inTotalSummPayAdd   TFloat               , -- Доплата по чеку
    IN inSession           TVarChar               -- сессия пользователя
)
RETURNS  VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbPaidTypeId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbCashRegisterId Integer;
BEGIN
    vbUserId:= lpGetUserBySession (inSession);

    -- Перебили дату документа
    IF CURRENT_DATE <> (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId) 
    THEN
      UPDATE Movement SET OperDate = CURRENT_DATE WHERE Movement.Id = inMovementId;
    END IF;

    IF CURRENT_DATE <> (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId) 
    THEN
        RAISE EXCEPTION 'Ошибка.Дата возврата доджна быть текущей.';
    END IF;

    -- Определить
    vbUnitId:= (SELECT MLO_Unit.ObjectId FROM MovementLinkObject AS MLO_Unit WHERE MLO_Unit.MovementId = inMovementId AND MLO_Unit.DescId = zc_MovementLinkObject_Unit());

    -- сохранили тип оплаты
    IF inPaidType = 0
    THEN
        PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_PaidType(), inMovementId, zc_Enum_PaidType_Cash());
    ELSEIF inPaidType = 1
    THEN
        PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_PaidType() ,inMovementId, zc_Enum_PaidType_Card());
    ELSEIF inPaidType = 2
    THEN
        PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_PaidType() ,inMovementId, zc_Enum_PaidType_CardAdd());
    ELSE
        RAISE EXCEPTION 'Ошибка.Не определен тип оплаты';
    END IF;

    -- Определить ид кассового аппарата
    IF COALESCE(inCashRegister,'') <> ''
    THEN
        vbCashRegisterId := gpGet_Object_CashRegister_By_Serial(inSerial := inCashRegister -- Серийный номер аппарата
                                                              , inSession:= inSession);
    ELSE
        vbCashRegisterId := 0;
    END IF;
    -- Сохранили связь с кассовым аппаратом
    IF vbCashRegisterId <> 0
    THEN
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CashRegister(), inMovementId, vbCashRegisterId);
    END IF;

    -- сохранили Доплату по чеку
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPayAdd(), inMovementId, inTotalSummPayAdd);

    -- пересчитали Итоговые суммы
    PERFORM lpInsertUpdate_MovementFloat_TotalSummReturnIn (inMovementId);

    -- формируются проводки
    PERFORM lpComplete_Movement_ReturnIn  (inMovementId, vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.  Шаблий О.В
 10.08.20                                                                                    *

*/

-- тест
-- SELECT * FROM gpComplete_Movement_ReturnIn_Cash (inMovementId:= 19806544 , inPaidType := 1, inCashRegister := '', inTotalSummPayAdd := 0, inSession:= '3')