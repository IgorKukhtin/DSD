-- Function: gpUpdate_MI_Payment_NeedPay()

DROP FUNCTION IF EXISTS gpUpdate_MI_Payment_NeedPay (Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Payment_NeedPay(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   ,
    IN inNeedPay             Boolean   , -- Нужно платить
   OUT outNeedPay            Boolean   , -- Нужно платить
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Payment());
    vbUserId := inSession;
    
    --Сохранили свойство <Нужно платить>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_NeedPay(), inId, inNeedPay);
    
    --Пересчитали суммы по документу
    PERFORM lpInsertUpdate_MovementFloat_TotalSummPayment (inMovementId);

    outNeedPay := inNeedPay;

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.10.18         *
*/