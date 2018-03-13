-- Function: gpComplete_Movement_GoodsAccount()

DROP FUNCTION IF EXISTS gpComplete_Movement_GoodsAccount (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_GoodsAccount(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar                -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpGetUserBySession (inSession);
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_GoodsAccount());

     -- создаются временные таблицы - для формирование данных по проводкам
     PERFORM lpComplete_Movement_GoodsAccount_CreateTemp();

     -- собственно проводки
     PERFORM lpComplete_Movement_GoodsAccount (inMovementId  -- ключ Документа
                                             , vbUserId);    -- Пользователь

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 23.07.17         *
 18.05.17         *
 */

-- тест
-- SELECT * FROM gpComplete_Movement_GoodsAccount (inMovementId:= 1100, inSession:= zfCalc_UserAdmin())
