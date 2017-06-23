-- Function: lpInsertUpdate_MovementItem_Sale()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer);

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, Integer, Integer
                                                        , TFloat, TFloat, TFloat, TFloat, TFloat
                                                        , TFloat, TFloat, TFloat, TFloat, TFloat
                                                        , TFloat, TFloat, TFloat, TFloat, TFloat
                                                        , TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Sale(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inGoodsId               Integer   , -- Товары
    IN inPartionId             Integer   , -- Партия
    IN inDiscountSaleKindId    Integer   , -- Вид скидки при продаже
    IN inAmount                TFloat    , -- Количество
    IN inChangePercent         TFloat    , -- % Скидки
    IN inSummChangePercent     TFloat    , -- Сумма дополнительной Скидки (в ГРН)
    IN inOperPrice             TFloat    , -- Цена
    IN inCountForPrice         TFloat    , -- Цена за количество
    IN inOperPriceList         TFloat    , -- Цена по прайсу
    IN inCurrencyValue         TFloat    , -- 
    IN inParValue              TFloat    , -- 
    IN inTotalChangePercent    TFloat    , -- 
    IN inTotalChangePercentPay TFloat    , -- 
    IN inTotalPay              TFloat    , -- 
    IN inTotalPayOth           TFloat    , -- 
    IN inTotalCountReturn      TFloat    , -- 
    IN inTotalReturn           TFloat    , -- 
    IN inTotalPayReturn        TFloat    , -- 

    IN inBarCode               TVarChar  , -- Штрих-код поставщика
    IN inUserId                Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка - связанные документы Изменять нельзя
     -- PERFORM lfCheck_Movement_Parent (inMovementId:= inMovementId, inComment:= 'изменение');


     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inPartionId, inMovementId, inAmount, NULL);
   
     -- сохранили свойство <Цена>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(), ioId, inOperPrice);
     -- сохранили свойство <Цена за количество>
     IF COALESCE (inCountForPrice, 0) = 0 THEN inCountForPrice := 1; END IF;
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, inCountForPrice);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList(), ioId, inOperPriceList);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CurrencyValue(), ioId, inCurrencyValue);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ParValue(), ioId, inParValue);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalChangePercent(), ioId, inTotalChangePercent);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalChangePercentPay(), ioId, inTotalChangePercentPay);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalPay(), ioId, inTotalPay);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalPayOth(), ioId, inTotalPayOth);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalCountReturn(), ioId, inTotalCountReturn);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalReturn(), ioId, inTotalReturn);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalPayReturn(), ioId, inTotalPayReturn);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), ioId, inChangePercent);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChangePercent(), ioId, inSummChangePercent);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_BarCode(), ioId, inBarCode);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_DiscountSaleKind(), ioId, inDiscountSaleKindId);


     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.05.17         *
*/

-- тест
-- 