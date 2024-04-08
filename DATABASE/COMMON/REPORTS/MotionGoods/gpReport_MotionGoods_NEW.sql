-- Function: gpReport_MotionGoods_NEW()

DROP FUNCTION IF EXISTS gpReport_MotionGoods_NEW (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_MotionGoods_NEW (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_MotionGoods_NEW(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inAccountGroupId     Integer,    --
    IN inUnitGroupId        Integer,    -- группа подразделений на самом деле может быть и подразделением
    IN inLocationId         Integer,    --
    IN inGoodsGroupId       Integer,    -- группа товара
    IN inGoodsId            Integer,    -- товар
    IN inUnitGroupId_by     Integer,    -- группа подразделений 1
    IN inLocationId_by      Integer,    -- место учета 1
    IN inIsInfoMoney        Boolean,    --
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (AccountGroupName TVarChar, AccountDirectionName TVarChar
             , AccountId Integer, AccountCode Integer, AccountName TVarChar, AccountName_All TVarChar
             , LocationDescName TVarChar, LocationId Integer, LocationCode Integer, LocationName TVarChar
             , CarCode Integer, CarName TVarChar
             , GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsKindId Integer, GoodsKindName TVarChar, MeasureName TVarChar
             , Weight TFloat
             , PartionGoodsId Integer, PartionGoodsName TVarChar, AssetToName TVarChar

             , CountStart TFloat
             , CountStart_Weight TFloat
             , CountEnd TFloat
             , CountEnd_Weight TFloat

             , CountIncome TFloat
             , CountIncome_Weight TFloat
             , CountReturnOut TFloat
             , CountReturnOut_Weight TFloat

             , CountSendIn TFloat
             , CountSendIn_Weight TFloat
             , CountSendOut TFloat
             , CountSendOut_Weight TFloat

             , CountSendOnPriceIn TFloat
             , CountSendOnPriceIn_Weight TFloat
             , CountSendOnPriceOut TFloat
             , CountSendOnPriceOut_Weight TFloat

             , CountSale TFloat
             , CountSale_Weight TFloat
             , CountSale_10500 TFloat
             , CountSale_10500_Weight TFloat
             , CountSale_40208 TFloat
             , CountSale_40208_Weight TFloat

             , CountReturnIn TFloat
             , CountReturnIn_Weight TFloat
             , CountReturnIn_40208 TFloat
             , CountReturnIn_40208_Weight TFloat

             , CountLoss TFloat
             , CountLoss_Weight TFloat
             , CountInventory TFloat
             , CountInventory_Weight TFloat

             , CountProductionIn TFloat
             , CountProductionIn_Weight TFloat
             , CountProductionOut TFloat
             , CountProductionOut_Weight TFloat

             , CountTotalIn TFloat
             , CountTotalIn_Weight TFloat
             , CountTotalOut TFloat
             , CountTotalOut_Weight TFloat

             , SummStart TFloat
             , SummEnd TFloat
             , SummIncome TFloat
             , SummReturnOut TFloat
             , SummSendIn TFloat
             , SummSendOut TFloat
             , SummSendOnPriceIn TFloat
             , SummSendOnPriceOut TFloat
             , SummSale TFloat
             , SummSale_10500 TFloat
             , SummSale_40208 TFloat
             , SummReturnIn TFloat
             , SummReturnIn_40208 TFloat
             , SummLoss TFloat
             , SummInventory TFloat
             , SummInventory_RePrice TFloat
             , SummProductionIn TFloat
             , SummProductionOut TFloat
             , SummTotalIn TFloat
             , SummTotalOut TFloat

             , PriceStart TFloat
             , PriceEnd TFloat
             , PriceIncome TFloat
             , PriceReturnOut TFloat
             , PriceSendIn TFloat
             , PriceSendOut TFloat
             , PriceSendOnPriceIn TFloat
             , PriceSendOnPriceOut TFloat
             , PriceSale TFloat
             , PriceReturnIn TFloat
             , PriceLoss TFloat
             , PriceInventory TFloat
             , PriceProductionIn TFloat
             , PriceProductionOut TFloat
             , PriceTotalIn TFloat
             , PriceTotalOut TFloat

             , PriceListStart TFloat
             , PriceListEnd TFloat

             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , InfoMoneyId_Detail Integer, InfoMoneyCode_Detail Integer, InfoMoneyGroupName_Detail TVarChar, InfoMoneyDestinationName_Detail TVarChar, InfoMoneyName_Detail TVarChar, InfoMoneyName_all_Detail TVarChar

             , ContainerId_Summ Integer
             , LineNum Integer

              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Report_MotionGoods());
    vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

   -- !!!меняются параметры для филиала!!!
   IF 0 < (SELECT BranchId FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND BranchId <> 0 GROUP BY BranchId)
   THEN
       inAccountGroupId:= zc_Enum_AccountGroup_20000(); -- Запасы
       inIsInfoMoney:= FALSE;
   END IF;

    -- таблица -
    CREATE TEMP TABLE _tmpLocation (LocationId Integer, DescId Integer, ContainerDescId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpListContainer (LocationId Integer, ContainerDescId Integer, ContainerId_count Integer, ContainerId_begin Integer, GoodsId Integer, AccountId Integer, AccountGroupId Integer, Amount TFloat) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpContainer_Count (ContainerDescId Integer, ContainerId_count Integer, ContainerId_begin Integer, LocationId Integer, GoodsId Integer, GoodsKindId Integer, PartionGoodsId Integer, AssetToId Integer, AccountId Integer, AccountGroupId Integer, Amount TFloat) ON COMMIT DROP;


    -- группа подразделений или подразделение или место учета (МО, Авто)
    IF inUnitGroupId <> 0
    THEN
        INSERT INTO _tmpLocation (LocationId, DescId, ContainerDescId)
           SELECT lfSelect_Object_Unit_byGroup.UnitId AS LocationId
                , zc_ContainerLinkObject_Unit()       AS DescId
                , tmpDesc.ContainerDescId
           FROM lfSelect_Object_Unit_byGroup (inUnitGroupId) AS lfSelect_Object_Unit_byGroup
                LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId UNION SELECT zc_Container_Summ() AS ContainerDescId) AS tmpDesc ON 1 = 1
          ;
    ELSE
        IF inLocationId <> 0
        THEN
            INSERT INTO _tmpLocation (LocationId, DescId, ContainerDescId)
               SELECT Object.Id AS LocationId
                    , CASE WHEN Object.DescId = zc_Object_Unit() THEN zc_ContainerLinkObject_Unit() 
                           WHEN Object.DescId = zc_Object_Car() THEN zc_ContainerLinkObject_Car() 
                           WHEN Object.DescId = zc_Object_Member() THEN zc_ContainerLinkObject_Member()
                      END AS DescId
                    , tmpDesc.ContainerDescId
               FROM Object
                    LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId UNION SELECT zc_Container_Summ() AS ContainerDescId) AS tmpDesc ON 1 = 1
               WHERE Object.Id = inLocationId;
        ELSE
            WITH tmpBranch AS (SELECT TRUE AS Value WHERE 1 = 0 AND NOT EXISTS (SELECT BranchId FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND BranchId <> 0))
            INSERT INTO _tmpLocation (LocationId)
               SELECT Id FROM Object INNER JOIN tmpBranch ON tmpBranch.Value = TRUE WHERE DescId = zc_Object_Unit()
              UNION ALL
               SELECT Id FROM Object INNER JOIN tmpBranch ON tmpBranch.Value = TRUE WHERE DescId = zc_Object_Member()
              UNION ALL
               SELECT Id FROM Object INNER JOIN tmpBranch ON tmpBranch.Value = TRUE WHERE DescId = zc_Object_Car();
        END IF;
    END IF;

    -- !!!!!!!!!!!!!!!!!!!!!!!
    ANALYZE _tmpLocation;


    -- группа товаров или товар или все товары из проводок
    IF inGoodsGroupId <> 0
    THEN
        WITH tmpGoods AS (SELECT lfObject_Goods_byGoodsGroup.GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup)
           , tmpAccount AS (SELECT View_Account.AccountGroupId, View_Account.AccountId
                            FROM Object_Account_View AS View_Account
                            WHERE (View_Account.AccountGroupId = inAccountGroupId OR COALESCE (inAccountGroupId, 0) = 0)
                               -- OR (View_Account.AccountGroupId = zc_Enum_AccountGroup_110000() AND inAccountGroupId = zc_Enum_AccountGroup_20000()) -- Транзит AND Запасы
                           )
        INSERT INTO _tmpListContainer (LocationId, ContainerDescId, ContainerId_count, ContainerId_begin, GoodsId, AccountId, AccountGroupId, Amount)
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
           WHERE tmpAccount.AccountId > 0 OR _tmpLocation.ContainerDescId = zc_Container_Count()
          ;
    ELSE IF inGoodsId <> 0
         THEN
             WITH tmpContainer AS (SELECT CLO_Goods.ContainerId FROM ContainerLinkObject AS CLO_Goods WHERE CLO_Goods.ObjectId = inGoodsId AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()
                                 UNION
                                   SELECT Container.Id FROM Container WHERE Container.ObjectId = inGoodsId AND Container.DescId = zc_Container_Count()
                                  )
                , tmpAccount AS (SELECT View_Account.AccountGroupId, View_Account.AccountId
                                 FROM Object_Account_View AS View_Account
                                 WHERE (View_Account.AccountGroupId = inAccountGroupId OR COALESCE (inAccountGroupId, 0) = 0)
                                    OR (View_Account.AccountGroupId = zc_Enum_AccountGroup_110000() AND inAccountGroupId = zc_Enum_AccountGroup_20000()) -- Транзит AND Запасы
                                )
             INSERT INTO _tmpListContainer (LocationId, ContainerDescId, ContainerId_count, ContainerId_begin, GoodsId, AccountId, AccountGroupId, Amount)
                SELECT _tmpLocation.LocationId
                     , _tmpLocation.ContainerDescId
                     , CASE WHEN _tmpLocation.ContainerDescId = zc_Container_Count()
                                 THEN tmpContainer.ContainerId
                            ELSE COALESCE (Container.ParentId, 0)
                       END AS ContainerId_count
                     , tmpContainer.ContainerId AS ContainerId_begin
                     , inGoodsId AS GoodsId
                     , CASE WHEN _tmpLocation.ContainerDescId = zc_Container_Count()
                                 THEN COALESCE (CLO_Account.ObjectId, 0)
                            ELSE COALESCE (Container.ObjectId, 0)
                       END AS AccountId
                     , CASE WHEN CLO_Account.ObjectId > 0 AND _tmpLocation.ContainerDescId = zc_Container_Count()
                                 THEN zc_Enum_AccountGroup_110000() -- Транзит
                            ELSE COALESCE (tmpAccount.AccountGroupId, 0)
                       END AS AccountGroupId
                     , Container.Amount
                FROM tmpContainer
                     INNER JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = tmpContainer.ContainerId
                     INNER JOIN _tmpLocation ON _tmpLocation.LocationId = ContainerLinkObject.ObjectId
                                            AND _tmpLocation.DescId = ContainerLinkObject.DescId
                     INNER JOIN Container ON Container.Id = tmpContainer.ContainerId
                                         AND Container.DescId = _tmpLocation.ContainerDescId
                     LEFT JOIN tmpAccount ON tmpAccount.AccountId = Container.ObjectId
                     LEFT JOIN ContainerLinkObject AS CLO_Account ON CLO_Account.ContainerId = Container.Id
                                                                 AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                                                                 AND _tmpLocation.ContainerDescId = zc_Container_Count()
                WHERE tmpAccount.AccountId > 0 OR _tmpLocation.ContainerDescId = zc_Container_Count()
               ;
         ELSE
             WITH tmpAccount AS (SELECT View_Account.AccountGroupId, View_Account.AccountId
                                 FROM Object_Account_View AS View_Account
                                 WHERE (View_Account.AccountGroupId = inAccountGroupId OR COALESCE (inAccountGroupId, 0) = 0)
                                    OR (View_Account.AccountGroupId = zc_Enum_AccountGroup_110000() AND inAccountGroupId = zc_Enum_AccountGroup_20000()) -- Транзит AND Запасы
                                )
             INSERT INTO _tmpListContainer (LocationId, ContainerDescId, ContainerId_count, ContainerId_begin, GoodsId, AccountId, AccountGroupId, Amount)
                SELECT _tmpLocation.LocationId
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
                WHERE tmpAccount.AccountId > 0 OR _tmpLocation.ContainerDescId = zc_Container_Count() AND inAccountGroupId = zc_Enum_AccountGroup_20000() 
               ;
             --  SELECT Id FROM Object WHERE DescId = zc_Object_Goods() AND (inUnitGroupId <> 0 OR inLocationId <> 0)
             -- UNION
             --  SELECT Id FROM Object WHERE DescId = zc_Object_Fuel() AND (inUnitGroupId <> 0 OR inLocationId <> 0)
         END IF;
    END IF;


    -- !!!!!!!!!!!!!!!!!!!!!!!
    ANALYZE _tmpListContainer;

    -- пытаемся найти <Счет> для zc_Container_Count
    UPDATE _tmpListContainer SET AccountId = _tmpListContainer_summ.AccountId
                               , AccountGroupId = _tmpListContainer_summ.AccountGroupId
    FROM _tmpListContainer AS _tmpListContainer_summ
    WHERE _tmpListContainer.ContainerId_count = _tmpListContainer_summ.ContainerId_count
      AND _tmpListContainer.ContainerDescId = zc_Container_Count()
      AND _tmpListContainer_summ.ContainerDescId = zc_Container_Summ()
      AND _tmpListContainer.AccountId = 0
      AND _tmpListContainer_summ.AccountGroupId <> zc_Enum_AccountGroup_110000() -- Транзит
   ;

    -- все ContainerId
    INSERT INTO _tmpContainer_Count (ContainerDescId, ContainerId_count, ContainerId_begin, LocationId, GoodsId, GoodsKindId, PartionGoodsId, AssetToId, AccountId, AccountGroupId, Amount)
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
       ;

-- return;
--  RAISE EXCEPTION '%    %     %', (select count(*) from _tmpLocation), (select count(*) from _tmpListContainer),  (select count(*) from _tmpContainer_Count);

    -- !!!!!!!!!!!!!!!!!!!!!!!
    ANALYZE _tmpContainer_Count;

         -- !!!!!!!!!!!!!!!!!!!!!!!
         -- !!!старт!!! ЕСЛИ <= 300
         -- !!!!!!!!!!!!!!!!!!!!!!!
      RETURN QUERY
         WITH tmpPriceStart AS (SELECT lfObjectHistory_PriceListItem.GoodsId
                                     , lfObjectHistory_PriceListItem.GoodsKindId
                                     , lfObjectHistory_PriceListItem.ValuePrice AS Price
                                FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis(), inOperDate:= inStartDate)
                                     AS lfObjectHistory_PriceListItem
                                WHERE lfObjectHistory_PriceListItem.ValuePrice <> 0
                               )
              , tmpPriceEnd AS (SELECT lfObjectHistory_PriceListItem.GoodsId
                                     , lfObjectHistory_PriceListItem.GoodsKindId
                                     , lfObjectHistory_PriceListItem.ValuePrice AS Price
                                FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis(), inOperDate:= inEndDate)
                                     AS lfObjectHistory_PriceListItem
                                WHERE lfObjectHistory_PriceListItem.ValuePrice <> 0
                               )
       , tmpMIContainer_Count AS (SELECT CASE WHEN inIsInfoMoney = TRUE THEN tmpContainer_Count.ContainerDescId   ELSE 0 END AS ContainerDescId
                                       , CASE WHEN inIsInfoMoney = TRUE THEN tmpContainer_Count.ContainerId_count ELSE 0 END AS ContainerId_count
                                       , CASE WHEN inIsInfoMoney = TRUE THEN tmpContainer_Count.ContainerId_begin ELSE 0 END AS ContainerId_begin
                                       , tmpContainer_Count.LocationId
                                       , tmpContainer_Count.GoodsId
                                       , tmpContainer_Count.GoodsKindId
                                       , tmpContainer_Count.PartionGoodsId
                                       , tmpContainer_Count.AssetToId
                                       , tmpContainer_Count.AccountId
                                       , tmpContainer_Count.AccountGroupId

                                        -- ***COUNT***
                                       , SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Income()
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountIncome
                                       , SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnOut()
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountReturnOut

                                       , SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Send()
                                                    AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSendIn
                                       , SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Send()
                                                    AND MIContainer.isActive = FALSE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSendOut

                                       , SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossCount_20200() -- Кол-во, списание при реализации/перемещении по цене
                                                    AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSendOnPriceIn
                                       , SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossCount_20200() -- Кол-во, списание при реализации/перемещении по цене
                                                    AND MIContainer.isActive = FALSE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSendOnPriceOut

                                       , SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400() -- Кол-во, реализация, у покупателя
                                                    -- AND (tmpContainer_Count.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE) -- Транзит
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSale
                                       , SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10500() -- Кол-во, реализация, Скидка за вес
                                                    -- AND (tmpContainer_Count.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE) -- Транзит
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSale_10500
                                       , SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_40200() -- Кол-во, реализация, Разница в весе
                                                    -- AND (tmpContainer_Count.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE) -- Транзит
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSale_40208

                                       , SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400() -- Кол-во, реализация, у покупателя
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSaleReal
                                       , SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10500() -- Кол-во, реализация, Скидка за вес
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSaleReal_10500
                                       , SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_40200() -- Кол-во, реализация, Разница в весе
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSaleReal_40208


                                       , SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_10800() -- Кол-во, возврат, от покупателя
                                                    -- AND (tmpContainer_Count.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE) -- Транзит
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountReturnIn
                                       , SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_40200() -- Кол-во, возврат, Разница в весе
                                                    -- AND (tmpContainer_Count.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE) -- Транзит
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountReturnIn_40208

                                       , SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_10800() -- Кол-во, возврат, от покупателя
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountReturnInReal
                                       , SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_40200() -- Кол-во, возврат, Разница в весе
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountReturnInReal_40208


                                       , SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND (MIContainer.MovementDescId = zc_Movement_Loss()
                                                         OR MIContainer.AnalyzerId = zc_Enum_AnalyzerId_LossCount_20200() -- Кол-во, списание при реализации/перемещении по цене
                                                        )
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountLoss
                                       , SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountInventory
                                       , SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                    AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountProductionIn
                                       , SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                    AND MIContainer.isActive = FALSE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountProductionOut

                                        -- ***SUMM***
                                      , SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Income()
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummIncome
                                      , SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnOut()
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummReturnOut

                                      , SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Send()
                                                   AND MIContainer.isActive = TRUE
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSendIn
                                      , SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Send()
                                                   AND MIContainer.isActive = FALSE
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSendOut

                                      , SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                   AND MovementBoolean_HistoryCost.ValueData = TRUE
                                                   AND tmpContainer_Count.AccountGroupId = zc_Enum_AccountGroup_60000()  --
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossSumm_20200() -- Сумма с/с, списание при реализации/перемещении по цене
                                                       THEN MIContainer.Amount
                                                  WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                   AND MIContainer.isActive = TRUE
                                                   AND tmpContainer_Count.AccountGroupId <> zc_Enum_AccountGroup_60000()  --
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossSumm_20200() -- Сумма с/с, списание при реализации/перемещении по цене
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSendOnPriceIn
                                      , SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                   AND COALESCE (MovementBoolean_HistoryCost.ValueData, FALSE) = FALSE
                                                   AND tmpContainer_Count.AccountGroupId = zc_Enum_AccountGroup_60000()  --
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossSumm_20200() -- Сумма с/с, списание при реализации/перемещении по цене
                                                       THEN -1 * MIContainer.Amount
                                                  WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                   AND MIContainer.isActive = FALSE
                                                   AND tmpContainer_Count.AccountGroupId <> zc_Enum_AccountGroup_60000()  --
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossSumm_20200() -- Сумма с/с, списание при реализации/перемещении по цене
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSendOnPriceOut

                                      , SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10400() -- Сумма с/с, реализация, у покупателя
                                                   -- AND (tmpContainer_Count.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE)
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSale
                                      , SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10500() -- Сумма с/с, реализация, Скидка за вес
                                                   -- AND (tmpContainer_Count.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE)
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSale_10500
                                      , SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_40200() -- Сумма с/с, реализация, Разница в весе
                                                   -- AND (tmpContainer_Count.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE)
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSale_40208

                                      , SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10400() -- Сумма с/с, реализация, у покупателя
                                                   AND MIContainer.ContainerId_Analyzer <> 0
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSaleReal
                                      , SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10500() -- Сумма с/с, реализация, Скидка за вес
                                                   AND MIContainer.ContainerId_Analyzer <> 0
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSaleReal_10500
                                      , SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_40200() -- Сумма с/с, реализация, Разница в весе
                                                   AND MIContainer.ContainerId_Analyzer <> 0
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSaleReal_40208


                                      , SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10800() -- Сумма с/с, возврат, от покупателя
                                                   AND (tmpContainer_Count.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE)
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummReturnIn
                                      , SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_40200() -- Сумма с/с, возврат, Разница в весе
                                                   -- AND (tmpContainer_Count.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE)
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummReturnIn_40208

                                      , SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10800() -- Сумма с/с, возврат, от покупателя
                                                   -- AND MIContainer.ContainerId_Analyzer <> 0
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummReturnInReal
                                      , SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_40200() -- Сумма с/с, возврат, Разница в весе
                                                   AND MIContainer.ContainerId_Analyzer <> 0
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummReturnInReal_40208


                                      , SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND (MIContainer.MovementDescId = zc_Movement_Loss()
                                                        OR MIContainer.AnalyzerId = zc_Enum_AnalyzerId_LossSumm_20200() -- Сумма с/с, списание при реализации/перемещении по цене
                                                       )
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummLoss

                                      , SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AccountGroup_60000() -- Прибыль будущих периодов
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummInventory

                                      , SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AccountGroup_60000() -- Прибыль будущих периодов
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummInventory_RePrice

                                      , SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                   AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                  ELSE 0
                                              END) AS SummProductionIn
                                      , SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                   AND MIContainer.isActive = FALSE
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                              END) AS SummProductionOut

                                       , CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count() AND (tmpContainer_Count.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE) THEN tmpContainer_Count.Amount - COALESCE (SUM (MIContainer.Amount), 0) ELSE 0 END <> 0 AS CountStart
                                       , CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count() AND (tmpContainer_Count.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE) THEN tmpContainer_Count.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END)) ELSE 0 END <> 0 AS CountEnd

                                       , CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ() AND (tmpContainer_Count.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE) THEN tmpContainer_Count.Amount - COALESCE (SUM (MIContainer.Amount), 0) ELSE 0 END <> 0 AS SummStart
                                       , CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ() AND (tmpContainer_Count.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE) THEN tmpContainer_Count.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END)) ELSE 0 END <> 0 AS SummEnd

                                  FROM _tmpContainer_Count AS tmpContainer_Count
                                       LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = tmpContainer_Count.ContainerId_begin
                                                                                     AND MIContainer.OperDate >= inStartDate
                                       LEFT JOIN MovementBoolean AS MovementBoolean_HistoryCost
                                                                 ON MovementBoolean_HistoryCost.MovementId = MIContainer.MovementId
                                                                AND MovementBoolean_HistoryCost.DescId = zc_MovementBoolean_HistoryCost()
                                       /*LEFT JOIN MovementItemFloat AS MIFloat_AmountChangePercent ON MIFloat_AmountChangePercent.MovementItemId = MIContainer.MovementItemId
                                                                                                 AND MIFloat_AmountChangePercent.DescId = zc_MIFloat_AmountChangePercent()
                                       LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner ON MIFloat_AmountPartner.MovementItemId = MIContainer.MovementItemId
                                                                                           AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()*/
                                  GROUP BY tmpContainer_Count.ContainerDescId
                                         , CASE WHEN inIsInfoMoney = TRUE THEN tmpContainer_Count.ContainerId_count ELSE 0 END
                                         , CASE WHEN inIsInfoMoney = TRUE THEN tmpContainer_Count.ContainerId_begin ELSE 0 END
                                         , tmpContainer_Count.LocationId
                                         , tmpContainer_Count.GoodsId
                                         , tmpContainer_Count.GoodsKindId
                                         , tmpContainer_Count.PartionGoodsId
                                         , tmpContainer_Count.AssetToId
                                         , tmpContainer_Count.AccountId
                                         , tmpContainer_Count.AccountGroupId
                                         , tmpContainer_Count.Amount
                                  HAVING -- ***COUNT***
                                         SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Income()
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0
                                      OR SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnOut()
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0

                                      OR SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Send()
                                                    AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0
                                      OR SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Send()
                                                    AND MIContainer.isActive = FALSE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0

                                      OR SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossCount_20200() -- Кол-во, списание при реализации/перемещении по цене
                                                    AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0
                                      OR SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossCount_20200() -- Кол-во, списание при реализации/перемещении по цене
                                                    AND MIContainer.isActive = FALSE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0

                                      OR SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400() -- Кол-во, реализация, у покупателя
                                                    -- AND (tmpContainer_Count.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE) -- Транзит
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0
                                      OR SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10500() -- Кол-во, реализация, Скидка за вес
                                                    -- AND (tmpContainer_Count.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE) -- Транзит
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0
                                      OR SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_40200() -- Кол-во, реализация, Разница в весе
                                                    -- AND (tmpContainer_Count.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE) -- Транзит
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0

                                      OR SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400() -- Кол-во, реализация, у покупателя
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0
                                      OR SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10500() -- Кол-во, реализация, Скидка за вес
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0
                                      OR SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_40200() -- Кол-во, реализация, Разница в весе
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0


                                      OR SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_10800() -- Кол-во, возврат, от покупателя
                                                    -- AND (tmpContainer_Count.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE) -- Транзит
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0
                                      OR SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_40200() -- Кол-во, возврат, Разница в весе
                                                    -- AND (tmpContainer_Count.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE) -- Транзит
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0

                                      OR SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_10800() -- Кол-во, возврат, от покупателя
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0
                                      OR SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_40200() -- Кол-во, возврат, Разница в весе
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0


                                      OR SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND (MIContainer.MovementDescId = zc_Movement_Loss()
                                                         OR MIContainer.AnalyzerId = zc_Enum_AnalyzerId_LossCount_20200() -- Кол-во, списание при реализации/перемещении по цене
                                                        )
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0
                                      OR SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0
                                      OR SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                    AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0
                                      OR SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                    AND MIContainer.isActive = FALSE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0

                                        -- ***SUMM***
                                     OR SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Income()
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0
                                     OR SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnOut()
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0

                                     OR SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Send()
                                                   AND MIContainer.isActive = TRUE
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0
                                     OR SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Send()
                                                   AND MIContainer.isActive = FALSE
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0

                                     OR SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                   AND MovementBoolean_HistoryCost.ValueData = TRUE
                                                   AND tmpContainer_Count.AccountGroupId = zc_Enum_AccountGroup_60000()  --
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossSumm_20200() -- Сумма с/с, списание при реализации/перемещении по цене
                                                       THEN MIContainer.Amount
                                                  WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                   AND MIContainer.isActive = TRUE
                                                   AND tmpContainer_Count.AccountGroupId <> zc_Enum_AccountGroup_60000()  --
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossSumm_20200() -- Сумма с/с, списание при реализации/перемещении по цене
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0
                                     OR SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                   AND COALESCE (MovementBoolean_HistoryCost.ValueData, FALSE) = FALSE
                                                   AND tmpContainer_Count.AccountGroupId = zc_Enum_AccountGroup_60000()  --
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossSumm_20200() -- Сумма с/с, списание при реализации/перемещении по цене
                                                       THEN -1 * MIContainer.Amount
                                                  WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                   AND MIContainer.isActive = FALSE
                                                   AND tmpContainer_Count.AccountGroupId <> zc_Enum_AccountGroup_60000()  --
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossSumm_20200() -- Сумма с/с, списание при реализации/перемещении по цене
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0

                                     OR SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10400() -- Сумма с/с, реализация, у покупателя
                                                   -- AND (tmpContainer_Count.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE)
                                                   -- AND tmpContainer_Count.AccountGroupId = zc_Enum_AccountGroup_60000()  --
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0
                                     OR SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10500() -- Сумма с/с, реализация, Скидка за вес
                                                   -- AND (tmpContainer_Count.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE)
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0
                                     OR SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_40200() -- Сумма с/с, реализация, Разница в весе
                                                   -- AND (tmpContainer_Count.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE)
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0

                                     OR SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10400() -- Сумма с/с, реализация, у покупателя
                                                   AND MIContainer.ContainerId_Analyzer <> 0
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0
                                     OR SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10500() -- Сумма с/с, реализация, Скидка за вес
                                                   AND MIContainer.ContainerId_Analyzer <> 0
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0
                                     OR SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_40200() -- Сумма с/с, реализация, Разница в весе
                                                   AND MIContainer.ContainerId_Analyzer <> 0
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0


                                     OR SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10800() -- Сумма с/с, возврат, от покупателя
                                                   -- AND (tmpContainer_Count.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE)
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0
                                     OR SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_40200() -- Сумма с/с, возврат, Разница в весе
                                                   -- AND (tmpContainer_Count.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE)
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0

                                     OR SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10800() -- Сумма с/с, возврат, от покупателя
                                                   AND MIContainer.ContainerId_Analyzer <> 0
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0
                                     OR SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_40200() -- Сумма с/с, возврат, Разница в весе
                                                   AND MIContainer.ContainerId_Analyzer <> 0
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0


                                     OR SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND (MIContainer.MovementDescId = zc_Movement_Loss()
                                                        OR MIContainer.AnalyzerId = zc_Enum_AnalyzerId_LossSumm_20200() -- Сумма с/с, списание при реализации/перемещении по цене
                                                       )
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0

                                     OR SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AccountGroup_60000() -- Прибыль будущих периодов
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0

                                     OR SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AccountGroup_60000()
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0

                                     OR SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                   AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                  ELSE 0
                                              END) <> 0
                                     OR SUM (CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                   AND MIContainer.isActive = FALSE
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                              END) <> 0

                                        -- ***REMAINS***
                                      OR CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count() AND (tmpContainer_Count.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE) THEN tmpContainer_Count.Amount - COALESCE (SUM (MIContainer.Amount), 0) ELSE 0 END <> 0
                                      OR CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Count() AND (tmpContainer_Count.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE) THEN tmpContainer_Count.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END)) ELSE 0 END <> 0

                                      OR CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ() AND (tmpContainer_Count.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE) THEN tmpContainer_Count.Amount - COALESCE (SUM (MIContainer.Amount), 0) ELSE 0 END <> 0
                                      OR CASE WHEN tmpContainer_Count.ContainerDescId = zc_Container_Summ() AND (tmpContainer_Count.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE) THEN tmpContainer_Count.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END)) ELSE 0 END <> 0
                                 )

   SELECT View_Account.AccountGroupName, View_Account.AccountDirectionName
        , View_Account.AccountId, View_Account.AccountCode, View_Account.AccountName, View_Account.AccountName_all
        , ObjectDesc.ItemName            AS LocationDescName
        , CAST (COALESCE(Object_Location.Id, 0) AS Integer)             AS LocationId
        , Object_Location.ObjectCode     AS LocationCode
        , CAST (COALESCE(Object_Location.ValueData,'') AS TVarChar)     AS LocationName
        , Object_Car.ObjectCode          AS CarCode
        , Object_Car.ValueData           AS CarName
        , Object_GoodsGroup.ValueData    AS GoodsGroupName
        , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
        , CAST (COALESCE(Object_Goods.Id, 0) AS Integer)                 AS GoodsId
        , Object_Goods.ObjectCode        AS GoodsCode
        , CAST (COALESCE(Object_Goods.ValueData, '') AS TVarChar)        AS GoodsName
        , CAST (COALESCE(Object_GoodsKind.Id, 0) AS Integer)             AS GoodsKindId
        , CAST (COALESCE(Object_GoodsKind.ValueData, '') AS TVarChar)    AS GoodsKindName
        , Object_Measure.ValueData       AS MeasureName
        , ObjectFloat_Weight.ValueData   AS Weight
        , CAST (COALESCE(Object_PartionGoods.Id, 0) AS Integer)           AS PartionGoodsId
        , CAST (COALESCE(Object_PartionGoods.ValueData,'') AS TVarChar)  AS PartionGoodsName
        , Object_AssetTo.ValueData       AS AssetToName

        , CAST (tmpMIContainer_group.CountStart          AS TFloat) AS CountStart
        , CAST (tmpMIContainer_group.CountStart * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END          AS TFloat) AS CountStart_Weight
        , CAST (tmpMIContainer_group.CountEnd            AS TFloat) AS CountEnd
        , CAST (tmpMIContainer_group.CountEnd * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END            AS TFloat) AS CountEnd_Weight

        , CAST (tmpMIContainer_group.CountIncome         AS TFloat) AS CountIncome
        , CAST (tmpMIContainer_group.CountIncome * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END         AS TFloat) AS CountIncome_Weight
        , CAST (tmpMIContainer_group.CountReturnOut      AS TFloat) AS CountReturnOut
        , CAST (tmpMIContainer_group.CountReturnOut * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END      AS TFloat) AS CountReturnOut_Weight

        , CAST (tmpMIContainer_group.CountSendIn         AS TFloat) AS CountSendIn
        , CAST (tmpMIContainer_group.CountSendIn * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END         AS TFloat) AS CountSendIn_Weight
        , CAST (tmpMIContainer_group.CountSendOut        AS TFloat) AS CountSendOut
        , CAST (tmpMIContainer_group.CountSendOut * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END        AS TFloat) AS CountSendOut_Weight

        , CAST (tmpMIContainer_group.CountSendOnPriceIn  AS TFloat) AS CountSendOnPriceIn
        , CAST (tmpMIContainer_group.CountSendOnPriceIn * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END  AS TFloat) AS CountSendOnPriceIn_Weight
        , CAST (tmpMIContainer_group.CountSendOnPriceOut AS TFloat) AS CountSendOnPriceOut
        , CAST (tmpMIContainer_group.CountSendOnPriceOut * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END AS TFloat) AS CountSendOnPriceOut_Weight

        , CAST (tmpMIContainer_group.CountSale           AS TFloat) AS CountSale
        , CAST (tmpMIContainer_group.CountSale * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END           AS TFloat) AS CountSale_Weight
        , CAST (tmpMIContainer_group.CountSale_10500     AS TFloat) AS CountSale_10500
        , CAST (tmpMIContainer_group.CountSale_10500 * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END     AS TFloat) AS CountSale_10500_Weight
        , CAST (tmpMIContainer_group.CountSale_40208     AS TFloat) AS CountSale_40208
        , CAST (tmpMIContainer_group.CountSale_40208 * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END     AS TFloat) AS CountSale_40208_Weight

        , CAST (tmpMIContainer_group.CountReturnIn       AS TFloat) AS CountReturnIn
        , CAST (tmpMIContainer_group.CountReturnIn * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END       AS TFloat) AS CountReturnIn_Weight
        , CAST (tmpMIContainer_group.CountReturnIn_40208 AS TFloat) AS CountReturnIn_40208
        , CAST (tmpMIContainer_group.CountReturnIn_40208 * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END AS TFloat) AS CountReturnIn_40208_Weight

        , CAST (tmpMIContainer_group.CountLoss           AS TFloat) AS CountLoss
        , CAST (tmpMIContainer_group.CountLoss * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END           AS TFloat) AS CountLoss_Weight
        , CAST (tmpMIContainer_group.CountInventory      AS TFloat) AS CountInventory
        , CAST (tmpMIContainer_group.CountInventory * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END      AS TFloat) AS CountInventory_Weight

        , CAST (tmpMIContainer_group.CountProductionIn   AS TFloat) AS CountProductionIn
        , CAST (tmpMIContainer_group.CountProductionIn * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END   AS TFloat) AS CountProductionIn_Weight
        , CAST (tmpMIContainer_group.CountProductionOut  AS TFloat) AS CountProductionOut
        , CAST (tmpMIContainer_group.CountProductionOut * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END  AS TFloat) AS CountProductionOut_Weight

        , CAST (tmpMIContainer_group.CountTotalIn        AS TFloat) AS CountTotalIn
        , CAST (tmpMIContainer_group.CountTotalIn * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END        AS TFloat) AS CountTotalIn_Weight
        , CAST (tmpMIContainer_group.CountTotalOut       AS TFloat) AS CountTotalOut
        , CAST (tmpMIContainer_group.CountTotalOut * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END       AS TFloat) AS CountTotalOut_Weight

        , CAST (tmpMIContainer_group.SummStart            AS TFloat) AS SummStart
        , CAST (tmpMIContainer_group.SummEnd              AS TFloat) AS SummEnd
        , CAST (tmpMIContainer_group.SummIncome           AS TFloat) AS SummIncome
        , CAST (tmpMIContainer_group.SummReturnOut        AS TFloat) AS SummReturnOut
        , CAST (tmpMIContainer_group.SummSendIn           AS TFloat) AS SummSendIn
        , CAST (tmpMIContainer_group.SummSendOut          AS TFloat) AS SummSendOut
        , CAST (tmpMIContainer_group.SummSendOnPriceIn    AS TFloat) AS SummSendOnPriceIn
        , CAST (tmpMIContainer_group.SummSendOnPriceOut   AS TFloat) AS SummSendOnPriceOut
        , CAST (tmpMIContainer_group.SummSale             AS TFloat) AS SummSale
        , CAST (tmpMIContainer_group.SummSale_10500       AS TFloat) AS SummSale_10500
        , CAST (tmpMIContainer_group.SummSale_40208       AS TFloat) AS SummSale_40208
        , CAST (tmpMIContainer_group.SummReturnIn         AS TFloat) AS SummReturnIn
        , CAST (tmpMIContainer_group.SummReturnIn_40208   AS TFloat) AS SummReturnIn_40208
        , CAST (tmpMIContainer_group.SummLoss             AS TFloat) AS SummLoss
        , CAST (tmpMIContainer_group.SummInventory        AS TFloat) AS SummInventory
        , CAST (tmpMIContainer_group.SummInventory_RePrice AS TFloat) AS SummInventory_RePrice
        , CAST (tmpMIContainer_group.SummProductionIn     AS TFloat) AS SummProductionIn
        , CAST (tmpMIContainer_group.SummProductionOut    AS TFloat) AS SummProductionOut
        , CAST (tmpMIContainer_group.SummTotalIn          AS TFloat) AS SummTotalIn
        , CAST (tmpMIContainer_group.SummTotalOut         AS TFloat) AS SummTotalOut

        , CAST (CASE WHEN tmpMIContainer_group.CountStart <> 0
                          THEN tmpMIContainer_group.SummStart / tmpMIContainer_group.CountStart
                     ELSE 0
                END AS TFloat) AS PriceStart
        , CAST (CASE WHEN tmpMIContainer_group.CountEnd <> 0
                          THEN tmpMIContainer_group.SummEnd / tmpMIContainer_group.CountEnd
                     ELSE 0
                END AS TFloat) AS PriceEnd

        , CAST (CASE WHEN tmpMIContainer_group.CountIncome <> 0
                          THEN tmpMIContainer_group.SummIncome / tmpMIContainer_group.CountIncome
                     ELSE 0
                END AS TFloat) AS PriceIncome
        , CAST (CASE WHEN tmpMIContainer_group.CountReturnOut <> 0
                          THEN tmpMIContainer_group.SummReturnOut / tmpMIContainer_group.CountReturnOut
                     ELSE 0
                END AS TFloat) AS PriceReturnOut

        , CAST (CASE WHEN tmpMIContainer_group.CountSendIn <> 0
                          THEN tmpMIContainer_group.SummSendIn / tmpMIContainer_group.CountSendIn
                     ELSE 0
                END AS TFloat) AS PriceSendIn
        , CAST (CASE WHEN tmpMIContainer_group.CountSendOut <> 0
                          THEN tmpMIContainer_group.SummSendOut / tmpMIContainer_group.CountSendOut
                     ELSE 0
                END AS TFloat) AS PriceSendOut

        , CAST (CASE WHEN tmpMIContainer_group.CountSendOnPriceIn <> 0
                          THEN tmpMIContainer_group.SummSendOnPriceIn / tmpMIContainer_group.CountSendOnPriceIn
                     ELSE 0
                END AS TFloat) AS PriceSendOnPriceIn
        , CAST (CASE WHEN tmpMIContainer_group.CountSendOnPriceOut <> 0
                          THEN tmpMIContainer_group.SummSendOnPriceOut / tmpMIContainer_group.CountSendOnPriceOut
                     ELSE 0
                END AS TFloat) AS PriceSendOnPriceOut

        , CAST (CASE WHEN tmpMIContainer_group.CountSale <> 0
                          THEN tmpMIContainer_group.SummSale / tmpMIContainer_group.CountSale
                     ELSE 0
                END AS TFloat) AS PriceSale
        , CAST (CASE WHEN tmpMIContainer_group.CountReturnIn <> 0
                          THEN tmpMIContainer_group.SummReturnIn / tmpMIContainer_group.CountReturnIn
                     ELSE 0
                END AS TFloat) AS PriceReturnIn

        , CAST (CASE WHEN tmpMIContainer_group.CountLoss <> 0
                          THEN tmpMIContainer_group.SummLoss / tmpMIContainer_group.CountLoss
                     ELSE 0
                END AS TFloat) AS PriceLoss
        , CAST (CASE WHEN tmpMIContainer_group.CountInventory <> 0
                          THEN tmpMIContainer_group.SummInventory / tmpMIContainer_group.CountInventory
                     ELSE 0
                END AS TFloat) AS PriceInventory
        , CAST (CASE WHEN tmpMIContainer_group.CountProductionIn <> 0
                          THEN tmpMIContainer_group.SummProductionIn / tmpMIContainer_group.CountProductionIn
                     ELSE 0
                END AS TFloat) AS PriceProductionIn
        , CAST (CASE WHEN tmpMIContainer_group.CountProductionOut <> 0
                          THEN tmpMIContainer_group.SummProductionOut / tmpMIContainer_group.CountProductionOut
                     ELSE 0
                END AS TFloat) AS PriceProductionOut

        , CAST (CASE WHEN tmpMIContainer_group.CountTotalIn <> 0
                          THEN tmpMIContainer_group.SummTotalIn / tmpMIContainer_group.CountTotalIn
                     ELSE 0
                END AS TFloat) AS PriceTotalIn
        , CAST (CASE WHEN tmpMIContainer_group.CountTotalOut <> 0
                          THEN tmpMIContainer_group.SummTotalOut / tmpMIContainer_group.CountTotalOut
                     ELSE 0
                END AS TFloat) AS PriceTotalOut

        , COALESCE (tmpPriceStart_kind.Price,tmpPriceStart.Price) AS PriceListStart
        , COALESCE (tmpPriceEnd_kind.Price, tmpPriceEnd.Price)   AS PriceListEnd

        , View_InfoMoney.InfoMoneyId
        , View_InfoMoney.InfoMoneyCode
        , View_InfoMoney.InfoMoneyGroupName
        , View_InfoMoney.InfoMoneyDestinationName
        , View_InfoMoney.InfoMoneyName
        , View_InfoMoney.InfoMoneyName_all

        , View_InfoMoneyDetail.InfoMoneyId              AS InfoMoneyId_Detail
        , View_InfoMoneyDetail.InfoMoneyCode            AS InfoMoneyCode_Detail
        , View_InfoMoneyDetail.InfoMoneyGroupName       AS InfoMoneyGroupName_Detail
        , View_InfoMoneyDetail.InfoMoneyDestinationName AS InfoMoneyDestinationName_Detail
        , View_InfoMoneyDetail.InfoMoneyName            AS InfoMoneyName_Detail
        , View_InfoMoneyDetail.InfoMoneyName_all        AS InfoMoneyName_all_Detail

        , tmpMIContainer_group.ContainerId_Summ
        , CAST (row_number() OVER () AS INTEGER)        AS LineNum

      FROM
        (SELECT (tmpMIContainer_all.AccountId) AS AccountId
              , tmpMIContainer_all.ContainerId_Summ
              , tmpMIContainer_all.LocationId
              , tmpMIContainer_all.GoodsId
              , tmpMIContainer_all.GoodsKindId
              , tmpMIContainer_all.PartionGoodsId
              , tmpMIContainer_all.AssetToId
              , SUM (tmpMIContainer_all.CountStart)          AS CountStart
              , SUM (tmpMIContainer_all.CountEnd)            AS CountEnd

              , SUM (tmpMIContainer_all.CountIncome)         AS CountIncome
              , SUM (tmpMIContainer_all.CountReturnOut)      AS CountReturnOut

              , SUM (tmpMIContainer_all.CountSendIn)         AS CountSendIn
              , SUM (tmpMIContainer_all.CountSendOut)        AS CountSendOut

              , SUM (tmpMIContainer_all.CountSendOnPriceIn)  AS CountSendOnPriceIn
              , SUM (tmpMIContainer_all.CountSendOnPriceOut) AS CountSendOnPriceOut

              , SUM (tmpMIContainer_all.CountSale)           AS CountSale
              , SUM (tmpMIContainer_all.CountSale_10500)     AS CountSale_10500
              , SUM (tmpMIContainer_all.CountSale_40208)     AS CountSale_40208

              , SUM (tmpMIContainer_all.CountReturnIn)       AS CountReturnIn
              , SUM (tmpMIContainer_all.CountReturnIn_40208) AS CountReturnIn_40208

              , SUM (tmpMIContainer_all.CountLoss)           AS CountLoss
              , SUM (tmpMIContainer_all.CountInventory)      AS CountInventory

              , SUM (tmpMIContainer_all.CountProductionIn)   AS CountProductionIn
              , SUM (tmpMIContainer_all.CountProductionOut)  AS CountProductionOut

              , SUM (tmpMIContainer_all.CountIncome
                   + tmpMIContainer_all.CountSendIn
                   + tmpMIContainer_all.CountSendOnPriceIn
                   + tmpMIContainer_all.CountReturnIn
                   + tmpMIContainer_all.CountReturnIn_40208
                   + tmpMIContainer_all.CountProductionIn)   AS CountTotalIn
              , SUM (tmpMIContainer_all.CountReturnOut
                   + tmpMIContainer_all.CountSendOut
                   + tmpMIContainer_all.CountSendOnPriceOut
                   + tmpMIContainer_all.CountSale
                   + tmpMIContainer_all.CountSale_10500
                   - tmpMIContainer_all.CountSale_40208
                   + tmpMIContainer_all.CountLoss
                   + tmpMIContainer_all.CountProductionOut)  AS CountTotalOut

              , SUM (tmpMIContainer_all.SummStart)           AS SummStart
              , SUM (tmpMIContainer_all.SummEnd)             AS SummEnd
              , SUM (tmpMIContainer_all.SummIncome)          AS SummIncome
              , SUM (tmpMIContainer_all.SummReturnOut)       AS SummReturnOut
              , SUM (tmpMIContainer_all.SummSendIn)          AS SummSendIn
              , SUM (tmpMIContainer_all.SummSendOut)         AS SummSendOut
              , SUM (tmpMIContainer_all.SummSendOnPriceIn)   AS SummSendOnPriceIn
              , SUM (tmpMIContainer_all.SummSendOnPriceOut)  AS SummSendOnPriceOut
              , SUM (tmpMIContainer_all.SummSale)            AS SummSale
              , SUM (tmpMIContainer_all.SummSale_10500)      AS SummSale_10500
              , SUM (tmpMIContainer_all.SummSale_40208)      AS SummSale_40208
              , SUM (tmpMIContainer_all.SummReturnIn)        AS SummReturnIn
              , SUM (tmpMIContainer_all.SummReturnIn_40208)  AS SummReturnIn_40208
              , SUM (tmpMIContainer_all.SummLoss)            AS SummLoss
              , SUM (tmpMIContainer_all.SummInventory)       AS SummInventory
              , SUM (tmpMIContainer_all.SummInventory_RePrice) AS SummInventory_RePrice
              , SUM (tmpMIContainer_all.SummProductionIn)    AS SummProductionIn
              , SUM (tmpMIContainer_all.SummProductionOut)   AS SummProductionOut

              , SUM (tmpMIContainer_all.SummIncome
                   + tmpMIContainer_all.SummSendIn
                   + tmpMIContainer_all.SummSendOnPriceIn
                   + tmpMIContainer_all.SummReturnIn
                   + tmpMIContainer_all.SummReturnIn_40208
                   + tmpMIContainer_all.SummProductionIn)    AS SummTotalIn
              , SUM (tmpMIContainer_all.SummReturnOut
                   + tmpMIContainer_all.SummSendOut
                   + tmpMIContainer_all.SummSendOnPriceOut
                   + tmpMIContainer_all.SummSale
                   + tmpMIContainer_all.SummSale_10500
                   - tmpMIContainer_all.SummSale_40208
                   + tmpMIContainer_all.SummLoss
                   + tmpMIContainer_all.SummProductionOut)   AS SummTotalOut

        FROM (SELECT tmpMIContainer_Count.ContainerId_count AS ContainerId
                   , tmpMIContainer_Count.ContainerId_begin AS ContainerId_Summ
                   , tmpMIContainer_Count.AccountId
                   , tmpMIContainer_Count.LocationId
                   , tmpMIContainer_Count.GoodsId
                   , tmpMIContainer_Count.GoodsKindId
                   , tmpMIContainer_Count.PartionGoodsId
                   , tmpMIContainer_Count.AssetToId

                   , CASE WHEN inIsInfoMoney = FALSE AND tmpMIContainer_Count.AccountGroupId = zc_Enum_AccountGroup_60000() THEN 0 ELSE COALESCE (tmpMIContainer_Count.CountStart, 0) END AS CountStart
                   , CASE WHEN inIsInfoMoney = FALSE AND tmpMIContainer_Count.AccountGroupId = zc_Enum_AccountGroup_60000() THEN 0 ELSE COALESCE (tmpMIContainer_Count.CountEnd, 0) END AS CountEnd
                   , CASE WHEN inIsInfoMoney = FALSE AND tmpMIContainer_Count.AccountGroupId = zc_Enum_AccountGroup_60000() THEN 0 ELSE COALESCE (tmpMIContainer_Count.CountIncome, 0) END AS CountIncome
                   , CASE WHEN inIsInfoMoney = FALSE AND tmpMIContainer_Count.AccountGroupId = zc_Enum_AccountGroup_60000() THEN 0 ELSE COALESCE (tmpMIContainer_Count.CountReturnOut, 0) END AS CountReturnOut
                   , CASE WHEN inIsInfoMoney = FALSE AND tmpMIContainer_Count.AccountGroupId = zc_Enum_AccountGroup_60000() THEN 0 ELSE COALESCE (tmpMIContainer_Count.CountSendIn, 0) END AS CountSendIn
                   , CASE WHEN inIsInfoMoney = FALSE AND tmpMIContainer_Count.AccountGroupId = zc_Enum_AccountGroup_60000() THEN 0 ELSE COALESCE (tmpMIContainer_Count.CountSendOut, 0) END AS CountSendOut
                   , CASE WHEN inIsInfoMoney = FALSE AND tmpMIContainer_Count.AccountGroupId = zc_Enum_AccountGroup_60000() THEN 0 ELSE COALESCE (tmpMIContainer_Count.CountSendOnPriceIn, 0) END AS CountSendOnPriceIn
                   , CASE WHEN inIsInfoMoney = FALSE AND tmpMIContainer_Count.AccountGroupId = zc_Enum_AccountGroup_60000() THEN 0 ELSE COALESCE (tmpMIContainer_Count.CountSendOnPriceOut, 0) END AS CountSendOnPriceOut
                   , CASE WHEN inIsInfoMoney = FALSE AND tmpMIContainer_Count.AccountGroupId = zc_Enum_AccountGroup_60000() THEN 0 ELSE COALESCE (tmpMIContainer_Count.CountSale, 0) END AS CountSale
                   , CASE WHEN inIsInfoMoney = FALSE AND tmpMIContainer_Count.AccountGroupId = zc_Enum_AccountGroup_60000() THEN 0 ELSE COALESCE (tmpMIContainer_Count.CountSale_10500, 0) END AS CountSale_10500
                   , CASE WHEN inIsInfoMoney = FALSE AND tmpMIContainer_Count.AccountGroupId = zc_Enum_AccountGroup_60000() THEN 0 ELSE COALESCE (tmpMIContainer_Count.CountSale_40208, 0) END AS CountSale_40208
                   , CASE WHEN inIsInfoMoney = FALSE AND tmpMIContainer_Count.AccountGroupId = zc_Enum_AccountGroup_60000() THEN 0 ELSE COALESCE (tmpMIContainer_Count.CountReturnIn, 0) END AS CountReturnIn
                   , CASE WHEN inIsInfoMoney = FALSE AND tmpMIContainer_Count.AccountGroupId = zc_Enum_AccountGroup_60000() THEN 0 ELSE COALESCE (tmpMIContainer_Count.CountReturnIn_40208, 0) END AS CountReturnIn_40208
                   , CASE WHEN inIsInfoMoney = FALSE AND tmpMIContainer_Count.AccountGroupId = zc_Enum_AccountGroup_60000() THEN 0 ELSE COALESCE (tmpMIContainer_Count.CountLoss, 0) END AS CountLoss
                   , CASE WHEN inIsInfoMoney = FALSE AND tmpMIContainer_Count.AccountGroupId = zc_Enum_AccountGroup_60000() THEN 0 ELSE COALESCE (tmpMIContainer_Count.CountInventory, 0) END AS CountInventory
                   , CASE WHEN inIsInfoMoney = FALSE AND tmpMIContainer_Count.AccountGroupId = zc_Enum_AccountGroup_60000() THEN 0 ELSE COALESCE (tmpMIContainer_Count.CountProductionIn, 0) END AS CountProductionIn
                   , CASE WHEN inIsInfoMoney = FALSE AND tmpMIContainer_Count.AccountGroupId = zc_Enum_AccountGroup_60000() THEN 0 ELSE COALESCE (tmpMIContainer_Count.CountProductionOut, 0) END AS CountProductionOut

                   , COALESCE (tmpMIContainer_Count.SummStart, 0) AS SummStart
                   , COALESCE (tmpMIContainer_Count.SummEnd, 0) AS SummEnd
                   , COALESCE (tmpMIContainer_Count.SummIncome, 0) AS SummIncome
                   , COALESCE (tmpMIContainer_Count.SummReturnOut, 0) AS SummReturnOut
                   , COALESCE (tmpMIContainer_Count.SummSendIn, 0) AS SummSendIn
                   , COALESCE (tmpMIContainer_Count.SummSendOut, 0) AS SummSendOut
                   , COALESCE (tmpMIContainer_Count.SummSendOnPriceIn, 0) AS SummSendOnPriceIn
                   , COALESCE (tmpMIContainer_Count.SummSendOnPriceOut, 0) AS SummSendOnPriceOut
                   , COALESCE (tmpMIContainer_Count.SummSale, 0) AS SummSale
                   , COALESCE (tmpMIContainer_Count.SummSale_10500, 0) AS SummSale_10500
                   , COALESCE (tmpMIContainer_Count.SummSale_40208, 0) AS SummSale_40208
                   , COALESCE (tmpMIContainer_Count.SummReturnIn, 0) AS SummReturnIn
                   , COALESCE (tmpMIContainer_Count.SummReturnIn_40208, 0) AS SummReturnIn_40208
                   , COALESCE (tmpMIContainer_Count.SummLoss, 0) AS SummLoss
                   , COALESCE (tmpMIContainer_Count.SummInventory, 0) AS SummInventory
                   , COALESCE (tmpMIContainer_Count.SummInventory_RePrice, 0) AS SummInventory_RePrice
                   , COALESCE (tmpMIContainer_Count.SummProductionIn, 0) AS SummProductionIn
                   , COALESCE (tmpMIContainer_Count.SummProductionOut, 0) AS SummProductionOut
              FROM tmpMIContainer_Count

             ) AS tmpMIContainer_all
         GROUP BY tmpMIContainer_all.ContainerId
                , tmpMIContainer_all.ContainerId_Summ
                , tmpMIContainer_all.AccountId
                , tmpMIContainer_all.LocationId
                , tmpMIContainer_all.GoodsId
                , tmpMIContainer_all.GoodsKindId
                , tmpMIContainer_all.PartionGoodsId
                , tmpMIContainer_all.AssetToId
        ) AS tmpMIContainer_group

        LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                      ON CLO_InfoMoney.ContainerId = tmpMIContainer_group.ContainerId_Summ
                                     AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
        LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = CLO_InfoMoney.ObjectId
        LEFT JOIN ContainerLinkObject AS CLO_InfoMoneyDetail
                                      ON CLO_InfoMoneyDetail.ContainerId = tmpMIContainer_group.ContainerId_Summ
                                     AND CLO_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
        LEFT JOIN Object_InfoMoney_View AS View_InfoMoneyDetail ON View_InfoMoneyDetail.InfoMoneyId = CLO_InfoMoneyDetail.ObjectId

        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMIContainer_group.GoodsId
        LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMIContainer_group.GoodsKindId
        LEFT JOIN Object AS Object_Location_find ON Object_Location_find.Id = tmpMIContainer_group.LocationId
        LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Location_find.DescId
        LEFT JOIN ObjectLink AS ObjectLink_Car_Unit ON ObjectLink_Car_Unit.ObjectId = tmpMIContainer_group.LocationId
                                                   AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
        LEFT JOIN Object AS Object_Location ON Object_Location.Id = CASE WHEN Object_Location_find.DescId = zc_Object_Car() THEN ObjectLink_Car_Unit.ChildObjectId ELSE tmpMIContainer_group.LocationId END
        LEFT JOIN Object AS Object_Car ON Object_Car.Id = CASE WHEN Object_Location_find.DescId = zc_Object_Car() THEN tmpMIContainer_group.LocationId END

        LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                             ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                            AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
        LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                                        AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
        LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

        LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                               ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                              AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()
        LEFT JOIN ObjectFloat AS ObjectFloat_Weight ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                             AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

        LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpMIContainer_group.PartionGoodsId
        LEFT JOIN Object AS Object_AssetTo ON Object_AssetTo.Id = tmpMIContainer_group.AssetToId

        LEFT JOIN Object_Account_View AS View_Account ON View_Account.AccountId = tmpMIContainer_group.AccountId

        -- привязываем цены 2 раза по виду товара и без
        LEFT JOIN tmpPriceStart ON tmpPriceStart.GoodsId = tmpMIContainer_group.GoodsId
                               AND tmpPriceStart.GoodsKindId IS NULL
        LEFT JOIN tmpPriceStart AS tmpPriceStart_kind
                                ON tmpPriceStart_kind.GoodsId = tmpMIContainer_group.GoodsId
                               AND COALESCE (tmpPriceStart_kind.GoodsKindId,0) = COALESCE (tmpMIContainer_group.GoodsKindId, 0)

        LEFT JOIN tmpPriceEnd ON tmpPriceEnd.GoodsId = tmpMIContainer_group.GoodsId
                             AND tmpPriceEnd.GoodsKindId IS NULL
        LEFT JOIN tmpPriceEnd AS tmpPriceEnd_kind
                              ON tmpPriceEnd_kind.GoodsId = tmpMIContainer_group.GoodsId
                             AND COALESCE (tmpPriceEnd_kind.GoodsKindId,0) = COALESCE (tmpMIContainer_group.GoodsKindId, 0)
      ;

         -- !!!!!!!!!!!!!!!!!!!!!!!
         -- !!!финиш!!! ЕСЛИ <= 300
         -- !!!!!!!!!!!!!!!!!!!!!!!

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_MotionGoods_NEW (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 12.12.19         *
 15.02.15                                        * add zc_Enum_AnalyzerId_Loss...
 01.02.15                                                       *
 14.11.14                                                       * add LineNum
 23.10.14                                        * add inAccountGroupId and inIsInfoMoney
 23.08.14                                        * add Account...
 12.08.14                                        * add ContainerId
 01.06.14                                        * ALL
 31.08.13         *
*/

-- тест
-- SELECT * FROM gpReport_MotionGoods_NEW (inStartDate:= '01.01.2015', inEndDate:= '01.01.2015', inAccountGroupId:= 0, inUnitGroupId:= 0, inLocationId:= 0, inGoodsGroupId:= 0, inGoodsId:= 0, inUnitGroupId_by:=0, inLocationId_by:= 0, inIsInfoMoney:= FALSE, inSession:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM gpReport_MotionGoods_NEW (inStartDate:= '01.06.2018', inEndDate:= '30.06.2018', inAccountGroupId:= 0, inUnitGroupId := 8459 , inLocationId := 0 , inGoodsGroupId := 1860 , inGoodsId := 0 , inUnitGroupId_by:=0, inLocationId_by:= 0, inIsInfoMoney:= TRUE, inSession := zfCalc_UserAdmin() :: Integer);
