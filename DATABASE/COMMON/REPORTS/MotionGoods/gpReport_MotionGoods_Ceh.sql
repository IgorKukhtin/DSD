-- Function: gpReport_MotionGoods_Ceh()

DROP FUNCTION IF EXISTS gpReport_MotionGoods_Ceh (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_MotionGoods_Ceh(
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
             , GoodsGroupId Integer, GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsKindId Integer, GoodsKindName TVarChar, GoodsKindName_complete TVarChar, MeasureName TVarChar
             , Weight TFloat, WeightTare TFloat
             , PartionGoodsId Integer, PartionGoodsName TVarChar, AssetToName TVarChar

             , CountStart TFloat
             , CountStart_Weight TFloat
             , CountEnd TFloat
             , CountEnd_Weight TFloat
             , CountEnd_calc TFloat
             , CountEnd_calc_Weight TFloat

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

             , CountSendOnPrice_10500 TFloat
             , CountSendOnPrice_10500_Weight TFloat
             , CountSendOnPrice_40200 TFloat
             , CountSendOnPrice_40200_Weight TFloat

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
             , SummEnd_calc TFloat
             , SummIncome TFloat
             , SummReturnOut TFloat
             , SummSendIn TFloat
             , SummSendOut TFloat
             , SummSendOnPriceIn TFloat
             , SummSendOnPriceOut TFloat
             , SummSendOnPrice_10500  TFloat
             , SummSendOnPrice_40200  TFloat
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

             , CountProductionIn_by TFloat        -- приход с произв. (если с другого подр., т.е. не пересорт)
             , CountProductionIn_by_Weight TFloat --
             , SummProductionIn_by TFloat         -- приход с произв. (если с другого подр., т.е. не пересорт)

             , CountIn_by TFloat                  -- приход с "выбранного" подр1.
             , CountIn_by_Weight TFloat           --
             , SummIn_by TFloat                   -- приход с "выбранного" подр1.
    
             , CountOtherIn_by TFloat             -- приход другой
             , CountOtherIn_by_Weight TFloat      --
             , SummOtherIn_by TFloat              -- приход другой

             , CountOut_by TFloat             -- расход на "выбранное" подр1.
             , CountOut_by_Weight TFloat      --
             , SummOut_by TFloat              -- расход на "выбранное" подр1.
 
             , CountOtherOut_by TFloat        -- расход другой
             , CountOtherOut_by_Weight TFloat --
             , SummOtherOut_by TFloat         -- расход другой

             , CountProductionOut_Norm TFloat        -- Расход с произв. норма
             , SummProductionOut_Norm  TFloat        -- Расход с произв. норма
          
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , InfoMoneyId_Detail Integer, InfoMoneyCode_Detail Integer, InfoMoneyGroupName_Detail TVarChar, InfoMoneyDestinationName_Detail TVarChar, InfoMoneyName_Detail TVarChar, InfoMoneyName_all_Detail TVarChar

             , ContainerId_Summ Integer
             , LineNum Integer

              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsSummIn Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Report_MotionGoods());
    vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    -- !!!определяется!!!
    vbIsSummIn:= NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE UserId = vbUserId AND RoleId = 442647)  -- Отчеты руководитель сырья
             AND NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE UserId = vbUserId AND RoleId = 5708947) -- Отчеты руководитель производство
                 -- Ограничение просмотра с/с
             AND NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE AccessKeyId = zc_Enum_Process_AccessKey_NotCost() AND UserId = vbUserId)
            ;

    -- таблица -
    CREATE TEMP TABLE _tmpLocation (LocationId Integer, DescId Integer, ContainerDescId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpLocation_by (LocationId Integer) ON COMMIT DROP;
    -- таблица -
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer) ON COMMIT DROP;

    -- товары
    IF inGoodsGroupId <> 0 AND COALESCE (inGoodsId, 0) = 0
    THEN
        INSERT INTO _tmpGoods (GoodsId, InfoMoneyDestinationId, InfoMoneyId)
          SELECT lfObject.GoodsId, 0, 0 FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject;
    ELSE IF inGoodsId <> 0
         THEN
             INSERT INTO _tmpGoods (GoodsId, InfoMoneyDestinationId, InfoMoneyId)
               SELECT inGoodsId, 0, 0;
         END IF;
   END IF;
   --
   UPDATE _tmpGoods SET InfoMoneyDestinationId = View_InfoMoney.InfoMoneyDestinationId
                      , InfoMoneyId            = ObjectLink_Goods_InfoMoney.ChildObjectId
   FROM ObjectLink AS ObjectLink_Goods_InfoMoney
        LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
   WHERE ObjectLink_Goods_InfoMoney.ObjectId = _tmpGoods.GoodsId
     AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
     ;


    -- группа подразделений или подразделение или место учета (МО, Авто)
    IF inUnitGroupId <> 0 AND COALESCE (inLocationId, 0) = 0
    THEN
        INSERT INTO _tmpLocation (LocationId, DescId, ContainerDescId)
           SELECT lfSelect_Object_Unit_byGroup.UnitId AS LocationId
                , zc_ContainerLinkObject_Unit()       AS DescId
                , tmpDesc.ContainerDescId
           FROM lfSelect_Object_Unit_byGroup (inUnitGroupId) AS lfSelect_Object_Unit_byGroup
                LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId UNION SELECT zc_Container_Summ() AS ContainerDescId WHERE vbIsSummIn = TRUE) AS tmpDesc ON 1 = 1
          ;
    ELSE
        IF inLocationId <> 0
        THEN
            INSERT INTO _tmpLocation (LocationId, DescId, ContainerDescId)
               SELECT Object.Id AS LocationId
                    , CASE WHEN Object.DescId = zc_Object_Unit()   THEN zc_ContainerLinkObject_Unit() 
                           WHEN Object.DescId = zc_Object_Car()    THEN zc_ContainerLinkObject_Car() 
                           WHEN Object.DescId = zc_Object_Member() THEN zc_ContainerLinkObject_Member()
                      END AS DescId
                    , tmpDesc.ContainerDescId
               FROM Object
                    -- LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId) AS tmpDesc ON 1 = 1 -- !!!временно без с/с, для скорости!!!
                    LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId UNION SELECT zc_Container_Summ() AS ContainerDescId WHERE vbIsSummIn = TRUE) AS tmpDesc ON 1 = 1
               WHERE Object.Id = inLocationId
             /*UNION
               SELECT lfSelect.UnitId               AS LocationId
                    , zc_ContainerLinkObject_Unit() AS DescId
                    , tmpDesc.ContainerDescId
               FROM lfSelect_Object_Unit_byGroup (inLocationId) AS lfSelect
                    -- LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId) AS tmpDesc ON 1 = 1 -- !!!временно без с/с, для скорости!!!
                    LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId UNION SELECT zc_Container_Summ() AS ContainerDescId WHERE vbIsSummIn = TRUE) AS tmpDesc ON 1 = 1*/
              ;
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


    -- группа подразделений или подразделение ...by
    INSERT INTO _tmpLocation_by (LocationId)                 
            SELECT lfSelect_Object_Unit_byGroup.UnitId AS LocationId
            FROM lfSelect_Object_Unit_byGroup (8439) AS lfSelect_Object_Unit_byGroup        -- "Участок мясного сырья" и все в него входящее
           UNION
            SELECT lfSelect_Object_Unit_byGroup.UnitId AS LocationId
            FROM lfSelect_Object_Unit_byGroup (8455) AS lfSelect_Object_Unit_byGroup        -- "Склад специй"
    ;


    -- !!!!!!!!!!!!!!!!!!!!!!!
    ANALYZE _tmpLocation_by;


    -- Результат
    RETURN QUERY
    WITH tmpReport AS (SELECT * FROM lpReport_MotionGoods (inStartDate:= inStartDate, inEndDate:= inEndDate, inAccountGroupId:= inAccountGroupId, inUnitGroupId:= inUnitGroupId, inLocationId:= inLocationId, inGoodsGroupId:= inGoodsGroupId, inGoodsId:= inGoodsId, inIsInfoMoney:= FALSE, inUserId:= vbUserId))

    , tmpLocation AS (SELECT _tmpLocation.LocationId FROM _tmpLocation GROUP BY _tmpLocation.LocationId)

    , tmpMIContainer_GP AS (-- Приход с производства ГП
                            SELECT MIContainer.AnalyzerId                           AS LocationId
                                 , MIContainer.ObjectId_Analyzer                    AS GoodsId
                                 , COALESCE (MILinkObject_Receipt.ObjectId, 0)      AS ReceiptId
                                 , COALESCE (MIBoolean_TaxExit.ValueData, TRUE)     AS isTaxExit
                                 , SUM (MIContainer.Amount)                         AS OperCount
                                 , SUM (COALESCE (MIFloat_CuterCount.ValueData, 0)) AS CuterCount
                            FROM tmpLocation
                                 INNER JOIN MovementItemContainer AS MIContainer ON MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                                                AND MIContainer.DescId                 = zc_MIContainer_Count()
                                                                                -- AND MIContainer.WhereObjectId_Analyzer = _tmpLocation.LocationId
                                                                                AND MIContainer.AnalyzerId             = tmpLocation.LocationId
                                                                                AND MIContainer.MovementDescId         = zc_Movement_ProductionUnion()
                                                                                AND MIContainer.isActive               = TRUE
                                 LEFT JOIN MovementItemBoolean AS MIBoolean_TaxExit
                                                               ON MIBoolean_TaxExit.MovementItemId = MIContainer.MovementItemId
                                                              AND MIBoolean_TaxExit.DescId = zc_MIBoolean_TaxExit()
                                 LEFT JOIN MovementItemFloat AS MIFloat_CuterCount
                                                             ON MIFloat_CuterCount.MovementItemId = MIContainer.MovementItemId
                                                            AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount()
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Receipt
                                                                  ON MILinkObject_Receipt.MovementItemId = MIContainer.MovementItemId
                                                                 AND MILinkObject_Receipt.DescId = zc_MILinkObject_Receipt()
                                 LEFT JOIN MovementBoolean AS MovementBoolean_Peresort
                                                           ON MovementBoolean_Peresort.MovementId = MIContainer.MovementId
                                                          AND MovementBoolean_Peresort.DescId     = zc_MovementBoolean_Peresort()
                                                          AND MovementBoolean_Peresort.ValueData  = TRUE
                            -- !!!убрали Пересортицу!!!
                            WHERE MovementBoolean_Peresort.MovementId IS NULL
                            GROUP BY MIContainer.AnalyzerId
                                   , MIContainer.ObjectId_Analyzer
                                   , COALESCE (MILinkObject_Receipt.ObjectId, 0)
                                   , COALESCE (MIBoolean_TaxExit.ValueData, TRUE)
                           )
        , tmpOut_norm AS (-- 
                          SELECT tmpMIContainer_GP.LocationId
                               , COALESCE (ObjectLink_ReceiptChild_Goods.ChildObjectId, 0)     AS GoodsId
                               , CASE WHEN _tmpGoods.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- Общефирменные + Ирна
                                                                              , zc_Enum_InfoMoneyDestination_30100()  -- Доходы + Продукция
                                                                              , zc_Enum_InfoMoneyDestination_30200()  -- Доходы + Мясное сырье
                                                                               )
                                           THEN COALESCE (ObjectLink_ReceiptChild_GoodsKind.ChildObjectId, 0)

                                      WHEN _tmpGoods.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
                                       AND _tmpGoods.InfoMoneyId NOT IN (zc_Enum_InfoMoney_10105()  -- Прочее мясное сырье
                                                                       , zc_Enum_InfoMoney_10106()  -- Сыр
                                                                        )
                                       AND ObjectLink_ReceiptChild_GoodsKind.ChildObjectId <> zc_GoodsKind_Basis()
                                           THEN COALESCE (ObjectLink_ReceiptChild_GoodsKind.ChildObjectId, 0)

                                      ELSE 0

                                 END AS GoodsKindId
                               , SUM (CASE WHEN tmpMIContainer_GP.CuterCount <> 0 AND tmpMIContainer_GP.isTaxExit = TRUE
                                                THEN tmpMIContainer_GP.CuterCount * COALESCE (ObjectFloat_Value.ValueData, 0)
                                           WHEN ObjectFloat_Value_master.ValueData <> 0
                                                THEN tmpMIContainer_GP.OperCount * COALESCE (ObjectFloat_Value.ValueData, 0) / ObjectFloat_Value_master.ValueData
                                           ELSE 0
                                      END) AS OperCount
                          FROM tmpMIContainer_GP
                              LEFT JOIN ObjectFloat AS ObjectFloat_Value_master
                                                    ON ObjectFloat_Value_master.ObjectId = tmpMIContainer_GP.ReceiptId
                                                   AND ObjectFloat_Value_master.DescId = zc_ObjectFloat_Receipt_Value()
                              LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                                                   ON ObjectLink_ReceiptChild_Receipt.ChildObjectId = ObjectFloat_Value_master.ObjectId
                                                  AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()
                              LEFT JOIN Object AS Object_ReceiptChild ON Object_ReceiptChild.Id = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                                     AND Object_ReceiptChild.isErased = FALSE
                              LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                                   ON ObjectLink_ReceiptChild_Goods.ObjectId = Object_ReceiptChild.Id
                                                  AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
                              LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_GoodsKind
                                                   ON ObjectLink_ReceiptChild_GoodsKind.ObjectId = Object_ReceiptChild.Id
                                                  AND ObjectLink_ReceiptChild_GoodsKind.DescId = zc_ObjectLink_ReceiptChild_GoodsKind()
                              LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                    ON ObjectFloat_Value.ObjectId = Object_ReceiptChild.Id
                                                   AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()
                              LEFT JOIN _tmpGoods ON _tmpGoods.GoodsId = ObjectLink_ReceiptChild_Goods.ChildObjectId

                          WHERE _tmpGoods.GoodsId > 0 OR (COALESCE (inGoodsGroupId, 0) = 0 AND COALESCE (inGoodsId, 0) = 0)

                          GROUP BY tmpMIContainer_GP.LocationId
                                 , COALESCE (ObjectLink_ReceiptChild_Goods.ChildObjectId, 0)
                                 , CASE WHEN _tmpGoods.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- Общефирменные + Ирна
                                                                                , zc_Enum_InfoMoneyDestination_30100()  -- Доходы + Продукция
                                                                                , zc_Enum_InfoMoneyDestination_30200()  -- Доходы + Мясное сырье
                                                                                 )
                                             THEN COALESCE (ObjectLink_ReceiptChild_GoodsKind.ChildObjectId, 0)

                                        WHEN _tmpGoods.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
                                         AND _tmpGoods.InfoMoneyId NOT IN (zc_Enum_InfoMoney_10105()  -- Прочее мясное сырье
                                                                         , zc_Enum_InfoMoney_10106()  -- Сыр
                                                                          )
                                         AND ObjectLink_ReceiptChild_GoodsKind.ChildObjectId <> zc_GoodsKind_Basis()
                                             THEN COALESCE (ObjectLink_ReceiptChild_GoodsKind.ChildObjectId, 0)

                                        ELSE 0
                                   END
                          HAVING SUM (CASE WHEN ObjectFloat_Value_master.ValueData <> 0 THEN tmpMIContainer_GP.OperCount * COALESCE (ObjectFloat_Value.ValueData, 0) / ObjectFloat_Value_master.ValueData ELSE 0 END) <> 0
                         )

   -- Результат
   SELECT View_Account.AccountGroupName, View_Account.AccountDirectionName
        , View_Account.AccountId, View_Account.AccountCode, View_Account.AccountName, View_Account.AccountName_all
        , ObjectDesc.ItemName            AS LocationDescName
        , CAST (COALESCE(Object_Location.Id, 0) AS Integer)             AS LocationId
        , Object_Location.ObjectCode     AS LocationCode
        , CAST (COALESCE(Object_Location.ValueData,'') AS TVarChar)     AS LocationName
        , Object_Car.ObjectCode          AS CarCode
        , Object_Car.ValueData           AS CarName
        , Object_GoodsGroup.Id           AS GoodsGroupId
        , Object_GoodsGroup.ValueData    AS GoodsGroupName
        , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
        , CAST (COALESCE(Object_Goods.Id, 0) AS Integer)                 AS GoodsId
        , Object_Goods.ObjectCode        AS GoodsCode
        , CAST (COALESCE(Object_Goods.ValueData, '') AS TVarChar)        AS GoodsName
        , CAST (COALESCE(Object_GoodsKind.Id, 0) AS Integer)             AS GoodsKindId
        , CAST (COALESCE(Object_GoodsKind.ValueData, '') AS TVarChar)    AS GoodsKindName
        , CAST (COALESCE(Object_GoodsKind_complete.ValueData, '') AS TVarChar) AS GoodsKindName_complete
        , Object_Measure.ValueData           AS MeasureName
        , ObjectFloat_Weight.ValueData       AS Weight
        , ObjectFloat_WeightTare.ValueData ::TFloat  AS WeightTare
        , CAST (COALESCE(Object_PartionGoods.Id, 0) AS Integer)           AS PartionGoodsId
        , CAST (COALESCE(Object_PartionGoods.ValueData,'') AS TVarChar)  AS PartionGoodsName
        , Object_AssetTo.ValueData       AS AssetToName

        , CAST (tmpMIContainer_group.CountStart          AS TFloat) AS CountStart
        , CAST (tmpMIContainer_group.CountStart * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END          AS TFloat) AS CountStart_Weight
        , CAST (tmpMIContainer_group.CountEnd            AS TFloat) AS CountEnd
        , CAST (tmpMIContainer_group.CountEnd * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END            AS TFloat) AS CountEnd_Weight
        , CAST (tmpMIContainer_group.CountEnd_calc       AS TFloat) AS CountEnd_calc
        , CAST (tmpMIContainer_group.CountEnd_calc * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END       AS TFloat) AS CountEnd_calc_Weight
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

        , CAST (tmpMIContainer_group.CountSendOnPrice_10500  AS TFloat) AS CountSendOnPrice_10500
        , CAST (tmpMIContainer_group.CountSendOnPrice_10500 * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END  AS TFloat) AS CountSendOnPrice_10500_Weight
        , CAST (tmpMIContainer_group.CountSendOnPrice_40200  AS TFloat) AS CountSendOnPrice_40200
        , CAST (tmpMIContainer_group.CountSendOnPrice_40200 * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END  AS TFloat) AS CountSendOnPrice_40200_Weight
        
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
        , CAST (tmpMIContainer_group.SummEnd_calc         AS TFloat) AS SummEnd_calc
        , CAST (tmpMIContainer_group.SummIncome           AS TFloat) AS SummIncome
        , CAST (tmpMIContainer_group.SummReturnOut        AS TFloat) AS SummReturnOut
        , CAST (tmpMIContainer_group.SummSendIn           AS TFloat) AS SummSendIn
        , CAST (tmpMIContainer_group.SummSendOut          AS TFloat) AS SummSendOut
        , CAST (tmpMIContainer_group.SummSendOnPriceIn    AS TFloat) AS SummSendOnPriceIn
        , CAST (tmpMIContainer_group.SummSendOnPriceOut   AS TFloat) AS SummSendOnPriceOut
        , CAST (tmpMIContainer_group.SummSendOnPrice_10500       AS TFloat) AS SummSendOnPrice_10500
        , CAST (tmpMIContainer_group.SummSendOnPrice_40200       AS TFloat) AS SummSendOnPrice_40200
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

        , tmpMIContainer_group.CountProductionIn_by :: TFloat  -- приход с произв. (если с другого подр., т.е. не пересорт)
        , (tmpMIContainer_group.CountProductionIn_by * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS CountProductionIn_by_Weight
        , tmpMIContainer_group.SummProductionIn_by  :: TFloat -- приход с произв. (если с другого подр., т.е. не пересорт)
        
        , tmpMIContainer_group.CountIn_by           :: TFloat -- приход с "выбранного" подр.
        , (tmpMIContainer_group.CountIn_by * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS CountIn_by_Weight
        , tmpMIContainer_group.SummIn_by            :: TFloat -- приход с "выбранного" подр.
 
        , tmpMIContainer_group.CountOtherIn_by      :: TFloat -- приход другой
        , (tmpMIContainer_group.CountOtherIn_by * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS CountOtherIn_by_Weight
        , tmpMIContainer_group.SummOtherIn_by       :: TFloat -- приход другой

        , tmpMIContainer_group.CountOut_by      :: TFloat -- расход на "выбранное" подр.
        , (tmpMIContainer_group.CountOut_by * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS CountOut_by_Weight
        , tmpMIContainer_group.SummOut_by       :: TFloat -- расход на "выбранное" подр.
   
        , tmpMIContainer_group.CountOtherOut_by :: TFloat -- расход другой
        , (tmpMIContainer_group.CountOtherOut_by * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS CountOtherOut_by_Weight
        , tmpMIContainer_group.SummOtherOut_by  :: TFloat -- расход другой


        , tmpMIContainer_group.CountProductionOut_Norm ::TFloat AS CountProductionOut_Norm
        , CASE WHEN tmpMIContainer_group.CountProductionOut <> 0
                    THEN tmpMIContainer_group.CountProductionOut_Norm * tmpMIContainer_group.SummProductionOut / tmpMIContainer_group.CountProductionOut
               ELSE 0
          END :: TFloat AS SummProductionOut_Norm


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

        , tmpMIContainer_group.ContainerId              AS ContainerId_Summ
        , CAST (row_number() OVER () AS INTEGER)        AS LineNum

      FROM 
        (SELECT tmp.AccountId
              , tmp.ContainerId
              , tmp.LocationId
              , tmp.GoodsId
              , tmp.GoodsKindId
              , tmp.PartionGoodsId
              , tmp.AssetToId

              , SUM (tmp.CountStart) AS CountStart
              , SUM (tmp.CountEnd) AS CountEnd
              , SUM (tmp.CountEnd_calc) AS CountEnd_calc

              , SUM (tmp.CountIncome) AS CountIncome
              , SUM (tmp.CountReturnOut) AS CountReturnOut

              , SUM (tmp.CountSendIn) AS CountSendIn
              , SUM (tmp.CountSendOut) AS CountSendOut

              , SUM (tmp.CountSendOnPriceIn)     AS CountSendOnPriceIn
              , SUM (tmp.CountSendOnPriceOut)    AS CountSendOnPriceOut
              , SUM (tmp.CountSendOnPrice_10500) AS CountSendOnPrice_10500
              , SUM (tmp.CountSendOnPrice_40200) AS CountSendOnPrice_40200
              
              , SUM (tmp.CountSale) AS CountSale
              , SUM (tmp.CountSale_10500) AS CountSale_10500
              , SUM (tmp.CountSale_40208) AS CountSale_40208

              , SUM (tmp.CountReturnIn)       AS CountReturnIn
              , SUM (tmp.CountReturnIn_40208) AS CountReturnIn_40208

              , SUM (tmp.CountLoss)      AS CountLoss
              , SUM (tmp.CountInventory) AS CountInventory

              , SUM (tmp.CountProductionIn)  AS CountProductionIn
              , SUM (tmp.CountProductionOut) AS CountProductionOut

              , SUM (tmp.CountProductionIn_by) AS CountProductionIn_by
              , SUM (tmp.SummProductionIn_by)  AS SummProductionIn_by

              , SUM (tmp.CountIn_by) AS CountIn_by
              , SUM (tmp.SummIn_by)  AS SummIn_by

              , SUM (tmp.CountOtherIn_by) AS CountOtherIn_by
              , SUM (tmp.SummOtherIn_by)  AS SummOtherIn_by

              , SUM (tmp.CountOut_by) AS CountOut_by
              , SUM (tmp.SummOut_by)  AS SummOut_by

              , SUM (tmp.CountOtherOut_by) AS CountOtherOut_by
              , SUM (tmp.SummOtherOut_by)  AS SummOtherOut_by

              , SUM (tmp.CountTotalIn)  AS CountTotalIn
              , SUM (tmp.CountTotalOut) AS CountTotalOut

              , SUM (tmp.SummStart)     AS SummStart
              , SUM (tmp.SummEnd)       AS SummEnd
              , SUM (tmp.SummEnd_calc)  AS SummEnd_calc

              , SUM (tmp.SummIncome)              AS SummIncome
              , SUM (tmp.SummReturnOut)           AS SummReturnOut
              , SUM (tmp.SummSendIn)              AS SummSendIn
              , SUM (tmp.SummSendOut)             AS SummSendOut
              , SUM (tmp.SummSendOnPriceIn)       AS SummSendOnPriceIn
              , SUM (tmp.SummSendOnPriceOut)      AS SummSendOnPriceOut
              , SUM (tmp.SummSendOnPrice_10500)   AS SummSendOnPrice_10500
              , SUM (tmp.SummSendOnPrice_40200)   AS SummSendOnPrice_40200
              , SUM (tmp.SummSale)                AS SummSale
              , SUM (tmp.SummSale_10500)          AS SummSale_10500
              , SUM (tmp.SummSale_40208)          AS SummSale_40208
              , SUM (tmp.SummReturnIn)            AS SummReturnIn
              , SUM (tmp.SummReturnIn_40208)      AS SummReturnIn_40208
              , SUM (tmp.SummLoss)                AS SummLoss
              , SUM (tmp.SummInventory)           AS SummInventory
              , SUM (tmp.SummInventory_RePrice)   AS SummInventory_RePrice
              , SUM (tmp.SummProductionIn)        AS SummProductionIn
              , SUM (tmp.SummProductionOut)       AS SummProductionOut

              , SUM (tmp.SummTotalIn)             AS SummTotalIn
              , SUM (tmp.SummTotalOut)            AS SummTotalOut

              , SUM (tmp.CountProductionOut_norm) AS CountProductionOut_norm
         FROM
        (SELECT 0 AS AccountId
              , 0 AS ContainerId
              , tmpMIContainer_all.LocationId
              , tmpMIContainer_all.GoodsId
              , tmpMIContainer_all.GoodsKindId
              , CASE WHEN tmpMIContainer_all.PartionGoodsId = 80132 THEN 0 ELSE tmpMIContainer_all.PartionGoodsId END AS PartionGoodsId
              , COALESCE (tmpMIContainer_all.AssetToId, 0)      AS AssetToId

              , SUM (tmpMIContainer_all.CountStart)          AS CountStart
              , SUM (tmpMIContainer_all.CountEnd)            AS CountEnd
              , SUM (tmpMIContainer_all.CountEnd_calc)       AS CountEnd_calc

              , SUM (tmpMIContainer_all.CountIncome)         AS CountIncome
              , SUM (tmpMIContainer_all.CountReturnOut)      AS CountReturnOut

              , SUM (tmpMIContainer_all.CountSendIn)         AS CountSendIn
              , SUM (tmpMIContainer_all.CountSendOut)        AS CountSendOut

              , SUM (tmpMIContainer_all.CountSendOnPriceIn)  AS CountSendOnPriceIn
              , SUM (tmpMIContainer_all.CountSendOnPriceOut) AS CountSendOnPriceOut

              , SUM (tmpMIContainer_all.CountSendOnPrice_10500)  AS CountSendOnPrice_10500
              , SUM (tmpMIContainer_all.CountSendOnPrice_40200)  AS CountSendOnPrice_40200

              , SUM (tmpMIContainer_all.CountSale)           AS CountSale
              , SUM (tmpMIContainer_all.CountSale_10500)     AS CountSale_10500
              , SUM (tmpMIContainer_all.CountSale_40208)     AS CountSale_40208

              , SUM (tmpMIContainer_all.CountReturnIn)       AS CountReturnIn
              , SUM (tmpMIContainer_all.CountReturnIn_40208) AS CountReturnIn_40208

              , SUM (tmpMIContainer_all.CountLoss)           AS CountLoss
              , SUM (tmpMIContainer_all.CountInventory)      AS CountInventory

              , SUM (CASE WHEN tmpMIContainer_all.LocationId_by = -1 THEN 0 ELSE tmpMIContainer_all.CountProductionIn  END) AS CountProductionIn   -- не пересорт
              , SUM (CASE WHEN tmpMIContainer_all.LocationId_by = -1 THEN 0 ELSE tmpMIContainer_all.CountProductionOut END) AS CountProductionOut  -- не пересорт

              , SUM (CASE WHEN _tmpLocation.LocationId > 0 AND COALESCE (tmpMIContainer_all.LocationId_by, 0) <> -1 THEN tmpMIContainer_all.CountProductionIn ELSE 0 END) AS CountProductionIn_by -- приход с произв. (если с другого подр., т.е. не пересорт)
              , SUM (CASE WHEN _tmpLocation.LocationId > 0 AND COALESCE (tmpMIContainer_all.LocationId_by, 0) <> -1 THEN tmpMIContainer_all.SummProductionIn  ELSE 0 END) AS SummProductionIn_by  -- приход с произв. (если с другого подр., т.е. не пересорт)

              , SUM (CASE WHEN _tmpLocation_by.LocationId > 0 AND _tmpLocation.LocationId IS NULL
                           AND COALESCE (tmpMIContainer_all.LocationId_by, 0) <> -1 -- не пересорт
                               THEN tmpMIContainer_all.CountSendIn
                                  + tmpMIContainer_all.CountProductionIn
                                  + tmpMIContainer_all.CountSendOnPriceIn
                          ELSE 0
                     END) AS CountIn_by -- приход с "выбранного" подр.
              , SUM (CASE WHEN _tmpLocation_by.LocationId > 0 AND _tmpLocation.LocationId IS NULL
                           AND COALESCE (tmpMIContainer_all.LocationId_by, 0) <> -1 -- не пересорт
                               THEN tmpMIContainer_all.SummSendIn
                                  + tmpMIContainer_all.SummProductionIn
                                  + tmpMIContainer_all.SummSendOnPriceIn
                          ELSE 0
                     END) AS SummIn_by -- приход с "выбранного" подр.

              , SUM (CASE WHEN (_tmpLocation.LocationId IS NULL AND _tmpLocation_by.LocationId IS NULL) OR tmpMIContainer_all.LocationId_by = -1 THEN tmpMIContainer_all.CountProductionIn ELSE 0 END
                   + CASE WHEN _tmpLocation_by.LocationId IS NULL
                              THEN tmpMIContainer_all.CountSendIn
                                 + tmpMIContainer_all.CountSendOnPriceIn
                          ELSE 0
                     END
                   + tmpMIContainer_all.CountIncome
                   + tmpMIContainer_all.CountReturnIn
                   + tmpMIContainer_all.CountReturnIn_40208
                    ) AS CountOtherIn_by -- приход другой
              , SUM (CASE WHEN (_tmpLocation.LocationId IS NULL AND _tmpLocation_by.LocationId IS NULL) OR tmpMIContainer_all.LocationId_by = -1 THEN tmpMIContainer_all.SummProductionIn ELSE 0 END
                   + CASE WHEN _tmpLocation_by.LocationId IS NULL
                              THEN tmpMIContainer_all.SummSendIn
                                 + tmpMIContainer_all.SummSendOnPriceIn
                          ELSE 0
                     END
                   + tmpMIContainer_all.SummIncome
                   + tmpMIContainer_all.SummReturnIn
                   + tmpMIContainer_all.SummReturnIn_40208
                    ) AS SummOtherIn_by -- приход другой

              , SUM (CASE WHEN COALESCE (_tmpLocation_by.LocationId, 0) > 0 AND COALESCE (tmpMIContainer_all.LocationId_by, 0) <> -1
                               THEN tmpMIContainer_all.CountSendOut
                                  + tmpMIContainer_all.CountProductionOut
                                  + tmpMIContainer_all.CountSendOnPriceOut
                          ELSE 0
                     END) AS CountOut_by -- расход на "выбранное" подр.
              , SUM (CASE WHEN _tmpLocation_by.LocationId > 0 AND COALESCE (tmpMIContainer_all.LocationId_by, 0) <> -1
                               THEN tmpMIContainer_all.SummSendOut
                                  + tmpMIContainer_all.SummProductionOut
                                  + tmpMIContainer_all.SummSendOnPriceOut
                          ELSE 0
                     END) AS SummOut_by -- расход на "выбранное" подр.
    
              , SUM (CASE WHEN NOT (COALESCE (_tmpLocation_by.LocationId, 0) > 0 AND COALESCE (tmpMIContainer_all.LocationId_by, 0) <> -1)
                           AND tmpMIContainer_all.LocationId_by = -1
                               THEN tmpMIContainer_all.CountProductionOut
                          ELSE 0
                     END
                   + CASE WHEN _tmpLocation_by.LocationId IS NULL
                               THEN tmpMIContainer_all.CountSendOut
                                  + tmpMIContainer_all.CountSendOnPriceOut
                          ELSE 0
                     END
                   + tmpMIContainer_all.CountReturnOut
                   + tmpMIContainer_all.CountSale
                   + tmpMIContainer_all.CountSale_10500
                   - tmpMIContainer_all.CountSale_40208
                   + tmpMIContainer_all.CountLoss
                    ) AS CountOtherOut_by -- расход другой
              , SUM (CASE WHEN NOT (COALESCE (_tmpLocation_by.LocationId, 0) > 0 AND COALESCE (tmpMIContainer_all.LocationId_by, 0) <> -1) 
                           AND tmpMIContainer_all.LocationId_by = -1
                               THEN tmpMIContainer_all.SummProductionOut
                          ELSE 0
                     END
                   + CASE WHEN _tmpLocation_by.LocationId IS NULL
                               THEN tmpMIContainer_all.SummSendOut
                                  + tmpMIContainer_all.SummSendOnPriceOut
                          ELSE 0
                     END
                   + tmpMIContainer_all.SummReturnOut
                   + tmpMIContainer_all.SummSale
                   + tmpMIContainer_all.SummSale_10500
                   - tmpMIContainer_all.SummSale_40208
                   + tmpMIContainer_all.SummLoss
                    ) AS SummOtherOut_by -- расход другой

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
              , SUM (tmpMIContainer_all.SummEnd_calc)        AS SummEnd_calc
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

              , SUM (CASE WHEN tmpMIContainer_all.LocationId_by = -1 THEN 0 ELSE tmpMIContainer_all.SummProductionIn  END) AS SummProductionIn   -- не пересорт
              , SUM (CASE WHEN tmpMIContainer_all.LocationId_by = -1 THEN 0 ELSE tmpMIContainer_all.SummProductionOut END) AS SummProductionOut  -- не пересорт

              , SUM (tmpMIContainer_all.SummSendOnPrice_10500)      AS SummSendOnPrice_10500
              , SUM (tmpMIContainer_all.SummSendOnPrice_40200)      AS SummSendOnPrice_40200

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

              , 0 AS CountProductionOut_norm

         FROM tmpReport AS tmpMIContainer_all
              LEFT JOIN _tmpLocation ON _tmpLocation.LocationId = tmpMIContainer_all.LocationId_by AND _tmpLocation.ContainerDescId = zc_Container_Count()
              LEFT JOIN _tmpLocation_by ON _tmpLocation_by.LocationId = tmpMIContainer_all.LocationId_by

         GROUP BY tmpMIContainer_all.AccountId
                , CASE WHEN inIsInfoMoney = TRUE THEN tmpMIContainer_all.ContainerId ELSE 0 END
                , tmpMIContainer_all.LocationId
                , tmpMIContainer_all.GoodsId
                , tmpMIContainer_all.GoodsKindId
                , tmpMIContainer_all.PartionGoodsId
                , tmpMIContainer_all.AssetToId
        UNION ALL
         SELECT 0 AS AccountId
              , 0 AS ContainerId
              , tmpOut_norm.LocationId
              , tmpOut_norm.GoodsId
              , tmpOut_norm.GoodsKindId
              , 0 AS PartionGoodsId
              , 0 AS AssetToId
              , 0 AS CountStart
              , 0 AS CountEnd
              , 0 AS CountEnd_calc

              , 0 AS CountIncome
              , 0 AS CountReturnOut

              , 0 AS CountSendIn
              , 0 AS CountSendOut

              , 0 AS CountSendOnPriceIn
              , 0 AS CountSendOnPriceOut

              , 0 AS CountSendOnPrice_10500
              , 0 AS CountSendOnPrice_40200

              , 0 AS CountSale
              , 0 AS CountSale_10500
              , 0 AS CountSale_40208

              , 0 AS CountReturnIn
              , 0 AS CountReturnIn_40208

              , 0 AS CountLoss
              , 0 AS CountInventory

              , 0 AS CountProductionIn
              , 0 AS CountProductionOut

              , 0 AS CountProductionIn_by -- приход с произв. (если с другого подр., т.е. не пересорт)
              , 0 AS SummProductionIn_by  -- приход с произв. (если с другого подр., т.е. не пересорт)

              , 0 AS CountIn_by -- приход с "выбранного" подр.
              , 0 AS SummIn_by -- приход с "выбранного" подр.

              , 0 AS CountOtherIn_by -- приход другой
              , 0 AS SummOtherIn_by -- приход другой

              , 0 AS CountOut_by -- расход на "выбранное" подр.
              , 0 AS SummOut_by -- расход на "выбранное" подр.

              , 0 AS CountOtherOut_by -- расход другой
              , 0 AS SummOtherOut_by -- расход другой

              , 0 AS CountTotalIn
              , 0 AS CountTotalOut

              , 0 AS SummStart
              , 0 AS SummEnd
              , 0 AS SummEnd_calc

              , 0 AS SummIncome
              , 0 AS SummReturnOut
              , 0 AS SummSendIn
              , 0 AS SummSendOut
              , 0 AS SummSendOnPriceIn
              , 0 AS SummSendOnPriceOut
              , 0 AS SummSale
              , 0 AS SummSale_10500
              , 0 AS SummSale_40208
              , 0 AS SummReturnIn
              , 0 AS SummReturnIn_40208
              , 0 AS SummLoss
              , 0 AS SummInventory
              , 0 AS SummInventory_RePrice
              , 0 AS SummProductionIn
              , 0 AS SummProductionOut

              , 0 AS SummSendOnPrice_10500
              , 0 AS SummSendOnPrice_40200

              , 0 AS SummTotalIn
              , 0 AS SummTotalOut

              , tmpOut_norm.OperCount AS CountProductionOut_norm

         FROM tmpOut_norm
        ) AS tmp
         GROUP BY tmp.AccountId
                , tmp.ContainerId
                , tmp.LocationId
                , tmp.GoodsId
                , tmp.GoodsKindId
                , tmp.PartionGoodsId
                , tmp.AssetToId
        ) AS tmpMIContainer_group

        LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                      ON CLO_InfoMoney.ContainerId = tmpMIContainer_group.ContainerId
                                     AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
        LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = CLO_InfoMoney.ObjectId
        LEFT JOIN ContainerLinkObject AS CLO_InfoMoneyDetail
                                      ON CLO_InfoMoneyDetail.ContainerId = tmpMIContainer_group.ContainerId
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

        LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                              ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                             AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
        LEFT JOIN ObjectFloat AS ObjectFloat_WeightTare 
                              ON ObjectFloat_WeightTare.ObjectId = Object_Goods.Id
                             AND ObjectFloat_WeightTare.DescId = zc_ObjectFloat_Goods_WeightTare()

        LEFT JOIN ObjectLink AS ObjectLink_GoodsKindComplete
                             ON ObjectLink_GoodsKindComplete.ObjectId = tmpMIContainer_group.PartionGoodsId
                            AND ObjectLink_GoodsKindComplete.DescId = zc_ObjectLink_PartionGoods_GoodsKindComplete()
        LEFT JOIN Object AS Object_GoodsKind_complete ON Object_GoodsKind_complete.Id = ObjectLink_GoodsKindComplete.ChildObjectId
        LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpMIContainer_group.PartionGoodsId
        LEFT JOIN Object AS Object_AssetTo ON Object_AssetTo.Id = tmpMIContainer_group.AssetToId

        LEFT JOIN Object_Account_View AS View_Account ON View_Account.AccountId = tmpMIContainer_group.AccountId
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_MotionGoods_Ceh (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 26.10.18         *
 11.07.15                                        * add GoodsKindName_complete
 13.05.15         *
*/

-- тест
-- SELECT * FROM gpReport_MotionGoods_Ceh (inStartDate:= '01.01.2015', inEndDate:= '01.01.2015', inAccountGroupId:= 0, inUnitGroupId:= 0, inLocationId:= 0, inGoodsGroupId:= 0, inGoodsId:= 0, inUnitGroupId_by:=0, inLocationId_by:= 0, inIsInfoMoney:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * from gpReport_MotionGoods_Ceh (inStartDate:= '01.08.2018', inEndDate:= '01.08.2018', inAccountGroupId:= 0, inUnitGroupId := 8459 , inLocationId := 0 , inGoodsGroupId := 1860 , inGoodsId := 0 , inUnitGroupId_by:=0, inLocationId_by:= 0, inIsInfoMoney:= TRUE, inSession := zfCalc_UserAdmin());
