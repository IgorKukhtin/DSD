-- Function: gpSelect_Movement_MemberHoliday()

-- DROP FUNCTION IF EXISTS gpSelect_Movement_MemberHoliday (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_MemberHoliday (TDateTime, TDateTime, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_MemberHoliday(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inIsErased          Boolean ,
    IN inJuridicalBasisId  Integer ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , OperDateStart TDateTime, OperDateEnd TDateTime
             , BeginDateStart TDateTime, BeginDateEnd TDateTime
             , MemberId Integer, MemberName TVarChar
             , MemberMainId Integer, MemberMainName TVarChar
             , InsertName TVarChar
             , UpdateName TVarChar
             , InsertDate TDateTime
             , UpdateDate TDateTime
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_MemberHoliday());
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
           , Object_Status.ObjectCode              AS StatusCode
           , Object_Status.ValueData               AS StatusName

           , MovementDate_OperDateStart.ValueData  AS OperDateStartDate
           , MovementDate_OperDateEnd.ValueData    AS OperDateEndDate
           , MovementDate_BeginDateStart.ValueData AS BeginDateStartDate
           , MovementDate_BeginDateEnd.ValueData   AS BeginDateEndDate

           , Object_Member.Id                      AS MemberId
           , Object_Member.ValueData               AS MemberName
           , Object_MemberMain.Id                  AS MemberMainId
           , Object_MemberMain.ValueData           AS MemberMainName

           , Object_Insert.ValueData               AS InsertName
           , Object_Update.ValueData               AS UpdateName
           , MovementDate_Insert.ValueData         AS InsertDate
           , MovementDate_Update.ValueData         AS UpdateDate

       FROM tmpStatus
            JOIN Movement ON Movement.DescId = zc_Movement_MemberHoliday()
                         AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                         AND Movement.StatusId = tmpStatus.StatusId
            LEFT JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                   ON MovementDate_OperDateStart.MovementId = Movement.Id
                                  AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()

            LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                   ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                  AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()

            LEFT JOIN MovementDate AS MovementDate_BeginDateStart
                                   ON MovementDate_BeginDateStart.MovementId = Movement.Id
                                  AND MovementDate_BeginDateStart.DescId = zc_MovementDate_BeginDateStart()

            LEFT JOIN MovementDate AS MovementDate_BeginDateEnd
                                   ON MovementDate_BeginDateEnd.MovementId = Movement.Id
                                  AND MovementDate_BeginDateEnd.DescId = zc_MovementDate_BeginDateEnd()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member
                                         ON MovementLinkObject_Member.MovementId = Movement.Id
                                        AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = MovementLinkObject_Member.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_MemberMain
                                         ON MovementLinkObject_MemberMain.MovementId = Movement.Id
                                        AND MovementLinkObject_MemberMain.DescId = zc_MovementLinkObject_MemberMain()
            LEFT JOIN Object AS Object_MemberMain ON Object_MemberMain.Id = MovementLinkObject_MemberMain.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                         ON MovementLinkObject_Insert.MovementId = Movement.Id
                                        AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementLinkObject_Insert.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Update
                                         ON MovementLinkObject_Update.MovementId = Movement.Id
                                        AND MovementLinkObject_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MovementLinkObject_Update.ObjectId
      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.12.18         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_MemberHoliday (inStartDate:= '30.10.2015', inEndDate:= '01.12.2015', inIsErased:=false, inJuridicalBasisId:= 0, inSession:= zfCalc_UserAdmin())
