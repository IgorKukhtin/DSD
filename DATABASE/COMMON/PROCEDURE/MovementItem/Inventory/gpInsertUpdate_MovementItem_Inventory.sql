-- Function: gpInsertUpdate_MovementItem_Inventory()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Inventory(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ Возврат поставщику>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inPartionGoodsDate    TDateTime , -- Дата партии/Дата перемещения
    IN inPrice               TFloat    , -- Цена
    IN inSumm                TFloat    , -- Сумма
    IN inHeadCount           TFloat    , -- Количество голов
    IN inCount               TFloat    , -- Количество батонов или упаковок
    IN inPartionGoods        TVarChar  , -- Партия товара/Инвентарный номер
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inGoodsKindCompleteId Integer   , -- Виды товаров  ГП
    IN inAssetId             Integer   , -- Основные средства (для которых закупается ТМЦ)
    IN inUnitId              Integer   , -- Подразделение (для МО)
    IN inStorageId           Integer   , -- Место хранения
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());

     -- меняем параметр
     IF inPartionGoodsDate <= '01.01.1900' THEN inPartionGoodsDate:= NULL; END IF;

     -- сохранили
     ioId:= lpInsertUpdate_MovementItem_Inventory (ioId                 := ioId
                                                 , inMovementId         := inMovementId
                                                 , inGoodsId            := inGoodsId
                                                 , inAmount             := inAmount
                                                 , inPartionGoodsDate   := inPartionGoodsDate
                                                 , inPrice              := inPrice
                                                 , inSumm               := inSumm
                                                 , inHeadCount          := inHeadCount
                                                 , inCount              := inCount
                                                 , inPartionGoods       := inPartionGoods
                                                 , inGoodsKindId        := inGoodsKindId
                                                 , inGoodsKindCompleteId:= inGoodsKindCompleteId
                                                 , inAssetId            := inAssetId
                                                 , inUnitId             := inUnitId
                                                 , inStorageId          := inStorageId
                                                 , inUserId             := vbUserId
                                                  ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 25.04.05         * add lpInsertUpdate_MovementItem_Inventory
 26.07.14                                        * add inPrice and inUnitId and inStorageId
 21.08.13                                        * add inGoodsKindId
 18.07.13         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_Inventory (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
