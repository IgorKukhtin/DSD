-- Function: gpComplete_Movement_PriceCorrective()

DROP FUNCTION IF EXISTS gpComplete_Movement_PriceCorrective (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_PriceCorrective(
    IN inMovementId        Integer              , -- ключ Документа
    IN inSession           TVarChar               -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_PriceCorrective());


     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_PriceCorrective_CreateTemp();
     -- Проводим Документ
     PERFORM lpComplete_Movement_PriceCorrective (inMovementId     := inMovementId
                                                , inUserId         := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 17.08.14                                        * add MovementDescId
 05.06.14                                        * all
 03.06.14         *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 10154, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_PriceCorrective (inMovementId:= 10154, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 10154, inSession:= '2')
