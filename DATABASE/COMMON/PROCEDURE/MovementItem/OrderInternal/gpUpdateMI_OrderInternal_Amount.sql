-- Function: gpUpdateMI_OrderInternal_Amount()

DROP FUNCTION IF EXISTS gpUpdateMI_OrderInternal_Amount (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMI_OrderInternal_Amount(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inAmount              TFloat    , -- Количество
    IN inAmountSecond        TFloat    , -- Количество дозаказ
    IN inAmountNext          TFloat    , -- Количество
    IN inAmountNextSecond    TFloat    , -- Количество дозаказ
   OUT outAmountAllTotal     TFloat    , -- 
   OUT outAmountTotal        TFloat    , -- 
   OUT outAmountNextTotal    TFloat    , -- 
   OUT outIsCalculated       Boolean   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderInternal());

     -- проверка
     IF COALESCE (inId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Элемент не найден.';
     END IF;

     -- Склады База + Реализации -> ЦЕХ упаковки
     IF   EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.ObjectId = 8457 AND MLO.DescId = zc_MovementLinkObject_From())
      AND EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.ObjectId = 8451 AND MLO.DescId = zc_MovementLinkObject_To())
      -- !!!только при изменении кол-ва
      AND EXISTS (SELECT 1 FROM MovementItem AS MI WHERE MI.Id = inId AND MI.Amount <> inAmount)
     THEN
         -- меняется признак
         outIsCalculated:= FALSE;
         -- сохранили свойство <Изменять факт при пересчете>
         PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Calculated(), inId, FALSE);
     ELSE
         -- НЕ меняется признак
         outIsCalculated:= COALESCE ((SELECT MIB.ValueData FROM MovementItemBoolean AS MIB WHERE MIB.MovementItemId = inId AND MIB.DescId = zc_MIBoolean_Calculated()), TRUE);
     END IF;

     -- сохранили <Элемент документа>
     PERFORM lpInsertUpdate_MovementItem (MovementItem.Id, MovementItem.DescId, MovementItem.ObjectId, MovementItem.MovementId, inAmount, NULL)
     FROM MovementItem
     WHERE MovementItem.Id = inId;

     -- сохранили свойство <Количество дозаказ>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountSecond(), inId, inAmountSecond);


     -- сохранили свойство <Количество заказ на УПАК>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountNext(), inId, inAmountNext);
     -- сохранили свойство <Количество дозаказ>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountNextSecond(), inId, inAmountNextSecond);
     
     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);
     

     -- сохранили протокол !!!после изменений!!!
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

     -- расчитали Итоговые суммы
     outAmountTotal    := inAmount + inAmountSecond;
     outAmountNextTotal:= inAmountNext + inAmountNextSecond;
     outAmountAllTotal := outAmountTotal + outAmountNextTotal;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 16.11.17         *
*/

-- тест
-- SELECT * FROM gpUpdateMI_OrderInternal_Amount (inId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
