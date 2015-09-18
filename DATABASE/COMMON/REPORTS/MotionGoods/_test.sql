-- SELECT * from gpReport_MotionGoods (inStartDate:= '30.08.2015', inEndDate:= '31.08.2015', inAccountGroupId:= 0, inUnitGroupId:= 0, inLocationId:= 8451, inGoodsGroupId:= 1832,  inGoodsId:= 0, inUnitGroupId_by:= 0, inLocationId_by:= 0, inIsInfoMoney:= FALSE, inSession := zfCalc_UserAdmin());

    -- таблица -
--    CREATE TEMP TABLE _tmpListContainer (LocationId Integer, ContainerDescId Integer, ContainerId_count Integer, ContainerId_begin Integer, GoodsId Integer, AccountId Integer, AccountGroupId Integer, Amount TFloat) ON COMMIT DROP;
  --  CREATE TEMP TABLE _tmpContainer (ContainerDescId Integer, ContainerId_count Integer, ContainerId_begin Integer, LocationId Integer, GoodsId Integer, GoodsKindId Integer, PartionGoodsId Integer, AssetToId Integer, AccountId Integer, AccountGroupId Integer, Amount TFloat) ON COMMIT DROP;

    /*CREATE TEMP TABLE _tmpLocation (LocationId Integer, DescId Integer, ContainerDescId Integer) ON COMMIT DROP;
            INSERT INTO _tmpLocation (LocationId, DescId, ContainerDescId)
               SELECT Object.Id AS LocationId, zc_ContainerLinkObject_Unit() as DescId, tmpDesc.ContainerDescId
               FROM Object
                    LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId UNION SELECT zc_Container_Summ() AS ContainerDescId ) AS tmpDesc ON 1 = 1
                    -- LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId) AS tmpDesc ON 1 = 1 -- !!!временно без с/с, для скорости!!!
               WHERE Object.Id = 8451;*/

  EXPLAIN (ANALYZE, BUFFERS)
             
        WITH _tmpLocation as (SELECT Object.Id AS LocationId, zc_ContainerLinkObject_Unit() as DescId, tmpDesc.ContainerDescId
               FROM Object
                    LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId UNION SELECT zc_Container_Summ() AS ContainerDescId ) AS tmpDesc ON 1 = 1
                    -- LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId) AS tmpDesc ON 1 = 1 -- !!!временно без с/с, для скорости!!!
               WHERE Object.Id = 8451)
           , tmpGoods AS (SELECT lfSelect.GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (1832) AS lfSelect)
           , tmpAccount AS (SELECT View_Account.AccountGroupId, View_Account.AccountId
                            FROM (SELECT zc_Enum_AccountGroup_10000()  AS AccountGroupId 
                            UNION SELECT zc_Enum_AccountGroup_20000()  AS AccountGroupId 
                            UNION SELECT zc_Enum_AccountGroup_60000()  AS AccountGroupId 
                            UNION SELECT zc_Enum_AccountGroup_110000() AS AccountGroupId 
                                 ) AS tmp
                                 INNER JOIN Object_Account_View AS View_Account ON View_Account.AccountGroupId = tmp.AccountGroupId
                           )
        , _tmpListContainer as (
           SELECT _tmpLocation.LocationId
                , _tmpLocation.ContainerDescId
                , CASE WHEN _tmpLocation.ContainerDescId = zc_Container_Count()
                            THEN ContainerLinkObject.ContainerId
                       ELSE COALESCE (Container.ParentId, 0)
                  END AS ContainerId_count
                , ContainerLinkObject.ContainerId AS ContainerId_begin
                , tmpGoods.GoodsId
                , CASE WHEN _tmpLocation.ContainerDescId = zc_Container_Count()
                            THEN COALESCE (CLO_Account.ObjectId, 0)
                       ELSE COALESCE (Container.ObjectId, 0)
                  END AS AccountId
                , CASE WHEN CLO_Account.ObjectId > 0 AND _tmpLocation.ContainerDescId = zc_Container_Count()
                            THEN zc_Enum_AccountGroup_110000() -- Транзит
                       ELSE COALESCE (tmpAccount.AccountGroupId, 0)
                  END AS AccountGroupId
                , Container.Amount
           FROM _tmpLocation
                INNER JOIN ContainerLinkObject ON ContainerLinkObject.ObjectId = _tmpLocation.LocationId
                                              AND ContainerLinkObject.DescId = _tmpLocation.DescId
                LEFT JOIN ContainerLinkObject AS CLO_Goods ON CLO_Goods.ContainerId = ContainerLinkObject.ContainerId
                                                          AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()
                                                          AND _tmpLocation.ContainerDescId = zc_Container_Summ()
                LEFT JOIN Container ON Container.Id = ContainerLinkObject.ContainerId
                                   AND Container.DescId = _tmpLocation.ContainerDescId
                INNER JOIN tmpGoods ON tmpGoods.GoodsId = CASE WHEN _tmpLocation.ContainerDescId = zc_Container_Count() THEN Container.ObjectId ELSE CLO_Goods.ObjectId END
                LEFT JOIN tmpAccount ON tmpAccount.AccountId = Container.ObjectId
                LEFT JOIN ContainerLinkObject AS CLO_Account ON CLO_Account.ContainerId = Container.Id
                                                            AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                                                            AND _tmpLocation.ContainerDescId = zc_Container_Count()
           WHERE (_tmpLocation.ContainerDescId = zc_Container_Summ() AND tmpAccount.AccountId > 0)
              OR (_tmpLocation.ContainerDescId = zc_Container_Count() AND ((CLO_Account.ContainerId > 0 AND 0 = zc_Enum_AccountGroup_110000()) -- Транзит
                                                                        OR (CLO_Account.ContainerId IS NULL AND 0 <> zc_Enum_AccountGroup_110000()) -- Транзит
                                                                         ))
          )

