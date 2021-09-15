-- Function: gpSelect_MI_OrderGoodsDetail_Child()

DROP FUNCTION IF EXISTS gpSelect_MI_OrderGoodsDetail_Child (Integer, Boolean, TVarChar); 
  
CREATE OR REPLACE FUNCTION gpSelect_MI_OrderGoodsDetail_Child(
    IN inParentId    Integer      , -- ключ Документа
    IN inisErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , ParentId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindName TVarChar
             , GoodsGroupNameFull TVarChar             
             , MeasureName TVarChar
             , PartionGoods TDateTime
             , Amount TFloat     
             , isErased Boolean
             )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderGoodsDetail());
     vbUserId:= lpGetUserBySession (inSession);
     -- Результат другой
     RETURN QUERY

     SELECT MovementItem.Id
          , MovementItem.ParentId
          , Object_Goods.Id          		AS GoodsId
          , Object_Goods.ObjectCode  		AS GoodsCode
          , Object_Goods.ValueData   		AS GoodsName
          , Object_GoodsKind.ValueData          AS GoodsKindName
          , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
          , Object_Measure.ValueData            AS MeasureName
          , MIDate_PartionGoods.ValueData       AS PartionGoods          
          , MovementItem.Amount :: TFloat       AS Amount
          , MovementItem.isErased               AS isErased
     FROM MovementItem
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

          LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                     ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                    AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

          LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                           ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                          AND MILO_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILO_GoodsKind.ObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                 ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId =  Object_Goods.Id
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

     WHERE MovementItem.ParentId = inParentId
       AND MovementItem.DescId   = zc_MI_Child()
       AND (MovementItem.isErased = FALSE OR inisErased = TRUE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.09.21         *
*/

-- тест
-- select * from gpSelect_MI_OrderGoodsDetail_Child(inParentId := 18298048 , inisErased:=FALSE , inSession := '5')
