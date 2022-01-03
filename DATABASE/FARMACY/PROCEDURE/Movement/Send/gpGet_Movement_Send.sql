-- Function: gpGet_Movement_Send()

DROP FUNCTION IF EXISTS gpGet_Movement_Send (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Send(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- дата Документа
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
             , isSendLoss Boolean, isSendLossFrom Boolean
             , SetFocused TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitKey TVarChar;
  DECLARE vbUnitId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Send());
     vbUserId := inSession;

     vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
     IF vbUnitKey = '' THEN
       vbUnitKey := '0';
     END IF;
     vbUnitId := vbUnitKey::Integer;

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('Movement_Send_seq') AS TVarChar) AS InvNumber
             , CURRENT_DATE::TDateTime                          AS OperDate
             , Object_Status.Code                               AS StatusCode
             , Object_Status.Name                               AS StatusName
             , CAST (0 AS TFloat)                               AS TotalCount
             , 0                     		             		AS FromId
             , CAST ('' AS TVarChar) 		            		AS FromName
             , 0                     		                    AS ToId
             , CAST ('' AS TVarChar) 			                AS ToName
             , 0                                                AS PartionDateKindId
             , CAST ('' AS TVarChar) 			                AS PartionDateKindName
             , 0                     		                    AS DriverSunId
             , CAST ('' AS TVarChar)   		                    AS DriverSunName
             , CAST ('' AS TVarChar) 		                    AS Comment
             , FALSE                                            AS isAuto
             , CAST (0 AS TFloat)                               AS MCSPeriod
             , CAST (0 AS TFloat)                               AS MCSDay
             , FALSE                                            AS Checked
             , FALSE                                            AS isComplete
             , FALSE                                            AS isDeferred
             , FALSE                                            AS isSUN
             , FALSE                                            AS isSUN_v2
             , FALSE                                            AS isSUN_v3
             , FALSE                                            AS isSUN_v4
             , FALSE                                            AS isDefSUN
             , FALSE                                            AS isSent
             , FALSE                                            AS isReceived
             , FALSE                                            AS NotDisplaySUN
             , FALSE                                            AS isVIP
             , FALSE                                            AS isUrgently
             , FALSE                                            AS isConfirmed
             , CAST ('Не определено' AS TVarChar)               AS ConfirmedText
             , CAST (0 AS Integer)                              AS NumberSeats
             , FALSE                                            AS isBanFiscalSale
             , FALSE                                            AS isSendLoss
             , FALSE                                            AS isSendLossFrom
             , ''::TVarChar                                     AS SetFocused 
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;

     ELSE

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
           , COALESCE (MovementBoolean_SendLossFrom.ValueData, FALSE)     ::Boolean AS isSendLossFrom           
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
            LEFT JOIN MovementBoolean AS MovementBoolean_SendLossFrom
                                      ON MovementBoolean_SendLossFrom.MovementId = Movement.Id
                                     AND MovementBoolean_SendLossFrom.DescId = zc_MovementBoolean_SendLossFrom()

            LEFT JOIN MovementFloat AS MovementFloat_MCSPeriod
                                    ON MovementFloat_MCSPeriod.MovementId =  Movement.Id
                                   AND MovementFloat_MCSPeriod.DescId = zc_MovementFloat_MCSPeriod()
            LEFT JOIN MovementFloat AS MovementFloat_MCSDay
                                    ON MovementFloat_MCSDay.MovementId =  Movement.Id
                                   AND MovementFloat_MCSDay.DescId = zc_MovementFloat_MCSDay()

            LEFT JOIN MovementFloat AS MovementFloat_NumberSeats
                                    ON MovementFloat_NumberSeats.MovementId =  Movement.Id
                                   AND MovementFloat_NumberSeats.DescId = zc_MovementFloat_NumberSeats()

       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_Send();

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_Send (Integer, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.   Шаблий О.В.
 20.05.20                                                                                     * Перемещение ВИП
 31.03.20         * zc_MovementBoolean_SUN_v3
 05.03.20                                                                                     * zc_MovementLinkObject_DriverSun
 09.12.19         *
 23.09.19         * zc_MovementLinkObject_Driver
 06.08.19                                                                                     * zc_MovementBoolean_Received
 24.07.19         * zc_MovementBoolean_DefSUN
 11.07.19         * zc_MovementBoolean_SUN
 09.06.19         * PartionDateKind
 08.11.17         * Deferred
 15.11.16         * add isComplete
 15.06.16         * CURRENT_DATE::TDateTime 
 14.06.16         *
 21.03.16         *
 29.07.15                                                                       *
 */

-- тест
-- select * from gpGet_Movement_Send(inMovementId := 18968591 , inOperDate := ('25.05.2020')::TDateTime ,  inSession := '3');