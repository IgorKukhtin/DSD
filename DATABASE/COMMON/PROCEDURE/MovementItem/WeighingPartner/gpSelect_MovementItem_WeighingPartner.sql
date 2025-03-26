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
             , Amount TFloat, Amount_mi TFloat, AmountPartner TFloat, AmountPartnerSecond TFloat, SummPartner TFloat, AmountPartner_mi TFloat 
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
             , CountPack TFloat, WeightPack TFloat
             , Count TFloat, Count_mi TFloat, HeadCount TFloat, HeadCount_mi TFloat, BoxCount TFloat, BoxCount_mi TFloat
             , BoxNumber TFloat, LevelNumber TFloat
             , ChangePercentAmount TFloat, AmountChangePercent TFloat, ChangePercent TFloat
             , Price TFloat, CountForPrice TFloat
             , PricePartner TFloat
             , PartionGoodsDate TDateTime, PartionGoods TVarChar
             , PartionNum TFloat
             , GoodsKindName TVarChar, MeasureName TVarChar
             , BoxName TVarChar
             , PriceListName  TVarChar
             , ReasonName TVarChar
             , AssetName TVarChar, AssetName_two TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , StartBegin TDateTime, EndBegin TDateTime, diffBegin_sec TFloat
             , MovementPromo TVarChar, PricePromo TFloat
             , isBarCode Boolean
             , isAmountPartnerSecond Boolean
             , isPriceWithVAT Boolean 
             , isReturnOut Boolean
             , Comment TVarChar 
             , PriceRetOutDate TDateTime
             , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , isErased Boolean
              )
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_WeighingPartner());

/*if inSession <> '5' AND inShowAll = TRUE
then
    RAISE EXCEPTION 'Ошибка.Повторите действие через 3 мин.';
end if;*/


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
                              FROM (SELECT DISTINCT tmpMIList.MovementId_Promo :: Integer AS MovementId_Promo FROM tmpMIList WHERE tmpMIList.MovementId_Promo <> 0) AS tmp
                                   INNER JOIN MovementItem ON MovementItem.MovementId = tmp.MovementId_Promo
                                                          AND MovementItem.DescId = zc_MI_Master()
                                                          AND MovementItem.isErased = FALSE
                             )
      , tmpMILinkObjectPromo AS (SELECT MILinkObject_GoodsKind.*
                                 FROM MovementItemLinkObject AS MILinkObject_GoodsKind
                                 WHERE MILinkObject_GoodsKind.MovementItemId IN (SELECT DISTINCT tmpMIPromo_all.MovementItemId FROM tmpMIPromo_all)
                                   AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                )
           , tmpMIFloatPromo AS (SELECT MIFloat_PriceWithOutVAT.*
                                 FROM MovementItemFloat AS MIFloat_PriceWithOutVAT
                                 WHERE MIFloat_PriceWithOutVAT.MovementItemId IN (SELECT DISTINCT tmpMIPromo_all.MovementItemId FROM tmpMIPromo_all)
                                   AND MIFloat_PriceWithOutVAT.DescId         = zc_MIFloat_PriceWithOutVAT()
                                )
             , tmpMIPromo AS (SELECT DISTINCT 
                                     tmpMIPromo_all.MovementId_Promo
                                   , tmpMIPromo_all.GoodsId
                                 --, tmpMIPromo_all.GoodsKindId
                                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                   , CASE WHEN /*tmpMIPromo_all.TaxPromo <> 0*/ 1=1 THEN MIFloat_PriceWithOutVAT.ValueData ELSE 0 END AS PricePromo
                              FROM tmpMIPromo_all
                                   LEFT JOIN tmpMIFloatPromo AS MIFloat_PriceWithOutVAT
                                                             ON MIFloat_PriceWithOutVAT.MovementItemId = tmpMIPromo_all.MovementItemId
                                   LEFT JOIN tmpMILinkObjectPromo AS MILinkObject_GoodsKind
                                                                  ON MILinkObject_GoodsKind.MovementItemId = tmpMIPromo_all.MovementItemId
                             )
