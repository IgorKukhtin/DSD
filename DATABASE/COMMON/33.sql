-- Проверка что все контейнеры - есть HistoryCost

-- select * from _tmpContainerList_partion_2024_07  where ContainerId_count = 9162190
-- select * from _tmpContainerList_2024_07  where ContainerId_count in (9154730)
-- select * from MovementItemContainer where MovementItemContainer.ContainerId = 8651068 and MovementItemContainer.OperDate between '01.12.2024' and '31.12.2024'
-- insert into historycost_2024_12 select * from historycost where StartDate = '01.12.2024'
-- select * from historycost where StartDate = '01.12.2024' and ContainerId = 177282
-- SELECT * FROM HistoryCost WHERE '01.03.2025' = StartDate and ContainerId in (SELECT Id FROM Container WHERE ParentId in (4120409))

-- !!!Project!!!
/*
-- select * from MovementItemContainer where MovementItemContainer.ContainerId = 309211 and MovementItemContainer.OperDate between '01.03.2025' and '31.01.2025'
-- select * from MovementItemContainer where MovementItemId = 313557437 and ContainerId in (SELECT Id FROM Container WHERE ParentId in (309211, 4120409))
select * 
from Container 
left join ContainerLinkObject on ContainerId = Container.Id
left join ContainerLinkObjectDesc on ContainerLinkObjectDesc.Id  = ContainerLinkObject.DescId
left join Object on Object.Id = ContainerLinkObject.ObjectId
left join Object as Object_Account on Object_Account.Id = Container.ObjectId
left join ObjectDesc on ObjectDesc.Id = Object.DescId
-- left join ContainerDesc on ContainerDesc.Id = Container.DescId
where Container.Id = 309211
309211


*/

with -- Список zc_Container_Count + MIContainer
     a as (select distinct Container.Id , Container.ObjectId as GoodsId
           from Container 
                join ContainerLinkObject on ContainerLinkObject.ContainerId = Container.Id
                                        and ContainerLinkObject.Descid = zc_ContainerLinkObject_Unit()
                                        and ContainerLinkObject.ObjectId = zc_Unit_RK()
                join MovementItemContainer on MovementItemContainer.ContainerId = Container.Id
                                          and MovementItemContainer.OperDate between '01.03.2025' and '31.03.2025'
                                          and MovementItemContainer.Amount <> 0
                                          and MovementItemContainer.MovementDescId <> zc_Movement_Inventory()
                LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Account
                                              ON ContainerLinkObject_Account.ContainerId = Container.Id
                                             AND ContainerLinkObject_Account.DescId = zc_ContainerLinkObject_Account()
           
           where Container.DescId = 1
             -- без счета Транзит
             AND ContainerLinkObject_Account.ContainerId IS NULL
           )
  -- нашли цену - HistoryCost
, tmp_find_all AS (select a.GoodsId
                    , ContainerLinkObject.ObjectId         AS InfoMoneyDetailId
                    , coalesce (clo_GoodsKind.ObjectId, 0) AS GoodsKindId
                    , max (HistoryCost.Price)              AS Price
                    , a.Id                                 AS ContainerId_goods
               from a
                    left join Container as Container_Summ on Container_Summ.ParentId = a.Id
                                                         AND Container_Summ.ObjectId <> zc_Enum_Account_20901()  -- Запасы + Оборотная тара
                                                         AND Container_Summ.ObjectId <> zc_Enum_Account_110101() -- Транзит + товар в пути
                                                         AND Container_Summ.ObjectId <> zc_Enum_Account_110102()
                                                         AND Container_Summ.ObjectId <> zc_Enum_Account_110111()
                                                         AND Container_Summ.ObjectId <> zc_Enum_Account_110112()
                                                         AND Container_Summ.ObjectId <> zc_Enum_Account_110121()
                                                         AND Container_Summ.ObjectId <> zc_Enum_Account_110122()
                                                         AND Container_Summ.ObjectId <> zc_Enum_Account_110131()
                                                         AND Container_Summ.ObjectId <> zc_Enum_Account_110132()
                    left join ContainerLinkObject on ContainerLinkObject.ContainerId = Container_Summ.Id
                                                 and ContainerLinkObject.Descid = zc_ContainerLinkObject_InfoMoneyDetail() 
                    left join ContainerLinkObject as clo_GoodsKind
                                                  on clo_GoodsKind.ContainerId = Container_Summ.Id
                                                 and clo_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind() 
                    left join Object on Object.Id = ContainerLinkObject.ObjectId 
                    join HistoryCost on HistoryCost.StartDate = '01.03.2025' 
                                    and HistoryCost.ContainerId = Container_Summ.Id
                                    and HistoryCost.Price > 1
               group by a.GoodsId, ContainerLinkObject.ObjectId , coalesce (clo_GoodsKind.ObjectId, 0), a.Id
         
              )
  -- нашли цену - HistoryCost
