-- Function: lpInsertUpdate_MovementItem_PromoGoods()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_PromoGoods(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- % скидки на товар
    IN inPrice               TFloat    , --Цена в прайсе
    IN inPriceWithOutVAT     TFloat    , --Цена отгрузки без учета НДС, с учетом скидки, грн
    IN inPriceWithVAT        TFloat    , --Цена отгрузки с учетом НДС, с учетом скидки, грн
    IN inAmountReal          TFloat    , --Объем продаж в аналогичный период, кг
    IN inAmountPlanMin       TFloat    , --Минимум планируемого объема продаж на акционный период (в кг)
    IN inAmountPlanMax       TFloat    , --Максимум планируемого объема продаж на акционный период (в кг)
    IN inGoodsKindId         Integer    , --ИД обьекта <Вид товара>
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
    
    -- сохранили <цена в прайсе>
    IF inPrice is not null
    THEN
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);
    END IF;

    -- сохранили <Цена отгрузки без учета НДС, с учетом скидки, грн>
    IF inPriceWithOutVAT is not null
    THEN
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceWithOutVAT(), ioId, inPriceWithOutVAT);
    END IF;

    -- сохранили <Цена отгрузки с учетом НДС, с учетом скидки, грн>
    IF inPriceWithOutVAT is not null
    THEN
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceWithVAT(), ioId, inPriceWithVAT);
    END IF;

    -- сохранили <Объем продаж в аналогичный период, кг>
    IF inPriceWithOutVAT is not null
    THEN
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountReal(), ioId, inAmountReal);
    END IF;

    -- сохранили <Минимум планируемого объема продаж на акционный период (в кг)>
    IF inPriceWithOutVAT is not null
    THEN
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlanMin(), ioId, inAmountPlanMin);
    END IF;

    -- сохранили <Максимум планируемого объема продаж на акционный период (в кг)>
    IF inPriceWithOutVAT is not null
    THEN
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlanMax(), ioId, inAmountPlanMax);
    END IF;

    -- сохранили связь с <Вид товара>
    IF inPriceWithOutVAT is not null
    THEN
        PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
    END IF;

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А,
 13.10.15                                                                       *
 */