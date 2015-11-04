-- Function: gpSelect_MovementItem_PromoGoods()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_PromoGoods (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PromoGoods(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat, AmountRemains TFloat
             , Price TFloat, Summ TFloat
             , isErased Boolean
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbUnitId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_PromoGoods());
    vbUserId:= lpGetUserBySession (inSession);

    -- определяется подразделение
    SELECT 
        Movement_PromoGoods.UnitId
    INTO
        vbUnitId
    FROM 
        Movement_PromoGoods_View AS Movement_PromoGoods
    WHERE 
        Movement_PromoGoods.Id = inMovementId;

    -- Результат
    IF inShowAll THEN
        -- Результат такой
        RETURN QUERY
            WITH 
                tmpRemains AS(
                                SELECT 
                                    Container.ObjectId                  AS GoodsId
                                  , SUM(Container.Amount)::TFloat       AS Amount
                                FROM Container
                                WHERE Container.DescId = zc_Container_Count()
                                  AND Container.WhereObjectId = vbUnitId
                                  AND Container.Amount <> 0
                                GROUP BY 
                                    Container.ObjectId
                             )
               ,MovementItem_PromoGoods AS (
                                        SELECT 
                                            MI_PromoGoods.Id
                                           ,MI_PromoGoods.GoodsId
                                           ,MI_PromoGoods.Amount
                                           ,MI_PromoGoods.Price
                                           ,MI_PromoGoods.Summ
                                           ,MI_PromoGoods.IsErased
                                        FROM 
                                            MovementItem_PromoGoods_View AS MI_PromoGoods
                                        WHERE 
                                            MI_PromoGoods.MovementId = inMovementId
                                            AND
                                            (
                                                MI_PromoGoods.isErased = FALSE 
                                                or 
                                                inIsErased = TRUE
                                            )
                                     )
            SELECT
                COALESCE(MovementItem_PromoGoods.Id,0)                     AS Id
              , Object_Goods.Id                                      AS GoodsId
              , Object_Goods.GoodsCodeInt                            AS GoodsCode
              , Object_Goods.GoodsName                               AS GoodsName
              , MovementItem_PromoGoods.Amount                             AS Amount
              , tmpRemains.Amount::TFloat                            AS AmountRemains
              , COALESCE(MovementItem_PromoGoods.Price,Object_Price.Price) AS Price
              , MovementItem_PromoGoods.Summ                               AS Summ
              , COALESCE(MovementItem_PromoGoods.IsErased,FALSE)           AS isErased
            FROM tmpRemains
                FULL OUTER JOIN MovementItem_PromoGoods ON tmpRemains.GoodsId = MovementItem_PromoGoods.GoodsId
                LEFT JOIN Object_Goods_View AS Object_Goods ON Object_Goods.Id = COALESCE(MovementItem_PromoGoods.GoodsId,tmpRemains.GoodsId)
                LEFT OUTER JOIN Object_Price_View AS Object_Price
                                                  ON Object_Price.GoodsId = COALESCE(MovementItem_PromoGoods.GoodsId,tmpRemains.GoodsId)
                                                 AND Object_Price.UnitId = vbUnitId
            WHERE 
                Object_Goods.isErased = FALSE 
                or 
                MovementItem_PromoGoods.id is not null;
    ELSE
        -- Результат другой
        RETURN QUERY
            WITH
                tmpRemains AS(
                                SELECT 
                                    Container.ObjectId                  AS GoodsId
                                  , SUM(Container.Amount)::TFloat       AS Amount
                                FROM Container
                                WHERE Container.DescId = zc_Container_Count()
                                  AND Container.WhereObjectId = vbUnitId
                                  AND Container.Amount <> 0
                                GROUP BY 
                                    Container.ObjectId
                             )
               ,MovementItem_PromoGoods AS (
                                        SELECT 
                                            MI_PromoGoods.Id
                                           ,MI_PromoGoods.GoodsId
                                           ,MI_PromoGoods.GoodsCode
                                           ,MI_PromoGoods.GoodsName
                                           ,MI_PromoGoods.Amount
                                           ,MI_PromoGoods.Price
                                           ,MI_PromoGoods.Summ
                                           ,MI_PromoGoods.IsErased
                                        FROM 
                                            MovementItem_PromoGoods_View AS MI_PromoGoods
                                        WHERE 
                                            MI_PromoGoods.MovementId = inMovementId
                                            AND
                                            (
                                                MI_PromoGoods.isErased = FALSE 
                                                or 
                                                inIsErased = TRUE
                                            )
                                     )
            SELECT
                MovementItem_PromoGoods.Id          AS Id
              , MovementItem_PromoGoods.GoodsId     AS GoodsId
              , MovementItem_PromoGoods.GoodsCode   AS GoodsCode
              , MovementItem_PromoGoods.GoodsName   AS GoodsName
              , MovementItem_PromoGoods.Amount      AS Amount
              , tmpRemains.Amount::TFloat     AS AmountRemains
              , MovementItem_PromoGoods.Price       AS Price
              , MovementItem_PromoGoods.Summ        AS Summ
              , MovementItem_PromoGoods.IsErased    AS isErased
            FROM MovementItem_PromoGoods
                LEFT OUTER JOIN tmpRemains ON tmpRemains.GoodsId = MovementItem_PromoGoods.GoodsId;
     END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_PromoGoods (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.
 13.10.15                                                          *
*/