-- Function: lpComplete_Movement_Send_CreateTemp ()

DROP FUNCTION IF EXISTS lpComplete_Movement_Send_CreateTemp ();

CREATE OR REPLACE FUNCTION lpComplete_Movement_Send_CreateTemp()
RETURNS VOID
AS
$BODY$
BEGIN
     -- таблица - Проводки
     PERFORM lpComplete_Movement_All_CreateTemp();

     -- таблица - количественные элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer, MovementId Integer, OperDate TDateTime, UnitId_From Integer, MemberId_From Integer, BranchId_From Integer, UnitId_To Integer, MemberId_To Integer, BranchId_To Integer
                               , MIContainerId_To Integer, ContainerId_GoodsFrom Integer, ContainerId_GoodsTo Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate_From TDateTime, PartionGoodsDate_To TDateTime
                               , OperCount TFloat
                               , AccountDirectionId_From Integer, AccountDirectionId_To Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , JuridicalId_basis_To Integer, BusinessId_To Integer
                               , UnitId_Item Integer, StorageId_Item Integer, PartionGoodsId_Item Integer, UnitId_Partion Integer, Price_Partion TFloat
                               , isPartionCount Boolean, isPartionSumm Boolean, isPartionDate_From Boolean, isPartionDate_To Boolean
                               , PartionGoodsId_From Integer, PartionGoodsId_To Integer) ON COMMIT DROP;
     -- таблица - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItemSumm (MovementItemId Integer, MIContainerId_To Integer, ContainerId_To Integer, AccountId_To Integer, ContainerId_From Integer, AccountId_From Integer, InfoMoneyId_Detail_From Integer, OperSumm TFloat) ON COMMIT DROP;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.12.14                                        *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_Send_CreateTemp ()
