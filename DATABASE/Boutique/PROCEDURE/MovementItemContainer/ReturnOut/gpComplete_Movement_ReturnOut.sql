-- Function: gpComplete_Movement_ReturnOut()

DROP FUNCTION IF EXISTS gpComplete_Movement_ReturnOut  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_ReturnOut(
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
     PERFORM lpComplete_Movement_ReturnOut_CreateTemp();

     -- проводки
     PERFORM lpComplete_Movement_ReturnOut (inMovementId -- Документ
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
 
-- тест
-- SELECT * FROM gpComplete_Movement_Income (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
