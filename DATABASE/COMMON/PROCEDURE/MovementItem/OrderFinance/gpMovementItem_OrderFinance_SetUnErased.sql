-- Function: gpMovementItem_OrderFinance_SetUnErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_OrderFinance_SetUnErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_OrderFinance_SetUnErased(
    IN inMovementItemId      Integer              , -- ключ объекта <Элемент документа>
   OUT outIsErased           Boolean              , -- новое значение
    IN inSession             TVarChar               -- текущий пользователь
)
  RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetUnErased_MI_OrderFinance());

  -- нашли
  vbMovementId:= (SELECT MovementItem.MovementId FROM MovementItem WHERE MovementItem.Id = inMovementItemId);

  -- устанавливаем новое значение
  outIsErased:= lpSetUnErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);

  -- Проверка - после SetUnErased
  PERFORM lpCheck_Movement_OrderFinance (inMovementId:= vbMovementId, inUserId:= vbUserId);

  -- пересчитали Итоговые суммы
  PERFORM lpInsertUpdate_MovementFloat_TotalSummOrderFinance (vbMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.07.19         *
*/

-- тест
--