-- Function: lpComplete_Movement_Send_CreateTemp ()

DROP FUNCTION IF EXISTS lpComplete_Movement_Send_CreateTemp ();

CREATE OR REPLACE FUNCTION lpComplete_Movement_Send_CreateTemp()
RETURNS VOID
AS
$BODY$
BEGIN
     -- таблица - Проводки
     PERFORM lpComplete_Movement_All_CreateTemp();

     -- таблица - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , ContainerId_SummFrom Integer, ContainerId_GoodsFrom Integer
                               , ContainerId_SummTo   Integer, ContainerId_GoodsTo   Integer
                               , GoodsId Integer, PartionId Integer, GoodsSizeId Integer
                               , OperCount TFloat, OperSumm TFloat, OperSumm_Currency TFloat
                               , AccountId_From Integer, AccountId_To Integer, InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                                ) ON COMMIT DROP;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.06.17                                        *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_Send_CreateTemp ()
