	-- Function: gpSelect_MI_OrderIncomeSnab()

DROP FUNCTION IF EXISTS gpSelect_MI_OrderIncomeSnab (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_OrderIncomeSnab(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, LineNum Integer
             , GoodsGroupNameFull TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , MeasureId Integer, MeasureName TVarChar
             , Amount TFloat
             , Comment TVarChar
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE Cursor1 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_OrderIncome());
     vbUserId:= lpGetUserBySession (inSession);

 
     IF inShowAll THEN

     RETURN QUERY
     WITH 
     tmpGoodsListIncome AS (SELECT DISTINCT ObjectLink_GoodsListIncome_Goods.ChildObjectId AS GoodsId
                            FROM Object AS Object_GoodsListIncome
                                 INNER JOIN ObjectLink AS ObjectLink_GoodsListIncome_Goods
                                         ON ObjectLink_GoodsListIncome_Goods.ObjectId = Object_GoodsListIncome.Id
                                        AND ObjectLink_GoodsListIncome_Goods.DescId = zc_ObjectLink_GoodsListIncome_Goods()
                            WHERE Object_GoodsListIncome.DescId = zc_Object_GoodsListIncome()
                              AND Object_GoodsListIncome.isErased =False
                           )

           , tmpMI_Goods AS (SELECT MovementItem.Id                               AS MovementItemId
                                  , MovementItem.ObjectId                         AS MeasureId
                                  , MILinkObject_Goods.ObjectId                   AS GoodsId
                                  , MovementItem.Amount                           AS Amount
                                  , MIString_Comment.ValueData                    AS Comment
                                  , MovementItem.isErased
                             FROM (SELECT false AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased) AS tmpIsErased
                                  JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                   AND MovementItem.DescId = zc_MI_Master()
                                                   AND MovementItem.isErased = tmpIsErased.isErased
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                         ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                        AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                  LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()
                            )

        SELECT 0                          AS Id
             , 0                          AS LineNum
             , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
             , Object_Goods.Id            AS GoodsId
             , Object_Goods.ObjectCode    AS GoodsCode
             , Object_Goods.ValueData     AS GoodsName
             , Object_Measure.Id          AS MeasureId
             , Object_Measure.ValueData   AS MeasureName
             , CAST (NULL AS TFloat)      AS Amount
             , CAST (NULL AS TVarChar)    AS Comment
             , FALSE                      AS isErased
        FROM tmpGoodsListIncome AS tmpGoods
             LEFT JOIN tmpMI_Goods AS tmpMI ON tmpMI.GoodsId     = tmpGoods.GoodsId

             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoods.GoodsId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId 
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

             LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                    ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                   AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

        WHERE tmpMI.GoodsId IS NULL

      UNION ALL
        SELECT tmpMI.MovementItemId    AS Id
             , (ROW_NUMBER() OVER (ORDER BY tmpMI.MovementItemId))::Integer AS LineNum
             , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
             , tmpMI.GoodsId
             , Object_Goods.ObjectCode    AS GoodsCode
             , Object_Goods.ValueData     AS GoodsName
             , Object_Measure.Id          AS MeasureId
             , Object_Measure.ValueData   AS MeasureName
             , tmpMI.Amount
             , tmpMI.Comment
             , tmpMI.isErased
        FROM tmpMI_Goods AS tmpMI
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = tmpMI.MeasureId

             LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                    ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                   AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
;

     ELSE

     RETURN QUERY
     WITH  
             tmpMI_Goods AS (SELECT MovementItem.Id                               AS MovementItemId
                                  , MovementItem.ObjectId                         AS MeasureId
                                  , MILinkObject_Goods.ObjectId                   AS GoodsId
                                  , MovementItem.Amount                           AS Amount
                                  , MIString_Comment.ValueData                    AS Comment
                                  , MovementItem.isErased
                             FROM (SELECT false AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased) AS tmpIsErased
                                  JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                   AND MovementItem.DescId = zc_MI_Master()
                                                   AND MovementItem.isErased = tmpIsErased.isErased
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                             ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                 
                                  LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()
                            )

        SELECT tmpMI.MovementItemId       AS Id
             , (ROW_NUMBER() OVER (ORDER BY tmpMI.MovementItemId))::Integer AS LineNum
             , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
             , tmpMI.GoodsId
             , Object_Goods.ObjectCode    AS GoodsCode
             , Object_Goods.ValueData     AS GoodsName
             , Object_Measure.Id          AS MeasureId
             , Object_Measure.ValueData   AS MeasureName
             , tmpMI.Amount
             , tmpMI.Comment
             , tmpMI.isErased
        FROM tmpMI_Goods AS tmpMI
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId

             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = tmpMI.MeasureId

             LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                    ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                   AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
;


     END IF;
 
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И. 
 14.04.17         * 
*/

-- тест
-- SELECT * FROM gpSelect_MI_OrderIncomeSnab (0, FALSE, zfCalc_UserAdmin());
