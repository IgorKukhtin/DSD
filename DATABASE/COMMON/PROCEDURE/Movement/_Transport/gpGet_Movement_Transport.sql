-- Function: gpGet_Movement_Transport()

DROP FUNCTION IF EXISTS gpGet_Movement_Transport (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Transport(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , StartRunPlan TDateTime, EndRunPlan TDateTime, StartRun TDateTime, EndRun TDateTime
             , HoursWork TFloat, HoursAdd TFloat
             , Comment TVarChar
             , CarId Integer, CarName TVarChar, CarModelName TVarChar
             , CarTrailerId Integer, CarTrailerName TVarChar
             , PersonalDriverId Integer, PersonalDriverName TVarChar, DriverCertificate TVarChar
             , PersonalDriverMoreId Integer, PersonalDriverMoreName TVarChar
             , PersonalId Integer, PersonalName TVarChar
             , UnitForwardingId Integer, UnitForwardingName TVarChar
             , JuridicalName TVarChar
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Transport());
     vbUserId:= lpGetUserBySession (inSession);


     IF COALESCE (inMovementId, 0) = 0
     THEN

     RETURN QUERY 
       SELECT
             0 AS Id
           , CAST (NEXTVAL ('Movement_Transport_seq') AS TVarChar) AS InvNumber
           , CAST (CURRENT_DATE AS TDateTime)      AS OperDate
           , lfObject_Status.Code                  AS StatusCode
           , lfObject_Status.Name                  AS StatusName
           
           , CAST (DATE_TRUNC ('MINUTE', CURRENT_TIMESTAMP) AS TDateTime) AS StartRunPlan 
           , CAST (DATE_TRUNC ('MINUTE', CURRENT_TIMESTAMP) AS TDateTime) AS EndRunPlan
           , CAST (DATE_TRUNC ('MINUTE', CURRENT_TIMESTAMP) AS TDateTime) AS StartRun 
           , CAST (DATE_TRUNC ('MINUTE', CURRENT_TIMESTAMP) AS TDateTime) AS EndRun           
          
           , CAST (0 as TFloat)                    AS HoursWork
           , CAST (0 as TFloat)                    AS HoursAdd
                      
           , CAST ('' as TVarChar) AS Comment

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

           , Object_UnitForwarding.Id        AS UnitForwardingId
           , Object_UnitForwarding.ValueData AS UnitForwardingName
   
           , CAST ('' as TVarChar) AS JuridicalName

       FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS lfObject_Status
            LEFT JOIN Object AS Object_UnitForwarding ON Object_UnitForwarding.Id = (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Branch() AND Object.AccessKeyId = lpGetAccessKey (vbUserId, zc_Enum_Process_Get_Movement_Transport()));

     ELSE

     RETURN QUERY 
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName
           
           , CAST (DATE_TRUNC ('MINUTE', MovementDate_StartRunPlan.ValueData) AS TDateTime) AS StartRunPlan
           , CAST (DATE_TRUNC ('MINUTE', MovementDate_EndRunPlan.ValueData)   AS TDateTime) AS EndRunPlan
           , CAST (DATE_TRUNC ('MINUTE', MovementDate_StartRun.ValueData)     AS TDateTime) AS StartRun
           , CAST (DATE_TRUNC ('MINUTE', MovementDate_EndRun.ValueData)       AS TDateTime) AS EndRun
          
           , CAST (COALESCE (MovementFloat_HoursWork.ValueData, 0) + COALESCE (MovementFloat_HoursAdd.ValueData, 0) AS TFloat) AS HoursWork
           , MovementFloat_HoursAdd.ValueData      AS HoursAdd
                      
           , MovementString_Comment.ValueData      AS Comment

           , Object_Car.Id             AS CarId
           , Object_Car.ValueData      AS CarName
           , Object_CarModel.ValueData AS CarModelName

           , Object_CarTrailer.Id        AS CarTrailerId
           , Object_CarTrailer.ValueData AS CarTrailerName

           , View_PersonalDriver.PersonalId   AS PersonalDriverId
           , View_PersonalDriver.PersonalName AS PersonalDriverName
           , ObjectString_DriverCertificate.ValueData AS DriverCertificate

           , View_PersonalDriverMore.PersonalId   AS PersonalDriverMoreId
           , View_PersonalDriverMore.PersonalName AS PersonalDriverMoreName

           , View_Personal.PersonalId   AS PersonalId
           , View_Personal.PersonalName AS PersonalName

           , Object_UnitForwarding.Id        AS UnitForwardingId
           , Object_UnitForwarding.ValueData AS UnitForwardingName

           , Object_Juridical.ValueData AS JuridicalName
   
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
            LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                                           AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId
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
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_Transport (Integer, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
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


-- ����
-- SELECT * FROM gpGet_Movement_Transport (inMovementId:= 0, inSession:= '2')
