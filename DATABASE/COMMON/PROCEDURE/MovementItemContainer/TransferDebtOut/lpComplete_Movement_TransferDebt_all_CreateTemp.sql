-- Function: lpComplete_Movement_TransferDebt_all_CreateTemp ()

DROP FUNCTION IF EXISTS lpComplete_Movement_TransferDebt_all_CreateTemp ();

CREATE OR REPLACE FUNCTION lpComplete_Movement_TransferDebt_all_CreateTemp()
RETURNS VOID
AS
$BODY$
BEGIN
     -- таблица - Проводки
     PERFORM lpComplete_Movement_All_CreateTemp();

     -- таблица - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , AccountId_From Integer, AccountId_To Integer, ContainerId_From Integer, ContainerId_To Integer
                               , ContainerId_Summ Integer, GoodsId Integer, GoodsKindId Integer
                               , OperCount TFloat, OperCount_Partner TFloat, Price_original TFloat, tmpOperSumm_Partner TFloat, OperSumm_Partner TFloat
                               , AccountId_Summ Integer, InfoMoneyId_Summ Integer
                               , isErased Boolean -- используется только в lpCheck_Movement_ReturnIn_Auto
                                ) ON COMMIT DROP;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.12.14                                        *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_TransferDebt_all_CreateTemp ()
