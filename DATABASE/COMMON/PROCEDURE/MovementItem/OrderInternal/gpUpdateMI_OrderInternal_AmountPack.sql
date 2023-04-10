-- Function: gpUpdateMI_OrderInternal_AmountPack()

DROP FUNCTION IF EXISTS gpUpdateMI_OrderInternal_AmountPack (Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdateMI_OrderInternal_AmountPack (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMI_OrderInternal_AmountPack(
    IN inId                      Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId              Integer   , -- Ключ объекта <Документ>
    IN inAmountPack              TFloat    , -- Количество
    IN inAmountPackSecond        TFloat    , -- Количество дозаказ
    IN inAmountPackNext          TFloat    , -- Количество
    IN inAmountPackNextSecond    TFloat    , -- Количество дозаказ
   OUT outIsCalculated           Boolean   , --
    IN inSession                 TVarChar    -- сессия пользователя
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbParentId Integer;
   DECLARE vbGoodsId_complete Integer;
   DECLARE vbGoodsKindId_complete Integer;
   DECLARE vbMovementItemId_detail Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderInternal());

     -- проверка
     IF COALESCE (inId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Элемент не найден.';
     END IF;

     -- сохранили свойство <Изменять факт при пересчете>
     IF  inAmountPackNext       <> COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_AmountPackNext()), 0)
      OR inAmountPackNextSecond <> COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_AmountPackNextSecond()), 0)
      --
      OR inAmountPack           <> COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_AmountPack()), 0)
      OR inAmountPackSecond     <> COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_AmountPackSecond()), 0)
     THEN
         outIsCalculated:= FALSE;
         PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Calculated(), inId, FALSE);
     ELSE
         outIsCalculated:= COALESCE ((SELECT MIB.ValueData FROM MovementItemBoolean AS MIB WHERE MIB.MovementItemId = inId AND MIB.DescId = zc_MIBoolean_Calculated()), TRUE);
     END IF;


     -- сохранили свойство <Количество заказ на УПАК>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPack(), inId, inAmountPack);
     -- сохранили свойство <Количество дозаказ>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPackSecond(), inId, inAmountPackSecond);

     -- сохранили свойство <Количество заказ на УПАК план2>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPackNext(), inId, inAmountPackNext);
     -- сохранили свойство <Количество дозаказ план2>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPackNextSecond(), inId, inAmountPackNextSecond);

     -- нашли
     vbMovementItemId_detail:= (SELECT MI.Id FROM MovementItem AS MI WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Detail() AND MI.ParentId = inId AND MI.isErased = FALSE ORDER BY MI.Amount DESC LIMIT 1);
     --
     IF COALESCE (vbMovementItemId_detail, 0) = 0
     THEN
         vbMovementItemId_detail:= lpInsertUpdate_MovementItem (vbMovementItemId_detail, zc_MI_Detail(), vbUserId, inMovementId, COALESCE ((SELECT MAX (MI.Amount) FROM MovementItem AS MI WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Detail()), 1), inId);
         --
         -- сохранили протокол
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), vbMovementItemId_detail, CURRENT_TIMESTAMP);
         -- сохранили протокол
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), vbMovementItemId_detail, vbUserId);
     END IF;

     -- сохранили свойство <Количество заказ на УПАК>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPack(), vbMovementItemId_detail, inAmountPack);
     -- сохранили свойство <Количество дозаказ>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPackSecond(), vbMovementItemId_detail, inAmountPackSecond);

     -- сохранили свойство <Количество заказ на УПАК план2>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPackNext(), vbMovementItemId_detail, inAmountPackNext);
     -- сохранили свойство <Количество дозаказ план2>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPackNextSecond(), vbMovementItemId_detail, inAmountPackNextSecond);
     -- сохранили
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Calculated(), vbMovementItemId_detail, outIsCalculated);

     -- сохранили протокол
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), vbMovementItemId_detail, CURRENT_TIMESTAMP);
     -- сохранили протокол
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), vbMovementItemId_detail, vbUserId);

     -- сохранили протокол !!!после изменений!!!
     PERFORM lpInsert_MovementItemProtocol (vbMovementItemId_detail, vbUserId, FALSE);

     -- нашли
     vbGoodsId_complete:= (SELECT MILO.ObjectId
                           FROM MovementItemLinkObject AS MILO
                           WHERE MILO.MovementItemId = inId
                             AND MILO.DescId         = zc_MILinkObject_Goods()
                          );
     -- нашли
     vbGoodsKindId_complete:= (SELECT MILO.ObjectId
                               FROM MovementItemLinkObject AS MILO
                               WHERE MILO.MovementItemId = inId
                                 AND MILO.DescId         = zc_MILinkObject_GoodsKindComplete()
                              );
     -- проверка
     IF COALESCE (vbGoodsId_complete, 0) = 0 THEN
         RAISE EXCEPTION 'Ошибка.Товар (расход) на упаковку не определен.';
     END IF;
     -- проверка
     IF COALESCE (vbGoodsKindId_complete, 0) = 0 THEN
         RAISE EXCEPTION 'Ошибка.Вид товара (расход) на упаковку не определен.';
     END IF;

     -- проверка 1.1
     IF 1 < (SELECT COUNT(*) FROM MovementItem AS MI JOIN MovementItemLinkObject AS MILO_2 ON MILO_2.MovementItemId = MI.Id AND MILO_2.DescId = zc_MILinkObject_GoodsKind() AND MILO_2.ObjectId = vbGoodsKindId_complete WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE AND MI.ObjectId = vbGoodsId_complete)
      --AND vbUserId = 5
     THEN
         RAISE EXCEPTION 'Ошибка.Кол-во vbGoodsKindId_complete  = %   %   %   %.' , inMovementId, vbGoodsId_complete, vbGoodsKindId_complete
             , (SELECT COUNT(*) FROM MovementItem AS MI JOIN MovementItemLinkObject AS MILO_2 ON MILO_2.MovementItemId = MI.Id AND MILO_2.DescId = zc_MILinkObject_GoodsKind() AND MILO_2.ObjectId = vbGoodsKindId_complete
                WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE AND MI.ObjectId = vbGoodsId_complete
               );

     -- проверка 1.1
     ELSEIF (SELECT SUM (MIF.ValueData) FROM MovementItem AS MI JOIN MovementItemLinkObject AS MILO_1 ON MILO_1.MovementItemId = MI.Id AND MILO_1.DescId = zc_MILinkObject_Goods() AND MILO_1.ObjectId = vbGoodsId_complete JOIN MovementItemLinkObject AS MILO_2 ON MILO_2.MovementItemId = MI.Id AND MILO_2.DescId = zc_MILinkObject_GoodsKindComplete() AND MILO_2.ObjectId = vbGoodsKindId_complete JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = MI.Id AND MIF.DescId = zc_MIFloat_AmountPack() WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE) - 2
      > COALESCE ((SELECT MI.Amount FROM MovementItem AS MI JOIN MovementItemLinkObject AS MILO_2 ON MILO_2.MovementItemId = MI.Id AND MILO_2.DescId = zc_MILinkObject_GoodsKind() AND MILO_2.ObjectId = vbGoodsKindId_complete WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE AND MI.ObjectId = vbGoodsId_complete), 0)
      --AND vbUserId = 5
     THEN
         RAISE EXCEPTION 'Ошибка.Кол-во упакованной П1 с УПАК факт (с Ост.) = <%>%БОЛЬШЕ% чем Кол-во План1 выдали = <%>.%(%) %(%)'
                       ,  (SELECT SUM (MIF.ValueData) FROM MovementItem AS MI JOIN MovementItemLinkObject AS MILO_1 ON MILO_1.MovementItemId = MI.Id AND MILO_1.DescId = zc_MILinkObject_Goods() AND MILO_1.ObjectId = vbGoodsId_complete JOIN MovementItemLinkObject AS MILO_2 ON MILO_2.MovementItemId = MI.Id AND MILO_2.DescId = zc_MILinkObject_GoodsKindComplete() AND MILO_2.ObjectId = vbGoodsKindId_complete JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = MI.Id AND MIF.DescId = zc_MIFloat_AmountPack() WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE)
                       , CHR (13)
                       , CHR (13)
                       , (SELECT MI.Amount FROM MovementItem AS MI JOIN MovementItemLinkObject AS MILO_2 ON MILO_2.MovementItemId = MI.Id AND MILO_2.DescId = zc_MILinkObject_GoodsKind() AND MILO_2.ObjectId = vbGoodsKindId_complete WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE AND MI.ObjectId = vbGoodsId_complete)
                       , CHR (13)
