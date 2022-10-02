-- Function: gpInsertUpdate_MovementItem_Sale()

--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Sale(
 INOUT ioId                      Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId              Integer   , -- Ключ объекта <Документ>
    IN inGoodsId                 Integer   , -- Товары
 INOUT ioAmount                  TFloat    , -- Количество
 INOUT ioAmountPartner           TFloat    , -- Количество у контрагента
   OUT outAmountChangePercent    TFloat    , -- Количество c учетом % скидки (!!!расчет!!!)
    IN inChangePercentAmount     TFloat    , -- % скидки для кол-ва (!!!из контрола!!!)
 INOUT ioChangePercentAmount     TFloat    , -- % скидки для кол-ва (!!!из грида!!!)
    IN inIsChangePercentAmount   Boolean   , -- Признак - будет ли использоваться из контрола <% скидки для кол-ва>
    IN inIsCalcAmountPartner     Boolean   , -- Признак - будет ли расчитано <Количество у контрагента>
 INOUT ioPrice                   TFloat    , -- Цена
 INOUT ioCountForPrice           TFloat    , -- Цена за количество
   OUT outAmountSumm             TFloat    , -- Сумма расчетная 
    IN inCount                   TFloat    , -- Количество батонов или упаковок
    IN inHeadCount               TFloat    , -- Количество голов
    IN inBoxCount                TFloat    , -- Количество ящиков
    IN inPartionGoods            TVarChar  , -- Партия товара
    IN inGoodsKindId             Integer   , -- Виды товаров
    IN inAssetId                 Integer   , -- Основные средства (для которых закупается ТМЦ)
    IN inBoxId                   Integer   , -- Ящики
   OUT outWeightPack             TFloat    ,
   OUT outWeightTotal            TFloat    , 
   OUT outCountPack              TFloat    , 
   OUT outMovementPromo          TVarChar  , -- 
   OUT outPricePromo             Numeric (16,8), --
   OUT outGoodsRealCode         Integer  , -- Товар (факт отгрузка)
   OUT outGoodsRealName         TVarChar  , -- Товар (факт отгрузка)
   OUT outGoodsKindRealName     TVarChar  , -- Вид товара (факт отгрузка) 
    IN inSession                 TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMeasureId Integer;
   DECLARE vbIsBarCode Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Sale());

     -- получили значение
     vbMeasureId:= (SELECT ObjectLink.ChildObjectId FROM ObjectLink WHERE ObjectLink.ObjectId = inGoodsId AND ObjectLink.DescId = zc_ObjectLink_Goods_Measure());
     -- получили значение
     vbIsBarCode:= COALESCE ((SELECT MIBoolean.ValueData FROM MovementItemBoolean AS MIBoolean WHERE MIBoolean.MovementItemId = ioId AND MIBoolean.DescId = zc_MIBoolean_BarCode()), FALSE);

     -- !!!скидка - вес упаковки!!!
     IF vbIsBarCode = TRUE
     THEN
         -- !!!из контрола!!! - % скидки для кол-ва
         IF inIsChangePercentAmount = TRUE
         THEN
             IF vbMeasureId = zc_Measure_Kg()
             THEN ioChangePercentAmount:= inChangePercentAmount; -- !!!из контрола!!!
             ELSE ioChangePercentAmount:= 0;
             END IF;
         END IF;

         -- проверка: если вводится кол склад надо сообщить что оно расчетное, вводить нельзя
         IF ioId <> 0 AND EXISTS (SELECT 1 FROM MovementItemFloat AS MIFloat WHERE MIFloat.MovementItemId = ioId AND MIFloat.DescId = zc_MIFloat_AmountPartner() AND MIFloat.ValueData = ioAmountPartner)
                      AND NOT EXISTS (SELECT 1 FROM MovementItem AS MI WHERE MI.Id = ioId AND MI.DescId = zc_MI_Master() AND MI.Amount = ioAmount)
                      AND vbMeasureId = zc_Measure_Kg()
         THEN
             RAISE EXCEPTION 'Ошибка.Ввод запрещен, т.к. <Кол-во склад> является расчетным если установлен признак <Скидка скан. упак.>.';
         END IF;

         -- получили значения для упаковки
         SELECT ObjectFloat_WeightPackage.ValueData, ObjectFloat_WeightTotal.ValueData
                INTO outWeightPack, outWeightTotal
         FROM Object_GoodsByGoodsKind_View
              -- вес 1-ого пакета - Вес пакета для УПАКОВКИ
              LEFT JOIN ObjectFloat AS ObjectFloat_WeightPackage
                                    ON ObjectFloat_WeightPackage.ObjectId = Object_GoodsByGoodsKind_View.Id 
                                   AND ObjectFloat_WeightPackage.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightPackage()
              --  вес в упаковке - "чистый" вес + вес 1-ого пакета
              LEFT JOIN ObjectFloat AS ObjectFloat_WeightTotal
                                    ON ObjectFloat_WeightTotal.ObjectId = Object_GoodsByGoodsKind_View.Id 
                                   AND ObjectFloat_WeightTotal.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightTotal()
         WHERE Object_GoodsByGoodsKind_View.GoodsId = inGoodsId 
           AND Object_GoodsByGoodsKind_View.GoodsKindId = inGoodsKindId;
         -- расчет кол-во шт. упаковки (пока округление до 4-х знаков)
         outCountPack:= CASE WHEN outWeightTotal <> 0 AND outWeightPack <> 0 AND outWeightTotal > outWeightPack
                                  THEN CAST (CAST (ioAmountPartner / (1 - outWeightPack / outWeightTotal) AS NUMERIC (16, 4)) / outWeightTotal AS NUMERIC (16, 4))
                             ELSE 0
                        END;

         IF vbMeasureId = zc_Measure_Kg()
         THEN
             -- !!!только в этом случае расчет "кол-во склад"!!!
             ioAmount:= (ioAmountPartner + CAST (outCountPack * COALESCE (outWeightPack, 0) / (1 - CASE WHEN ioChangePercentAmount < 100 THEN ioChangePercentAmount/100 ELSE 0 END) AS NUMERIC (16, 4)));
             -- !!!обнуление "других" скидок!!!
             --ioChangePercentAmount:= 0;
             --inIsChangePercentAmount:= FALSE;
             -- !!!расчет!!! - Количество c учетом % скидки
             outAmountChangePercent:= ioAmountPartner;
         ELSE
             -- !!!обнуление "других" скидок!!!
             ioChangePercentAmount:= 0;
             inIsChangePercentAmount:= FALSE;
             -- !!!расчет!!! - Количество c учетом % скидки
             outAmountChangePercent:= ioAmount;
         END IF;

     ELSE
         -- !!!из контрола!!! - % скидки для кол-ва
         IF inIsChangePercentAmount = TRUE
         THEN
             IF vbMeasureId = zc_Measure_Kg()
             THEN ioChangePercentAmount:= inChangePercentAmount; -- !!!из контрола!!!
             ELSE ioChangePercentAmount:= 0;
             END IF;
         END IF;
         -- !!!расчет!!! - Количество c учетом % скидки
         outAmountChangePercent:= CAST (ioAmount * (1 - COALESCE (ioChangePercentAmount, 0) / 100) AS NUMERIC (16, 3));

     END IF;


     IF inIsCalcAmountPartner = TRUE
     THEN
         -- !!!расчет!!! - Количество c у покупателя
         ioAmountPartner:= outAmountChangePercent;
     END IF;


     -- сохранили
     SELECT tmp.ioId, tmp.ioPrice, tmp.ioCountForPrice, tmp.outAmountSumm
          , zfCalc_PromoMovementName (tmp.outMovementId_Promo, NULL, NULL, NULL, NULL)
          , tmp.outPricePromo
          , tmp.outGoodsRealCode, tmp.outGoodsRealName
          , tmp.outGoodsKindRealName
            INTO ioId, ioPrice, ioCountForPrice, outAmountSumm, outMovementPromo, outPricePromo
               , outGoodsRealCode, outGoodsRealName, outGoodsKindRealName
     FROM lpInsertUpdate_MovementItem_Sale (ioId                 := ioId
                                          , inMovementId         := inMovementId
                                          , inGoodsId            := inGoodsId
                                          , inAmount             := ioAmount
                                          , inAmountPartner      := ioAmountPartner
                                          , inAmountChangePercent:= outAmountChangePercent
                                          , inChangePercentAmount:= ioChangePercentAmount
                                          , ioPrice              := ioPrice
                                          , ioCountForPrice      := ioCountForPrice
                                          , inCount              := inCount 
                                          , inHeadCount          := inHeadCount
                                          , inBoxCount           := inBoxCount
                                          , inPartionGoods       := inPartionGoods
                                          , inGoodsKindId        := inGoodsKindId
                                          , inAssetId            := inAssetId
                                          , inBoxId              := inBoxId
                                          
                                          , inCountPack          := COALESCE (outCountPack, 0)
                                          , inWeightTotal        := COALESCE (outWeightTotal, 0)
                                          , inWeightPack         := COALESCE (outWeightPack, 0)
                                          , inIsBarCode          := vbIsBarCode
                                                                                                                              
                                          , inUserId             := vbUserId
                                           ) AS tmp;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 26.07.22         * inCount
 10.10.14                                                       * add box
 08.02.14                                        * была ошибка с lpInsertUpdate_MovementItem_Sale
 04.02.14                        * add lpInsertUpdate_MovementItem_Sale
 08.09.13                                        * add zc_MIFloat_AmountChangePercent
 02.09.13                                        * add zc_MIFloat_ChangePercentAmount
 13.08.13                                        * add RAISE EXCEPTION
 09.07.13                                        * add IF inGoodsId <> 0
 18.07.13         * add inAssetId
 13.07.13         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_Sale (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, ioAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, ioPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
