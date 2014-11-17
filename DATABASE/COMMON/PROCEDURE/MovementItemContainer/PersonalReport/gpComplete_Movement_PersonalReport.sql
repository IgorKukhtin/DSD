-- Function: gpComplete_Movement_PersonalReport()

DROP FUNCTION IF EXISTS gpCompletePeriod_Movement_PersonalReport (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_PersonalReport (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_PersonalReport(
    IN inMovementId        Integer              , -- ключ Документа
    IN inSession           TVarChar               -- сессия пользователя
)
RETURNS void
--  RETURNS TABLE (OperDate TDateTime, ObjectId Integer, ObjectDescId Integer, OperSumm TFloat, ContainerId Integer, AccountGroupId Integer, AccountDirectionId Integer, AccountId Integer, ProfitLossGroupId Integer, ProfitLossDirectionId Integer, InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, BusinessId Integer, JuridicalId_Basis Integer, UnitId Integer, ContractId Integer, PaidKindId Integer, IsActive Boolean)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_PersonalReport());

     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- проводим Документ
     PERFORM lpComplete_Movement_PersonalReport (inMovementId := inMovementId
                                               , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 12.11.14                                        * add lpComplete_Movement_Finance_CreateTemp
 15.09.14                                                        *
*/

-- тест
-- SELECT * FROM lpUnComplete_Movement (inMovementId:= 3581, inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM gpComplete_Movement_PersonalReport (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
