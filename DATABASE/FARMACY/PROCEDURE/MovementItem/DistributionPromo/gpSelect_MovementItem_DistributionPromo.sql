-- Function: gpSelect_MovementItem_DistributionPromo()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_DistributionPromo (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_DistributionPromo(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsGroupId Integer, GoodsGroupCode Integer, GoodsGroupName TVarChar
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
                                  , MI_PromoCode.ObjectId AS GoodsGroupId
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

            SELECT COALESCE(MI_PromoCode.Id,0)                AS Id
                 , Object_GoodsGroup.Id                       AS GoodsGroupId
                 , Object_GoodsGroup.ObjectCode               AS GoodsGroupCode
                 , Object_GoodsGroup.ValueData                AS GoodsGroupName
                 , COALESCE (MI_PromoCode.Comment, '') :: TVarChar AS Comment
                 , CASE WHEN MI_PromoCode.Amount = 1 THEN TRUE ELSE FALSE END AS IsChecked
                 , COALESCE(MI_PromoCode.IsErased,FALSE) AS isErased
            FROM Object AS Object_GoodsGroup
                FULL OUTER JOIN MI_PromoCode ON MI_PromoCode.GoodsGroupId = Object_GoodsGroup.Id
            WHERE Object_GoodsGroup.isErased = FALSE 
              AND Object_GoodsGroup.DescId   = zc_Object_GoodsGroup()
               OR MI_PromoCode.Id IS NOT NULL;
    ELSE
        -- Результат другой
        RETURN QUERY

           SELECT MI_PromoCode.Id
                , MI_PromoCode.ObjectId          AS GoodsGroupId
                , Object_GoodsGroup.ObjectCode   AS GoodsGroupCode
                , Object_GoodsGroup.ValueData    AS GoodsGroupName
                , MIString_Comment.ValueData ::TVarChar AS Comment
                , CASE WHEN MI_PromoCode.Amount = 1 THEN TRUE ELSE FALSE END AS IsChecked
                , MI_PromoCode.IsErased
           FROM MovementItem AS MI_PromoCode
                LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = MI_PromoCode.ObjectId  
   
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
 02.12.20                                                       *
*/

-- select * from gpSelect_MovementItem_DistributionPromo(inMovementId := 0 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3'::TVarChar);