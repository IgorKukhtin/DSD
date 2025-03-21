-- Function: gpSelect_ScaleCeh_MI()

DROP FUNCTION IF EXISTS gpSelect_ScaleCeh_MI (Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ScaleCeh_MI(
    IN inIsGoodsComplete Boolean   , --
    IN inMovementId      Integer   , -- ключ Документа
    IN inSession         TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementItemId Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, MeasureId Integer, MeasureName TVarChar
             , GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar, StorageLineName TVarChar, AssetId  Integer, AssetName  TVarChar, AssetId_two  Integer, AssetName_two  TVarChar
             , isStartWeighing Boolean
             , Amount TFloat, AmountWeight TFloat, AmountOneWeight TFloat
             , RealWeight TFloat, RealWeightWeight TFloat
             , RealWeight_gd TFloat
             , WeightTare TFloat
             , WeightOther TFloat
             , CountSkewer1_k TFloat, CountSkewer1 TFloat, CountSkewer2 TFloat
             , WeightSkewer1_k TFloat, WeightSkewer1 TFloat, WeightSkewer2 TFloat
             , TotalWeightSkewer1_k TFloat, TotalWeightSkewer1 TFloat, TotalWeightSkewer2 TFloat
             , Count TFloat, CountPack TFloat, WeightPack TFloat, HeadCount TFloat, LiveWeight TFloat
             , PartionGoods TVarChar, PartionGoodsDate TDateTime
             , InsertDate TDateTime, UpdateDate TDateTime
             , isErased Boolean
             , LightColor Integer
             , PersonalId_KVK Integer, PersonalName_KVK TVarChar
             , NumberKVK TVarChar
              )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Scale_MI());
     vbUserId:= lpGetUserBySession (inSession);
     
     -- Еще проверка
     IF NOT EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_WeighingProduction())
     THEN
         RETURN;
     END IF;


     RETURN QUERY
       WITH tmpMI AS
            (SELECT MovementItem.Id AS MovementItemId
                  , MovementItem.ObjectId AS GoodsId
                  , MovementItem.Amount

                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)   AS GoodsKindId
                  , COALESCE (MILinkObject_StorageLine.ObjectId, 0) AS StorageLineId
                  , CASE WHEN MIFloat_PartionCell.ValueData > 0 THEN MIFloat_PartionCell.ValueData ELSE COALESCE (MILinkObject_Asset.ObjectId, 0) END :: Integer AS AssetId
                  , COALESCE (MILinkObject_Asset_two.ObjectId, 0)   AS AssetId_two

                  , COALESCE (MIBoolean_StartWeighing.ValueData, FALSE) AS isStartWeighing

                  , COALESCE (MIFloat_RealWeight.ValueData, 0)    AS RealWeight
                  , COALESCE (MIFloat_WeightTare.ValueData, 0)    AS WeightTare
                  , COALESCE (MIFloat_WeightOther.ValueData, 0)   AS WeightOther

                  , CASE WHEN inIsGoodsComplete = FALSE THEN COALESCE (MIFloat_CountSkewer1.ValueData, 0) ELSE 0 END AS CountSkewer1_k
                  , CASE WHEN inIsGoodsComplete = FALSE THEN COALESCE (MIFloat_WeightSkewer1.ValueData, 0) ELSE 0 END AS WeightSkewer1_k

                  , CASE WHEN inIsGoodsComplete = TRUE THEN COALESCE (MIFloat_CountSkewer1.ValueData, 0) ELSE 0 END AS CountSkewer1
                  , CASE WHEN inIsGoodsComplete = TRUE THEN COALESCE (MIFloat_WeightSkewer1.ValueData, 0) ELSE 0 END AS WeightSkewer1
                  , COALESCE (MIFloat_CountSkewer2.ValueData, 0)  AS CountSkewer2
                  , COALESCE (MIFloat_WeightSkewer2.ValueData, 0) AS WeightSkewer2

                  , COALESCE (MIFloat_Count.ValueData, 0)               AS Count
                    -- Количество упаковок
                  , COALESCE (MIFloat_CountPack.ValueData, 0)           AS CountPack
                    -- Вес 1-ой упаковки
                  , COALESCE (MIFloat_WeightPack.ValueData, 0)          AS WeightPack
                    --
                  , COALESCE (MIFloat_HeadCount.ValueData, 0)           AS HeadCount
                  , COALESCE (MIFloat_LiveWeight.ValueData, 0)          AS LiveWeight

                  , MIString_PartionGoods.ValueData AS PartionGoods

                  , MIDate_PartionGoods.ValueData     AS PartionGoodsDate
                  , CASE WHEN MIFloat_MovementItemId.ValueData > 0 THEN MIFloat_MovementItemId.ValueData ELSE NULL END :: Integer AS MovementItemId_Partion

                  , MIDate_Insert.ValueData AS InsertDate
                  , MIDate_Update.ValueData AS UpdateDate

                  , MovementItem.isErased

                  , Object_PersonalKVK.Id        AS PersonalId_KVK
                  , Object_PersonalKVK.ValueData AS PersonalName_KVK
                  , MIString_KVK.ValueData       AS NumberKVK

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
                  LEFT JOIN MovementItemString AS MIString_KVK
                                               ON MIString_KVK.MovementItemId = MovementItem.Id
                                              AND MIString_KVK.DescId = zc_MIString_KVK()

                  LEFT JOIN MovementItemLinkObject AS MILinkObject_PersonalKVK
                                                   ON MILinkObject_PersonalKVK.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_PersonalKVK.DescId = zc_MILinkObject_PersonalKVK()
                  LEFT JOIN Object AS Object_PersonalKVK ON Object_PersonalKVK.Id = MILinkObject_PersonalKVK.ObjectId

                  LEFT JOIN MovementItemFloat AS MIFloat_PartionCell
                                              ON MIFloat_PartionCell.MovementItemId = MovementItem.Id
                                             AND MIFloat_PartionCell.DescId = zc_MIFloat_PartionCell()

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
                  LEFT JOIN MovementItemFloat AS MIFloat_WeightPack
                                              ON MIFloat_WeightPack.MovementItemId = MovementItem.Id
                                             AND MIFloat_WeightPack.DescId = zc_MIFloat_WeightPack()

                  LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                              ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                             AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
                  LEFT JOIN MovementItemFloat AS MIFloat_LiveWeight
                                              ON MIFloat_LiveWeight.MovementItemId = MovementItem.Id
                                             AND MIFloat_LiveWeight.DescId = zc_MIFloat_LiveWeight()

                  LEFT JOIN MovementItemFloat AS MIFloat_MovementItemId
                                              ON MIFloat_MovementItemId.MovementItemId = MovementItem.Id
                                             AND MIFloat_MovementItemId.DescId = zc_MIFloat_MovementItemId()

                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_StorageLine
                                                   ON MILinkObject_StorageLine.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_StorageLine.DescId = zc_MILinkObject_StorageLine()
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                   ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_Asset.DescId         = zc_MILinkObject_Asset()
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset_two
                                                   ON MILinkObject_Asset_two.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_Asset_two.DescId         = zc_MILinkObject_Asset_two()

             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.DescId     = zc_MI_Master()
            )
       SELECT
             tmpMI.MovementItemId
           , Object_Goods.Id                  AS GoodsId
           , Object_Goods.ObjectCode          AS GoodsCode
           , Object_Goods.ValueData           AS GoodsName
           , Object_Measure.Id                AS MeasureId
           , Object_Measure.ValueData         AS MeasureName

           , Object_GoodsKind.Id              AS GoodsKindId

           , Object_GoodsKind.ObjectCode      AS GoodsKindCode
           , CASE WHEN Object_GoodsKind.ValueData <> ''
                       THEN Object_GoodsKind.ValueData
                  WHEN MI_Partion.Id > 0
                       THEN Object_GoodsKindComplete.ValueData
             END :: TVarChar AS GoodsKindName

           , Object_StorageLine.ValueData     AS StorageLineName

           , Object_Asset.Id                 AS  AssetId
           , (Object_Asset.ValueData || ' (' || Object_Asset.ObjectCode :: TVarChar || ')' || CASE WHEN ObjectString_Asset_InvNumber.ValueData  <> '' THEN ' (' || ObjectString_Asset_InvNumber.ValueData || ')'  ELSE '' END) :: TVarChar AS AssetName
           , Object_Asset_two.Id                 AS  AssetId_two
           , (Object_Asset_two.ValueData || ' (' || Object_Asset_two.ObjectCode :: TVarChar || ')' || CASE WHEN ObjectString_Asset_InvNumber_two.ValueData  <> '' THEN ' (' || ObjectString_Asset_InvNumber_two.ValueData || ')'  ELSE '' END) :: TVarChar AS AssetName_two

           , tmpMI.isStartWeighing :: Boolean AS isStartWeighing

           , tmpMI.Amount :: TFloat           AS Amount
           , (tmpMI.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Kg() THEN 1 WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 0 END) :: TFloat AS AmountWeight
           , CASE WHEN tmpMI.Count > 0 THEN CAST ((tmpMI.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Kg() THEN 1 WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 0 END) / tmpMI.Count AS NUMERIC (16, 3)) ELSE 0 END :: TFloat AS AmountOneWeight

           , tmpMI.RealWeight  :: TFloat      AS RealWeight
           , (tmpMI.RealWeight * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Kg() THEN 1 WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 0 END) :: TFloat AS RealWeightWeight
             -- Вес за минусом втулок и тары
           , CASE WHEN Object_Measure.Id NOT IN (zc_Measure_Kg(), zc_Measure_Sh())
                   AND ObjectFloat_Weight.ValueData > 0
                       THEN tmpMI.RealWeight /*- COALESCE (tmpMI.WeightTare, 0)*/ - COALESCE (ObjectFloat_WeightTare.ValueData, 0) * COALESCE (tmpMI.Count, 0) - tmpMI.WeightTare
                  ELSE 0
             END :: TFloat AS RealWeight_gd
             --
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

             -- Количество упаковок
           , tmpMI.CountPack   :: TFloat AS CountPack
             -- Вес 1-ой упаковки
           , tmpMI.WeightPack   :: TFloat AS WeightPack

           , tmpMI.HeadCount   :: TFloat AS HeadCount
           , tmpMI.LiveWeight  :: TFloat AS LiveWeight

