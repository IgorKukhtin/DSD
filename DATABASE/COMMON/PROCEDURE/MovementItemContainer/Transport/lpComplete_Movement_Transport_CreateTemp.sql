-- Function: lpComplete_Movement_Transport_CreateTemp ()

DROP FUNCTION IF EXISTS lpComplete_Movement_Transport_CreateTemp ();

CREATE OR REPLACE FUNCTION lpComplete_Movement_Transport_CreateTemp()
RETURNS VOID
AS
$BODY$
BEGIN
     -- таблица - Проводки
     PERFORM lpComplete_Movement_All_CreateTemp();

     -- таблица
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpItem_Transport'))
     THEN

     -- таблица - элементы продаж для распределения Затрат по накладным
     CREATE TEMP TABLE _tmpMI_Sale (MI_Id_sale Integer, PartnerId Integer, GoodsId Integer, GoodsKindId Integer, Amount TFloat, AmountWeight TFloat) ON COMMIT DROP;

     -- таблица свойств (остатки) документа/элементов
     CREATE TEMP TABLE _tmpPropertyRemains (Kind Integer, FuelId Integer, Amount TFloat) ON COMMIT DROP;
     -- таблица - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem_Transport (MovementItemId Integer, MovementItemId_parent Integer, UnitId_ProfitLoss Integer, BranchId_ProfitLoss Integer, RouteId_ProfitLoss Integer, UnitId_Route Integer, BranchId_Route Integer
                                         , ContainerId_Goods Integer, GoodsId Integer, AssetId Integer
                                         , OperCount TFloat
                                         , ProfitLossGroupId Integer, ProfitLossDirectionId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                                         , BusinessId_Car Integer, BusinessId_Route Integer
                                         , JuridicalId Integer, ContractId Integer, PaidKindId Integer
                                          ) ON COMMIT DROP;
     -- таблица - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem_TransportSumm_Transport (MovementItemId Integer, ContainerId_ProfitLoss Integer, ContainerId_50000 Integer
                                                       , ContainerId Integer, AccountId Integer, AccountId_50000 Integer
                                                       , ContainerId_jur Integer, AccountId_jur Integer
                                                       , OperSumm TFloat
                                                        ) ON COMMIT DROP;
     -- таблица - элементы по Сотруднику (ЗП) + затраты "командировочные" + "дальнобойные" + "такси", со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem_SummPersonal (MovementItemId Integer, OperSumm_Add TFloat, OperSumm_AddLong TFloat, OperSumm_Taxi TFloat
                                            , ContainerId Integer, AccountId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                                            , PersonalId Integer, BranchId Integer, UnitId Integer, PositionId Integer, ServiceDateId Integer, PersonalServiceListId Integer
                                            , BusinessId_ProfitLoss Integer, BranchId_ProfitLoss Integer, UnitId_ProfitLoss Integer
                                            , ContainerId_ProfitLoss Integer
                                            , ContainerId_50000 Integer, AccountId_50000 Integer
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
-- SELECT * FROM lpComplete_Movement_Transport_CreateTemp ()
