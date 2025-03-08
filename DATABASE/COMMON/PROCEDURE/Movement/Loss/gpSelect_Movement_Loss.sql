-- Function: gpSelect_Movement_Loss()

DROP FUNCTION IF EXISTS gpSelect_Movement_Loss (TDateTime, TDateTime, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Loss(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inIsErased          Boolean ,
    IN inJuridicalBasisId  Integer ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat, TotalCountSh TFloat, TotalCountKg TFloat
             , FromId Integer, FromName TVarChar, ItemName_from TVarChar
             , ToId Integer, ToName TVarChar, ItemName_to TVarChar
             , ArticleLossId Integer, ArticleLossName TVarChar
             , Comment TVarChar
             , CheckedName   TVarChar
             , CheckedDate   TDateTime
             , Checked       Boolean
             , MovementId_Income Integer, InvNumber_IncomeFull TVarChar 
             , MovementId_Production Integer, InvNumber_ProductionFull TVarChar
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsIrna Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Loss());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     -- !!!Ирна!!!
     vbIsIrna:= zfCalc_User_isIrna (vbUserId);


     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        , tmpUserAdmin AS (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId)
        , tmpRoleAccessKey AS (SELECT DISTINCT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId AND NOT EXISTS (SELECT UserId FROM tmpUserAdmin)
                         UNION SELECT DISTINCT AccessKeyId FROM Object_RoleAccessKey_View WHERE EXISTS (SELECT 1 FROM tmpUserAdmin)
                                                                                             OR EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE UserId = vbUserId AND AccessKeyId = zc_Enum_Process_AccessKey_DocumentAll())
                              )

       SELECT
             Movement.Id                             AS Id
           , Movement.InvNumber                      AS InvNumber
           , Movement.OperDate                       AS OperDate
           , zfCalc_StatusCode_next (Movement.StatusId, Movement.StatusId_next)                          ::Integer  AS StatusCode
           , zfCalc_StatusName_next (Object_Status.ValueData, Movement.StatusId, Movement.StatusId_next) ::TVarChar AS StatusName
           , MovementFloat_TotalCount.ValueData      AS TotalCount
           , MovementFloat_TotalCountSh.ValueData    AS TotalCountSh
           , MovementFloat_TotalCountKg.ValueData    AS TotalCountKg
           , Object_From.Id                          AS FromId
           , Object_From.ValueData                   AS FromName
           , ObjectDesc_from.ItemName                AS ItemName_from
           , Object_To.Id                            AS ToId
           , (Object_To.ValueData || CASE WHEN Object_Unit_CarTo.ValueData <> '' THEN ' (' || Object_Unit_CarTo.ValueData ||')' ELSE '' END) :: TVarChar AS ToName
           , ObjectDesc_to.ItemName                  AS ItemName_to
           , Object_ArticleLoss.Id                   AS ArticleLossId
           , Object_ArticleLoss.ValueData            AS ArticleLossName

           , MovementString_Comment.ValueData        AS Comment

           , Object_Checked.ValueData                AS CheckedName
           , MovementDate_Checked.ValueData          AS CheckedDate

           , COALESCE (MovementBoolean_Checked.ValueData, FALSE) AS Checked

           , COALESCE (Movement_Income.Id, -1)       AS MovementId_Income
           , zfCalc_PartionMovementName (Movement_Income.DescId, MovementDesc_Income.ItemName, Movement_Income.InvNumber, Movement_Income.OperDate) :: TVarChar AS InvNumber_IncomeFull

           , COALESCE(Movement_Production.Id, -1)               AS MovementId_Production
           , COALESCE(CASE WHEN Movement_Production.StatusId = zc_Enum_Status_Erased()
                       THEN '***'
                   WHEN Movement_Production.StatusId = zc_Enum_Status_UnComplete()
                       THEN '*'
                   ELSE ''
              END
           || zfCalc_PartionMovementName (Movement_Production.DescId, MovementDesc_Production.ItemName, Movement_Production.InvNumber, Movement_Production.OperDate)
             , ' ')                     :: TVarChar             AS InvNumber_ProductionFull
       FROM (SELECT Movement.id
             FROM tmpStatus
                  JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate  AND Movement.DescId = zc_Movement_Loss() AND Movement.StatusId = tmpStatus.StatusId
                  LEFT JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
                  LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                               ON MovementLinkObject_From.MovementId = Movement.Id
                                              AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                  LEFT JOIN ObjectLink AS ObjectLink_Unit_Business_from
                                       ON ObjectLink_Unit_Business_from.ObjectId = MovementLinkObject_From.ObjectId
                                      AND ObjectLink_Unit_Business_from.DescId   = zc_ObjectLink_Unit_Business()
             WHERE (tmpRoleAccessKey.AccessKeyId > 0
                 OR vbIsIrna IS NULL
                 OR (vbIsIrna = TRUE  AND ObjectLink_Unit_Business_from.ChildObjectId = zc_Business_Irna())
                   )
            ) AS tmpMovement

            LEFT JOIN Movement ON Movement.id = tmpMovement.id

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountSh
                                    ON MovementFloat_TotalCountSh.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                    ON MovementFloat_TotalCountKg.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()

            LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                      ON MovementBoolean_Checked.MovementId = Movement.Id
                                     AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementDate AS MovementDate_Checked
                                   ON MovementDate_Checked.MovementId = Movement.Id
                                  AND MovementDate_Checked.DescId = zc_MovementDate_Checked()

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

            LEFT JOIN ObjectLink AS ObjectLink_CarTo_Unit
                                 ON ObjectLink_CarTo_Unit.ObjectId = MovementLinkObject_To.ObjectId
                                AND ObjectLink_CarTo_Unit.DescId = zc_ObjectLink_Car_Unit()
            LEFT JOIN Object AS Object_Unit_CarTo ON Object_Unit_CarTo.Id = ObjectLink_CarTo_Unit.ChildObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ArticleLoss
                                         ON MovementLinkObject_ArticleLoss.MovementId = Movement.Id
                                        AND MovementLinkObject_ArticleLoss.DescId = zc_MovementLinkObject_ArticleLoss()
            LEFT JOIN Object AS Object_ArticleLoss ON Object_ArticleLoss.Id = MovementLinkObject_ArticleLoss.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Checked
                                         ON MovementLinkObject_Checked.MovementId = Movement.Id
                                        AND MovementLinkObject_Checked.DescId = zc_MovementLinkObject_Checked()
            LEFT JOIN Object AS Object_Checked ON Object_Checked.Id = MovementLinkObject_Checked.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Income
                                           ON MovementLinkMovement_Income.MovementId = Movement.Id
                                          AND MovementLinkMovement_Income.DescId     = zc_MovementLinkMovement_Income()
            LEFT JOIN Movement AS Movement_Income ON Movement_Income.Id = MovementLinkMovement_Income.MovementChildId
            LEFT JOIN MovementDesc AS MovementDesc_Income ON MovementDesc_Income.Id = Movement_Income.DescId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Production
                                           ON MovementLinkMovement_Production.MovementChildId = Movement.Id
                                          AND MovementLinkMovement_Production.DescId          = zc_MovementLinkMovement_Production()
            LEFT JOIN Movement AS Movement_Production ON Movement_Production.Id = MovementLinkMovement_Production.MovementId
            LEFT JOIN MovementDesc AS MovementDesc_Production ON MovementDesc_Production.Id = Movement_Production.DescId

       -- огр. просмотра
       WHERE vbUserId <> 300550 -- Рибалко Вікторія Віталіївна
         AND vbUserId <> 929721 -- Решетова И.А.
         AND COALESCE (Movement_Production.StatusId, 0) <> zc_Enum_Status_Erased()

      UNION ALL
       SELECT
             Movement.Id                             AS Id
           , Movement.InvNumber                      AS InvNumber
           , Movement.OperDate                       AS OperDate
           , Object_Status.ObjectCode                AS StatusCode
           , Object_Status.ValueData                 AS StatusName
           , MovementFloat_TotalCount.ValueData      AS TotalCount
           , MovementFloat_TotalCountSh.ValueData    AS TotalCountSh
           , MovementFloat_TotalCountKg.ValueData    AS TotalCountKg
           , Object_From.Id                          AS FromId
           , Object_From.ValueData                   AS FromName
           , ObjectDesc_from.ItemName                AS ItemName_from
           , Object_To.Id                            AS ToId
           , (Object_To.ValueData || CASE WHEN Object_Unit_CarTo.ValueData <> '' THEN ' (' || Object_Unit_CarTo.ValueData ||')' ELSE '' END) :: TVarChar AS ToName
           , ObjectDesc_to.ItemName                  AS ItemName_to
           , Object_ArticleLoss.Id                   AS ArticleLossId
           , Object_ArticleLoss.ValueData            AS ArticleLossName
                                                     
           , MovementString_Comment.ValueData        AS Comment
                                                     
           , Object_Checked.ValueData                AS CheckedName
           , MovementDate_Checked.ValueData          AS CheckedDate

           , COALESCE (MovementBoolean_Checked.ValueData, FALSE) AS Checked

           , COALESCE(Movement_Income.Id, -1)                         AS MovementId_Income
           , zfCalc_PartionMovementName (Movement_Income.DescId, MovementDesc_Income.ItemName, Movement_Income.InvNumber, Movement_Income.OperDate) :: TVarChar      AS InvNumber_IncomeFull

           , COALESCE(Movement_Production.Id, -1)               AS MovementId_Production
           , COALESCE(CASE WHEN Movement_Production.StatusId = zc_Enum_Status_Erased()
                       THEN '***'
                   WHEN Movement_Production.StatusId = zc_Enum_Status_UnComplete()
                       THEN '*'
                   ELSE ''
              END
           || zfCalc_PartionMovementName (Movement_Production.DescId, MovementDesc_Production.ItemName, Movement_Production.InvNumber, Movement_Production.OperDate)
             , ' ')                     :: TVarChar             AS InvNumber_ProductionFull
       FROM (SELECT Movement.id
             FROM tmpStatus
                  JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate  AND Movement.DescId = zc_Movement_Loss() AND Movement.StatusId = tmpStatus.StatusId
                  JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
            ) AS tmpMovement

            LEFT JOIN Movement ON Movement.id = tmpMovement.id

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountSh
                                    ON MovementFloat_TotalCountSh.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                    ON MovementFloat_TotalCountKg.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()

            LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                      ON MovementBoolean_Checked.MovementId = Movement.Id
                                     AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementDate AS MovementDate_Checked
                                   ON MovementDate_Checked.MovementId = Movement.Id
                                  AND MovementDate_Checked.DescId = zc_MovementDate_Checked()

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

            LEFT JOIN ObjectLink AS ObjectLink_CarTo_Unit
                                 ON ObjectLink_CarTo_Unit.ObjectId = MovementLinkObject_To.ObjectId
                                AND ObjectLink_CarTo_Unit.DescId = zc_ObjectLink_Car_Unit()
            LEFT JOIN Object AS Object_Unit_CarTo ON Object_Unit_CarTo.Id = ObjectLink_CarTo_Unit.ChildObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ArticleLoss
                                         ON MovementLinkObject_ArticleLoss.MovementId = Movement.Id
                                        AND MovementLinkObject_ArticleLoss.DescId = zc_MovementLinkObject_ArticleLoss()
            LEFT JOIN Object AS Object_ArticleLoss ON Object_ArticleLoss.Id = MovementLinkObject_ArticleLoss.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Checked
                                         ON MovementLinkObject_Checked.MovementId = Movement.Id
                                        AND MovementLinkObject_Checked.DescId = zc_MovementLinkObject_Checked()
            LEFT JOIN Object AS Object_Checked ON Object_Checked.Id = MovementLinkObject_Checked.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Income
                                           ON MovementLinkMovement_Income.MovementId = Movement.Id
                                          AND MovementLinkMovement_Income.DescId     = zc_MovementLinkMovement_Income()
            LEFT JOIN Movement AS Movement_Income ON Movement_Income.Id = MovementLinkMovement_Income.MovementChildId
            LEFT JOIN MovementDesc AS MovementDesc_Income ON MovementDesc_Income.Id = Movement_Income.DescId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Production
                                           ON MovementLinkMovement_Production.MovementChildId = Movement.Id
                                          AND MovementLinkMovement_Production.DescId          = zc_MovementLinkMovement_Production()
            LEFT JOIN Movement AS Movement_Production ON Movement_Production.Id = MovementLinkMovement_Production.MovementId
            LEFT JOIN MovementDesc AS MovementDesc_Production ON MovementDesc_Production.Id = Movement_Production.DescId
       -- огр. просмотра - Рибалко Вікторія Віталіївна
       WHERE ((vbUserId = 300550
           AND Object_From.Id IN (8447   -- цех колбасный
                                , 8448   -- ЦЕХ деликатесов
                                , 8449   -- цех с/к
                                 )
              )
          OR (vbUserId        = 929721 -- Решетова И.А.
          AND Object_From.Id = 8459   -- Склад Реализации
             )
            )
          AND COALESCE (Movement_Production.StatusId, 0) <> zc_Enum_Status_Erased()
          ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_Movement_Loss (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 13.12.22         * add MovementId_Production
 11.10.18         *
 27.03.17         *
 05.10.16         * add inJuridicalBasisId
 02.09.14                                                        *
 26.05.14                                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Loss (inStartDate:= '30.01.2014', inEndDate:= '01.02.2014', inIsErased := FALSE, inJuridicalBasisId:= zc_Juridical_Basis(), inSession:= zfCalc_UserAdmin())
