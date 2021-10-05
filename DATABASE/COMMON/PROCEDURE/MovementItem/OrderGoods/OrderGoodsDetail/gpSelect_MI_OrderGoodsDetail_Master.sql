-- Function: gpSelect_MI_OrderGoodsDetail_Master()


 DROP FUNCTION IF EXISTS gpSelect_MI_OrderGoodsDetail_Master (Integer, Boolean, Boolean, TVarChar); 
 
CREATE OR REPLACE FUNCTION gpSelect_MI_OrderGoodsDetail_Master(
    IN inParentId    Integer      , -- ключ Документа OrderGoods
    IN inisErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindName TVarChar
             , GoodsGroupNameFull TVarChar             
             , MeasureName TVarChar
             , Amount                   TFloat
             , Amount_sh                TFloat
             , Amount_kg                TFloat
             , AmountForecast           TFloat
             , AmountForecastOrder      TFloat
             , AmountForecastPromo      TFloat
             , AmountForecastOrderPromo TFloat
             , isErased Boolean
             )
AS
$BODY$
  DECLARE vbUserId          Integer;
  DECLARE vbMovement        Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderGoods());
     vbUserId:= lpGetUserBySession (inSession);

     vbMovement := (SELECT Movement.Id FROM Movement WHERE Movement.ParentId = inParentId AND Movement.DescId = zc_Movement_OrderGoodsDetail());
     
     -- Результат другой
     RETURN QUERY

       WITH 
           tmpMI AS (SELECT MovementItem.Id                               AS MovementItemId
                          , MovementItem.ParentId                         AS ParentId
                          , MovementItem.Amount                           AS Amount
                          , MovementItem.ObjectId                         AS GoodsId
                          , MovementItem.isErased                         AS isErased
                     FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                          INNER JOIN MovementItem ON MovementItem.MovementId = vbMovement-- MovementItem.ParentId = inParentId
                                                 AND MovementItem.DescId     = zc_MI_Master()
                                                 AND MovementItem.isErased   = tmpIsErased.isErased
                     )

        SELECT
             tmpMI.MovementItemId    :: Integer AS Id
           , tmpMI.ParentId                     AS ParentId
           , Object_Goods.Id          		AS GoodsId
           , Object_Goods.ObjectCode  		AS GoodsCode
           , Object_Goods.ValueData   		AS GoodsName
           , Object_GoodsKind.ValueData         AS GoodsKindName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData           AS MeasureName

           , tmpMI.Amount                               :: TFloat AS Amount
           , CAST (CASE WHEN Object_Measure.Id = zc_Measure_Sh() 
                        THEN tmpMI.Amount
                        ELSE 0
                   END  AS NUMERIC (16,0)) ::TFloat AS Amount_sh

           , CAST (CASE WHEN Object_Measure.Id = zc_Measure_Sh() 
                        THEN tmpMI.Amount * COALESCE (ObjectFloat_Weight.ValueData,1)
                        ELSE tmpMI.Amount
                   END  AS NUMERIC (16,0)) ::TFloat AS Amount_kg

           --, tmpMI.Amount ::TFloat AS Amount_kg --CASE WHEN  Object_Measure.Id <> zc_Measure_Sh() THEN tmpMI.Amount ELSE 0 END ::TFloat AS Amount_kg

           , MIFloat_AmountForecast.ValueData           :: TFloat AS AmountForecast
           , MIFloat_AmountForecastOrder.ValueData      :: TFloat AS AmountForecastOrder
           , MIFloat_AmountForecastPromo.ValueData      :: TFloat AS AmountForecastPromo
           , MIFloat_AmountForecastOrderPromo.ValueData :: TFloat AS AmountForecastOrderPromo

           , tmpMI.isErased             AS isErased

       FROM tmpMI
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId

            LEFT JOIN MovementItemFloat AS MIFloat_AmountForecast
                                        ON MIFloat_AmountForecast.MovementItemId = tmpMI.MovementItemId
                                       AND MIFloat_AmountForecast.DescId = zc_MIFloat_AmountForecast()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountForecastOrder
                                        ON MIFloat_AmountForecastOrder.MovementItemId = tmpMI.MovementItemId
                                       AND MIFloat_AmountForecastOrder.DescId = zc_MIFloat_AmountForecastOrder()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountForecastPromo
                                        ON MIFloat_AmountForecastPromo.MovementItemId = tmpMI.MovementItemId
                                       AND MIFloat_AmountForecastPromo.DescId = zc_MIFloat_AmountForecastPromo()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountForecastOrderPromo
                                        ON MIFloat_AmountForecastOrderPromo.MovementItemId = tmpMI.MovementItemId
                                       AND MIFloat_AmountForecastOrderPromo.DescId = zc_MIFloat_AmountForecastOrderPromo()


            LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                             ON MILO_GoodsKind.MovementItemId = tmpMI.MovementItemId
                                            AND MILO_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILO_GoodsKind.ObjectId


            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = tmpMI.GoodsId
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
           ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.09.21         *
*/

-- тест
-- select * from gpSelect_MI_OrderGoodsDetail_Master(inParentId := 18298048 , inIsErased := 'False' ,  inSession := '5')
