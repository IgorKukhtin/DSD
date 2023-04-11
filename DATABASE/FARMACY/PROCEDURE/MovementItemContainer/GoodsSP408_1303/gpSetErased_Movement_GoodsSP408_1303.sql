-- Function: gpSetErased_Movement_GoodsSP408_1303 (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_GoodsSP408_1303 (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_GoodsSP408_1303(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_GoodsSP_1303());

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
 11.04.23                                                       *
*/

-- тест
-- SELECT * FROM gpSetErased_Movement_GoodsSP408_1303 (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