--                  , CASE WHEN MIString_PartionGoods.ValueData = (MIFloat_MovementItemId.ValueData :: Integer) :: TVarChar THEN '*' || MIString_PartionGoods.ValueData
--                         WHEN vbUserId <> 5 AND MIString_PartionGoods.ValueData <> '' THEN MIString_PartionGoods.ValueData
--                         WHEN MIFloat_MovementItemId.ValueData > 0 THEN '*' || (MIFloat_MovementItemId.ValueData :: Integer) :: TVarChar
--                         ELSE NULL
--                    END :: TVarChar AS PartionGoods

           , CASE WHEN tmpMI.PartionGoods <> ''
                       THEN tmpMI.PartionGoods
                  WHEN MI_Partion.Id > 0
                       THEN
                       ('кол.=<' || zfConvert_FloatToString (COALESCE (MI_Partion.Amount, 0)) || '>'
                     || ' кут.=<' || zfConvert_FloatToString (COALESCE (MIFloat_CuterCount.ValueData, 0)) || '>'
                     || ' вид=<' || COALESCE (Object_GoodsKindComplete.ValueData, '') || '>'
                     || ' партия=<' || DATE (COALESCE (Movement_Partion.OperDate, zc_DateEnd())) || '>'
                     || ' № <' || COALESCE (Movement_Partion.InvNumber, '') || '>'
                       )
                  ELSE tmpMI.MovementItemId_Partion :: TVarChar
             END :: TVarChar AS PartionGoods

           , CASE WHEN COALESCE (tmpMI.PartionGoodsDate, zc_DateStart()) <> zc_DateStart()
                       THEN tmpMI.PartionGoodsDate
                  WHEN MI_Partion.Id > 0
                       THEN Movement_Partion.OperDate
             END :: TDateTime  AS PartionGoodsDate


           , tmpMI.InsertDate :: TDateTime AS InsertDate
           , tmpMI.UpdateDate :: TDateTime AS UpdateDate

           , tmpMI.isErased

           , 0 :: Integer AS LightColor

           , tmpMI.PersonalId_KVK
           , tmpMI.PersonalName_KVK
           , tmpMI.NumberKVK

       FROM tmpMI
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId
            LEFT JOIN Object AS Object_StorageLine ON Object_StorageLine.Id = tmpMI.StorageLineId
            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = tmpMI.AssetId
            LEFT JOIN Object AS Object_Asset_two ON Object_Asset_two.Id = tmpMI.AssetId_two

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = tmpMI.GoodsId
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
            LEFT JOIN ObjectFloat AS ObjectFloat_WeightTare
                                  ON ObjectFloat_WeightTare.ObjectId = tmpMI.GoodsId
                                 AND ObjectFloat_WeightTare.DescId   = zc_ObjectFloat_Goods_WeightTare()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Asset_InvNumber
                                   ON ObjectString_Asset_InvNumber.ObjectId = Object_Asset.Id
                                  AND ObjectString_Asset_InvNumber.DescId = zc_ObjectString_Asset_InvNumber()
            LEFT JOIN ObjectString AS ObjectString_Asset_InvNumber_two
                                   ON ObjectString_Asset_InvNumber_two.ObjectId = Object_Asset_two.Id
                                  AND ObjectString_Asset_InvNumber_two.DescId = zc_ObjectString_Asset_InvNumber()

            LEFT JOIN MovementItem AS MI_Partion ON MI_Partion.Id = tmpMI.MovementItemId_Partion
            LEFT JOIN Movement AS Movement_Partion ON Movement_Partion.Id       = MI_Partion.MovementId
                                                  AND Movement_Partion.DescId   = zc_Movement_ProductionUnion()
            LEFT JOIN MovementItemLinkObject AS MILO_GoodsKindComplete
                                             ON MILO_GoodsKindComplete.MovementItemId = MI_Partion.Id
                                            AND MILO_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
            LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = MILO_GoodsKindComplete.ObjectId
            LEFT JOIN MovementItemFloat AS MIFloat_CuterCount
                                        ON MIFloat_CuterCount.MovementItemId = MI_Partion.Id
                                       AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount()
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
-- SELECT * FROM gpSelect_ScaleCeh_MI (inIsGoodsComplete:= 'True', inMovementId:= 25410219, inSession:= '5');
