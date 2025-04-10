-- Function: lpComplete_Movement_Inventory_CreateTemp ()

DROP FUNCTION IF EXISTS lpComplete_Movement_Inventory_CreateTemp ();

CREATE OR REPLACE FUNCTION lpComplete_Movement_Inventory_CreateTemp()
RETURNS VOID
AS
$BODY$
BEGIN
     -- таблица - Проводки
     PERFORM lpComplete_Movement_All_CreateTemp();

     -- таблица - количественный остаток
     CREATE TEMP TABLE _tmpGoods_Complete_Inventory (GoodsId Integer, GoodsKindId Integer, GoodsKindId_real Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer) ON COMMIT DROP;

     -- таблица - количественный остаток
     CREATE TEMP TABLE _tmpRemainsCount (MovementItemId Integer, ContainerId_Goods Integer, ContainerId_count Integer, GoodsId Integer, GoodsKindId Integer, InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, OperCount TFloat, OperCount_add TFloat, OperCount_find TFloat, OperCountCount TFloat, OperCountCount_find TFloat, OperSumm_item TFloat) ON COMMIT DROP;
     -- таблица - суммовой остаток
     CREATE TEMP TABLE _tmpRemainsSumm (ContainerId_Goods Integer, ContainerId Integer, AccountId Integer, GoodsId Integer, GoodsKindId Integer, InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, OperSumm TFloat, OperSumm_add TFloat, InfoMoneyId Integer, InfoMoneyId_Detail Integer) ON COMMIT DROP;

     -- таблица - суммовые элементы документа, !!!без!!! свойств для формирования Аналитик в проводках (если ContainerId=0 тогда возьмем их из _tmpItem)
     CREATE TEMP TABLE _tmpItemSumm (MovementItemId Integer, ContainerId_ProfitLoss Integer, ContainerId Integer, AccountId Integer, OperSumm TFloat) ON COMMIT DROP;
     -- таблица - суммовые элементы документа, для переоценки
     CREATE TEMP TABLE _tmpItemSummRePrice (MovementItemId Integer, ContainerId_Active Integer, AccountId_Active Integer, ContainerId_Passive Integer, AccountId_Passive Integer, OperSumm TFloat) ON COMMIT DROP;

     -- таблица - количественные элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , ContainerId_Goods Integer, ContainerId_count Integer, GoodsId Integer, GoodsKindId Integer, GoodsKindId_complete Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime
                               , OperCount TFloat, OperCountCount TFloat, OperSumm TFloat
                               , InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId Integer
                               , UnitId_Item Integer, StorageId_Item Integer, UnitId_Partion Integer, Price_Partion TFloat
                               , PartionCellId Integer
                               , isPartionCount Boolean, isPartionSumm Boolean
                               , PartionGoodsId Integer) ON COMMIT DROP;

     -- таблица - 
     IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE '_tmpList_Goods_1942')
     THEN
         CREATE TEMP TABLE _tmpList_Goods_1942 ON COMMIT DROP
            AS SELECT lfSelect.GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (1942) AS lfSelect -- СО-ЭМУЛЬСИИ
        ;
     END IF;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.12.14                                        *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_Inventory_CreateTemp ()
