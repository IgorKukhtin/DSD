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
             , CountStart TFloat    , SummStart TFloat
             , CountIncomePartner TFloat, SummIncomePartner TFloat
             , CountSendIn TFloat   , SummSendIn TFloat
             , CountSendOut TFloat  , SummSendOut TFloat
             , CountSale TFloat     , SummSale TFloat
             , CountReturnOut TFloat, SummReturnOut TFloat
             , CountReturnIn TFloat , SummReturnIn TFloat
             , CountLoss TFloat     , SummLoss TFloat
             , CountInventory TFloat, SummInventory TFloat
             , CountEnd TFloat      , SummEnd TFloat
              )
AS
$BODY$BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_MotionGoods());

     RETURN QUERY 

      SELECT _tmp_All.GoodsId, Object_Goods.ObjectCode AS GoodsCode, Object_Goods.ValueData AS GoodsName  
           , _tmp_All.UnitId , Object_Unit.ObjectCode  AS UnitCode, Object_Unit.ValueData  AS UnitName
           , _tmp_All.PartionGoodsId, Object_PartionGoods.ObjectCode AS PartionGoodsCode, Object_PartionGoods.ValueData AS PartionGoodsName
           , _tmp_All.GoodsKindId, Object_GoodsKind.ObjectCode  AS GoodsKindCode, Object_GoodsKind.ValueData  AS GoodsKindName
           , _tmp_All.AssetToId, Object_AssetTo.ObjectCode  AS AssetToCode, Object_AssetTo.ValueData  AS AssetToName

           
           , SUM (CountStart)     AS CountStart      , SUM (SummStart)     AS SummStart
           , SUM (CountIncomePartner) AS CountIncomePartner , SUM (SummIncomePartner) AS SummIncomePartner
           , SUM (CountSendIn)    AS CountSendIn     , SUM (SummSendIn)    AS SummSendIn
           , SUM (CountSendOut)   AS CountSendOut    , SUM (SummSendOut)   AS SummSendOut
           , SUM (CountSale)      AS CountSale       , SUM (SummSale)      AS SummSale
           , SUM (CountReturnOut) AS CountReturnOut  , SUM (SummReturnOut) AS SummReturnOut
           , SUM (CountReturnIn)  AS CountReturnIn   , SUM (SummReturnIn)  AS SummReturnIn
           , SUM (CountLoss)      AS CountLoss       , SUM (SummLoss)      AS SummLoss
           , SUM (CountInventory) AS CountInventory  , SUM (SummInventory) AS SummInventory
           , SUM (CountEnd)       AS CountEnd        , SUM (SummEnd)       AS SummEnd
      FROM 
            (SELECT
                    ContainerLinkObject_Goods.ObjectId     AS GoodsId
                  , ContainerLinkObject_Unit.ObjectId      AS UnitId
                  , ContainerLinkObject_PartionGoods.ObjectId  AS PartionGoodsId
                  , ContainerLinkObject_GoodsKind.ObjectId AS GoodsKindId
                  , ContainerLinkObject_AssetTo.ObjectId   AS AssetToId
             
                  , _tmpContainer.RemainsStart AS SummStart
                  , _tmpContainer.SummIncomePartner
                  , _tmpContainer.SummSendIn 
                  , _tmpContainer.SummSendOut
                  , _tmpContainer.SummSale
                  , _tmpContainer.SummReturnOut
                  , _tmpContainer.SummReturnIn                 
                  , _tmpContainer.SummLoss
                  , _tmpContainer.SummInventory
                  ,(_tmpContainer.RemainsStart + _tmpContainer.SummIncomePartner + _tmpContainer.SummSendIn - _tmpContainer.SummSendOut + _tmpContainer.SummSale + _tmpContainer.SummReturnIn - _tmpContainer.SummReturnOut - _tmpContainer.SummLoss + _tmpContainer.SummInventory) AS SummEnd
            
                  , 0 AS CountStart
                  , 0 AS CountIncomePartner 
                  , 0 AS CountSendIn    
                  , 0 AS CountSendOut   
                  , 0 AS CountSale 
                  , 0 AS CountReturnOut 
                  , 0 AS CountReturnIn 
                  , 0 AS CountLoss 
                  , 0 AS CountInventory 
                  , 0 AS CountEnd 

                FROM (
                      SELECT  Container.Id AS ContainerId                                 --счет
                            , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS RemainsStart
                            --, Container.Amount - (CASE WHEN MIContainer.OperDate > inEndDate THEN  COALESCE (SUM (MIContainer.Amount), 0) ELSE 0 END) AS RemainsEnd
                            , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Income() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0)    AS SummIncomePartner
                            , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Send() AND MIContainer.isActive = TRUE AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0)  AS SummSendIn
                            , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Send() AND MIContainer.isActive = FALSE AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS SummSendOut
                            , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Sale() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0)      AS SummSale
                            , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_ReturnOut() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS SummReturnOut
                            , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_ReturnIn() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0)  AS SummReturnIn
                            , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Loss() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0)      AS SummLoss
                            , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Inventory() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS SummInventory
                      FROM lfSelect_Object_Account_byAccountGroup (zc_Enum_AccountGroup_20000()) AS lfObject_Account -- -20000; "Запасы"     -- написать функцию lfGet_Object_Account_byAccountGroup
                           LEFT JOIN Container ON Container.ObjectId = lfObject_Account.AccountId
                                              AND Container.DescId = zc_Container_Summ() 
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
                 
                 
                      LEFT JOIN  ContainerLinkObject AS ContainerLinkObject_Goods ON ContainerLinkObject_Goods.ContainerId = _tmpContainer.ContainerId
                                                    AND ContainerLinkObject_Goods.DescId = zc_ContainerLinkObject_Goods()
                      LEFT JOIN  ContainerLinkObject AS ContainerLinkObject_Unit ON ContainerLinkObject_Unit.Containerid = _tmpContainer.ContainerId
                                                    AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
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
                    
                    , 0 AS SummStart
                    , 0 AS SummIncomePartner
                    , 0 AS SummSendIn
                    , 0 AS SummSendOut
                    , 0 AS SummSale
                    , 0 AS SummReturnOut
                    , 0 AS SummReturnIn
                    , 0 AS SummLoss
                    , 0 AS SummInventory
                    , 0 AS SummEnd
                    , SUM (RemainsStart)     AS CountStart           
                    , SUM (CountIncomePartner) AS CountIncomePartner 
                    , SUM (CountSendIn)    AS CountSendIn    
                    , SUM (CountSendOut)   AS CountSendOut   
                    , SUM (CountSale)      AS CountSale      
                    , SUM (CountReturnOut) AS CountReturnOut 
                    , SUM (CountReturnIn)  AS CountReturnIn  
                    , SUM (CountLoss)      AS CountLoss      
                    , SUM (CountInventory) AS CountInventory 
                    , SUM (_tmpContainer.RemainsStart + _tmpContainer.CountIncomePartner + _tmpContainer.CountSendIn - _tmpContainer.CountSendOut + _tmpContainer.CountSale + _tmpContainer.CountReturnIn - _tmpContainer.CountReturnOut - _tmpContainer.CountLoss + _tmpContainer.CountInventory) AS CountEnd
      
               FROM (
                     SELECT  Container.Id AS ContainerId
                           , Container.ObjectId AS GoodsId
                           , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS RemainsStart
                      
                           , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Income() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0)    AS CountIncomePartner
                           , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Send() AND MIContainer.isActive = TRUE AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0)  AS CountSendIn
                           , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Send() AND MIContainer.isActive = FALSE AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS CountSendOut
                           , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Sale() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0)      AS CountSale
                           , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_ReturnOut() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS CountReturnOut
                           , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_ReturnIn() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0)  AS CountReturnIn
                           , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Loss() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0)      AS CountLoss
                           , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Inventory() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS CountInventory
                      
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
-- SELECT * FROM gpReport_MotionGoods (inStartDate:= '01.01.2013', inEndDate:= '01.02.2013', inSession:= '2') where AccountGroupCode = 20000 and CountStart <> 0 
