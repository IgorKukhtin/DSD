-- Function: gpReport_MotionGoods()

-- DROP FUNCTION gpReport_MotionGoods (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_MotionGoods(
    IN inStartDate    TDateTime , -- 
    IN inEndDate      TDateTime , --
    IN inUnitGroupId  Integer,    -- группа подразделений
    IN inUnitId       Integer,    -- подразделение
    IN inGoodsGroupId Integer,    -- группа товара 
    IN inGoodsId      Integer,    -- товар
    
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , PartionGoodsId Integer, PartionGoodsCode Integer, PartionGoodsName TVarChar
             , GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar
             , AssetToId Integer, AssetToCode Integer, AssetToName TVarChar
             , MeasureName TVarChar , Weight TFloat
             
             , StartWeight TFloat, StartCount TFloat    , StartSumm TFloat
             , IncomeWeight TFloat, IncomeCount TFloat   , IncomeSumm TFloat
             , SendInWeight TFloat, SendInCount TFloat   , SendInSumm TFloat
             , SendOutWeight TFloat, SendOutCount TFloat  , SendOutSumm TFloat
             , SaleWeight TFloat , SaleCount TFloat     , SaleSumm TFloat
             , ReturnOutWeight TFloat, ReturnOutCount TFloat, ReturnOutSumm TFloat
             , ReturnInWeight TFloat , ReturnInCount TFloat , ReturnInSumm TFloat
             , LossWeight TFloat     , LossCount TFloat     , LossSumm TFloat
             , InventoryWeight TFloat, InventoryCount TFloat, InventorySumm TFloat
             , EndWeight_calc TFloat , EndCount_calc TFloat , EndSumm_calc TFloat
              )
AS
$BODY$BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_MotionGoods());

     -- таблица - 
     CREATE TEMP TABLE tmpGoods (GoodsId Integer) ON COMMIT DROP;
     CREATE TEMP TABLE tmpLocationObject (LocationObjectId Integer) ON COMMIT DROP;

    IF inGoodsGroupId <> 0 
    THEN 
       INSERT INTO tmpGoods (GoodsId)
          SELECT GoodsId
          FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId);
    ELSE IF inGoodsId <> 0 
         THEN 
             INSERT INTO tmpGoods (GoodsId)
              SELECT inGoodsId;
         ELSE 
             INSERT INTO tmpGoods (GoodsId)
              SELECT Id FROM Object WHERE DescId = zc_Object_Goods();
         END IF;
    END IF;

    IF inUnitGroupId <> 0 
    THEN 
       INSERT INTO tmpLocationObject (LocationObjectId)
          SELECT UnitId
          FROM  lfSELECT_Object_Unit_byUnitGroup (inUnitGroupId);
    ELSE IF inUnitId <> 0 
         THEN 
             INSERT INTO tmpLocationObject (LocationObjectId)
              SELECT inUnitId;
         ELSE 
             INSERT INTO tmpLocationObject (LocationObjectId)
              SELECT Id FROM Object WHERE DescId = zc_Object_Unit()
             UNION all
              SELECT Id FROM Object WHERE DescId = zc_Object_Personal();
         END IF;
    END IF;

     RETURN QUERY 

      SELECT _tmp_All.GoodsId, Object_Goods.ObjectCode AS GoodsCode, Object_Goods.ValueData AS GoodsName  
           , _tmp_All.UnitId , Object_Unit.ObjectCode  AS UnitCode, Object_Unit.ValueData  AS UnitName
           , _tmp_All.PartionGoodsId, Object_PartionGoods.ObjectCode AS PartionGoodsCode, Object_PartionGoods.ValueData AS PartionGoodsName
           , _tmp_All.GoodsKindId, Object_GoodsKind.ObjectCode  AS GoodsKindCode, Object_GoodsKind.ValueData  AS GoodsKindName
           , _tmp_All.AssetToId, Object_AssetTo.ObjectCode  AS AssetToCode, Object_AssetTo.ValueData  AS AssetToName

           , Object_Measure.ValueData     AS MeasureName
           , ObjectFloat_Weight.ValueData AS Weight

           
           , case when Object_Measure.Id = '1'  /*шт*/ THEN CAST ((SUM (_tmp_All.StartCount)*ObjectFloat_Weight.ValueData) AS TFloat) else  CAST (SUM (_tmp_All.StartCount) AS TFloat) END AS StartWeight   
           , case when Object_Measure.Id = '1'  /*шт*/ THEN CAST  (SUM (_tmp_All.StartCount) AS TFloat) else 0 END AS StartCount   
           , CAST (SUM (_tmp_All.StartSumm) AS TFloat)     AS StartSumm

           , case when Object_Measure.Id = '1'  /*шт*/ THEN CAST ((SUM (_tmp_All.IncomeCount)*ObjectFloat_Weight.ValueData) AS TFloat) else  CAST (SUM (_tmp_All.IncomeCount) AS TFloat) END AS IncomeWeight   
           , case when Object_Measure.Id = '1'  /*шт*/ THEN CAST  (SUM (_tmp_All.IncomeCount) AS TFloat) else 0 END AS IncomeCount   
           , CAST (SUM (_tmp_All.IncomeSumm) AS TFloat)    AS IncomeSumm

           , case when Object_Measure.Id = '1'  /*шт*/ THEN CAST ((SUM (_tmp_All.SendInCount)*ObjectFloat_Weight.ValueData) AS TFloat) else  CAST (SUM (_tmp_All.SendInCount) AS TFloat) END AS SendInWeight   
           , case when Object_Measure.Id = '1'  /*шт*/ THEN CAST  (SUM (_tmp_All.SendInCount) AS TFloat) else 0 END AS SendInCount   
           , CAST (SUM (_tmp_All.SendInSumm) AS TFloat)    AS SendInSumm

           , case when Object_Measure.Id = '1'  /*шт*/ THEN CAST ((SUM (_tmp_All.SendOutCount)*ObjectFloat_Weight.ValueData) AS TFloat) else  CAST (SUM (_tmp_All.SendOutCount) AS TFloat) END AS SendOutWeight   
           , case when Object_Measure.Id = '1'  /*шт*/ THEN CAST  (SUM (_tmp_All.SendOutCount) AS TFloat) else 0 END AS SendOutCount           
           , CAST (SUM (_tmp_All.SendOutSumm) AS TFloat)   AS SendOutSumm

           , case when Object_Measure.Id = '1'  /*шт*/ THEN CAST ((SUM (_tmp_All.SaleCount)*ObjectFloat_Weight.ValueData) AS TFloat) else  CAST (SUM (_tmp_All.SaleCount) AS TFloat) END AS SaleWeight   
           , case when Object_Measure.Id = '1'  /*шт*/ THEN CAST  (SUM (_tmp_All.SaleCount) AS TFloat) else 0 END AS SaleCount           
           , CAST (SUM (_tmp_All.SaleSumm) AS TFloat)      AS SaleSumm

           , case when Object_Measure.Id = '1'  /*шт*/ THEN CAST ((SUM (_tmp_All.ReturnOutCount)*ObjectFloat_Weight.ValueData) AS TFloat) else  CAST (SUM (_tmp_All.ReturnOutCount) AS TFloat) END AS ReturnOutWeight   
           , case when Object_Measure.Id = '1'  /*шт*/ THEN CAST  (SUM (_tmp_All.ReturnOutCount) AS TFloat) else 0 END AS ReturnOutCount           
           , CAST (SUM (_tmp_All.ReturnOutSumm) AS TFloat) AS ReturnOutSumm

           , case when Object_Measure.Id = '1'  /*шт*/ THEN CAST ((SUM (_tmp_All.ReturnInCount)*ObjectFloat_Weight.ValueData) AS TFloat) else  CAST (SUM (_tmp_All.ReturnInCount) AS TFloat) END AS ReturnInWeight   
           , case when Object_Measure.Id = '1'  /*шт*/ THEN CAST  (SUM (_tmp_All.ReturnInCount) AS TFloat) else 0 END AS ReturnInCount           
           , CAST (SUM (_tmp_All.ReturnInSumm) AS TFloat)  AS ReturnInSumm
        
           , case when Object_Measure.Id = '1'  /*шт*/ THEN CAST ((SUM (_tmp_All.LossCount)*ObjectFloat_Weight.ValueData) AS TFloat) else  CAST (SUM (_tmp_All.LossCount) AS TFloat) END AS LossWeight   
           , case when Object_Measure.Id = '1'  /*шт*/ THEN CAST  (SUM (_tmp_All.LossCount) AS TFloat) else 0 END AS LossCount           
           , CAST (SUM (_tmp_All.LossSumm) AS TFloat)      AS LossSumm
        
           , case when Object_Measure.Id = '1'  /*шт*/ THEN CAST ((SUM (_tmp_All.InventoryCount)*ObjectFloat_Weight.ValueData) AS TFloat) else  CAST (SUM (_tmp_All.InventoryCount) AS TFloat) END AS InventoryWeight   
           , case when Object_Measure.Id = '1'  /*шт*/ THEN CAST  (SUM (_tmp_All.InventoryCount) AS TFloat) else 0 END AS InventoryCount           
           , CAST (SUM (_tmp_All.InventorySumm) AS TFloat) AS InventorySumm
           
           , case when Object_Measure.Id = '1'  /*шт*/ THEN CAST ((SUM (_tmp_All.EndCount_calc)*ObjectFloat_Weight.ValueData) AS TFloat) else  CAST (SUM (_tmp_All.EndCount_calc) AS TFloat) END AS EndWeight_calc   
           , case when Object_Measure.Id ='1'  /*шт*/ THEN CAST  (SUM (_tmp_All.EndCount_calc) AS TFloat) else 0 END AS EndCount_calc           
           , CAST (SUM (_tmp_All.EndSumm_calc) AS TFloat)  AS EndSumm_calc
           
      FROM 
            (SELECT
                    _tmpContainerAll.GoodsId               AS GoodsId
                  , ContainerLinkObject_Unit.ObjectId      AS UnitId
                  , ContainerLinkObject_PartionGoods.ObjectId  AS PartionGoodsId
                  , ContainerLinkObject_GoodsKind.ObjectId AS GoodsKindId
                  , ContainerLinkObject_AssetTo.ObjectId   AS AssetToId
             
                  , _tmpContainerAll.RemainsStart AS StartSumm
                  , _tmpContainerAll.IncomeSumm
                  , _tmpContainerAll.SendInSumm 
                  , _tmpContainerAll.SendOutSumm
                  , _tmpContainerAll.SaleSumm
                  , _tmpContainerAll.ReturnOutSumm
                  , _tmpContainerAll.ReturnInSumm                 
                  , _tmpContainerAll.LossSumm
                  , _tmpContainerAll.InventorySumm
                  ,(_tmpContainerAll.RemainsStart + _tmpContainerAll.IncomeSumm + _tmpContainerAll.SendInSumm - _tmpContainerAll.SendOutSumm + _tmpContainerAll.SaleSumm + _tmpContainerAll.ReturnInSumm - _tmpContainerAll.ReturnOutSumm - _tmpContainerAll.LossSumm + _tmpContainerAll.InventorySumm) AS EndSumm_calc
            
                  , 0 AS StartCount
                  , 0 AS IncomeCount
                  , 0 AS SendInCount
                  , 0 AS SendOutCount
                  , 0 AS SaleCount
                  , 0 AS ReturnOutCount
                  , 0 AS ReturnInCount 
                  , 0 AS LossCount 
                  , 0 AS InventoryCount 
                  , 0 AS EndCount_calc 

                FROM (
                      SELECT  Container.Id AS ContainerId                                 --счет
                            , tmpContainer.GoodsId AS GoodsId
                            , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS RemainsStart
                            --, Container.Amount - (CASE WHEN MIContainer.OperDate > inEndDate THEN  COALESCE (SUM (MIContainer.Amount), 0) ELSE 0 END) AS RemainsEnd
                            , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Income() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0)    AS IncomeSumm
                            , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Send() AND MIContainer.isActive = TRUE AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0)  AS SendInSumm
                            , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Send() AND MIContainer.isActive = FALSE AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS SendOutSumm
                            , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Sale() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0)      AS SaleSumm
                            , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_ReturnOut() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS ReturnOutSumm
                            , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_ReturnIn() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0)  AS ReturnInSumm
                            , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Loss() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0)      AS LossSumm
                            , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Inventory() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS InventorySumm
                      FROM lfSELECT_Object_Account_byAccountGroup (zc_Enum_AccountGroup_20000()) AS lfObject_Account -- -20000; "Запасы"     -- написать функцию lfGet_Object_Account_byAccountGroup
                           LEFT JOIN (SELECT tmpContainer.ContainerId, tmpContainer.AccountId, tmpGoods.GoodsId, tmpContainer.UnitId, tmpContainer.Amount
                                      FROM tmpGoods 
                                           join ContainerLinkObject AS ContainerLinkObject_Goods ON  ContainerLinkObject_Goods.ObjectId = tmpGoods .GoodsId
                                                                                                 AND ContainerLinkObject_Goods.DescId = zc_ContainerLinkObject_Goods()
                                           join  (SELECT Container.Id AS ContainerId, Container.ObjectId AS AccountId, UnitId, Container.Amount
                                                  FROM tmpUnit
                                                        LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Unit ON ContainerLinkObject_Unit.Objectid = tmpUnit.UnitId
                                                                                                                 AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                        LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Personal ON ContainerLinkObject_Personal.Objectid = tmpUnit.UnitId
                                                                                                                     AND ContainerLinkObject_Personal.DescId = zc_ContainerLinkObject_Unit()
                                                        JOIN  Container ON Container.Id = COALESCE (ContainerLinkObject_Unit.ContainerId, ContainerLinkObject_Personal.ContainerId)
                                                                       AND Container.DescId = zc_Container_Summ() 
                                                 ) AS  tmpObject on tmpObject.ContainerId = ContainerLinkObject_Goods.ContainerId
                                     ) AS tmpContainer ON tmpContainer.AccountId = lfObject_Account.AccountId
                                             
                           LEFT JOIN MovementItemContainer AS MIContainer
                                                           ON MIContainer.Containerid = Container.Id
                                                          AND MIContainer.OperDate >= inStartDate
                           LEFT JOIN Movement ON Movement.Id = MIContainer.MovementId
                      GROUP BY Container.Amount
                             , Container.Id
                      HAVING (Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0)
                          OR (COALESCE (SUM (CASE WHEN MIContainer.Amount > 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) <> 0)
                          OR (COALESCE (SUM (CASE WHEN MIContainer.Amount < 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN -MIContainer.Amount ELSE 0 END), 0) <> 0)
                      ) AS _tmpContainerAll
                 
                      LEFT JOIN  ContainerLinkObject AS ContainerLinkObject_PartionGoods ON ContainerLinkObject_PartionGoods.Containerid = _tmpContainerAll.ContainerId
                                                    AND ContainerLinkObject_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                      LEFT JOIN  ContainerLinkObject AS ContainerLinkObject_GoodsKind ON ContainerLinkObject_GoodsKind.Containerid = _tmpContainerAll.ContainerId
                                                    AND ContainerLinkObject_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                      LEFT JOIN  ContainerLinkObject AS ContainerLinkObject_AssetTo ON ContainerLinkObject_AssetTo.Containerid = _tmpContainerAll.ContainerId
                                                    AND ContainerLinkObject_AssetTo.DescId = zc_ContainerLinkObject_AssetTo()
                                               
                                                
        UNION ALL
               SELECT _tmpContainerAll.GoodsId 
                    , _tmpContainerAll.UnitId                   AS UnitId
                    , ContainerLinkObject_PartionGoods.ObjectId AS PartionGoodsId
                    , ContainerLinkObject_GoodsKind.ObjectId    AS GoodsKindId
                    , ContainerLinkObject_AssetTo.ObjectId      AS AssetToId
                    
                    , 0 AS StartSumm
                    , 0 AS IncomeSumm
                    , 0 AS SendInSumm
                    , 0 AS SendOutSumm
                    , 0 AS SaleSumm
                    , 0 AS ReturnOutSumm
                    , 0 AS ReturnInSumm
                    , 0 AS LossSumm
                    , 0 AS InventorySumm
                    , 0 AS EndSumm_calc
                    , SUM (RemainsStart)   AS StartCount           
                    , SUM (_tmpContainerAll.IncomeCount)    AS IncomeCount 
                    , SUM (_tmpContainerAll.SendInCount)    AS SendInCount    
                    , SUM (_tmpContainerAll.SendOutCount)   AS SendOutCount   
                    , SUM (_tmpContainerAll.SaleCount)      AS SaleCount      
                    , SUM (_tmpContainerAll.ReturnOutCount) AS ReturnOutCount 
                    , SUM (_tmpContainerAll.ReturnInCount)  AS ReturnInCount  
                    , SUM (_tmpContainerAll.LossCount)      AS LossCount      
                    , SUM (_tmpContainerAll.InventoryCount) AS InventoryCount 
                    , SUM (_tmpContainerAll.RemainsStart + _tmpContainerAll.IncomeCount + _tmpContainerAll.SendInCount - _tmpContainerAll.SendOutCount + _tmpContainerAll.SaleCount + _tmpContainerAll.ReturnInCount - _tmpContainerAll.ReturnOutCount - _tmpContainerAll.LossCount + _tmpContainerAll.InventoryCount) AS EndCount_calc
      
               FROM (
                     SELECT  tmpContainer.Id AS ContainerId
                           , tmpGoods.GoodsId AS GoodsId
                           , tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS RemainsStart
                           , tmpContainer.UnitId AS UnitId
                      
                           , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Income() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0)    AS IncomeCount
                           , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Send() AND MIContainer.isActive = TRUE AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0)  AS SendInCount
                           , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Send() AND MIContainer.isActive = FALSE AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS SendOutCount
                           , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Sale() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0)      AS SaleCount
                           , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_ReturnOut() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS ReturnOutCount
                           , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_ReturnIn() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0)  AS ReturnInCount
                           , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Loss() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0)      AS LossCount
                           , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Inventory() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS InventoryCount
                      
                     FROM tmpGoods 
                          join ContainerLinkObject AS ContainerLinkObject_Goods ON  ContainerLinkObject_Goods.ObjectId = tmpGoods .GoodsId
                                                                               AND ContainerLinkObject_Goods.DescId = zc_ContainerLinkObject_Goods()
                          join  (SELECT Container.Id AS ContainerId, Container.ObjectId AS GoodsId, UnitId, Container.Amount
                                 FROM tmpUnit
                                      LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Unit ON ContainerLinkObject_Unit.Objectid = tmpUnit.UnitId
                                                                                               AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                        
                                           JOIN  Container ON Container.Id = ContainerLinkObject_Unit.ContainerId
                                                          AND Container.DescId = zc_Container_Count() 
                                  ) AS  tmpObject on tmpObject.ContainerId = ContainerLinkObject_Goods.ContainerId
                                      
                     
                          LEFT JOIN MovementItemContainer AS MIContainer
                                                          ON MIContainer.Containerid = tmpContainer.Id
                                                         AND MIContainer.OperDate >= inStartDate
                          LEFT JOIN Movement ON Movement.Id = MIContainer.MovementId
                    -- WHERE Container.DescId = zc_Container_Count()

                     GROUP BY tmpContainer.Amount
                            , tmpContainer.Id 
                            , tmpGoods.GoodsId
                            , tmpContainer.UnitId
                     HAVING (Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0)
                         OR (COALESCE (SUM (CASE WHEN MIContainer.Amount > 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) <> 0)
                         OR (COALESCE (SUM (CASE WHEN MIContainer.Amount < 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN -MIContainer.Amount ELSE 0 END), 0) <> 0)
                     ) AS _tmpContainerAll

                  LEFT JOIN  ContainerLinkObject AS ContainerLinkObject_PartionGoods
                                                ON ContainerLinkObject_PartionGoods.Containerid = _tmpContainerAll.ContainerId
                                               AND ContainerLinkObject_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                 LEFT JOIN  ContainerLinkObject AS ContainerLinkObject_GoodsKind
                                                ON ContainerLinkObject_GoodsKind.Containerid = _tmpContainerAll.ContainerId
                                               AND ContainerLinkObject_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                 LEFT JOIN  ContainerLinkObject AS ContainerLinkObject_AssetTo 
                                                ON ContainerLinkObject_AssetTo.Containerid = _tmpContainerAll.ContainerId
                                               AND ContainerLinkObject_AssetTo.DescId = zc_ContainerLinkObject_AssetTo()
                 GROUP BY _tmpContainerAll.GoodsId
                         ,_tmpContainer.UnitId
                         , ContainerLinkObject_PartionGoods.ObjectId 
                         , ContainerLinkObject_GoodsKind.ObjectId
                         , ContainerLinkObject_AssetTo.ObjectId
                                               
      ) as _tmp_All
      
      LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = _tmp_All.GoodsId
      
          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id 
                                                          AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectFloat AS ObjectFloat_Weight ON ObjectFloat_Weight.ObjectId = Object_Goods.Id 
                               AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
     
      LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = _tmp_All.UnitId
      LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = _tmp_All.PartionGoodsId
      LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = _tmp_All.GoodsKindId
      LEFT JOIN Object AS Object_AssetTo ON Object_AssetTo.Id = _tmp_All.AssetToId
      
      GROUP BY _tmp_All.GoodsId, Object_Goods.ObjectCode, Object_Goods.ValueData
           , _tmp_All.UnitId , Object_Unit.ObjectCode, Object_Unit.ValueData
           , _tmp_All.PartionGoodsId, Object_PartionGoods.ObjectCode, Object_PartionGoods.ValueData
           , _tmp_All.GoodsKindId, Object_GoodsKind.ObjectCode, Object_GoodsKind.ValueData
           , _tmp_All.AssetToId, Object_AssetTo.ObjectCode, Object_AssetTo.ValueData; 
 

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_MotionGoods (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.08.13         *
*/

-- тест
-- SELECT * FROM gpReport_MotionGoods (inStartDate:= '01.01.2013', inEndDate:= '01.02.2013', inSession:= '2') where AccountGroupCode = 20000 and StartCount <> 0 