-- Function: gpSelect_MovementItem_Send()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Send (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Send(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat, AmountRemains TFloat, MaxPriceIn TFloat, PriceUnitFrom TFloat, PriceUnitTo TFloat
             , isErased Boolean
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbUnitFromId Integer;
    DECLARE vbUnitToId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Send());
    vbUserId:= lpGetUserBySession (inSession);

    -- определяется подразделение
    SELECT 
        MovementLinkObject_From.ObjectId
       ,MovementLinkObject_To.ObjectId
    INTO
        vbUnitFromId
       ,vbUnitToId 
    FROM 
        Movement
        Inner Join MovementLinkObject AS MovementLinkObject_From
                                      ON MovementLinkObject_From.MovementId = Movement.ID
                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
        Inner Join MovementLinkObject AS MovementLinkObject_To
                                      ON MovementLinkObject_To.MovementId = Movement.ID
                                     AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
    WHERE 
        Movement.Id = inMovementId;

    -- Результат
    IF inShowAll THEN

        -- Результат такой
        RETURN QUERY
            WITH 
                tmpRemains AS(
                                SELECT 
                                    Container.ObjectId                  AS GoodsId
                                  , SUM(Container.Amount)::TFloat       AS Amount
                                  , MAX(MIFloat_Price.ValueData)::TFloat AS MaxPriceIn
                                FROM Container
                                    INNER JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                                                   ON Container.Id = ContainerLinkObject_Unit.ContainerId 
                                                                  AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit() 
                                                                  AND ContainerLinkObject_Unit.ObjectId = vbUnitFromId
                                    INNER JOIN ContainerLinkObject AS CLI_MI 
                                                                   ON CLI_MI.ContainerId = Container.Id
                                                                  AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                    INNER JOIN OBJECT AS Object_PartionMovementItem 
                                                      ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                                    INNER JOIN MovementItem ON MovementItem.Id = Object_PartionMovementItem.ObjectCode
                                    LEFT OUTER JOIN MovementItemFloat AS MIFloat_Price
                                                                      ON MIFloat_Price.MovementItemId = MovementItem.ID
                                                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                WHERE Container.DescId = zc_Container_Count()
                                  AND Container.Amount <> 0
                                GROUP BY 
                                    Container.ObjectId
                             )
               ,MovementItem_Send AS (
                                        SELECT 
                                            MovementItem.Id
                                           ,MovementItem.ObjectId
                                           ,MovementItem.Amount
                                           ,MovementItem.IsErased
                                        FROM MovementItem
                                        WHERE MovementItem.MovementId = inMovementId
                                          AND MovementItem.DescId = zc_MI_Master()
                                          AND (MovementItem.isErased = FALSE or inIsErased = TRUE)
                                     )
            SELECT
                COALESCE(MovementItem_Send.Id,0)           AS Id
              , Object_Goods.Id                            AS GoodsId
              , Object_Goods.GoodsCodeInt                  AS GoodsCode
              , Object_Goods.GoodsName                     AS GoodsName
              , MovementItem_Send.Amount                   AS Amount
              , tmpRemains.Amount::TFloat                  AS AmountRemains
              , tmpRemains.MaxPriceIn::TFloat              AS MaxPriceIn
              , Object_Price_From.Price                    AS PriceUnitFrom
              , Object_Price_To.Price                      AS PriceUnitTo
              , COALESCE(MovementItem_Send.IsErased,FALSE) AS isErased
            FROM tmpRemains
                FULL OUTER JOIN MovementItem_Send ON tmpRemains.GoodsId = MovementItem_Send.ObjectId
                LEFT JOIN Object_Goods_View AS Object_Goods ON Object_Goods.Id = COALESCE(MovementItem_Send.ObjectId,tmpRemains.GoodsId)
                LEFT OUTER JOIN Object_Price_View AS Object_Price_From
                                                  ON Object_Price_From.GoodsId = COALESCE(MovementItem_Send.ObjectId,tmpRemains.GoodsId)
                                                 AND Object_Price_From.UnitId = vbUnitFromId
                LEFT OUTER JOIN Object_Price_View AS Object_Price_To
                                                  ON Object_Price_To.GoodsId = COALESCE(MovementItem_Send.ObjectId,tmpRemains.GoodsId)
                                                 AND Object_Price_To.UnitId = vbUnitToId
            WHERE 
                Object_Goods.isErased = FALSE 
             or MovementItem_Send.id is not null;

    ELSE

        -- Результат другой
        RETURN QUERY
            WITH tmpRemains AS (
                                SELECT 
                                    Container.ObjectId    AS GoodsId
                                  , SUM(Container.Amount) AS Amount
                                  , MAX(MIFloat_Price.ValueData)::TFloat AS MaxPriceIn
                                FROM Container
                                    INNER JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                                                   ON Container.Id = ContainerLinkObject_Unit.ContainerId 
                                                                  AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit() 
                                                                  AND ContainerLinkObject_Unit.ObjectId = vbUnitFromId
                                    INNER JOIN ContainerLinkObject AS CLI_MI 
                                                                   ON CLI_MI.ContainerId = Container.Id
                                                                  AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                    INNER JOIN OBJECT AS Object_PartionMovementItem 
                                                      ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                                    INNER JOIN MovementItem ON MovementItem.Id = Object_PartionMovementItem.ObjectCode
                                    LEFT OUTER JOIN MovementItemFloat AS MIFloat_Price
                                                                      ON MIFloat_Price.MovementItemId = MovementItem.ID
                                                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                WHERE Container.DescId = zc_Container_Count()
                                  AND Container.Amount <> 0
                                GROUP BY Container.ObjectId
                                )
           ,MovementItem_Send AS (SELECT MovementItem.Id
                                        ,MovementItem.ObjectId
                                        ,MovementItem.Amount
                                        ,MovementItem.IsErased
                                  FROM MovementItem
                                  WHERE MovementItem.MovementId = inMovementId
                                    AND MovementItem.DescId = zc_MI_Master()
                                    AND (MovementItem.isErased = FALSE or inIsErased = TRUE)
                                 )
       SELECT
             MovementItem_Send.Id             AS Id
           , Object_Goods.Id                  AS GoodsId
           , Object_Goods.GoodsCodeInt        AS GoodsCode
           , Object_Goods.GoodsName           AS GoodsName
           , MovementItem_Send.Amount         AS Amount
           , tmpRemains.Amount::TFloat        AS AmountRemains
           , tmpRemains.MaxPriceIn::TFloat    AS MaxPriceIn
           , Object_Price_From.Price          AS PriceUnitFrom
           , Object_Price_To.Price            AS PriceUnitTo
           , MovementItem_Send.IsErased       AS isErased
       FROM MovementItem_Send
            LEFT OUTER JOIN tmpRemains ON tmpRemains.GoodsId = MovementItem_Send.ObjectId
            LEFT JOIN Object_Goods_View AS Object_Goods ON Object_Goods.Id = MovementItem_Send.ObjectId
            LEFT OUTER JOIN Object_Price_View AS Object_Price_From
                                              ON Object_Price_From.GoodsId = COALESCE(MovementItem_Send.ObjectId,tmpRemains.GoodsId)
                                             AND Object_Price_From.UnitId = vbUnitFromId
            LEFT OUTER JOIN Object_Price_View AS Object_Price_To
                                              ON Object_Price_To.GoodsId = COALESCE(MovementItem_Send.ObjectId,tmpRemains.GoodsId)
                                             AND Object_Price_To.UnitId = vbUnitToId
            ;

     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_Send (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.10.14         * add Price, Storage_Partion
 04.08.14                                        * add Object_InfoMoney_View
 04.08.14         * add zc_MILinkObject_Unit
                        zc_MILinkObject_Storage
                        zc_MILinkObject_PartionGoods
 07.12.13                                        * rename UserRole_View -> ObjectLink_UserRole_View
 09.11.13                                        * add FuelName and tmpUserTransport
 30.10.13                       *            FULL JOIN
 29.10.13                       *            add GoodsKindId
 22.07.13         * add Count
 18.07.13         * add Object_Asset
 12.07.13         *

*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_Send (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_Send (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
