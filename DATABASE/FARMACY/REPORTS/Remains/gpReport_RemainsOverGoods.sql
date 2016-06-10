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
    CREATE TEMP TABLE tmpRemeins (objectid Integer, Remains tfloat, RemainsEnd tfloat, UnitId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE tmpMCS (MCSValue tfloat, GoodsId Integer, UnitId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE tmpData (Id Integer, Price TFloat, MCSValue TFloat
                             , MCSPeriod TFloat, MCSDay TFloat
                             , StartDate TDateTime
                             , StartDateEnd TDateTime
                             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
                             , GoodsGroupName TVarChar, NDSKindName TVarChar
                             , DateChange TDateTime, MCSDateChange TDateTime
                             , MCSIsClose Boolean, MCSIsCloseDateChange TDateTime
                             , MCSNotRecalc Boolean, MCSNotRecalcDateChange TDateTime
                             , Fix Boolean, FixDateChange TDateTime
                            --, MinExpirationDate TDateTime
                             , Remains TFloat, SummaRemains TFloat
                             , RemainsNotMCS TFloat, SummaNotMCS TFloat
                             , PriceEnd TFloat
                             , RemainsEnd TFloat, SummaRemainsEnd TFloat
                             , UnitId Integer) ON COMMIT DROP;
    
        INSERT INTO tmpUnit (UnitId)
                    SELECT Object_Unit.Id AS UnitId
                    FROM Object AS Object_Unit
                    WHERE Object_Unit.DescId = zc_Object_Unit();
                    
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
                             --   AND Container.WhereObjectId = inUnitId
                              GROUP BY container.objectid,COALESCE(container.Amount,0), container.Id,Container.WhereObjectId 
                               HAVING  COALESCE(container.Amount,0) - COALESCE(SUM(MIContainer.Amount), 0)<>0 
                                   OR 
                                     (COALESCE(container.Amount,0) - SUM (CASE WHEN MIContainer.OperDate >= DATE_TRUNC ('DAY', inStartDate )+interval '1 day' then COALESCE(MIContainer.Amount, 0) ELSE 0 END))  <> 0
                             ) AS tmp
                        GROUP BY tmp.objectid, tmp.UnitId
                        --limit 100
                       ;

       INSERT INTO tmpMCS (MCSValue, GoodsId, UnitId)
                     SELECT tmp.MCSValue 
                          , tmp.GoodsId 
                          , tmp.UnitId 
                       FROM gpSelect_RecalcMCS(0, 0, inPeriod::Integer, inDay::Integer, inStartDate, inSession) AS tmp;
  /*                   FROM (SELECT * FROM tmpRemeins WHERE tmpRemeins.Remains >0 OR tmpRemeins.RemainsEND >0) AS tmpRemeins
                       LEFT JOIN gpSelect_RecalcMCS(tmpRemeins.UnitId, tmpRemeins.objectid , inPeriod::Integer, inDay::Integer, inStartDate, inSession) AS tmp 
                              ON tmp.UnitId  = tmpRemeins.UnitId
                             AND tmp.GoodsId = tmpRemeins.objectid ;
*/
       

        INSERT INTO tmpData (Id--, Price
                             , MCSValue 
                             , MCSPeriod, MCSDay
                             --, StartDate, StartDateEnd
                             , GoodsId, GoodsCode, GoodsName
                             , GoodsGroupName, NDSKindName
                             
                             , Remains-- SummaRemains
                           --  , RemainsNotMCS-- SummaNotMCS
                             , RemainsEnd, Unitid)
                             
             SELECT
                 0 --   Object_Price_View.Id                            AS Id
               , COALESCE(tmpMCS.MCSValue,0)                     AS MCSValue
               , inPeriod                AS MCSPeriod
               , inDay                   AS MCSDay
               , Object_Goods_View.id                            AS GoodsId
               , Object_Goods_View.GoodsCodeInt                  AS GoodsCode
               , Object_Goods_View.GoodsName                     AS GoodsName
               , Object_Goods_View.GoodsGroupName                AS GoodsGroupName
               , Object_Goods_View.NDSKindName                   AS NDSKindName
         
               , Object_Remains.Remains                          AS Remains
               , Object_Remains.RemainsEnd                       AS RemainsEnd
               , Object_Remains.unitid 
            FROM               
            Object_Goods_View
                INNER JOIN ObjectLink ON ObjectLink.ObjectId = Object_Goods_View.Id 
                                     AND ObjectLink.ChildObjectId = vbObjectId
                                                              
                LEFT OUTER JOIN tmpRemeins AS Object_Remains
                                           ON Object_Remains.ObjectId = Object_Goods_View.Id
                                      --    AND Object_Remains.unitid = Object_Price_View.unitid
                      
                LEFT JOIN tmpMCS ON tmpMCS.GoodsId = Object_Goods_View.Id 
                                AND tmpMCS.UnitId = Object_Remains.unitid
                 
            WHERE Object_Goods_View.isErased = False
            ORDER BY GoodsGroupName, GoodsName;


     OPEN Cursor1 FOR
     
     SELECT      tmpData.MCSValue        :: TFLOAT     
               , tmpData.MCSPeriod       :: TFLOAT     
               , tmpData.MCSDay          :: TFLOAT     
               , tmpData.StartDate       :: TDateTime 
               , tmpData.StartDateEnd    :: TDateTime 
               
               , tmpData.Remains         :: TFloat                AS Remains
               , tmpData.SummaRemains    :: TFloat                AS SummaRemains

               , tmpData.RemainsEnd      :: TFloat                AS RemainsEnd
               , Object_Unit.ValueDAta   :: TVarChar              AS UnitName 
               , tmpData.GoodsId         ::integer                
               , tmpData.GoodsCode       ::integer                AS GoodsCode
               , tmpData.GoodsName       ::TVarChar               AS GoodsName
               , tmpData.GoodsGroupName  ::TVarChar               AS GoodsGroupName
               , tmpData.NDSKindName     ::TVarChar               AS NDSKindName
             
     FROM tmpData
     LEFT JOIN Object AS Object_Unit  on Object_Unit.Id = tmpData.UnitId
     WHERE tmpData.UnitId = inUnitId
          
          ;
     RETURN NEXT Cursor1;

    -- Результат 2

     OPEN Cursor2 FOR

     SELECT      tmpData.MCSValue  ::TFLOAT     
               , tmpData.MCSPeriod ::TFLOAT     
               , tmpData.MCSDay    ::TFLOAT     
               , tmpData.StartDate :: TDateTime 
               , tmpData.StartDateEnd :: TDateTime AS StartDateEnd
               
               , tmpData.Remains  :: TFloat               AS Remains
               , tmpData.SummaRemains ::TFloat AS SummaRemains

               , tmpData.RemainsEnd :: TFloat      AS RemainsEnd
               --, tmpData.Unitid  
               , Object_Unit.ValueDAta   ::TVarChar                AS UnitName 
               , tmpData.GoodsId  ::integer                
          , tmpData.GoodsCode      ::integer                 AS GoodsCode
          , tmpData.GoodsName      ::TVarChar                AS GoodsName
          , tmpData.GoodsGroupName ::TVarChar                AS GoodsGroupName
          , tmpData.NDSKindName    ::TVarChar                AS NDSKindName
     FROM tmpData
     LEFT JOIN Object AS Object_Unit  on Object_Unit.Id = tmpData.UnitId
     WHERE tmpData.UnitId <> inUnitId
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