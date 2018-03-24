-- Function: gpComplete_Movement_ReturnIn()

DROP FUNCTION IF EXISTS gpComplete_Movement_ReturnIn  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_ReturnIn(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar                -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_ReturnIn());
     -- vbUserId:= lpGetUserBySession (inSession);


     -- Проверка - Дата Документа
     PERFORM lpCheckOperDate_byUnit (inUnitId_by:= lpGetUnit_byUser (vbUserId), inOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId), inUserId:= vbUserId);

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
 23.07.17         *
 14.05.17         *
 */

-- тест
-- SELECT * FROM gpComplete_Movement_ReturnIn (inMovementId:= 1100, inSession:= zfCalc_UserAdmin())
