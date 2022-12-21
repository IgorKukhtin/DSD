-- Function: gpSetErased_Movement_SendOnPrice (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_SendOnPrice (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_SendOnPrice(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId_Peresort Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_SendOnPrice());

     -- проверка - если <Master> Проведен, то <Ошибка>
     PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= 'удалить');

     -- проверка - если есть <Child> Проведен, то <Ошибка>
     PERFORM lfCheck_Movement_ChildStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= 'удалить');

     -- Удаляем Документ
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);


     -- Поиск "Пересортица"
     vbMovementId_Peresort:= (SELECT MLM.MovementId FROM MovementLinkMovement AS MLM WHERE MLM.MovementChildId = inMovementId AND MLM.DescId = zc_MovementLinkMovement_Production());
     -- Синхронно - Удалили
     IF vbMovementId_Peresort <> 0
     THEN
         PERFORM lpSetErased_Movement (inMovementId := vbMovementId_Peresort
                                     , inUserId     := vbUserId
                                      );
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.05.14                                                       *
 29.10.13                                        *
*/

-- тест
-- SELECT * FROM gpSetErased_Movement_SendOnPrice (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
