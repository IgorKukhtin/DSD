-- Function: gpReport_HistoryCost()

-- DROP FUNCTION gpReport_HistoryCost (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_HistoryCost(
    IN inStartDate   TDateTime , -- 
    IN inEndDate     TDateTime , --
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (ObjectCostId Integer
             , MovementId Integer, MovementItemId Integer, ContainerId Integer, OperDate TDateTime, InvNumber TVarChar, MovementDescCode TVarChar, OperCount TFloat, OperPrice TFloat -- , OperSumm TFloat
             , Price TFloat, Price_Calc TFloat
             , UnitParentCode Integer, UnitParentName TVarChar, UnitCode Integer, UnitName TVarChar
             , GoodsGroupCode Integer, GoodsGroupName TVarChar, GoodsCode Integer, GoodsName TVarChar, GoodsKindCode Integer, GoodsKindName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyCode_Detail Integer, InfoMoneyName_Detail TVarChar
             , PartionGoodsName TVarChar
             , BusinessId Integer, BusinessCode Integer, BusinessName TVarChar, JuridicalBasisId Integer, JuridicalBasisCode Integer, JuridicalBasisName TVarChar
             , BranchCode Integer, BranchName TVarChar, PersonalCode Integer, PersonalName TVarChar, AssetCode Integer, AssetName TVarChar
             , CalcCount TFloat, StartCount TFloat, StartCount_calc TFloat, IncomeCount TFloat, IncomeCount_calc TFloat, OutCount TFloat, OutCount_calc TFloat, EndCount TFloat, EndCount_calc TFloat
             , StartSumm TFloat, StartSumm_calc TFloat, IncomeSumm TFloat, IncomeSumm_calc TFloat, OutSumm TFloat, OutSumm_calc TFloat, EndSumm TFloat, EndSumm_calc TFloat
              )
AS
$BODY$BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_HistoryCost());

     RETURN QUERY 
       SELECT
             ContainerObjectCost.ObjectCostId
           , _tmpSumm.MovementId
           , _tmpSumm.MovementItemId
           , _tmpSumm.ContainerId
           , _tmpSumm.OperDate
           , _tmpSumm.InvNumber
           , _tmpSumm.Code AS MovementDescCode
           , _tmpSumm.OperCount
           , CAST (_tmpSumm.OperPrice AS TFloat) AS OperPrice
--           , CAST (_tmpSumm.OperSumm AS TFloat) AS OperSumm

           , HistoryCost.Price
           , CAST (
             CASE WHEN (COALESCE (tmpOperationCount.AmountRemainsStart, 0) + COALESCE (tmpOperationCount.AmountDebet, 0)) > 0 AND (COALESCE (tmpOperationSumm.AmountRemainsStart, 0) + COALESCE (tmpOperationSumm.AmountDebet, 0)) > 0
                      THEN  (COALESCE (tmpOperationSumm.AmountRemainsStart, 0) + COALESCE (tmpOperationSumm.AmountDebet, 0)) / (COALESCE (tmpOperationCount.AmountRemainsStart, 0) + COALESCE (tmpOperationCount.AmountDebet, 0))
                  WHEN  (COALESCE (tmpOperationCount.AmountRemainsStart, 0) + COALESCE (tmpOperationCount.AmountDebet, 0)) < 0 AND (COALESCE (tmpOperationSumm.AmountRemainsStart, 0) + COALESCE (tmpOperationSumm.AmountDebet, 0)) < 0
                      THEN  (COALESCE (tmpOperationSumm.AmountRemainsStart, 0) + COALESCE (tmpOperationSumm.AmountDebet, 0)) / (COALESCE (tmpOperationCount.AmountRemainsStart, 0) + COALESCE (tmpOperationCount.AmountDebet, 0))
                  ELSE 0
             END AS TFloat) AS Price_Calc

           , Object_UnitParent.ObjectCode AS UnitParentCode
           , Object_UnitParent.ValueData AS UnitParentName
           , Object_Unit.ObjectCode AS UnitCode
           , Object_Unit.ValueData AS UnitName

           , Object_GoodsGroup.ObjectCode AS GoodsGroupCode
           , Object_GoodsGroup.ValueData AS GoodsGroupName
           , Object_Goods.ObjectCode AS GoodsCode
           , Object_Goods.ValueData AS GoodsName
           , Object_GoodsKind.ObjectCode AS GoodsKindCode
           , Object_GoodsKind.ValueData AS GoodsKindName

           , lfObject_InfoMoney.InfoMoneyCode
           , lfObject_InfoMoney.InfoMoneyName
           , lfObject_InfoMoney_Detail.InfoMoneyCode AS InfoMoneyCode_Detail
           , lfObject_InfoMoney_Detail.InfoMoneyName AS InfoMoneyName_Detail

           , Object_PartionGoods.ValueData AS PartionGoodsName

           , Object_Business.Id AS BusinessId
           , Object_Business.ObjectCode AS BusinessCode
           , Object_Business.ValueData AS BusinessName
           , Object_JuridicalBasis.Id AS JuridicalBasisId
           , Object_JuridicalBasis.ObjectCode AS JuridicalBasisCode
           , Object_JuridicalBasis.ValueData AS JuridicalBasisName
           , Object_Branch.ObjectCode AS BranchCode
           , Object_Branch.ValueData AS BranchName
           , Object_Personal.ObjectCode AS PersonalCode
           , Object_Personal.ValueData AS PersonalName
           , Object_Asset.ObjectCode AS AssetCode
           , Object_Asset.ValueData AS AssetName

           , (HistoryCost.CalcCount )  AS CalcCount 
           , (HistoryCost.StartCount)  AS StartCount
           , tmpOperationCount.AmountRemainsStart AS StartCount_calc

           , (HistoryCost.IncomeCount) AS IncomeCount
           , tmpOperationCount.AmountDebet AS IncomeCount_calc

           , CAST (0 AS TFloat) AS OutCount -- _tmpHistoryCost.OutCount
           , tmpOperationCount.AmountKredit AS OutCount_calc

           , CAST (0 AS TFloat) AS EndCount -- _tmpHistoryCost.EndCount
           , tmpOperationCount.AmountRemainsEnd AS EndCount_calc


           , (HistoryCost.StartSumm)   AS StartSumm
           , tmpOperationSumm.AmountRemainsStart AS StartSumm_calc

           , (HistoryCost.IncomeSumm)  AS IncomeSumm
           , tmpOperationSumm.AmountDebet AS IncomeSumm_calc

           , CAST ( 0 AS TFloat) AS OutSumm -- _tmpHistoryCost.OutSumm
           , tmpOperationSumm.AmountKredit AS OutSumm_calc

           , CAST ( 0 AS TFloat) AS EndSumm -- _tmpHistoryCost.EndSumm
           , tmpOperationSumm.AmountRemainsEnd AS EndSumm_calc

       FROM (SELECT ContainerObjectCost.ObjectCostId FROM ContainerObjectCost WHERE ContainerObjectCost.ObjectCostDescId = zc_ObjectCost_Basis() GROUP BY ContainerObjectCost.ObjectCostId
            ) AS ContainerObjectCost
            LEFT JOIN ObjectCostLink AS ObjectCostLink_Unit
                                     ON ObjectCostLink_Unit.ObjectCostId = ContainerObjectCost.ObjectCostId
                                    AND ObjectCostLink_Unit.DescId = zc_ObjectCostLink_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectCostLink_Unit.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                 ON ObjectLink_Unit_Parent.ObjectId = ObjectCostLink_Unit.ObjectId
                                AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
            LEFT JOIN Object AS Object_UnitParent ON Object_UnitParent.Id = ObjectLink_Unit_Parent.ChildObjectId

            LEFT JOIN ObjectCostLink AS ObjectCostLink_Goods
                                     ON ObjectCostLink_Goods.ObjectCostId = ContainerObjectCost.ObjectCostId
                                    AND ObjectCostLink_Goods.DescId = zc_ObjectCostLink_Goods()
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectCostLink_Goods.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = ObjectCostLink_Goods.ObjectId
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

            LEFT JOIN ObjectCostLink AS ObjectCostLink_GoodsKind
                                     ON ObjectCostLink_GoodsKind.ObjectCostId = ContainerObjectCost.ObjectCostId
                                    AND ObjectCostLink_GoodsKind.DescId = zc_ObjectCostLink_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectCostLink_GoodsKind.ObjectId

            LEFT JOIN ObjectCostLink AS ObjectCostLink_InfoMoney
                                     ON ObjectCostLink_InfoMoney.ObjectCostId = ContainerObjectCost.ObjectCostId
                                    AND ObjectCostLink_InfoMoney.DescId = zc_ObjectCostLink_InfoMoney()
            LEFT JOIN lfSelect_Object_InfoMoney() AS lfObject_InfoMoney ON lfObject_InfoMoney.InfoMoneyId = ObjectCostLink_InfoMoney.ObjectId

            LEFT JOIN ObjectCostLink AS ObjectCostLink_InfoMoneyDetail
                                     ON ObjectCostLink_InfoMoneyDetail.ObjectCostId = ContainerObjectCost.ObjectCostId
                                    AND ObjectCostLink_InfoMoneyDetail.DescId = zc_ObjectCostLink_InfoMoneyDetail()
            LEFT JOIN lfSelect_Object_InfoMoney() AS lfObject_InfoMoney_Detail ON lfObject_InfoMoney_Detail.InfoMoneyId = ObjectCostLink_InfoMoneyDetail.ObjectId

            LEFT JOIN ObjectCostLink AS ObjectCostLink_PartionGoods
                                     ON ObjectCostLink_PartionGoods.ObjectCostId = ContainerObjectCost.ObjectCostId
                                    AND ObjectCostLink_PartionGoods.DescId = zc_ObjectCostLink_PartionGoods()
            LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = ObjectCostLink_PartionGoods.ObjectId

            LEFT JOIN ObjectCostLink AS ObjectCostLink_Business
                                     ON ObjectCostLink_Business.ObjectCostId = ContainerObjectCost.ObjectCostId
                                    AND ObjectCostLink_Business.DescId = zc_ObjectCostLink_Business()
            LEFT JOIN Object AS Object_Business ON Object_Business.Id = ObjectCostLink_Business.ObjectId

            LEFT JOIN ObjectCostLink AS ObjectCostLink_JuridicalBasis
                                     ON ObjectCostLink_JuridicalBasis.ObjectCostId = ContainerObjectCost.ObjectCostId
                                    AND ObjectCostLink_JuridicalBasis.DescId = zc_ObjectCostLink_JuridicalBasis()
            LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = ObjectCostLink_JuridicalBasis.ObjectId

            LEFT JOIN ObjectCostLink AS ObjectCostLink_Branch
                                     ON ObjectCostLink_Branch.ObjectCostId = ContainerObjectCost.ObjectCostId
                                    AND ObjectCostLink_Branch.DescId = zc_ObjectCostLink_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectCostLink_Branch.ObjectId

            LEFT JOIN ObjectCostLink AS ObjectCostLink_Personal
                                     ON ObjectCostLink_Personal.ObjectCostId = ContainerObjectCost.ObjectCostId
                                    AND ObjectCostLink_Personal.DescId = zc_ObjectCostLink_Personal()
            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectCostLink_Personal.ObjectId

            LEFT JOIN ObjectCostLink AS ObjectCostLink_Asset
                                     ON ObjectCostLink_Asset.ObjectCostId = ContainerObjectCost.ObjectCostId
                                    AND ObjectCostLink_Asset.DescId = zc_ObjectCostLink_AssetTo()
            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = ObjectCostLink_Asset.ObjectId

            LEFT JOIN HistoryCost ON HistoryCost.ObjectCostId = ContainerObjectCost.ObjectCostId
                                 AND HistoryCost.StartDate = inStartDate AND HistoryCost.EndDate = inEndDate
--            (SELECT HistoryCost.ObjectCostId
--                  , (HistoryCost.StartCount)  AS StartCount
--                  , (HistoryCost.StartSumm)   AS StartSumm
--                  , (HistoryCost.IncomeCount) AS IncomeCount
--                  , (HistoryCost.IncomeSumm)  AS IncomeSumm
--             FROM HistoryCost
--             WHERE HistoryCost.StartDate = inStartDate AND HistoryCost.EndDate = inEndDate
--            ) AS _tmpHistoryCost ON _tmpHistoryCost.ObjectCostId = ContainerObjectCost.ObjectCostId

            LEFT JOIN
           (SELECT ContainerObjectCost_Summ.ObjectCostId
                 , Movement.Id AS MovementId
                 , MIContainer.MovementItemId
                 , MIContainer.ContainerId
                 , Movement.OperDate
                 , Movement.InvNumber
                 , CAST (MovementDesc.Code || '+' || MovementItemDesc.Code AS TVarChar) AS Code
                 , MovementItem.Amount AS OperCount
                 , CAST (CASE WHEN MovementItem.Amount <> 0 THEN MIContainer.Amount / MovementItem.Amount ELSE 0 END AS TFloat) AS OperPrice
                 , MIContainer.Amount AS OperSumm
            FROM (SELECT MovementItemContainer.ContainerId, MovementItemContainer.MovementItemId, ABS (SUM (Amount)) AS Amount FROM MovementItemContainer WHERE MovementItemContainer.OperDate BETWEEN inStartDate AND inEndDate AND MovementItemContainer.DescId = zc_MIContainer_Summ() GROUP BY MovementItemContainer.ContainerId, MovementItemContainer.MovementItemId) AS MIContainer
                 JOIN ContainerObjectCost AS ContainerObjectCost_Summ
                                          ON ContainerObjectCost_Summ.ContainerId = MIContainer.ContainerId
                                         AND ContainerObjectCost_Summ.ObjectCostDescId = zc_ObjectCost_Basis()
                 JOIN MovementItem ON MovementItem.Id = MIContainer.MovementItemId
                 JOIN Movement ON Movement.Id = MovementItem.MovementId
                 JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
                 JOIN MovementItemDesc ON MovementItemDesc.Id = MovementItem.DescId
            -- WHERE 1=0
           ) AS _tmpSumm ON _tmpSumm.ObjectCostId = ContainerObjectCost.ObjectCostId
            LEFT JOIN
           (SELECT ContainerObjectCost_RemainsSumm.ObjectCostId
                 , CAST (SUM (tmpMIContainer_Remains.AmountRemainsStart) AS TFloat) AS AmountRemainsStart
                 , CAST (SUM (tmpMIContainer_Remains.AmountDebet) AS TFloat) AS AmountDebet
                 , CAST (SUM (tmpMIContainer_Remains.AmountKredit) AS TFloat) AS AmountKredit
                 , CAST (SUM (tmpMIContainer_Remains.AmountRemainsStart + tmpMIContainer_Remains.AmountDebet - tmpMIContainer_Remains.AmountKredit) AS TFloat) AS AmountRemainsEnd
            FROM
                (SELECT Container.Id AS ContainerId
                      , COALESCE (SUM (CASE WHEN MIContainer.Amount > 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) AS AmountDebet
                      , COALESCE (SUM (CASE WHEN MIContainer.Amount < 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN -MIContainer.Amount ELSE 0 END), 0) AS AmountKredit
                      , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS AmountRemainsStart
                 FROM Container
                      LEFT JOIN MovementItemContainer AS MIContainer
                                                      ON MIContainer.Containerid = Container.Id
                                                     AND MIContainer.OperDate >= inStartDate
                 WHERE Container.DescId = zc_Container_Summ()
                 GROUP BY Container.Amount
                        , Container.Id
                 HAVING (Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0) -- AmountRemainsStart <> 0
                     OR (COALESCE (SUM (CASE WHEN MIContainer.Amount > 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) <> 0) -- AmountDebet <> 0
                     OR (COALESCE (SUM (CASE WHEN MIContainer.Amount < 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN -MIContainer.Amount ELSE 0 END), 0) <> 0) -- AmountKredit <> 0
                ) AS tmpMIContainer_Remains
                LEFT JOIN ContainerObjectCost AS ContainerObjectCost_RemainsSumm
                                              ON ContainerObjectCost_RemainsSumm.ContainerId = tmpMIContainer_Remains.ContainerId
                                             AND ContainerObjectCost_RemainsSumm.ObjectCostDescId = zc_ObjectCost_Basis()
            GROUP BY ContainerObjectCost_RemainsSumm.ObjectCostId
           ) AS tmpOperationSumm ON tmpOperationSumm.ObjectCostId = ContainerObjectCost.ObjectCostId
            LEFT JOIN
           (SELECT ContainerObjectCost_RemainsSumm.ObjectCostId
                 , CAST (SUM (tmpMIContainer_Remains.AmountRemainsStart) AS TFloat) AS AmountRemainsStart
                 , CAST (SUM (tmpMIContainer_Remains.AmountDebet) AS TFloat) AS AmountDebet
                 , CAST (SUM (tmpMIContainer_Remains.AmountKredit) AS TFloat) AS AmountKredit
                 , CAST (SUM (tmpMIContainer_Remains.AmountRemainsStart + tmpMIContainer_Remains.AmountDebet - tmpMIContainer_Remains.AmountKredit) AS TFloat) AS AmountRemainsEnd
            FROM
                (SELECT Container.Id AS ContainerId
                      , COALESCE (SUM (CASE WHEN MIContainer.Amount > 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) AS AmountDebet
                      , COALESCE (SUM (CASE WHEN MIContainer.Amount < 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN -MIContainer.Amount ELSE 0 END), 0) AS AmountKredit
                      , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS AmountRemainsStart
                 FROM Container
                      LEFT JOIN MovementItemContainer AS MIContainer
                                                      ON MIContainer.Containerid = Container.Id
                                                     AND MIContainer.OperDate >= inStartDate
                 WHERE Container.DescId = zc_Container_Count()
                 GROUP BY Container.Amount
                        , Container.Id
                 HAVING (Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0) -- AmountRemainsStart <> 0
                     OR (COALESCE (SUM (CASE WHEN MIContainer.Amount > 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) <> 0) -- AmountDebet <> 0
                     OR (COALESCE (SUM (CASE WHEN MIContainer.Amount < 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN -MIContainer.Amount ELSE 0 END), 0) <> 0) -- AmountKredit <> 0
                ) AS tmpMIContainer_Remains
                LEFT JOIN Container AS Container_Summ ON Container_Summ.ParentId = tmpMIContainer_Remains.ContainerId
                                                     AND Container_Summ.DescId = zc_Container_Summ()
                LEFT JOIN ContainerObjectCost AS ContainerObjectCost_RemainsSumm
                                              ON ContainerObjectCost_RemainsSumm.ContainerId = Container_Summ.Id
                                             AND ContainerObjectCost_RemainsSumm.ObjectCostDescId = zc_ObjectCost_Basis()
            GROUP BY ContainerObjectCost_RemainsSumm.ObjectCostId
           ) AS tmpOperationCount ON tmpOperationCount.ObjectCostId = ContainerObjectCost.ObjectCostId

--       WHERE HistoryCost.Price <> 0
/*       WHERE (
--              HistoryCost.CalcCount <> 0
--           OR HistoryCost.StartCount <> 0
--           OR 
               tmpOperationCount.AmountRemainsStart <> 0

--           OR HistoryCost.IncomeCount <> 0
--           OR tmpOperationCount.AmountDebet <> 0

--           OR tmpOperationCount.AmountKredit <> 0

--           OR tmpOperationCount.AmountRemainsEnd <> 0

           OR HistoryCost.StartSumm <> 0
           OR tmpOperationSumm.AmountRemainsStart <> 0

           OR HistoryCost.IncomeSumm <> 0
           OR tmpOperationSumm.AmountDebet <> 0

           OR tmpOperationSumm.AmountKredit <> 0

           OR tmpOperationSumm.AmountRemainsEnd <> 0

           OR _tmpSumm.OperCount <> 0
           OR _tmpSumm.OperPrice <> 0
           OR _tmpSumm.OperSumm <> 0
           OR HistoryCost.Price <> 0
             )*/
       ;

  
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_HistoryCost (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.07.13                                        *
*/

-- тест
-- SELECT * FROM gpReport_HistoryCost (inStartDate:= '01.01.2013', inEndDate:= '31.01.2013', inSession:= '2') -- WHERE ObjectCostId IN (13928)
-- SELECT * FROM gpReport_HistoryCost (inStartDate:= '01.01.2013', inEndDate:= '31.01.2013', inSession:= '2') -- WHERE (MovementId <> 0 OR  IncomeSumm_calc <> 0 OR OutSumm_calc <> 0) and  GoodsCode = 4033
