-- Function: gpUpdateMI_OrderInternal_AmountPack()

DROP FUNCTION IF EXISTS gpUpdateMI_OrderInternal_AmountPack (Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdateMI_OrderInternal_AmountPack (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMI_OrderInternal_AmountPack(
    IN inId                      Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId              Integer   , -- Ключ объекта <Документ>
    IN inAmountPack              TFloat    , -- Количество
    IN inAmountPackSecond        TFloat    , -- Количество дозаказ
    IN inAmountPackNext          TFloat    , -- Количество
    IN inAmountPackNextSecond    TFloat    , -- Количество дозаказ
   OUT outIsCalculated           Boolean   , -- 
    IN inSession                 TVarChar    -- сессия пользователя
)
RETURNS Boolean
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

     -- сохранили свойство <Изменять факт при пересчете>
     IF  inAmountPackNext       <> COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_AmountPackNext()), 0)
      OR inAmountPackNextSecond <> COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_AmountPackNextSecond()), 0)
     THEN
         outIsCalculated:= FALSE;
         PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Calculated(), inId, FALSE);
     ELSE
         outIsCalculated:= COALESCE ((SELECT MIB.ValueData FROM MovementItemBoolean AS MIB WHERE MIB.MovementItemId = inId AND MIB.DescId = zc_MIBoolean_Calculated()), TRUE);
     END IF;


     -- сохранили свойство <Количество заказ на УПАК>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPack(), inId, inAmountPack);
     -- сохранили свойство <Количество дозаказ>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPackSecond(), inId, inAmountPackSecond);
     
     -- сохранили свойство <Количество заказ на УПАК план2>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPackNext(), inId, inAmountPackNext);
     -- сохранили свойство <Количество дозаказ план2>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPackNextSecond(), inId, inAmountPackNextSecond);
     
    
     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- сохранили протокол !!!после изменений!!!
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 17.11.17         *
 16.11.17         *
*/

-- тест
-- 