-- Function: gpInsertUpdate_MI_ProductionPeresort()

-- DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionPeresort  (Integer, Integer, Integer, TFloat, TVarChar, TDateTime, TVarChar, Integer, Integer, TVarChar, TDateTime, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionPeresort  (Integer, Integer, Integer, TFloat, TVarChar, TDateTime, TVarChar, Integer, Integer, Integer, TVarChar, TDateTime, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionPeresort  (Integer, Integer, Integer, TFloat, TVarChar, TDateTime, TVarChar, Integer, Integer, Integer, Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionPeresort  (Integer, Integer, Integer, TFloat, TVarChar, TDateTime, TVarChar, Integer, Integer, Integer, TVarChar
                                                            , TDateTime, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ProductionPeresort(
 INOUT ioId                     Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId             Integer   , -- Ключ объекта <Документ>
    IN inGoodsId                Integer   , -- Товар
    IN inAmountOut              TFloat    , -- Количество расход
  
    IN inPartionGoods           TVarChar  , -- Партия товара
    IN inPartionGoodsDate       TDateTime , -- Партия товара
    IN inComment                TVarChar  , -- Примечание	                   
    IN inGoodsKindId            Integer   , -- Виды товаров 
    IN inGoodsKindId_Complete   Integer   , -- Виды товаров
 INOUT ioGoodsChildId           Integer   , -- Товары
    IN inPartionGoodsChild      TVarChar  , -- Партия товара
    IN inPartionGoodsDateChild  TDateTime , -- Партия товара    
    IN inGoodsKindChildId       Integer   , -- Виды товаров
    IN inGoodsKindId_Complete_child  Integer   , -- Виды товаров 
    
    IN inStorageId              Integer   , -- Место хранения
    IN inStorageId_child        Integer   , -- Место хранения
 INOUT ioPartNumber             TVarChar  , -- № по тех паспорту
 INOUT ioPartNumber_child       TVarChar  , -- № по тех паспорту
 INOUT ioModel                  TVarChar  , -- Model
 INOUT ioModel_child            TVarChar  , -- Model
   
   OUT outGoodsChilCode         Integer   , --
   OUT outGoodsChildName        TVarChar  , --
   OUT outAmountIn              TFloat    , -- Количество приход  - расчет такой : outAmountIn= inAmountOut * вес  ИЛИ inAmountOut / вес ИЛИ  inAmountOut
                                                                 -- т.е. в зависимости от ед.изм. для товара приход и расход когда  они отличаются
    IN inSession                TVarChar    -- сессия пользователя
)                              
RETURNS Record AS
$BODY$
   DECLARE vbUserId          Integer;

   DECLARE vbMeasureId       Integer;
   DECLARE vbMeasureId_child Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ProductionUnion());
   

   -- меняем параметр
   IF COALESCE (ioGoodsChildId, 0) = 0 
   THEN
       ioGoodsChildId:= inGoodsId;
   END IF;
   
  
   -- поиск
   vbMeasureId:= (SELECT ObjectLink_Goods_Measure.ChildObjectId
                  FROM ObjectLink AS ObjectLink_Goods_Measure
                  WHERE ObjectLink_Goods_Measure.ObjectId = inGoodsId
                    AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure());
   -- поиск
   vbMeasureId_child:= (SELECT ObjectLink_Goods_Measure.ChildObjectId
                        FROM ObjectLink AS ObjectLink_Goods_Measure
                        WHERE ObjectLink_Goods_Measure.ObjectId = ioGoodsChildId
                          AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure());

   -- переводим Kg -> Sh
   IF vbMeasureId = zc_Measure_Sh() AND vbMeasureId_child = zc_Measure_Kg()
   THEN
       -- расчет
       outAmountIn:= (SELECT inAmountOut / ObjectFloat_Weight.ValueData 
                      FROM ObjectFloat AS ObjectFloat_Weight
                      WHERE ObjectFloat_Weight.ObjectId = inGoodsId
                        AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                        AND ObjectFloat_Weight.ValueData <> 0
                     ) ;
   ELSE
   -- переводим Sh -> Kg
   IF vbMeasureId = zc_Measure_Kg() AND vbMeasureId_child = zc_Measure_Sh()
   THEN
       -- расчет
       outAmountIn:= (SELECT inAmountOut * ObjectFloat_Weight.ValueData
                      FROM ObjectFloat AS ObjectFloat_Weight
                      WHERE ObjectFloat_Weight.ObjectId = ioGoodsChildId
                        AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                        AND ObjectFloat_Weight.ValueData <> 0
                     ) ;
   ELSE
       -- ничего не делаем
       outAmountIn:= inAmountOut;
   END IF;
   END IF;

   -- проверка
   IF COALESCE (outAmountIn, 0) = 0 AND inAmountOut <> 0
   THEN
       RAISE EXCEPTION 'Ошибка.У товара не установлено значение <Вес>.';
   END IF;

   -- сохранили
   ioId:= lpInsertUpdate_MI_ProductionPeresort (ioId                     := ioId
                                              , inMovementId             := inMovementId
                                              , inGoodsId                := inGoodsId
                                              , inGoodsId_child          := ioGoodsChildId
                                              , inGoodsKindId            := inGoodsKindId
                                              , inGoodsKindId_Complete   := inGoodsKindId_Complete
                                              , inGoodsKindId_child      := inGoodsKindChildId
                                              , inGoodsKindId_Complete_child:= inGoodsKindId_Complete_child
                                              , inAmount                 := outAmountIn
                                              , inAmount_child           := inAmountOut
                                              , inPartionGoods           := inPartionGoods
                                              , inPartionGoods_child     := inPartionGoodsChild
                                              , inPartionGoodsDate       := inPartionGoodsDate
                                              , inPartionGoodsDate_child := inPartionGoodsDateChild
                                              , inStorageId              := inStorageId                                              
                                              , inStorageId_child        := inStorageId_child
                                              , inPartNumber             := ioPartNumber
                                              , inPartNumber_child       := ioPartNumber_child
                                              , inModel                  := ioModel
                                              , inModel_child            := ioModel_child                                              
                                              , inUserId                 := vbUserId
                                               );


    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

   --
   outGoodsChildName:= (SELECT ValueData FROM Object WHERE Id = ioGoodsChildId);
   outGoodsChilCode:= (SELECT ObjectCode FROM Object WHERE Id = ioGoodsChildId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.05.23         * Model
 05.05.23         *
 17.07.15                                        * all
 29.06.15         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_ProductionPeresort (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPartionClose:= FALSE, inComment:= '', inCount:= 1, inRealWeight:= 1, inCuterCount:= 0, inReceiptId:= 0, inSession:= '2')
-- SELECT * from gpInsertUpdate_MI_ProductionPeresort(ioId := 0 , inMovementId := 597577 , inGoodsId := 2589 , inAmount := 5 , inPartionGoods := '' , inComment := '' , inGoodsKindId := 8330 , inGoodsChildId := 0 , inPartionGoodsChild := '' , inGoodsKindChildId := 0 ,  inSession := '5');
