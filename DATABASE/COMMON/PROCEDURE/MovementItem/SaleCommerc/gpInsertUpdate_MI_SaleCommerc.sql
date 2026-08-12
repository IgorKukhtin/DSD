-- Function: gpInsertUpdate_MI_SaleCommerc()

--DROP FUNCTION IF EXISTS gpInsertUpdate_MI_SaleCommerc (Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_SaleCommerc (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat,TFloat,TFloat,TFloat,TFloat,TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MI_SaleCommerc (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_SaleCommerc (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_SaleCommerc(
 INOUT ioId                   Integer   , -- Ключ объекта <Элемент документа master>
 INOUT ioId_Child             Integer   , -- Ключ объекта <Элемент документа child>
    IN inMovementId           Integer   , -- Ключ объекта <Документ>
    IN inContractId           Integer   , -- 
    IN inBranchId             Integer   , --
    IN inKAMId                Integer   , --  KAM
    IN inBranchId_KAM         Integer   , --  ПОдразделение  КАМ  
    IN inPartnerId            Integer   , --
    IN inPaidKindId           Integer   , --
    IN inGoodsId              Integer   , -- Товар
    IN inGoodsKindId          Integer   , -- Вид Товар
 INOUT ioAmount_sh            TFloat    , --
 INOUT ioAmount_weight        TFloat    , --
    IN inSumm                 TFloat    , --
 INOUT ioAmountPromo_sh       TFloat    , --
 INOUT ioAmountPromo_weight   TFloat    , --
    IN inSummPromo            TFloat    , --
 INOUT ioAmountNoPromo_sh     TFloat    , --
 INOUT ioAmountNoPromo_weight TFloat    , --
    IN inSummNoPromo          TFloat    , --
   OUT outPrice               TFloat    , --
   OUT outAmount              TFloat    , --
   OUT outAmountPromo         TFloat    , --
   OUT outAmountNoPromo       TFloat    , -- 
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
           vbIsInsert Boolean;
           vbVATPercent TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SaleCommerc());

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     

     -- сохранили <Элемент документа>
     SELECT tmp.ioId
   INTO ioId
     FROM lpInsertUpdate_MI_SaleCommerc (ioId          := COALESCE(ioId,0) ::Integer
                                       , inMovementId  := inMovementId     ::Integer
                                       , inContractId  := inContractId     ::Integer
                                       , inBranchId    := inBranchId       ::Integer
                                       , inBranchKAMId := CASE WHEN COALESCE (inKAMId,0) <> 0 THEN inKAMId ELSE inBranchId_KAM END ::Integer
                                       , inPartnerId   := inPartnerId      ::Integer
                                       , inPaidKindId  := inPaidKindId     ::Integer
                                       , inUserId      := vbUserId         ::Integer
                                        ) AS tmp;

     -- Цены из прайса базового прайса без НДС
     outPrice := (WITH
                  tmp AS (SELECT lfSelect.GoodsKindId AS GoodsKindId
                               , lfSelect.ValuePrice  AS Price
                          FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_BasisComerc()
                                                                   , inOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId)
                                                                    ) AS lfSelect
                          WHERE lfSelect.GoodsId = inGoodsId
                          )
                  SELECT COALESCE ( (SELECT tmp.Price FROM tmp WHERE COALESCE (tmp.GoodsKindId,0) = COALESCE (inGoodsKindId,0))
                                  , (SELECT tmp.Price FROM tmp WHERE tmp.GoodsKindId IS NULL)
                                  , 0 
                                  ) ::TFloat AS Price
                 ) ::TFloat;
     -- zc_PriceList_BasisComerc() прайс без ндс, поэтому нужно к цене + НДС
     -- НДС прайса
     vbVATPercent:= 1 + COALESCE ((SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = zc_PriceList_BasisComerc() AND ObjectFloat.DescId = zc_ObjectFloat_PriceList_VATPercent()), 0) / 100;
     --пересчитываем цену с учетом НДС
     outPrice := (outPrice * vbVATPercent) ::TFloat;

     -- если товар шт - берем эту колонку, если там 0 а есть кг, то переводим в шт, весовой - всегда в кг
     SELECT CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()       
                 THEN CASE WHEN COALESCE (ioAmount_sh,0) <> 0
                           THEN ioAmount_sh
                           ELSE CASE WHEN COALESCE (ObjectFloat_Weight.ValueData,0) <> 0
                                     THEN ioAmount_weight / COALESCE (ObjectFloat_Weight.ValueData,0)
                                     ELSE 0
                                END
                      END
                 ELSE COALESCE (ioAmount_weight,0)
            END ::TFloat AS Amount

          , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()       
                 THEN CASE WHEN COALESCE (ioAmountPromo_sh,0) <> 0
                           THEN ioAmountPromo_sh
                           ELSE CASE WHEN COALESCE (ObjectFloat_Weight.ValueData,0) <> 0
                                     THEN ioAmountPromo_weight / COALESCE (ObjectFloat_Weight.ValueData,0)
                                     ELSE 0
                                END
                      END
                 ELSE COALESCE (ioAmountPromo_weight,0)
            END ::TFloat AS AmountPromo

          , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()       
                 THEN CASE WHEN COALESCE (ioAmountNoPromo_sh,0) <> 0
                           THEN ioAmountNoPromo_sh
                           ELSE CASE WHEN COALESCE (ObjectFloat_Weight.ValueData,0) <> 0
                                     THEN ioAmountNoPromo_weight / COALESCE (ObjectFloat_Weight.ValueData,0)
                                     ELSE 0
                                END
                      END
                 ELSE COALESCE (ioAmountNoPromo_weight,0)
            END ::TFloat AS AmountNoPromo
   INTO outAmount, outAmountPromo, outAmountNoPromo
     FROM ObjectLink AS ObjectLink_Goods_Measure
          LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                ON ObjectFloat_Weight.ObjectId = ObjectLink_Goods_Measure.ObjectId
                               AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
     WHERE ObjectLink_Goods_Measure.ObjectId = inGoodsId
       AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure();

     -- сохранили <Элемент документа>
     SELECT tmp.ioId
   INTO ioId_Child
     FROM lpInsertUpdate_MI_SaleCommerc_Child (ioId             := COALESCE(ioId_Child,0) ::Integer
                                             , inParentId       := ioId                   ::Integer
                                             , inMovementId     := inMovementId           ::Integer
                                             , inGoodsId        := inGoodsId              ::Integer
                                             , inGoodsKindId    := inGoodsKindId          ::Integer
                                             , inAmount         := outAmount              ::TFloat
                                             , inSumm           := inSumm                 ::TFloat
                                             , inAmountPromo    := outAmountPromo         ::TFloat
                                             , inSummPromo      := inSummPromo            ::TFloat
                                             , inAmountNoPromo  := outAmountNoPromo       ::TFloat
                                             , inSummNoPromo    := inSummNoPromo          ::TFloat
                                             , inPrice          := outPrice               ::TFloat
                                             , inUserId         := vbUserId               ::Integer
                                              ) AS tmp;
                                        
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.07.26         *
*/

-- тест
--