-- Function: lpReport_MotionGoods()

DROP FUNCTION IF EXISTS lpReport_MotionGoodsCount_light (TDateTime, TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpReport_MotionGoodsCount_light (
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inLocationId         Integer,    --
    IN inUserId             Integer     -- пользователь
)
RETURNS TABLE (OperDate TDateTime
             , LocationId Integer
             , GoodsId Integer, GoodsKindId Integer
           
             , CountStart     TFloat
             , CountEnd       TFloat
             , CountEnd_calc  TFloat
             , Remains_Mov    TFloat

             , CountIncome    TFloat
             , CountReturnOut TFloat

             , CountSendIn  TFloat
             , CountSendOut TFloat

             , CountSendOnPriceIn        TFloat
             , CountSendOnPriceOut       TFloat
             , CountSendOnPriceOut_10900 TFloat

             , CountSendOnPrice_10500   TFloat
             , CountSendOnPrice_40200   TFloat

             , CountSale           TFloat
             , CountSale_10500     TFloat
             , CountSale_40208     TFloat
             , CountSaleReal       TFloat
             , CountSaleReal_10500 TFloat
             , CountSaleReal_40208 TFloat

             , CountReturnIn           TFloat
             , CountReturnIn_40208     TFloat
             , CountReturnInReal       TFloat
             , CountReturnInReal_40208 TFloat

             , CountLoss      TFloat
             , CountInventory TFloat

             , CountProductionIn  TFloat
             , CountProductionOut TFloat    
             
             , CostStart TFloat
             , CostEnd  TFloat
             , CostEnd_calc TFloat
             , CostRemains_Mov  TFloat

              )
AS
$BODY$
   DECLARE vbIsAssetTo Boolean;
   DECLARE vbIsCLO_Member Boolean;
BEGIN

   IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE ('_tmpLocation'))
   THEN
        DELETE FROM _tmpLocation;
   ELSE 
        CREATE TEMP TABLE _tmpLocation (LocationId Integer, DescId Integer, ContainerDescId Integer) ON COMMIT DROP;
   END IF;

   INSERT INTO _tmpLocation (LocationId, DescId, ContainerDescId)
      SELECT inLocationId AS LocationId -- Склад реализации  8459
           , zc_ContainerLinkObject_Unit()  AS DescId
           , zc_Container_Count()           AS ContainerDescId
      ;
 

  

    -- таблица -
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE ('_tmpListContainer'))
    THEN
         DELETE FROM _tmpListContainer;
    ELSE 
         CREATE TEMP TABLE _tmpListContainer (LocationId Integer, ContainerDescId Integer, ContainerId_count Integer, ContainerId_begin Integer, GoodsId Integer, AccountId Integer, AccountGroupId Integer, Amount TFloat) ON COMMIT DROP;
    END IF;

    -- таблица -
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE ('_tmpContainer'))
    THEN
         DELETE FROM _tmpContainer;
    ELSE 
         CREATE TEMP TABLE _tmpContainer (ContainerDescId Integer, ContainerId_count Integer, ContainerId_begin Integer, LocationId Integer, CarId Integer, GoodsId Integer, GoodsKindId Integer, PartionGoodsId Integer, AssetToId Integer, AccountId Integer, AccountGroupId Integer, Amount TFloat) ON COMMIT DROP;
    END IF;


    -- все товары из проводок
    INSERT INTO _tmpListContainer (LocationId, ContainerDescId, ContainerId_count, ContainerId_begin, GoodsId, AccountId, AccountGroupId, Amount)
       WITH tmpAccount AS (SELECT View_Account.AccountGroupId, View_Account.AccountId
                           FROM (SELECT zc_Enum_AccountGroup_10000()  AS AccountGroupId
                           UNION SELECT zc_Enum_AccountGroup_20000()  AS AccountGroupId
                           UNION SELECT zc_Enum_AccountGroup_60000()  AS AccountGroupId
                           UNION SELECT zc_Enum_AccountGroup_110000() AS AccountGroupId
                                ) AS tmp
                                INNER JOIN Object_Account_View AS View_Account ON View_Account.AccountGroupId = tmp.AccountGroupId
                          )    
       SELECT tmp.LocationId, tmp.ContainerDescId, tmp.ContainerId_count, tmp.ContainerId_begin, tmp.GoodsId, tmp.AccountId, tmp.AccountGroupId, tmp.Amount
       FROM
             (SELECT _tmpLocation.LocationId
                   , _tmpLocation.ContainerDescId
                   , CASE WHEN _tmpLocation.ContainerDescId = zc_Container_Count()
                               THEN ContainerLinkObject.ContainerId
                          ELSE COALESCE (Container.ParentId, 0)
                     END AS ContainerId_count
                   , ContainerLinkObject.ContainerId AS ContainerId_begin
                   , CASE WHEN _tmpLocation.ContainerDescId = zc_Container_Count() THEN COALESCE (Container.ObjectId, 0) ELSE COALESCE (CLO_Goods.ObjectId, 0) END AS GoodsId
                   , CASE WHEN _tmpLocation.ContainerDescId = zc_Container_Count()
                               THEN COALESCE (CLO_Account.ObjectId, 0)
                          ELSE COALESCE (Container.ObjectId, 0)
                     END AS AccountId
                   , CASE WHEN CLO_Account.ObjectId > 0 AND _tmpLocation.ContainerDescId = zc_Container_Count()
                               THEN zc_Enum_AccountGroup_110000() -- Транзит
                          ELSE COALESCE (tmpAccount.AccountGroupId, 0)
                     END AS AccountGroupId
                   , Container.Amount 
                   , _tmpLocation.DescId    AS Value1_ch
                   , CLO_Member.ContainerId AS Value2_ch
              FROM _tmpLocation
                   INNER JOIN ContainerLinkObject ON ContainerLinkObject.ObjectId = _tmpLocation.LocationId
                                                 AND ContainerLinkObject.DescId = _tmpLocation.DescId
                   INNER JOIN Container ON Container.Id = ContainerLinkObject.ContainerId
                                       AND Container.DescId = _tmpLocation.ContainerDescId
                   LEFT JOIN tmpAccount ON tmpAccount.AccountId = Container.ObjectId
                   LEFT JOIN ContainerLinkObject AS CLO_Goods ON CLO_Goods.ContainerId = ContainerLinkObject.ContainerId
                                                             AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()
                                                             AND _tmpLocation.ContainerDescId = zc_Container_Summ()
                   LEFT JOIN ContainerLinkObject AS CLO_Account ON CLO_Account.ContainerId = Container.Id
                                                               AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                                                               AND _tmpLocation.ContainerDescId = zc_Container_Count()
                   LEFT JOIN ContainerLinkObject AS CLO_Member ON CLO_Member.ContainerId = CASE WHEN vbIsCLO_Member = TRUE THEN Container.Id ELSE NULL END
                                                              AND CLO_Member.DescId = zc_ContainerLinkObject_Member()
       
                   LEFT JOIN ContainerLinkObject AS CLO_AssetTo ON CLO_AssetTo.ContainerId = ContainerLinkObject.ContainerId
                                                               AND CLO_AssetTo.DescId = zc_ContainerLinkObject_AssetTo()
                   LEFT JOIN ContainerLinkObject AS CLO_PartionGoods ON CLO_PartionGoods.ContainerId = ContainerLinkObject.ContainerId
                                                                    AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                   LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = CLO_PartionGoods.ObjectId
              WHERE ((_tmpLocation.ContainerDescId = zc_Container_Count() AND ((CLO_Account.ContainerId > 0 AND 0 = zc_Enum_AccountGroup_110000()) -- Транзит
                                                                            OR (CLO_Account.ContainerId IS NULL AND 0 <> zc_Enum_AccountGroup_110000()) -- Транзит
                                                                             ))
                    )
        -- AND (((Object_PartionGoods.ObjectCode > 0 OR CLO_AssetTo.ObjectId > 0 OR tmpAccount.AccountGroupId = zc_Enum_AccountGroup_10000()) AND vbIsAssetTo = TRUE)  OR FALSE = FALSE)
         -- AND ((ContainerLinkObject.DescId <> zc_ContainerLinkObject_Member() AND CLO_Member.ContainerId IS NULL)
         --   OR ContainerLinkObject.DescId = zc_ContainerLinkObject_Member())
      ) AS tmp
       WHERE ((tmp.Value1_ch <> zc_ContainerLinkObject_Member() AND tmp.Value2_ch IS NULL)
           OR tmp.Value1_ch = zc_ContainerLinkObject_Member())
      ;

    -- !!!!!!!!!!!!!!!!!!!!!!!
    ANALYZE _tmpListContainer;

    -- 1. пытаемся найти <Счет> для zc_Container_Count
    UPDATE _tmpListContainer SET AccountId      = _tmpListContainer_summ.AccountId
                               , AccountGroupId = _tmpListContainer_summ.AccountGroupId
    FROM _tmpListContainer AS _tmpListContainer_summ
         INNER JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() -- Инвестиции
         INNER JOIN ContainerLinkObject AS CLO_InfoMoneyDetail ON CLO_InfoMoneyDetail.ContainerId = _tmpListContainer_summ.ContainerId_begin
                                                              AND CLO_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
                                                              AND CLO_InfoMoneyDetail.ObjectId = View_InfoMoney.InfoMoneyId

    WHERE _tmpListContainer.ContainerId_count = _tmpListContainer_summ.ContainerId_count
      AND _tmpListContainer.ContainerDescId = zc_Container_Count()
     --AND _tmpListContainer_summ.ContainerDescId = zc_Container_Summ()
      AND _tmpListContainer.AccountId = 0
      AND _tmpListContainer_summ.AccountGroupId = zc_Enum_AccountGroup_10000(); -- Необоротные активы

    -- 2.1. пытаемся найти <Счет> для zc_Container_Count
    UPDATE _tmpListContainer SET AccountId = _tmpListContainer_summ.AccountId
                               , AccountGroupId = _tmpListContainer_summ.AccountGroupId
    FROM _tmpListContainer AS _tmpListContainer_summ
    WHERE _tmpListContainer.ContainerId_count = _tmpListContainer_summ.ContainerId_count
      AND _tmpListContainer.ContainerDescId = zc_Container_Count()
      AND _tmpListContainer_summ.ContainerDescId = zc_Container_Summ()
      AND _tmpListContainer.AccountId = 0
      AND _tmpListContainer_summ.AccountGroupId <> zc_Enum_AccountGroup_110000() -- Транзит
      AND _tmpListContainer_summ.Amount <> 0
   ;
    -- 2.2. пытаемся найти <Счет> для zc_Container_Count
    UPDATE _tmpListContainer SET AccountId      = _tmpListContainer_summ.AccountId
                               , AccountGroupId = _tmpListContainer_summ.AccountGroupId
    FROM (SELECT _tmpListContainer.ContainerId_count, _tmpListContainer.AccountId, _tmpListContainer.AccountGroupId, _tmpListContainer.ContainerDescId
                 -- № п/п
               , ROW_NUMBER() OVER (PARTITION BY _tmpListContainer.ContainerId_count ORDER BY _tmpListContainer.ContainerId_begin DESC) AS Ord
          FROM _tmpListContainer
          WHERE _tmpListContainer.ContainerDescId = zc_Container_Summ()
            AND _tmpListContainer.AccountGroupId  <> zc_Enum_AccountGroup_110000() -- Транзит
         ) AS _tmpListContainer_summ
    WHERE _tmpListContainer.ContainerId_count = _tmpListContainer_summ.ContainerId_count
      AND _tmpListContainer.ContainerDescId = zc_Container_Count()
      -- AND _tmpListContainer_summ.ContainerDescId = zc_Container_Summ()
      AND _tmpListContainer.AccountId = 0
      AND _tmpListContainer_summ.AccountGroupId <> zc_Enum_AccountGroup_110000() -- Транзит
      AND _tmpListContainer_summ.Ord = 1 -- !!!последний!!!
   ;

    -- все ContainerId
    INSERT INTO _tmpContainer (ContainerDescId, ContainerId_count, ContainerId_begin, LocationId, GoodsId, GoodsKindId, Amount)
       SELECT _tmpListContainer.ContainerDescId
            , _tmpListContainer.ContainerId_count
            , _tmpListContainer.ContainerId_begin
            , CASE WHEN _tmpListContainer.LocationId = 0 THEN COALESCE (CLO_Unit.ObjectId, 0) ELSE _tmpListContainer.LocationId END AS LocationId
            , _tmpListContainer.GoodsId
            , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
            , _tmpListContainer.Amount
       FROM _tmpListContainer
            LEFT JOIN ContainerLinkObject AS CLO_GoodsKind ON CLO_GoodsKind.ContainerId = _tmpListContainer.ContainerId_count --ContainerId_begin
                                                          AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
            LEFT JOIN ContainerLinkObject AS CLO_Unit ON CLO_Unit.ContainerId = _tmpListContainer.ContainerId_count --ContainerId_begin
                                                     AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
       ;

    -- !!!!!!!!!!!!!!!!!!!!!!!
    ANALYZE _tmpContainer;

    -- Результат
    RETURN QUERY
          WITH 
              tmpMIContainer AS (SELECT _tmpContainer.ContainerDescId
                                       , MIContainer.OperDate
                                       , _tmpContainer.LocationId
                                       , _tmpContainer.GoodsId
                                       , _tmpContainer.GoodsKindId
                                       , _tmpContainer.ContainerId_begin

                                         -- ***COUNT***
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_IncomeCost(), zc_Movement_IncomeAsset())
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountIncome
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnOut()
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountReturnOut

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendAsset())
                                                    AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSendIn
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendAsset())
                                                    AND MIContainer.isActive = FALSE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSendOut

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossCount_20200() -- Кол-во, списание при реализации/перемещении по цене
                                                    AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSendOnPriceIn
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) = zc_Enum_AnalyzerId_SendCount_10500() -- Кол-во, перемещение, перемещение по цене, Скидка за вес
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSendOnPrice_10500
                                         , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) = zc_Enum_AnalyzerId_SendCount_40200() -- Кол-во, перемещение, перемещение по цене, Разница в весе
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSendOnPrice_40200
                                              
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossCount_20200() -- Кол-во, списание при реализации/перемещении по цене
                                                    AND MIContainer.isActive = FALSE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSendOnPriceOut
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_LossCount_10900() -- Кол-во, Утилизация возвратов при реализации/перемещении по цене
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSendOnPriceOut_10900

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400() -- Кол-во, реализация, у покупателя
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSale
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10500() -- Кол-во, реализация, Скидка за вес
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSale_10500
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_40200() -- Кол-во, реализация, Разница в весе
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSale_40208

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400() -- Кол-во, реализация, у покупателя
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSaleReal
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10500() -- Кол-во, реализация, Скидка за вес
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSaleReal_10500
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_40200() -- Кол-во, реализация, Разница в весе
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSaleReal_40208


                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) IN (0, zc_Enum_AnalyzerId_ReturnInCount_10800()) -- !!!Тара!!! + Кол-во, возврат, от покупателя
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountReturnIn
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_40200() -- Кол-во, возврат, Разница в весе
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountReturnIn_40208

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) IN (0, zc_Enum_AnalyzerId_ReturnInCount_10800()) -- !!!Тара!!! + Кол-во, возврат, от покупателя
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountReturnInReal
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_40200() -- Кол-во, возврат, Разница в весе
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountReturnInReal_40208


                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND (MIContainer.MovementDescId IN (zc_Movement_Loss(), zc_Movement_Transport())
                                                         OR MIContainer.AnalyzerId = zc_Enum_AnalyzerId_LossCount_20200() -- Кол-во, списание при реализации/перемещении по цене
                                                        )
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountLoss
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountInventory
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                    AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountProductionIn
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                    AND MIContainer.isActive = FALSE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountProductionOut

                                         -- ***REMAINS***
                                       , 0                             AS RemainsStart
                                       , 0                             AS RemainsEnd
                                       , -1 * SUM (MIContainer.Amount) AS Remains_Mov   
                                       

                                  FROM _tmpContainer
                                       INNER JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = _tmpContainer.ContainerId_begin
                                                                                      AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate

                                       LEFT JOIN MovementBoolean AS MovementBoolean_HistoryCost
                                                                 ON MovementBoolean_HistoryCost.MovementId = MIContainer.MovementId
                                                                AND MovementBoolean_HistoryCost.DescId = zc_MovementBoolean_HistoryCost()
                                       LEFT JOIN MovementBoolean AS MovementBoolean_Peresort
                                                                 ON MovementBoolean_Peresort.MovementId = MIContainer.MovementId
                                                                AND MovementBoolean_Peresort.DescId = zc_MovementBoolean_Peresort()
                                      
                                  GROUP BY _tmpContainer.ContainerDescId
                                         , MIContainer.OperDate
                                         , _tmpContainer.LocationId
                                         , _tmpContainer.GoodsId
                                         , _tmpContainer.GoodsKindId
                                         , _tmpContainer.ContainerId_begin

                                  HAVING -- ***COUNT***
                                         SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_IncomeCost(), zc_Movement_IncomeAsset())
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountIncome
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnOut()
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountReturnOut

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendAsset())
                                                    AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountSendIn
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendAsset())
                                                    AND MIContainer.isActive = FALSE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountSendOut

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossCount_20200() -- Кол-во, списание при реализации/перемещении по цене
                                                    AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountSendOnPriceIn
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) = zc_Enum_AnalyzerId_SendCount_10500() -- Кол-во, перемещение, перемещение по цене, Скидка за вес
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 --AS CountSendOnPrice_10500
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) = zc_Enum_AnalyzerId_SendCount_40200() -- Кол-во, перемещение, перемещение по цене, Разница в весе
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 --AS CountSendOnPrice_40200

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossCount_20200() -- Кол-во, списание при реализации/перемещении по цене
                                                    AND MIContainer.isActive = FALSE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountSendOnPriceOut

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_LossCount_10900() -- Кол-во, Утилизация возвратов при реализации/перемещении по цене
                                                    -- AND MIContainer.isActive = FALSE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountSendOnPriceOut_10900

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400() -- Кол-во, реализация, у покупателя
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountSale
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10500() -- Кол-во, реализация, Скидка за вес
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountSale_10500
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_40200() -- Кол-во, реализация, Разница в весе
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountSale_40208

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400() -- Кол-во, реализация, у покупателя
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountSaleReal
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10500() -- Кол-во, реализация, Скидка за вес
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountSaleReal_10500
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_40200() -- Кол-во, реализация, Разница в весе
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountSaleReal_40208


                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) IN (0, zc_Enum_AnalyzerId_ReturnInCount_10800()) -- !!!Тара!!! + Кол-во, возврат, от покупателя
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountReturnIn
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_40200() -- Кол-во, возврат, Разница в весе
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountReturnIn_40208

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) IN (0, zc_Enum_AnalyzerId_ReturnInCount_10800()) -- !!!Тара!!! + Кол-во, возврат, от покупателя
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountReturnInReal
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_40200() -- Кол-во, возврат, Разница в весе
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountReturnInReal_40208

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND (MIContainer.MovementDescId IN (zc_Movement_Loss(), zc_Movement_Transport())
                                                         OR MIContainer.AnalyzerId = zc_Enum_AnalyzerId_LossCount_20200() -- Кол-во, списание при реализации/перемещении по цене
                                                        )
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountLoss
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountInventory
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                    AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountProductionIn
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                    AND MIContainer.isActive = FALSE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountProductionOut

                                         -- ***REMAINS***
                                      OR SUM (MIContainer.Amount) <> 0 -- AS RemainsStart

                                 UNION ALL
                                  SELECT _tmpContainer.ContainerDescId
                                       , inStartDate AS Operdate
                                       , _tmpContainer.LocationId
                                       , _tmpContainer.GoodsId
                                       , _tmpContainer.GoodsKindId
                                       , _tmpContainer.ContainerId_begin

                                         -- ***COUNT***
                                       , 0 AS CountIncome
                                       , 0 AS CountReturnOut

                                       , 0 AS CountSendIn
                                       , 0 AS CountSendOut

                                       , 0 AS CountSendOnPriceIn
                                       , 0 AS CountSendOnPrice_10500
                                       , 0 AS CountSendOnPrice_40200
                                       , 0 AS CountSendOnPriceOut
                                       , 0 AS CountSendOnPriceOut_10900

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

                                         -- ***REMAINS***
                                       --, _tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS RemainsStart
                                       --, _tmpContainer.Amount - SUM (CASE WHEN MIContainer.OperDate >= inStartDate THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS RemainsStart
                                       , _tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS RemainsStart
                                       , _tmpContainer.Amount - SUM (CASE WHEN MIContainer.OperDate >inEndDate THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS RemainsEnd
                                       , 0 AS Remains_Mov

                                  FROM _tmpContainer AS _tmpContainer
                                       LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = _tmpContainer.ContainerId_count
                                                                                     AND MIContainer.OperDate >= inStartDate -->inEndDate

                                  GROUP BY _tmpContainer.ContainerDescId
                                       --  , _tmpContainer.ContainerId_count
                                         , _tmpContainer.ContainerId_begin
                                         , _tmpContainer.LocationId
                                         , _tmpContainer.GoodsId
                                         , _tmpContainer.GoodsKindId
                                         , _tmpContainer.Amount
                                    --     , MIContainer.OperDate
                                        , inStartDate
                                  HAVING _tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0
                                      --OR _tmpContainer.Amount - SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) <> 0
                                 )


 , tmpCost AS (SELECT tmpMIContainer.ContainerId_begin
                               , SUM (HistoryCost.Price) AS Price
                          FROM tmpMIContainer
                               JOIN Container ON Container.ParentId = tmpMIContainer.ContainerId_begin
                                             AND Container.DescId = zc_Container_Summ()
                               JOIN HistoryCost ON HistoryCost.ContainerId = Container.Id
                                               AND (tmpMIContainer.OperDate - INTERVAL '1 DAY') BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
                          GROUP BY tmpMIContainer.ContainerId_begin
                          )

         -- Результат
         SELECT tmpMIContainer_all.OperDate
              , tmpMIContainer_all.LocationId
              , tmpMIContainer_all.GoodsId
              , tmpMIContainer_all.GoodsKindId

              , SUM (CASE WHEN tmpMIContainer_all.ContainerDescId = zc_Container_Count() THEN tmpMIContainer_all.RemainsStart ELSE 0 END) :: TFloat AS CountStart
              , SUM (CASE WHEN tmpMIContainer_all.ContainerDescId = zc_Container_Count() THEN tmpMIContainer_all.RemainsEnd   ELSE 0 END) :: TFloat AS CountEnd
              , SUM (CASE WHEN tmpMIContainer_all.ContainerDescId = zc_Container_Count() THEN tmpMIContainer_all.RemainsEnd - tmpMIContainer_all.CountInventory ELSE 0 END) :: TFloat AS CountEnd_calc
              , SUM (tmpMIContainer_all.Remains_Mov)             :: TFloat AS Remains_Mov

              , SUM (tmpMIContainer_all.CountIncome)             :: TFloat AS CountIncome
              , SUM (tmpMIContainer_all.CountReturnOut)          :: TFloat AS CountReturnOut

              , SUM (tmpMIContainer_all.CountSendIn)             :: TFloat AS CountSendIn
              , SUM (tmpMIContainer_all.CountSendOut)            :: TFloat AS CountSendOut

              , SUM (tmpMIContainer_all.CountSendOnPriceIn)        :: TFloat AS CountSendOnPriceIn
              , SUM (tmpMIContainer_all.CountSendOnPriceOut)       :: TFloat AS CountSendOnPriceOut
              , SUM (tmpMIContainer_all.CountSendOnPriceOut_10900) :: TFloat AS CountSendOnPriceOut_10900

              , SUM (tmpMIContainer_all.CountSendOnPrice_10500)    :: TFloat AS CountSendOnPrice_10500
              , SUM (tmpMIContainer_all.CountSendOnPrice_40200)    :: TFloat AS CountSendOnPrice_40200
              
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
              
              , SUM (tmpCost.Price * COALESCE(tmpMIContainer_all.RemainsStart,0) ) :: TFloat AS CostStart
              , SUM (tmpCost.Price * tmpMIContainer_all.RemainsEnd ) :: TFloat AS CostEnd
              , SUM (tmpCost.Price * tmpMIContainer_all.RemainsEnd - tmpMIContainer_all.CountInventory ) :: TFloat AS CostEnd_calc
              , SUM (tmpCost.Price * tmpMIContainer_all.Remains_Mov)  :: TFloat AS CostRemains_Mov

         FROM tmpMIContainer AS tmpMIContainer_all
              LEFT JOIN tmpCost ON tmpCost.ContainerId_begin = tmpMIContainer_all.ContainerId_begin
         GROUP BY tmpMIContainer_all.LocationId
                , tmpMIContainer_all.GoodsId
                , tmpMIContainer_all.GoodsKindId
                , tmpMIContainer_all.OperDate
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.11.22         * Cost
 29.04.20         * zc_Movement_SendAsset
 13.08.19         *
*/

-- тест
--
-- SELECT * FROM lpReport_MotionGoodsCount_light (inStartDate:= '01.08.2019', inEndDate:= '02.08.2019', inLocationId := 8459 , inUserId := zfCalc_UserAdmin() :: Integer) as tt
--left join Object on Object.Id = tt.GoodsId 
--where tt.GoodsId  = 2055;

 --SELECT * FROM RemainsOLAPTable                     
 --SELECT * FROM lpReport_MotionGoodsCount_light (inStartDate:= '01.11.2022', inEndDate:= '02.11.2022', inLocationId := 8459 , inUserId := zfCalc_UserAdmin() :: Integer) as tt