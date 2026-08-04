-- Function: gpSelect_MovementItem_OrderRK()

 DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderRK (Integer, Boolean, TVarChar); 
 
CREATE OR REPLACE FUNCTION gpSelect_MovementItem_OrderRK(
    IN inMovementId  Integer      , -- ключ Документа
    IN inisErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, LineNum Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar             
             , MeasureName TVarChar 
             , GoodsKindId Integer, GoodsKindName  TVarChar
             , GoodsId_in Integer, GoodsCode_in Integer, GoodsName_in TVarChar
             , GoodsKindId_in Integer, GoodsKindName_in TVarChar
             , Amount TFloat
             , isErased Boolean
             )
AS
$BODY$
  DECLARE vbUserId          Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderRK());
     vbUserId:= lpGetUserBySession (inSession);

   
     -- Результат
     RETURN QUERY

       WITH 
       tmpMI AS (SELECT MovementItem.Id                               AS Id
                      , MovementItem.Amount                           AS Amount
                      , MovementItem.ObjectId                         AS GoodsId
                      , MovementItem.isErased                         AS isErased
                 FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                      INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                 )

     , tmpGoods_Param AS (SELECT tmp.GoodsId
                               , Object_Measure.ValueData       AS MeasureName
                               , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                         FROM (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI) AS tmp
                              LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                                     ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmp.GoodsId
                                                    AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

                             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                  ON ObjectLink_Goods_Measure.ObjectId = tmp.GoodsId
                                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
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
        SELECT
             MovementItem.Id                  :: Integer AS Id
           , ROW_NUMBER() OVER (Order BY MovementItem.Id)  ::Integer AS LineNum
           , Object_Goods.Id                             AS GoodsId
           , Object_Goods.ObjectCode                     AS GoodsCode
           , Object_Goods.ValueData                      AS GoodsName
           , tmpGoods_Param.GoodsGroupNameFull ::TVarChar AS GoodsGroupNameFull
           , tmpGoods_Param.MeasureName        ::TVarChar AS MeasureName
           , COALESCE (Object_GoodsKind.Id, 0)           AS GoodsKindId
           , Object_GoodsKind.ValueData                  AS GoodsKindName

           , Object_Goods_in.Id                   AS GoodsId_in
           , Object_Goods_in.ObjectCode           AS GoodsCode_in
           , Object_Goods_in.ValueData            AS GoodsName_in
           , COALESCE (Object_GoodsKind_in.Id, 0) AS GoodsKindId_in
           , Object_GoodsKind_in.ValueData        AS GoodsKindName_in

           , MovementItem.Amount        :: TFloat AS Amount
           , MovementItem.isErased                AS isErased

       FROM tmpMI AS MovementItem
           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.GoodsId
           LEFT JOIN tmpGoods_Param ON tmpGoods_Param.GoodsId = MovementItem.GoodsId

           LEFT JOIN tmpMILO_GoodsKind AS MILinkObject_GoodsKind
                                       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                      AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
           LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

           LEFT JOIN tmpMILO_Goods_in AS MILinkObject_Goods_in
                                      ON MILinkObject_Goods_in.MovementItemId = MovementItem.Id
                                     AND MILinkObject_Goods_in.DescId = zc_MILinkObject_Goods_in()
           LEFT JOIN Object AS Object_Goods_in ON Object_Goods_in.Id = MILinkObject_Goods_in.ObjectId

           LEFT JOIN tmpMILO_GoodsKind_in AS MILinkObject_GoodsKind_in
                                          ON MILinkObject_GoodsKind_in.MovementItemId = MovementItem.Id
                                         AND MILinkObject_GoodsKind_in.DescId = zc_MILinkObject_GoodsKind_in()
           LEFT JOIN Object AS Object_GoodsKind_in ON Object_GoodsKind_in.Id = MILinkObject_GoodsKind_in.ObjectId
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
-- select * from gpSelect_MovementItem_OrderRK(inMovementId := 18298048 , inIsErased := 'False' ,inSession := '5')
