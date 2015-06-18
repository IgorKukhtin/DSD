-- Function: gpSelect_ScaleCeh_MI()

DROP FUNCTION IF EXISTS gpSelect_ScaleCeh_MI (Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ScaleCeh_MI(
    IN inIsCeh       Boolean   , --
    IN inMovementId  Integer   , -- ключ Документа
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementItemId Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, MeasureId Integer, MeasureName TVarChar
             , GoodsKindName TVarChar
             , isStartWeighing Boolean
             , Amount TFloat, AmountWeight TFloat
             , RealWeight TFloat, RealWeightWeight TFloat
             , WeightTare TFloat
             , WeightOther TFloat
             , CountSkewer1_k TFloat, CountSkewer1 TFloat, CountSkewer2 TFloat
             , WeightSkewer1_k TFloat, WeightSkewer1 TFloat, WeightSkewer2 TFloat
             , TotalWeightSkewer1_k TFloat, TotalWeightSkewer1 TFloat, TotalWeightSkewer2 TFloat
             , Count TFloat, CountPack TFloat, HeadCount TFloat, LiveWeight TFloat
             , PartionGoods TVarChar, PartionGoodsDate TDateTime
             , InsertDate TDateTime, UpdateDate TDateTime
             , isErased Boolean
              )
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Scale_MI());

     RETURN QUERY 
       SELECT
             tmpMI.MovementItemId
           , Object_Goods.Id                  AS GoodsId
           , Object_Goods.ObjectCode          AS GoodsCode
           , Object_Goods.ValueData           AS GoodsName
           , Object_Measure.Id                AS MeasureId
           , Object_Measure.ValueData         AS MeasureName
           , Object_GoodsKind.ValueData       AS GoodsKindName

           , tmpMI.isStartWeighing :: Boolean AS isStartWeighing

           , tmpMI.Amount :: TFloat           AS Amount
           , (tmpMI.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Kg() THEN 1 WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 0 END) :: TFloat AS AmountWeight

           , tmpMI.RealWeight  :: TFloat      AS RealWeight
           , (tmpMI.RealWeight * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Kg() THEN 1 WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 0 END) :: TFloat AS RealWeightWeight
           , tmpMI.WeightTare  :: TFloat      AS WeightTare
           , tmpMI.WeightOther :: TFloat      AS WeightOther

           , tmpMI.CountSkewer1_k   :: TFloat AS CountSkewer1_k
           , tmpMI.CountSkewer1     :: TFloat AS CountSkewer1
           , tmpMI.CountSkewer2     :: TFloat AS CountSkewer2
           , tmpMI.WeightSkewer1_k  :: TFloat AS WeightSkewer1_k
           , tmpMI.WeightSkewer1    :: TFloat AS WeightSkewer1
           , tmpMI.WeightSkewer2    :: TFloat AS WeightSkewer2
           , (tmpMI.CountSkewer1_k * tmpMI.WeightSkewer1_k) :: TFloat AS TotalWeightSkewer1_k
           , (tmpMI.CountSkewer1   * tmpMI.WeightSkewer1)   :: TFloat AS TotalWeightSkewer1
           , (tmpMI.CountSkewer2   * tmpMI.WeightSkewer2)   :: TFloat AS TotalWeightSkewer2

           , tmpMI.Count       :: TFloat AS Count
           , tmpMI.CountPack   :: TFloat AS CountPack
           , tmpMI.HeadCount   :: TFloat AS HeadCount
           , tmpMI.LiveWeight  :: TFloat AS LiveWeight

           
           , tmpMI.PartionGoods :: TVarChar       AS PartionGoods
           , tmpMI.PartionGoodsDate :: TDateTime  AS PartionGoodsDate

           
           , tmpMI.InsertDate :: TDateTime AS InsertDate
           , tmpMI.UpdateDate :: TDateTime AS UpdateDate

           , tmpMI.isErased

       FROM (SELECT MovementItem.Id AS MovementItemId
                  , MovementItem.ObjectId AS GoodsId
                  , MovementItem.Amount

                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                  , COALESCE (MIBoolean_StartWeighing.ValueData, FALSE) AS isStartWeighing

                  , COALESCE (MIFloat_RealWeight.ValueData, 0)    AS RealWeight
                  , COALESCE (MIFloat_WeightTare.ValueData, 0)    AS WeightTare
                  , COALESCE (MIFloat_WeightOther.ValueData, 0)   AS WeightOther

                  , CASE WHEN inIsCeh = FALSE THEN COALESCE (MIFloat_CountSkewer1.ValueData, 0) ELSE 0 END AS CountSkewer1_k
                  , CASE WHEN inIsCeh = FALSE THEN COALESCE (MIFloat_WeightSkewer1.ValueData, 0) ELSE 0 END AS WeightSkewer1_k

                  , CASE WHEN inIsCeh = TRUE THEN COALESCE (MIFloat_CountSkewer1.ValueData, 0) ELSE 0 END AS CountSkewer1
                  , CASE WHEN inIsCeh = TRUE THEN COALESCE (MIFloat_WeightSkewer1.ValueData, 0) ELSE 0 END AS WeightSkewer1
                  , COALESCE (MIFloat_CountSkewer2.ValueData, 0)  AS CountSkewer2
                  , COALESCE (MIFloat_WeightSkewer2.ValueData, 0) AS WeightSkewer2

                  , COALESCE (MIFloat_Count.ValueData, 0)               AS Count
                  , COALESCE (MIFloat_CountPack.ValueData, 0)           AS CountPack
                  , COALESCE (MIFloat_HeadCount.ValueData, 0)           AS HeadCount
                  , COALESCE (MIFloat_LiveWeight.ValueData, 0)          AS LiveWeight
          
                  , MIString_PartionGoods.ValueData   AS PartionGoods
                  , MIDate_PartionGoods.ValueData     AS PartionGoodsDate

                  , MIDate_Insert.ValueData AS InsertDate
                  , MIDate_Update.ValueData AS UpdateDate

                  , MovementItem.isErased

             FROM MovementItem
                  LEFT JOIN MovementItemDate AS MIDate_Insert
                                             ON MIDate_Insert.MovementItemId = MovementItem.Id
                                            AND MIDate_Insert.DescId = zc_MIDate_Insert()
                  LEFT JOIN MovementItemDate AS MIDate_Update
                                             ON MIDate_Update.MovementItemId = MovementItem.Id
                                            AND MIDate_Update.DescId = zc_MIDate_Update()

                  LEFT JOIN MovementItemBoolean AS MIBoolean_StartWeighing
                                                ON MIBoolean_StartWeighing.MovementItemId = MovementItem.Id
                                               AND MIBoolean_StartWeighing.DescId = zc_MIBoolean_StartWeighing()

                  LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                             ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                            AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                  LEFT JOIN MovementItemString AS MIString_PartionGoods
                                               ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                              AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                                                                 
                  LEFT JOIN MovementItemFloat AS MIFloat_RealWeight
                                              ON MIFloat_RealWeight.MovementItemId = MovementItem.Id
                                             AND MIFloat_RealWeight.DescId = zc_MIFloat_RealWeight()
                  LEFT JOIN MovementItemFloat AS MIFloat_WeightTare
                                              ON MIFloat_WeightTare.MovementItemId = MovementItem.Id
                                             AND MIFloat_WeightTare.DescId = zc_MIFloat_WeightTare()
                  LEFT JOIN MovementItemFloat AS MIFloat_WeightOther
                                              ON MIFloat_WeightOther.MovementItemId = MovementItem.Id
                                             AND MIFloat_WeightOther.DescId = zc_MIFloat_WeightOther()

                  LEFT JOIN MovementItemFloat AS MIFloat_CountSkewer1
                                              ON MIFloat_CountSkewer1.MovementItemId = MovementItem.Id
                                             AND MIFloat_CountSkewer1.DescId = zc_MIFloat_CountSkewer1()
                  LEFT JOIN MovementItemFloat AS MIFloat_CountSkewer2
                                              ON MIFloat_CountSkewer2.MovementItemId = MovementItem.Id
                                             AND MIFloat_CountSkewer2.DescId = zc_MIFloat_CountSkewer2()
                  LEFT JOIN MovementItemFloat AS MIFloat_WeightSkewer1
                                              ON MIFloat_WeightSkewer1.MovementItemId = MovementItem.Id
                                             AND MIFloat_WeightSkewer1.DescId = zc_MIFloat_WeightSkewer1()
                  LEFT JOIN MovementItemFloat AS MIFloat_WeightSkewer2
                                              ON MIFloat_WeightSkewer2.MovementItemId = MovementItem.Id
                                             AND MIFloat_WeightSkewer2.DescId = zc_MIFloat_WeightSkewer2()

                  LEFT JOIN MovementItemFloat AS MIFloat_Count
                                              ON MIFloat_Count.MovementItemId = MovementItem.Id
                                             AND MIFloat_Count.DescId = zc_MIFloat_Count()
                  LEFT JOIN MovementItemFloat AS MIFloat_CountPack
                                              ON MIFloat_CountPack.MovementItemId = MovementItem.Id
                                             AND MIFloat_CountPack.DescId = zc_MIFloat_CountPack()
                  LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                              ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                             AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
                  LEFT JOIN MovementItemFloat AS MIFloat_LiveWeight
                                              ON MIFloat_LiveWeight.MovementItemId = MovementItem.Id
                                             AND MIFloat_LiveWeight.DescId = zc_MIFloat_LiveWeight()

                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.DescId     = zc_MI_Master()
            ) AS tmpMI
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = tmpMI.GoodsId
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

       ORDER BY tmpMI.MovementItemId DESC
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_ScaleCeh_MI (Boolean, Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 08.06.15                                        *
*/

-- тест
-- SELECT * FROM gpSelect_ScaleCeh_MI (TRUE, inMovementId:= 25173, inSession:= '2')