, tmp_find AS (select DISTINCT
                      tmp_find_all.GoodsId
                    , tmp_find_all.GoodsKindId
                    , tmp_find_all.Price
               from tmp_find_all
              )

, res as (
-- 55386
-- select count(*)
 select Container_Summ.Id, Container_Summ.ParentId AS ContainerId_goods, Object.*, tmp_find.Price
      , a.GoodsId
      , coalesce (clo_GoodsKind_summ.ObjectId, 0) AS GoodsKindId
      , ContainerLinkObject.ObjectId              AS InfoMoneyDetailId 
 from a
       -- если хоть одна цена есть, то ОК
      left join tmp_find_all ON tmp_find_all.ContainerId_goods = a.Id

      left join ContainerLinkObject as clo_GoodsKind_count
                                    on clo_GoodsKind_count.ContainerId  = a.Id
                                   and clo_GoodsKind_count.Descid = zc_ContainerLinkObject_GoodsKind() 
      left join Container as Container_Summ on Container_Summ.ParentId = a.Id
                                           AND Container_Summ.ObjectId <> zc_Enum_Account_20901()  -- Запасы + Оборотная тара
                                           AND Container_Summ.ObjectId <> zc_Enum_Account_110101() -- Транзит + товар в пути
                                           AND Container_Summ.ObjectId <> zc_Enum_Account_110102()
                                           AND Container_Summ.ObjectId <> zc_Enum_Account_110111()
                                           AND Container_Summ.ObjectId <> zc_Enum_Account_110112()
                                           AND Container_Summ.ObjectId <> zc_Enum_Account_110121()
                                           AND Container_Summ.ObjectId <> zc_Enum_Account_110122()
                                           AND Container_Summ.ObjectId <> zc_Enum_Account_110131()
                                           AND Container_Summ.ObjectId <> zc_Enum_Account_110132()
                                           and Container_Summ.ObjectId <>  256303 -- "Ирна"

      left join ContainerLinkObject as clo_GoodsKind_summ
                                    on clo_GoodsKind_summ.ContainerId  = Container_Summ.Id
                                   and clo_GoodsKind_summ.Descid       = zc_ContainerLinkObject_GoodsKind() 

      join ContainerLinkObject as CLO_InfoMoney on CLO_InfoMoney.ContainerId = Container_Summ.Id
                                               and CLO_InfoMoney.Descid = zc_ContainerLinkObject_InfoMoney() 
                                               and CLO_InfoMoney.ObjectId <> 8929 -- Ирна"

      left join ContainerLinkObject on ContainerLinkObject.ContainerId = Container_Summ.Id
                                   and ContainerLinkObject.Descid      = zc_ContainerLinkObject_InfoMoneyDetail() 
      left join Object on Object.Id = ContainerLinkObject.ObjectId 


      -- если не нашли цену
      left join HistoryCost on '01.03.2025' = StartDate and HistoryCost.ContainerId = Container_Summ.Id

      -- если нашли цену по ключу
      join tmp_find on tmp_find.GoodsId           = a.GoodsId
                   and tmp_find.GoodsKindId       = coalesce (clo_GoodsKind_count.ObjectId, 0)
                 --and tmp_find.InfoMoneyDetailId = ContainerLinkObject.ObjectId

where HistoryCost.ContainerId IS NULL
-- and ContainerLinkObject.ObjectId = 8906
  AND COALESCE (clo_GoodsKind_count.ObjectId, 0) = COALESCE (clo_GoodsKind_summ.ObjectId, 0)
  -- если вообще не нашли цену для ContainerId_goods
  AND tmp_find_all.ContainerId_goods IS NULL

 limit 200
)
 select * from res order by ContainerId_goods
-- select count(*)  from res 
-- 33287
-- 33288
-- select count(*) from tmp_find




