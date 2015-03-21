-- Function: gpInsertUpdate_MI_ProductionUnionTech()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnionTech (Integer, Integer, Integer, TDateTime, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ProductionUnionTech(
    IN inMovementItemId_order Integer   , -- Ключ объекта <Элемент документа>
 INOUT ioMovementItemId       Integer   , -- Ключ объекта <Элемент документа>
 INOUT ioMovementId           Integer   , -- Ключ объекта <Документ>
    IN inOperDate             TDateTime , -- Дата документа
    IN inFromId               Integer   , -- От кого (в документе)
    IN inToId                 Integer   , -- Кому (в документе)

    IN inReceiptId            Integer   , -- Рецептуры
    IN inGoodsId              Integer   , -- Товары
    IN inCount	              TFloat    , -- Количество батонов или упаковок
    IN inRealWeight           TFloat    , -- Фактический вес(информативно)
    IN inCuterCount           TFloat    , -- Количество кутеров

    IN inComment              TVarChar  , -- Комментарий
    IN inGoodsKindId          Integer   , -- Виды товаров
    IN inGoodsKindCompleteId  Integer   , -- Виды товаров  ГП
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbAmount TFloat;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ProductionUnionTech());


   -- проверка
   IF COALESCE (inReceiptId, 0) = 0 
   THEN
       RAISE EXCEPTION 'Ошибка.Значение <Название рецептуры> не установлено.';
   END IF;


   -- сохранили <Документ>
   IF COALESCE (ioMovementId, 0) = 0
   THEN ioMovementId:= lpInsertUpdate_Movement_ProductionUnion (ioId        := ioMovementId
                                                              , inInvNumber := NEXTVAL ('movement_productionunion_seq') :: TVarChar
                                                              , inOperDate  := inOperDate
                                                              , inFromId    := inFromId
                                                              , inToId      := inToId
                                                              , inIsPeresort:= FALSE
                                                              , inUserId    := vbUserId
                                                               );
   END IF;


   -- таблица элементы Child
   CREATE TEMP TABLE _tmpChild (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, Amount TFloat, AmountReceipt TFloat, isWeightMain Boolean, isTaxExit Boolean) ON COMMIT DROP;
   --
   WITH tmpMI_Child AS (SELECT MovementItem.Id                                  AS MovementItemId
                             , MovementItem.ObjectId                            AS GoodsId
                             , COALESCE (MILO_GoodsKind.ObjectId, 0)            AS GoodsKindId
                             , MovementItem.Amount                              AS Amount
                             , COALESCE (MIFloat_AmountReceipt.ValueData, 0)    AS AmountReceipt
                        FROM MovementItem
                             LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                              ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                             AND MILO_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                             LEFT JOIN MovementItemFloat AS MIFloat_AmountReceipt
                                                         ON MIFloat_AmountReceipt.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountReceipt.DescId = zc_MIFloat_AmountReceipt()
                             LEFT JOIN MovementItemBoolean AS MIBoolean_WeightMain
                                                           ON MIBoolean_WeightMain.MovementItemId =  MovementItem.Id
                                                          AND MIBoolean_WeightMain.DescId = zc_MIBoolean_WeightMain()
                        WHERE MovementItem.ParentId = ioMovementItemId
                          AND MovementItem.DescId   = zc_MI_Child()
                          AND MovementItem.isErased = FALSE
                       )
      , tmpReceiptChild AS
                       (SELECT COALESCE (ObjectLink_ReceiptChild_Goods.ChildObjectId, 0)      AS GoodsId
                             , COALESCE (ObjectLink_ReceiptChild_GoodsKind.ChildObjectId, 0)  AS GoodsKindId
                             , ObjectFloat_Value.ValueData                                    AS AmountReceipt
                             , COALESCE (ObjectBoolean_TaxExit.ValueData, FALSE)              AS isTaxExit
                             , COALESCE (ObjectBoolean_WeightMain.ValueData, FALSE)           AS isWeightMain
                        FROM ObjectLink AS ObjectLink_ReceiptChild_Receipt
                             INNER JOIN ObjectFloat AS ObjectFloat_Value_master
                                                    ON ObjectFloat_Value_master.ObjectId = inReceiptId
                                                   AND ObjectFloat_Value_master.DescId = zc_ObjectFloat_Receipt_Value()
                             LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                                  ON ObjectLink_ReceiptChild_Goods.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                 AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
                             LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_GoodsKind
                                                  ON ObjectLink_ReceiptChild_GoodsKind.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                 AND ObjectLink_ReceiptChild_GoodsKind.DescId = zc_ObjectLink_ReceiptChild_GoodsKind()
                             INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                    ON ObjectFloat_Value.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                   AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()
                                                   AND ObjectFloat_Value.ValueData <> 0
                             LEFT JOIN ObjectBoolean AS ObjectBoolean_WeightMain
                                                     ON ObjectBoolean_WeightMain.ObjectId = Object_ReceiptChild.Id 
                                                    AND ObjectBoolean_WeightMain.DescId = zc_ObjectBoolean_ReceiptChild_WeightMain()
                             LEFT JOIN ObjectBoolean AS ObjectBoolean_TaxExit
                                                     ON ObjectBoolean_TaxExit.ObjectId = Object_ReceiptChild.Id 
                                                    AND ObjectBoolean_TaxExit.DescId = zc_ObjectBoolean_ReceiptChild_TaxExit()
                        WHERE ObjectLink_ReceiptChild_Receipt.ChildObjectId = inReceiptId
                          AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()
                       )
   -- сформировали данные по элементам Child
   INSERT INTO _tmpChild (MovementItemId, GoodsId, GoodsKindId, Amount, AmountReceipt, isWeightMain, isTaxExit)
      SELECT COALESCE (tmpMI_Child.MovementItemId, 0)                            AS MovementItemId
           , COALESCE (tmpMI_Child.GoodsId, tmpReceiptChild.GoodsId)             AS GoodsId
           , COALESCE (tmpMI_Child.GoodsKindId, tmpReceiptChild.GoodsKindId)     AS GoodsKindId
           , CASE WHEN COALESCE (tmpMI_Child.AmountReceipt, -1) = 0 THEN tmpMI_Child.Amount ELSE COALESCE (COALESCE (inCuterCount, 0) * COALESCE (tmpMI_Child.AmountReceipt, tmpReceiptChild.AmountReceipt), tmpMI_Child.Amount) END AS Amount
           , COALESCE (tmpMI_Child.AmountReceipt, tmpReceiptChild.AmountReceipt) AS AmountReceipt
           , COALESCE (tmpReceiptChild.isWeightMain, FALSE)                      AS isWeightMain
           , COALESCE (tmpReceiptChild.isTaxExit, FALSE)                         AS isTaxExit
      FROM tmpMI_Child
           FULL JOIN tmpReceiptChild ON tmpReceiptChild.GoodsId     = tmpMI_Child.GoodsId
                                    AND tmpReceiptChild.GoodsKindId = tmpMI_Child.GoodsKindId
     ;


   -- Расчет кол-во
   vbAmount = (SELECT SUM (_tmpChild.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END)
               FROM _tmpChild
                    LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                         ON ObjectLink_Goods_Measure.ObjectId = _tmpChild.GoodsId
                                        AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                    LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                          ON ObjectFloat_Weight.ObjectId = _tmpChild.GoodsId
                                         AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
               WHERE _tmpChild.isTaxExit = FALSE
              );

   -- сохранили <Главный элемент документа>
   ioMovementItemId:= lpInsertUpdate_MI_ProductionUnionTech_Master (ioId                 := ioId
                                                                  , ioMovementId         := ioMovementId
                                                                  , inGoodsId            := inGoodsId
                                                                  , inAmount             := COALESCE (vbAmount, 0)
                                                                  , inCount              := inCount
                                                                  , inRealWeight         := inRealWeight
                                                                  , inCuterCount         := inCuterCount
                                                                  , inComment            := inComment
                                                                  , inGoodsKindId        := inGoodsKindId
                                                                  , inGoodsKindCompleteId:= inGoodsKindCompleteId
                                                                  , inReceiptId          := inReceiptId
                                                                  , inUserId             := vbUserId
                                                                   );

   -- сохранили <Подчиненный элемент документа>
   UPDATE _tmpChild SET MovementItemId = lpInsertUpdate_MI_ProductionUnionTech_Child (ioId                 := _tmpChild.MovementItemId
                                                                                    , ioMovementId         := ioMovementId
                                                                                    , inGoodsId            := _tmpChild.GoodsId
                                                                                    , inAmount             := _tmpChild.Amount
                                                                                    , inParentId           := ioMovementItemId
                                                                                    , inAmountReceipt      := _tmpChild.AmountReceipt
                                                                                    , inPartionGoodsDate   := CASE WHEN _tmpChild.MovementItemId > 0 THEN (SELECT MovementItemDate.ValueData FROM MovementItemDate WHERE MovementItemDate.MovementItemId = _tmpChild.MovementItemId AND MovementItemDate.DescId = zc_MIDate_PartionGoods()) ELSE NULL END
                                                                                    , inComment            := CASE WHEN _tmpChild.MovementItemId > 0 THEN (SELECT MovementItemString.ValueData FROM MovementItemString WHERE MovementItemString.MovementItemId = _tmpChild.MovementItemId AND MovementItemString.DescId = zc_MIString_Comment()) ELSE NULL END
                                                                                    , inGoodsKindId        := _tmpChild.GoodsKindId
                                                                                    , inUserId             := vbUserId
                                                                                     );
   -- сохранили св-ва по рецептуре <Входит в общий вес сырья> + <Зависит от % выхода>
   PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_WeightMain(), _tmpChild.MovementItemId, _tmpChild.isWeightMain)
         , lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_TaxExit(), _tmpChild.MovementItemId, _tmpChild.isTaxExit)
   FROM _tmpChild;


   -- !!!сохранили св-ва <Рецептуры> у заявки!!!
   IF inMovementItemId_order <> 0
   THEN
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Receipt(), inMovementItemId_order, inReceiptId);
   END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 21.03.15                                        *all
 19.12.14                                                       * add zc_MILinkObject_GoodsKindComplete
 12.12.14                                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_ProductionUnionTech (ioId:= 0, ioMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPartionClose:= FALSE, inComment:= '', inCount:= 1, inRealWeight:= 1, inCuterCount:= 0, inReceiptId:= 0, inSession:= '2')
