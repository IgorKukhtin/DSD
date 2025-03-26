-- Function: gpSelect_Scale_MovementCeh()

-- DROP FUNCTION IF EXISTS gpSelect_Scale_MovementCeh (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Scale_MovementCeh (TDateTime, TDateTime, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Scale_MovementCeh(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inIsComlete   Boolean ,
    IN inBranchCode  Integer   , --
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , MovementId_parent Integer, OperDate_parent TDateTime, InvNumber_parent TVarChar, StatusCode_parent Integer, StatusName_parent TVarChar
             , StartWeighing TDateTime, EndWeighing TDateTime, EndWeighing_calc TDateTime
             , MovementDescNumber Integer, MovementDescId Integer, MovementDescName TVarChar
             , WeighingNumber TFloat
             , PartionGoods TVarChar
             , isProductionIn Boolean
             , TotalCount TFloat, TotalCountTare TFloat
             , FromName TVarChar, ToName TVarChar
             , DocumentKindName TVarChar
             , SubjectDocName TVarChar
             , Comment TVarChar
             , UserName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Scale_MovementCeh());
     vbUserId:= lpGetUserBySession (inSession);


     -- !!!временно!!! менется параметр
     IF EXISTS (SELECT ObjectLink_UserRole_View.UserId FROM ObjectLink_UserRole_View WHERE RoleId IN (zc_Enum_Role_Admin(), 428386, 447972) AND ObjectLink_UserRole_View.UserId = vbUserId) -- Руководитель склад ГП Днепр + Просмотр СБ
        OR vbUserId = 343013 -- Нагорная Я.Г.
     THEN vbUserId:= 0;
     END IF;


     -- Результат
     RETURN QUERY
     /*WITH tmpUserAdmin AS (SELECT ObjectLink_UserRole_View.UserId FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND ObjectLink_UserRole_View.UserId = vbUserId)
        , tmpRoleAccessKey AS (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE Object_RoleAccessKey_View.UserId = vbUserId AND NOT EXISTS (SELECT tmpUserAdmin.UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
                         UNION SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE EXISTS (SELECT tmpUserAdmin.UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
                              )*/
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId WHERE inIsComlete = TRUE OR vbUserId = 5
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         )
       -- Результат
       SELECT  Movement.Id
             , zfConvert_StringToNumber (Movement.InvNumber)  AS InvNumber
             , Movement.OperDate
             , Object_Status.ObjectCode          AS StatusCode
             , Object_Status.ValueData           AS StatusName


             , Movement_Parent.Id                AS MovementId_parent
             , Movement_Parent.OperDate          AS OperDate_parent
             , CASE WHEN Movement_Parent.StatusId = zc_Enum_Status_Complete()
                         THEN Movement_Parent.InvNumber
                    WHEN Movement_Parent.StatusId = zc_Enum_Status_UnComplete()
                         THEN '***' || Movement_Parent.InvNumber
                    WHEN Movement_Parent.StatusId = zc_Enum_Status_Erased()
                         THEN '*' || Movement_Parent.InvNumber
                    ELSE ''
               END :: TVarChar AS InvNumber_parent
             , Object_Status_parent.ObjectCode          AS StatusCode_parent
             , Object_Status_parent.ValueData           AS StatusName_parent

             , MovementDate_StartWeighing.ValueData  AS StartWeighing
             , MovementDate_EndWeighing.ValueData    AS EndWeighing
             , COALESCE (MovementDate_EndWeighing.ValueData, MovementDate_StartWeighing.ValueData) AS EndWeighing_calc

             , MovementFloat_MovementDescNumber.ValueData :: Integer AS MovementDescNumber
             , MovementDesc.Id                            AS MovementDescId
             , MovementDesc.ItemName                      AS MovementDescName
             , MovementFloat_WeighingNumber.ValueData     AS WeighingNumber

             , MovementString_PartionGoods.ValueData      AS PartionGoods
             , MovementBoolean_isIncome.ValueData         AS isProductionIn

             , MovementFloat_TotalCount.ValueData         AS TotalCount
             , MovementFloat_TotalCountTare.ValueData     AS TotalCountTare

             , Object_From.ValueData              AS FromName
             , Object_To.ValueData                AS ToName

             , Object_DocumentKind.ValueData      AS DocumentKindName
             , Object_SubjectDoc.ValueData        AS SubjectDocName

             , MovementString_Comment.ValueData   AS Comment

             , Object_User.ValueData              AS UserName

       FROM tmpStatus
            JOIN Movement ON Movement.DescId IN (zc_Movement_WeighingProduction())
                         AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                         AND Movement.StatusId = tmpStatus.StatusId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN Movement AS Movement_Parent ON Movement_Parent.Id = Movement.ParentId
            LEFT JOIN Object AS Object_Status_parent ON Object_Status_parent.Id = Movement_Parent.StatusId

            LEFT JOIN MovementBoolean AS MovementBoolean_isIncome
                                      ON MovementBoolean_isIncome.MovementId =  Movement.Id
                                     AND MovementBoolean_isIncome.DescId = zc_MovementBoolean_isIncome()

            LEFT JOIN MovementDate AS MovementDate_StartWeighing
                                   ON MovementDate_StartWeighing.MovementId =  Movement.Id
                                  AND MovementDate_StartWeighing.DescId = zc_MovementDate_StartWeighing()
            LEFT JOIN MovementDate AS MovementDate_EndWeighing
                                   ON MovementDate_EndWeighing.MovementId =  Movement.Id
                                  AND MovementDate_EndWeighing.DescId = zc_MovementDate_EndWeighing()

            LEFT JOIN MovementFloat AS MovementFloat_MovementDescNumber
                                    ON MovementFloat_MovementDescNumber.MovementId =  Movement.Id
                                   AND MovementFloat_MovementDescNumber.DescId = zc_MovementFloat_MovementDescNumber()
            LEFT JOIN MovementFloat AS MovementFloat_MovementDesc
                                    ON MovementFloat_MovementDesc.MovementId =  Movement.Id
                                   AND MovementFloat_MovementDesc.DescId = zc_MovementFloat_MovementDesc()
            LEFT JOIN MovementDesc ON MovementDesc.Id = MovementFloat_MovementDesc.ValueData

            LEFT JOIN MovementFloat AS MovementFloat_WeighingNumber
                                    ON MovementFloat_WeighingNumber.MovementId =  Movement.Id
                                   AND MovementFloat_WeighingNumber.DescId = zc_MovementFloat_WeighingNumber()

            LEFT JOIN MovementString AS MovementString_PartionGoods
                                     ON MovementString_PartionGoods.MovementId =  Movement.Id
                                    AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()
            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId =  Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountTare
                                    ON MovementFloat_TotalCountTare.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountTare.DescId = zc_MovementFloat_TotalCountTare()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentKind
                                         ON MovementLinkObject_DocumentKind.MovementId = Movement.Id
                                        AND MovementLinkObject_DocumentKind.DescId = zc_MovementLinkObject_DocumentKind()
            LEFT JOIN Object AS Object_DocumentKind ON Object_DocumentKind.Id = MovementLinkObject_DocumentKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_SubjectDoc
                                         ON MovementLinkObject_SubjectDoc.MovementId = Movement.Id
                                        AND MovementLinkObject_SubjectDoc.DescId     = zc_MovementLinkObject_SubjectDoc()
            LEFT JOIN Object AS Object_SubjectDoc ON Object_SubjectDoc.Id = MovementLinkObject_SubjectDoc.ObjectId

            INNER JOIN MovementLinkObject AS MovementLinkObject_User
                                          ON MovementLinkObject_User.MovementId = Movement.Id
                                         AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
                                         AND (MovementLinkObject_User.ObjectId = vbUserId OR vbUserId = 0
                                            OR (MovementLinkObject_From.ObjectId = zc_Unit_RK()
                                            AND MovementLinkObject_To.ObjectId   = 8451 -- ЦЕХ упаковки
                                            AND inIsComlete                      = TRUE
                                            AND inBranchCode                     = 101
                                            AND inIsComlete                      = TRUE
                                            AND Movement.StatusId                = zc_Enum_Status_Complete()
                                               )
                                             )
            LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_User.ObjectId

      UNION ALL

       SELECT  Movement.Id
             , zfConvert_StringToNumber (Movement.InvNumber)  AS InvNumber
             , Movement.OperDate
             , Object_Status.ObjectCode          AS StatusCode
             , Object_Status.ValueData           AS StatusName


             , Movement_Parent.Id                AS MovementId_parent
             , Movement_Parent.OperDate          AS OperDate_parent
             , CASE WHEN Movement_Parent.StatusId = zc_Enum_Status_Complete()
                         THEN Movement_Parent.InvNumber
                    WHEN Movement_Parent.StatusId = zc_Enum_Status_UnComplete()
                         THEN '***' || Movement_Parent.InvNumber
                    WHEN Movement_Parent.StatusId = zc_Enum_Status_Erased()
                         THEN '*' || Movement_Parent.InvNumber
                    ELSE ''
               END :: TVarChar AS InvNumber_parent
             , Object_Status_parent.ObjectCode          AS StatusCode_parent
             , Object_Status_parent.ValueData           AS StatusName_parent

             , MovementDate_StartWeighing.ValueData  AS StartWeighing
             , MovementDate_EndWeighing.ValueData    AS EndWeighing
             , COALESCE (MovementDate_EndWeighing.ValueData, MovementDate_StartWeighing.ValueData) AS EndWeighing_calc

             , MovementFloat_MovementDescNumber.ValueData :: Integer AS MovementDescNumber
             , MovementDesc.Id                            AS MovementDescId
             , MovementDesc.ItemName                      AS MovementDescName
             , MovementFloat_WeighingNumber.ValueData     AS WeighingNumber

             , MovementString_PartionGoods.ValueData      AS PartionGoods
             , MovementBoolean_isIncome.ValueData         AS isProductionIn

             , MovementFloat_TotalCount.ValueData         AS TotalCount
             , MovementFloat_TotalCountTare.ValueData     AS TotalCountTare

             , Object_From.ValueData              AS FromName
             , Object_To.ValueData                AS ToName

             , Object_DocumentKind.ValueData      AS DocumentKindName
             , Object_SubjectDoc.ValueData        AS SubjectDocName

             , MovementString_Comment.ValueData   AS Comment

             , Object_User.ValueData              AS UserName

       FROM tmpStatus
            JOIN Movement ON Movement.DescId IN (zc_Movement_WeighingPartner())
                         AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                         AND Movement.StatusId = tmpStatus.StatusId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN Movement AS Movement_Parent ON Movement_Parent.Id = Movement.ParentId
            LEFT JOIN Object AS Object_Status_parent ON Object_Status_parent.Id = Movement_Parent.StatusId

            LEFT JOIN MovementBoolean AS MovementBoolean_isIncome
                                      ON MovementBoolean_isIncome.MovementId =  Movement.Id
                                     AND MovementBoolean_isIncome.DescId = zc_MovementBoolean_isIncome()

            LEFT JOIN MovementDate AS MovementDate_StartWeighing
                                   ON MovementDate_StartWeighing.MovementId =  Movement.Id
                                  AND MovementDate_StartWeighing.DescId = zc_MovementDate_StartWeighing()
            LEFT JOIN MovementDate AS MovementDate_EndWeighing
                                   ON MovementDate_EndWeighing.MovementId =  Movement.Id
                                  AND MovementDate_EndWeighing.DescId = zc_MovementDate_EndWeighing()

            LEFT JOIN MovementFloat AS MovementFloat_MovementDescNumber
                                    ON MovementFloat_MovementDescNumber.MovementId =  Movement.Id
                                   AND MovementFloat_MovementDescNumber.DescId = zc_MovementFloat_MovementDescNumber()
            LEFT JOIN MovementFloat AS MovementFloat_MovementDesc
                                    ON MovementFloat_MovementDesc.MovementId =  Movement.Id
                                   AND MovementFloat_MovementDesc.DescId = zc_MovementFloat_MovementDesc()
            LEFT JOIN MovementDesc ON MovementDesc.Id = MovementFloat_MovementDesc.ValueData

            LEFT JOIN MovementFloat AS MovementFloat_WeighingNumber
                                    ON MovementFloat_WeighingNumber.MovementId =  Movement.Id
                                   AND MovementFloat_WeighingNumber.DescId = zc_MovementFloat_WeighingNumber()

            LEFT JOIN MovementString AS MovementString_PartionGoods
                                     ON MovementString_PartionGoods.MovementId =  Movement.Id
                                    AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()
            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId =  Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountTare
                                    ON MovementFloat_TotalCountTare.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountTare.DescId = zc_MovementFloat_TotalCountTare()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentKind
                                         ON MovementLinkObject_DocumentKind.MovementId = Movement.Id
                                        AND MovementLinkObject_DocumentKind.DescId = zc_MovementLinkObject_DocumentKind()
            LEFT JOIN Object AS Object_DocumentKind ON Object_DocumentKind.Id = MovementLinkObject_DocumentKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_SubjectDoc
                                         ON MovementLinkObject_SubjectDoc.MovementId = Movement.Id
                                        AND MovementLinkObject_SubjectDoc.DescId     = zc_MovementLinkObject_SubjectDoc()
            LEFT JOIN Object AS Object_SubjectDoc ON Object_SubjectDoc.Id = MovementLinkObject_SubjectDoc.ObjectId

            INNER JOIN MovementLinkObject AS MovementLinkObject_User
                                          ON MovementLinkObject_User.MovementId = Movement.Id
                                         AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
                                         AND (MovementLinkObject_User.ObjectId = vbUserId OR vbUserId = 0
                                            OR (MovementLinkObject_From.ObjectId = 8459 -- Розподільчий комплекс
                                            AND MovementLinkObject_To.ObjectId   = 8451 -- ЦЕХ упаковки
                                            AND inIsComlete                      = TRUE
                                            AND inBranchCode                     = 101
                                               )
                                             )
            LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_User.ObjectId

       WHERE inBranchCode = 101 AND MovementDesc.Id = zc_Movement_Send()
         AND Object_From.Id = zc_Unit_RK()
         AND inIsComlete = TRUE
         AND Movement.StatusId = zc_Enum_Status_Complete()

       ORDER BY 13 DESC
              , 11 DESC
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 12.06.15                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Scale_MovementCeh (inStartDate:= '01.05.2016', inEndDate:= '01.05.2016', inIsComlete:= TRUE, inBranchCode:= 101, inSession:= zfCalc_UserAdmin())
