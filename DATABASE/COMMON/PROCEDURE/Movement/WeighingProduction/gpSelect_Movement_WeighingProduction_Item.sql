-- Function: gpSelect_Movement_WeighingProduction_Item()

DROP FUNCTION IF EXISTS gpSelect_Movement_WeighingProduction_Item (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_WeighingProduction_Item (TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_WeighingProduction_Item (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_WeighingProduction_Item(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inGoodsGroupId       Integer   ,
    IN inGoodsId            Integer   ,
    IN inJuridicalBasisId   Integer ,
    IN inIsErased           Boolean   , -- 
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , MovementId_parent Integer, OperDate_parent TDateTime, InvNumber_parent TVarChar
             , StartWeighing TDateTime, EndWeighing TDateTime
             , MovementId_Order Integer, InvNumberOrder TVarChar 
             , MovementDescNumber Integer, MovementDescName TVarChar
             , SubjectDocId Integer, SubjectDocName TVarChar
             , PersonalGroupId Integer, PersonalGroupName TVarChar, UnitName_PersonalGroup TVarChar
             , WeighingNumber TFloat
             , PartionGoods TVarChar
             , isProductionIn Boolean, isAuto Boolean
             , isList Boolean
             , isRePack Boolean
             , TotalCount TFloat, TotalCountTare TFloat
             , FromName TVarChar, ToName TVarChar
             , UserName TVarChar
             , Comment TVarChar
             , BranchCode Integer

             , DocumentKindId Integer, DocumentKindName TVarChar
             , GoodsTypeKindId Integer, GoodsTypeKindName TVarChar
             , BarCodeBoxId Integer, BarCodeBoxName TVarChar

             , StartBegin TDateTime, EndBegin TDateTime, diffBegin_sec TFloat
             , GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar, MeasureName TVarChar
             , Amount TFloat
             , StartWeighingMI Boolean, isAutoMI Boolean
             , InsertDate TDateTime, UpdateDate TDateTime
             , RealWeight TFloat, WeightTare TFloat, LiveWeight TFloat
             , HeadCount TFloat, Count TFloat, CountPack TFloat, WeightPack TFloat
             , CountSkewer1 TFloat, WeightSkewer1 TFloat
             , CountSkewer2 TFloat, WeightSkewer2 TFloat,  WeightOther TFloat
             , PartionGoodsDate TDateTime, PartionGoodsMI TVarChar
             , GoodsKindName TVarChar

             , PersonalKVKId Integer, PersonalKVKName TVarChar
             , PositionCode_KVK Integer
             , PositionName_KVK TVarChar
             , UnitCode_KVK Integer
             , UnitName_KVK TVarChar
             , KVK TVarChar
             , AssetName TVarChar, AssetName_two TVarChar

             , isErased Boolean
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

       WITH _tmpGoods AS -- (GoodsId Integer) ON COMMIT DROP;
             (SELECT lfSelect.GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect
              WHERE inGoodsGroupId <> 0 AND COALESCE (inGoodsId, 0) = 0
             UNION
              SELECT inGoodsId WHERE inGoodsId > 0
             UNION
              SELECT Object.Id FROM Object
              WHERE Object.DescId = zc_Object_Goods() AND (inStartDate + INTERVAL '3 DAY') >= inEndDate
                AND COALESCE (inGoodsGroupId, 0) = 0 AND COALESCE (inGoodsId, 0) = 0
             UNION
              SELECT Object.Id FROM Object
              WHERE Object.DescId = zc_Object_Goods() AND inIsErased = TRUE
                AND COALESCE (inGoodsGroupId, 0) = 0 AND COALESCE (inGoodsId, 0) = 0
             )

     /*WITH tmpUserAdmin AS (SELECT ObjectLink_UserRole_View.UserId FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND ObjectLink_UserRole_View.UserId = vbUserId)
        , tmpRoleAccessKey AS (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE Object_RoleAccessKey_View.UserId = vbUserId AND NOT EXISTS (SELECT tmpUserAdmin.UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
                         UNION SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE EXISTS (SELECT tmpUserAdmin.UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
                              )*/
         , tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
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

             , MovementLinkMovement_Order.MovementChildId AS MovementId_Order
             , Movement_Order.InvNumber       :: TVarChar AS InvNumberOrder

             , MovementFloat_MovementDescNumber.ValueData :: Integer AS MovementDescNumber
             , MovementDesc.ItemName                      AS MovementDescName

             , Object_SubjectDoc.Id                       AS SubjectDocId
             , Object_SubjectDoc.ValueData                AS SubjectDocName

             , Object_PersonalGroup.Id                    AS PersonalGroupId
             , Object_PersonalGroup.ValueData             AS PersonalGroupName
             , Object_Unit_PersonalGroup.ValueData        AS UnitName_PersonalGroup
             
             , MovementFloat_WeighingNumber.ValueData     AS WeighingNumber

             , CASE WHEN MIString_PartionGoodsMI.ValueData <> ''
                         THEN MIString_PartionGoodsMI.ValueData
                    WHEN MI_Partion.Id > 0
                         THEN 
                       ('кол.=<' || zfConvert_FloatToString (COALESCE (MI_Partion.Amount, 0)) || '>'
                     || ' кут.=<' || zfConvert_FloatToString (COALESCE (MIFloat_CuterCount.ValueData, 0)) || '>'
                     || ' вид=<' || COALESCE (Object_GoodsKindComplete.ValueData, '') || '>'
                     || ' партия=<' || DATE (COALESCE (Movement_Partion.OperDate, zc_DateEnd())) || '>'
                     || ' № <' || COALESCE (Movement_Partion.InvNumber, '') || '>'
                       )
                    ELSE MIFloat_MovementItemId.ValueData :: TVarChar
               END :: TVarChar AS PartionGoods

             , MovementBoolean_isIncome.ValueData         AS isProductionIn
             , COALESCE(MovementBoolean_isAuto.ValueData, False)    :: Boolean  AS isAuto
             , COALESCE (MovementBoolean_List.ValueData,False)      :: Boolean  AS isList
             , COALESCE (MovementBoolean_isRePack.ValueData, False) :: Boolean  AS isRePack

             , MovementFloat_TotalCount.ValueData         AS TotalCount
             , MovementFloat_TotalCountTare.ValueData     AS TotalCountTare

             , Object_From.ValueData           AS FromName
             , Object_To.ValueData             AS ToName
             
             , Object_User.ValueData           AS UserName
             
             , MovementString_Comment.ValueData AS Comment
             , MovementFloat_BranchCode.ValueData ::Integer AS BranchCode
             --
             , Object_DocumentKind.Id          AS DocumentKindId
             , Object_DocumentKind.ValueData   AS DocumentKindName
             , Object_GoodsTypeKind.Id         AS GoodsTypeKindId
             , Object_GoodsTypeKind.ValueData  AS GoodsTypeKindName
             , Object_BarCodeBox.Id            AS BarCodeBoxId
             , Object_BarCodeBox.ValueData     AS BarCodeBoxName
             
             , MIDate_StartBegin.ValueData  AS StartBegin
             , MIDate_EndBegin.ValueData    AS EndBegin
             , EXTRACT (EPOCH FROM (COALESCE (MIDate_EndBegin.ValueData, zc_DateStart()) - COALESCE (MIDate_StartBegin.ValueData, zc_DateStart())) :: INTERVAL) :: TFloat AS diffBegin_sec

           , Object_Goods.ObjectCode  AS GoodsCode
           , Object_Goods.ValueData   AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , MovementItem.Amount

           , MIBoolean_StartWeighing.ValueData AS StartWeighingMI
           , COALESCE (MIBoolean_isAuto.ValueData, FALSE) :: Boolean AS isAutoMI

           , MIDate_Insert.ValueData           AS InsertDate
           , MIDate_Update.ValueData           AS UpdateDate
           
           , MIFloat_RealWeight.ValueData   AS RealWeight
           , MIFloat_WeightTare.ValueData   AS WeightTare
           , MIFloat_LiveWeight.ValueData   AS LiveWeight
           , MIFloat_HeadCount.ValueData    AS HeadCount
           , MIFloat_Count.ValueData        AS Count

           , MIFloat_CountPack.ValueData      AS CountPack 
           , MIFloat_WeightPack.ValueData  ::TFloat AS WeightPack
           , MIFloat_CountSkewer1.ValueData   AS CountSkewer1
           , MIFloat_WeightSkewer1.ValueData  AS WeightSkewer1
           , MIFloat_CountSkewer2.ValueData   AS CountSkewer2
           , MIFloat_WeightSkewer2.ValueData  AS WeightSkewer2
           , MIFloat_WeightOther.ValueData    AS WeightOther


           , MIDate_PartionGoods.ValueData   AS PartionGoodsDate
           , MIString_PartionGoodsMI.ValueData AS PartionGoodsMI

           , Object_GoodsKind.ValueData AS GoodsKindName

           , Object_PersonalKVK.Id           AS PersonalKVKId
           , Object_PersonalKVK.ValueData    AS PersonalKVKName
           , Object_PositionKVK.ObjectCode   AS PositionCode_KVK
           , Object_PositionKVK.ValueData    AS PositionName_KVK
           , Object_UnitKVK.ObjectCode       AS UnitCode_KVK
           , Object_UnitKVK.ValueData        AS UnitName_KVK
           , MIString_KVK.ValueData          AS KVK

           , Object_Asset.ValueData          AS AssetName
           , Object_Asset_two.ValueData      AS AssetName_two

           , MovementItem.isErased

       FROM tmpStatus
            JOIN Movement ON Movement.DescId = zc_Movement_WeighingProduction()
                         AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                         AND Movement.StatusId = tmpStatus.StatusId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
            LEFT JOIN Movement AS Movement_Parent ON Movement_Parent.Id = Movement.ParentId

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
            LEFT JOIN MovementDesc ON MovementDesc.Id = MovementFloat_MovementDesc.ValueData -- COALESCE (Movement_Parent.DescId, MovementFloat_MovementDesc.ValueData)
            
            LEFT JOIN MovementFloat AS MovementFloat_WeighingNumber
                                    ON MovementFloat_WeighingNumber.MovementId = Movement.Id
                                   AND MovementFloat_WeighingNumber.DescId = zc_MovementFloat_WeighingNumber()

            LEFT JOIN MovementFloat AS MovementFloat_BranchCode
                                    ON MovementFloat_BranchCode.MovementId = Movement.Id
                                   AND MovementFloat_BranchCode.DescId = zc_MovementFloat_BranchCode()

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

            LEFT JOIN MovementString AS MovementString_PartionGoods
                                     ON MovementString_PartionGoods.MovementId = Movement.Id
                                    AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId = Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountTare
                                    ON MovementFloat_TotalCountTare.MovementId = Movement.Id
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

            LEFT JOIN MovementLinkObject AS MovementLinkObject_SubjectDoc
                                         ON MovementLinkObject_SubjectDoc.MovementId = Movement.Id
                                        AND MovementLinkObject_SubjectDoc.DescId = zc_MovementLinkObject_SubjectDoc()
            LEFT JOIN Object AS Object_SubjectDoc ON Object_SubjectDoc.Id = MovementLinkObject_SubjectDoc.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                           ON MovementLinkMovement_Order.MovementId = Movement.Id
                                          AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
            LEFT JOIN Movement AS Movement_Order ON Movement_Order.Id = MovementLinkMovement_Order.MovementChildId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalGroup
                                         ON MovementLinkObject_PersonalGroup.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalGroup.DescId = zc_MovementLinkObject_PersonalGroup()
            LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = MovementLinkObject_PersonalGroup.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_PersonalGroup_Unit
                                 ON ObjectLink_PersonalGroup_Unit.ObjectId = Object_PersonalGroup.Id
                                AND ObjectLink_PersonalGroup_Unit.DescId = zc_ObjectLink_PersonalGroup_Unit()
            LEFT JOIN Object AS Object_Unit_PersonalGroup ON Object_Unit_PersonalGroup.Id = ObjectLink_PersonalGroup_Unit.ChildObjectId

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id 
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            --- строки
            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   AND (MovementItem.isErased  = inIsErased OR inIsErased = TRUE)
                                   AND (inGoodsGroupId <> 0
                                        OR inGoodsId <> 0
                                        OR (inStartDate + INTERVAL '3 DAY') >= inEndDate
                                       )
            INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = _tmpGoods.GoodsId

            LEFT JOIN MovementItemBoolean AS MIBoolean_StartWeighing
                                          ON MIBoolean_StartWeighing.MovementItemId = MovementItem.Id
                                         AND MIBoolean_StartWeighing.DescId = zc_MIBoolean_StartWeighing()
            LEFT JOIN MovementItemBoolean AS MIBoolean_isAuto
                                          ON MIBoolean_isAuto.MovementItemId = MovementItem.Id
                                         AND MIBoolean_isAuto.DescId = zc_MIBoolean_isAuto()

            LEFT JOIN MovementItemDate AS MIDate_StartBegin
                                       ON MIDate_StartBegin.MovementItemId = MovementItem.Id
                                      AND MIDate_StartBegin.DescId         = zc_MIDate_StartBegin()
            LEFT JOIN MovementItemDate AS MIDate_EndBegin
                                       ON MIDate_EndBegin.MovementItemId = MovementItem.Id
                                      AND MIDate_EndBegin.DescId         = zc_MIDate_EndBegin()

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
            LEFT JOIN MovementItemFloat AS MIFloat_WeightPack
                                        ON MIFloat_WeightPack.MovementItemId = MovementItem.Id
                                       AND MIFloat_WeightPack.DescId = zc_MIFloat_WeightPack()

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
            
            LEFT JOIN MovementItemFloat AS MIFloat_MovementItemId
                                        ON MIFloat_MovementItemId.MovementItemId = MovementItem.Id
                                       AND MIFloat_MovementItemId.DescId = zc_MIFloat_MovementItemId()
            LEFT JOIN MovementItem AS MI_Partion ON MI_Partion.Id = CASE WHEN MIFloat_MovementItemId.ValueData > 0 THEN MIFloat_MovementItemId.ValueData ELSE NULL END :: Integer
            LEFT JOIN Movement AS Movement_Partion ON Movement_Partion.Id       = MI_Partion.MovementId
                                                  AND Movement_Partion.DescId   = zc_Movement_ProductionUnion()
            LEFT JOIN MovementItemLinkObject AS MILO_GoodsKindComplete
                                             ON MILO_GoodsKindComplete.MovementItemId = MI_Partion.Id
                                            AND MILO_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
            LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = MILO_GoodsKindComplete.ObjectId
            LEFT JOIN MovementItemFloat AS MIFloat_CuterCount
                                        ON MIFloat_CuterCount.MovementItemId = MI_Partion.Id
                                       AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount()

            LEFT JOIN MovementItemString AS MIString_KVK
                                         ON MIString_KVK.MovementItemId = MovementItem.Id
                                        AND MIString_KVK.DescId = zc_MIString_KVK()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PersonalKVK
                                             ON MILinkObject_PersonalKVK.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PersonalKVK.DescId = zc_MILinkObject_PersonalKVK()
            LEFT JOIN Object AS Object_PersonalKVK ON Object_PersonalKVK.Id = MILinkObject_PersonalKVK.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Personal_PositionKVK
                                 ON ObjectLink_Personal_PositionKVK.ObjectId = Object_PersonalKVK.Id
                                AND ObjectLink_Personal_PositionKVK.DescId = zc_ObjectLink_Personal_Position()
            LEFT JOIN Object AS Object_PositionKVK ON Object_PositionKVK.Id = ObjectLink_Personal_PositionKVK.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Personal_UnitKVK
                                 ON ObjectLink_Personal_UnitKVK.ObjectId = Object_PersonalKVK.Id
                                AND ObjectLink_Personal_UnitKVK.DescId = zc_ObjectLink_Personal_Unit()
            LEFT JOIN Object AS Object_UnitKVK ON Object_UnitKVK.Id = ObjectLink_Personal_UnitKVK.ChildObjectId


            LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                             ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = MILinkObject_Asset.ObjectId
            LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset_two
                                             ON MILinkObject_Asset_two.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Asset_two.DescId = zc_MILinkObject_Asset_two()
            LEFT JOIN Object AS Object_Asset_two ON Object_Asset_two.Id = MILinkObject_Asset_two.ObjectId

       WHERE Movement.DescId = zc_Movement_WeighingProduction()
         AND Movement.OperDate BETWEEN inStartDate AND inEndDate;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 14.03.25         *
 17.07.24         * isRePack
 15.11.22         *
 06.09.21         *
 08.02.21         * Comment
 17.08.20         *
 05.10.16         * add inJuridicalBasisId
 29.08.15         * add inGoodsGroupId, inGoodsId
 12.06.15                                        * all
 13.03.14         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_WeighingProduction_Item (inStartDate:= '01.05.2016', inEndDate:= '01.05.2016', inGoodsGroupId:= 0, inGoodsId:= 0, inJuridicalBasisId:= 0, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
