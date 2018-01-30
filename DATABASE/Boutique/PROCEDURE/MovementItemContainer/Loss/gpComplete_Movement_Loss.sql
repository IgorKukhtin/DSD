-- Function: gpComplete_Movement_Loss()

DROP FUNCTION IF EXISTS gpComplete_Movement_Loss  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Loss(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar                -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

     -- создаются временные таблицы - для формирование данных по проводкам
     PERFORM lpComplete_Movement_Loss_CreateTemp();

    -- собственно проводки
    PERFORM lpComplete_Movement_Loss (inMovementId -- ключ Документа
                                    , vbUserId     -- Пользователь
                                     );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 25.04.17         *
 */