-- Function: gpMovementItem_Send_SetErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_Send_SetErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_Send_SetErased(
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
   DECLARE vbUnitId Integer;
   DECLARE vbFromId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbUserUnitId Integer;
BEGIN
  --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_MI_Send());
  vbUserId := inSession;
  -- устанавливаем новое значение
  outIsErased := TRUE;

  -- Обязательно меняем
  UPDATE MovementItem SET isErased = TRUE WHERE Id = inMovementItemId
         RETURNING MovementId INTO vbMovementId;

  -- проверка - связанные документы Изменять нельзя
  -- PERFORM lfCheck_Movement_Parent (inMovementId:= vbMovementId, inComment:= 'изменение');

  IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
            WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = 308121) -- Для роли "Кассир аптеки"
  THEN
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
      vbUnitKey := '0';
    END IF;
    vbUserUnitId := vbUnitKey::Integer;
        
    IF COALESCE (vbUserUnitId, 0) = 0
    THEN 
      RAISE EXCEPTION 'Ошибка. Не найдено подразделение сотрудника.';     
    END IF;     

    --определяем подразделение получателя
    SELECT MovementLinkObject_To.ObjectId AS UnitId
           INTO vbUnitId
    FROM MovementLinkObject AS MovementLinkObject_To
    WHERE MovementLinkObject_To.MovementId = vbMovementId
      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To();

    --определяем подразделение отправителя
    SELECT MovementLinkObject_From.ObjectId AS vbFromId
           INTO vbFromId
    FROM MovementLinkObject AS MovementLinkObject_From
    WHERE MovementLinkObject_From.MovementId = vbMovementId
      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From();
       
    IF COALESCE (vbFromId, 0) <> COALESCE (vbUserUnitId, 0) AND COALESCE (vbUnitId, 0) <> COALESCE (vbUserUnitId, 0) 
    THEN 
      RAISE EXCEPTION 'Ошибка. Вам разрешено работать только с подразделением <%>.', (SELECT ValueData FROM Object WHERE ID = vbUserUnitId);     
    END IF;     
  END IF;     

  -- определяем <Статус>
  vbStatusId := (SELECT StatusId FROM Movement WHERE Id = vbMovementId);
  -- проверка - проведенные/удаленные документы Изменять нельзя
  IF vbStatusId <> zc_Enum_Status_UnComplete() AND NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
  THEN
      RAISE EXCEPTION 'Ошибка.Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
  END IF;

  -- пересчитали Итоговые суммы по накладной
  PERFORM lpInsertUpdate_MovementFloat_TotalSummSend (vbMovementId);

  -- !!! НЕ ПОНЯТНО - ПОЧЕМУ НАДО ВОЗВРАЩАТЬ НАОБОРОТ!!!
  -- outIsErased := FALSE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpMovementItem_Send_SetErased (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.A.  Воробкало А.А.  Шаблий О.В.
 19.12.18                                                                                    *  
 29.07.15                                                                    *
*/

-- тест
-- SELECT * FROM gpMovementItem_Send_SetErased (inMovementId:= 55, inJuridicalId = 1, inSession:= '2')
