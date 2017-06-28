-- Function: lpComplete_Movement_ReturnOut_CreateTemp ()

DROP FUNCTION IF EXISTS lpComplete_Movement_ReturnOut_CreateTemp ();

CREATE OR REPLACE FUNCTION lpComplete_Movement_ReturnOut_CreateTemp()
RETURNS VOID
AS
$BODY$
BEGIN
     -- таблица - Проводки
     PERFORM lpComplete_Movement_All_CreateTemp();

     -- таблица - элементы по контрагенту, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem_SummPartner (MovementItemId Integer, ContainerId Integer, ContainerId_Currency Integer, AccountId Integer
                                           , InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                                           , GoodsId Integer, PartionId Integer
                                           , OperSumm TFloat, OperSumm_Currency TFloat
                                            ) ON COMMIT DROP;

     -- таблица - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , ContainerId_Summ Integer, ContainerId_Goods Integer
                               , GoodsId Integer, PartionId Integer, GoodsSizeId Integer
                               , OperCount TFloat, OperSumm TFloat, OperSumm_Currency TFloat
                               , AccountId Integer, InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                                ) ON COMMIT DROP;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.06.17                                        *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_ReturnOut_CreateTemp ()
