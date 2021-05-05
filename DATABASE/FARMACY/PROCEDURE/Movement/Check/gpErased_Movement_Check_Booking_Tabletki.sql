-- Function: gpErased_Movement_Check_Booking_Tabletki()

DROP FUNCTION IF EXISTS gpErased_Movement_Check_Booking_Tabletki (TVarChar);

CREATE OR REPLACE FUNCTION gpErased_Movement_Check_Booking_Tabletki(
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderInternal());
    vbUserId := inSession;
    PERFORM gpSetErased_Movement_Check (T1.Id, inSession)
    FROM (
       WITH
            tmpMovementCheck AS (SELECT Movement.Id
                                 FROM Movement
                                 WHERE Movement.DescId = zc_Movement_Check()
                                   AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                   AND Movement.OperDate >= CURRENT_DATE - INTERVAL '1 month')
          , tmpMovReserveId AS (
                             SELECT Movement.Id
                                  , COALESCE(MovementBoolean_Deferred.ValueData, FALSE) AS  isDeferred
                                  ,  MovementString_CommentError.ValueData              AS  CommentError
                             FROM tmpMovementCheck AS Movement
                                  LEFT JOIN MovementBoolean AS MovementBoolean_Deferred ON Movement.Id     = MovementBoolean_Deferred.MovementId
                                                            AND MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                                  LEFT JOIN MovementString AS MovementString_CommentError ON Movement.Id     = MovementString_CommentError.MovementId
                                                          AND MovementString_CommentError.DescId = zc_MovementString_CommentError()
                                                          AND MovementString_CommentError.ValueData <> '')

          , tmpMovementLinkObject AS (SELECT * FROM MovementLinkObject
                                      WHERE MovementLinkObject.MovementId in (select tmpMovReserveId.ID from tmpMovReserveId))

          , tmpMov AS (
                             SELECT Movement.Id
                                  , Movement.isDeferred
                                  , MovementLinkObject_Unit.ObjectId            AS UnitId
                                  , MovementLinkObject_ConfirmedKind.ObjectId   AS ConfirmedKindId
                                  , Movement.CommentError
                             FROM tmpMovReserveId AS Movement
                                  INNER JOIN tmpMovementLinkObject AS MovementLinkObject_Unit
                                                                   ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                  AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                  LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_ConfirmedKind
                                                                  ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                                                 AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
                             WHERE isDeferred = TRUE OR COALESCE(CommentError, '') <> '')
          , tmpMI_all AS (SELECT MovementItem.MovementId AS MovementId, MovementItem.ObjectId AS GoodsId, MovementItem.Amount AS Amount
                          FROM MovementItem
                          WHERE MovementItem.MovementId IN (SELECT tmpMov.Id FROM tmpMov)
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.isErased   = FALSE
                         )
          , tmpMI AS (SELECT tmpMI_all.MovementId, tmpMov.UnitId, tmpMI_all.GoodsId, SUM (tmpMI_all.Amount) AS Amount
                      FROM tmpMI_all
                           INNER JOIN tmpMov ON tmpMov.Id = tmpMI_all.MovementId
                      GROUP BY tmpMI_all.MovementId, tmpMov.UnitId, tmpMI_all.GoodsId
                     )
          , tmpMIConfirmedKind AS (SELECT tmpMI.UnitId, tmpMI.GoodsId, SUM (tmpMI.Amount) AS Amount
                                   FROM tmpMI
                                        INNER JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                                                      ON MovementLinkObject_ConfirmedKind.MovementId = tmpMI.MovementId
                                                                     AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
                                                                     AND MovementLinkObject_ConfirmedKind.ObjectId = zc_Enum_ConfirmedKind_Complete() 
                                   GROUP BY tmpMI.UnitId, tmpMI.GoodsId
                                  )
          , tmpRemains AS (SELECT tmpMI.MovementId
                                , tmpMI.GoodsId
                                , tmpMI.UnitId
                                , tmpMI.Amount           AS Amount_mi
                                , COALESCE (SUM (Container.Amount), 0) - COALESCE (Max (tmpMIConfirmedKind.Amount), 0) AS Amount_remains
                           FROM tmpMI
                                LEFT JOIN tmpMIConfirmedKind ON tmpMIConfirmedKind.GoodsId = tmpMI.GoodsId
                                                            AND tmpMIConfirmedKind.UnitId = tmpMI.UnitId
                                LEFT JOIN Container ON Container.DescId = zc_Container_Count()
                                                   AND Container.ObjectId = tmpMI.GoodsId
                                                   AND Container.WhereObjectId = tmpMI.UnitId
                                                   AND Container.Amount <> 0
                           GROUP BY tmpMI.MovementId
                                  , tmpMI.GoodsId
                                  , tmpMI.UnitId
                                  , tmpMI.Amount
                           HAVING (COALESCE (SUM (Container.Amount), 0) - COALESCE (MAX (tmpMIConfirmedKind.Amount), 0)) < tmpMI.Amount
                          )
          , tmpErr AS (SELECT DISTINCT tmpMov.Id AS MovementId
                       FROM tmpMov
                            INNER JOIN tmpMI_all ON tmpMI_all.MovementId = tmpMov.Id
                            INNER JOIN tmpRemains ON tmpRemains.MovementId = tmpMI_all.MovementId
                                                 AND tmpRemains.GoodsId = tmpMI_all.GoodsId
                                                 --AND tmpRemains.UnitId  = tmpMI_all.UnitId
                      )
        
                
       SELECT Movement.Id
            , Movement.InvNumber
            , Movement.OperDate
            , MovementLinkObject_Unit.ObjectId                   AS UnitId
            , Object_Unit.ObjectCode                             AS UnitCode
            , Object_Unit.ValueData                              AS UnitName

            , MovementString_BookingId.ValueData                 AS BookingId
            , MovementString_BookingStatus.ValueData             AS BookingStatus
            
       FROM MovementLinkObject

            INNER JOIN Movement ON Movement.ID = MovementLinkObject.MovementID
                               AND Movement.StatusId = zc_Enum_Status_UnComplete()

            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                          ON MovementLinkObject_Unit.MovementId = Movement.Id
                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            INNER JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId 

            INNER JOIN MovementString AS MovementString_BookingId
                                      ON MovementString_BookingId.MovementId = Movement.Id
                                     AND MovementString_BookingId.DescId = zc_MovementString_BookingId()

            INNER JOIN MovementString AS MovementString_BookingStatus
                                      ON MovementString_BookingStatus.MovementId = Movement.Id
                                     AND MovementString_BookingStatus.DescId = zc_MovementString_BookingStatus()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                         ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                        AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
                                                               
            LEFT JOIN tmpErr ON tmpErr.MovementId = Movement.Id

       WHERE MovementLinkObject.DescId = zc_MovementLinkObject_CheckSourceKind()
         AND MovementLinkObject.ObjectId = zc_Enum_CheckSourceKind_Tabletki()
         AND MovementString_BookingStatus.ValueData = '2.0'
         AND COALESCE (MovementLinkObject_ConfirmedKind.ObjectId, 0) = zc_Enum_ConfirmedKind_UnComplete()        
         AND COALESCE (tmpErr.MovementId, 0) <> 0) AS T1;
         
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpErased_Movement_Check_Booking_Tabletki (TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
              Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Шаблий О.В.
 04.05.2                                                        * 
*/            

-- select * from gpErased_Movement_Check_Booking_Tabletki ('3');