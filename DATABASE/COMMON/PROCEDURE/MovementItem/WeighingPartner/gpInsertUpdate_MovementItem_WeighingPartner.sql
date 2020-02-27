-- Function: gpInsertUpdate_MovementItem_WeighingPartner()

-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingPartner (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, Integer, Integer, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingPartner (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TDateTime, Integer, Integer, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingPartner (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingPartner (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar);

--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingPartner (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingPartner (Integer, Integer, Integer
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TVarChar, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_WeighingPartner(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inAmountPartner       TFloat    , -- Количество у контрагента
    IN inRealWeight          TFloat    , -- Реальный вес (без учета: минус тара и % скидки для кол-ва)
    IN inChangePercentAmount TFloat    , -- % скидки для кол-ва
    IN inCountTare           TFloat    , -- Количество тары
    IN inWeightTare          TFloat    , -- Вес тары

    IN inCountTare1          TFloat    , -- Количество ящ. вида1
    IN inWeightTare1         TFloat    , -- Вес ящ. вида1
    IN inCountTare2          TFloat    , -- Количество ящ. вида2
    IN inWeightTare2         TFloat    , -- Вес ящ. вида2
    IN inCountTare3          TFloat    , -- Количество ящ. вида3
    IN inWeightTare3         TFloat    , -- Вес ящ. вида3
    IN inCountTare4          TFloat    , -- Количество ящ. вида4
    IN inWeightTare4         TFloat    , -- Вес ящ. вида4
    IN inCountTare5          TFloat    , -- Количество ящ. вида5
    IN inWeightTare5         TFloat    , -- Вес ящ. вида5
    IN inCountTare6          TFloat    , -- Количество ящ. вида6
    IN inWeightTare6         TFloat    , -- Вес ящ. вида6
        
    IN inCountPack           TFloat    , -- Количество упаковок
    IN inHeadCount           TFloat    , -- Количество голов
    IN inBoxCount            TFloat    , -- Количество Ящик(гофро)
    IN inBoxNumber           TFloat    , -- Номер ящика
    IN inLevelNumber         TFloat    , -- Номер слоя 
    IN inPrice               TFloat    , -- Цена
    IN inCountForPrice       TFloat    , -- Цена за количество
    IN inChangePercent       TFloat    , -- (-)% Скидки (+)% Наценки
    IN inPartionGoods        TVarChar  , -- Партия
    IN inPartionGoodsDate    TDateTime , -- Партия
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inPriceListId         Integer   , -- Прайс
    IN inBoxId               Integer   , -- Ящик(гофро)
    IN inMovementId_Promo    Integer   ,
    IN inIsBarCode           Boolean   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_WeighingPartner());
     vbUserId:= lpGetUserBySession (inSession);

     -- проверка - связанные документы Изменять нельзя
     -- PERFORM lfCheck_Movement_Parent (inMovementId:= inMovementId, inComment:= 'изменение');

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);
   
     -- сохранили свойство <MovementId-Акция>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PromoMovementId(), ioId, inMovementId_Promo);

     -- меняем параметр
     IF inPartionGoodsDate <= '01.01.1900' THEN inPartionGoodsDate:= NULL; END IF;
     -- сохранили свойство <Партия товара>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), ioId, inPartionGoodsDate);

     -- сохранили свойство <Партия товара>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartionGoods(), ioId, inPartionGoods);

     -- сохранили свойство <Дата/время создания>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);

     -- сохранили свойство <Количество у контрагента>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), ioId, inAmountPartner);
     -- сохранили свойство <Реальный вес (без учета: минус тара и % скидки для кол-ва)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RealWeight(), ioId, inRealWeight);
     -- сохранили свойство <% скидки для кол-ва>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercentAmount(), ioId, inChangePercentAmount);
     -- сохранили свойство <Количество тары>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare(), ioId, inCountTare);
     -- сохранили свойство <Вес тары>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare(), ioId, inWeightTare);
     -- сохранили свойство <Количество упаковок>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountPack(), ioId, inCountPack);
     -- сохранили свойство <Количество голов>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_HeadCount(), ioId, inHeadCount);
     -- сохранили свойство <Количество Ящик(гофро)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_BoxCount(), ioId, inBoxCount);
     -- сохранили свойство <Номер ящика>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_BoxNumber(), ioId, inBoxNumber);
     -- сохранили свойство <Номер слоя>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_LevelNumber(), ioId, inLevelNumber);
     -- сохранили свойство <По сканеру>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_BarCode(), ioId, inIsBarCode);

     -- сохранили свойство <Количество ящ. вида1>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare1(), ioId, inCountTare1);
     -- сохранили свойство <Вес ящ. вида1>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare1(), ioId, inWeightTare1);
     -- сохранили свойство <Количество ящ. вида2>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare2(), ioId, inCountTare2);
     -- сохранили свойство <Вес ящ. вида2>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare2(), ioId, inWeightTare2);
     -- сохранили свойство <Количество ящ. вида3>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare3(), ioId, inCountTare3);
     -- сохранили свойство <Вес ящ. вида3>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare3(), ioId, inWeightTare3);
     -- сохранили свойство <Количество ящ. вида4>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare4(), ioId, inCountTare4);
     -- сохранили свойство <Вес ящ. вида4>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare4(), ioId, inWeightTare4);
     -- сохранили свойство <Количество ящ. вида5>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare5(), ioId, inCountTare5);
     -- сохранили свойство <Вес ящ. вида5>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare5(), ioId, inWeightTare5);
     -- сохранили свойство <Количество ящ. вида6>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare6(), ioId, inCountTare6);
     -- сохранили свойство <Вес ящ. вида6>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare6(), ioId, inWeightTare6);

     -- сохранили свойство <Цена>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);
     -- сохранили свойство <Цена за количество>
     IF COALESCE (inCountForPrice, 0) = 0 THEN inCountForPrice := 1; END IF;
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, inCountForPrice);
     -- сохранили свойство <(-)% Скидки (+)% Наценки>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), ioId, inChangePercent);

     -- сохранили связь с <Виды товаров>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
     -- сохранили связь с <Прайс>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PriceList(), ioId, inPriceListId);
     -- сохранили связь с <Вид гофро. ящ.>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box(), ioId, inBoxId);


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
 27.02.20         *
 13.11.15                                        *
 13.10.14                                        * all
 13.03.14         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_WeighingPartner (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
