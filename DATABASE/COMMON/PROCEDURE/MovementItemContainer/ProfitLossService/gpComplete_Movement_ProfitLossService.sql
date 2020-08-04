-- Function: gpComplete_Movement_ProfitLossService()

DROP FUNCTION IF EXISTS gpCompletePeriod_Movement_ProfitLossService (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_ProfitLossService (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_ProfitLossService(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
 RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Service());

     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();

/*
     -- !!!временно - округляем!!!
     UPDATE MovementItem SET Amount = CAST (MovementItem.Amount AS NUMERIC (16, 2))
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId = zc_MI_Master()
       AND MovementItem.Amount <> CAST (MovementItem.Amount AS NUMERIC (16, 2))
    ;
*/

     -- проводим Документ
     PERFORM lpComplete_Movement_Service (inMovementId := inMovementId
                                        , inUserId     := vbUserId);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 12.11.14                                        * add lpComplete_Movement_Finance_CreateTemp
 12.09.14                                        * add PositionId and ServiceDateId and BusinessId_... and BranchId_...
 17.08.14                                        * add MovementDescId
 05.04.14                                        * add !!!ДЛЯ ОПТИМИЗАЦИИ!!! : _tmp1___ and _tmp2___
 25.03.14                                        * таблица - !!!ДЛЯ ОПТИМИЗАЦИИ!!!
 06.03.14                                        * add lpComplete_Movement_Service
 17.02.14                                                       *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 122175 , inSession:= '2')
-- SELECT * FROM gpComplete_Movement_ProfitLossService (inMovementId:= 122175, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 122175 , inSession:= '2')
