-- Function: gpUnComplete_Movement_PersonalReport (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_PersonalReport (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_PersonalReport(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar                -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_PersonalReport());

     -- проверка
     PERFORM lpCheck_Movement_PersonalReport (inMovementId:= inMovementId, inComment:= 'распроведен', inUserId:= vbUserId);

     -- Распроводим Документ
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 15.09.14                                                        *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement_PersonalReport (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
