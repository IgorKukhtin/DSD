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
RETURNS Integer
AS
$BODY$
    DECLARE vbIsInsert Boolean;
    DECLARE vbMinimumLot TFloat;
BEGIN
     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;


     -- Проверка что б такого элемента не было (потом сделаем НОРМАЛЬНО - т.е. ошибку лайт)
     IF vbIsInsert = TRUE AND EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.ObjectId = inGoodsId AND MovementItem.isErased = FALSE)
     THEN
         RAISE EXCEPTION 'Ошибка.%Для товара <%> уже сформировано кол-во заказа = <%>.%Обновите у себя данные по <F5>.', CHR (13), lfGet_Object_ValueData (inGoodsId), (SELECT SUM (MovementItem.Amount) FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.ObjectId = inGoodsId AND MovementItem.isErased = FALSE), CHR (13);
     END IF;


    -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

    -- Количество, установленное вручную
    IF inAmountManual IS NULL 
    THEN
        -- MinimumLot
        SELECT Object_Goods_View.MinimumLot
               INTO vbMinimumLot
        FROM Object_Goods_View 
        WHERE Object_Goods_View.Id = inGoodsId
          AND Object_Goods_View.MinimumLot <> 0;

        -- заменили inAmountManual
        SELECT -- округлили ВВЕРХ AllLot
               CEIL((-- Спецзаказ
                     inAmount
                     -- Количество дополнительное
                   + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                     -- кол-во отказов
                   + COALESCE (MIFloat_ListDiff.ValueData, 0)
                     -- кол-во СУА
                   + COALESCE (MIFloat_AmountSUA.ValueData, 0)
                    ) / COALESCE (vbMinimumLot, 1)
                   ) * COALESCE (vbMinimumLot, 1)
        INTO
            inAmountManual
        FROM
            MovementItem
            LEFT OUTER JOIN MovementItemFloat AS MIFloat_AmountSecond
                                              ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                             AND MIFloat_AmountSecond.DescId         = zc_MIFloat_AmountSecond()
            LEFT OUTER JOIN MovementItemFloat AS MIFloat_ListDiff
                                              ON MIFloat_ListDiff.MovementItemId = MovementItem.Id
                                             AND MIFloat_ListDiff.DescId         = zc_MIFloat_ListDiff()
            LEFT OUTER JOIN MovementItemFloat AS MIFloat_AmountSUA
                                              ON MIFloat_AmountSUA.MovementItemId = MovementItem.Id
                                             AND MIFloat_AmountSUA.DescId         = zc_MIFloat_AmountSUA()
        WHERE MovementItem.Id = ioId;

    END IF;

    -- сохранили свойство <Количество, установленное вручную>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountManual(), ioId, COALESCE(inAmountManual, 0));

    
    -- сохранили свойство <Сумма заказа>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, COALESCE(inPrice, 0));

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 22.03.21                                                                     *
 23.10.14                         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_OrderInternal (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')