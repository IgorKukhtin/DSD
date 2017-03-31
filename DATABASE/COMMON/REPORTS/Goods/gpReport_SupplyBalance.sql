-- Function: gpReport_SupplyBalance()

DROP FUNCTION IF EXISTS gpReport_SupplyBalance (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_SupplyBalance(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inLocationId         Integer,    -- подразделение склад
    IN inGoodsGroupId       Integer,    -- группа товара
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsCode Integer, GoodsName TVarChar
             , GoodsKindName  TVarChar
             , MeasureName TVarChar
             , GoodsGroupNameFull TVarChar

             , CountDays TFloat
             , RemainsStart TFloat
             , RemainsEnd TFloat
             , CountIncome TFloat
             , CountProductionOut TFloat
             , CountSendIn  TFloat
             , CountSendOut TFloat
             , CountOnDay Float 
             , RemainsDays Float 
             , ReserveDays Float 
             , PlanOrder Float 
             , CountOrder Float 
             , RemainsDaysWithOrder Float 
             , Color_RemainsDays Integer
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCountDays Integer;
BEGIN

    -- Ограничения по товарам
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
    IF inGoodsGroupId <> 0
    THEN
        INSERT INTO _tmpGoods (GoodsId)
           SELECT lfObject_Goods_byGoodsGroup.GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup;
    ELSE
        INSERT INTO _tmpGoods (GoodsId)
           SELECT Object.Id FROM Object WHERE DescId = zc_Object_Goods();
    END IF;

    vbCountDays := (SELECT DATE_PART('day', (inEndDate - inStartDate )) + 1);

     RETURN QUERY
     WITH 
    tmpContainer AS (SELECT tmp.GoodsId, tmp.goodskindid
                          , SUM (tmp.StartAmount)        AS RemainsStart 
                          , SUM (tmp.EndAmount)          AS RemainsEnd 
                          , SUM (tmp.CountIncome)        AS CountIncome
                          , SUM (tmp.CountProductionOut) AS CountProductionOut
                          , SUM (tmp.CountSendIn)        AS CountSendIn
                          , SUM (tmp.CountSendOut)       AS CountSendOut
                     FROM (SELECT Container.ObjectId                     AS GoodsId
                                , COALESCE (CLO_GoodsKind.ObjectId, 0)   AS GoodsKindId
                                , Container.Amount 
                                , Container.Amount - SUM (COALESCE(MIContainer.Amount, 0))  AS StartAmount
                                , Container.Amount - SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS EndAmount
                                         
                                , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                             AND MIContainer.MovementDescId in (zc_Movement_Income(), zc_Movement_ReturnOut()) 
                                            THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS CountIncome
                                , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                             AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                             AND MIContainer.isActive = FALSE
                                            THEN -1 * MIContainer.Amount
                                            ELSE 0
                                       END) AS CountProductionOut
                                , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                             AND MIContainer.MovementDescId = zc_Movement_Send()
                                             AND MIContainer.isActive = TRUE
                                            THEN MIContainer.Amount
                                            ELSE 0
                                       END) AS CountSendIn
                                , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                             AND MIContainer.MovementDescId = zc_Movement_Send()
                                             AND MIContainer.isActive = FALSE
                                            THEN -1 * MIContainer.Amount
                                            ELSE 0
                                       END) AS CountSendOut
                           FROM ContainerLinkObject AS CLO_Unit
                                INNER JOIN Container ON Container.Id = CLO_Unit.ContainerId AND Container.DescId = zc_Container_Count() 
                                LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                              ON CLO_GoodsKind.ContainerId = CLO_Unit.ContainerId
                                                             AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                LEFT JOIN MovementItemContainer AS MIContainer 
                                                                ON MIContainer.Containerid = Container.Id
                                                               AND MIContainer.OperDate >= inStartDate
                           WHERE CLO_Unit.ObjectId = inLocationId
                             AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                            -- AND Container.ObjectId = 625267
                           GROUP BY Container.ObjectId, GoodsKindId, Container.Amount
                           HAVING (Container.Amount - COALESCE(SUM (MIContainer.Amount), 0)) <>0 ) AS tmp
                     GROUP BY tmp.GoodsId, tmp.goodskindid
                     )

       -- Результат
       SELECT
             Object_Goods.ObjectCode                    AS GoodsCode
           , Object_Goods.ValueData                     AS GoodsName
           , Object_GoodsKind.ValueData                 AS GoodsKindName
           , Object_Measure.ValueData                   AS MeasureName
           , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
           , vbCountDays                 AS CountDays

           , tmpContainer.RemainsStart   :: TFloat
           , tmpContainer.RemainsEnd     :: TFloat
           , tmpContainer.CountIncome         :: TFloat
           , tmpContainer.CountProductionOut  :: TFloat 
           , tmpContainer.CountSendIn         :: TFloat
           , tmpContainer.CountSendOut        :: TFloat

           , CASE WHEN vbCountDays <> 0 THEN tmpContainer.CountProductionOut/vbCountDays ELSE 0 END  :: TFloat AS CountOnDay
           , CASE WHEN tmpContainer.RemainsEnd <> 0 AND (tmpContainer.CountProductionOut/vbCountDays) <> 0
                  THEN tmpContainer.RemainsEnd / (tmpContainer.CountProductionOut/vbCountDays) 
                  ELSE 0
             END                                :: TFloat AS RemainsDays
           , 30 :: TFloat AS ReserveDays
           , ((tmpContainer.CountProductionOut/vbCountDays) * 30 - tmpContainer.RemainsEnd)    :: TFloat AS PlanOrder
           , 0  :: TFloat AS CountOrder
           , CASE WHEN (tmpContainer.CountProductionOut/vbCountDays) <> 0 
                  THEN (tmpContainer.RemainsEnd + 0)/ (tmpContainer.CountProductionOut/vbCountDays) 
                  ELSE 0 
             END  :: TFloat AS RemainsDaysWithOrder

           , CASE WHEN (CASE WHEN tmpContainer.RemainsEnd <> 0 AND (tmpContainer.CountProductionOut/vbCountDays) <> 0
                        THEN tmpContainer.RemainsEnd / (tmpContainer.CountProductionOut/vbCountDays) 
                        ELSE 0 END) < 30
                  THEN zc_Color_Red() 
                  ELSE zc_Color_Black()
             END  :: integer AS Color_RemainsDays

       FROM tmpContainer
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpContainer.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpContainer.GoodsKindId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                                          AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()
          ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 30.03.17         *
*/

-- тест
-- 