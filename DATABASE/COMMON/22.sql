-- как получается _tmpContainerList
WITH tmpContainerS_zavod AS (SELECT Container_Summ.*
                                          , CLO_Unit.ObjectId                    AS UnitId
                                          , CLO_Goods.ObjectId                   AS GoodsId
                                          , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
                                          , CLO_JuridicalBasis.ObjectId          AS JuridicalId_basis
                                          , CLO_InfoMoney.ObjectId               AS InfoMoneyId
                                          , CLO_InfoMoneyDetail.ObjectId         AS InfoMoneyId_Detail
                                      FROM Container AS Container_Summ
--                                           LEFT JOIN _tmpContainer_branch ON _tmpContainer_branch.ContainerId = Container_Summ.Id

                                           LEFT JOIN ContainerLinkObject AS CLO_Unit
                                                                         ON CLO_Unit.ContainerId = Container_Summ.Id
                                                                        AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                           LEFT JOIN ContainerLinkObject AS CLO_InfoMoney ON CLO_InfoMoney.ContainerId = Container_Summ.Id
                                                                                         AND CLO_InfoMoney.DescId      = zc_ContainerLinkObject_InfoMoney()
                                           LEFT JOIN ContainerLinkObject AS CLO_InfoMoneyDetail ON CLO_InfoMoneyDetail.ContainerId = Container_Summ.Id
                                                                                               AND CLO_InfoMoneyDetail.DescId      = zc_ContainerLinkObject_InfoMoneyDetail()
                                           LEFT JOIN ContainerLinkObject AS CLO_Goods ON CLO_Goods.ContainerId = Container_Summ.Id
                                                                                     AND CLO_Goods.DescId      = zc_ContainerLinkObject_Goods()
                                           LEFT JOIN ContainerLinkObject AS CLO_GoodsKind ON CLO_GoodsKind.ContainerId = Container_Summ.Id
                                                                                         AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
                                           LEFT JOIN ContainerLinkObject AS CLO_JuridicalBasis ON CLO_JuridicalBasis.ContainerId = Container_Summ.Id
                                                                                              AND CLO_JuridicalBasis.DescId      = zc_ContainerLinkObject_JuridicalBasis()

                                      WHERE Container_Summ.DescId = zc_Container_Summ()
                                        AND Container_Summ.ParentId > 0
                                        AND Container_Summ.ObjectId <> zc_Enum_Account_20901()  -- Запасы + Оборотная тара
                                        AND Container_Summ.ObjectId <> zc_Enum_Account_110101() -- Транзит + товар в пути
                                        AND Container_Summ.ObjectId <> zc_Enum_Account_110102()
                                        AND Container_Summ.ObjectId <> zc_Enum_Account_110111()
                                        AND Container_Summ.ObjectId <> zc_Enum_Account_110112()
                                        AND Container_Summ.ObjectId <> zc_Enum_Account_110121()
                                        AND Container_Summ.ObjectId <> zc_Enum_Account_110122()
                                        AND Container_Summ.ObjectId <> zc_Enum_Account_110131()
                                        AND Container_Summ.ObjectId <> zc_Enum_Account_110132()
and Container_Summ.ParentId = 9491843
                                     )
           , tmpContainerS_branch AS (SELECT Container_Summ.*
                                      FROM Container AS Container_Summ
                                           
                                      WHERE Container_Summ.DescId = zc_Container_Summ()
                                        AND Container_Summ.ParentId > 0
                                        AND Container_Summ.ObjectId <> zc_Enum_Account_20901()  -- Запасы + Оборотная тара
                                        AND Container_Summ.ObjectId <> zc_Enum_Account_110101() -- Транзит + товар в пути
                                        AND Container_Summ.ObjectId <> zc_Enum_Account_110102()
                                        AND Container_Summ.ObjectId <> zc_Enum_Account_110111()
                                        AND Container_Summ.ObjectId <> zc_Enum_Account_110112()
                                        AND Container_Summ.ObjectId <> zc_Enum_Account_110121()
                                        AND Container_Summ.ObjectId <> zc_Enum_Account_110122()
                                        AND Container_Summ.ObjectId <> zc_Enum_Account_110131()
                                        AND Container_Summ.ObjectId <> zc_Enum_Account_110132()
and 1=0
                                     )
