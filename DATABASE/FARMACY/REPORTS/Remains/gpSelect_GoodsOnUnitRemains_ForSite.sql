
DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnitRemains_ForSite (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsOnUnitRemains_ForSite(
    IN inUnitId           Integer  ,  -- Подразделение
    IN inRemainsDate      TDateTime,  -- Дата остатка
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id integer, GoodsCode Integer, GoodsName TVarChar, GoodsGroupName TVarChar
             , OperAmount TFloat, Price TFloat, NDSKindName TVarChar
             , OperSum TFloat, PriceOut TFloat, SumOut TFloat
             , MinExpirationDate TDateTime)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    -- Ограничение на просмотр товарного справочника
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    -- Результат
    RETURN QUERY
        WITH containerCount AS (SELECT 
                                    container.Id
                                  , container.Amount
                                  ,CASE WHEN COALESCE(MovementBoolean_PriceWithVAT.ValueData,FALSE) = TRUE
                                               THEN MIFloat_Price.ValueData / (1 + ObjectFloat_NDSKind_NDS.ValueData/100)
                                               ELSE MIFloat_Price.ValueData
                                            END::TFloat AS PriceWithOutVAT
                                  , container.ObjectID 
                                FROM 
                                    container
                                    LEFT OUTER JOIN ContainerLinkObject AS CLI_MI 
                                                                        ON CLI_MI.ContainerId = container.Id
                                                                       AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                    LEFT OUTER JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                                    LEFT OUTER JOIN MovementItem AS MI_Income
                                                                 ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                    LEFT OUTER JOIN MovementItemFloat AS MIFloat_Price
                                                                      ON MIFloat_Price.MovementItemId = MI_Income.Id
                                                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                    LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                              ON MovementBoolean_PriceWithVAT.MovementId =  MI_Income.MovementId
                                                             AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                                 ON MovementLinkObject_NDSKind.MovementId = MI_Income.MovementId
                                                                AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                                    LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                                          ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                                                         AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS() 
                                WHERE 
                                    container.descid = zc_container_count()
                                    AND
                                    Container.WhereObjectId = inUnitId)

        SELECT Object_Goods_View.Id                         as Id
             , Object_Goods_View.GoodsCodeInt ::Integer     as GoodsCode
             , Object_Goods_View.GoodsName                  as GoodsName
             , Object_Goods_View.GoodsGroupName             AS GoodsGroupName

             , DD.OperAmount::TFloat                        as OperAmount
             , CASE WHEN DD.OperAmount <> 0 
                 THEN (DD.OperSum / DD.OperAmount)
               END::TFloat                                  as Price
             , Object_Goods_View.NDSKindName                AS NDSKindName  
             , DD.OperSum::TFloat                           as OperSum
             , Object_Price.Price                           as PriceOut
             , (DD.OperAmount * Object_Price.Price)::TFloat as SumOut
             , SelectMinPrice_AllGoods.MinExpirationDate    AS MinExpirationDate
        FROM(
            SELECT 
                SUM(DD.OperAmount) AS OperAmount, 
                SUM(DD.OperSum) AS OperSum, 
                ObjectId
            FROM(
                SELECT 
                    SUM(DD.OperAmount) AS OperAmount, 
                    SUM(DD.OperAmount*PriceWithOutVAT) AS OperSum,
                    ObjectID 
                FROM(
                    SELECT 
                        containerCount.Amount - COALESCE(SUM(MIContainer.Amount), 0) AS OperAmount
                      , containerCount.PriceWithOutVAT  
                      , containerCount.ObjectID 
                    FROM containerCount
                        LEFT JOIN MovementItemContainer AS MIContainer 
                                                        ON MIContainer.ContainerId = containerCount.Id
                                                       AND MIContainer.OperDate > inRemainsDate
                    GROUP BY containerCount.Id, containerCount.ObjectID, containerCount.Amount, containerCount.PriceWithOutVAT
                    ) AS DD
                GROUP BY DD.ObjectID
                /* UNION ALL
                SELECT 
                    0 AS OperAmount, 
                    SUM(DD.OperAmount) AS OperSumm, 
                    ObjectID 
                FROM(
                    SELECT 
                        container.Amount - COALESCE(SUM(MIContainer.Amount), 0) AS OperAmount
                      , container.Id
                      , containerCount.ObjectID 
                    FROM Container 
                        JOIN containerCount ON Container.parentid = containerCount.Id
                        LEFT JOIN MovementItemContainer AS MIContainer 
                                                        ON MIContainer.ContainerId = container.Id
                                                       AND MIContainer.OperDate > inRemainsDate
                    GROUP BY container.Id, containerCount.ObjectID, container.Amount
                    ) AS DD
                GROUP BY DD.ObjectID*/
                ) AS DD
            GROUP BY DD.ObjectID
            HAVING (SUM(DD.OperAmount) <> 0)-- OR (SUM(DD.OperSum) <> 0)
            ) AS DD
            LEFT JOIN Object_Goods_View ON Object_Goods_View.Id = DD.ObjectId

            LEFT OUTER JOIN Object_Price_View AS Object_Price
                                              ON DD.ObjectId = Object_Price.GoodsId
                                             AND Object_Price.UnitId = inUnitId

            LEFT JOIN lpSelectMinPrice_AllGoods(inUnitId := inUnitId,
                                                inObjectId := vbObjectId, 
                                                inUserId := vbUserId) AS SelectMinPrice_AllGoods
                                                                      ON SelectMinPrice_AllGoods.GoodsId = Object_Goods_View.Id

;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_GoodsOnUnitRemains_ForSite (Integer, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 28.01.16         *
 02.06.15                        *

*/

-- тест
--select * from gpSelect_GoodsOnUnitRemains_ForSite(inUnitId := 377613 , inRemainsDate := ('16.09.2015')::TDateTime ,  inSession := '3');