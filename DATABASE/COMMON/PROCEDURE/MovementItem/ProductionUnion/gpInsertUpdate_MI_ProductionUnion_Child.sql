

-- Function: gpInsertUpdate_MI_ProductionUnion_Child()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Child (Integer, Integer, Integer, TFloat, Integer, TFloat, TDateTime, TVarChar,TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ProductionUnion_Child(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ Производство - смешивание>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inParentId            Integer   , -- Главный элемент документа
    IN inAmountReceipt       TFloat    , -- Количество по рецептуре на 1 кутер 
    IN inPartionGoodsDate    TDateTime , -- Партия товара	
    IN inPartionGoods        TVarChar  , -- Партия товара        
    IN inComment             TVarChar  , -- Комментарий
    IN inGoodsKindId         Integer   , -- Виды товаров            
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ProductionUnion());

   -- меняем параметр
   IF inPartionGoodsDate <= '01.01.1900' THEN inPartionGoodsDate:= NULL; END IF;

   -- сохранили 
   ioId := lpInsertUpdate_MI_ProductionUnion_Child(ioId               := ioId
                                                 , inMovementId       := inMovementId
                                                 , inGoodsId          := inGoodsId
                                                 , inAmount           := inAmount
                                                 , inParentId         := inParentId
                                                 , inAmountReceipt    := inAmountReceipt
                                                 , inPartionGoodsDate := inPartionGoodsDate
                                                 , inPartionGoods     := inPartionGoods
                                                 , inComment          := inComment
                                                 , inGoodsKindId      := inGoodsKindId
                                                 , inUserId           := vbUserId
                                                 );
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.12.14         * add lpInsertUpdate_MI_ProductionUnion_Child
 24.07.13                                        * Важен порядок полей
 15.07.13         *     
 30.06.13                                        *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_ProductionUnion_Child (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inParentId:= NULL, inAmountReceipt:= 1, inComment:= '', inSession:= '2')
