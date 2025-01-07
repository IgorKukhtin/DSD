-- Function: gpSelect_MovementItem_Income()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Income (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_Income (Integer, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_Income (Integer, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Income(
    IN inMovementId       Integer      , -- ключ Документа
    IN inInvoiceId        Integer      ,
    IN inShowAll          Boolean      , --
    IN inIsErased         Boolean      , --
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsName_old TVarChar
             , GoodsGroupNameFull TVarChar, MeasureName TVarChar
             , Amount TFloat, AmountPartner TFloat, AmountPartnerSecond TFloat, AmountPacker TFloat, Amount_unit TFloat, Amount_diff TFloat
             , Price TFloat, PriceNoVAT TFloat, PricePartner TFloat, CountForPrice TFloat, LiveWeight TFloat, HeadCount TFloat
             , PartionGoods TVarChar, PartNumber TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar, AssetId  Integer, AssetName  TVarChar
             , StorageId Integer, StorageName TVarChar
             , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , AmountSumm TFloat
             , AmountRemains TFloat
             , isErased Boolean
             , MIId_Invoice Integer, InvNumber_Invoice TVarChar
             , Amount_parent TFloat, Price_parent TFloat
             , GoodsRealId Integer, GoodsRealCode Integer, GoodsRealName TVarChar
             , GoodsKindRealId Integer, GoodsKindRealName TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbUnitId Integer;
  DECLARE vbPriceListId Integer;
  DECLARE vbJuridicalId_From Integer;

  DECLARE vbVATPercent TFloat;
  DECLARE vbPriceWithVAT Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_Income());
     vbUserId:= lpGetUserBySession (inSession);

     -- определяется
     vbUnitId:= (SELECT MovementLinkObject.ObjectId FROM MovementLinkObject WHERE MovementLinkObject.MovementId = inMovementId AND MovementLinkObject.DescId = zc_MovementLinkObject_To());
     IF vbUnitId IN (SELECT lfSelect_Object_Unit_byGroup.UnitId FROM lfSelect_Object_Unit_byGroup (8433) AS lfSelect_Object_Unit_byGroup) -- Производство
     THEN vbUnitId:= NULL;
     END IF;

     -- определяется - Пав-ны приход
     vbPriceListId:= (SELECT 140208 WHERE EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId IN (80548))); -- Бухгалтер ПАВИЛЬОНЫ

     --определяем пост. из документа
     vbJuridicalId_From := (SELECT ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId_From
                            FROM MovementLinkObject AS MovementLinkObject_From
                                 LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                        ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                       AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                            WHERE MovementLinkObject_From.MovementId = inMovementId
                              AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                           );

     -- параметры из документа
     SELECT COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE) AS PriceWithVAT
          , COALESCE (MovementFloat_VATPercent.ValueData, 0)        AS VATPercent
          
            INTO vbPriceWithVAT, vbVATPercent
     FROM Movement
          LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                    ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                   AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
          LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                  ON MovementFloat_VATPercent.MovementId = Movement.Id
                                 AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
     WHERE Movement.Id = inMovementId;
     
     
     
     -- Результат
     IF inShowAll = TRUE
                AND COALESCE (vbPriceListId, 0) = 0
                AND EXISTS (SELECT 1
                            FROM Object AS Object_GoodsListIncome
                                 INNER JOIN ObjectLink AS ObjectLink_GoodsListIncome_Juridical
                                                       ON ObjectLink_GoodsListIncome_Juridical.ObjectId      = Object_GoodsListIncome.Id
                                                      AND ObjectLink_GoodsListIncome_Juridical.DescId        = zc_ObjectLink_GoodsListIncome_Juridical()
                                                      AND ObjectLink_GoodsListIncome_Juridical.ChildObjectId = vbJuridicalId_From

                                 INNER JOIN ObjectLink AS ObjectLink_GoodsListIncome_Goods
                                                       ON ObjectLink_GoodsListIncome_Goods.ObjectId = Object_GoodsListIncome.Id
                                                      AND ObjectLink_GoodsListIncome_Goods.DescId = zc_ObjectLink_GoodsListIncome_Goods()
                            WHERE Object_GoodsListIncome.DescId   = zc_Object_GoodsListIncome()
                              AND Object_GoodsListIncome.isErased = FALSE
                           )
     THEN

     -- Результат такой
     RETURN QUERY
       WITH tmpRemains AS (SELECT Container.ObjectId                          AS GoodsId
                                , Container.Amount                            AS Amount
                                , COALESCE (CLO_GoodsKind.ObjectId, 0)        AS GoodsKindId
                                , Object_PartionGoods.ValueData               AS PartionGoodsName
                           FROM ContainerLinkObject AS CLO_Unit
                                INNER JOIN Container ON Container.Id = CLO_Unit.ContainerId AND Container.DescId = zc_Container_Count() AND Container.Amount <> 0
                                LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                              ON CLO_GoodsKind.ContainerId = CLO_Unit.ContainerId
                                                             AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                LEFT JOIN ContainerLinkObject AS CLO_Account
                                                              ON CLO_Account.ContainerId = CLO_Unit.ContainerId
                                                             AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                                LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                              ON CLO_PartionGoods.ContainerId = CLO_Unit.ContainerId
                                                             AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                                LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = CLO_PartionGoods.ObjectId
                           WHERE CLO_Unit.ObjectId = vbUnitId
                             AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                             AND CLO_Account.ContainerId IS NULL -- !!!т.е. без счета Транзит!!!
                          )
          , tmpPrice AS (SELECT tmp.GoodsId
                              , tmp.GoodsKindId
                              , tmp.ValuePrice
                         FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceListId, inOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId)) AS tmp)

          , tmpMI AS (SELECT MovementItem.Id
                           , MovementItem.ObjectId AS GoodsId
                           , COALESCE (MILinkObject_Asset.ObjectId, 0)       AS AssetId
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                           , MovementItem.Amount
                           , COALESCE (MIFloat_Price.ValueData, 0)           AS Price
                           , COALESCE (MIFloat_PricePartner.ValueData,0)     AS PricePartner
                           , COALESCE (MIFloat_CountForPrice.ValueData, 1)   AS CountForPrice
                           , MIFloat_Invoice.ValueData :: Integer            AS MIId_Invoice

                       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                   ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                  AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()    
                            LEFT JOIN MovementItemFloat AS MIFloat_PricePartner
                                                        ON MIFloat_PricePartner.MovementItemId = MovementItem.Id
                                                       AND MIFloat_PricePartner.DescId = zc_MIFloat_PricePartner()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                             ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
                            LEFT JOIN MovementItemFloat AS MIFloat_Invoice
                                                        ON MIFloat_Invoice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Invoice.DescId = zc_MIFloat_MovementItemId()
                        /*    LEFT JOIN MovementItem AS MI_Invoice
                                                   ON MI_Invoice.Id = MIFloat_Invoice.ValueData :: Integer
                                                  AND MI_Invoice.isErased = FALSE
                            LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MI_Invoice.MovementId
                            LEFT JOIN MovementDesc AS MovementDesc_Invoice ON MovementDesc_Invoice.Id = Movement_Invoice.DescId
                            LEFT JOIN MovementString AS MovementString_InvNumberPartner_Invoice
                                                     ON MovementString_InvNumberPartner_Invoice.MovementId =  Movement_Invoice.Id
                                                    AND MovementString_InvNumberPartner_Invoice.DescId = zc_MovementString_InvNumberPartner()*/
                      )

   , tmpMI_parent AS (SELECT   MovementItem.Id                                 AS MovementItemId
                             , MovementItem.MovementId                         AS MovementId
                             , COALESCE (MILinkObject_Goods.ObjectId, MILinkObject_NameBefore.ObjectId)    AS GoodsId
                             , COALESCE (MovementItem.ObjectId, 0)             AS MeasureId
                             , COALESCE (MILinkObject_Asset.ObjectId, 0)       AS AssetId
                             , MovementItem.Amount                             AS Amount
                             , COALESCE (MIFloat_Price.ValueData, 0)           AS Price
                             , COALESCE (MIFloat_CountForPrice.ValueData, 1)   AS CountForPrice
                      FROM MovementItem
                                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                              ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                  LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                              ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                             AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_NameBefore
                                                                   ON MILinkObject_NameBefore.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_NameBefore.DescId = zc_MILinkObject_NameBefore()
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                                   ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                                   ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
                      WHERE MovementItem.MovementId = inInvoiceId
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                     )


   , tmpResult AS (SELECT tmpMI.Id                                                         AS Id
                        , COALESCE (tmpMI.GoodsId, tmpMI_parent.GoodsId)                   AS GoodsId
                        , COALESCE (tmpMI.AssetId, tmpMI_parent.AssetId)                   AS AssetId
                        , tmpMI.Amount                                                     AS Amount
                        , COALESCE (tmpMI.Price, tmpMI_parent.Price)                       AS Price  
                        , COALESCE (tmpMI.PricePartner, 0)                                 AS PricePartner
                        , COALESCE (tmpMI.CountForPrice, tmpMI_parent.CountForPrice)       AS CountForPrice
                        , COALESCE (tmpMI.MIId_Invoice, tmpMI_parent.MovementItemId)       AS MIId_Invoice
                        --, COALESCE (tmpMI.MovementId_Invoice, tmpMI_parent.MovementId) AS MovementId_Invoice

                        , tmpMI_parent.GoodsId       AS GoodsId_parent
                        , tmpMI_parent.MeasureId     AS MeasureId_parent
                        , tmpMI_parent.AssetId       AS AssetId_parent
                        , tmpMI_parent.Amount        AS Amount_parent
                        , tmpMI_parent.Price         AS Price_parent
                        , tmpMI_parent.CountForPrice AS CountForPrice_parent
                   FROM tmpMI
                        FULL JOIN tmpMI_parent ON tmpMI_parent.MovementItemId = tmpMI.MIId_Invoice
                   WHERE inShowAll = TRUE
                  UNION ALL
                   SELECT tmpMI.Id                                                         AS Id
                        , COALESCE (tmpMI.GoodsId, tmpMI_parent.GoodsId)                   AS GoodsId
                        , COALESCE (tmpMI.AssetId, tmpMI_parent.AssetId)                   AS AssetId
                        , tmpMI.Amount                                                     AS Amount
                        , COALESCE (tmpMI.Price, tmpMI_parent.Price)                       AS Price  
                        , COALESCE (tmpMI.PricePartner, 0)                                 AS PricePartner
                        , COALESCE (tmpMI.CountForPrice, tmpMI_parent.CountForPrice)       AS CountForPrice
                        , COALESCE (tmpMI.MIId_Invoice, tmpMI_parent.MovementItemId)       AS MIId_Invoice
                        --, COALESCE (tmpMI.MovementId_OrderIncome, tmpMI_parent.MovementId) AS MovementId_OrderIncome

                        , tmpMI_parent.GoodsId       AS GoodsId_parent
                        , tmpMI_parent.MeasureId     AS MeasureId_parent
                        , tmpMI_parent.AssetId       AS AssetId_parent
                        , tmpMI_parent.Amount        AS Amount_parent
                        , tmpMI_parent.Price         AS Price_parent
                        , tmpMI_parent.CountForPrice AS CountForPrice_parent
                   FROM tmpMI
                        LEFT JOIN tmpMI_parent ON tmpMI_parent.MovementItemId = tmpMI.MIId_Invoice
                   WHERE inShowAll = FALSE
                  )

   , tmpGoodsListIncome AS (SELECT DISTINCT ObjectLink_GoodsListIncome_Goods.ChildObjectId AS GoodsId
                            FROM Object AS Object_GoodsListIncome
                                 INNER JOIN ObjectLink AS ObjectLink_GoodsListIncome_Juridical
                                         ON ObjectLink_GoodsListIncome_Juridical.ObjectId = Object_GoodsListIncome.Id
                                        AND ObjectLink_GoodsListIncome_Juridical.DescId = zc_ObjectLink_GoodsListIncome_Juridical()
                                        AND ObjectLink_GoodsListIncome_Juridical.ChildObjectId = vbJuridicalId_From

                                 INNER JOIN ObjectLink AS ObjectLink_GoodsListIncome_Goods
                                         ON ObjectLink_GoodsListIncome_Goods.ObjectId = Object_GoodsListIncome.Id
                                        AND ObjectLink_GoodsListIncome_Goods.DescId = zc_ObjectLink_GoodsListIncome_Goods()
                            WHERE Object_GoodsListIncome.DescId = zc_Object_GoodsListIncome()
                              AND Object_GoodsListIncome.isErased =False
                           )


       SELECT
             0 AS Id
           , tmpGoods.GoodsId
           , tmpGoods.GoodsCode
           , tmpGoods.GoodsName
           , ObjectString_Goods_Scale.ValueData          AS GoodsName_old
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , CAST (NULL AS TFloat) AS Amount
           , CAST (NULL AS TFloat) AS AmountPartner
           , CAST (NULL AS TFloat) AS AmountPartnerSecond
           , CAST (NULL AS TFloat) AS AmountPacker
           , CAST (NULL AS TFloat) AS Amount_unit
           , CAST (NULL AS TFloat) AS Amount_diff

           , COALESCE (tmpPrice_Kind.ValuePrice, tmpPrice.ValuePrice)  ::TFloat AS Price

           -- расчет цены без НДС, до 4 знаков
           , CASE WHEN vbPriceWithVAT = TRUE
                  THEN CAST (COALESCE (tmpPrice_Kind.ValuePrice, tmpPrice.ValuePrice) - COALESCE (tmpPrice_Kind.ValuePrice, tmpPrice.ValuePrice) * (vbVATPercent / (vbVATPercent + 100)) AS NUMERIC (16, 2))
                  ELSE COALESCE (tmpPrice_Kind.ValuePrice, tmpPrice.ValuePrice)
             END    ::TFloat    AS PriceNoVAT

           , 0      :: TFloat   AS PricePartner
           , 1      :: TFloat   AS CountForPrice

           , CAST (NULL AS TFloat) AS LiveWeight
           , CAST (NULL AS TFloat) AS HeadCount

           , COALESCE (tmpRemains.PartionGoodsName,NULL) :: TVarChar AS PartionGoods
           , '' ::TVarChar              AS PartNumber

           , Object_GoodsKind.Id        AS GoodsKindId
           , Object_GoodsKind.ValueData AS GoodsKindName
           , CAST (0 AS Integer)        AS AssetId
           , CAST (NULL AS TVarChar)    AS AssetName
           , CAST (NULL AS Integer)     AS StorageId
           , CAST (NULL AS TVarChar)    AS StorageName

           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName
           , Object_InfoMoney_View.InfoMoneyName_all

           , CAST (NULL AS TFloat) AS AmountSumm

           , tmpRemains.Amount          AS AmountRemains

           , FALSE AS isErased

           , CAST (0 AS Integer)        AS MIId_Invoice
           , CAST (NULL AS TVarChar)    AS InvNumber_Invoice
           , CAST (NULL AS TFloat)      AS Amount_parent
           , CAST (NULL AS TFloat)      AS Price_parent

           , CAST (0 AS Integer)        AS GoodsRealId
           , CAST (0 AS Integer)        AS GoodsRealCode
           , CAST (NULL AS TVarChar)    AS GoodsRealName
           , CAST (0 AS Integer)        AS GoodsKindRealId
           , CAST (NULL AS TVarChar)    AS GoodsKindRealName

       FROM (SELECT Object_Goods.Id                                                   AS GoodsId
                  , Object_Goods.ObjectCode                                           AS GoodsCode
                  , Object_Goods.ValueData                                            AS GoodsName
                  , COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0)            AS GoodsKindId
                  , ObjectLink_Goods_InfoMoney.ChildObjectId                          AS InfoMoneyId
             FROM tmpGoodsListIncome
                  LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoodsListIncome.GoodsId
                  LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                       ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                      AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                  LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyDestination
                                       ON ObjectLink_InfoMoney_InfoMoneyDestination.ObjectId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                      AND ObjectLink_InfoMoney_InfoMoneyDestination.DescId   = zc_ObjectLink_InfoMoney_InfoMoneyDestination()
                  LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsId = Object_Goods.Id
                                                        AND (ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) -- Ирна + Готовая продукция + Доходы Мясное сырье
                                                          -- OR ObjectLink_InfoMoney_InfoMoneyDestination.ChildObjectId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
                                                            )
            -- WHERE Object_Goods.DescId = zc_Object_Goods()
            --   AND Object_Goods.isErased = FALSE
            ) AS tmpGoods

            LEFT JOIN tmpMI ON tmpMI.GoodsId     = tmpGoods.GoodsId
                           AND tmpMI.GoodsKindId = tmpGoods.GoodsKindId

            -- привязываем 2 раза по виду товара и без
            LEFT JOIN tmpPrice ON tmpPrice.GoodsId = tmpGoods.GoodsId
                              AND tmpPrice.GoodsKindId IS NULL
            LEFT JOIN tmpPrice AS tmpPrice_Kind
                               ON tmpPrice_Kind.GoodsId = tmpGoods.GoodsId
                              AND COALESCE (tmpPrice_Kind.GoodsKindId,0) = COALESCE (tmpGoods.GoodsKindId,0)

            LEFT JOIN tmpRemains ON tmpRemains.GoodsId = tmpGoods.GoodsId
                                AND tmpRemains.GoodsKindId = tmpGoods.GoodsKindId
                                AND tmpRemains.Amount <> 0

            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpGoods.GoodsKindId
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = tmpGoods.InfoMoneyId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectString AS ObjectString_Goods_Scale
                                   ON ObjectString_Goods_Scale.ObjectId = tmpGoods.GoodsId
                                  AND ObjectString_Goods_Scale.DescId   = zc_ObjectString_Goods_Scale()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

       WHERE tmpMI.GoodsId IS NULL
         AND (COALESCE (tmpPrice_Kind.ValuePrice, tmpPrice.ValuePrice, 0) <> 0 OR vbPriceListId IS NULL)
         AND COALESCE(inInvoiceId,0) = 0

      UNION ALL
       SELECT
             MovementItem.Id
           , Object_Goods.Id                             AS GoodsId
           , Object_Goods.ObjectCode                     AS GoodsCode
           , Object_Goods.ValueData                      AS GoodsName
           , ObjectString_Goods_Scale.ValueData          AS GoodsName_old
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , MovementItem.Amount
           , MIFloat_AmountPartner.ValueData       AS AmountPartner
           , MIFloat_AmountPartnerSecond.ValueData AS AmountPartnerSecond 
           , MIFloat_AmountPacker.ValueData        AS AmountPacker
           , CAST (MovementItem.Amount + COALESCE (MIFloat_AmountPacker.ValueData, 0) AS TFloat) AS Amount_unit
           , CAST (MovementItem.Amount - COALESCE (MIFloat_AmountPartner.ValueData, 0) AS TFloat) AS Amount_diff

           , tmpMI.Price          ::TFloat

             -- расчет цены без НДС, до 4 знаков
           , (CASE WHEN vbPriceWithVAT = TRUE
                  THEN CAST (tmpMI.Price - tmpMI.Price * (vbVATPercent / (vbVATPercent + 100)) AS NUMERIC (16, 2))
                  ELSE tmpMI.Price
             END  / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END )
             ::TFloat AS PriceNoVAT
   
           , tmpMI.PricePartner   ::TFloat
           , tmpMI.CountForPrice  ::TFloat

           , MIFloat_LiveWeight.ValueData AS LiveWeight
           , MIFloat_HeadCount.ValueData  AS HeadCount

           , COALESCE (MIString_PartionGoods.ValueData, MIString_PartionGoodsCalc.ValueData) :: TVarChar AS PartionGoods
           , MIString_PartNumber.ValueData :: TVarChar AS PartNumber

           , Object_GoodsKind.Id        AS GoodsKindId
           , Object_GoodsKind.ValueData AS GoodsKindName
           , Object_Asset.Id            AS AssetId
           , Object_Asset.ValueData     AS AssetName

           , Object_Storage.Id          AS StorageId
           , Object_Storage.ValueData   AS StorageName

           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName
           , Object_InfoMoney_View.InfoMoneyName_all

           , CAST (CASE WHEN tmpMI.CountForPrice > 0
                           THEN CAST ( (COALESCE (MIFloat_AmountPartner.ValueData, 0) + COALESCE (MIFloat_AmountPacker.ValueData, 0)) * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                        ELSE CAST ( (COALESCE (MIFloat_AmountPartner.ValueData, 0) + COALESCE (MIFloat_AmountPacker.ValueData, 0)) * tmpMI.Price AS NUMERIC (16, 2))
                   END AS TFloat) AS AmountSumm

           , tmpRemains.Amount          AS AmountRemains

           , MovementItem.isErased

           , MI_Invoice.Id              AS MIId_Invoice
           , zfCalc_PartionMovementName (Movement_Invoice.DescId
                                       , MovementDesc_Invoice.ItemName
                                       , COALESCE (MovementString_InvNumberPartner_Invoice.ValueData,'') || '/' || Movement_Invoice.InvNumber
                                       , Movement_Invoice.OperDate) AS InvNumber_Invoice
           , tmpMI.Amount_parent   ::TFloat
           , tmpMI.Price_parent    ::TFloat

           , Object_GoodsReal.Id            AS GoodsRealId
           , Object_GoodsReal.ObjectCode    AS GoodsRealCode
           , Object_GoodsReal.ValueData     AS GoodsRealName
           , Object_GoodsKindReal.Id        AS GoodsKindRealId
           , Object_GoodsKindReal.ValueData AS GoodsKindRealName
       FROM tmpResult AS tmpMI
            LEFT JOIN MovementItem ON MovementItem.Id = tmpMI.Id
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartnerSecond
                                        ON MIFloat_AmountPartnerSecond.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPartnerSecond.DescId = zc_MIFloat_AmountPartnerSecond()

            LEFT JOIN MovementItemFloat AS MIFloat_AmountPacker
                                        ON MIFloat_AmountPacker.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPacker.DescId = zc_MIFloat_AmountPacker()

            LEFT JOIN MovementItemFloat AS MIFloat_LiveWeight
                                        ON MIFloat_LiveWeight.MovementItemId = MovementItem.Id
                                       AND MIFloat_LiveWeight.DescId = zc_MIFloat_LiveWeight()
            LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                        ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                       AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()

            LEFT JOIN MovementItemString AS MIString_PartionGoods
                                         ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                        AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                                        AND MIString_PartionGoods.ValueData <> ''
            LEFT JOIN MovementItemString AS MIString_PartionGoodsCalc
                                         ON MIString_PartionGoodsCalc.MovementItemId = MovementItem.Id
                                        AND MIString_PartionGoodsCalc.DescId = zc_MIString_PartionGoodsCalc()

            LEFT JOIN MovementItemString AS MIString_PartNumber
                                         ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                        AND MIString_PartNumber.DescId = zc_MIString_PartNumber()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Storage
                                             ON MILinkObject_Storage.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Storage.DescId = zc_MILinkObject_Storage()
            LEFT JOIN Object AS Object_Storage ON Object_Storage.Id = MILinkObject_Storage.ObjectId

            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = tmpMI.AssetId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsReal
                                             ON MILinkObject_GoodsReal.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsReal.DescId = zc_MILinkObject_GoodsReal()
            LEFT JOIN Object AS Object_GoodsReal ON Object_GoodsReal.Id = MILinkObject_GoodsReal.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindReal
                                             ON MILinkObject_GoodsKindReal.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKindReal.DescId = zc_MILinkObject_GoodsKindReal()
            LEFT JOIN Object AS Object_GoodsKindReal ON Object_GoodsKindReal.Id = MILinkObject_GoodsKindReal.ObjectId


            -- это док. "Счет"
            LEFT JOIN MovementItem AS MI_Invoice ON MI_Invoice.Id = tmpMI.MIId_Invoice
                                                AND MI_Invoice.isErased = FALSE
            LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MI_Invoice.MovementId
            LEFT JOIN MovementDesc AS MovementDesc_Invoice ON MovementDesc_Invoice.Id = Movement_Invoice.DescId
            LEFT JOIN MovementString AS MovementString_InvNumberPartner_Invoice
                                     ON MovementString_InvNumberPartner_Invoice.MovementId =  Movement_Invoice.Id
                                    AND MovementString_InvNumberPartner_Invoice.DescId = zc_MovementString_InvNumberPartner()
            --
            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMI.GoodsId  --Object_Goods.Id
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId  --Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectString AS ObjectString_Goods_Scale
                                   ON ObjectString_Goods_Scale.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Goods_Scale.DescId   = zc_ObjectString_Goods_Scale()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId  --Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN tmpRemains ON tmpRemains.GoodsId = tmpMI.GoodsId  --MovementItem.ObjectId
                                AND tmpRemains.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                AND COALESCE (tmpRemains.PartionGoodsName,'') = COALESCE (MIString_PartionGoods.ValueData, MIString_PartionGoodsCalc.ValueData,'')


       ;

     ELSEIF inShowAll = TRUE
     THEN
       -- Результат ЕЩЕ
     -- Результат такой
     RETURN QUERY
       WITH tmpRemains AS (SELECT Container.ObjectId                          AS GoodsId
                                , Container.Amount                            AS Amount
                                , COALESCE (CLO_GoodsKind.ObjectId, 0)        AS GoodsKindId
                                , Object_PartionGoods.ValueData               AS PartionGoodsName
                           FROM ContainerLinkObject AS CLO_Unit
                                INNER JOIN Container ON Container.Id = CLO_Unit.ContainerId AND Container.DescId = zc_Container_Count() AND Container.Amount <> 0
                                LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                              ON CLO_GoodsKind.ContainerId = CLO_Unit.ContainerId
                                                             AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                LEFT JOIN ContainerLinkObject AS CLO_Account
                                                              ON CLO_Account.ContainerId = CLO_Unit.ContainerId
                                                             AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                                LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                              ON CLO_PartionGoods.ContainerId = CLO_Unit.ContainerId
                                                             AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                                LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = CLO_PartionGoods.ObjectId
                           WHERE CLO_Unit.ObjectId = vbUnitId
                             AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                             AND CLO_Account.ContainerId IS NULL -- !!!т.е. без счета Транзит!!!
                          )
          , tmpPrice AS (SELECT tmp.GoodsId
                              , tmp.GoodsKindId
                              , tmp.ValuePrice
                         FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceListId, inOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId)) AS tmp)

          , tmpMI AS (SELECT MovementItem.Id
                           , MovementItem.ObjectId AS GoodsId
                           , COALESCE (MILinkObject_Asset.ObjectId, 0)       AS AssetId
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)   AS GoodsKindId
                           , MovementItem.Amount
                           , COALESCE (MIFloat_Price.ValueData, 0)           AS Price
                           , COALESCE (MIFloat_PricePartner.ValueData,0)     AS PricePartner
                           , COALESCE (MIFloat_CountForPrice.ValueData, 1)   AS CountForPrice
                           , MIFloat_Invoice.ValueData :: Integer            AS MIId_Invoice
                           , MIString_PartNumber.ValueData :: TVarChar       AS PartNumber
                       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                   ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                  AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
                            LEFT JOIN MovementItemFloat AS MIFloat_PricePartner
                                                        ON MIFloat_PricePartner.MovementItemId = MovementItem.Id
                                                       AND MIFloat_PricePartner.DescId = zc_MIFloat_PricePartner()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                             ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
                            LEFT JOIN MovementItemFloat AS MIFloat_Invoice
                                                        ON MIFloat_Invoice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Invoice.DescId = zc_MIFloat_MovementItemId()
                        /*    LEFT JOIN MovementItem AS MI_Invoice
                                                   ON MI_Invoice.Id = MIFloat_Invoice.ValueData :: Integer
                                                  AND MI_Invoice.isErased = FALSE
                            LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MI_Invoice.MovementId
                            LEFT JOIN MovementDesc AS MovementDesc_Invoice ON MovementDesc_Invoice.Id = Movement_Invoice.DescId
                            LEFT JOIN MovementString AS MovementString_InvNumberPartner_Invoice
                                                     ON MovementString_InvNumberPartner_Invoice.MovementId =  Movement_Invoice.Id
                                                    AND MovementString_InvNumberPartner_Invoice.DescId = zc_MovementString_InvNumberPartner()*/
                            LEFT JOIN MovementItemString AS MIString_PartNumber
                                                         ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                                        AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                      )

   , tmpMI_parent AS (SELECT   MovementItem.Id                                 AS MovementItemId
                             , MovementItem.MovementId                         AS MovementId
                             , COALESCE (MILinkObject_Goods.ObjectId, MILinkObject_NameBefore.ObjectId)    AS GoodsId
                             , COALESCE (MovementItem.ObjectId, 0)             AS MeasureId
                             , COALESCE (MILinkObject_Asset.ObjectId, 0)       AS AssetId
                             , MovementItem.Amount                             AS Amount
                             , COALESCE (MIFloat_Price.ValueData, 0)           AS Price
                             , COALESCE (MIFloat_CountForPrice.ValueData, 1)   AS CountForPrice
                      FROM MovementItem
                                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                              ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                  LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                              ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                             AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_NameBefore
                                                                   ON MILinkObject_NameBefore.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_NameBefore.DescId = zc_MILinkObject_NameBefore()
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                                   ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                                   ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
                      WHERE MovementItem.MovementId = inInvoiceId
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                     )


   , tmpResult AS (SELECT tmpMI.Id                                                         AS Id
                        , COALESCE (tmpMI.GoodsId, tmpMI_parent.GoodsId)                   AS GoodsId
                        , COALESCE (tmpMI.AssetId, tmpMI_parent.AssetId)                   AS AssetId
                        , tmpMI.Amount                                                     AS Amount
                        , COALESCE (tmpMI.Price, tmpMI_parent.Price)                       AS Price
                        , COALESCE (tmpMI.PricePartner,0)                                  AS PricePartner
                        , COALESCE (tmpMI.CountForPrice, tmpMI_parent.CountForPrice)       AS CountForPrice
                        , COALESCE (tmpMI.MIId_Invoice, tmpMI_parent.MovementItemId)       AS MIId_Invoice
                        --, COALESCE (tmpMI.MovementId_Invoice, tmpMI_parent.MovementId) AS MovementId_Invoice

                        , tmpMI_parent.GoodsId       AS GoodsId_parent
                        , tmpMI_parent.MeasureId     AS MeasureId_parent
                        , tmpMI_parent.AssetId       AS AssetId_parent
                        , tmpMI_parent.Amount        AS Amount_parent
                        , tmpMI_parent.Price         AS Price_parent
                        , tmpMI_parent.CountForPrice AS CountForPrice_parent
                   FROM tmpMI
                        FULL JOIN tmpMI_parent ON tmpMI_parent.MovementItemId = tmpMI.MIId_Invoice
                   WHERE inShowAll = TRUE
                  UNION ALL
                   SELECT tmpMI.Id                                                         AS Id
                        , COALESCE (tmpMI.GoodsId, tmpMI_parent.GoodsId)                   AS GoodsId
                        , COALESCE (tmpMI.AssetId, tmpMI_parent.AssetId)                   AS AssetId
                        , tmpMI.Amount                                                     AS Amount
                        , COALESCE (tmpMI.Price, tmpMI_parent.Price)                       AS Price
                        , COALESCE (tmpMI.PricePartner,0)                                  AS PricePartner
                        , COALESCE (tmpMI.CountForPrice, tmpMI_parent.CountForPrice)       AS CountForPrice
                        , COALESCE (tmpMI.MIId_Invoice, tmpMI_parent.MovementItemId)       AS MIId_Invoice
                        --, COALESCE (tmpMI.MovementId_OrderIncome, tmpMI_parent.MovementId) AS MovementId_OrderIncome

                        , tmpMI_parent.GoodsId       AS GoodsId_parent
                        , tmpMI_parent.MeasureId     AS MeasureId_parent
                        , tmpMI_parent.AssetId       AS AssetId_parent
                        , tmpMI_parent.Amount        AS Amount_parent
                        , tmpMI_parent.Price         AS Price_parent
                        , tmpMI_parent.CountForPrice AS CountForPrice_parent
                   FROM tmpMI
                        LEFT JOIN tmpMI_parent ON tmpMI_parent.MovementItemId = tmpMI.MIId_Invoice
                   WHERE inShowAll = FALSE
                  )





       SELECT
             0 AS Id
           , tmpGoods.GoodsId
           , tmpGoods.GoodsCode
           , tmpGoods.GoodsName
           , ObjectString_Goods_Scale.ValueData          AS GoodsName_old
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , CAST (NULL AS TFloat) AS Amount
           , CAST (NULL AS TFloat) AS AmountPartner
           , CAST (NULL AS TFloat) AS AmountPartnerSecond
           , CAST (NULL AS TFloat) AS AmountPacker
           , CAST (NULL AS TFloat) AS Amount_unit
           , CAST (NULL AS TFloat) AS Amount_diff

           , COALESCE (tmpPrice_Kind.ValuePrice, tmpPrice.ValuePrice)  AS Price   

             -- расчет цены без НДС, до 4 знаков
           , (CASE WHEN vbPriceWithVAT = TRUE
                  THEN CAST (COALESCE (tmpPrice_Kind.ValuePrice, tmpPrice.ValuePrice) - COALESCE (tmpPrice_Kind.ValuePrice, tmpPrice.ValuePrice) * (vbVATPercent / (vbVATPercent + 100)) AS NUMERIC (16, 2))
                  ELSE COALESCE (tmpPrice_Kind.ValuePrice, tmpPrice.ValuePrice)
             END)    ::TFloat    AS PriceNoVAT

           , 0      ::TFloat    AS PricePartner
           , 1      :: TFloat   AS CountForPrice

           , CAST (NULL AS TFloat) AS LiveWeight
           , CAST (NULL AS TFloat) AS HeadCount

           , COALESCE (tmpRemains.PartionGoodsName,NULL) :: TVarChar AS PartionGoods
           , ''  ::TVarChar             AS PartNumber

           , Object_GoodsKind.Id        AS GoodsKindId
           , Object_GoodsKind.ValueData AS GoodsKindName
           , CAST (0 AS Integer)        AS AssetId
           , CAST (NULL AS TVarChar)    AS AssetName
           , CAST (NULL AS Integer)     AS StorageId
           , CAST (NULL AS TVarChar)    AS StorageName

           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName
           , Object_InfoMoney_View.InfoMoneyName_all

           , CAST (NULL AS TFloat) AS AmountSumm

           , tmpRemains.Amount          AS AmountRemains

           , FALSE AS isErased

           , CAST (0 AS Integer)        AS MIId_Invoice
           , CAST (NULL AS TVarChar)    AS InvNumber_Invoice
           , CAST (NULL AS TFloat)      AS Amount_parent
           , CAST (NULL AS TFloat)      AS Price_parent

           , CAST (0 AS Integer)        AS GoodsRealId
           , CAST (0 AS Integer)        AS GoodsRealCode
           , CAST (NULL AS TVarChar)    AS GoodsRealName
           , CAST (0 AS Integer)        AS GoodsKindRealId
           , CAST (NULL AS TVarChar)    AS GoodsKindRealName
       FROM (SELECT Object_Goods.Id                                                   AS GoodsId
                  , Object_Goods.ObjectCode                                           AS GoodsCode
                  , Object_Goods.ValueData                                            AS GoodsName
                  , COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0)            AS GoodsKindId
                  , ObjectLink_Goods_InfoMoney.ChildObjectId                          AS InfoMoneyId
             FROM Object AS Object_Goods
                  LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                       ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                      AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                  LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyDestination
                                       ON ObjectLink_InfoMoney_InfoMoneyDestination.ObjectId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                      AND ObjectLink_InfoMoney_InfoMoneyDestination.DescId   = zc_ObjectLink_InfoMoney_InfoMoneyDestination()
                  LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsId = Object_Goods.Id
                                                        AND (ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) -- Ирна + Готовая продукция + Доходы Мясное сырье
                                                          -- OR ObjectLink_InfoMoney_InfoMoneyDestination.ChildObjectId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
                                                            )
             WHERE Object_Goods.DescId = zc_Object_Goods()
               AND Object_Goods.isErased = FALSE
            ) AS tmpGoods

            LEFT JOIN tmpMI ON tmpMI.GoodsId     = tmpGoods.GoodsId
                           AND tmpMI.GoodsKindId = tmpGoods.GoodsKindId

            -- привязываем 2 раза по виду товара и без
            LEFT JOIN tmpPrice ON tmpPrice.GoodsId = tmpGoods.GoodsId
                              AND tmpPrice.GoodsKindId IS NULL
            LEFT JOIN tmpPrice AS tmpPrice_Kind
                               ON tmpPrice_Kind.GoodsId = tmpGoods.GoodsId
                              AND COALESCE (tmpPrice_Kind.GoodsKindId,0) = COALESCE (tmpGoods.GoodsKindId,0)

            LEFT JOIN tmpRemains ON tmpRemains.GoodsId = tmpGoods.GoodsId
                                AND tmpRemains.GoodsKindId = tmpGoods.GoodsKindId
                                AND tmpRemains.Amount <> 0

            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpGoods.GoodsKindId
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = tmpGoods.InfoMoneyId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectString AS ObjectString_Goods_Scale
                                   ON ObjectString_Goods_Scale.ObjectId = tmpGoods.GoodsId
                                  AND ObjectString_Goods_Scale.DescId   = zc_ObjectString_Goods_Scale()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

       WHERE tmpMI.GoodsId IS NULL
         AND (COALESCE (tmpPrice_Kind.ValuePrice, tmpPrice.ValuePrice, 0) <> 0 OR vbPriceListId IS NULL)
         AND COALESCE(inInvoiceId,0) = 0

      UNION ALL
       SELECT
             MovementItem.Id
           , Object_Goods.Id                             AS GoodsId
           , Object_Goods.ObjectCode                     AS GoodsCode
           , Object_Goods.ValueData                      AS GoodsName
           , ObjectString_Goods_Scale.ValueData          AS GoodsName_old
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , MovementItem.Amount
           , MIFloat_AmountPartner.ValueData   AS AmountPartner
           , MIFloat_AmountPartner.ValueData   AS AmountPartnerSecond
           , MIFloat_AmountPacker.ValueData    AS AmountPacker
           , CAST (MovementItem.Amount + COALESCE (MIFloat_AmountPacker.ValueData, 0) AS TFloat) AS Amount_unit
           , CAST (MovementItem.Amount - COALESCE (MIFloat_AmountPartner.ValueData, 0) AS TFloat) AS Amount_diff

           , tmpMI.Price          ::TFloat 

             -- расчет цены без НДС, до 4 знаков
           , (CASE WHEN vbPriceWithVAT = TRUE
                  THEN CAST (tmpMI.Price - tmpMI.Price * (vbVATPercent / (vbVATPercent + 100)) AS NUMERIC (16, 2))
                  ELSE tmpMI.Price
             END  / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END)
             ::TFloat AS PriceNoVAT

           , tmpMI.PricePartner   ::TFloat
           , tmpMI.CountForPrice  ::TFloat

           , MIFloat_LiveWeight.ValueData AS LiveWeight
           , MIFloat_HeadCount.ValueData  AS HeadCount

           , COALESCE (MIString_PartionGoods.ValueData, MIString_PartionGoodsCalc.ValueData) :: TVarChar AS PartionGoods
           , MIString_PartNumber.ValueData :: TVarChar AS PartNumber

           , Object_GoodsKind.Id        AS GoodsKindId
           , Object_GoodsKind.ValueData AS GoodsKindName
           , Object_Asset.Id            AS AssetId
           , Object_Asset.ValueData     AS AssetName
           , Object_Storage.Id          AS StorageId
           , Object_Storage.ValueData   AS StorageName

           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName
           , Object_InfoMoney_View.InfoMoneyName_all

           , CAST (CASE WHEN tmpMI.CountForPrice > 0
                           THEN CAST ( (COALESCE (MIFloat_AmountPartner.ValueData, 0) + COALESCE (MIFloat_AmountPacker.ValueData, 0)) * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                        ELSE CAST ( (COALESCE (MIFloat_AmountPartner.ValueData, 0) + COALESCE (MIFloat_AmountPacker.ValueData, 0)) * tmpMI.Price AS NUMERIC (16, 2))
                   END AS TFloat) AS AmountSumm

           , tmpRemains.Amount          AS AmountRemains

           , MovementItem.isErased

           , MI_Invoice.Id              AS MIId_Invoice
           , zfCalc_PartionMovementName (Movement_Invoice.DescId, MovementDesc_Invoice.ItemName, COALESCE (MovementString_InvNumberPartner_Invoice.ValueData,'') || '/' || Movement_Invoice.InvNumber, Movement_Invoice.OperDate) AS InvNumber_Invoice
           , tmpMI.Amount_parent   ::TFloat
           , tmpMI.Price_parent    ::TFloat

           , Object_GoodsReal.Id            AS GoodsRealId
           , Object_GoodsReal.ObjectCode    AS GoodsRealCode
           , Object_GoodsReal.ValueData     AS GoodsRealName
           , Object_GoodsKindReal.Id        AS GoodsKindRealId
           , Object_GoodsKindReal.ValueData AS GoodsKindRealName

       FROM tmpResult AS tmpMI
            LEFT JOIN MovementItem ON MovementItem.Id = tmpMI.Id
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartnerSecond
                                        ON MIFloat_AmountPartnerSecond.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPartnerSecond.DescId = zc_MIFloat_AmountPartnerSecond()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountPacker
                                        ON MIFloat_AmountPacker.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPacker.DescId = zc_MIFloat_AmountPacker()

            LEFT JOIN MovementItemFloat AS MIFloat_LiveWeight
                                        ON MIFloat_LiveWeight.MovementItemId = MovementItem.Id
                                       AND MIFloat_LiveWeight.DescId = zc_MIFloat_LiveWeight()
            LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                        ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                       AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()

            LEFT JOIN MovementItemString AS MIString_PartionGoods
                                         ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                        AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                                        AND MIString_PartionGoods.ValueData <> ''
            LEFT JOIN MovementItemString AS MIString_PartionGoodsCalc
                                         ON MIString_PartionGoodsCalc.MovementItemId = MovementItem.Id
                                        AND MIString_PartionGoodsCalc.DescId = zc_MIString_PartionGoodsCalc()
            LEFT JOIN MovementItemString AS MIString_PartNumber
                                         ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                        AND MIString_PartNumber.DescId = zc_MIString_PartNumber()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Storage
                                             ON MILinkObject_Storage.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Storage.DescId = zc_MILinkObject_Storage()
            LEFT JOIN Object AS Object_Storage ON Object_Storage.Id = MILinkObject_Storage.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsReal
                                             ON MILinkObject_GoodsReal.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsReal.DescId = zc_MILinkObject_GoodsReal()
            LEFT JOIN Object AS Object_GoodsReal ON Object_GoodsReal.Id = MILinkObject_GoodsReal.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindReal
                                             ON MILinkObject_GoodsKindReal.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKindReal.DescId = zc_MILinkObject_GoodsKindReal()
            LEFT JOIN Object AS Object_GoodsKindReal ON Object_GoodsKindReal.Id = MILinkObject_GoodsKindReal.ObjectId

            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = tmpMI.AssetId

            -- это док. "Счет"
            LEFT JOIN MovementItem AS MI_Invoice ON MI_Invoice.Id = tmpMI.MIId_Invoice
                                                AND MI_Invoice.isErased = FALSE
            LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MI_Invoice.MovementId
            LEFT JOIN MovementDesc AS MovementDesc_Invoice ON MovementDesc_Invoice.Id = Movement_Invoice.DescId
            LEFT JOIN MovementString AS MovementString_InvNumberPartner_Invoice
                                     ON MovementString_InvNumberPartner_Invoice.MovementId =  Movement_Invoice.Id
                                    AND MovementString_InvNumberPartner_Invoice.DescId = zc_MovementString_InvNumberPartner()
            --
            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMI.GoodsId  --Object_Goods.Id
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId  --Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectString AS ObjectString_Goods_Scale
                                   ON ObjectString_Goods_Scale.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Goods_Scale.DescId   = zc_ObjectString_Goods_Scale()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId  --Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN tmpRemains ON tmpRemains.GoodsId = tmpMI.GoodsId  --MovementItem.ObjectId
                                AND tmpRemains.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                AND COALESCE (tmpRemains.PartionGoodsName,'') = COALESCE (MIString_PartionGoods.ValueData, MIString_PartionGoodsCalc.ValueData,'')

       ;



     ELSE

       -- Результат другой
       RETURN QUERY
       WITH tmpMI_Goods AS (SELECT MovementItem.Id                               AS MovementItemId
                                 , MovementItem.ObjectId                         AS GoodsId
                                 , MovementItem.Amount                           AS Amount
                                 , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                 , COALESCE (MILinkObject_Asset.ObjectId, 0)     AS AssetId
                                 , COALESCE (MILinkObject_Storage.ObjectId,0)    AS StorageId
                                 , COALESCE (MIFloat_AmountPartner.ValueData, 0) AS AmountPartner
                                 , COALESCE (MIFloat_AmountPartnerSecond.ValueData,0)   AS AmountPartnerSecond
                                 , COALESCE (MIFloat_AmountPacker.ValueData, 0)  AS AmountPacker
                                 , COALESCE (MIFloat_Price.ValueData, 0)         AS Price
                                 , COALESCE (MIFloat_PricePartner.ValueData,0)   AS PricePartner
                                 , CASE WHEN MIFloat_CountForPrice.ValueData <> 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice
                                 , COALESCE (MIFloat_LiveWeight.ValueData, 0)    AS LiveWeight
                                 , COALESCE (MIFloat_HeadCount.ValueData, 0)     AS HeadCount
                                 , COALESCE (MIString_PartionGoods.ValueData, MIString_PartionGoodsCalc.ValueData) :: TVarChar AS PartionGoods
                                 , MIString_PartNumber.ValueData     :: TVarChar AS PartNumber
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
                                 LEFT JOIN MovementItemFloat AS MIFloat_AmountPartnerSecond
                                                             ON MIFloat_AmountPartnerSecond.MovementItemId = MovementItem.Id
                                                            AND MIFloat_AmountPartnerSecond.DescId = zc_MIFloat_AmountPartnerSecond()
                                 LEFT JOIN MovementItemFloat AS MIFloat_AmountPacker
                                                             ON MIFloat_AmountPacker.MovementItemId = MovementItem.Id
                                                            AND MIFloat_AmountPacker.DescId = zc_MIFloat_AmountPacker()

                                 LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                             ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                            AND MIFloat_Price.DescId = zc_MIFloat_Price() 
                                 LEFT JOIN MovementItemFloat AS MIFloat_PricePartner
                                                             ON MIFloat_PricePartner.MovementItemId = MovementItem.Id
                                                            AND MIFloat_PricePartner.DescId = zc_MIFloat_PricePartner() 
                                   
                                 LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                             ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                            AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                                 LEFT JOIN MovementItemFloat AS MIFloat_LiveWeight
                                                             ON MIFloat_LiveWeight.MovementItemId = MovementItem.Id
                                                            AND MIFloat_LiveWeight.DescId = zc_MIFloat_LiveWeight()
                                 LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                                             ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                                            AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()

                                 LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                              ON MIString_PartionGoods.MovementItemId =  MovementItem.Id
                                                             AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                                                             AND MIString_PartionGoods.ValueData <> ''
                                 LEFT JOIN MovementItemString AS MIString_PartionGoodsCalc
                                                              ON MIString_PartionGoodsCalc.MovementItemId =  MovementItem.Id
                                                             AND MIString_PartionGoodsCalc.DescId = zc_MIString_PartionGoodsCalc()

                                 LEFT JOIN MovementItemString AS MIString_PartNumber
                                                              ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                                             AND MIString_PartNumber.DescId = zc_MIString_PartNumber()

                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                                  ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Storage
                                                                  ON MILinkObject_Storage.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_Storage.DescId = zc_MILinkObject_Storage()
                          )

          , tmpRemains AS (SELECT tmpMI_Goods.MovementItemId
                                , Container.Amount              AS Amount
                                , Object_PartionGoods.ValueData AS PartionGoodsName
                           FROM tmpMI_Goods
                                INNER JOIN Container ON Container.ObjectId = tmpMI_Goods.GoodsId
                                                    AND Container.DescId = zc_Container_Count()
                                                    AND Container.Amount <> 0
                                INNER JOIN ContainerLinkObject AS CLO_Unit
                                                               ON CLO_Unit.ContainerId = Container.Id
                                                              AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                              AND CLO_Unit.ObjectId = vbUnitId
                                LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                              ON CLO_GoodsKind.ContainerId = Container.Id
                                                             AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                LEFT JOIN ContainerLinkObject AS CLO_Account
                                                              ON CLO_Account.ContainerId = Container.Id
                                                             AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                                LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                              ON CLO_PartionGoods.ContainerId = CLO_Unit.ContainerId
                                                             AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                                LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = CLO_PartionGoods.ObjectId
                           WHERE COALESCE (CLO_GoodsKind.ObjectId, 0) = tmpMI_Goods.GoodsKindId
                             AND CLO_Account.ContainerId IS NULL -- !!!т.е. без счета Транзит!!!
                          )

       SELECT
             tmpMI_Goods.MovementItemId                  AS Id
           , Object_Goods.Id                             AS GoodsId
           , Object_Goods.ObjectCode                     AS GoodsCode
           , Object_Goods.ValueData                      AS GoodsName
           , ObjectString_Goods_Scale.ValueData          AS GoodsName_old
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , tmpMI_Goods.Amount         :: TFloat
           , tmpMI_Goods.AmountPartner  :: TFloat
           , tmpMI_Goods.AmountPartnerSecond :: TFloat
           , tmpMI_Goods.AmountPacker   :: TFloat
           , CAST (tmpMI_Goods.Amount + tmpMI_Goods.AmountPacker AS TFloat) AS Amount_unit
           , CAST (tmpMI_Goods.Amount - tmpMI_Goods.AmountPartner AS TFloat) AS Amount_diff

           , tmpMI_Goods.Price         :: TFloat  

             -- расчет цены без НДС, до 4 знаков
           , (CASE WHEN vbPriceWithVAT = TRUE
                  THEN CAST (tmpMI_Goods.Price - tmpMI_Goods.Price * (vbVATPercent / (vbVATPercent + 100)) AS NUMERIC (16, 2))
                  ELSE tmpMI_Goods.Price
             END  / CASE WHEN tmpMI_Goods.CountForPrice <> 0 THEN tmpMI_Goods.CountForPrice ELSE 1 END)
            ::TFloat AS PriceNoVAT

           , tmpMI_Goods.PricePartner  :: TFloat
           , tmpMI_Goods.CountForPrice :: TFloat AS CountForPrice

           , tmpMI_Goods.LiveWeight  :: TFloat
           , tmpMI_Goods.HeadCount   :: TFloat

           , tmpMI_Goods.PartionGoods
           , tmpMI_Goods.PartNumber ::TVarChar

           , Object_GoodsKind.Id        AS GoodsKindId
           , Object_GoodsKind.ValueData AS GoodsKindName
           , Object_Asset.Id            AS AssetId
           , Object_Asset.ValueData     AS AssetName
           , Object_Storage.Id          AS StorageId
           , Object_Storage.ValueData   AS StorageName

           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName
           , Object_InfoMoney_View.InfoMoneyName_all

           , CAST ((tmpMI_Goods.AmountPartner + tmpMI_Goods.AmountPacker) * tmpMI_Goods.Price / tmpMI_Goods.CountForPrice AS NUMERIC (16, 2)) :: TFloat AS AmountSumm

           , tmpRemains.Amount                  AS AmountRemains

           , tmpMI_Goods.isErased               AS isErased

           , MI_Invoice.Id                      AS MIId_Invoice
           , zfCalc_PartionMovementName (Movement_Invoice.DescId, MovementDesc_Invoice.ItemName, COALESCE (MovementString_InvNumberPartner_Invoice.ValueData,'') || '/' || Movement_Invoice.InvNumber, Movement_Invoice.OperDate) AS InvNumber_Invoice

           , MI_Invoice.Amount                           ::TFloat AS Amount_parent
           , COALESCE(MIFloat_Price_Invoice.ValueData,0) ::TFloat AS Price_parent

           , Object_GoodsReal.Id            AS GoodsRealId
           , Object_GoodsReal.ObjectCode    AS GoodsRealCode
           , Object_GoodsReal.ValueData     AS GoodsRealName
           , Object_GoodsKindReal.Id        AS GoodsKindRealId
           , Object_GoodsKindReal.ValueData AS GoodsKindRealName
       FROM tmpMI_Goods
            LEFT JOIN tmpRemains ON tmpRemains.MovementItemId = tmpMI_Goods.MovementItemId
                                AND COALESCE (tmpRemains.PartionGoodsName,'') = COALESCE (tmpMI_Goods.PartionGoods,'')

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsReal
                                             ON MILinkObject_GoodsReal.MovementItemId = tmpMI_Goods.MovementItemId
                                            AND MILinkObject_GoodsReal.DescId = zc_MILinkObject_GoodsReal()
            LEFT JOIN Object AS Object_GoodsReal ON Object_GoodsReal.Id = MILinkObject_GoodsReal.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindReal
                                             ON MILinkObject_GoodsKindReal.MovementItemId = tmpMI_Goods.MovementItemId
                                            AND MILinkObject_GoodsKindReal.DescId = zc_MILinkObject_GoodsKindReal()
            LEFT JOIN Object AS Object_GoodsKindReal ON Object_GoodsKindReal.Id = MILinkObject_GoodsKindReal.ObjectId
 
            -- это док. "Счет"
            LEFT JOIN MovementItemFloat AS MIFloat_Invoice
                                        ON MIFloat_Invoice.MovementItemId = tmpMI_Goods.MovementItemId
                                       AND MIFloat_Invoice.DescId = zc_MIFloat_MovementItemId()
            LEFT JOIN MovementItem AS MI_Invoice ON MI_Invoice.Id = MIFloat_Invoice.ValueData :: Integer
                                                AND MI_Invoice.isErased = FALSE
            LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MI_Invoice.MovementId
            LEFT JOIN MovementDesc AS MovementDesc_Invoice ON MovementDesc_Invoice.Id = Movement_Invoice.DescId
            LEFT JOIN MovementString AS MovementString_InvNumberPartner_Invoice
                                     ON MovementString_InvNumberPartner_Invoice.MovementId =  Movement_Invoice.Id
                                    AND MovementString_InvNumberPartner_Invoice.DescId = zc_MovementString_InvNumberPartner()
            LEFT JOIN MovementItemFloat AS MIFloat_Price_Invoice
                                        ON MIFloat_Price_Invoice.MovementItemId = MI_Invoice.Id
                                       AND MIFloat_Price_Invoice.DescId = zc_MIFloat_Price()
            --

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI_Goods.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI_Goods.GoodsKindId

            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = tmpMI_Goods.AssetId
            LEFT JOIN Object AS Object_Storage ON Object_Storage.Id = tmpMI_Goods.StorageId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectString AS ObjectString_Goods_Scale
                                   ON ObjectString_Goods_Scale.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_Scale.DescId   = zc_ObjectString_Goods_Scale()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
       ;

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 08.10.24         *
 27.06.23         *
 08.02.22         *
 05.12.19         *
 18.04.17         *
 21.07.16         *
 31.03.15         * add GoodsGroupNameFull, MeasureName
 12.02.14                                        * add Object_InfoMoney_View
 04.10.13                                        * add inIsErased
 07.07.13                                        *
 30.06.13                                        *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_Income (inMovementId:= 25173, inShowAll:= TRUE, inInvoiceId:= 0, inIsErased:= TRUE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItem_Income (inMovementId:= 25173, inShowAll:= FALSE, inInvoiceId:= 0, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItem_Income (inMovementId:= 22151383, inShowAll:= FALSE, inInvoiceId:= 0, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
--select * from gpSelect_MovementItem_Income (inMovementId := 30180935 , inInvoiceId := 0 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '9457');
