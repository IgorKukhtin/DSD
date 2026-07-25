-- Function: gpSelect_MI_SaleCommerc_Child (Integer, Boolean, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_MI_SaleCommerc_Child (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_SaleCommerc_Child(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , MeasureName TVarChar, TradeMarkName TVarChar
             , GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsGroupPropertyName TVarChar, GoodsGroupPropertyName_Parent TVarChar
           
             , Amount TFloat, Summ TFloat
             , AmountPromo TFloat, SummPromo TFloat
             , AmountNoPromo TFloat, SummNoPromo TFloat
             , Bonus TFloat, Price TFloat
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SaleCommerc());
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY 
       SELECT
             MovementItem.Id
           , MovementItem.ParentId
           , Object_Goods.Id                             AS GoodsId
           , Object_Goods.ObjectCode                     AS GoodsCode
           , Object_Goods.ValueData                      AS GoodsName
           , Object_GoodsKind.Id                         AS GoodsKindId
           , Object_GoodsKind.ValueData                  AS GoodsKindName 

           , Object_Measure.ValueData                    AS MeasureName
           , Object_TradeMark.ValueData                  AS TradeMarkName           
           , Object_GoodsGroup.ValueData                 AS GoodsGroupName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroupProperty.ValueData         AS GoodsGroupPropertyName
           , Object_GoodsGroupPropertyParent.ValueData   AS GoodsGroupPropertyName_Parent

           , MovementItem.Amount                           ::TFloat AS Amount
           , COALESCE (MIFloat_Summ.ValueData, 0)          ::TFloat AS Summ
           , COALESCE (MIFloat_AmountPromo.ValueData, 0)   ::TFloat AS AmountPromo
           , COALESCE (MIFloat_SummPromo.ValueData, 0)     ::TFloat AS SummPromo
           , COALESCE (MIFloat_AmountNoPromo.ValueData, 0) ::TFloat AS AmountNoPromo
           , COALESCE (MIFloat_SummNoPromo.ValueData, 0)   ::TFloat AS SummNoPromo
           , COALESCE (MIFloat_Bonus.ValueData, 0)         ::TFloat AS Bonus
           , COALESCE (MIFloat_Price.ValueData, 0)         ::TFloat AS Price

           , MovementItem.isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Child()
                             AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id =  MovementItem.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                        ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                       AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountPromo
                                        ON MIFloat_AmountPromo.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPromo.DescId = zc_MIFloat_AmountPromo()
            LEFT JOIN MovementItemFloat AS MIFloat_SummPromo
                                        ON MIFloat_SummPromo.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummPromo.DescId = zc_MIFloat_SummPromo()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountNoPromo
                                        ON MIFloat_AmountNoPromo.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountNoPromo.DescId = zc_MIFloat_AmountNoPromo()
            LEFT JOIN MovementItemFloat AS MIFloat_SummNoPromo
                                        ON MIFloat_SummNoPromo.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummNoPromo.DescId = zc_MIFloat_SummNoPromo()
            LEFT JOIN MovementItemFloat AS MIFloat_Bonus
                                        ON MIFloat_Bonus.MovementItemId = MovementItem.Id
                                       AND MIFloat_Bonus.DescId = zc_MIFloat_Bonus()
            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()

            --
            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                 ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
            LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupProperty
                                 ON ObjectLink_Goods_GoodsGroupProperty.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsGroupProperty.DescId = zc_ObjectLink_Goods_GoodsGroupProperty()
            LEFT JOIN Object AS Object_GoodsGroupProperty ON Object_GoodsGroupProperty.Id = ObjectLink_Goods_GoodsGroupProperty.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_GoodsGroupProperty_Parent
                                 ON ObjectLink_GoodsGroupProperty_Parent.ObjectId = Object_GoodsGroupProperty.Id
                                AND ObjectLink_GoodsGroupProperty_Parent.DescId = zc_ObjectLink_GoodsGroupProperty_Parent()
            LEFT JOIN Object AS Object_GoodsGroupPropertyParent ON Object_GoodsGroupPropertyParent.Id = ObjectLink_GoodsGroupProperty_Parent.ChildObjectId
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.07.26         * 
 
*/

-- тест
-- SELECT * FROM gpSelect_MI_SaleCommerc_Child (inMovementId:= 34853167 , inIsErased:= false, inSession:= '2')