-- Function: gpUpdate_MI_ProductionUnionTech_Master()

DROP FUNCTION IF EXISTS gpUpdate_MI_ProductionUnionTech_Master (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_ProductionUnionTech_Master(
    IN inMovementItemId_order Integer   , -- Ключ объекта <Элемент документа>
 INOUT ioMovementItemId       Integer   , -- Ключ объекта <Элемент документа>
 INOUT ioMovementId           Integer   , -- Ключ объекта <Документ>
    IN inReceiptId            Integer   , -- Рецептуры
    IN inGoodsId              Integer   , -- Товар - !!!только для проверки inReceiptId!!!
    IN inCount	              TFloat    , -- Количество батонов или упаковок
    IN inRealWeight           TFloat    , -- Фактический вес(информативно)
    IN inComment              TVarChar  , -- Примечание
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbFromId Integer;
   DECLARE vbToId   Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ProductionUnionTech_Master());


   -- проверка - если не нашли ioMovementItemId + ioMovementId
   IF ioMovementId <> 0 AND NOT EXISTS (SELECT Id FROM MovementItem WHERE Id = ioMovementItemId AND MovementId = ioMovementId)
   THEN
       RAISE EXCEPTION 'Ошибка.MovementId.';
   END IF;

   -- если это элемент - заявка
   IF NOT EXISTS (SELECT MovementItem.Id FROM MovementItem INNER JOIN Movement ON Movement.Id = MovementItem.MovementId AND Movement.DescId = zc_Movement_ProductionUnion() WHERE MovementItem.Id = ioMovementItemId)
   THEN
       RAISE EXCEPTION 'Ошибка.Данные по <Закладке> не сформированы.';
   END IF;

   -- Проверка для ЦЕХ колбаса+дел-сы
   vbFromId:= COALESCE ((SELECT MovementLinkObject.ObjectId FROM MovementLinkObject WHERE MovementLinkObject.MovementId = ioMovementId AND MovementLinkObject.DescId = zc_MovementLinkObject_From()), 0);
   vbToId  := COALESCE ((SELECT MovementLinkObject.ObjectId FROM MovementLinkObject WHERE MovementLinkObject.MovementId = ioMovementId AND MovementLinkObject.DescId = zc_MovementLinkObject_To())  , 0);
   IF (vbFromId <> vbToId) OR (NOT EXISTS (SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (8446) AS lfSelect WHERE lfSelect.UnitId = vbFromId)
                           -- AND vbFromId <> 951601 -- ЦЕХ упаковки мясо
                           AND vbFromId <> 981821   -- ЦЕХ шприц. мясо
                           AND vbFromId <> 2790412  -- ЦЕХ Тушенка
                           AND vbFromId <> 8020711  -- ЦЕХ колбаса + деликатесы (Ирна)
                              )
   THEN
       RAISE EXCEPTION 'Ошибка.Изменения возможны только для подазделений <%>.', lfGet_Object_ValueData (8446);
   END IF;

   -- проверка
   IF COALESCE (inReceiptId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Значение <Название рецептуры> не установлено.';
   END IF;

   -- проверка
   IF 1 = 0 AND NOT EXISTS (SELECT ObjectId FROM ObjectLink  WHERE ChildObjectId = inGoodsId AND ObjectId = inReceiptId AND DescId = zc_ObjectLink_Receipt_Goods())
   THEN
       RAISE EXCEPTION 'Ошибка.Для товара <%> не может быть выбрана рецептура <%>.', lfGet_Object_ValueData (inGoodsId), lfGet_Object_ValueData (inReceiptId);
   END IF;

   -- проверка - если изменилась <Рецептура>
   IF COALESCE (inReceiptId, 0) <> COALESCE ((SELECT ObjectId FROM MovementItemLinkObject WHERE MovementItemId = ioMovementItemId AND DescId = zc_MILinkObject_Receipt()), 0)
      AND EXISTS (SELECT MovementId FROM MovementItem WHERE MovementId = ioMovementId AND DescId = zc_MI_Child())
   THEN
       RAISE EXCEPTION 'Ошибка.Найдены данные по <Закладке>.Значение <Название рецептуры> изменять нельзя.';
   END IF;


   -- сохранили связь с <Рецептуры>
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MILinkObject_Receipt(), ioMovementItemId, inReceiptId);
   -- сохранили св-во <на основании дозаявки>
   PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_WeightMain(), tmp.MovementItemId, CASE WHEN MIFloat_AmountSecond.ValueData > 0 THEN TRUE ELSE FALSE END)
   FROM (SELECT ioMovementItemId AS MovementItemId) AS tmp
        LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                    ON MIFloat_AmountSecond.MovementItemId = inMovementItemId_order
                                   AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond();

   -- сохранили свойство <Количество батонов>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_Count(), ioMovementItemId, inCount);
   -- сохранили свойство <Фактический вес(информативно)>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_RealWeight(), ioMovementItemId, inRealWeight);

   -- сохранили свойство <Примечание>
   PERFORM lpInsertUpdate_MovementItemString(zc_MIString_Comment(), ioMovementItemId, inComment);


   -- !!!сохранили св-ва <Рецептуры> у заявки!!!
   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ReceiptBasis(), MovementItem_f.Id, inReceiptId)
   FROM MovementItem
        INNER JOIN MovementItemLinkObject AS MILO_Goods
                                          ON MILO_Goods.MovementItemId = MovementItem.Id
                                         AND MILO_Goods.DescId = zc_MILinkObject_Goods()
        INNER JOIN MovementItemLinkObject AS MILO_GoodsKindComplete
                                          ON MILO_GoodsKindComplete.MovementItemId = MovementItem.Id
                                         AND MILO_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
        INNER JOIN MovementItem AS MovementItem_f ON MovementItem_f.MovementId = MovementItem.MovementId
                                                 AND MovementItem_f.DescId = zc_MI_Master()
        INNER JOIN MovementItemLinkObject AS MILO_Goods_f
                                          ON MILO_Goods_f.MovementItemId = MovementItem_f.Id
                                         AND MILO_Goods_f.DescId         = zc_MILinkObject_Goods()
                                         AND MILO_Goods_f.ObjectId       = MILO_Goods.ObjectId
        INNER JOIN MovementItemLinkObject AS MILO_GoodsKindComplete_f
                                          ON MILO_GoodsKindComplete_f.MovementItemId = MovementItem_f.Id
                                         AND MILO_GoodsKindComplete_f.DescId         = zc_MILinkObject_GoodsKindComplete()
                                         AND MILO_GoodsKindComplete_f.ObjectId       = MILO_GoodsKindComplete.ObjectId
   WHERE MovementItem.Id = inMovementItemId_order;

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), ioMovementItemId, vbUserId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), ioMovementItemId, CURRENT_TIMESTAMP);

   -- сохранили протокол
   PERFORM lpInsert_MovementItemProtocol (ioMovementItemId, vbUserId, FALSE);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 21.03.15                                        *all
 19.12.14                                                       * add zc_MILinkObject_GoodsKindComplete
 12.12.14                                                       *
*/

-- тест
-- SELECT * FROM gpUpdate_MI_ProductionUnionTech_Master (ioId:= 0, ioMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPartionClose:= FALSE, inComment:= '', inCount:= 1, inRealWeight:= 1, inCuterCount:= 0, inReceiptId:= 0, inSession:= '2')
