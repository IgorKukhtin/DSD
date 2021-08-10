-- Function: gpSelect_MovementItem_ReturnIn()

-- DROP FUNCTION gpSelect_MovementItem_ReturnIn (Integer, Boolean, TVarChar);
 DROP FUNCTION IF EXISTS gpSelect_MovementItem_ReturnIn (Integer, Boolean, TVarChar);
 DROP FUNCTION IF EXISTS gpSelect_MovementItem_ReturnIn (Integer, Boolean, Boolean, TVarChar);
 DROP FUNCTION IF EXISTS gpSelect_MovementItem_ReturnIn (Integer, Integer, Boolean, Boolean, TVarChar);
 DROP FUNCTION IF EXISTS gpSelect_MovementItem_ReturnIn (Integer, Integer, TDateTime, Boolean, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ReturnIn(
    IN inMovementId  Integer      , -- ключ Документа
    IN inPriceListId Integer      , -- ключ Прайс листа
    IN inOperDate    TDateTime    , -- Дата документа
    IN inShowAll     Boolean      , --
    IN inisErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, LineNum Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar             
             , Amount TFloat, AmountPartner TFloat, Amount_find TFloat
             , Price TFloat, CountForPrice TFloat, ChangePercent TFloat, Price_Pricelist TFloat, Price_Pricelist_vat TFloat, isCheck_Pricelist Boolean
             , HeadCount TFloat
             , PartionGoods TVarChar, GoodsKindId Integer, GoodsKindName  TVarChar, MeasureName TVarChar
             , AssetId Integer, AssetName TVarChar
             , AmountSumm TFloat, AmountSummVat TFloat
             , MovementId_Partion Integer, PartionMovementName TVarChar
             , MovementPromo TVarChar, PricePromo TFloat
             , AmountChild TFloat, AmountChildDiff TFloat
             , Value5 Integer, Value10 Integer
             , isErased Boolean
             )
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbMovementId_parent Integer;
  DECLARE vbIsB Boolean;

  DECLARE vbUnitId Integer;
  DECLARE vbPartnerId Integer;
  DECLARE vbContractId Integer;
  DECLARE vbChangePercent TFloat;
  DECLARE vbOperDate_promo TDateTime;

  DECLARE vbPriceWithVAT Boolean;
  DECLARE vbPriceWithVAT_pl Boolean;
  DECLARE vbVATPercent_pl TFloat;
  DECLARE vbVATPercent TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_ReturnIn());
     vbUserId:= lpGetUserBySession (inSession);


     -- Подразделение
     vbUnitId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To());
     -- Контрагент
     vbPartnerId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From());
     -- Договор
     vbContractId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract());
     -- (-)% Скидки (+)% Наценки
     vbChangePercent:= (SELECT MovementFloat.ValueData FROM MovementFloat WHERE MovementFloat.MovementId = inMovementId AND MovementFloat.DescId = zc_MovementFloat_ChangePercent());

     -- Цены с НДС
     vbPriceWithVAT:= (SELECT MB.ValueData FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_PriceWithVAT());
     -- % с НДС
     vbVATPercent:= (SELECT MovementFloat.ValueData FROM MovementFloat WHERE MovementFloat.MovementId = inMovementId AND MovementFloat.DescId = zc_MovementFloat_VATPercent());
     -- Цены с НДС (прайс)
     vbPriceWithVAT_pl:= COALESCE ((SELECT OB.ValueData FROM ObjectBoolean AS OB WHERE OB.ObjectId = inPriceListId AND OB.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT()), FALSE);
     -- Цены (прайс)
     vbVATPercent_pl:= 1 + COALESCE ((SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = inPriceListId AND ObjectFloat.DescId = zc_ObjectFloat_PriceList_VATPercent()), 0) / 100;

     -- определяется
     vbIsB:= EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId IN (300364, 442931, 343951, zc_Enum_Role_Admin())); -- Склад Специй (Баранченко) + Накладные полный доступ СЫРЬЕ - Кисличная Т.А. + Экономист (производство)

     -- Дата для поиска акций - <Дата покупателя>
     vbOperDate_promo:= (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_OperDatePartner());


     -- находим ...
     vbMovementId_parent:= (SELECT COALESCE (Movement.ParentId, 0) FROM Movement WHERE Movement.Id = inMovementId);
     -- меняется параметр
     IF inShowAll = TRUE AND vbMovementId_parent > 0
     THEN
         inShowAll:= FALSE;
     ELSE
         IF inShowAll = TRUE
         THEN
             inShowAll:= inMovementId <> 0; -- AND NOT EXISTS (SELECT MovementId FROM MovementLinkMovement WHERE MovementId = inMovementId AND DescId = zc_MovementLinkMovement_Order() AND MovementChildId <> 0);
         END IF;
     END IF;

     --
     IF inShowAll = TRUE THEN

     -- Результат
     RETURN QUERY
       WITH -- Акции по товарам на дату
            tmpPromo AS (SELECT tmp.*
                         FROM lpSelect_Movement_Promo_Data_all (inOperDate   := vbOperDate_promo
                                                              , inPartnerId  := vbPartnerId
                                                              , inContractId := vbContractId
                                                              , inUnitId     := vbUnitId
                                                              , inIsReturn   := TRUE
                                                               ) AS tmp
                        )
          , tmpMI AS (SELECT MovementItem.Id                               AS MovementItemId
                           , MovementItem.Amount                           AS Amount
                           , MovementItem.ObjectId                         AS GoodsId
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                           , COALESCE (MIFloat_AmountPartner.ValueData, 0) AS AmountPartner
                           , COALESCE (MIFloat_Price.ValueData, 0)         AS Price
                           , MIFloat_CountForPrice.ValueData               AS CountForPrice
                           , COALESCE (MIFloat_ChangePercent.ValueData, 0) AS ChangePercent
                           , MIFloat_PromoMovement.ValueData :: Integer    AS MovementId_Promo
                           , MIFloat_MovementSale.ValueData  :: Integer    AS MovementId_sale
                           , MIString_PartionGoods.ValueData               AS PartionGoods
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
                           LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                       ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()
                           LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                       ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                      AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                           LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                       ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                      AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()

                           LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                        ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                                       AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()

                           LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                                       ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                                      AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
                           -- это партия "продажа покупателю"
                           LEFT JOIN MovementItemFloat AS MIFloat_MovementSale
                                                       ON MIFloat_MovementSale.MovementItemId = MovementItem.Id
                                                      AND MIFloat_MovementSale.DescId = zc_MIFloat_MovementId()
                     )

         , tmpMIPromo_all AS (SELECT tmp.MovementId_Promo                          AS MovementId_Promo
                                   , MovementItem.Id                               AS MovementItemId
                                   , MovementItem.ObjectId                         AS GoodsId
                                   , MovementItem.Amount                           AS TaxPromo
                              FROM (SELECT DISTINCT tmpMI.MovementId_Promo AS MovementId_Promo FROM tmpMI WHERE tmpMI.MovementId_Promo <> 0) AS tmp
                                   INNER JOIN MovementItem ON MovementItem.MovementId = tmp.MovementId_Promo
                                                          AND MovementItem.DescId = zc_MI_Master()
                                                          AND MovementItem.isErased = FALSE
                             )
        , tmpMIPromo_MILO AS (SELECT MILO.*
                              FROM MovementItemLinkObject AS MILO
                              WHERE MILO.MovementItemId IN (SELECT DISTINCT tmpMIPromo_all.MovementItemId FROM tmpMIPromo_all)
                                AND MILO.DescId         = zc_MILinkObject_GoodsKind()
                             )
         , tmpMIPromo_MIF AS (SELECT MIF.*
                              FROM MovementItemFloat AS MIF
                              WHERE MIF.MovementItemId IN (SELECT DISTINCT tmpMIPromo_all.MovementItemId FROM tmpMIPromo_all)
                                AND MIF.DescId         = zc_MIFloat_PriceWithOutVAT()
                             )
             , tmpMIPromo AS (SELECT DISTINCT
                                     tmpMIPromo_all.MovementId_Promo
                                   , tmpMIPromo_all.GoodsId
                                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                   , CASE WHEN /*tmpMIPromo_all.TaxPromo <> 0*/ 1=1 THEN MIFloat_PriceWithOutVAT.ValueData ELSE 0 END AS PricePromo
                              FROM tmpMIPromo_all
                                   LEFT JOIN tmpMIPromo_MILO AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = tmpMIPromo_all.MovementItemId
                                                            AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                   LEFT JOIN tmpMIPromo_MIF AS MIFloat_PriceWithOutVAT
                                                            ON MIFloat_PriceWithOutVAT.MovementItemId = tmpMIPromo_all.MovementItemId
                                                           AND MIFloat_PriceWithOutVAT.DescId         = zc_MIFloat_PriceWithOutVAT()
                             )
   , tmpMI_parent AS (SELECT MovementItem.ObjectId                         AS GoodsId
                           , SUM (MovementItem.Amount)                     AS Amount
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                           , COALESCE (MIFloat_Price.ValueData, 0)         AS Price
                           , COALESCE (MIFloat_ChangePercent.ValueData, 0) AS ChangePercent
                      FROM MovementItem
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                           LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                       ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()
                           LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                       ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                      AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
                      WHERE MovementItem.MovementId = vbMovementId_parent
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                      GROUP BY MovementItem.ObjectId
                             , MILinkObject_GoodsKind.ObjectId
                             , MIFloat_Price.ValueData
                             , MIFloat_ChangePercent.ValueData
                     )
   , tmpMI_parent_find AS (SELECT tmp.MovementItemId
                                , tmpMI_parent.GoodsId
                                , tmpMI_parent.Amount
                                , tmpMI_parent.GoodsKindId
                                , tmpMI_parent.Price
                                , tmpMI_parent.ChangePercent
                           FROM tmpMI_parent
                                LEFT JOIN (SELECT MAX (tmpMI.MovementItemId) AS MovementItemId, tmpMI.GoodsId, tmpMI.GoodsKindId, tmpMI.Price FROM tmpMI WHERE tmpMI.isErased = FALSE GROUP BY tmpMI.GoodsId, tmpMI.GoodsKindId, tmpMI.Price
                                          ) AS tmp ON tmp.GoodsId     = tmpMI_parent.GoodsId
                                                  AND tmp.GoodsKindId = tmpMI_parent.GoodsKindId
                                                  AND tmp.Price       = tmpMI_parent.Price
                          )

   , tmpResult AS (SELECT tmpMI.MovementItemId
                        , COALESCE (tmpMI.GoodsId, tmpMI_parent_find.GoodsId)         AS GoodsId
                        , tmpMI.Amount
                        , tmpMI.AmountPartner
                        , tmpMI_parent_find.Amount AS Amount_find
                        , COALESCE (tmpMI.GoodsKindId, tmpMI_parent_find.GoodsKindId) AS GoodsKindId
                        , COALESCE (tmpMI.Price, tmpMI_parent_find.Price)             AS Price
                        , COALESCE (tmpMI.CountForPrice, 1)                           AS CountForPrice
                        , COALESCE (tmpMI.ChangePercent, tmpMI_parent_find.ChangePercent) AS ChangePercent
                        , COALESCE (tmpMI.MovementId_Promo, 0) :: Integer             AS MovementId_Promo
                        , COALESCE (tmpMI.MovementId_sale, 0)  :: Integer             AS MovementId_sale
                        , tmpMI.PartionGoods                                          AS PartionGoods
                        , COALESCE (tmpMI.isErased, FALSE)                            AS isErased
                   FROM tmpMI
                        FULL JOIN tmpMI_parent_find ON tmpMI_parent_find.MovementItemId = tmpMI.MovementItemId
                  )
     -- Цены из прайса
   , tmpPrice AS (SELECT lfSelect.GoodsId     AS GoodsId
                       , lfSelect.GoodsKindId AS GoodsKindId
                       , CASE WHEN vbPriceWithVAT_pl = FALSE OR vbVATPercent_pl = 0 THEN lfSelect.ValuePrice ELSE lfSelect.ValuePrice / vbVATPercent_pl END AS Price_PriceList
                       , CASE WHEN vbPriceWithVAT_pl = TRUE  OR vbVATPercent_pl = 0 THEN lfSelect.ValuePrice ELSE lfSelect.ValuePrice * vbVATPercent_pl END AS Price_PriceList_vat
                  FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= inPriceListId, inOperDate:= inOperDate) AS lfSelect
                 )
          , tmpGoodsByGoodsKind AS (SELECT Object_GoodsByGoodsKind_View.GoodsId
                                         , COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0) AS GoodsKindId
                                    FROM ObjectBoolean AS ObjectBoolean_Order
                                         LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.Id = ObjectBoolean_Order.ObjectId
                                    WHERE ObjectBoolean_Order.ValueData = TRUE
                                      AND ObjectBoolean_Order.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order()
                                   )
     , tmpGoods1 AS (SELECT Object_Goods.Id           AS GoodsId
                          , Object_Goods.ObjectCode   AS GoodsCode
                          , CASE WHEN ObjectString_Goods_BUH.ValueData <> '' THEN ObjectString_Goods_BUH.ValueData ELSE Object_Goods.ValueData END AS GoodsName
                          , COALESCE (tmpGoodsByGoodsKind.GoodsKindId, 0)          AS GoodsKindId
                     FROM Object_InfoMoney_View
                          JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                          ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                         AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                          JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_InfoMoney.ObjectId
                                                     AND Object_Goods.isErased = FALSE
                        LEFT JOIN ObjectString AS ObjectString_Goods_BUH
                                               ON ObjectString_Goods_BUH.ObjectId = Object_Goods.Id
                                              AND ObjectString_Goods_BUH.DescId = zc_ObjectString_Goods_BUH()
                          LEFT JOIN tmpGoodsByGoodsKind ON tmpGoodsByGoodsKind.GoodsId = Object_Goods.Id
                     -- WHERE (tmpGoodsByGoodsKind.GoodsId > 0 AND Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900(), zc_Enum_InfoMoneyDestination_21000(), zc_Enum_InfoMoneyDestination_21100(), zc_Enum_InfoMoneyDestination_30100(), zc_Enum_InfoMoneyDestination_30200()))
                     --    OR (vbIsB = TRUE AND Object_InfoMoney_View.InfoMoneyDestinationId NOT IN (zc_Enum_InfoMoneyDestination_20900(), zc_Enum_InfoMoneyDestination_21000(), zc_Enum_InfoMoneyDestination_21100(), zc_Enum_InfoMoneyDestination_30100(), zc_Enum_InfoMoneyDestination_30200()))
                    )
      , tmpGoods2 AS (SELECT DISTINCT ObjectLink_GoodsListSale_Goods.ChildObjectId AS GoodsId
                      FROM Object AS Object_GoodsListSale 
                           INNER JOIN ObjectLink AS ObjectLink_GoodsListSale_Partner
                                                 ON ObjectLink_GoodsListSale_Partner.ObjectId = Object_GoodsListSale.Id
                                                AND ObjectLink_GoodsListSale_Partner.DescId = zc_ObjectLink_GoodsListSale_Partner()
                                                AND ObjectLink_GoodsListSale_Partner.ChildObjectId = vbPartnerId
                           LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_Goods
                                                ON ObjectLink_GoodsListSale_Goods.ObjectId = Object_GoodsListSale.Id
                                               AND ObjectLink_GoodsListSale_Goods.DescId = zc_ObjectLink_GoodsListSale_Goods()
                           INNER JOIN Object AS Object_Goods 
                                             ON Object_Goods.Id = ObjectLink_GoodsListSale_Goods.ChildObjectId
                                            AND Object_Goods.isErased = FALSE
                      WHERE Object_GoodsListSale.DescId = zc_Object_GoodsListSale()
                        AND Object_GoodsListSale.isErased = FALSE
                    )
      , tmpGoods AS ( SELECT tmpGoods1.GoodsId
                           , tmpGoods1.GoodsCode
                           , tmpGoods1.GoodsName
                           , tmpGoods1.GoodsKindId
                      FROM tmpGoods1
                           INNER JOIN tmpGoods2 ON tmpGoods2.GoodsId = tmpGoods1.GoodsId
                     )

     , tmpMIChild AS (SELECT MovementItem.ParentId     AS MI_ParentId
                           , MIN (COALESCE (MIFloat_PromoMovement.ValueData, 0)) AS MovementId_promo_min
                           , MAX (COALESCE (MIFloat_PromoMovement.ValueData, 0)) AS MovementId_promo_max
                           , SUM (MovementItem.Amount) AS Amount
                      FROM MovementItem
                           LEFT JOIN MovementItemFloat AS MIFloat_MovementItemId
                                                       ON MIFloat_MovementItemId.MovementItemId = MovementItem.Id
                                                      AND MIFloat_MovementItemId.DescId         = zc_MIFloat_MovementItemId()
                           LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                                       ON MIFloat_PromoMovement.MovementItemId = MIFloat_MovementItemId.ValueData :: Integer
                                                      AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId     = zc_MI_Child()
                        AND MovementItem.isErased   = FALSE
                        AND MovementItem.Amount     <> 0
                      GROUP BY MovementItem.ParentId
                     )

       -- StickerProperty -  кількість діб  + кількість діб - второй срок
     , tmpStickerProperty AS (SELECT ObjectLink_Sticker_Goods.ChildObjectId              AS GoodsId
                                   , ObjectLink_StickerProperty_GoodsKind.ChildObjectId  AS GoodsKindId
                                   , COALESCE (ObjectFloat_Value5.ValueData, 0)          AS Value5
                                   , COALESCE (ObjectFloat_Value10.ValueData, 0)         AS Value10
                                     --  № п/п
                                   , ROW_NUMBER() OVER (PARTITION BY ObjectLink_Sticker_Goods.ChildObjectId, ObjectLink_StickerProperty_GoodsKind.ChildObjectId ORDER BY COALESCE (ObjectFloat_Value5.ValueData, 0) DESC) AS Ord
                              FROM Object AS Object_StickerProperty
                                    LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_Sticker
                                                         ON ObjectLink_StickerProperty_Sticker.ObjectId = Object_StickerProperty.Id
                                                        AND ObjectLink_StickerProperty_Sticker.DescId   = zc_ObjectLink_StickerProperty_Sticker()
                                    LEFT JOIN ObjectLink AS ObjectLink_Sticker_Goods
                                                         ON ObjectLink_Sticker_Goods.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                                        AND ObjectLink_Sticker_Goods.DescId   = zc_ObjectLink_Sticker_Goods()
                                    LEFT JOIN ObjectLink AS ObjectLink_Sticker_Juridical
                                                         ON ObjectLink_Sticker_Juridical.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                                        AND ObjectLink_Sticker_Juridical.DescId   = zc_ObjectLink_StickerProperty_GoodsKind()

                                    LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_GoodsKind
                                                         ON ObjectLink_StickerProperty_GoodsKind.ObjectId = Object_StickerProperty.Id
                                                        AND ObjectLink_StickerProperty_GoodsKind.DescId = zc_ObjectLink_StickerProperty_GoodsKind()
                                    -- кількість діб
                                    LEFT JOIN ObjectFloat AS ObjectFloat_Value5
                                                          ON ObjectFloat_Value5.ObjectId = Object_StickerProperty.Id
                                                         AND ObjectFloat_Value5.DescId = zc_ObjectFloat_StickerProperty_Value5()
                                   -- кількість діб - второй срок
                                   LEFT JOIN ObjectFloat AS ObjectFloat_Value10
                                                         ON ObjectFloat_Value10.ObjectId = Object_StickerProperty.Id 
                                                        AND ObjectFloat_Value10.DescId = zc_ObjectFloat_StickerProperty_Value10()
                              WHERE Object_StickerProperty.DescId   = zc_Object_StickerProperty()
                                AND Object_StickerProperty.isErased = FALSE
                                AND ObjectLink_Sticker_Juridical.ChildObjectId IS NULL -- !!!обязательно БЕЗ Покупателя!!!
                             )


       -- Результат
       SELECT
             0                          AS Id
           , 0 :: Integer               AS LineNum
           , tmpGoods.GoodsId           AS GoodsId
           , tmpGoods.GoodsCode         AS GoodsCode
           , tmpGoods.GoodsName         AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , CAST (NULL AS TFloat)      AS Amount
           , CAST (NULL AS TFloat)      AS AmountPartner
           , CAST (NULL AS TFloat)      AS Amount_find

           , CASE WHEN /*tmpPromo.TaxPromo <> 0 AND*/ tmpPromo.GoodsId > 0 AND vbPriceWithVAT = TRUE THEN tmpPromo.PriceWithVAT
                  WHEN /*tmpPromo.TaxPromo <> 0*/ tmpPromo.GoodsId > 0 AND 1=1 THEN tmpPromo.PriceWithOutVAT
                  WHEN vbPriceWithVAT = FALSE THEN COALESCE (tmpPrice_kind.Price_Pricelist, tmpPrice.Price_Pricelist)
                  WHEN vbPriceWithVAT = TRUE  THEN COALESCE (tmpPrice_kind.Price_Pricelist_vat, tmpPrice.Price_Pricelist_vat)
             END :: TFloat              AS Price
           , CAST (1 AS TFloat)         AS CountForPrice

           , CASE WHEN COALESCE (tmpPromo.isChangePercent, TRUE) = TRUE THEN vbChangePercent ELSE 0 END :: TFloat AS ChangePercent

           , CAST (COALESCE (tmpPrice_kind.Price_Pricelist, tmpPrice.Price_Pricelist) AS TFloat)         AS Price_Pricelist
           , CAST (COALESCE (tmpPrice_kind.Price_Pricelist_vat, tmpPrice.Price_Pricelist_vat) AS TFloat) AS Price_Pricelist_vat

           , FALSE                      AS isCheck_Pricelist

           , CAST (NULL AS TFloat)      AS HeadCount
           , CAST (NULL AS TVarChar)    AS PartionGoods
           , Object_GoodsKind.Id        AS GoodsKindId
           , Object_GoodsKind.ValueData AS GoodsKindName
           , Object_Measure.ValueData   AS MeasureName
           , 0 ::Integer                AS AssetId
           , '' ::TVarChar              AS AssetName
           , CAST (NULL AS TFloat)      AS AmountSumm
           , CAST (NULL AS TFloat)      AS AmountSummVat

           , CAST (0  AS Integer)       AS MovementId_Partion
           , CAST ('' AS TVarChar)  	AS PartionMovementName

           , tmpPromo.MovementPromo
           , CASE WHEN /*tmpPromo.TaxPromo <> 0 AND*/ tmpPromo.GoodsId > 0 AND vbPriceWithVAT = TRUE THEN tmpPromo.PriceWithVAT
                  WHEN /*tmpPromo.TaxPromo <> 0*/ tmpPromo.GoodsId > 0 AND 1=1 THEN tmpPromo.PriceWithOutVAT
                  ELSE 0
             END :: TFloat AS PricePromo

           , 0 :: TFloat AS AmountChild
           , 0 :: TFloat AS AmountChildDiff

           , tmpStickerProperty.Value5  :: Integer AS Value5
           , tmpStickerProperty.Value10 :: Integer AS Value10

           , FALSE                      AS isErased

       FROM tmpGoods
            LEFT JOIN tmpMI ON tmpMI.GoodsId     = tmpGoods.GoodsId
                           AND tmpMI.GoodsKindId = tmpGoods.GoodsKindId

            LEFT JOIN tmpPromo ON tmpPromo.GoodsId      = tmpGoods.GoodsId
                              AND (tmpPromo.GoodsKindId = tmpGoods.GoodsKindId OR tmpPromo.GoodsKindId = 0)
                              AND (tmpPromo.MovementId  = tmpMI.MovementId_Promo OR COALESCE (tmpMI.MovementId_Promo, 0) = 0)
                              

            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpGoods.GoodsKindId
            
            -- привязываем цены 2 раза по виду товара и без 
            LEFT JOIN tmpPrice ON tmpPrice.GoodsId = tmpGoods.GoodsId
                              AND tmpPrice.GoodsKindId IS NULL
            LEFT JOIN tmpPrice AS tmpPrice_kind
                               ON tmpPrice_kind.GoodsId = tmpGoods.GoodsId
                              AND COALESCE (tmpPrice_kind.GoodsKindId,0) = COALESCE (tmpGoods.GoodsKindId,0)

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

             LEFT JOIN tmpStickerProperty ON tmpStickerProperty.GoodsId     = tmpGoods.GoodsId
                                         AND tmpStickerProperty.GoodsKindId = tmpGoods.GoodsKindId
                                         AND tmpStickerProperty.Ord         = 1
       WHERE tmpMI.GoodsId IS NULL

      UNION ALL
       SELECT
             tmpResult.MovementItemId :: Integer AS Id
           , CASE WHEN tmpResult.MovementItemId <> 0 THEN CAST (ROW_NUMBER() OVER (ORDER BY tmpResult.MovementItemId) AS Integer) ELSE 0 END AS LineNum
           , Object_Goods.Id          		AS GoodsId
           , Object_Goods.ObjectCode  		AS GoodsCode
           , Object_Goods.ValueData   		AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , tmpResult.Amount        :: TFloat  AS Amount
           , tmpResult.AmountPartner :: TFloat  AS AmountPartner
           , tmpResult.Amount_find   :: TFloat  AS Amount_find
           , tmpResult.Price         :: TFloat  AS Price
           , tmpResult.CountForPrice :: TFloat  AS CountForPrice
           , tmpResult.ChangePercent :: TFloat  AS ChangePercent

           , COALESCE (tmpPrice_kind.Price_Pricelist, tmpPrice.Price_Pricelist)         :: TFloat AS Price_Pricelist
           , COALESCE (tmpPrice_kind.Price_Pricelist_vat, tmpPrice.Price_Pricelist_vat) :: TFloat AS Price_Pricelist_vat

           , CASE WHEN /*tmpPromo.TaxPromo <> 0 AND*/ tmpPromo.GoodsId > 0 AND vbPriceWithVAT = TRUE AND tmpPromo.PriceWithVAT = tmpResult.Price
                       THEN FALSE
                  WHEN /*tmpPromo.TaxPromo <> 0 AND*/ tmpPromo.GoodsId > 0 AND tmpPromo.PriceWithOutVAT = tmpResult.Price
                       THEN FALSE
                  WHEN (COALESCE (tmpResult.Price, 0) = COALESCE (tmpPrice_kind.Price_Pricelist, tmpPrice.Price_Pricelist, 0) AND vbPriceWithVAT = FALSE)
                    OR (COALESCE (tmpResult.Price, 0) = COALESCE (tmpPrice_kind.Price_Pricelist_vat, tmpPrice.Price_Pricelist_vat, 0) AND vbPriceWithVAT = TRUE)
                       THEN FALSE
                  ELSE TRUE
             END :: Boolean AS isCheck_Pricelist

           , 0  :: TFloat         		AS HeadCount
           , tmpResult.PartionGoods        	AS PartionGoods
           , Object_GoodsKind.Id        	AS GoodsKindId
           , Object_GoodsKind.ValueData 	AS GoodsKindName
           , Object_Measure.ValueData           AS MeasureName
           , 0 :: Integer         		AS AssetId
           , '' :: TVarChar         		AS AssetName
           , CASE WHEN tmpResult.CountForPrice > 0
                       THEN CAST (tmpResult.AmountPartner * tmpResult.Price / tmpResult.CountForPrice AS NUMERIC (16, 2))
                   ELSE CAST (tmpResult.AmountPartner * tmpResult.Price AS NUMERIC (16, 2))
             END :: TFloat 		        AS AmountSumm

           , CASE WHEN tmpResult.CountForPrice > 0
                            THEN CASE WHEN vbPriceWithVAT = TRUE THEN CAST (tmpResult.Price * tmpResult.AmountPartner/tmpResult.CountForPrice AS NUMERIC (16, 2))
                                                                 ELSE CAST ((1 + vbVATPercent / 100) * CAST ((tmpResult.Price * tmpResult.AmountPartner/tmpResult.CountForPrice) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                 END
                            ELSE CASE WHEN vbPriceWithVAT = TRUE THEN CAST (tmpResult.Price * tmpResult.AmountPartner AS NUMERIC (16, 2))
                                                                 ELSE CAST ((1 + vbVATPercent / 100) * CAST ((tmpResult.Price * tmpResult.AmountPartner) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                 END
             END :: TFloat 		        AS AmountSummVat

           , tmpResult.MovementId_sale          AS MovementId_Partion
           , zfCalc_PartionMovementName (Movement_PartionMovement.DescId, MovementDesc_PartionMovement.ItemName, Movement_PartionMovement.InvNumber, MovementDate_OperDatePartner_PartionMovement.ValueData) AS PartionMovementName

           , (CASE WHEN (tmpPromo.isChangePercent = TRUE  AND tmpResult.ChangePercent <> vbChangePercent)
                     OR (tmpPromo.isChangePercent = FALSE AND tmpResult.ChangePercent <> 0)
                        THEN 'ОШИБКА <(-)% Скидки (+)% Наценки>'
                   ELSE ''
              END
           || CASE WHEN COALESCE (tmpResult.MovementId_Promo, 0) <> COALESCE (tmpMIChild.MovementId_promo_min, 0) OR COALESCE (tmpResult.MovementId_Promo, 0) <> COALESCE (tmpMIChild.MovementId_promo_max, 0)
                        THEN 'ОШИБКА : '
                   ELSE ''
              END
           || zfCalc_PromoMovementName (NULL, Movement_Promo_View.InvNumber :: TVarChar, Movement_Promo_View.OperDate, Movement_Promo_View.StartSale, Movement_Promo_View.EndReturn)
             ) :: TVarChar AS MovementPromo

           , CASE WHEN 1 = 1 AND tmpMIPromo.PricePromo <> 0 THEN tmpMIPromo.PricePromo
                  WHEN /*tmpPromo.TaxPromo <> 0 AND*/ tmpPromo.GoodsId > 0 AND vbPriceWithVAT = TRUE THEN tmpPromo.PriceWithVAT
                  WHEN /*tmpPromo.TaxPromo <> 0*/ tmpPromo.GoodsId > 0 AND 1=1 THEN tmpPromo.PriceWithOutVAT
                  ELSE 0
             END :: TFloat AS PricePromo

           , tmpMIChild.Amount       :: TFloat   AS AmountChild
           , (tmpResult.AmountPartner - COALESCE(tmpMIChild.Amount,0)) :: TFloat   AS AmountChildDiff

           , tmpStickerProperty.Value5  :: Integer AS Value5
           , tmpStickerProperty.Value10 :: Integer AS Value10

           , tmpResult.isErased                AS isErased

       FROM tmpResult
            LEFT JOIN tmpMIPromo ON tmpMIPromo.MovementId_Promo = tmpResult.MovementId_Promo                -- акция
                                AND tmpMIPromo.GoodsId          = tmpResult.GoodsId
                                AND (tmpMIPromo.GoodsKindId     = tmpResult.GoodsKindId
                                  OR tmpMIPromo.GoodsKindId     = 0)

            LEFT JOIN tmpPromo ON tmpPromo.GoodsId      = tmpResult.GoodsId
                              AND (tmpPromo.GoodsKindId = tmpResult.GoodsKindId OR tmpPromo.GoodsKindId = 0)
                              AND (tmpPromo.MovementId  = tmpResult.MovementId_Promo OR COALESCE (tmpResult.MovementId_Promo, 0) = 0)

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpResult.GoodsId
                        LEFT JOIN ObjectString AS ObjectString_Goods_BUH
                                               ON ObjectString_Goods_BUH.ObjectId = tmpResult.GoodsId
                                              AND ObjectString_Goods_BUH.DescId = zc_ObjectString_Goods_BUH()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpResult.GoodsKindId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpResult.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            -- привязываем цены 2 раза по виду товара и без 
            LEFT JOIN tmpPrice ON tmpPrice.GoodsId = tmpResult.GoodsId
                              AND tmpPrice.GoodsKindId IS NULL
            LEFT JOIN tmpPrice AS tmpPrice_kind
                               ON tmpPrice_kind.GoodsId = tmpResult.GoodsId
                              AND COALESCE (tmpPrice_kind.GoodsKindId,0) = COALESCE (tmpResult.GoodsKindId,0)

            LEFT JOIN Movement AS Movement_PartionMovement ON Movement_PartionMovement.Id = tmpResult.MovementId_sale
            LEFT JOIN MovementDesc AS MovementDesc_PartionMovement ON MovementDesc_PartionMovement.Id = Movement_PartionMovement.DescId
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner_PartionMovement
                                   ON MovementDate_OperDatePartner_PartionMovement.MovementId =  Movement_PartionMovement.Id
                                  AND MovementDate_OperDatePartner_PartionMovement.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN Movement_Promo_View ON Movement_Promo_View.Id = tmpResult.MovementId_Promo
 
            LEFT JOIN tmpMIChild ON tmpMIChild.MI_ParentId = tmpResult.MovementItemId

            LEFT JOIN tmpStickerProperty ON tmpStickerProperty.GoodsId     = tmpResult.GoodsId
                                        AND tmpStickerProperty.GoodsKindId = tmpResult.GoodsKindId
                                        AND tmpStickerProperty.Ord         = 1
           ;
     ELSE

     RETURN QUERY
       WITH -- Акции по товарам на дату
            tmpPromo AS (SELECT tmp.*
                         FROM lpSelect_Movement_Promo_Data_all (inOperDate   := vbOperDate_promo
                                                              , inPartnerId  := vbPartnerId
                                                              , inContractId := vbContractId
                                                              , inUnitId     := vbUnitId
                                                              , inIsReturn   := TRUE
                                                               ) AS tmp
                        )
          , tmpMI AS (SELECT MovementItem.Id                               AS MovementItemId
                           , MovementItem.Amount                           AS Amount
                           , MovementItem.ObjectId                         AS GoodsId
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                           , COALESCE (MIFloat_AmountPartner.ValueData, 0) AS AmountPartner
                           , COALESCE (MIFloat_Price.ValueData, 0)         AS Price
                           , MIFloat_CountForPrice.ValueData               AS CountForPrice
                           , COALESCE (MIFloat_ChangePercent.ValueData, 0) AS ChangePercent
                           , MIFloat_PromoMovement.ValueData :: Integer    AS MovementId_Promo
                           , MIFloat_MovementSale.ValueData  :: Integer    AS MovementId_sale
                           , MIString_PartionGoods.ValueData               AS PartionGoods
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
                           LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                       ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()
                           LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                       ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                      AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                           LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                       ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                      AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()

                           LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                        ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                                       AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()

                           LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                                       ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                                      AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
                           -- это партия "продажа покупателю"
                           LEFT JOIN MovementItemFloat AS MIFloat_MovementSale
                                                       ON MIFloat_MovementSale.MovementItemId = MovementItem.Id
                                                      AND MIFloat_MovementSale.DescId = zc_MIFloat_MovementId()
                     )

         , tmpMIPromo_all AS (SELECT tmp.MovementId_Promo                          AS MovementId_Promo
                                   , MovementItem.Id                               AS MovementItemId
                                   , MovementItem.ObjectId                         AS GoodsId
                                   , MovementItem.Amount                           AS TaxPromo
                              FROM (SELECT DISTINCT tmpMI.MovementId_Promo AS MovementId_Promo FROM tmpMI WHERE tmpMI.MovementId_Promo <> 0) AS tmp
                                   INNER JOIN MovementItem ON MovementItem.MovementId = tmp.MovementId_Promo
                                                          AND MovementItem.DescId = zc_MI_Master()
                                                          AND MovementItem.isErased = FALSE
                             )
        , tmpMIPromo_MILO AS (SELECT MILO.*
                              FROM MovementItemLinkObject AS MILO
                              WHERE MILO.MovementItemId IN (SELECT DISTINCT tmpMIPromo_all.MovementItemId FROM tmpMIPromo_all)
                                AND MILO.DescId         = zc_MILinkObject_GoodsKind()
                             )
         , tmpMIPromo_MIF AS (SELECT MIF.*
                              FROM MovementItemFloat AS MIF
                              WHERE MIF.MovementItemId IN (SELECT DISTINCT tmpMIPromo_all.MovementItemId FROM tmpMIPromo_all)
                                AND MIF.DescId         = zc_MIFloat_PriceWithOutVAT()
                             )
             , tmpMIPromo AS (SELECT DISTINCT
                                     tmpMIPromo_all.MovementId_Promo
                                   , tmpMIPromo_all.GoodsId
                                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                   , CASE WHEN /*tmpMIPromo_all.TaxPromo <> 0*/ 1=1 THEN MIFloat_PriceWithOutVAT.ValueData ELSE 0 END AS PricePromo
                              FROM tmpMIPromo_all
                                   LEFT JOIN tmpMIPromo_MILO AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = tmpMIPromo_all.MovementItemId
                                                            AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                   LEFT JOIN tmpMIPromo_MIF AS MIFloat_PriceWithOutVAT
                                                            ON MIFloat_PriceWithOutVAT.MovementItemId = tmpMIPromo_all.MovementItemId
                                                           AND MIFloat_PriceWithOutVAT.DescId         = zc_MIFloat_PriceWithOutVAT()
                             )
   , tmpMI_parent AS (SELECT MovementItem.ObjectId                         AS GoodsId
                           , SUM (MovementItem.Amount)                     AS Amount
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                           , COALESCE (MIFloat_Price.ValueData, 0)         AS Price
                           , COALESCE (MIFloat_ChangePercent.ValueData, 0) AS ChangePercent
                      FROM MovementItem
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                           LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                       ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()
                           LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                       ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                      AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
                      WHERE MovementItem.MovementId = vbMovementId_parent
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                      GROUP BY MovementItem.ObjectId
                             , MILinkObject_GoodsKind.ObjectId
                             , MIFloat_Price.ValueData
                             , MIFloat_ChangePercent.ValueData
                     )
   , tmpMI_parent_find AS (SELECT tmp.MovementItemId
                                , tmpMI_parent.GoodsId
                                , tmpMI_parent.Amount
                                , tmpMI_parent.GoodsKindId
                                , tmpMI_parent.Price
                                , tmpMI_parent.ChangePercent
                           FROM tmpMI_parent
                                LEFT JOIN (SELECT MAX (tmpMI.MovementItemId) AS MovementItemId, tmpMI.GoodsId, tmpMI.GoodsKindId, tmpMI.Price FROM tmpMI WHERE tmpMI.isErased = FALSE GROUP BY tmpMI.GoodsId, tmpMI.GoodsKindId, tmpMI.Price
                                          ) AS tmp ON tmp.GoodsId     = tmpMI_parent.GoodsId
                                                  AND tmp.GoodsKindId = tmpMI_parent.GoodsKindId
                                                  AND tmp.Price       = tmpMI_parent.Price
                          )

   , tmpResult AS (SELECT tmpMI.MovementItemId
                        , COALESCE (tmpMI.GoodsId, tmpMI_parent_find.GoodsId)         AS GoodsId
                        , tmpMI.Amount 
                        , tmpMI.AmountPartner
                        , tmpMI_parent_find.Amount AS Amount_find
                        , COALESCE (tmpMI.GoodsKindId, tmpMI_parent_find.GoodsKindId) AS GoodsKindId
                        , COALESCE (tmpMI.Price, tmpMI_parent_find.Price)             AS Price
                        , COALESCE (tmpMI.CountForPrice, 1)                           AS CountForPrice
                        , COALESCE (tmpMI.ChangePercent, tmpMI_parent_find.ChangePercent) AS ChangePercent
                        , COALESCE (tmpMI.MovementId_Promo, 0) :: Integer             AS MovementId_Promo
                        , COALESCE (tmpMI.MovementId_sale, 0)  :: Integer             AS MovementId_sale
                        , tmpMI.PartionGoods                                          AS PartionGoods
                        , COALESCE (tmpMI.isErased, FALSE)                            AS isErased
                   FROM tmpMI
                        FULL JOIN tmpMI_parent_find ON tmpMI_parent_find.MovementItemId = tmpMI.MovementItemId
                  )
     -- Цены из прайса
   , tmpPrice AS (SELECT lfSelect.GoodsId     AS GoodsId
                       , lfSelect.GoodsKindId AS GoodsKindId
                       , CASE WHEN vbPriceWithVAT_pl = FALSE OR vbVATPercent_pl = 0 THEN lfSelect.ValuePrice ELSE lfSelect.ValuePrice / vbVATPercent_pl END AS Price_PriceList
                       , CASE WHEN vbPriceWithVAT_pl = TRUE  OR vbVATPercent_pl = 0 THEN lfSelect.ValuePrice ELSE lfSelect.ValuePrice * vbVATPercent_pl END AS Price_PriceList_vat
                  FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= inPriceListId, inOperDate:= inOperDate) AS lfSelect
                 )
   , tmpMIChild AS (SELECT MovementItem.ParentId     AS MI_ParentId
                         , MIN (COALESCE (MIFloat_PromoMovement.ValueData, 0)) AS MovementId_promo_min
                         , MAX (COALESCE (MIFloat_PromoMovement.ValueData, 0)) AS MovementId_promo_max
                         , SUM (MovementItem.Amount) AS Amount
                    FROM MovementItem
                         LEFT JOIN MovementItemFloat AS MIFloat_MovementItemId
                                                     ON MIFloat_MovementItemId.MovementItemId = MovementItem.Id
                                                    AND MIFloat_MovementItemId.DescId         = zc_MIFloat_MovementItemId()
                         LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                                     ON MIFloat_PromoMovement.MovementItemId = MIFloat_MovementItemId.ValueData :: Integer
                                                    AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.DescId     = zc_MI_Child()
                      AND MovementItem.isErased   = FALSE
                      AND MovementItem.Amount     <> 0
                    GROUP BY MovementItem.ParentId
                   )

       -- StickerProperty -  кількість діб  + кількість діб - второй срок
     , tmpStickerProperty AS (SELECT ObjectLink_Sticker_Goods.ChildObjectId              AS GoodsId
                                   , ObjectLink_StickerProperty_GoodsKind.ChildObjectId  AS GoodsKindId
                                   , COALESCE (ObjectFloat_Value5.ValueData, 0)          AS Value5
                                   , COALESCE (ObjectFloat_Value10.ValueData, 0)         AS Value10
                                     --  № п/п
                                   , ROW_NUMBER() OVER (PARTITION BY ObjectLink_Sticker_Goods.ChildObjectId, ObjectLink_StickerProperty_GoodsKind.ChildObjectId ORDER BY COALESCE (ObjectFloat_Value5.ValueData, 0) DESC) AS Ord
                              FROM Object AS Object_StickerProperty
                                    LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_Sticker
                                                         ON ObjectLink_StickerProperty_Sticker.ObjectId = Object_StickerProperty.Id
                                                        AND ObjectLink_StickerProperty_Sticker.DescId   = zc_ObjectLink_StickerProperty_Sticker()
                                    LEFT JOIN ObjectLink AS ObjectLink_Sticker_Goods
                                                         ON ObjectLink_Sticker_Goods.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                                        AND ObjectLink_Sticker_Goods.DescId   = zc_ObjectLink_Sticker_Goods()
                                    LEFT JOIN ObjectLink AS ObjectLink_Sticker_Juridical
                                                         ON ObjectLink_Sticker_Juridical.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                                        AND ObjectLink_Sticker_Juridical.DescId   = zc_ObjectLink_StickerProperty_GoodsKind()

                                    LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_GoodsKind
                                                         ON ObjectLink_StickerProperty_GoodsKind.ObjectId = Object_StickerProperty.Id
                                                        AND ObjectLink_StickerProperty_GoodsKind.DescId = zc_ObjectLink_StickerProperty_GoodsKind()
                                    -- кількість діб
                                    LEFT JOIN ObjectFloat AS ObjectFloat_Value5
                                                          ON ObjectFloat_Value5.ObjectId = Object_StickerProperty.Id
                                                         AND ObjectFloat_Value5.DescId = zc_ObjectFloat_StickerProperty_Value5()
                                   -- кількість діб - второй срок
                                   LEFT JOIN ObjectFloat AS ObjectFloat_Value10
                                                         ON ObjectFloat_Value10.ObjectId = Object_StickerProperty.Id 
                                                        AND ObjectFloat_Value10.DescId = zc_ObjectFloat_StickerProperty_Value10()
                              WHERE Object_StickerProperty.DescId   = zc_Object_StickerProperty()
                                AND Object_StickerProperty.isErased = FALSE
                                AND ObjectLink_Sticker_Juridical.ChildObjectId IS NULL -- !!!обязательно БЕЗ Покупателя!!!
                             )

     -- по продаже находим налоговую и данные по MIBoolean_Goods_Name_new
     , tmpName_new AS (SELECT DISTINCT
                              MovementItem.ObjectId           AS GoodsId
                            , MILinkObject_GoodsKind.ObjectId AS GoodsKindId
                            , tmp.MovementId_sale
                            , TRUE AS isName_new
                       FROM (SELECT DISTINCT
                                    MLM_Master.MovementChildId AS MovementId_tax
                                  , tmpSale.MovementId_sale
                             FROM (SELECT DISTINCT tmpResult.MovementId_sale
                                   FROM tmpResult) AS tmpSale
                                  INNER MovementLinkMovement AS MLM_Master 
                                                             ON MLM_Master.MovementId = tmpSale.MovementId_sale
                                                            AND MLM_Master.DescId = zc_MovementLinkMovement_Master()
                                  INNER JOIN Movement ON Movement.Id = MLM_Master.MovementId
                                                     AND Movement.StatusId = zc_Enum_Status_Complete()
                             ) AS tmp
                            INNER JOIN MovementItem ON MovementItem.MovementId = tmp.MovementId_tax
                                                   AND MovementItem.DescId     = zc_MI_Child()
                                                   AND MovementItem.isErased   = FALSE
                            INNER JOIN MovementItemBoolean AS MIBoolean_Goods_Name_new
                                                           ON MIBoolean_Goods_Name_new.MovementItemId = MovementItem.Id
                                                          AND MIBoolean_Goods_Name_new.DescId = zc_MIBoolean_Goods_Name_new()
                                                          AND COALESCE (MIBoolean_Goods_Name_new.ValueData, FALSE) = TRUE
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                       )


       SELECT
             tmpResult.MovementItemId :: Integer AS Id
           , CASE WHEN tmpResult.MovementItemId <> 0 THEN CAST (ROW_NUMBER() OVER (ORDER BY tmpResult.MovementItemId) AS Integer) ELSE 0 END AS LineNum
           , Object_Goods.Id          		AS GoodsId
           , Object_Goods.ObjectCode  		AS GoodsCode
           
           --, CASE WHEN ObjectString_Goods_BUH.ValueData <> '' THEN ObjectString_Goods_BUH.ValueData ELSE Object_Goods.ValueData END :: TVarChar AS GoodsName
           , CASE WHEN COALESCE (tmpName_new.isName_new, FALSE) = TRUE THEN Object_Goods.ValueData
                  WHEN ObjectString_Goods_BUH.ValueData <> '' THEN ObjectString_Goods_BUH.ValueData ELSE Object_Goods.ValueData
             END :: TVarChar AS GoodsName

           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , tmpResult.Amount        :: TFloat  AS Amount
           , tmpResult.AmountPartner :: TFloat  AS AmountPartner
           , tmpResult.Amount_find   :: TFloat  AS Amount_find
           
           , tmpResult.Price         :: TFloat  AS Price
           , tmpResult.CountForPrice :: TFloat  AS CountForPrice
           , tmpResult.ChangePercent :: TFloat  AS ChangePercent

           , COALESCE (tmpPrice_kind.Price_Pricelist, tmpPrice.Price_Pricelist)         :: TFloat AS Price_Pricelist
           , COALESCE (tmpPrice_kind.Price_Pricelist_vat, tmpPrice.Price_Pricelist_vat) :: TFloat AS Price_Pricelist_vat

           , CASE WHEN /*tmpPromo.TaxPromo <> 0 AND*/ tmpPromo.GoodsId > 0 AND vbPriceWithVAT = TRUE AND tmpPromo.PriceWithVAT = tmpResult.Price
                       THEN FALSE
                  WHEN /*tmpPromo.TaxPromo <> 0 AND*/ tmpPromo.GoodsId > 0 AND tmpPromo.PriceWithOutVAT = tmpResult.Price
                       THEN FALSE
                  WHEN (COALESCE (tmpResult.Price, 0) = COALESCE (tmpPrice_kind.Price_Pricelist, tmpPrice.Price_Pricelist, 0)     AND vbPriceWithVAT = FALSE)
                    OR (COALESCE (tmpResult.Price, 0) = COALESCE (tmpPrice_kind.Price_Pricelist_vat, tmpPrice.Price_Pricelist_vat, 0) AND vbPriceWithVAT = TRUE)
                       THEN FALSE
                  ELSE TRUE
             END :: Boolean AS isCheck_Pricelist

           , 0  :: TFloat         		AS HeadCount
           , tmpResult.PartionGoods        	AS PartionGoods
           , Object_GoodsKind.Id        	AS GoodsKindId
           , Object_GoodsKind.ValueData 	AS GoodsKindName
           , Object_Measure.ValueData           AS MeasureName
           , 0 :: Integer         		AS AssetId
           , '' :: TVarChar         		AS AssetName
           , CASE WHEN tmpResult.CountForPrice > 0
                       THEN CAST (tmpResult.AmountPartner * tmpResult.Price / tmpResult.CountForPrice AS NUMERIC (16, 2))
                   ELSE CAST (tmpResult.AmountPartner * tmpResult.Price AS NUMERIC (16, 2))
             END :: TFloat 		        AS AmountSumm

           , CASE WHEN tmpResult.CountForPrice > 0
                            THEN CASE WHEN vbPriceWithVAT = TRUE THEN CAST (tmpResult.Price * tmpResult.AmountPartner/tmpResult.CountForPrice AS NUMERIC (16, 2))
                                                                 ELSE CAST ((1 + vbVATPercent / 100) * CAST ((tmpResult.Price * tmpResult.AmountPartner/tmpResult.CountForPrice) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                 END
                            ELSE CASE WHEN vbPriceWithVAT = TRUE THEN CAST (tmpResult.Price * tmpResult.AmountPartner AS NUMERIC (16, 2))
                                                                 ELSE CAST ((1 + vbVATPercent / 100) * CAST ((tmpResult.Price * tmpResult.AmountPartner) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                 END
             END :: TFloat 		        AS AmountSummVat

           , tmpResult.MovementId_sale          AS MovementId_Partion
           , zfCalc_PartionMovementName (Movement_PartionMovement.DescId, MovementDesc_PartionMovement.ItemName, Movement_PartionMovement.InvNumber, MovementDate_OperDatePartner_PartionMovement.ValueData) AS PartionMovementName

           , (CASE WHEN (tmpPromo.isChangePercent = TRUE  AND tmpResult.ChangePercent <> vbChangePercent)
                     OR (tmpPromo.isChangePercent = FALSE AND tmpResult.ChangePercent <> 0)
                        THEN 'ОШИБКА <(-)% Скидки (+)% Наценки>'
                   ELSE ''
              END
           || CASE WHEN COALESCE (tmpResult.MovementId_Promo, 0) <> COALESCE (tmpMIChild.MovementId_promo_min, 0) OR COALESCE (tmpResult.MovementId_Promo, 0) <> COALESCE (tmpMIChild.MovementId_promo_max, 0)
                        THEN 'ОШИБКА : '
                   ELSE ''
              END
           || zfCalc_PromoMovementName (NULL, Movement_Promo_View.InvNumber :: TVarChar, Movement_Promo_View.OperDate, Movement_Promo_View.StartSale, Movement_Promo_View.EndReturn)
             ) :: TVarChar AS MovementPromo
           , CASE WHEN 1 = 1 AND tmpMIPromo.PricePromo <> 0 THEN tmpMIPromo.PricePromo
                  WHEN /*tmpPromo.TaxPromo <> 0 AND*/ tmpPromo.GoodsId > 0 AND vbPriceWithVAT = TRUE THEN tmpPromo.PriceWithVAT
                  WHEN /*tmpPromo.TaxPromo <> 0*/ tmpPromo.GoodsId > 0 AND 1=1 THEN tmpPromo.PriceWithOutVAT
                  ELSE 0
             END :: TFloat AS PricePromo

           , tmpMIChild.Amount       :: TFloat   AS AmountChild
           , (tmpResult.AmountPartner - COALESCE(tmpMIChild.Amount,0)) :: TFloat   AS AmountChildDiff

           , tmpStickerProperty.Value5  :: Integer AS Value5
           , tmpStickerProperty.Value10 :: Integer AS Value10

           , tmpResult.isErased                AS isErased

       FROM tmpResult
            LEFT JOIN tmpMIPromo ON tmpMIPromo.MovementId_Promo = tmpResult.MovementId_Promo                -- акция
                                AND tmpMIPromo.GoodsId          = tmpResult.GoodsId
                                AND (tmpMIPromo.GoodsKindId     = tmpResult.GoodsKindId
                                  OR tmpMIPromo.GoodsKindId     = 0)
            LEFT JOIN tmpPromo ON tmpPromo.GoodsId      = tmpResult.GoodsId
                              AND (tmpPromo.GoodsKindId = tmpResult.GoodsKindId OR tmpPromo.GoodsKindId = 0)
                              AND 1 = 0 -- !!!отключил!!!

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpResult.GoodsId
                        LEFT JOIN ObjectString AS ObjectString_Goods_BUH
                                               ON ObjectString_Goods_BUH.ObjectId = tmpResult.GoodsId
                                              AND ObjectString_Goods_BUH.DescId = zc_ObjectString_Goods_BUH()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpResult.GoodsKindId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpResult.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            -- привязываем цены 2 раза по виду товара и без 
            LEFT JOIN tmpPrice ON tmpPrice.GoodsId = tmpResult.GoodsId
                              AND tmpPrice.GoodsKindId IS NULL
            LEFT JOIN tmpPrice AS tmpPrice_kind
                               ON tmpPrice_kind.GoodsId = tmpResult.GoodsId
                              AND COALESCE (tmpPrice_kind.GoodsKindId,0) = COALESCE (tmpResult.GoodsKindId,0)

            LEFT JOIN Movement AS Movement_PartionMovement ON Movement_PartionMovement.Id = tmpResult.MovementId_sale
            LEFT JOIN MovementDesc AS MovementDesc_PartionMovement ON MovementDesc_PartionMovement.Id = Movement_PartionMovement.DescId
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner_PartionMovement
                                   ON MovementDate_OperDatePartner_PartionMovement.MovementId =  Movement_PartionMovement.Id
                                  AND MovementDate_OperDatePartner_PartionMovement.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN Movement_Promo_View ON Movement_Promo_View.Id = tmpResult.MovementId_Promo

            LEFT JOIN tmpMIChild ON tmpMIChild.MI_ParentId = tmpResult.MovementItemId

            LEFT JOIN tmpStickerProperty ON tmpStickerProperty.GoodsId     = tmpResult.GoodsId
                                        AND tmpStickerProperty.GoodsKindId = tmpResult.GoodsKindId
                                        AND tmpStickerProperty.Ord         = 1
            LEFT JOIN tmpName_new ON tmpName_new.GoodsId = tmpResult.GoodsId
                                 AND COALESCE (tmpName_new.GoodsKindId,0) = COALESCE (tmpResult.GoodsKindId,0)
                                 AND tmpName_new.MovementId_sale = tmpResult.MovementId_sale
           ;

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_ReturnIn (Integer, Integer, TDateTime, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 06.12.19         *
 10.10.16         * add tmpGoods из GoodsListSale
 05.02.16         * 
 31.03.15         * add GoodsGroupNameFull
 14.04.14                                                        * inOperDate
 08.04.14                                        * add zc_Enum_InfoMoneyDestination_30100
 12.02.14                                                       * inPriceListId
 30.01.14							* add inisErased
 18.07.13         * add Object_Asset
 17.07.13         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_ReturnIn (inMovementId:= 25173, inPriceListId:=18840, inOperDate:= CURRENT_TIMESTAMP, inShowAll:= FALSE, inisErased:= FALSE, inSession:= '2')
