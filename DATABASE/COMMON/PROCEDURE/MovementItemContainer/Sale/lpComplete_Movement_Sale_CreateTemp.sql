-- Function: lpComplete_Movement_Sale_CreateTemp ()

DROP FUNCTION IF EXISTS lpComplete_Movement_Sale_CreateTemp ();

CREATE OR REPLACE FUNCTION lpComplete_Movement_Sale_CreateTemp()
RETURNS VOID
AS
$BODY$
BEGIN
     -- таблица - Проводки
     PERFORM lpComplete_Movement_All_CreateTemp();

     -- таблица - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItemSumm (MovementItemId Integer, ContainerId_ProfitLoss_40208 Integer, ContainerId_ProfitLoss_10500 Integer, ContainerId_ProfitLoss_10400 Integer, ContainerId Integer, AccountId Integer, OperSumm TFloat, OperSumm_ChangePercent TFloat, OperSumm_Partner TFloat) ON COMMIT DROP;
     -- таблица - количественные элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , ContainerId_Goods Integer, ContainerId_GoodsPartner Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime
                               , OperCount TFloat, OperCount_ChangePercent TFloat, OperCount_Partner TFloat, tmpOperSumm_PriceList TFloat, OperSumm_PriceList TFloat, tmpOperSumm_Partner TFloat, tmpOperSumm_Partner_original TFloat, OperSumm_Partner TFloat, OperSumm_Partner_ChangePercent TFloat, OperSumm_Currency TFloat, OperSumm_80103 TFloat
                               , ContainerId_ProfitLoss_10100 Integer, ContainerId_ProfitLoss_10200 Integer, ContainerId_ProfitLoss_10300 Integer, ContainerId_ProfitLoss_80103 Integer
                               , ContainerId_Partner Integer, ContainerId_Currency Integer, AccountId_Partner Integer, ContainerId_Transit Integer, AccountId_Transit Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId_From Integer
                               , isPartionCount Boolean, isPartionSumm Boolean, isTareReturning Boolean, isLossMaterials Boolean
                               , PartionGoodsId Integer
                               , PriceListPrice TFloat, Price TFloat, Price_original TFloat, CountForPrice TFloat) ON COMMIT DROP;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.11.14                                        *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_Sale_CreateTemp ()
