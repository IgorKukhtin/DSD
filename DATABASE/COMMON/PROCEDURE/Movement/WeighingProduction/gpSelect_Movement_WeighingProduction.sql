-- Function: gpSelect_Movement_WeighingProduction()

DROP FUNCTION IF EXISTS gpSelect_Movement_WeighingProduction (TDateTime, TDateTime, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_WeighingProduction(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inIsErased          Boolean ,
    IN inJuridicalBasisId  Integer ,
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber Integer, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , MovementId_parent Integer, OperDate_parent TDateTime, InvNumber_parent TVarChar
             , StartWeighing TDateTime, EndWeighing TDateTime 
             , MovementDescNumber Integer, MovementDescName TVarChar
             , WeighingNumber TFloat
             , PartionGoods TVarChar
             , isProductionIn Boolean, isAuto Boolean
             , TotalCountKg TFloat, TotalCountTare TFloat
             , FromName TVarChar, ToName TVarChar
             , UserName TVarChar
             , DocumentKindId Integer, DocumentKindName TVarChar
             , GoodsTypeKindId Integer, GoodsTypeKindName TVarChar
             , BarCodeBoxId Integer, BarCodeBoxName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_WeighingProduction());
     vbUserId:= lpGetUserBySession (inSession);

     -- ���������
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

             , MovementFloat_MovementDescNumber.ValueData :: Integer AS MovementDescNumber
             , MovementDesc.ItemName                      AS MovementDescName
             , MovementFloat_WeighingNumber.ValueData     AS WeighingNumber

             , MovementString_PartionGoods.ValueData      AS PartionGoods
             , MovementBoolean_isIncome.ValueData         AS isProductionIn
             , COALESCE(MovementBoolean_isAuto.ValueData, False) :: Boolean  AS isAuto

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

       FROM tmpStatus
            JOIN Movement ON Movement.DescId = zc_Movement_WeighingProduction()
                         AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                         AND Movement.StatusId = tmpStatus.StatusId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
            LEFT JOIN Movement AS Movement_Parent ON Movement_Parent.Id = Movement.ParentId

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
            LEFT JOIN MovementDesc ON MovementDesc.Id = MovementFloat_MovementDesc.ValueData -- COALESCE (Movement_Parent.DescId, MovementFloat_MovementDesc.ValueData)
            
            LEFT JOIN MovementFloat AS MovementFloat_WeighingNumber
                                    ON MovementFloat_WeighingNumber.MovementId =  Movement.Id
                                   AND MovementFloat_WeighingNumber.DescId = zc_MovementFloat_WeighingNumber()

            LEFT JOIN MovementBoolean AS MovementBoolean_isIncome
                                      ON MovementBoolean_isIncome.MovementId =  Movement.Id
                                     AND MovementBoolean_isIncome.DescId = zc_MovementBoolean_isIncome()
            LEFT JOIN MovementBoolean AS MovementBoolean_isAuto
                                      ON MovementBoolean_isAuto.MovementId = Movement.Id
                                     AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()

            LEFT JOIN MovementString AS MovementString_PartionGoods
                                     ON MovementString_PartionGoods.MovementId =  Movement.Id
                                    AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                    ON MovementFloat_TotalCountKg.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()
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
       WHERE Movement.DescId = zc_Movement_WeighingProduction()
         AND Movement.OperDate BETWEEN inStartDate AND inEndDate;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Movement_WeighingProduction (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 05.10.16         * add inJuridicalBasisId
 14.06.16         * DocumentKind
 12.06.15                                        * all
 13.03.14         *
*/

-- ����
--  SELECT * FROM gpSelect_Movement_WeighingProduction (inStartDate:= '01.05.2015', inEndDate:= '01.05.2015', inIsErased:= FALSE, inJuridicalBasisId :=0, inSession:= zfCalc_UserAdmin())
