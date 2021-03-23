-- Function: lpInsertUpdate_MI_OrderInternal_SUN()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderInternal_SUN(Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderInternal_SUN(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_OrderInternal_SUN(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- АВТОЗАКАЗ
    IN inAmountReal          TFloat    , -- первоначальный заказ без учета СУН
    IN inRemainsSUN          TFloat    , -- остаток в тек. аптеке сроковых
    IN inSendSUN             TFloat    , -- Перемещение по СУН
    IN inSendDefSUN          TFloat    , -- Отложенное Перемещение по СУН
    IN inUserId              Integer     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
    DECLARE vbIsInsert    Boolean;
    DECLARE vbMinimumLot TFloat;
BEGIN
     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (inId, 0) = 0;

     -- если
     IF vbIsInsert = TRUE
     THEN
          IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.ObjectId = inGoodsId AND MovementItem.isErased = FALSE)
          THEN
              RAISE EXCEPTION 'Ошибка.%Для товара <%> уже сформировано кол-во заказа = <%>.%Обновите у себя данные по <F5>.', CHR (13), lfGet_Object_ValueData (inGoodsId), (SELECT SUM (MovementItem.Amount) FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.ObjectId = inGoodsId AND MovementItem.isErased = FALSE), CHR (13);
          ELSE
              -- сохранили <Элемент документа> - ЗАКАЗ
              inId := lpInsertUpdate_MovementItem (inId, zc_MI_Master(), inGoodsId, inMovementId, 0, NULL);
          END IF;
          RAISE EXCEPTION 'Ошибка.%Для товара <%> не найден элемент кол-во заказа = <%>.', CHR (13), lfGet_Object_ValueData (inGoodsId), inAmount;
     END IF;

     -- сохранили <Элемент документа>
     -- inId := lpInsertUpdate_MovementItem (inId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);
     -- UPDATE MovementItem SET Amount = inAmount WHERE Id = inId;


     -- сохранили свойство <АВТОЗАКАЗ>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountSecond(), inId, inAmount);

     -- сохранили свойство <первоначальный АВТОЗАКАЗ без учета СУН>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountReal(),   inId, inAmountReal);
     -- сохранили свойство <остаток в тек. аптеке сроковых>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RemainsSUN(),   inId, inRemainsSUN);

     -- сохранили свойство <Перемещение по СУН>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SendSUN(),      inId, inSendSUN);
     -- сохранили свойство <Отложенное Перемещение по СУН>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SendDefSUN(),   inId, inSendDefSUN);


     -- MinimumLot
     SELECT Object_Goods_View.MinimumLot
            INTO vbMinimumLot
     FROM Object_Goods_View
     WHERE Object_Goods_View.Id = inGoodsId
       AND Object_Goods_View.MinimumLot <> 0;


     -- заменили inAmountManual
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountManual(), inId, tmp.AmountManual)
     FROM (SELECT -- округлили ВВЕРХ AllLot
                  CEIL((-- Спецзаказ
                        MovementItem.Amount
                        -- Количество дополнительное
                      + inAmount
                        -- кол-во отказов
                      + COALESCE (MIFloat_ListDiff.ValueData, 0)
                        -- кол-во СУА
                      + COALESCE (MIFloat_AmountSUA.ValueData, 0)
                       ) / COALESCE (vbMinimumLot, 1)
                      ) * COALESCE (vbMinimumLot, 1)
                  AS AmountManual
           FROM MovementItem
                LEFT OUTER JOIN MovementItemFloat AS MIFloat_ListDiff
                                                  ON MIFloat_ListDiff.MovementItemId = MovementItem.Id
                                                 AND MIFloat_ListDiff.DescId         = zc_MIFloat_ListDiff()
                LEFT OUTER JOIN MovementItemFloat AS MIFloat_AmountSUA
                                                  ON MIFloat_AmountSUA.MovementItemId = MovementItem.Id
                                                 AND MIFloat_AmountSUA.DescId         = zc_MIFloat_AmountSUA()
           WHERE MovementItem.Id = inId
          ) AS tmp;

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inId, inUserId, vbIsInsert);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 22.03.21                                                       *
 13.07.19         *
*/

-- тест
--