-- Function: lpComplete_Movement_PersonalSendCash_CreateTemp ()

DROP FUNCTION IF EXISTS lpComplete_Movement_PersonalSendCash_CreateTemp ();

CREATE OR REPLACE FUNCTION lpComplete_Movement_PersonalSendCash_CreateTemp()
RETURNS VOID
AS
$BODY$
BEGIN
     -- таблица - Проводки
     PERFORM lpComplete_Movement_All_CreateTemp();

     -- таблица - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer, OperDate TDateTime, UnitId_ProfitLoss Integer, BranchId_ProfitLoss Integer, UnitId_Route Integer, BranchId_Route Integer
                               , ContainerId_From Integer, AccountId_From Integer, ContainerId_To Integer, AccountId_To Integer, ContainerId_ProfitLoss Integer, AccountId_ProfitLoss Integer, MemberId_To Integer, CarId_To Integer
                               , OperSumm TFloat
                               , ProfitLossGroupId Integer, ProfitLossDirectionId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId_PersonalTo Integer, BusinessId_Route Integer
                                ) ON COMMIT DROP;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.12.14                                        *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_PersonalSendCash_CreateTemp ()
