-- Function: gpReport_MotionGoods()

-- DROP FUNCTION gpReport_MotionGoods (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_MotionGoods(
    IN inStartDate   TDateTime , -- 
    IN inEndDate     TDateTime , --
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , PartionGoodsId Integer, PartionGoodsCode Integer, PartionGoodsName TVarChar
             , GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar
             , AssetToId Integer, AssetToCode Integer, AssetToName TVarChar
             , StartCount TFloat    , StartSumm TFloat
             , IncomeCount TFloat   , IncomeSumm TFloat
             , SendInCount TFloat   , SendInSumm TFloat
             , SendOutCount TFloat  , SendOutSumm TFloat
             , SaleCount TFloat     , SaleSumm TFloat
             , ReturnOutCount TFloat, ReturnOutSumm TFloat
             , ReturnInCount TFloat , ReturnInSumm TFloat
             , LossCount TFloat     , LossSumm TFloat
             , InventoryCount TFloat, InventorySumm TFloat
             , EndCount_calc TFloat , EndSumm_calc TFloat
              )
AS
$BODY$BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_MotionGoods());

     -- таблица - Аналитики остатка
     CREATE TEMP TABLE tmpGoods (GoodsId Integer) ON COMMIT DROP;
     CREATE TEMP TABLE tmpLocationObject (LocationObjectId Integer) ON COMMIT DROP;


    IF inUnitGroupId <> 0 
    then 
       insert tmpLocationObject (LocationObjectId)
          select UnitId
          from  gpSelect_Object_Unit_byUnitGoup (inUnitGroupId)
    else IF inUnitId <> 0 
         then 
             insert tmpLocationObject (LocationObjectId)
              select inUnitId
         else 
             insert tmpLocationObject (LocationObjectId)
              select Id from Object where DescId = zc_Object_Unit()
             union
              select Id from Object where DescId = zc_Object_Personal()
    end if;


     RETURN QUERY 

      SELECT _tmp_All.GoodsId, Object_Goods.ObjectCode AS GoodsCode, Object_Goods.ValueData AS GoodsName  
           , _tmp_All.UnitId , Object_Unit.ObjectCode  AS UnitCode, Object_Unit.ValueData  AS UnitName
           , _tmp_All.PartionGoodsId, Object_PartionGoods.ObjectCode AS PartionGoodsCode, Object_PartionGoods.ValueData AS PartionGoodsName
           , _tmp_All.GoodsKindId, Object_GoodsKind.ObjectCode  AS GoodsKindCode, Object_GoodsKind.ValueData  AS GoodsKindName
           , _tmp_All.AssetToId, Object_AssetTo.ObjectCode  AS AssetToCode, Object_AssetTo.ValueData  AS AssetToName

           
           , CAST (SUM (_tmp_All.StartCount) AS TFloat)     AS StartCount      , CAST (SUM (_tmp_All.StartSumm) AS TFloat)     AS StartSumm
           , CAST (SUM (_tmp_All.IncomeCount) AS TFloat)    AS IncomeCount     , CAST (SUM (_tmp_All.IncomeSumm) AS TFloat)    AS IncomeSumm
           , CAST (SUM (_tmp_All.SendInCount) AS TFloat)    AS SendInCount     , CAST (SUM (_tmp_All.SendInSumm) AS TFloat)    AS SendInSumm
           , CAST (SUM (_tmp_All.SendOutCount) AS TFloat)   AS SendOutCount    , CAST (SUM (_tmp_All.SendOutSumm) AS TFloat)   AS SendOutSumm
           , CAST (SUM (_tmp_All.SaleCount) AS TFloat)      AS SaleCount       , CAST (SUM (_tmp_All.SaleSumm) AS TFloat)      AS SaleSumm
           , CAST (SUM (_tmp_All.ReturnOutCount) AS TFloat) AS ReturnOutCount  , CAST (SUM (_tmp_All.ReturnOutSumm) AS TFloat) AS ReturnOutSumm
           , CAST (SUM (_tmp_All.ReturnInCount) AS TFloat)  AS ReturnInCount   , CAST (SUM (_tmp_All.ReturnInSumm) AS TFloat)  AS ReturnInSumm
           , CAST (SUM (_tmp_All.LossCount) AS TFloat)      AS LossCount       , CAST (SUM (_tmp_All.LossSumm) AS TFloat)      AS LossSumm
           , CAST (SUM (_tmp_All.InventoryCount) AS TFloat) AS InventoryCount  , CAST (SUM (_tmp_All.InventorySumm) AS TFloat) AS InventorySumm
           , CAST (SUM (_tmp_All.EndCount_calc) AS TFloat)  AS EndCount_calc   , CAST (SUM (_tmp_All.EndSumm_calc) AS TFloat)  AS EndSumm_calc
      FROM 
            (SELECT
                    ContainerLinkObject_Goods.ObjectId     AS GoodsId
                  , ContainerLinkObject_Unit.ObjectId      AS UnitId
                  , ContainerLinkObject_PartionGoods.ObjectId  AS PartionGoodsId
                  , ContainerLinkObject_GoodsKind.ObjectId AS GoodsKindId
                  , ContainerLinkObject_AssetTo.ObjectId   AS AssetToId
             
                  , _tmpContainer.RemainsStart AS StartSumm
                  , _tmpContainer.IncomeSumm
                  , _tmpContainer.SendInSumm 
                  , _tmpContainer.SendOutSumm
                  , _tmpContainer.SaleSumm
                  , _tmpContainer.ReturnOutSumm
                  , _tmpContainer.ReturnInSumm                 
                  , _tmpContainer.LossSumm
                  , _tmpContainer.InventorySumm
                  ,(_tmpContainer.RemainsStart + _tmpContainer.IncomeSumm + _tmpContainer.SendInSumm - _tmpContainer.SendOutSumm + _tmpContainer.SaleSumm + _tmpContainer.ReturnInSumm - _tmpContainer.ReturnOutSumm - _tmpContainer.LossSumm + _tmpContainer.InventorySumm) AS EndSumm_calc
            
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
                      FROM lfSelect_Object_Account_byAccountGroup (zc_Enum_AccountGroup_20000()) AS lfObject_Account -- -20000; "Запасы"     -- написать функцию lfGet_Object_Account_byAccountGroup
                           LEFT JOIN (SELECT tmpContainer.ContainerId, tmpContainer.AccountId, GoodsId, tmpContainer.UnitId, tmpContainer.Amount
                                      FROM tmpGoods 
                                           join ContainerLinkObject AS ContainerLinkObject_Goods ON  ContainerLinkObject_Goods.ObjectId = = tmpGoods .GoodsId
                                                                                                 AND ContainerLinkObject_Goods.DescId = zc_ContainerLinkObject_Goods()
                                           join  (SELECT Container.Id AS ContainerId, Container.ObjectId AS AccountId, UnitId, Container.Amount
                                                  from tmpUnit
                                                        LEFT JOIN  ContainerLinkObject AS ContainerLinkObject_Unit ON ContainerLinkObject_Unit.Objectid = tmpUnit.UnitId
                                                                                                             AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                        LEFT JOIN  ContainerLinkObject AS ContainerLinkObject_Personal ON ContainerLinkObject_Personal.Objectid = tmpUnit.UnitId
                                                                                                                      AND ContainerLinkObject_Personal.DescId = zc_ContainerLinkObject_Unit()
                                                        JOIN  Container ON Container.Id =  COALESCE (ContainerLinkObject_Unit.ContainerId, ContainerLinkObject_Personal.ContainerId)
                                                                       AND Container.DescId = zc_Container_Summ() 
                                                 ) AS  t1 on t1.ContainerId = ContainerLinkObject_Goods.ContainerId
                                     ) AS tmpContainer ON tmpContainer.AccountId = lfObject_Account.AccountId
                                              AND 
                           LEFT JOIN MovementItemContainer AS MIContainer
                                                           ON MIContainer.Containerid = Container.Id
                                                          AND MIContainer.OperDate >= inStartDate
                           LEFT JOIN Movement ON Movement.Id = MIContainer.MovementId
                      GROUP BY Container.Amount
                             , Container.Id
                      HAVING (Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0)
                          OR (COALESCE (SUM (CASE WHEN MIContainer.Amount > 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) <> 0)
                          OR (COALESCE (SUM (CASE WHEN MIContainer.Amount < 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN -MIContainer.Amount ELSE 0 END), 0) <> 0)
                      ) AS _tmpContainer
                 
                 
                      LEFT JOIN  ContainerLinkObject AS ContainerLinkObject_PartionGoods ON ContainerLinkObject_PartionGoods.Containerid = _tmpContainer.ContainerId
                                                    AND ContainerLinkObject_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                      LEFT JOIN  ContainerLinkObject AS ContainerLinkObject_GoodsKind ON ContainerLinkObject_GoodsKind.Containerid = _tmpContainer.ContainerId
                                                    AND ContainerLinkObject_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                      LEFT JOIN  ContainerLinkObject AS ContainerLinkObject_AssetTo ON ContainerLinkObject_AssetTo.Containerid = _tmpContainer.ContainerId
                                                    AND ContainerLinkObject_AssetTo.DescId = zc_ContainerLinkObject_AssetTo()
                                               
                                                
        UNION ALL
               SELECT _tmpContainer.GoodsId 
                    , ContainerLinkObject_Unit.ObjectId         AS UnitId
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
                    , SUM (_tmpContainer.IncomeCount)    AS IncomeCount 
                    , SUM (_tmpContainer.SendInCount)    AS SendInCount    
                    , SUM (_tmpContainer.SendOutCount)   AS SendOutCount   
                    , SUM (_tmpContainer.SaleCount)      AS SaleCount      
                    , SUM (_tmpContainer.ReturnOutCount) AS ReturnOutCount 
                    , SUM (_tmpContainer.ReturnInCount)  AS ReturnInCount  
                    , SUM (_tmpContainer.LossCount)      AS LossCount      
                    , SUM (_tmpContainer.InventoryCount) AS InventoryCount 
                    , SUM (_tmpContainer.RemainsStart + _tmpContainer.IncomeCount + _tmpContainer.SendInCount - _tmpContainer.SendOutCount + _tmpContainer.SaleCount + _tmpContainer.ReturnInCount - _tmpContainer.ReturnOutCount - _tmpContainer.LossCount + _tmpContainer.InventoryCount) AS EndCount_calc
      
               FROM (
                     SELECT  Container.Id AS ContainerId
                           , Container.ObjectId AS GoodsId
                           , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS RemainsStart
                      
                           , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Income() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0)    AS IncomeCount
                           , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Send() AND MIContainer.isActive = TRUE AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0)  AS SendInCount
                           , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Send() AND MIContainer.isActive = FALSE AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS SendOutCount
                           , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Sale() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0)      AS SaleCount
                           , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_ReturnOut() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS ReturnOutCount
                           , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_ReturnIn() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0)  AS ReturnInCount
                           , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Loss() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0)      AS LossCount
                           , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Inventory() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS InventoryCount
                      
                     FROM Container
                          LEFT JOIN MovementItemContainer AS MIContainer
                                                          ON MIContainer.Containerid = Container.Id
                                                         AND MIContainer.OperDate >= inStartDate
                          LEFT JOIN Movement ON Movement.Id = MIContainer.MovementId
                     WHERE Container.DescId = zc_Container_Count()

                     GROUP BY Container.Amount
                            , Container.Id
                     HAVING (Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0)
                         OR (COALESCE (SUM (CASE WHEN MIContainer.Amount > 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) <> 0)
                         OR (COALESCE (SUM (CASE WHEN MIContainer.Amount < 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN -MIContainer.Amount ELSE 0 END), 0) <> 0)
                     ) AS _tmpContainer

                 LEFT JOIN  ContainerLinkObject AS ContainerLinkObject_Unit
                                                ON ContainerLinkObject_Unit.Containerid = _tmpContainer.ContainerId
                                               AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                 LEFT JOIN  ContainerLinkObject AS ContainerLinkObject_PartionGoods
                                                ON ContainerLinkObject_PartionGoods.Containerid = _tmpContainer.ContainerId
                                               AND ContainerLinkObject_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                 LEFT JOIN  ContainerLinkObject AS ContainerLinkObject_GoodsKind
                                                ON ContainerLinkObject_GoodsKind.Containerid = _tmpContainer.ContainerId
                                               AND ContainerLinkObject_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                 LEFT JOIN  ContainerLinkObject AS ContainerLinkObject_AssetTo 
                                                ON ContainerLinkObject_AssetTo.Containerid = _tmpContainer.ContainerId
                                               AND ContainerLinkObject_AssetTo.DescId = zc_ContainerLinkObject_AssetTo()
                 GROUP BY _tmpContainer.GoodsId
                         , ContainerLinkObject_Unit.ObjectId 
                         , ContainerLinkObject_PartionGoods.ObjectId 
                         , ContainerLinkObject_GoodsKind.ObjectId
                         , ContainerLinkObject_AssetTo.ObjectId
                                               
      ) as _tmp_All
      
      LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = _tmp_All.GoodsId
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
ALTER FUNCTION gpReport_MotionGoods (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.08.13         *
*/

-- тест
-- SELECT * FROM gpReport_MotionGoods (inStartDate:= '01.01.2013', inEndDate:= '01.02.2013', inSession:= '2') where AccountGroupCode = 20000 and StartCount <> 0 
