-- Function: gpInsertUpdate_MI_ProductionUnion_Master()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Master  (Integer, Integer, Integer, TFloat, Boolean , TFloat, TFloat, TFloat, TVarChar,TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ProductionUnion_Master(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inPartionClose	     Boolean   , -- партия закрыта (да/нет)        	
    IN inCount	             TFloat    , -- Количество батонов или упаковок 
    IN inRealWeight          TFloat    , -- Фактический вес(информативно)
    IN inCuterCount          TFloat    , -- Количество кутеров
    IN inPartionGoods        TVarChar  , -- Партия товара
    IN inComment             TVarChar  , -- Комментарий	                   
    IN inGoodsKindId         Integer   , -- Виды товаров 
    IN inReceiptId           Integer   , -- Рецептуры	                   
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ProductionUnion());

   -- сохранили <Элемент документа>
   ioId :=lpInsertUpdate_MI_ProductionUnion_Master (ioId               := ioId
                                                  , inMovementId       := inMovementId
                                                  , inGoodsId          := inGoodsId
                                                  , inAmount           := inAmount
                                                  , inPartionClose     := inPartionClose
                                                  , inCount            := inCount
                                                  , inRealWeight       := inRealWeight
                                                  , inCuterCount       := inCuterCount
                                                  , inPartionGoods     := inPartionGoods
                                                  , inComment          := inComment
                                                  , inGoodsKindId      := inGoodsKindId
                                                  , inReceiptId        := inReceiptId
                                                  , inUserId           := vbUserId
                                                  );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.12.14         * add lpInsertUpdate_MI_ProductionUnion_Master

 24.07.13                                        * Важен порядок полей
 22.07.13         * add GoodsKind
 17.07.13         *              
 30.06.13                                        *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_ProductionUnion_Master (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPartionClose:= FALSE, inComment:= '', inCount:= 1, inRealWeight:= 1, inCuterCount:= 0, inReceiptId:= 0, inSession:= '2')
