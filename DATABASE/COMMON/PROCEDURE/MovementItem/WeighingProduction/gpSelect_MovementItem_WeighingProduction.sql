-- Function: gpSelect_MovementItem_WeighingProduction()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_WeighingProduction (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_WeighingProduction (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_WeighingProduction(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar, MeasureName TVarChar
             , Amount TFloat
             , StartWeighing Boolean, isAuto Boolean
             , InsertDate TDateTime, UpdateDate TDateTime
             , RealWeight TFloat, WeightTare TFloat, LiveWeight TFloat
             , HeadCount TFloat, Count TFloat, CountPack TFloat, WeightPack TFloat
             , CountSkewer1 TFloat, WeightSkewer1 TFloat
             , CountSkewer2 TFloat, WeightSkewer2 TFloat,  WeightOther TFloat
             , PartionGoodsDate TDateTime, PartionGoods TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , StorageLineId Integer, StorageLineName TVarChar
             , PersonalKVKId Integer, PersonalKVKName TVarChar
             , PositionCode_KVK Integer
             , PositionName_KVK TVarChar
             , UnitCode_KVK Integer
             , UnitName_KVK TVarChar
             , KVK TVarChar
             , AssetName TVarChar, AssetName_two TVarChar
             , CountTare1 TFloat, CountTare2 TFloat, CountTare3 TFloat, CountTare4 TFloat, CountTare5 TFloat
             , PartionNum TFloat
             , BoxId_1 Integer, BoxName_1 TVarChar, BoxId_2 Integer, BoxName_2 TVarChar, BoxId_3 Integer, BoxName_3 TVarChar, BoxId_4 Integer, BoxName_4 TVarChar, BoxId_5 Integer, BoxName_5 TVarChar
             , PartionCellId Integer, PartionCellName TVarChar
             , isErased Boolean
              )
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_WeighingProduction());

     -- inShowAll:= TRUE;
     RETURN QUERY 
       SELECT
             MovementItem.Id
           , Object_Goods.Id          AS GoodsId
           , Object_Goods.ObjectCode  AS GoodsCode
           , Object_Goods.ValueData   AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , MovementItem.Amount

           , MIBoolean_StartWeighing.ValueData AS StartWeighing
           , COALESCE (MIBoolean_isAuto.ValueData, FALSE) :: Boolean  AS isAuto
           
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

             , CASE WHEN MIString_PartionGoods.ValueData <> ''
                         THEN MIString_PartionGoods.ValueData
                    WHEN MI_Partion.Id > 0 AND Movement_Partion.DescId = zc_Movement_ProductionUnion()
                         THEN 
                       ('кол.=<' || zfConvert_FloatToString (COALESCE (MI_Partion.Amount, 0)) || '>'
                     || ' кут.=<' || zfConvert_FloatToString (COALESCE (MIFloat_CuterCount.ValueData, 0)) || '>'
                     || ' вид=<' || COALESCE (Object_GoodsKindComplete.ValueData, '') || '>'
                     || ' партия=<' || zfConvert_DateToString (COALESCE (Movement_Partion.OperDate, zc_DateEnd())) || '>'
                     || ' № <' || COALESCE (Movement_Partion.InvNumber, '') || '>'
                       )
                    WHEN MI_Partion.Id > 0 AND Movement_Partion.DescId IN (zc_Movement_WeighingPartner(), zc_Movement_WeighingProduction())
                         THEN 
                       ('кол. = <' || zfConvert_FloatToString (COALESCE (MI_Partion.Amount, 0)) || '>'
                     || ' вид = <' || COALESCE (Object_GoodsKind_part.ValueData, '') || '>'
                     || CASE WHEN MIDate_PartionGoods_part.ValueData > zc_DateStart() THEN ' партия = <' || zfConvert_DateToString (MIDate_PartionGoods_part.ValueData) || '>' ELSE '' END
                     || ' № док. <' || COALESCE (Movement_Partion.InvNumber, '') || '>'
                     || ' от <' || zfConvert_DateToString (COALESCE (Movement_Partion.OperDate, zc_DateEnd())) || '>'
                       )
                    ELSE MIFloat_MovementItemId.ValueData :: TVarChar
               END :: TVarChar AS PartionGoods

           , Object_GoodsKind.Id          AS GoodsKindId
           , Object_GoodsKind.ValueData   AS GoodsKindName
 
           , Object_StorageLine.Id        AS StorageLineId
           , Object_StorageLine.ValueData AS StorageLineName
           
           , Object_PersonalKVK.Id           AS PersonalKVKId
           , Object_PersonalKVK.ValueData    AS PersonalKVKName
           , Object_PositionKVK.ObjectCode   AS PositionCode_KVK
           , Object_PositionKVK.ValueData    AS PositionName_KVK
           , Object_UnitKVK.ObjectCode       AS UnitCode_KVK
           , Object_UnitKVK.ValueData        AS UnitName_KVK
           , MIString_KVK.ValueData          AS KVK

           , Object_Asset.ValueData          AS AssetName
           , Object_Asset_two.ValueData      AS AssetName_two   
           
           , MIFloat_CountTare1.ValueData   ::TFloat AS CountTare1
           , MIFloat_CountTare2.ValueData   ::TFloat AS CountTare2
           , MIFloat_CountTare3.ValueData   ::TFloat AS CountTare3
           , MIFloat_CountTare4.ValueData   ::TFloat AS CountTare4
           , MIFloat_CountTare5.ValueData   ::TFloat AS CountTare5
           , MIFloat_PartionNum.ValueData   ::TFloat AS PartionNum 
           
           , Object_Box1.Id                   AS BoxId_1
           , Object_Box1.ValueData ::TVarChar AS BoxName_1
           , Object_Box2.Id                   AS BoxId_2
           , Object_Box2.ValueData ::TVarChar AS BoxName_2
           , Object_Box3.Id                   AS BoxId_3
           , Object_Box3.ValueData ::TVarChar AS BoxName_3
           , Object_Box4.Id                   AS BoxId_4
           , Object_Box4.ValueData ::TVarChar AS BoxName_4
           , Object_Box5.Id                   AS BoxId_5
           , Object_Box5.ValueData ::TVarChar AS BoxName_5        
           
           , Object_PartionCell.Id                   AS PartionCellId
           , Object_PartionCell.ValueData ::TVarChar AS PartionCellName
           
           , MovementItem.isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemBoolean AS MIBoolean_StartWeighing
                                          ON MIBoolean_StartWeighing.MovementItemId = MovementItem.Id
                                         AND MIBoolean_StartWeighing.DescId = zc_MIBoolean_StartWeighing()
            LEFT JOIN MovementItemBoolean AS MIBoolean_isAuto
                                          ON MIBoolean_isAuto.MovementItemId = MovementItem.Id
                                         AND MIBoolean_isAuto.DescId = zc_MIBoolean_isAuto()

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

            LEFT JOIN MovementItemFloat AS MIFloat_CountTare1
                                        ON MIFloat_CountTare1.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountTare1.DescId = zc_MIFloat_CountTare1()
            LEFT JOIN MovementItemFloat AS MIFloat_CountTare2
                                        ON MIFloat_CountTare2.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountTare2.DescId = zc_MIFloat_CountTare2()
            LEFT JOIN MovementItemFloat AS MIFloat_CountTare3
                                        ON MIFloat_CountTare3.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountTare3.DescId = zc_MIFloat_CountTare3()
            LEFT JOIN MovementItemFloat AS MIFloat_CountTare4
                                        ON MIFloat_CountTare4.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountTare4.DescId = zc_MIFloat_CountTare4()
            LEFT JOIN MovementItemFloat AS MIFloat_CountTare5
                                        ON MIFloat_CountTare5.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountTare5.DescId = zc_MIFloat_CountTare5()

            LEFT JOIN MovementItemFloat AS MIFloat_PartionNum
                                        ON MIFloat_PartionNum.MovementItemId = MovementItem.Id
                                       AND MIFloat_PartionNum.DescId = zc_MIFloat_PartionNum()

            LEFT JOIN MovementItemString AS MIString_PartionGoods
                                         ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                        AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()

            LEFT JOIN MovementItemString AS MIString_KVK
                                         ON MIString_KVK.MovementItemId = MovementItem.Id
                                        AND MIString_KVK.DescId = zc_MIString_KVK()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_StorageLine
                                             ON MILinkObject_StorageLine.MovementItemId = MovementItem.Id
                                            AND MILinkObject_StorageLine.DescId = zc_MILinkObject_StorageLine()
            LEFT JOIN Object AS Object_StorageLine ON Object_StorageLine.Id = MILinkObject_StorageLine.ObjectId

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
                                                  AND Movement_Partion.DescId   IN (zc_Movement_ProductionUnion(), zc_Movement_WeighingPartner(), zc_Movement_WeighingProduction())
            LEFT JOIN MovementItemLinkObject AS MILO_GoodsKindComplete
                                             ON MILO_GoodsKindComplete.MovementItemId = MI_Partion.Id
                                            AND MILO_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
            LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = MILO_GoodsKindComplete.ObjectId
            LEFT JOIN MovementItemFloat AS MIFloat_CuterCount
                                        ON MIFloat_CuterCount.MovementItemId = MI_Partion.Id
                                       AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount()

            LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind_part
                                             ON MILO_GoodsKind_part.MovementItemId = MI_Partion.Id
                                            AND MILO_GoodsKind_part.DescId         = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind_part ON Object_GoodsKind_part.Id = MILO_GoodsKind_part.ObjectId
            LEFT JOIN MovementItemDate AS MIDate_PartionGoods_part
                                       ON MIDate_PartionGoods_part.MovementItemId = MI_Partion.Id
                                      AND MIDate_PartionGoods_part.DescId         = zc_MIDate_PartionGoods()


            LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                             ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = MILinkObject_Asset.ObjectId
            LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset_two
                                             ON MILinkObject_Asset_two.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Asset_two.DescId = zc_MILinkObject_Asset_two()
            LEFT JOIN Object AS Object_Asset_two ON Object_Asset_two.Id = MILinkObject_Asset_two.ObjectId 

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Box1
                                             ON MILinkObject_Box1.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Box1.DescId = zc_MILinkObject_Box1()
            LEFT JOIN Object AS Object_Box1 ON Object_Box1.Id = MILinkObject_Box1.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Box2
                                             ON MILinkObject_Box2.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Box2.DescId = zc_MILinkObject_Box2()
            LEFT JOIN Object AS Object_Box2 ON Object_Box2.Id = MILinkObject_Box2.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Box3
                                             ON MILinkObject_Box3.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Box3.DescId = zc_MILinkObject_Box3()
            LEFT JOIN Object AS Object_Box3 ON Object_Box3.Id = MILinkObject_Box3.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Box4
                                             ON MILinkObject_Box4.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Box4.DescId = zc_MILinkObject_Box4()
            LEFT JOIN Object AS Object_Box4 ON Object_Box4.Id = MILinkObject_Box4.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Box5
                                             ON MILinkObject_Box5.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Box5.DescId = zc_MILinkObject_Box5()
            LEFT JOIN Object AS Object_Box5 ON Object_Box5.Id = MILinkObject_Box5.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell
                                             ON MILinkObject_PartionCell.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionCell.DescId = zc_MILinkObject_PartionCell()
            LEFT JOIN Object AS Object_PartionCell ON Object_PartionCell.Id = MILinkObject_PartionCell.ObjectId
;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_WeighingProduction (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.03.25         *
 18.10.22         * asset
 16.09.21         *
 30.06.21         *
 26.05.17         * add StorageLine
 27.06.15         * add CountPack
 11.03.14         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_WeighingProduction (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= TRUE, inSession:= '2')
