-- Function: gpSelect_MovementItem_Inventory()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Inventory (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Inventory(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat, Price TFloat, Summ TFloat
             , isErased Boolean
             , Remains_Amount TFloat, Remains_Summ TFloat
             , Deficit TFloat, DeficitSumm TFloat
             , Proficit TFloat, ProficitSumm TFloat, Diff TFloat, DiffSumm TFloat
             , MIComment TVarChar      
             , isAuto Boolean      
             )
AS
$BODY$
DECLARE
  vbUserId Integer;
  vbObjectId Integer;
  vbUnitId Integer;
  vbOperDate TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Inventory());
    -- inShowAll:= TRUE;
    vbUserId:= lpGetUserBySession (inSession);
    vbObjectId := lpGet_DefaultValue ('zc_Object_Retail', vbUserId);


    -- вытягиваем дату и подразделение
    SELECT
        DATE_TRUNC ('DAY', Movement_Inventory.OperDate) + INTERVAL '1 DAY'
       ,Inventory_Unit.ObjectId
    INTO
        vbOperDate,
        vbUnitId
    FROM 
        Movement AS Movement_Inventory
        Inner Join MovementLinkObject as Inventory_Unit
                                      ON Movement_Inventory.Id = Inventory_Unit.MovementId
                                     AND Inventory_Unit.DescId = zc_MovementLinkObject_Unit()
    WHERE Movement_Inventory.Id = inMovementId;
    
    IF inShowAll = FALSE 
    THEN
        RETURN QUERY
            WITH REMAINS AS (   -- остатки на дату документа
                                SELECT 
                                    T0.ObjectId
                                   ,SUM (T0.Amount) :: TFloat AS Amount
                                FROM(
                                        SELECT 
                                             Container.Id 
                                           , Container.ObjectId  -- Товар
                                           , Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0.0) AS Amount
                                        FROM Container
                                            /*JOIN ContainerLinkObject AS CLI_Unit 
                                                                     ON CLI_Unit.containerid = Container.Id
                                                                    AND CLI_Unit.descid = zc_ContainerLinkObject_Unit()
                                                                    AND CLI_Unit.ObjectId = vbUnitId*/
                                            LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id
                                                                                 -- AND DATE_TRUNC ('DAY', MovementItemContainer.Operdate) > vbOperDate
                                                                                 AND MovementItemContainer.Operdate >= vbOperDate
                                        WHERE 
                                            Container.DescID = zc_Container_Count()
                                        AND Container.WhereObjectId = vbUnitId
                                        GROUP BY 
                                            Container.Id 
                                           ,Container.ObjectId
                                        HAVING Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0) <> 0
                                       UNION ALL
                                        SELECT 
                                             Container.Id 
                                           , Container.ObjectId  -- Товар
                                           , -1 * SUM (MovementItemContainer.Amount) AS Amount
                                        FROM MovementItemContainer
                                            INNER JOIN Container ON Container.Id = MovementItemContainer.ContainerId
                                        WHERE MovementItemContainer.DescID = zc_MIContainer_Count()
                                          AND MovementItemContainer.MovementId = inMovementId
                                        GROUP BY 
                                            Container.Id 
                                           ,Container.ObjectId
                                    ) as T0
                                GROUP BY ObjectId
                                HAVING SUM (T0.Amount) <> 0
                            )
            SELECT
                MovementItem.Id                                                     AS Id
              , Object_Goods.Id                                                     AS GoodsId
              , Object_Goods.ObjectCode                                             AS GoodsCode
              , Object_Goods.ValueData                                              AS GoodsName
              , MovementItem.Amount                                                 AS Amount
              , MIFloat_Price.ValueData                                             AS Price
              , MIFloat_Summ.ValueData                                              AS Summ
              , MovementItem.isErased                                               AS isErased
              , REMAINS.Amount                                                      AS Remains_Amount
              , (COALESCE(REMAINS.Amount,0) * MIFloat_Price.ValueData) ::TFloat     AS Remains_Summ
              , CASE 
                  WHEN COALESCE(REMAINS.Amount,0)>MovementItem.Amount
                    THEN COALESCE(REMAINS.Amount,0)-COALESCE(MovementItem.Amount,0)
                END::TFloat                                                         AS Deficit
              , (CASE 
                  WHEN COALESCE(REMAINS.Amount,0)>MovementItem.Amount
                    THEN COALESCE(REMAINS.Amount,0)-COALESCE(MovementItem.Amount,0)
                END * MIFloat_Price.ValueData)::TFloat                              AS DeficitSumm
              , CASE 
                  WHEN COALESCE(REMAINS.Amount,0)<MovementItem.Amount
                    THEN COALESCE(MovementItem.Amount,0)-COALESCE(REMAINS.Amount,0)
                END::TFloat                                                         AS Proficit
              , (CASE 
                  WHEN COALESCE(REMAINS.Amount,0)<MovementItem.Amount
                    THEN COALESCE(MovementItem.Amount,0)-COALESCE(REMAINS.Amount,0)
                END * MIFloat_Price.ValueData)::TFloat                              AS ProficitSumm
              , (MovementItem.Amount-COALESCE(REMAINS.Amount,0))::TFloat AS DIff
              , ((MovementItem.Amount-COALESCE(REMAINS.Amount,0))
                  *MIFloat_Price.ValueData)::TFloat                                 AS DiffSumm
              , MIString_Comment.ValueData                                          AS MIComment
              , COALESCE(MIBoolean_isAuto.ValueData, FALSE) ::Boolean                          AS isAuto
            FROM MovementItem
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
                LEFT JOIN MovementItemFloat AS MIFloat_Price
                                            ON MIFloat_Price.MovementItemId = MovementItem.Id
                                           AND MIFloat_Price.DescId = zc_MIFloat_Price()
                LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                            ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                           AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                LEFT OUTER JOIN REMAINS ON MovementItem.ObjectId = REMAINS.ObjectId
                LEFT OUTER JOIN MovementItemString AS MIString_Comment
                                                   ON MIString_Comment.MovementItemId = MovementItem.Id
                                                  AND MIString_Comment.DescId = zc_MIString_Comment()
                LEFT JOIN MovementItemBoolean AS MIBoolean_isAuto
                                              ON MIBoolean_isAuto.MovementItemId = MovementItem.Id
                                             AND MIBoolean_isAuto.DescId = zc_MIBoolean_isAuto()
            WHERE
                MovementItem.MovementId = inMovementId
                AND 
                MovementItem.DescId     = zc_MI_Master()
                AND 
                (
                    MovementItem.isErased = False
                    or
                    inIsErased = TRUE
                );
    ELSE
        RETURN QUERY
            WITH tmpPrice AS (
                                SELECT 
                                    Object_Price_View.GoodsId
                                  , Object_Price_View.Price
                                FROM 
                                    Object_Price_View
                                WHERE 
                                    Object_Price_View.UnitId = vbUnitId
                              ),
                 REMAINS AS ( --остатки на дату документа
                                SELECT 
                                    T0.ObjectId
                                   ,SUM (T0.Amount) :: TFloat AS Amount
                                FROM(
                                        SELECT 
                                             Container.Id 
                                           , Container.ObjectId  -- Товар
                                           , Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0.0) AS Amount
                                        FROM Container
                                            /*JOIN ContainerLinkObject AS CLI_Unit 
                                                                     ON CLI_Unit.containerid = Container.Id
                                                                    AND CLI_Unit.descid = zc_ContainerLinkObject_Unit()
                                                                    AND CLI_Unit.ObjectId = vbUnitId*/
                                            LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id
                                                                                 -- AND DATE_TRUNC ('DAY', MovementItemContainer.Operdate) > vbOperDate
                                                                                 AND MovementItemContainer.Operdate >= vbOperDate
                                        WHERE 
                                            Container.DescID = zc_Container_Count()
                                        AND Container.WhereObjectId = vbUnitId
                                        GROUP BY 
                                            Container.Id 
                                           ,Container.ObjectId
                                        HAVING Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0) <> 0
                                       UNION ALL
                                        SELECT 
                                             Container.Id 
                                           , Container.ObjectId  -- Товар
                                           , -1 * SUM (MovementItemContainer.Amount) AS Amount
                                        FROM MovementItemContainer
                                            INNER JOIN Container ON Container.Id = MovementItemContainer.ContainerId
                                        WHERE MovementItemContainer.DescID = zc_MIContainer_Count()
                                          AND MovementItemContainer.MovementId = inMovementId
                                        GROUP BY 
                                            Container.Id 
                                           ,Container.ObjectId
                                    ) as T0
                                GROUP BY ObjectId
                                HAVING SUM (T0.Amount) <> 0
                            )
            SELECT
                MovementItem.Id                                                     AS Id
              , Object_Goods.Id                                                     AS GoodsId
              , Object_Goods.GoodsCodeInt                                           AS GoodsCode
              , Object_Goods.GoodsName                                              AS GoodsName
              , MovementItem.Amount                                                 AS Amount
              , COALESCE(MIFloat_Price.ValueData,tmpPrice.Price)                    AS Price
              , MIFloat_Summ.ValueData                                              AS Summ
              , MovementItem.isErased                                               AS isErased
              , REMAINS.Amount                                                      AS Remains_Amount
              , (COALESCE(REMAINS.Amount,0) * COALESCE(MIFloat_Price.ValueData,tmpPrice.Price))::TFloat  AS Remains_Summ
              , CASE 
                  WHEN COALESCE(REMAINS.Amount,0)>MovementItem.Amount
                    THEN COALESCE(REMAINS.Amount,0)-COALESCE(MovementItem.Amount,0)
                END::TFloat                                                         AS Deficit
              , (CASE 
                  WHEN COALESCE(REMAINS.Amount,0)>MovementItem.Amount
                    THEN COALESCE(REMAINS.Amount,0)-COALESCE(MovementItem.Amount,0)
                END * COALESCE(MIFloat_Price.ValueData,tmpPrice.Price))::TFloat     AS DeficitSumm
              , CASE 
                  WHEN COALESCE(REMAINS.Amount,0)<MovementItem.Amount
                    THEN COALESCE(MovementItem.Amount,0)-COALESCE(REMAINS.Amount,0)
                END::TFloat                                                         AS Proficit
              , (CASE 
                  WHEN COALESCE(REMAINS.Amount,0)<MovementItem.Amount
                    THEN COALESCE(MovementItem.Amount,0)-COALESCE(REMAINS.Amount,0)
                END * COALESCE(MIFloat_Price.ValueData,tmpPrice.Price))::TFloat     AS ProficitSumm
              , (MovementItem.Amount-COALESCE(REMAINS.Amount,0))::TFloat            AS DIff
              , ((MovementItem.Amount-COALESCE(REMAINS.Amount,0))
                  *COALESCE(MIFloat_Price.ValueData,tmpPrice.Price))::TFloat        AS DiffSumm
              , MIString_Comment.ValueData                                          AS MIComment
              , COALESCE(MIBoolean_isAuto.ValueData, FALSE) ::Boolean                          AS isAuto
            FROM 
                Object_Goods_View AS Object_Goods 
                LEFT JOIN MovementItem ON Object_Goods.Id = MovementItem.ObjectId 
                                      AND MovementItem.MovementId = inMovementId
                                      AND MovementItem.DescId     = zc_MI_Master()
                                      AND (MovementItem.isErased = False
                                            or
                                           inIsErased = TRUE)
                LEFT JOIN MovementItemFloat AS MIFloat_Price
                                            ON MIFloat_Price.MovementItemId = MovementItem.Id
                                           AND MIFloat_Price.DescId = zc_MIFloat_Price()
                LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                            ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                           AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                LEFT JOIN tmpPrice ON Object_Goods.Id = tmpPrice.GoodsId
                LEFT OUTER JOIN REMAINS ON Object_Goods.Id = REMAINS.ObjectId
                LEFT OUTER JOIN MovementItemString AS MIString_Comment
                                                   ON MIString_Comment.MovementItemId = MovementItem.Id
                                                  AND MIString_Comment.DescId = zc_MIString_Comment()

                LEFT JOIN MovementItemBoolean AS MIBoolean_isAuto
                                              ON MIBoolean_isAuto.MovementItemId = MovementItem.Id
                                             AND MIBoolean_isAuto.DescId = zc_MIBoolean_isAuto()
            WHERE
                Object_Goods.ObjectId = vbObjectId
                AND
                (
                    Object_Goods.IsErased = False
                    or
                    MovementItem.Id is not null
                );
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_Inventory (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.A.   Воробкало А.А.
 29.06.16         *
 11.07.15                                                                        *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_Inventory (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= TRUE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItem_Inventory (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
