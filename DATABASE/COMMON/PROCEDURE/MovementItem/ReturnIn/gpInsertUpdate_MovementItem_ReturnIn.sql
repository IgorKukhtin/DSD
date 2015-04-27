-- Function: gpInsertUpdate_MovementItem_ReturnIn()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ReturnIn (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ReturnIn (Integer, Integer, Integer, TFloat, TFloat, Boolean, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ReturnIn (Integer, Integer, Integer, TFloat, TFloat, Boolean, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ReturnIn (Integer, Integer, Integer, TFloat, TFloat, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, TVarChar);



CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ReturnIn(
 INOUT ioId                     Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId             Integer   , -- Ключ объекта <Документ Возврат покупателя>
    IN inGoodsId                Integer   , -- Товары
    IN inAmount                 TFloat    , -- Количество
 INOUT ioAmountPartner          TFloat    , -- Количество у контрагента
    IN inIsCalcAmountPartner    Boolean   , -- Признак - будет ли исправлено <Количество у контрагента>
    IN inPrice                  TFloat    , -- Цена
 INOUT ioCountForPrice          TFloat    , -- Цена за количество
   OUT outAmountSumm            TFloat    , -- Сумма расчетная
    IN inHeadCount              TFloat    , -- Количество голов
    IN inMovementId_Top         TFloat    , -- Id документа продажи из шапки
    IN inMovementId_MI          TFloat    , -- Id документа продажи строчная часть
    IN inPartionGoods           TVarChar  , -- Партия товара
    IN inGoodsKindId            Integer   , -- Виды товаров
    IN inAssetId                Integer   , -- Основные средства (для которых закупается ТМЦ)
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ReturnIn());

     -- !!!меняется параметр!!! - Количество у контрагента
     IF inIsCalcAmountPartner = TRUE
     THEN
         ioAmountPartner := inAmount;
     END IF;

     IF COALESCE (inMovementId_MI, 0) = 0
     THEN
         inMovementId_MI := COALESCE (inMovementId_Top, 0);
     END IF;

     -- сохранили <Элемент документа>
     SELECT tmp.ioId, tmp.ioCountForPrice, tmp.outAmountSumm
            INTO ioId, ioCountForPrice, outAmountSumm
     FROM lpInsertUpdate_MovementItem_ReturnIn (ioId                 := ioId
                                              , inMovementId         := inMovementId
                                              , inGoodsId            := inGoodsId
                                              , inAmount             := inAmount
                                              , inAmountPartner      := ioAmountPartner
                                              , inPrice              := inPrice
                                              , ioCountForPrice      := ioCountForPrice
                                              , inHeadCount          := inHeadCount
                                              , inMovementId_MI      := inMovementId_MI
                                              , inPartionGoods       := inPartionGoods
                                              , inGoodsKindId        := inGoodsKindId
                                              , inAssetId            := inAssetId
                                              , inUserId             := vbUserId
                                               ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Манько Д.А.
 27.04.15         * add inMovementId_top/_MI
 14.02.14                                                         * fix lpInsertUpdate_MovementItem_ReturnIn
 13.02.14                        * lpInsertUpdate_MovementItem_ReturnIn
 28.01.14                                                          * add outAmountSumm
 13.01.14                                        * add RAISE EXCEPTION
 18.07.13         * add inAssetId
 17.07.13         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_ReturnIn (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inPrice:= 1, ioCountForPrice:= 1 , inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
