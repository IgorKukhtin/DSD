-- Function: gpGet_Movement_Transport()

DROP FUNCTION IF EXISTS gpGet_Movement_Transport (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Transport(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, IdBarCode TVarChar, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , StartRunPlan TDateTime, EndRunPlan TDateTime, StartRun TDateTime, EndRun TDateTime
             , StartStop TDateTime, EndStop TDateTime
             , StartPlanHour TFloat, StartPlanMinute TFloat
             , EndPlanHour TFloat, EndPlanMinute   TFloat
             , HoursWork TFloat, HoursAdd TFloat
             , HoursStop TFloat, HoursMove TFloat
             , PartnerCount TFloat
             , Comment TVarChar, CommentStop TVarChar
             , CarId Integer, CarName TVarChar, CarModelName TVarChar
             , CarTrailerId Integer, CarTrailerName TVarChar
             , PersonalDriverId Integer, PersonalDriverName TVarChar, DriverCertificate TVarChar
             , PersonalDriverMoreId Integer, PersonalDriverMoreName TVarChar
             , PersonalId Integer, PersonalName TVarChar
             , UnitForwardingId Integer, UnitForwardingName TVarChar
             , JuridicalName TVarChar
             , UserId_ConfirmedKind Integer, UserName_ConfirmedKind TVarChar
             , Date_UserConfirmedKind TDateTime
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Transport());
     vbUserId:= lpGetUserBySession (inSession);


     IF COALESCE (inMovementId, 0) = 0
     THEN
       --
       vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_Get_Movement_Transport());
       --
       RETURN QUERY 
       WITH tmpBranch  AS (SELECT Object.Id AS BranchId FROM Object WHERE Object.DescId = zc_Object_Branch() AND Object.AccessKeyId = vbAccessKeyId)
          , tmpUnitAll AS (SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byProfitLossDirection() AS lfSelect
                           WHERE lfSelect.ProfitLossDirectionId = zc_Enum_ProfitLossDirection_40100()
                              OR (lfSelect.ProfitLossDirectionId = zc_Enum_ProfitLossDirection_40200() AND lfSelect.UnitName ILIKE '%Транспорт%')
                          )
          , tmpUnit AS (SELECT Object.*
                        FROM ObjectLink AS OL_Unit_Branch
                             INNER JOIN tmpBranch ON tmpBranch.BranchId = OL_Unit_Branch.ChildObjectId
                             INNER JOIN tmpUnitAll ON tmpUnitAll.UnitId = OL_Unit_Branch.ObjectId
                             LEFT JOIN Object ON Object.Id = OL_Unit_Branch.ObjectId
                        WHERE OL_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                       )
       SELECT
             0 AS Id
           , '' :: TVarChar AS IdBarCode
           , CAST (NEXTVAL ('Movement_Transport_seq') AS TVarChar) AS InvNumber
           , CAST (CURRENT_DATE AS TDateTime)      AS OperDate
           , Object_Status.ObjectCode              AS StatusCode
           , Object_Status.ValueData               AS StatusName
           
           , CAST (DATE_TRUNC ('MINUTE', CURRENT_TIMESTAMP) AS TDateTime) AS StartRunPlan 
           , CAST (DATE_TRUNC ('MINUTE', CURRENT_TIMESTAMP) AS TDateTime) AS EndRunPlan
           , CAST (DATE_TRUNC ('MINUTE', CURRENT_TIMESTAMP) AS TDateTime) AS StartRun
           , CAST (DATE_TRUNC ('MINUTE', CURRENT_TIMESTAMP) AS TDateTime) AS EndRun
           
           , CAST (NULL AS TDateTime) AS StartStop
           , CAST (NULL AS TDateTime) AS EndStop
          
           , date_part ('HOUR',CURRENT_TIMESTAMP)  ::TFloat AS StartPlanHour
           , date_part ('MINUTE',CURRENT_TIMESTAMP)::TFloat AS StartPlanMinute
           , date_part ('HOUR',CURRENT_TIMESTAMP)  ::TFloat AS EndPlanHour
           , date_part ('MINUTE',CURRENT_TIMESTAMP)::TFloat AS EndPlanMinute

           , CAST (0 as TFloat)                    AS HoursWork
           , CAST (0 as TFloat)                    AS HoursAdd
           , CAST (0 as TFloat)                    AS HoursStop
           , CAST (0 as TFloat)                    AS HoursMove
           , CAST (0 as TFloat)                    AS PartnerCount
                      
           , CAST ('' as TVarChar) AS Comment
           , CAST ('' as TVarChar) AS CommentStop

           , 0                     AS CarId
           , CAST ('' as TVarChar) AS CarName
           , CAST ('' as TVarChar) AS CarModelName

           , 0                     AS CarTrailerId
           , CAST ('' as TVarChar) AS CarTrailerName

           , 0                     AS PersonalDriverId
           , CAST ('' as TVarChar) AS PersonalDriverName
           , CAST ('' as TVarChar) AS DriverCertificate

           , 0                     AS PersonalDriverMoreId
           , CAST ('' as TVarChar) AS PersonalDriverMoreName

           , 0                     AS PersonalId
           , CAST ('' as TVarChar) AS PersonalName

           , View_Unit.Id        AS UnitForwardingId
           , View_Unit.ValueData AS UnitForwardingName
   
           , CAST ('' as TVarChar) AS JuridicalName

           , 0                     AS UserId_ConfirmedKind
           , CAST ('' as TVarChar) AS UserName_ConfirmedKind
           , CAST (NULL AS TDateTime) AS Date_UserConfirmedKind

       FROM Object AS Object_Status
            -- LEFT JOIN Object AS Object_UnitForwarding ON Object_UnitForwarding.Id = (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Branch() AND Object.AccessKeyId = lpGetAccessKey (vbUserId, zc_Enum_Process_Get_Movement_Transport()))
            CROSS JOIN tmpUnit AS View_Unit 
       WHERE Object_Status.Id = zc_Enum_Status_UnComplete()
       LIMIT 1
       ;

     ELSE

     RETURN QUERY 
       SELECT
             Movement.Id
           , zfFormat_BarCode (zc_BarCodePref_Movement(), Movement.Id) AS IdBarCode
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName
           
           , CAST (DATE_TRUNC ('MINUTE', COALESCE (MovementDate_StartRunPlan.ValueData, Movement.OperDate)) AS TDateTime) AS StartRunPlan
           , CAST (DATE_TRUNC ('MINUTE', COALESCE (MovementDate_EndRunPlan.ValueData, Movement.OperDate))   AS TDateTime) AS EndRunPlan
           , CAST (DATE_TRUNC ('MINUTE', COALESCE (MovementDate_StartRun.ValueData, Movement.OperDate))     AS TDateTime) AS StartRun
           , CAST (DATE_TRUNC ('MINUTE', COALESCE (MovementDate_EndRun.ValueData, Movement.OperDate))       AS TDateTime) AS EndRun

           , CAST (MovementDate_StartStop.ValueData AS TDateTime) AS StartStop
           , CAST (MovementDate_EndStop.ValueData AS TDateTime)   AS EndStop
           
           , date_part ('HOUR',  COALESCE (MovementDate_StartRunPlan.ValueData, Movement.OperDate))  ::TFloat AS StartPlanHour
           , date_part ('MINUTE',COALESCE (MovementDate_StartRunPlan.ValueData, Movement.OperDate))  ::TFloat AS StartPlanMinute
           , date_part ('HOUR',  COALESCE (MovementDate_EndRunPlan.ValueData, Movement.OperDate))    ::TFloat AS EndPlanHour
           , date_part ('MINUTE',COALESCE (MovementDate_EndRunPlan.ValueData, Movement.OperDate))    ::TFloat AS EndPlanMinute

           , CAST (COALESCE (MovementFloat_HoursWork.ValueData, 0) + COALESCE (MovementFloat_HoursAdd.ValueData, 0) AS TFloat) AS HoursWork
           , MovementFloat_HoursAdd.ValueData      AS HoursAdd

           , COALESCE (MovementFloat_HoursStop.ValueData, 0) :: TFloat AS HoursStop
           , CAST (COALESCE (MovementFloat_HoursWork.ValueData, 0) + COALESCE (MovementFloat_HoursAdd.ValueData, 0) - COALESCE (MovementFloat_HoursStop.ValueData, 0)  AS TFloat) AS HoursMove
           , CAST (MovementFloat_PartnerCount.ValueData AS TFloat)     AS PartnerCount

           , MovementString_Comment.ValueData      AS Comment
           , COALESCE (MovementString_CommentStop.ValueData,'') ::TVarChar AS CommentStop

           , Object_Car.Id             AS CarId
           , Object_Car.ValueData      AS CarName
           , (COALESCE (Object_CarModel.ValueData,'') || COALESCE (' ' || Object_CarType.ValueData, '') ) ::TVarChar AS CarModelName

           , Object_CarTrailer.Id        AS CarTrailerId
           , Object_CarTrailer.ValueData AS CarTrailerName

           , View_PersonalDriver.PersonalId   AS PersonalDriverId
           , (View_PersonalDriver.PersonalName /*|| ' ' || View_PersonalDriver.PositionName*/) :: TVarChar AS PersonalDriverName
           , ObjectString_DriverCertificate.ValueData AS DriverCertificate

           , View_PersonalDriverMore.PersonalId   AS PersonalDriverMoreId
           , (View_PersonalDriverMore.PersonalName /*|| ' ' || View_PersonalDriverMore.PositionName*/) :: TVarChar AS PersonalDriverMoreName

           , View_Personal.PersonalId   AS PersonalId
           , (View_Personal.PersonalName /*|| ' ' || View_Personal.PositionName*/) :: TVarChar AS PersonalName

           , Object_UnitForwarding.Id        AS UnitForwardingId
           , Object_UnitForwarding.ValueData AS UnitForwardingName

           , Object_Juridical.ValueData AS JuridicalName
           
           , Object_UserConfirmedKind.Id                           AS UserId_ConfirmedKind
           , Object_UserConfirmedKind.ValueData                    AS UserName_ConfirmedKind
           , MovementDate_UserConfirmedKind.ValueData :: TDateTime AS Date_UserConfirmedKind
   
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

            LEFT JOIN MovementDate AS MovementDate_StartStop
                                   ON MovementDate_StartStop.MovementId = Movement.Id
                                  AND MovementDate_StartStop.DescId = zc_MovementDate_StartStop()

            LEFT JOIN MovementDate AS MovementDate_EndStop
                                   ON MovementDate_EndStop.MovementId = Movement.Id
                                  AND MovementDate_EndStop.DescId = zc_MovementDate_EndStop()

            LEFT JOIN MovementDate AS MovementDate_UserConfirmedKind
                                   ON MovementDate_UserConfirmedKind.MovementId = Movement.Id
                                  AND MovementDate_UserConfirmedKind.DescId = zc_MovementDate_UserConfirmedKind()

            LEFT JOIN MovementFloat AS MovementFloat_HoursWork
                                    ON MovementFloat_HoursWork.MovementId = Movement.Id
                                   AND MovementFloat_HoursWork.DescId = zc_MovementFloat_HoursWork()
            
            LEFT JOIN MovementFloat AS MovementFloat_HoursAdd
                                    ON MovementFloat_HoursAdd.MovementId = Movement.Id
                                   AND MovementFloat_HoursAdd.DescId = zc_MovementFloat_HoursAdd()

            LEFT JOIN MovementFloat AS MovementFloat_HoursStop
                                    ON MovementFloat_HoursStop.MovementId = Movement.Id
                                   AND MovementFloat_HoursStop.DescId = zc_MovementFloat_HoursStop()

            LEFT JOIN MovementFloat AS MovementFloat_PartnerCount
                                    ON MovementFloat_PartnerCount.MovementId = Movement.Id
                                   AND MovementFloat_PartnerCount.DescId = zc_MovementFloat_PartnerCount()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()
            LEFT JOIN MovementString AS MovementString_CommentStop
                                     ON MovementString_CommentStop.MovementId = Movement.Id
                                    AND MovementString_CommentStop.DescId = zc_MovementString_CommentStop()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                         ON MovementLinkObject_Car.MovementId = Movement.Id
                                        AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = MovementLinkObject_Car.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                                           AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                 ON ObjectLink_Car_CarType.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_CarType.DescId = zc_ObjectLink_Car_CarType()
            LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId


            LEFT JOIN ObjectLink AS ObjectLink_Car_Unit ON ObjectLink_Car_Unit.ObjectId = Object_Car.Id
                                                       AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
            LEFT JOIN ObjectLink AS ObjectLink_UnitCar_Juridical ON ObjectLink_UnitCar_Juridical.ObjectId = ObjectLink_Car_Unit.ChildObjectId
                                                                AND ObjectLink_UnitCar_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_UnitCar_Juridical.ChildObjectId

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
 
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                         ON MovementLinkObject_Personal.MovementId = Movement.Id
                                        AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
            LEFT JOIN Object_Personal_View AS View_Personal ON View_Personal.PersonalId = MovementLinkObject_Personal.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_UserConfirmedKind
                                         ON MovementLinkObject_UserConfirmedKind.MovementId = Movement.Id
                                        AND MovementLinkObject_UserConfirmedKind.DescId = zc_MovementLinkObject_UserConfirmedKind()
            LEFT JOIN Object AS Object_UserConfirmedKind ON Object_UserConfirmedKind.Id = MovementLinkObject_UserConfirmedKind.ObjectId

            LEFT JOIN ObjectString AS ObjectString_DriverCertificate
                                   ON ObjectString_DriverCertificate.ObjectId = View_PersonalDriver.MemberId 
                                  AND ObjectString_DriverCertificate.DescId = zc_ObjectString_Member_DriverCertificate()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_UnitForwarding
                                         ON MovementLinkObject_UnitForwarding.MovementId = Movement.Id
                                        AND MovementLinkObject_UnitForwarding.DescId = zc_MovementLinkObject_UnitForwarding()
            LEFT JOIN Object AS Object_UnitForwarding ON Object_UnitForwarding.Id = MovementLinkObject_UnitForwarding.ObjectId

       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_Transport();

     END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_Transport (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 26.04.21         *
 22.01.20         * add StartPlanHour, StartPlanMinute, 
                        EndPlanHour, EndPlanMinute
 16.12.13                                        * err on DriverCertificate
 15.12.13                                        * add lpGetAccessKey
 02.12.13         * add Personal
 04.11.13                                        * add JuridicalName and DriverCertificate
 03.11.13                                        * add CarModelName
 25.10.13                                        * add MINUTE
 23.10.13                                        * add NEXTVAL
 30.09.13                                        * add Object_Personal_View
 26.09.13                                        * changes in wiki
 25.09.13         * changes in wiki              
 20.08.13         *
*/


-- тест
-- SELECT * FROM gpGet_Movement_Transport (inMovementId:= 2156006, inSession:= '2')
