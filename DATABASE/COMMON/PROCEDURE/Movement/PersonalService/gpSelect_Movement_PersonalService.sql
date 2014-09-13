-- Function: gpSelect_Movement_PersonalService()

DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalService (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PersonalService(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , ServiceDate TDateTime
             , TotalSumm TFloat, TotalSummService TFloat, TotalSummCard TFloat, TotalSummMinus TFloat, TotalSummAdd TFloat
             , Comment TVarChar
             , PersonalServiceListId Integer, PersonalServiceListName TVarChar
              )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PersonalService());
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        , tmpUserAdmin AS (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId)
        , tmpRoleAccessKey AS (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId AND NOT EXISTS (SELECT UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
                         UNION SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE EXISTS (SELECT UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
                              )

       SELECT
             Movement.Id                        AS Id
           , Movement.InvNumber                 AS InvNumber
           , Movement.OperDate                  AS OperDate
           , Object_Status.ObjectCode           AS StatusCode
           , Object_Status.ValueData            AS StatusName
           , Date_ServiceDate.ValueData         AS ServiceDate 
           , MovementFloat_TotalSumm.ValueData          AS TotalSumm
           , MovementFloat_TotalSummService .ValueData  AS TotalSummService 
           , MovementFloat_TotalSummCard.ValueData      AS TotalSummCard
           , MovementFloat_TotalSummMinus.ValueData     AS TotalSummMinus
           , MovementFloat_TotalSummAdd.ValueData       AS TotalSumm
           , MovementString_Comment.ValueData   AS Comment
           , COALESCE (Object_PersonalServiceList.Id, CAST (0 AS Integer))            AS PersonalServiceListId
           , COALESCE (Object_PersonalServiceList.ValueData, CAST ('' AS TVarChar))  AS PersonalServiceListName

       FROM (SELECT Movement.id
             FROM tmpStatus
                  JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate  AND Movement.DescId = zc_Movement_PersonalService() AND Movement.StatusId = tmpStatus.StatusId
--                  JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
            ) AS tmpMovement

            LEFT JOIN Movement ON Movement.id = tmpMovement.id

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS Date_ServiceDate
                                   ON Date_ServiceDate.MovementId = Movement.Id
                                  AND Date_ServiceDate.DescId = zc_MovementDate_ServiceDate()
                                  
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummService
                                    ON MovementFloat_TotalSummService.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummService.DescId = zc_MovementFloat_TotalSummService()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummCard
                                    ON MovementFloat_TotalSummCard.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummCard.DescId = zc_MovementFloat_TotalSummCard()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMinus
                                    ON MovementFloat_TotalSummMinus.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummMinus.DescId = zc_MovementFloat_TotalSummMinus()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummAdd
                                    ON MovementFloat_TotalSummAdd.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummAdd.DescId = zc_MovementFloat_TotalSummAdd()

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()
          
            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                         ON MovementLinkObject_PersonalServiceList.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
            LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = MovementLinkObject_PersonalServiceList.ObjectId


            ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_PersonalService (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 11.09.14         *
 
*/

-- тест
--SELECT * FROM gpSelect_Movement_PersonalService (inStartDate:= '30.01.2014', inEndDate:= '01.02.2015', inIsErased := FALSE, inSession:= '2')