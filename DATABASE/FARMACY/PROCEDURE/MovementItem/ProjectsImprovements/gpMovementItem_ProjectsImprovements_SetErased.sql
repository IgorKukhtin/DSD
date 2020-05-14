-- Function: gpMovementItem_ProjectsImprovements_SetErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_ProjectsImprovements_SetErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_ProjectsImprovements_SetErased(
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

  -- проверка прав пользователя на вызов процедуры
  vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProjectsImprovements());

  -- устанавливаем новое значение
  outIsErased := TRUE;

  -- Обязательно меняем
  UPDATE MovementItem SET isErased = TRUE WHERE Id = inMovementItemId
         RETURNING MovementId INTO vbMovementId;

  -- определяем <Статус>
  vbStatusId := (SELECT StatusId FROM Movement WHERE Id = vbMovementId);

  -- проверка - проведенные/удаленные документы Изменять нельзя
  IF vbStatusId <> zc_Enum_Status_UnComplete() --AND NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
  THEN
      RAISE EXCEPTION 'Ошибка.Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
  END IF;

  -- проверка - проведенные/удаленные документы Изменять нельзя
  IF EXISTS(SELECT 1 FROM MovementItem WHERE MovementItem.Id = inMovementItemId AND MovementItem.Amount <> 0)
  THEN
      RAISE EXCEPTION 'Ошибка.Доработка выполнена удаление не возможно.';
  END IF;

  -- !!! НЕ ПОНЯТНО - ПОЧЕМУ НАДО ВОЗВРАЩАТЬ НАОБОРОТ!!!
  -- outIsErased := FALSE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpMovementItem_ProjectsImprovements_SetErased (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 14.5.20                                                        *  
*/

-- тест
-- SELECT * FROM gpMovementItem_ProjectsImprovements_SetErased (inMovementId:= 55, inJuridicalId = 1, inSession:= '2')
