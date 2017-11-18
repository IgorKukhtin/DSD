-- Function: gpUpdateMI_OrderInternal_AmountPack_master()

DROP FUNCTION IF EXISTS gpUpdateMI_OrderInternal_AmountPack_master (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMI_OrderInternal_AmountPack_master(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inAmount              TFloat    , -- Количество
    IN inAmountSecond        TFloat    , -- Количество дозаказ
    IN inAmountNext          TFloat    , -- Количество
    IN inAmountNextSecond    TFloat    , -- Количество дозаказ
   OUT outAmountTotal        TFloat    , -- 
   OUT outAmountNextTotal    TFloat    , -- 
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

     -- сохранили протокол !!!до изменений!!!
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

     -- сохранили <Элемент документа>
     PERFORM lpInsertUpdate_MovementItem (MovementItem.Id, MovementItem.DescId, MovementItem.ObjectId, MovementItem.MovementId, inAmount, NULL)
     FROM MovementItem
     WHERE MovementItem.Id = inId;

     -- сохранили свойство <Количество дозаказ>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountSecond(), inId, inAmountSecond);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountNext(), inId, inAmountNext);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountNextSecond(), inId, inAmountNextSecond);

     --
     outAmountTotal := COALESCE (inAmount, 0) + COALESCE (inAmountSecond, 0);
     outAmountNextTotal := COALESCE (inAmountNext, 0) + COALESCE (inAmountNextSecond, 0);
     
     
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
*/

-- тест
--