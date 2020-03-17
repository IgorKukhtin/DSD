-- Function: gpSetErased_Movement_SendAsset (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_SendAsset (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_SendAsset(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbMovementId_SendAsset_out Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_SendAsset());

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
 17.03.20         *
*/

-- тест
-- SELECT * FROM gpSetErased_Movement_SendAsset (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
