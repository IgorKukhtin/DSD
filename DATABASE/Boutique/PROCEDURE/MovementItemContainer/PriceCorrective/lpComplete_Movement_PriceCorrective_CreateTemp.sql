-- Function: lpComplete_Movement_PriceCorrective_CreateTemp ()

DROP FUNCTION IF EXISTS lpComplete_Movement_PriceCorrective_CreateTemp ();

CREATE OR REPLACE FUNCTION lpComplete_Movement_PriceCorrective_CreateTemp()
RETURNS VOID
AS
$BODY$
BEGIN
     -- таблица - Проводки
     PERFORM lpComplete_Movement_All_CreateTemp();

     -- таблица - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItemSumm (MovementItemId Integer, ContainerId_ProfitLoss_40208 Integer, ContainerId_ProfitLoss_10800 Integer, ContainerId Integer, AccountId Integer, OperSumm TFloat, OperSumm_Partner TFloat) ON COMMIT DROP;

     -- таблица - количественные элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , ContainerId_Summ Integer, GoodsId Integer, GoodsKindId Integer
                               , OperCount TFloat, tmpOperSumm_Partner TFloat, OperSumm_Partner TFloat
                               , ContainerId_ProfitLoss_10300 Integer
                               , ContainerId_Partner Integer, AccountId_Partner Integer
                               , BusinessId_To Integer
                               , AccountId_Summ Integer, InfoMoneyDestinationId_Summ Integer, InfoMoneyId_Summ Integer) ON COMMIT DROP;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.12.14                                        *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_PriceCorrective_CreateTemp ()
