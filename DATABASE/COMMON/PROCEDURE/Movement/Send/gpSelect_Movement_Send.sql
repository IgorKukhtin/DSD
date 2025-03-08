-- Function: gpSelect_Movement_Send()

DROP FUNCTION IF EXISTS gpSelect_Movement_Send (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Send(
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
             , isRePack Boolean
             , UnionName TVarChar
             , UnionDate TDateTime
             , InsertDate TDateTime, InsertName TVarChar
             , StatusInsertDate TDateTime, StatusInsertName TVarChar
             , MovementId_Send Integer, InvNumber_SendFull TVarChar
             , MovementId_Order Integer, OperDate_Order TDateTime, InvNumberOrder TVarChar
             , PartnerName_Order TVarChar
             , SubjectDocId Integer, SubjectDocName TVarChar
             , PersonalGroupId Integer, PersonalGroupName TVarChar
             , MovementId_Production Integer, InvNumber_ProductionFull TVarChar
              )
AS
$BODY$
   DECLARE vbUserId         Integer;
   DECLARE vbIsDocumentUser Boolean;
   DECLARE vbIsIrna Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Send());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- !!!Ирна!!!
     vbIsIrna:= zfCalc_User_isIrna (vbUserId);

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
        , tmpMovement AS (SELECT Movement.id
                          FROM tmpStatus
                               JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate  AND Movement.DescId = zc_Movement_Send() AND Movement.StatusId = tmpStatus.StatusId
                               LEFT JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                            ON MovementLinkObject_From.MovementId = Movement.Id
                                                           AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                               LEFT JOIN ObjectLink AS ObjectLink_Unit_Business_from
                                                    ON ObjectLink_Unit_Business_from.ObjectId = MovementLinkObject_From.ObjectId
                                                   AND ObjectLink_Unit_Business_from.DescId   = zc_ObjectLink_Unit_Business()
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                            ON MovementLinkObject_To.MovementId = Movement.Id
                                                           AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                               LEFT JOIN ObjectLink AS ObjectLink_Unit_Business_to
                                                    ON ObjectLink_Unit_Business_to.ObjectId = MovementLinkObject_To.ObjectId
                                                   AND ObjectLink_Unit_Business_to.DescId   = zc_ObjectLink_Unit_Business()
                          WHERE (tmpRoleAccessKey.AccessKeyId > 0
                              OR vbIsIrna IS NULL
                              OR (vbIsIrna = TRUE  AND ObjectLink_Unit_Business_from.ChildObjectId = zc_Business_Irna())
                              OR (vbIsIrna = TRUE  AND ObjectLink_Unit_Business_to.ChildObjectId   = zc_Business_Irna())
                                )
                         )
        , tmpMLM AS (SELECT MovementLinkMovement.*
                     FROM MovementLinkMovement
                     WHERE MovementLinkMovement.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                       AND MovementLinkMovement.DescId IN (zc_MovementLinkMovement_Send()
                                                         , zc_MovementLinkMovement_Order())
                     )

        , tmpMLM_Production AS (SELECT MovementLinkMovement.*
                                     , ROW_NUMBER() OVER (PARTITION BY MovementLinkMovement.MovementChildId ORDER BY MovementLinkMovement.MovementId DESC) AS Ord
                                FROM MovementLinkMovement
                                WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Production()
                                  AND MovementLinkMovement.MovementChildId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                               )

       SELECT
             Movement.Id                                    AS Id
           , Movement.InvNumber                             AS InvNumber
           , Movement.OperDate                              AS OperDate
           , zfCalc_StatusCode_next (Movement.StatusId, Movement.StatusId_next)                          ::Integer  AS StatusCode
           , zfCalc_StatusName_next (Object_Status.ValueData, Movement.StatusId, Movement.StatusId_next) ::TVarChar AS StatusName
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

           , COALESCE(MovementBoolean_isAuto.ValueData, False)    :: Boolean  AS isAuto
           , COALESCE (MovementBoolean_isRePack.ValueData, FALSE) :: Boolean  AS isRePack

           , Object_Union.ValueData                 AS UnionName
           , MovementDate_Union.ValueData           AS UnionDate
           
           , MovementDate_Insert.ValueData          AS InsertDate
           , Object_Insert.ValueData                AS InsertName

           , MovementDate_StatusInsert.ValueData    AS StatusInsertDate
           , Object_StatusInsert.ValueData          AS StatusInsertName

           , COALESCE(Movement_Send.Id, -1)                         AS MovementId_Send
           , COALESCE(CASE WHEN Movement_Send.StatusId = zc_Enum_Status_Erased()
                       THEN '***'
                   WHEN Movement_Send.StatusId = zc_Enum_Status_UnComplete()
                       THEN '*'
                   ELSE ''
              END
           || zfCalc_PartionMovementName (Movement_Send.DescId, MovementDesc_Send.ItemName, Movement_Send.InvNumber, Movement_Send.OperDate)
             , ' ')                     :: TVarChar      AS InvNumber_SendFull

           -- заявка
           , MovementLinkMovement_Order.MovementChildId         AS MovementId_Order
           , Movement_Order.OperDate    :: TDateTime            AS OperDate_Order
           , CASE WHEN MovementLinkMovement_Order.MovementChildId IS NOT NULL
                  THEN CASE WHEN Movement_Order.StatusId IN (zc_Enum_Status_Complete())
                                 THEN ''
                            ELSE '???'
                       END
                    || Movement_Order.InvNumber
             END                                    :: TVarChar AS InvNumberOrder
           , Object_From_order.ValueData                        AS PartnerName_order
           
           , Object_SubjectDoc.Id                               AS SubjectDocId
           , Object_SubjectDoc.ValueData                        AS SubjectDocName

           , Object_PersonalGroup.Id                            AS PersonalGroupId
           , Object_PersonalGroup.ValueData                     AS PersonalGroupName
          
           , COALESCE(Movement_Production.Id, -1)               AS MovementId_Production
           , COALESCE(CASE WHEN Movement_Production.StatusId = zc_Enum_Status_Erased()
                       THEN '***'
                   WHEN Movement_Production.StatusId = zc_Enum_Status_UnComplete()
                       THEN '*'
                   ELSE ''
              END
           || zfCalc_PartionMovementName (Movement_Production.DescId, MovementDesc_Production.ItemName, Movement_Production.InvNumber, Movement_Production.OperDate)
             , ' ')                     :: TVarChar             AS InvNumber_ProductionFull

       FROM tmpMovement

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
            LEFT JOIN MovementBoolean AS MovementBoolean_isRePack
                                      ON MovementBoolean_isRePack.MovementId = Movement.Id
                                     AND MovementBoolean_isRePack.DescId = zc_MovementBoolean_isRePack()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

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

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Union
                                         ON MovementLinkObject_Union.MovementId = Movement.Id
                                        AND MovementLinkObject_Union.DescId = zc_MovementLinkObject_Union()
            LEFT JOIN Object AS Object_Union ON Object_Union.Id = MovementLinkObject_Union.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_SubjectDoc
                                         ON MovementLinkObject_SubjectDoc.MovementId = Movement.Id
                                        AND MovementLinkObject_SubjectDoc.DescId = zc_MovementLinkObject_SubjectDoc()
            LEFT JOIN Object AS Object_SubjectDoc ON Object_SubjectDoc.Id = MovementLinkObject_SubjectDoc.ObjectId

            LEFT JOIN MovementDate AS MovementDate_Union 
                                   ON MovementDate_Union.MovementId = Movement.Id
                                  AND MovementDate_Union.DescId = zc_MovementDate_Union()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

            LEFT JOIN MovementDate AS MovementDate_StatusInsert
                                   ON MovementDate_StatusInsert.MovementId = Movement.Id
                                  AND MovementDate_StatusInsert.DescId = zc_MovementDate_StatusInsert()
            LEFT JOIN MovementLinkObject AS MLO_StatusInsert
                                         ON MLO_StatusInsert.MovementId = Movement.Id
                                        AND MLO_StatusInsert.DescId = zc_MovementLinkObject_StatusInsert()
            LEFT JOIN Object AS Object_StatusInsert ON Object_StatusInsert.Id = MLO_StatusInsert.ObjectId

            LEFT JOIN tmpMLM AS MovementLinkMovement_Send
                             ON MovementLinkMovement_Send.MovementId = Movement.Id
                            AND MovementLinkMovement_Send.DescId     = zc_MovementLinkMovement_Send()
            LEFT JOIN Movement AS Movement_Send ON Movement_Send.Id = COALESCE (MovementLinkMovement_Send.MovementChildId, Movement.ParentId)
            LEFT JOIN MovementDesc AS MovementDesc_Send ON MovementDesc_Send.Id = Movement_Send.DescId

            --заявка
            LEFT JOIN tmpMLM AS MovementLinkMovement_Order
                             ON MovementLinkMovement_Order.MovementId = Movement.Id
                            AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
            LEFT JOIN Movement AS Movement_Order ON Movement_Order.Id = MovementLinkMovement_Order.MovementChildId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From_order
                                         ON MovementLinkObject_From_order.MovementId = MovementLinkMovement_Order.MovementChildId
                                        AND MovementLinkObject_From_order.DescId     = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From_order ON Object_From_order.Id = MovementLinkObject_From_order.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalGroup
                                         ON MovementLinkObject_PersonalGroup.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalGroup.DescId = zc_MovementLinkObject_PersonalGroup()
            LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = MovementLinkObject_PersonalGroup.ObjectId

            LEFT JOIN tmpMLM_Production AS MovementLinkMovement_Production
                                        ON MovementLinkMovement_Production.MovementChildId = Movement.Id
                                       AND MovementLinkMovement_Production.DescId          = zc_MovementLinkMovement_Production()
                                       AND MovementLinkMovement_Production.Ord             = 1
            LEFT JOIN Movement AS Movement_Production ON Movement_Production.Id = MovementLinkMovement_Production.MovementId
            LEFT JOIN MovementDesc AS MovementDesc_Production ON MovementDesc_Production.Id = Movement_Production.DescId

       WHERE (vbIsDocumentUser = FALSE OR MLO_Insert.ObjectId = vbUserId)
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 17.07.24         *
 19.04.23         * StatusInsert....
 09.12.22         * add MovementId_Production
 04.10.19         *
 27.02.19         * 
 03.10.17         add Comment
 05.10.16         * add inJuridicalBasisId
 14.07.16         *
 17.06.16         *
 22.05.14                                                        *
 12.07.13         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Send (inStartDate:= '30.11.2022', inEndDate:= '30.11.2022', inJuridicalBasisId:=0, inIsErased := FALSE, inSession:= '2')
