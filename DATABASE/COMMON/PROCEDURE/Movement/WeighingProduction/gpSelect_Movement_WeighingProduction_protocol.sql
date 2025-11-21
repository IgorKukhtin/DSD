-- Function: gpSelect_Movement_WeighingProduction()

DROP FUNCTION IF EXISTS gpSelect_Movement_WeighingProduction_protocol (TDateTime, TDateTime, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_WeighingProduction_protocol(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inIsErased          Boolean ,
    IN inJuridicalBasisId  Integer ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , MovementId_parent Integer, OperDate_parent TDateTime, InvNumber_parent TVarChar
             , StartWeighing TDateTime, EndWeighing TDateTime
             , MovementId_Order Integer, InvNumberOrder TVarChar
             , MovementDescNumber Integer, MovementDescName TVarChar
             , WeighingNumber TFloat
             , NumSecurity TFloat, isNumSecurity Boolean
             , PartionGoods TVarChar
             , isProductionIn Boolean, isAuto Boolean
             , isList Boolean 
             , isRePack Boolean
             , TotalCountKg TFloat, TotalCountTare TFloat
             , FromName TVarChar, ToName TVarChar
             , UserName TVarChar
             , DocumentKindId Integer, DocumentKindName TVarChar
             , GoodsTypeKindId Integer, GoodsTypeKindName TVarChar
             , BarCodeBoxId Integer, BarCodeBoxName TVarChar
             , SubjectDocId Integer, SubjectDocName TVarChar
             , PersonalGroupId Integer, PersonalGroupName TVarChar, UnitName_PersonalGroup TVarChar
             , Comment TVarChar 
             , BranchCode Integer
             , Count_user Integer
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_WeighingProduction());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- Результат
     RETURN QUERY 
     /*WITH tmpUserAdmin AS (SELECT ObjectLink_UserRole_View.UserId FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND ObjectLink_UserRole_View.UserId = vbUserId)
        , tmpRoleAccessKey AS (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE Object_RoleAccessKey_View.UserId = vbUserId AND NOT EXISTS (SELECT tmpUserAdmin.UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
                         UNION SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE EXISTS (SELECT tmpUserAdmin.UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
                              )*/
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                         )

        , tmpMovement AS (SELECT Movement.*
                          FROM tmpStatus
                            JOIN Movement ON Movement.DescId = zc_Movement_WeighingProduction()
                                         AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                         AND Movement.StatusId = tmpStatus.StatusId
                          )

        , tmpProtocol AS (WITH
                          tmpMovement_Protocol AS (SELECT DISTINCT MovementProtocol.MovementId
                                                        , MovementProtocol.UserId
                                                   FROM MovementProtocol
                                                   WHERE MovementProtocol.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                                   )
                        , tmpMI AS (SELECT MovementItem.*
                                    FROM MovementItem
                                    WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement) 
                                      AND MovementItem.isErased = FALSE
                                    )
                        , tmpMI_Protocol AS (SELECT DISTINCT tmpMI.MovementId
                                                  , MI_Protocol.UserId
                                             FROM MovementItemProtocol AS MI_Protocol
                                                  INNER JOIN tmpMI ON tmpMI.Id = MI_Protocol.MovementItemId
                                             WHERE MI_Protocol.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                             )
                        SELECT tmp.MovementId
                             , COUNT (DISTINCT tmp.UserId) AS Count_user 
                        FROM (
                              SELECT tmp.MovementId
                                   , tmp.UserId 
                              FROM tmpMovement_Protocol AS tmp
                            UNION 
                              SELECT tmp.MovementId
                                   , tmp.UserId 
                              FROM tmpMI_Protocol AS tmp
                             ) AS tmp
                          GROUP BY tmp.MovementId
                          )

        , tmpMLM AS (SELECT MovementLinkMovement.*
                     FROM MovementLinkMovement
                     WHERE MovementLinkMovement.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                       AND MovementLinkMovement.DescId IN (zc_MovementLinkMovement_Order()
                                                          )
                     )

        , tmpMovementDate AS (SELECT *
                              FROM MovementDate
                              WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                AND MovementDate.DescId IN (zc_MovementDate_StartWeighing()
                                                          , zc_MovementDate_EndWeighing()
                                                            )
                              )

        , tmpMovementFloat AS (SELECT *
                              FROM MovementFloat
                              WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                AND MovementFloat.DescId IN (zc_MovementFloat_BranchCode()
                                                           , zc_MovementFloat_MovementDesc()
                                                           , zc_MovementFloat_MovementDescNumber()
                                                           , zc_MovementFloat_NumSecurity()
                                                           , zc_MovementFloat_TotalCountKg()
                                                           , zc_MovementFloat_TotalCountTare()
                                                           , zc_MovementFloat_WeighingNumber()
                                                            )
                              )

        , tmpMovementString AS (SELECT *
                                FROM MovementString
                                WHERE MovementString.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                  AND MovementString.DescId IN (zc_MovementString_Comment()
                                                              , zc_MovementString_PartionGoods()
                                                              )
                                )

        , tmpMovementBoolean AS (SELECT *
                                 FROM MovementBoolean
                                 WHERE MovementBoolean.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                   AND MovementBoolean.DescId IN (zc_MovementBoolean_List()
                                                                , zc_MovementBoolean_isAuto()
                                                                , zc_MovementBoolean_isIncome()
                                                                , zc_MovementBoolean_isRePack()
                                                                 )
                                 )

        , tmpMLO AS (SELECT *
                     FROM MovementLinkObject
                     WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                       AND MovementLinkObject.DescId IN (zc_MovementLinkObject_BarCodeBox()
                                                       , zc_MovementLinkObject_DocumentKind()
                                                       , zc_MovementLinkObject_From()
                                                       , zc_MovementLinkObject_GoodsTypeKind()
                                                       , zc_MovementLinkObject_PersonalGroup()
                                                       , zc_MovementLinkObject_SubjectDoc()
                                                       , zc_MovementLinkObject_To()
                                                       , zc_MovementLinkObject_User()
                                                        )
                     )


       ---
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
 
             , MovementDate_StartWeighing.ValueData  AS StartWeighing  
             , MovementDate_EndWeighing.ValueData    AS EndWeighing

             , MovementLinkMovement_Order.MovementChildId AS MovementId_Order
             , Movement_Order.InvNumber       :: TVarChar AS InvNumberOrder

             , MovementFloat_MovementDescNumber.ValueData :: Integer AS MovementDescNumber
             , MovementDesc.ItemName                      AS MovementDescName
             , MovementFloat_WeighingNumber.ValueData     AS WeighingNumber 

               -- Номер охранника 
             , MovementFloat_NumSecurity.ValueData        AS NumSecurity
             , CASE WHEN MovementFloat_NumSecurity.ValueData < 0 THEN TRUE ELSE FALSE END ::Boolean AS isNumSecurity

             , MovementString_PartionGoods.ValueData      AS PartionGoods
             , MovementBoolean_isIncome.ValueData         AS isProductionIn
             , COALESCE (MovementBoolean_isAuto.ValueData, False) :: Boolean  AS isAuto
             , COALESCE (MovementBoolean_List.ValueData,False)    :: Boolean  AS isList
             , COALESCE (MovementBoolean_isRePack.ValueData, FALSE) :: Boolean  AS isRePack

             , MovementFloat_TotalCountKg.ValueData       AS TotalCountKg
             , MovementFloat_TotalCountTare.ValueData     AS TotalCountTare

             , Object_From.ValueData           AS FromName
             , Object_To.ValueData             AS ToName
             
             , Object_User.ValueData           AS UserName

             , Object_DocumentKind.Id          AS DocumentKindId
             , Object_DocumentKind.ValueData   AS DocumentKindName

             , Object_GoodsTypeKind.Id         AS GoodsTypeKindId
             , Object_GoodsTypeKind.ValueData  AS GoodsTypeKindName

             , Object_BarCodeBox.Id            AS BarCodeBoxId
             , Object_BarCodeBox.ValueData     AS BarCodeBoxName

             , Object_SubjectDoc.Id            AS SubjectDocId
             , Object_SubjectDoc.ValueData     AS SubjectDocName

             , Object_PersonalGroup.Id         AS PersonalGroupId
             , Object_PersonalGroup.ValueData  AS PersonalGroupName
             , Object_Unit_PersonalGroup.ValueData AS UnitName_PersonalGroup
             , MovementString_Comment.ValueData AS Comment

             , MovementFloat_BranchCode.ValueData ::Integer AS BranchCode

             , tmpProtocol.Count_user ::Integer AS Count_user
       FROM tmpMovement AS Movement

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
            LEFT JOIN Movement AS Movement_Parent ON Movement_Parent.Id = Movement.ParentId

            LEFT JOIN tmpMovementDate AS MovementDate_StartWeighing
                                      ON MovementDate_StartWeighing.MovementId =  Movement.Id
                                     AND MovementDate_StartWeighing.DescId = zc_MovementDate_StartWeighing()
            LEFT JOIN tmpMovementDate AS MovementDate_EndWeighing
                                      ON MovementDate_EndWeighing.MovementId =  Movement.Id
                                     AND MovementDate_EndWeighing.DescId = zc_MovementDate_EndWeighing()
                                  
            LEFT JOIN tmpMovementFloat AS MovementFloat_MovementDescNumber
                                       ON MovementFloat_MovementDescNumber.MovementId =  Movement.Id
                                      AND MovementFloat_MovementDescNumber.DescId = zc_MovementFloat_MovementDescNumber()
            LEFT JOIN tmpMovementFloat AS MovementFloat_MovementDesc
                                       ON MovementFloat_MovementDesc.MovementId =  Movement.Id
                                      AND MovementFloat_MovementDesc.DescId = zc_MovementFloat_MovementDesc()
            LEFT JOIN MovementDesc ON MovementDesc.Id = MovementFloat_MovementDesc.ValueData -- COALESCE (Movement_Parent.DescId, MovementFloat_MovementDesc.ValueData)
            
            LEFT JOIN tmpMovementFloat AS MovementFloat_WeighingNumber
                                    ON MovementFloat_WeighingNumber.MovementId =  Movement.Id
                                   AND MovementFloat_WeighingNumber.DescId = zc_MovementFloat_WeighingNumber()
            LEFT JOIN tmpMovementFloat AS MovementFloat_NumSecurity
                                    ON MovementFloat_NumSecurity.MovementId =  Movement.Id
                                   AND MovementFloat_NumSecurity.DescId = zc_MovementFloat_NumSecurity()
 
            LEFT JOIN tmpMovementBoolean AS MovementBoolean_isIncome
                                         ON MovementBoolean_isIncome.MovementId =  Movement.Id
                                        AND MovementBoolean_isIncome.DescId = zc_MovementBoolean_isIncome()
            LEFT JOIN tmpMovementBoolean AS MovementBoolean_isAuto
                                         ON MovementBoolean_isAuto.MovementId = Movement.Id
                                        AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()
            LEFT JOIN tmpMovementBoolean AS MovementBoolean_List
                                         ON MovementBoolean_List.MovementId = Movement.Id
                                        AND MovementBoolean_List.DescId = zc_MovementBoolean_List()
            LEFT JOIN tmpMovementBoolean AS MovementBoolean_isRePack
                                         ON MovementBoolean_isRePack.MovementId = Movement.Id
                                        AND MovementBoolean_isRePack.DescId = zc_MovementBoolean_isRePack()

            LEFT JOIN tmpMovementString AS MovementString_PartionGoods
                                        ON MovementString_PartionGoods.MovementId =  Movement.Id
                                       AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()

            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCountKg
                                       ON MovementFloat_TotalCountKg.MovementId =  Movement.Id
                                      AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCountTare
                                       ON MovementFloat_TotalCountTare.MovementId =  Movement.Id
                                      AND MovementFloat_TotalCountTare.DescId = zc_MovementFloat_TotalCountTare()

            LEFT JOIN tmpMovementFloat AS MovementFloat_BranchCode
                                       ON MovementFloat_BranchCode.MovementId = Movement.Id
                                      AND MovementFloat_BranchCode.DescId = zc_MovementFloat_BranchCode()

            LEFT JOIN tmpMLO AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            
            LEFT JOIN tmpMLO AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
            
            LEFT JOIN tmpMLO AS MovementLinkObject_User
                                         ON MovementLinkObject_User.MovementId = Movement.Id
                                        AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
            LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_User.ObjectId

            LEFT JOIN tmpMLO AS MovementLinkObject_DocumentKind
                                         ON MovementLinkObject_DocumentKind.MovementId = Movement.Id
                                        AND MovementLinkObject_DocumentKind.DescId = zc_MovementLinkObject_DocumentKind()
            LEFT JOIN Object AS Object_DocumentKind ON Object_DocumentKind.Id = MovementLinkObject_DocumentKind.ObjectId

            LEFT JOIN tmpMLO AS MovementLinkObject_GoodsTypeKind
                                         ON MovementLinkObject_GoodsTypeKind.MovementId = Movement.Id
                                        AND MovementLinkObject_GoodsTypeKind.DescId = zc_MovementLinkObject_GoodsTypeKind()
            LEFT JOIN Object AS Object_GoodsTypeKind ON Object_GoodsTypeKind.Id = MovementLinkObject_GoodsTypeKind.ObjectId

            LEFT JOIN tmpMLO AS MovementLinkObject_BarCodeBox
                                         ON MovementLinkObject_BarCodeBox.MovementId = Movement.Id
                                        AND MovementLinkObject_BarCodeBox.DescId = zc_MovementLinkObject_BarCodeBox()
            LEFT JOIN Object AS Object_BarCodeBox ON Object_BarCodeBox.Id = MovementLinkObject_BarCodeBox.ObjectId

            LEFT JOIN tmpMLO AS MovementLinkObject_SubjectDoc
                                         ON MovementLinkObject_SubjectDoc.MovementId = Movement.Id
                                        AND MovementLinkObject_SubjectDoc.DescId = zc_MovementLinkObject_SubjectDoc()
            LEFT JOIN Object AS Object_SubjectDoc ON Object_SubjectDoc.Id = MovementLinkObject_SubjectDoc.ObjectId

            LEFT JOIN tmpMLM AS MovementLinkMovement_Order
                             ON MovementLinkMovement_Order.MovementId = Movement.Id
                            AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
            LEFT JOIN Movement AS Movement_Order ON Movement_Order.Id = MovementLinkMovement_Order.MovementChildId

            LEFT JOIN tmpMLO AS MovementLinkObject_PersonalGroup
                                         ON MovementLinkObject_PersonalGroup.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalGroup.DescId = zc_MovementLinkObject_PersonalGroup()
            LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = MovementLinkObject_PersonalGroup.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_PersonalGroup_Unit
                                 ON ObjectLink_PersonalGroup_Unit.ObjectId = Object_PersonalGroup.Id
                                AND ObjectLink_PersonalGroup_Unit.DescId = zc_ObjectLink_PersonalGroup_Unit()
            LEFT JOIN Object AS Object_Unit_PersonalGroup ON Object_Unit_PersonalGroup.Id = ObjectLink_PersonalGroup_Unit.ChildObjectId

            LEFT JOIN tmpMovementString AS MovementString_Comment
                                        ON MovementString_Comment.MovementId = Movement.Id 
                                       AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN tmpProtocol ON tmpProtocol.MovementId = Movement.Id
       ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Movement_WeighingProduction (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 22.05.25         * NumSecurity
*/

-- тест
--  SELECT * FROM gpSelect_Movement_WeighingProduction_protocol (inStartDate:= '01.02.2020', inEndDate:= '01.02.2020', inIsErased:= FALSE, inJuridicalBasisId :=0, inSession:= zfCalc_UserAdmin())