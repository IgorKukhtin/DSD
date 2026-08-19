-- Function: gpSelect_MovementItem_OrderRK()

 DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderRK (Integer, Boolean, TVarChar); 
 DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderRK (Integer, Boolean, Boolean, TVarChar); 
 
CREATE OR REPLACE FUNCTION gpSelect_MovementItem_OrderRK(
    IN inMovementId  Integer      , -- ключ Документа 
    IN inShowAll     Boolean      , --
    IN inisErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Key TVarChar 
             , Id Integer, LineNum Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar             
             , MeasureName TVarChar 
             , GoodsKindId Integer, GoodsKindName  TVarChar
             , GoodsId_in Integer, GoodsCode_in Integer, GoodsName_in TVarChar
             , GoodsKindId_in Integer, GoodsKindName_in TVarChar
             , Amount TFloat
             , AmountTotal  TFloat
             , Amount_order TFloat
             , Amount_diff  TFloat
             , isErased Boolean
             )
AS
$BODY$
  DECLARE vbUserId           Integer;
          vbMovementId_Order Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderRK());
     vbUserId:= lpGetUserBySession (inSession);

     vbMovementId_Order := (SELECT Movement.ParentId FROM Movement WHERE Movement.Id = inMovementId);
     -- Результат
     RETURN QUERY

       WITH 
       tmpMI AS (SELECT MovementItem.Id                               AS Id
                      , MovementItem.Amount                           AS Amount
                      , MovementItem.ObjectId                         AS ObjectId
                      , MovementItem.isErased                         AS isErased
                 FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                      INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                 )



     , tmpMILO_GoodsKind AS (SELECT MovementItemLinkObject.*
                             FROM MovementItemLinkObject
                             WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                               AND MovementItemLinkObject.DescId IN (zc_MILinkObject_GoodsKind())
                            )
     , tmpMILO_Goods_in AS (SELECT MovementItemLinkObject.*
                             FROM MovementItemLinkObject
                             WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                               AND MovementItemLinkObject.DescId IN (zc_MILinkObject_Goods_in())
                            )
     , tmpMILO_GoodsKind_in AS (SELECT MovementItemLinkObject.*
                                FROM MovementItemLinkObject
                                WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                  AND MovementItemLinkObject.DescId IN (zc_MILinkObject_GoodsKind_in())
                               )

     , tmpMI_all AS (SELECT MovementItem.Id
                          , MovementItem.ObjectId
                          , MovementItem.Amount
                          , MovementItem.isErased
                          , MILinkObject_GoodsKind.ObjectId AS GoodsKindId
                     FROM tmpMI AS MovementItem
                          LEFT JOIN tmpMILO_GoodsKind AS MILinkObject_GoodsKind
                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                     )

     --на показать все показываем товары из OrderExternal
     , tmpMI_order AS (WITH
                       tmpMI AS (SELECT MovementItem.Id
                                      , MovementItem.ObjectId 
                                      , MovementItem.Amount
                                 FROM MovementItem
                                 WHERE MovementItem.MovementId = vbMovementId_Order
                                  AND MovementItem.DescId     = zc_MI_Master()
                                  AND MovementItem.isErased   = False
                                 )
 
                     , tmpMILO_GoodsKind_order AS (SELECT MovementItemLinkObject.*
                                                   FROM MovementItemLinkObject
                                                   WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                                     AND MovementItemLinkObject.DescId IN (zc_MILinkObject_GoodsKind())
                                                   )

                     , tmpMI_Float_order AS (SELECT MovementItemFloat.*
                                             FROM MovementItemFloat
                                             WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                               AND MovementItemFloat.DescId IN (zc_MIFloat_AmountSecond())
                                            )

                      SELECT MovementItem.ObjectId                         AS GoodsId
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                           , (COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData,0)) AS Amount
                      FROM tmpMI AS MovementItem
                           LEFT JOIN tmpMILO_GoodsKind_order AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                           LEFT JOIN tmpMI_Float_order AS MIFloat_AmountSecond
                                                       ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                      )
     
     , tmpGoods_Param AS (SELECT tmp.GoodsId
                              , Object_Measure.ValueData       AS MeasureName
                              , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                        FROM (SELECT DISTINCT tmpMI.ObjectId AS GoodsId FROM tmpMI
                          UNION 
                              SELECT DISTINCT tmpMI_order.GoodsId AS GoodsId FROM tmpMI_order
                              ) AS tmp
                             LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                                    ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmp.GoodsId
                                                   AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

                            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                 ON ObjectLink_Goods_Measure.ObjectId = tmp.GoodsId
                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
                       )
 
 
     -- все задания по Заявке vbMovementId_Order
     , tmpOrderRK_Total AS (WITH
                            tmpMovement AS (SELECT Movement.*
                                            FROM Movement 
                                            WHERE Movement.ParentId = vbMovementId_Order
                                              AND Movement.DescId = zc_Movement_OrderRK()
                                              AND Movement.StatusId <> zc_Enum_Status_Erased()   --= zc_Enum_Status_Complete()
                                              --AND Movement.Id <> inMovementId
                                            )
                          , tmpMI AS (SELECT MovementItem.Id
                                           , MovementItem.Amount
                                           , MovementItem.ObjectId
                                      FROM MovementItem
                                      WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                        AND MovementItem.DescId     = zc_MI_Master()
                                        AND MovementItem.isErased   = FALSE
                                        AND COALESCE (MovementItem.Amount,0) <> 0
                                      )
                          , tmpMILO_GoodsKind AS (SELECT MovementItemLinkObject.*
                                                  FROM MovementItemLinkObject
                                                  WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                                    AND MovementItemLinkObject.DescId IN (zc_MILinkObject_GoodsKind())
                                                 )
                            SELECT MovementItem.ObjectId                  AS GoodsId
                                 , COALESCE (MILinkObject_GoodsKind.ObjectId,0)        AS GoodsKindId 
                                 , SUM (COALESCE (MovementItem.Amount,0)) AS Amount
                            FROM tmpMI AS MovementItem
                                 LEFT JOIN tmpMILO_GoodsKind AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                            GROUP BY MovementItem.ObjectId
                                   , COALESCE (MILinkObject_GoodsKind.ObjectId,0)  
                            )
     
     
       SELECT (MovementItem.ObjectId||'_'||COALESCE (MovementItem.GoodsKindId,0)) ::TVarChar AS Key
            , MovementItem.Id                   :: Integer AS Id
            , ROW_NUMBER() OVER (Order BY MovementItem.Id)  ::Integer AS LineNum
            , Object_Goods.Id                              AS GoodsId
            , Object_Goods.ObjectCode                      AS GoodsCode
            , Object_Goods.ValueData                       AS GoodsName
            , tmpGoods_Param.GoodsGroupNameFull ::TVarChar AS GoodsGroupNameFull
            , tmpGoods_Param.MeasureName        ::TVarChar AS MeasureName
            , COALESCE (Object_GoodsKind.Id, 0)            AS GoodsKindId
            , Object_GoodsKind.ValueData                   AS GoodsKindName

            , Object_Goods_in.Id                   AS GoodsId_in
            , Object_Goods_in.ObjectCode           AS GoodsCode_in
            , Object_Goods_in.ValueData            AS GoodsName_in
            , COALESCE (Object_GoodsKind_in.Id, 0) AS GoodsKindId_in
            , Object_GoodsKind_in.ValueData        AS GoodsKindName_in

            , MovementItem.Amount        :: TFloat AS Amount
            , tmpOrderRK_Total.Amount    ::TFloat AS AmountTotal  --
            , tmpMI_order.Amount  ::TFloat  AS Amount_order
            , (COALESCE (tmpOrderRK_Total.Amount,0) - COALESCE (tmpMI_order.Amount,0) ) ::TFloat AS Amount_diff  -- 
            , MovementItem.isErased                AS isErased

       FROM tmpMI_all AS MovementItem
           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
           LEFT JOIN tmpGoods_Param ON tmpGoods_Param.GoodsId = MovementItem.ObjectId

           LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MovementItem.GoodsKindId

           LEFT JOIN tmpMILO_Goods_in AS MILinkObject_Goods_in
                                      ON MILinkObject_Goods_in.MovementItemId = MovementItem.Id
                                     AND MILinkObject_Goods_in.DescId = zc_MILinkObject_Goods_in()
           LEFT JOIN Object AS Object_Goods_in ON Object_Goods_in.Id = MILinkObject_Goods_in.ObjectId

           LEFT JOIN tmpMILO_GoodsKind_in AS MILinkObject_GoodsKind_in
                                          ON MILinkObject_GoodsKind_in.MovementItemId = MovementItem.Id
                                         AND MILinkObject_GoodsKind_in.DescId = zc_MILinkObject_GoodsKind_in()
           LEFT JOIN Object AS Object_GoodsKind_in ON Object_GoodsKind_in.Id = MILinkObject_GoodsKind_in.ObjectId 

           --Данные из заявки
           LEFT JOIN tmpMI_order ON tmpMI_order.GoodsId = MovementItem.ObjectId
                                AND COALESCE (tmpMI_order.GoodsKindId,0) = COALESCE (MovementItem.GoodsKindId,0)
           --Данные из всех заданий для текущей заявки
           LEFT JOIN tmpOrderRK_Total ON tmpOrderRK_Total.GoodsId = MovementItem.ObjectId
                                     AND COALESCE (tmpOrderRK_Total.GoodsKindId,0) = COALESCE (MovementItem.GoodsKindId,0)

     UNION
       SELECT (Object_Goods.Id||'_'||COALESCE (Object_GoodsKind.Id, 0)) ::TVarChar AS Key
            , 0 ::Integer AS Id
            , 0 ::Integer AS LineNum
            , Object_Goods.Id                              AS GoodsId
            , Object_Goods.ObjectCode                      AS GoodsCode
            , Object_Goods.ValueData                       AS GoodsName
            , tmpGoods_Param.GoodsGroupNameFull ::TVarChar AS GoodsGroupNameFull
            , tmpGoods_Param.MeasureName        ::TVarChar AS MeasureName
            , COALESCE (Object_GoodsKind.Id, 0)            AS GoodsKindId
            , Object_GoodsKind.ValueData                   AS GoodsKindName

            , 0                   AS GoodsId_in
            , 0                   AS GoodsCode_in
            , '' ::TVarChar       AS GoodsName_in
            , 0                   AS GoodsKindId_in
            , '' ::TVarChar       AS GoodsKindName_in

            , 0  ::TFloat         AS Amount 
            , tmpOrderRK_Total.Amount    ::TFloat AS AmountTotal  --
            , tmpMI_order.Amount         ::TFloat AS Amount_order
            , (COALESCE (tmpOrderRK_Total.Amount,0) - COALESCE (tmpMI_order.Amount,0)) ::TFloat AS Amount_diff  -- 
            , FALSE                AS isErased
       FROM tmpMI_order
           LEFT JOIN tmpMI_all ON tmpMI_all.ObjectId = tmpMI_order.GoodsId
                              AND COALESCE (tmpMI_all.GoodsKindId,0) = COALESCE (tmpMI_order.GoodsKindId,0)

           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI_order.GoodsId
           LEFT JOIN tmpGoods_Param ON tmpGoods_Param.GoodsId = tmpMI_order.GoodsId

           LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI_order.GoodsKindId

           --Данные из всех заданий для текущей заявки
           LEFT JOIN tmpOrderRK_Total ON tmpOrderRK_Total.GoodsId = tmpMI_order.GoodsId
                                     AND COALESCE (tmpOrderRK_Total.GoodsKindId,0) = COALESCE (tmpMI_order.GoodsKindId,0)
                                     AND tmpMI_all.Id IS NULL
       WHERE tmpMI_all.Id IS NULL
         AND inShowAll = TRUE
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.08.26         *
*/

-- тест
--select * from gpSelect_MovementItem_OrderRK(inMovementId := 18298048 , inShowAll := 'true'  , inIsErased := 'False' ,inSession := '5')


--(SELECT Movement.ParentId FROM Movement WHERE Movement.Id = 18298048);
