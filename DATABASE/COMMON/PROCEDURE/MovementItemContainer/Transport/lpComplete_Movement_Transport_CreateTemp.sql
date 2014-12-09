-- Function: lpComplete_Movement_Transport_CreateTemp ()

DROP FUNCTION IF EXISTS lpComplete_Movement_Transport_CreateTemp ();

CREATE OR REPLACE FUNCTION lpComplete_Movement_Transport_CreateTemp()
RETURNS VOID
AS
$BODY$
BEGIN
     -- таблица - Проводки
     PERFORM lpComplete_Movement_All_CreateTemp();

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

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.12.14                                        *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_Transport_CreateTemp ()
