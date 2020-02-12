-- Function: gpUnComplete_Movement_ReestrTransportGoods (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_ReestrTransportGoods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_ReestrTransportGoods(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_ReestrTransportGoods());

     -- Распроводим Документ
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 12.02.20         *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement_ReestrTransportGoods (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
