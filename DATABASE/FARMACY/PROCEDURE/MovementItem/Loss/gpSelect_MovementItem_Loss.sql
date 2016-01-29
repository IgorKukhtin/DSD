-- Function: gpSelect_MovementItem_Loss()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Loss (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Loss(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat, Price TFloat, Summ TFloat 
             , Remains_Amount TFloat, PriceIn TFloat, SummIn TFloat
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbObjectId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbOperDate TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Loss());
    vbUserId:= lpGetUserBySession (inSession);
     
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
    --Определили подразделение для розничной цены и дату для остатка
    SELECT 
        MovementLinkObject_Unit.ObjectId
       ,Movement_Loss.OperDate 
    INTO 
        vbUnitId
       ,vbOperDate
    FROM
        Movement AS Movement_Loss
        INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement_Loss.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
    WHERE 
        Movement_Loss.Id = inMovementId;
        

    IF inShowAll THEN
    -- Результат
        RETURN QUERY
            WITH REMAINS AS ( --остатки на дату документа
                                SELECT 
                                    T0.ObjectId
                                   ,SUM(T0.Amount)::TFloat as Amount
                                   ,SUM(T0.Summ)::TFloat as Summ
                                   ,CASE WHEN SUM(T0.Amount) <> 0
                                        THEN SUM(T0.Summ) / SUM(T0.Amount)
                                    END AS Price
                                FROM(
                                        SELECT 
                                            Container.Id 
                                           ,Container.ObjectId --Товар
                                           ,(Container.Amount - COALESCE(SUM(MovementItemContainer.amount),0.0))::TFloat as Amount  --Тек. остаток - Движение после даты переучета
                                           ,(Container.Amount * COALESCE(MIFloat_Income_Price.ValueData,0) - COALESCE(SUM(MovementItemContainer.amount * COALESCE(MIFloat_Income_Price.ValueData,0)),0.0))::TFloat as Summ  --Тек. остаток - Движение после даты переучета
                                        FROM Container
                                            LEFT OUTER JOIN MovementItemContainer ON Container.Id = MovementItemContainer.ContainerId
                                                                                 AND 
                                                                                 (
                                                                                    date_trunc('day', MovementItemContainer.Operdate) > vbOperDate
                                                                                    OR
                                                                                    MovementItemContainer.MovementId = inMovementId
                                                                                 )
                                            LEFT OUTER JOIN containerlinkobject AS CLI_MI 
                                                                                ON CLI_MI.containerid = Container.Id
                                                                               AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()
                                            LEFT OUTER JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                                            LEFT OUTER JOIN MovementitemFloat AS MIFloat_Income_Price
                                                                              ON MIFloat_Income_Price.MovementItemId = Object_PartionMovementItem.ObjectCode
                                                                             AND MIFloat_Income_Price.DescId = zc_MIFloat_Price()
                                            
                                        WHERE 
                                            Container.DescID = zc_Container_Count()
                                            AND
                                            Container.WhereObjectId = vbUnitId
                                        GROUP BY 
                                            Container.Id 
                                           ,Container.ObjectId
                                           ,Container.Amount
                                           ,MIFloat_Income_Price.ValueData
                                    ) as T0
                                GROUP By ObjectId
                                HAVING SUM(T0.Amount) <> 0
                            ),
                 CurrPRICE AS(
                                SELECT Object_Price_View.GoodsId, Object_Price_View.Price
                                FROM Object_Price_View
                                WHERE Object_Price_View.UnitId = vbUnitId
                            ),
                 MIContainer AS ( 
                                    SELECT
                                        MovementItemContainer.MovementItemId,
                                        CASE WHEN  SUM(-MovementItemContainer.Amount) <> 0 
                                            THEN SUM(-MovementItemContainer.Amount * MIFloat_Income_Price.ValueData)
                                                 / SUM(-MovementItemContainer.Amount)
                                        END::TFloat AS Price
                                    FROM MovementItemContainer 
                                        LEFT OUTER JOIN containerlinkobject AS CLI_MI 
                                                                            ON CLI_MI.containerid = MovementItemContainer.ContainerId
                                                                           AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()
                                        LEFT OUTER JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                                        LEFT OUTER JOIN MovementitemFloat AS MIFloat_Income_Price
                                                                              ON MIFloat_Income_Price.MovementItemId = Object_PartionMovementItem.ObjectCode
                                                                             AND MIFloat_Income_Price.DescId = zc_MIFloat_Price()
                                    WHERE MovementItemContainer.MovementId = inMovementId
                                      AND MovementItemContainer.DescId = zc_MIContainer_Count()
                                    GROUP BY
                                        MovementItemContainer.MovementItemId
                                )
            SELECT
                    COALESCE(MovementItem.Id,0)           AS Id
                  , Object_Goods_View.Id                  AS GoodsId
                  , Object_Goods_View.GoodsCodeInt        AS GoodsCode
                  , Object_Goods_View.GoodsName           AS GoodsName
                  , MovementItem.Amount                   AS Amount
                  , CurrPRICE.Price                       AS Price
                  , (MovementItem.Amount*CurrPRICE.Price)::TFloat                           AS Summ
                  , REMAINS.Amount                                                          AS Remains_Amount 
                  , COALESCE(MIContainer.Price,REMAINS.Price)::TFloat                       AS PriceIn
                  , (MovementItem.Amount*COALESCE(MIContainer.Price,REMAINS.Price))::TFloat AS SummIn
                  , COALESCE(MovementItem.IsErased,FALSE) AS isErased
            FROM Object_Goods_View
                LEFT JOIN MovementItem ON Object_Goods_View.Id = MovementItem.ObjectId 
                                       AND MovementItem.MovementId = inMovementId
                                       AND MovementItem.DescId = zc_MI_Master()
                                       AND (MovementItem.isErased = FALSE or inIsErased = TRUE)
                LEFT OUTER JOIN CurrPRICE ON object_Goods_View.Id = CurrPRICE.GoodsId
                LEFT OUTER JOIN REMAINS ON object_Goods_View.Id = REMAINS.ObjectId 
                LEFT OUTER JOIN MIContainer ON MIContainer.MovementItemId = MovementItem.Id
            WHERE 
                Object_Goods_View.ObjectId = vbObjectId
                AND 
                (
                    Object_Goods_View.isErased = FALSE 
                    OR 
                    MovementItem.Id IS NOT NULL
                );
     ELSE
     -- Результат
     RETURN QUERY
        WITH REMAINS AS ( --остатки на дату документа
                                SELECT 
                                    T0.ObjectId
                                   ,SUM(T0.Amount)::TFloat as Amount
                                   ,SUM(T0.Summ)::TFloat as Summ
                                   ,CASE WHEN SUM(T0.Amount) <> 0
                                        THEN SUM(T0.Summ) / SUM(T0.Amount)
                                    END AS Price
                                FROM(
                                        SELECT 
                                            Container.Id 
                                           ,Container.ObjectId --Товар
                                           ,(Container.Amount - COALESCE(SUM(MovementItemContainer.amount),0.0))::TFloat as Amount  --Тек. остаток - Движение после даты переучета
                                           ,(Container.Amount * COALESCE(MIFloat_Income_Price.ValueData,0) - COALESCE(SUM(MovementItemContainer.amount * COALESCE(MIFloat_Income_Price.ValueData,0)),0.0))::TFloat as Summ  --Тек. остаток - Движение после даты переучета
                                        FROM Container
                                            LEFT OUTER JOIN MovementItemContainer ON Container.Id = MovementItemContainer.ContainerId
                                                                                 AND 
                                                                                 (
                                                                                    date_trunc('day', MovementItemContainer.Operdate) > vbOperDate
                                                                                    OR
                                                                                    MovementItemContainer.MovementId = inMovementId
                                                                                 )
                                            LEFT OUTER JOIN containerlinkobject AS CLI_MI 
                                                                                ON CLI_MI.containerid = Container.Id
                                                                               AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()
                                            LEFT OUTER JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                                            LEFT OUTER JOIN MovementitemFloat AS MIFloat_Income_Price
                                                                              ON MIFloat_Income_Price.MovementItemId = Object_PartionMovementItem.ObjectCode
                                                                             AND MIFloat_Income_Price.DescId = zc_MIFloat_Price()
                                        WHERE 
                                            Container.DescID = zc_Container_Count()
                                            AND
                                            Container.WhereObjectId = vbUnitId
                                        GROUP BY 
                                            Container.Id 
                                           ,Container.ObjectId
                                           ,Container.Amount
                                           ,MIFloat_Income_Price.ValueData
                                    ) as T0
                                GROUP By ObjectId
                                HAVING SUM(T0.Amount) <> 0
                            ),
                 CurrPRICE AS(
                                SELECT Object_Price_View.GoodsId, Object_Price_View.Price
                                FROM Object_Price_View
                                WHERE Object_Price_View.UnitId = vbUnitId
                            ),
                 MIContainer AS ( 
                                    SELECT
                                        MovementItemContainer.MovementItemId,
                                        CASE WHEN  SUM(-MovementItemContainer.Amount) <> 0 
                                            THEN SUM(-MovementItemContainer.Amount * MIFloat_Income_Price.ValueData)
                                                 / SUM(-MovementItemContainer.Amount)
                                        END::TFloat AS Price
                                    FROM MovementItemContainer 
                                        LEFT OUTER JOIN containerlinkobject AS CLI_MI 
                                                                            ON CLI_MI.containerid = MovementItemContainer.ContainerId
                                                                           AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()
                                        LEFT OUTER JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                                        LEFT OUTER JOIN MovementitemFloat AS MIFloat_Income_Price
                                                                              ON MIFloat_Income_Price.MovementItemId = Object_PartionMovementItem.ObjectCode
                                                                             AND MIFloat_Income_Price.DescId = zc_MIFloat_Price()
                                    WHERE MovementItemContainer.MovementId = inMovementId
                                      AND MovementItemContainer.DescId = zc_MIContainer_Count()
                                    GROUP BY
                                        MovementItemContainer.MovementItemId
                                )
        SELECT
            MovementItem.Id                       AS Id
          , Object_Goods_View.Id                  AS GoodsId
          , Object_Goods_View.GoodsCodeInt        AS GoodsCode
          , Object_Goods_View.GoodsName           AS GoodsName
          , MovementItem.Amount                   AS Amount
          , CurrPRICE.Price                       AS Price
          , (MovementItem.Amount*CurrPRICE.Price)::TFloat                           AS Summ
          , REMAINS.Amount                                                          AS Remains_Amount
          , COALESCE(MIContainer.Price,REMAINS.Price)::TFloat                       AS PriceIn
          , (MovementItem.Amount*COALESCE(MIContainer.Price,REMAINS.Price))::TFloat AS SummIn
          , COALESCE(MovementItem.IsErased,FALSE) AS isErased
        FROM MovementItem
            LEFT JOIN Object_Goods_View ON Object_Goods_View.Id = MovementItem.ObjectId 
                                       AND Object_Goods_View.ObjectId = vbObjectId
            LEFT OUTER JOIN CurrPRICE ON object_Goods_View.Id = CurrPRICE.GoodsId
            LEFT OUTER JOIN REMAINS ON MovementItem.ObjectId = REMAINS.ObjectId
            LEFT OUTER JOIN MIContainer ON MIContainer.MovementItemId = MovementItem.Id
        WHERE 
            MovementItem.MovementId = inMovementId
            AND 
            MovementItem.DescId = zc_MI_Master()
            AND 
            (
                MovementItem.isErased = FALSE 
                OR 
                inIsErased = TRUE
            );
     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_Loss (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 31.03.15         * add GoodsGroupNameFull, MeasureName
 17.10.14         * add св-ва PartionGoods
 08.10.14                                        * add Object_InfoMoney_View
 01.09.14                                                       * + PartionGoodsDate
 26.05.14                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_Loss (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_Loss (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
