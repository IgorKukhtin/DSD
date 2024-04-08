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
             , CalcCount TFloat, CalcSumm TFloat
             , StartCount TFloat, StartCount_calc TFloat, IncomeCount TFloat, IncomeCount_calc TFloat, OutCount TFloat, OutCount_calc TFloat, EndCount TFloat, EndCount_calc TFloat
             , StartSumm TFloat, StartSumm_calc TFloat, IncomeSumm TFloat, IncomeSumm_calc TFloat, OutSumm TFloat, OutSumm_calc TFloat, EndSumm TFloat, EndSumm_calc TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);
 
     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_HistoryCost());

     RETURN QUERY 
       SELECT
             ContainerObjectCost.ContainerId AS ObjectCostId
           , _tmpSumm.MovementId
           , _tmpSumm.MovementItemId
           , _tmpSumm.ContainerId
           , _tmpSumm.OperDate
           , _tmpSumm.InvNumber
           , _tmpSumm.Code AS MovementDescCode
           , _tmpSumm.OperCount
           , CAST (_tmpSumm.OperPrice AS TFloat) AS OperPrice

           , HistoryCost.Price
           , CAST (
             CASE WHEN ((COALESCE (tmpOperationSumm.StartCount, 0) + COALESCE (tmpOperationSumm.IncomeCount, 0)) > 0 AND (COALESCE (tmpOperationSumm.StartSumm, 0) + COALESCE (tmpOperationSumm.IncomeSumm, 0)) > 0)
                    OR ((COALESCE (tmpOperationSumm.StartCount, 0) + COALESCE (tmpOperationSumm.IncomeCount, 0)) < 0 AND (COALESCE (tmpOperationSumm.StartSumm, 0) + COALESCE (tmpOperationSumm.IncomeSumm, 0)) < 0)
                      THEN  (COALESCE (tmpOperationSumm.StartSumm, 0) + COALESCE (tmpOperationSumm.IncomeSumm, 0)) / (COALESCE (tmpOperationSumm.StartCount, 0) + COALESCE (tmpOperationSumm.IncomeCount, 0))
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

           , (HistoryCost.CalcCount) AS CalcCount
           , (HistoryCost.CalcSumm)  AS CalcSumm

           , (HistoryCost.StartCount)  AS StartCount
           , tmpOperationSumm.StartCount AS StartCount_calc

           , CAST (HistoryCost.IncomeCount + HistoryCost.CalcCount AS TFloat) AS IncomeCount
           , tmpOperationSumm.IncomeCount AS IncomeCount_calc

           , HistoryCost.OutCount
           , tmpOperationSumm.OutCount AS OutCount_calc

           , CAST (HistoryCost.StartCount + HistoryCost.IncomeCount + HistoryCost.CalcCount - HistoryCost.OutCount AS TFloat) AS EndCount
           , CAST (tmpOperationSumm.StartCount + tmpOperationSumm.IncomeCount - tmpOperationSumm.OutCount AS TFloat) AS EndCount_calc


           , (HistoryCost.StartSumm)   AS StartSumm
           , tmpOperationSumm.StartSumm AS StartSumm_calc

           , CAST (HistoryCost.IncomeSumm + HistoryCost.CalcSumm AS TFloat)  AS IncomeSumm
           , tmpOperationSumm.IncomeSumm AS IncomeSumm_calc

           , HistoryCost.OutSumm
           , tmpOperationSumm.OutSumm AS OutSumm_calc

           , CAST (HistoryCost.StartSumm + HistoryCost.IncomeSumm + HistoryCost.CalcSumm - HistoryCost.OutSumm AS TFloat) AS EndSumm
           , CAST (tmpOperationSumm.StartSumm + tmpOperationSumm.IncomeSumm - tmpOperationSumm.OutSumm AS TFloat) AS EndSumm_calc

       FROM (SELECT Container_summ.Id AS ContainerId FROM Container INNER JOIN Container AS Container_summ ON Container_summ.ParentId = Container.Id AND Container_summ.DescId = zc_Container_Summ() WHERE Container.DescId = zc_Container_Count()
            ) AS ContainerObjectCost
            LEFT JOIN ContainerLinkObject AS ObjectCostLink_Unit
                                          ON ObjectCostLink_Unit.ContainerId = ContainerObjectCost.ContainerId
                                         AND ObjectCostLink_Unit.DescId = zc_ContainerLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectCostLink_Unit.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                 ON ObjectLink_Unit_Parent.ObjectId = ObjectCostLink_Unit.ObjectId
                                AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
            LEFT JOIN Object AS Object_UnitParent ON Object_UnitParent.Id = ObjectLink_Unit_Parent.ChildObjectId

            LEFT JOIN ContainerLinkObject AS ObjectCostLink_Goods
                                          ON ObjectCostLink_Goods.ContainerId = ContainerObjectCost.ContainerId
                                         AND ObjectCostLink_Goods.DescId = zc_ContainerLinkObject_Goods()
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectCostLink_Goods.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = ObjectCostLink_Goods.ObjectId
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

            LEFT JOIN ContainerLinkObject AS ObjectCostLink_GoodsKind
                                          ON ObjectCostLink_GoodsKind.ContainerId = ContainerObjectCost.ContainerId
                                         AND ObjectCostLink_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectCostLink_GoodsKind.ObjectId

            LEFT JOIN ContainerLinkObject AS ObjectCostLink_InfoMoney
                                          ON ObjectCostLink_InfoMoney.ContainerId = ContainerObjectCost.ContainerId
                                         AND ObjectCostLink_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
            LEFT JOIN lfSelect_Object_InfoMoney() AS lfObject_InfoMoney ON lfObject_InfoMoney.InfoMoneyId = ObjectCostLink_InfoMoney.ObjectId

            LEFT JOIN ContainerLinkObject AS ObjectCostLink_InfoMoneyDetail
                                          ON ObjectCostLink_InfoMoneyDetail.ContainerId = ContainerObjectCost.ContainerId
                                         AND ObjectCostLink_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
            LEFT JOIN lfSelect_Object_InfoMoney() AS lfObject_InfoMoney_Detail ON lfObject_InfoMoney_Detail.InfoMoneyId = ObjectCostLink_InfoMoneyDetail.ObjectId

            LEFT JOIN ContainerLinkObject AS ObjectCostLink_PartionGoods
                                          ON ObjectCostLink_PartionGoods.ContainerId = ContainerObjectCost.ContainerId
                                         AND ObjectCostLink_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
            LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = ObjectCostLink_PartionGoods.ObjectId

            LEFT JOIN ContainerLinkObject AS ObjectCostLink_Business
                                     ON ObjectCostLink_Business.ContainerId = ContainerObjectCost.ContainerId
                                    AND ObjectCostLink_Business.DescId = zc_ContainerLinkObject_Business()
            LEFT JOIN Object AS Object_Business ON Object_Business.Id = ObjectCostLink_Business.ObjectId

            LEFT JOIN ContainerLinkObject AS ObjectCostLink_JuridicalBasis
                                     ON ObjectCostLink_JuridicalBasis.ContainerId = ContainerObjectCost.ContainerId
                                    AND ObjectCostLink_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
            LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = ObjectCostLink_JuridicalBasis.ObjectId

            LEFT JOIN ContainerLinkObject AS ObjectCostLink_Branch
                                     ON ObjectCostLink_Branch.ContainerId = ContainerObjectCost.ContainerId
                                    AND ObjectCostLink_Branch.DescId = zc_ContainerLinkObject_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectCostLink_Branch.ObjectId

            LEFT JOIN ContainerLinkObject AS ObjectCostLink_Personal
                                     ON ObjectCostLink_Personal.ContainerId = ContainerObjectCost.ContainerId
                                    AND ObjectCostLink_Personal.DescId = zc_ContainerLinkObject_Personal()
            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectCostLink_Personal.ObjectId

            LEFT JOIN ContainerLinkObject AS ObjectCostLink_Asset
                                     ON ObjectCostLink_Asset.ContainerId = ContainerObjectCost.ContainerId
                                    AND ObjectCostLink_Asset.DescId = zc_ContainerLinkObject_AssetTo()
            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = ObjectCostLink_Asset.ObjectId

            LEFT JOIN HistoryCost ON HistoryCost.ContainerId = ContainerObjectCost.ContainerId
                                 AND HistoryCost.StartDate = inStartDate AND HistoryCost.EndDate = inEndDate
            LEFT JOIN
            -- это операции в разрезе документов
           (SELECT MIContainer.ContainerId
                 , Movement.Id AS MovementId
                 , MIContainer.MovementItemId
                 , Movement.OperDate
                 , Movement.InvNumber
                 , CAST (MovementDesc.Code || '+' || MovementItemDesc.Code AS TVarChar) AS Code
                 , MovementItem.Amount AS OperCount
                 , CAST (CASE WHEN MovementItem.Amount <> 0 THEN MIContainer.Amount / MovementItem.Amount ELSE 0 END AS TFloat) AS OperPrice
                 , MIContainer.Amount AS OperSumm
            FROM (SELECT MovementItemContainer.ContainerId, MovementItemContainer.MovementItemId, ABS (SUM (Amount)) AS Amount FROM MovementItemContainer WHERE MovementItemContainer.OperDate BETWEEN inStartDate AND inEndDate AND MovementItemContainer.DescId = zc_MIContainer_Summ() GROUP BY MovementItemContainer.ContainerId, MovementItemContainer.MovementItemId) AS MIContainer
                 JOIN MovementItem ON MovementItem.Id = MIContainer.MovementItemId
                 JOIN Movement ON Movement.Id = MovementItem.MovementId
                 JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
                 JOIN MovementItemDesc ON MovementItemDesc.Id = MovementItem.DescId
            -- WHERE 1=0
           ) AS _tmpSumm ON _tmpSumm.ContainerId = ContainerObjectCost.ContainerId
            -- это Количество и Сумма - ост, приход, расход
            LEFT JOIN
           (SELECT COALESCE (Container_Summ.Id, tmpContainer.ContainerId) AS ContainerId
                 , CAST (SUM (tmpContainer.StartCount) AS  TFloat) AS StartCount
                 , CAST (SUM (tmpContainer.StartSumm) AS  TFloat) AS StartSumm
                 , CAST (SUM (tmpContainer.IncomeCount) AS  TFloat) AS IncomeCount
                 , CAST (SUM (tmpContainer.IncomeSumm) AS  TFloat) AS IncomeSumm
                 , CAST (SUM (tmpContainer.OutCount) AS  TFloat) AS OutCount
                 , CAST (SUM (tmpContainer.OutSumm) AS  TFloat) AS OutSumm
            FROM
                (SELECT Container.Id AS ContainerId
                      , Container.DescId
                      , CASE WHEN Container.DescId = zc_Container_Count() THEN Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) ELSE 0 END AS StartCount
                      , CASE WHEN Container.DescId = zc_Container_Summ()  THEN Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) ELSE 0 END AS StartSumm
                      , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.Amount > 0 THEN  MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS IncomeCount
                      , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.Amount > 0 THEN  MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS IncomeSumm
                      , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.Amount < 0 THEN -MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS OutCount
                      , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.Amount < 0 THEN -MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS OutSumm
                 FROM Container
                      LEFT JOIN MovementItemContainer AS MIContainer
                                                      ON MIContainer.Containerid = Container.Id
                                                     AND MIContainer.OperDate >= inStartDate
                 -- WHERE Container.DescId = IN (zc_Container_Summ(), zc_Container_Count())
                 GROUP BY Container.Id
                        , Container.DescId
                        , Container.Amount
                 HAVING (Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0)
                     OR (COALESCE (SUM (CASE WHEN MIContainer.Amount > 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) <> 0) -- AmountDebet <> 0
                     OR (COALESCE (SUM (CASE WHEN MIContainer.Amount < 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN -MIContainer.Amount ELSE 0 END), 0) <> 0) -- AmountKredit <> 0
                ) AS tmpContainer
                LEFT JOIN Container AS Container_Summ
                                    ON Container_Summ.ParentId = tmpContainer.ContainerId
                                   AND Container_Summ.DescId = zc_Container_Summ()
                                   AND tmpContainer.DescId = zc_Container_Count()
            GROUP BY COALESCE (Container_Summ.Id, tmpContainer.ContainerId)
           ) AS tmpOperationSumm ON tmpOperationSumm.ContainerId = ContainerObjectCost.ContainerId

--       WHERE HistoryCost.Price <> 0
       WHERE HistoryCost.StartSumm <> 0
          OR tmpOperationSumm.StartSumm <> 0

          OR HistoryCost.CalcSumm <> 0
          OR HistoryCost.IncomeSumm <> 0
          OR tmpOperationSumm.IncomeSumm <> 0

          OR HistoryCost.OutSumm <> 0
          OR tmpOperationSumm.OutSumm <> 0

          OR HistoryCost.Price <> 0
          OR _tmpSumm.MovementId <> 0
       ;

  
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_HistoryCost (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.08.13                                        *
 22.07.13                                        *
*/

-- тест
-- SELECT * FROM gpReport_HistoryCost (inStartDate:= '01.01.2013', inEndDate:= '31.01.2013', inSession:= '2') -- WHERE ObjectCostId IN (13928)
-- SELECT * FROM gpReport_HistoryCost (inStartDate:= '01.12.2017', inEndDate:= '01.12.2017', inSession:= '2') -- WHERE (MovementId <> 0 OR  IncomeSumm_calc <> 0 OR OutSumm_calc <> 0) and  GoodsCode = 4033
