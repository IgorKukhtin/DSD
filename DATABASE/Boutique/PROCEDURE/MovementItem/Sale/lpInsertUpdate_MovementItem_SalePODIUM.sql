-- Function: lpInsertUpdate_MovementItem_Sale()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer);

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, Integer, Integer
                                                        , TFloat, TFloat, TFloat, TFloat, TFloat
                                                        , TFloat, TFloat, TFloat, TFloat, TFloat
                                                        , TFloat, TFloat, TFloat, TFloat, TFloat
                                                        , TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, Integer, Integer
                                                        , TFloat, TFloat, TFloat, TFloat, TFloat
                                                        , TFloat, TFloat, TFloat, TFloat, TFloat
                                                        , TFloat, TFloat, TFloat, TFloat, TFloat
                                                        , TVarChar, TVarChar, Integer);

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, Integer, Integer
                                                        , TFloat, TFloat, TFloat, TFloat
                                                        , TFloat, TFloat, TFloat, TFloat
                                                        , TVarChar, TVarChar, Integer);

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, Integer, Integer
                                                        , TFloat, TFloat, TFloat, TFloat, TFloat
                                                        , TFloat, TFloat, TFloat, TFloat
                                                        , TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Sale(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inGoodsId               Integer   , -- Товар
    IN inPartionId             Integer   , -- Партия
    IN inDiscountSaleKindId    Integer   , -- Вид скидки при продаже
    IN inAmount                TFloat    , -- Количество
    IN inChangePercent         TFloat    , -- % Скидки
    IN inChangePercentNext     TFloat    , -- % Скидки
    -- IN inSummChangePercent     TFloat    , -- Дополнительная скидка в продаже ГРН
    IN inOperPrice             TFloat    , -- Цена вх. в валюте
    IN inCountForPrice         TFloat    , -- Цена вх.за количество
    IN inOperPriceList         TFloat    , -- Цена по прайсу
    IN inCurrencyValue         TFloat    , -- Курс для перевода из валюты партии в ГРН
    IN inParValue              TFloat    , -- Номинал для перевода из валюты партии в ГРН
    IN inTotalChangePercent    TFloat    , -- Итого скидка в продаже ГРН
    -- IN inTotalChangePercentPay TFloat    , --
    -- IN inTotalPay              TFloat    , -- Итого оплата в продаже ГРН
    -- IN inTotalPayOth           TFloat    , --
    -- IN inTotalCountReturn      TFloat    , --
    -- IN inTotalReturn           TFloat    , --
    -- IN inTotalPayReturn        TFloat    , --

    IN inBarCode               TVarChar  , -- Штрих-код поставщика
    IN inComment               TVarChar  , -- примечание
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

     -- сохранили свойство <цена (прайс)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList(), ioId, inOperPriceList);
     -- сохранили свойство <Курс для перевода из валюты партии в ГРН>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CurrencyValue(), ioId, inCurrencyValue);
     -- сохранили свойство <Номинал для перевода из валюты партии в ГРН>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ParValue(), ioId, inParValue);

     -- сохранили свойство <Итого скидка в продаже ГРН>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalChangePercent(), ioId, inTotalChangePercent);

     -- сохранили свойство <% Скидки>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), ioId, inChangePercent);
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercentNext(), ioId, inChangePercentNext);

     -- сохранили свойство <Штрих-код поставщика>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_BarCode(), ioId, inBarCode);
     -- сохранили свойство <примечание>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

     -- сохранили связь с <Вид скидки при продаже>
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
 06.07.17         *
 10.05.17         *
*/

-- тест
--