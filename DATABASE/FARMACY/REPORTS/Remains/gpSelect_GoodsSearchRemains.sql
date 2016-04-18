-- Function: gpSelect_Movement_Income()

DROP FUNCTION IF EXISTS gpSelect_GoodsSearchRemains (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsSearchRemains(
    IN inGoodsSearch    TVarChar    -- поиск товаров
  , IN inSession        TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupName TVarChar
             , UnitName TVarChar
             , Amount TFloat
             , PriceSale  TFloat
             , SummaSale TFloat
             
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbRemainsDate TDateTime;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    -- Ограничение на просмотр товарного справочника
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    vbRemainsDate = CURRENT_TIMESTAMP;

    -- Результат
    RETURN QUERY
        WITH 
        tmpGoods AS (SELECT Object.Id
                     FROM Object 
                     WHERE Object.DescId = zc_Object_Goods()
                       AND upper(Object.ValueData) LIKE UPPER('%'||inGoodsSearch||'%')
                     )
           , containerCount AS (SELECT Container.Id                AS ContainerId
                                     , Container.Amount
                                     , Container.ObjectID          AS GoodsId
                                     , Container.WhereObjectId     AS UnitId
                                FROM tmpGoods
                                   LEFT JOIN Container ON Container.ObjectID = tmpGoods.Id
                                WHERE Container.descid = zc_container_count()
                                )

           , tmpData AS (SELECT tmpData_all.UnitId
                              , tmpData_all.GoodsId
                              , SUM (tmpData_all.Amount)   AS Amount
                         FROM (  SELECT ContainerCount.Amount - COALESCE(SUM(MIContainer.Amount), 0) AS Amount
                                      , ContainerCount.GoodsId 
                                      , ContainerCount.UnitId 
                                 FROM ContainerCount
                                      LEFT JOIN MovementItemContainer AS MIContainer 
                                                                      ON MIContainer.ContainerId = ContainerCount.ContainerId
                                                                     AND MIContainer.OperDate >= vbRemainsDate
                                 GROUP BY ContainerCount.ContainerId, containerCount.GoodsId, containerCount.Amount, ContainerCount.GoodsId , ContainerCount.UnitId 
                                 ) AS tmpData_all
                         GROUP BY tmpData_all.GoodsId
                                , tmpData_all.UnitId
                         HAVING (SUM (tmpData_all.Amount) <> 0)                                
                          )


        SELECT Object_Goods_View.Id                         as Id
             , Object_Goods_View.GoodsCodeInt ::Integer     as GoodsCode
             , Object_Goods_View.GoodsName                  as GoodsName
             , Object_Goods_View.GoodsGroupName             AS GoodsGroupName
             , Object_Unit.ValueData                        AS UnitName
            , tmpData.Amount :: TFloat                      AS Amount
            , COALESCE (ObjectHistoryFloat_Price.ValueData, 0)                 :: TFloat AS PriceSale
            , (tmpData.Amount * COALESCE (ObjectHistoryFloat_Price.ValueData, 0)) :: TFloat AS SummaSale
              
        FROM tmpData
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpData.UnitId

            LEFT JOIN Object_Goods_View ON Object_Goods_View.Id = tmpData.GoodsId

            LEFT OUTER JOIN Object_Price_View AS Object_Price
                                              ON Object_Price.GoodsId = tmpData.GoodsId
                                             AND Object_Price.UnitId = tmpData.UnitId
                                       
            -- получаем значения цены и НТЗ из истории значений на дату на начало                                                          
            LEFT JOIN ObjectHistory AS ObjectHistory_Price
                                    ON ObjectHistory_Price.ObjectId = Object_Price.Id
                                   AND ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
                                   AND vbRemainsDate >= ObjectHistory_Price.StartDate AND vbRemainsDate < ObjectHistory_Price.EndDate
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price
                                         ON ObjectHistoryFloat_Price.ObjectHistoryId = ObjectHistory_Price.Id
                                        AND ObjectHistoryFloat_Price.DescId = zc_ObjectHistoryFloat_Price_Value()
         
          order by Object_Unit.ValueData 
                 , Object_Goods_View.GoodsGroupName
                 , Object_Goods_View.GoodsName 
           ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 18.04.16         *
*/

-- тест
-- SELECT * FROM gpSelect_GoodsSearchRemains ('глюкоз%200', inSession := '3');

