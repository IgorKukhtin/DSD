-- Function: lpInsertUpdate_MovementItem_Send_Value()

-- DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Send_Value (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Send_Value (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Send_Value (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Send_Value(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inPartionGoodsDate    TDateTime , -- Дата партии
    IN inCount               TFloat    , -- Количество батонов или упаковок
    IN inHeadCount           TFloat    , -- Количество голов
    IN inPartionGoods        TVarChar  , -- Партия товара/Инвентарный номер 
    IN inPartNumber          TVarChar  , -- Сер номер
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inAssetId             Integer   , -- Основные средства (для которых закупается ТМЦ)
    IN inAssetId_two         Integer   , -- Основные средства (для которых закупается ТМЦ)
    IN inUnitId              Integer   , -- Подразделение (для МО)
    IN inStorageId           Integer   , -- Место хранения
    IN inPartionModelId      Integer   , -- Модель
    IN inPartionGoodsId      Integer   , -- Партии товаров (для партии расхода если с МО)
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- сохранили
     ioId:=
    (SELECT tmp.ioId
     FROM lpInsertUpdate_MovementItem_Send (ioId                  := ioId
                                          , inMovementId          := inMovementId
                                          , inGoodsId             := inGoodsId
                                          , inAmount              := inAmount
                                          , inPartionGoodsDate    := inPartionGoodsDate
                                          , inCount               := inCount
                                          , inHeadCount           := inHeadCount
                                          , ioPartionGoods        := inPartionGoods
                                          , ioPartNumber          := inPartNumber
                                          , inGoodsKindId         := inGoodsKindId
                                          , inGoodsKindCompleteId := NULL
                                          , inAssetId             := inAssetId 
                                          , inAssetId_two         := inAssetId_two
                                          , inUnitId              := inUnitId
                                          , inStorageId           := inStorageId
                                          , inPartionModelId      := inPartionModelId
                                          , inPartionGoodsId      := inPartionGoodsId
                                          , inUserId              := inUserId
                                           ) AS tmp);

     -- сохранили связь с <Оборудовании-2 (выработка)>
     --PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Asset_two(), ioId, inAssetId_two);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 29.05.15                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItem_Send_Value (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
