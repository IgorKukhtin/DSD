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
             , ChangePercentAmount TFloat, AmountChangePercent TFloat, ChangePercent TFloat
             , Price TFloat, CountForPrice TFloat
             , PartionGoodsDate TDateTime
             , GoodsKindName TVarChar, MeasureName TVarChar
             , BoxName TVarChar
             , PriceListName  TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , StartBegin TDateTime, EndBegin TDateTime, diffBegin_sec TFloat
             , MovementPromo TVarChar, PricePromo TFloat
             , isBarCode Boolean
             , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , isErased Boolean
              )
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_WeighingPartner());

     -- inShowAll:= TRUE;
     RETURN QUERY 

   WITH tmpMIList AS (SELECT MovementItem.Id AS MovementItemId
                           , MovementItem.*
                           , MIFloat_PromoMovement.ValueData               AS MovementId_Promo
                           , MovementItem.isErased AS isErasedMI
                      FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                           JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                            AND MovementItem.DescId     = zc_MI_Master()
                                            AND MovementItem.isErased   = tmpIsErased.isErased
                           LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                                       ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                                      AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
                     )

         , tmpMIPromo_all AS (SELECT tmp.MovementId_Promo                          AS MovementId_Promo
                                   , MovementItem.Id                               AS MovementItemId
                                   , MovementItem.ObjectId                         AS GoodsId
                                   , MovementItem.Amount                           AS TaxPromo
                                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                              FROM (SELECT DISTINCT tmpMIList.MovementId_Promo :: Integer AS MovementId_Promo FROM tmpMIList WHERE tmpMIList.MovementId_Promo <> 0) AS tmp
                                   INNER JOIN MovementItem ON MovementItem.MovementId = tmp.MovementId_Promo
                                                          AND MovementItem.DescId = zc_MI_Master()
                                                          AND MovementItem.isErased = FALSE
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                             )
             , tmpMIPromo AS (SELECT DISTINCT 
                                     tmpMIPromo_all.MovementId_Promo
                                   , tmpMIPromo_all.GoodsId
                                   , tmpMIPromo_all.GoodsKindId
                                   , CASE WHEN tmpMIPromo_all.TaxPromo <> 0 THEN MIFloat_PriceWithOutVAT.ValueData ELSE 0 END AS PricePromo
                              FROM tmpMIPromo_all
                                   LEFT JOIN MovementItemFloat AS MIFloat_PriceWithOutVAT
                                                               ON MIFloat_PriceWithOutVAT.MovementItemId = tmpMIPromo_all.MovementItemId
                                                              AND MIFloat_PriceWithOutVAT.DescId = zc_MIFloat_PriceWithOutVAT()
                             )
       -- Результат     
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

           , CASE WHEN tmpMI.CountPack = 0    THEN NULL ELSE tmpMI.CountPack    END :: TFloat AS Count
           , CASE WHEN tmpMI.CountPack_mi = 0 THEN NULL ELSE tmpMI.CountPack_mi END :: TFloat AS Count_mi
           , CASE WHEN tmpMI.HeadCount = 0    THEN NULL ELSE tmpMI.HeadCount    END :: TFloat AS HeadCount
           , CASE WHEN tmpMI.HeadCount_mi = 0 THEN NULL ELSE tmpMI.HeadCount_mi END :: TFloat AS HeadCount_mi
           , CASE WHEN tmpMI.BoxCount = 0     THEN NULL ELSE tmpMI.BoxCount     END :: TFloat AS BoxCount
           , CASE WHEN tmpMI.BoxCount_mi = 0  THEN NULL ELSE tmpMI.BoxCount_mi  END :: TFloat AS BoxCount_mi

           , CASE WHEN tmpMI.BoxNumber = 0 THEN NULL ELSE tmpMI.BoxNumber END :: TFloat     AS BoxNumber
           , CASE WHEN tmpMI.LevelNumber = 0 THEN NULL ELSE tmpMI.LevelNumber END :: TFloat AS LevelNumber

           , CASE WHEN tmpMI.ChangePercentAmount = 0 THEN NULL ELSE tmpMI.ChangePercentAmount END :: TFloat AS ChangePercentAmount
           , CASE WHEN tmpMI.AmountChangePercent = 0 THEN NULL ELSE tmpMI.AmountChangePercent END :: TFloat AS AmountChangePercent

           , tmpMI.ChangePercent :: TFloat AS ChangePercent
           , CASE WHEN tmpMI.Price = 0 THEN NULL ELSE tmpMI.Price END :: TFloat                 AS Price
           , CASE WHEN tmpMI.CountForPrice = 0 THEN NULL ELSE tmpMI.CountForPrice END :: TFloat AS CountForPrice
           
           , CASE WHEN tmpMI.PartionGoodsDate = zc_DateStart() THEN NULL ELSE tmpMI.PartionGoodsDate END :: TDateTime AS PartionGoodsDate

           , Object_GoodsKind.ValueData      AS GoodsKindName
           , Object_Measure.ValueData        AS MeasureName
           , Object_Box.ValueData            AS BoxName
           , Object_PriceList.ValueData      AS PriceListName
           
           , CASE WHEN tmpMI.InsertDate = zc_DateStart() THEN NULL ELSE tmpMI.InsertDate END :: TDateTime AS InsertDate
           , CASE WHEN tmpMI.UpdateDate = zc_DateStart() THEN NULL ELSE tmpMI.UpdateDate END :: TDateTime AS UpdateDate

           , tmpMI.StartBegin :: TDateTime
           , tmpMI.EndBegin   :: TDateTime
           , (COALESCE (tmpMI.diffBegin_sec,0)) ::TFloat AS diffBegin_sec

           , zfCalc_PromoMovementName (NULL, Movement_Promo_View.InvNumber :: TVarChar, Movement_Promo_View.OperDate, Movement_Promo_View.StartSale, CASE WHEN MovementFloat_MovementDesc.ValueData = zc_Movement_ReturnIn() THEN Movement_Promo_View.EndReturn ELSE Movement_Promo_View.EndSale END) AS MovementPromo
           , tmpMIPromo.PricePromo :: TFloat AS PricePromo

           , tmpMI.isBarCode

           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName
           , Object_InfoMoney_View.InfoMoneyName_all

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

                  , SUM (tmpMI.CountPack)      AS CountPack
                  , SUM (tmpMI.CountPack_mi)   AS CountPack_mi
                  , SUM (tmpMI.HeadCount)      AS HeadCount
                  , SUM (tmpMI.HeadCount_mi)   AS HeadCount_mi
                  , SUM (tmpMI.BoxCount)       AS BoxCount
                  , SUM (tmpMI.BoxCount_mi)    AS BoxCount_mi

                  , tmpMI.BoxNumber            AS BoxNumber
                  , MAX (tmpMI.LevelNumber)    AS LevelNumber -- MAX

                  , tmpMI.ChangePercentAmount
                  , SUM (tmpMI.AmountChangePercent) AS AmountChangePercent
                  , tmpMI.ChangePercent
                  , tmpMI.Price
                  , tmpMI.CountForPrice
    
                  , tmpMI.PartionGoodsDate
                  , tmpMI.GoodsKindId
                  , tmpMI.BoxId
                  , tmpMI.PriceListId

                  , tmpMI.InsertDate
                  , tmpMI.UpdateDate

                  , MAX (tmpMI.StartBegin) AS StartBegin
                  , MAX (tmpMI.EndBegin)   AS EndBegin
                  , SUM (COALESCE (tmpMI.diffBegin_sec,0)) ::TFloat AS diffBegin_sec

                  , tmpMI.MovementPromoId
                  
                  , tmpMI.isBarCode
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

                  , COALESCE (MIFloat_CountPack.ValueData, 0)           AS CountPack
                  , 0 AS CountPack_mi
                  , COALESCE (MIFloat_HeadCount.ValueData, 0)           AS HeadCount
                  , 0 AS HeadCount_mi
                  , COALESCE (MIFloat_BoxCount.ValueData, 0)            AS BoxCount
                  , 0 AS BoxCount_mi

                  , CASE WHEN inShowAll = TRUE THEN COALESCE (MIFloat_BoxNumber.ValueData, 0)   ELSE 0 END AS BoxNumber
                  , COALESCE (MIFloat_LevelNumber.ValueData, 0) AS LevelNumber

                  , COALESCE (MIFloat_ChangePercentAmount.ValueData, 0) AS ChangePercentAmount
                  , 0 AmountChangePercent

                  , COALESCE (MIFloat_ChangePercent.ValueData, 0)         AS ChangePercent
                  , COALESCE (MIFloat_Price.ValueData, 0) 		  AS Price
                  , COALESCE (MIFloat_CountForPrice.ValueData, 0) 	  AS CountForPrice
           
                  , COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart()) AS PartionGoodsDate
                  
                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                  , CASE WHEN inShowAll = TRUE THEN COALESCE (MILinkObject_Box.ObjectId, 0)       ELSE 0 END AS BoxId
                  , CASE WHEN inShowAll = TRUE THEN COALESCE (MILinkObject_PriceList.ObjectId, 0) ELSE 0 END AS PriceListId
           
                  , CASE WHEN inShowAll = TRUE THEN MIDate_Insert.ValueData ELSE zc_DateStart() END AS InsertDate
                  , CASE WHEN inShowAll = TRUE THEN MIDate_Update.ValueData ELSE zc_DateStart() END AS UpdateDate

                  , COALESCE (MIDate_StartBegin.ValueData,zc_DateStart())  AS StartBegin
                  , COALESCE (MIDate_EndBegin.ValueData,zc_DateStart())    AS EndBegin
                  , EXTRACT (EPOCH FROM (COALESCE (MIDate_EndBegin.ValueData, zc_DateStart()) - COALESCE (MIDate_StartBegin.ValueData, zc_DateStart())) :: INTERVAL) :: TFloat AS diffBegin_sec

                  , COALESCE (MIBoolean_BarCode.ValueData, FALSE) :: Boolean AS isBarCode

                  , MovementItem.isErased
                  
                  , MIFloat_PromoMovement.ValueData AS MovementPromoId

             FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                  INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                         AND MovementItem.DescId     = zc_MI_Master()
                                         AND MovementItem.isErased   = tmpIsErased.isErased

                  LEFT JOIN MovementItemBoolean AS MIBoolean_BarCode
                                                ON MIBoolean_BarCode.MovementItemId =  MovementItem.Id
                                               AND MIBoolean_BarCode.DescId = zc_MIBoolean_BarCode()

                  LEFT JOIN MovementItemDate AS MIDate_Insert
                                             ON MIDate_Insert.MovementItemId = MovementItem.Id
                                            AND MIDate_Insert.DescId = zc_MIDate_Insert()
                  LEFT JOIN MovementItemDate AS MIDate_Update
                                             ON MIDate_Update.MovementItemId = MovementItem.Id
                                            AND MIDate_Update.DescId = zc_MIDate_Update()
                  LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                             ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                            AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

                  LEFT JOIN MovementItemDate AS MIDate_StartBegin
                                             ON MIDate_StartBegin.MovementItemId = MovementItem.Id
                                            AND MIDate_StartBegin.DescId = zc_MIDate_StartBegin()
                  LEFT JOIN MovementItemDate AS MIDate_EndBegin
                                             ON MIDate_EndBegin.MovementItemId = MovementItem.Id
                                            AND MIDate_EndBegin.DescId = zc_MIDate_EndBegin()

                  LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentAmount
                                              ON MIFloat_ChangePercentAmount.MovementItemId = MovementItem.Id
                                             AND MIFloat_ChangePercentAmount.DescId = zc_MIFloat_ChangePercentAmount()
                  LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                              ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                             AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
                  LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                              ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                             AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()

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
                  LEFT JOIN MovementItemFloat AS MIFloat_CountPack
                                              ON MIFloat_CountPack.MovementItemId = MovementItem.Id
                                             AND MIFloat_CountPack.DescId = zc_MIFloat_CountPack()
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

                  , 0                                         AS CountPack
                  , COALESCE (MIFloat_CountPack.ValueData, 0) AS CountPack_mi
                  , 0                                         AS HeadCount
                  , COALESCE (MIFloat_HeadCount.ValueData, 0) AS HeadCount_mi
                  , 0                                         AS BoxCount
                  , COALESCE (MIFloat_BoxCount.ValueData, 0)  AS BoxCount_mi

                  , 0 AS BoxNumber
                  , 0 AS LevelNumber

                  , COALESCE (MIFloat_ChangePercentAmount.ValueData, 0) AS ChangePercentAmount
                  , COALESCE (MIFloat_AmountChangePercent.ValueData, 0) AS AmountChangePercent

                  , COALESCE (MIFloat_ChangePercent.ValueData, 0)         AS ChangePercent
                  , COALESCE (MIFloat_Price.ValueData, 0) 		  AS Price
                  , COALESCE (MIFloat_CountForPrice.ValueData, 0) 	  AS CountForPrice
           
                  , COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart()) AS PartionGoodsDate

                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                  , CASE WHEN inShowAll = TRUE THEN COALESCE (MILinkObject_Box.ObjectId, 0)       ELSE 0 END AS BoxId
                  , 0 AS PriceListId
           
                  , zc_DateStart()  AS InsertDate
                  , zc_DateStart()  AS UpdateDate

                  , zc_DateStart()  AS StartBegin
                  , zc_DateStart()  AS EndBegin
                  , 0     :: TFloat AS diffBegin_sec

                  , COALESCE (MIBoolean_BarCode.ValueData, FALSE) :: Boolean AS isBarCode

                  , MovementItem.isErased
                 
                  , MIFloat_PromoMovement.ValueData :: Integer AS MovementPromoId

             FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                  INNER JOIN Movement ON Movement.Id = inMovementId
                                     AND inShowAll = FALSE
                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement.ParentId
                                         AND MovementItem.DescId     = zc_MI_Master()
                                         AND MovementItem.isErased   = tmpIsErased.isErased

                  LEFT JOIN MovementItemBoolean AS MIBoolean_BarCode
                                                ON MIBoolean_BarCode.MovementItemId =  MovementItem.Id
                                               AND MIBoolean_BarCode.DescId = zc_MIBoolean_BarCode()

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
                  LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                              ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                             AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()

                  LEFT JOIN MovementItemFloat AS MIFloat_CountPack
                                              ON MIFloat_CountPack.MovementItemId = MovementItem.Id
                                             AND MIFloat_CountPack.DescId = zc_MIFloat_CountPack()
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
                  LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                              ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                             AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
                  

            ) AS tmpMI
            GROUP BY tmpMI.MovementItemId
                   , tmpMI.GoodsId
                   , tmpMI.WeightTare
                   , tmpMI.BoxNumber
                   , tmpMI.ChangePercentAmount
                   , tmpMI.ChangePercent
                   , tmpMI.Price
                   , tmpMI.CountForPrice
                   , tmpMI.PartionGoodsDate
                   , tmpMI.GoodsKindId
                   , tmpMI.BoxId
                   , tmpMI.PriceListId
                   , tmpMI.InsertDate
                   , tmpMI.UpdateDate
                   , tmpMI.isBarCode
                   , tmpMI.isErased
                   , tmpMI.MovementPromoId
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
  
            LEFT JOIN Movement_Promo_View ON Movement_Promo_View.Id = tmpMI.MovementPromoId 
            LEFT JOIN tmpMIPromo ON tmpMIPromo.MovementId_Promo = tmpMI.MovementPromoId
                                AND tmpMIPromo.GoodsId          = Object_Goods.Id
                                AND (tmpMIPromo.GoodsKindId     = Object_GoodsKind.Id
                                  OR tmpMIPromo.GoodsKindId     = 0)

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id 
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

            LEFT JOIN MovementFloat AS MovementFloat_MovementDesc
                                    ON MovementFloat_MovementDesc.MovementId =  inMovementId
                                   AND MovementFloat_MovementDesc.DescId = zc_MovementFloat_MovementDesc()

     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_WeighingPartner (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 04.11.19         *
 01.12.15         * promo
 16.10.14                                        * all
 11.03.14         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_WeighingPartner (inMovementId:= 14764281 , inShowAll:= TRUE, inIsErased:= TRUE, inSession:= '2')
