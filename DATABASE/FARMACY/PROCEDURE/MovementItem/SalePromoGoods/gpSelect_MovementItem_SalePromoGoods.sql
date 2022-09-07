-- Function: gpSelect_MovementItem_SalePromoGoods()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_SalePromoGoods (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_SalePromoGoods(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Comment TVarChar
             , IsChecked Boolean
             , isErased Boolean
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbObjectId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    -- поиск <Торговой сети>
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    -- Результат
    IF inShowAll THEN
        -- Результат такой
        RETURN QUERY
            WITH 
                
            MI_PromoCode AS (SELECT MI_PromoCode.Id
                                  , MI_PromoCode.ObjectId AS GoodsId
                                  , MI_PromoCode.Amount
                                  , MIString_Comment.ValueData ::TVarChar AS Comment
                                  , MI_PromoCode.IsErased
                             FROM MovementItem AS MI_PromoCode
                                  LEFT JOIN MovementItemString AS MIString_Comment
                                                               ON MIString_Comment.MovementItemId = MI_PromoCode.Id
                                                              AND MIString_Comment.DescId = zc_MIString_Comment()
                             WHERE MI_PromoCode.MovementId = inMovementId
                               AND MI_PromoCode.DescId = zc_MI_Master()
                               AND (MI_PromoCode.isErased = FALSE or inIsErased = TRUE)
                             )

            SELECT COALESCE(MI_PromoCode.Id,0)           AS Id
                 , Object_Goods.Id                       AS GoodsId
                 , Object_Goods.ObjectCode               AS GoodsCode
                 , Object_Goods.Name                     AS GoodsName
                 , COALESCE (MI_PromoCode.Comment, '') :: TVarChar AS Comment
                 , CASE WHEN MI_PromoCode.Amount = 1 THEN TRUE ELSE FALSE END AS IsChecked
                 , COALESCE(MI_PromoCode.IsErased,FALSE) AS isErased
            FROM Object_Goods_Main AS Object_Goods
                FULL OUTER JOIN MI_PromoCode ON MI_PromoCode.GoodsId = Object_Goods.Id
            WHERE Object_Goods.isErased = FALSE 
               OR MI_PromoCode.Id IS NOT NULL;
    ELSE
        -- Результат другой
        RETURN QUERY

           SELECT MI_PromoCode.Id
                , MI_PromoCode.ObjectId     AS GoodsId
                , Object_Goods.ObjectCode   AS GoodsCode
                , Object_Goods.Name         AS GoodsName
                , MIString_Comment.ValueData ::TVarChar AS Comment
                , CASE WHEN MI_PromoCode.Amount = 1 THEN TRUE ELSE FALSE END AS IsChecked
                , MI_PromoCode.IsErased
           FROM MovementItem AS MI_PromoCode
                LEFT JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = MI_PromoCode.ObjectId  
   
                LEFT JOIN MovementItemString AS MIString_Comment
                                             ON MIString_Comment.MovementItemId = MI_PromoCode.Id
                                            AND MIString_Comment.DescId = zc_MIString_Comment()                                    
           WHERE MI_PromoCode.MovementId = inMovementId
             AND MI_PromoCode.DescId = zc_MI_Master()
             AND (MI_PromoCode.isErased = FALSE or inIsErased = TRUE);
     END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.09.22                                                       *
*/

-- select * from gpSelect_MovementItem_SalePromoGoods(inMovementId := 0 , inShowAll := 'True' , inIsErased := 'False' ,  inSession := '3'::TVarChar);