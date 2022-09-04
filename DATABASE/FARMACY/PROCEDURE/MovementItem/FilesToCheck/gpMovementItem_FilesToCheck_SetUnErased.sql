-- Function: gpMovementItem_FilesToCheck_SetUnErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_FilesToCheck_SetUnErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_FilesToCheck_SetUnErased(
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
BEGIN
  --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetUnErased_MI_FilesToCheck());
  vbUserId:= lpGetUserBySession (inSession);
  
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


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 03.09.22                                                       *
*/

-- тест
--