-- Function: gpSetErased_Movement_PromoBonus (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_PromoBonus (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_PromoBonus(
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
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_PromoBonus());
     vbUserId := inSession;

--     IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
--     THEN
--       RAISE EXCEPTION 'Выполненние операции вам запрещено, обратитесь к системному администратору';
--     END IF;

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
 17.02.21                                                       *
*/

-- тест
-- SELECT * FROM gpSetErased_Movement_PromoBonus (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())