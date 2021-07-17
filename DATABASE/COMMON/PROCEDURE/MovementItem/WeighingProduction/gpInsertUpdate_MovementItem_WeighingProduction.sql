-- Function: gpInsertUpdate_MovementItem_WeighingProduction()

-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingProduction (Integer, Integer, Integer, TFloat, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingProduction (Integer, Integer, Integer, TFloat, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar, Integer, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingProduction (Integer, Integer, Integer, TFloat, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingProduction (Integer, Integer, Integer, TFloat, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_WeighingProduction(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inIsStartWeighing     Boolean   , -- Режим начала взвешивания
    IN inRealWeight          TFloat    , -- Реальный вес (без учета: минус тара и прочее)
    IN inWeightTare          TFloat    , -- Вес тары
    IN inLiveWeight          TFloat    , -- Живой вес
    IN inHeadCount           TFloat    , -- Количество голов
    IN inCount               TFloat    , -- Количество батонов
    IN inCountPack           TFloat    , -- Количество упаковок
    IN inCountSkewer1        TFloat    , -- Количество шпажек/крючков вида1
    IN inWeightSkewer1       TFloat    , -- Вес одной шпажки/крючка вида1
    IN inCountSkewer2        TFloat    , -- Количество шпажек вида2
    IN inWeightSkewer2       TFloat    , -- Вес одной шпажки вида2
    IN inWeightOther         TFloat    , -- Вес, прочее
    IN inPartionGoodsDate    TDateTime , -- Партия товара (дата)
    IN inPartionGoods        TVarChar  , -- Партия товара
    IN inNumberKVK           TVarChar  , -- № КВК
    IN inMovementItemId      Integer   , -- 
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inStorageLineId       Integer   , -- Линия пр-ва
    IN inPersonalId_KVK      Integer   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_WeighingProduction());
     vbUserId:= lpGetUserBySession (inSession);

     -- проверка - связанные документы Изменять нельзя
     -- PERFORM lfCheck_Movement_Parent (inMovementId:= inMovementId, inComment:= 'изменение');

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);
   
     -- сохранили свойство <Режим начала взвешивания>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_StartWeighing(), ioId, inIsStartWeighing);

     -- сохранили свойство <Дата/время создания>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);

     -- сохранили свойство <Реальный вес (без учета: минус тара и прочее)
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RealWeight(), ioId, inRealWeight);
     -- сохранили свойство <Вес тары>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare(), ioId, inWeightTare);
     -- сохранили свойство <Живой вес>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_LiveWeight(), ioId, inLiveWeight);
     -- сохранили свойство <Количество голов>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_HeadCount(), ioId, inHeadCount);
     -- сохранили свойство <Количество батонов>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Count(), ioId, inCount);
     -- сохранили свойство <Количество упаковок>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountPack(), ioId, inCountPack);


     -- сохранили свойство <Количество шпажек/крючков вида1>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountSkewer1(), ioId, inCountSkewer1);
     -- сохранили свойство <Вес одной шпажки/крючка вида1>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightSkewer1(), ioId, inWeightSkewer1);
     -- сохранили свойство <Количество шпажек вида2>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountSkewer2(), ioId, inCountSkewer2);
     -- сохранили свойство <Вес одной шпажки вида2>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightSkewer2(), ioId, inWeightSkewer2);
     -- сохранили свойство <Вес, прочее>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightOther(), ioId, inWeightOther);

     -- сохранили свойство <MovementItemId - Партия производства>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementItemId(), ioId, inMovementItemId);

     -- сохранили свойство <Партия товара (дата)>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), ioId, inPartionGoodsDate);
     -- сохранили свойство <Партия товара>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartionGoods(), ioId, inPartionGoods);
     -- сохранили свойство <№ КВК>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_KVK(), ioId, inNumberKVK);

     -- сохранили связь с <Виды товаров>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
     -- сохранили связь с <Линия пр-ва>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_StorageLine(), ioId, inStorageLineId);
     -- сохранили связь с <Оператор КВК(Ф.И.О)>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PersonalKVK(), ioId, inPersonalId_KVK);
     
    
     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.05.15                                        * all
 13.03.14         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_WeighingProduction (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
