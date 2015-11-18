-- Function: gpSelect_Movement_Transport()

DROP FUNCTION IF EXISTS gpSelect_Movement_Transport (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Transport (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Transport(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inIsErased    Boolean ,
    IN inSession     TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber Integer, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , StartRunPlan TDateTime, EndRunPlan TDateTime, StartRun TDateTime, EndRun TDateTime
             , HoursWork TFloat, HoursAdd TFloat
             , Comment TVarChar
             , BranchCode Integer, BranchName TVarChar
             , CarName TVarChar, CarModelName TVarChar, CarTrailerName TVarChar
             , PersonalDriverName TVarChar
             , PersonalDriverMoreName TVarChar
             , PersonalName TVarChar
             , UnitForwardingName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Transport());
     vbUserId:= lpGetUserBySession (inSession);


     -- ������������ - ����� �� ���������� ������ ��� ���������
     IF zfCalc_AccessKey_TransportAll (vbUserId) = TRUE
     THEN vbAccessKeyId:= 0;
     ELSE vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_Transport());
     END IF;


     -- ���������
     RETURN QUERY 
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_UnComplete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                       )
       SELECT
             Movement.Id
           , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName
           
           , MovementDate_StartRunPlan.ValueData AS StartRunPlan 
           , MovementDate_EndRunPlan.ValueData   AS EndRunPlan 
           , MovementDate_StartRun.ValueData     AS StartRun 
           , MovementDate_EndRun.ValueData       AS EndRun           
          
           , CAST (COALESCE (MovementFloat_HoursWork.ValueData, 0) + COALESCE (MovementFloat_HoursAdd.ValueData, 0) AS TFloat) AS HoursWork
           , MovementFloat_HoursAdd.ValueData      AS HoursAdd
                      
           , MovementString_Comment.ValueData      AS Comment

           , View_Unit.BranchCode
           , View_Unit.BranchName
           , Object_Car.ValueData        AS CarName
           , Object_CarModel.ValueData   AS CarModelName
           , Object_CarTrailer.ValueData AS CarTrailerName

           , View_PersonalDriver.PersonalName     AS PersonalDriverName
           , View_PersonalDriverMore.PersonalName AS PersonalDriverMoreName
           , View_Personal.PersonalName           AS PersonalName

           , Object_UnitForwarding.ValueData AS UnitForwardingName
   
       FROM tmpStatus
            INNER JOIN Movement ON Movement.DescId = zc_Movement_Transport()
                               AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                               AND Movement.StatusId = tmpStatus.StatusId
                               AND (Movement.AccessKeyId = vbAccessKeyId OR vbAccessKeyId = 0)
            -- JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId) AS tmpRoleAccessKey
            --                                                                                                       ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId

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
            LEFT JOIN ObjectLink AS ObjectLink_Car_Unit ON ObjectLink_Car_Unit.ObjectId = Object_Car.Id
                                                       AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
            LEFT JOIN Object_Unit_View AS View_Unit ON View_Unit.Id = ObjectLink_Car_Unit.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                                           AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId

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

            LEFT JOIN MovementLinkObject AS MovementLinkObject_UnitForwarding
                                         ON MovementLinkObject_UnitForwarding.MovementId = Movement.Id
                                        AND MovementLinkObject_UnitForwarding.DescId = zc_MovementLinkObject_UnitForwarding()
            LEFT JOIN Object AS Object_UnitForwarding ON Object_UnitForwarding.Id = MovementLinkObject_UnitForwarding.ObjectId
 
      
         -- AND tmpRoleAccessKey.AccessKeyId IS NOT NULL
      ;
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_Movement_Transport (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.08.15         * add inIsErased
 06.02.14                                        * add Branch...
 14.12.13                                        * add lpGetUserBySession
 02.12.13         * add Personal (changes in wiki)
 23.10.13                                        * add zfConvert_StringToNumber
 18.10.13                                        * add CarModelName
 30.09.13                                        * add Object_Personal_View
 26.09.13                                        * changes in wiki
 25.09.13         * changes in wiki
 20.08.13         *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_Transport (inStartDate:= '30.01.2013', inEndDate:= '01.02.2013', inSession:= zfCalc_UserAdmin())
