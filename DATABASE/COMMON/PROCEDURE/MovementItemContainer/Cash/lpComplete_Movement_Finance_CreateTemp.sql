-- Function: lpComplete_Movement_Finance_CreateTemp ()

DROP FUNCTION IF EXISTS lpComplete_Movement_Finance_CreateTemp ();

CREATE OR REPLACE FUNCTION lpComplete_Movement_Finance_CreateTemp()
RETURNS VOID
AS
$BODY$
BEGIN
     -- таблица - Проводки
     PERFORM lpComplete_Movement_All_CreateTemp();

     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE '_tmpItem')
     THEN
         DELETE FROM _tmpItem;
     ELSE
     -- таблица - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem (MovementDescId Integer, OperDate TDateTime, ObjectId Integer, ObjectDescId Integer, OperSumm TFloat, OperSumm_Currency TFloat, OperSumm_Diff TFloat, OperSumm_Asset TFloat, OperSumm_Diff_Asset TFloat, Price TFloat
                               , MovementItemId Integer, ContainerId Integer, ContainerId_Currency Integer, ContainerId_Diff Integer, ProfitLossId_Diff Integer
                               , AccountGroupId Integer, AccountDirectionId Integer, AccountId Integer
                               , ProfitLossGroupId Integer, ProfitLossDirectionId Integer
                               , InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId_Balance Integer, BusinessId_ProfitLoss Integer, JuridicalId_Basis Integer
                               , UnitId Integer, PositionId Integer, PersonalServiceListId Integer, BranchId_Balance Integer, BranchId_ProfitLoss Integer, ServiceDateId Integer, ContractId Integer, PaidKindId Integer
                               , PartionMovementId Integer, PartionGoodsId Integer, AssetId Integer
                               , AnalyzerId Integer, ObjectIntId_Analyzer Integer, ObjectExtId_Analyzer Integer
                               , CurrencyId Integer
                               , CarId Integer, NDSKindId Integer, DivisionPartiesId Integer
                               , IsActive Boolean, IsMaster Boolean
                                ) ON COMMIT DROP;
     END IF;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.11.14                                        * add lpComplete_Movement_All_CreateTemp
 12.11.14                                        *
*/

-- тест
-- SELECT * FROM lpUnComplete_Movement (inMovementId:= 3581, inUserId:= zfCalc_UserAdmin() :: Integer)
