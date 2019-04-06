-- Function: gpInsertUpdate_MI_SendPartionDate_Master()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_SendPartionDate_Master (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_SendPartionDate_Master(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inAmountRemains       TFloat    , --
    IN inPrice               TFloat    , -- цена (срок от 1 мес до 6 мес)
    IN inPriceExp            TFloat    , -- цена (срок меньше месяца)
    IN inUserId              Integer    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN

    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);
    
    -- сохранили <цену>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceExp(), ioId, inPriceExp);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountRemains(), ioId, inAmountRemains);

    -- пересчитали Итоговые суммы по накладной
    --PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);
    
    -- сохранили протокол
    --PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.04.19         *
*/