-- Function: gpReComplete_Movement_MobileBills(integer, boolean, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_MobileBills (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_MobileBills(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_MobileBills());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_MobileBills())
     THEN
         -- Распроводим Документ
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;

     -- Проводим Документ
     PERFORM lpComplete_Movement_MobileBills (inMovementId     := inMovementId
                                           , inUserId         := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 28.09.16         *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 122175 , inSession:= '2')
-- SELECT * FROM gpReComplete_Movement_MobileBills (inMovementId:= 122175, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 122175 , inSession:= '2')
