-- Function: gpSelect_MovementItem_StoreReal()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_StoreReal (Integer, Integer, TDateTime, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_StoreReal (Integer, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_StoreReal(
    IN inMovementId  Integer      , -- ключ Документа
    IN inPriceListId Integer      ,
    IN inOperDate    TDateTime    , -- Дата документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id                       Integer
             , LineNum                  Integer
             , GoodsId                  Integer
             , GoodsCode                Integer
             , GoodsName                TVarChar
             , GoodsGroupNameFull       TVarChar
             , Amount                   TFloat
             , GoodsKindId              Integer
             , GoodsKindName            TVarChar
             , MeasureName              TVarChar
             , InfoMoneyCode            Integer
             , InfoMoneyGroupName       TVarChar
             , InfoMoneyDestinationName TVarChar
             , InfoMoneyName            TVarChar
             , GUID                     TVarChar
             , isErased                 Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_MI_StoreReal());
      vbUserId:= lpGetUserBySession (inSession);

     IF inShowAll THEN

     RETURN QUERY
     WITH   -- Ограничение для ГП - какие товары показать
            tmpGoodsByGoodsKind AS (SELECT Object_GoodsByGoodsKind_View.GoodsId
                                         , COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0) AS GoodsKindId
                                    FROM ObjectBoolean AS ObjectBoolean_Order
                                         LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.Id = ObjectBoolean_Order.ObjectId
                                    WHERE ObjectBoolean_Order.ValueData = TRUE
                                      AND ObjectBoolean_Order.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order()
                                   )

           , tmpMI_Goods AS (SELECT MovementItem.Id                               AS MovementItemId
                                  , MovementItem.ObjectId                         AS GoodsId
                                  , MovementItem.Amount                           AS Amount
                                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                  , MIString_GUID.ValueData                       AS GUID
                                  , MovementItem.isErased
                             FROM (SELECT false AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased) AS tmpIsErased
                                  JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                   AND MovementItem.DescId = zc_MI_Master()
                                                   AND MovementItem.isErased = tmpIsErased.isErased
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                  LEFT JOIN MovementItemString AS MIString_GUID
                                                               ON MIString_GUID.MovementItemId = MovementItem.Id
                                                              AND MIString_GUID.DescId = zc_MIString_GUID()
                            )
        SELECT 0                          AS Id
             , 0                          AS LineNum
             , tmpGoods.GoodsId           AS GoodsId
             , tmpGoods.GoodsCode         AS GoodsCode
             , tmpGoods.GoodsName         AS GoodsName

             , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

             , CAST (NULL AS TFloat)      AS Amount
             , tmpMI.GoodsKindId
             , Object_GoodsKind.ValueData AS GoodsKindName
             , Object_Measure.ValueData   AS MeasureName

             , tmpGoods.InfoMoneyCode
             , tmpGoods.InfoMoneyGroupName
             , tmpGoods.InfoMoneyDestinationName
             , tmpGoods.InfoMoneyName

             , CAST (NULL AS TVarChar)    AS GUID
             , FALSE                      AS isErased
        FROM 
            (SELECT Object_Goods.Id                                        AS GoodsId
                  , Object_Goods.ObjectCode                                AS GoodsCode
                  , Object_Goods.ValueData                                 AS GoodsName
                  , COALESCE (tmpGoodsByGoodsKind.GoodsKindId, 0)          AS GoodsKindId

                  , Object_InfoMoney_View.InfoMoneyCode
                  , Object_InfoMoney_View.InfoMoneyGroupName
                  , Object_InfoMoney_View.InfoMoneyDestinationName
                  , Object_InfoMoney_View.InfoMoneyName
                 -- , Object_InfoMoney_View.InfoMoneyName_all
             FROM Object_InfoMoney_View
                  JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                  ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                 AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                  JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_InfoMoney.ObjectId
                                             AND Object_Goods.isErased = FALSE
                  LEFT JOIN tmpGoodsByGoodsKind ON tmpGoodsByGoodsKind.GoodsId = Object_Goods.Id
             WHERE (tmpGoodsByGoodsKind.GoodsId > 0 AND Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()
                                                                                                       , zc_Enum_InfoMoneyDestination_21000()
                                                                                                       , zc_Enum_InfoMoneyDestination_21100()
                                                                                                       , zc_Enum_InfoMoneyDestination_30100()
                                                                                                       , zc_Enum_InfoMoneyDestination_30200() )
                   )

            ) AS tmpGoods
             LEFT JOIN tmpMI_Goods AS tmpMI ON tmpMI.GoodsId     = tmpGoods.GoodsId
                                           AND tmpMI.GoodsKindId = tmpGoods.GoodsKindId
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoods.GoodsId
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpGoods.GoodsKindId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

             LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                    ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                   AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

        WHERE tmpMI.GoodsId IS NULL

      UNION ALL
        SELECT tmpMI.MovementItemId    AS Id
             , (ROW_NUMBER() OVER (ORDER BY tmpMI.MovementItemId))::Integer AS LineNum
             , tmpMI.GoodsId
             , Object_Goods.ObjectCode AS GoodsCode
             , Object_Goods.ValueData  AS GoodsName

             , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

             , tmpMI.Amount
             , tmpMI.GoodsKindId
             , Object_GoodsKind.ValueData AS GoodsKindName
             , Object_Measure.ValueData   AS MeasureName

             , Object_InfoMoney_View.InfoMoneyCode
             , Object_InfoMoney_View.InfoMoneyGroupName
             , Object_InfoMoney_View.InfoMoneyDestinationName
             , Object_InfoMoney_View.InfoMoneyName

             , tmpMI.GUID
             , tmpMI.isErased
        FROM tmpMI_Goods AS tmpMI
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

             LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                    ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                   AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

             LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                  ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
             LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId;

     ELSE

     RETURN QUERY
     WITH  
             tmpMI_Goods AS (SELECT MovementItem.Id                               AS MovementItemId
                                  , MovementItem.ObjectId                         AS GoodsId
                                  , MovementItem.Amount                           AS Amount
                                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                  , MIString_GUID.ValueData                       AS GUID
                                  , MovementItem.isErased
                             FROM (SELECT false AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased) AS tmpIsErased
                                  JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                   AND MovementItem.DescId = zc_MI_Master()
                                                   AND MovementItem.isErased = tmpIsErased.isErased
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                  LEFT JOIN MovementItemString AS MIString_GUID
                                                               ON MIString_GUID.MovementItemId = MovementItem.Id
                                                              AND MIString_GUID.DescId = zc_MIString_GUID()
                            )

        SELECT tmpMI.MovementItemId    AS Id
             , (ROW_NUMBER() OVER (ORDER BY tmpMI.MovementItemId))::Integer AS LineNum
             , tmpMI.GoodsId
             , Object_Goods.ObjectCode AS GoodsCode
             , Object_Goods.ValueData  AS GoodsName

             , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

             , tmpMI.Amount
             , tmpMI.GoodsKindId
             , Object_GoodsKind.ValueData AS GoodsKindName
             , Object_Measure.ValueData   AS MeasureName

             , Object_InfoMoney_View.InfoMoneyCode
             , Object_InfoMoney_View.InfoMoneyGroupName
             , Object_InfoMoney_View.InfoMoneyDestinationName
             , Object_InfoMoney_View.InfoMoneyName

             , tmpMI.GUID
             , tmpMI.isErased
        FROM tmpMI_Goods AS tmpMI
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

             LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                    ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                   AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

             LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                  ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
             LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId;


     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 25.03.17         *
 28.02.17                                                         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_StoreReal (inMovementId:= 5285619, inPriceListId:= 0, inOperDate:= CURRENT_DATE, inShowAll:= FALSE, inIsErased:= TRUE, inSession:= zfCalc_UserAdmin())