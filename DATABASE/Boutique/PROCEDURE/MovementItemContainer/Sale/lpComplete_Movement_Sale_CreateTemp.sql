-- Function: lpComplete_Movement_Sale_CreateTemp ()

DROP FUNCTION IF EXISTS lpComplete_Movement_Sale_CreateTemp ();

CREATE OR REPLACE FUNCTION lpComplete_Movement_Sale_CreateTemp()
RETURNS VOID
AS
$BODY$
BEGIN
     -- таблица - Проводки
     PERFORM lpComplete_Movement_All_CreateTemp();

     -- таблица - элементы по контрагенту, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem_SummClient (MovementItemId Integer, ContainerId_Summ Integer, ContainerId_Summ_20102 Integer, ContainerId_Goods Integer, AccountId Integer, AccountId_20102 Integer
                                          , InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                                          , GoodsId Integer, PartionId Integer, GoodsSizeId Integer, PartionId_MI Integer
                                          , OperCount TFloat, OperCount_sale TFloat, OperSumm TFloat, OperSumm_ToPay TFloat, TotalPay TFloat
                                           ) ON COMMIT DROP;

     -- таблица - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , ContainerId_Summ Integer, ContainerId_Goods Integer
                               , GoodsId Integer, PartionId Integer, GoodsSizeId Integer
                               , OperCount TFloat, OperPrice TFloat, CountForPrice TFloat, OperSumm TFloat, OperSumm_Currency TFloat
                               , OperSumm_ToPay TFloat, OperSummPriceList TFloat, TotalChangePercent TFloat, TotalPay TFloat
                               , Summ_10201 TFloat, Summ_10202 TFloat, Summ_10203 TFloat, Summ_10204 TFloat
                               , AccountId Integer, InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , CurrencyValue TFloat, ParValue TFloat
                                ) ON COMMIT DROP;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.08.17                                        *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_Sale_CreateTemp ()
