-- Function: lpComplete_Movement_Sale_CreateTemp()

DROP FUNCTION IF EXISTS lpComplete_Movement_Sale_CreateTemp();

CREATE OR REPLACE FUNCTION lpComplete_Movement_Sale_CreateTemp()
RETURNS VOID
AS
$BODY$
BEGIN

     -- таблица - Проводки
     PERFORM lpComplete_Movement_All_CreateTemp();

     -- таблица - элементы по контрагенту, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem_SummClient (MovementItemId Integer, ContainerId Integer, AccountId Integer, ContainerId_VAT Integer, AccountId_VAT Integer
                                          , GoodsId Integer, PartionId Integer
                                          , OperSumm TFloat, OperSumm_VAT TFloat
                                           ) ON COMMIT DROP;
     -- таблица - элементы Child
     CREATE TEMP TABLE _tmpItem_Master_mi (MovementItemId Integer
                                         , GoodsId Integer
                                         , Amount TFloat, OperSumm TFloat, OperSumm_VAT TFloat
                                         , OperSumm_10101 TFloat, OperSumm_10201 TFloat, OperSumm_10202 TFloat, OperSumm_10704 TFloat
                                         , PartNumber TVarChar
                                         , InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                                          ) ON COMMIT DROP;
     -- таблица - партии
     CREATE TEMP TABLE _tmpItem_Master (MovementItemId Integer
                                      , GoodsId Integer, PartionId Integer
                                      , ContainerId_Summ Integer, ContainerId_Goods Integer
                                      , AccountId Integer
                                      , ProfitLossId_10101 Integer, ProfitLossId_10201 Integer, ProfitLossId_10202 Integer, ProfitLossId_10301 Integer, ProfitLossId_10704 Integer
                                      , ContainerId_10101 Integer, ContainerId_10201 Integer, ContainerId_10202 Integer, ContainerId_10301 Integer, ContainerId_10704 Integer
                                      , Amount TFloat, OperSumm_10301 TFloat
                                      , MovementId_order Integer
                                       ) ON COMMIT DROP;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.06.17                                        *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_Sale_CreateTemp ()