/*
select Container.Id AS ContainerId
                 , CASE WHEN _tmpMaster.isInfoMoney_80401 = TRUE
                             THEN CASE WHEN (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) <> 0
                                            THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount)
                                       ELSE  0
                                  END
                        WHEN (((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) > 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) > 0)
                           OR ((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) < 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) < 0))
                             THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount)
                        ELSE 0
                   END AS Price
from _tmpHistoryCost_PartionCell_2024_07 as _tmpMaster

                 JOIN Container ON Container.ObjectId = _tmpMaster.AccountId
                               AND Container.DescId   = zc_Container_Summ()
-- and Container.ObjectId <> 8929
                               -- только этот список
                               AND Container.ParentId IN (SELECT DISTINCT tmpContainerList_partion.ContainerId_count FROM _tmpContainerList_partion_2024_07  tmpContainerList_partion
-- select * from _tmpContainerList_partion_2024_07  where ContainerId_count = 9491843
-- select * from _tmpContainerList_2024_07  where ContainerId_count = 9491843
                                                         UNION
                                                          SELECT DISTINCT _tmpContainerSumm_Goods_insert.ContainerId_Goods FROM _tmpContainerSumm_Goods_insert_2024_07 as _tmpContainerSumm_Goods_insert
                                                         )

                 INNER JOIN ContainerLinkObject AS CLO_Goods
                                                ON CLO_Goods.ContainerId = Container.Id
                                               AND CLO_Goods.DescId      = zc_ContainerLinkObject_Goods()
                                               AND CLO_Goods.ObjectId    = _tmpMaster.GoodsId
                 INNER JOIN ContainerLinkObject AS CLO_Unit
                                                ON CLO_Unit.ContainerId = Container.Id
                                               AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                               -- !!! Розподільчий комплекс
                                               AND CLO_Unit.ObjectId    = _tmpMaster.UnitId

                 LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                               ON CLO_GoodsKind.ContainerId = Container.Id
                                              AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
                 LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                               ON CLO_InfoMoney.ContainerId = Container.Id
                                              AND CLO_InfoMoney.DescId      = zc_ContainerLinkObject_InfoMoney()
                 LEFT JOIN ContainerLinkObject AS CLO_InfoMoneyDetail
                                               ON CLO_InfoMoneyDetail.ContainerId = Container.Id
                                              AND CLO_InfoMoneyDetail.DescId      = zc_ContainerLinkObject_InfoMoneyDetail()

                 LEFT JOIN ContainerLinkObject AS CLO_JuridicalBasis
                                               ON CLO_JuridicalBasis.ContainerId = Container.Id
                                              AND CLO_JuridicalBasis.DescId      = zc_ContainerLinkObject_JuridicalBasis()

            WHERE _tmpMaster.GoodsKindId        = COALESCE (CLO_GoodsKind.ObjectId, 0)
              AND _tmpMaster.InfoMoneyId        = COALESCE (CLO_InfoMoney.ObjectId, 0)
              AND _tmpMaster.InfoMoneyId_Detail = COALESCE (CLO_InfoMoneyDetail.ObjectId, 0)
          --    AND _tmpMaster.JuridicalId_basis  = COALESCE (CLO_JuridicalBasis.ObjectId, 0)
-- and Container.Id = 9492593 

where _tmpMaster.GoodsId = 7917624
 and _tmpMaster.GoodsKindId = 8352
 and _tmpMaster.InfoMoneyId_Detail = 8906
*/


/*

select * 
from Container 
left join ContainerLinkObject on ContainerId = Container.Id
left join ContainerLinkObjectDesc on ContainerLinkObjectDesc.Id  = ContainerLinkObject.DescId
left join Object on Object.Id = ContainerLinkObject.ObjectId
left join Object as Object_Account on Object_Account.Id = Container.ObjectId
left join ObjectDesc on ObjectDesc.Id = Object.DescId
-- left join ContainerDesc on ContainerDesc.Id = Container.DescId
where Container.Id =   109381

select * from MovementItemContainer where ContainerId  = 109381 and OperDate between '01.03.2025' and  '31.03.2025'
select * from miContainer_2024_12_1 where ContainerId  = 109381 and OperDate between '01.03.2025' and  '31.03.2025'

select 1, * from MovementItemContainer where MovementId  = 30303624 and ContainerId  = 109381 and OperDate between '01.03.2025' and  '31.03.2025'
union all
select 2, * from miContainer_2024_12_1 where MovementId  = 30303624 and MovementItemId = 314255034 and OperDate between '01.03.2025' and  '31.03.2025' and DescId = 1
order by 1


-- insert into miContainer_2024_12_1 select * from movementitemcontainer where OperDate between '01.01.2025' and '31.01.2025'
-- insert into historycost_2024_12_1 select * from historycost where StartDate = '01.01.2025'

select 2, * from miContainer_2024_12_1 where MovementId  = 30303624 and MovementItemId = 314255035 and OperDate between '01.03.2025' and  '31.03.2025' and DescId = 1


select * from MovementItem where Id  = 314181045


select 1, sum (amount) from MovementItemContainer where  ContainerId  = 9646958 and OperDate between '01.03.2025' and  '31.03.2025'and DescId = 1
union all
select 2, * from miContainer_2024_12_1 where ContainerId  = 9764863 and OperDate between '01.03.2025' and  '31.03.2025' and DescId = 1
order by 7, 4, 8, 6, 1


select * from Container where Id = 9646958
select -3.5464 - 1.16 , -5.5123

select 1, * from MovementItemContainer where MovementId  = 30144484 and DescId = 1  and ContainerId = 9646958
union all
select 3, * from miContainer_2024_12_1 where MovementId  = 30144484 and DescId = 1  and ContainerId = 9646958


 SELECT 1, * FROM HistoryCost WHERE '01.03.2025' = StartDate and ContainerId = 280649
union
SELECT 2, * FROM historycost_2024_12_1 WHERE '01.03.2025' = StartDate and ContainerId = 5275601
union
SELECT 3, * FROM historycost_2024_12_2 WHERE '01.03.2025' = StartDate and ContainerId = 5275601
order by 1

select *, xmin, CURRENT_TIMESTAMP from pg_replication_slots
;
*/