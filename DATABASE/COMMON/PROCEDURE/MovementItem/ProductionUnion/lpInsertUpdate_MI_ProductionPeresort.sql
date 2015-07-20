-- Function: lpInsertUpdate_MI_ProductionPeresort()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionPeresort  (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar, TDateTime, TDateTime, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionPeresort  (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar, TDateTime, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_ProductionPeresort(
 INOUT ioId                     Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId             Integer   , -- Ключ объекта <Документ>
    IN inGoodsId                Integer   , -- Товар
    IN inGoodsId_child          Integer   , -- Товары
    IN inGoodsKindId            Integer   , -- Виды товаров 
    IN inGoodsKindId_child      Integer   , -- Виды товаров
    IN inAmount                 TFloat    , -- Количество приход
    IN inAmount_child           TFloat    , -- Количество расход
    IN inPartionGoods           TVarChar  , -- Партия товара
    IN inPartionGoods_child     TVarChar  , -- Партия товара  
    IN inPartionGoodsDate       TDateTime , -- Партия товара
    IN inPartionGoodsDate_child TDateTime , -- Партия товара    
    IN inUserId                 Integer     -- пользователя
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbId_child Integer;
BEGIN
   -- поиск
   IF COALESCE (ioId, 0) <> 0
   THEN
      vbId_child := (SELECT Id FROM MovementItem WHERE MovementId = inMovementId AND ParentId = ioId AND DescId = zc_MI_Child() AND isErased = FALSE);
   END IF;

   -- сохранили <Master>
   ioId:= lpInsertUpdate_MI_ProductionUnion_Master (ioId               := ioId
                                                  , inMovementId       := inMovementId
                                                  , inGoodsId          := inGoodsId
                                                  , inAmount           := inAmount
                                                  , inCount            := 0
                                                  , inPartionGoodsDate := inPartionGoodsDate
                                                  , inPartionGoods     := inPartionGoods
                                                  , inGoodsKindId      := inGoodsKindId
                                                  , inUserId           := inUserId
                                                   );

   -- сохранили <Child>
   PERFORM lpInsertUpdate_MI_ProductionUnion_Child (ioId               := vbId_child
                                                  , inMovementId       := inMovementId
                                                  , inGoodsId          := inGoodsId_child
                                                  , inAmount           := inAmount_child
                                                  , inParentId         := ioId
                                                  , inPartionGoodsDate := inPartionGoodsDate_child
                                                  , inPartionGoods     := inPartionGoods_child
                                                  , inGoodsKindId      := inGoodsKindId_child
                                                  , inUserId           := inUserId
                                                   );


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.07.15                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MI_ProductionPeresort (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPartionClose:= FALSE, inComment:= '', inCount:= 1, inRealWeight:= 1, inCuterCount:= 0, inReceiptId:= 0, inSession:= '2')
-- SELECT * from lpInsertUpdate_MI_ProductionPeresort(ioId := 0 , inMovementId := 597577 , inGoodsId := 2589 , inAmount := 5 , inPartionGoods := '' , inComment := '' , inGoodsKindId := 8330 , inGoodsChildId := 0 , inPartionGoodsChild := '' , inGoodsKindChildId := 0 ,  inSession := '5');
