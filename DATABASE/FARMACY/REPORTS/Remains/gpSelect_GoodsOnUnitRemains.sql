-- Function: gpSelect_Movement_Income()

DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnitRemains (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsOnUnitRemains(
    IN inUnitId           Integer  ,  -- Подразделение
    IN inRemainsDate      TDateTime,  -- Дата остатка
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id integer, GoodsCode Integer, GoodsName TVarChar, OperAmount TFloat, Price TFloat, OperSum TFloat, PriceOut TFloat, SumOut TFloat)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY
        WITH containerCount AS (SELECT container.Id, container.Amount, container.ObjectID FROM container  
                                  JOIN containerlinkobject AS CLO_Unit
                                                           ON CLO_Unit.containerid = container.id 
                                                          AND CLO_Unit.descid = zc_ContainerLinkObject_Unit()
                                                          AND CLO_Unit.objectid = inUnitId 
                                WHERE container.descid = zc_container_count())

        SELECT Object_Goods.Id                              as Id
             , Object_Goods.ObjectCode                      as GoodsCode
             , Object_Goods.ValueData                       as GoodsName
             , DD.OperAmount::TFloat                        as OperAmount
             , CASE WHEN DD.OperAmount <> 0 
                 THEN (DD.OperSum / DD.OperAmount)
               END::TFloat                                  as Price
             , DD.OperSum::TFloat                           as OperSum
             , Object_Price.Price                           as PriceOut
             , (DD.OperAmount * Object_Price.Price)::TFloat as SumOut
        FROM(
            SELECT 
                SUM(DD.OperAmount) AS OperAmount, 
                SUM(DD.OperSum) AS OperSum, 
                ObjectId
            FROM(
                SELECT 
                    SUM(DD.OperAmount) AS OperAmount, 
                    0 AS OperSum, 
                    ObjectID 
                FROM(
                    SELECT 
                        containerCount.Amount - COALESCE(SUM(MIContainer.Amount), 0) AS OperAmount
                      , containerCount.ObjectID 
                    FROM containerCount
                        LEFT JOIN MovementItemContainer AS MIContainer 
                                                        ON MIContainer.ContainerId = containerCount.Id
                                                       AND MIContainer.OperDate > inRemainsDate
                    GROUP BY containerCount.Id, containerCount.ObjectID, containerCount.Amount
                    ) AS DD
                GROUP BY DD.ObjectID
                UNION ALL
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
                GROUP BY DD.ObjectID
                ) AS DD
            GROUP BY DD.ObjectID
            HAVING (SUM(DD.OperAmount) <> 0)-- OR (SUM(DD.OperSum) <> 0)
            ) AS DD
            LEFT JOIN OBJECT AS Object_Goods ON Object_Goods.Id = DD.ObjectId
            LEFT OUTER JOIN Object_Price_View AS Object_Price
                                              ON DD.ObjectId = Object_Price.GoodsId
                                             AND Object_Price.UnitId = inUnitId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_GoodsOnUnitRemains (Integer, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 02.06.15                        *

*/

-- тест
-- SELECT * FROM gpSelect_CashRemains (inSession:= '2')