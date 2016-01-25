-- Function: gpSelect_MovementItem_Sale_Order()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Sale_Order (Integer, Integer, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Sale_Order(
    IN inMovementId  Integer      , -- ���� ���������
    IN inPriceListId Integer      , -- ���� ����� �����
    IN inOperDate    TDateTime    , -- ���� ���������
    IN inShowAll     Boolean      , --
    IN inisErased    Boolean      , --
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, LineNum Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar
             , Amount TFloat, AmountChangePercent TFloat, AmountPartner TFloat, AmountOrder TFloat
             , ChangePercentAmount TFloat, TotalPercentAmount TFloat, ChangePercent TFloat
             , Price TFloat, CountForPrice TFloat, Price_Pricelist TFloat, Price_Pricelist_vat TFloat
             , HeadCount TFloat, BoxCount TFloat
             , PartionGoods TVarChar, GoodsKindId Integer, GoodsKindName  TVarChar, MeasureName TVarChar
             , AssetId Integer, AssetName TVarChar
             , BoxId Integer, BoxName TVarChar
             , AmountSumm TFloat
             , isCheck_Pricelist Boolean
             , MovementPromo TVarChar, PricePromo TFloat
             , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbMovementId_order Integer;

   DECLARE vbUnitId Integer;
   DECLARE vbPartnerId Integer;
   DECLARE vbContractId Integer;
   DECLARE vbChangePercent TFloat;
   DECLARE vbPriceWithVAT Boolean;
   DECLARE vbPriceWithVAT_pl Boolean;
   DECLARE vbVATPercent_pl TFloat;
   DECLARE vbOperDate_promo TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_Sale());
     vbUserId:= lpGetUserBySession (inSession);


     -- ������� ������
     vbMovementId_order:= (SELECT MLM_Order.MovementChildId FROM MovementLinkMovement AS MLM_Order WHERE MLM_Order.MovementId = inMovementId AND MLM_Order.DescId = zc_MovementLinkMovement_Order());
     -- �������� ��������
     IF inShowAll = TRUE AND vbMovementId_order > 0
     THEN
         inShowAll:= FALSE;
     ELSE
         IF inShowAll = TRUE
         THEN
             inShowAll:= inMovementId <> 0; -- AND NOT EXISTS (SELECT MovementId FROM MovementLinkMovement WHERE MovementId = inMovementId AND DescId = zc_MovementLinkMovement_Order() AND MovementChildId <> 0);
         END IF;
     END IF;


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


     IF inShowAll = TRUE
     THEN

     RETURN QUERY
       WITH -- ����� �� ������� �� ����
            tmpPromo AS (SELECT tmp.*
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
          , tmpMI AS (SELECT MovementItem.Id                               AS MovementItemId
                           , MovementItem.ObjectId                         AS GoodsId
                           , MovementItem.Amount                           AS Amount
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId

                           , MIFloat_AmountPartner.ValueData               AS AmountPartner
                           , MIFloat_AmountChangePercent.ValueData         AS AmountChangePercent
                           , MIFloat_ChangePercentAmount.ValueData         AS ChangePercentAmount
                           , COALESCE (MIFloat_ChangePercent.ValueData, 0) AS ChangePercent

                           , COALESCE (MIFloat_Price.ValueData, 0)         AS Price
                           , CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice

                           , MIFloat_HeadCount.ValueData                   AS HeadCount
                           , MIFloat_BoxCount.ValueData                    AS BoxCount
                           , MIString_PartionGoods.ValueData               AS PartionGoods

                           , MILinkObject_Box.ObjectId                     AS BoxId
                           , MILinkObject_Asset.ObjectId                   AS AssetId
                           , MIFloat_PromoMovement.ValueData               AS MovementId_Promo

                           , MovementItem.isErased
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
                              FROM (SELECT DISTINCT tmpMI.MovementId_Promo :: Integer AS MovementId_Promo FROM tmpMI WHERE tmpMI.MovementId_Promo <> 0) AS tmp
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
           -- ������ �� ������
        , tmpMI_Order AS (SELECT MovementItem.ObjectId                         AS GoodsId
                               , SUM (MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)) AS Amount
                               , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                               , COALESCE (MIFloat_Price.ValueData, 0)         AS Price
                               , CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice
                          FROM MovementItem
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                               LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                           ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                          AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                               LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                           ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                          AND MIFloat_Price.DescId = zc_MIFloat_Price()
                               LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                           ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                          AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                          WHERE MovementItem.MovementId = vbMovementId_order
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.isErased   = FALSE
                          GROUP BY MovementItem.ObjectId
                                 , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                 , COALESCE (MIFloat_Price.ValueData, 0)
                                 , CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
                         )
          -- ����� ��� ������� �� ������ - MovementItemId �������
        , tmpMI_Order_find AS (SELECT tmpMI_Order.GoodsId
                                    , tmpMI_Order.Amount
                                    , tmpMI_Order.GoodsKindId
                                    , tmpMI_Order.Price
                                    , tmpMI_Order.CountForPrice
                                    , COALESCE (tmpMI.MovementItemId, 0) AS MovementItemId
                               FROM tmpMI_Order
                                    LEFT JOIN (SELECT MAX (tmpMI.MovementItemId) AS MovementItemId
                                                    , tmpMI.GoodsId
                                                    , tmpMI.GoodsKindId
                                                    , tmpMI.Price
                                               FROM tmpMI
                                               WHERE tmpMI.isErased = FALSE
                                               GROUP BY tmpMI.GoodsId
                                                      , tmpMI.GoodsKindId
                                                      , tmpMI.Price
                                              ) AS tmpMI ON tmpMI.GoodsId     = tmpMI_Order.GoodsId
                                                        AND tmpMI.GoodsKindId = tmpMI_Order.GoodsKindId
                                                        AND tmpMI.Price       = tmpMI_Order.Price
                              )
            -- FULL JOIN ������� �� ������ - MovementItemId �������
          , tmpMI_all AS (SELECT tmpMI.MovementItemId
                               , COALESCE (tmpMI.GoodsId, tmpMI_Order_find.GoodsId) AS GoodsId
                               , tmpMI.Amount            AS Amount
                               , tmpMI_Order_find.Amount AS AmountOrder

                               , tmpMI.AmountPartner
                               , tmpMI.AmountChangePercent
                               , tmpMI.ChangePercentAmount
                               , tmpMI.ChangePercent
                               , tmpMI.HeadCount
                               , tmpMI.BoxCount
                               , tmpMI.PartionGoods
                               , tmpMI.BoxId
                               , tmpMI.AssetId
                               , tmpMI.MovementId_Promo

                               , COALESCE (tmpMI.GoodsKindId, tmpMI_Order_find.GoodsKindId)     AS GoodsKindId
                               , COALESCE (tmpMI.Price, tmpMI_Order_find.Price)                 AS Price
                               , COALESCE (tmpMI.CountForPrice, tmpMI_Order_find.CountForPrice) AS CountForPrice
                               , COALESCE (tmpMI.isErased, FALSE) AS isErased
                          FROM tmpMI
                               FULL JOIN tmpMI_Order_find ON tmpMI_Order_find.MovementItemId = tmpMI.MovementItemId
                         )
       SELECT
             0                          AS Id
           , 0 :: Integer               AS LineNum
           , tmpGoods.GoodsId           AS GoodsId
           , tmpGoods.GoodsCode         AS GoodsCode
           , tmpGoods.GoodsName         AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , CAST (NULL AS TFloat)      AS Amount
           , CAST (NULL AS TFloat)      AS AmountChangePercent
           , CAST (NULL AS TFloat)      AS AmountPartner
           , CAST (NULL AS TFloat)      AS AmountOrder
           , CAST (NULL AS TFloat)      AS ChangePercentAmount
           , CAST (NULL AS TFloat)      AS TotalPercentAmount
           , CASE WHEN tmpPromo.isChangePercent = TRUE THEN vbChangePercent ELSE 0 END :: TFloat AS ChangePercent

           , CASE WHEN tmpPromo.TaxPromo <> 0 AND vbPriceWithVAT = TRUE THEN tmpPromo.PriceWithVAT
                  WHEN tmpPromo.TaxPromo <> 0 THEN tmpPromo.PriceWithOutVAT
                  WHEN vbPriceWithVAT = FALSE THEN tmpPriceList.Price_Pricelist
                  WHEN vbPriceWithVAT = TRUE  THEN tmpPriceList.Price_Pricelist_vat
             END :: TFloat              AS Price
           , CAST (1 AS TFloat)         AS CountForPrice

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
           , FALSE                      AS isCheck_Pricelist

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

       FROM (SELECT Object_Goods.Id                                        AS GoodsId
                  , Object_Goods.ObjectCode                                AS GoodsCode
                  , Object_Goods.ValueData                                 AS GoodsName
                  , COALESCE (tmpGoodsByGoodsKind.GoodsKindId, 0)          AS GoodsKindId
                  -- , COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0)            AS GoodsKindId

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

             WHERE tmpGoodsByGoodsKind.GoodsId > 0 AND Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900(), zc_Enum_InfoMoneyDestination_21000(), zc_Enum_InfoMoneyDestination_21100(), zc_Enum_InfoMoneyDestination_30100(), zc_Enum_InfoMoneyDestination_30200())
            ) AS tmpGoods

            LEFT JOIN tmpMI_all AS tmpMI ON tmpMI.GoodsId     = tmpGoods.GoodsId
                                        AND tmpMI.GoodsKindId = tmpGoods.GoodsKindId
            LEFT JOIN tmpPromo ON tmpPromo.GoodsId      = tmpGoods.GoodsId
                              AND (tmpPromo.GoodsKindId = tmpGoods.GoodsKindId OR tmpPromo.GoodsKindId = 0)
            LEFT JOIN tmpPriceList ON tmpPriceList.GoodsId = tmpGoods.GoodsId

            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpGoods.GoodsKindId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
           
            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

       WHERE tmpMI.GoodsId IS NULL

      UNION ALL
       SELECT
             tmpMI.MovementItemId :: Integer    AS Id
           , CAST (row_number() OVER (ORDER BY tmpMI.MovementItemId) AS Integer) AS LineNum
           , Object_Goods.Id                    AS GoodsId
           , Object_Goods.ObjectCode            AS GoodsCode
           , Object_Goods.ValueData             AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , tmpMI.Amount                       AS Amount

           , tmpMI.AmountChangePercent:: TFloat AS AmountChangePercent
           , tmpMI.AmountPartner      :: TFloat AS AmountPartner
           , tmpMI.AmountOrder        :: TFloat AS AmountOrder
           , tmpMI.ChangePercentAmount:: TFloat AS ChangePercentAmount
           , (tmpMI.Amount - COALESCE (tmpMI.AmountChangePercent, 0)) :: TFloat AS TotalPercentAmount
           , tmpMI.ChangePercent      :: TFloat AS ChangePercent

           , tmpMI.Price              :: TFloat AS Price
           , tmpMI.CountForPrice      :: TFloat AS CountForPrice

           , tmpPriceList.Price_Pricelist     :: TFloat AS Price_Pricelist
           , tmpPriceList.Price_Pricelist_vat :: TFloat AS Price_Pricelist_vat

           , tmpMI.HeadCount          :: TFloat AS HeadCount
           , tmpMI.BoxCount           :: TFloat AS BoxCount

           , tmpMI.PartionGoods
           , Object_GoodsKind.Id                    AS GoodsKindId
           , Object_GoodsKind.ValueData             AS GoodsKindName
           , Object_Measure.ValueData               AS MeasureName

           , Object_Asset.Id                        AS AssetId
           , Object_Asset.ValueData                 AS AssetName

           , Object_Box.Id                          AS BoxId
           , Object_Box.ValueData                   AS BoxName

           , CAST (CASE WHEN tmpMI.CountForPrice > 0
                           THEN CAST ( (COALESCE (tmpMI.AmountPartner, 0)) * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                           ELSE CAST ( (COALESCE (tmpMI.AmountPartner, 0)) * tmpMI.Price AS NUMERIC (16, 2))
                   END AS TFloat)                   AS AmountSumm

           , CASE WHEN tmpPromo.TaxPromo <> 0 AND vbPriceWithVAT = TRUE AND tmpPromo.PriceWithVAT = tmpMI.Price
                       THEN FALSE
                  WHEN tmpPromo.TaxPromo <> 0 AND tmpPromo.PriceWithOutVAT = tmpMI.Price
                       THEN FALSE
                  WHEN (COALESCE (tmpMI.Price, 0) = COALESCE (tmpPriceList.Price_Pricelist, 0)     AND vbPriceWithVAT = FALSE)
                    OR (COALESCE (tmpMI.Price, 0) = COALESCE (tmpPriceList.Price_Pricelist_vat, 0) AND vbPriceWithVAT = TRUE)
                       THEN FALSE
                  ELSE TRUE
             END :: Boolean AS isCheck_Pricelist

           , (CASE WHEN (tmpPromo.isChangePercent = TRUE  AND tmpMI.ChangePercent <> vbChangePercent)
                     OR (tmpPromo.isChangePercent = FALSE AND tmpMI.ChangePercent <> 0)
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

           , tmpMI.isErased                     AS isErased

       FROM tmpMI_all AS tmpMI
            LEFT JOIN tmpMIPromo ON tmpMIPromo.MovementId_Promo = tmpMI.MovementId_Promo
                                AND tmpMIPromo.GoodsId          = tmpMI.GoodsId
                                AND (tmpMIPromo.GoodsKindId     = tmpMI.GoodsKindId
                                  OR tmpMIPromo.GoodsKindId     = 0)
            LEFT JOIN tmpPromo ON tmpPromo.GoodsId      = tmpMI.GoodsId
                              AND (tmpPromo.GoodsKindId = tmpMI.GoodsKindId OR tmpPromo.GoodsKindId = 0)

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN Object AS Object_Box ON Object_Box.Id = tmpMI.BoxId
            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = tmpMI.AssetId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN Movement_Promo_View ON Movement_Promo_View.Id = tmpMI.MovementId_Promo  

            LEFT JOIN tmpPriceList ON tmpPriceList.GoodsId = tmpMI.GoodsId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
           ;

     ELSE

     RETURN QUERY
       WITH -- ����� �� ������� �� ����
            tmpPromo AS (SELECT tmp.*
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
          , tmpMI AS (SELECT MovementItem.Id                               AS MovementItemId
                           , MovementItem.ObjectId                         AS GoodsId
                           , MovementItem.Amount                           AS Amount
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId

                           , MIFloat_AmountPartner.ValueData               AS AmountPartner
                           , MIFloat_AmountChangePercent.ValueData         AS AmountChangePercent
                           , MIFloat_ChangePercentAmount.ValueData         AS ChangePercentAmount
                           , COALESCE (MIFloat_ChangePercent.ValueData, 0) AS ChangePercent

                           , COALESCE (MIFloat_Price.ValueData, 0)         AS Price
                           , CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice

                           , MIFloat_HeadCount.ValueData                   AS HeadCount
                           , MIFloat_BoxCount.ValueData                    AS BoxCount
                           , MIString_PartionGoods.ValueData               AS PartionGoods

                           , MILinkObject_Box.ObjectId                     AS BoxId
                           , MILinkObject_Asset.ObjectId                   AS AssetId
                           , MIFloat_PromoMovement.ValueData               AS MovementId_Promo

                           , MovementItem.isErased
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
                              FROM (SELECT DISTINCT tmpMI.MovementId_Promo :: Integer AS MovementId_Promo FROM tmpMI WHERE tmpMI.MovementId_Promo <> 0) AS tmp
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
          -- ������ �� ������
        , tmpMI_Order AS (SELECT MovementItem.ObjectId                         AS GoodsId
                               , SUM (MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)) AS Amount
                               , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                               , COALESCE (MIFloat_Price.ValueData, 0)         AS Price
                               , CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice
                          FROM (SELECT MovementLinkMovement_Order.MovementChildId AS MovementId
                                FROM MovementLinkMovement AS MovementLinkMovement_Order
                                WHERE MovementLinkMovement_Order.MovementId = inMovementId
                                  AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                               ) AS tmpMovement
                               INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.MovementId
                                                      AND MovementItem.DescId     = zc_MI_Master()
                                                      AND MovementItem.isErased   = FALSE
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                               LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                           ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                          AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                               LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                           ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                          AND MIFloat_Price.DescId = zc_MIFloat_Price()
                               LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                           ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                          AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                          GROUP BY MovementItem.ObjectId
                                 , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                 , COALESCE (MIFloat_Price.ValueData, 0)
                                 , CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
                         )
          -- ����� ��� ������� �� ������ - MovementItemId �������
        , tmpMI_Order_find AS (SELECT tmpMI_Order.GoodsId
                                    , tmpMI_Order.Amount
                                    , tmpMI_Order.GoodsKindId
                                    , tmpMI_Order.Price
                                    , tmpMI_Order.CountForPrice
                                    , COALESCE (tmpMI.MovementItemId, 0) AS MovementItemId
                               FROM tmpMI_Order
                                    LEFT JOIN (SELECT MAX (tmpMI.MovementItemId) AS MovementItemId
                                                    , tmpMI.GoodsId
                                                    , tmpMI.GoodsKindId
                                                    , tmpMI.Price
                                               FROM tmpMI
                                               WHERE tmpMI.isErased = FALSE
                                               GROUP BY tmpMI.GoodsId
                                                      , tmpMI.GoodsKindId
                                                      , tmpMI.Price
                                              ) AS tmpMI ON tmpMI.GoodsId     = tmpMI_Order.GoodsId
                                                        AND tmpMI.GoodsKindId = tmpMI_Order.GoodsKindId
                                                        AND tmpMI.Price       = tmpMI_Order.Price
                              )
            -- FULL JOIN ������� �� ������ - MovementItemId �������
          , tmpMI_all AS (SELECT tmpMI.MovementItemId
                               , COALESCE (tmpMI.GoodsId, tmpMI_Order_find.GoodsId) AS GoodsId
                               , tmpMI.Amount            AS Amount
                               , tmpMI_Order_find.Amount AS AmountOrder

                               , tmpMI.AmountPartner
                               , tmpMI.AmountChangePercent
                               , tmpMI.ChangePercentAmount
                               , tmpMI.ChangePercent
                               , tmpMI.HeadCount
                               , tmpMI.BoxCount
                               , tmpMI.PartionGoods
                               , tmpMI.BoxId
                               , tmpMI.AssetId
                               , tmpMI.MovementId_Promo

                               , COALESCE (tmpMI.GoodsKindId, tmpMI_Order_find.GoodsKindId)     AS GoodsKindId
                               , COALESCE (tmpMI.Price, tmpMI_Order_find.Price)                 AS Price
                               , COALESCE (tmpMI.CountForPrice, tmpMI_Order_find.CountForPrice) AS CountForPrice
                               , COALESCE (tmpMI.isErased, FALSE) AS isErased
                          FROM tmpMI
                               FULL JOIN tmpMI_Order_find ON tmpMI_Order_find.MovementItemId = tmpMI.MovementItemId
                         )
       SELECT
             tmpMI.MovementItemId :: Integer    AS Id
           , CAST (row_number() OVER (ORDER BY tmpMI.MovementItemId) AS Integer) AS LineNum
           , Object_Goods.Id                    AS GoodsId
           , Object_Goods.ObjectCode            AS GoodsCode
           , Object_Goods.ValueData             AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , tmpMI.Amount                       AS Amount

           , tmpMI.AmountChangePercent:: TFloat AS AmountChangePercent
           , tmpMI.AmountPartner      :: TFloat AS AmountPartner
           , tmpMI.AmountOrder        :: TFloat AS AmountOrder
           , tmpMI.ChangePercentAmount:: TFloat AS ChangePercentAmount
           , (tmpMI.Amount - COALESCE (tmpMI.AmountChangePercent, 0)) :: TFloat AS TotalPercentAmount
           , tmpMI.ChangePercent      :: TFloat AS ChangePercent

           , tmpMI.Price              :: TFloat AS Price
           , tmpMI.CountForPrice      :: TFloat AS CountForPrice

           , tmpPriceList.Price_Pricelist     :: TFloat AS Price_Pricelist
           , tmpPriceList.Price_Pricelist_vat :: TFloat AS Price_Pricelist_vat

           , tmpMI.HeadCount          :: TFloat AS HeadCount
           , tmpMI.BoxCount           :: TFloat AS BoxCount

           , tmpMI.PartionGoods
           , Object_GoodsKind.Id                    AS GoodsKindId
           , Object_GoodsKind.ValueData             AS GoodsKindName
           , Object_Measure.ValueData               AS MeasureName

           , Object_Asset.Id                        AS AssetId
           , Object_Asset.ValueData                 AS AssetName

           , Object_Box.Id                          AS BoxId
           , Object_Box.ValueData                   AS BoxName

           , CAST (CASE WHEN tmpMI.CountForPrice > 0
                           THEN CAST ( (COALESCE (tmpMI.AmountPartner, 0)) * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                           ELSE CAST ( (COALESCE (tmpMI.AmountPartner, 0)) * tmpMI.Price AS NUMERIC (16, 2))
                   END AS TFloat)                   AS AmountSumm

           , CASE WHEN tmpPromo.TaxPromo <> 0 AND vbPriceWithVAT = TRUE AND tmpPromo.PriceWithVAT = tmpMI.Price
                       THEN FALSE
                  WHEN tmpPromo.TaxPromo <> 0 AND tmpPromo.PriceWithOutVAT = tmpMI.Price
                       THEN FALSE
                  WHEN (COALESCE (tmpMI.Price, 0) = COALESCE (tmpPriceList.Price_Pricelist, 0)     AND vbPriceWithVAT = FALSE)
                    OR (COALESCE (tmpMI.Price, 0) = COALESCE (tmpPriceList.Price_Pricelist_vat, 0) AND vbPriceWithVAT = TRUE)
                       THEN FALSE
                  ELSE TRUE
             END :: Boolean AS isCheck_Pricelist

           , (CASE WHEN (tmpPromo.isChangePercent = TRUE  AND tmpMI.ChangePercent <> vbChangePercent)
                     OR (tmpPromo.isChangePercent = FALSE AND tmpMI.ChangePercent <> 0)
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

           , tmpMI.isErased                     AS isErased

       FROM tmpMI_all AS tmpMI
            LEFT JOIN tmpMIPromo ON tmpMIPromo.MovementId_Promo = tmpMI.MovementId_Promo
                                AND tmpMIPromo.GoodsId          = tmpMI.GoodsId
                                AND (tmpMIPromo.GoodsKindId     = tmpMI.GoodsKindId
                                  OR tmpMIPromo.GoodsKindId     = 0)
            LEFT JOIN tmpPromo ON tmpPromo.GoodsId      = tmpMI.GoodsId
                              AND (tmpPromo.GoodsKindId = tmpMI.GoodsKindId OR tmpPromo.GoodsKindId = 0)

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN Object AS Object_Box ON Object_Box.Id = tmpMI.BoxId
            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = tmpMI.AssetId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN Movement_Promo_View ON Movement_Promo_View.Id = tmpMI.MovementId_Promo  

            LEFT JOIN tmpPriceList ON tmpPriceList.GoodsId = tmpMI.GoodsId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
           ;

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_Sale_Order (Integer, Integer, TDateTime, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 31.03.15         * add GoodsGroupNameFull 
 22.10.14                                        *
*/

-- ����
-- SELECT * FROM gpSelect_MovementItem_Sale_Order (inMovementId:= 1257078, inPriceListId:= zc_PriceList_Basis(), inOperDate:= CURRENT_TIMESTAMP, inShowAll:= TRUE, inisErased:= TRUE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItem_Sale_Order (inMovementId:= 1257078, inPriceListId:= zc_PriceList_Basis(), inOperDate:= CURRENT_TIMESTAMP, inShowAll:= FALSE, inisErased:= TRUE, inSession:= '2')
