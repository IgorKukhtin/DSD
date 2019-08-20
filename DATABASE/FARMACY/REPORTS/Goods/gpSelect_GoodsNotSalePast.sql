-- Function: gpSelect_GoodsNotSalePast()


DROP FUNCTION IF EXISTS gpSelect_GoodsNotSalePast (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsNotSalePast (
    IN inUnitId         Integer ,
    IN inAmountDay      Integer ,
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (UnitID Integer, UnitCode Integer, UnitName TVarChar,
               GoodsId Integer, GoodsCode Integer, GoodsName TVarChar,
               Remains TFloat
              ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
   vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY
    WITH tmpContainer AS (SELECT Container.WhereObjectId  AS UnitID
                               , Container.ObjectId       AS GoodsID   
                               , SUM(Container.Amount)    AS Amount
                          FROM Container
                          WHERE Container.DescId = zc_Container_Count()
                            AND (Container.WhereObjectId = inUnitId OR inUnitId = 0)
                          GROUP BY Container.WhereObjectId
                                 , Container.ObjectId
                          HAVING SUM(Container.Amount) > 0
                         )
       , tmpMovementItemContainer AS (SELECT MovementItemContainer.WhereObjectId_Analyzer    AS UnitID
                                           , MovementItemContainer.ObjectId_Analyzer         AS GoodsID  
                                           , SUM(MovementItemContainer.Amount)               AS Amount
                                           , SUM(CASE WHEN MovementItemContainer.MovementDescId = zc_Movement_Check() THEN 1 ELSE 0 END) AS Check
                                      FROM MovementItemContainer 
                                      WHERE  (MovementItemContainer.WhereObjectId_Analyzer = inUnitId OR inUnitId = 0)
                                        AND MovementItemContainer.OperDate >= CURRENT_DATE -  (inAmountDay||' DAY')::INTERVAL 
                                      GROUP BY MovementItemContainer.WhereObjectId_Analyzer, MovementItemContainer.ObjectId_Analyzer)
       , tmpRemains AS (SELECT Container.UnitID
                             , Container.GoodsID
                             , Container.Amount    AS Remains
                        FROM tmpContainer AS Container
                             LEFT JOIN tmpMovementItemContainer AS MovementItemContainer
                                                                ON MovementItemContainer.UnitID = Container.UnitID
                                                               AND MovementItemContainer.GoodsID = Container.GoodsID 
                        WHERE (Container.Amount > COALESCE(MovementItemContainer.Amount, 0)) AND COALESCE(MovementItemContainer.Check, 0) = 0)


    SELECT Object_Unit.ID            AS UnitID
         , Object_Unit.ObjectCode    AS UnitCode
         , Object_Unit.ValueData     AS UnitName
         , Container.GoodsID         AS GoodsId
         , Object_Goods.ObjectCode   AS GoodsCode
         , Object_Goods.ValueData    AS GoodsName
         , Container.Remains::TFloat AS Remains
    FROM tmpRemains AS Container

         LEFT JOIN Object AS Object_Unit
                          ON Object_Unit.Id = Container.UnitID

         LEFT JOIN Object AS Object_Goods
                          ON Object_Goods.Id = Container.GoodsID;


END;
$BODY$


LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 19.07.19                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_GoodsNotSalePast(inUnitId :=  375626 , inAmountDay := 100, inSession := '3')