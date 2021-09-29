-- Function: gpComplete_Movement_Sale()

DROP FUNCTION IF EXISTS gpComplete_Movement_Sale (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Sale(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar                -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    IF zfConvert_StringToNumber (inSession) < 0
    THEN
        -- проверка прав пользователя на вызов процедуры
        vbUserId:= lpCheckRight ((-1 * zfConvert_StringToNumber (inSession)) :: TVarChar, zc_Enum_Process_Complete_Sale());
    ELSE
        -- проверка прав пользователя на вызов процедуры
        vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Sale());
    END IF;


     -- Проверка - Дата Документа
     PERFORM lpCheckOperDate_byUnit (inUnitId_by:= lpGetUnit_byUser (vbUserId), inOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId), inUserId:= vbUserId);

     -- создаются временные таблицы - для формирование данных по проводкам
     PERFORM lpComplete_Movement_Sale_CreateTemp();

     -- собственно проводки
     PERFORM lpComplete_Movement_Sale (inMovementId  -- Документ
                                     , CASE WHEN zfConvert_StringToNumber (inSession) < 0 THEN -1 * vbUserId ELSE vbUserId END
                                      );    -- Пользователь

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 14.05.17         *
 */

-- тест
-- SELECT * FROM gpComplete_Movement_Sale (inMovementId:= 1100, inSession:= zfCalc_UserAdmin())
