-- Function: gpGet_Movement_Send_Number()

DROP FUNCTION IF EXISTS gpGet_Movement_Send_Number (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Send_Number(
    IN inInvNumber         Integer  , -- номер Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , PartionDateKindId Integer, PartionDateKindName TVarChar
             , DriverSunId Integer, DriverSunName TVarChar
             , Comment TVarChar
             , isAuto Boolean, MCSPeriod TFloat, MCSDay TFloat
             , Checked Boolean
             , isComplete Boolean
             , isDeferred Boolean
             , isSUN Boolean, isSUN_v2 Boolean, isSUN_v3 Boolean, isSUN_v4 Boolean
             , isDefSUN Boolean, isSent Boolean, isReceived Boolean, isNotDisplaySUN Boolean
             , isVIP Boolean, isUrgently Boolean, isConfirmed Boolean, ConfirmedText TVarChar
             , NumberSeats Integer
             , isBanFiscalSale Boolean
             , isSendLoss Boolean
             , SetFocused TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitKey TVarChar;
  DECLARE vbUnitId Integer;
  DECLARE vbMovementId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Send());
     vbUserId := inSession;

     vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
     IF vbUnitKey = '' THEN
       vbUnitKey := '0';
     END IF;
     vbUnitId := vbUnitKey::Integer;
     
     SELECT Movement.id
     INTO vbMovementId
     FROM Movement 
     WHERE Movement.DescId = zc_Movement_Send() 
       AND Movement.InvNumber = inInvNumber::TVarChar;
     
     IF COALESCE (vbMovementId, 0) = 0
     THEN
        RAISE EXCEPTION 'Перемещение с номером <%> не найдено.', inInvNumber;
     END IF;

     RETURN QUERY
       SELECT
             Movement.Id                                        AS Id
           , Movement.InvNumber                                 AS InvNumber
           , Movement.OperDate                                  AS OperDate
           , Object_Status.ObjectCode                           AS StatusCode
           , Object_Status.ValueData                            AS StatusName
           , MovementFloat_TotalCount.ValueData                 AS TotalCount
           , Object_From.Id                                     AS FromId
           , Object_From.ValueData                              AS FromName
           , Object_To.Id                                       AS ToId
           , Object_To.ValueData                                AS ToName
           , Object_PartionDateKind.Id                          AS PartionDateKindId
           , Object_PartionDateKind.ValueData                   AS PartionDateKindName
           , Object_DriverSun.Id                                AS DriverSunId
           , Object_DriverSun.ValueData             :: TVarChar AS DriverSunName
           , COALESCE (MovementString_Comment.ValueData,'')     ::TVarChar AS Comment
           , COALESCE (MovementBoolean_isAuto.ValueData, FALSE) ::Boolean  AS isAuto
           , COALESCE (MovementFloat_MCSPeriod.ValueData,0)     ::TFloat   AS MCSPeriod
           , COALESCE (MovementFloat_MCSDay.ValueData,0)        ::TFloat   AS MCSDay
           , COALESCE (MovementBoolean_Checked.ValueData, FALSE) ::Boolean AS Checked
           , COALESCE (MovementBoolean_Complete.ValueData, FALSE)::Boolean AS isComplete
           , COALESCE (MovementBoolean_Deferred.ValueData, FALSE)::Boolean AS isDeferred
           , COALESCE (MovementBoolean_SUN.ValueData, FALSE)     ::Boolean AS isSUN
           , COALESCE (MovementBoolean_SUN_v2.ValueData, FALSE)  ::Boolean AS isSUN_v2
           , COALESCE (MovementBoolean_SUN_v3.ValueData, FALSE)  ::Boolean AS isSUN_v3
           , COALESCE (MovementBoolean_SUN_v4.ValueData, FALSE)  ::Boolean AS isSUN_v4
           , COALESCE (MovementBoolean_DefSUN.ValueData, FALSE)  ::Boolean AS isDefSUN
           , COALESCE (MovementBoolean_Sent.ValueData, FALSE)    ::Boolean AS isSent
           , COALESCE (MovementBoolean_Received.ValueData, FALSE)::Boolean AS isReceived
           , COALESCE (MovementBoolean_NotDisplaySUN.ValueData, FALSE)::Boolean AS isNotDisplaySUN
           , COALESCE (MovementBoolean_VIP.ValueData, FALSE)     ::Boolean AS isVIP
           , COALESCE (MovementBoolean_Urgently.ValueData, FALSE)::Boolean AS isUrgently
           , COALESCE (MovementBoolean_Confirmed.ValueData, FALSE)::Boolean AS isConfirmed           
           , CASE WHEN COALESCE (MovementBoolean_VIP.ValueData, FALSE) = FALSE THEN 'Подтверждение'   
                  WHEN MovementBoolean_Confirmed.ValueData IS NULL THEN 'Ожидает подтвержд.'   
                  WHEN MovementBoolean_Confirmed.ValueData = TRUE  THEN 'Подтвержден'   
                  ELSE 'Не подтвержден' END ::TVarChar          AS ConfirmedText
           , MovementFloat_NumberSeats.ValueData::Integer       AS NumberSeats
           , COALESCE (MovementBoolean_BanFiscalSale.ValueData, FALSE)    ::Boolean AS isBanFiscalSale           
           , COALESCE (MovementBoolean_SendLoss.ValueData, FALSE)         ::Boolean AS isSendLoss           
           , CASE WHEN Object_To.Id = vbUnitId
                   AND COALESCE (MovementBoolean_Sent.ValueData, FALSE) = True
                   AND COALESCE (MovementBoolean_Received.ValueData, FALSE) = False
                  THEN 'AmountManual' 
                  ELSE '' END::TVarChar    AS SetFocused 
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                         ON MovementLinkObject_PartionDateKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
            LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = MovementLinkObject_PartionDateKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_DriverSun
                                         ON MovementLinkObject_DriverSun.MovementId = Movement.Id
                                        AND MovementLinkObject_DriverSun.DescId = zc_MovementLinkObject_DriverSun()
            LEFT JOIN Object AS Object_DriverSun ON Object_DriverSun.Id = MovementLinkObject_DriverSun.ObjectId 

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementBoolean AS MovementBoolean_isAuto
                                      ON MovementBoolean_isAuto.MovementId = Movement.Id
                                     AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()
            LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                      ON MovementBoolean_Checked.MovementId =  Movement.Id
                                     AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()
            LEFT JOIN MovementBoolean AS MovementBoolean_Complete
                                      ON MovementBoolean_Complete.MovementId = Movement.Id
                                     AND MovementBoolean_Complete.DescId = zc_MovementBoolean_Complete()

            LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                      ON MovementBoolean_Deferred.MovementId = Movement.Id
                                     AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()

            LEFT JOIN MovementBoolean AS MovementBoolean_SUN
                                      ON MovementBoolean_SUN.MovementId = Movement.Id
                                     AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
            LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v2
                                      ON MovementBoolean_SUN_v2.MovementId = Movement.Id
                                     AND MovementBoolean_SUN_v2.DescId = zc_MovementBoolean_SUN_v2()
            LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v3
                                      ON MovementBoolean_SUN_v3.MovementId = Movement.Id
                                     AND MovementBoolean_SUN_v3.DescId = zc_MovementBoolean_SUN_v3()
            LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v4
                                      ON MovementBoolean_SUN_v4.MovementId = Movement.Id
                                     AND MovementBoolean_SUN_v4.DescId = zc_MovementBoolean_SUN_v4()

            LEFT JOIN MovementBoolean AS MovementBoolean_DefSUN
                                      ON MovementBoolean_DefSUN.MovementId = Movement.Id
                                     AND MovementBoolean_DefSUN.DescId = zc_MovementBoolean_DefSUN()

            LEFT JOIN MovementBoolean AS MovementBoolean_Sent
                                      ON MovementBoolean_Sent.MovementId = Movement.Id
                                     AND MovementBoolean_Sent.DescId = zc_MovementBoolean_Sent()
            LEFT JOIN MovementBoolean AS MovementBoolean_Received
                                      ON MovementBoolean_Received.MovementId = Movement.Id
                                     AND MovementBoolean_Received.DescId = zc_MovementBoolean_Received()
            LEFT JOIN MovementBoolean AS MovementBoolean_NotDisplaySUN
                                      ON MovementBoolean_NotDisplaySUN.MovementId = Movement.Id
                                     AND MovementBoolean_NotDisplaySUN.DescId = zc_MovementBoolean_NotDisplaySUN()

            LEFT JOIN MovementBoolean AS MovementBoolean_VIP
                                      ON MovementBoolean_VIP.MovementId = Movement.Id
                                     AND MovementBoolean_VIP.DescId = zc_MovementBoolean_VIP()
            LEFT JOIN MovementBoolean AS MovementBoolean_Urgently
                                      ON MovementBoolean_Urgently.MovementId = Movement.Id
                                     AND MovementBoolean_Urgently.DescId = zc_MovementBoolean_Urgently()
            LEFT JOIN MovementBoolean AS MovementBoolean_Confirmed
                                      ON MovementBoolean_Confirmed.MovementId = Movement.Id
                                     AND MovementBoolean_Confirmed.DescId = zc_MovementBoolean_Confirmed()

            LEFT JOIN MovementBoolean AS MovementBoolean_BanFiscalSale
                                      ON MovementBoolean_BanFiscalSale.MovementId = Movement.Id
                                     AND MovementBoolean_BanFiscalSale.DescId = zc_MovementBoolean_BanFiscalSale()
            LEFT JOIN MovementBoolean AS MovementBoolean_SendLoss
                                      ON MovementBoolean_SendLoss.MovementId = Movement.Id
                                     AND MovementBoolean_SendLoss.DescId = zc_MovementBoolean_SendLoss()

            LEFT JOIN MovementFloat AS MovementFloat_MCSPeriod
                                    ON MovementFloat_MCSPeriod.MovementId =  Movement.Id
                                   AND MovementFloat_MCSPeriod.DescId = zc_MovementFloat_MCSPeriod()
            LEFT JOIN MovementFloat AS MovementFloat_MCSDay
                                    ON MovementFloat_MCSDay.MovementId =  Movement.Id
                                   AND MovementFloat_MCSDay.DescId = zc_MovementFloat_MCSDay()

            LEFT JOIN MovementFloat AS MovementFloat_NumberSeats
                                    ON MovementFloat_NumberSeats.MovementId =  Movement.Id
                                   AND MovementFloat_NumberSeats.DescId = zc_MovementFloat_NumberSeats()

       WHERE Movement.Id =  vbMovementId
         AND Movement.DescId = zc_Movement_Send();

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_Send_Number (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 29.11.21                                                       * Перемещение ВИП
 */

-- тест
-- 
select * from gpGet_Movement_Send_Number(inInvNumber := 150254 , inSession := '3');