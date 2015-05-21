-- Function: gpSelect_Movement_TransportGoods()

DROP FUNCTION IF EXISTS gpSelect_Movement_TransportGoods (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_QualityDoc(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inIsErased    Boolean ,
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , InvNumberMark TVarChar
             , MovementId_Sale Integer, InvNumber_Sale TVarChar, OperDate_Sale TDateTime
             , InvNumberPartner_Sale TVarChar, OperDatePartner_Sale TDateTime
             , RouteName TVarChar
             , CarName TVarChar, CarModelName TVarChar, CarTrailerName TVarChar
             , PersonalDriverName TVarChar
             , MemberName1 TVarChar
             , MemberName2 TVarChar
             , MemberName3 TVarChar
             , MemberName4 TVarChar
             , MemberName5 TVarChar
             , MemberName6 TVarChar
             , MemberName7 TVarChar
             , FromName TVarChar, ToName TVarChar
             , PaidKindName TVarChar
             , TotalCountSh TFloat, TotalCountKg TFloat, TotalSumm TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_TransportGoods());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY 
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_UnComplete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                       )
        , tmpRoleAccessKey_all AS (SELECT AccessKeyId, UserId FROM Object_RoleAccessKey_View)
        , tmpRoleAccessKey_user AS (SELECT AccessKeyId FROM tmpRoleAccessKey_all WHERE UserId = vbUserId GROUP BY AccessKeyId)
        , tmpAccessKey_IsDocumentAll AS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId
                                   UNION SELECT 1 AS Id FROM tmpRoleAccessKey_user WHERE AccessKeyId = zc_Enum_Process_AccessKey_DocumentAll()
                                        )
        , tmpRoleAccessKey AS (SELECT tmpRoleAccessKey_user.AccessKeyId FROM tmpRoleAccessKey_user WHERE NOT EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll)
                         UNION SELECT Object_RoleAccessKeyDocument_View.AccessKeyId FROM Object_RoleAccessKeyDocument_View WHERE EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll) GROUP BY Object_RoleAccessKeyDocument_View.AccessKeyId
                         -- UNION SELECT 0 AS AccessKeyId WHERE EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll)
                              )
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName

           , MovementString_InvNumberMark.ValueData  AS InvNumberMark

           , Movement_Sale.Id        AS MovementId_Sale
           , Movement_Sale.InvNumber AS InvNumber_Sale
           , Movement_Sale.OperDate  AS OperDate_Sale
           , MovementString_InvNumberPartner_Sale.ValueData AS InvNumberPartner_Sale
           , MovementDate_OperDatePartner_Sale.ValueData    AS OperDatePartner_Sale

           , Object_Route.ValueData          AS RouteName
           , Object_Car.ValueData            AS CarName
           , Object_CarModel.ValueData       AS CarModelName
           , Object_CarTrailer.ValueData     AS CarTrailerName
           , Object_PersonalDriver.ValueData AS PersonalDriverName

           , Object_Member1.ValueData AS MemberName1
           , Object_Member2.ValueData AS MemberName2
           , Object_Member3.ValueData AS MemberName3
           , Object_Member4.ValueData AS MemberName4
           , Object_Member5.ValueData AS MemberName5
           , Object_Member6.ValueData AS MemberName6
           , Object_Member7.ValueData AS MemberName7
 
           , Object_From.ValueData                AS FromName
           , Object_To.ValueData                  AS ToName
           , Object_PaidKind.ValueData            AS PaidKindName
           , MovementFloat_TotalCountSh.ValueData AS TotalCountSh
           , MovementFloat_TotalCountKg.ValueData AS TotalCountKg
           , MovementFloat_TotalSumm.ValueData    AS TotalSumm

       FROM tmpStatus
            JOIN Movement ON Movement.DescId = zc_Movement_TransportGoods()
                         AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                         AND Movement.StatusId = tmpStatus.StatusId
            JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MovementString_InvNumberMark
                                     ON MovementString_InvNumberMark.MovementId =  Movement.Id
                                    AND MovementString_InvNumberMark.DescId = zc_MovementString_InvNumberMark()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                         ON MovementLinkObject_Route.MovementId = Movement.Id
                                        AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = MovementLinkObject_Route.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                         ON MovementLinkObject_Car.MovementId = Movement.Id
                                        AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = MovementLinkObject_Car.ObjectId
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
            LEFT JOIN Object AS Object_PersonalDriver ON Object_PersonalDriver.Id = MovementLinkObject_PersonalDriver.ObjectId
    
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member1
                                         ON MovementLinkObject_Member1.MovementId = Movement.Id
                                        AND MovementLinkObject_Member1.DescId = zc_MovementLinkObject_Member1()
            LEFT JOIN Object AS Object_Member1 ON Object_Member1.Id = MovementLinkObject_Member1.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member2
                                         ON MovementLinkObject_Member2.MovementId = Movement.Id
                                        AND MovementLinkObject_Member2.DescId = zc_MovementLinkObject_Member2()
            LEFT JOIN Object AS Object_Member2 ON Object_Member2.Id = MovementLinkObject_Member2.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member3
                                         ON MovementLinkObject_Member3.MovementId = Movement.Id
                                        AND MovementLinkObject_Member3.DescId = zc_MovementLinkObject_Member3()
            LEFT JOIN Object AS Object_Member3 ON Object_Member3.Id = MovementLinkObject_Member3.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member4
                                         ON MovementLinkObject_Member4.MovementId = Movement.Id
                                        AND MovementLinkObject_Member4.DescId = zc_MovementLinkObject_Member4()
            LEFT JOIN Object AS Object_Member4 ON Object_Member4.Id = MovementLinkObject_Member4.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member5
                                         ON MovementLinkObject_Member5.MovementId = Movement.Id
                                        AND MovementLinkObject_Member5.DescId = zc_MovementLinkObject_Member5()
            LEFT JOIN Object AS Object_Member5 ON Object_Member5.Id = MovementLinkObject_Member5.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member6
                                         ON MovementLinkObject_Member6.MovementId = Movement.Id
                                        AND MovementLinkObject_Member6.DescId = zc_MovementLinkObject_Member6()
            LEFT JOIN Object AS Object_Member6 ON Object_Member6.Id = MovementLinkObject_Member6.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member7
                                         ON MovementLinkObject_Member7.MovementId = Movement.Id
                                        AND MovementLinkObject_Member7.DescId = zc_MovementLinkObject_Member7()
            LEFT JOIN Object AS Object_Member7 ON Object_Member7.Id = MovementLinkObject_Member7.ObjectId


            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_TransportGoods
                                           ON MovementLinkMovement_TransportGoods.MovementChildId = Movement.Id 
                                          AND MovementLinkMovement_TransportGoods.DescId = zc_MovementLinkMovement_TransportGoods()
            LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = MovementLinkMovement_TransportGoods.MovementId
                                               AND Movement_Sale.StatusId = zc_Enum_Status_Complete()
            LEFT JOIN MovementString AS MovementString_InvNumberPartner_Sale
                                     ON MovementString_InvNumberPartner_Sale.MovementId =  MovementLinkMovement_TransportGoods.MovementId
                                    AND MovementString_InvNumberPartner_Sale.DescId = zc_MovementString_InvNumberPartner()
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner_Sale
                                   ON MovementDate_OperDatePartner_Sale.MovementId =  MovementLinkMovement_TransportGoods.MovementId
                                  AND MovementDate_OperDatePartner_Sale.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = MovementLinkMovement_TransportGoods.MovementId
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = MovementLinkMovement_TransportGoods.MovementId
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = MovementLinkMovement_TransportGoods.MovementId
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCountSh
                                    ON MovementFloat_TotalCountSh.MovementId =  Movement_Sale.Id
                                   AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                    ON MovementFloat_TotalCountKg.MovementId =  Movement_Sale.Id
                                   AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement_Sale.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_TransportGoods (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 28.03.15                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_TransportGoods (inStartDate:= '30.01.2013', inEndDate:= '01.02.2014', inIsErased:=false , inSession:= zfCalc_UserAdmin())
