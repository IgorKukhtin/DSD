-- Function: gpReComplete_Movement_ReestrTransportGoods(integer, boolean, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_ReestrTransportGoods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_ReestrTransportGoods(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_ReestrTransportGoods());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_ReestrTransportGoods())
     THEN
         -- Распроводим Документ
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;

     -- Проводим Документ
     PERFORM lpComplete_Movement_ReestrTransportGoods (inMovementId     := inMovementId
                                             , inUserId         := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 12.02.20         *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 122175 , inSession:= '2')
-- SELECT * FROM gpReComplete_Movement_ReestrTransportGoods (inMovementId:= 122175, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 122175 , inSession:= '2')
