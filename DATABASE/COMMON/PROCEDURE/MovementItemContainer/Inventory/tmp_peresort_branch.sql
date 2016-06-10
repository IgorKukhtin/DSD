-- select * from MovementItemContainer where MovementItemId = (select min (MovementItemId) from MovementItemContainer where MovementId =3615883  and ContainerId = 297223) order by 1
-- delete from MovementItemContainer where Id>= 2747898647 and MovementItemId = (select min (MovementItemId) from MovementItemContainer where MovementId =3615883  and ContainerId = 297223)

-- update Container set Amount = Container.Amount + tmp.Amount from (
        WITH tmpContainerList AS (SELECT DISTINCT Container.*, ContainerLinkObject_InfoMoneyDetail.ObjectId AS InfoMoneyId_Detail
                                  FROM (SELECT * FROM Container WHERE Container.Id = 297223
                                       ) AS tmp
                                       JOIN Container ON Container.ParentId = tmp.ParentId
                                                     AND Container.DescId = zc_Container_Summ()
                   LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                                 ON ContainerLinkObject_InfoMoney.ContainerId = Container.Id
                                                AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                   LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoneyDetail
                                                 ON ContainerLinkObject_InfoMoneyDetail.ContainerId = Container.Id
                                                AND ContainerLinkObject_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()

                                  WHERE COALESCE (ContainerLinkObject_InfoMoney.ObjectId, 0)       <> zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                                    AND COALESCE (ContainerLinkObject_InfoMoneyDetail.ObjectId, 0) <> zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                                 )
               , tmpContainer AS (SELECT tmpContainerList.InfoMoneyId_Detail
                                       , tmpContainerList.Id       AS ContainerId
                                       , tmpContainerList.ObjectId AS AccountId
                                       , tmpContainerList.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS Amount
                                  FROM tmpContainerList
                                       LEFT JOIN MovementItemContainer AS MIContainer
                                                                       ON MIContainer.ContainerId = tmpContainerList.Id
                                                                      AND MIContainer.OperDate >= '01.05.2016'
                                  GROUP BY tmpContainerList.InfoMoneyId_Detail
                                         , tmpContainerList.Id
                                         , tmpContainerList.ObjectId
                                         , tmpContainerList.Amount
                                  HAVING tmpContainerList.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0
                                 )
              , tmpResult AS (SELECT zc_MIContainer_Summ() AS DescId
                                   , Movement.DescId AS MovementDescId
                                   , MovementItem.MovementId
                                   , MovementItem.Id AS MovementItemId
                                   , tmpContainer.ContainerId
                                   , tmpContainer.AccountId
                                   , NULL :: Integer AS AnalyzerId
                                   , MovementItem.ObjectId AS ObjectId_Analyzer
                                   , CLO_Unit.ObjectId AS WhereObjectId_Analyzer
                                   , NULL :: Integer AS ContainerId_Analyzer
                                   , CLO_GoodsKind.ObjectId AS ObjectIntId_Analyzer
                                   , NULL :: Integer AS ObjectExtId_Analyzer
                                   , NULL :: Integer AS ParentId
                                   , tmpContainer.Amount
                                   , Movement.OperDate
                                   , FALSE AS isActive
                                   , View_InfoMoney.*
                              FROM tmpContainer
                                   LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                                 ON CLO_GoodsKind.ContainerId = tmpContainer.ContainerId
                                                                AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                   LEFT JOIN ContainerLinkObject AS CLO_Unit
                                                                 ON CLO_Unit.ContainerId = tmpContainer.ContainerId
                                                                AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                   LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpContainer.InfoMoneyId_Detail
                                   LEFT JOIN MovementItem ON MovementItem.Id = (select min (MovementItemId) from MovementItemContainer where MovementId =3615883  and ContainerId = 297223)
                                   LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                             )
-- SELECT *  FROM tmpResult
 /*insert into MovementItemContainer (DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                    , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                     , ParentId, Amount, OperDate, isActive)*/
   SELECT DescId, MovementDescId, MovementId, MovementItemId, ContainerId
        , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
        , ParentId
        , -1 * tmpResult.Amount AS Amount
        , OperDate, isActive
   FROM tmpResult
   WHERE tmpResult.InfoMoneyId <> zc_Enum_InfoMoney_30101() -- "(30101) Доходы Продукция Готовая продукция"
  UNION ALL
   SELECT DescId, MovementDescId, MovementId, MovementItemId, ContainerId
        , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
        , ParentId
        , 1 * (SELECT SUM (Amount) FROM tmpResult WHERE tmpResult.InfoMoneyId <> zc_Enum_InfoMoney_30101()) AS  Amount
        , OperDate, isActive
   FROM tmpResult
   WHERE tmpResult.InfoMoneyId = zc_Enum_InfoMoney_30101() -- "(30101) Доходы Продукция Готовая продукция"

--  ) as tmp where tmp.ContainerId = Container.Id