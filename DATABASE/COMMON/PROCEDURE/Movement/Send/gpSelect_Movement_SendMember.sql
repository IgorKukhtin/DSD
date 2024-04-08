-- Function: gpSelect_Movement_SendMember()

DROP FUNCTION IF EXISTS gpSelect_Movement_SendMember (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_SendMember(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inJuridicalBasisId  Integer , -- гл. юр.лицо
    IN inIsErased          Boolean ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat, TotalCountTare TFloat, TotalCountSh TFloat, TotalCountKg TFloat
             , FromId Integer, FromName TVarChar, ItemName_from TVarChar, ToId Integer, ToName TVarChar, ItemName_to TVarChar
             , DocumentKindId Integer, DocumentKindName TVarChar
             , Comment TVarChar
             , isAuto Boolean
             , InsertDate TDateTime, InsertName TVarChar
             , SubjectDocId Integer, SubjectDocName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId         Integer;
   DECLARE vbIsDocumentUser Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Send());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- проверка прав
     vbIsDocumentUser:= EXISTS (SELECT 1 FROM Object_RoleAccessKey_View AS View_RoleAccessKey WHERE View_RoleAccessKey.AccessKeyId = zc_Enum_Process_AccessKey_DocumentUser() AND View_RoleAccessKey.UserId = vbUserId);

     -- Результат
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
             Movement.Id                                    AS Id
           , Movement.InvNumber                             AS InvNumber
           , Movement.OperDate                              AS OperDate
           , Object_Status.ObjectCode                       AS StatusCode
           , Object_Status.ValueData                        AS StatusName
           , MovementFloat_TotalCount.ValueData             AS TotalCount
           , MovementFloat_TotalCountTare.ValueData         AS TotalCountTare
           , MovementFloat_TotalCountSh.ValueData           AS TotalCountSh
           , MovementFloat_TotalCountKg.ValueData           AS TotalCountKg
           , Object_From.Id                                 AS FromId
           , Object_From.ValueData                          AS FromName
           , ObjectDesc_from.ItemName                       AS ItemName_from
           , Object_To.Id                                   AS ToId
           , Object_To.ValueData                            AS ToName
           , ObjectDesc_to.ItemName                         AS ItemName_to
           , Object_DocumentKind.Id                         AS DocumentKindId
           , Object_DocumentKind.ValueData                  AS DocumentKindName

           , MovementString_Comment.ValueData       AS Comment

           , COALESCE(MovementBoolean_isAuto.ValueData, False) :: Boolean  AS isAuto

           , MovementDate_Insert.ValueData          AS InsertDate
           , Object_Insert.ValueData                AS InsertName

           , Object_SubjectDoc.Id                   AS SubjectDocId
           , Object_SubjectDoc.ValueData            AS SubjectDocName

       FROM (SELECT Movement.id
             FROM tmpStatus
                  JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate  AND Movement.DescId = zc_Movement_Send() AND Movement.StatusId = tmpStatus.StatusId
               -- JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
            ) AS tmpMovement

            LEFT JOIN Movement ON Movement.id = tmpMovement.id

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountTare
                                    ON MovementFloat_TotalCountTare.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountTare.DescId = zc_MovementFloat_TotalCountTare()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountSh
                                    ON MovementFloat_TotalCountSh.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                    ON MovementFloat_TotalCountKg.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()

            LEFT JOIN MovementBoolean AS MovementBoolean_isAuto
                                      ON MovementBoolean_isAuto.MovementId = Movement.Id
                                     AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId  

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            LEFT JOIN ObjectDesc AS ObjectDesc_from ON ObjectDesc_from.Id = Object_From.DescId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
            LEFT JOIN ObjectDesc AS ObjectDesc_to ON ObjectDesc_to.Id = Object_To.DescId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentKind
                                         ON MovementLinkObject_DocumentKind.MovementId = Movement.Id
                                        AND MovementLinkObject_DocumentKind.DescId = zc_MovementLinkObject_DocumentKind()
            LEFT JOIN Object AS Object_DocumentKind ON Object_DocumentKind.Id = MovementLinkObject_DocumentKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_SubjectDoc
                                         ON MovementLinkObject_SubjectDoc.MovementId = Movement.Id
                                        AND MovementLinkObject_SubjectDoc.DescId = zc_MovementLinkObject_SubjectDoc()
            LEFT JOIN Object AS Object_SubjectDoc ON Object_SubjectDoc.Id = MovementLinkObject_SubjectDoc.ObjectId

       WHERE (Object_To.DescId   IN (zc_Object_Member(), zc_Object_Car())
           OR Object_From.DescId IN (zc_Object_Member(), zc_Object_Car())
             )
         AND (vbIsDocumentUser = FALSE OR MLO_Insert.ObjectId = vbUserId)
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.02.19         * 
 28.11.17         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_SendMember (inStartDate:= '30.11.2017', inEndDate:= '30.11.2017', inJuridicalBasisId:=0, inIsErased := FALSE, inSession:= '2')
