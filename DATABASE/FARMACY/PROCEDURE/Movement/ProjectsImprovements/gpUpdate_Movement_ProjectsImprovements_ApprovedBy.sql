-- Function: gpUpdate_Movement_ProjectsImprovements_ApprovedBy 

DROP FUNCTION IF EXISTS gpUpdate_Movement_ProjectsImprovements_ApprovedBy (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_ProjectsImprovements_ApprovedBy(
    IN inId                  Integer              , -- ключ объекта <Документ>
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
  
  IF COALESCE (inId, 0) = 0
  THEN
    RAISE EXCEPTION 'Документ не записан.';  
  END IF;
  
  IF  vbUserId <> 948223 AND NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
  THEN
    RAISE EXCEPTION 'У вас нет прав изменение <Утверждено>.';    
  END IF;

  -- определяем <Статус>
  vbStatusId := (SELECT StatusId FROM Movement WHERE Id = inId);

  -- проверка - проведенные/удаленные документы Изменять нельзя
  IF vbStatusId <> zc_Enum_Status_UnComplete()
  THEN
      RAISE EXCEPTION 'Ошибка.Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
  END IF;

  -- Сохранили <Пояснение>
  PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_ApprovedBy(), inId, NOT inisApprovedBy);

  -- сохранили протокол
  PERFORM lpInsert_MovementProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Movement_ProjectsImprovements_ApprovedBy (Integer, Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 14.5.20                                                        *  
*/

-- тест
-- SELECT * FROM gpUpdate_Movement_ProjectsImprovements_ApprovedBy (inMovementId:= 55, inSession:= '2')
