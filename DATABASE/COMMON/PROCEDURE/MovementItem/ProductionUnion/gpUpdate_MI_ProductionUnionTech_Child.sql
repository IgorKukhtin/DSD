-- Function: gpUpdate_MI_ProductionUnionTech_Child()

DROP FUNCTION IF EXISTS gpUpdate_MI_ProductionUnionTech_Child (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_ProductionUnionTech_Child(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ Производство - смешивание>
    IN inGoodsId             Integer   , -- Товары
 INOUT ioAmount              TFloat    , -- Количество
    IN inParentId            Integer   , -- Главный элемент документа
    IN inAmountReceipt       TFloat    , -- Количество по рецептуре на 1 кутер
    IN inPartionGoodsDate    TDateTime , -- Партия товара
    IN inGoodsKindId         Integer   , -- Виды товаров            
    IN inComment             TVarChar  , -- Примечание
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;

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


   -- сохранили
   ioId:= lpInsertUpdate_MI_ProductionUnionTech_Child (ioId                 := ioId
                                                     , inMovementId         := inMovementId
                                                     , inGoodsId            := inGoodsId
                                                     , inAmount             := ioAmount
                                                     , inParentId           := inParentId
                                                     , inAmountReceipt      := inAmountReceipt
                                                     , inPartionGoodsDate   := inPartionGoodsDate
                                                     , inComment            := inComment
                                                     , inGoodsKindId        := inGoodsKindId
                                                     , inUserId             := vbUserId
                                                      );


   -- Расчет кол-во
   vbAmount = (SELECT SUM (MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END)
               FROM MovementItem
                    LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                         ON ObjectLink_Goods_Measure.ObjectId = _tmpChild.GoodsId
                                        AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                    LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                          ON ObjectFloat_Weight.ObjectId = _tmpChild.GoodsId
                                         AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
               WHERE MovementItem.ParentId = inParentId
                 AND MovementItem.MovementId = inMovementId
                 AND MovementItem.DescId = zc_MI_Child()
                 AND MovementItem.isErased = FALSE
              );


   -- !!!сохранили св-ва <Количество> у zc_MI_Master!!!
   PERFORM lpInsertUpdate_MovementItem (MovementItem.Id, MovementItem.DescId, MovementItem.ObjectId, MovementItem.MovementId, vbAmount, MovementItem.ParentId)
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
