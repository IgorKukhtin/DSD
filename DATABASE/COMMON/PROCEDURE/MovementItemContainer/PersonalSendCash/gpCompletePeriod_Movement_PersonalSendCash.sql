-- Function: gpCompletePeriod_Movement_PersonalSendCash (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpCompletePeriod_Movement_PersonalSendCash (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpCompletePeriod_Movement_PersonalSendCash(
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
    IN inSession      TVarChar DEFAULT ''     -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_CompletePeriod_PersonalSendCash());

     -- таблица - Документы которые надо сначала Распровести, потом Провести
     CREATE TEMP TABLE _tmpMovement (MovementId Integer, OperDate TDateTime) ON COMMIT DROP;

     -- формируется список !!!только!! из Проведенных Документов
     INSERT INTO _tmpMovement (MovementId, OperDate)
        SELECT Movement.Id, Movement.OperDate
        FROM Movement
        WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
          AND Movement.DescId   = zc_Movement_PersonalSendCash()
          AND Movement.StatusId = zc_Enum_Status_Complete();


     -- !!!Распроводим Документы!!!
     PERFORM lpUnComplete_Movement (inMovementId := _tmpMovement.MovementId
                                  , inUserId     := vbUserId)
     FROM _tmpMovement;


     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_PersonalSendCash_CreateTemp();
     -- !!!Проводим Документы!!!
     PERFORM lpComplete_Movement_PersonalSendCash (inMovementId := tmp.MovementId
                                                 , inUserId     := vbUserId)
     FROM (SELECT _tmpMovement.MovementId FROM _tmpMovement ORDER BY _tmpMovement.OperDate, _tmpMovement.MovementId) AS tmp;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.08.14                                        * add MovementDescId
 05.04.14                                        * add !!!ДЛЯ ОПТИМИЗАЦИИ!!! : _tmp1___ and _tmp2___
 25.03.14                                        * таблица - !!!ДЛЯ ОПТИМИЗАЦИИ!!!
 21.12.13                                        * Personal -> Member
 04.11.13                                        * add OperDate
 02.11.13                                        * add ContainerId_ProfitLoss, AccountId_ProfitLoss
 02.11.13                                        * add BranchId_ProfitLoss, UnitId_Route, BranchId_Route
 29.10.13                                        *
*/

-- тест
-- SELECT * FROM gpCompletePeriod_Movement_PersonalSendCash (inStartDate:= '01.10.2013', inEndDate:= '01.10.2013', inSession:= zfCalc_UserAdmin())
