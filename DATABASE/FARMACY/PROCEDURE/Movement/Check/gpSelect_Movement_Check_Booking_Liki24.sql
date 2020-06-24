-- Function: gpSelect_Movement_Check_Booking_Liki24()

DROP FUNCTION IF EXISTS gpSelect_Movement_Check_Booking_Liki24 (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Check_Booking_Liki24(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer,
               BookingId TVarChar, BookingStatus TVarChar, BookingStatusNew TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);


     RETURN QUERY
     SELECT Movement.Id
          , Movement.InvNumber
          , Movement.OperDate
          , Object_Status.ObjectCode                           AS StatusCode

          , MovementString_BookingId.ValueData                 AS BookingId
          , MovementString_BookingStatus.ValueData             AS BookingStatus

          , CASE WHEN MovementString_BookingStatus.ValueData = 'Processing'
                  AND Movement.StatusId <> zc_Enum_Status_Erased()  THEN 'PreAproved'
                 WHEN MovementString_BookingStatus.ValueData = 'Processing'
                  AND Movement.StatusId = zc_Enum_Status_Erased()  THEN 'Cancelled'
                 END :: TVarChar AS BookingStatusNew

     FROM MovementLinkObject

          INNER JOIN Movement ON Movement.ID = MovementLinkObject.MovementID

          INNER JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId


          INNER JOIN MovementString AS MovementString_BookingId
                                    ON MovementString_BookingId.MovementId = Movement.Id
                                   AND MovementString_BookingId.DescId = zc_MovementString_BookingId()

          INNER JOIN MovementString AS MovementString_BookingStatus
                                    ON MovementString_BookingStatus.MovementId = Movement.Id
                                   AND MovementString_BookingStatus.DescId = zc_MovementString_BookingStatus()

     WHERE MovementLinkObject.DescId = zc_MovementLinkObject_CheckSourceKind()
       AND MovementLinkObject.ObjectId = zc_Enum_CheckSourceKind_Liki24()
       AND (MovementString_BookingStatus.ValueData = 'Processing'
           )

      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.  Шаблий О.В. +
 23.05.19                                                                                    *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Check_Booking_Liki24 (inSession:= '3')
