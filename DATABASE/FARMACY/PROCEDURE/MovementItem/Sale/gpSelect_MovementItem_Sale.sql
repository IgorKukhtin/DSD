-- Function: gpSelect_MovementItem_Sale()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Sale (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Sale(
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
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Sale());
    vbUserId:= lpGetUserBySession (inSession);

    -- определяется подразделение
    SELECT 
        Movement_Sale.UnitId
    INTO
        vbUnitId
    FROM 
        Movement_Sale_View AS Movement_Sale
    WHERE 
        Movement_Sale.Id = inMovementId;

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
               ,MovementItem_Sale AS (
                                        SELECT 
                                            MI_Sale.Id
                                           ,MI_Sale.GoodsId
                                           ,MI_Sale.Amount
                                           ,MI_Sale.Price
                                           ,MI_Sale.Summ
                                           ,MI_Sale.IsErased
                                        FROM 
                                            MovementItem_Sale_View AS MI_Sale
                                        WHERE 
                                            MI_Sale.MovementId = inMovementId
                                            AND
                                            (
                                                MI_Sale.isErased = FALSE 
                                                or 
                                                inIsErased = TRUE
                                            )
                                     )
            SELECT
                COALESCE(MovementItem_Sale.Id,0)                     AS Id
              , Object_Goods.Id                                      AS GoodsId
              , Object_Goods.GoodsCodeInt                            AS GoodsCode
              , Object_Goods.GoodsName                               AS GoodsName
              , MovementItem_Sale.Amount                             AS Amount
              , tmpRemains.Amount::TFloat                            AS AmountRemains
              , COALESCE(MovementItem_Sale.Price,Object_Price.Price) AS Price
              , MovementItem_Sale.Summ                               AS Summ
              , COALESCE(MovementItem_Sale.IsErased,FALSE)           AS isErased
            FROM tmpRemains
                FULL OUTER JOIN MovementItem_Sale ON tmpRemains.GoodsId = MovementItem_Sale.GoodsId
                LEFT JOIN Object_Goods_View AS Object_Goods ON Object_Goods.Id = COALESCE(MovementItem_Sale.GoodsId,tmpRemains.GoodsId)
                LEFT OUTER JOIN Object_Price_View AS Object_Price
                                                  ON Object_Price.GoodsId = COALESCE(MovementItem_Sale.GoodsId,tmpRemains.GoodsId)
                                                 AND Object_Price.UnitId = vbUnitId
            WHERE 
                Object_Goods.isErased = FALSE 
                or 
                MovementItem_Sale.id is not null;
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
               ,MovementItem_Sale AS (
                                        SELECT 
                                            MI_Sale.Id
                                           ,MI_Sale.GoodsId
                                           ,MI_Sale.GoodsCode
                                           ,MI_Sale.GoodsName
                                           ,MI_Sale.Amount
                                           ,MI_Sale.Price
                                           ,MI_Sale.Summ
                                           ,MI_Sale.IsErased
                                        FROM 
                                            MovementItem_Sale_View AS MI_Sale
                                        WHERE 
                                            MI_Sale.MovementId = inMovementId
                                            AND
                                            (
                                                MI_Sale.isErased = FALSE 
                                                or 
                                                inIsErased = TRUE
                                            )
                                     )
            SELECT
                MovementItem_Sale.Id          AS Id
              , MovementItem_Sale.GoodsId     AS GoodsId
              , MovementItem_Sale.GoodsCode   AS GoodsCode
              , MovementItem_Sale.GoodsName   AS GoodsName
              , MovementItem_Sale.Amount      AS Amount
              , tmpRemains.Amount::TFloat     AS AmountRemains
              , MovementItem_Sale.Price       AS Price
              , MovementItem_Sale.Summ        AS Summ
              , MovementItem_Sale.IsErased    AS isErased
            FROM MovementItem_Sale
                LEFT OUTER JOIN tmpRemains ON tmpRemains.GoodsId = MovementItem_Sale.GoodsId;
     END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_Sale (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.
 13.10.15                                                          *
*/