-- Function: gpSelect_Movement_Check_Booking_Tabletki()

DROP FUNCTION IF EXISTS gpSelect_Movement_Check_Booking_Tabletki (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Check_Booking_Tabletki(
    IN inUnitId        Integer   , -- Подразделение
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer,
               BookingId TVarChar, BookingStatus TVarChar, BookingStatusNew TVarChar,
               Bayer TVarChar, BayerPhone TVarChar, OrderId TVarChar,
               CancelReason TVarChar
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

          , CASE WHEN MovementString_BookingStatus.ValueData = '0.0'
                  AND Movement.StatusId <> zc_Enum_Status_Erased()  THEN '2.0'
                 WHEN MovementString_BookingStatus.ValueData <> '7.0'
                  AND Movement.StatusId = zc_Enum_Status_Erased()  THEN '7.0'
                 WHEN MovementString_BookingStatus.ValueData = '2.0'
                  AND COALESCE (MovementLinkObject_ConfirmedKind.ObjectId, 0) = zc_Enum_ConfirmedKind_Complete()    THEN '4.0'
                 WHEN MovementString_BookingStatus.ValueData = '4.0'
                  AND Movement.StatusId = zc_Enum_Status_Complete()    THEN '6.0'
                 END :: TVarChar AS BookingStatusNew

          , MovementString_Bayer.ValueData                     AS Bayer
          , MovementString_BayerPhone.ValueData                AS BayerPhone
          , MovementString_OrderId.ValueData                   AS OrderId
          , CASE WHEN Movement.StatusId = zc_Enum_Status_Erased()
                 THEN COALESCE(Object_CancelReason.ValueData, CancelReasonDefault.Name) END::TVarChar  AS CancelReason

     FROM MovementLinkObject

          INNER JOIN Movement ON Movement.ID = MovementLinkObject.MovementID

          INNER JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

          INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                        ON MovementLinkObject_Unit.MovementId = Movement.Id
                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                       AND (MovementLinkObject_Unit.ObjectId   = inUnitId OR inUnitId = 0)

          INNER JOIN MovementString AS MovementString_BookingId
                                    ON MovementString_BookingId.MovementId = Movement.Id
                                   AND MovementString_BookingId.DescId = zc_MovementString_BookingId()

          INNER JOIN MovementString AS MovementString_BookingStatus
                                    ON MovementString_BookingStatus.MovementId = Movement.Id
                                   AND MovementString_BookingStatus.DescId = zc_MovementString_BookingStatus()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                       ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                      AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()

          INNER JOIN MovementString AS MovementString_Bayer
                                    ON MovementString_Bayer.MovementId = Movement.Id
                                   AND MovementString_Bayer.DescId = zc_MovementString_Bayer()
          INNER JOIN MovementString AS MovementString_BayerPhone
                                    ON MovementString_BayerPhone.MovementId = Movement.Id
                                   AND MovementString_BayerPhone.DescId = zc_MovementString_BayerPhone()
          INNER JOIN MovementString AS MovementString_OrderId
                                    ON MovementString_OrderId.MovementId = Movement.Id
                                   AND MovementString_OrderId.DescId = zc_MovementString_OrderId()
                                   

          LEFT JOIN MovementLinkObject AS MovementLinkObject_CancelReason
                                       ON MovementLinkObject_CancelReason.MovementId = Movement.Id
                                      AND MovementLinkObject_CancelReason.DescId = zc_MovementLinkObject_CancelReason()
          LEFT JOIN Object AS Object_CancelReason ON Object_CancelReason.Id = MovementLinkObject_CancelReason.ObjectId
                                   
          LEFT JOIN (SELECT * FROM gpSelect_Object_CancelReason('3') AS CR ORDER BY CR.Code LIMIT 1) AS CancelReasonDefault ON 1 =1 

     WHERE MovementLinkObject.DescId = zc_MovementLinkObject_CheckSourceKind()
       AND MovementLinkObject.ObjectId = zc_Enum_CheckSourceKind_Tabletki()
       AND (MovementString_BookingStatus.ValueData = '0.0'
        OR MovementString_BookingStatus.ValueData = '2.0'
           AND COALESCE (MovementLinkObject_ConfirmedKind.ObjectId, 0) = zc_Enum_ConfirmedKind_Complete()
        OR MovementString_BookingStatus.ValueData = '4.0'
           AND Movement.StatusId = zc_Enum_Status_Complete()
        OR MovementString_BookingStatus.ValueData <> '7.0'
           AND Movement.StatusId = zc_Enum_Status_Erased()
           )

      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.  Шаблий О.В. +
 27.08.20                                                                                    *
*/

-- тест
-- select * from Movement_Check_View where id = 20000230
-- select lpInsertUpdate_MovementString (zc_MovementString_BookingStatus(), 20000230, '7.0');

SELECT * FROM gpSelect_Movement_Check_Booking_Tabletki (0  , '3');