--                       ,  (SELECT MIN (MIF.MovementItemId) FROM MovementItem AS MI JOIN MovementItemLinkObject AS MILO_1 ON MILO_1.MovementItemId = MI.Id AND MILO_1.DescId = zc_MILinkObject_Goods() AND MILO_1.ObjectId = vbGoodsId_complete JOIN MovementItemLinkObject AS MILO_2 ON MILO_2.MovementItemId = MI.Id AND MILO_2.DescId = zc_MILinkObject_GoodsKindComplete() AND MILO_2.ObjectId = vbGoodsKindId_complete JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = MI.Id AND MIF.DescId = zc_MIFloat_AmountPack() WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE)
                       ,  (SELECT COUNT (*) FROM MovementItem AS MI JOIN MovementItemLinkObject AS MILO_1 ON MILO_1.MovementItemId = MI.Id AND MILO_1.DescId = zc_MILinkObject_Goods() AND MILO_1.ObjectId = vbGoodsId_complete JOIN MovementItemLinkObject AS MILO_2 ON MILO_2.MovementItemId = MI.Id AND MILO_2.DescId = zc_MILinkObject_GoodsKindComplete() AND MILO_2.ObjectId = vbGoodsKindId_complete JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = MI.Id AND MIF.DescId = zc_MIFloat_AmountPack() WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE)
                       , CHR (13)
                       ,  (SELECT MAX (MIF.MovementItemId) FROM MovementItem AS MI JOIN MovementItemLinkObject AS MILO_1 ON MILO_1.MovementItemId = MI.Id AND MILO_1.DescId = zc_MILinkObject_Goods() AND MILO_1.ObjectId = vbGoodsId_complete JOIN MovementItemLinkObject AS MILO_2 ON MILO_2.MovementItemId = MI.Id AND MILO_2.DescId = zc_MILinkObject_GoodsKindComplete() AND MILO_2.ObjectId = vbGoodsKindId_complete JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = MI.Id AND MIF.DescId = zc_MIFloat_AmountPack() WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE)
                        ;
     END IF;
     -- проверка 1.2
     IF (SELECT SUM (MIF.ValueData) FROM MovementItem AS MI JOIN MovementItemLinkObject AS MILO_1 ON MILO_1.MovementItemId = MI.Id AND MILO_1.DescId = zc_MILinkObject_Goods() AND MILO_1.ObjectId = vbGoodsId_complete JOIN MovementItemLinkObject AS MILO_2 ON MILO_2.MovementItemId = MI.Id AND MILO_2.DescId = zc_MILinkObject_GoodsKindComplete() AND MILO_2.ObjectId = vbGoodsKindId_complete JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = MI.Id AND MIF.DescId = zc_MIFloat_AmountPackSecond() WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE) - 2
      > COALESCE ((SELECT MIF.ValueData FROM MovementItem AS MI JOIN MovementItemLinkObject AS MILO_2 ON MILO_2.MovementItemId = MI.Id AND MILO_2.DescId = zc_MILinkObject_GoodsKind() AND MILO_2.ObjectId = vbGoodsKindId_complete JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = MI.Id AND MIF.DescId = zc_MIFloat_AmountSecond() WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE AND MI.ObjectId = vbGoodsId_complete), 0)
      --AND vbUserId = 5
     THEN
         RAISE EXCEPTION 'Ошибка.Кол-во упакованной П1 с Цеха факт (с Ост.) = <%>%БОЛЬШЕ% чем Кол-во План1 выдали = <%>.'
                       ,  (SELECT SUM (MIF.ValueData) FROM MovementItem AS MI JOIN MovementItemLinkObject AS MILO_1 ON MILO_1.MovementItemId = MI.Id AND MILO_1.DescId = zc_MILinkObject_Goods() AND MILO_1.ObjectId = vbGoodsId_complete JOIN MovementItemLinkObject AS MILO_2 ON MILO_2.MovementItemId = MI.Id AND MILO_2.DescId = zc_MILinkObject_GoodsKindComplete() AND MILO_2.ObjectId = vbGoodsKindId_complete JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = MI.Id AND MIF.DescId = zc_MIFloat_AmountPackSecond() WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE)
                       , CHR (13)
                       , CHR (13)
                       , (SELECT MIF.ValueData FROM MovementItem AS MI JOIN MovementItemLinkObject AS MILO_2 ON MILO_2.MovementItemId = MI.Id AND MILO_2.DescId = zc_MILinkObject_GoodsKind() AND MILO_2.ObjectId = vbGoodsKindId_complete JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = MI.Id AND MIF.DescId = zc_MIFloat_AmountSecond() WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE AND MI.ObjectId = vbGoodsId_complete)
                        ;
     END IF;


     -- проверка 2.1
     IF (SELECT SUM (MIF.ValueData) FROM MovementItem AS MI JOIN MovementItemLinkObject AS MILO_1 ON MILO_1.MovementItemId = MI.Id AND MILO_1.DescId = zc_MILinkObject_Goods() AND MILO_1.ObjectId = vbGoodsId_complete JOIN MovementItemLinkObject AS MILO_2 ON MILO_2.MovementItemId = MI.Id AND MILO_2.DescId = zc_MILinkObject_GoodsKindComplete() AND MILO_2.ObjectId = vbGoodsKindId_complete JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = MI.Id AND MIF.DescId = zc_MIFloat_AmountPackNext() WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE) - 2
      > COALESCE ((SELECT MIF.ValueData FROM MovementItem AS MI JOIN MovementItemLinkObject AS MILO_2 ON MILO_2.MovementItemId = MI.Id AND MILO_2.DescId = zc_MILinkObject_GoodsKind() AND MILO_2.ObjectId = vbGoodsKindId_complete JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = MI.Id AND MIF.DescId = zc_MIFloat_AmountNext() WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE AND MI.ObjectId = vbGoodsId_complete), 0)
      --AND vbUserId = 5
     THEN
         RAISE EXCEPTION 'Ошибка.Кол-во упакованной П2 с УПАК факт (с Ост.) = <%>%БОЛЬШЕ% чем Кол-во План2 выдали = <%>.'
                       ,  (SELECT SUM (MIF.ValueData) FROM MovementItem AS MI JOIN MovementItemLinkObject AS MILO_1 ON MILO_1.MovementItemId = MI.Id AND MILO_1.DescId = zc_MILinkObject_Goods() AND MILO_1.ObjectId = vbGoodsId_complete JOIN MovementItemLinkObject AS MILO_2 ON MILO_2.MovementItemId = MI.Id AND MILO_2.DescId = zc_MILinkObject_GoodsKindComplete() AND MILO_2.ObjectId = vbGoodsKindId_complete JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = MI.Id AND MIF.DescId = zc_MIFloat_AmountPackNext() WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE)
                       , CHR (13)
                       , CHR (13)
                       , (SELECT MIF.ValueData FROM MovementItem AS MI JOIN MovementItemLinkObject AS MILO_2 ON MILO_2.MovementItemId = MI.Id AND MILO_2.DescId = zc_MILinkObject_GoodsKind() AND MILO_2.ObjectId = vbGoodsKindId_complete JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = MI.Id AND MIF.DescId = zc_MIFloat_AmountNext() WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE AND MI.ObjectId = vbGoodsId_complete)
                        ;
     END IF;
     -- проверка 2.2
     IF (SELECT SUM (MIF.ValueData) FROM MovementItem AS MI JOIN MovementItemLinkObject AS MILO_1 ON MILO_1.MovementItemId = MI.Id AND MILO_1.DescId = zc_MILinkObject_Goods() AND MILO_1.ObjectId = vbGoodsId_complete JOIN MovementItemLinkObject AS MILO_2 ON MILO_2.MovementItemId = MI.Id AND MILO_2.DescId = zc_MILinkObject_GoodsKindComplete() AND MILO_2.ObjectId = vbGoodsKindId_complete JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = MI.Id AND MIF.DescId = zc_MIFloat_AmountPackNextSecond() WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE) - 2
      > COALESCE ((SELECT MIF.ValueData FROM MovementItem AS MI JOIN MovementItemLinkObject AS MILO_2 ON MILO_2.MovementItemId = MI.Id AND MILO_2.DescId = zc_MILinkObject_GoodsKind() AND MILO_2.ObjectId = vbGoodsKindId_complete JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = MI.Id AND MIF.DescId = zc_MIFloat_AmountNextSecond() WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE AND MI.ObjectId = vbGoodsId_complete), 0)
      --AND vbUserId = 5
     THEN
         RAISE EXCEPTION 'Ошибка.Кол-во упакованной П2 с Цеха факт (с Ост.) = <%>%БОЛЬШЕ% чем Кол-во План2 выдали = <%>.'
                       ,  (SELECT SUM (MIF.ValueData) FROM MovementItem AS MI JOIN MovementItemLinkObject AS MILO_1 ON MILO_1.MovementItemId = MI.Id AND MILO_1.DescId = zc_MILinkObject_Goods() AND MILO_1.ObjectId = vbGoodsId_complete JOIN MovementItemLinkObject AS MILO_2 ON MILO_2.MovementItemId = MI.Id AND MILO_2.DescId = zc_MILinkObject_GoodsKindComplete() AND MILO_2.ObjectId = vbGoodsKindId_complete JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = MI.Id AND MIF.DescId = zc_MIFloat_AmountPackNextSecond() WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE)
                       , CHR (13)
                       , CHR (13)
                       , (SELECT MIF.ValueData FROM MovementItem AS MI JOIN MovementItemLinkObject AS MILO_2 ON MILO_2.MovementItemId = MI.Id AND MILO_2.DescId = zc_MILinkObject_GoodsKind() AND MILO_2.ObjectId = vbGoodsKindId_complete JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = MI.Id AND MIF.DescId = zc_MIFloat_AmountNextSecond() WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE AND MI.ObjectId = vbGoodsId_complete)
                        ;
     END IF;

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- сохранили протокол !!!после изменений!!!
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

IF vbUserId = 5 AND 1=0
THEN
    RAISE EXCEPTION 'Ошибка.test ok <%>  <%>', (SELECT MIB.ValueData FROM MovementItemBoolean AS MIB WHERE MIB.MovementItemId = inId AND MIB.DescId = zc_MIBoolean_Calculated())
             , (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_AmountPackNextSecond())
              ;
END IF;


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 17.11.17         *
 16.11.17         *
*/

-- тест
--