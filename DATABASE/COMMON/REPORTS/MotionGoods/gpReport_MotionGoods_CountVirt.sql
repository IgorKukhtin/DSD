  -- Function: gpReport_MotionGoods_NEW()

DROP FUNCTION IF EXISTS gpReport_MotionGoods_CountVirt (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_MotionGoods_CountVirt(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inUnitGroupId        Integer,    -- группа подразделений на самом деле может быть и подразделением
    IN inGoodsGroupId       Integer,    -- группа товара
    IN inGoodsId            Integer,    -- товар
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (UnitId Integer, UnitCode Integer, UnitName TVarChar
             , GoodsGroupId Integer, GoodsGroupCode Integer, GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , MeasureName TVarChar
             , Weight TFloat

             , CountStart TFloat
             , CountStart_Weight TFloat
             , CountEnd TFloat
             , CountEnd_Weight TFloat
             
             , CountSendIn TFloat
             , CountSendIn_Weight TFloat
             , CountSendOut TFloat
             , CountSendOut_Weight TFloat
              
             , CountProductionIn TFloat
             , CountProductionIn_Weight TFloat
             , CountProductionOut TFloat
             , CountProductionOut_Weight TFloat

             , CountOrderRKOut        TFloat
             , CountOrderRKOut_Weight TFloat

             , CountItsIn         TFloat
             , CountItsIn_Weight  TFloat
             , CountItsOut        TFloat
             , CountItsOut_Weight TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsSummIn Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Report_MotionGoods());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);
     
     CREATE TEMP TABLE _tmpLocation (LocationId Integer, DescId Integer, ContainerDescId Integer) ON COMMIT DROP;
     
     IF inUnitGroupId <> 0
     THEN
         INSERT INTO _tmpLocation (LocationId)     
            SELECT lfSelect_Object_Unit_byGroup.UnitId AS LocationId
            FROM lfSelect_Object_Unit_byGroup (inUnitGroupId) AS lfSelect_Object_Unit_byGroup;
     ELSE
         INSERT INTO _tmpLocation (LocationId)     
            SELECT Object.Id AS LocationId
            FROM Object
            WHERE Object.DescId = zc_Object_Unit() 
              AND Object.isErased = FALSE;
     END IF;



    -- Результат
    RETURN QUERY
   
    WITH
    tmpGoods AS (SELECT lfSelect.GoodsId
                 FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect
                 WHERE COALESCE (inGoodsGroupId,0) <> 0
                   AND COALESCE (inGoodsId,0) = 0
                UNION ALL
                 SELECT Object.Id AS GoodsId
                 FROM Object
                 WHERE Object.DescId = zc_Object_Goods()
                   AND (Object.Id = inGoodsId OR (inGoodsId = 0 AND COALESCE (inGoodsGroupId,0) = 0))
                   
                )
                          
    -- все ContainerId    
  , tmpContainer AS (SELECT Container.*
                         , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
                         , CLO_Unit.ObjectId AS UnitId
                     FROM Container
                          INNER JOIN ContainerLinkObject AS CLO_Unit
                                                         ON CLO_Unit.ContainerId = Container.Id
                                                        AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                          INNER JOIN _tmpLocation ON _tmpLocation.LocationId = CLO_Unit.ObjectId      --  AND  IN 8459 --inUnitId    ---"Розподільчий комплекс"

                          LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                        ON CLO_GoodsKind.ContainerId = Container.Id
                                                       AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                     WHERE Container.DescId = zc_Container_CountVirt()
                       AND Container.ObjectId IN (SELECT DISTINCT tmpGoods.GoodsId FROM tmpGoods)
                    )

  , tmpMIContainer AS (SELECT tmp.UnitId
                            , tmp.GoodsId
                            , tmp.GoodsKindId 
                            , SUM (COALESCE (tmp.CountSendIn,0))        AS CountSendIn
                            , SUM (COALESCE (tmp.CountSendOut,0))       AS CountSendOut
                            , SUM (COALESCE (tmp.CountProductionIn,0))  AS CountProductionIn
                            , SUM (COALESCE (tmp.CountProductionOut,0)) AS CountProductionOut
                            , SUM (COALESCE (tmp.CountOrderRKOut,0))    AS CountOrderRKOut
                            , SUM (COALESCE (tmp.CountItsIn,0))         AS CountItsIn
                            , SUM (COALESCE (tmp.CountItsOut,0))        AS CountItsOut
                            , SUM (COALESCE (tmp.RemainsStart, 0))      AS CountStart
                            , SUM (COALESCE (tmp.RemainsEnd, 0))        AS CountEnd
                       FROM (SELECT tmpContainer.UnitId
                                  , tmpContainer.ObjectId AS GoodsId
                                  , tmpContainer.GoodsKindId 
                                  , SUM (CASE WHEN MIContainer.OperDate  BETWEEN inStartDate AND inEndDate
                                               AND MIContainer.MovementDescId IN (zc_Movement_Send())
                                               AND MIContainer.isActive = TRUE
                                                   THEN MIContainer.Amount
                                              ELSE 0
                                         END) AS CountSendIn
                                  , SUM (CASE WHEN MIContainer.OperDate  BETWEEN inStartDate AND inEndDate
                                               AND MIContainer.MovementDescId IN (zc_Movement_Send())
                                               AND MIContainer.isActive = FALSE
                                                   THEN -1 * MIContainer.Amount
                                              ELSE 0
                                         END) AS CountSendOut
      
                                  , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                               AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                               AND MIContainer.isActive = TRUE
                                                    THEN MIContainer.Amount
                                              ELSE 0
                                         END) AS CountProductionIn
                                  , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                               AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                               AND MIContainer.isActive = FALSE
                                                   THEN -1 * MIContainer.Amount
                                              ELSE 0
                                         END) AS CountProductionOut
      
                                  , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                               AND MIContainer.MovementDescId IN (zc_Movement_OrderRK())
                                               AND MIContainer.isActive = FALSE
                                                   THEN -1 * MIContainer.Amount
                                              ELSE 0
                                         END) AS CountOrderRKOut
      
                                  , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                               AND MIContainer.MovementDescId NOT IN (zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                               AND MIContainer.isActive = TRUE
                                                    THEN MIContainer.Amount
                                              ELSE 0
                                         END) AS CountItsIn
      
                                  , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                               AND MIContainer.MovementDescId NOT IN (zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate(), zc_Movement_OrderRK())
                                               AND MIContainer.isActive = FALSE
                                                   THEN -1 * MIContainer.Amount
                                              ELSE 0
                                         END) AS CountItsOut
      
                                  -- ***REMAINS***
                                  , -1 * SUM (MIContainer.Amount) AS RemainsStart
                                  , 0 AS RemainsEnd
                             FROM tmpContainer
                                 LEFT JOIN MovementItemContainer AS MIContainer 
                                                                 ON MIContainer.ContainerId = tmpContainer.Id
                                                                AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                                AND MIContainer.DescId = zc_MIContainer_CountVirt()
                             GROUP BY tmpContainer.UnitId
                                    , tmpContainer.ObjectId
                                    , tmpContainer.GoodsKindId 
                             HAVING SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                               AND MIContainer.MovementDescId IN (zc_Movement_Send())
                                               AND MIContainer.isActive = TRUE
                                                   THEN MIContainer.Amount
                                              ELSE 0
                                         END) <> 0 --AS CountSendIn
      
                                 OR SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                               AND MIContainer.MovementDescId IN (zc_Movement_Send())
                                               AND MIContainer.isActive = FALSE
                                                   THEN -1 * MIContainer.Amount
                                              ELSE 0
                                         END) <> 0 -- AS CountSendOut
      
                                 OR SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                             AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                             AND MIContainer.isActive = TRUE
                                                  THEN MIContainer.Amount
                                            ELSE 0
                                        END) <> 0 -- AS CountProductionIn
                                 OR SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                             AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                             AND MIContainer.isActive = FALSE
                                                 THEN -1 * MIContainer.Amount
                                            ELSE 0
                                        END) <> 0 -- AS CountProductionOut
      
                                 OR SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                             AND MIContainer.MovementDescId IN (zc_Movement_OrderRK())
                                             AND MIContainer.isActive = FALSE
                                                 THEN -1 * MIContainer.Amount
                                            ELSE 0
                                        END) <> 0 -- AS CountOrderRKOut
      
                                 OR SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                             AND MIContainer.MovementDescId NOT IN (zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                             AND MIContainer.isActive = TRUE
                                                  THEN MIContainer.Amount
                                            ELSE 0
                                        END) <> 0 -- AS CountItsIn
      
                                 OR SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                             AND MIContainer.MovementDescId NOT IN (zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate(), zc_Movement_OrderRK())
                                             AND MIContainer.isActive = FALSE
                                                 THEN -1 * MIContainer.Amount
                                            ELSE 0
                                        END) <> 0 -- AS CountItsOut 
                                 -- ***REMAINS***
                                 OR SUM (MIContainer.Amount) <> 0 -- AS RemainsStart     
                           UNION ALL
                             -- ***REMAINS***
                             SELECT tmpContainer.UnitId
                                  , tmpContainer.ObjectId AS GoodsId
                                  , tmpContainer.GoodsKindId 
                                  , 0 AS CountSendIn
                                  , 0 AS CountSendOut
                                  , 0 AS CountProductionIn
                                  , 0 AS CountProductionOut
                                  , 0 AS CountOrderRKOut
                                  , 0 AS CountItsIn
                                  , 0 AS CountItsOut
                                  -- ***REMAINS***
                                  , tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS RemainsStart
                                  , tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS RemainsEnd
                             FROM tmpContainer
                                 LEFT JOIN MovementItemContainer AS MIContainer 
                                                                 ON MIContainer.ContainerId = tmpContainer.Id
                                                                AND MIContainer.OperDate > inEndDate
                                                                AND MIContainer.DescId = zc_MIContainer_CountVirt()
                             GROUP BY tmpContainer.UnitId
                                    , tmpContainer.ObjectId
                                    , tmpContainer.GoodsKindId 
                                    , tmpContainer.Amount
                             HAVING tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0
                            ) AS tmp
                       GROUP BY tmp.UnitId
                              , tmp.GoodsId
                              , tmp.GoodsKindId
                       )

  , tmpGoods_Param AS (SELECT Object_Goods.Id                AS GoodsId
                            , Object_Goods.ObjectCode        AS GoodsCode
                            , Object_Goods.ValueData         AS GoodsName
                            , Object_GoodsGroup.Id           AS GoodsGroupId 
                            , Object_GoodsGroup.ObjectCode   AS GoodsGroupCode
                            , Object_GoodsGroup.ValueData    AS GoodsGroupName
                            , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
                            , Object_Measure.Id              AS MeasureId
                            , Object_Measure.ValueData       AS MeasureName
                            , ObjectFloat_Weight.ValueData   AS Weight
                       FROM (SELECT DISTINCT tmpMIContainer.GoodsId FROM tmpMIContainer) AS tmpGoods
                           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoods.GoodsId
                         
       
                           LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                                  ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                                 AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                               AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                           LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
                                                                                                                                    
                           LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                               AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                           LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
                                                                                                                                    
                           LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                 ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                                AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                       )



     SELECT Object_Unit.Id              AS UnitId
          , Object_Unit.ObjectCode      AS UnitCode
          , Object_Unit.ValueData       AS UnitName
          , tmpGoods.GoodsGroupId
          , tmpGoods.GoodsGroupCode
          , tmpGoods.GoodsGroupName
          , tmpGoods.GoodsGroupNameFull
          , tmpGoods.GoodsId
          , tmpGoods.GoodsCode
          , tmpGoods.GoodsName
          , Object_GoodsKind.Id         AS GoodsKindId
          , Object_GoodsKind.ValueData  AS GoodsKindName
          , tmpGoods.MeasureName
          , tmpGoods.Weight
          
          , tmpMIContainer.CountStart         ::TFloat
          , (tmpMIContainer.CountStart * CASE WHEN tmpGoods.MeasureId = zc_Measure_Sh() THEN tmpGoods.Weight ELSE 1 END) ::TFloat AS CountStart_Weight
          , tmpMIContainer.CountEnd           ::TFloat
          , (tmpMIContainer.CountEnd * CASE WHEN tmpGoods.MeasureId = zc_Measure_Sh() THEN tmpGoods.Weight ELSE 1 END)   ::TFloat AS CountEnd_Weight
          
          , tmpMIContainer.CountSendIn        ::TFloat
          , (tmpMIContainer.CountSendIn * CASE WHEN tmpGoods.MeasureId = zc_Measure_Sh() THEN tmpGoods.Weight ELSE 1 END)   ::TFloat AS CountSendIn_Weight
          , tmpMIContainer.CountSendOut       ::TFloat
          , (tmpMIContainer.CountSendOut * CASE WHEN tmpGoods.MeasureId = zc_Measure_Sh() THEN tmpGoods.Weight ELSE 1 END)   ::TFloat AS CountSendOut_Weight
           
          , tmpMIContainer.CountProductionIn  ::TFloat
          , (tmpMIContainer.CountProductionIn * CASE WHEN tmpGoods.MeasureId = zc_Measure_Sh() THEN tmpGoods.Weight ELSE 1 END)   ::TFloat AS CountProductionIn_Weight
          , tmpMIContainer.CountProductionOut ::TFloat
          , (tmpMIContainer.CountProductionOut * CASE WHEN tmpGoods.MeasureId = zc_Measure_Sh() THEN tmpGoods.Weight ELSE 1 END)   ::TFloat AS CountProductionOut_Weight

          , tmpMIContainer.CountOrderRKOut    ::TFloat
          , (tmpMIContainer.CountOrderRKOut * CASE WHEN tmpGoods.MeasureId = zc_Measure_Sh() THEN tmpGoods.Weight ELSE 1 END)   ::TFloat AS CountOrderRKOut_Weight

          , tmpMIContainer.CountItsIn         ::TFloat
          , (tmpMIContainer.CountItsIn * CASE WHEN tmpGoods.MeasureId = zc_Measure_Sh() THEN tmpGoods.Weight ELSE 1 END)   ::TFloat AS CountItsIn_Weight
          , tmpMIContainer.CountItsOut        ::TFloat
          , (tmpMIContainer.CountItsOut * CASE WHEN tmpGoods.MeasureId = zc_Measure_Sh() THEN tmpGoods.Weight ELSE 1 END)   ::TFloat AS CountItsOut_Weight
          
     FROM tmpMIContainer
          LEFT JOIN tmpGoods_Param AS tmpGoods ON tmpGoods.GoodsId = tmpMIContainer.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMIContainer.GoodsKindId
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMIContainer.UnitId  

      ;                                
       
       --zc_Container_CountVirt + zc_MIContainer_CountVirt - 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 01.09.26         *
*/

-- тест
--select * from gpReport_MotionGoods_CountVirt (inStartDate :=('03.08.2026')::TDateTime, inEndDate := ('08.08.2026')::TDateTime, inUnitGroupId := 0, inGoodsGroupId := 1846, inGoodsId := 0,  inSession := '5');
-- select * from gpReport_MotionGoods_CountVirt(inStartDate := ('01.08.2026')::TDateTime , inEndDate := ('31.08.2026')::TDateTime , inUnitGroupId := 8459 , inGoodsGroupId := 563246 , inGoodsId := 0 ,  inSession := '9457');