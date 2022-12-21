-- Function: gpUnComplete_Movement_SendOnPrice (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_SendOnPrice (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_SendOnPrice(
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
     vbUserId:= lpCheckRight(inSession, zc_Enum_Process_UnComplete_SendOnPrice());

     -- проверка - если <Master> Удален, то <Ошибка>
     PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_UnComplete(), inComment:= 'распровести');

     -- Распроводим Документ
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);


     -- Поиск "Пересортица"
     vbMovementId_Peresort:= (SELECT MLM.MovementId
                              FROM MovementLinkMovement AS MLM
                                   JOIN Movement ON Movement.Id       = MLM.MovementId
                                                AND Movement.StatusId <> zc_Enum_Status_Erased()
                              WHERE MLM.MovementChildId = inMovementId AND MLM.DescId = zc_MovementLinkMovement_Production()
                             );
     -- Синхронно - Распровели
     IF vbMovementId_Peresort <> 0
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := vbMovementId_Peresort
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
-- SELECT * FROM gpUnComplete_Movement_SendOnPrice (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
