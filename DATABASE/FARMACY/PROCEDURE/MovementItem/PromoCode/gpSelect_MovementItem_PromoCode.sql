--

-- Function: gpSelect_MovementItem_Promo()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_PromoCode (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PromoCode(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat
             , Comment TVarChar
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
                
            tmpGoods AS (SELECT Object_Goods_View.Id
                              , Object_Goods_View.isErased
                              , Object_Goods_View.Price
                              , CASE WHEN Object_Goods_View.isSecond = TRUE THEN 16440317 WHEN Object_Goods_View.isFirst = TRUE THEN zc_Color_GreenL() ELSE zc_Color_White() END AS Color_calc   --10965163
                         FROM Object_Goods_View
                         WHERE Object_Goods_View.ObjectId = vbObjectId
                           AND (Object_Goods_View.isErased = FALSE OR (Object_Goods_View.isErased = TRUE AND inIsErased = TRUE))
                         )

           ,MI_PromoCode AS (SELECT MI_PromoCode.Id
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
                 , Object_Goods.ValueData                AS GoodsName
                 , MI_PromoCode.Amount                   AS Amount
                 , COALESCE (MI_PromoCode.Comment, '') :: TVarChar AS Comment
                 , COALESCE(MI_PromoCode.IsErased,FALSE) AS isErased
            FROM tmpGoods
                FULL OUTER JOIN MI_PromoCode ON MI_PromoCode.GoodsId = tmpGoods.Id
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = COALESCE(MI_PromoCode.GoodsId,tmpGoods.Id)
            WHERE Object_Goods.isErased = FALSE 
               OR MI_PromoCode.Id IS NOT NULL;
    ELSE
        -- Результат другой
        RETURN QUERY

           SELECT MI_PromoCode.Id
                , MI_PromoCode.ObjectId     AS GoodsId
                , Object_Goods.ObjectCode   AS GoodsCode
                , Object_Goods.ValueData    AS GoodsName
                , MI_PromoCode.Amount       ::TFloat 
                , MIString_Comment.ValueData ::TVarChar AS Comment
                , MI_PromoCode.IsErased
           FROM MovementItem AS MI_PromoCode
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MI_PromoCode.ObjectId  
   
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
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.
 13.12.17         *
*/

--select * from gpSelect_MovementItem_PromoCode(inMovementId := 0 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');