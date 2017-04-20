-- Function: gpInsertUpdate_MI_OrderIncomeSnab()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_OrderIncomeSnab (Integer, Integer, Integer, TFloat, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_OrderIncomeSnab (Integer, Integer, Integer, TFloat, TFloat, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_OrderIncomeSnab(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
 INOUT ioMeasureId           Integer   , -- 
   OUT outMeasureName        TVarChar  , -- 
    IN inAmount              TFloat    , -- Количество
    IN inPrice               TFloat    , -- 
  OUT outAmountSumm          TFloat    , -- Сумма расчетная
    IN inGoodsId             Integer   , -- Товар
    IN inComment             TVarChar ,   -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbMovementItemId Integer;
   DECLARE vbNameBeforeId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderIncome());

     -- замена
     IF COALESCE (ioMeasureId, 0) = 0
     THEN
         ioMeasureId:= zc_Measure_Sht();
     END IF;
     outMeasureName:= (SELECT ValueData FROM Object WHERE Id = ioMeasureId);
   
     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), ioMeasureId, inMovementId, inAmount, NULL);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Goods(), ioId, inGoodsId);
     
     -- расчитали сумму по элементу, для грида
     outAmountSumm := CAST (inAmount * inPrice AS NUMERIC (16, 2));

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- сохранили протокол !!!после изменений!!!
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 14.04.17         *
*/

-- тест
-- 