-- Function: gpSelect_MI_Invoice_Child()

DROP FUNCTION IF EXISTS gpSelect_MI_OrderPartner_Child (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_OrderPartner_Child(
    IN inMovementId       Integer      , -- ключ Документа
    IN inIsErased         Boolean      , --
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, OperDate TDateTime, Invnumber TVarChar
             , Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat, AmountPartner TFloat
             , OperPrice TFloat
             , isErased Boolean
             , Article TVarChar
             , GoodsGroupNameFull TVarChar
             , GoodsGroupName TVarChar
             , EKPrice        TFloat -- Цена вх.
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры

     vbUserId:= lpGetUserBySession (inSession);

      RETURN QUERY
      WITH
      tmpOrderClient AS (SELECT MovementItem.MovementId
                              , Movement.OperDate
                              , Movement.Invnumber
                              , MovementItem.Id
                              , MovementItem.ObjectId
                              , MovementItem.PartionId
                              , MovementItem.Amount
                              , MovementItem.isErased

                         FROM MovementItemFloat
                              INNER JOIN MovementItem ON MovementItem.Id = MovementItemFloat.MovementItemId
                                                     AND MovementItem.DescId = zc_MI_Child()
                                                     AND (MovementItem.isErased = False OR inIsErased = TRUE)
                              INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                 AND Movement.DescId= zc_Movement_OrderClient()
                         WHERE MovementItemFloat.DescId = zc_MIFloat_MovementId()
                           AND MovementItemFloat.ValueData ::Integer = inMovementId
                         )

        SELECT
             MovementItem.MovementId
           , MovementItem.OperDate
           , MovementItem.Invnumber
           , MovementItem.Id                          AS Id
           , Object_Goods.Id                          AS GoodsId
           , Object_Goods.ObjectCode                  AS GoodsCode
           , Object_Goods.ValueData                   AS GoodsName
           , MovementItem.Amount             ::TFloat AS Amount            --Количество резерв
           , MIFloat_AmountPartner.ValueData ::TFloat AS AmountPartner     --Количество заказ поставщику
           , MIFloat_OperPrice.ValueData     ::TFloat AS OperPrice         -- Цена вх без НДС
           , MovementItem.isErased

           , ObjectString_Article.ValueData AS Article
           , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroup.ValueData    AS GoodsGroupName
           , Object_PartionGoods.EKPrice
                           
       FROM tmpOrderClient AS MovementItem
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
            LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = MovementItem.PartionId

            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
            LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                        ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()

            LEFT JOIN ObjectString AS ObjectString_Article
                                   ON ObjectString_Article.ObjectId = Object_Goods.Id
                                  AND ObjectString_Article.DescId = zc_ObjectString_Article()
            LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                   ON ObjectString_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
            --
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = Object_PartionGoods.GoodsGroupId
           ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И. 
 12.04.21         *
*/

-- тест
-- SELECT * from gpSelect_MI_OrderPartner_Child (0,False, '3');
