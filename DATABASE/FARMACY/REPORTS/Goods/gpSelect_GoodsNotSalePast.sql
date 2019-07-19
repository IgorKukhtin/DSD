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
    WITH tmpContainer AS (SELECT Container.Id
                               , Container.WhereObjectId
                               , Container.ObjectId
                               , Container.Amount
                          FROM Container
                          WHERE Container.DescId = zc_Container_Count()
                            AND (Container.WhereObjectId = inUnitId OR inUnitId = 0)
                            AND Container.Amount <> 0
                         )
       , tmpNotSold AS (SELECT DISTINCT
                               MovementItemContainer.ObjectId_Analyzer       AS GoodsId
                             , MovementItemContainer.WhereObjectId_analyzer  AS UnitId
                        FROM MovementItemContainer
                        WHERE MovementItemContainer.OperDate >= CURRENT_DATE -  (inAmountDay||' DAY')::INTERVAL
                          AND MovementItemContainer.MovementDescId = zc_Movement_Check()
                          AND (MovementItemContainer.WhereObjectId_Analyzer = inUnitId OR inUnitId = 0)
                       )
       , tmpRemains AS (SELECT Container.WhereObjectId
                             , Container.ObjectId
                             , SUM (Container.Amount) AS Remains
                        FROM tmpContainer AS Container
                        GROUP BY Container.WhereObjectId , Container.ObjectId)


    SELECT Object_Unit.ID            AS UnitID
         , Object_Unit.ObjectCode    AS UnitCode
         , Object_Unit.ValueData     AS UnitName
         , Container.ObjectId        AS GoodsId
         , Object_Goods.ObjectCode   AS GoodsCode
         , Object_Goods.ValueData    AS GoodsName
         , Container.Remains::TFloat AS Remains
    FROM tmpRemains AS Container

         LEFT JOIN Object AS Object_Unit
                          ON Object_Unit.Id = Container.WhereObjectId

         LEFT JOIN Object AS Object_Goods
                          ON Object_Goods.Id = Container.ObjectId

         LEFT JOIN tmpNotSold ON tmpNotSold.GoodsId = Container.ObjectId
                             AND tmpNotSold.UnitId = Container.WhereObjectId

    WHERE tmpNotSold.GoodsId Is	NULL;


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
-- SELECT * FROM gpSelect_GoodsNotSalePast(inUnitId :=  183292, inAmountDay := 100, inSession := '3')