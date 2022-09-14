-- Function: lpComplete_Movement_ReturnIn_CreateTemp ()

DROP FUNCTION IF EXISTS lpComplete_Movement_ReturnIn_CreateTemp ();

CREATE OR REPLACE FUNCTION lpComplete_Movement_ReturnIn_CreateTemp()
RETURNS VOID
AS
$BODY$
BEGIN
     -- таблица - Проводки
     PERFORM lpComplete_Movement_All_CreateTemp();

     -- таблица - альтернативные ContainerId
     CREATE TEMP TABLE _tmpList_Alternative (ContainerId_Goods Integer, ContainerId_Summ_Alternative Integer, ContainerId_Summ Integer) ON COMMIT DROP;
     -- таблица - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItemSumm (MovementItemId Integer, ContainerId_ProfitLoss_40208 Integer, ContainerId_ProfitLoss_10800 Integer, ContainerId Integer, AccountId Integer, ContainerId_Transit Integer, OperSumm TFloat, OperSumm_Partner TFloat) ON COMMIT DROP;
     -- таблица - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItemPartnerTo (MovementItemId Integer, ContainerId_Goods Integer, ContainerId_Partner Integer, AccountId_Partner Integer, ContainerId_ProfitLoss_10700 Integer, ContainerId_ProfitLoss_10800 Integer, OperSumm_Partner TFloat) ON COMMIT DROP;

     -- таблица - количественные элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , ContainerId_Goods Integer, ContainerId_Count Integer, ContainerId_Goods_Alternative Integer, ContainerId_SummIn_60000 Integer, ContainerId_SummOut_60000 Integer, AccountId_SummIn_60000 Integer, AccountId_SummOut_60000 Integer, ContainerId_GoodsPartner Integer, ContainerId_GoodsTransit Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime, ChangePercent TFloat, isChangePrice Boolean
                               , OperCount TFloat, OperCountCount TFloat, OperCount_Partner TFloat, tmpOperSumm_PriceList TFloat, OperSumm_PriceList TFloat, tmpOperSumm_PriceList_real TFloat, OperSumm_PriceList_real TFloat, tmpOperSumm_Partner TFloat, tmpOperSumm_Partner_original TFloat, OperSumm_Partner TFloat, OperSumm_Partner_ChangePercent TFloat, OperSumm_51201 TFloat
                               , tmpOperSumm_Partner_Currency TFloat, OperSumm_Currency TFloat
                               , ContainerId_ProfitLoss_10700 Integer
                               , ContainerId_Partner Integer, ContainerId_Currency Integer, AccountId_Partner Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId_To Integer
                               , isPartionCount Boolean, isPartionSumm Boolean, isTareReturning Boolean
                               , PartionGoodsId Integer, PartionMovementId Integer
                               , PriceListPrice TFloat, Price TFloat, Price_original TFloat, Price_Currency TFloat, CountForPrice TFloat
                               , isErased Boolean -- используется только в lpCheck_Movement_ReturnIn_Auto
                                ) ON COMMIT DROP;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.04.15                                        * add ..._60000
 07.02.15                                        * add _tmpItemPartnerTo
 06.12.14                                        *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_ReturnIn_CreateTemp ()
