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
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight(inSession, zc_Enum_Process_UnComplete_Inventory());

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
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 16.09.2015                                                                   *  + Удалить все строки, залитые автоматом при проведении
 01.09.14                                                       *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement_Inventory (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
