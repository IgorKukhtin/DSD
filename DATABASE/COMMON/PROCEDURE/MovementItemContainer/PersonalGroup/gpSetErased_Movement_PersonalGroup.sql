-- Function: gpSetErased_Movement_PersonalGroup (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_PersonalGroup (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_PersonalGroup(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbStatusId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_PersonalGroup());

     --получаем текущий статус документа
     vbStatusId := (SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inMovementId);

     -- Удаляем Документ
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

     --при распроведении или удалении - в табеле автоматом  удаляется WorkTimeKind 
     -- если статус НЕ проведен , то данных в табеле уже нет, пропускаем этот шаг, выполняем только если проведен
     IF vbStatusId = zc_Enum_Status_Complete()
     THEN
         PERFORM gpInsertUpdate_MI_SheetWorkTime_byPersonalGroup(inMovementId, TRUE, inSession);
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.11.21         *
*/

-- тест
-- SELECT * FROM gpSetErased_Movement_PersonalGroup (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
