-- Function: lpInsertUpdate_MovementItem_Sale_Value()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Sale_Value (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Sale_Value (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Sale_Value (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, TFloat, TFloat, TFloat, Boolean, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Sale_Value (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Sale_Value (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Sale_Value(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inAmountPartner       TFloat    , -- Количество у контрагента
    IN inAmountChangePercent TFloat    , -- Количество c учетом % скидки
    IN inChangePercentAmount TFloat    , -- % скидки для кол-ва
    IN inPrice               TFloat    , -- Цена
    IN ioCountForPrice       TFloat    , -- Цена за количество
    IN inCount               TFloat    , -- Количество батонов или упаковок
    IN inHeadCount           TFloat    , -- Количество голов
    IN inBoxCount            TFloat    , -- Количество ящиков
    IN inPartionGoods        TVarChar  , -- Партия товара
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inAssetId             Integer   , -- Основные средства (для которых закупается ТМЦ)
    IN inBoxId               Integer   , -- Ящики
--    IN inCountPack           TFloat    , -- Количество упаковок (расчет)
--    IN inWeightTotal         TFloat    , -- Вес 1 ед. продукции + упаковка
--    IN inWeightPack          TFloat    , -- Вес упаковки для 1-ой ед. продукции
    IN inIsBarCode           Boolean   , -- 
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbCountPack TFloat;
   DECLARE vbWeightTotal TFloat;
   DECLARE vbWeightPack TFloat;
   DECLARE vbPartionGoodsDate TDateTime;
BEGIN

     -- !!!скидка - вес упаковки!!!
     IF inIsBarCode = TRUE
     THEN
         -- получили значения для упаковки
         SELECT ObjectFloat_WeightPackage.ValueData, ObjectFloat_WeightTotal.ValueData
                INTO vbWeightPack, vbWeightTotal
         FROM Object_GoodsByGoodsKind_View
              LEFT JOIN ObjectFloat AS ObjectFloat_WeightPackage
                                    ON ObjectFloat_WeightPackage.ObjectId = Object_GoodsByGoodsKind_View.Id 
                                   AND ObjectFloat_WeightPackage.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightPackage()
              LEFT JOIN ObjectFloat AS ObjectFloat_WeightTotal
                                    ON ObjectFloat_WeightTotal.ObjectId = Object_GoodsByGoodsKind_View.Id 
                                   AND ObjectFloat_WeightTotal.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightTotal()
         WHERE Object_GoodsByGoodsKind_View.GoodsId = inGoodsId 
           AND Object_GoodsByGoodsKind_View.GoodsKindId = inGoodsKindId;
         -- расчет кол-во шт. упаковки (пока округление до 4-х знаков)
         vbCountPack:= CASE WHEN vbWeightTotal <> 0
                                 THEN CAST (inAmount / vbWeightTotal AS NUMERIC (16, 4))
                            ELSE 0
                       END;
     END IF;
     
     vbPartionGoodsDate:= zfConvert_StringToDate (inPartionGoods);

     -- сохранили
     SELECT tmp.ioId INTO ioId
     FROM lpInsertUpdate_MovementItem_Sale (ioId                 := ioId
                                          , inMovementId         := inMovementId
                                          , inGoodsId            := inGoodsId
                                          , inAmount             := inAmount
                                          , inAmountPartner      := inAmountPartner
                                          , inAmountChangePercent:= inAmountChangePercent
                                          , inChangePercentAmount:= inChangePercentAmount
                                          , ioPrice              := inPrice
                                          , ioCountForPrice      := ioCountForPrice 
                                          , inCount              := inCount
                                          , inHeadCount          := inHeadCount
                                          , inBoxCount           := inBoxCount
                                          , inPartionGoods       := CASE WHEN vbPartionGoodsDate > zc_DateStart() THEN '' ELSE inPartionGoods END
                                          , inGoodsKindId        := inGoodsKindId
                                          , inAssetId            := inAssetId
                                          , inBoxId              := inBoxId
                                          , inCountPack          := COALESCE (vbCountPack, 0)
                                          , inWeightTotal        := COALESCE (vbWeightTotal,0)
                                          , inWeightPack         := COALESCE (vbWeightPack,0)
                                          , inIsBarCode          := inIsBarCode

                                          , inUserId             := inUserId
                                           ) AS tmp;


     -- дописали свойство <Партия товара-дата>
     IF vbPartionGoodsDate > zc_DateStart()
     THEN
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), ioId, vbPartionGoodsDate);
     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 13.11.15                                        *
 04.02.15                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItem_Sale_Value (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
