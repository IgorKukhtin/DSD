-- Function: gpInsertUpdate_MovementItem_Loss()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Loss (Integer, Integer, Integer, TFloat, TFloat,TFloat, TDateTime, TVarChar, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Loss (Integer, Integer, Integer, TFloat, TFloat,TFloat, TDateTime, TVarChar, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Loss (Integer, Integer, Integer, TFloat, TFloat,TFloat, TDateTime, TVarChar, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Loss(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inCount               TFloat    , -- Количество батонов или упаковок
    IN inHeadCount           TFloat    , -- Количество голов
    IN inPartionGoodsDate    TDateTime , -- Дата партии/Дата перемещения
    IN inPartionGoods        TVarChar  , -- Партия товара
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inGoodsKindCompleteId Integer   , -- Виды товаров  ГП
    IN inAssetId             Integer   , -- Основные средства (для которых закупается ТМЦ)
    IN inAssetId_top         Integer   , -- Основные средства из Шапки документа
    IN inPartionGoodsId      Integer   , -- Партии товаров (для партии расхода если с МО)
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Loss());

     -- сохранили
     ioId:= lpInsertUpdate_MovementItem_Loss (ioId                  := ioId
                                            , inMovementId          := inMovementId
                                            , inGoodsId             := inGoodsId
                                            , inAmount              := inAmount
                                            , inCount               := inCount
                                            , inHeadCount           := inHeadCount
                                            , inPartionGoodsDate    := inPartionGoodsDate
                                            , inPartionGoods        := inPartionGoods
                                            , inGoodsKindId         := inGoodsKindId
                                            , inGoodsKindCompleteId := inGoodsKindCompleteId
                                            , inAssetId             := CASE WHEN COALESCE (inAssetId,0) = 0 THEN inAssetId_top ELSE inAssetId END :: Integer
                                            , inPartionGoodsId      := inPartionGoodsId
                                            , inUserId              := vbUserId
                                             );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 10.10.14                                        * add inPartionGoodsId
 06.09.14                                        * add lpInsertUpdate_MovementItem_Loss
 01.09.14                                                       * + PartionGoodsDate
 26.05.14                                                       *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_Loss (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
