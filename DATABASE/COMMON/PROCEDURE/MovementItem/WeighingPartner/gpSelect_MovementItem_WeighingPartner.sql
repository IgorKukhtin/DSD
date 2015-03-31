-- Function: gpSelect_MovementItem_WeighingPartner()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_WeighingPartner (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_WeighingPartner(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar
             , Amount TFloat, Amount_mi TFloat, AmountPartner TFloat, AmountPartner_mi TFloat
             , RealWeight TFloat, CountTare TFloat, WeightTare TFloat
             , Count TFloat, Count_mi TFloat, HeadCount TFloat, HeadCount_mi TFloat, BoxCount TFloat, BoxCount_mi TFloat
             , BoxNumber TFloat, LevelNumber TFloat
             , ChangePercentAmount TFloat, AmountChangePercent TFloat
             , Price TFloat, CountForPrice TFloat
             , PartionGoodsDate TDateTime
             , GoodsKindName TVarChar, MeasureName TVarChar
             , BoxName TVarChar
             , PriceListName  TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , isErased Boolean
              )
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_WeighingPartner());

     -- inShowAll:= TRUE;
     RETURN QUERY 
       SELECT
             tmpMI.MovementItemId :: Integer  AS Id
           , Object_Goods.ObjectCode          AS GoodsCode
           , Object_Goods.ValueData           AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , tmpMI.Amount :: TFloat           AS Amount
           , tmpMI.Amount_mi :: TFloat        AS Amount_mi

           , CASE WHEN tmpMI.AmountPartner = 0 THEN NULL ELSE tmpMI.AmountPartner END :: TFloat       AS AmountPartner
           , CASE WHEN tmpMI.AmountPartner_mi = 0 THEN NULL ELSE tmpMI.AmountPartner_mi END :: TFloat AS AmountPartner_mi

           , tmpMI.RealWeight  :: TFloat      AS RealWeight
           , tmpMI.CountTare   :: TFloat      AS CountTare
           , CASE WHEN inShowAll = TRUE THEN tmpMI.WeightTare WHEN tmpMI.CountTare <> 0 THEN (tmpMI.RealWeight - tmpMI.Amount) / tmpMI.CountTare ELSE 0 END :: TFloat AS WeightTare

           , CASE WHEN tmpMI.Count = 0        THEN NULL ELSE tmpMI.Count        END :: TFloat AS Count
           , CASE WHEN tmpMI.Count_mi = 0     THEN NULL ELSE tmpMI.Count_mi     END :: TFloat AS Count_mi
           , CASE WHEN tmpMI.HeadCount = 0    THEN NULL ELSE tmpMI.HeadCount    END :: TFloat AS HeadCount
           , CASE WHEN tmpMI.HeadCount_mi = 0 THEN NULL ELSE tmpMI.HeadCount_mi END :: TFloat AS HeadCount_mi
           , CASE WHEN tmpMI.BoxCount = 0     THEN NULL ELSE tmpMI.BoxCount     END :: TFloat AS BoxCount
           , CASE WHEN tmpMI.BoxCount_mi = 0  THEN NULL ELSE tmpMI.BoxCount_mi  END :: TFloat AS BoxCount_mi

           , CASE WHEN tmpMI.BoxNumber = 0 THEN NULL ELSE tmpMI.BoxNumber END :: TFloat     AS BoxNumber
           , CASE WHEN tmpMI.LevelNumber = 0 THEN NULL ELSE tmpMI.LevelNumber END :: TFloat AS LevelNumber

           , CASE WHEN tmpMI.ChangePercentAmount = 0 THEN NULL ELSE tmpMI.ChangePercentAmount END :: TFloat AS ChangePercentAmount
           , CASE WHEN tmpMI.AmountChangePercent = 0 THEN NULL ELSE tmpMI.AmountChangePercent END :: TFloat AS AmountChangePercent

           , CASE WHEN tmpMI.Price = 0 THEN NULL ELSE tmpMI.Price END :: TFloat                 AS Price
           , CASE WHEN tmpMI.CountForPrice = 0 THEN NULL ELSE tmpMI.CountForPrice END :: TFloat AS CountForPrice
           
           , CASE WHEN tmpMI.PartionGoodsDate = zc_DateStart() THEN NULL ELSE tmpMI.PartionGoodsDate END :: TDateTime AS PartionGoodsDate

           , Object_GoodsKind.ValueData      AS GoodsKindName
           , Object_Measure.ValueData        AS MeasureName
           , Object_Box.ValueData            AS BoxName
           , Object_PriceList.ValueData      AS PriceListName
           
           , CASE WHEN tmpMI.InsertDate = zc_DateStart() THEN NULL ELSE tmpMI.InsertDate END :: TDateTime AS InsertDate
           , CASE WHEN tmpMI.UpdateDate = zc_DateStart() THEN NULL ELSE tmpMI.UpdateDate END :: TDateTime AS UpdateDate

           , tmpMI.isErased

       FROM (SELECT tmpMI.MovementItemId
                  , tmpMI.GoodsId
                  , SUM (tmpMI.Amount)           AS Amount
                  , SUM (tmpMI.Amount_mi)        AS Amount_mi
                  , SUM (tmpMI.AmountPartner)    AS AmountPartner
                  , SUM (tmpMI.AmountPartner_mi) AS AmountPartner_mi

                  , SUM (tmpMI.RealWeight)     AS RealWeight
                  , SUM (tmpMI.CountTare)      AS CountTare
                  , tmpMI.WeightTare           AS WeightTare

                  , SUM (tmpMI.Count)          AS Count
                  , SUM (tmpMI.Count_mi)       AS Count_mi
                  , SUM (tmpMI.HeadCount)      AS HeadCount
                  , SUM (tmpMI.HeadCount_mi)   AS HeadCount_mi
                  , SUM (tmpMI.BoxCount)       AS BoxCount
                  , SUM (tmpMI.BoxCount_mi)    AS BoxCount_mi

                  , tmpMI.BoxNumber            AS BoxNumber
                  , MAX (tmpMI.LevelNumber)    AS LevelNumber -- MAX

                  , tmpMI.ChangePercentAmount
                  , SUM (tmpMI.AmountChangePercent) AS AmountChangePercent
                  , tmpMI.Price
                  , tmpMI.CountForPrice
    
                  , tmpMI.PartionGoodsDate
                  , tmpMI.GoodsKindId
                  , tmpMI.BoxId
                  , tmpMI.PriceListId

                  , tmpMI.InsertDate
                  , tmpMI.UpdateDate

                  , tmpMI.isErased
             FROM
            (SELECT CASE WHEN inShowAll = TRUE THEN MovementItem.Id ELSE 0 END :: Integer AS MovementItemId
                  , MovementItem.ObjectId AS GoodsId
                  , MovementItem.Amount
                  , 0 AS Amount_mi

                  , COALESCE (MIFloat_AmountPartner.ValueData, 0) AS AmountPartner
                  , 0                                             AS AmountPartner_mi

                  , COALESCE (MIFloat_RealWeight.ValueData, 0)          AS RealWeight
                  , COALESCE (MIFloat_CountTare.ValueData, 0)           AS CountTare
                  , CASE WHEN inShowAll = TRUE THEN COALESCE (MIFloat_WeightTare.ValueData, 0) ELSE 0 END AS WeightTare

                  , COALESCE (MIFloat_Count.ValueData, 0)               AS Count
                  , 0 AS Count_mi
                  , COALESCE (MIFloat_HeadCount.ValueData, 0)           AS HeadCount
                  , 0 AS HeadCount_mi
                  , COALESCE (MIFloat_BoxCount.ValueData, 0)            AS BoxCount
                  , 0 AS BoxCount_mi

                  , CASE WHEN inShowAll = TRUE THEN COALESCE (MIFloat_BoxNumber.ValueData, 0)   ELSE 0 END AS BoxNumber
                  , COALESCE (MIFloat_LevelNumber.ValueData, 0) AS LevelNumber

                  , COALESCE (MIFloat_ChangePercentAmount.ValueData, 0) AS ChangePercentAmount
                  , 0 AmountChangePercent

                  , COALESCE (MIFloat_Price.ValueData, 0) 		  AS Price
                  , COALESCE (MIFloat_CountForPrice.ValueData, 0) 	  AS CountForPrice
           
                  , COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart()) AS PartionGoodsDate

                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                  , CASE WHEN inShowAll = TRUE THEN COALESCE (MILinkObject_Box.ObjectId, 0)       ELSE 0 END AS BoxId
                  , CASE WHEN inShowAll = TRUE THEN COALESCE (MILinkObject_PriceList.ObjectId, 0) ELSE 0 END AS PriceListId
           
                  , CASE WHEN inShowAll = TRUE THEN MIDate_Insert.ValueData ELSE zc_DateStart() END AS InsertDate
                  , CASE WHEN inShowAll = TRUE THEN MIDate_Update.ValueData ELSE zc_DateStart() END AS UpdateDate

                  , MovementItem.isErased

             FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                  INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                         AND MovementItem.DescId     = zc_MI_Master()
                                         AND MovementItem.isErased   = tmpIsErased.isErased

                  LEFT JOIN MovementItemDate AS MIDate_Insert
                                             ON MIDate_Insert.MovementItemId = MovementItem.Id
                                            AND MIDate_Insert.DescId = zc_MIDate_Insert()
                  LEFT JOIN MovementItemDate AS MIDate_Update
                                             ON MIDate_Update.MovementItemId = MovementItem.Id
                                            AND MIDate_Update.DescId = zc_MIDate_Update()
                  LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                             ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                            AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                                                 
                  LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentAmount
                                              ON MIFloat_ChangePercentAmount.MovementItemId = MovementItem.Id
                                             AND MIFloat_ChangePercentAmount.DescId = zc_MIFloat_ChangePercentAmount()

                  LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                              ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                             AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                  LEFT JOIN MovementItemFloat AS MIFloat_RealWeight
                                              ON MIFloat_RealWeight.MovementItemId = MovementItem.Id
                                             AND MIFloat_RealWeight.DescId = zc_MIFloat_RealWeight()
                  LEFT JOIN MovementItemFloat AS MIFloat_CountTare
                                              ON MIFloat_CountTare.MovementItemId = MovementItem.Id
                                             AND MIFloat_CountTare.DescId = zc_MIFloat_CountTare()
                  LEFT JOIN MovementItemFloat AS MIFloat_WeightTare
                                              ON MIFloat_WeightTare.MovementItemId = MovementItem.Id
                                             AND MIFloat_WeightTare.DescId = zc_MIFloat_WeightTare()
                  LEFT JOIN MovementItemFloat AS MIFloat_Count
                                              ON MIFloat_Count.MovementItemId = MovementItem.Id
                                             AND MIFloat_Count.DescId = zc_MIFloat_Count()
                  LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                              ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                             AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()

                  LEFT JOIN MovementItemFloat AS MIFloat_BoxCount
                                              ON MIFloat_BoxCount.MovementItemId = MovementItem.Id
                                             AND MIFloat_BoxCount.DescId = zc_MIFloat_BoxCount()
                  LEFT JOIN MovementItemFloat AS MIFloat_BoxNumber
                                              ON MIFloat_BoxNumber.MovementItemId = MovementItem.Id
                                             AND MIFloat_BoxNumber.DescId = zc_MIFloat_BoxNumber()
                  LEFT JOIN MovementItemFloat AS MIFloat_LevelNumber
                                              ON MIFloat_LevelNumber.MovementItemId = MovementItem.Id
                                             AND MIFloat_LevelNumber.DescId = zc_MIFloat_LevelNumber()

                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                              ON MIFloat_Price.MovementItemId = MovementItem.Id
                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()
                  LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                              ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                             AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                                             AND MIFloat_Price.ValueData <> 0 -- !!!временно!!!

                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Box
                                                   ON MILinkObject_Box.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_Box.DescId = zc_MILinkObject_Box()

                  LEFT JOIN MovementItemLinkObject AS MILinkObject_PriceList
                                                   ON MILinkObject_PriceList.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_PriceList.DescId = zc_MILinkObject_PriceList()
            UNION ALL
             SELECT CASE WHEN inShowAll = TRUE THEN MovementItem.Id ELSE 0 END :: Integer AS MovementItemId
                  , MovementItem.ObjectId AS GoodsId

                  , 0 AS Amount
                  , MovementItem.Amount AS Amount_mi

                  , 0                                             AS AmountPartner
                  , COALESCE (MIFloat_AmountPartner.ValueData, 0) AS AmountPartner_mi

                  , 0 AS RealWeight
                  , 0 AS CountTare
                  , 0 AS WeightTare

                  , 0                                         AS Count
                  , COALESCE (MIFloat_Count.ValueData, 0)     AS Count_mi
                  , 0                                         AS HeadCount
                  , COALESCE (MIFloat_HeadCount.ValueData, 0) AS HeadCount_mi
                  , 0                                         AS BoxCount
                  , COALESCE (MIFloat_BoxCount.ValueData, 0)  AS BoxCount_mi

                  , 0 AS BoxNumber
                  , 0 AS LevelNumber

                  , COALESCE (MIFloat_ChangePercentAmount.ValueData, 0) AS ChangePercentAmount
                  , COALESCE (MIFloat_AmountChangePercent.ValueData, 0) AS AmountChangePercent

                  , COALESCE (MIFloat_Price.ValueData, 0) 		  AS Price
                  , COALESCE (MIFloat_CountForPrice.ValueData, 0) 	  AS CountForPrice
           
                  , COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart()) AS PartionGoodsDate

                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                  , CASE WHEN inShowAll = TRUE THEN COALESCE (MILinkObject_Box.ObjectId, 0)       ELSE 0 END AS BoxId
                  , 0 AS PriceListId
           
                  , zc_DateStart() AS InsertDate
                  , zc_DateStart() AS UpdateDate

                  , MovementItem.isErased

             FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                  INNER JOIN Movement ON Movement.Id = inMovementId
                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement.ParentId
                                         AND MovementItem.DescId     = zc_MI_Master()
                                         AND MovementItem.isErased   = tmpIsErased.isErased

                  LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                             ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                            AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

                  LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                              ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                             AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                  LEFT JOIN MovementItemFloat AS MIFloat_AmountChangePercent
                                              ON MIFloat_AmountChangePercent.MovementItemId = MovementItem.Id
                                             AND MIFloat_AmountChangePercent.DescId = zc_MIFloat_AmountChangePercent()
                  LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentAmount
                                              ON MIFloat_ChangePercentAmount.MovementItemId = MovementItem.Id
                                             AND MIFloat_ChangePercentAmount.DescId = zc_MIFloat_ChangePercentAmount()

                  LEFT JOIN MovementItemFloat AS MIFloat_Count
                                              ON MIFloat_Count.MovementItemId = MovementItem.Id
                                             AND MIFloat_Count.DescId = zc_MIFloat_Count()
                  LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                              ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                             AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()

                  LEFT JOIN MovementItemFloat AS MIFloat_BoxCount
                                              ON MIFloat_BoxCount.MovementItemId = MovementItem.Id
                                             AND MIFloat_BoxCount.DescId = zc_MIFloat_BoxCount()

                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                              ON MIFloat_Price.MovementItemId = MovementItem.Id
                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()
                  LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                              ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                             AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                                             AND MIFloat_Price.ValueData <> 0 -- !!!временно!!!

                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Box
                                                   ON MILinkObject_Box.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_Box.DescId = zc_MILinkObject_Box()

                  LEFT JOIN MovementItemLinkObject AS MILinkObject_PriceList
                                                   ON MILinkObject_PriceList.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_PriceList.DescId = zc_MILinkObject_PriceList()
            ) AS tmpMI
            GROUP BY tmpMI.MovementItemId
                   , tmpMI.GoodsId
                   , tmpMI.WeightTare
                   , tmpMI.BoxNumber
                   , tmpMI.ChangePercentAmount
                   , tmpMI.Price
                   , tmpMI.CountForPrice
                   , tmpMI.PartionGoodsDate
                   , tmpMI.GoodsKindId
                   , tmpMI.BoxId
                   , tmpMI.PriceListId
                   , tmpMI.InsertDate
                   , tmpMI.UpdateDate
                   , tmpMI.isErased
            ) AS tmpMI
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId
            LEFT JOIN Object AS Object_Box ON Object_Box.Id = tmpMI.BoxId
            LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = tmpMI.PriceListId
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_WeighingPartner (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 16.10.14                                        * all
 11.03.14         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_WeighingPartner (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= TRUE, inSession:= '2')