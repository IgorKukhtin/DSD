-- Function: gpReport_RemainsOverGoods()

DROP FUNCTION IF EXISTS gpReport_RemainsOverGoods (Integer, TDateTime, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_RemainsOverGoods(
    IN inUnitId           Integer  ,  -- Подразделение
    IN inStartDate        TDateTime,  -- Дата остатка
    IN inPeriod           TFloat,    -- 
    IN inDay              TFloat,    -- 
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS  SETOF refcursor
/*TABLE (Id Integer, Price TFloat, MCSValue TFloat
             , MCSPeriod TFloat, MCSDay TFloat
             , StartDate TDateTime
             --, MCSPeriodEnd TFloat, MCSDayEnd TFloat
             , EndDate TDateTime
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupName TVarChar, NDSKindName TVarChar
             , DateChange TDateTime, MCSDateChange TDateTime
             , MCSIsClose Boolean, MCSIsCloseDateChange TDateTime
             , MCSNotRecalc Boolean, MCSNotRecalcDateChange TDateTime
             , Fix Boolean, FixDateChange TDateTime
             , MinExpirationDate TDateTime
             , Remains TFloat, SummaRemains TFloat
             , RemainsMCS_from TFloat, SummaRemainsMCS_from TFloat
             
             , PriceEnd TFloat---, MCSValueEnd TFloat
             , RemainsEnd TFloat, SummaRemainsEnd TFloat
--             , RemainsMCS_fromEnd TFloat, SummaRemainsMCS_fromEnd TFloat

             )*/
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE Cursor1 refcursor;
   DECLARE Cursor2 refcursor;
   DECLARE Cursor3 refcursor;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- замена
    inStartDate := DATE_TRUNC ('DAY', inStartDate);

    -- !!!только НЕ так определяется <Торговая сеть>!!!
    -- vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
    -- !!!только так - определяется <Торговая сеть>!!!
    vbObjectId:= (SELECT ObjectLink_Juridical_Retail.ChildObjectId
                  FROM ObjectLink AS ObjectLink_Unit_Juridical
                       INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                             ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                  WHERE ObjectLink_Unit_Juridical.ObjectId = inUnitId
                    AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                 );

    -- Таблицы
    CREATE TEMP TABLE tmpGoods_list (GoodsId Integer, UnitId Integer, PriceId Integer, PRIMARY KEY (UnitId, GoodsId)) ON COMMIT DROP;
    CREATE TEMP TABLE tmpRemains (GoodsId Integer, UnitId Integer, RemainsStart TFloat, PRIMARY KEY (UnitId, GoodsId)) ON COMMIT DROP;
    CREATE TEMP TABLE tmpMCS (GoodsId Integer, UnitId Integer, MCSValue TFloat, PRIMARY KEY (UnitId, GoodsId)) ON COMMIT DROP;
    -- Таблица - Результат
    CREATE TEMP TABLE tmpData (GoodsId Integer, UnitId Integer, MCSValue TFloat
                             , Price TFloat, StartDate TDateTime, EndDate TDateTime
                             , RemainsStart TFloat, SummaRemainsStart TFloat
                             , RemainsMCS_from TFloat, SummaRemainsMCS_from TFloat
                             , RemainsMCS_to TFloat, SummaRemainsMCS_to TFloat
                             , isClose Boolean, isTOP Boolean, isFirst Boolean, isSecond Boolean
                             , PRIMARY KEY (UnitId, GoodsId)
                              ) ON COMMIT DROP;
    -- Таблица - Результат
    CREATE TEMP TABLE tmpDataTo (GoodsId Integer, UnitId Integer, RemainsMCS_result TFloat, PRIMARY KEY (UnitId, GoodsId)) ON COMMIT DROP;


       -- Remains
       INSERT INTO tmpRemains (GoodsId, UnitId, RemainsStart)
                        SELECT tmp.GoodsId
                             , tmp.UnitId
                             , SUM (tmp.RemainsStart) AS RemainsStart
                        FROM (SELECT Container.Objectid      AS GoodsId
                                   , Container.WhereObjectId AS UnitId
                                   , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS RemainsStart
                              FROM Container
                                   INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                         ON ObjectLink_Unit_Juridical.ObjectId = Container.WhereObjectId
                                                        AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                   INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                         ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                        AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                        AND ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId
                                   LEFT JOIN MovementItemContainer AS MIContainer
                                                                   ON MIContainer.ContainerId = Container.Id
                                                                  AND MIContainer.OperDate >= inStartDate

                              WHERE Container.DescId = zc_Container_Count()
                              GROUP BY Container.Id, Container.Objectid, Container.WhereObjectId, Container.Amount
                              HAVING  Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0
                              -- LIMIT 10000
                             ) AS tmp
                        GROUP BY tmp.GoodsId
                               , tmp.UnitId
                        HAVING  SUM (tmp.RemainsStart) <> 0
                       ;

       -- MCS
       INSERT INTO tmpMCS (GoodsId, UnitId, MCSValue)
                     SELECT tmp.GoodsId
                          , tmp.UnitId
                          , tmp.MCSValue
                       FROM gpSelect_RecalcMCS (-1 * inUnitId, 0, inPeriod::Integer, inDay::Integer, inStartDate, inSession) AS tmp
                       -- FROM gpSelect_RecalcMCS (inUnitId, 0, inPeriod::Integer, inDay::Integer, inStartDate, inSession) AS tmp
                       WHERE tmp.MCSValue > 0
                      ;


       -- Goods_list
       INSERT INTO tmpGoods_list (GoodsId, UnitId, PriceId)
         SELECT tmpRemains.GoodsId, tmpRemains.UnitId, 0 AS PriceId FROM tmpRemains
        UNION
         SELECT tmpMCS.GoodsId, tmpMCS.UnitId, 0 AS PriceId FROM tmpMCS
        ;
  
       -- Goods_list - PriceId
       UPDATE tmpGoods_list SET PriceId = Price_Goods.ObjectId
       FROM ObjectLink AS Price_Goods, ObjectLink AS Price_Unit
       WHERE Price_Goods.ChildObjectId = tmpGoods_list.GoodsId
         AND Price_Goods.DescId        = zc_ObjectLink_Price_Goods()

         AND Price_Unit.ObjectId       = Price_Goods.ObjectId
         AND Price_Unit.ChildObjectId  = tmpGoods_list.UnitId
         AND Price_Unit.DescId         = zc_ObjectLink_Price_Unit()
        ;



        -- Result
        INSERT INTO tmpData  (GoodsId, UnitId, MCSValue 
                            , Price, StartDate, EndDate
                            , RemainsStart, SummaRemainsStart
                            , RemainsMCS_from, SummaRemainsMCS_from
                            , RemainsMCS_to, SummaRemainsMCS_to
                            , isClose, isTOP, isFirst, isSecond
                             )
             SELECT
                 tmpGoods_list.GoodsId
               , tmpGoods_list.UnitId
               , tmpMCS.MCSValue

               , COALESCE (ObjectHistoryFloat_Price.ValueData, 0)  AS Price
               , COALESCE (ObjectHistory_Price.StartDate, NULL)    AS StartDate
               , COALESCE (ObjectHistory_Price.EndDate, NULL)      AS EndDate

               , Object_Remains.RemainsStart                       AS RemainsStart
               , (Object_Remains.RemainsStart * COALESCE (ObjectHistoryFloat_Price.ValueData, 0)) AS SummaRemainsStart
               
               , CASE WHEN ObjectBoolean_Goods_Close.ValueData = TRUE THEN 0 WHEN Object_Remains.RemainsStart > tmpMCS.MCSValue AND tmpMCS.MCSValue > 0 THEN FLOOR (Object_Remains.RemainsStart - tmpMCS.MCSValue) ELSE 0 END AS RemainsMCS_from
               , CASE WHEN ObjectBoolean_Goods_Close.ValueData = TRUE THEN 0 WHEN Object_Remains.RemainsStart > tmpMCS.MCSValue AND tmpMCS.MCSValue > 0 THEN FLOOR (Object_Remains.RemainsStart - tmpMCS.MCSValue) * COALESCE (ObjectHistoryFloat_Price.ValueData, 0) ELSE 0 END AS RemainsMCS_from

               , CASE WHEN ObjectBoolean_Goods_Close.ValueData = TRUE THEN 0 WHEN COALESCE (Object_Remains.RemainsStart, 0) < tmpMCS.MCSValue AND tmpMCS.MCSValue > 0 THEN CEIL (tmpMCS.MCSValue - COALESCE (Object_Remains.RemainsStart, 0)) ELSE 0 END AS RemainsMCS_to
               , CASE WHEN ObjectBoolean_Goods_Close.ValueData = TRUE THEN 0 WHEN COALESCE (Object_Remains.RemainsStart, 0) < tmpMCS.MCSValue AND tmpMCS.MCSValue > 0 THEN CEIL (tmpMCS.MCSValue - COALESCE (Object_Remains.RemainsStart, 0)) * COALESCE (ObjectHistoryFloat_Price.ValueData, 0) ELSE 0 END AS RemainsMCS_to
               
               , COALESCE (ObjectBoolean_Goods_Close.ValueData, FALSE)   AS isClose
               , COALESCE (ObjectBoolean_Goods_TOP.ValueData, FALSE)     AS isTOP
               , COALESCE (ObjectBoolean_First.ValueData, FALSE)         AS isFirst
               , COALESCE (ObjectBoolean_Second.ValueData, FALSE)        AS isSecond

            FROM tmpGoods_list
                LEFT JOIN tmpRemains AS Object_Remains
                                     ON Object_Remains.GoodsId = tmpGoods_list.GoodsId
                                    AND Object_Remains.UnitId = tmpGoods_list.UnitId
                LEFT JOIN tmpMCS ON tmpMCS.GoodsId = tmpGoods_list.GoodsId
                                AND tmpMCS.UnitId =  tmpGoods_list.UnitId
                -- получаем значения цены и НТЗ из истории значений на начало дня                                                          
                LEFT JOIN ObjectHistory AS ObjectHistory_Price
                                        ON ObjectHistory_Price.ObjectId = tmpGoods_list.PriceId
                                       AND ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
                                       AND inStartDate >= ObjectHistory_Price.StartDate AND inStartDate < ObjectHistory_Price.EndDate
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price
                                             ON ObjectHistoryFloat_Price.ObjectHistoryId = ObjectHistory_Price.Id
                                            AND ObjectHistoryFloat_Price.DescId = zc_ObjectHistoryFloat_Price_Value()

                LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Close
                                        ON ObjectBoolean_Goods_Close.ObjectId = tmpGoods_list.GoodsId
                                       AND ObjectBoolean_Goods_Close.DescId = zc_ObjectBoolean_Goods_Close()   
                LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                        ON ObjectBoolean_Goods_TOP.ObjectId = tmpGoods_list.GoodsId
                                       AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP()  
                LEFT JOIN ObjectBoolean AS ObjectBoolean_First
                                        ON ObjectBoolean_First.ObjectId = tmpGoods_list.GoodsId
                                       AND ObjectBoolean_First.DescId = zc_ObjectBoolean_Goods_First() 
                LEFT JOIN ObjectBoolean AS ObjectBoolean_Second
                                        ON ObjectBoolean_Second.ObjectId = tmpGoods_list.GoodsId
                                       AND ObjectBoolean_Second.DescId = zc_ObjectBoolean_Goods_Second()
            ;
       

     -- !!!ResultTO!!!
  WITH tmpDataFrom AS (SELECT GoodsId, RemainsMCS_from -- количество "излишков" в одной аптеке
                       FROM tmpData
                       WHERE UnitId = inUnitId AND RemainsMCS_from > 0
                      )
       , tmpDataTo AS (SELECT UnitId, GoodsId, RemainsMCS_to -- количество "не хватает" в остальных аптеках
                       FROM tmpData
                       WHERE UnitId <> inUnitId AND RemainsMCS_to > 0
                      )
      , tmpDataAll AS (SELECT tmpDataTo.UnitId
                            , tmpDataTo.GoodsId
                            , tmpDataTo.RemainsMCS_to
                            , tmpDataFrom.RemainsMCS_from
                              -- "накопительная" сумма "не хватает" = все предыдущие + текущая запись , !!!обязательно сортировка аналогичная с № п/п!!!
                            , SUM (tmpDataTo.RemainsMCS_to) OVER (PARTITION BY tmpDataTo.GoodsId ORDER BY tmpDataTo.RemainsMCS_to DESC, tmpDataTo.UnitId DESC) AS RemainsMCS_period
                              -- № п/п, начинаем с максимального количества "не хватает"
                            , ROW_NUMBER() OVER (PARTITION BY tmpDataTo.GoodsId ORDER BY tmpDataTo.RemainsMCS_to DESC, tmpDataTo.UnitId DESC) AS Ord
                       FROM tmpDataFrom
                            INNER JOIN tmpDataTo ON tmpDataTo.GoodsId = tmpDataFrom.GoodsId
                      )
   INSERT INTO tmpDataTo (GoodsId, UnitId, RemainsMCS_result)
   SELECT tmpDataAll.GoodsId
        , tmpDataAll.UnitId
        /*, tmpDataAll.RemainsMCS_from
        , tmpDataAll.RemainsMCS_to
        , tmpDataAll.RemainsMCS_period
        , tmpDataAll.Ord*/
        , CASE -- для первого - учитывается ТОЛЬКО "не хватает"
               WHEN Ord = 1 THEN CASE WHEN RemainsMCS_to <= RemainsMCS_from THEN RemainsMCS_to ELSE RemainsMCS_from END
               -- для остальных - учитывается "накопительная" сумма "не хватает" !!!минус!!! то что в текущей записи
               WHEN RemainsMCS_from - (RemainsMCS_period - RemainsMCS_to) > 0 -- сколько осталось "излишков" если всем предыдущим уже распределили
                    THEN CASE -- если "не хватает" меньше сколько осталось "излишков"
                              WHEN RemainsMCS_to <= RemainsMCS_from - (RemainsMCS_period - RemainsMCS_to)
                                   THEN RemainsMCS_to
                              ELSE -- иначе остаток "излишков"
                                   RemainsMCS_from - (RemainsMCS_period - RemainsMCS_to)
                         END
               ELSE 0
          END AS RemainsMCS_result
   FROM tmpDataAll
   WHERE  CASE -- для первого - учитывается ТОЛЬКО "не хватает"
               WHEN Ord = 1 THEN CASE WHEN RemainsMCS_to <= RemainsMCS_from THEN RemainsMCS_to ELSE RemainsMCS_from END
               -- для остальных - учитывается "накопительная" сумма "не хватает" !!!минус!!! то что в текущей записи
               WHEN RemainsMCS_from - (RemainsMCS_period - RemainsMCS_to) > 0 -- сколько осталось "излишков" если всем предыдущим уже распределили
                    THEN CASE -- если "не хватает" меньше сколько осталось "излишков"
                              WHEN RemainsMCS_to <= RemainsMCS_from - (RemainsMCS_period - RemainsMCS_to)
                                   THEN RemainsMCS_to
                              ELSE -- иначе остаток "излишков"
                                   RemainsMCS_from - (RemainsMCS_period - RemainsMCS_to)
                         END
               ELSE 0
          END <> 0
         ;


--  RAISE EXCEPTION '<%>  <%>  <%>  <%>', (select Count (*) from tmpGoods_list), (select Count (*) from tmpDataTo), (select Count (*) from tmpData where UnitId = inUnitId), (select Count (*) from tmpData where UnitId <> inUnitId);


     OPEN Cursor1 FOR
     
     WITH tmpChild AS (SELECT tmpData.GoodsId
                            , SUM (tmpData.RemainsMCS_from) AS RemainsMCS_from, SUM (tmpData.SummaRemainsMCS_from) AS SummaRemainsMCS_from
                            , SUM (tmpData.RemainsMCS_to)   AS RemainsMCS_to,   SUM (tmpData.SummaRemainsMCS_to)   AS SummaRemainsMCS_to
                            , SUM (tmpData.MCSValue)                 AS MCSValue
                            , SUM (tmpData.MCSValue * tmpData.Price) AS SummaMCSValue
                       FROM tmpData
                       WHERE tmpData.UnitId <> inUnitId
                       GROUP BY tmpData.GoodsId
                      )
      , tmpChildTo AS (SELECT tmpDataTo.GoodsId
                            , SUM (tmpDataTo.RemainsMCS_result) AS RemainsMCS_result
                       FROM tmpDataTo
                       GROUP BY tmpDataTo.GoodsId
                      )
          SELECT tmpData.StartDate
               , tmpData.EndDate
               , tmpData.Price

               , tmpData.MCSValue
               , (tmpData.MCSValue * tmpData.Price) :: TFloat AS SummaMCSValue

               , tmpData.RemainsStart
               , tmpData.SummaRemainsStart
               , tmpData.RemainsMCS_from
               , tmpData.SummaRemainsMCS_from
               , tmpData.RemainsMCS_to
               , tmpData.SummaRemainsMCS_to

               , tmpChild.MCSValue             :: TFloat  AS MCSValue_Child
               , tmpChild.SummaMCSValue        :: TFloat  AS SummaMCSValue_Child
               , tmpChild.RemainsMCS_from      :: TFloat  AS RemainsMCS_from_Child
               , tmpChild.SummaRemainsMCS_from :: TFloat  AS SummaRemainsMCS_from_Child
               , tmpChild.RemainsMCS_to        :: TFloat  AS RemainsMCS_to_Child
               , tmpChild.SummaRemainsMCS_to   :: TFloat  AS SummaRemainsMCS_to_Child
               
               , tmpChildTo.RemainsMCS_result                   :: TFloat AS RemainsMCS_result
               , (tmpChildTo.RemainsMCS_result * tmpData.Price) :: TFloat AS SummaRemainsMCS_result


               , tmpData.GoodsId
               , tmpData.isClose
               , tmpData.isTOP
               , tmpData.isFirst
               , tmpData.isSecond
               , Object_Goods.ObjectCode                      AS GoodsCode
               , Object_Goods.ValueData                       AS GoodsName
               , Object_Goods.isErased                        AS isErased
               , Object_GoodsGroup.ValueData                  AS GoodsGroupName
               , Object_NDSKind.ValueData                     AS NDSKindName
               , Object_Measure.ValueData                     AS MeasureName
             
     FROM tmpData
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
                LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                     ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpData.GoodsId
                                    AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId 

                LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                     ON ObjectLink_Goods_NDSKind.ObjectId = tmpData.GoodsId
                                    AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
                LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId     

                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                     ON ObjectLink_Goods_Measure.ObjectId = tmpData.GoodsId
                                    AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId     

                LEFT JOIN tmpChild ON tmpChild.GoodsId = tmpData.GoodsId
                LEFT JOIN tmpChildTo ON tmpChildTo.GoodsId = tmpData.GoodsId

     WHERE tmpData.UnitId = inUnitId;

     RETURN NEXT Cursor1;


    -- Результат 2

     OPEN Cursor2 FOR

       SELECT    Object_Unit.Id        AS UnitId
               , Object_Unit.ValueDAta AS UnitName 
               , tmpData.GoodsId
               , tmpData.MCSValue
               , (tmpData.MCSValue * tmpData.Price) :: TFloat AS SummaMCSValue

               , tmpData.StartDate
               , tmpData.EndDate
               , tmpData.Price

               , tmpData.RemainsStart
               , tmpData.SummaRemainsStart
               , tmpData.RemainsMCS_from
               , tmpData.SummaRemainsMCS_from
               , tmpData.RemainsMCS_to
               , tmpData.SummaRemainsMCS_to

               , tmpDataTo.RemainsMCS_result
               , (tmpDataTo.RemainsMCS_result * tmpData.Price) :: TFloat AS SummaRemainsMCS_result
               
                  
     FROM tmpData
          LEFT JOIN Object AS Object_Unit  on Object_Unit.Id = tmpData.UnitId
          LEFT JOIN tmpDataTo ON tmpDataTo.GoodsId = tmpData.GoodsId AND tmpDataTo.UnitId = tmpData.UnitId
          LEFT JOIN tmpData AS tmpDataFrom ON tmpDataFrom.GoodsId = tmpData.GoodsId AND tmpDataFrom.UnitId = inUnitId
     WHERE tmpData.UnitId <> inUnitId
       -- AND tmpDataTo.RemainsMCS_result > 0
       AND (tmpDataTo.RemainsMCS_result > 0 OR tmpDataFrom.RemainsMCS_to > 0)
     -- LIMIT 50000
    ;
     
     RETURN NEXT Cursor2;

     -- Результат 3
     -- !!!дублируем Cursor2!!!
     OPEN Cursor3 FOR
       SELECT    Object_Unit.Id        AS UnitId
               , Object_Unit.ValueDAta AS UnitName 
               , tmpData.GoodsId
               , tmpData.MCSValue
               , (tmpData.MCSValue * tmpData.Price) :: TFloat AS SummaMCSValue

               , tmpData.StartDate
               , tmpData.EndDate
               , tmpData.Price
               , tmpDataFrom.Price  :: TFloat  AS PriceFrom 

               , tmpData.RemainsStart
               , tmpData.SummaRemainsStart
               , tmpData.RemainsMCS_from
               , tmpData.SummaRemainsMCS_from
               , tmpData.RemainsMCS_to
               , tmpData.SummaRemainsMCS_to

               , tmpDataTo.RemainsMCS_result
               , (tmpDataTo.RemainsMCS_result * tmpData.Price) :: TFloat AS SummaRemainsMCS_result
               
                  
     FROM tmpData
          LEFT JOIN Object AS Object_Unit  on Object_Unit.Id = tmpData.UnitId
          LEFT JOIN tmpDataTo ON tmpDataTo.GoodsId = tmpData.GoodsId AND tmpDataTo.UnitId = tmpData.UnitId
          LEFT JOIN tmpData AS tmpDataFrom ON tmpDataFrom.GoodsId = tmpData.GoodsId AND tmpDataFrom.UnitId = inUnitId
     WHERE tmpData.UnitId <> inUnitId
       -- AND tmpDataTo.RemainsMCS_result > 0
       AND (tmpDataTo.RemainsMCS_result > 0 OR tmpDataFrom.RemainsMCS_to > 0)
     --LIMIT 50000
    ;
     RETURN NEXT Cursor3;
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 09.06.16         *
*/

-- тест
-- SELECT * FROM gpReport_RemainsOverGoods (inUnitId:= 183292, inStartDate:= '01.06.2016', inPeriod:= 30, inDay:= 5, inSession:= '3');  -- Аптека_1 пр_Правды_6
