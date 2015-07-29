-- Function: lpComplete_Movement_All_CreateTemp ()

DROP FUNCTION IF EXISTS lpComplete_Movement_All_CreateTemp ();

CREATE OR REPLACE FUNCTION lpComplete_Movement_All_CreateTemp ()
RETURNS VOID
AS
$BODY$
BEGIN
     -- таблица - Проводки
     CREATE TEMP TABLE _tmpMIContainer_insert (Id Integer, DescId Integer, MovementDescId Integer, MovementId Integer, MovementItemId Integer, ContainerId Integer, ParentId Integer
                                             , AccountId Integer, AnalyzerId Integer
                                             , ObjectId_Analyzer Integer, WhereObjectId_Analyzer Integer, ContainerId_Analyzer Integer
                                             , ObjectIntId_Analyzer Integer, ObjectExtId_Analyzer Integer
                                             , Amount TFloat, OperDate TDateTime, IsActive Boolean) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpMIReport_insert (Id Integer, MovementDescId Integer, MovementId Integer, MovementItemId Integer, ActiveContainerId Integer, PassiveContainerId Integer, ActiveAccountId Integer, PassiveAccountId Integer, ReportContainerId Integer, ChildReportContainerId Integer, Amount TFloat, OperDate TDateTime) ON COMMIT DROP;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.07.14                                        * add ObjectIntId_Analyzer and ObjectExtId_Analyzer
 30.11.14                                        *
*/

-- тест
-- SELECT * FROM lpUnComplete_Movement (inMovementId:= 3581, inUserId:= zfCalc_UserAdmin() :: Integer)
