-- Function: gpUpdateMovement_OrderFinance_Status_Complete()

DROP FUNCTION IF EXISTS gpUpdateMovement_OrderFinance_Status_Complete (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_OrderFinance_Status_Complete(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inStartWeekNumber   Integer   , --
    IN inEndWeekNumber     Integer   , -- временно, только 1 неделя
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId  Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     --
     CREATE TEMP TABLE _tmpMovement ON COMMIT DROP
        AS (SELECT Movement.Id AS MovementId
            FROM Movement
                 INNER JOIN MovementFloat AS MovementFloat_WeekNumber
                                          ON MovementFloat_WeekNumber.MovementId = Movement.Id
                                         AND MovementFloat_WeekNumber.DescId = zc_MovementFloat_WeekNumber()
                                         AND MovementFloat_WeekNumber.ValueData BETWEEN inStartWeekNumber AND inEndWeekNumber
                INNER JOIN MovementLinkObject AS MovementLinkObject_OrderFinance
                                              ON MovementLinkObject_OrderFinance.MovementId = Movement.Id
                                             AND MovementLinkObject_OrderFinance.DescId     = zc_MovementLinkObject_OrderFinance()
                                           --AND MovementLinkObject_OrderFinance.ObjectId   = 3988049
                -- если Разрешено изменение плана по дням - в проведенном док. = ДА
                LEFT JOIN ObjectBoolean AS ObjectBoolean_Status_off
                                         ON ObjectBoolean_Status_off.ObjectId  = MovementLinkObject_OrderFinance.ObjectId
                                        AND ObjectBoolean_Status_off.DescId    = zc_ObjectBoolean_OrderFinance_Status_off()
                                        AND ObjectBoolean_Status_off.ValueData = TRUE

            WHERE Movement.DescId = zc_Movement_OrderFinance()
              AND Movement.StatusId = zc_Enum_Status_UnComplete()
              AND Movement.OperDate BETWEEN inStartDate - INTERVAL '14 DAY' AND inEndDate
              -- кроме таких
              AND ObjectBoolean_Status_off.ObjectId IS NULL
           );


     --
     UPDATE Movement SET StatusId = zc_Enum_Status_Complete(), StatusId_next = zc_Enum_Status_Complete()
     WHERE Movement.Id IN (SELECT _tmpMovement.MovementId FROM _tmpMovement);


     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (_tmpMovement.MovementId, vbUserId, FALSE)
     FROM _tmpMovement;

     --
     if vbUserId IN (9457) then RAISE EXCEPTION 'Админ.Test Ok. <%>  <%>', inStartWeekNumber, inEndWeekNumber; end if;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.12.25                                        *
*/


-- тест
-- select * from gpUpdateMovement_OrderFinance_Status_Complete (inMovementId := 32907603 , inMovementItemId := 341774314 , inDateDay := ('27.10.2025')::TDateTime , ioDateDay_old := ('27.10.2025')::TDateTime , inAmount := 15000 , ioAmountPlan_day := 23 , inIsAmountPlan_day := 'True' ,  inSession := '9457');
