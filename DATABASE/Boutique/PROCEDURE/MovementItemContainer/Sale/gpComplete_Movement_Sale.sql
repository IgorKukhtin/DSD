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
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Sale());


     -- Проверка - Дата Документа
     PERFORM lpCheckOperDate_byUnit (inUnitId_by:= lpGetUnit_byUser (vbUserId), inOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId), inUserId:= vbUserId);

     -- создаются временные таблицы - для формирование данных по проводкам
     PERFORM lpComplete_Movement_Sale_CreateTemp();

     -- формирование
     IF 1=1 AND zc_Enum_GlobalConst_isTerry() = FALSE AND zfCalc_User_PriceListReal (vbUserId) = TRUE
     THEN
         PERFORM gpComplete_Movement_Sale_recalc (inMovementId := inMovementId
                                                , inSession    := inSession
                                                 );
     END IF;

     -- собственно проводки
     PERFORM lpComplete_Movement_Sale (inMovementId  -- Документ
                                     , vbUserId);    -- Пользователь

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
