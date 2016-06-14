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

    IF inUnitId is null
    THEN
        inUnitId := 0;
    END IF;

    -- Результат
    CREATE TEMP TABLE tmpUnit (UnitId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE tmpGoodsList (GoodsId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE tmpGoods(GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
                             , GoodsGroupName TVarChar, NDSKindName TVarChar
                             , isClose Boolean, isTOP Boolean, isFirst Boolean, isSecond Boolean
                             ) ON COMMIT DROP;

    CREATE TEMP TABLE tmpPrice (PriceId Integer, GoodsId Integer, UnitId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE tmpRemeins (objectid Integer, Remains tfloat, RemainsEnd tfloat, UnitId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE tmpMCS (MCSValue tfloat, GoodsId Integer, UnitId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE tmpData_1 (Id Integer, Price TFloat, MCSValue TFloat
                             , MCSPeriod TFloat, MCSDay TFloat
                             , StartDate TDateTime
                             , StartDateEnd TDateTime
                             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
                             , GoodsGroupName TVarChar, NDSKindName TVarChar
                             , isClose Boolean, isTOP Boolean, isFirst Boolean, isSecond Boolean
                             , DateChange TDateTime, MCSDateChange TDateTime
                             , MCSIsClose Boolean, MCSIsCloseDateChange TDateTime
                             , MCSNotRecalc Boolean, MCSNotRecalcDateChange TDateTime
                             , Fix Boolean, FixDateChange TDateTime
                             , Remains TFloat, SummaRemains TFloat
                             , RemainsNotMCS TFloat, SummaNotMCS TFloat
                             , PriceEnd TFloat
                             , RemainsEnd TFloat, SummaRemainsEnd TFloat
                             , RemainsNotMCSEnd TFloat, SummaNotMCSEnd TFloat
                             , UnitId Integer) ON COMMIT DROP;

    CREATE TEMP TABLE tmpData (Id Integer, Price TFloat, MCSValue TFloat
                             , MCSPeriod TFloat, MCSDay TFloat
                             , StartDate TDateTime
                             , StartDateEnd TDateTime
                             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
                             , GoodsGroupName TVarChar, NDSKindName TVarChar
                             , isClose Boolean, isTOP Boolean, isFirst Boolean, isSecond Boolean
                             , DateChange TDateTime, MCSDateChange TDateTime
                             , MCSIsClose Boolean, MCSIsCloseDateChange TDateTime
                             , MCSNotRecalc Boolean, MCSNotRecalcDateChange TDateTime
                             , Fix Boolean, FixDateChange TDateTime
                             , Remains TFloat, SummaRemains TFloat
                             , RemainsNotMCS TFloat, SummaNotMCS TFloat
                             , PriceEnd TFloat
                             , RemainsEnd TFloat, SummaRemainsEnd TFloat
                             , RemainsNotMCSEnd TFloat, SummaNotMCSEnd TFloat
                             , UnitId Integer) ON COMMIT DROP;

    

                    
        INSERT INTO tmpRemeins (objectid, Remains, RemainsEnd, UnitId)
                        SELECT tmp.objectid,
                               SUM(tmp.Remains)     AS Remains,
                               SUM(tmp.RemainsEnd)  AS RemainsEnd,
                               tmp.UnitId
                        FROM (SELECT container.objectid,
                                     Container.WhereObjectId AS UnitId,
                                    COALESCE(container.Amount,0) - COALESCE(SUM(MIContainer.Amount), 0)   AS Remains , 
                                    (COALESCE(container.Amount,0) - SUM (CASE WHEN MIContainer.OperDate >= DATE_TRUNC ('DAY', inStartDate )+interval '1 day' then COALESCE(MIContainer.Amount, 0) ELSE 0 END)) AS RemainsEnd
                              FROM Container
                                    LEFT JOIN MovementItemContainer AS MIContainer 
                                                                    ON MIContainer.ContainerId = container.Id
                                                                   AND MIContainer.OperDate >= DATE_TRUNC ('DAY', inStartDate)
                              WHERE container.descid = zc_container_count() 
                             --  AND Container.WhereObjectId = inUnitId--377610 --inUnitId
                              GROUP BY container.objectid,COALESCE(container.Amount,0), container.Id,Container.WhereObjectId 
                               HAVING  COALESCE(container.Amount,0) - COALESCE(SUM(MIContainer.Amount), 0)<>0 
                                   OR 
                                     (COALESCE(container.Amount,0) - SUM (CASE WHEN MIContainer.OperDate >= DATE_TRUNC ('DAY', inStartDate )+interval '1 day' then COALESCE(MIContainer.Amount, 0) ELSE 0 END))  <> 0
                             ) AS tmp
                        GROUP BY tmp.objectid, tmp.UnitId
                        limit 10000
                       ;

       INSERT INTO tmpMCS (MCSValue, GoodsId, UnitId)
                     SELECT tmp.MCSValue 
                          , tmp.GoodsId 
                          , tmp.UnitId 
                       FROM gpSelect_RecalcMCS(0, 0, inPeriod::Integer, inDay::Integer, inStartDate, inSession) AS tmp;
       
                   /*  FROM (SELECT * FROM tmpRemeins WHERE tmpRemeins.Remains >0 OR tmpRemeins.RemainsEND >0) AS tmpRemeins
                       LEFT JOIN gpSelect_RecalcMCS(tmpRemeins.UnitId, 0/*tmpRemeins.objectid*/ , inPeriod::Integer, inDay::Integer, inStartDate, inSession) AS tmp 
                              ON tmp.UnitId  = tmpRemeins.UnitId
                             AND tmp.GoodsId = tmpRemeins.objectid;
                    */

       INSERT INTO tmpGoodsList (GoodsId)
         SELECT DISTINCT tmpRemeins.objectid AS GoodsId
         FROM tmpRemeins
       Union 
         SELECT DISTINCT tmpMCS.Goodsid AS GoodsId
         FROM tmpMCS where tmpMCS.mcsvalue <> 0;

        INSERT INTO tmpPrice (PriceId, GoodsId, UnitId)
                   /* SELECT Price_Goods.ObjectId      AS PriceId
                         , Price_Goods.ChildObjectId AS GoodsId
                         , ObjectLink_Price_Unit.ChildObjectId AS UnitId
                    FROM tmpGoodsList
                        LEFT JOIN ObjectLink AS Price_Goods 
                                             ON Price_Goods.ChildObjectId = tmpGoodsList.GoodsId
                                            AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                                
                        LEFT JOIN ObjectLink AS ObjectLink_Price_Unit
                                             ON ObjectLink_Price_Unit.ObjectId = Price_Goods.ObjectId
                                            AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()*/
 SELECT Price_Goods.ObjectId      AS PriceId
                         , Price_Goods.ChildObjectId AS GoodsId
                         , ObjectLink_Price_Unit.ChildObjectId AS UnitId
                    FROM ObjectLink AS Price_Goods
                        LEFT JOIN ObjectLink AS ObjectLink_Price_Unit
                                             ON ObjectLink_Price_Unit.ObjectId = Price_Goods.ObjectId
                                            AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                    WHERE Price_Goods.DescId = zc_ObjectLink_Price_Goods();
                    
       INSERT INTO  tmpGoods ( GoodsId, GoodsCode, GoodsName
                             , GoodsGroupName, NDSKindName
                             , isClose, isTOP, isFirst, isSecond)
            SELECT Object_Goods.id                              AS GoodsId
                 , Object_Goods.ObjectCode                      AS GoodsCode
                 , Object_Goods.ValueData                       AS GoodsName
                 , Object_GoodsGroup.ValueData                  AS GoodsGroupName
                 , Object_NDSKind.ValueData                     AS NDSKindName

                 , COALESCE(ObjectBoolean_Goods_Close.ValueData, false)   AS isClose
                 , COALESCE(ObjectBoolean_Goods_TOP.ValueData, false)     AS isTOP
                 , COALESCE(ObjectBoolean_First.ValueData, False)         AS isFirst
                 , COALESCE(ObjectBoolean_Second.ValueData, False)        AS isSecond
            FROM tmpGoodsList
                INNER JOiN ObjectLink ON ObjectLink.ObjectId = tmpGoodsList.GoodsId
                                    AND ObjectLink.DescId = zc_ObjectLink_Goods_Object()
                                    AND ObjectLink.ChildObjectId = vbObjectId
                                     
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoodsList.GoodsId
                                                 AND Object_Goods.DescId= zc_Object_Goods() 
                                                 AND Object_Goods.isErased = False
                LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                     ON ObjectLink_Goods_GoodsGroup.ObjectId = ObjectLink.ObjectId
                                    AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId 

                LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                     ON ObjectLink_Goods_NDSKind.ObjectId = ObjectLink.ObjectId
                                    AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
                LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId     

                LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Close
                                        ON ObjectBoolean_Goods_Close.ObjectId = ObjectLink.ObjectId
                                       AND ObjectBoolean_Goods_Close.DescId = zc_ObjectBoolean_Goods_Close()   
                LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                        ON ObjectBoolean_Goods_TOP.ObjectId = ObjectLink.ObjectId
                                       AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP()  
                LEFT JOIN ObjectBoolean AS ObjectBoolean_First
                                        ON ObjectBoolean_First.ObjectId = ObjectLink.ObjectId
                                       AND ObjectBoolean_First.DescId = zc_ObjectBoolean_Goods_First() 
                LEFT JOIN ObjectBoolean AS ObjectBoolean_Second
                                        ON ObjectBoolean_Second.ObjectId = ObjectLink.ObjectId
                                       AND ObjectBoolean_Second.DescId = zc_ObjectBoolean_Goods_Second();

        INSERT INTO tmpData( /*Price
                             , */MCSValue 
                             , MCSPeriod, MCSDay
                          --   , StartDate, StartDateEnd
                             , GoodsId, GoodsCode, GoodsName
                             , GoodsGroupName, NDSKindName
                             , isClose, isTOP, isFirst, isSecond
                             
                             , Remains--, SummaRemains
                             , RemainsNotMCS--, SummaNotMCS
                             , RemainsEnd--, SummaRemainsEnd
                             , RemainsNotMCSEnd--, SummaNotMCSEnd
                             , Unitid)
                             
             SELECT
                 /*COALESCE (ObjectHistoryFloat_Price.ValueData, 0)  AS Price
               , */COALESCE(tmpMCS.MCSValue,0)                       AS MCSValue
               , inPeriod                AS MCSPeriod
               , inDay                   AS MCSDay
               --, COALESCE (ObjectHistory_Price.StartDate, NULL)    AS StartDate
               --, COALESCE (ObjectHistory_PriceEnd.StartDate, NULL) AS StartDateEnd
               , tmpGoods.GoodsId
               , tmpGoods.GoodsCode
               , tmpGoods.GoodsName
               , tmpGoods.GoodsGroupName
               , tmpGoods.NDSKindName
               , tmpGoods.isClose
               , tmpGoods.isTOP
               , tmpGoods.isFirst
               , tmpGoods.isSecond

               , Object_Remains.Remains                          AS Remains
            --   , (Object_Remains.Remains * COALESCE (ObjectHistoryFloat_Price.ValueData, 0)) AS SummaRemains
               
               , CASE WHEN COALESCE (Object_Remains.Remains, 0) > COALESCE(tmpMCS.MCSValue,0) THEN COALESCE (Object_Remains.Remains, 0) - COALESCE(tmpMCS.MCSValue,0) ELSE 0 END :: TFloat AS RemainsNotMCS
            --   , CASE WHEN COALESCE (Object_Remains.Remains, 0) > COALESCE(tmpMCS.MCSValue,0) THEN (COALESCE (Object_Remains.Remains, 0) - COALESCE(tmpMCS.MCSValue,0)) * COALESCE (ObjectHistoryFloat_Price.ValueData, 0) ELSE 0 END :: TFloat AS SummaNotMCS
               
               , Object_Remains.RemainsEnd                       AS RemainsEnd

            --   , (Object_Remains.RemainsEnd * COALESCE (ObjectHistoryFloat_PriceEnd.ValueData, 0)) ::TFloat AS SummaRemainsEnd
               , CASE WHEN COALESCE (Object_Remains.RemainsEnd, 0) > COALESCE(tmpMCS.MCSValue,0) THEN COALESCE (Object_Remains.RemainsEnd, 0) - COALESCE(tmpMCS.MCSValue,0) ELSE 0 END :: TFloat AS RemainsNotMCSEnd
            --   , CASE WHEN COALESCE (Object_Remains.RemainsEnd, 0) > COALESCE(tmpMCS.MCSValue,0) THEN (COALESCE (Object_Remains.RemainsEnd, 0) - COALESCE(tmpMCS.MCSValue,0)) * COALESCE (ObjectHistoryFloat_PriceEnd.ValueData, 0) ELSE 0 END :: TFloat AS SummaNotMCSEnd
              
               , Object_Remains.unitid 
               
            FROM tmpGoods
                LEFT JOIN tmpPrice ON tmpPrice.GoodsId = tmpGoods.GoodsId 
                                                               
                LEFT OUTER JOIN tmpRemeins AS Object_Remains
                                           ON Object_Remains.ObjectId = tmpGoods.GoodsId 
                                          AND Object_Remains.UnitId = tmpPrice.UnitId

                LEFT JOIN tmpMCS ON tmpMCS.GoodsId = tmpGoods.GoodsId  
                                AND tmpMCS.UnitId =  tmpPrice.UnitId
                               
                                
                -- получаем значения цены и НТЗ из истории значений на начало дня                                                          
/*                LEFT JOIN ObjectHistory AS ObjectHistory_Price
                                        ON ObjectHistory_Price.ObjectId = tmpPrice.PriceId
                                       AND ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
                                       AND DATE_TRUNC ('DAY', inStartDate) >= ObjectHistory_Price.StartDate AND DATE_TRUNC ('DAY', inStartDate) < ObjectHistory_Price.EndDate
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price
                                             ON ObjectHistoryFloat_Price.ObjectHistoryId = ObjectHistory_Price.Id
                                            AND ObjectHistoryFloat_Price.DescId = zc_ObjectHistoryFloat_Price_Value()
                                                                            
                -- получаем значения цены и НТЗ из истории значений на конец дня (на сл.день 00:00)
                LEFT JOIN ObjectHistory AS ObjectHistory_PriceEnd
                                        ON ObjectHistory_PriceEnd.ObjectId = tmpPrice.PriceId

                                       AND ObjectHistory_PriceEnd.DescId = zc_ObjectHistory_Price()
                                        AND DATE_TRUNC ('DAY', inStartDate) +interval '1 day' >= ObjectHistory_PriceEnd.StartDate AND DATE_TRUNC ('DAY', inStartDate) +interval '1 day' < ObjectHistory_PriceEnd.EndDate
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceEnd
                                             ON ObjectHistoryFloat_PriceEnd.ObjectHistoryId = ObjectHistory_PriceEnd.Id
                                            AND ObjectHistoryFloat_PriceEnd.DescId = zc_ObjectHistoryFloat_Price_Value()
*/                                            
          
            --ORDER BY GoodsGroupName, GoodsName
            ;

       



     OPEN Cursor1 FOR
     
     SELECT      tmpData.MCSValue        :: TFLOAT     
               , tmpData.MCSPeriod       :: TFLOAT     
               , tmpData.MCSDay          :: TFLOAT     
               , tmpData.StartDate       :: TDateTime 
               , tmpData.StartDateEnd    :: TDateTime 
               , tmpData.Price           :: TFloat
               , tmpData.StartDate       :: TDateTime
               , tmpData.Remains         :: TFloat       
               , tmpData.SummaRemains    :: TFloat       
               , tmpData.RemainsNotMCS   :: TFloat
               , tmpData.SummaNotMCS     :: TFloat
               

               , tmpData.RemainsEnd      :: TFloat          
               , tmpData.SummaRemainsEnd    :: TFloat       
               , tmpData.RemainsNotMCSEnd   :: TFloat
               , tmpData.SummaNotMCSEnd     :: TFloat

               , tmpData.GoodsId         :: integer                
               , tmpData.GoodsCode       :: integer    
               , tmpData.GoodsName       :: TVarChar   
               , tmpData.GoodsGroupName  :: TVarChar   
               , tmpData.NDSKindName     :: TVarChar   
               , tmpData.isClose         :: Boolean
               , tmpData.isTOP           :: Boolean
               , tmpData.isFirst         :: Boolean
               , tmpData.isSecond        :: Boolean
             
     FROM tmpData
     --LEFT JOIN Object AS Object_Unit  on Object_Unit.Id = tmpData.UnitId
     WHERE tmpData.UnitId = inUnitId
              
          ;
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
               , tmpData.StartDate       :: TDateTime
               , tmpData.Remains         :: TFloat       
               , tmpData.SummaRemains    :: TFloat       
               , tmpData.RemainsNotMCS   :: TFloat
               , tmpData.SummaNotMCS     :: TFloat
               
               , tmpData.RemainsEnd      :: TFloat          
               , tmpData.SummaRemainsEnd    :: TFloat       
               , tmpData.RemainsNotMCSEnd   :: TFloat
               , tmpData.SummaNotMCSEnd     :: TFloat

               , tmpData.GoodsId         :: integer                
               , tmpData.GoodsCode       :: integer       
               , tmpData.GoodsName       :: TVarChar      
               , tmpData.GoodsGroupName  :: TVarChar      
               , tmpData.NDSKindName     :: TVarChar      
               , tmpData.isClose         :: Boolean
               , tmpData.isTOP           :: Boolean
               , tmpData.isFirst         :: Boolean
               , tmpData.isSecond        :: Boolean
                  
     FROM tmpData
     LEFT JOIN Object AS Object_Unit  on Object_Unit.Id = tmpData.UnitId
     WHERE tmpData.UnitId <> inUnitId
     limit 95000
     ;
     
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
-- SELECT * FROM gpReport_RemainsOverGoods (inUnitId := 377613 , inRemainsDate := ('10.05.2016')::TDateTime, inIsPartion:= FALSE, inisPartionPrice:= FALSE, inSession := '3');
--select * from gpReport_RemainsOverGoods(inUnitId := 377574 , inStartDate:= '01.10.2015'::TDateTime, inPeriod := 2 ::TFloat , inDay := 2 ::TFloat,   inSession := '3'::TVarChar)