-- Function: gpUpdate_MI_ProductionUnionTech_Child()

DROP FUNCTION IF EXISTS gpUpdate_MI_ProductionUnionTech_Child (Integer, Integer, Integer, TFloat, Integer, TFloat, TDateTime, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_ProductionUnionTech_Child(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ Производство - смешивание>
    IN inGoodsId             Integer   , -- Товары
 INOUT ioAmount              TFloat    , -- Количество
    IN inParentId            Integer   , -- Главный элемент документа
 INOUT ioAmountReceipt       TFloat    , -- Количество по рецептуре на 1 кутер
    IN inPartionGoodsDate    TDateTime , -- Партия товара
    IN inGoodsKindId         Integer   , -- Виды товаров            
    IN inComment             TVarChar  , -- Примечание
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbAmount_master TFloat;
   DECLARE vbCuterCount TFloat;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ProductionUnionTech_Child());


   -- проверка - если не нашли inParentId + inMovementId
   IF inMovementId <> 0 AND NOT EXISTS (SELECT Id FROM MovementItem WHERE Id = inParentId AND MovementId = inMovementId)
   THEN
       RAISE EXCEPTION 'Ошибка.MovementId.';
   END IF;

   -- если inParentId - это элемент - заявка
   IF NOT EXISTS (SELECT MovementItem.Id FROM MovementItem INNER JOIN Movement ON Movement.Id = MovementItem.MovementId AND Movement.DescId = zc_Movement_ProductionUnion() WHERE MovementItem.Id = inParentId)
   THEN
       RAISE EXCEPTION 'Ошибка.Данные по <Закладке> не сформированы.';
   END IF;


   -- определяется <Количество кутеров>
   vbCuterCount:= (SELECT MIFloat_CuterCount.ValueData FROM MovementItemFloat AS MIFloat_CuterCount WHERE MIFloat_CuterCount.MovementItemId = inParentId AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount());
   -- проверка
   IF COALESCE (vbCuterCount, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Значение <Количество кутеров> не определено.';
   END IF;


   -- расчет, смотря что вводили
   IF ioId > 0
   THEN
       IF COALESCE (ioAmountReceipt, 0) <> COALESCE ((SELECT MIFloat_AmountReceipt.ValueData FROM MovementItemFloat AS MIFloat_AmountReceipt WHERE MIFloat_AmountReceipt.MovementItemId = ioId AND MIFloat_AmountReceipt.DescId = zc_MIFloat_AmountReceipt()), 0)
       THEN ioAmount:= vbCuterCount * ioAmountReceipt; -- если вводили <Количество по рецептуре на 1 кутер> тогда расчет <Количество>
       ELSE IF COALESCE (ioAmount, 0) <> COALESCE ((SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.Id = ioId), 0)
            THEN ioAmountReceipt:= 0; -- если вводили <Количество> тогда обнуляется <Количество по рецептуре на 1 кутер>
            END IF;
       END IF;
   ELSE
       IF ioAmountReceipt <> 0
       THEN ioAmount:= vbCuterCount * ioAmountReceipt; -- если вводили <Количество по рецептуре на 1 кутер> тогда расчет <Количество>
       END IF;
   END IF;

   -- сохранили
   ioId:= lpInsertUpdate_MI_ProductionUnionTech_Child (ioId                 := ioId
                                                     , inMovementId         := inMovementId
                                                     , inGoodsId            := inGoodsId
                                                     , inAmount             := ioAmount
                                                     , inParentId           := inParentId
                                                     , inAmountReceipt      := ioAmountReceipt
                                                     , inPartionGoodsDate   := inPartionGoodsDate
                                                     , inComment            := inComment
                                                     , inGoodsKindId        := inGoodsKindId
                                                     , inUserId             := vbUserId
                                                      );


   -- Расчет кол-во
   vbAmount_master =
              (SELECT SUM (MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END)
               FROM MovementItem
                    LEFT JOIN MovementItemBoolean AS MIBoolean_TaxExit
                                                  ON MIBoolean_TaxExit.MovementItemId =  MovementItem.Id
                                                 AND MIBoolean_TaxExit.DescId = zc_MIBoolean_TaxExit()
                                                 AND MIBoolean_TaxExit.ValueData = TRUE
                    LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                         ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                        AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                    LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                          ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                         AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
               WHERE MovementItem.ParentId = inParentId
                 AND MovementItem.MovementId = inMovementId
                 AND MovementItem.DescId = zc_MI_Child()
                 AND MovementItem.isErased = FALSE
                 AND MIBoolean_TaxExit.MovementItemId IS NULL
              );


   -- !!!сохранили св-ва <Количество> у zc_MI_Master!!!
   PERFORM lpInsertUpdate_MovementItem (MovementItem.Id, MovementItem.DescId, MovementItem.ObjectId, MovementItem.MovementId, vbAmount_master, MovementItem.ParentId)
   FROM MovementItem
   WHERE MovementItem.Id = inParentId;


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
-- SELECT * FROM gpUpdate_MI_ProductionUnionTech_Child (ioId:= 0, ioMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPartionClose:= FALSE, inComment:= '', inCount:= 1, inRealWeight:= 1, inCuterCount:= 0, inReceiptId:= 0, inSession:= '2')
