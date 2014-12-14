-- Function: gpReport_MotionGoods()

DROP FUNCTION IF EXISTS gpReport_MotionGoods (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_MotionGoods(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inAccountGroupId     Integer,    --
    IN inUnitGroupId        Integer,    -- группа подразделений на самом деле это подразделение
    IN inLocationId         Integer,    --
    IN inGoodsGroupId       Integer,    -- группа товара
    IN inGoodsId            Integer,    -- товар
    IN inIsInfoMoney        Boolean,    --
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (AccountGroupName TVarChar, AccountDirectionName TVarChar
             , AccountCode Integer, AccountName TVarChar, AccountName_All TVarChar
             , LocationDescName TVarChar, LocationCode Integer, LocationName TVarChar
             , CarCode Integer, CarName TVarChar
             , GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar, MeasureName TVarChar
             , Weight TFloat
             , PartionGoodsName TVarChar, AssetToName TVarChar

             , CountStart TFloat
             , CountEnd TFloat
             , CountIncome TFloat
             , CountReturnOut TFloat
             , CountSendIn TFloat
             , CountSendOut TFloat
             , CountSendOnPriceIn TFloat
             , CountSendOnPriceOut TFloat
             , CountSale TFloat
             , CountSale_10500 TFloat
             , CountSale_40208 TFloat
             , CountReturnIn TFloat
             , CountReturnIn_40208 TFloat
             , CountLoss TFloat
             , CountInventory TFloat
             , CountProductionIn TFloat
             , CountProductionOut TFloat
             , CountTotalIn TFloat
             , CountTotalOut TFloat

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

             , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , InfoMoneyCode_Detail Integer, InfoMoneyGroupName_Detail TVarChar, InfoMoneyDestinationName_Detail TVarChar, InfoMoneyName_Detail TVarChar, InfoMoneyName_all_Detail TVarChar

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

   -- !!!меняются параметры для филиала!!!
   IF 0 < (SELECT BranchId FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND BranchId <> 0)
   THEN
       inAccountGroupId:= zc_Enum_AccountGroup_20000(); -- Запасы
       inIsInfoMoney:= FALSE;
   END IF;

    -- таблица -
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpLocation (LocationId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpContainer_Count (ContainerId Integer, LocationId Integer, GoodsId Integer, GoodsKindId Integer, PartionGoodsId Integer, AssetToId Integer, Amount TFloat) ON COMMIT DROP;


    IF inGoodsGroupId <> 0
    THEN
        INSERT INTO _tmpGoods (GoodsId)
           SELECT GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup;
    ELSE IF inGoodsId <> 0
         THEN
             INSERT INTO _tmpGoods (GoodsId)
              SELECT inGoodsId;
         ELSE
             INSERT INTO _tmpGoods (GoodsId)
              SELECT Id FROM Object WHERE DescId = zc_Object_Goods() AND (inUnitGroupId <> 0 OR inLocationId <> 0)
             UNION
              SELECT Id FROM Object WHERE DescId = zc_Object_Fuel() AND (inUnitGroupId <> 0 OR inLocationId <> 0);
         END IF;
    END IF;

    IF inUnitGroupId <> 0
    THEN
        INSERT INTO _tmpLocation (LocationId)
           SELECT UnitId FROM lfSelect_Object_Unit_byGroup (inUnitGroupId) AS lfSelect_Object_Unit_byGroup;
    ELSE
        IF inLocationId <> 0
        THEN
            INSERT INTO _tmpLocation (LocationId)
               SELECT inLocationId;
        ELSE
            WITH tmpBranch AS (SELECT TRUE AS Value WHERE NOT EXISTS (SELECT BranchId FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND BranchId <> 0))
            INSERT INTO _tmpLocation (LocationId)
               SELECT Id FROM Object INNER JOIN tmpBranch ON tmpBranch.Value = TRUE WHERE DescId = zc_Object_Unit()
              UNION ALL
               SELECT Id FROM Object INNER JOIN tmpBranch ON tmpBranch.Value = TRUE WHERE DescId = zc_Object_Member()
              UNION ALL
               SELECT Id FROM Object INNER JOIN tmpBranch ON tmpBranch.Value = TRUE WHERE DescId = zc_Object_Car();
        END IF;
    END IF;


           WITH tmpLocation AS (SELECT COALESCE (CLO_Unit.ContainerId, COALESCE (CLO_Car.ContainerId, COALESCE (CLO_Member.ContainerId, 0))) AS ContainerId
                                     , _tmpLocation.LocationId
                                FROM _tmpLocation
                                     LEFT JOIN ContainerLinkObject AS CLO_Unit ON CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                                              AND CLO_Unit.ObjectId = _tmpLocation.LocationId
                                     LEFT JOIN ContainerLinkObject AS CLO_Car ON CLO_Car.DescId = zc_ContainerLinkObject_Car()
                                                                             AND CLO_Car.ObjectId = _tmpLocation.LocationId
                                     LEFT JOIN ContainerLinkObject AS CLO_Member ON CLO_Member.DescId = zc_ContainerLinkObject_Member()
                                                                                AND CLO_Member.ObjectId = _tmpLocation.LocationId
                                WHERE COALESCE (CLO_Unit.ContainerId, COALESCE (CLO_Car.ContainerId, COALESCE (CLO_Member.ContainerId, 0))) > 0
                                GROUP BY COALESCE (CLO_Unit.ContainerId, COALESCE (CLO_Car.ContainerId, COALESCE (CLO_Member.ContainerId, 0)))
                                       , _tmpLocation.LocationId
                               )
      , tmpContainer_Count2 AS (SELECT Container.*, tmpLocation.LocationId
                                FROM _tmpGoods AS tmpGoods
                                     INNER JOIN Container ON Container.ObjectId = tmpGoods.GoodsId
                                                         AND Container.DescId = zc_Container_Count()
                                     INNER JOIN tmpLocation ON tmpLocation.ContainerId = Container.Id
                               )
       , tmpContainer_Count AS (SELECT Container.Id AS ContainerId
                                     , Container.LocationId
                                     , Container.ObjectId AS GoodsId
                                     , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
                                     , COALESCE (CLO_PartionGoods.ObjectId, 0) AS PartionGoodsId
                                     , COALESCE (CLO_AssetTo.ObjectId, 0) AS AssetToId
                                     , Container.Amount
                                FROM tmpContainer_Count2 AS Container
                                     LEFT JOIN ContainerLinkObject AS CLO_GoodsKind ON CLO_GoodsKind.ContainerId = Container.Id
                                                                                   AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                     LEFT JOIN ContainerLinkObject AS CLO_PartionGoods ON CLO_PartionGoods.ContainerId = Container.Id
                                                                                      AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                                     LEFT JOIN ContainerLinkObject AS CLO_AssetTo ON CLO_AssetTo.ContainerId = Container.Id
                                                                                 AND CLO_AssetTo.DescId = zc_ContainerLinkObject_AssetTo()
                               )
           INSERT INTO _tmpContainer_Count (ContainerId, LocationId, GoodsId, GoodsKindId, PartionGoodsId, AssetToId, Amount)
             SELECT ContainerId, LocationId, GoodsId, GoodsKindId, PartionGoodsId, AssetToId, Amount FROM tmpContainer_Count;
/*
     IF (SELECT COUNT(*) FROM _tmpContainer_Count) <= 300
     THEN
  */

    -- !!!!!!!!!!!!!!!!!!!!!!!
    ANALYZE _tmpContainer_Count;

         -- !!!!!!!!!!!!!!!!!!!!!!!
         -- !!!старт!!! ЕСЛИ <= 300
         -- !!!!!!!!!!!!!!!!!!!!!!!
      RETURN QUERY
    WITH tmpMIContainer_Count AS (SELECT tmpContainer_Count.ContainerId
                                       , tmpContainer_Count.LocationId
                                       , tmpContainer_Count.GoodsId
                                       , tmpContainer_Count.GoodsKindId
                                       , tmpContainer_Count.PartionGoodsId
                                       , tmpContainer_Count.AssetToId
                                       , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Income()
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS Amount_Income
                                       , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnOut()
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS Amount_ReturnOut

                                       , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Send()
                                                    AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS Amount_SendIn
                                       , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Send()
                                                    AND MIContainer.isActive = FALSE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS Amount_SendOut

                                       , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                    AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS Amount_SendOnPriceIn
                                       , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                    AND MIContainer.isActive = FALSE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS Amount_SendOnPriceOut

                                       , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_ProfitLossDirection_10400() -- Себестоимость реализации
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS Amount_Sale
                                       , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_ProfitLossDirection_10500() -- Скидка за вес
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS Amount_Sale_10500
                                       , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_ProfitLossDirection_40200() -- Содержание филиалов (Разница в весе)
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS Amount_Sale_40208

                                       , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND MIContainer.AnalyzerId = zc_Enum_ProfitLossDirection_10800() -- Себестоимость возвратов
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS Amount_ReturnIn
                                       , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND MIContainer.AnalyzerId = zc_Enum_ProfitLossDirection_40200() -- Содержание филиалов (Разница в весе)
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS Amount_ReturnIn_40208

                                       , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Loss()
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS Amount_Loss
                                       , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS Amount_Inventory
                                       , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                    AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS Amount_ProductionIn
                                       , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                    AND MIContainer.isActive = FALSE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS Amount_ProductionOut

                                       , tmpContainer_Count.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS Amount_Start
                                       , tmpContainer_Count.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END)) AS Amount_End
                                  FROM _tmpContainer_Count AS tmpContainer_Count
                                       LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = tmpContainer_Count.ContainerId
                                                                                     AND MIContainer.OperDate >= inStartDate
                                       /*LEFT JOIN MovementItemFloat AS MIFloat_AmountChangePercent ON MIFloat_AmountChangePercent.MovementItemId = MIContainer.MovementItemId
                                                                                                 AND MIFloat_AmountChangePercent.DescId = zc_MIFloat_AmountChangePercent()
                                       LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner ON MIFloat_AmountPartner.MovementItemId = MIContainer.MovementItemId
                                                                                           AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()*/
                                  GROUP BY tmpContainer_Count.ContainerId
                                         , tmpContainer_Count.LocationId
                                         , tmpContainer_Count.GoodsId
                                         , tmpContainer_Count.GoodsKindId
                                         , tmpContainer_Count.PartionGoodsId
                                         , tmpContainer_Count.AssetToId
                                         , tmpContainer_Count.Amount
                                 )
       , tmpAccount AS (SELECT View_Account.AccountId FROM Object_Account_View AS View_Account WHERE View_Account.AccountGroupId = inAccountGroupId OR COALESCE (inAccountGroupId, 0) = 0)
       , tmpContainer_Summ AS (SELECT tmpContainer_Count.ContainerId AS ContainerId_Count
                                    , tmpContainer_Count.LocationId
                                    , tmpContainer_Count.GoodsId
                                    , tmpContainer_Count.GoodsKindId
                                    , tmpContainer_Count.PartionGoodsId
                                    , tmpContainer_Count.AssetToId
                                    , Container.Id                         AS ContainerId_Summ
                                    , Container.ObjectId                   AS AccountId
                                    , Container.Amount
                               FROM _tmpContainer_Count AS tmpContainer_Count
                                    INNER JOIN Container ON Container.ParentId = tmpContainer_Count.ContainerId
                                                        AND Container.DescId = zc_Container_Summ()
                                    INNER JOIN tmpAccount ON tmpAccount.AccountId = Container.ObjectId
                              )
       , tmpMIContainer_Summ AS (SELECT tmpContainer_Summ.ContainerId_Count
                                      , CASE WHEN inIsInfoMoney = TRUE THEN tmpContainer_Summ.ContainerId_Summ ELSE 0 END AS ContainerId_Summ
                                      , tmpContainer_Summ.AccountId
                                      , tmpContainer_Summ.LocationId
                                      , tmpContainer_Summ.GoodsId
                                      , tmpContainer_Summ.GoodsKindId
                                      , tmpContainer_Summ.PartionGoodsId
                                      , tmpContainer_Summ.AssetToId
                                      , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Income()
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS Amount_Income
                                      , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnOut()
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS Amount_ReturnOut

                                      , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Send()
                                                   AND MIContainer.isActive = TRUE
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS Amount_SendIn
                                      , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Send()
                                                   AND MIContainer.isActive = FALSE
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS Amount_SendOut

                                      , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                   /*AND (MIContainer.isActive = TRUE
                                                     OR MovementBoolean_HistoryCost.ValueData = TRUE)*/
                                                   AND MovementBoolean_HistoryCost.ValueData = TRUE
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS Amount_SendOnPriceIn
                                      , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                   /*AND NOT (MIContainer.isActive = TRUE
                                                     OR MovementBoolean_HistoryCost.ValueData = TRUE)*/
                                                   AND COALESCE (MovementBoolean_HistoryCost.ValueData, FALSE) = FALSE
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS Amount_SendOnPriceOut

                                      , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                   AND MIContainer.AnalyzerId = zc_Enum_ProfitLossDirection_10400() -- Себестоимость реализации
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS Amount_Sale
                                      , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                   AND MIContainer.AnalyzerId = zc_Enum_ProfitLossDirection_10500() -- Скидка за вес
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS Amount_Sale_10500
                                      , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_ProfitLossDirection_40200() -- Содержание филиалов (Разница в весе)
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS Amount_Sale_40208

                                      , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                   AND MIContainer.AnalyzerId = zc_Enum_ProfitLossDirection_10800() -- Себестоимость возвратов
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS Amount_ReturnIn
                                      , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                   AND MIContainer.AnalyzerId = zc_Enum_ProfitLossDirection_40200() -- Содержание филиалов (Разница в весе)
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS Amount_ReturnIn_40208

                                      , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Loss()
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS Amount_Loss

                                      , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AccountGroup_60000() -- Прибыль будущих периодов
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS Amount_Inventory

                                      , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AccountGroup_60000()
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS Amount_Inventory_RePrice

                                      , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                   AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                  ELSE 0
                                              END) AS Amount_ProductionIn
                                      , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                   AND MIContainer.isActive = FALSE
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                              END) AS Amount_ProductionOut

                                       , tmpContainer_Summ.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS Amount_Start
                                       , tmpContainer_Summ.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END)) AS Amount_End
                                 FROM tmpContainer_Summ
                                      LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = tmpContainer_Summ.ContainerId_Summ
                                                                                    AND MIContainer.OperDate >= inStartDate
                                      /*LEFT JOIN MovementItemReport AS MIContainer ON MIContainer.ReportContainerId = tmpContainer_Summ.ReportContainerId
                                                                                 AND MIContainer.OperDate >= inStartDate*/
                                      LEFT JOIN MovementBoolean AS MovementBoolean_HistoryCost
                                                                ON MovementBoolean_HistoryCost.MovementId = MIContainer.MovementId
                                                               AND MovementBoolean_HistoryCost.DescId = zc_MovementBoolean_HistoryCost()
                                 GROUP BY tmpContainer_Summ.ContainerId_Count
                                        , CASE WHEN inIsInfoMoney = TRUE THEN tmpContainer_Summ.ContainerId_Summ ELSE 0 END
                                        , tmpContainer_Summ.AccountId
                                        , tmpContainer_Summ.LocationId
                                        , tmpContainer_Summ.GoodsId
                                        , tmpContainer_Summ.GoodsKindId
                                        , tmpContainer_Summ.PartionGoodsId
                                        , tmpContainer_Summ.AssetToId
                                        , tmpContainer_Summ.Amount
                                )

   SELECT View_Account.AccountGroupName, View_Account.AccountDirectionName
        , View_Account.AccountCode, View_Account.AccountName, View_Account.AccountName_all
        , ObjectDesc.ItemName            AS LocationDescName
        , Object_Location.ObjectCode     AS LocationCode
        , Object_Location.ValueData      AS LocationName
        , Object_Car.ObjectCode          AS CarCode
        , Object_Car.ValueData           AS CarName
        , Object_GoodsGroup.ValueData    AS GoodsGroupName
        , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
        , Object_Goods.ObjectCode        AS GoodsCode
        , Object_Goods.ValueData         AS GoodsName
        , Object_GoodsKind.ValueData     AS GoodsKindName
        , Object_Measure.ValueData       AS MeasureName
        , ObjectFloat_Weight.ValueData   AS Weight
        , Object_PartionGoods.ValueData  AS PartionGoodsName
        , Object_AssetTo.ValueData       AS AssetToName

        , CAST (tmpMIContainer_group.CountStart          AS TFloat) AS CountStart
        , CAST (tmpMIContainer_group.CountEnd            AS TFloat) AS CountEnd
        , CAST (tmpMIContainer_group.CountIncome         AS TFloat) AS CountIncome
        , CAST (tmpMIContainer_group.CountReturnOut      AS TFloat) AS CountReturnOut
        , CAST (tmpMIContainer_group.CountSendIn         AS TFloat) AS CountSendIn
        , CAST (tmpMIContainer_group.CountSendOut        AS TFloat) AS CountSendOut
        , CAST (tmpMIContainer_group.CountSendOnPriceIn  AS TFloat) AS CountSendOnPriceIn
        , CAST (tmpMIContainer_group.CountSendOnPriceOut AS TFloat) AS CountSendOnPriceOut
        , CAST (tmpMIContainer_group.CountSale           AS TFloat) AS CountSale
        , CAST (tmpMIContainer_group.CountSale_10500     AS TFloat) AS CountSale_10500
        , CAST (tmpMIContainer_group.CountSale_40208     AS TFloat) AS CountSale_40208
        , CAST (tmpMIContainer_group.CountReturnIn       AS TFloat) AS CountReturnIn
        , CAST (tmpMIContainer_group.CountReturnIn_40208 AS TFloat) AS CountReturnIn_40208
        , CAST (tmpMIContainer_group.CountLoss           AS TFloat) AS CountLoss
        , CAST (tmpMIContainer_group.CountInventory      AS TFloat) AS CountInventory
        , CAST (tmpMIContainer_group.CountProductionIn   AS TFloat) AS CountProductionIn
        , CAST (tmpMIContainer_group.CountProductionOut  AS TFloat) AS CountProductionOut
        , CAST (tmpMIContainer_group.CountTotalIn        AS TFloat) AS CountTotalIn
        , CAST (tmpMIContainer_group.CountTotalOut       AS TFloat) AS CountTotalOut

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

        , View_InfoMoney.InfoMoneyCode
        , View_InfoMoney.InfoMoneyGroupName
        , View_InfoMoney.InfoMoneyDestinationName
        , View_InfoMoney.InfoMoneyName
        , View_InfoMoney.InfoMoneyName_all

        , View_InfoMoneyDetail.InfoMoneyCode AS InfoMoneyCode_Detail
        , View_InfoMoneyDetail.InfoMoneyGroupName AS InfoMoneyGroupName_Detail
        , View_InfoMoneyDetail.InfoMoneyDestinationName AS InfoMoneyDestinationName_Detail
        , View_InfoMoneyDetail.InfoMoneyName AS InfoMoneyName_Detail
        , View_InfoMoneyDetail.InfoMoneyName_all AS InfoMoneyName_all_Detail

        , tmpMIContainer_group.ContainerId_Summ
        , CAST (row_number() OVER () AS INTEGER) AS LineNum

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
                   - tmpMIContainer_all.CountReturnIn_40208
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
                   - tmpMIContainer_all.SummReturnIn_40208
                   + tmpMIContainer_all.SummProductionIn)    AS SummTotalIn
              , SUM (tmpMIContainer_all.SummReturnOut
                   + tmpMIContainer_all.SummSendOut
                   + tmpMIContainer_all.SummSendOnPriceOut
                   + tmpMIContainer_all.SummSale
                   + tmpMIContainer_all.SummSale_10500
                   - tmpMIContainer_all.SummSale_40208
                   + tmpMIContainer_all.SummLoss
                   + tmpMIContainer_all.SummProductionOut)   AS SummTotalOut

        FROM (SELECT COALESCE (tmpMIContainer_Summ.ContainerId, tmpMIContainer_Count.ContainerId) AS ContainerId
                   , COALESCE (tmpMIContainer_Summ.ContainerId_Summ, CASE WHEN inIsInfoMoney = TRUE THEN tmpMIContainer_Count.ContainerId ELSE 0 END) AS ContainerId_Summ
                   , COALESCE (tmpMIContainer_Summ.AccountId, 0) AS AccountId
                   , COALESCE (tmpMIContainer_Summ.LocationId, tmpMIContainer_Count.LocationId) AS LocationId
                   , COALESCE (tmpMIContainer_Summ.GoodsId, tmpMIContainer_Count.GoodsId) AS GoodsId
                   , COALESCE (tmpMIContainer_Summ.GoodsKindId, tmpMIContainer_Count.GoodsKindId) AS GoodsKindId
                   , COALESCE (tmpMIContainer_Summ.PartionGoodsId, tmpMIContainer_Count.PartionGoodsId) AS PartionGoodsId
                   , COALESCE (tmpMIContainer_Summ.AssetToId, tmpMIContainer_Count.AssetToId) AS AssetToId

                   , COALESCE (tmpMIContainer_Count.CountStart, 0) AS CountStart
                   , COALESCE (tmpMIContainer_Count.CountEnd, 0) AS CountEnd
                   , COALESCE (tmpMIContainer_Count.CountIncome, 0) AS CountIncome
                   , COALESCE (tmpMIContainer_Count.CountReturnOut, 0) AS CountReturnOut
                   , COALESCE (tmpMIContainer_Count.CountSendIn, 0) AS CountSendIn
                   , COALESCE (tmpMIContainer_Count.CountSendOut, 0) AS CountSendOut
                   , COALESCE (tmpMIContainer_Count.CountSendOnPriceIn, 0) AS CountSendOnPriceIn
                   , COALESCE (tmpMIContainer_Count.CountSendOnPriceOut, 0) AS CountSendOnPriceOut
                   , COALESCE (tmpMIContainer_Count.CountSale, 0) AS CountSale
                   , COALESCE (tmpMIContainer_Count.CountSale_10500, 0) AS CountSale_10500
                   , COALESCE (tmpMIContainer_Count.CountSale_40208, 0) AS CountSale_40208
                   , COALESCE (tmpMIContainer_Count.CountReturnIn, 0) AS CountReturnIn
                   , COALESCE (tmpMIContainer_Count.CountReturnIn_40208, 0) AS CountReturnIn_40208
                   , COALESCE (tmpMIContainer_Count.CountLoss, 0) AS CountLoss
                   , COALESCE (tmpMIContainer_Count.CountInventory, 0) AS CountInventory
                   , COALESCE (tmpMIContainer_Count.CountProductionIn, 0) AS CountProductionIn
                   , COALESCE (tmpMIContainer_Count.CountProductionOut, 0) AS CountProductionOut

                   , COALESCE (tmpMIContainer_Summ.SummStart, 0) AS SummStart
                   , COALESCE (tmpMIContainer_Summ.SummEnd, 0) AS SummEnd
                   , COALESCE (tmpMIContainer_Summ.SummIncome, 0) AS SummIncome
                   , COALESCE (tmpMIContainer_Summ.SummReturnOut, 0) AS SummReturnOut
                   , COALESCE (tmpMIContainer_Summ.SummSendIn, 0) AS SummSendIn
                   , COALESCE (tmpMIContainer_Summ.SummSendOut, 0) AS SummSendOut
                   , COALESCE (tmpMIContainer_Summ.SummSendOnPriceIn, 0) AS SummSendOnPriceIn
                   , COALESCE (tmpMIContainer_Summ.SummSendOnPriceOut, 0) AS SummSendOnPriceOut
                   , COALESCE (tmpMIContainer_Summ.SummSale, 0) AS SummSale
                   , COALESCE (tmpMIContainer_Summ.SummSale_10500, 0) AS SummSale_10500
                   , COALESCE (tmpMIContainer_Summ.SummSale_40208, 0) AS SummSale_40208
                   , COALESCE (tmpMIContainer_Summ.SummReturnIn, 0) AS SummReturnIn
                   , COALESCE (tmpMIContainer_Summ.SummReturnIn_40208, 0) AS SummReturnIn_40208
                   , COALESCE (tmpMIContainer_Summ.SummLoss, 0) AS SummLoss
                   , COALESCE (tmpMIContainer_Summ.SummInventory, 0) AS SummInventory
                   , COALESCE (tmpMIContainer_Summ.SummInventory_RePrice, 0) AS SummInventory_RePrice
                   , COALESCE (tmpMIContainer_Summ.SummProductionIn, 0) AS SummProductionIn
                   , COALESCE (tmpMIContainer_Summ.SummProductionOut, 0) AS SummProductionOut
              FROM
             (SELECT tmpMIContainer_Count.ContainerId
                   , 0 AS AccountId
                   , tmpMIContainer_Count.LocationId
                   , tmpMIContainer_Count.GoodsId
                   , tmpMIContainer_Count.GoodsKindId
                   , tmpMIContainer_Count.PartionGoodsId
                   , tmpMIContainer_Count.AssetToId

                   , tmpMIContainer_Count.Amount_Start          AS CountStart
                   , tmpMIContainer_Count.Amount_End            AS CountEnd
                   , tmpMIContainer_Count.Amount_Income         AS CountIncome
                   , tmpMIContainer_Count.Amount_ReturnOut      AS CountReturnOut
                   , tmpMIContainer_Count.Amount_SendIn         AS CountSendIn
                   , tmpMIContainer_Count.Amount_SendOut        AS CountSendOut
                   , tmpMIContainer_Count.Amount_SendOnPriceIn  AS CountSendOnPriceIn
                   , tmpMIContainer_Count.Amount_SendOnPriceOut AS CountSendOnPriceOut
                   , tmpMIContainer_Count.Amount_Sale           AS CountSale
                   , tmpMIContainer_Count.Amount_Sale_10500     AS CountSale_10500
                   , tmpMIContainer_Count.Amount_Sale_40208     AS CountSale_40208
                   , tmpMIContainer_Count.Amount_ReturnIn       AS CountReturnIn
                   , tmpMIContainer_Count.Amount_ReturnIn_40208 AS CountReturnIn_40208
                   , tmpMIContainer_Count.Amount_Loss           AS CountLoss
                   , tmpMIContainer_Count.Amount_Inventory      AS CountInventory
                   , tmpMIContainer_Count.Amount_ProductionIn   AS CountProductionIn
                   , tmpMIContainer_Count.Amount_ProductionOut  AS CountProductionOut
              FROM tmpMIContainer_Count
              WHERE tmpMIContainer_Count.Amount_Start          <> 0
                 OR tmpMIContainer_Count.Amount_End            <> 0
                 OR tmpMIContainer_Count.Amount_Income         <> 0
                 OR tmpMIContainer_Count.Amount_ReturnOut      <> 0
                 OR tmpMIContainer_Count.Amount_SendIn         <> 0
                 OR tmpMIContainer_Count.Amount_SendOut        <> 0
                 OR tmpMIContainer_Count.Amount_SendOnPriceIn  <> 0
                 OR tmpMIContainer_Count.Amount_SendOnPriceOut <> 0
                 OR tmpMIContainer_Count.Amount_Sale           <> 0
                 OR tmpMIContainer_Count.Amount_Sale_10500     <> 0
                 OR tmpMIContainer_Count.Amount_Sale_40208     <> 0
                 OR tmpMIContainer_Count.Amount_ReturnIn       <> 0
                 OR tmpMIContainer_Count.Amount_ReturnIn_40208 <> 0
                 OR tmpMIContainer_Count.Amount_Loss           <> 0
                 OR tmpMIContainer_Count.Amount_Inventory      <> 0
                 OR tmpMIContainer_Count.Amount_ProductionIn   <> 0
                 OR tmpMIContainer_Count.Amount_ProductionOut  <> 0
             ) AS tmpMIContainer_Count
               FULL JOIN
             (SELECT tmpMIContainer_Summ.ContainerId_Count AS ContainerId
                   , tmpMIContainer_Summ.ContainerId_Summ
                   , tmpMIContainer_Summ.AccountId
                   , tmpMIContainer_Summ.LocationId
                   , tmpMIContainer_Summ.GoodsId
                   , tmpMIContainer_Summ.GoodsKindId
                   , tmpMIContainer_Summ.PartionGoodsId
                   , tmpMIContainer_Summ.AssetToId

                   , SUM (tmpMIContainer_Summ.Amount_Start)             AS SummStart
                   , SUM (tmpMIContainer_Summ.Amount_End)               AS SummEnd
                   , SUM (tmpMIContainer_Summ.Amount_Income)            AS SummIncome
                   , SUM (tmpMIContainer_Summ.Amount_ReturnOut)         AS SummReturnOut
                   , SUM (tmpMIContainer_Summ.Amount_SendIn)            AS SummSendIn
                   , SUM (tmpMIContainer_Summ.Amount_SendOut)           AS SummSendOut
                   , SUM (tmpMIContainer_Summ.Amount_SendOnPriceIn)     AS SummSendOnPriceIn
                   , SUM (tmpMIContainer_Summ.Amount_SendOnPriceOut)    AS SummSendOnPriceOut
                   , SUM (tmpMIContainer_Summ.Amount_Sale)              AS SummSale
                   , SUM (tmpMIContainer_Summ.Amount_Sale_10500)        AS SummSale_10500
                   , SUM (tmpMIContainer_Summ.Amount_Sale_40208)        AS SummSale_40208
                   , SUM (tmpMIContainer_Summ.Amount_ReturnIn)          AS SummReturnIn
                   , SUM (tmpMIContainer_Summ.Amount_ReturnIn_40208)    AS SummReturnIn_40208
                   , SUM (tmpMIContainer_Summ.Amount_Loss)              AS SummLoss
                   , SUM (tmpMIContainer_Summ.Amount_Inventory)         AS SummInventory
                   , SUM (tmpMIContainer_Summ.Amount_Inventory_RePrice) AS SummInventory_RePrice
                   , SUM (tmpMIContainer_Summ.Amount_ProductionIn)      AS SummProductionIn
                   , SUM (tmpMIContainer_Summ.Amount_ProductionOut)     AS SummProductionOut
              FROM tmpMIContainer_Summ
              WHERE tmpMIContainer_Summ.Amount_Start          <> 0
                 OR tmpMIContainer_Summ.Amount_End            <> 0
                 OR tmpMIContainer_Summ.Amount_Income         <> 0
                 OR tmpMIContainer_Summ.Amount_ReturnOut      <> 0
                 OR tmpMIContainer_Summ.Amount_SendIn         <> 0
                 OR tmpMIContainer_Summ.Amount_SendOut        <> 0
                 OR tmpMIContainer_Summ.Amount_SendOnPriceIn  <> 0
                 OR tmpMIContainer_Summ.Amount_SendOnPriceOut <> 0
                 OR tmpMIContainer_Summ.Amount_Sale           <> 0
                 OR tmpMIContainer_Summ.Amount_Sale_10500     <> 0
                 OR tmpMIContainer_Summ.Amount_Sale_40208     <> 0
                 OR tmpMIContainer_Summ.Amount_ReturnIn       <> 0
                 OR tmpMIContainer_Summ.Amount_ReturnIn_40208 <> 0
                 OR tmpMIContainer_Summ.Amount_Loss           <> 0
                 OR tmpMIContainer_Summ.Amount_Inventory      <> 0
                 OR tmpMIContainer_Summ.Amount_Inventory_RePrice <> 0
                 OR tmpMIContainer_Summ.Amount_ProductionIn   <> 0
                 OR tmpMIContainer_Summ.Amount_ProductionOut  <> 0
              GROUP BY tmpMIContainer_Summ.ContainerId_Count
                     , tmpMIContainer_Summ.ContainerId_Summ
                     , tmpMIContainer_Summ.AccountId
                     , tmpMIContainer_Summ.LocationId
                     , tmpMIContainer_Summ.GoodsId
                     , tmpMIContainer_Summ.GoodsKindId
                     , tmpMIContainer_Summ.PartionGoodsId
                     , tmpMIContainer_Summ.AssetToId
             ) AS tmpMIContainer_Summ ON tmpMIContainer_Summ.ContainerId = tmpMIContainer_Count.ContainerId

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
      ;

         -- !!!!!!!!!!!!!!!!!!!!!!!
         -- !!!финиш!!! ЕСЛИ <= 300
         -- !!!!!!!!!!!!!!!!!!!!!!!

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_MotionGoods (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 14.11.14                                                       * add LineNum
 23.10.14                                        * add inAccountGroupId and inIsInfoMoney
 23.08.14                                        * add Account...
 12.08.14                                        * add ContainerId
 01.06.14                                        * ALL
 31.08.13         *
*/

-- тест
-- SELECT * FROM gpReport_MotionGoods (inStartDate:= '01.01.2014', inEndDate:= '01.01.2014', inAccountGroupId:= 0, inUnitGroupId:= 0, inLocationId:= 0, inGoodsGroupId:= 0, inGoodsId:= 0, inIsInfoMoney:= FALSE, inSession:= '2')
-- SELECT * from gpReport_MotionGoods (inStartDate:= '01.06.2014', inEndDate:= '30.06.2014', inAccountGroupId:= 0, inUnitGroupId := 8459 , inLocationId := 0 , inGoodsGroupId := 1860 , inGoodsId := 0 ,  inIsInfoMoney:= TRUE, inSession := '5');
