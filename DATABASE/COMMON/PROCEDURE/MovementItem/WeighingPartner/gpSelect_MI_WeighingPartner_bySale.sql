-- Function: gpSelect_MI_WeighingPartner_bySale()

DROP FUNCTION IF EXISTS gpSelect_MI_WeighingPartner_bySale (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_WeighingPartner_bySale(
    IN inMovementId_sale  Integer      , -- ключ Документа продажа
    IN inGoodsId          Integer      , --
    IN inGoodsKindId      Integer      , --
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, OperDate TDateTime, OperDatePartner TDateTime, InvNumber TVarChar
             , StartWeighing TDateTime, EndWeighing TDateTime
             , Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar
             , Amount TFloat, AmountPartner TFloat
             , RealWeight TFloat, CountTare TFloat, WeightTare TFloat
             , CountTare1   TFloat
             , CountTare2   TFloat
             , CountTare3   TFloat
             , CountTare4   TFloat
             , CountTare5   TFloat
             , CountTare6   TFloat
             , WeightTare1  TFloat
             , WeightTare2  TFloat
             , WeightTare3  TFloat
             , WeightTare4  TFloat
             , WeightTare5  TFloat
             , WeightTare6  TFloat
             , Count TFloat, HeadCount TFloat, BoxCount TFloat
             , BoxNumber TFloat, LevelNumber TFloat
             , ChangePercentAmount TFloat, ChangePercent TFloat
             , Price TFloat, CountForPrice TFloat
             , PartionGoodsDate TDateTime
             , GoodsKindName TVarChar, MeasureName TVarChar
             , BoxName TVarChar
             , PriceListName  TVarChar
             , ReasonName TVarChar
             , AssetName TVarChar, AssetName_two TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , StartBegin TDateTime, EndBegin TDateTime, diffBegin_sec TFloat
             , MovementPromo TVarChar--, PricePromo TFloat
             , isBarCode Boolean
             , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE inShowAll Boolean;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     inShowAll:= TRUE;
     RETURN QUERY

   WITH -- Взвешивания
   tmpWeighingPartner AS (SELECT Movement.*
                               , MovementDate_OperDatePartner.ValueData ::TDateTime AS OperDatePartner
                               , MovementDate_StartWeighing.ValueData  AS StartWeighing
                               , MovementDate_EndWeighing.ValueData    AS EndWeighing
                          FROM Movement
                               LEFT JOIN MovementDate AS MovementDate_StartWeighing
                                                      ON MovementDate_StartWeighing.MovementId =  Movement.Id
                                                     AND MovementDate_StartWeighing.DescId = zc_MovementDate_StartWeighing()
                               LEFT JOIN MovementDate AS MovementDate_EndWeighing
                                                      ON MovementDate_EndWeighing.MovementId =  Movement.Id
                                                     AND MovementDate_EndWeighing.DescId = zc_MovementDate_EndWeighing()
                               LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                      ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                                     AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                          WHERE Movement.ParentId = inMovementId_sale
                            AND Movement.DescId   = zc_Movement_WeighingPartner()
                          )

 , tmpMovementItem AS (SELECT tmpWeighingPartner.Id AS MovementId
                            , tmpWeighingPartner.InvNumber
                            , tmpWeighingPartner.OperDate
                            , tmpWeighingPartner.OperDatePartner
                            , tmpWeighingPartner.StartWeighing
                            , tmpWeighingPartner.EndWeighing
                            , MovementItem.ObjectId
                            , MovementItem.Amount
                            , MovementItem.Id
                       FROM tmpWeighingPartner
                            INNER JOIN MovementItem ON MovementItem.MovementId = tmpWeighingPartner.Id
                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                   AND MovementItem.isErased   = FALSE
                                                   AND (MovementItem.ObjectId = inGoodsId OR inGoodsId = 0)
                       )

 , tmpMILO AS (SELECT MovementItemLinkObject.*
               FROM MovementItemLinkObject
               WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMovementItem.Id FROM tmpMovementItem)
                 AND MovementItemLinkObject.DescId IN (zc_MILinkObject_PriceList()
                                              , zc_MILinkObject_Reason()
                                              , zc_MILinkObject_GoodsKind()
                                              , zc_MILinkObject_Box()
                                              , zc_MILinkObject_Asset()
                                              , zc_MILinkObject_Asset_two()
                                              )
               )

 , tmpMIDate AS (SELECT MovementItemDate.*
                 FROM MovementItemDate
                 WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpMovementItem.Id FROM tmpMovementItem)
                   AND MovementItemDate.DescId IN (zc_MIDate_Insert()
                                                 , zc_MIDate_Update()
                                                 , zc_MIDate_PartionGoods()
                                                 , zc_MIDate_StartBegin()
                                                 , zc_MIDate_EndBegin()
                                                  )
                 )

 , tmpMIFloat AS (SELECT MovementItemFloat.*
                  FROM MovementItemFloat
                  WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMovementItem.Id FROM tmpMovementItem)
                  )

 , tmpMI AS (SELECT MovementItem.MovementId
                  , MovementItem.InvNumber
                  , MovementItem.OperDate 
                  , MovementItem.OperDatePartner
                  , MovementItem.StartWeighing
                  , MovementItem.EndWeighing
                  , CASE WHEN inShowAll = TRUE THEN MovementItem.Id ELSE 0 END :: Integer AS MovementItemId
                  , MovementItem.ObjectId AS GoodsId
                  , MovementItem.Amount
                  , COALESCE (MIFloat_AmountPartner.ValueData, 0) AS AmountPartner
                  , COALESCE (MIFloat_RealWeight.ValueData, 0)          AS RealWeight
                  , COALESCE (MIFloat_CountTare.ValueData, 0)           AS CountTare
                  , CASE WHEN inShowAll = TRUE THEN COALESCE (MIFloat_WeightTare.ValueData, 0) ELSE 0 END AS WeightTare

                  , COALESCE (MIFloat_CountTare1.ValueData, 0)                                             AS CountTare1
                  , CASE WHEN inShowAll = TRUE THEN COALESCE (MIFloat_WeightTare1.ValueData, 0) ELSE 0 END AS WeightTare1
                  , COALESCE (MIFloat_CountTare2.ValueData, 0)                                             AS CountTare2
                  , CASE WHEN inShowAll = TRUE THEN COALESCE (MIFloat_WeightTare2.ValueData, 0) ELSE 0 END AS WeightTare2
                  , COALESCE (MIFloat_CountTare3.ValueData, 0)                                             AS CountTare3
                  , CASE WHEN inShowAll = TRUE THEN COALESCE (MIFloat_WeightTare3.ValueData, 0) ELSE 0 END AS WeightTare3
                  , COALESCE (MIFloat_CountTare4.ValueData, 0)                                             AS CountTare4
                  , CASE WHEN inShowAll = TRUE THEN COALESCE (MIFloat_WeightTare4.ValueData, 0) ELSE 0 END AS WeightTare4
                  , COALESCE (MIFloat_CountTare5.ValueData, 0)                                             AS CountTare5
                  , CASE WHEN inShowAll = TRUE THEN COALESCE (MIFloat_WeightTare5.ValueData, 0) ELSE 0 END AS WeightTare5
                  , COALESCE (MIFloat_CountTare6.ValueData, 0)                                             AS CountTare6
                  , CASE WHEN inShowAll = TRUE THEN COALESCE (MIFloat_WeightTare6.ValueData, 0) ELSE 0 END AS WeightTare6

                  , COALESCE (MIFloat_CountPack.ValueData, 0)           AS CountPack
                  , COALESCE (MIFloat_HeadCount.ValueData, 0)           AS HeadCount
                  , COALESCE (MIFloat_BoxCount.ValueData, 0)            AS BoxCount

                  , CASE WHEN inShowAll = TRUE THEN COALESCE (MIFloat_BoxNumber.ValueData, 0)   ELSE 0 END AS BoxNumber
                  , COALESCE (MIFloat_LevelNumber.ValueData, 0) AS LevelNumber

                  , COALESCE (MIFloat_ChangePercentAmount.ValueData, 0) AS ChangePercentAmount
                  , COALESCE (MIFloat_ChangePercent.ValueData, 0)       AS ChangePercent
                  , COALESCE (MIFloat_Price.ValueData, 0) 		        AS Price
                  , COALESCE (MIFloat_CountForPrice.ValueData, 0) 	    AS CountForPrice

                  , COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart()) AS PartionGoodsDate

                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                  , CASE WHEN inShowAll = TRUE THEN COALESCE (MILinkObject_Box.ObjectId, 0)       ELSE 0 END AS BoxId
                  , CASE WHEN inShowAll = TRUE THEN COALESCE (MILinkObject_PriceList.ObjectId, 0) ELSE 0 END AS PriceListId
                  , CASE WHEN inShowAll = TRUE THEN COALESCE (MILinkObject_Reason.ObjectId, 0)    ELSE 0 END AS ReasonId
                  
                  , CASE WHEN inShowAll = TRUE THEN COALESCE (MILinkObject_Asset.ObjectId, 0)     ELSE 0 END AS AssetId
                  , CASE WHEN inShowAll = TRUE THEN COALESCE (MILinkObject_Asset_two.ObjectId, 0) ELSE 0 END AS AssetId_two

                  , CASE WHEN inShowAll = TRUE THEN MIDate_Insert.ValueData ELSE zc_DateStart() END AS InsertDate
                  , CASE WHEN inShowAll = TRUE THEN MIDate_Update.ValueData ELSE zc_DateStart() END AS UpdateDate

                  , COALESCE (MIDate_StartBegin.ValueData,zc_DateStart())  AS StartBegin
                  , COALESCE (MIDate_EndBegin.ValueData,zc_DateStart())    AS EndBegin
                  , EXTRACT (EPOCH FROM (COALESCE (MIDate_EndBegin.ValueData, zc_DateStart()) - COALESCE (MIDate_StartBegin.ValueData, zc_DateStart())) :: INTERVAL) :: TFloat AS diffBegin_sec

                  , COALESCE (MIBoolean_BarCode.ValueData, FALSE) :: Boolean AS isBarCode

                  , MIFloat_PromoMovement.ValueData AS MovementPromoId
             FROM tmpMovementItem AS MovementItem

                  LEFT JOIN tmpMILO AS MILinkObject_GoodsKind
                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                  LEFT JOIN MovementItemBoolean AS MIBoolean_BarCode
                                                ON MIBoolean_BarCode.MovementItemId =  MovementItem.Id
                                               AND MIBoolean_BarCode.DescId = zc_MIBoolean_BarCode()

                  LEFT JOIN tmpMIDate AS MIDate_Insert
                                      ON MIDate_Insert.MovementItemId = MovementItem.Id
                                     AND MIDate_Insert.DescId = zc_MIDate_Insert()
                  LEFT JOIN tmpMIDate AS MIDate_Update
                                      ON MIDate_Update.MovementItemId = MovementItem.Id
                                     AND MIDate_Update.DescId = zc_MIDate_Update()
                  LEFT JOIN tmpMIDate AS MIDate_PartionGoods
                                      ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                     AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

                  LEFT JOIN tmpMIDate AS MIDate_StartBegin
                                      ON MIDate_StartBegin.MovementItemId = MovementItem.Id
                                     AND MIDate_StartBegin.DescId = zc_MIDate_StartBegin()
                  LEFT JOIN tmpMIDate AS MIDate_EndBegin
                                      ON MIDate_EndBegin.MovementItemId = MovementItem.Id
                                     AND MIDate_EndBegin.DescId = zc_MIDate_EndBegin()

                  LEFT JOIN tmpMIFloat AS MIFloat_ChangePercentAmount
                                       ON MIFloat_ChangePercentAmount.MovementItemId = MovementItem.Id
                                      AND MIFloat_ChangePercentAmount.DescId = zc_MIFloat_ChangePercentAmount()
                  LEFT JOIN tmpMIFloat AS MIFloat_ChangePercent
                                       ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                      AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
                  LEFT JOIN tmpMIFloat AS MIFloat_PromoMovement
                                       ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                      AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()

                  LEFT JOIN tmpMIFloat AS MIFloat_AmountPartner
                                       ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                      AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                  LEFT JOIN tmpMIFloat AS MIFloat_RealWeight
                                       ON MIFloat_RealWeight.MovementItemId = MovementItem.Id
                                      AND MIFloat_RealWeight.DescId = zc_MIFloat_RealWeight()
                  LEFT JOIN tmpMIFloat AS MIFloat_CountTare
                                       ON MIFloat_CountTare.MovementItemId = MovementItem.Id
                                      AND MIFloat_CountTare.DescId = zc_MIFloat_CountTare()
                  LEFT JOIN tmpMIFloat AS MIFloat_WeightTare
                                       ON MIFloat_WeightTare.MovementItemId = MovementItem.Id
                                      AND MIFloat_WeightTare.DescId = zc_MIFloat_WeightTare()

                  LEFT JOIN tmpMIFloat AS MIFloat_CountTare1
                                       ON MIFloat_CountTare1.MovementItemId = MovementItem.Id
                                      AND MIFloat_CountTare1.DescId = zc_MIFloat_CountTare1()
                  LEFT JOIN tmpMIFloat AS MIFloat_WeightTare1
                                       ON MIFloat_WeightTare1.MovementItemId = MovementItem.Id
                                      AND MIFloat_WeightTare1.DescId = zc_MIFloat_WeightTare1()
                  LEFT JOIN tmpMIFloat AS MIFloat_CountTare2
                                       ON MIFloat_CountTare2.MovementItemId = MovementItem.Id
                                      AND MIFloat_CountTare2.DescId = zc_MIFloat_CountTare2()
                  LEFT JOIN tmpMIFloat AS MIFloat_WeightTare2
                                       ON MIFloat_WeightTare2.MovementItemId = MovementItem.Id
                                      AND MIFloat_WeightTare2.DescId = zc_MIFloat_WeightTare2()
                  LEFT JOIN tmpMIFloat AS MIFloat_CountTare3
                                       ON MIFloat_CountTare3.MovementItemId = MovementItem.Id
                                      AND MIFloat_CountTare3.DescId = zc_MIFloat_CountTare3()
                  LEFT JOIN tmpMIFloat AS MIFloat_WeightTare3
                                       ON MIFloat_WeightTare3.MovementItemId = MovementItem.Id
                                      AND MIFloat_WeightTare3.DescId = zc_MIFloat_WeightTare3()
                  LEFT JOIN tmpMIFloat AS MIFloat_CountTare4
                                       ON MIFloat_CountTare4.MovementItemId = MovementItem.Id
                                      AND MIFloat_CountTare4.DescId = zc_MIFloat_CountTare4()
                  LEFT JOIN tmpMIFloat AS MIFloat_WeightTare4
                                       ON MIFloat_WeightTare4.MovementItemId = MovementItem.Id
                                      AND MIFloat_WeightTare4.DescId = zc_MIFloat_WeightTare4()
                  LEFT JOIN tmpMIFloat AS MIFloat_CountTare5
                                       ON MIFloat_CountTare5.MovementItemId = MovementItem.Id
                                      AND MIFloat_CountTare5.DescId = zc_MIFloat_CountTare5()
                  LEFT JOIN tmpMIFloat AS MIFloat_WeightTare5
                                       ON MIFloat_WeightTare5.MovementItemId = MovementItem.Id
                                      AND MIFloat_WeightTare5.DescId = zc_MIFloat_WeightTare5()
                  LEFT JOIN tmpMIFloat AS MIFloat_CountTare6
                                       ON MIFloat_CountTare6.MovementItemId = MovementItem.Id
                                      AND MIFloat_CountTare6.DescId = zc_MIFloat_CountTare6()
                  LEFT JOIN tmpMIFloat AS MIFloat_WeightTare6
                                       ON MIFloat_WeightTare6.MovementItemId = MovementItem.Id
                                      AND MIFloat_WeightTare6.DescId = zc_MIFloat_WeightTare6()

                  LEFT JOIN tmpMIFloat AS MIFloat_CountPack
                                       ON MIFloat_CountPack.MovementItemId = MovementItem.Id
                                      AND MIFloat_CountPack.DescId = zc_MIFloat_CountPack()
                  LEFT JOIN tmpMIFloat AS MIFloat_HeadCount
                                       ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                      AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()

                  LEFT JOIN tmpMIFloat AS MIFloat_BoxCount
                                       ON MIFloat_BoxCount.MovementItemId = MovementItem.Id
                                      AND MIFloat_BoxCount.DescId = zc_MIFloat_BoxCount()
                  LEFT JOIN tmpMIFloat AS MIFloat_BoxNumber
                                       ON MIFloat_BoxNumber.MovementItemId = MovementItem.Id
                                      AND MIFloat_BoxNumber.DescId = zc_MIFloat_BoxNumber()
                  LEFT JOIN tmpMIFloat AS MIFloat_LevelNumber
                                       ON MIFloat_LevelNumber.MovementItemId = MovementItem.Id
                                      AND MIFloat_LevelNumber.DescId = zc_MIFloat_LevelNumber()

                  LEFT JOIN tmpMIFloat AS MIFloat_Price
                                       ON MIFloat_Price.MovementItemId = MovementItem.Id
                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()
                  LEFT JOIN tmpMIFloat AS MIFloat_CountForPrice
                                       ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                      AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                                      AND MIFloat_Price.ValueData <> 0 -- !!!временно!!!

                  LEFT JOIN tmpMILO AS MILinkObject_Box
                                    ON MILinkObject_Box.MovementItemId = MovementItem.Id
                                   AND MILinkObject_Box.DescId = zc_MILinkObject_Box()

                  LEFT JOIN tmpMILO AS MILinkObject_PriceList
                                    ON MILinkObject_PriceList.MovementItemId = MovementItem.Id
                                   AND MILinkObject_PriceList.DescId = zc_MILinkObject_PriceList()

                  LEFT JOIN tmpMILO AS MILinkObject_Reason
                                    ON MILinkObject_Reason.MovementItemId = MovementItem.Id
                                   AND MILinkObject_Reason.DescId = zc_MILinkObject_Reason()

                  LEFT JOIN tmpMILO AS MILinkObject_Asset
                                    ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                   AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset() 
                  LEFT JOIN tmpMILO AS MILinkObject_Asset_two
                                    ON MILinkObject_Asset_two.MovementItemId = MovementItem.Id
                                   AND MILinkObject_Asset_two.DescId = zc_MILinkObject_Asset_two()
           
             WHERE COALESCE (MILinkObject_GoodsKind.ObjectId,0) = inGoodsKindId OR inGoodsKindId = 0
             )


       -- Результат
       SELECT

             tmpMI.MovementId
           , tmpMI.OperDate
           , tmpMI.OperDatePartner
           , tmpMI.InvNumber
           , tmpMI.StartWeighing
           , tmpMI.EndWeighing
           , tmpMI.MovementItemId :: Integer  AS Id
           , Object_Goods.Id                  AS GoodsId
           , Object_Goods.ObjectCode          AS GoodsCode
           , Object_Goods.ValueData           AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , tmpMI.Amount :: TFloat           AS Amount

           , CASE WHEN tmpMI.AmountPartner = 0 THEN NULL ELSE tmpMI.AmountPartner END :: TFloat       AS AmountPartner

           , tmpMI.RealWeight  :: TFloat      AS RealWeight
           , tmpMI.CountTare   :: TFloat      AS CountTare
           , CASE WHEN inShowAll = TRUE THEN tmpMI.WeightTare WHEN tmpMI.CountTare <> 0 THEN (tmpMI.RealWeight - tmpMI.Amount) / tmpMI.CountTare ELSE 0 END :: TFloat AS WeightTare

           , tmpMI.CountTare1   :: TFloat   AS CountTare1
           , tmpMI.CountTare2   :: TFloat   AS CountTare2
           , tmpMI.CountTare3   :: TFloat   AS CountTare3
           , tmpMI.CountTare4   :: TFloat   AS CountTare4
           , tmpMI.CountTare5   :: TFloat   AS CountTare5
           , tmpMI.CountTare6   :: TFloat   AS CountTare6

           , tmpMI.WeightTare1  :: TFloat   AS WeightTare1
           , tmpMI.WeightTare2  :: TFloat   AS WeightTare2
           , tmpMI.WeightTare3  :: TFloat   AS WeightTare3
           , tmpMI.WeightTare4  :: TFloat   AS WeightTare4
           , tmpMI.WeightTare5  :: TFloat   AS WeightTare5
           , tmpMI.WeightTare6  :: TFloat   AS WeightTare6

           , CASE WHEN tmpMI.CountPack = 0    THEN NULL ELSE tmpMI.CountPack    END :: TFloat AS Count
           , CASE WHEN tmpMI.HeadCount = 0    THEN NULL ELSE tmpMI.HeadCount    END :: TFloat AS HeadCount
           , CASE WHEN tmpMI.BoxCount = 0     THEN NULL ELSE tmpMI.BoxCount     END :: TFloat AS BoxCount


           , CASE WHEN tmpMI.BoxNumber = 0 THEN NULL ELSE tmpMI.BoxNumber END :: TFloat     AS BoxNumber
           , CASE WHEN tmpMI.LevelNumber = 0 THEN NULL ELSE tmpMI.LevelNumber END :: TFloat AS LevelNumber

           , CASE WHEN tmpMI.ChangePercentAmount = 0 THEN NULL ELSE tmpMI.ChangePercentAmount END :: TFloat AS ChangePercentAmount
           , tmpMI.ChangePercent :: TFloat AS ChangePercent
           , CASE WHEN tmpMI.Price = 0 THEN NULL ELSE tmpMI.Price END :: TFloat                 AS Price
           , CASE WHEN tmpMI.CountForPrice = 0 THEN NULL ELSE tmpMI.CountForPrice END :: TFloat AS CountForPrice

           , CASE WHEN tmpMI.PartionGoodsDate = zc_DateStart() THEN NULL ELSE tmpMI.PartionGoodsDate END :: TDateTime AS PartionGoodsDate

           , Object_GoodsKind.ValueData      AS GoodsKindName
           , Object_Measure.ValueData        AS MeasureName
           , Object_Box.ValueData            AS BoxName
           , Object_PriceList.ValueData      AS PriceListName
           , Object_Reason.ValueData         AS ReasonName

           , Object_Asset.ValueData          AS AssetName
           , Object_Asset_two.ValueData      AS AssetName_two
           
           , CASE WHEN tmpMI.InsertDate = zc_DateStart() THEN NULL ELSE tmpMI.InsertDate END :: TDateTime AS InsertDate
           , CASE WHEN tmpMI.UpdateDate = zc_DateStart() THEN NULL ELSE tmpMI.UpdateDate END :: TDateTime AS UpdateDate

           , tmpMI.StartBegin :: TDateTime
           , tmpMI.EndBegin   :: TDateTime
           , (COALESCE (tmpMI.diffBegin_sec,0)) ::TFloat AS diffBegin_sec

           , zfCalc_PromoMovementName (NULL, Movement_Promo_View.InvNumber :: TVarChar, Movement_Promo_View.OperDate, Movement_Promo_View.StartSale, Movement_Promo_View.EndSale) AS MovementPromo
           --, tmpMIPromo.PricePromo :: TFloat AS PricePromo

           , tmpMI.isBarCode

           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName
           , Object_InfoMoney_View.InfoMoneyName_all

       FROM (SELECT tmpMI.MovementId
                  , tmpMI.OperDate 
                  , tmpMI.OperDatePartner
                  , tmpMI.InvNumber
                  , tmpMI.StartWeighing
                  , tmpMI.EndWeighing
                  , tmpMI.MovementItemId
                  , tmpMI.GoodsId
                  , SUM (tmpMI.Amount)           AS Amount
                  , SUM (tmpMI.AmountPartner)    AS AmountPartner

                  , SUM (tmpMI.RealWeight)     AS RealWeight
                  , SUM (tmpMI.CountTare)      AS CountTare
                  , tmpMI.WeightTare           AS WeightTare

                  , SUM (tmpMI.CountTare1)      AS CountTare1
                  , SUM (tmpMI.CountTare2)      AS CountTare2
                  , SUM (tmpMI.CountTare3)      AS CountTare3
                  , SUM (tmpMI.CountTare4)      AS CountTare4
                  , SUM (tmpMI.CountTare5)      AS CountTare5
                  , SUM (tmpMI.CountTare6)      AS CountTare6

                  , tmpMI.WeightTare1           AS WeightTare1
                  , tmpMI.WeightTare2           AS WeightTare2
                  , tmpMI.WeightTare3           AS WeightTare3
                  , tmpMI.WeightTare4           AS WeightTare4
                  , tmpMI.WeightTare5           AS WeightTare5
                  , tmpMI.WeightTare6           AS WeightTare6

                  , SUM (tmpMI.CountPack)      AS CountPack
                  , SUM (tmpMI.HeadCount)      AS HeadCount
                  , SUM (tmpMI.BoxCount)       AS BoxCount

                  , tmpMI.BoxNumber            AS BoxNumber
                  , MAX (tmpMI.LevelNumber)    AS LevelNumber -- MAX

                  , tmpMI.ChangePercentAmount
                  , tmpMI.ChangePercent
                  , tmpMI.Price
                  , tmpMI.CountForPrice

                  , tmpMI.PartionGoodsDate
                  , tmpMI.GoodsKindId
                  , tmpMI.BoxId
                  , tmpMI.PriceListId
                  , tmpMI.ReasonId
                  
                  , tmpMI.AssetId
                  , tmpMI.AssetId_two

                  , tmpMI.InsertDate
                  , tmpMI.UpdateDate

                  , MAX (tmpMI.StartBegin) AS StartBegin
                  , MAX (tmpMI.EndBegin)   AS EndBegin
                  , SUM (COALESCE (tmpMI.diffBegin_sec,0)) ::TFloat AS diffBegin_sec
                  , tmpMI.MovementPromoId
                  , tmpMI.isBarCode
             FROM tmpMI
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
                   , tmpMI.ReasonId  
                   , tmpMI.AssetId
                   , tmpMI.AssetId_two
                   , tmpMI.InsertDate
                   , tmpMI.UpdateDate
                   , tmpMI.isBarCode
                   , tmpMI.MovementPromoId
                   , tmpMI.WeightTare1
                   , tmpMI.WeightTare2
                   , tmpMI.WeightTare3
                   , tmpMI.WeightTare4
                   , tmpMI.WeightTare5
                   , tmpMI.WeightTare6
                   , tmpMI.MovementId
                   , tmpMI.OperDate
                   , tmpMI.OperDatePartner
                   , tmpMI.InvNumber
                   , tmpMI.StartWeighing
                   , tmpMI.EndWeighing
            ) AS tmpMI
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId
            LEFT JOIN Object AS Object_Box ON Object_Box.Id = tmpMI.BoxId
            LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = tmpMI.PriceListId
            LEFT JOIN Object AS Object_Reason ON Object_Reason.Id = tmpMI.ReasonId
            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = tmpMI.AssetId
            LEFT JOIN Object AS Object_Asset_two ON Object_Asset_two.Id = tmpMI.AssetId_two
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN Movement_Promo_View ON Movement_Promo_View.Id = tmpMI.MovementPromoId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.11.23         *
 18.10.22         *
 04.08.22         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_WeighingPartner_bySale (inMovementId_sale:= 23059199 , inGoodsId:=7497164, inGoodsKindId:= 0, inSession:= '2'::TVarChar)
