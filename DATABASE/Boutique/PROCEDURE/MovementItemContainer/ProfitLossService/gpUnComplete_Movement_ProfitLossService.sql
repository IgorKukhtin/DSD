-- Function: gpUnComplete_Movement_ProfitLossService (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_ProfitLossService (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_ProfitLossService(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar                -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_ProfitLossService());

     -- Распроводим Документ
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 06.03.14                                        * add lpCheckRight
 17.02.14				                        *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement_ProfitLossService (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
