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
             , AmountRemains TFloat, Amount TFloat, AmountEDI TFloat, AmountSecond TFloat
             , GoodsKindId Integer, GoodsKindName  TVarChar, MeasureName TVarChar
             , Price TFloat, CountForPrice TFloat, AmountSumm TFloat, AmountSumm_Partner TFloat
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_MI_OrderExternal());
     vbUserId:= lpGetUserBySession (inSession);

     -- меняется параметр
     IF COALESCE (inPriceListId, 0) = 0 THEN inPriceListId := zc_PriceList_Basis(); END IF;


     vbUnitId:= (SELECT MovementLinkObject.ObjectId FROM MovementLinkObject INNER JOIN Object ON Object.Id = MovementLinkObject.ObjectId AND Object.DescId = zc_Object_Unit() WHERE MovementLinkObject.MovementId = inMovementId AND MovementLinkObject.DescId = zc_MovementLinkObject_From());
     IF COALESCE (vbUnitId, 0) = 0
     THEN
         vbUnitId:= (SELECT MovementLinkObject.ObjectId FROM MovementLinkObject WHERE MovementLinkObject.MovementId = inMovementId AND MovementLinkObject.DescId = zc_MovementLinkObject_To());
     END IF;


     -- Результат
     IF inShowAll THEN

     -- Результат такой
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
                           WHERE CLO_Unit.ObjectId = vbUnitId
                             AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
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
                            FULL JOIN tmpRemains ON tmpRemains.GoodsId = tmpMI_Goods.GoodsId
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
       SELECT
             0 :: Integer               AS Id
           , tmpGoods.GoodsId           AS GoodsId
           , tmpGoods.GoodsCode         AS GoodsCode
           , tmpGoods.GoodsName         AS GoodsName
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
           , FALSE                      AS isErased

       FROM (SELECT Object_Goods.Id                                                   AS GoodsId
                  , Object_Goods.ObjectCode                                           AS GoodsCode
                  , Object_Goods.ValueData                                            AS GoodsName
                  -- , zc_Enum_GoodsKind_Main()  AS GoodsKindId
                  , COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, 0) AS GoodsKindId
             FROM Object_InfoMoney_View
                  JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                  ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                 AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                  JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_InfoMoney.ObjectId
                                             AND Object_Goods.isErased = FALSE
                  LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                       ON ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = Object_Goods.Id
                                      AND ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
                  LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                       ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                      AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()

             WHERE Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900(), zc_Enum_InfoMoneyDestination_21000(), zc_Enum_InfoMoneyDestination_21100(), zc_Enum_InfoMoneyDestination_30100())
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
       WHERE tmpMI.GoodsId IS NULL

      UNION ALL
       SELECT
             tmpMI.MovementItemId :: Integer    AS Id
           , Object_Goods.Id                    AS GoodsId
           , Object_Goods.ObjectCode            AS GoodsCode
           , Object_Goods.ValueData             AS GoodsName
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
                           WHERE CLO_Unit.ObjectId = vbUnitId
                             AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
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
       SELECT
             tmpMI.MovementItemId :: Integer    AS Id
           , Object_Goods.Id                    AS GoodsId
           , Object_Goods.ObjectCode            AS GoodsCode
           , Object_Goods.ValueData             AS GoodsName
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
       ;

     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_OrderExternal (Integer, Integer, TDateTime, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 20.10.14                                        * all
 26.08.14                                                        *
 18.08.14                                                        *
 06.06.14                                                        *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_OrderExternal (inMovementId:= 25173, inPriceListId:= zc_PriceList_Basis(), inOperDate:= CURRENT_TIMESTAMP, inShowAll:= TRUE, inIsErased:= TRUE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItem_OrderExternal (inMovementId:= 25173, inPriceListId:= zc_PriceList_Basis(), inOperDate:= CURRENT_TIMESTAMP, inShowAll:= FALSE, inIsErased:= TRUE, inSession:= zfCalc_UserAdmin())
