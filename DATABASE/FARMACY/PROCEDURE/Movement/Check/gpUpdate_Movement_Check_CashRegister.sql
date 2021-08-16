-- Function: gpComplete_Movement_IncomeAdmin()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_CashRegister (Integer, Integer, TVarChar, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_CashRegister(
    IN inMovementId        Integer              , -- ключ Документа
    IN inPaidType          Integer   , -- тип оплаты
    IN inCashRegister      TVarChar  , -- Серийник кассового аппарата
    IN inFiscalCheckNumber TVarChar  , -- Номер фискального чека
    IN inTotalSummPayAdd   TFloat    , -- Доплата по чеку
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbCashRegisterId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Income());
    vbUserId:= inSession;
    
    -- сохранили связь с <Тип оплаты>
    IF inPaidType <> -1
    THEN
        if inPaidType = 0
        THEN
            PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidType(),inMovementId,zc_Enum_PaidType_Cash());
        ELSEIF inPaidType = 1
        THEN
            PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidType(),inMovementId,zc_Enum_PaidType_Card());
        ELSEIF inPaidType = 2
        THEN
            PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidType(),inMovementId,zc_Enum_PaidType_CardAdd());
        ELSE
            RAISE EXCEPTION 'Ошибка.Не определен тип оплаты';
        END IF;
    END IF;

    vbCashRegisterId := gpGet_Object_CashRegister_By_Serial(inSerial := inCashRegister, inSession := inSession);
    PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_CashRegister(), inMovementId, vbCashRegisterId);

    -- сохранили Номер чека в кассовом аппарате
    PERFORM lpInsertUpdate_MovementString(zc_MovementString_FiscalCheckNumber(), inMovementId, inFiscalCheckNumber);

    -- сохранили Доплату по чеку
    IF inTotalSummPayAdd <> 0  THEN
	   PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPayAdd(), inMovementId, inTotalSummPayAdd);
	END IF;

    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Movement_Check_CashRegister (Integer, Integer, TVarChar, TVarChar, TFloat, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 16.08.21                                                       *
 
*/

-- тест
-- SELECT * FROM gpUpdate_Movement_Check_CashRegister (inMovementId:= 579, inSession:= '2')