, tmpMI_1 AS (SELECT CASE WHEN inShowAll = TRUE THEN MovementItem.Id ELSE 0 END :: Integer AS MovementItemId
                  , MovementItem.ObjectId AS GoodsId
                  , MovementItem.Amount
                  , 0 AS Amount_mi

                  , COALESCE (MIFloat_AmountPartner.ValueData, 0) AS AmountPartner   
                  , COALESCE (MIFloat_AmountPartnerSecond.ValueData, 0) AS AmountPartnerSecond
                  , 0                                             AS AmountPartner_mi

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

                  , CASE WHEN COALESCE (MIFloat_WeightPack.ValueData,0) > 0 THEN 0 ELSE COALESCE (MIFloat_CountPack.ValueData, 0) END AS CountPack
                  , 0 AS CountPack_mi
                  , COALESCE (MIFloat_HeadCount.ValueData, 0)           AS HeadCount
                  , 0 AS HeadCount_mi
                  , COALESCE (MIFloat_BoxCount.ValueData, 0)            AS BoxCount
                  , 0 AS BoxCount_mi

                  , CASE WHEN COALESCE (MIFloat_WeightPack.ValueData,0) > 0 THEN MIFloat_CountPack.ValueData ELSE 0 END  AS CountPack_2
                  , MIFloat_WeightPack.ValueData  ::TFloat AS WeightPack

                  , CASE WHEN inShowAll = TRUE THEN COALESCE (MIFloat_BoxNumber.ValueData, 0)   ELSE 0 END AS BoxNumber
                  , COALESCE (MIFloat_LevelNumber.ValueData, 0) AS LevelNumber

                  , COALESCE (MIFloat_ChangePercentAmount.ValueData, 0) AS ChangePercentAmount
                  , 0 AmountChangePercent

                  , COALESCE (MIFloat_ChangePercent.ValueData, 0)         AS ChangePercent
                  , COALESCE (MIFloat_Price.ValueData, 0)                 AS Price
                  , COALESCE (MIFloat_CountForPrice.ValueData, 0)         AS CountForPrice
                  , COALESCE (MIFloat_PricePartner.ValueData, 0)          AS PricePartner

                  , COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart()) AS PartionGoodsDate
                  , COALESCE (MIString_PartionGoods.ValueData, '')           AS PartionGoods
                  
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

                  , MovementItem.isErased
                  
                  , MIFloat_PromoMovement.ValueData AS MovementPromoId

                  , COALESCE (MIBoolean_AmountPartnerSecond.ValueData, FALSE) :: Boolean  AS isAmountPartnerSecond
                  , COALESCE (MIBoolean_PriceWithVAT.ValueData, FALSE)         :: Boolean  AS isPriceWithVAT
                  , COALESCE (MIBoolean_ReturnOut.ValueData, FALSE)           :: Boolean  AS isReturnOut
                  , COALESCE (MIDate_PriceRetOut.ValueData, NULL)             ::TDateTime AS PriceRetOutDate
                  , COALESCE (MIFloat_SummPartner.ValueData,0)                ::TFloat    AS SummPartner 
                  , COALESCE (MIString_Comment.ValueData, '')                 :: TVarChar AS Comment
                  
                  , tmpMIFloat_PartionNum.ValueData                  ::TFloat    AS PartionNum
             FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                  INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                         AND MovementItem.DescId     = zc_MI_Master()
                                         AND MovementItem.isErased   = tmpIsErased.isErased

                  LEFT JOIN MovementItemBoolean AS MIBoolean_BarCode
                                                ON MIBoolean_BarCode.MovementItemId =  MovementItem.Id
                                               AND MIBoolean_BarCode.DescId = zc_MIBoolean_BarCode()

                  LEFT JOIN MovementItemBoolean AS MIBoolean_AmountPartnerSecond
                                                ON MIBoolean_AmountPartnerSecond.MovementItemId = MovementItem.Id
                                               AND MIBoolean_AmountPartnerSecond.DescId = zc_MIBoolean_AmountPartnerSecond()
                  LEFT JOIN MovementItemBoolean AS MIBoolean_PriceWithVAT
                                                ON MIBoolean_PriceWithVAT.MovementItemId = MovementItem.Id
                                               AND MIBoolean_PriceWithVAT.DescId = zc_MIBoolean_PriceWithVAT()
                  LEFT JOIN MovementItemBoolean AS MIBoolean_ReturnOut
                                                ON MIBoolean_ReturnOut.MovementItemId = MovementItem.Id
                                               AND MIBoolean_ReturnOut.DescId = zc_MIBoolean_ReturnOut()


                  LEFT JOIN MovementItemDate AS MIDate_Insert
                                             ON MIDate_Insert.MovementItemId = MovementItem.Id
                                            AND MIDate_Insert.DescId = zc_MIDate_Insert()
                  LEFT JOIN MovementItemDate AS MIDate_Update
                                             ON MIDate_Update.MovementItemId = MovementItem.Id
                                            AND MIDate_Update.DescId = zc_MIDate_Update()
                  LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                             ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                            AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                  LEFT JOIN MovementItemDate AS MIDate_PriceRetOut
                                             ON MIDate_PriceRetOut.MovementItemId = MovementItem.Id
                                            AND MIDate_PriceRetOut.DescId = zc_MIDate_PriceRetOut()

                  LEFT JOIN MovementItemString AS MIString_PartionGoods
                                               ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                              AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                  LEFT JOIN MovementItemString AS MIString_Comment
                                               ON MIString_Comment.MovementItemId = MovementItem.Id
                                              AND MIString_Comment.DescId = zc_MIString_Comment()

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

                  LEFT JOIN MovementItemFloat AS MIFloat_SummPartner
                                              ON MIFloat_SummPartner.MovementItemId = MovementItem.Id
                                             AND MIFloat_SummPartner.DescId = zc_MIFloat_SummPartner()

                  LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                              ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                             AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                  LEFT JOIN MovementItemFloat AS MIFloat_AmountPartnerSecond
                                              ON MIFloat_AmountPartnerSecond.MovementItemId = MovementItem.Id
                                             AND MIFloat_AmountPartnerSecond.DescId = zc_MIFloat_AmountPartnerSecond()
                  LEFT JOIN MovementItemFloat AS MIFloat_RealWeight
                                              ON MIFloat_RealWeight.MovementItemId = MovementItem.Id
                                             AND MIFloat_RealWeight.DescId = zc_MIFloat_RealWeight()
                  LEFT JOIN MovementItemFloat AS MIFloat_CountTare
                                              ON MIFloat_CountTare.MovementItemId = MovementItem.Id
                                             AND MIFloat_CountTare.DescId = zc_MIFloat_CountTare()
                  LEFT JOIN MovementItemFloat AS MIFloat_WeightTare
                                              ON MIFloat_WeightTare.MovementItemId = MovementItem.Id
                                             AND MIFloat_WeightTare.DescId = zc_MIFloat_WeightTare()

                  LEFT JOIN MovementItemFloat AS MIFloat_CountTare1
                                              ON MIFloat_CountTare1.MovementItemId = MovementItem.Id
                                             AND MIFloat_CountTare1.DescId = zc_MIFloat_CountTare1()
                  LEFT JOIN MovementItemFloat AS MIFloat_WeightTare1
                                              ON MIFloat_WeightTare1.MovementItemId = MovementItem.Id
                                             AND MIFloat_WeightTare1.DescId = zc_MIFloat_WeightTare1()
                  LEFT JOIN MovementItemFloat AS MIFloat_CountTare2
                                              ON MIFloat_CountTare2.MovementItemId = MovementItem.Id
                                             AND MIFloat_CountTare2.DescId = zc_MIFloat_CountTare2()
                  LEFT JOIN MovementItemFloat AS MIFloat_WeightTare2
                                              ON MIFloat_WeightTare2.MovementItemId = MovementItem.Id
                                             AND MIFloat_WeightTare2.DescId = zc_MIFloat_WeightTare2()
                  LEFT JOIN MovementItemFloat AS MIFloat_CountTare3
                                              ON MIFloat_CountTare3.MovementItemId = MovementItem.Id
                                             AND MIFloat_CountTare3.DescId = zc_MIFloat_CountTare3()
                  LEFT JOIN MovementItemFloat AS MIFloat_WeightTare3
                                              ON MIFloat_WeightTare3.MovementItemId = MovementItem.Id
                                             AND MIFloat_WeightTare3.DescId = zc_MIFloat_WeightTare3()
                  LEFT JOIN MovementItemFloat AS MIFloat_CountTare4
                                              ON MIFloat_CountTare4.MovementItemId = MovementItem.Id
                                             AND MIFloat_CountTare4.DescId = zc_MIFloat_CountTare4()
                  LEFT JOIN MovementItemFloat AS MIFloat_WeightTare4
                                              ON MIFloat_WeightTare4.MovementItemId = MovementItem.Id
                                             AND MIFloat_WeightTare4.DescId = zc_MIFloat_WeightTare4()
                  LEFT JOIN MovementItemFloat AS MIFloat_CountTare5
                                              ON MIFloat_CountTare5.MovementItemId = MovementItem.Id
                                             AND MIFloat_CountTare5.DescId = zc_MIFloat_CountTare5()
                  LEFT JOIN MovementItemFloat AS MIFloat_WeightTare5
                                              ON MIFloat_WeightTare5.MovementItemId = MovementItem.Id
                                             AND MIFloat_WeightTare5.DescId = zc_MIFloat_WeightTare5()
                  LEFT JOIN MovementItemFloat AS MIFloat_CountTare6
                                              ON MIFloat_CountTare6.MovementItemId = MovementItem.Id
                                             AND MIFloat_CountTare6.DescId = zc_MIFloat_CountTare6()
                  LEFT JOIN MovementItemFloat AS MIFloat_WeightTare6
                                              ON MIFloat_WeightTare6.MovementItemId = MovementItem.Id
                                             AND MIFloat_WeightTare6.DescId = zc_MIFloat_WeightTare6()

                  LEFT JOIN MovementItemFloat AS MIFloat_CountPack
                                              ON MIFloat_CountPack.MovementItemId = MovementItem.Id
                                             AND MIFloat_CountPack.DescId = zc_MIFloat_CountPack()
                  LEFT JOIN MovementItemFloat AS MIFloat_WeightPack
                                              ON MIFloat_WeightPack.MovementItemId = MovementItem.Id
                                             AND MIFloat_WeightPack.DescId = zc_MIFloat_WeightPack()
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

                  LEFT JOIN MovementItemFloat AS MIFloat_PricePartner
                                              ON MIFloat_PricePartner.MovementItemId = MovementItem.Id
                                             AND MIFloat_PricePartner.DescId = zc_MIFloat_PricePartner()

                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Box
                                                   ON MILinkObject_Box.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_Box.DescId = zc_MILinkObject_Box()

                  LEFT JOIN MovementItemLinkObject AS MILinkObject_PriceList
                                                   ON MILinkObject_PriceList.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_PriceList.DescId = zc_MILinkObject_PriceList()

                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Reason
                                                   ON MILinkObject_Reason.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_Reason.DescId = zc_MILinkObject_Reason()  

                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                   ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset_two
                                                   ON MILinkObject_Asset_two.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_Asset_two.DescId = zc_MILinkObject_Asset_two()

                  -- № паспорта
                  LEFT JOIN MovementItemFloat AS tmpMIFloat_PartionNum
                                              ON tmpMIFloat_PartionNum.MovementItemId = MovementItem.Id
                                             AND tmpMIFloat_PartionNum.DescId         = zc_MIFloat_PartionNum()
            UNION ALL
             SELECT CASE WHEN inShowAll = TRUE THEN MovementItem.Id ELSE 0 END :: Integer AS MovementItemId
                  , MovementItem.ObjectId AS GoodsId

                  , 0 AS Amount
                  , MovementItem.Amount AS Amount_mi

                  , 0                                             AS AmountPartner
                  , 0                                             AS AmountPartnerSecond
                  , COALESCE (MIFloat_AmountPartner.ValueData, 0) AS AmountPartner_mi

                  , 0 AS RealWeight
                  , 0 AS CountTare
                  , 0 AS WeightTare

                  , 0 AS CountTare1
                  , 0 AS WeightTare1
                  , 0 AS CountTare2
                  , 0 AS WeightTare2
                  , 0 AS CountTare3
                  , 0 AS WeightTare3
                  , 0 AS CountTare4
                  , 0 AS WeightTare4
                  , 0 AS CountTare5
                  , 0 AS WeightTare5
                  , 0 AS CountTare6
                  , 0 AS WeightTare6

                  , 0                                         AS CountPack
                  , CASE WHEN COALESCE (MIFloat_WeightPack.ValueData,0) > 0 THEN 0 ELSE COALESCE (MIFloat_CountPack.ValueData, 0) END AS CountPack_mi
                  , 0                                         AS HeadCount
                  , COALESCE (MIFloat_HeadCount.ValueData, 0) AS HeadCount_mi
                  , 0                                         AS BoxCount
                  , COALESCE (MIFloat_BoxCount.ValueData, 0)  AS BoxCount_mi

                  , 0 AS CountPack_2
                  , 0 AS WeightPack

                  , 0 AS BoxNumber
                  , 0 AS LevelNumber

                  , COALESCE (MIFloat_ChangePercentAmount.ValueData, 0) AS ChangePercentAmount
                  , COALESCE (MIFloat_AmountChangePercent.ValueData, 0) AS AmountChangePercent

                  , COALESCE (MIFloat_ChangePercent.ValueData, 0)       AS ChangePercent
                  , COALESCE (MIFloat_Price.ValueData, 0) 		        AS Price
                  , COALESCE (MIFloat_CountForPrice.ValueData, 0) 	    AS CountForPrice
                  , COALESCE (MIFloat_PricePartner.ValueData, 0)        AS PricePartner
                  
                  , COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart()) AS PartionGoodsDate
                  , COALESCE (MIString_PartionGoods.ValueData, '')           AS PartionGoods

                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                  , CASE WHEN inShowAll = TRUE THEN COALESCE (MILinkObject_Box.ObjectId, 0)       ELSE 0 END AS BoxId
                  , 0 AS PriceListId
                  , CASE WHEN inShowAll = TRUE THEN COALESCE (MILinkObject_Reason.ObjectId, 0)    ELSE 0 END AS ReasonId

                  , CASE WHEN inShowAll = TRUE THEN COALESCE (MILinkObject_Asset.ObjectId, 0)     ELSE 0 END AS AssetId
                  , CASE WHEN inShowAll = TRUE THEN COALESCE (MILinkObject_Asset_two.ObjectId, 0) ELSE 0 END AS AssetId_two

                  , zc_DateStart()  AS InsertDate
                  , zc_DateStart()  AS UpdateDate

                  , zc_DateStart()  AS StartBegin
                  , zc_DateStart()  AS EndBegin
                  , 0     :: TFloat AS diffBegin_sec

                  , COALESCE (MIBoolean_BarCode.ValueData, FALSE) :: Boolean AS isBarCode

                  , MovementItem.isErased
                 
                  , MIFloat_PromoMovement.ValueData :: Integer AS MovementPromoId
 
                  , COALESCE (MIBoolean_AmountPartnerSecond.ValueData, FALSE) :: Boolean  AS isAmountPartnerSecond
                  , COALESCE (MIBoolean_PriceWithVAT.ValueData, FALSE)        :: Boolean  AS isPriceWithVAT
                  , COALESCE (MIBoolean_ReturnOut.ValueData, FALSE)           :: Boolean  AS isReturnOut
                  , COALESCE (MIDate_PriceRetOut.ValueData, NULL)             ::TDateTime AS PriceRetOutDate
                  , COALESCE (MIFloat_SummPartner.ValueData,0)                ::TFloat    AS SummPartner 
                  , COALESCE (MIString_Comment.ValueData, '')                 :: TVarChar AS Comment

                  , tmpMIFloat_PartionNum.ValueData                  ::TFloat    AS PartionNum
             FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                  INNER JOIN Movement ON Movement.Id = inMovementId
                                     AND inShowAll = FALSE
                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement.ParentId
                                         AND MovementItem.DescId     = zc_MI_Master()
                                         AND MovementItem.isErased   = tmpIsErased.isErased

                  LEFT JOIN MovementItemBoolean AS MIBoolean_BarCode
                                                ON MIBoolean_BarCode.MovementItemId =  MovementItem.Id
                                               AND MIBoolean_BarCode.DescId = zc_MIBoolean_BarCode()

                  LEFT JOIN MovementItemBoolean AS MIBoolean_AmountPartnerSecond
                                                ON MIBoolean_AmountPartnerSecond.MovementItemId = MovementItem.Id
                                               AND MIBoolean_AmountPartnerSecond.DescId = zc_MIBoolean_AmountPartnerSecond()
                  LEFT JOIN MovementItemBoolean AS MIBoolean_PriceWithVAT
                                                ON MIBoolean_PriceWithVAT.MovementItemId = MovementItem.Id
                                               AND MIBoolean_PriceWithVAT.DescId = zc_MIBoolean_PriceWithVAT()

                  LEFT JOIN MovementItemBoolean AS MIBoolean_ReturnOut
                                                ON MIBoolean_ReturnOut.MovementItemId = MovementItem.Id
                                               AND MIBoolean_ReturnOut.DescId = zc_MIBoolean_ReturnOut()

                  LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                             ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                            AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

                  LEFT JOIN MovementItemDate AS MIDate_PriceRetOut
                                             ON MIDate_PriceRetOut.MovementItemId = MovementItem.Id
                                            AND MIDate_PriceRetOut.DescId = zc_MIDate_PriceRetOut()

                  LEFT JOIN MovementItemString AS MIString_PartionGoods
                                               ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                              AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                  LEFT JOIN MovementItemString AS MIString_Comment
                                               ON MIString_Comment.MovementItemId = MovementItem.Id
                                              AND MIString_Comment.DescId = zc_MIString_Comment()

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

                  LEFT JOIN MovementItemFloat AS MIFloat_SummPartner
                                              ON MIFloat_SummPartner.MovementItemId = MovementItem.Id
                                             AND MIFloat_SummPartner.DescId = zc_MIFloat_SummPartner()

                  LEFT JOIN MovementItemFloat AS MIFloat_CountPack
                                              ON MIFloat_CountPack.MovementItemId = MovementItem.Id
                                             AND MIFloat_CountPack.DescId = zc_MIFloat_CountPack()
                  LEFT JOIN MovementItemFloat AS MIFloat_WeightPack
                                              ON MIFloat_WeightPack.MovementItemId = MovementItem.Id
                                             AND MIFloat_WeightPack.DescId = zc_MIFloat_WeightPack()
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

                  LEFT JOIN MovementItemFloat AS MIFloat_PricePartner
                                              ON MIFloat_PricePartner.MovementItemId = MovementItem.Id
                                             AND MIFloat_PricePartner.DescId = zc_MIFloat_PricePartner()

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

                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Reason
                                                   ON MILinkObject_Reason.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_Reason.DescId = zc_MILinkObject_Reason()

                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                   ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset_two
                                                   ON MILinkObject_Asset_two.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_Asset_two.DescId = zc_MILinkObject_Asset_two()

                  -- № паспорта
                  LEFT JOIN MovementItemFloat AS tmpMIFloat_PartionNum
                                              ON tmpMIFloat_PartionNum.MovementItemId = MovementItem.Id
                                             AND tmpMIFloat_PartionNum.DescId         = zc_MIFloat_PartionNum()
            ) 

       -- Результат     
       SELECT
             tmpMI.MovementItemId :: Integer  AS Id
           , Object_Goods.ObjectCode          AS GoodsCode
           , Object_Goods.ValueData           AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , tmpMI.Amount :: TFloat           AS Amount
           , tmpMI.Amount_mi :: TFloat        AS Amount_mi

           , CASE WHEN tmpMI.AmountPartner = 0 THEN NULL ELSE tmpMI.AmountPartner END :: TFloat  AS AmountPartner
           , tmpMI.AmountPartnerSecond                                                :: TFloat  AS AmountPartnerSecond 
           , tmpMI.SummPartner                                                        :: TFloat  AS SummPartner
           
           , CASE WHEN tmpMI.AmountPartner_mi = 0 THEN NULL ELSE tmpMI.AmountPartner_mi END :: TFloat AS AmountPartner_mi

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
           
           , tmpMI.CountPack_2  :: TFloat   AS CountPack
           , tmpMI.WeightPack   :: TFloat   AS WeightPack

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
           , CASE WHEN tmpMI.PricePartner = 0 THEN NULL ELSE tmpMI.PricePartner END   :: TFloat AS PricePartner
           
           , CASE WHEN tmpMI.PartionGoodsDate = zc_DateStart() THEN NULL ELSE tmpMI.PartionGoodsDate END :: TDateTime AS PartionGoodsDate
           , tmpMI.PartionGoods :: TVarChar AS PartionGoods
           , tmpMI.PartionNum   ::TFloat    AS PartionNum

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

           , zfCalc_PromoMovementName (NULL, Movement_Promo_View.InvNumber :: TVarChar, Movement_Promo_View.OperDate, Movement_Promo_View.StartSale, CASE WHEN MovementFloat_MovementDesc.ValueData = zc_Movement_ReturnIn() THEN Movement_Promo_View.EndReturn ELSE Movement_Promo_View.EndSale END) AS MovementPromo
           , tmpMIPromo.PricePromo :: TFloat AS PricePromo

           , tmpMI.isBarCode

           , tmpMI.isAmountPartnerSecond ::Boolean
           , tmpMI.isPriceWithVAT        ::Boolean
           , tmpMI.isReturnOut           ::Boolean
           , tmpMI.Comment               ::TVarChar
           , tmpMI.PriceRetOutDate       ::TDateTime

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
                  , SUM (tmpMI.AmountPartnerSecond) AS AmountPartnerSecond
                  , SUM (tmpMI.AmountPartner_mi) AS AmountPartner_mi
                  , SUM (tmpMI.SummPartner)      AS SummPartner

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
                  , SUM (tmpMI.CountPack_mi)   AS CountPack_mi
                  , SUM (tmpMI.HeadCount)      AS HeadCount
                  , SUM (tmpMI.HeadCount_mi)   AS HeadCount_mi
                  , SUM (tmpMI.BoxCount)       AS BoxCount
                  , SUM (tmpMI.BoxCount_mi)    AS BoxCount_mi
                  
                  , SUM (tmpMI.CountPack_2)    AS CountPack_2
                  , SUM (tmpMI.WeightPack)     AS WeightPack

                  , tmpMI.BoxNumber            AS BoxNumber
                  , MAX (tmpMI.LevelNumber)    AS LevelNumber -- MAX

                  , tmpMI.ChangePercentAmount
                  , SUM (tmpMI.AmountChangePercent) AS AmountChangePercent
                  , tmpMI.ChangePercent
                  , tmpMI.Price
                  , tmpMI.CountForPrice
                  , tmpMI.PricePartner

                  , tmpMI.PartionGoodsDate
                  , tmpMI.PartionGoods
                  , tmpMI.GoodsKindId
                  , tmpMI.BoxId
                  , tmpMI.PriceListId
                  , tmpMI.ReasonId 
                  , tmpMI.PartionNum

                  , tmpMI.AssetId
                  , tmpMI.AssetId_two

                  , tmpMI.InsertDate
                  , tmpMI.UpdateDate

                  , MAX (tmpMI.StartBegin) AS StartBegin
                  , MAX (tmpMI.EndBegin)   AS EndBegin
                  , SUM (COALESCE (tmpMI.diffBegin_sec,0)) ::TFloat AS diffBegin_sec

                  , tmpMI.MovementPromoId
                  
                  , tmpMI.isBarCode
                  , tmpMI.isAmountPartnerSecond
                  , tmpMI.isPriceWithVAT
                  , tmpMI.isReturnOut
                  , tmpMI.PriceRetOutDate 
                  , STRING_AGG (DISTINCT tmpMI.Comment, ';') ::TVarChar AS Comment
                  , tmpMI.isErased
             FROM tmpMI_1 AS tmpMI
            GROUP BY tmpMI.MovementItemId
                   , tmpMI.GoodsId
                   , tmpMI.WeightTare
                   , tmpMI.BoxNumber
                   , tmpMI.ChangePercentAmount
                   , tmpMI.ChangePercent
                   , tmpMI.Price
                   , tmpMI.CountForPrice 
                   , tmpMI.PricePartner
                   , tmpMI.PartionGoodsDate
                   , tmpMI.PartionGoods
                   , tmpMI.GoodsKindId
                   , tmpMI.BoxId
                   , tmpMI.PriceListId
                   , tmpMI.ReasonId
                   , tmpMI.PartionNum   
                   , tmpMI.AssetId
                   , tmpMI.AssetId_two
                   , tmpMI.InsertDate
                   , tmpMI.UpdateDate
                   , tmpMI.isBarCode
                   , tmpMI.isErased
                   , tmpMI.MovementPromoId
                   , tmpMI.WeightTare1
                   , tmpMI.WeightTare2
                   , tmpMI.WeightTare3
                   , tmpMI.WeightTare4
                   , tmpMI.WeightTare5
                   , tmpMI.WeightTare6
                   , tmpMI.isAmountPartnerSecond
                   , tmpMI.isPriceWithVAT
                   , tmpMI.PriceRetOutDate
                   , tmpMI.isReturnOut
                   --, tmpMI.Comment
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
--ALTER FUNCTION gpSelect_MovementItem_WeighingPartner (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 26.03.25         *
 18.10.24         * 
 18.10.22         * Asset
 04.11.19         *
 01.12.15         * promo
 16.10.14                                        * all
 11.03.14         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_WeighingPartner (inMovementId:= 14764281 , inShowAll:= TRUE, inIsErased:= TRUE, inSession:= '2')
-- select * from gpSelect_MovementItem_WeighingPartner(inMovementId := 29774297  , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '9457');

