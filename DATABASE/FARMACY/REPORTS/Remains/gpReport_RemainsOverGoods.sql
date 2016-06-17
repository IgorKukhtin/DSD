-- Function: gpSelect_Movement_Income()

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
             , StartDateEnd TDateTime
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupName TVarChar, NDSKindName TVarChar
             , DateChange TDateTime, MCSDateChange TDateTime
             , MCSIsClose Boolean, MCSIsCloseDateChange TDateTime
             , MCSNotRecalc Boolean, MCSNotRecalcDateChange TDateTime
             , Fix Boolean, FixDateChange TDateTime
             , MinExpirationDate TDateTime
             , Remains TFloat, SummaRemains TFloat
             , RemainsNotMCS TFloat, SummaNotMCS TFloat
             
             , PriceEnd TFloat---, MCSValueEnd TFloat
             , RemainsEnd TFloat, SummaRemainsEnd TFloat
--             , RemainsNotMCSEnd TFloat, SummaNotMCSEnd TFloat

             )*/
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE Cursor1 refcursor;
   DECLARE Cursor2 refcursor;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    -- Ограничение на просмотр товарного справочника
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    inStartDate := ( '' ||inStartDate::Date || ' 00:00:00'):: TDateTime;

    IF inUnitId is null
    THEN
        inUnitId := 0;
    END IF;

    -- Результат
    CREATE TEMP TABLE tmpUnit (UnitId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE tmpGoodsList (GoodsId Integer, UnitId  Integer) ON COMMIT DROP;
    CREATE TEMP TABLE tmpGoods(GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
                             , GoodsGroupName TVarChar, NDSKindName TVarChar
                             , isClose Boolean, isTOP Boolean, isFirst Boolean, isSecond Boolean
                             ) ON COMMIT DROP;

    CREATE TEMP TABLE tmpPrice (PriceId Integer, GoodsId Integer, UnitId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE tmpRemeins (objectid Integer, Remains tfloat, RemainsEnd tfloat, UnitId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE tmpMCS (MCSValue tfloat, GoodsId Integer, UnitId Integer) ON COMMIT DROP;

    CREATE TEMP TABLE tmpData (Price TFloat, MCSValue TFloat
                             , MCSPeriod TFloat, MCSDay TFloat
                             , StartDate TDateTime
                             , StartDateEnd TDateTime
                             , GoodsId Integer
                             , Remains TFloat, SummaRemains TFloat
                             , RemainsNotMCS TFloat, SummaNotMCS TFloat
                             , Deficit TFloat, SummaDeficit TFloat
                             , UnitId Integer
                             , primary key (UnitId, GoodsId)
                              ) ON COMMIT DROP;


                    
        INSERT INTO tmpRemeins (objectid, Remains, UnitId)
                        SELECT tmp.objectid,
                               SUM(tmp.Remains)     AS Remains,
                               tmp.UnitId
                        FROM (SELECT container.objectid,
                                     Container.WhereObjectId AS UnitId,
                                    COALESCE(container.Amount,0) - COALESCE(SUM(MIContainer.Amount), 0)   AS Remains 
                              FROM Container
                                    LEFT JOIN MovementItemContainer AS MIContainer 
                                                                    ON MIContainer.ContainerId = container.Id
                                                                   AND MIContainer.OperDate >= DATE_TRUNC ('DAY', inStartDate)
                              WHERE container.descid = zc_container_count() 
                             -- AND Container.WhereObjectId = inUnitId--377610 --inUnitId
                              GROUP BY container.objectid,COALESCE(container.Amount,0), container.Id,Container.WhereObjectId 
                              HAVING  COALESCE(container.Amount,0) - COALESCE(SUM(MIContainer.Amount), 0)<>0 
                             -- LIMIT 10000
                             ) AS tmp
 
                        GROUP BY tmp.objectid, tmp.UnitId;

       INSERT INTO tmpMCS (MCSValue, GoodsId, UnitId)
                     SELECT tmp.MCSValue 
                          , tmp.GoodsId 
                          , tmp.UnitId 
                       FROM gpSelect_RecalcMCS(0, 0, inPeriod::Integer, inDay::Integer, inStartDate, inSession) AS tmp;

       INSERT INTO tmpGoodsList (GoodsId, UnitId)
         SELECT tmpRemeins.objectid AS GoodsId, tmpRemeins.UnitId
         FROM tmpRemeins
       Union 
         SELECT tmpMCS.Goodsid AS GoodsId, tmpMCS.UnitId
         FROM tmpMCS where tmpMCS.mcsvalue <> 0;
  
        INSERT INTO tmpPrice (PriceId, GoodsId, UnitId)
                    SELECT Price_Goods.ObjectId AS PriceId
                         , tmpGoodsList.GoodsId AS GoodsId
                         , tmpGoodsList.UnitId  AS UnitId
                    FROM tmpGoodsList
                        INNER JOIN ObjectLink AS Price_Goods 
                                             ON Price_Goods.ChildObjectId = tmpGoodsList.GoodsId
                                            AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                                
                        INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                             ON ObjectLink_Price_Unit.ObjectId = Price_Goods.ObjectId
                                            AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                            AND ObjectLink_Price_Unit.ChildObjectId = tmpGoodsList.UnitId;
       INSERT INTO  tmpGoods ( GoodsId, GoodsCode, GoodsName
                             , GoodsGroupName, NDSKindName
                             , isClose, isTOP, isFirst, isSecond)
            SELECT tmpGoodsList.GoodsId
                 , Object_Goods.ObjectCode                      AS GoodsCode
                 , Object_Goods.ValueData                       AS GoodsName
                 , Object_GoodsGroup.ValueData                  AS GoodsGroupName
                 , Object_NDSKind.ValueData                     AS NDSKindName

                 , COALESCE(ObjectBoolean_Goods_Close.ValueData, false)   AS isClose
                 , COALESCE(ObjectBoolean_Goods_TOP.ValueData, false)     AS isTOP
                 , COALESCE(ObjectBoolean_First.ValueData, False)         AS isFirst
                 , COALESCE(ObjectBoolean_Second.ValueData, False)        AS isSecond
            FROM (SELECT DISTINCT GoodsId FROM tmpGoodsList) AS tmpGoodsList
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoodsList.GoodsId

                LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                     ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpGoodsList.GoodsId
                                    AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId 

                LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                     ON ObjectLink_Goods_NDSKind.ObjectId = tmpGoodsList.GoodsId
                                    AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
                LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId     

                LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Close
                                        ON ObjectBoolean_Goods_Close.ObjectId = tmpGoodsList.GoodsId
                                       AND ObjectBoolean_Goods_Close.DescId = zc_ObjectBoolean_Goods_Close()   
                LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                        ON ObjectBoolean_Goods_TOP.ObjectId = tmpGoodsList.GoodsId
                                       AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP()  
                LEFT JOIN ObjectBoolean AS ObjectBoolean_First
                                        ON ObjectBoolean_First.ObjectId = tmpGoodsList.GoodsId
                                       AND ObjectBoolean_First.DescId = zc_ObjectBoolean_Goods_First() 
                LEFT JOIN ObjectBoolean AS ObjectBoolean_Second
                                        ON ObjectBoolean_Second.ObjectId = tmpGoodsList.GoodsId
                                       AND ObjectBoolean_Second.DescId = zc_ObjectBoolean_Goods_Second();

        INSERT INTO tmpData  ( Price
                             , MCSValue 
                             , MCSPeriod, MCSDay
                             , StartDate, StartDateEnd
                             , GoodsId
                             
                             , Remains, SummaRemains
                             , RemainsNotMCS, SummaNotMCS
                             , Deficit, SummaDeficit
                             , Unitid)
                             
             SELECT
                 COALESCE (ObjectHistoryFloat_Price.ValueData, 0)  AS Price
               , COALESCE(tmpMCS.MCSValue,0)                       AS MCSValue
               , inPeriod                AS MCSPeriod
               , inDay                   AS MCSDay
               , COALESCE (ObjectHistory_Price.StartDate, NULL)    AS StartDate
               , COALESCE (ObjectHistory_Price.EndDate, NULL)      AS StartDateEnd
               , tmpGoodsList.GoodsId

               , Object_Remains.Remains                          AS Remains
               , (Object_Remains.Remains * COALESCE (ObjectHistoryFloat_Price.ValueData, 0)) AS SummaRemains
               
               , CASE WHEN COALESCE (Object_Remains.Remains, 0) > COALESCE(tmpMCS.MCSValue,0) THEN COALESCE (Object_Remains.Remains, 0) - COALESCE (tmpMCS.MCSValue,0) ELSE 0 END :: TFloat AS RemainsNotMCS  --over
               , CASE WHEN COALESCE (Object_Remains.Remains, 0) > COALESCE(tmpMCS.MCSValue,0) THEN (COALESCE (Object_Remains.Remains, 0) - COALESCE(tmpMCS.MCSValue,0)) * COALESCE (ObjectHistoryFloat_Price.ValueData, 0) ELSE 0 END :: TFloat AS SummaNotMCS

               , CASE WHEN COALESCE (Object_Remains.Remains, 0) < COALESCE(tmpMCS.MCSValue,0) THEN COALESCE (tmpMCS.MCSValue,0) - COALESCE (Object_Remains.Remains, 0) ELSE 0 END :: TFloat AS Deficit
               , CASE WHEN COALESCE (Object_Remains.Remains, 0) < COALESCE(tmpMCS.MCSValue,0) THEN (COALESCE(tmpMCS.MCSValue,0) - COALESCE (Object_Remains.Remains, 0)) * COALESCE (ObjectHistoryFloat_Price.ValueData, 0) ELSE 0 END :: TFloat AS SummaDeficit

               , tmpGoodsList.UnitId
               
            FROM tmpGoodsList
               
                LEFT JOIN tmpPrice ON tmpPrice.GoodsId = tmpGoodsList.GoodsId
                                  AND tmpPrice.UnitId = tmpGoodsList.UnitId
                                                               
                LEFT JOIN tmpRemeins AS Object_Remains
                                     ON Object_Remains.ObjectId = tmpGoodsList.GoodsId
                                    AND Object_Remains.UnitId = tmpGoodsList.UnitId

                LEFT JOIN tmpMCS ON tmpMCS.GoodsId = tmpGoodsList.GoodsId
                                AND tmpMCS.UnitId =  tmpGoodsList.UnitId
                               
                -- получаем значения цены и НТЗ из истории значений на начало дня                                                          
                LEFT JOIN ObjectHistory AS ObjectHistory_Price
                                        ON ObjectHistory_Price.ObjectId = tmpPrice.PriceId
                                       AND ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
                                       AND inStartDate >= ObjectHistory_Price.StartDate AND inStartDate < ObjectHistory_Price.EndDate
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price
                                             ON ObjectHistoryFloat_Price.ObjectHistoryId = ObjectHistory_Price.Id
                                            AND ObjectHistoryFloat_Price.DescId = zc_ObjectHistoryFloat_Price_Value()
            ;

       
--  RAISE EXCEPTION '<%>  <%>', (select count (*) from tmpData), (select count (*) from tmpData where UnitId = inUnitId);
--  RAISE EXCEPTION '<%>  <%>', (select count (*) from tmpData where UnitId = inUnitId), (select count (*) from tmpData where UnitId <> inUnitId);



     OPEN Cursor1 FOR
     
     SELECT      tmpData.MCSValue        :: TFLOAT     
               , tmpData.MCSPeriod       :: TFLOAT     
               , tmpData.MCSDay          :: TFLOAT     
               , tmpData.StartDate       :: TDateTime 
               , tmpData.StartDateEnd    :: TDateTime 
               , tmpData.Price           :: TFloat
               , tmpData.Remains         :: TFloat       
               , tmpData.SummaRemains    :: TFloat       
               , tmpData.RemainsNotMCS   :: TFloat
               , tmpData.SummaNotMCS     :: TFloat
               , tmpData.Deficit         :: TFloat       
               , tmpData.SummaDeficit    :: TFloat

               , tmpChild.RemainsNotMCS   :: TFloat  AS RemainsNotMCS_Child
               , tmpChild.SummaNotMCS     :: TFloat  AS SummaNotMCS_Child
               , tmpChild.Deficit         :: TFloat  AS Deficit_Child
               , tmpChild.SummaDeficit    :: TFloat  AS SummaDeficit_Child
               
               , tmpData.GoodsId          :: integer   
               , tmpGoods.GoodsCode       :: integer    
               , tmpGoods.GoodsName       :: TVarChar   
               , tmpGoods.GoodsGroupName  :: TVarChar   
               , tmpGoods.NDSKindName     :: TVarChar   
               , tmpGoods.isClose         :: Boolean
               , tmpGoods.isTOP           :: Boolean
               , tmpGoods.isFirst         :: Boolean
               , tmpGoods.isSecond        :: Boolean
             
     FROM tmpData
       LEFT JOIN tmpGoods ON tmpGoods.GoodsId = tmpData.GoodsId
       LEFT JOIN (SELECT tmpData.GoodsId
                       , SUM(tmpData.RemainsNotMCS) AS RemainsNotMCS, SUM(tmpData.SummaNotMCS) AS SummaNotMCS
                       , SUM(tmpData.Deficit) AS Deficit, SUM(tmpData.SummaDeficit) AS SummaDeficit
                  FROM tmpData
                  WHERE tmpData.UnitId <> inUnitId
                  GROUP BY tmpData.GoodsId) AS tmpChild ON tmpChild.GoodsId = tmpData.GoodsId

     WHERE tmpData.UnitId = inUnitId;
     RETURN NEXT Cursor1;

    -- Результат 2

     OPEN Cursor2 FOR

       SELECT    Object_Unit.ValueDAta   :: TVarChar    AS UnitName 
               , tmpData.MCSValue        :: TFLOAT     
               , tmpData.MCSPeriod       :: TFLOAT     
               , tmpData.MCSDay          :: TFLOAT     
               , tmpData.StartDate       :: TDateTime 
               , tmpData.StartDateEnd    :: TDateTime 
               , tmpData.Price           :: TFloat
               , tmpData.Remains         :: TFloat       
               , tmpData.SummaRemains    :: TFloat       
               , tmpData.RemainsNotMCS   :: TFloat
               , tmpData.SummaNotMCS     :: TFloat
               , tmpData.Deficit         :: TFloat       
               , tmpData.SummaDeficit    :: TFloat
               
               , tmpData.GoodsId         :: integer                
                  
     FROM tmpData
          LEFT JOIN Object AS Object_Unit  on Object_Unit.Id = tmpData.UnitId
     WHERE tmpData.UnitId <> inUnitId;
     
     RETURN NEXT Cursor2;

     
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 09.06.16         *
*/

-- тест
-- select * from gpReport_RemainsOverGoods(inUnitId := 183292, inStartDate:= '01.06.2016', inPeriod := 30 ::TFloat , inDay := 5 ::TFloat, inSession := '3'::TVarChar)
