-- Function: lpComplete_Movement_ProductionUnion_CreateTemp ()

DROP FUNCTION IF EXISTS lpComplete_Movement_ProductionUnion_CreateTemp();

CREATE OR REPLACE FUNCTION lpComplete_Movement_ProductionUnion_CreateTemp()
RETURNS VOID
AS
$BODY$
BEGIN
     -- таблица - Проводки
     PERFORM lpComplete_Movement_All_CreateTemp();

     -- таблица - количественные Master(приход)-элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem_pr (MovementItemId Integer
                                  , MIContainerId_To BigInt, MIContainerId_count BigInt, ContainerId_GoodsTo Integer, ContainerId_count Integer, GoodsId Integer, GoodsKindId Integer, GoodsKindId_complete Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime
                                  , OperCount TFloat, OperCountCount TFloat
                                  , InfoMoneyDestinationId Integer, InfoMoneyId Integer
                                  , BusinessId_To Integer
                                  , UnitId_Item Integer, StorageId_Item Integer
                                  , isPartionCount Boolean, isPartionSumm Boolean
                                  , PartionGoodsId Integer, PartionGoodsId_child Integer, PartNumber TVarChar, PartionModelName TVarChar
                                  , isAsset Boolean, ObjectDescId Integer
                                   ) ON COMMIT DROP;
     -- таблица - суммовые Master(приход)-элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItemSumm_pr (MovementItemId Integer, AccountGroupId_From Integer, AccountDirectionId_From Integer, AccountId_From Integer, ContainerId_From Integer, MIContainerId_To BigInt, ContainerId_To Integer, AccountId_To Integer, InfoMoneyDestinationId_asset Integer, InfoMoneyId_asset Integer, InfoMoneyId_Detail_To Integer, OperSumm TFloat) ON COMMIT DROP;

     -- таблица - количественные Child(расход)-элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItemChild (MovementItemId_Parent Integer, MovementItemId Integer
                                    , ContainerId_GoodsFrom Integer, ContainerId_count Integer, GoodsId Integer, GoodsKindId Integer, GoodsKindId_complete Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime
                                    , OperCount TFloat, OperCountCount TFloat
                                    , InfoMoneyDestinationId Integer, InfoMoneyId Integer
                                    , BusinessId_From Integer
                                    , UnitId_Item Integer, PartionGoodsId_container Integer
                                    , isPartionCount Boolean, isPartionSumm Boolean
                                    , PartionGoodsId Integer
                                    , isAsset_master Boolean
                                    , ObjectDescId Integer
                                    , OperCount_start TFloat
                                     ) ON COMMIT DROP;
     -- таблица - суммовые Child(расход)-элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItemSummChild (MovementItemId_Parent Integer, MovementItemId Integer, ContainerId_GoodsFrom Integer, ContainerId_From Integer, AccountId_From Integer, InfoMoneyId_Detail_From Integer, OperSumm TFloat) ON COMMIT DROP;


     -- таблица - 
     CREATE TEMP TABLE _tmpItem_Partion (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, ReceiptId Integer, PartionGoodsDate TDateTime, OperCount TFloat, Count_onCount TFloat) ON COMMIT DROP;
     -- таблица - 
     CREATE TEMP TABLE _tmpItem_Partion_child (MovementItemId_Parent Integer, MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, PartionGoodsDate TDateTime, OperCount TFloat) ON COMMIT DROP;
     
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
-- SELECT * FROM lpComplete_Movement_ProductionUnion_CreateTemp ()
