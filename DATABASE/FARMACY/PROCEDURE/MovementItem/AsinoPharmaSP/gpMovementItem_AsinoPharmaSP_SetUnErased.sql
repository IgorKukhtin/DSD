-- Function: gpMovementItem_AsinoPharmaSP_SetUnErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_AsinoPharmaSP_SetUnErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_AsinoPharmaSP_SetUnErased(
    IN inMovementItemId      Integer              , -- ключ объекта <Элемент документа>
   OUT outIsErased           Boolean              , -- новое значение
    IN inSession             TVarChar               -- текущий пользователь
)
  RETURNS Boolean
AS
$BODY$
   DECLARE vbMovementId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbUserId Integer;
   DECLARE vbQueue Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;
  
  -- устанавливаем новое значение
  outIsErased := FALSE;

  -- Обязательно меняем
  UPDATE MovementItem SET isErased = FALSE WHERE Id = inMovementItemId
         RETURNING MovementId INTO vbMovementId;

  -- определяем <Статус>
  vbStatusId := (SELECT StatusId FROM Movement WHERE Id = vbMovementId);
  -- проверка - проведенные/удаленные документы Изменять нельзя
  IF vbStatusId <> zc_Enum_Status_UnComplete()
  THEN
      RAISE EXCEPTION 'Ошибка.Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
  END IF;
  
  vbQueue := COALESCE((SELECT count(*)
                       FROM MovementItem
                       WHERE MovementItem.DescId = zc_MI_Master()
                         AND MovementItem.MovementId = vbMovementId
                         AND MovementItem.isErased = FALSE), 0)::Integer;  

  PERFORM lpInsertUpdate_MovementItem_AsinoPharmaSP (ioId                  := MovementItem.Id
                                                   , inMovementId          := vbMovementId
                                                   , inQueue               := vbQueue
                                                   , inUserId              := vbUserId)
  FROM MovementItem
  WHERE MovementItem.DescId = zc_MI_Master()
    AND MovementItem.MovementId = vbMovementId
    AND MovementItem.Id = inMovementItemId
    AND MovementItem.isErased = FALSE;

  -- пересчитали Итоговые суммы по накладной
  --PERFORM lpInsertUpdate_MovementFloat_TotalSumm (vbMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 28.02.23                                                       *
*/

-- тест
-- SELECT * FROM gpMovementItem_AsinoPharmaSP_SetUnErased (inMovementId:= 55, inSession:= '2')