, tmpContainer_Summ_union AS (SELECT tmpContainerS_zavod.GoodsId
                                   , tmpContainerS_zavod.UnitId
                                     -- 20101 - Продукция
                                   , MAX (CASE WHEN tmpContainerS_zavod.ObjectId    = 9086 THEN tmpContainerS_zavod.ObjectId    ELSE 0 END) AS ObjectId
                                     -- Готовая продукция
                                   , MAX (CASE WHEN tmpContainerS_zavod.InfoMoneyId = 8962 THEN tmpContainerS_zavod.InfoMoneyId ELSE 0 END) AS InfoMoneyId
                              FROM tmpContainerS_zavod
                              GROUP BY tmpContainerS_zavod.GoodsId
                                     , tmpContainerS_zavod.UnitId
                             )
            -- или Начальный ост или есть движение
          , tmpContainer_count_RK AS (SELECT Container_count.Id AS ContainerId
                                      FROM Container AS Container_count
                                           INNER JOIN ContainerLinkObject AS CLO_Unit
                                                                          ON CLO_Unit.ContainerId = Container_count.Id
                                                                         AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                                         AND CLO_Unit.ObjectId    = zc_Unit_RK()
                                           LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Account
                                                                         ON ContainerLinkObject_Account.ContainerId = Container_count.Id
                                                                        AND ContainerLinkObject_Account.DescId = zc_ContainerLinkObject_Account()
                                           LEFT JOIN MovementItemContainer AS MIContainer
                                                                           ON MIContainer.ContainerId = Container_count.Id
                                                                          AND MIContainer.OperDate >= '01.12.2024'
                                      WHERE Container_count.DescId = zc_Container_Count()
                                        AND ContainerLinkObject_Account.ContainerId IS NULL
and Container_count.Id = 9491843
                                      GROUP BY Container_count.Id, Container_count.Amount
                                      HAVING Container_count.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0
                                          OR 0 <> SUM (CASE WHEN MIContainer.OperDate BETWEEN '01.12.2024' AND '31.12.2024' AND MIContainer.Amount <> 0 THEN 1 ELSE 0 END)
                                     )
        -- Результат - Суммы, если есть Остаток или Движение
, a as (        SELECT Container_Summ.Id AS ContainerId, Container_Summ.ParentId AS ContainerId_count
             , CASE WHEN tmpContainer_Summ_union.ObjectId > 0 THEN tmpContainer_Summ_union.ObjectId ELSE Container_Summ.ObjectId END AS AccountId
             , TRUE AS isZavod
             , Container_Summ.UnitId
             , Container_Summ.GoodsId
             , Container_Summ.GoodsKindId
             , Container_Summ.JuridicalId_basis
             , CASE WHEN tmpContainer_Summ_union.InfoMoneyId > 0 THEN tmpContainer_Summ_union.InfoMoneyId ELSE Container_Summ.InfoMoneyId END AS InfoMoneyId
             , Container_Summ.InfoMoneyId_Detail
        FROM tmpContainerS_zavod AS Container_Summ
             LEFT JOIN tmpContainer_count_RK ON tmpContainer_count_RK.ContainerId = Container_Summ.ParentId
             --
             LEFT JOIN tmpContainer_Summ_union ON tmpContainer_Summ_union.GoodsId = Container_Summ.GoodsId
                                              AND tmpContainer_Summ_union.UnitId  = Container_Summ.UnitId
             LEFT JOIN MovementItemContainer AS MIContainer
                                             ON MIContainer.ContainerId = Container_Summ.Id
                                            AND MIContainer.OperDate >= '01.12.2024'
                                            AND MIContainer.AccountId <> zc_Enum_Account_110101() -- Транзит + товар в пути
                                            AND MIContainer.AccountId <> zc_Enum_Account_110102()
                                            AND MIContainer.AccountId <> zc_Enum_Account_110111()
                                            AND MIContainer.AccountId <> zc_Enum_Account_110112()
                                            AND MIContainer.AccountId <> zc_Enum_Account_110121()
                                            AND MIContainer.AccountId <> zc_Enum_Account_110122()
                                            AND MIContainer.AccountId <> zc_Enum_Account_110131()
                                            AND MIContainer.AccountId <> zc_Enum_Account_110132()
        WHERE Container_Summ.DescId = zc_Container_Summ()
          AND Container_Summ.ParentId > 0
          AND Container_Summ.ObjectId <> zc_Enum_Account_20901()  -- Запасы + Оборотная тара
          AND Container_Summ.ObjectId <> zc_Enum_Account_110101() -- Транзит + товар в пути
          AND Container_Summ.ObjectId <> zc_Enum_Account_110102()
          AND Container_Summ.ObjectId <> zc_Enum_Account_110111()
          AND Container_Summ.ObjectId <> zc_Enum_Account_110112()
          AND Container_Summ.ObjectId <> zc_Enum_Account_110121()
          AND Container_Summ.ObjectId <> zc_Enum_Account_110122()
          AND Container_Summ.ObjectId <> zc_Enum_Account_110131()
          AND Container_Summ.ObjectId <> zc_Enum_Account_110132()
        GROUP BY Container_Summ.Id, Container_Summ.ParentId, Container_Summ.Amount
               , CASE WHEN tmpContainer_Summ_union.ObjectId > 0 THEN tmpContainer_Summ_union.ObjectId ELSE Container_Summ.ObjectId END
               , Container_Summ.UnitId
               , Container_Summ.GoodsId
               , Container_Summ.GoodsKindId
               , Container_Summ.JuridicalId_basis
               , CASE WHEN tmpContainer_Summ_union.InfoMoneyId > 0 THEN tmpContainer_Summ_union.InfoMoneyId ELSE Container_Summ.InfoMoneyId END
               , Container_Summ.InfoMoneyId_Detail
        HAVING Container_Summ.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0
            -- или движение Container_Summ
            OR MAX (CASE WHEN MIContainer.OperDate BETWEEN '01.12.2024' AND '31.12.2024' THEN Container_Summ.Id ELSE 0 END) > 0
            -- или движение Container_count_RK
            OR MAX (CASE WHEN tmpContainer_count_RK.ContainerId > 0 THEN tmpContainer_count_RK.ContainerId ELSE 0 END) > 0
)
select * from a where ContainerId = 9492593