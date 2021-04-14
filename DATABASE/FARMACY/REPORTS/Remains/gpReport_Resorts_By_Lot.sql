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
  
  TypeResorts TVarChar,

  Amount TFloat,
  AmountRest TFloat,

  AmountPD TFloat,
  CountPD integer,
  ContainerPDId integer 

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
                              GROUP BY tmpContainer.Id),
         tmpContainerPD AS (SELECT Container.ParentId,
                                   SUM(Container.Amount)   AS Amount,
                                   COUNT(*)::Integer       AS CountPD,
                                   Max(Container.Id)       AS ContainerId
                            FROM Container
                            WHERE Container.DescId = zc_Container_CountPartionDate()
                            GROUP BY Container.ParentId)
                     
    SELECT tmpContainer.Id                   AS ContainerId,
           tmpContainer.WhereObjectId        AS UnitID,
           Object_Unit.ValueData             AS UnitName,
           tmpContainer.ObjectId             AS GoodsId,
           Object_Goods.ObjectCode           AS GoodsCode,
           Object_Goods.ValueData            AS GoodsName,
           
           'Основным'::TVarChar              AS TypeResorts,

           tmpContainer.Amount::TFloat       AS Amount,
           tmpContainerRest.Amount::TFloat   AS AmountRest,

           0::TFloat                         AS AmountPD,
           0::integer                        AS CountPD,
           0::integer                        AS ContainerPDId 

    FROM tmpContainer

         INNER JOIN tmpContainerRest on tmpContainerRest.Id = tmpContainer.Id

         LEFT JOIN Object AS Object_Goods ON Object_Goods.ID = tmpContainer.ObjectId

         LEFT JOIN Object AS Object_Unit ON Object_Unit.ID = tmpContainer.WhereObjectId

         LEFT JOIN ObjectBoolean ON ObjectBoolean.objectid = tmpContainer.WhereObjectId
                                AND ObjectBoolean.descid = zc_ObjectBoolean_Unit_SUN()
                              
    WHERE inisSUN = FALSE OR COALESCE(ObjectBoolean.ValueData, False) = TRUE
    UNION ALL 
    SELECT Container.Id                      AS ContainerId,
           Container.WhereObjectId           AS UnitID,
           Object_Unit.ValueData             AS UnitName,
           Container.ObjectId                AS GoodsId,
           Object_Goods.ObjectCode           AS GoodsCode,
           Object_Goods.ValueData            AS GoodsName,
           
           'Сроковым'::TVarChar              AS TypeResorts,

           Container.Amount::TFloat          AS Amount,
           0::TFloat                         AS AmountRest,

           tmpContainerPD.Amount::TFloat       AS AmountPD,
           tmpContainerPD.CountPD::integer     AS CountPD,
           tmpContainerPD.ContainerId::integer AS ContainerPDId 


    FROM Container

       INNER JOIN tmpContainerPD ON tmpContainerPD.ParentId = Container.Id

       LEFT JOIN Object AS Object_Goods ON Object_Goods.ID = Container.ObjectId
       LEFT JOIN Object AS Object_Unit ON Object_Unit.ID = Container.WhereObjectId

       LEFT JOIN ObjectBoolean ON ObjectBoolean.objectid = Container.WhereObjectId
                              AND ObjectBoolean.descid = zc_ObjectBoolean_Unit_SUN()
                              
    WHERE Container.DescId = zc_Container_Count()
      AND Container.Amount <> tmpContainerPD.Amount
      AND (inisSUN = FALSE OR COALESCE(ObjectBoolean.ValueData, False) = TRUE)
    ;
    
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
--select * from gpReport_Resorts_By_Lot(inUnitId := 0 , inisSUN := 'False' ,  inSession := '3');