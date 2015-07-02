-- Function: gpSelect_Movement_WeighingProduction_Item()

DROP FUNCTION IF EXISTS gpSelect_Movement_WeighingProduction_Item (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_WeighingProduction_Item(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inIsErased    Boolean ,
    IN inSession     TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber Integer, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , MovementId_parent Integer, OperDate_parent TDateTime, InvNumber_parent TVarChar
             , StartWeighing TDateTime, EndWeighing TDateTime 
             , MovementDescNumber Integer, MovementDescName TVarChar
             , WeighingNumber TFloat
             , PartionGoods TVarChar
             , isProductionIn Boolean
             , TotalCount TFloat, TotalCountTare TFloat
             , FromName TVarChar, ToName TVarChar
             , UserName TVarChar

             , GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar, MeasureName TVarChar
             , Amount TFloat
             , StartWeighingMI Boolean
             , InsertDate TDateTime, UpdateDate TDateTime
             , RealWeight TFloat, WeightTare TFloat, LiveWeight TFloat
             , HeadCount TFloat, Count TFloat, CountPack TFloat
             , CountSkewer1 TFloat, WeightSkewer1 TFloat
             , CountSkewer2 TFloat, WeightSkewer2 TFloat,  WeightOther TFloat
             , PartionGoodsDate TDateTime, PartionGoodsMI TVarChar
             , GoodsKindName TVarChar
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

             , MovementFloat_TotalCount.ValueData         AS TotalCount
             , MovementFloat_TotalCountTare.ValueData     AS TotalCountTare

             , Object_From.ValueData           AS FromName
             , Object_To.ValueData             AS ToName
             
             , Object_User.ValueData           AS UserName

           , Object_Goods.ObjectCode  AS GoodsCode
           , Object_Goods.ValueData   AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , MovementItem.Amount

           , MIBoolean_StartWeighing.ValueData AS StartWeighingMI
           , MIDate_Insert.ValueData           AS InsertDate
           , MIDate_Update.ValueData           AS UpdateDate
           
           , MIFloat_RealWeight.ValueData   AS RealWeight
           , MIFloat_WeightTare.ValueData   AS WeightTare
           , MIFloat_LiveWeight.ValueData   AS LiveWeight
           , MIFloat_HeadCount.ValueData    AS HeadCount
           , MIFloat_Count.ValueData        AS Count

           , MIFloat_CountPack.ValueData      AS CountPack
           , MIFloat_CountSkewer1.ValueData   AS CountSkewer1
           , MIFloat_WeightSkewer1.ValueData  AS WeightSkewer1
           , MIFloat_CountSkewer2.ValueData   AS CountSkewer2
           , MIFloat_WeightSkewer2.ValueData  AS WeightSkewer2
           , MIFloat_WeightOther.ValueData    AS WeightOther


           , MIDate_PartionGoods.ValueData   AS PartionGoodsDate
           , MIString_PartionGoodsMI.ValueData AS PartionGoodsMI

           , Object_GoodsKind.ValueData AS GoodsKindName


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
            LEFT JOIN MovementString AS MovementString_PartionGoods
                                     ON MovementString_PartionGoods.MovementId =  Movement.Id
                                    AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()

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
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_User
                                         ON MovementLinkObject_User.MovementId = Movement.Id
                                        AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
            LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_User.ObjectId

            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = False
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemBoolean AS MIBoolean_StartWeighing
                                          ON MIBoolean_StartWeighing.MovementItemId = MovementItem.Id
                                         AND MIBoolean_StartWeighing.DescId = zc_MIBoolean_StartWeighing()

            LEFT JOIN MovementItemDate AS MIDate_Insert
                                       ON MIDate_Insert.MovementItemId = MovementItem.Id
                                      AND MIDate_Insert.DescId = zc_MIDate_Insert()
            LEFT JOIN MovementItemDate AS MIDate_Update
                                       ON MIDate_Update.MovementItemId = MovementItem.Id
                                      AND MIDate_Update.DescId = zc_MIDate_Update()
            LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                       ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                      AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                                                 
            LEFT JOIN MovementItemFloat AS MIFloat_RealWeight
                                        ON MIFloat_RealWeight.MovementItemId = MovementItem.Id
                                       AND MIFloat_RealWeight.DescId = zc_MIFloat_RealWeight()

            LEFT JOIN MovementItemFloat AS MIFloat_LiveWeight
                                        ON MIFloat_LiveWeight.MovementItemId = MovementItem.Id
                                       AND MIFloat_LiveWeight.DescId = zc_MIFloat_LiveWeight()

            LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                        ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                       AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
                                       
            LEFT JOIN MovementItemFloat AS MIFloat_WeightTare
                                        ON MIFloat_WeightTare.MovementItemId = MovementItem.Id
                                       AND MIFloat_WeightTare.DescId = zc_MIFloat_WeightTare()

            LEFT JOIN MovementItemFloat AS MIFloat_Count
                                        ON MIFloat_Count.MovementItemId = MovementItem.Id
                                       AND MIFloat_Count.DescId = zc_MIFloat_Count()

            LEFT JOIN MovementItemFloat AS MIFloat_CountPack
                                        ON MIFloat_CountPack.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountPack.DescId = zc_MIFloat_CountPack()

            LEFT JOIN MovementItemFloat AS MIFloat_CountSkewer1
                                        ON MIFloat_CountSkewer1.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountSkewer1.DescId = zc_MIFloat_CountSkewer1()

            LEFT JOIN MovementItemFloat AS MIFloat_WeightSkewer1
                                        ON MIFloat_WeightSkewer1.MovementItemId = MovementItem.Id
                                       AND MIFloat_WeightSkewer1.DescId = zc_MIFloat_WeightSkewer1()

            LEFT JOIN MovementItemFloat AS MIFloat_CountSkewer2
                                        ON MIFloat_CountSkewer2.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountSkewer2.DescId = zc_MIFloat_CountSkewer2()

            LEFT JOIN MovementItemFloat AS MIFloat_WeightSkewer2
                                        ON MIFloat_WeightSkewer2.MovementItemId = MovementItem.Id
                                       AND MIFloat_WeightSkewer2.DescId = zc_MIFloat_WeightSkewer2()

            LEFT JOIN MovementItemFloat AS MIFloat_WeightOther
                                        ON MIFloat_WeightOther.MovementItemId = MovementItem.Id
                                       AND MIFloat_WeightOther.DescId = zc_MIFloat_WeightOther()

            LEFT JOIN MovementItemString AS MIString_PartionGoodsMI
                                         ON MIString_PartionGoodsMI.MovementItemId = MovementItem.Id
                                        AND MIString_PartionGoodsMI.DescId = zc_MIString_PartionGoods()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id 
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
            
       WHERE Movement.DescId = zc_Movement_WeighingProduction()
         AND Movement.OperDate BETWEEN inStartDate AND inEndDate;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_WeighingProduction_Item (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 12.06.15                                        * all
 13.03.14         *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_WeighingProduction_Item (inStartDate:= '01.05.2015', inEndDate:= '01.05.2015', inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
