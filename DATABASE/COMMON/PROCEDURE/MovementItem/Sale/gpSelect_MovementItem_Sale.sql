-- Function: gpSelect_MovementItem_Sale()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Sale (Integer, Integer, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Sale(
    IN inMovementId  Integer      , -- ���� ���������
    IN inPriceListId Integer      , -- ���� ����� �����
    IN inOperDate    TDateTime    , -- ���� ���������
    IN inShowAll     Boolean      , --
    IN inisErased    Boolean      , --
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, LineNum Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar
             , Amount TFloat, AmountChangePercent TFloat, AmountPartner TFloat
             , ChangePercentAmount TFloat, TotalPercentAmount TFloat, ChangePercent TFloat
             , Price TFloat, CountForPrice TFloat, PriceCost TFloat, SumCost TFloat, Price_Pricelist TFloat, Price_Pricelist_vat TFloat
             , HeadCount TFloat, BoxCount TFloat
             , PartionGoods TVarChar, GoodsKindId Integer, GoodsKindName  TVarChar, MeasureName TVarChar
             , AssetId Integer, AssetName TVarChar
             , BoxId Integer, BoxName TVarChar
             , AmountSumm TFloat
             , CountPack TFloat, WeightTotal TFloat, WeightPack TFloat, isBarCode Boolean 
             , isCheck_Pricelist Boolean
             , MovementPromo TVarChar, PricePromo TFloat
             , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , isErased Boolean
             , isPeresort Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbMovementId_order Integer;
   DECLARE vbIsB Boolean;

   DECLARE vbUnitId Integer;
   DECLARE vbPartnerId Integer;
   DECLARE vbContractId Integer;
   DECLARE vbChangePercent TFloat;
   DECLARE vbOperDate_promo TDateTime;

   DECLARE vbPriceWithVAT Boolean;
   DECLARE vbPriceWithVAT_pl Boolean;
   DECLARE vbVATPercent_pl TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_Sale());
     vbUserId:= lpGetUserBySession (inSession);


     -- ������������
     vbIsB:= EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId IN (300364, 442931, 343951, zc_Enum_Role_Admin())); -- ����� ������ (����������) + ��������� ������ ������ ����� - ��������� �.�. + ��������� (������������)

     -- ������� ������
     vbMovementId_order:= (SELECT MLM_Order.MovementChildId FROM MovementLinkMovement AS MLM_Order INNER JOIN Movement ON Movement.Id = MLM_Order.MovementId AND Movement.StatusId = zc_Enum_Status_Complete() WHERE MLM_Order.MovementId = inMovementId AND MLM_Order.DescId = zc_MovementLinkMovement_Order());
     -- �������� ��������
     -- !!!������!!!
     SELECT tmp.PriceListId, tmp.OperDate
            INTO inPriceListId, inOperDate
     FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract())
                                               , inPartnerId      := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To())
                                               , inMovementDescId := zc_Movement_Sale()
                                               , inOperDate_order := CASE WHEN vbMovementId_order <> 0
                                                                               THEN (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_order)
                                                                          ELSE NULL
                                                                     END
                                               , inOperDatePartner:= CASE WHEN vbMovementId_order <> 0 AND inOperDate + INTERVAL '1 DAY' >= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_order)
                                                                               THEN NULL
                                                                          ELSE inOperDate
                                                                     END
                                               , inDayPrior_PriceReturn:= 0 -- !!!�������� ����� �� �����!!!
                                               , inIsPrior        := FALSE -- !!!�������� ����� �� �����!!!
                                                ) AS tmp;


     -- �������������
     vbUnitId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From());
     -- ����������
     vbPartnerId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To());
     -- �������
     vbContractId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract());
     -- (-)% ������ (+)% �������
     vbChangePercent:= (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_ChangePercent());

     -- ���� � ���
     vbPriceWithVAT:= (SELECT MB.ValueData FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_PriceWithVAT());
     -- ���� � ��� (�����)
     vbPriceWithVAT_pl:= COALESCE ((SELECT OB.ValueData FROM ObjectBoolean AS OB WHERE OB.ObjectId = inPriceListId AND OB.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT()), FALSE);
     -- ���� (�����)
     vbVATPercent_pl:= 1 + COALESCE ((SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = inPriceListId AND ObjectFloat.DescId = zc_ObjectFloat_PriceList_VATPercent()), 0) / 100;

     -- ���� ��� ������ ����� - ��� <���� ���������� � �������> ��� <���� ������>
     vbOperDate_promo:= CASE WHEN vbMovementId_order <> 0
                              AND TRUE = (SELECT ObjectBoolean_OperDateOrder.ValueData
                                          FROM ObjectLink AS ObjectLink_Juridical
                                               INNER JOIN ObjectLink AS ObjectLink_Retail
                                                                     ON ObjectLink_Retail.ObjectId = ObjectLink_Juridical.ChildObjectId
                                                                    AND ObjectLink_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                               INNER JOIN ObjectBoolean AS ObjectBoolean_OperDateOrder
                                                                        ON ObjectBoolean_OperDateOrder.ObjectId = ObjectLink_Retail.ChildObjectId
                                                                       AND ObjectBoolean_OperDateOrder.DescId = zc_ObjectBoolean_Retail_OperDateOrder()
                                          WHERE ObjectLink_Juridical.ObjectId = vbPartnerId
                                            AND ObjectLink_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                         )
                                  THEN (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_Order)
                             ELSE (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_OperDatePartner())
                        END;


     -- �������� ��������
     IF inShowAll = TRUE
     THEN
         inShowAll:= inMovementId <> 0; -- AND NOT EXISTS (SELECT MovementId FROM MovementLinkMovement WHERE MovementId = inMovementId AND DescId = zc_MovementLinkMovement_Order() AND MovementChildId <> 0);
     END IF;


     IF inShowAll THEN

     RETURN QUERY
     
     WITH -- ������������� 
          tmpPriceCost AS (SELECT MIContainer.MovementItemId, -1 * SUM (MIContainer.Amount) AS SumCost 
                           FROM MovementItemContainer AS MIContainer
                           WHERE MIContainer.MovementId = inMovementId 
                             and MIContainer.DescId = zc_MIContainer_Summ()
                             and MIContainer.isActive = FALSE
                             and MIContainer.AccountId <> zc_Enum_Account_100301()
                           GROUP BY MIContainer.MovementItemId
                           )
           -- ����� �� ������� �� ����
         , tmpPromo AS (SELECT tmp.*
                        FROM lpSelect_Movement_Promo_Data (inOperDate   := vbOperDate_promo
                                                         , inPartnerId  := vbPartnerId
                                                         , inContractId := vbContractId
                                                         , inUnitId     := vbUnitId
                                                          ) AS tmp
                      )
            -- ����������� ��� �� - ����� ������ ��������
          , tmpGoodsByGoodsKind AS (SELECT Object_GoodsByGoodsKind_View.GoodsId
                                         , COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0) AS GoodsKindId
                                    FROM ObjectBoolean AS ObjectBoolean_Order
                                         LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.Id = ObjectBoolean_Order.ObjectId
                                    WHERE ObjectBoolean_Order.ValueData = TRUE
                                      AND ObjectBoolean_Order.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order()
                                   )
            -- ���� �� ������
          , tmpPriceList AS (SELECT lfSelect.GoodsId    AS GoodsId
                                   , CASE WHEN vbPriceWithVAT_pl = FALSE OR vbVATPercent_pl = 0 THEN lfSelect.ValuePrice ELSE lfSelect.ValuePrice / vbVATPercent_pl END AS Price_PriceList
                                   , CASE WHEN vbPriceWithVAT_pl = TRUE  OR vbVATPercent_pl = 0 THEN lfSelect.ValuePrice ELSE lfSelect.ValuePrice * vbVATPercent_pl END AS Price_PriceList_vat
                             FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= inPriceListId, inOperDate:= inOperDate) AS lfSelect 
                            )
            -- ������������ MovementItem
          , tmpMI_Goods AS (SELECT MovementItem.Id                               AS MovementItemId
                                 , MovementItem.ObjectId                         AS GoodsId
                                 , MovementItem.Amount                           AS Amount
                                 , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId

                                 , MIFloat_AmountPartner.ValueData               AS AmountPartner
                                 , MIFloat_AmountChangePercent.ValueData         AS AmountChangePercent
                                 , MIFloat_ChangePercentAmount.ValueData         AS ChangePercentAmount
                                 , COALESCE (MIFloat_ChangePercent.ValueData, 0) AS ChangePercent

                                 , MIFloat_Price.ValueData                       AS Price
                                 , MIFloat_CountForPrice.ValueData               AS CountForPrice

                                 , MIFloat_HeadCount.ValueData                   AS HeadCount
                                 , MIFloat_BoxCount.ValueData                    AS BoxCount
                                 , MIFloat_CountPack.ValueData                   AS CountPack
                                 , MIFloat_WeightTotal.ValueData                 AS WeightTotal
                                 , MIFloat_WeightPack.ValueData                  AS WeightPack
                                 , MIBoolean_BarCode.ValueData                   AS isBarCode
                                 , MIString_PartionGoods.ValueData               AS PartionGoods

                                 , MILinkObject_Box.ObjectId                     AS BoxId
                                 , MILinkObject_Asset.ObjectId                   AS AssetId
                                 , MIFloat_PromoMovement.ValueData               AS MovementId_Promo
                                 , MovementItem.isErased                         AS isErased
                            FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                                 INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                        AND MovementItem.DescId     = zc_MI_Master()
                                                        AND MovementItem.isErased   = tmpIsErased.isErased
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                  ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
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
                                 LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                             ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                            AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                 LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                             ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                            AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                                 LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                                             ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                                            AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
                                 LEFT JOIN MovementItemFloat AS MIFloat_BoxCount
                                                             ON MIFloat_BoxCount.MovementItemId = MovementItem.Id
                                                            AND MIFloat_BoxCount.DescId = zc_MIFloat_BoxCount()

                                 LEFT JOIN MovementItemFloat AS MIFloat_CountPack
                                                             ON MIFloat_CountPack.MovementItemId = MovementItem.Id
                                                            AND MIFloat_CountPack.DescId = zc_MIFloat_CountPack()
                                 LEFT JOIN MovementItemFloat AS MIFloat_WeightTotal
                                                             ON MIFloat_WeightTotal.MovementItemId = MovementItem.Id
                                                            AND MIFloat_WeightTotal.DescId = zc_MIFloat_WeightTotal()
                                 LEFT JOIN MovementItemFloat AS MIFloat_WeightPack
                                                             ON MIFloat_WeightPack.MovementItemId = MovementItem.Id
                                                            AND MIFloat_WeightPack.DescId = zc_MIFloat_WeightPack()
                                 LEFT JOIN MovementItemBoolean AS MIBoolean_BarCode 
                                                               ON MIBoolean_BarCode.MovementItemId = MovementItem.Id
                                                              AND MIBoolean_BarCode.DescId = zc_MIBoolean_BarCode()
                                       
                                 LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                              ON MIString_PartionGoods.MovementItemId =  MovementItem.Id
                                                             AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()

                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Box
                                                                  ON MILinkObject_Box.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_Box.DescId = zc_MILinkObject_Box()
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                                  ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()

                                 LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                                             ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                                            AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
                           )
           -- ����� � ������� ��� ������������ MovementItem
         , tmpMIPromo_all AS (SELECT tmp.MovementId_Promo                          AS MovementId_Promo
                                   , MovementItem.Id                               AS MovementItemId
                                   , MovementItem.ObjectId                         AS GoodsId
                                   , MovementItem.Amount                           AS TaxPromo
                                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                              FROM (SELECT DISTINCT tmpMI_Goods.MovementId_Promo :: Integer AS MovementId_Promo FROM tmpMI_Goods WHERE tmpMI_Goods.MovementId_Promo <> 0) AS tmp
                                   INNER JOIN MovementItem ON MovementItem.MovementId = tmp.MovementId_Promo
                                                          AND MovementItem.DescId = zc_MI_Master()
                                                          AND MovementItem.isErased = FALSE
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                             )
               -- ����� �� ������� ��� ������������ MovementItem
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

           -- ������ �������� ��/���
          , tmpGoodsByGoodsKindSub AS (SELECT Object_GoodsByGoodsKind_View.GoodsId
                                            , COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0) AS GoodsKindId
                                            --, ObjectLink_GoodsByGoodsKind_GoodsSub.ChildObjectId     AS GoodsSubId
                                            --, ObjectLink_GoodsByGoodsKind_GoodsKindSub.ChildObjectId AS GoodsKindSubId
                                            , CASE WHEN COALESCE(ObjectLink_GoodsByGoodsKind_GoodsSub.ChildObjectId ,0)<>0 OR COALESCE(ObjectLink_GoodsByGoodsKind_GoodsKindSub.ChildObjectId,0) <> 0 
                                                   THEN TRUE ELSE FALSE 
                                              END AS isPeresort
                                       FROM Object_GoodsByGoodsKind_View 
                                         LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsSub 
                                                              ON ObjectLink_GoodsByGoodsKind_GoodsSub.ObjectId = Object_GoodsByGoodsKind_View.Id 
                                                             AND ObjectLink_GoodsByGoodsKind_GoodsSub.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsSub()
                                         LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKindSub
                                                              ON ObjectLink_GoodsByGoodsKind_GoodsKindSub.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                             AND ObjectLink_GoodsByGoodsKind_GoodsKindSub.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKindSub()
                                       WHERE COALESCE(ObjectLink_GoodsByGoodsKind_GoodsSub.ChildObjectId ,0)<>0 OR COALESCE(ObjectLink_GoodsByGoodsKind_GoodsKindSub.ChildObjectId,0) <> 0 
                                       )
       -- ���������
       SELECT
             0                          AS Id
           , 0                          AS LineNum
           , tmpGoods.GoodsId           AS GoodsId
           , tmpGoods.GoodsCode         AS GoodsCode
           , tmpGoods.GoodsName         AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , CAST (NULL AS TFloat)      AS Amount
           , CAST (NULL AS TFloat)      AS AmountChangePercent
           , CAST (NULL AS TFloat)      AS AmountPartner
           , CAST (NULL AS TFloat)      AS ChangePercentAmount
           , CAST (NULL AS TFloat)      AS TotalPercentAmount
           , CASE WHEN COALESCE (tmpPromo.isChangePercent, TRUE) = TRUE THEN vbChangePercent ELSE 0 END :: TFloat AS ChangePercent

           , CASE WHEN tmpPromo.TaxPromo <> 0 AND vbPriceWithVAT = TRUE THEN tmpPromo.PriceWithVAT
                  WHEN tmpPromo.TaxPromo <> 0 THEN tmpPromo.PriceWithOutVAT
                  WHEN vbPriceWithVAT = FALSE THEN tmpPriceList.Price_Pricelist
                  WHEN vbPriceWithVAT = TRUE  THEN tmpPriceList.Price_Pricelist_vat
             END :: TFloat              AS Price
           , CAST (1 AS TFloat)         AS CountForPrice

           , CAST (0 AS TFloat)         AS PriceCost
           , CAST (0 AS TFloat)         AS SumCost

           , CAST (tmpPriceList.Price_Pricelist AS TFloat)     AS Price_Pricelist
           , CAST (tmpPriceList.Price_Pricelist_vat AS TFloat) AS Price_Pricelist_vat

           , CAST (NULL AS TFloat)      AS HeadCount
           , CAST (NULL AS TFloat)      AS BoxCount
           , CAST (NULL AS TVarChar)    AS PartionGoods
           , Object_GoodsKind.Id        AS GoodsKindId
           , Object_GoodsKind.ValueData AS GoodsKindName
           , Object_Measure.ValueData   AS MeasureName
           , 0 ::Integer                AS AssetId
           , '' ::TVarChar              AS AssetName
           , 0 ::Integer                AS BoxId
           , '' ::TVarChar              AS BoxName
           , CAST (NULL AS TFloat)      AS AmountSumm
           
           , CAST (NULL AS TFloat)      AS CountPack
           , CAST (NULL AS TFloat)      AS WeightTotal
           , CAST (NULL AS TFloat)      AS WeightPack
           , FALSE                      AS isBarCode
                      
           , FALSE                      AS isCheck_PricelistBoolean

           , tmpPromo.MovementPromo
           , CASE WHEN tmpPromo.TaxPromo <> 0 AND vbPriceWithVAT = TRUE THEN tmpPromo.PriceWithVAT
                  WHEN tmpPromo.TaxPromo <> 0 THEN tmpPromo.PriceWithOutVAT
                  ELSE 0
             END :: TFloat AS PricePromo

           , tmpGoods.InfoMoneyCode
           , tmpGoods.InfoMoneyGroupName
           , tmpGoods.InfoMoneyDestinationName
           , tmpGoods.InfoMoneyName
           , tmpGoods.InfoMoneyName_all

           , FALSE AS isErased
           , COALESCE (tmpGoodsByGoodsKindSub.isPeresort, False) AS isPeresort
       FROM (SELECT Object_Goods.Id                                        AS GoodsId
                  , Object_Goods.ObjectCode                                AS GoodsCode
                  , Object_Goods.ValueData                                 AS GoodsName
                  , COALESCE (tmpGoodsByGoodsKind.GoodsKindId, 0)          AS GoodsKindId
                  -- , CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) THEN zc_Enum_GoodsKind_Main() ELSE 0 END AS GoodsKindId -- ���� + ������� ��������� + ������ ������ �����
                  -- , COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0) AS GoodsKindId

                  , Object_InfoMoney_View.InfoMoneyCode
                  , Object_InfoMoney_View.InfoMoneyGroupName
                  , Object_InfoMoney_View.InfoMoneyDestinationName
                  , Object_InfoMoney_View.InfoMoneyName
                  , Object_InfoMoney_View.InfoMoneyName_all
                 
             FROM Object_InfoMoney_View
                  JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                  ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                 AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                  JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_InfoMoney.ObjectId
                                             AND Object_Goods.isErased = FALSE
                  LEFT JOIN tmpGoodsByGoodsKind ON tmpGoodsByGoodsKind.GoodsId = Object_Goods.Id
                  /*LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsId = Object_Goods.Id
                                                        AND Object_InfoMoney_View.InfoMoneyId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) -- ���� + ������� ��������� + ������ ������ �����*/
                 
             WHERE (tmpGoodsByGoodsKind.GoodsId > 0 AND Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()
                                                                                                       , zc_Enum_InfoMoneyDestination_21000()
                                                                                                       , zc_Enum_InfoMoneyDestination_21100()
                                                                                                       , zc_Enum_InfoMoneyDestination_30100()
                                                                                                       , zc_Enum_InfoMoneyDestination_30200()
                                                                                                       -- , zc_Enum_InfoMoneyDestination_20500() -- ������������� + ��������� ����
                                                                                                       -- , zc_Enum_InfoMoneyDestination_20600() -- ������������� + ������ ���������
                                                                                                        ))
                -- OR Object_InfoMoney_View.InfoMoneyDestinationId IN  (zc_Enum_InfoMoneyDestination_20500() -- ������������� + ��������� ����
                --                                                    , zc_Enum_InfoMoneyDestination_20600() -- ������������� + ������ ���������
                --                                                     )
                OR vbIsB = TRUE
            ) AS tmpGoods
            LEFT JOIN tmpMI_Goods AS tmpMI ON tmpMI.GoodsId     = tmpGoods.GoodsId
                                          AND tmpMI.GoodsKindId = tmpGoods.GoodsKindId
            LEFT JOIN tmpPromo ON tmpPromo.GoodsId      = tmpGoods.GoodsId
                              AND (tmpPromo.GoodsKindId = tmpGoods.GoodsKindId OR tmpPromo.GoodsKindId = 0)

            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpGoods.GoodsKindId
            LEFT JOIN tmpPriceList ON tmpPriceList.GoodsId = tmpGoods.GoodsId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN tmpGoodsByGoodsKindSub ON tmpGoodsByGoodsKindSub.GoodsId = tmpGoods.GoodsId
                                            AND tmpGoodsByGoodsKindSub.GoodsKindId = tmpGoods.GoodsKindId
       WHERE tmpMI.GoodsId IS NULL

      UNION ALL
       SELECT
             tmpMI_Goods.MovementItemId             AS Id
           , CAST (row_number() OVER (ORDER BY tmpMI_Goods.MovementItemId) AS Integer) AS LineNum
           , Object_Goods.Id                        AS GoodsId
           , Object_Goods.ObjectCode                AS GoodsCode
           , Object_Goods.ValueData                 AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , tmpMI_Goods.Amount                     AS Amount
           , tmpMI_Goods.AmountChangePercent
           , tmpMI_Goods.AmountPartner
           , tmpMI_Goods.ChangePercentAmount
           , (tmpMI_Goods.Amount - COALESCE (tmpMI_Goods.AmountChangePercent, 0)) :: TFloat AS TotalPercentAmount
           , tmpMI_Goods.ChangePercent :: TFloat AS ChangePercent

           , tmpMI_Goods.Price
           , tmpMI_Goods.CountForPrice

           , CASE WHEN tmpMI_Goods.Amount <> 0 THEN tmpPriceCost.SumCost / tmpMI_Goods.Amount ELSE 0 END  ::TFloat AS PriceCost
           , tmpPriceCost.SumCost :: TFloat         AS SumCost

           , tmpPriceList.Price_Pricelist     :: TFloat AS Price_Pricelist
           , tmpPriceList.Price_Pricelist_vat :: TFloat AS Price_Pricelist_vat

           , tmpMI_Goods.HeadCount
           , tmpMI_Goods.BoxCount

           , tmpMI_Goods.PartionGoods
           , Object_GoodsKind.Id                    AS GoodsKindId
           , Object_GoodsKind.ValueData             AS GoodsKindName
           , Object_Measure.ValueData               AS MeasureName

           , Object_Asset.Id                        AS AssetId
           , Object_Asset.ValueData                 AS AssetName

           , Object_Box.Id                          AS BoxId
           , Object_Box.ValueData                   AS BoxName

           , CAST (CASE WHEN tmpMI_Goods.CountForPrice > 0
                           THEN CAST ( (COALESCE (tmpMI_Goods.AmountPartner, 0)) * tmpMI_Goods.Price / tmpMI_Goods.CountForPrice AS NUMERIC (16, 2))
                           ELSE CAST ( (COALESCE (tmpMI_Goods.AmountPartner, 0)) * tmpMI_Goods.Price AS NUMERIC (16, 2))
                   END AS TFloat)                   AS AmountSumm
                   
           , tmpMI_Goods.CountPack
           , tmpMI_Goods.WeightTotal
           , tmpMI_Goods.WeightPack
           , tmpMI_Goods.isBarCode

           , CASE WHEN tmpPromo.TaxPromo <> 0 AND vbPriceWithVAT = TRUE AND tmpPromo.PriceWithVAT = tmpMI_Goods.Price
                       THEN FALSE
                  WHEN tmpPromo.TaxPromo <> 0 AND tmpPromo.PriceWithOutVAT = tmpMI_Goods.Price
                       THEN FALSE
                  WHEN (COALESCE (tmpMI_Goods.Price, 0) = COALESCE (tmpPriceList.Price_Pricelist, 0)     AND vbPriceWithVAT = FALSE)
                    OR (COALESCE (tmpMI_Goods.Price, 0) = COALESCE (tmpPriceList.Price_Pricelist_vat, 0) AND vbPriceWithVAT = TRUE)
                       THEN FALSE
                  ELSE TRUE
             END :: Boolean AS isCheck_PricelistBoolean

           , (CASE WHEN (tmpPromo.isChangePercent = TRUE  AND tmpMI_Goods.ChangePercent <> vbChangePercent)
                     OR (tmpPromo.isChangePercent = FALSE AND tmpMI_Goods.ChangePercent <> 0)
                        THEN '������ <(-)% ������ (+)% �������>'
                   ELSE ''
              END
           || CASE WHEN tmpMIPromo.MovementId_Promo = tmpPromo.MovementId
                        THEN tmpPromo.MovementPromo
                   WHEN tmpMIPromo.MovementId_Promo <> COALESCE (tmpPromo.MovementId, 0)
                        THEN '������ ' || zfCalc_PromoMovementName (NULL, Movement_Promo_View.InvNumber :: TVarChar, Movement_Promo_View.OperDate, Movement_Promo_View.StartSale, Movement_Promo_View.EndSale)
                   WHEN COALESCE (tmpMIPromo.MovementId_Promo, 0) <> tmpPromo.MovementId
                        THEN '������ ' || tmpPromo.MovementPromo
                   ELSE ''
              END) :: TVarChar AS MovementPromo

           , CASE WHEN 1 = 0 AND tmpMIPromo.PricePromo <> 0 THEN tmpMIPromo.PricePromo
                  WHEN tmpPromo.TaxPromo <> 0 AND vbPriceWithVAT = TRUE THEN tmpPromo.PriceWithVAT
                  WHEN tmpPromo.TaxPromo <> 0 THEN tmpPromo.PriceWithOutVAT
                  ELSE 0
             END :: TFloat AS PricePromo

           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName
           , Object_InfoMoney_View.InfoMoneyName_all

           , tmpMI_Goods.isErased
           , COALESCE (tmpGoodsByGoodsKindSub.isPeresort, False) AS isPeresort
       FROM tmpMI_Goods
            LEFT JOIN tmpMIPromo ON tmpMIPromo.MovementId_Promo = tmpMI_Goods.MovementId_Promo
                                AND tmpMIPromo.GoodsId          = tmpMI_Goods.GoodsId
                                AND (tmpMIPromo.GoodsKindId     = tmpMI_Goods.GoodsKindId
                                  OR tmpMIPromo.GoodsKindId     = 0)
            LEFT JOIN tmpPromo ON tmpPromo.GoodsId      = tmpMI_Goods.GoodsId
                              AND (tmpPromo.GoodsKindId = tmpMI_Goods.GoodsKindId OR tmpPromo.GoodsKindId = 0)

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI_Goods.GoodsId
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpMI_Goods.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId


            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI_Goods.GoodsKindId

            LEFT JOIN Object AS Object_Box ON Object_Box.Id = tmpMI_Goods.BoxId
            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = tmpMI_Goods.AssetId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI_Goods.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN Movement_Promo_View ON Movement_Promo_View.Id = tmpMI_Goods.MovementId_Promo
                                  
            LEFT JOIN tmpPriceCost ON tmpPriceCost.MovementItemId = tmpMI_Goods.MovementItemId
            LEFT JOIN tmpPriceList ON tmpPriceList.GoodsId = tmpMI_Goods.GoodsId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

            LEFT JOIN tmpGoodsByGoodsKindSub ON tmpGoodsByGoodsKindSub.GoodsId = tmpMI_Goods.GoodsId
                                            AND tmpGoodsByGoodsKindSub.GoodsKindId = tmpMI_Goods.GoodsKindId
           ;
     ELSE

     RETURN QUERY

     
     WITH -- �������������
          tmpPriceCost AS (SELECT MIC.MovementItemId, Sum ( MIC.Amount) *(-1) AS SumCost 
                           FROM MovementItemContainer AS MIC
                           WHERE MIC.MovementId = inMovementId 
                             and MIC.DescId = zc_MIContainer_Summ()
                             and MIC.isactive = False 
                             and MIC.AccountId <> zc_Enum_Account_100301 ()
                           GROUP BY MIC.MovementItemId
                           )
            -- ����� �� ������� �� ����
          , tmpPromo AS (SELECT tmp.*
                         FROM lpSelect_Movement_Promo_Data (inOperDate   := vbOperDate_promo
                                                          , inPartnerId  := vbPartnerId
                                                          , inContractId := vbContractId
                                                          , inUnitId     := vbUnitId
                                                           ) AS tmp
                        )
            -- ���� �� ������
          , tmpPriceList AS (SELECT lfSelect.GoodsId    AS GoodsId
                                   , CASE WHEN vbPriceWithVAT_pl = FALSE OR vbVATPercent_pl = 0 THEN lfSelect.ValuePrice ELSE lfSelect.ValuePrice / vbVATPercent_pl END AS Price_PriceList
                                   , CASE WHEN vbPriceWithVAT_pl = TRUE  OR vbVATPercent_pl = 0 THEN lfSelect.ValuePrice ELSE lfSelect.ValuePrice * vbVATPercent_pl END AS Price_PriceList_vat
                             FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= inPriceListId, inOperDate:= inOperDate) AS lfSelect
                            )
            -- ������������ MovementItem
          , tmpMI_Goods AS (SELECT MovementItem.Id                               AS MovementItemId
                                 , MovementItem.ObjectId                         AS GoodsId
                                 , MovementItem.Amount                           AS Amount
                                 , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId

                                 , MIFloat_AmountPartner.ValueData               AS AmountPartner
                                 , MIFloat_AmountChangePercent.ValueData         AS AmountChangePercent
                                 , MIFloat_ChangePercentAmount.ValueData         AS ChangePercentAmount
                                 , COALESCE (MIFloat_ChangePercent.ValueData, 0) AS ChangePercent

                                 , MIFloat_Price.ValueData                       AS Price
                                 , MIFloat_CountForPrice.ValueData               AS CountForPrice

                                 , MIFloat_HeadCount.ValueData                   AS HeadCount
                                 , MIFloat_BoxCount.ValueData                    AS BoxCount
                                 , MIFloat_CountPack.ValueData                   AS CountPack

                                 , MIFloat_WeightTotal.ValueData                 AS WeightTotal
                                 , MIFloat_WeightPack.ValueData                  AS WeightPack
                                 , MIBoolean_BarCode.ValueData                   AS isBarCode
                                 , MIString_PartionGoods.ValueData               AS PartionGoods

                                 , MILinkObject_Box.ObjectId                     AS BoxId
                                 , MILinkObject_Asset.ObjectId                   AS AssetId
                                 , MIFloat_PromoMovement.ValueData               AS MovementId_Promo
                                 , MovementItem.isErased                         AS isErased
                            FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                                 INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                        AND MovementItem.DescId     = zc_MI_Master()
                                                        AND MovementItem.isErased   = tmpIsErased.isErased
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                  ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
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

                                 LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                             ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                            AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                 LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                             ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                            AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                                 LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                                             ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                                            AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
                                 LEFT JOIN MovementItemFloat AS MIFloat_BoxCount
                                                             ON MIFloat_BoxCount.MovementItemId = MovementItem.Id
                                                            AND MIFloat_BoxCount.DescId = zc_MIFloat_BoxCount()

                                 LEFT JOIN MovementItemFloat AS MIFloat_CountPack
                                                             ON MIFloat_CountPack.MovementItemId = MovementItem.Id
                                                            AND MIFloat_CountPack.DescId = zc_MIFloat_CountPack()
                                 LEFT JOIN MovementItemFloat AS MIFloat_WeightTotal
                                                             ON MIFloat_WeightTotal.MovementItemId = MovementItem.Id
                                                            AND MIFloat_WeightTotal.DescId = zc_MIFloat_WeightTotal()
                                 LEFT JOIN MovementItemFloat AS MIFloat_WeightPack
                                                             ON MIFloat_WeightPack.MovementItemId = MovementItem.Id
                                                            AND MIFloat_WeightPack.DescId = zc_MIFloat_WeightPack()
                                 LEFT JOIN MovementItemBoolean AS MIBoolean_BarCode 
                                                               ON MIBoolean_BarCode.MovementItemId = MovementItem.Id
                                                              AND MIBoolean_BarCode.DescId = zc_MIBoolean_BarCode()
                                       
                                 LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                              ON MIString_PartionGoods.MovementItemId =  MovementItem.Id
                                                             AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()

                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Box
                                                                  ON MILinkObject_Box.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_Box.DescId = zc_MILinkObject_Box()
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                                  ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()

                                 LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                                             ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                                            AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
                           )
           -- ����� � ������� ��� ������������ MovementItem
         , tmpMIPromo_all AS (SELECT tmp.MovementId_Promo                          AS MovementId_Promo
                                   , MovementItem.Id                               AS MovementItemId
                                   , MovementItem.ObjectId                         AS GoodsId
                                   , MovementItem.Amount                           AS TaxPromo
                                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                              FROM (SELECT DISTINCT tmpMI_Goods.MovementId_Promo :: Integer AS MovementId_Promo FROM tmpMI_Goods WHERE tmpMI_Goods.MovementId_Promo <> 0) AS tmp
                                   INNER JOIN MovementItem ON MovementItem.MovementId = tmp.MovementId_Promo
                                                          AND MovementItem.DescId = zc_MI_Master()
                                                          AND MovementItem.isErased = FALSE
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                             )
               -- ����� �� ������� ��� ������������ MovementItem
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
            -- ������ �������� ��/���
          , tmpGoodsByGoodsKindSub AS (SELECT Object_GoodsByGoodsKind_View.GoodsId
                                            , COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0) AS GoodsKindId
                                            --, ObjectLink_GoodsByGoodsKind_GoodsSub.ChildObjectId     AS GoodsSubId
                                            --, ObjectLink_GoodsByGoodsKind_GoodsKindSub.ChildObjectId AS GoodsKindSubId
                                            , CASE WHEN COALESCE(ObjectLink_GoodsByGoodsKind_GoodsSub.ChildObjectId ,0)<>0 OR COALESCE(ObjectLink_GoodsByGoodsKind_GoodsKindSub.ChildObjectId,0) <> 0 
                                                   THEN TRUE ELSE FALSE 
                                              END AS isPeresort
                                       FROM Object_GoodsByGoodsKind_View 
                                         LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsSub 
                                                              ON ObjectLink_GoodsByGoodsKind_GoodsSub.ObjectId = Object_GoodsByGoodsKind_View.Id 
                                                             AND ObjectLink_GoodsByGoodsKind_GoodsSub.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsSub()
                                         LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKindSub
                                                              ON ObjectLink_GoodsByGoodsKind_GoodsKindSub.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                             AND ObjectLink_GoodsByGoodsKind_GoodsKindSub.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKindSub()
                                       WHERE COALESCE(ObjectLink_GoodsByGoodsKind_GoodsSub.ChildObjectId ,0)<>0 OR COALESCE(ObjectLink_GoodsByGoodsKind_GoodsKindSub.ChildObjectId,0) <> 0 
                                       )
       -- ���������     
       SELECT
             tmpMI_Goods.MovementItemId             AS Id
           , CAST (row_number() OVER (ORDER BY tmpMI_Goods.MovementItemId) AS Integer) AS LineNum
           , Object_Goods.Id                        AS GoodsId
           , Object_Goods.ObjectCode                AS GoodsCode
           , Object_Goods.ValueData                 AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , tmpMI_Goods.Amount                     AS Amount
           , tmpMI_Goods.AmountChangePercent
           , tmpMI_Goods.AmountPartner
           , tmpMI_Goods.ChangePercentAmount
           , (tmpMI_Goods.Amount - COALESCE (tmpMI_Goods.AmountChangePercent, 0)) :: TFloat AS TotalPercentAmount
           , tmpMI_Goods.ChangePercent      :: TFloat AS ChangePercent

           , tmpMI_Goods.Price
           , tmpMI_Goods.CountForPrice
           , CASE WHEN tmpMI_Goods.Amount <> 0 THEN tmpPriceCost.SumCost / tmpMI_Goods.Amount ELSE 0 END  ::TFloat AS PriceCost
           , tmpPriceCost.SumCost :: TFloat         AS SumCost

           , tmpPriceList.Price_Pricelist     :: TFloat AS Price_Pricelist
           , tmpPriceList.Price_Pricelist_vat :: TFloat AS Price_Pricelist_vat

           , tmpMI_Goods.HeadCount
           , tmpMI_Goods.BoxCount

           , tmpMI_Goods.PartionGoods
           , Object_GoodsKind.Id                    AS GoodsKindId
           , Object_GoodsKind.ValueData             AS GoodsKindName
           , Object_Measure.ValueData               AS MeasureName

           , Object_Asset.Id                        AS AssetId
           , Object_Asset.ValueData                 AS AssetName

           , Object_Box.Id                          AS BoxId
           , Object_Box.ValueData                   AS BoxName

           , CAST (CASE WHEN tmpMI_Goods.CountForPrice > 0
                           THEN CAST ( (COALESCE (tmpMI_Goods.AmountPartner, 0)) * tmpMI_Goods.Price / tmpMI_Goods.CountForPrice AS NUMERIC (16, 2))
                           ELSE CAST ( (COALESCE (tmpMI_Goods.AmountPartner, 0)) * tmpMI_Goods.Price AS NUMERIC (16, 2))
                   END AS TFloat)                   AS AmountSumm
                   
           , tmpMI_Goods.CountPack
           , tmpMI_Goods.WeightTotal
           , tmpMI_Goods.WeightPack
           , tmpMI_Goods.isBarCode

           , CASE WHEN tmpPromo.TaxPromo <> 0 AND vbPriceWithVAT = TRUE AND tmpPromo.PriceWithVAT = tmpMI_Goods.Price
                       THEN FALSE
                  WHEN tmpPromo.TaxPromo <> 0 AND tmpPromo.PriceWithOutVAT = tmpMI_Goods.Price
                       THEN FALSE
                  WHEN (COALESCE (tmpMI_Goods.Price, 0) = COALESCE (tmpPriceList.Price_Pricelist, 0)     AND vbPriceWithVAT = FALSE)
                    OR (COALESCE (tmpMI_Goods.Price, 0) = COALESCE (tmpPriceList.Price_Pricelist_vat, 0) AND vbPriceWithVAT = TRUE)
                       THEN FALSE
                  ELSE TRUE
             END :: Boolean AS isCheck_PricelistBoolean

           , (CASE WHEN (tmpPromo.isChangePercent = TRUE  AND tmpMI_Goods.ChangePercent <> vbChangePercent)
                     OR (tmpPromo.isChangePercent = FALSE AND tmpMI_Goods.ChangePercent <> 0)
                        THEN '������ <(-)% ������ (+)% �������>'
                   ELSE ''
              END
           || CASE WHEN tmpMIPromo.MovementId_Promo = tmpPromo.MovementId
                        THEN tmpPromo.MovementPromo
                   WHEN tmpMIPromo.MovementId_Promo <> COALESCE (tmpPromo.MovementId, 0)
                        THEN '������ ' || zfCalc_PromoMovementName (NULL, Movement_Promo_View.InvNumber :: TVarChar, Movement_Promo_View.OperDate, Movement_Promo_View.StartSale, Movement_Promo_View.EndSale)
                   WHEN COALESCE (tmpMIPromo.MovementId_Promo, 0) <> tmpPromo.MovementId
                        THEN '������ ' || tmpPromo.MovementPromo
                   ELSE ''
              END) :: TVarChar AS MovementPromo

           , CASE WHEN 1 = 0 AND tmpMIPromo.PricePromo <> 0 THEN tmpMIPromo.PricePromo
                  WHEN tmpPromo.TaxPromo <> 0 AND vbPriceWithVAT = TRUE THEN tmpPromo.PriceWithVAT
                  WHEN tmpPromo.TaxPromo <> 0 THEN tmpPromo.PriceWithOutVAT
                  ELSE 0
             END :: TFloat AS PricePromo

           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName
           , Object_InfoMoney_View.InfoMoneyName_all

           , tmpMI_Goods.isErased
           , COALESCE (tmpGoodsByGoodsKindSub.isPeresort, False) AS isPeresort

       FROM tmpMI_Goods
            LEFT JOIN tmpMIPromo ON tmpMIPromo.MovementId_Promo = tmpMI_Goods.MovementId_Promo
                                AND tmpMIPromo.GoodsId          = tmpMI_Goods.GoodsId
                                AND (tmpMIPromo.GoodsKindId     = tmpMI_Goods.GoodsKindId
                                  OR tmpMIPromo.GoodsKindId     = 0)
            LEFT JOIN tmpPromo ON tmpPromo.GoodsId      = tmpMI_Goods.GoodsId
                              AND (tmpPromo.GoodsKindId = tmpMI_Goods.GoodsKindId OR tmpPromo.GoodsKindId = 0)

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI_Goods.GoodsId
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpMI_Goods.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId


            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI_Goods.GoodsKindId

            LEFT JOIN Object AS Object_Box ON Object_Box.Id = tmpMI_Goods.BoxId
            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = tmpMI_Goods.AssetId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI_Goods.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN Movement_Promo_View ON Movement_Promo_View.Id = COALESCE (tmpPromo.MovementId, tmpMI_Goods.MovementId_Promo)
                                  
            LEFT JOIN tmpPriceCost ON tmpPriceCost.MovementItemId = tmpMI_Goods.MovementItemId
            LEFT JOIN tmpPriceList ON tmpPriceList.GoodsId = tmpMI_Goods.GoodsId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

            LEFT JOIN tmpGoodsByGoodsKindSub ON tmpGoodsByGoodsKindSub.GoodsId = tmpMI_Goods.GoodsId
                                            AND tmpGoodsByGoodsKindSub.GoodsKindId = tmpMI_Goods.GoodsKindId
           ;

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_Sale (Integer, Integer, TDateTime, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.10.14                                                       * add box
 14.04.14                                                       * add inOperDate
 08.04.14                                        * add zc_Enum_InfoMoneyDestination_30100
 08.04.14                                        * add MeasureName
 30.01.14                                                        * inisErased
 21.01.14                                                        * PriceList
 08.09.13                                        * add AmountChangePercent
 03.09.13                                        * add ChangePercentAmount
 21.07.13                                        * add lfSelect_ObjectHistory_PriceListItem
 18.07.13         * add Object_Asset
 13.07.13         *
*/

-- ����
-- SELECT * FROM gpSelect_MovementItem_Sale (inMovementId:= 4229, inPriceListId:=0, inOperDate:= CURRENT_TIMESTAMP, inShowAll:= TRUE, inisErased:= True, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItem_Sale (inMovementId:= 2696373, inPriceListId:=0, inOperDate:= CURRENT_TIMESTAMP, inShowAll:= FALSE, inisErased:= True, inSession:= '2')
