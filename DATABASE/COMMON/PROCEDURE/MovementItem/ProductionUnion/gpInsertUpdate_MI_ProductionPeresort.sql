-- Function: gpInsertUpdate_MI_ProductionPeresort()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionPeresort  (Integer, Integer, Integer, TFloat, TVarChar, TDateTime, TVarChar, Integer, Integer, TVarChar, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ProductionPeresort(
 INOUT ioId                     Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId             Integer   , -- Ключ объекта <Документ>
    IN inGoodsId                Integer   , -- Товар
    IN inAmount                 TFloat    , -- Количество
    IN inPartionGoods           TVarChar  , -- Партия товара
    IN inPartionGoodsDate       TDateTime , -- Партия товара
    IN inComment                TVarChar  , -- Примечание	                   
    IN inGoodsKindId            Integer   , -- Виды товаров 
 INOUT ioGoodsChildId           Integer   , -- Товары
    IN inPartionGoodsChild      TVarChar  , -- Партия товара  
    IN inPartionGoodsDateChild  TDateTime , -- Партия товара    
    IN inGoodsKindChildId       Integer   , -- Виды товаров
   OUT outGoodsChilCode         Integer   , --
   OUT outGoodsChildName        TVarChar  , --
    IN inSession                TVarChar    -- сессия пользователя
)                              
RETURNS Record AS
$BODY$
   DECLARE vbUserId  Integer;
   DECLARE vbChildId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ProductionUnion());
   
   -- меняем параметр
   IF COALESCE (ioGoodsChildId, 0) = 0 
   THEN
       ioGoodsChildId:= inGoodsId;
   END IF;
   --
   outGoodsChildName:= (SELECT ValueData FROM Object WHERE Id = ioGoodsChildId);
   outGoodsChilCode:= (SELECT ObjectCode FROM Object WHERE Id = ioGoodsChildId);

   
   IF COALESCE (ioId,0) <> 0
   THEN
      vbChildId := (SELECT Id FROM MovementItem WHERE MovementId = inMovementId 
                                                  AND ParentId   = ioId
                                                  AND DescId     = zc_MI_Child());
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
                                                  , inUserId           := vbUserId
                                                   );


   -- сохранили свойство <Партия товара> для мастера
   PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), ioId, inPartionGoodsDate);

   -- сохранили <Child>
   vbChildId := lpInsertUpdate_MI_ProductionUnion_Child (ioId               := vbChildId
                                                       , inMovementId       := inMovementId
                                                       , inGoodsId          := ioGoodsChildId
                                                       , inAmount           := inAmount
                                                       , inParentId         := ioId
                                                       , inPartionGoodsDate := inPartionGoodsDateChild
                                                       , inPartionGoods     := inPartionGoodsChild
                                                       , inGoodsKindId      := inGoodsKindChildId
                                                       , inUserId           := vbUserId
                                                        );


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.03.15                                        * all
 26.12.14                                        *
 11.12.14         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_ProductionPeresort (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPartionClose:= FALSE, inComment:= '', inCount:= 1, inRealWeight:= 1, inCuterCount:= 0, inReceiptId:= 0, inSession:= '2')
-- select * from gpInsertUpdate_MI_ProductionPeresort(ioId := 0 , inMovementId := 597577 , inGoodsId := 2589 , inAmount := 5 , inPartionGoods := '' , inComment := '' , inGoodsKindId := 8330 , inGoodsChildId := 0 , inPartionGoodsChild := '' , inGoodsKindChildId := 0 ,  inSession := '5');
