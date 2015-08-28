-- Function: gpInsertUpdate_MovementItem_OrderInternal()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_OrderInternal(Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_OrderInternal(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inAmountManual        TFloat    , -- Количество ручное
    IN inPrice               TFloat    , -- Сумма заказа
    IN inUserId              Integer    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
    DECLARE vbMinimumLot TFloat;
BEGIN

    -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

    IF inAmountManual IS NULL
    THEN
        SELECT MinimumLot INTO vbMinimumLot
        FROM Object_Goods_View WHERE Id = inGoodsId;
    
        SELECT
            (CEIL((inAmount + COALESCE(MIFloat_AmountSecond.ValueData,0)) / COALESCE(vbMinimumLot, 1)) * COALESCE(vbMinimumLot, 1))
        INTO
            inAmountManual
        FROM
            MovementItem
            LEFT OUTER JOIN MovementItemFloat AS MIFloat_AmountSecond
                                              ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                             AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
        WHERE
            Id = ioId;
    END IF;
    -- сохранили свойство <Ручное количество>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountManual(), ioId, COALESCE(inAmountManual, 0));

    
    -- сохранили свойство <Сумма заказа>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, COALESCE(inPrice, 0));

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 23.10.14                         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_OrderInternal (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
