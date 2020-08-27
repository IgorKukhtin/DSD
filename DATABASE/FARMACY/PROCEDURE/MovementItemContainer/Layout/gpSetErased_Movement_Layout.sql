-- Function: gpSetErased_Movement_Layout (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_Layout (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_Layout(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_Layout());
     vbUserId := inSession;

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
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.08.20         *
*/

-- тест
-- SELECT * FROM gpSetErased_Movement_Layout (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
