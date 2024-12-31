-- Function: lpInsertUpdate_MI_PromoGoods_Detail()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_PromoGoods_Detail (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TDateTime, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_PromoGoods_Detail (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TDateTime, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_PromoGoods_Detail(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inParentId              Integer   , --
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inGoodsId               Integer   , -- Товары
    IN inAmount                TFloat    , -- 
    IN inAmountIn              TFloat    , -- 
    IN inAmountReal            TFloat    , -- Объем продаж в аналогичный период, кг
    IN inAmountRetIn           TFloat    , --
    IN inOperDate              TDateTime  , --месяц
    IN inUserId                Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN

    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Detail(), inGoodsId, inMovementId, inAmount, inParentId);
    
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountIn(), ioId, inAmountIn);

    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountReal(), ioId, inAmountReal);

    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountRetIn(), ioId, inAmountRetIn);

    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_OperDate(), ioId, inOperDate);

 
    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.12.24         *
 */