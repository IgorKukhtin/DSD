-- Function: gpSelect_Movement_ProductionUnion()

-- DROP FUNCTION IF EXISTS gpSelect_Movement_ProductionUnion (TDateTime, TDateTime, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_ProductionUnion (TDateTime, TDateTime, Boolean, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ProductionUnion(
    IN inStartDate         TDateTime,
    IN inEndDate           TDateTime,
    IN inIsErased          Boolean  ,
    IN inIsPeresort        Boolean  ,     -- пересорт
    IN inJuridicalBasisId  Integer ,
    IN inSession           TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat, TotalCountChild TFloat
             , FromId Integer, FromName TVarChar, ItemName_from TVarChar, ToId Integer, ToName TVarChar, ItemName_to TVarChar
             , DocumentKindId Integer, DocumentKindName TVarChar
             , SubjectDocId Integer, SubjectDocName TVarChar
             , isAuto Boolean, InsertDate TDateTime
             , MovementId_Production Integer, InvNumber_ProductionFull TVarChar
             , MovementId_Peresort Integer, InvNumber_PeresortFull TVarChar
             , MovementId_Order Integer, InvNumber_Order_Full TVarChar
             , isPeresort Boolean
             , isClosed Boolean
             , isEtiketka Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsIrna Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_ProductionUnion());
   vbUserId:= lpGetUserBySession (inSession);

   -- !!!Только просмотр Аудитор!!!
   PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

   -- !!!Ирна!!!
   vbIsIrna:= zfCalc_User_isIrna (vbUserId);


   -- Результат
   RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        , tmpRoleAccessKey_all AS (SELECT AccessKeyId, UserId FROM Object_RoleAccessKey_View)
        , tmpRoleAccessKey_user AS (SELECT AccessKeyId FROM tmpRoleAccessKey_all WHERE UserId = vbUserId GROUP BY AccessKeyId)
        , tmpAccessKey_IsDocumentAll AS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId
                                   UNION SELECT 1 AS Id FROM tmpRoleAccessKey_user WHERE AccessKeyId = zc_Enum_Process_AccessKey_DocumentAll()
                                        )
        , tmpRoleAccessKey AS (SELECT tmpRoleAccessKey_user.AccessKeyId FROM tmpRoleAccessKey_user WHERE NOT EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll)
                         UNION SELECT tmpRoleAccessKey_all.AccessKeyId FROM tmpRoleAccessKey_all WHERE EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll) GROUP BY tmpRoleAccessKey_all.AccessKeyId
                              )
     SELECT
           Movement.Id                              AS Id
         , Movement.InvNumber                       AS InvNumber
         , Movement.OperDate                        AS OperDate
         , zfCalc_StatusCode_next (Movement.StatusId, Movement.StatusId_next)                          ::Integer  AS StatusCode
         , zfCalc_StatusName_next (Object_Status.ValueData, Movement.StatusId, Movement.StatusId_next) ::TVarChar AS StatusName
         , MovementFloat_TotalCount.ValueData       AS TotalCount
         , MovementFloat_TotalCountChild.ValueData  AS TotalCountChild
         , Object_From.Id                           AS FromId
         , Object_From.ValueData                    AS FromName
         , ObjectDesc_from.ItemName                 AS ItemName_from
         , Object_To.Id                             AS ToId
         , Object_To.ValueData                      AS ToName
         , ObjectDesc_to.ItemName                   AS ItemName_to

         , Object_DocumentKind.Id                   AS DocumentKindId
         , Object_DocumentKind.ValueData            AS DocumentKindName

         , Object_SubjectDoc.Id                     AS SubjectDocId
         , Object_SubjectDoc.ValueData              AS SubjectDocName

         , COALESCE (MovementBoolean_isAuto.ValueData, FALSE) AS isAuto
         , MovementDate_Insert.ValueData            AS InsertDate
 
         , Movement_Sale.Id                         AS MovementId_Production
         , (CASE WHEN Movement_Sale.StatusId = zc_Enum_Status_Erased()
                       THEN '***'
                   WHEN Movement_Sale.StatusId = zc_Enum_Status_UnComplete()
                       THEN '*'
                   ELSE ''
              END
           || zfCalc_PartionMovementName (Movement_Sale.DescId, MovementDesc_Sale.ItemName, Movement_Sale.InvNumber, Movement_Sale.OperDate) || COALESCE (' - ' || Object_From_Sale.ValueData, '')
             ) :: TVarChar AS InvNumber_ProductionFull

         , COALESCE(Movement_Peresort.Id, -1)                         AS MovementId_Peresort
         , COALESCE(CASE WHEN Movement_Peresort.StatusId = zc_Enum_Status_Erased()
                     THEN '***'
                 WHEN Movement_Peresort.StatusId = zc_Enum_Status_UnComplete()
                     THEN '*'
                 ELSE ''
            END
         || zfCalc_PartionMovementName (Movement_Peresort.DescId, MovementDesc_Peresort.ItemName, Movement_Peresort.InvNumber, Movement_Peresort.OperDate)
           , ' ')                     :: TVarChar      AS InvNumber_PeresortFull

           , Movement_Order.Id                      AS MovementId_Order
           , ('№ ' || Movement_Order.InvNumber || ' от ' || Movement_Order.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_Order_Full
           
           , COALESCE (MovementBoolean_Peresort.ValueData, FALSE) :: Boolean AS isPeresort
           , COALESCE (MovementBoolean_Closed.ValueData, False)   :: Boolean AS isClosed
           , COALESCE (MovementBoolean_Etiketka.ValueData, False) :: Boolean AS isEtiketka

     FROM (SELECT Movement.id
           FROM tmpStatus
                JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate  AND Movement.DescId = zc_Movement_ProductionUnion() AND Movement.StatusId = tmpStatus.StatusId
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
            ) AS tmpMovement

          LEFT JOIN Movement ON Movement.id = tmpMovement.id

          LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

          LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                  ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                 AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

          LEFT JOIN MovementFloat AS MovementFloat_TotalCountChild
                                  ON MovementFloat_TotalCountChild.MovementId =  Movement.Id
                                 AND MovementFloat_TotalCountChild.DescId = zc_MovementFloat_TotalCountChild()

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

          INNER JOIN MovementBoolean AS MovementBoolean_Peresort
                                     ON MovementBoolean_Peresort.MovementId = Movement.Id
                                    AND MovementBoolean_Peresort.DescId = zc_MovementBoolean_Peresort()
                                    AND (MovementBoolean_Peresort.ValueData = inIsPeresort OR vbUserId = 5)

          LEFT JOIN MovementBoolean AS MovementBoolean_isAuto
                                    ON MovementBoolean_isAuto.MovementId = Movement.Id
                                   AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()

          LEFT JOIN MovementBoolean AS MovementBoolean_Closed
                                    ON MovementBoolean_Closed.MovementId = Movement.Id
                                   AND MovementBoolean_Closed.DescId = zc_MovementBoolean_Closed()

          LEFT JOIN MovementBoolean AS MovementBoolean_Etiketka
                                    ON MovementBoolean_Etiketka.MovementId = Movement.Id
                                   AND MovementBoolean_Etiketka.DescId = zc_MovementBoolean_Etiketka()

          LEFT JOIN MovementDate AS MovementDate_Insert
                                 ON MovementDate_Insert.MovementId = Movement.Id
                                AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

          LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Sale
                                         ON MovementLinkMovement_Sale.MovementId = Movement.Id
                                        AND MovementLinkMovement_Sale.DescId = zc_MovementLinkMovement_Production()
          LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = MovementLinkMovement_Sale.MovementChildId
          LEFT JOIN MovementDesc AS MovementDesc_Sale ON MovementDesc_Sale.Id = Movement_Sale.DescId
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From_Sale
                                       ON MovementLinkObject_From_Sale.MovementId = Movement_Sale.Id
                                      AND MovementLinkObject_From_Sale.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From_Sale ON Object_From_Sale.Id = MovementLinkObject_From_Sale.ObjectId
           
          LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                         ON MovementLinkMovement_Order.MovementId = Movement.Id
                                        AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
          LEFT JOIN Movement AS Movement_Order ON Movement_Order.Id = MovementLinkMovement_Order.MovementChildId
          --пересортица
          LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Peresort
                                         ON MovementLinkMovement_Peresort.MovementChildId = Movement.Id
                                        AND MovementLinkMovement_Peresort.DescId          = zc_MovementLinkMovement_Production()
          LEFT JOIN Movement AS Movement_Peresort ON Movement_Peresort.Id = MovementLinkMovement_Peresort.MovementId
          LEFT JOIN MovementDesc AS MovementDesc_Peresort ON MovementDesc_Peresort.Id = Movement_Peresort.DescId
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 21.08.23         * 
 29.03.22         * isClosed
 17.02.20         * SubjectDoc
 31.05.17         * add Movement_Order
 05.10.16         * add inJuridicalBasisId
 26.07.16         *
 13.06.16         * DocumentKind
 26.12.14                                        * add inIsPeresort
 26.12.14                                        * del inArticleLossId
 11.12.14         * add inArticleLossId
 03.06.14                                                        *
 16.17.13                                        * DROP FUNCTION
 15.07.13         *
 30.06.13                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_ProductionUnion (inStartDate:= '01.08.2022', inEndDate:= '01.08.2022', inIsErased:=true, inIsPeresort:=false, inJuridicalBasisId:=0, inSession:= '2')
