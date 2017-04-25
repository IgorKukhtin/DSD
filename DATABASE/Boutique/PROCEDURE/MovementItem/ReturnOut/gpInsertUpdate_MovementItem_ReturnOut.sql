-- Function: gpInsertUpdate_MovementItem_ReturnOut()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ReturnOut (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ReturnOut(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inPartionId           Integer   , -- Партия
    IN inAmount              TFloat    , -- Количество
    IN inOperPrice           TFloat    , -- Цена
 INOUT ioCountForPrice       TFloat    , -- Цена за количество
   OUT outAmountSumm         TFloat    , -- Сумма расчетная
    IN inOperPriceList       TFloat    , -- Цена по прайсу
   OUT outAmountPriceListSumm TFloat    , -- Сумма по прайсу
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPartionId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ReturnOut());

     -- Заменили свойство <Цена за количество>
     IF COALESCE (ioCountForPrice, 0) = 0 THEN ioCountForPrice := 1; END IF;


     -- сохранили
     ioId:= lpInsertUpdate_MovementItem_ReturnOut (ioId                 := ioId
                                              , inMovementId         := inMovementId
                                              , inGoodsId            := inGoodsId
                                              , inPartionId          := COALESCE(inPartionId,0)
                                              , inAmount             := inAmount
                                              , inOperPrice          := inOperPrice
                                              , inCountForPrice      := ioCountForPrice
                                              , inOperPriceList      := inOperPriceList
                                              , inUserId             := vbUserId
                                               );

   /*  IF COALESCE (inPartionId, 0) = 0 AND COALESCE (ioId, 0) <> 0
        THEN
            -- сохраняем партию 
            inPartionId := lpInsertUpdate_Object_PartionGoods (
                                                  ioMovementItemId := ioId
                                                , inMovementId     := inMovementId
                                                , inSybaseId       := Null
                                                , inPartnerId      := MovementLinkObject_From.ObjectId
                                                , inUnitId         := MovementLinkObject_To.ObjectId
                                                , inOperDate       := Movement.OperDate
                                                , inGoodsId        := inGoodsId
                                                , inGoodsItemId    := COALESCE (Object_PartionGoods.GoodsItemId,0)
                                                , inCurrencyId     := COALESCE (Object_PartionGoods.CurrencyId,0)
                                                , inAmount         := inAmount
                                                , inOperPrice      := inOperPrice
                                                , inPriceSale      := inOperPriceList
                                                , inBrandId        := ObjectLink_Partner_Brand.ChildObjectId
                                                , inPeriodId       := ObjectLink_Partner_Period.ChildObjectId
                                                , inPeriodYear     := ObjectFloat_PeriodYear.ValueData         :: integer
                                                , inFabrikaId      := ObjectLink_Partner_Fabrika.ChildObjectId
                                                , inGoodsGroupId   := ObjectLink_Goods_GoodsGroup.ChildObjectId
                                                , inMeasureId      := vbMeasureId
                                                , inCompositionId  := vbCompositionId
                                                , inGoodsInfoId    := vbGoodsInfoId
                                                , inLineFabricaId  := vbLineFabricaId
                                                , inLabelId        := vbLabelId
                                                , inCompositionGroupId := vbCompositionGroupId
                                                , inGoodsSizeId    := vbGoodsSizeId 
                                                , inUserId         := vbUserId
                                                        )
     FROM Movement
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            --
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Brand
                                 ON ObjectLink_Partner_Brand.ObjectId = MovementLinkObject_From.ObjectId
                                AND ObjectLink_Partner_Brand.DescId = zc_ObjectLink_Partner_Brand()
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Period
                                 ON ObjectLink_Partner_Period.ObjectId = MovementLinkObject_From.ObjectId
                                AND ObjectLink_Partner_Period.DescId = zc_ObjectLink_Partner_Period()
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Fabrika
                                 ON ObjectLink_Partner_Fabrika.ObjectId = MovementLinkObject_From.ObjectId
                                AND ObjectLink_Partner_Fabrika.DescId = zc_ObjectLink_Partner_Fabrika()
            LEFT JOIN ObjectFloat AS ObjectFloat_PeriodYear 
                                  ON ObjectFloat_PeriodYear.ObjectId = MovementLinkObject_From.ObjectId
                                 AND ObjectFloat_PeriodYear.DescId = zc_ObjectFloat_Partner_PeriodYear()
    
            LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = ioId
            -- по товару
            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = inGoodsId
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = inGoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

     WHERE Movement.Id = inMovementId;
;
     END IF;
*/
     -- расчитали сумму по элементу, для грида
     outAmountSumm := CASE WHEN ioCountForPrice > 0
                                THEN CAST (inAmount * inOperPrice / ioCountForPrice AS NUMERIC (16, 2))
                           ELSE CAST (inAmount * inOperPrice AS NUMERIC (16, 2))
                      END;
     -- расчитали сумму по прайсу по элементу, для грида
     outAmountPriceListSumm := CASE WHEN ioCountForPrice > 0
                                         THEN CAST (inAmount * inOperPriceList / ioCountForPrice AS NUMERIC (16, 2))
                                    ELSE CAST (inAmount * inOperPriceList AS NUMERIC (16, 2))
                               END;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.04.17         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_ReturnOut (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
