-- Function: lpComplete_Movement_SendOnPrice_CreateTemp ()

DROP FUNCTION IF EXISTS lpComplete_Movement_SendOnPrice_CreateTemp ();

CREATE OR REPLACE FUNCTION lpComplete_Movement_SendOnPrice_CreateTemp()
RETURNS VOID
AS
$BODY$
BEGIN
     -- таблица - Проводки
     PERFORM lpComplete_Movement_All_CreateTemp();

     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = '_tmpitem')
     THEN
         DELETE FROM _tmpItemSumm;
         DELETE FROM _tmpItem;
     ELSE
         -- таблица - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках
         CREATE TEMP TABLE _tmpItemSumm (MovementItemId Integer, isLossMaterials Boolean, isRestoreAccount_60000 Boolean, isAccount_60000 Boolean, MIContainerId_To BigInt
                                       , ContainerId_GoodsFrom Integer
                                       , ContainerId_Transit Integer
                                       , ContainerId_Transit_01 Integer, ContainerId_Transit_02 Integer
                                       , ContainerId_Transit_51 Integer, ContainerId_Transit_52 Integer, ContainerId_Transit_53 Integer
                                       , ContainerId_To Integer, AccountId_To Integer, ContainerId_ProfitLoss_10900 Integer, ContainerId_ProfitLoss_20200 Integer, ContainerId_ProfitLoss_40208 Integer, ContainerId_ProfitLoss_10500 Integer, ContainerId_60000 Integer, AccountId_60000 Integer, ContainerId_From Integer, AccountId_From Integer, InfoMoneyId_From Integer, InfoMoneyId_Detail_From Integer
                                       , OperSumm TFloat, OperSumm_ChangePercent TFloat, OperSumm_Partner TFloat, OperSumm_Account_60000 TFloat, OperSummVirt_Account_60000 TFloat
                                        ) ON COMMIT DROP;
         -- таблица - количественные элементы документа, со всеми свойствами для формирования Аналитик в проводках
         CREATE TEMP TABLE _tmpItem (MovementItemId Integer, isLossMaterials Boolean
                                   , MIContainerId_To BigInt, ContainerId_GoodsFrom Integer, ContainerId_GoodsTo Integer
                                   , ContainerId_GoodsTransit Integer
                                   , ContainerId_GoodsTransit_01 Integer, ContainerId_GoodsTransit_02 Integer, ContainerId_GoodsTransit_53 Integer
                                   , GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime
                                   , OperCount TFloat, OperCount_ChangePercent TFloat, OperCount_Partner TFloat
                                   , tmpOperSumm_PriceList TFloat, OperSumm_PriceList TFloat
                                   , tmpOperSumm_Partner TFloat, OperSumm_Partner TFloat, OperSumm_Partner_ChangePercent TFloat
                                   , tmpOperSumm_PartnerVirt TFloat, OperSumm_PartnerVirt_ChangePercent TFloat
                                   , InfoMoneyDestinationId Integer, InfoMoneyId Integer
                                   , BusinessId_From Integer, BusinessId_To Integer
                                   , isPartionCount Boolean, isPartionSumm Boolean
                                   , PartionGoodsId_From Integer, PartionGoodsId_To Integer
                                   , UnitId_To Integer, MemberId_To Integer, BranchId_To Integer, AccountDirectionId_To Integer, IsPartionDate_UnitTo Boolean, JuridicalId_Basis_To Integer
                                   , WhereObjectId_Analyzer_To Integer, isTo_10900 Boolean
                                   , OperCount_start TFloat, OperCount_ChangePercent_start TFloat, OperCount_Partner_start TFloat
                                   , tmpOperSumm_PriceList_start TFloat, tmpOperSumm_Partner_start TFloat, tmpOperSumm_PartnerVirt_start TFloat
                                    ) ON COMMIT DROP;
     END IF;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.12.14                                        *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_SendOnPrice_CreateTemp ()
