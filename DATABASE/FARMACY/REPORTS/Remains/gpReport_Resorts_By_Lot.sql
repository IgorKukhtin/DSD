-- Function:  gpReport_Resorts_By_Lot

DROP FUNCTION IF EXISTS gpReport_Resorts_By_Lot (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Resorts_By_Lot (
  inUnitID  Integer,
  inisSUN   Boolean,
  inSession TVarChar
)
RETURNS TABLE (
  ContainerId integer,
  UnitID integer,
  UnitName TVarChar,
  GoodsId integer,
  GoodsCode integer,
  GoodsName TVarChar,

  Amount TFloat,
  AmountRest TFloat
) AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY
    WITH tmpContainer AS (SELECT Container.Id,
                                 Container.ObjectId,
                                 Container.WhereObjectId,
                                 Container.Amount

                          FROM Container
                          WHERE Container.DescId = zc_Container_Count()
                            AND Container.Amount < 0
                            AND (Container.WhereObjectId = inUnitID OR COALESCE(inUnitID, 0) = 0)),
         tmpContainerRest AS (SELECT tmpContainer.Id
                                   , SUM(Container.Amount)  AS Amount
                              FROM tmpContainer
                                   INNER JOIN Container ON Container.ObjectId = tmpContainer.ObjectId
                                                       AND Container.WhereObjectId = tmpContainer.WhereObjectId
                                                       AND Container.DescId = zc_Container_Count()
                                                       AND Container.Amount > 0
                              GROUP BY tmpContainer.Id
                              )

    SELECT tmpContainer.Id                   AS ContainerId,
           tmpContainer.WhereObjectId        AS UnitID,
           Object_Unit.ValueData             AS UnitName,
           tmpContainer.ObjectId             AS GoodsId,
           Object_Goods.ObjectCode           AS GoodsCode,
           Object_Goods.ValueData            AS GoodsName,

           tmpContainer.Amount::TFloat       AS Amount,
           tmpContainerRest.Amount::TFloat   AS AmountRest

    FROM tmpContainer

         INNER JOIN tmpContainerRest on tmpContainerRest.Id = tmpContainer.Id

         LEFT JOIN Object AS Object_Goods ON Object_Goods.ID = tmpContainer.ObjectId

         LEFT JOIN Object AS Object_Unit ON Object_Unit.ID = tmpContainer.WhereObjectId

         LEFT JOIN ObjectBoolean ON ObjectBoolean.objectid = tmpContainer.WhereObjectId
                                AND ObjectBoolean.descid = zc_ObjectBoolean_Unit_SUN()
                              
    WHERE inisSUN = FALSE OR COALESCE(ObjectBoolean.ValueData, False) = TRUE;
    
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 29.09.20                                                       *

*/

-- тест
--
 select * from gpReport_Resorts_By_Lot (183292, True, '3')