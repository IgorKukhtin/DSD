-- Function: gpInsertUpdate_MovementItem_WeighingProduction()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingProduction (Integer, Integer, Integer, TFloat, Boolean, TFloat,TFloat,TFloat,TFloat,TFloat, TFloat,TFloat,TFloat,TFloat,TFloat,  TDateTime, TVarChar,Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_WeighingProduction(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inStartWeighing       Boolean   , -- Режим начала взвешивания
    IN inRealWeight          TFloat    , -- Реальный вес (без учета % скидки для кол-ва)
    IN inWeightTare          TFloat    , -- Вес тары
    IN inLiveWeight          TFloat    , -- Живой вес
    IN inHeadCount           TFloat    , -- Количество голов
    IN inCount               TFloat    , -- Количество батонов или упаковок
    IN inCountSkewer1        TFloat    , -- Количество шпажек вида1
    IN inWeightSkewer1       TFloat    , -- Вес шпажек вида1
    IN inCountSkewer2        TFloat    , -- Количество шпажек вида2
    IN inWeightSkewer2       TFloat    , -- Вес шпажек вида2
    IN inWeightOther         TFloat    , -- Вес, прочее
    IN inPartionGoodsDate    TDateTime , -- Партия
    IN inPartionGoods        TVarChar  , -- Партия товара
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_WeighingProduction());

     -- проверка - связанные документы Изменять нельзя
     -- PERFORM lfCheck_Movement_Parent (inMovementId:= inMovementId, inComment:= 'изменение');

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);
   
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RealWeight(), ioId, inRealWeight);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare(), ioId, inWeightTare);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_LiveWeight(), ioId, inLiveWeight);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_HeadCount(), ioId, inHeadCount);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Count(), ioId, inCount);


     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountSkewer1(), ioId, inCountSkewer1);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightSkewer1(), ioId, inWeightSkewer1);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountSkewer2(), ioId, inCountSkewer2);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightSkewer2(), ioId, inWeightSkewer2);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightOther(), ioId, inWeightOther);


     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemIDate (zc_MIFIDate_PartionGoods(), ioId, inPartionGoodsDate);
     -- сохранили свойство <Партия товара>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartionGoods(), ioId, inPartionGoods);

     -- сохранили связь с <Виды товаров>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
    
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
 13.03.14         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_WeighingProduction (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
