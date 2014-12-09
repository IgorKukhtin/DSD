-- Function: gpCompletePeriod_Movement_IncomeFuel (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpCompletePeriod_Movement_IncomeFuel (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpCompletePeriod_Movement_IncomeFuel(
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
    IN inSession      TVarChar DEFAULT ''     -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_CompletePeriod_IncomeFuel());

     -- таблица - Документы которые надо сначала Распровести, потом Провести
     CREATE TEMP TABLE _tmpMovement (MovementId Integer, OperDate TDateTime) ON COMMIT DROP;

     -- формируется список !!!только!! из Проведенных Документов
     INSERT INTO _tmpMovement (MovementId, OperDate)
        SELECT Movement.Id, Movement.OperDate
        FROM Movement
             JOIN MovementLinkObject AS MovementLinkObject_To
                                     ON MovementLinkObject_To.MovementId = Movement.Id
                                    AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                    AND MovementLinkObject_To.ObjectId IN (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Car())
        WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
          AND Movement.DescId   = zc_Movement_Income()
          AND Movement.StatusId = zc_Enum_Status_Complete();


     -- !!!Распроводим Документы!!!
     PERFORM lpUnComplete_Movement (inMovementId := _tmpMovement.MovementId
                                  , inUserId     := vbUserId)
     FROM _tmpMovement;


     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Income_CreateTemp();

     -- !!!Проводим Документы!!!
     PERFORM lpComplete_Movement_Income (inMovementId := tmp.MovementId
                                       , inUserId     := vbUserId)
     FROM (SELECT _tmpMovement.MovementId FROM _tmpMovement ORDER BY _tmpMovement.OperDate, _tmpMovement.MovementId) AS tmp;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 01.10.14                                        * add InfoMoneyGroupId and InfoMoneyGroupId_Detail and UnitId_Asset
 17.08.14                                        * add MovementDescId
 01.11.13                                        * add ...Id_Transit
 31.10.13                                        * all
 30.10.13         *
*/

-- тест
-- SELECT * FROM gpCompletePeriod_Movement_IncomeFuel (inStartDate:= '01.10.2013', inEndDate:= '01.10.2013', inSession:= zfCalc_UserAdmin())
