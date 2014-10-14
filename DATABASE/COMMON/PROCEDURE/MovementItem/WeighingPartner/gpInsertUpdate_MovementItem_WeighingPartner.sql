-- Function: gpInsertUpdate_MovementItem_WeighingPartner()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingPartner (Integer, Integer, Integer, TFloat, TFloat,TFloat,TFloat,TFloat,TFloat, TDateTime, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingPartner (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_WeighingPartner(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inRealWeight          TFloat    , -- Реальный вес (без учета % скидки для кол-ва)
    IN inChangePercentAmount TFloat    , -- % скидки для кол-ва
    IN inCountTare           TFloat    , -- Количество тары
    IN inWeightTare          TFloat    , -- Вес тары
    IN inCount               TFloat    , -- Количество батонов или упаковок
    IN inBoxCount            TFloat    , -- Количество Ящик(гофро)
    IN inBoxNumber           TFloat    , -- Номер ящика
    IN inLevelNumber         TFloat    , -- Номер слоя 
    IN inPrice               TFloat    , -- Цена
    IN inCountForPrice       TFloat    , -- Цена за количество
    IN inPartionGoodsDate    TDateTime , -- Партия
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inPriceListId         Integer   , -- Прайс
    IN inBoxId               Integer   , -- Ящик(гофро)
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_WeighingPartner());

     -- проверка - связанные документы Изменять нельзя
     -- PERFORM lfCheck_Movement_Parent (inMovementId:= inMovementId, inComment:= 'изменение');

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);
   
     -- сохранили свойство <Партия товара>
     PERFORM lpInsertUpdate_MovementItemIDate (zc_MIFIDate_PartionGoods(), ioId, inPartionGoodsDate);

     -- сохранили свойство <Реальный вес (без учета % скидки для кол-ва)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RealWeight(), ioId, inRealWeight);
     -- сохранили свойство <% скидки для кол-ва>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercentAmount(), ioId, inChangePercentAmount);
     -- сохранили свойство <Количество тары>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare(), ioId, inCountTare);
     -- сохранили свойство <Вес тары>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare(), ioId, inWeightTare);
     -- сохранили свойство <Количество батонов или упаковок>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Count(), ioId, inCount);
     -- сохранили свойство <Количество Ящик(гофро)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_BoxCount(), ioId, inBoxCount);
     -- сохранили свойство <Номер ящика>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_BoxNumber(), ioId, inBoxNumber);
     -- сохранили свойство <Номер слоя>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_LevelNumber(), ioId, inLevelNumber);

     -- сохранили связь с <Виды товаров>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
     -- сохранили связь с <Прайс>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PriceList(), ioId, inPriceListId);
     -- сохранили связь с <Прайс>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box(), ioId, inBoxId);
    
     -- создали объект <Связи Товары и Виды товаров>
     PERFORM lpInsert_Object_GoodsByGoodsKind (inGoodsId, inGoodsKindId, vbUserId);

     -- сохранили протокол
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.10.14                                        * all
 13.03.14         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_WeighingPartner (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
