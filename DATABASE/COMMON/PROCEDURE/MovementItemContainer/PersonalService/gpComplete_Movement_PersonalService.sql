-- Function: gpComplete_Movement_PersonalService()

DROP FUNCTION IF EXISTS gpComplete_Movement_PersonalService (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_PersonalService(
    IN inMovementId        Integer              , -- ключ Документа
    IN inSession           TVarChar               -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_PersonalService());

     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- проводим Документ
     PERFORM lpComplete_Movement_PersonalService (inMovementId := inMovementId
                                                , inUserId     := vbUserId);

     -- Админу только отладка
     IF vbUserId = zfCalc_UserAdmin() :: Integer AND 1=1
     THEN
         RAISE EXCEPTION 'Ошибка.test = ok';
     END IF;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 12.11.14                                        * add lpComplete_Movement_Finance_CreateTemp
 09.09.14                                        *
*/

-- тест
-- SELECT * FROM lpUnComplete_Movement (inMovementId:= 3581, inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM gpComplete_Movement_PersonalService (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
