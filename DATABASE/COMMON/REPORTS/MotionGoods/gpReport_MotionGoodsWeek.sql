-- Function: gpReport_MotionGoodsWeek()

DROP FUNCTION IF EXISTS gpReport_MotionGoodsWeek (TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_MotionGoodsWeek(
    IN inStartDate          TDateTime , --
    IN inUnitId             Integer,    -- подразделение склад
    IN inGoodsGroupId       Integer,    -- группа товара
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindName  TVarChar
             , MeasureName TVarChar
             , GoodsGroupNameFull TVarChar
             , GoodsGroupId   Integer
             , GoodsGroupName TVarChar
             , RemainsStart TFloat
             , RemainsEnd TFloat
             , CountIn1 TFloat
             , CountIn2 TFloat
             , CountIn3 TFloat
             , CountIn4 TFloat
             , CountIn5 TFloat
             , CountIn6 TFloat
             , CountIn7 TFloat
             , CountOut1 TFloat
             , CountOut2 TFloat
             , CountOut3 TFloat
             , CountOut4 TFloat
             , CountOut5 TFloat
             , CountOut6 TFloat
             , CountOut7 TFloat
             , EndDate TDateTime
             --, Color_RemainsDays Integer
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCountDays Integer;
   DECLARE vbStartDate Integer;
   DECLARE vbEndDate TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inStartDate, NULL, NULL, NULL, vbUserId);

     
   /* IF (EXTRACT (DOW FROM inStartDate)) <> 1 
      THEN
          RAISE EXCEPTION 'Ошибка.Выбран не понедельник.';
    END IF; 
*/
    vbEndDate := inStartDate + interval '6 day';
    
    -- Ограничения по товарам
    /*CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
    IF inGoodsGroupId <> 0
    THEN
        INSERT INTO _tmpGoods (GoodsId)
           SELECT lfObject_Goods_byGoodsGroup.GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup;
    ELSE
        INSERT INTO _tmpGoods (GoodsId)
           SELECT Object.Id FROM Object WHERE DescId = zc_Object_Goods();
    END IF;

    CREATE TEMP TABLE tmpListDate ON COMMIT DROP
       AS SELECT generate_series(inStartDate, vbEndDate, '1 DAY'::interval) OperDate;*/


   RETURN QUERY
   WITH 

           _tmpGoods AS (SELECT lfObject_Goods_byGoodsGroup.GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup 
                         WHERE inGoodsGroupId <> 0
                        UNION
                         SELECT Object.Id FROM Object WHERE DescId = zc_Object_Goods();
                         WHERE COALESCE (inGoodsGroupId, 0) = 0
                        )
    , tmpListDate AS (SELECT generate_series(inStartDate, vbEndDate, '1 DAY'::interval) OperDate)

    , tmpContainer AS (SELECT Container.Id                           AS ContainerId
                            , Container.ObjectId                     AS GoodsId
                            , COALESCE (CLO_GoodsKind.ObjectId, 0)   AS GoodsKindId
                            , Container.Amount
                       FROM ContainerLinkObject AS CLO_Unit
                                INNER JOIN Container ON Container.Id = CLO_Unit.ContainerId AND Container.DescId = zc_Container_Count() 
                                INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = Container.ObjectId
                                LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                              ON CLO_GoodsKind.ContainerId = CLO_Unit.ContainerId
                                                             AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                       WHERE CLO_Unit.ObjectId = inUnitId
                         AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                       GROUP BY Container.Id, Container.ObjectId, GoodsKindId, Container.Amount
                      )
    , tmpRemains AS (SELECT tmp.GoodsId, tmp.GoodsKindId
                          , SUM (tmp.StartAmount)        AS RemainsStart 
                          , SUM (tmp.EndAmount)          AS RemainsEnd 
                     FROM (SELECT tmpContainer.GoodsId
                                , tmpContainer.GoodsKindId
                                , tmpContainer.Amount - SUM (COALESCE(MIContainer.Amount, 0))  AS StartAmount
                                , tmpContainer.Amount - SUM (CASE WHEN MIContainer.OperDate > vbEndDate THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS EndAmount
                           FROM tmpContainer
                                LEFT JOIN MovementItemContainer AS MIContainer 
                                                                ON MIContainer.Containerid = tmpContainer.ContainerId
                                                               AND MIContainer.OperDate >= inStartDate
                           GROUP BY tmpContainer.GoodsId
                                  , tmpContainer.GoodsKindId
                                  , tmpContainer.Amount
                          HAVING tmpContainer.Amount - SUM (COALESCE (MIContainer.Amount, 0))  <> 0
                              OR tmpContainer.Amount - SUM (CASE WHEN MIContainer.OperDate > vbEndDate THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) <> 0
                           ) AS tmp
                     GROUP BY tmp.GoodsId, tmp.goodskindid
                     )

      , tmpMotion AS (SELECT MIContainer.OperDate, tmpContainer.GoodsId
                           , tmpContainer.GoodsKindId
                           , SUM (CASE WHEN MIContainer.isActive = TRUE
                                       THEN COALESCE (MIContainer.Amount, 0)
                                       ELSE 0
                                  END) AS CountIn
                           , SUM (CASE WHEN MIContainer.isActive = FALSE
                                       THEN -1 * MIContainer.Amount
                                       ELSE 0
                                  END) AS CountOut
                      FROM tmpContainer
                           LEFT JOIN MovementItemContainer AS MIContainer 
                                                           ON MIContainer.Containerid = tmpContainer.ContainerId
                                                          AND MIContainer.OperDate BETWEEN inStartDate AND vbEndDate
                      GROUP BY MIContainer.OperDate
                             , tmpContainer.GoodsId
                             , tmpContainer.GoodsKindId
                      HAVING SUM (CASE WHEN MIContainer.isActive = TRUE
                                       THEN COALESCE (MIContainer.Amount, 0)
                                       ELSE 0
                                  END) <> 0
                          OR SUM (CASE WHEN MIContainer.isActive = FALSE
                                       THEN -1 * MIContainer.Amount
                                       ELSE 0
                                  END) <> 0
                      )
    , tmpGoods AS (SELECT DISTINCT tmpRemains.GoodsId, tmpRemains.GoodsKindId
                   FROM tmpRemains
                  UNION 
                   SELECT DISTINCT tmpMotion.GoodsId, tmpMotion.GoodsKindId
                   FROM tmpMotion
                   )

   , tmpData AS (SELECT tmpMotion.GoodsId
                      , tmpMotion.GoodsKindId 
                      , SUM (CASE WHEN tmpWeekDay.Number = 1 THEN tmpMotion.CountIn ELSE 0 END) CountIn1
                      , SUM (CASE WHEN tmpWeekDay.Number = 2 THEN tmpMotion.CountIn ELSE 0 END) CountIn2
                      , SUM (CASE WHEN tmpWeekDay.Number = 3 THEN tmpMotion.CountIn ELSE 0 END) CountIn3
                      , SUM (CASE WHEN tmpWeekDay.Number = 4 THEN tmpMotion.CountIn ELSE 0 END) CountIn4
                      , SUM (CASE WHEN tmpWeekDay.Number = 5 THEN tmpMotion.CountIn ELSE 0 END) CountIn5
                      , SUM (CASE WHEN tmpWeekDay.Number = 6 THEN tmpMotion.CountIn ELSE 0 END) CountIn6
                      , SUM (CASE WHEN tmpWeekDay.Number = 7 THEN tmpMotion.CountIn ELSE 0 END) CountIn7

                      , SUM (CASE WHEN tmpWeekDay.Number = 1 THEN tmpMotion.CountOut ELSE 0 END) CountOut1
                      , SUM (CASE WHEN tmpWeekDay.Number = 2 THEN tmpMotion.CountOut ELSE 0 END) CountOut2
                      , SUM (CASE WHEN tmpWeekDay.Number = 3 THEN tmpMotion.CountOut ELSE 0 END) CountOut3
                      , SUM (CASE WHEN tmpWeekDay.Number = 4 THEN tmpMotion.CountOut ELSE 0 END) CountOut4
                      , SUM (CASE WHEN tmpWeekDay.Number = 5 THEN tmpMotion.CountOut ELSE 0 END) CountOut5
                      , SUM (CASE WHEN tmpWeekDay.Number = 6 THEN tmpMotion.CountOut ELSE 0 END) CountOut6
                      , SUM (CASE WHEN tmpWeekDay.Number = 7 THEN tmpMotion.CountOut ELSE 0 END) CountOut7
                 FROM tmpListDate
                      LEFT JOIN tmpMotion ON tmpMotion.OperDate = tmpListDate.OperDate
                      LEFT JOIN zfCalc_DayOfWeekName (tmpListDate.OperDate) AS tmpWeekDay ON 1=1   
                 GROUP BY tmpMotion.GoodsId
                        , tmpMotion.GoodsKindId 
                 )

       -- Результат
       SELECT 
             Object_Goods.Id                            AS GoodsId
           , Object_Goods.ObjectCode                    AS GoodsCode
           , Object_Goods.ValueData                     AS GoodsName
           , Object_GoodsKind.ValueData                 AS GoodsKindName
           , Object_Measure.ValueData                   AS MeasureName
           , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroup.Id                       AS GoodsGroupId
           , Object_GoodsGroup.ValueData                AS GoodsGroupName
           
           , tmpRemains.RemainsStart   :: TFloat
           , tmpRemains.RemainsEnd     :: TFloat
 
           , tmpData.CountIn1  :: TFloat
           , tmpData.CountIn2  :: TFloat
           , tmpData.CountIn3  :: TFloat
           , tmpData.CountIn4  :: TFloat
           , tmpData.CountIn5  :: TFloat
           , tmpData.CountIn6  :: TFloat
           , tmpData.CountIn7  :: TFloat

           , tmpData.CountOut1  :: TFloat
           , tmpData.CountOut2  :: TFloat
           , tmpData.CountOut3  :: TFloat
           , tmpData.CountOut4  :: TFloat
           , tmpData.CountOut5  :: TFloat
           , tmpData.CountOut6  :: TFloat
           , tmpData.CountOut7  :: TFloat
           , vbEndDate          AS EndDate
       FROM tmpGoods
          LEFT JOIN tmpData ON tmpData.GoodsId = tmpGoods.GoodsId 
                           AND tmpData.GoodsKindId = tmpGoods.GoodsKindId 
          LEFT JOIN tmpRemains ON tmpRemains.GoodsId = tmpGoods.GoodsId 
                              AND tmpRemains.GoodsKindId = tmpGoods.GoodsKindId 

          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoods.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpGoods.GoodsKindId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                                          AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
       WHERE tmpRemains.RemainsStart <> 0 OR tmpRemains.RemainsEnd   <> 0
          OR tmpData.CountIn1  <> 0 OR tmpData.CountIn2  <> 0 OR tmpData.CountIn3  <> 0 OR tmpData.CountIn4 <> 0
          OR tmpData.CountIn5  <> 0 OR tmpData.CountIn6  <> 0 OR tmpData.CountIn7  <> 0
          OR tmpData.CountOut1 <> 0 OR tmpData.CountOut2 <> 0 OR tmpData.CountOut3 <> 0 OR tmpData.CountOut4 <> 0
          OR tmpData.CountOut5 <> 0 OR tmpData.CountOut6 <> 0 OR tmpData.CountOut7 <> 0
       ORDER BY Object_Goods.ValueData    
          ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 31.03.17         *
*/

-- тест
 --select * from gpReport_MotionGoodsWeek(inStartDate := ('27.03.2016')::TDateTime, inUnitId := 8455 , inGoodsGroupId := 1917 ,  inSession := '5');