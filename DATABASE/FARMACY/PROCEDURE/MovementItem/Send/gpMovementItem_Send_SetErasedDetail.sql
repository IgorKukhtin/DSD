-- Function: gpMovementItem_Send_SetErasedDetail (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_Send_SetErasedDetail (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_Send_SetErasedDetail(
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
   DECLARE vbisSUN         Boolean;
BEGIN
  --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_MI_Send());
  vbUserId := inSession;

  IF COALESCE (inMovementItemId, 0) = 0
  THEN 
      RAISE EXCEPTION 'Ошибка. Удалять можно только привязанные позиции.';     
  END IF;    

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
    SELECT MovementLinkObject_To.ObjectId                               AS UnitId
         , MovementLinkObject_From.ObjectId                             AS FromId
         , COALESCE (MovementBoolean_SUN.ValueData, FALSE)::Boolean     AS isSUN
    INTO vbUnitId, vbFromId, vbisSUN
    FROM Movement 
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
    
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
    
          LEFT JOIN MovementBoolean AS MovementBoolean_SUN
                                    ON MovementBoolean_SUN.MovementId = Movement.Id
                                   AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()

    WHERE Movement.Id = vbMovementId;
     
    IF vbisSUN = TRUE 
    THEN
      RAISE EXCEPTION 'Ошибка. В перемещения по СУН удаление товара вам запрещено.';    
    END IF;
       
    IF COALESCE (vbFromId, 0) <> COALESCE (vbUserUnitId, 0) AND COALESCE (vbUnitId, 0) <> COALESCE (vbUserUnitId, 0) 
    THEN 
      RAISE EXCEPTION 'Ошибка. Вам разрешено работать только с подразделением <%>.', (SELECT ValueData FROM Object WHERE ID = vbUserUnitId);     
    END IF;     

    RAISE EXCEPTION 'Ошибка. В перемещения удаление товара вам запрещено.';    
  END IF;     

  -- определяем <Статус>
  vbStatusId := (SELECT StatusId FROM Movement WHERE Id = vbMovementId);
  -- проверка - проведенные/удаленные документы Изменять нельзя
  IF vbStatusId <> zc_Enum_Status_UnComplete() AND NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
  THEN
      RAISE EXCEPTION 'Ошибка.Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
  END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpMovementItem_Send_SetErasedDetail (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 11.01.20                                                       *  
*/

-- тест
-- SELECT * FROM gpMovementItem_Send_SetErasedDetail (inMovementId:= 55, inJuridicalId = 1, inSession:= '2')