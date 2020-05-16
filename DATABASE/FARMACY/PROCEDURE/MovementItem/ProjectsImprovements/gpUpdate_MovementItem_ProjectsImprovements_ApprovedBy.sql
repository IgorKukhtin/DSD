-- Function: gpUpdate_MovementItem_ProjectsImprovements_ApprovedBy 

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_ProjectsImprovements_ApprovedBy (Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_ProjectsImprovements_ApprovedBy(
    IN inId                  Integer              , -- ключ объекта <Содержимое Документ>
    IN inMovementId          Integer              , -- ключ объекта <Документ>
    IN inisApprovedBy        Boolean              , -- новое значение
    IN inSession             TVarChar               -- текущий пользователь
)
  RETURNS VOID
AS
$BODY$
   DECLARE vbMovementId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbUserId Integer;
BEGIN

  -- проверка прав пользователя на вызов процедуры
  vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProjectsImprovements());
  
  IF COALESCE (inId, 0) = 0 OR COALESCE (inMovementId, 0) = 0 OR
     NOT EXISTS(SELECT 1 FROM MovementItem WHERE MovementItem.Id = inId AND MovementItem.MovementId = inMovementId)
  THEN
    RAISE EXCEPTION 'Документ не записан.';  
  END IF;
  
  IF  vbUserId <> 948223 AND NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
  THEN
    RAISE EXCEPTION 'У вас нет прав изменение <Утверждено>.';    
  END IF;

  -- определяем <Статус>
  vbStatusId := (SELECT StatusId FROM Movement WHERE Id = inMovementId);

  -- проверка - проведенные/удаленные документы Изменять нельзя
  IF vbStatusId <> zc_Enum_Status_UnComplete()
  THEN
      RAISE EXCEPTION 'Ошибка.Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
  END IF;

  -- проверка - проведенные/удаленные документы Изменять нельзя
  IF EXISTS(SELECT 1 FROM MovementItem WHERE MovementItem.Id = inId AND MovementItem.isErased = True)
  THEN
      RAISE EXCEPTION 'Ошибка.Изменение удаленных доработок не возможно.';
  END IF;

  -- проверка - проведенные/удаленные документы Изменять нельзя
  IF EXISTS(SELECT 1 FROM MovementItem WHERE MovementItem.Id = inId AND MovementItem.Amount <> 0)
  THEN
      RAISE EXCEPTION 'Ошибка.Доработка выполнена отмена Утвержден не возможна.';
  END IF;

  -- Сохранили <Пояснение>
  PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_ApprovedBy(), inId, NOT inisApprovedBy);

  -- сохранили протокол
  PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_MovementItem_ProjectsImprovements_ApprovedBy (Integer, Integer, Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 14.5.20                                                        *  
*/

-- тест
-- SELECT * FROM gpUpdate_MovementItem_ProjectsImprovements_ApprovedBy (inMovementId:= 55, inSession:= '2')


