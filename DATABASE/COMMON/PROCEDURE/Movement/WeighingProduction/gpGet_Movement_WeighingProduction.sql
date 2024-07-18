-- Function: gpGet_Movement_WeighingProduction (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Movement_WeighingProduction (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_WeighingProduction(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , InvNumber_Parent TVarChar, MovementId_parent Integer, OperDate_Parent TDateTime
             , isProductionIn Boolean, isAuto Boolean, isList Boolean
             , isRePack Boolean
             , StartWeighing TDateTime, EndWeighing TDateTime
             , MovementId_Order Integer, InvNumberOrder TVarChar
             , MovementDescNumber Integer
             , MovementDesc Integer, MovementDescName TVarChar
             , WeighingNumber TFloat
             , PartionGoods TVarChar
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , UserId Integer, UserName TVarChar
             , DocumentKindId Integer, DocumentKindName TVarChar
             , GoodsTypeKindId Integer, GoodsTypeKindName TVarChar
             , BarCodeBoxId Integer, BarCodeBoxName TVarChar
             , SubjectDocId Integer, SubjectDocCode Integer, SubjectDocName TVarChar
             , PersonalGroupId Integer, PersonalGroupName TVarChar
             , Comment TVarChar 
             , BranchCode Integer
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Get_Movement_WeighingProduction());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('Movement_WeighingProduction_seq') AS TVarChar) AS InvNumber
             , CAST (CURRENT_DATE as TDateTime) AS OperDate
             , Object_Status.Code               AS StatusCode
             , Object_Status.Name               AS StatusName

             , CAST ('' AS TVarChar)            AS Parent
             , 0                                AS MovementId_Parent
             , CAST (Null AS TDateTime)         AS OperDate_Parent

             , FALSE                 AS isProductionIn
             , FALSE                 AS isAuto
             , FALSE                 AS isList 
             , FALSE                 AS isRePack
             , CAST (CURRENT_DATE AS TDateTime) AS StartWeighing
             , CAST (CURRENT_DATE AS TDateTime) AS EndWeighing

             , 0                     AS MovementId_Order
             , CAST ('' AS TVarChar) AS InvNumberOrder

             , 0                     AS MovementDescNumber
             , 0                     AS MovementDesc
             , CAST ('' AS TVarChar) AS MovementDescName

             , CAST (0 AS TFloat)    AS WeighingNumber

             , CAST ('' AS TVarChar) AS PartionGoods

             , 0                     AS FromId
             , CAST ('' AS TVarChar) AS FromName
             , 0                     AS ToId
             , CAST ('' AS TVarChar) AS ToName

             , 0                     AS UserId
             , CAST ('' AS TVarChar) AS UserName


             , 0                     AS DocumentKindId
             , CAST ('' AS TVarChar) AS DocumentKindName
             , 0                     AS GoodsTypeKindId
             , CAST ('' AS TVarChar) AS GoodsTypeKindName
             , 0                     AS BarCodeBoxId
             , CAST ('' AS TVarChar) AS BarCodeBoxName
             , 0                     AS SubjectDocId
             , 0                     AS SubjectDocCode
             , CAST ('' AS TVarChar) AS SubjectDocName

             , 0                     AS PersonalGroupId
             , CAST ('' AS TVarChar) AS PersonalGroupName

             , CAST ('' AS TVarChar) AS Comment
             , 0   ::Integer         AS BranchCode
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
     ELSE
       RETURN QUERY
         SELECT
               Movement.Id
             , Movement.InvNumber
             , Movement.OperDate
             , Object_Status.ObjectCode          AS StatusCode
             , Object_Status.ValueData           AS StatusName

             , Movement_Parent.InvNumber         AS InvNumber_Parent
             , Movement_Parent.Id                AS MovementId_Parent
             , Movement_Parent.OperDate          AS OperDate_Parent

             , MovementBoolean_isIncome.ValueData    AS isProductionIn
             , COALESCE(MovementBoolean_isAuto.ValueData, False)    :: Boolean  AS isAuto
             , COALESCE (MovementBoolean_List.ValueData,False)      :: Boolean  AS isList
             , COALESCE (MovementBoolean_isRePack.ValueData, FALSE) :: Boolean  AS isRePack

             , MovementDate_StartWeighing.ValueData  AS StartWeighing
             , MovementDate_EndWeighing.ValueData    AS EndWeighing

             , MovementLinkMovement_Order.MovementChildId AS MovementId_Order
             , Movement_Order.InvNumber       :: TVarChar AS InvNumberOrder

             , MovementFloat_MovementDescNumber.ValueData :: Integer AS MovementDescNumber
             , MovementDesc.Id                            AS MovementDesc
             , MovementDesc.ItemName                      AS MovementDescName
             , MovementFloat_WeighingNumber.ValueData     AS WeighingNumber

             , MovementString_PartionGoods.ValueData      AS PartionGoods

             , Object_From.Id                             AS FromId
             , Object_From.ValueData                      AS FromName
             , Object_To.Id                               AS ToId
             , Object_To.ValueData                        AS ToName

             , Object_User.Id                             AS UserId
             , Object_User.ValueData                      AS UserName

             , Object_DocumentKind.Id                     AS DocumentKindId
             , Object_DocumentKind.ValueData              AS DocumentKindName
             , Object_GoodsTypeKind.Id                    AS GoodsTypeKindId
             , Object_GoodsTypeKind.ValueData             AS GoodsTypeKindName
             , Object_BarCodeBox.Id                       AS BarCodeBoxId
             , Object_BarCodeBox.ValueData                AS BarCodeBoxName

             , Object_SubjectDoc.Id                       AS SubjectDocId
             , Object_SubjectDoc.ObjectCode               AS SubjectDocCode
             , Object_SubjectDoc.ValueData                AS SubjectDocName

             , Object_PersonalGroup.Id                    AS PersonalGroupId
             , Object_PersonalGroup.ValueData             AS PersonalGroupName

             , MovementString_Comment.ValueData           AS Comment
             
             , MovementFloat_BranchCode.ValueData ::Integer AS BranchCode
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
            LEFT JOIN Movement AS Movement_Parent ON Movement_Parent.Id = Movement.ParentId

            LEFT JOIN MovementBoolean AS MovementBoolean_isIncome
                                      ON MovementBoolean_isIncome.MovementId = Movement.Id
                                     AND MovementBoolean_isIncome.DescId = zc_MovementBoolean_isIncome()
            LEFT JOIN MovementBoolean AS MovementBoolean_isAuto
                                      ON MovementBoolean_isAuto.MovementId = Movement.Id
                                     AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()
            LEFT JOIN MovementBoolean AS MovementBoolean_List
                                      ON MovementBoolean_List.MovementId = Movement.Id
                                     AND MovementBoolean_List.DescId = zc_MovementBoolean_List()

            LEFT JOIN MovementBoolean AS MovementBoolean_isRePack
                                      ON MovementBoolean_isRePack.MovementId = Movement.Id
                                     AND MovementBoolean_isRePack.DescId = zc_MovementBoolean_isRePack()

            LEFT JOIN MovementDate AS MovementDate_StartWeighing
                                   ON MovementDate_StartWeighing.MovementId = Movement.Id
                                  AND MovementDate_StartWeighing.DescId = zc_MovementDate_StartWeighing()
            LEFT JOIN MovementDate AS MovementDate_EndWeighing
                                   ON MovementDate_EndWeighing.MovementId = Movement.Id
                                  AND MovementDate_EndWeighing.DescId = zc_MovementDate_EndWeighing()

            LEFT JOIN MovementFloat AS MovementFloat_MovementDescNumber
                                    ON MovementFloat_MovementDescNumber.MovementId = Movement.Id
                                   AND MovementFloat_MovementDescNumber.DescId = zc_MovementFloat_MovementDescNumber()
            LEFT JOIN MovementFloat AS MovementFloat_MovementDesc
                                    ON MovementFloat_MovementDesc.MovementId = Movement.Id
                                   AND MovementFloat_MovementDesc.DescId = zc_MovementFloat_MovementDesc()
            LEFT JOIN MovementDesc ON MovementDesc.Id = MovementFloat_MovementDesc.ValueData

            LEFT JOIN MovementFloat AS MovementFloat_BranchCode
                                    ON MovementFloat_BranchCode.MovementId = Movement.Id
                                   AND MovementFloat_BranchCode.DescId = zc_MovementFloat_BranchCode()

            LEFT JOIN MovementFloat AS MovementFloat_WeighingNumber
                                    ON MovementFloat_WeighingNumber.MovementId = Movement.Id
                                   AND MovementFloat_WeighingNumber.DescId = zc_MovementFloat_WeighingNumber()

            LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                     ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                    AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()

            LEFT JOIN MovementString AS MovementString_PartionGoods
                                     ON MovementString_PartionGoods.MovementId = Movement.Id
                                    AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()
            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId =  Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_User
                                         ON MovementLinkObject_User.MovementId = Movement.Id
                                        AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
            LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_User.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentKind
                                         ON MovementLinkObject_DocumentKind.MovementId = Movement.Id
                                        AND MovementLinkObject_DocumentKind.DescId = zc_MovementLinkObject_DocumentKind()
            LEFT JOIN Object AS Object_DocumentKind ON Object_DocumentKind.Id = MovementLinkObject_DocumentKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_GoodsTypeKind
                                         ON MovementLinkObject_GoodsTypeKind.MovementId = Movement.Id
                                        AND MovementLinkObject_GoodsTypeKind.DescId = zc_MovementLinkObject_GoodsTypeKind()
            LEFT JOIN Object AS Object_GoodsTypeKind ON Object_GoodsTypeKind.Id = MovementLinkObject_GoodsTypeKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_BarCodeBox
                                         ON MovementLinkObject_BarCodeBox.MovementId = Movement.Id
                                        AND MovementLinkObject_BarCodeBox.DescId = zc_MovementLinkObject_BarCodeBox()
            LEFT JOIN Object AS Object_BarCodeBox ON Object_BarCodeBox.Id = MovementLinkObject_BarCodeBox.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_SubjectDoc
                                         ON MovementLinkObject_SubjectDoc.MovementId = Movement.Id
                                        AND MovementLinkObject_SubjectDoc.DescId     = zc_MovementLinkObject_SubjectDoc()
            LEFT JOIN Object AS Object_SubjectDoc ON Object_SubjectDoc.Id = MovementLinkObject_SubjectDoc.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                           ON MovementLinkMovement_Order.MovementId = Movement.Id
                                          AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
            LEFT JOIN Movement AS Movement_Order ON Movement_Order.Id = MovementLinkMovement_Order.MovementChildId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalGroup
                                         ON MovementLinkObject_PersonalGroup.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalGroup.DescId = zc_MovementLinkObject_PersonalGroup()
            LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = MovementLinkObject_PersonalGroup.ObjectId
       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_WeighingProduction();
     END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 17.07.24         * isRePack
 15.11.22         * 
 06.09.21         *
 03.03.20         * Add Order
 24.11.16         *
 14.06.16         *
 13.03.14         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_WeighingProduction (inMovementId:= 1, inSession:= zfCalc_UserAdmin())

--select * from gpGet_Movement_WeighingProduction(inMovementId := 3950163 ,  inSession := '5');