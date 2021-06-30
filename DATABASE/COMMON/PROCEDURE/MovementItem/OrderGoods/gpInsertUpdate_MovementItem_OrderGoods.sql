-- Function: gpInsertUpdate_MovementItem_OrderGoods()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderGoods (Integer, Integer, Integer, Integer, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderGoods (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_OrderGoods(
 INOUT ioId                     Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId             Integer   , -- Ключ объекта <Документ Возврат покупателя>
    IN inGoodsId                Integer   , -- Товары
    --IN inGoodsKindId            Integer   , -- Виды товаров
    IN inAmount                 TFloat    , -- Количество кг
    IN inAmountSecond           TFloat    , -- Количество шт
    IN inPrice                  TFloat    , --
    IN inComment                TVarChar  , -- 
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbWeight TFloat;
   DECLARE vbMeasureId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderGoods());
 
 
     -- проверка что внесено кг или шт
     IF COALESCE (inAmount, 0) <> 0 AND COALESCE (inAmountSecond, 0) <> 0
     THEN
     	 RAISE EXCEPTION 'Ошибка.Одновременный ввод Количества и Веса не возможен.';
     END IF;
     
     vbWeight := (SELECT ObjectFloat_Weight.ValueData
                  FROM ObjectFloat AS ObjectFloat_Weight
                  WHERE ObjectFloat_Weight.ObjectId = inGoodsId
                    AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                  );
     vbMeasureId :=COALESCE ((SELECT ObjectLink_Goods_Measure.ChildObjectId
                              FROM ObjectLink AS ObjectLink_Goods_Measure
                              WHERE ObjectLink_Goods_Measure.ObjectId = inGoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                             ),0) ;

/*
     --получаем кг или шт
     IF COALESCE (inAmount, 0) = 0 AND vbMeasureId <> zc_Measure_Sh() 
     THEN
         -- получаем вес по штукам
         inAmount := (inAmountSecond * COALESCE (vbWeight,1));
         inAmountSecond := 0;
     END IF;

     IF COALESCE (inAmountSecond, 0) = 0 AND vbMeasureId = zc_Measure_Sh() 
     THEN
         -- получаем шт по весу
         inAmountSecond := ( CASE WHEN vbWeight <> 0 THEN inAmount /vbWeight ELSE 0 END);
         inAmount := 0;
     END IF;
     */
     
     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem_OrderGoods (ioId           := ioId
                                                     , inMovementId   := inMovementId
                                                     , inGoodsId      := inGoodsId
                                                     , inAmount       := inAmount
                                                     , inAmountSecond := inAmountSecond
                                                     , inPrice        := inPrice
                                                     , inComment      := inComment
                                                     , inUserId       := vbUserId
                                                      ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.06.21         *
*/

-- тест
--