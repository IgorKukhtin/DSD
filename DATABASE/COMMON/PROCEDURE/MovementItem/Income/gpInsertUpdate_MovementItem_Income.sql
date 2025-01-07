-- Function: gpInsertUpdate_MovementItem_Income()

--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income (Integer, Integer, Integer, TFloat, TFloat, TFloat, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income (Integer, Integer, Integer, TFloat, TFloat, TFloat, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Income(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
 INOUT ioAmount              TFloat    , -- Количество
 INOUT ioAmountPartner       TFloat    , -- Количество у контрагента
    IN inAmountPacker        TFloat    , -- Количество у заготовителя
    IN inIsCalcAmountPartner Boolean   , -- Признак - будет ли расчитано <Количество у контрагента>
    IN inPrice               TFloat    , -- Цена
   OUT outPriceNoVat         TFloat    , -- Цена без НДС
    IN inMIId_Invoice        TFloat    , -- элемент документа Cчет
 INOUT ioCountForPrice       TFloat    , -- Цена за количество
   OUT outAmountSumm         TFloat    , -- Сумма расчетная
    IN inLiveWeight          TFloat    , -- Живой вес
    IN inHeadCount           TFloat    , -- Количество голов
    IN inPartionGoods        TVarChar  , -- Партия товара
 INOUT ioPartNumber          TVarChar  , -- № по тех паспорту
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inAssetId             Integer   , -- Основные средства (для которых закупается ТМЦ) 
    IN inStorageId           Integer   , -- Место хранения
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbVATPercent   TFloat;
   DECLARE vbPriceWithVAT Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Income());


     -- !!!Заменили значение!!!
     IF inIsCalcAmountPartner = TRUE --  OR 1 = 1 -- временно OR...
     THEN ioAmountPartner:= ioAmount;
     END IF;

     -- Заменили свойство <Цена за количество>
     IF COALESCE (ioCountForPrice, 0) = 0 THEN ioCountForPrice := 1; END IF;

     -- сохранили
     ioId:= lpInsertUpdate_MovementItem_Income (ioId                 := ioId
                                              , inMovementId         := inMovementId
                                              , inGoodsId            := inGoodsId
                                              , inAmount             := ioAmount
                                              , inAmountPartner      := ioAmountPartner
                                              , inAmountPacker       := inAmountPacker
                                              , inPrice              := inPrice
                                              , inCountForPrice      := ioCountForPrice
                                              , inLiveWeight         := inLiveWeight
                                              , inHeadCount          := inHeadCount
                                              , inPartionGoods       := inPartionGoods
                                              , inPartNumber         := ioPartNumber
                                              , inGoodsKindId        := inGoodsKindId
                                              , inAssetId            := inAssetId
                                              , inStorageId          := inStorageId
                                              , inUserId             := vbUserId
                                               );

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementItemId(), ioId, inMIId_Invoice);

     -- расчитали сумму по элементу, для грида
     outAmountSumm := CASE WHEN ioCountForPrice > 0
                                THEN CAST (ioAmountPartner * inPrice / ioCountForPrice AS NUMERIC (16, 2))
                           ELSE CAST (ioAmountPartner * inPrice AS NUMERIC (16, 2))
                      END; 
                             
     
     -- параметры из документа
     SELECT COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE) AS PriceWithVAT
          , COALESCE (MovementFloat_VATPercent.ValueData, 0)        AS VATPercent
          
            INTO vbPriceWithVAT, vbVATPercent
     FROM Movement
          LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                    ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                   AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
          LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                  ON MovementFloat_VATPercent.MovementId = Movement.Id
                                 AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
     WHERE Movement.Id = inMovementId;

     -- расчет цены без НДС, до 4 знаков
     outPriceNoVat := (CASE WHEN vbPriceWithVAT = TRUE
                            THEN CAST (inPrice - inPrice * (vbVATPercent / (vbVATPercent + 100)) AS NUMERIC (16, 2))
                            ELSE inPrice
                       END  / CASE WHEN ioCountForPrice <> 0 THEN ioCountForPrice ELSE 1 END)
                       ::TFloat;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.01.25         *
 27.06.23         *
 21.07.16         *
 29.06.15                                        * add inIsCalcAmountPartner
 29.05.15                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_Income (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
