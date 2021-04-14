-- Function: gpSelect_MI_Invoice_Child()

DROP FUNCTION IF EXISTS gpSelect_MI_OrderPartner_Child (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_OrderPartner_Child(
    IN inMovementId       Integer      , -- ключ Документа
    IN inIsErased         Boolean      , --
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, OperDate TDateTime, Invnumber TVarChar, StatusCode Integer
             , ProductId Integer, ProductName TVarChar, BrandId Integer, BrandName TVarChar, CIN TVarChar
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
                              , Movement.StatusId
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
           , Object_Status.ObjectCode AS StatusCode
           , Object_Product.Id                          AS ProductId
           , CASE WHEN Object_Product.isErased = TRUE THEN '--- ' || Object_Product.ValueData ELSE Object_Product.ValueData END :: TVarChar AS ProductName
           , Object_Brand.Id                            AS BrandId
           , Object_Brand.ValueData                     AS BrandName
           , ObjectString_CIN.ValueData                 AS CIN

           , MovementItem.Id                          AS Id
           , Object_Goods.Id                          AS GoodsId
           , Object_Goods.ObjectCode                  AS GoodsCode
           , Object_Goods.ValueData                   AS GoodsName
           , MovementItem.Amount             ::TFloat AS Amount            --Количество резерв
           , MIFloat_AmountPartner.ValueData ::TFloat AS AmountPartner     --Количество заказ поставщику
           , MIFloat_OperPrice.ValueData     ::TFloat AS OperPrice         -- Цена вх без НДС
           , MovementItem.isErased

           , ObjectString_Article.ValueData AS Article
           , Object_PartionGoods.EKPrice
                           
       FROM tmpOrderClient AS MovementItem
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
            LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = MovementItem.PartionId
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = MovementItem.StatusId

            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
            LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                        ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()

            LEFT JOIN ObjectString AS ObjectString_Article
                                   ON ObjectString_Article.ObjectId = Object_Goods.Id
                                  AND ObjectString_Article.DescId = zc_ObjectString_Article()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                         ON MovementLinkObject_Product.MovementId = MovementItem.MovementId
                                        AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
            LEFT JOIN Object AS Object_Product  ON Object_Product.Id = MovementLinkObject_Product.ObjectId

            --
            LEFT JOIN ObjectString AS ObjectString_CIN
                                   ON ObjectString_CIN.ObjectId = Object_Product.Id
                                  AND ObjectString_CIN.DescId = zc_ObjectString_Product_CIN()
            LEFT JOIN ObjectLink AS ObjectLink_Brand
                                 ON ObjectLink_Brand.ObjectId = Object_Product.Id
                                AND ObjectLink_Brand.DescId = zc_ObjectLink_Product_Brand()
            LEFT JOIN Object AS Object_Brand ON Object_Brand.Id = ObjectLink_Brand.ChildObjectId
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
