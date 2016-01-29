-- Function: gpUpdate_MI_SendOnPrice_AmountPartner (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_MI_SendOnPrice_AmountPartner (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_SendOnPrice_AmountPartner(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SendOnPrice_Branch());

     -- распровели
     PERFORM gpUnComplete_Movement_SendOnPrice (inMovementId:= inMovementId, inSession:= inSession);

     -- сохранили
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), MovementItem.Id, COALESCE (MIFloat_AmountChangePercent.ValueData, 0))
     FROM MovementItem
          LEFT JOIN MovementItemFloat AS MIFloat_AmountChangePercent
                                      ON MIFloat_AmountChangePercent.MovementItemId = MovementItem.Id
                                     AND MIFloat_AmountChangePercent.DescId = zc_MIFloat_AmountChangePercent()
     WHERE MovementId = inMovementId;


     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- провели
     PERFORM gpComplete_Movement_SendOnPrice (inMovementId:= inMovementId, inSession:= inSession);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (MovementItem.Id, vbUserId, FALSE)
     FROM MovementItem
     WHERE MovementId = inMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 12.01.16         *
*/

-- тест
-- SELECT * FROM gpUpdate_MI_SendOnPrice_AmountPartner
