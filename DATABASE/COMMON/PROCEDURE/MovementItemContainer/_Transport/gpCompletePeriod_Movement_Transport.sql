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
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Complete_Movement_Transport());
     vbUserId:=2; -- CAST (inSession AS Integer);



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


     -- таблица - Проводки 
     CREATE TEMP TABLE _tmpMIContainer_insert (Id Integer, DescId Integer, MovementId Integer, MovementItemId Integer, ContainerId Integer, ParentId Integer, Amount TFloat, OperDate TDateTime, IsActive Boolean) ON COMMIT DROP;
     -- таблица свойств (остатки) документа/элементов
     CREATE TEMP TABLE _tmpPropertyRemains (Kind Integer, FuelId Integer, Amount TFloat) ON COMMIT DROP;
     -- таблица - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem_Transport (MovementItemId Integer, MovementItemId_parent Integer, UnitId_ProfitLoss Integer
                                         , ContainerId_Goods Integer, GoodsId Integer, AssetId Integer
                                         , OperCount TFloat
                                         , ProfitLossGroupId Integer, ProfitLossDirectionId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                                         , BusinessId Integer, BusinessId_Route Integer
                                          ) ON COMMIT DROP;
     -- таблица - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem_TransportSumm_Transport (MovementItemId Integer, ContainerId_ProfitLoss Integer, ContainerId Integer, AccountId Integer, OperSumm TFloat) ON COMMIT DROP;


     -- !!!Проводим Документы!!!
     PERFORM lpComplete_Movement_Transport (inMovementId := _tmpMovement.MovementId
                                          , inUserId     := vbUserId)
     FROM _tmpMovement
     ORDER BY _tmpMovement.OperDate, _tmpMovement.MovementId;


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.10.13                                        *
*/

-- тест
-- SELECT * FROM gpCompletePeriod_Movement_Transport (inStartDate:= '01.10.2013', inEndDate:= '01.10.2013', inSession:= zfCalc_UserAdmin())
