-- Function: gpRun_Movement_Check_Delay()

DROP FUNCTION IF EXISTS gpRun_Movement_Check_Delay (TVarChar);

CREATE OR REPLACE FUNCTION gpRun_Movement_Check_Delay(
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpGetUserBySession (inSession);

    IF 3 <> inSession::Integer AND 375661 <> inSession::Integer AND 4183126 <> inSession::Integer AND
      8001630 <> inSession::Integer AND 9560329 <> inSession::Integer
    THEN
      RAISE EXCEPTION 'Звпуск процедуры авто установки признака <Просрочка.> вам запрещено.';
    END IF;

    PERFORM gpUpdate_Movement_Check_Delay (Movement.Id, inSession) FROM
    (WITH
         tmpMovAll AS (SELECT Movement.Id
                      FROM Movement
                            INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                                       ON Movement.Id = MovementBoolean_Deferred.MovementId
                                                      AND MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                                                      AND MovementBoolean_Deferred.ValueData = TRUE
                      WHERE Movement.DescId = zc_Movement_Check()
                        AND zc_Enum_Status_UnComplete() = Movement.StatusId
                    )
       , tmpMov AS (SELECT Movement.Id
                           , MovementLinkObject_Unit.ObjectId AS UnitId
                      FROM tmpMovAll AS Movement

                        INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                     )

    SELECT Movement.Id
    FROM tmpMov

         LEFT JOIN Movement ON Movement.Id = tmpMov.Id

         LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckMember
                                      ON MovementLinkObject_CheckMember.MovementId = Movement.Id
                                     AND MovementLinkObject_CheckMember.DescId = zc_MovementLinkObject_CheckMember()
  	     LEFT JOIN Object AS Object_CashMember ON Object_CashMember.Id = MovementLinkObject_CheckMember.ObjectId


         LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                  ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                 AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
         LEFT JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                      ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                     AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
         LEFT JOIN Object AS Object_ConfirmedKind ON Object_ConfirmedKind.Id = MovementLinkObject_ConfirmedKind.ObjectId


         LEFT JOIN MovementDate AS MovementDate_UserConfirmedKind
                                ON MovementDate_UserConfirmedKind.MovementId = Movement.Id
                               AND MovementDate_UserConfirmedKind.DescId = zc_MovementDate_UserConfirmedKind()

         LEFT JOIN MovementDate AS MovementDate_Delay
                                ON MovementDate_Delay.MovementId = Movement.Id
                               AND MovementDate_Delay.DescId = zc_MovementDate_Delay()

         LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckSourceKind
                                      ON MovementLinkObject_CheckSourceKind.MovementId =  Movement.Id
                                     AND MovementLinkObject_CheckSourceKind.DescId = zc_MovementLinkObject_CheckSourceKind()

    WHERE CASE WHEN MovementDate_Delay.ValueData is not Null THEN MovementDate_Delay.ValueData
               WHEN MovementDate_UserConfirmedKind.ValueData is not Null THEN MovementDate_UserConfirmedKind.ValueData
               WHEN MovementLinkObject_CheckSourceKind.ObjectId = zc_Enum_CheckSourceKind_Tabletki() THEN Movement.OperDate
               ELSE Movement.OperDate + INTERVAL '3 DAY' END <= DATE_TRUNC ('DAY', CURRENT_DATE) - INTERVAL '2 DAY') AS Movement;
               
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Шаблий О.В.
 04.07.19                                                                    *
 18.04.19                                                                    *
 04.04.19                                                                    *
*/
-- тест
-- select * from gpRun_Movement_Check_Delay(inSession := '3');