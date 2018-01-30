-- Function: lpComplete_Movement_Loss_CreateTemp ()

DROP FUNCTION IF EXISTS lpComplete_Movement_Loss_CreateTemp ();

CREATE OR REPLACE FUNCTION lpComplete_Movement_Loss_CreateTemp()
RETURNS VOID
AS
$BODY$
BEGIN
     -- таблица - Проводки
     PERFORM lpComplete_Movement_All_CreateTemp();


     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpItem'))
     THEN
         DELETE FROM _tmpItem;
     ELSE
         -- таблица - элементы документа, со всеми свойствами для формирования Аналитик в проводках
         CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                                   , ContainerId_Summ Integer, ContainerId_Goods Integer
                                   , GoodsId Integer, PartionId Integer, GoodsSizeId Integer
                                   , OperCount TFloat, OperSumm TFloat, OperSumm_Currency TFloat
                                   , AccountId Integer, InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                                   , ProfitLossId_30200 Integer, ContainerId_ProfitLoss_30200 Integer
                                    ) ON COMMIT DROP;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.06.17                                        *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_Loss_CreateTemp ()
