-- Function: gpSelect_MovementItem_WeighingProduction()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_WeighingProduction (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_WeighingProduction(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar, MeasureName TVarChar
             , Amount TFloat
             , StartWeighing Boolean
             , InsertDate TDateTime, UpdateDate TDateTime
             , RealWeight TFloat, WeightTare TFloat, LiveWeight TFloat, HeadCount TFloat,  Count TFloat
             , CountSkewer1 TFloat, WeightSkewer1 TFloat, CountSkewer2 TFloat, WeightSkewer2 TFloat,  WeightOther TFloat
             , PartionGoodsDate TDateTime, PartionGoods TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
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
           , MIDate_Insert.ValueData           AS InsertDate
           , MIDate_Update.ValueData           AS UpdateDate
           
           , MIFloat_RealWeight.ValueData   AS RealWeight
           , MIFloat_WeightTare.ValueData   AS WeightTare
           , MIFloat_LiveWeight.ValueData   AS LiveWeight
           , MIFloat_HeadCount.ValueData    AS HeadCount
           , MIFloat_Count.ValueData        AS Count

           , MIFloat_CountSkewer1.ValueData   AS CountSkewer1
           , MIFloat_WeightSkewer1.ValueData  AS WeightSkewer1
           , MIFloat_CountSkewer2.ValueData   AS CountSkewer2
           , MIFloat_WeightSkewer2.ValueData  AS WeightSkewer2
           , MIFloat_WeightOther.ValueData    AS WeightOther


           , MIDate_PartionGoods.ValueData   AS PartionGoodsDate
           , MIString_PartionGoods.ValueData AS PartionGoods

           , Object_GoodsKind.Id        AS GoodsKindId
           , Object_GoodsKind.ValueData AS GoodsKindName

           , MovementItem.isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased
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
;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_WeighingProduction (Integer, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 11.03.14         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_WeighingProduction (inMovementId:= 25173, inIsErased:= TRUE, inSession:= '2')
