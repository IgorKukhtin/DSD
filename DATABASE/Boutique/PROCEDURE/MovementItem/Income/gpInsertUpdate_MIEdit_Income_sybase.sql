-- Function: gpInsertUpdate_MIEdit_Income_sybase()

DROP FUNCTION IF EXISTS gpInsertUpdate_MIEdit_Income_sybase (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MIEdit_Income_sybase(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsItemId         Integer   , --
    IN inSybaseId            Integer   , -- 
    IN inAmount              TFloat    , -- Количество
    IN inOperPrice           TFloat    , -- Цена
 INOUT ioCountForPrice       TFloat    , -- Цена за количество
    IN inOperPriceList       TFloat    , -- Цена по прайсу
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPartionId Integer; 
   DECLARE vbGoodsId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Income());

     -- Заменили свойство <Цена за количество>
     IF COALESCE (ioCountForPrice, 0) = 0 THEN ioCountForPrice := 1; END IF;
    
     select GoodsId into vbGoodsId FROM Object_goodsitem WHERE Object_goodsitem.id  = inGoodsItemId; 

     -- сохранили
     ioId:= lpInsertUpdate_MovementItem_Income (ioId                 := ioId
                                              , inMovementId         := inMovementId
                                              , inGoodsId            := vbGoodsId
                                              , inPartionId          := Null :: integer
                                              , inAmount             := inAmount
                                              , inOperPrice          := inOperPrice
                                              , inCountForPrice      := ioCountForPrice
                                              , inOperPriceList      := inOperPriceList
                                              , inUserId             := vbUserId
                                               );


      -- cохраняем Object_PartionGoods
      vbPartionId := lpInsertUpdate_Object_PartionGoods (
                                                  ioMovementItemId := ioId
                                                , inMovementId     := inMovementId
                                                , inSybaseId       := inSybaseId
                                                , inPartnerId      := MovementLinkObject_From.ObjectId
                                                , inUnitId         := MovementLinkObject_To.ObjectId
                                                , inOperDate       := Movement.OperDate
                                                , inGoodsId        := Object_goodsitem.GoodsId
                                                , inGoodsItemId    := inGoodsItemId
                                                , inCurrencyId     := MovementLinkObject_CurrencyDocument.ObjectId
                                                , inAmount         := inAmount
                                                , inOperPrice      := inOperPrice
                                                , inPriceSale      := inOperPriceList
                                                , inBrandId        := ObjectLink_Partner_Brand.ChildObjectId
                                                , inPeriodId       := ObjectLink_Partner_Period.ChildObjectId
                                                , inPeriodYear     := ObjectFloat_PeriodYear.ValueData         :: integer
                                                , inFabrikaId      := ObjectLink_Partner_Fabrika.ChildObjectId
                                                , inGoodsGroupId   := ObjectLink_Goods_GoodsGroup.ChildObjectId
                                                , inMeasureId      := ObjectLink_Goods_Measure.ChildObjectId
                                                , inCompositionId  := ObjectLink_Goods_Composition.ChildObjectId
                                                , inGoodsInfoId    := ObjectLink_Goods_GoodsInfo.ChildObjectId
                                                , inLineFabricaId  := ObjectLink_Goods_LineFabrica.ChildObjectId
                                                , inLabelId        := ObjectLink_Goods_Label.ChildObjectId
                                                , inCompositionGroupId := ObjectLink_Composition_CompositionGroup.ChildObjectId  
                                                , inGoodsSizeId    := Object_goodsitem.GoodsSizeId 
                                                , inUserId         := vbUserId
                                                        )
     FROM Movement
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument
                                         ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id
                                        AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
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
            --
           

            --
            left join Object_goodsitem on Object_goodsitem.id  = inGoodsItemId

            -- -- 
            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_goodsitem.GoodsId
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()


            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_goodsitem.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()


            LEFT JOIN ObjectLink AS ObjectLink_Goods_Composition
                                 ON ObjectLink_Goods_Composition.ObjectId = Object_goodsitem.GoodsId
                                AND ObjectLink_Goods_Composition.DescId = zc_ObjectLink_Goods_Composition()


            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsInfo
                                 ON ObjectLink_Goods_GoodsInfo.ObjectId = Object_goodsitem.GoodsId
                                AND ObjectLink_Goods_GoodsInfo.DescId = zc_ObjectLink_Goods_GoodsInfo()


            LEFT JOIN ObjectLink AS ObjectLink_Goods_LineFabrica
                                 ON ObjectLink_Goods_LineFabrica.ObjectId = Object_goodsitem.GoodsId
                                AND ObjectLink_Goods_LineFabrica.DescId = zc_ObjectLink_Goods_LineFabrica()


            LEFT JOIN ObjectLink AS ObjectLink_Goods_Label
                                 ON ObjectLink_Goods_Label.ObjectId = Object_goodsitem.GoodsId
                                AND ObjectLink_Goods_Label.DescId = zc_ObjectLink_Goods_Label()
            LEFT JOIN Object AS Object_Label ON Object_Label.Id = ObjectLink_Goods_Label.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Composition_CompositionGroup
                                ON ObjectLink_Composition_CompositionGroup.ObjectId = ObjectLink_Goods_Composition.ChildObjectId
                               AND ObjectLink_Composition_CompositionGroup.DescId = zc_ObjectLink_Composition_CompositionGroup()


     WHERE Movement.Id = inMovementId;

     -- сохранили пересохраняем с партией
     ioId:= lpInsertUpdate_MovementItem_Income (ioId                 := ioId
                                              , inMovementId         := inMovementId
                                              , inGoodsId            := COALESCE (vbGoodsId,0)
                                              , inPartionId          := vbPartionId
                                              , inAmount             := inAmount
                                              , inOperPrice          := inOperPrice
                                              , inCountForPrice      := ioCountForPrice
                                              , inOperPriceList      := inOperPriceList
                                              , inUserId             := vbUserId
                                               );

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И. Полятыкин А.А.
 21.04.17                                                       *
 10.04.17         *
*/

-- тест
-- 