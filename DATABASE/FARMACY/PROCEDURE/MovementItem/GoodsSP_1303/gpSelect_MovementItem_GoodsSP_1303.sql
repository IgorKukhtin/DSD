 -- Function: gpSelect_MovementItem_GoodsSP_1303()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_GoodsSP_1303 (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_GoodsSP_1303(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id            Integer
             , GoodsId       Integer
             , GoodsCode     Integer
             , GoodsName     TVarChar
             , PriceOptSP    TFloat
             , PriceSale     TFloat
             , isErased      Boolean
             )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_GoodsSP_1303());
    vbUserId:= lpGetUserBySession (inSession);

    IF inShowAll THEN
    
    RETURN QUERY
    WITH 
        tmpGoodsMain AS (SELECT ObjectBoolean_Goods_isMain.ObjectId AS Id
                         FROM ObjectBoolean AS ObjectBoolean_Goods_isMain 
                              INNER JOIN Object AS Object_Goods 
                                                ON Object_Goods.Id = ObjectBoolean_Goods_isMain.ObjectId
                                               AND (Object_Goods.isErased = inIsErased OR inIsErased = TRUE)
                         WHERE ObjectBoolean_Goods_isMain.DescId = zc_ObjectBoolean_Goods_isMain()
                         )

        SELECT COALESCE (MovementItem.Id, 0)                         AS Id
             , Object_Goods.      Id                                 AS GoodsId
             , Object_Goods.ObjectCode                    ::Integer  AS GoodsCode
             , Object_Goods.ValueData                                AS GoodsName

             , MIFloat_PriceOptSP.ValueData                          AS PriceOptSP
             , MovementItem.Amount                                   AS PriceSale

             , COALESCE (MovementItem.isErased, FALSE)    ::Boolean  AS isErased

        FROM tmpGoodsMain
             LEFT JOIN MovementItem ON MovementItem.ObjectId = tmpGoodsMain.Id
                                   AND MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId = zc_MI_Master()
                                   AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
                                       
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoodsMain.Id
             
             LEFT JOIN MovementItemFloat AS MIFloat_PriceOptSP
                                         ON MIFloat_PriceOptSP.MovementItemId = MovementItem.Id
                                        AND MIFloat_PriceOptSP.DescId = zc_MIFloat_PriceOptSP()
            ;

    ELSE
    
    RETURN QUERY

        SELECT MovementItem.Id                                       AS Id
             , MovementItem.ObjectId                                 AS GoodsId
             , Object_Goods.ObjectCode                    ::Integer  AS GoodsCode
             , Object_Goods.ValueData                                AS GoodsName

             , MIFloat_PriceOptSP.ValueData                          AS PriceOptSP
             , MovementItem.Amount                                   AS PriceSale

             , COALESCE (MovementItem.isErased, FALSE)    ::Boolean  AS isErased

        FROM MovementItem
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
            
            LEFT JOIN MovementItemFloat AS MIFloat_PriceOptSP
                                        ON MIFloat_PriceOptSP.MovementItemId = MovementItem.Id
                                       AND MIFloat_PriceOptSP.DescId = zc_MIFloat_PriceOptSP()

         WHERE MovementItem.DescId = zc_MI_Master()
           AND MovementItem.MovementId = inMovementId
           AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
         ;
    END IF;            

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.04.22                                                       *
*/

--ТЕСТ
-- SELECT * FROM gpSelect_MovementItem_GoodsSP_1303 (inMovementId:= 0, inShowAll:= true, inIsErased:= FALSE, inSession:= '3')