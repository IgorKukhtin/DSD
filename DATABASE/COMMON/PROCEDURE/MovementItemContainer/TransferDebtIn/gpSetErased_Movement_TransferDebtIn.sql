-- Function: gpSetErased_Movement_TransferDebtIn (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_TransferDebtIn (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_TransferDebtIn(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_TransferDebtIn());


     -- удаляются все подчиненные корректировки
     PERFORM lpSetErased_Movement (inMovementId := MovementLinkMovement.MovementId
                                 , inUserId     := vbUserId)
     FROM MovementLinkMovement
     WHERE MovementLinkMovement.MovementChildId = inMovementId
       AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master();

     -- Удаляем Документ
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 24.12.14				         * add удаляются все подчиненные корректировки
 25.04.14         *
*/

-- тест
-- SELECT * FROM gpSetErased_Movement_TransferDebtIn (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