--  select * from _tmpListContainer

    -- !!!!!!!!!!!!!!!!!!!!!!!
    -- ANALYZE _tmpListContainer;

    -- пытаемся найти <Счет> для zc_Container_Count
    /*UPDATE _tmpListContainer SET AccountId = _tmpListContainer_summ.AccountId
                               , AccountGroupId = _tmpListContainer_summ.AccountGroupId
    FROM _tmpListContainer AS _tmpListContainer_summ
         INNER JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() -- Инвестиции
         INNER JOIN ContainerLinkObject AS CLO_InfoMoneyDetail ON CLO_InfoMoneyDetail.ContainerId = _tmpListContainer_summ.ContainerId_begin
                                                              AND CLO_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
                                                              AND CLO_InfoMoneyDetail.ObjectId = View_InfoMoney.InfoMoneyId
         
    WHERE _tmpListContainer.ContainerId_count = _tmpListContainer_summ.ContainerId_count
      AND _tmpListContainer.ContainerDescId = zc_Container_Count()
      AND _tmpListContainer_summ.ContainerDescId = zc_Container_Summ()
      AND _tmpListContainer.AccountId = 0
      AND _tmpListContainer_summ.AccountGroupId = zc_Enum_AccountGroup_10000(); -- Необоротные активы

    -- пытаемся найти <Счет> для zc_Container_Count
    UPDATE _tmpListContainer SET AccountId = _tmpListContainer_summ.AccountId
                               , AccountGroupId = _tmpListContainer_summ.AccountGroupId
    FROM _tmpListContainer AS _tmpListContainer_summ
    WHERE _tmpListContainer.ContainerId_count = _tmpListContainer_summ.ContainerId_count
      AND _tmpListContainer.ContainerDescId = zc_Container_Count()
      AND _tmpListContainer_summ.ContainerDescId = zc_Container_Summ()
      AND _tmpListContainer.AccountId = 0
      AND _tmpListContainer_summ.AccountGroupId <> zc_Enum_AccountGroup_110000() -- Транзит

   ;*/

    -- все ContainerId
     , _tmpContainer as (
       SELECT _tmpListContainer.ContainerDescId
            , _tmpListContainer.ContainerId_count
            , _tmpListContainer.ContainerId_begin
            , _tmpListContainer.LocationId
            , _tmpListContainer.GoodsId
            , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
            , COALESCE (CLO_PartionGoods.ObjectId, 0) AS PartionGoodsId
            , COALESCE (CLO_AssetTo.ObjectId, 0) AS AssetToId
            , _tmpListContainer.AccountId
            , _tmpListContainer.AccountGroupId
            , _tmpListContainer.Amount
       FROM _tmpListContainer
            LEFT JOIN ContainerLinkObject AS CLO_GoodsKind ON CLO_GoodsKind.ContainerId = _tmpListContainer.ContainerId_begin
                                                          AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
            LEFT JOIN ContainerLinkObject AS CLO_PartionGoods ON CLO_PartionGoods.ContainerId = _tmpListContainer.ContainerId_begin
                                                             AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
            LEFT JOIN ContainerLinkObject AS CLO_AssetTo ON CLO_AssetTo.ContainerId = _tmpListContainer.ContainerId_begin
                                                        AND CLO_AssetTo.DescId = zc_ContainerLinkObject_AssetTo()
       )

    -- !!!!!!!!!!!!!!!!!!!!!!!
    -- ANALYZE _tmpContainer;




    -- Результат
          , tmpMIContainer AS (SELECT _tmpContainer.ContainerDescId
                                       , CASE WHEN false = TRUE THEN _tmpContainer.ContainerId_count ELSE 0 END AS ContainerId_count
                                       , CASE WHEN false = TRUE THEN _tmpContainer.ContainerId_begin ELSE 0 END AS ContainerId_begin
                                       , _tmpContainer.LocationId
                                       , _tmpContainer.GoodsId
                                       , _tmpContainer.GoodsKindId
                                       , _tmpContainer.PartionGoodsId
                                       , _tmpContainer.AssetToId
                                       , _tmpContainer.AccountId
                                       , _tmpContainer.AccountGroupId

                                       , CASE WHEN MIContainer.MovementDescId IN (zc_Movement_SendOnPrice(), zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                               AND false = FALSE
                                                   THEN MIContainer.ObjectExtId_Analyzer -- MIContainer.AnalyzerId
                                              ELSE 0
                                         END AS LocationId_by
                                       -- , 0 AS LocationId_by


                                         -- ***COUNT***
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                    AND MIContainer.MovementDescId = zc_Movement_Income()
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountIncome
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnOut()
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountReturnOut

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                    AND MIContainer.MovementDescId = zc_Movement_Send()
                                                    AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSendIn
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                    AND MIContainer.MovementDescId = zc_Movement_Send()
                                                    AND MIContainer.isActive = FALSE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSendOut

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                    AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossCount_20200() -- Кол-во, списание при реализации/перемещении по цене
                                                    AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSendOnPriceIn
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                    AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossCount_20200() -- Кол-во, списание при реализации/перемещении по цене
                                                    AND MIContainer.isActive = FALSE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSendOnPriceOut

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400() -- Кол-во, реализация, у покупателя
                                                    -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR false = TRUE) -- Транзит
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSale
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10500() -- Кол-во, реализация, Скидка за вес
                                                    -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR false = TRUE) -- Транзит
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSale_10500
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_40200() -- Кол-во, реализация, Разница в весе
                                                    -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR false = TRUE) -- Транзит
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSale_40208

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400() -- Кол-во, реализация, у покупателя
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSaleReal
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10500() -- Кол-во, реализация, Скидка за вес
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSaleReal_10500
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_40200() -- Кол-во, реализация, Разница в весе
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSaleReal_40208


                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_10800() -- Кол-во, возврат, от покупателя
                                                    -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR false = TRUE) -- Транзит
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountReturnIn
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_40200() -- Кол-во, возврат, Разница в весе
                                                    -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR false = TRUE) -- Транзит
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountReturnIn_40208

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_10800() -- Кол-во, возврат, от покупателя
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountReturnInReal
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_40200() -- Кол-во, возврат, Разница в весе
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountReturnInReal_40208


                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                    AND (MIContainer.MovementDescId = zc_Movement_Loss()
                                                         OR MIContainer.AnalyzerId = zc_Enum_AnalyzerId_LossCount_20200() -- Кол-во, списание при реализации/перемещении по цене
                                                        )
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountLoss
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                    AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountInventory
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                    AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                    AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountProductionIn
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                    AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                    AND MIContainer.isActive = FALSE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountProductionOut

                                         -- ***SUMM***
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId = zc_Movement_Income()
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummIncome
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnOut()
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummReturnOut

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId = zc_Movement_Send()
                                                   AND MIContainer.isActive = TRUE
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSendIn
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId = zc_Movement_Send()
                                                   AND MIContainer.isActive = FALSE
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSendOut

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                   AND MovementBoolean_HistoryCost.ValueData = TRUE
                                                   AND _tmpContainer.AccountGroupId = zc_Enum_AccountGroup_60000() -- Прибыль будущих периодов
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossSumm_20200() -- Сумма с/с, списание при реализации/перемещении по цене
                                                       THEN MIContainer.Amount
                                                  WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                   AND MIContainer.isActive = TRUE
                                                   AND _tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_60000() -- Прибыль будущих периодов
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossSumm_20200() -- Сумма с/с, списание при реализации/перемещении по цене
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSendOnPriceIn
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                   AND COALESCE (MovementBoolean_HistoryCost.ValueData, FALSE) = FALSE
                                                   AND _tmpContainer.AccountGroupId = zc_Enum_AccountGroup_60000() -- Прибыль будущих периодов
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossSumm_20200() -- Сумма с/с, списание при реализации/перемещении по цене
                                                       THEN -1 * MIContainer.Amount
                                                  WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                   AND MIContainer.isActive = FALSE
                                                   AND _tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_60000() -- Прибыль будущих периодов
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossSumm_20200() -- Сумма с/с, списание при реализации/перемещении по цене
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSendOnPriceOut

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10400() -- Сумма с/с, реализация, у покупателя
                                                   -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR false = TRUE)
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSale
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10500() -- Сумма с/с, реализация, Скидка за вес
                                                   -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR false = TRUE)
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSale_10500
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_40200() -- Сумма с/с, реализация, Разница в весе
                                                   -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR false = TRUE)
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSale_40208

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10400() -- Сумма с/с, реализация, у покупателя
                                                   AND MIContainer.ContainerId_Analyzer <> 0
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSaleReal
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10500() -- Сумма с/с, реализация, Скидка за вес
                                                   AND MIContainer.ContainerId_Analyzer <> 0
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSaleReal_10500
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_40200() -- Сумма с/с, реализация, Разница в весе
                                                   AND MIContainer.ContainerId_Analyzer <> 0
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSaleReal_40208


                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10800() -- Сумма с/с, возврат, от покупателя
                                                   -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR false = TRUE)
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummReturnIn
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_40200() -- Сумма с/с, возврат, Разница в весе
                                                   -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR false = TRUE)
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummReturnIn_40208

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10800() -- Сумма с/с, возврат, от покупателя
                                                   -- AND MIContainer.ContainerId_Analyzer <> 0
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummReturnInReal
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_40200() -- Сумма с/с, возврат, Разница в весе
                                                   AND MIContainer.ContainerId_Analyzer <> 0
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummReturnInReal_40208


                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND (MIContainer.MovementDescId = zc_Movement_Loss()
                                                        OR MIContainer.AnalyzerId = zc_Enum_AnalyzerId_LossSumm_20200() -- Сумма с/с, списание при реализации/перемещении по цене
                                                       )
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummLoss

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AccountGroup_60000() -- Прибыль будущих периодов
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummInventory

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AccountGroup_60000() -- Прибыль будущих периодов
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummInventory_RePrice

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                   AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                  ELSE 0
                                              END) AS SummProductionIn
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                   AND MIContainer.isActive = FALSE
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                              END) AS SummProductionOut

                                         -- ***REMAINS***
                                       , -1 * SUM (MIContainer.Amount) AS RemainsStart
                                       , 0                             AS RemainsEnd

                                  FROM _tmpContainer
                                       INNER JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = _tmpContainer.ContainerId_begin
                                                                                      AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                       LEFT JOIN MovementBoolean AS MovementBoolean_HistoryCost
                                                                 ON MovementBoolean_HistoryCost.MovementId = MIContainer.MovementId
                                                                AND MovementBoolean_HistoryCost.DescId = zc_MovementBoolean_HistoryCost()
                                  GROUP BY _tmpContainer.ContainerDescId
                                         , CASE WHEN false = TRUE THEN _tmpContainer.ContainerId_count ELSE 0 END
                                         , CASE WHEN false = TRUE THEN _tmpContainer.ContainerId_begin ELSE 0 END
                                         , _tmpContainer.LocationId
                                         , _tmpContainer.GoodsId
                                         , _tmpContainer.GoodsKindId
                                         , _tmpContainer.PartionGoodsId
                                         , _tmpContainer.AssetToId
                                         , _tmpContainer.AccountId
                                         , _tmpContainer.AccountGroupId
                                         , CASE WHEN MIContainer.MovementDescId IN (zc_Movement_SendOnPrice(), zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                 AND false = FALSE
                                                     THEN MIContainer.ObjectExtId_Analyzer -- MIContainer.AnalyzerId
                                                ELSE 0
                                           END
                                  HAVING -- ***COUNT***
                                         SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                    AND MIContainer.MovementDescId = zc_Movement_Income()
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountIncome
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnOut()
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountReturnOut

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                    AND MIContainer.MovementDescId = zc_Movement_Send()
                                                    AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountSendIn
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                    AND MIContainer.MovementDescId = zc_Movement_Send()
                                                    AND MIContainer.isActive = FALSE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountSendOut

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                    AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossCount_20200() -- Кол-во, списание при реализации/перемещении по цене
                                                    AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountSendOnPriceIn
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                    AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossCount_20200() -- Кол-во, списание при реализации/перемещении по цене
                                                    AND MIContainer.isActive = FALSE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountSendOnPriceOut

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400() -- Кол-во, реализация, у покупателя
                                                    -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR false = TRUE) -- Транзит
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountSale
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10500() -- Кол-во, реализация, Скидка за вес
                                                    -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR false = TRUE) -- Транзит
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountSale_10500
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_40200() -- Кол-во, реализация, Разница в весе
                                                    -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR false = TRUE) -- Транзит
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountSale_40208

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400() -- Кол-во, реализация, у покупателя
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountSaleReal
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10500() -- Кол-во, реализация, Скидка за вес
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountSaleReal_10500
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_40200() -- Кол-во, реализация, Разница в весе
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountSaleReal_40208


                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_10800() -- Кол-во, возврат, от покупателя
                                                    -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR false = TRUE) -- Транзит
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountReturnIn
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_40200() -- Кол-во, возврат, Разница в весе
                                                    -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR false = TRUE) -- Транзит
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountReturnIn_40208

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_10800() -- Кол-во, возврат, от покупателя
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountReturnInReal
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_40200() -- Кол-во, возврат, Разница в весе
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountReturnInReal_40208


                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                    AND (MIContainer.MovementDescId = zc_Movement_Loss()
                                                         OR MIContainer.AnalyzerId = zc_Enum_AnalyzerId_LossCount_20200() -- Кол-во, списание при реализации/перемещении по цене
                                                        )
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountLoss
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                    AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountInventory
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                    AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                    AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountProductionIn
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                    AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                    AND MIContainer.isActive = FALSE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountProductionOut

                                         -- ***SUMM***
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId = zc_Movement_Income()
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummIncome
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnOut()
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummReturnOut

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId = zc_Movement_Send()
                                                   AND MIContainer.isActive = TRUE
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummSendIn
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId = zc_Movement_Send()
                                                   AND MIContainer.isActive = FALSE
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummSendOut

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                   AND MovementBoolean_HistoryCost.ValueData = TRUE
                                                   AND _tmpContainer.AccountGroupId = zc_Enum_AccountGroup_60000()  --
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossSumm_20200() -- Сумма с/с, списание при реализации/перемещении по цене
                                                       THEN MIContainer.Amount
                                                  WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                   AND MIContainer.isActive = TRUE
                                                   AND _tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_60000()  --
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossSumm_20200() -- Сумма с/с, списание при реализации/перемещении по цене
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummSendOnPriceIn
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                   AND COALESCE (MovementBoolean_HistoryCost.ValueData, FALSE) = FALSE
                                                   AND _tmpContainer.AccountGroupId = zc_Enum_AccountGroup_60000()  --
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossSumm_20200() -- Сумма с/с, списание при реализации/перемещении по цене
                                                       THEN -1 * MIContainer.Amount
                                                  WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                   AND MIContainer.isActive = FALSE
                                                   AND _tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_60000()  --
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossSumm_20200() -- Сумма с/с, списание при реализации/перемещении по цене
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummSendOnPriceOut

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10400() -- Сумма с/с, реализация, у покупателя
                                                   -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR false = TRUE)
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummSale
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10500() -- Сумма с/с, реализация, Скидка за вес
                                                   -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR false = TRUE)
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummSale_10500
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_40200() -- Сумма с/с, реализация, Разница в весе
                                                   -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR false = TRUE)
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummSale_40208

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10400() -- Сумма с/с, реализация, у покупателя
                                                   AND MIContainer.ContainerId_Analyzer <> 0
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummSaleReal
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10500() -- Сумма с/с, реализация, Скидка за вес
                                                   AND MIContainer.ContainerId_Analyzer <> 0
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummSaleReal_10500
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_40200() -- Сумма с/с, реализация, Разница в весе
                                                   AND MIContainer.ContainerId_Analyzer <> 0
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummSaleReal_40208


                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10800() -- Сумма с/с, возврат, от покупателя
                                                   -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR false = TRUE)
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummReturnIn
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_40200() -- Сумма с/с, возврат, Разница в весе
                                                   -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR false = TRUE)
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummReturnIn_40208

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10800() -- Сумма с/с, возврат, от покупателя
                                                   -- AND MIContainer.ContainerId_Analyzer <> 0
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummReturnInReal
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_40200() -- Сумма с/с, возврат, Разница в весе
                                                   AND MIContainer.ContainerId_Analyzer <> 0
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummReturnInReal_40208


                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND (MIContainer.MovementDescId = zc_Movement_Loss()
                                                        OR MIContainer.AnalyzerId = zc_Enum_AnalyzerId_LossSumm_20200() -- Сумма с/с, списание при реализации/перемещении по цене
                                                       )
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummLoss

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AccountGroup_60000() -- Прибыль будущих периодов
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummInventory

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AccountGroup_60000() -- Прибыль будущих периодов
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummInventory_RePrice

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                   AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                  ELSE 0
                                              END) <> 0 -- AS SummProductionIn
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN '30.08.2015' AND '31.08.2015'
                                                   AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                   AND MIContainer.isActive = FALSE
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                              END) <> 0 -- AS SummProductionOut
                                         -- ***REMAINS***
                                      OR SUM (MIContainer.Amount) <> 0 -- AS RemainsStart

                                 UNION ALL
                                  SELECT _tmpContainer.ContainerDescId
                                       , CASE WHEN false = TRUE THEN _tmpContainer.ContainerId_count ELSE 0 END AS ContainerId_count
                                       , CASE WHEN false = TRUE THEN _tmpContainer.ContainerId_begin ELSE 0 END AS ContainerId_begin
                                       , _tmpContainer.LocationId
                                       , _tmpContainer.GoodsId
                                       , _tmpContainer.GoodsKindId
                                       , _tmpContainer.PartionGoodsId
                                       , _tmpContainer.AssetToId
                                       , _tmpContainer.AccountId
                                       , _tmpContainer.AccountGroupId

                                       , 0 AS LocationId_by

                                         -- ***COUNT***
                                       , 0 AS CountIncome
                                       , 0 AS CountReturnOut

                                       , 0 AS CountSendIn
                                       , 0 AS CountSendOut

                                       , 0 AS CountSendOnPriceIn
                                       , 0 AS CountSendOnPriceOut

                                       , 0 AS CountSale
                                       , 0 AS CountSale_10500
                                       , 0 AS CountSale_40208

                                       , 0 AS CountSaleReal
                                       , 0 AS CountSaleReal_10500
                                       , 0 AS CountSaleReal_40208

                                       , 0 AS CountReturnIn
                                       , 0 AS CountReturnIn_40208

                                       , 0 AS CountReturnInReal
                                       , 0 AS CountReturnInReal_40208

                                       , 0 AS CountLoss
                                       , 0 AS CountInventory
                                       , 0 AS CountProductionIn
                                       , 0 AS CountProductionOut

                                         -- ***SUMM***
                                       , 0 AS SummIncome
                                       , 0 AS SummReturnOut

                                       , 0 AS SummSendIn
                                       , 0 AS SummSendOut

                                       , 0 AS SummSendOnPriceIn
                                       , 0 AS SummSendOnPriceOut

                                       , 0 AS SummSale
                                       , 0 AS SummSale_10500
                                       , 0 AS SummSale_40208

                                       , 0 AS SummSaleReal
                                       , 0 AS SummSaleReal_10500
                                       , 0 AS SummSaleReal_40208

                                       , 0 AS SummReturnIn
                                       , 0 AS SummReturnIn_40208

                                       , 0 AS SummReturnInReal
                                       , 0 AS SummReturnInReal_40208

                                       , 0 AS SummLoss
                                       , 0 AS SummInventory
                                       , 0 AS SummInventory_RePrice

                                       , 0 AS SummProductionIn
                                       , 0 AS SummProductionOut
                                         -- ***REMAINS***
                                       , _tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS RemainsStart
                                       , _tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS RemainsEnd
                                  FROM _tmpContainer AS _tmpContainer
                                       LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = _tmpContainer.ContainerId_begin
                                                                                     AND MIContainer.OperDate > '31.08.2015'
                                  GROUP BY _tmpContainer.ContainerDescId
                                         , _tmpContainer.ContainerId_count
                                         , _tmpContainer.ContainerId_begin
                                         , _tmpContainer.LocationId
                                         , _tmpContainer.GoodsId
                                         , _tmpContainer.GoodsKindId
                                         , _tmpContainer.PartionGoodsId
                                         , _tmpContainer.AssetToId
                                         , _tmpContainer.AccountId
                                         , _tmpContainer.AccountGroupId
                                         , _tmpContainer.Amount
                                  HAVING _tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0

                                 )

         -- Результат
   SELECT (tmpMIContainer_all.AccountId)       AS AccountId
              , tmpMIContainer_all.ContainerId_count AS ContainerId_count
              , tmpMIContainer_all.ContainerId_begin AS ContainerId
              , tmpMIContainer_all.LocationId
              , tmpMIContainer_all.GoodsId
              , tmpMIContainer_all.GoodsKindId
              , tmpMIContainer_all.PartionGoodsId
              , tmpMIContainer_all.AssetToId

              , tmpMIContainer_all.LocationId_by

              , SUM (CASE WHEN tmpMIContainer_all.ContainerDescId = zc_Container_Count() THEN tmpMIContainer_all.RemainsStart ELSE 0 END) :: TFloat AS CountStart
              , SUM (CASE WHEN tmpMIContainer_all.ContainerDescId = zc_Container_Count() THEN tmpMIContainer_all.RemainsEnd   ELSE 0 END) :: TFloat AS CountEnd
              , SUM (CASE WHEN tmpMIContainer_all.ContainerDescId = zc_Container_Count() THEN tmpMIContainer_all.RemainsEnd - tmpMIContainer_all.CountInventory ELSE 0 END) :: TFloat AS CountEnd_calc

              , SUM (tmpMIContainer_all.CountIncome)             :: TFloat AS CountIncome
              , SUM (tmpMIContainer_all.CountReturnOut)          :: TFloat AS CountReturnOut

              , SUM (tmpMIContainer_all.CountSendIn)             :: TFloat AS CountSendIn
              , SUM (tmpMIContainer_all.CountSendOut)            :: TFloat AS CountSendOut

              , SUM (tmpMIContainer_all.CountSendOnPriceIn)      :: TFloat AS CountSendOnPriceIn
              , SUM (tmpMIContainer_all.CountSendOnPriceOut)     :: TFloat AS CountSendOnPriceOut

              , SUM (tmpMIContainer_all.CountSale)               :: TFloat AS CountSale
              , SUM (tmpMIContainer_all.CountSale_10500)         :: TFloat AS CountSale_10500
              , SUM (tmpMIContainer_all.CountSale_40208)         :: TFloat AS CountSale_40208
              , SUM (tmpMIContainer_all.CountSaleReal)           :: TFloat AS CountSaleReal
              , SUM (tmpMIContainer_all.CountSaleReal_10500)     :: TFloat AS CountSaleReal_10500
              , SUM (tmpMIContainer_all.CountSaleReal_40208)     :: TFloat AS CountSaleReal_40208

              , SUM (tmpMIContainer_all.CountReturnIn)           :: TFloat AS CountReturnIn
              , SUM (tmpMIContainer_all.CountReturnIn_40208)     :: TFloat AS CountReturnIn_40208
              , SUM (tmpMIContainer_all.CountReturnInReal)       :: TFloat AS CountReturnInReal
              , SUM (tmpMIContainer_all.CountReturnInReal_40208) :: TFloat AS CountReturnInReal_40208

              , SUM (tmpMIContainer_all.CountLoss)               :: TFloat AS CountLoss
              , SUM (tmpMIContainer_all.CountInventory)          :: TFloat AS CountInventory

              , SUM (tmpMIContainer_all.CountProductionIn)       :: TFloat AS CountProductionIn
              , SUM (tmpMIContainer_all.CountProductionOut)      :: TFloat AS CountProductionOut

              , SUM (CASE WHEN tmpMIContainer_all.ContainerDescId = zc_Container_Summ() THEN tmpMIContainer_all.RemainsStart ELSE 0 END) :: TFloat AS SummStart
              , SUM (CASE WHEN tmpMIContainer_all.ContainerDescId = zc_Container_Summ() THEN tmpMIContainer_all.RemainsEnd   ELSE 0 END) :: TFloat AS SummEnd
              , SUM (CASE WHEN tmpMIContainer_all.ContainerDescId = zc_Container_Summ() THEN tmpMIContainer_all.RemainsEnd - tmpMIContainer_all.SummInventory ELSE 0 END) :: TFloat AS SummEnd_calc

              , SUM (tmpMIContainer_all.SummIncome)              :: TFloat AS SummIncome
              , SUM (tmpMIContainer_all.SummReturnOut)           :: TFloat AS SummReturnOut
              , SUM (tmpMIContainer_all.SummSendIn)              :: TFloat AS SummSendIn
              , SUM (tmpMIContainer_all.SummSendOut)             :: TFloat AS SummSendOut
              , SUM (tmpMIContainer_all.SummSendOnPriceIn)       :: TFloat AS SummSendOnPriceIn
              , SUM (tmpMIContainer_all.SummSendOnPriceOut)      :: TFloat AS SummSendOnPriceOut
              , SUM (tmpMIContainer_all.SummSale)                :: TFloat AS SummSale
              , SUM (tmpMIContainer_all.SummSale_10500)          :: TFloat AS SummSale_10500
              , SUM (tmpMIContainer_all.SummSale_40208)          :: TFloat AS SummSale_40208
              , SUM (tmpMIContainer_all.SummSaleReal)            :: TFloat AS SummSaleReal
              , SUM (tmpMIContainer_all.SummSaleReal_10500)      :: TFloat AS SummSaleReal_10500
              , SUM (tmpMIContainer_all.SummSaleReal_40208)      :: TFloat AS SummSaleReal_40208
              , SUM (tmpMIContainer_all.SummReturnIn)            :: TFloat AS SummReturnIn
              , SUM (tmpMIContainer_all.SummReturnIn_40208)      :: TFloat AS SummReturnIn_40208
              , SUM (tmpMIContainer_all.SummReturnInReal)        :: TFloat AS SummReturnInReal
              , SUM (tmpMIContainer_all.SummReturnInReal_40208)  :: TFloat AS SummReturnInReal_40208
              , SUM (tmpMIContainer_all.SummLoss)                :: TFloat AS SummLoss
              , SUM (tmpMIContainer_all.SummInventory)           :: TFloat AS SummInventory
              , SUM (tmpMIContainer_all.SummInventory_RePrice)   :: TFloat AS SummInventory_RePrice
              , SUM (tmpMIContainer_all.SummProductionIn)        :: TFloat AS SummProductionIn
              , SUM (tmpMIContainer_all.SummProductionOut)       :: TFloat AS SummProductionOut

         FROM tmpMIContainer AS tmpMIContainer_all
         GROUP BY tmpMIContainer_all.AccountId 
                , tmpMIContainer_all.ContainerId_count
                , tmpMIContainer_all.ContainerId_begin
                , tmpMIContainer_all.LocationId
                , tmpMIContainer_all.GoodsId
                , tmpMIContainer_all.GoodsKindId
                , tmpMIContainer_all.PartionGoodsId
                , tmpMIContainer_all.AssetToId
                , tmpMIContainer_all.LocationId_by
      ;

