-- Function: gpSelect_MovementItem_OrderExternalUnit()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderExternalUnit (Integer, Integer, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_OrderExternalUnit(
    IN inMovementId  Integer      , -- ключ Документа
    IN inPriceListId Integer      , -- ключ Прайс листа
    IN inOperDate    TDateTime    , -- Дата документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar
             , Amount TFloat, AmountSecond TFloat
             , AmountRemains TFloat, AmountPartner TFloat, AmountForecast TFloat, AmountForecastOrder TFloat
             , AmountCalc TFloat, AmountCalcOrder TFloat
             , GoodsKindId Integer, GoodsKindName  TVarChar, MeasureName TVarChar
             , Price TFloat, CountForPrice TFloat, AmountSumm TFloat, AmountSumm_Partner TFloat
             , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar
             , ArticleGLN TVarChar
             , isErased Boolean
             , StartBegin TDateTime, EndBegin TDateTime, diffBegin_sec TFloat
             , Amount_child TFloat
             , AmountSecond_child TFloat
             , AmountDiff_child TFloat
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbGoodsPropertyId Integer;
  DECLARE vbIsOrderDnepr Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_MI_OrderExternal());
     vbUserId:= lpGetUserBySession (inSession);


     -- меняется параметр
     IF COALESCE (inPriceListId, 0) = 0 THEN inPriceListId := zc_PriceList_Basis(); END IF;

     -- определяется
     vbIsOrderDnepr:= EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId IN (402720, zc_Enum_Role_Admin())); -- Заявки-Днепр
     -- определяется
     vbGoodsPropertyId:= zfCalc_GoodsPropertyId (0, (SELECT ObjectLink_Partner_Juridical.ChildObjectId FROM MovementLinkObject LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject.ObjectId AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical() WHERE MovementLinkObject.MovementId = inMovementId AND MovementLinkObject.DescId = zc_MovementLinkObject_Partner())
                                                  , (SELECT MovementLinkObject.ObjectId FROM MovementLinkObject WHERE MovementLinkObject.MovementId = inMovementId AND MovementLinkObject.DescId = zc_MovementLinkObject_Partner())
                                                );


     IF inShowAll THEN

     RETURN QUERY
       WITH tmpGoodsPropertyValue AS (SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
                                           , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                                           , ObjectString_ArticleGLN.ValueData                                   AS ArticleGLN
                                      FROM (SELECT vbGoodsPropertyId AS GoodsPropertyId WHERE vbGoodsPropertyId <> 0
                                           ) AS tmpGoodsProperty
                                           INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                                 ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                                                AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                           LEFT JOIN ObjectString AS ObjectString_ArticleGLN
                                                                  ON ObjectString_ArticleGLN.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                 AND ObjectString_ArticleGLN.DescId = zc_ObjectString_GoodsPropertyValue_ArticleGLN()
                                           LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                                ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                               AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                           LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                                ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                               AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                                      WHERE ObjectString_ArticleGLN.ValueData <> ''
                                     )
          , tmpGoodsByGoodsKind AS (SELECT Object_GoodsByGoodsKind_View.GoodsId
                                         , COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0) AS GoodsKindId
                                    FROM ObjectBoolean AS ObjectBoolean_Order
                                         LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.Id = ObjectBoolean_Order.ObjectId
                                    WHERE ObjectBoolean_Order.ValueData = TRUE
                                      AND ObjectBoolean_Order.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order()
                                      -- AND vbIsOrderDnepr = TRUE
                                   )

            -- Цены из прайса
          , tmpPriceList AS (SELECT lfSelect.GoodsId     AS GoodsId
                                  , lfSelect.GoodsKindId AS GoodsKindId
                                  , lfSelect.ValuePrice  AS Price_PriceList
                             FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= inPriceListId, inOperDate:= inOperDate) AS lfSelect
                             )

          , tmpMI_Child AS (SELECT MovementItem.ParentId
                                 , SUM (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) = 0 THEN MovementItem.Amount ELSE 0 END) AS Amount
                                 , SUM (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) > 0 THEN MovementItem.Amount ELSE 0 END) AS AmountSecond
                                 , SUM (MovementItem.Amount) AS Amount_diff
                            FROM MovementItem
                                 LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                             ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                            AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
                            WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId     = zc_MI_Child()
                              AND MovementItem.isErased   = FALSE
                            GROUP BY MovementItem.ParentId
                            )


       SELECT
             0                          AS Id
           , tmpGoods.GoodsId           AS GoodsId
           , tmpGoods.GoodsCode         AS GoodsCode
           , tmpGoods.GoodsName         AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , CAST (NULL AS TFloat)      AS Amount
           , CAST (NULL AS TFloat)      AS AmountSecond
           
           , CAST (NULL AS TFloat)      AS AmountRemains
           , CAST (NULL AS TFloat)      AS AmountPartner 
           , CAST (NULL AS TFloat)      AS AmountForecast
           , CAST (NULL AS TFloat)      AS AmountForecastOrder
           , CAST (NULL AS TFloat)      AS AmountCalc
           , CAST (NULL AS TFloat)      AS AmountCalcOrder
           
           , Object_GoodsKind.Id        AS GoodsKindId
           , Object_GoodsKind.ValueData AS GoodsKindName
           , Object_Measure.ValueData   AS MeasureName
           
           , CAST (COALESCE (tmpPriceList_Kind.Price_Pricelist, tmpPriceList.Price_Pricelist) AS TFloat) AS Price
           
           , CAST (1 AS TFloat)         AS CountForPrice 
           , CAST (NULL AS TFloat)      AS AmountSumm
           , CAST (NULL AS TFloat)      AS AmountSumm_Partner

           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName

           , tmpGoodsPropertyValue.ArticleGLN
           , FALSE                      AS isErased

           , NULL                 :: TDateTime  AS StartBegin
           , NULL                 :: TDateTime  AS EndBegin
           , 0                    :: TFloat     AS diffBegin_sec

           , 0                    ::TFloat AS Amount_child
           , 0                    ::TFloat AS AmountSecond_child
           , 0                    ::TFloat AS AmountDiff_child
           
       FROM (SELECT Object_Goods.Id                                                   AS GoodsId
                  , Object_Goods.ObjectCode                                           AS GoodsCode
                  , Object_Goods.ValueData                                            AS GoodsName
                  , CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) THEN COALESCE (tmpGoodsByGoodsKind.GoodsKindId, zc_Enum_GoodsKind_Main()) ELSE 0 END AS GoodsKindId -- Ирна + Готовая продукция + Доходы Мясное сырье
                  -- , COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0) AS GoodsKindId
             FROM Object_InfoMoney_View
                  JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                  ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                 AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                  JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_InfoMoney.ObjectId
                                             AND Object_Goods.isErased = FALSE
                  LEFT JOIN tmpGoodsByGoodsKind ON tmpGoodsByGoodsKind.GoodsId = Object_Goods.Id
             WHERE Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900(), zc_Enum_InfoMoneyDestination_21000(), zc_Enum_InfoMoneyDestination_30100(), zc_Enum_InfoMoneyDestination_30200()) -- Общефирменные + Ирна + Чапли + Доходы + Продукция + Мясное сырье
               AND tmpGoodsByGoodsKind.GoodsId > 0 
            ) AS tmpGoods
            LEFT JOIN (SELECT MovementItem.ObjectId                         AS GoodsId
                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                      ) AS tmpMI ON tmpMI.GoodsId     = tmpGoods.GoodsId
                                AND tmpMI.GoodsKindId = tmpGoods.GoodsKindId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpGoods.GoodsKindId

            -- привязываем 2 раза по виду товара и без
            LEFT JOIN tmpPriceList AS tmpPriceList_Kind 
                                   ON tmpPriceList_Kind.GoodsId = tmpGoods.GoodsId
                                  AND COALESCE (tmpPriceList_Kind.GoodsKindId,0) = COALESCE (tmpGoods.GoodsKindId,0)

            LEFT JOIN tmpPriceList ON tmpPriceList.GoodsId = tmpGoods.GoodsId
                                  AND tmpPriceList.GoodsKindId IS NULL

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = tmpGoods.GoodsId
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

            LEFT JOIN tmpGoodsPropertyValue ON tmpGoodsPropertyValue.GoodsId     = tmpGoods.GoodsId
                                           AND tmpGoodsPropertyValue.GoodsKindId = tmpGoods.GoodsKindId

       WHERE tmpMI.GoodsId IS NULL

      UNION ALL
       SELECT
             MovementItem.Id                        AS Id
           , Object_Goods.Id                        AS GoodsId
           , Object_Goods.ObjectCode                AS GoodsCode
           , Object_Goods.ValueData                 AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , MovementItem.Amount
           , MIFloat_AmountSecond.ValueData         AS AmountSecond
           
           , MIFloat_AmountRemains.ValueData        AS AmountRemains
           , MIFloat_AmountPartner.ValueData        AS AmountPartner
           , MIFloat_AmountForecast.ValueData       AS AmountForecast
           , MIFloat_AmountForecastOrder.ValueData  AS AmountForecastOrder
           , (-1 * (COALESCE (MIFloat_AmountRemains.ValueData, 0) - COALESCE (MIFloat_AmountPartner.ValueData, 0) - COALESCE (MIFloat_AmountForecast.ValueData, 0))) :: TFloat AS AmountCalc
           , (-1 * (COALESCE (MIFloat_AmountRemains.ValueData, 0) - COALESCE (MIFloat_AmountPartner.ValueData, 0) - COALESCE (MIFloat_AmountForecastOrder.ValueData, 0))) :: TFloat AS AmountCalcOrder

           , Object_GoodsKind.Id                    AS GoodsKindId
           , Object_GoodsKind.ValueData             AS GoodsKindName
           , Object_Measure.ValueData               AS MeasureName
          
           , MIFloat_Price.ValueData                AS Price
           , MIFloat_CountForPrice.ValueData        AS CountForPrice
 
           , CAST ((MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)) * MIFloat_Price.ValueData  / COALESCE (MIFloat_CountForPrice.ValueData ,0) AS NUMERIC (16, 2)) :: TFloat AS AmountSumm 
           , MIFloat_Summ.ValueData                 AS AmountSumm_Partner
           
           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName

           , tmpGoodsPropertyValue.ArticleGLN
           , MovementItem.isErased                  AS isErased

           , MIDate_StartBegin.ValueData                   AS StartBegin
           , MIDate_EndBegin.ValueData                     AS EndBegin
           , EXTRACT (EPOCH FROM (COALESCE (MIDate_EndBegin.ValueData, zc_DateStart()) - COALESCE (MIDate_StartBegin.ValueData, zc_DateStart())) :: INTERVAL) :: TFloat AS diffBegin_sec

           , tmpMI_Child.Amount       ::TFloat AS Amount_child
           , tmpMI_Child.AmountSecond ::TFloat AS AmountSecond_child
           , tmpMI_Child.Amount_diff  ::TFloat AS AmountDiff_child

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_AmountRemains
                                        ON MIFloat_AmountRemains.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountRemains.DescId = zc_MIFloat_AmountRemains()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                        ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
            LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                        ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                       AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountForecast
                                        ON MIFloat_AmountForecast.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountForecast.DescId = zc_MIFloat_AmountForecast()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountForecastOrder
                                        ON MIFloat_AmountForecastOrder.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountForecastOrder.DescId = zc_MIFloat_AmountForecastOrder()

            LEFT JOIN MovementItemDate AS MIDate_StartBegin
                                       ON MIDate_StartBegin.MovementItemId = MovementItem.Id
                                      AND MIDate_StartBegin.DescId         = zc_MIDate_StartBegin()
            LEFT JOIN MovementItemDate AS MIDate_EndBegin
                                       ON MIDate_EndBegin.MovementItemId = MovementItem.Id
                                      AND MIDate_EndBegin.DescId         = zc_MIDate_EndBegin()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
                                  
            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

            LEFT JOIN tmpGoodsPropertyValue ON tmpGoodsPropertyValue.GoodsId     = MovementItem.ObjectId
                                           AND tmpGoodsPropertyValue.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
            
            LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = MovementItem.Id
            ;
     ELSE

     RETURN QUERY
       WITH tmpGoodsPropertyValue AS (SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
                                           , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                                           , ObjectString_ArticleGLN.ValueData                                   AS ArticleGLN
                                      FROM (SELECT vbGoodsPropertyId AS GoodsPropertyId WHERE vbGoodsPropertyId <> 0
                                           ) AS tmpGoodsProperty
                                           INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                                 ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                                                AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                           LEFT JOIN ObjectString AS ObjectString_ArticleGLN
                                                                  ON ObjectString_ArticleGLN.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                 AND ObjectString_ArticleGLN.DescId = zc_ObjectString_GoodsPropertyValue_ArticleGLN()
                                           LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                                ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                               AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                           LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                                ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                               AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                                      WHERE ObjectString_ArticleGLN.ValueData <> ''
                                     )

          , tmpMI_Child AS (SELECT MovementItem.ParentId
                                 , SUM (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) = 0 THEN MovementItem.Amount ELSE 0 END) AS Amount
                                 , SUM (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) > 0 THEN MovementItem.Amount ELSE 0 END) AS AmountSecond
                                 , SUM (MovementItem.Amount) AS Amount_diff
                            FROM MovementItem
                                 LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                             ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                            AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
                            WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId     = zc_MI_Child()
                              AND MovementItem.isErased   = FALSE
                            GROUP BY MovementItem.ParentId
                            )

       SELECT
             MovementItem.Id                        AS Id
           , Object_Goods.Id                        AS GoodsId
           , Object_Goods.ObjectCode                AS GoodsCode
           , Object_Goods.ValueData                 AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , MovementItem.Amount                    AS Amount
           , MIFloat_AmountSecond.ValueData         AS AmountSecond
           
           , MIFloat_AmountRemains.ValueData        AS AmountRemains
           , MIFloat_AmountPartner.ValueData        AS AmountPartner
           , MIFloat_AmountForecast.ValueData       AS AmountForecast
           , MIFloat_AmountForecastOrder.ValueData  AS AmountForecastOrder
           , (-1 * (COALESCE (MIFloat_AmountRemains.ValueData, 0) - COALESCE (MIFloat_AmountPartner.ValueData, 0) - COALESCE (MIFloat_AmountForecast.ValueData, 0))) :: TFloat AS AmountCalc
           , (-1 * (COALESCE (MIFloat_AmountRemains.ValueData, 0) - COALESCE (MIFloat_AmountPartner.ValueData, 0) - COALESCE (MIFloat_AmountForecastOrder.ValueData, 0))) :: TFloat AS AmountCalcOrder

           , Object_GoodsKind.Id                    AS GoodsKindId
           , Object_GoodsKind.ValueData             AS GoodsKindName
           , Object_Measure.ValueData               AS MeasureName  
           , MIFloat_Price.ValueData                AS Price
           , MIFloat_CountForPrice.ValueData        AS CountForPrice

           , CAST ((MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)) * MIFloat_Price.ValueData  / COALESCE (MIFloat_CountForPrice.ValueData ,0) AS NUMERIC (16, 2)) :: TFloat AS AmountSumm
 
           , MIFloat_Summ.ValueData            AS AmountSumm_Partner
                   
           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName

           , tmpGoodsPropertyValue.ArticleGLN

           , MovementItem.isErased

           , MIDate_StartBegin.ValueData                   AS StartBegin
           , MIDate_EndBegin.ValueData                     AS EndBegin
           , EXTRACT (EPOCH FROM (COALESCE (MIDate_EndBegin.ValueData, zc_DateStart()) - COALESCE (MIDate_StartBegin.ValueData, zc_DateStart())) :: INTERVAL) :: TFloat AS diffBegin_sec

           , tmpMI_Child.Amount       ::TFloat AS Amount_child
           , tmpMI_Child.AmountSecond ::TFloat AS AmountSecond_child
           , tmpMI_Child.Amount_diff  ::TFloat AS AmountDiff_child

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_AmountRemains
                                        ON MIFloat_AmountRemains.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountRemains.DescId = zc_MIFloat_AmountRemains()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                        ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
            LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                        ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                       AND MIFloat_Summ.DescId = zc_MIFloat_Summ()

            LEFT JOIN MovementItemFloat AS MIFloat_AmountForecast
                                        ON MIFloat_AmountForecast.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountForecast.DescId = zc_MIFloat_AmountForecast()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountForecastOrder
                                        ON MIFloat_AmountForecastOrder.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountForecastOrder.DescId = zc_MIFloat_AmountForecastOrder()

            LEFT JOIN MovementItemDate AS MIDate_StartBegin
                                       ON MIDate_StartBegin.MovementItemId = MovementItem.Id
                                      AND MIDate_StartBegin.DescId         = zc_MIDate_StartBegin()
            LEFT JOIN MovementItemDate AS MIDate_EndBegin
                                       ON MIDate_EndBegin.MovementItemId = MovementItem.Id
                                      AND MIDate_EndBegin.DescId         = zc_MIDate_EndBegin()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

            LEFT JOIN tmpGoodsPropertyValue ON tmpGoodsPropertyValue.GoodsId     = MovementItem.ObjectId
                                           AND tmpGoodsPropertyValue.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
            
            LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = MovementItem.Id
           ;

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_OrderExternalUnit (Integer, Integer, TDateTime, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 02.05.19         *
 31.03.15         * add GoodsGroupNameFull
 11.02.15         * 
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_OrderExternalUnit (inMovementId:= 4229, inPriceListId:=0, inOperDate:= CURRENT_TIMESTAMP, inShowAll:= TRUE, inisErased:= True, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItem_OrderExternalUnit (inMovementId:= 4229, inPriceListId:=0, inOperDate:= CURRENT_TIMESTAMP, inShowAll:= FALSE, inisErased:= True, inSession:= '2')
