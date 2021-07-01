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
             , HeadCount TFloat, Count TFloat, CountPack TFloat
             , CountSkewer1 TFloat, WeightSkewer1 TFloat
             , CountSkewer2 TFloat, WeightSkewer2 TFloat,  WeightOther TFloat
             , PartionGoodsDate TDateTime, PartionGoods TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , StorageLineId Integer, StorageLineName TVarChar
             , PersonalKVKId Integer, PersonalKVKName TVarChar
             , KVK TVarChar
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
           , MIFloat_CountSkewer1.ValueData   AS CountSkewer1
           , MIFloat_WeightSkewer1.ValueData  AS WeightSkewer1
           , MIFloat_CountSkewer2.ValueData   AS CountSkewer2
           , MIFloat_WeightSkewer2.ValueData  AS WeightSkewer2
           , MIFloat_WeightOther.ValueData    AS WeightOther


           , MIDate_PartionGoods.ValueData   AS PartionGoodsDate

             , CASE WHEN MIString_PartionGoods.ValueData <> ''
                         THEN MIString_PartionGoods.ValueData
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

           , Object_GoodsKind.Id          AS GoodsKindId
           , Object_GoodsKind.ValueData   AS GoodsKindName
 
           , Object_StorageLine.Id        AS StorageLineId
           , Object_StorageLine.ValueData AS StorageLineName
           
           , Object_PersonalKVK.Id        AS PersonalKVKId
           , Object_PersonalKVK.ValueData AS PersonalKVKName
           , MIString_KVK.ValueData       AS KVK

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

;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_WeighingProduction (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 30.06.21         *
 26.05.17         * add StorageLine
 27.06.15         * add CountPack
 11.03.14         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_WeighingProduction (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= TRUE, inSession:= '2')
