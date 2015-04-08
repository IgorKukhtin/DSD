-- Function: gpReComplete_Movement_PersonalService (integer, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_PersonalService (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_PersonalService(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_PersonalService());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_PersonalService())
     THEN
         -- Распроводим Документ
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;


     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();
     -- Проводим Документ
     PERFORM lpComplete_Movement_PersonalService (inMovementId     := inMovementId
                                                , inUserId         := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.04.15                                        *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 122175 , inSession:= '2')
-- SELECT * FROM gpReComplete_Movement_PersonalService (inMovementId:= 122175, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 122175 , inSession:= '2')
