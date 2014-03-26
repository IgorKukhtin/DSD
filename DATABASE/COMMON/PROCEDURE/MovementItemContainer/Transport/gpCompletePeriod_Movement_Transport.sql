-- Function: gpCompletePeriod_Movement_Transport (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpCompletePeriod_Movement_Transport (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpCompletePeriod_Movement_Transport(
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
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_CompletePeriod_Transport());


     -- таблица - Документы которые надо сначала Распровести, потом Провести
     CREATE TEMP TABLE _tmpMovement (MovementId Integer, OperDate TDateTime) ON COMMIT DROP;

     -- формируется список !!!только!! из Проведенных Документов
     INSERT INTO _tmpMovement (MovementId, OperDate)
        SELECT Movement.Id, Movement.OperDate
        FROM Movement
        WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
          AND Movement.DescId   = zc_Movement_Transport()
          AND Movement.StatusId = zc_Enum_Status_Complete();


     -- !!!Распроводим Документы!!!
     PERFORM lpUnComplete_Movement (inMovementId := _tmpMovement.MovementId
                                  , inUserId     := vbUserId)
     FROM _tmpMovement;


     -- таблица - !!!ДЛЯ ОПТИМИЗАЦИИ!!!
     CREATE TEMP TABLE _tmp___ (Id Integer) ON COMMIT DROP;
     -- таблица - Проводки 
     CREATE TEMP TABLE _tmpMIContainer_insert (Id Integer, DescId Integer, MovementId Integer, MovementItemId Integer, ContainerId Integer, ParentId Integer, Amount TFloat, OperDate TDateTime, IsActive Boolean) ON COMMIT DROP;
     -- таблица свойств (остатки) документа/элементов
     CREATE TEMP TABLE _tmpPropertyRemains (Kind Integer, FuelId Integer, Amount TFloat) ON COMMIT DROP;
     -- таблица - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem_Transport (MovementItemId Integer, MovementItemId_parent Integer, UnitId_ProfitLoss Integer, BranchId_ProfitLoss Integer, RouteId_ProfitLoss Integer, UnitId_Route Integer, BranchId_Route Integer
                                         , ContainerId_Goods Integer, GoodsId Integer, AssetId Integer
                                         , OperCount TFloat
                                         , ProfitLossGroupId Integer, ProfitLossDirectionId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                                         , BusinessId_Car Integer, BusinessId_Route Integer
                                          ) ON COMMIT DROP;
     -- таблица - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem_TransportSumm_Transport (MovementItemId Integer, ContainerId_ProfitLoss Integer, ContainerId Integer, AccountId Integer, OperSumm TFloat) ON COMMIT DROP;


     -- !!!Проводим Документы!!!
     PERFORM lpComplete_Movement_Transport (inMovementId := tmp.MovementId
                                          , inUserId     := vbUserId)
     FROM (SELECT _tmpMovement.MovementId FROM _tmpMovement ORDER BY _tmpMovement.OperDate, _tmpMovement.MovementId) AS tmp;


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.03.14                                        * таблица - !!!ДЛЯ ОПТИМИЗАЦИИ!!!
 03.11.13                                        * add RouteId_ProfitLoss
 02.11.13                                        * add BranchId_ProfitLoss, UnitId_Route, BranchId_Route
 26.10.13                                        *
*/

-- тест
-- SELECT * FROM gpCompletePeriod_Movement_Transport (inStartDate:= '01.10.2013', inEndDate:= '01.10.2013', inSession:= zfCalc_UserAdmin())
