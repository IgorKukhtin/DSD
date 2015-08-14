-- Function: lpComplete_Movement_Income_CreateTemp ()

DROP FUNCTION IF EXISTS lpComplete_Movement_Income_CreateTemp ();

CREATE OR REPLACE FUNCTION lpComplete_Movement_Income_CreateTemp()
RETURNS VOID
AS
$BODY$
BEGIN
     -- таблица - Проводки
     PERFORM lpComplete_Movement_All_CreateTemp();

     -- таблица - элементы по контрагенту, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem_SummPartner (MovementItemId Integer, ContainerId Integer, AccountId Integer, ContainerId_Transit Integer, AccountId_Transit Integer, InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, BusinessId Integer, UnitId_Asset Integer, GoodsId Integer, GoodsKindId Integer, OperSumm_Partner TFloat) ON COMMIT DROP;
     -- таблица - элементы по ПОКУПАТЕЛЮ, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem_SummPartner_To (MovementItemId Integer, ContainerId_Goods Integer, ContainerId Integer, AccountId Integer, ContainerId_ProfitLoss_70201 Integer, InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, BusinessId Integer, GoodsId Integer, OperCount_PartnerFrom TFloat, OperCount TFloat, OperSumm_Partner TFloat, OperSumm_70201 TFloat) ON COMMIT DROP;
     -- таблица - элементы по Сотруднику (заготовитель), со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem_SummPacker (ContainerId Integer, AccountId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, BusinessId Integer, OperSumm_Packer TFloat) ON COMMIT DROP;
     -- таблица - элементы по Сотруднику (Водитель), со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem_SummDriver (ContainerId Integer, AccountId Integer, ContainerId_Transit Integer, AccountId_Transit Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, BusinessId Integer, OperSumm_Driver TFloat) ON COMMIT DROP;
     -- таблица - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , ContainerId_Summ Integer, ContainerId_Goods Integer, ContainerId_CountSupplier Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime
                               , ContainerId_GoodsTicketFuel Integer, GoodsId_TicketFuel Integer
                               , OperCount TFloat, OperCount_Partner TFloat, OperCount_Packer TFloat, tmpOperSumm_Partner TFloat, OperSumm_Partner TFloat, tmpOperSumm_Packer TFloat, OperSumm_Packer TFloat, tmpOperSumm_PartnerTo TFloat, OperSumm_PartnerTo TFloat
                               , AccountId Integer, InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, InfoMoneyGroupId_Detail Integer, InfoMoneyDestinationId_Detail Integer, InfoMoneyId_Detail Integer
                               , BusinessId Integer, UnitId_Asset Integer
                               , isPartionCount Boolean, isPartionSumm Boolean, isCountSupplier Boolean
                               , PartionGoodsId Integer) ON COMMIT DROP;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.06.15                                        * add _tmpItem_SummPartner.GoodsId
 06.12.14                                        *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_Income_CreateTemp ()
