-- Function: gpSelect_MovementItem_OrderExternal()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderExternal (Integer, Integer, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_OrderExternal(
    IN inMovementId  Integer      , -- ключ Документа
    IN inPriceListId Integer      , -- ключ Прайс листа
    IN inOperDate    TDateTime    , -- Дата документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar
             , AmountRemains TFloat, Amount TFloat, AmountEDI TFloat, AmountSecond TFloat
             , GoodsKindId Integer, GoodsKindName  TVarChar, MeasureName TVarChar
             , Price TFloat, CountForPrice TFloat, AmountSumm TFloat, AmountSumm_Partner TFloat
             , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar
             , ArticleGLN TVarChar
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbUnitId Integer;
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
     vbGoodsPropertyId:= zfCalc_GoodsPropertyId ((SELECT MovementLinkObject.ObjectId FROM MovementLinkObject WHERE MovementLinkObject.MovementId = inMovementId AND MovementLinkObject.DescId = zc_MovementLinkObject_Contract())
                                               , (SELECT ObjectLink_Partner_Juridical.ChildObjectId FROM MovementLinkObject LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject.ObjectId AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical() WHERE MovementLinkObject.MovementId = inMovementId AND MovementLinkObject.DescId = zc_MovementLinkObject_From())
                                                );

     -- определяется
     vbUnitId:= (SELECT MovementLinkObject.ObjectId FROM MovementLinkObject INNER JOIN Object ON Object.Id = MovementLinkObject.ObjectId AND Object.DescId = zc_Object_Unit() WHERE MovementLinkObject.MovementId = inMovementId AND MovementLinkObject.DescId = zc_MovementLinkObject_From());
     IF COALESCE (vbUnitId, 0) = 0
     THEN
         vbUnitId:= (SELECT MovementLinkObject.ObjectId FROM MovementLinkObject WHERE MovementLinkObject.MovementId = inMovementId AND MovementLinkObject.DescId = zc_MovementLinkObject_To());
     END IF;


     -- Результат
     IF inShowAll THEN

     -- Результат такой
     RETURN QUERY
      WITH tmpInfoMoney AS (SELECT View_InfoMoney.InfoMoneyGroupId
                                 , View_InfoMoney.InfoMoneyDestinationId
                                 , View_InfoMoney.InfoMoneyId
                            FROM (SELECT View_InfoMoney.InfoMoneyGroupId
                                       , View_InfoMoney.InfoMoneyDestinationId
                                       , View_InfoMoney.InfoMoneyId
                                  FROM MovementLinkObject AS MLO_Contract
                                       INNER JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                                             ON ObjectLink_Contract_InfoMoney.ObjectId = MLO_Contract.ObjectId
                                                            AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                                       INNER JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Contract_InfoMoney.ChildObjectId
                                  WHERE MLO_Contract.MovementId = inMovementId
                                    AND MLO_Contract.DescId = zc_MovementLinkObject_Contract()
                                 ) AS tmpContract
                                 INNER JOIN Object_InfoMoney_View AS View_InfoMoney ON (View_InfoMoney.InfoMoneyDestinationId  IN (zc_Enum_InfoMoneyDestination_10100() -- Мясное сырье + Основное сырье
                                                                                                                                  )
                                                                                        AND tmpContract.InfoMoneyId = zc_Enum_InfoMoney_30201() -- Доходы + Мясное сырье + Мясное сырье
                                                                                       )
                                                                                    OR ((View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21100() -- Общефирменные + Дворкин
                                                                                         OR View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_30103() -- Доходы + Продукция + Хлеб
                                                                                        )
                                                                                        AND tmpContract.InfoMoneyId = zc_Enum_InfoMoney_30103() -- Доходы + Продукция + Хлеб
                                                                                       )
                                                                                    OR (View_InfoMoney.InfoMoneyDestinationId  IN (zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
                                                                                                                                 , zc_Enum_InfoMoneyDestination_21000() -- Общефирменные + Чапли
                                                                                                                                 , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                                                                                 , zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
                                                                                                                                  )
                                                                                        AND View_InfoMoney.InfoMoneyId <> zc_Enum_InfoMoney_30103() -- Доходы + Продукция + Хлеб
                                                                                        AND tmpContract.InfoMoneyId = zc_Enum_InfoMoney_30101() -- Доходы + Продукция + Готовая продукция
                                                                                       )

                           )
          , tmpMI_Goods AS (SELECT MovementItem.Id                               AS MovementItemId
                                 , MovementItem.ObjectId                         AS GoodsId
                                 , MovementItem.Amount                           AS Amount
                                 , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                 , COALESCE (MIFloat_Price.ValueData, 0)         AS Price
                                 , CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice
                                 , MovementItem.isErased
                            FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                                 INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                        AND MovementItem.DescId     = zc_MI_Master()
                                                        AND MovementItem.isErased   = tmpIsErased.isErased
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                  ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                 LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                             ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                            AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                 LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                             ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                            AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                          )
          , tmpGoodsByGoodsKind AS (SELECT Object_GoodsByGoodsKind_View.GoodsId
                                         , COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0) AS GoodsKindId
                                    FROM ObjectBoolean AS ObjectBoolean_Order
                                         LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.Id = ObjectBoolean_Order.ObjectId
                                    WHERE ObjectBoolean_Order.ValueData = TRUE
                                      AND ObjectBoolean_Order.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order()
                                      AND vbIsOrderDnepr = TRUE
                                   )

          , tmpRemains AS (SELECT Container.ObjectId                          AS GoodsId
                                , Container.Amount                            AS Amount
                                , COALESCE (CLO_GoodsKind.ObjectId, 0)        AS GoodsKindId
                           FROM ContainerLinkObject AS CLO_Unit
                                INNER JOIN Container ON Container.Id = CLO_Unit.ContainerId AND Container.DescId = zc_Container_Count() AND Container.Amount <> 0
                                LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                              ON CLO_GoodsKind.ContainerId = CLO_Unit.ContainerId
                                                             AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                LEFT JOIN ContainerLinkObject AS CLO_Account
                                                              ON CLO_Account.ContainerId = CLO_Unit.ContainerId
                                                             AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                           WHERE CLO_Unit.ObjectId = vbUnitId
                             AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                             AND CLO_Account.ContainerId IS NULL
                             AND vbIsOrderDnepr = FALSE
                          )
          , tmpMI AS (SELECT COALESCE (tmpMI_Goods.MovementItemId, 0)                   AS MovementItemId
                           , COALESCE (tmpMI_Goods.GoodsId, tmpRemains.GoodsId)         AS GoodsId
                           , COALESCE (tmpMI_Goods.Amount, 0)                           AS Amount
                           , COALESCE (tmpRemains.Amount, 0)                            AS AmountRemains
                           , COALESCE (tmpMI_Goods.GoodsKindId, tmpRemains.GoodsKindId) AS GoodsKindId
                           , COALESCE (tmpMI_Goods.Price, 0)                            AS Price
                           , COALESCE (tmpMI_Goods.CountForPrice, 1)                    AS CountForPrice
                           , COALESCE (tmpMI_Goods.isErased, FALSE)                     AS isErased
                       FROM tmpMI_Goods
                            LEFT JOIN tmpRemains ON tmpRemains.GoodsId = tmpMI_Goods.GoodsId
                                                AND tmpRemains.GoodsKindId = tmpMI_Goods.GoodsKindId
                     )
          , tmpMI_EDI AS (SELECT MovementItem.ObjectId                         AS GoodsId
                               , SUM (MovementItem.Amount)                     AS Amount
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
          , tmpMI_EDI_find AS (SELECT tmpMI_EDI.GoodsId
                                    , tmpMI_EDI.Amount
                                    , tmpMI_EDI.GoodsKindId
                                    , tmpMI_EDI.Price
                                    , tmpMI_EDI.CountForPrice
                                    , COALESCE (tmpMI.MovementItemId, 0) AS MovementItemId
                               FROM tmpMI_EDI
                                    LEFT JOIN (SELECT MAX (tmpMI.MovementItemId) AS MovementItemId
                                                    , tmpMI.GoodsId
                                                    , tmpMI.GoodsKindId
                                                    , tmpMI.Price
                                               FROM tmpMI
                                               WHERE tmpMI.isErased = FALSE
                                               GROUP BY tmpMI.GoodsId
                                                      , tmpMI.GoodsKindId
                                                      , tmpMI.Price
                                              ) AS tmpMI ON tmpMI.GoodsId     = tmpMI_EDI.GoodsId
                                                        AND tmpMI.GoodsKindId = tmpMI_EDI.GoodsKindId
                                                        AND tmpMI.Price       = tmpMI_EDI.Price
                              )
          , tmpMI_all AS (SELECT tmpMI.MovementItemId
                               , COALESCE (tmpMI.GoodsId, tmpMI_EDI_find.GoodsId) AS GoodsId
                               , tmpMI.AmountRemains   AS AmountRemains
                               , tmpMI.Amount          AS Amount
                               , tmpMI_EDI_find.Amount AS AmountEDI
                               , COALESCE (tmpMI.GoodsKindId, tmpMI_EDI_find.GoodsKindId)     AS GoodsKindId
                               , COALESCE (tmpMI.Price, tmpMI_EDI_find.Price)                 AS Price
                               , COALESCE (tmpMI.CountForPrice, tmpMI_EDI_find.CountForPrice) AS CountForPrice
                               , COALESCE (tmpMI.isErased, FALSE) AS isErased
                          FROM tmpMI
                               FULL JOIN tmpMI_EDI_find ON tmpMI_EDI_find.MovementItemId = tmpMI.MovementItemId
                         )
          , tmpGoodsPropertyValue AS (SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
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
       SELECT
             0 :: Integer               AS Id
           , tmpGoods.GoodsId           AS GoodsId
           , tmpGoods.GoodsCode         AS GoodsCode
           , tmpGoods.GoodsName         AS GoodsName
           , tmpGoods.GoodsGroupNameFull

           , tmpRemains.Amount          AS AmountRemains
           , 0 :: TFloat                AS Amount
           , 0 :: TFloat                AS AmountEDI
           , 0 :: TFloat                AS AmountSecond
           , Object_GoodsKind.Id        AS GoodsKindId
           , Object_GoodsKind.ValueData AS GoodsKindName
           , Object_Measure.ValueData   AS MeasureName
           , lfObjectHistory_PriceListItem.ValuePrice :: TFloat AS Price
           , 1 :: TFloat                AS CountForPrice
           , NULL :: TFloat             AS AmountSumm
           , NULL :: TFloat             AS AmountSumm_Partner

           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName

           , tmpGoodsPropertyValue.ArticleGLN

           , FALSE                      AS isErased

       FROM (SELECT Object_Goods.Id                                        AS GoodsId
                  , Object_Goods.ObjectCode                                AS GoodsCode
                  , Object_Goods.ValueData                                 AS GoodsName
                  -- , zc_Enum_GoodsKind_Main()  AS GoodsKindId
                  , COALESCE (tmpGoodsByGoodsKind.GoodsKindId, COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0)) AS GoodsKindId
                  , ObjectString_Goods_GoodsGroupFull.ValueData            AS GoodsGroupNameFull
             FROM tmpInfoMoney
                  JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                  ON ObjectLink_Goods_InfoMoney.ChildObjectId = tmpInfoMoney.InfoMoneyId
                                 AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                  JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_InfoMoney.ObjectId
                                             AND Object_Goods.isErased = FALSE
                  LEFT JOIN tmpGoodsByGoodsKind ON tmpGoodsByGoodsKind.GoodsId = Object_Goods.Id
                                               AND vbIsOrderDnepr = TRUE
                  LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsId = Object_Goods.Id
                                                        AND tmpInfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) -- Ирна + Готовая продукция + Доходы Мясное сырье
                                                        AND vbIsOrderDnepr = FALSE

                  LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                         ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                        AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
             WHERE tmpGoodsByGoodsKind.GoodsId > 0 OR vbIsOrderDnepr = FALSE
            ) AS tmpGoods

            LEFT JOIN tmpRemains ON tmpRemains.GoodsId     = tmpGoods.GoodsId
                                AND tmpRemains.GoodsKindId = tmpGoods.GoodsKindId
            LEFT JOIN tmpMI_all AS tmpMI ON tmpMI.GoodsId     = tmpGoods.GoodsId
                                        AND tmpMI.GoodsKindId = tmpGoods.GoodsKindId

            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpGoods.GoodsKindId
            LEFT JOIN lfSelect_ObjectHistory_PriceListItem (inPriceListId:= inPriceListId, inOperDate:= inOperDate)
                   AS lfObjectHistory_PriceListItem ON lfObjectHistory_PriceListItem.GoodsId = tmpGoods.GoodsId
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = tmpGoods.GoodsId
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

            LEFT JOIN tmpGoodsPropertyValue ON tmpGoodsPropertyValue.GoodsId     = tmpGoods.GoodsId
                                           AND tmpGoodsPropertyValue.GoodsKindId = tmpGoods.GoodsKindId
                                  
       WHERE tmpMI.GoodsId IS NULL

      UNION ALL
       SELECT
             tmpMI.MovementItemId :: Integer    AS Id
           , Object_Goods.Id                    AS GoodsId
           , Object_Goods.ObjectCode            AS GoodsCode
           , Object_Goods.ValueData             AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , tmpMI.AmountRemains :: TFloat      AS AmountRemains
           , tmpMI.Amount :: TFloat             AS Amount
           , tmpMI.AmountEDI :: TFloat          AS AmountEDI
           , MIFloat_AmountSecond.ValueData     AS AmountSecond
           , Object_GoodsKind.Id                AS GoodsKindId
           , Object_GoodsKind.ValueData         AS GoodsKindName
           , Object_Measure.ValueData           AS MeasureName
           , tmpMI.Price :: TFloat              AS Price
           , tmpMI.CountForPrice :: TFloat      AS CountForPrice
           , CAST ((tmpMI.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)) * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2)) :: TFloat AS AmountSumm
           , MIFloat_Summ.ValueData             AS AmountSumm_Partner

           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName

           , tmpGoodsPropertyValue.ArticleGLN

           , tmpMI.isErased                     AS isErased

       FROM tmpMI_all AS tmpMI
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                        ON MIFloat_AmountSecond.MovementItemId = tmpMI.MovementItemId
                                       AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
            LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                        ON MIFloat_Summ.MovementItemId = tmpMI.MovementItemId
                                       AND MIFloat_Summ.DescId = zc_MIFloat_Summ()

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
            LEFT JOIN tmpGoodsPropertyValue ON tmpGoodsPropertyValue.GoodsId     = tmpMI.GoodsId
                                           AND tmpGoodsPropertyValue.GoodsKindId = tmpMI.GoodsKindId
       ;

     ELSE

     -- Результат другой
     RETURN QUERY
 WITH tmpMI_Goods AS (SELECT MovementItem.Id                               AS MovementItemId
                           , MovementItem.ObjectId                         AS GoodsId
                           , MovementItem.Amount                           AS Amount
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                           , COALESCE (MIFloat_Price.ValueData, 0)         AS Price
                           , CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice
                           , MovementItem.isErased
                       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                   AND MovementItem.isErased   = tmpIsErased.isErased
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
                            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                     )
          , tmpRemains AS (SELECT Container.ObjectId                          AS GoodsId
                                , Container.Amount                            AS Amount
                                , COALESCE (CLO_GoodsKind.ObjectId, 0)        AS GoodsKindId
                           FROM ContainerLinkObject AS CLO_Unit
                                INNER JOIN Container ON Container.Id = CLO_Unit.ContainerId AND Container.DescId = zc_Container_Count() AND Container.Amount <> 0
                                LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                              ON CLO_GoodsKind.ContainerId = CLO_Unit.ContainerId
                                                             AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                LEFT JOIN ContainerLinkObject AS CLO_Account
                                                              ON CLO_Account.ContainerId = CLO_Unit.ContainerId
                                                             AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                           WHERE CLO_Unit.ObjectId = vbUnitId
                             AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                             AND CLO_Account.ContainerId IS NULL
                             AND vbIsOrderDnepr = FALSE
                          )
          , tmpMI AS (SELECT COALESCE (tmpMI_Goods.MovementItemId, 0)                   AS MovementItemId
                           , COALESCE (tmpMI_Goods.GoodsId, tmpRemains.GoodsId)         AS GoodsId
                           , COALESCE (tmpMI_Goods.Amount, 0)                           AS Amount
                           , COALESCE (tmpRemains.Amount, 0)                            AS AmountRemains
                           , COALESCE (tmpMI_Goods.GoodsKindId, tmpRemains.GoodsKindId) AS GoodsKindId
                           , COALESCE (tmpMI_Goods.Price, 0)                            AS Price
                           , COALESCE (tmpMI_Goods.CountForPrice, 1)                    AS CountForPrice
                           , COALESCE (tmpMI_Goods.isErased, FALSE)                     AS isErased
                       FROM tmpMI_Goods
                            LEFT JOIN tmpRemains ON tmpRemains.GoodsId = tmpMI_Goods.GoodsId
                                                AND tmpRemains.GoodsKindId = tmpMI_Goods.GoodsKindId
                     )
          , tmpMI_EDI AS (SELECT MovementItem.ObjectId                         AS GoodsId
                               , SUM (MovementItem.Amount)                     AS Amount
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
          , tmpMI_EDI_find AS (SELECT tmpMI_EDI.GoodsId
                                    , tmpMI_EDI.Amount
                                    , tmpMI_EDI.GoodsKindId
                                    , tmpMI_EDI.Price
                                    , tmpMI_EDI.CountForPrice
                                    , COALESCE (tmpMI.MovementItemId, 0) AS MovementItemId
                               FROM tmpMI_EDI
                                    LEFT JOIN (SELECT MAX (tmpMI.MovementItemId) AS MovementItemId
                                                    , tmpMI.GoodsId
                                                    , tmpMI.GoodsKindId
                                                    , tmpMI.Price
                                               FROM tmpMI
                                               WHERE tmpMI.isErased = FALSE
                                               GROUP BY tmpMI.GoodsId
                                                      , tmpMI.GoodsKindId
                                                      , tmpMI.Price
                                              ) AS tmpMI ON tmpMI.GoodsId     = tmpMI_EDI.GoodsId
                                                        AND tmpMI.GoodsKindId = tmpMI_EDI.GoodsKindId
                                                        AND tmpMI.Price       = tmpMI_EDI.Price
                              )
          , tmpMI_all AS (SELECT tmpMI.MovementItemId
                               , COALESCE (tmpMI.GoodsId, tmpMI_EDI_find.GoodsId) AS GoodsId
                               , tmpMI.AmountRemains   AS AmountRemains
                               , tmpMI.Amount          AS Amount
                               , tmpMI_EDI_find.Amount AS AmountEDI
                               , COALESCE (tmpMI.GoodsKindId, tmpMI_EDI_find.GoodsKindId)     AS GoodsKindId
                               , COALESCE (tmpMI.Price, tmpMI_EDI_find.Price)                 AS Price
                               , COALESCE (tmpMI.CountForPrice, tmpMI_EDI_find.CountForPrice) AS CountForPrice
                               , COALESCE (tmpMI.isErased, FALSE) AS isErased
                          FROM tmpMI
                               FULL JOIN tmpMI_EDI_find ON tmpMI_EDI_find.MovementItemId = tmpMI.MovementItemId
                         )
          , tmpGoodsPropertyValue AS (SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
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
       SELECT
             tmpMI.MovementItemId :: Integer    AS Id
           , Object_Goods.Id                    AS GoodsId
           , Object_Goods.ObjectCode            AS GoodsCode
           , Object_Goods.ValueData             AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , tmpMI.AmountRemains :: TFloat      AS AmountRemains
           , tmpMI.Amount :: TFloat             AS Amount
           , tmpMI.AmountEDI :: TFloat          AS AmountEDI
           , MIFloat_AmountSecond.ValueData     AS AmountSecond
           , Object_GoodsKind.Id                AS GoodsKindId
           , Object_GoodsKind.ValueData         AS GoodsKindName
           , Object_Measure.ValueData           AS MeasureName
           , tmpMI.Price :: TFloat              AS Price
           , tmpMI.CountForPrice :: TFloat      AS CountForPrice
           , CAST ((tmpMI.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)) * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2)) :: TFloat AS AmountSumm
           , MIFloat_Summ.ValueData             AS AmountSumm_Partner

           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName

           , tmpGoodsPropertyValue.ArticleGLN

           , tmpMI.isErased                     AS isErased

       FROM tmpMI_all AS tmpMI
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                        ON MIFloat_AmountSecond.MovementItemId = tmpMI.MovementItemId
                                       AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
            LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                        ON MIFloat_Summ.MovementItemId = tmpMI.MovementItemId
                                       AND MIFloat_Summ.DescId = zc_MIFloat_Summ()

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
                                  
            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMI.GoodsId
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

            LEFT JOIN tmpGoodsPropertyValue ON tmpGoodsPropertyValue.GoodsId     = tmpMI.GoodsId
                                           AND tmpGoodsPropertyValue.GoodsKindId = tmpMI.GoodsKindId
       ;

     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_OrderExternal (Integer, Integer, TDateTime, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 17.06.15                                        * add vbIsOrderDnepr
 31.03.15         * add GoodsGroupNameFull
 20.10.14                                        * all
 26.08.14                                                        *
 18.08.14                                                        *
 06.06.14                                                        *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_OrderExternal (inMovementId:= 25173, inPriceListId:= zc_PriceList_Basis(), inOperDate:= CURRENT_TIMESTAMP, inShowAll:= TRUE, inIsErased:= TRUE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItem_OrderExternal (inMovementId:= 25173, inPriceListId:= zc_PriceList_Basis(), inOperDate:= CURRENT_TIMESTAMP, inShowAll:= FALSE, inIsErased:= TRUE, inSession:= zfCalc_UserAdmin())
