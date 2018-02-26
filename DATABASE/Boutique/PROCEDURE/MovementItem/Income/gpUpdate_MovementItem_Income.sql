-- Function: gpInsertUpdate_MovementItem_Income()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income (Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Income (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Income(
    IN inId                   Integer   , -- Ключ объекта <Элемент документа>
    IN inAmount               TFloat    , -- Количество
   OUT outTotalSumm           TFloat    , -- Сумма вх.
   OUT outTotalSummBalance    TFloat    , -- Сумма вх. (ГРН)
   OUT outTotalSummPriceList  TFloat    , -- Сумма (прайс)
    IN inSession              TVarChar    -- сессия пользователя
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId         Integer;
   DECLARE vbMovementId     Integer;
   DECLARE vbCurrencyId_Doc Integer;
   DECLARE vbCurrencyValue  TFloat;
   DECLARE vbParValue       TFloat;
   DECLARE vbCountForPrice  TFloat;
   DECLARE vbOperPrice      TFloat;
   DECLARE vbOperPriceList  TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Income());

     -- сохранили
     PERFORM lpInsertUpdate_MovementItem (ioId         := MovementItem.Id
                                        , inDescId     := zc_MI_Master()
                                        , inObjectId   := MovementItem.ObjectId
                                        , inPartionId  := MovementItem.PartionId
                                        , inMovementId := MovementItem.MovementId
                                        , inAmount     := inAmount
                                        , inParentId   := NULL
                                        , inUserId     := vbUserId
                                         )
     FROM MovementItem
     WHERE MovementItem.Id = inId;

     -- данные для расчета сумм
     SELECT MovementItem.MovementId                         AS MovementId
          , MLO_CurrencyDocument.ObjectId                   AS CurrencyId_Doc
          , MF_CurrencyValue.ValueData                      AS CurrencyValue
          , MF_ParValue.ValueData                           AS ParValue
          , COALESCE (MIFloat_CountForPrice.ValueData, 1)   AS CountForPrice
          , COALESCE (MIFloat_OperPrice.ValueData, 0)       AS OperPrice
          , COALESCE (MIFloat_OperPriceList.ValueData, 0)   AS OperPriceList
            INTO vbMovementId, vbCurrencyId_Doc
               , vbCurrencyValue, vbParValue
               , vbCountForPrice, vbOperPrice, vbOperPriceList
     FROM MovementItem
          -- из док.
          LEFT JOIN MovementLinkObject AS MLO_CurrencyDocument
                                       ON MLO_CurrencyDocument.MovementId = MovementItem.MovementId
                                      AND MLO_CurrencyDocument.DescId     = zc_MovementLinkObject_CurrencyDocument()
          LEFT JOIN MovementFloat AS MF_CurrencyValue
                                  ON MF_CurrencyValue.MovementId = MovementItem.MovementId
                                 AND MF_CurrencyValue.DescId     = zc_MovementFloat_CurrencyValue()
          LEFT JOIN MovementFloat AS MF_ParValue
                                  ON MF_ParValue.MovementId = MovementItem.MovementId
                                 AND MF_ParValue.DescId     = zc_MovementFloat_ParValue()
          -- из строки
          LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                      ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                     AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
          LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                      ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                     AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()
          LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                      ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                     AND MIFloat_OperPriceList.DescId = zc_MIFloat_OperPriceList()

     WHERE MovementItem.Id = inId;

     -- расчитали <Сумма вх.> для грида
     outTotalSumm := zfCalc_SummIn (inAmount, vbOperPrice, vbCountForPrice);
 
     -- расчитали <Сумма вх. (ГРН)> для грида
     outTotalSummBalance := CASE WHEN vbCurrencyId_Doc = zc_Currency_Basis()
                                      THEN outTotalSumm
                                 ELSE zfCalc_CurrencyFrom (outTotalSumm, vbCurrencyValue, vbParValue)
                            END;

     -- расчитали <Сумма (прайс)> для грида
     outTotalSummPriceList := zfCalc_SummPriceList (inAmount, vbOperPriceList);

     -- Обновляем для Партии - Object_PartionGoods.Amount
     UPDATE Object_PartionGoods 
     SET Amount = inAmount
     WHERE Object_PartionGoods.MovementItemId = inId;

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (vbMovementId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.06.17         *
 09.05.17         * outOperPriceList
 10.04.17         *
*/

-- тест
-- SELECT * FROM gpUpdate_MovementItem_Income (inId := 154 , inAmount := 11 ,  inSession := '2');
