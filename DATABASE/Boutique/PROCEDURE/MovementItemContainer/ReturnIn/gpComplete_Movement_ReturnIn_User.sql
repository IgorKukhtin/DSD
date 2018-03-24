-- Function: gpComplete_Movement_ReturnIn()

DROP FUNCTION IF EXISTS gpComplete_Movement_ReturnIn_User  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_ReturnIn_User(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar                -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_ReturnIn());
     vbUserId:= lpGetUserBySession (inSession);


     -- !!!Меняем только для Подразделения!!! - Дата док. должна соответствовать Дате Проведения
     UPDATE Movement SET OperDate = CURRENT_DATE WHERE Movement.Id = inMovementId;

     -- создаются временные таблицы - для формирование данных по проводкам
     PERFORM lpComplete_Movement_ReturnIn_CreateTemp();

     -- проводки
     PERFORM lpComplete_Movement_ReturnIn (inMovementId  -- Документ
                                         , vbUserId);    -- Пользователь

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 26.02.18         *
 */

-- тест
-- SELECT * FROM gpComplete_Movement_ReturnIn_User (inMovementId:= 1100, inSession:= zfCalc_UserAdmin())
