-- Function: gpReComplete_Movement_ProductionSeparate(integer, boolean, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_ProductionSeparate (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_ProductionSeparate(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar                -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_ProductionSeparate());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_ProductionSeparate())
     THEN
         -- Распроводим Документ
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;


     -- Проводим Документ
     PERFORM gpComplete_Movement_ProductionSeparate (inMovementId     := inMovementId
                                                   , inIsLastComplete := TRUE
                                                   , inSession        := inSession);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 22.07.15                                        *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 122175 , inSession:= '2')
-- SELECT * FROM gpReComplete_Movement_ProductionSeparate (inMovementId:= 122175, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 122175 , inSession:= '2')
