-- Function: lpInsertUpdate_MovementItem_PromoUnit()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoUnit (Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_PromoUnit(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inAmountPlanMax       TFloat    , -- Количество для премии
    IN inPrice               TFloat    , -- Цена
    IN inComment             TVarChar  , -- примечание
    IN inisFixedPercent      Boolean   , -- Фиксированный процент выполнения
    IN inUserId              Integer     -- пользователь
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
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlanMax(), ioId, inAmountPlanMax);

    -- сохранили свойство <>
    PERFORM lpInsertUpdate_MovementItemString(zc_MIString_Comment(), ioId, inComment);

    -- сохранили свойство <>
    PERFORM lpInsertUpdate_MovementItemBoolean(zc_MIBoolean_FixedPercent(), ioId, inisFixedPercent);

    -- пересчитали Итоговые суммы по накладной
    PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);
    
    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А,
 04.02.17         *
 */