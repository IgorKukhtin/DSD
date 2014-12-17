--select * from gpInsertUpdate_MI_ProductionPeresort(ioId := 0 , inMovementId := 597577 , inGoodsId := 2589 , inAmount := 5 , inPartionGoods := '' , inComment := '' , inGoodsKindId := 8330 , inGoodsChildId := 0 , inPartionGoodsChild := '' , inGoodsKindChildId := 0 ,  inSession := '5');


-- Function: gpInsertUpdate_MI_ProductionPeresort()


DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionPeresort  (Integer, Integer, Integer, TFloat, TVarChar, TVarChar, Integer, Integer, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionPeresort  (Integer, Integer, Integer, TFloat, TVarChar, TDateTime, TVarChar, Integer, Integer, TVarChar, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ProductionPeresort(
 INOUT ioId                     Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId             Integer   , -- Ключ объекта <Документ>
    IN inGoodsId                Integer   , -- Товары
    IN inAmount                 TFloat    , -- Количество
    IN inPartionGoods           TVarChar  , -- Партия товара
    IN inPartionGoodsDate       TDateTime , -- Партия товара
    IN inComment                TVarChar  , -- Комментарий	                   
    IN inGoodsKindId            Integer   , -- Виды товаров 
    IN inGoodsChildId           Integer   , -- Товары
    IN inPartionGoodsChild      TVarChar  , -- Партия товара  
    IN inPartionGoodsDateChild  TDateTime , -- Партия товара    
    IN inGoodsKindChildId       Integer   , -- Виды товаров
    IN inSession                TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId  Integer;
   DECLARE vbChildId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ProductionUnion());
   
    -- меняем параметр
   IF inPartionGoodsDate <= '01.01.1900' THEN inPartionGoodsDate:= NULL; END IF;
   IF inPartionGoodsDateChild <= '01.01.1900' THEN inPartionGoodsDateChild:= NULL; END IF;
   
   IF COALESCE (ioId,0) <> 0
   THEN
      vbChildId := (SELECT Id FROM MovementItem where MovementId = inMovementId 
                                                  AND ParentId   = ioid
                                                  AND DescId     = zc_MI_Child()
                                                  AND isErased   = FALSE);
   END IF;

   -- сохранили <Master>
   ioId :=lpInsertUpdate_MI_ProductionUnion_Master (ioId               := ioId
                                                  , inMovementId       := inMovementId
                                                  , inGoodsId          := inGoodsId
                                                  , inAmount           := inAmount
                                                  , inPartionClose     := NULL-- ''::Boolean
                                                  , inCount            := 0 ::TFloat
                                                  , inRealWeight       := 0 ::TFloat
                                                  , inCuterCount       := 0 ::TFloat
                                                  , inPartionGoods     := inPartionGoods
                                                  , inComment          := inComment
                                                  , inGoodsKindId      := inGoodsKindId
                                                  , inReceiptId        := NULL--0 ::integer
                                                  , inUserId           := vbUserId
                                                  );


   -- сохранили свойство <Партия товара> для мастера
   PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), ioId, inPartionGoodsDate);

   -- сохранили <Child>
   vbChildId := lpInsertUpdate_MI_ProductionUnion_Child(ioId          := vbChildId
                                                 , inMovementId       := inMovementId
                                                 , inGoodsId          := inGoodsChildId
                                                 , inAmount           := inAmount
                                                 , inParentId         := ioId
                                                 , inAmountReceipt    := 0 ::TFloat
                                                 , inPartionGoodsDate := inPartionGoodsDateChild
                                                 , inPartionGoods     := inPartionGoodsChild
                                                 , inComment          := NULL--'' ::TVarChar
                                                 , inGoodsKindId      := inGoodsKindChildId
                                                 , inUserId           := vbUserId
                                                 );


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.12.14         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_ProductionPeresort (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPartionClose:= FALSE, inComment:= '', inCount:= 1, inRealWeight:= 1, inCuterCount:= 0, inReceiptId:= 0, inSession:= '2')
--select * from gpInsertUpdate_MI_ProductionPeresort(ioId := 0 , inMovementId := 597577 , inGoodsId := 2589 , inAmount := 5 , inPartionGoods := '' , inComment := '' , inGoodsKindId := 8330 , inGoodsChildId := 0 , inPartionGoodsChild := '' , inGoodsKindChildId := 0 ,  inSession := '5');