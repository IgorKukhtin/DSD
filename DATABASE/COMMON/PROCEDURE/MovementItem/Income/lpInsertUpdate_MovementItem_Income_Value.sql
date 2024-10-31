-- Function: lpInsertUpdate_MovementItem_Income_Value()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Income_Value (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Income_Value (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Income_Value (
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inAmountPartner       TFloat    , -- Количество у контрагента
    IN inAmountPartnerSecond TFloat    , -- Количество у контрагента
    IN inAmountPacker        TFloat    , -- Количество у заготовителя
    IN inPrice               TFloat    , -- Цена
    IN inCountForPrice       TFloat    , -- Цена за количество
    IN inPricePartner        TFloat    , -- Цена у контрагента
    IN inLiveWeight          TFloat    , -- Живой вес
    IN inHeadCount           TFloat    , -- Количество голов
    IN inPartionGoods        TVarChar  , -- Партия товара 
    IN inPartNumber          TVarChar  , -- № по тех паспорту 
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inAssetId             Integer   , -- Основные средства (для которых закупается ТМЦ) 
    IN inStorageId           Integer   , -- Место хранения
    IN inUserId              Integer     -- пользователь
   )
RETURNS Integer
AS
$BODY$
BEGIN

     --
     ioId:= lpInsertUpdate_MovementItem_Income (ioId                  := ioId
                                              , inMovementId          := inMovementId
                                              , inGoodsId             := inGoodsId
                                              , inAmount              := inAmount
                                              , inAmountPartner       := inAmountPartner
                                              , inAmountPacker        := inAmountPacker
                                              , inPrice               := inPrice
                                              , inCountForPrice       := inCountForPrice
                                              , inLiveWeight          := inLiveWeight
                                              , inHeadCount           := inHeadCount
                                              , inPartionGoods        := inPartionGoods
                                              , inPartNumber          := inPartNumber
                                              , inGoodsKindId         := inGoodsKindId
                                              , inAssetId             := inAssetId
                                              , inStorageId           := inStorageId
                                              , inUserId              := inUserId
                                               );

     -- сохранили свойство <Цена поставщика для Сырья>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartnerSecond(), ioId, inAmountPartnerSecond);

     -- сохранили свойство <Цена поставщика для Сырья>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PricePartner(), ioId, inPricePartner);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.10.24                                        *
*/

-- тест
-- 
