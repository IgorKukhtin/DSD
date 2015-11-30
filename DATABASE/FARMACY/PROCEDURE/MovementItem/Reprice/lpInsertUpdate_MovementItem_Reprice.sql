-- Function: lpInsertUpdate_MovementItem_Reprice()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Reprice (Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Reprice(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inPriceOld            TFloat    , -- Цена
    IN inPriceNew            TFloat    , -- сумма
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
    
    -- сохранили <цену старую>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPriceOld);

    -- сохранили <цену новую>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceSale(), ioId, inPriceNew);

    -- пересчитали Итоговые суммы по накладной
    PERFORM lpInsertUpdate_MovementFloat_TotalSummReprice (inMovementId);
    
    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А,
 27.11.15                                                                       *
 */