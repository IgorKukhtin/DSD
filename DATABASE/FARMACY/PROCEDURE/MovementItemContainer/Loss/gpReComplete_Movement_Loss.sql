-- Function: gpReComplete_Movement_Loss (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_Loss (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_Loss(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Loss());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_Loss())
     THEN
         -- Распроводим Документ
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;


     -- Проводим Документ
     PERFORM gpComplete_Movement_Loss (inMovementId     := inMovementId
                                          , inIsLastComplete := NULL
                                          , inSession        := inSession);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 21.07.15                                                                        *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 122175 , inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpReComplete_Movement_Loss (inMovementId:= 122175, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 122175 , inSession:= zfCalc_UserAdmin())
