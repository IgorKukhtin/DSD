-- Function: gpInsertUpdate_MovementItem_PriceCorrective()

-- DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PriceCorrective(Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PriceCorrective(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_PriceCorrective(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа Перевод долга (расход)>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inPrice               TFloat    , -- Цена -  на сколько корректируется("+"уменьшается или "-"увеличивается) 
    IN inPriceTax_calc       TFloat    , -- Цена продажи (корр.) - оригинальная, которая корректируется
 INOUT ioCountForPrice       TFloat    , -- Цена за количество
   OUT outAmountSumm         TFloat    , -- Сумма расчетная
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inUserId              Integer     -- пользователь
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

     -- сохранили свойство <Цена>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);
     -- сохранили свойство <Цена за количество>
     IF COALESCE (ioCountForPrice, 0) = 0 THEN ioCountForPrice := 1; END IF;
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, ioCountForPrice);

     -- сохранили свойство <Цена продажи (корр.)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceTax_calc(), ioId, inPriceTax_calc);

     -- сохранили свойство <Цена продажи (новая)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceTo(), ioId, inPriceTax_calc - inPrice);

     -- сохранили связь с <Виды товаров>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovemenTFloat_TotalSumm (inMovementId);

     -- расчитали сумму по элементу, для грида
     outAmountSumm := CASE WHEN ioCountForPrice > 0
                                THEN CAST (inAmount * inPrice / ioCountForPrice AS NUMERIC (16, 2))
                           ELSE CAST (inAmount * inPrice AS NUMERIC (16, 2))
                      END;

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 30.05.14         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItem_PriceCorrective (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPrice:= 1, inCountForPrice:= 1, inGoodsKindId:= 0, inUserId:=5)
