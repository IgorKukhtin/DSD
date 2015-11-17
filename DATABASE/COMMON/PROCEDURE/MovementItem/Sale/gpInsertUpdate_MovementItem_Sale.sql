-- Function: gpInsertUpdate_MovementItem_Sale()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Sale(
 INOUT ioId                      Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId              Integer   , -- Ключ объекта <Документ>
    IN inGoodsId                 Integer   , -- Товары
    IN inAmount                  TFloat    , -- Количество
 INOUT ioAmountPartner           TFloat    , -- Количество у контрагента
   OUT outAmountChangePercent    TFloat    , -- Количество c учетом % скидки (!!!расчет!!!)
    IN inChangePercentAmount     TFloat    , -- % скидки для кол-ва (!!!из контрола!!!)
 INOUT ioChangePercentAmount     TFloat    , -- % скидки для кол-ва (!!!из грида!!!)
    IN inIsChangePercentAmount   Boolean   , -- Признак - будет ли использоваться из контрола <% скидки для кол-ва>
    IN inIsCalcAmountPartner     Boolean   , -- Признак - будет ли расчитано <Количество у контрагента>
    IN inPrice                   TFloat    , -- Цена
 INOUT ioCountForPrice           TFloat    , -- Цена за количество
   OUT outAmountSumm             TFloat    , -- Сумма расчетная
    IN inHeadCount               TFloat    , -- Количество голов
    IN inBoxCount                TFloat    , -- Количество ящиков
    IN inPartionGoods            TVarChar  , -- Партия товара
    IN inGoodsKindId             Integer   , -- Виды товаров
    IN inAssetId                 Integer   , -- Основные средства (для которых закупается ТМЦ)
    IN inBoxId                   Integer   , -- Ящики
   OUT outWeightPack             TFloat    ,
   OUT outWeightTotal            TFloat    , 
   OUT outCountPack              TFloat    , 
    IN inSession                 TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Sale());


     -- !!!из контрола!!! - % скидки для кол-ва
     IF inIsChangePercentAmount = TRUE
     THEN
         IF EXISTS (SELECT ObjectId FROM ObjectLink WHERE ObjectId = inGoodsId AND ChildObjectId = zc_Measure_Kg())
         THEN ioChangePercentAmount:= inChangePercentAmount; -- !!!из контрола!!!
         ELSE ioChangePercentAmount:= 0;
         END IF;
     END IF;

     -- !!!расчет!!! - Количество c учетом % скидки
     outAmountChangePercent:= CAST (inAmount * (1 - COALESCE (ioChangePercentAmount, 0) / 100) AS NUMERIC (16, 3));

     IF inIsCalcAmountPartner = TRUE
     THEN
         ioAmountPartner:= outAmountChangePercent;
     END IF;

     -- расчет упаковки
     SELECT COALESCE (ObjectFloat_WeightPackage.ValueData,0)::TFloat  AS WeightPack
          , COALESCE (ObjectFloat_WeightTotal.ValueData,0)  ::TFloat  AS WeightTotal
         into outWeightPack, outWeightTotal
     FROM Object_GoodsByGoodsKind_View
           LEFT JOIN ObjectFloat AS ObjectFloat_WeightPackage
                                 ON ObjectFloat_WeightPackage.ObjectId = Object_GoodsByGoodsKind_View.Id 
                                AND ObjectFloat_WeightPackage.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightPackage()

           LEFT JOIN ObjectFloat AS ObjectFloat_WeightTotal
                                 ON ObjectFloat_WeightTotal.ObjectId = Object_GoodsByGoodsKind_View.Id 
                                AND ObjectFloat_WeightTotal.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightTotal()
      WHERE Object_GoodsByGoodsKind_View.GoodsId = inGoodsId 
        AND Object_GoodsByGoodsKind_View.GoodsKindId = inGoodsKindId;

      IF COALESCE (outWeightPack,0) <> 0 AND 
         COALESCE (outWeightTotal,0) <> 0 AND 
         COALESCE ((1-outWeightPack/outWeightTotal), 0) <> 0
      THEN 
          outCountPack:= CAST (((ioAmountPartner/(1-outWeightPack/outWeightTotal))/ outWeightTotal) AS NUMERIC (16, 4));
      ELSE
          outCountPack:= 0;
      END IF;
      

     -- сохранили
     SELECT tmp.ioId, tmp.ioCountForPrice, tmp.outAmountSumm
            INTO ioId, ioCountForPrice, outAmountSumm
     FROM lpInsertUpdate_MovementItem_Sale (ioId                 := ioId
                                          , inMovementId         := inMovementId
                                          , inGoodsId            := inGoodsId
                                          , inAmount             := inAmount
                                          , inAmountPartner      := ioAmountPartner
                                          , inAmountChangePercent:= outAmountChangePercent
                                          , inChangePercentAmount:= ioChangePercentAmount
                                          , inPrice              := inPrice
                                          , ioCountForPrice      := ioCountForPrice
                                          , inHeadCount          := inHeadCount
                                          , inBoxCount           := inBoxCount
                                          , inPartionGoods       := inPartionGoods
                                          , inGoodsKindId        := inGoodsKindId
                                          , inAssetId            := inAssetId
                                          , inBoxId              := inBoxId
                                          
                                          , inCountPack          := COALESCE (outCountPack, 0) ::TFloat
                                          , inWeightTotal        := COALESCE (outWeightTotal,0) ::TFloat
                                          , inWeightPack         := COALESCE (outWeightPack,0) ::TFloat
                                          , inIsBarCode          := COALESCE ((SELECT ValueData FROM MovementItemBoolean WHERE MovementItemId = ioId AND DescId = zc_MIBoolean_BarCode()), FALSE) 
                                                                                                                              
                                          , inUserId             := vbUserId
                                           ) AS tmp;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
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
-- SELECT * FROM gpInsertUpdate_MovementItem_Sale (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
