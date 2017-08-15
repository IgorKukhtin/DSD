-- Function: lpInsertUpdate_MovementItem_ReturnIn()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ReturnIn (Integer, Integer, Integer, Integer, Integer
                                                           , TFloat, TFloat, TFloat, TFloat, TFloat
                                                           , TFloat, TFloat, TFloat, TFloat
                                                           , Integer);

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ReturnIn (Integer, Integer, Integer, Integer, Integer, Integer
                                                           , TFloat, TFloat, TFloat, TFloat, TFloat
                                                           , TFloat, TFloat, TFloat, TFloat
                                                           , Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ReturnIn (Integer, Integer, Integer, Integer, Integer, Integer
                                                           , TFloat, TFloat, TFloat, TFloat, TFloat
                                                           , TFloat, TFloat, TFloat, TFloat
                                                           , TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ReturnIn (Integer, Integer, Integer, Integer, Integer
                                                           , TFloat, TFloat, TFloat, TFloat
                                                           , TFloat, TFloat, TFloat, TFloat
                                                           , TVarChar, Integer);                                                           
                                                           
CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_ReturnIn(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inGoodsId               Integer   , -- Товары
    IN inPartionId             Integer   , -- Партия
    IN inPartionMI_Id          Integer   , -- Партия элемента продажа/возврат
   -- IN inSaleMI_Id             Integer   , -- строка док. продажи
    IN inAmount                TFloat    , -- Количество
    IN inOperPrice             TFloat    , -- Цена
    IN inCountForPrice         TFloat    , -- Цена за количество
    IN inOperPriceList         TFloat    , -- Цена по прайсу
    IN inCurrencyValue         TFloat    , -- 
    IN inParValue              TFloat    , -- 
    IN inTotalChangePercent    TFloat    , -- 
    --IN inTotalPay              TFloat    , -- 
    --IN inTotalPayOth           TFloat    , -- 
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

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList(), ioId, inOperPriceList);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CurrencyValue(), ioId, inCurrencyValue);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ParValue(), ioId, inParValue);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalChangePercent(), ioId, inTotalChangePercent);
    
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionMI(), ioId, inPartionMI_Id);

     -- сохранили свойство <примечание>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);
     

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
 15.05.17         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItem_ReturnIn (ioId := 0 , inMovementId := 8 , inGoodsId := 446 , inPartionId := 50 , inisPay := False ,  inAmount := 4 ,inSummChangePercent:=0, ioOperPriceList := 1030 , inBarCode := '1' ::TVarChar,  inSession := '2');
