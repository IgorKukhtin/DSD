-- Function: gpInsertUpdate_MI_SaleCommerc()

--DROP FUNCTION IF EXISTS gpInsertUpdate_MI_SaleCommerc (Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_SaleCommerc (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat,TFloat,TFloat,TFloat,TFloat,TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_SaleCommerc(
 INOUT ioId                   Integer   , -- Ключ объекта <Элемент документа master>
 INOUT ioId_Child             Integer   , -- Ключ объекта <Элемент документа child>
    IN inMovementId           Integer   , -- Ключ объекта <Документ>
    IN inContractId           Integer   , -- 
    IN inBranchId             Integer   , --
    IN inPartnerId            Integer   , --
    IN inPaidKindId           Integer   , --
    IN inGoodsId              Integer   , -- Товар
    IN inGoodsKindId          Integer   , -- Вид Товар
    IN inAmount               TFloat    , --
    IN inSumm                 TFloat    , --
    IN inAmountPromo          TFloat    , --
    IN inSummPromo            TFloat    , --
    IN inAmountNoPromo        TFloat    , --
    IN inSummNoPromo          TFloat    , --
   OUT outPrice               TFloat    , -- 
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
           vbIsInsert Boolean;
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
                                       , inPartnerId   := inPartnerId      ::Integer
                                       , inPaidKindId  := inPaidKindId     ::Integer
                                       , inUserId      := vbUserId         ::Integer
                                        ) AS tmp;

     -- Цены из прайса базового прайса
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


     -- сохранили <Элемент документа>
     SELECT tmp.ioId
   INTO ioId_Child
     FROM lpInsertUpdate_MI_SaleCommerc_Child (ioId             := COALESCE(ioId_Child,0) ::Integer
                                             , inParentId       := ioId                   ::Integer
                                             , inMovementId     := inMovementId           ::Integer
                                             , inGoodsId        := inGoodsId              ::Integer
                                             , inGoodsKindId    := inGoodsKindId          ::Integer
                                             , inAmount         := inAmount               ::TFloat
                                             , inSumm           := inSumm                 ::TFloat
                                             , inAmountPromo    := inAmountPromo          ::TFloat
                                             , inSummPromo      := inSummPromo            ::TFloat
                                             , inAmountNoPromo  := inAmountNoPromo        ::TFloat
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