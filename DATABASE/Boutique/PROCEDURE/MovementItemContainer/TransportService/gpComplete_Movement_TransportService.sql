-- Function: gpComplete_Movement_TransportService (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpComplete_Movement_TransportService (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_TransportService(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_TransportService());


     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();
     -- проводим Документ
     PERFORM lpComplete_Movement_TransportService (inMovementId := inMovementId
                                                 , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 12.11.14                                        * add lpComplete_Movement_Finance_CreateTemp
 12.09.14                                        * add PositionId and ServiceDateId and BusinessId_... and BranchId_...
 17.08.14                                        * add MovementDescId
 05.04.14                                        * add !!!ДЛЯ ОПТИМИЗАЦИИ!!! : _tmp1___ and _tmp2___
 25.03.14                                        * таблица - !!!ДЛЯ ОПТИМИЗАЦИИ!!!
 25.01.14                                        *
 27.12.13          * 
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 601, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpComplete_Movement_TransportService (inMovementId:= 601, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 601, inSession:= zfCalc_UserAdmin())
