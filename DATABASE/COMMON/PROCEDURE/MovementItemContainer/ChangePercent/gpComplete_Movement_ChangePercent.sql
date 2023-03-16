-- Function: gpComplete_Movement_ChangePercent()

DROP FUNCTION IF EXISTS gpComplete_Movement_ChangePercent (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_ChangePercent(
    IN inMovementId        Integer              , -- ключ Документа
   OUT outMessageText      Text                 ,
    IN inSession           TVarChar               -- сессия пользователя
)                              
RETURNS Text
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_ChangePercent());


     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_ChangePercent_CreateTemp();
     -- проводим Документ
     PERFORM lpComplete_Movement_ChangePercent (inMovementId := inMovementId
                                              , inUserId     := vbUserId
                                               );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 17.08.14                                        * add MovementDescId
 11.05.14                                        * change _tmpItem
 04.05.14                                        * all
 25.04.14         *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 10154, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_ChangePercent (inMovementId:= 10154, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 10154, inSession:= '2')
