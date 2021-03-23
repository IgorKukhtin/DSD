-- Function: gpSetErased_Movement_FinalSUA (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_FinalSUA (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_FinalSUA(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbMovementId Integer;
  DECLARE vbStatusId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_FinalSUA());
     vbUserId := inSession;

     IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
       RAISE EXCEPTION 'Выполненние операции вам запрещено, обратитесь к системному администратору';
     END IF;

     IF EXISTS (SELECT 1 FROM MovementDate  WHERE MovementId = inMovementId AND DescId = zc_MovementDate_Calculation())
     THEN
       RAISE EXCEPTION 'По документу сформированы перемещения в СУН изменение статуса запрешено.';
     END IF;
    
     -- проверка - если <Master> Проведен, то <Ошибка>
     PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= 'удалить');

     -- проверка - если есть <Child> Проведен, то <Ошибка>
     PERFORM lfCheck_Movement_ChildStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= 'удалить');

     -- Удаляем Документ
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 11.02.21                                                       *
*/

-- тест
-- SELECT * FROM gpSetErased_Movement_FinalSUA (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())