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
     CREATE TEMP TABLE _tmpItem_SummPartner (MovementItemId Integer, ContainerId Integer, ContainerId_Currency Integer, ContainerId_re Integer, ContainerId_Currency_re Integer, AccountId Integer, ContainerId_Transit Integer, AccountId_Transit Integer, InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, BusinessId Integer, UnitId_Asset Integer, GoodsId Integer, GoodsKindId Integer, OperSumm_Partner TFloat, OperSumm_Partner_Currency TFloat) ON COMMIT DROP;
     -- таблица - элементы по ПОКУПАТЕЛЮ, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem_SummPartner_To (MovementItemId Integer, ContainerId_Goods Integer, ContainerId Integer, AccountId Integer, ContainerId_ProfitLoss_70201 Integer, InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, BusinessId Integer, GoodsId Integer, OperCount_PartnerFrom TFloat, OperCount TFloat, OperSumm_Partner TFloat, OperSumm_70201 TFloat) ON COMMIT DROP;
     -- таблица - элементы по Сотруднику (ЗП) + затраты "Заправка" + "Учредитель" + "Перевыставление", со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem_SummPersonal (MovementItemId Integer, ContainerId_Goods Integer, ContainerId Integer, AccountId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, PersonalId Integer, BranchId Integer, UnitId Integer, PositionId Integer, ServiceDateId Integer, PersonalServiceListId Integer, GoodsId Integer, OperCount TFloat, OperSumm_Partner TFloat
                                            , OperSumm_20401 TFloat, OperSumm_21425 TFloat
                                            , InfoMoneyDestinationId_20401 Integer, InfoMoneyId_20401 Integer, InfoMoneyDestinationId_21425 Integer, InfoMoneyId_21425 Integer
                                            , BusinessId_ProfitLoss Integer, BranchId_ProfitLoss Integer, UnitId_ProfitLoss Integer, ProfitLossGroupId Integer, ProfitLossDirectionId Integer
                                            , ContainerId_ProfitLoss_20401 Integer, ContainerId_ProfitLoss_21425 Integer
                                            , ContainerId_External Integer, AccountId_External Integer
                                            , FounderId Integer, ContractId Integer, JuridicalId Integer
                                             ) ON COMMIT DROP;
     -- таблица - элементы по Сотруднику (заготовитель), со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem_SummPacker (ContainerId Integer, AccountId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, BusinessId Integer, OperSumm_Packer TFloat) ON COMMIT DROP;
     -- таблица - элементы по Сотруднику (Водитель), со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem_SummDriver (ContainerId Integer, AccountId Integer, ContainerId_Transit Integer, AccountId_Transit Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, BusinessId Integer, OperSumm_Driver TFloat) ON COMMIT DROP;
     -- таблица - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , ContainerId_Summ Integer, ContainerId_Goods Integer, ContainerId_CountSupplier Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, UnitId_Asset Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime
                               , ContainerId_GoodsTicketFuel Integer, GoodsId_TicketFuel Integer
                               , ContainerId_Goods_Unit Integer, GoodsId_Unit Integer
                               , OperCount TFloat, OperCount_Partner TFloat, OperCount_Packer TFloat
                               , tmpOperSumm TFloat, OperSumm TFloat
                               , tmpOperSumm_Partner TFloat, OperSumm_Partner TFloat, tmpOperSumm_Partner_Currency TFloat, OperSumm_Partner_Currency TFloat, Price_Currency TFloat
                               , tmpOperSumm_Packer TFloat, OperSumm_Packer TFloat
                               , tmpOperSumm_PartnerTo TFloat, OperSumm_PartnerTo TFloat
                               , AccountId Integer, InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, InfoMoneyGroupId_Detail Integer, InfoMoneyDestinationId_Detail Integer, InfoMoneyId_Detail Integer
                               , BusinessId Integer
                               , ContainerId_ProfitLoss Integer
                               , isPartionCount Boolean, isPartionSumm Boolean, isTareReturning Boolean, isAsset Boolean
                               , PartionGoodsId Integer
                                ) ON COMMIT DROP;
     -- таблица - элементы 20202 
     CREATE TEMP TABLE _tmpItemPartion_20202 (MovementItemId Integer, PartionGoodsId Integer, ContainerId_Goods Integer, ContainerId_Summ Integer, PartionGoods TVarChar, OperCount TFloat, OperSumm TFloat) ON COMMIT DROP;
     -- таблица - суммовые элементы документа
     CREATE TEMP TABLE _tmpItemSumm_Unit (MovementItemId Integer, ContainerId_From Integer, AccountId_From Integer, OperSumm TFloat) ON COMMIT DROP;


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
