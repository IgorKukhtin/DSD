-- Function: gpUnComplete_Movement_Inventory (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_Inventory (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_Inventory(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbUnitKey TVarChar;
  DECLARE vbUserUnitId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= inSession; -- lpCheckRight(inSession, zc_Enum_Process_UnComplete_Inventory());

      -- Разрешаем только сотрудникам с правами админа    
     IF (SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inMovementId) = zc_Enum_Status_Complete()
     THEN
       IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_Admin(), zc_Enum_Role_UnComplete()))
       THEN
         RAISE EXCEPTION 'Распроведение вам запрещено, обратитесь к системному администратору';
       END IF;
     END IF;

     IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
               WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = 308121) -- Для роли "Кассир аптеки"
     THEN
     
        vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
        IF vbUnitKey = '' THEN
           vbUnitKey := '0';
        END IF;
        vbUserUnitId := vbUnitKey::Integer;

        SELECT MLO_Unit.ObjectId
        INTO vbUnitId
        FROM  Movement
              INNER JOIN MovementLinkObject AS MLO_Unit
                                            ON MLO_Unit.MovementId = Movement.Id
                                           AND MLO_Unit.DescId = zc_MovementLinkObject_Unit()
        WHERE Movement.Id = inMovementId;

        IF COALESCE (vbUnitId, 0) <> COALESCE (vbUserUnitId, 0)
        THEN
           RAISE EXCEPTION 'Ошибка. Вам разрешено работать только с подразделением <%>.', (SELECT ValueData FROM Object WHERE ID = vbUserUnitId);     
        END IF;     

        RAISE EXCEPTION 'Ошибка. Отмена подписи инвентаризаций вам запрещена.';     
     END IF;     

     -- проверка - если <Master> Удален, то <Ошибка>
     PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_UnComplete(), inComment:= 'распровести');

     -- Распроводим Документ
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

     --Удалить все строки, залитые автоматом при проведении
     PERFORM lpDelete_MovementItem(MovementItem.Id,inSession)
     FROM
         MovementItem
         INNER JOIN MovementItemBoolean AS MIBoolean_IsAuto
                                        ON MIBoolean_IsAuto.MovementItemId = MovementItem.Id
                                       AND MIBoolean_IsAuto.DescId = zc_MIBoolean_isAuto()
     WHERE
         MovementItem.MovementId = inMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.   Шаблий О.В.
 02.07.19                                                                                    *
 17.12.18                                                                                    *
 16.09.2015                                                                   *  + Удалить все строки, залитые автоматом при проведении
 01.09.14                                                       *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement_Inventory (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
