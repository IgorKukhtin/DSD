-- Function: gpInsertUpdate_MovementItem_Send()
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SendMember (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SendMember (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_SendMember(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inGoodsId               Integer   , -- Товары
    IN inAmount                TFloat    , -- Количество
    IN inPartionGoodsDate      TDateTime , -- Дата партии
    IN inCount                 TFloat    , -- Количество батонов или упаковок
    IN inHeadCount             TFloat    , -- Количество голов
 INOUT ioPartionGoods          TVarChar  , -- Партия товара/Инвентарный номер
 INOUT ioPartNumber            TVarChar  , -- № по тех паспорту
    IN inGoodsKindId           Integer   , -- Виды товаров
    IN inGoodsKindCompleteId   Integer   , -- Виды товаров  ГП
    IN inAssetId               Integer   , -- Основные средства (для которых закупается ТМЦ)
    IN inUnitId                Integer   , -- Подразделение (для МО)
    IN inStorageId             Integer   , -- Место хранения
    IN inPartionModelId        Integer   , -- Модель
    IN inPartionGoodsId        Integer   , -- Партии товаров (для партии расхода если с МО)
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SendMember());

     -- сохранили
     SELECT tmp.ioId, tmp.ioPartionGoods , tmp.ioPartNumber
            INTO ioId, ioPartionGoods, ioPartNumber
     FROM lpInsertUpdate_MovementItem_Send (ioId                  := ioId
                                          , inMovementId          := inMovementId
                                          , inGoodsId             := inGoodsId
                                          , inAmount              := inAmount
                                          , inPartionGoodsDate    := inPartionGoodsDate
                                          , inCount               := inCount
                                          , inHeadCount           := inHeadCount
                                          , ioPartionGoods        := ioPartionGoods
                                          , ioPartNumber          := ioPartNumber
                                          , inGoodsKindId         := inGoodsKindId
                                          , inGoodsKindCompleteId := inGoodsKindCompleteId
                                          , inAssetId             := inAssetId 
                                          , inAssetId_two         := Null
                                          , inUnitId              := inUnitId
                                          , inStorageId           := inStorageId 
                                          , inPartionModelId      := inPartionModelId
                                          , inPartionGoodsId      := inPartionGoodsId
                                          , inUserId              := vbUserId
                                           ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 28.11.17         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_SendMember (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
