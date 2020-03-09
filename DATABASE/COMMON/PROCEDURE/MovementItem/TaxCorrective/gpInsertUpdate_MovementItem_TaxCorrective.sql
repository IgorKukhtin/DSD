-- Function: gpInsertUpdate_MovementItem_TaxCorrective()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_TaxCorrective (integer, integer, integer, tfloat, tfloat, tfloat, integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_TaxCorrective (integer, integer, integer, tfloat, tfloat, tfloat, integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_TaxCorrective(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inPrice               TFloat    , -- Цена
 INOUT ioCountForPrice       TFloat    , -- Цена за количество
   OUT outAmountSumm         TFloat    , -- Сумма расчетная
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inLineNumTaxOld       Integer   , -- № п/п в НН
    IN inLineNumTax          Integer   , -- № п/п в НН новое значение
   OUT outisAuto             Boolean   , -- формируется автоматом (№ п/п в НН)
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_TaxCorrective());

     -- сохранили <Элемент документа>
     SELECT tmp.ioId, tmp.ioCountForPrice, tmp.outAmountSumm
            INTO ioId, ioCountForPrice, outAmountSumm
     FROM lpInsertUpdate_MovementItem_TaxCorrective (ioId            := ioId
                                                   , inMovementId    := inMovementId
                                                   , inGoodsId       := inGoodsId
                                                   , inAmount        := inAmount
                                                   , inPrice         := inPrice
                                                   , inPriceTax_calc := (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = @ioId AND MIF.DescId = zc_MIFloat_PriceTax_calc())
                                                   , ioCountForPrice := ioCountForPrice
                                                   , inGoodsKindId   := inGoodsKindId
                                                   , inUserId        := vbUserId
                                                    ) AS tmp;

     -- проверяем значения № пп НН, если изменено , устанавливаем свойство Авто = False
     outisAuto :=TRUE;
     IF COALESCE (inLineNumTaxOld, 0) <> COALESCE (inLineNumTax, 0) AND COALESCE (inLineNumTax, 0) <> 0
      THEN 
          PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_isAuto(), ioId, FALSE);
          PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_NPP(), ioId, inLineNumTax);
          outisAuto := FALSE;
     END IF;
     IF COALESCE (inLineNumTaxOld, 0) <> COALESCE (inLineNumTax, 0) AND COALESCE (inLineNumTax, 0) = 0
      THEN 
          PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_isAuto(), ioId, TRUE);
     END IF;
 

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 30.03.16         *
 10.02.14                                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_TaxCorrective (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPrice:= 1, ioCountForPrice:= 1, inGoodsKindId:= 0, inSession:= '2')
