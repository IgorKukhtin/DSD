-- Function: gpInsertUpdate_MI_ProductionPeresort()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionPeresort  (Integer, Integer, Integer, TFloat, TVarChar,TVarChar, Integer, Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ProductionPeresort(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
--    IN inPartionClose	     Boolean   , -- партия закрыта (да/нет)        	
--    IN inCount	     TFloat    , -- Количество батонов или упаковок 
--    IN inRealWeight        TFloat    , -- Фактический вес(информативно)
--    IN inCuterCount        TFloat    , -- Количество кутеров
    IN inPartionGoods        TVarChar  , -- Партия товара
    IN inComment             TVarChar  , -- Комментарий	                   
    IN inGoodsKindId         Integer   , -- Виды товаров 
--    IN inReceiptId         Integer   , -- Рецептуры	


    IN inGoodsChildId        Integer   , -- Товары

--    IN inParentId            Integer   , -- Главный элемент документа
--    IN inAmountReceipt       TFloat    , -- Количество по рецептуре на 1 кутер 
--    IN inPartionGoodsDate    TDateTime , -- Партия товара	
    IN inPartionGoodsChild     TVarChar  , -- Партия товара        
--    IN inComment             TVarChar  , -- Комментарий
    IN inGoodsKindChildId    Integer   , -- Виды товаров

                   
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId  Integer;
   DECLARE vbChildId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ProductionUnion());
   
   IF COALESCE (ioId,0) <> 0
   THEN
      vbChildId := (SELECT Id FROM MovementItem where MovementId = inMovementId
                                                  AND DescId     = zc_MI_Child()
                                                  AND isErased   = FALSE);
   END IF;

   -- сохранили <Master>
   ioId :=lpInsertUpdate_MI_ProductionUnion_Master (ioId               := ioId
                                                  , inMovementId       := inMovementId
                                                  , inGoodsId          := inGoodsId
                                                  , inAmount           := inAmount
                                                  , inPartionClose     := ''::Boolean
                                                  , inCount            := NULL--0 ::TFloat
                                                  , inRealWeight       := NULL--0 ::TFloat
                                                  , inCuterCount       := NULL--0 ::TFloat
                                                  , inPartionGoods     := inPartionGoods
                                                  , inComment          := inComment
                                                  , inGoodsKindId      := inGoodsKindId
                                                  , inReceiptId        := NULL--0 ::integer
                                                  , inUserId           := vbUserId
                                                  );



   -- сохранили <Child>
   vbChildId := lpInsertUpdate_MI_ProductionUnion_Child(ioId          := vbChildId
                                                 , inMovementId       := inMovementId
                                                 , inGoodsId          := inGoodsChildId
                                                 , inAmount           := inAmount
                                                 , inParentId         := ioId
                                                 , inAmountReceipt    := NULL--inAmountReceipt
                                                 , inPartionGoodsDate := NULL
                                                 , inPartionGoods     := inPartionGoods
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
