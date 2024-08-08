-- Function: gpSelect_MI_ChangePercent_Child()

DROP FUNCTION IF EXISTS gpSelect_MI_ChangePercent_Child (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_ChangePercent_Child(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId Integer, LineNum Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName  TVarChar, MeasureName TVarChar
             , UnitId Integer, UnitName TVarChar
             , Amount TFloat, Amount_master TFloat, Amount_diff TFloat
             , isErased Boolean
             )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
     WITH
         tmpMI AS (SELECT MAX (MovementItem.Id)                 AS Id
                        , MovementItem.ParentId                 AS ParentId
                        , MovementItem.ObjectId                 AS GoodsId
                        , MAX (MILinkObject_GoodsKind.ObjectId) AS GoodsKindId
                        , MILinkObject_Unit.ObjectId            AS UnitId
                        , SUM (MovementItem.Amount)             AS Amount
                        , MovementItem.isErased                 AS isErased
                   FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                        INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                               AND MovementItem.DescId     = zc_MI_Child()
                                               AND MovementItem.isErased   = tmpIsErased.isErased
            
                        LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                         ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                        AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                        LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                         ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                        AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                   GROUP BY MovementItem.ParentId
                          , MovementItem.ObjectId
                          , MILinkObject_Unit.ObjectId
                          , MovementItem.isErased
                  )

         --сохраненные строки мастера
         , tmpMI_Master AS (SELECT MovementItem.*
                            FROM MovementItem
                            WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId = zc_MI_Master()
                              AND MovementItem.isErased = FALSE
                            )

       --
       SELECT
             tmpMI.Id        :: Integer AS Id
           , tmpMI.ParentId  :: Integer AS ParentId
           , CAST (ROW_NUMBER() OVER (ORDER BY tmpMI_Master.Id) AS Integer) AS LineNum
           , Object_Goods.Id            AS GoodsId
           , Object_Goods.ObjectCode    AS GoodsCode
           , Object_Goods.ValueData     AS GoodsName
           , Object_GoodsKind.Id        AS GoodsKindId
           , Object_GoodsKind.ValueData AS GoodsKindName
           , Object_Measure.ValueData   AS MeasureName
           
           , Object_Unit.Id             AS UnitId
           , Object_Unit.ValueData      AS UnitName
           , tmpMI.Amount     :: TFloat AS Amount
           , tmpMI_Master.Amount        AS Amount_master 
           , (COALESCE (tmpMI.Amount,0) - COALESCE (tmpMI_Master.Amount,0)) ::TFloat AS Amount_diff
           , tmpMI.isErased             AS isErased

       FROM tmpMI
            LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId
            LEFT JOIN Object AS Object_Unit      ON Object_Unit.Id = tmpMI.UnitId
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
            
            LEFT JOIN tmpMI_Master ON tmpMI_Master.Id = tmpMI.ParentId
            ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.04.23         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_ChangePercent_Child (inMovementId:= 25173, inIsErased:= TRUE, inSession:= '2')
