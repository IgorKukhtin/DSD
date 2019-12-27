-- Function: gpInsertUpdate_MovementItem_LoyaltySaveMoneySign()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_LoyaltySaveMoneySign (Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_LoyaltySaveMoneySign(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inUnitId              Integer   , -- Подразделение
    IN inIsChecked           Boolean   , -- отмечен
    IN inDayCount            Integer    , -- Промокодов в день для аптеки
    IN inSummLimit           Tfloat     , -- Лимит суммы скидки в день для аптеки
    IN inSession             TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;
  
     -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inUnitId, inMovementId, (CASE WHEN inIsChecked = TRUE THEN 1 ELSE 0 END) ::TFloat, NULL);
    
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_DayCount(), ioId, inDayCount);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Limit(), ioId, inSummLimit);
     
    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.11.19                                                       *
*/
