-- Function: gpReComplete_Movement_Send(integer, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_Send (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_Send(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbFromId Integer;
  DECLARE vbUnitKey TVarChar;
  DECLARE vbUserUnitId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Send());

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
      WHERE MovementLinkObject_To.MovementId = inMovementId
        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To();

      --определяем подразделение отправителя
      SELECT MovementLinkObject_From.ObjectId AS vbFromId
             INTO vbFromId
      FROM MovementLinkObject AS MovementLinkObject_From
      WHERE MovementLinkObject_From.MovementId = inMovementId
        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From();
       
      IF COALESCE (vbFromId, 0) <> COALESCE (vbUserUnitId, 0) AND COALESCE (vbUnitId, 0) <> COALESCE (vbUserUnitId, 0) 
      THEN 
        RAISE EXCEPTION 'Ошибка. Вам разрешено работать только с подразделением <%>.', (SELECT ValueData FROM Object WHERE ID = vbUserUnitId);     
      END IF;     
    END IF;     

    -- только если документ проведен
    IF EXISTS(
                SELECT 1
                FROM Movement
                WHERE
                    Id = inMovementId
                    AND
                    StatusId = zc_Enum_Status_Complete()
             )
    THEN
        --распроводим документ
        PERFORM gpUpdate_Status_Send(inMovementId := inMovementId,
                                     inStatusCode := zc_Enum_StatusCode_UnComplete(),
                                     inSession    := inSession);
        --Проводим документ
        PERFORM gpUpdate_Status_Send(inMovementId := inMovementId,
                                     inStatusCode := zc_Enum_StatusCode_Complete(),
                                     inSession    := inSession);
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  ВОробкало А.А.  Шаблий О.В.
 19.12.18                                                                      *  
 18.09.15                                                         *
*/
