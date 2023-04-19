-- Function: lpComplete_Movement_ChangePercent_CreateTemp ()

DROP FUNCTION IF EXISTS lpComplete_Movement_ChangePercent_CreateTemp ();

CREATE OR REPLACE FUNCTION lpComplete_Movement_ChangePercent_CreateTemp()
RETURNS VOID
AS
$BODY$
BEGIN
     -- таблица - Проводки
     PERFORM lpComplete_Movement_All_CreateTemp();

     -- таблица - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , ContainerId_ProfitLoss_10300 Integer, AccountId_To Integer, ContainerId_To Integer
                               , GoodsId Integer, GoodsKindId Integer
                               , OperCount TFloat, Price_original TFloat, OperSumm_Partner_noDiscount TFloat, OperSumm_Partner_Discount TFloat, OperSumm_Partner TFloat
                               , BusinessId Integer, BranchId Integer, InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                                ) ON COMMIT DROP;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.12.14                                        *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_ChangePercent_CreateTemp ()
