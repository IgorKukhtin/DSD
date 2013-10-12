-- Function: gpGet_Movement_Transport()

DROP FUNCTION IF EXISTS gpGet_Movement_Transport (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Transport(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , StartRunPlan TDateTime, EndRunPlan TDateTime, StartRun TDateTime, EndRun TDateTime
             , HoursWork TFloat, HoursAdd TFloat
             , Comment TVarChar
             , CarId Integer, CarName TVarChar
             , CarTrailerId Integer, CarTrailerName TVarChar
             , PersonalDriverId Integer, PersonalDriverName TVarChar
             , PersonalDriverMoreId Integer, PersonalDriverMoreName TVarChar
             , UnitForwardingId Integer, UnitForwardingName TVarChar
             )
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Transport());

     IF COALESCE (inMovementId, 0) = 0
     THEN

     RETURN QUERY 
       SELECT
             0 AS Id
           , CAST (COALESCE (tmpMovement_InvNumber.InvNumber, 0) + 1 as TVarChar) AS InvNumber
           , CAST (CURRENT_TIMESTAMP as TDateTime) AS OperDate
           , lfObject_Status.Code                  AS StatusCode
           , lfObject_Status.Name                  AS StatusName
           
           , CAST (CURRENT_TIMESTAMP as TDateTime) AS StartRunPlan 
           , CAST (CURRENT_TIMESTAMP as TDateTime) AS EndRunPlan 
           , CAST (CURRENT_TIMESTAMP as TDateTime) AS StartRun 
           , CAST (CURRENT_TIMESTAMP as TDateTime) AS EndRun           
          
           , CAST (0 as TFloat)                    AS HoursWork
           , CAST (0 as TFloat)                    AS HoursAdd
                      
           , CAST ('' as TVarChar) AS Comment

           , 0                     AS CarId
           , CAST ('' as TVarChar) AS CarName

           , 0                     AS CarTrailerId
           , CAST ('' as TVarChar) AS CarTrailerName

           , 0                     AS PersonalDriverId
           , CAST ('' as TVarChar) AS PersonalDriverName

           , 0                     AS PersonalDriverMoreId
           , CAST ('' as TVarChar) AS PersonalDriverMoreName

           , Object_UnitForwarding.Id        AS UnitForwardingId
           , Object_UnitForwarding.ValueData AS UnitForwardingName
   
          FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS lfObject_Status
               LEFT JOIN Object AS Object_UnitForwarding ON Object_UnitForwarding.Id = zc_Branch_Basis()
               LEFT JOIN (SELECT CAST (MAX (Movement.InvNumber) AS Integer) AS InvNumber 
                         FROM Movement WHERE Movement.DescId = zc_Movement_Transport()) AS tmpMovement_InvNumber ON 1 = 1;

     ELSE

     RETURN QUERY 
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName
           
           , MovementDate_StartRunPlan.ValueData AS StartRunPlan 
           , MovementDate_EndRunPlan.ValueData   AS EndRunPlan 
           , MovementDate_StartRun.ValueData     AS StartRun 
           , MovementDate_EndRun.ValueData       AS EndRun           
          
           , MovementFloat_HoursWork.ValueData     AS HoursWork
           , MovementFloat_HoursAdd.ValueData      AS HoursAdd
                      
           , MovementString_Comment.ValueData      AS Comment

           , Object_Car.Id            AS CarId
           , Object_Car.ValueData     AS CarName

           , Object_CarTrailer.Id        AS CarTrailerId
           , Object_CarTrailer.ValueData AS CarTrailerName

           , View_PersonalDriver.PersonalId   AS PersonalDriverId
           , View_PersonalDriver.PersonalName AS PersonalDriverName

           , View_PersonalDriverMore.PersonalId   AS PersonalDriverMoreId
           , View_PersonalDriverMore.PersonalName AS PersonalDriverMoreName

           , Object_UnitForwarding.Id        AS UnitForwardingId
           , Object_UnitForwarding.ValueData AS UnitForwardingName
   
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_StartRunPlan
                                   ON MovementDate_StartRunPlan.MovementId = Movement.Id
                                  AND MovementDate_StartRunPlan.DescId = zc_MovementDate_StartRunPlan()

            LEFT JOIN MovementDate AS MovementDate_EndRunPlan
                                   ON MovementDate_EndRunPlan.MovementId = Movement.Id
                                  AND MovementDate_EndRunPlan.DescId = zc_MovementDate_EndRunPlan()

            LEFT JOIN MovementDate AS MovementDate_StartRun
                                   ON MovementDate_StartRun.MovementId = Movement.Id
                                  AND MovementDate_StartRun.DescId = zc_MovementDate_StartRun()

            LEFT JOIN MovementDate AS MovementDate_EndRun
                                   ON MovementDate_EndRun.MovementId = Movement.Id
                                  AND MovementDate_EndRun.DescId = zc_MovementDate_EndRun()

            LEFT JOIN MovementFloat AS MovementFloat_HoursWork
                                    ON MovementFloat_HoursWork.MovementId =  Movement.Id
                                   AND MovementFloat_HoursWork.DescId = zc_MovementFloat_HoursWork()
            
            LEFT JOIN MovementFloat AS MovementFloat_HoursAdd
                                    ON MovementFloat_HoursAdd.MovementId =  Movement.Id
                                   AND MovementFloat_HoursAdd.DescId = zc_MovementFloat_HoursAdd()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId =  Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                         ON MovementLinkObject_Car.MovementId = Movement.Id
                                        AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = MovementLinkObject_Car.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CarTrailer
                                         ON MovementLinkObject_CarTrailer.MovementId = Movement.Id
                                        AND MovementLinkObject_CarTrailer.DescId = zc_MovementLinkObject_CarTrailer()
            LEFT JOIN Object AS Object_CarTrailer ON Object_CarTrailer.Id = MovementLinkObject_CarTrailer.ObjectId
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                         ON MovementLinkObject_PersonalDriver.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
            LEFT JOIN Object_Personal_View AS View_PersonalDriver ON View_PersonalDriver.PersonalId = MovementLinkObject_PersonalDriver.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriverMore
                                         ON MovementLinkObject_PersonalDriverMore.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalDriverMore.DescId = zc_MovementLinkObject_PersonalDriverMore()
            LEFT JOIN Object_Personal_View AS View_PersonalDriverMore ON View_PersonalDriverMore.PersonalId = MovementLinkObject_PersonalDriverMore.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_UnitForwarding
                                         ON MovementLinkObject_UnitForwarding.MovementId = Movement.Id
                                        AND MovementLinkObject_UnitForwarding.DescId = zc_MovementLinkObject_UnitForwarding()
            LEFT JOIN Object AS Object_UnitForwarding ON Object_UnitForwarding.Id = MovementLinkObject_UnitForwarding.ObjectId

       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_Transport();

     END IF;
  
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_Transport (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.09.13                                        * add Object_Personal_View
 26.09.13                                        * changes in wiki
 25.09.13         * changes in wiki              
 20.08.13         *
*/


-- тест
-- SELECT * FROM gpGet_Movement_Transport (inMovementId:= 0, inSession:= '2')
