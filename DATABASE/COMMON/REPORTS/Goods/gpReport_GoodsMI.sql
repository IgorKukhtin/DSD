-- Function: gpReport_GoodsMI ()
--SELECT * FROM Object_Account_View WHERE AccountGroupId = zc_Enum_AccountGroup_20000()

DROP FUNCTION IF EXISTS gpReport_GoodsMI (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpReport_GoodsMI (
    IN inStartDate    TDateTime ,
    IN inEndDate      TDateTime ,
    IN inDescId       Integer   ,  --sale(продажа покупателю) = 5, returnin (возврат покупателя) = 6
    IN inGoodsGroupId Integer   ,
    IN inUnitGroupId  Integer   ,
    IN inUnitId       Integer   ,
    IN inPaidKindId   Integer   ,
    IN inJuridicalId  Integer   ,
    IN inInfoMoneyId  Integer   ,
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar, MeasureName TVarChar
             , TradeMarkName TVarChar
             , LocationCode Integer, LocationName TVarChar
             , JuridicalCode Integer, JuridicalName TVarChar
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
             , PaidKindName TVarChar
             , Amount_Weight TFloat, Amount_Sh TFloat
             , AmountChangePercent_Weight TFloat, AmountChangePercent_Sh TFloat
             , AmountPartner_Weight TFloat, AmountPartner_Sh TFloat
             , Amount_10500_Weight TFloat, Amount_10500_Sh TFloat
             , Amount_40200_Weight TFloat, Amount_40200_Sh TFloat
             , SummPartner_calc TFloat
             , SummPartner TFloat, SummPartner_10200 TFloat, SummPartner_10300 TFloat
             , SummDiff TFloat
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             ) 
AS
$BODY$
 DECLARE vbUserId Integer;
BEGIN
     vbUserId:= lpGetUserBySession (inSession);
   
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpUnit (UnitId Integer) ON COMMIT DROP;
    
  
    -- Ограничения по товару
    IF inGoodsGroupId <> 0
    THEN
        INSERT INTO _tmpGoods (GoodsId)
           SELECT lfObject_Goods_byGoodsGroup.GoodsId
           FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup;
    ELSE
        INSERT INTO _tmpGoods (GoodsId)
           SELECT Object.Id FROM Object WHERE DescId = zc_Object_Goods()
         UNION
           SELECT Object.Id FROM Object WHERE DescId = zc_Object_Fuel();
    END IF;

    

    -- группа подразделений или подразделение или место учета (МО, Авто)
    IF inUnitGroupId <> 0 AND COALESCE (inUnitId, 0) = 0
    THEN
        INSERT INTO _tmpUnit (UnitId)
           SELECT lfSelect_Object_Unit_byGroup.UnitId AS UnitId
           FROM lfSelect_Object_Unit_byGroup (inUnitGroupId) AS lfSelect_Object_Unit_byGroup;
    ELSE
        IF inUnitId <> 0
        THEN
            INSERT INTO _tmpUnit (UnitId)
               SELECT Object.Id AS UnitId
               FROM Object
               WHERE Object.Id = inUnitId;
        ELSE
           WITH tmpBranch AS (SELECT TRUE AS Value WHERE 1 = 0 AND NOT EXISTS (SELECT BranchId FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND BranchId <> 0))
            INSERT INTO _tmpUnit (UnitId)
               /*SELECT Id FROM Object WHERE DescId = zc_Object_Unit()
              UNION ALL*/
               SELECT Id FROM Object  WHERE DescId = zc_Object_Member()
              UNION ALL
               SELECT Id FROM Object  WHERE DescId = zc_Object_Car();
              
        END IF;
    END IF;


   -- Результат
    RETURN QUERY
    WITH tmpAnalyzer AS (SELECT Constant_ProfitLoss_AnalyzerId_View.*
                         FROM Constant_ProfitLoss_AnalyzerId_View
                         WHERE (isSale = TRUE AND inDescId = zc_Movement_Sale()) OR (isSale = FALSE AND inDescId = zc_Movement_ReturnIn())
                        ) 
        , tmpAccount AS (SELECT Object_Account_View.*
                         FROM Object_Account_View
                         WHERE Object_Account_View.AccountGroupId IN (zc_Enum_AccountGroup_60000()  -- Прибыль будущих периодов
                                                                    , zc_Enum_AccountGroup_110000() -- Транзит
                                                                     )
                        ) 
       SELECT Object_GoodsGroup.ValueData            AS GoodsGroupName 
         , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
         , Object_Goods.ObjectCode                AS GoodsCode
         , Object_Goods.ValueData                 AS GoodsName
         , Object_GoodsKind.ValueData             AS GoodsKindName
         , Object_Measure.ValueData               AS MeasureName
         , Object_TradeMark.ValueData             AS TradeMarkName

         , Object_Location.ObjectCode AS LocationCode
         , Object_Location.ValueData  AS LocationName

         , Object_Juridical.ObjectCode AS JuridicalCode
         , Object_Juridical.ValueData  AS JuridicalName

         , Object_Partner.Id           AS PartnerId
         , Object_Partner.ObjectCode   AS PartnerCode
         , Object_Partner.ValueData    AS PartnerName

         , Object_PaidKind.ValueData   AS PaidKindName

         , ((tmpOperationGroup.OperCount + OperCount_110000) * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS Amount_Weight
         , (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN (tmpOperationGroup.OperCount + OperCount_110000) ELSE 0 END) :: TFloat                                AS Amount_Sh

         , (tmpOperationGroup.OperCount_Change * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS AmountChangePercent_Weight
         , (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpOperationGroup.OperCount_Change ELSE 0 END) :: TFloat                                AS AmountChangePercent_Sh
         
         , (tmpOperationGroup.OperCount_110000 * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS AmountPartner_Weight
         , (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpOperationGroup.OperCount_110000 ELSE 0 END) :: TFloat                                AS AmountPartner_Sh

         , (tmpOperationGroup.OperCount_Change * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS Amount_10500_Weight
         , (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpOperationGroup.OperCount_Change ELSE 0 END) :: TFloat                                AS Amount_10500_Sh
         , (tmpOperationGroup.OperCount_40200 * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat  AS Amount_40200_Weight
         , (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpOperationGroup.OperCount_40200 ELSE 0 END) :: TFloat                                 AS Amount_40200_Sh

         , tmpOperationGroup.SummOut_PriceList      :: TFloat  AS SummPartner_calc
         , tmpOperationGroup.SummOut_Partner        :: TFloat  AS SummPartner
         , tmpOperationGroup.SummOut_Diff           :: TFloat  AS SummPartner_10200
         , tmpOperationGroup.SummOut_Change         :: TFloat  AS SummPartner_10300
         , tmpOperationGroup.SummOut_Partner_110000 :: TFloat  AS SummDiff

         , View_InfoMoney.InfoMoneyGroupName              AS InfoMoneyGroupName
         , View_InfoMoney.InfoMoneyDestinationName        AS InfoMoneyDestinationName
         , View_InfoMoney.InfoMoneyCode                   AS InfoMoneyCode
         , View_InfoMoney.InfoMoneyName                   AS InfoMoneyName

     FROM (SELECT tmpContainer.LocationId
                , tmpContainer.GoodsId
                , tmpContainer.GoodsKindId
                , tmpContainer.PartnerId
                , COALESCE (ContainerLO_Juridical.ObjectId,  COALESCE (ContainerLO_Member.ObjectId, 0 )) AS JuridicalId
                , CASE WHEN ContainerLO_Member.ObjectId > 0 THEN zc_Enum_PaidKind_SecondForm() ELSE COALESCE (ContainerLO_PaidKind.ObjectId,0) END AS PaidKindId
                , ContainerLinkObject_InfoMoney.ObjectId AS InfoMoneyId

                  -- 1.1. Кол-во
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL                         THEN tmpContainer.OperCount ELSE 0 END) AS OperCount
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpAccount.isActive = TRUE  THEN tmpContainer.OperCount ELSE 0 END) AS OperCount_110000_A
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpAccount.isActive = FALSE THEN tmpContainer.OperCount ELSE 0 END) AS OperCount_110000_P
                  -- 1.2. Себестоимость
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL                         THEN tmpContainer.SummIn ELSE 0 END) AS SummIn
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_60000()  THEN tmpContainer.SummIn ELSE 0 END) AS SummIn_60000
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpAccount.isActive = TRUE  THEN tmpContainer.SummIn ELSE 0 END) AS SummIn_110000_A
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpAccount.isActive = FALSE THEN tmpContainer.SummIn ELSE 0 END) AS SummIn_110000_P
                  -- 1.3. Сумма
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL                         THEN tmpContainer.SummOut_Partner ELSE 0 END) AS SummOut_Partner
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpAccount.isActive = TRUE  THEN tmpContainer.SummOut_Partner ELSE 0 END) AS SummOut_Partner_110000_A
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpAccount.isActive = FALSE THEN tmpContainer.SummOut_Partner ELSE 0 END) AS SummOut_Partner_110000_P

                  -- 2.1. Кол-во - Скидка за вес
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL                         THEN tmpContainer.OperCount ELSE 0 END) AS OperCount_Change
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpAccount.isActive = TRUE  THEN tmpContainer.OperCount ELSE 0 END) AS OperCount_Change_110000_A
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpAccount.isActive = FALSE THEN tmpContainer.OperCount ELSE 0 END) AS OperCount_Change_110000_P
                  -- 2.2. Себестоимость - Скидка за вес
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL                         THEN tmpContainer.SummIn_Change ELSE 0 END) AS SummIn_Change
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_60000()  THEN tmpContainer.SummIn_Change ELSE 0 END) AS SummIn_Change_60000
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpAccount.isActive = TRUE  THEN tmpContainer.SummIn_Change ELSE 0 END) AS SummIn_Change_110000_A
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpAccount.isActive = FALSE THEN tmpContainer.SummIn_Change ELSE 0 END) AS SummIn_Change_110000_P

                  -- 3.1. Кол-во Разница в весе
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL                         THEN tmpContainer.OperCount_40200 ELSE 0 END) AS OperCount_40200
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpAccount.isActive = TRUE  THEN tmpContainer.OperCount_40200 ELSE 0 END) AS OperCount_40200_110000_A
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpAccount.isActive = FALSE THEN tmpContainer.OperCount_40200 ELSE 0 END) AS OperCount_40200_110000_P
                  -- 3.2. Себестоимость - Разница в весе
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL                         THEN tmpContainer.SummIn_40200 ELSE 0 END) AS SummIn_40200
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_60000()  THEN tmpContainer.SummIn_40200 ELSE 0 END) AS SummIn_40200_60000
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpAccount.isActive = TRUE  THEN tmpContainer.SummIn_40200 ELSE 0 END) AS SummIn_40200_110000_A
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpAccount.isActive = FALSE THEN tmpContainer.SummIn_40200 ELSE 0 END) AS SummIn_40200_110000_P

                  -- 4.1. Кол-во списание
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL                         THEN tmpContainer.OperCount_Loss ELSE 0 END) AS OperCount_Loss
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_60000()  THEN tmpContainer.OperCount_Loss ELSE 0 END) AS OperCount_Loss_60000
                  -- 4.2. Себестоимость - списание
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL                         THEN tmpContainer.SummIn_Loss ELSE 0 END) AS SummIn_Loss
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_60000()  THEN tmpContainer.SummIn_Loss ELSE 0 END) AS SummIn_Loss_60000

                  -- 5.1. Кол-во у покупателя
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL                         THEN tmpContainer.OperCount_Partner ELSE 0 END) AS OperCount_Partner
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpAccount.isActive = TRUE  THEN tmpContainer.OperCount_Partner ELSE 0 END) AS OperCount_Partner_110000_A
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpAccount.isActive = FALSE THEN tmpContainer.OperCount_Partner ELSE 0 END) AS OperCount_Partner_110000_P
                  -- 5.2. Себестоимость у покупателя
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL                         THEN tmpContainer.SummIn_Partner ELSE 0 END) AS SummIn_Partner
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_60000()  THEN tmpContainer.SummIn_Partner ELSE 0 END) AS SummIn_Partner_60000
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpAccount.isActive = TRUE  THEN tmpContainer.SummIn_Partner ELSE 0 END) AS SummIn_Partner_110000_A
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpAccount.isActive = FALSE THEN tmpContainer.SummIn_Partner ELSE 0 END) AS SummIn_Partner_110000_P
                  -- 5.3.1. Сумма у покупателя По прайсу
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL                         THEN tmpContainer.SummOut_PriceList ELSE 0 END) AS SummOut_PriceList
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpAccount.isActive = TRUE  THEN tmpContainer.SummOut_PriceList ELSE 0 END) AS SummOut_PriceList_110000_A
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpAccount.isActive = FALSE THEN tmpContainer.SummOut_PriceList ELSE 0 END) AS SummOut_PriceList_110000_P
                  -- 5.3.2. Сумма у покупателя Разница с оптовыми ценами
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL                         THEN tmpContainer.SummOut_Diff ELSE 0 END) AS SummOut_Diff
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpAccount.isActive = TRUE  THEN tmpContainer.SummOut_Diff ELSE 0 END) AS SummOut_Diff_110000_A
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpAccount.isActive = FALSE THEN tmpContainer.SummOut_Diff ELSE 0 END) AS SummOut_Diff_110000_P
                  -- 5.3.3. Сумма у покупателя Скидка дополнительная
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL                         THEN tmpContainer.SummOut_Change ELSE 0 END) AS SummOut_Change
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpAccount.isActive = TRUE  THEN tmpContainer.SummOut_Change ELSE 0 END) AS SummOut_Change_110000_A
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpAccount.isActive = FALSE THEN tmpContainer.SummOut_Change ELSE 0 END) AS SummOut_Change_110000_P

           FROM (SELECT MIContainer.WhereObjectId_analyzer  AS LocationId
                      , MIContainer.ContainerId             AS ContainerId
                      , MIContainer.ObjectId_analyzer       AS GoodsId
                      , MIContainer.ObjectIntId_analyzer    AS GoodsKindId
                      , MIContainer.ObjectExtId_analyzer    AS PartnerId
                      , MIContainer.ContainerId_analyzer
                      , MIContainer.isActive
                      , COALESCE (MIContainer.AccountId, 0) AS AccountId

                        -- 1.1. Кол-во
                      , SUM (CASE WHEN tmpAnalyzer.isSale = TRUE  AND tmpAnalyzer.isSumm = FALSE THEN -1 * MIContainer.Amount
                                  WHEN tmpAnalyzer.isSale = FALSE AND tmpAnalyzer.isSumm = FALSE THEN  1 * MIContainer.Amount
                                  ELSE 0
                             END) AS OperCount
                        -- 1.2. Себестоимость
                      , SUM (CASE WHEN tmpAnalyzer.isSale = TRUE  AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = TRUE THEN -1 * MIContainer.Amount
                                  WHEN tmpAnalyzer.isSale = FALSE AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = TRUE THEN  1 * MIContainer.Amount
                                  ELSE 0
                             END) AS SummIn
                        -- 1.3. Сумма
                      , SUM (CASE WHEN tmpAnalyzer.isSale = TRUE  AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE THEN  1 * MIContainer.Amount -- знак наоборот т.к. это проводка покупателя
                                  WHEN tmpAnalyzer.isSale = FALSE AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE THEN -1 * MIContainer.Amount -- знак наоборот т.к. это проводка покупателя
                                  ELSE 0
                             END) AS SummOut_Partner


                        -- 2.1. Кол-во - Скидка за вес
                      , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10500() THEN -1 * MIContainer.Amount
                                  ELSE 0
                             END) AS OperCount_Change
                        -- 2.2. Себестоимость - Скидка за вес
                      , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10500() THEN -1 * MIContainer.Amount
                                  ELSE 0
                             END) AS SummIn_Change

                        -- 3.1. Кол-во Разница в весе
                      , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_40200()     THEN -1 * MIContainer.Amount
                                  WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_40200() THEN  1 * MIContainer.Amount
                                  ELSE 0
                             END) AS OperCount_40200
                        -- 3.2. Себестоимость - Разница в весе
                      , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_40200()     THEN -1 * MIContainer.Amount
                                  WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_40200() THEN  1 * MIContainer.Amount
                                  ELSE 0
                             END) AS SummIn_40200

                        -- 4.1. Кол-во списание
                      , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_LossCount_20200() THEN -1 * MIContainer.Amount
                                  ELSE 0
                             END) AS OperCount_Loss
                        -- 4.2. Себестоимость - списание
                      , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_LossSumm_20200() THEN -1 * MIContainer.Amount
                                  ELSE 0
                             END) AS SummIn_Loss

                        -- 5.1. Кол-во у покупателя
                      , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400()     THEN -1 * MIContainer.Amount
                                  WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_10800() THEN  1 * MIContainer.Amount
                                  ELSE 0
                             END) AS OperCount_Partner
                        -- 5.2. Себестоимость у покупателя
                      , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10400()     THEN -1 * MIContainer.Amount
                                  WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10800() THEN  1 * MIContainer.Amount
                                  ELSE 0
                             END) AS SummIn_Partner
                        -- 5.3.1. Сумма у покупателя По прайсу
                      , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10100()     THEN  1 * MIContainer.Amount -- знак наоборот т.к. это проводка покупателя
                                  WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10700() THEN -1 * MIContainer.Amount -- знак наоборот т.к. это проводка покупателя
                                  ELSE 0
                             END) AS SummOut_PriceList
                        -- 5.3.2. Сумма у покупателя Разница с оптовыми ценами
                      , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10200()     THEN  1 * MIContainer.Amount -- знак наоборот т.к. это проводка покупателя
                                  WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10200() THEN -1 * MIContainer.Amount -- знак наоборот т.к. это проводка покупателя
                                  ELSE 0
                             END) AS SummOut_Diff
                        -- 5.3.3. Сумма у покупателя Скидка дополнительная
                      , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10300()     THEN  1 * MIContainer.Amount -- знак наоборот т.к. это проводка покупателя
                                  WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10300() THEN -1 * MIContainer.Amount -- знак наоборот т.к. это проводка покупателя
                                  ELSE 0
                             END) AS SummOut_Change

                 FROM tmpAnalyzer
                      INNER JOIN MovementItemContainer AS MIContainer
                                                       ON MIContainer.AnalyzerId = tmpAnalyzer.AnalyzerId
                                                      AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                      INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MIContainer.ObjectId_analyzer
                      INNER JOIN _tmpUnit ON _tmpUnit.UnitId = MIContainer.WhereObjectId_analyzer

                 GROUP BY MIContainer.ContainerId
                        , MIContainer.WhereObjectId_analyzer
                        , MIContainer.ObjectId_analyzer
                        , MIContainer.ObjectIntId_analyzer
                        , MIContainer.ObjectExtId_analyzer
                        , MIContainer.ContainerId_analyzer       
                        , MIContainer.AccountId
                        , MIContainer.isActive
                      
                  ) AS tmpContainer
     
                      LEFT JOIN tmpAccount ON tmpAccount.AccountId = tmpContainer.AccountId

                      LEFT JOIN ContainerLinkObject AS ContainerLO_Juridical
                                                    ON ContainerLO_Juridical.ContainerId = tmpContainer.ContainerId_analyzer
                                                   AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                      LEFT JOIN ContainerLinkObject AS ContainerLO_PaidKind
                                                    ON ContainerLO_PaidKind.ContainerId =  tmpContainer.ContainerId_analyzer
                                                   AND ContainerLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                      LEFT JOIN ContainerLinkObject AS ContainerLO_Member
                                                    ON ContainerLO_Member.ContainerId =  tmpContainer.ContainerId_analyzer
                                                   AND ContainerLO_Member.DescId = zc_ContainerLinkObject_Member()       
                      INNER JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                                                 ON ContainerLinkObject_InfoMoney.ContainerId = tmpContainer.ContainerId_analyzer
                                                                AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                                                AND (ContainerLinkObject_InfoMoney.ObjectId = inInfoMoneyId OR COALESCE (inInfoMoneyId, 0) = 0)  
                  
                      WHERE (ContainerLO_Juridical.ObjectId = inJuridicalId OR inJuridicalId = 0)
                        AND (ContainerLO_PaidKind.ObjectId = inPaidKindId OR inPaidKindId=0 OR (ContainerLO_Member.ObjectId > 0 AND inPaidKindId = zc_Enum_PaidKind_SecondForm()))

                      GROUP BY tmpContainer.LocationId
                             , tmpContainer.GoodsId
                             , tmpContainer.GoodsKindId
                             , tmpContainer.PartnerId
                             , CASE WHEN ContainerLO_Member.ObjectId > 0 THEN zc_Enum_PaidKind_SecondForm() ELSE COALESCE (ContainerLO_PaidKind.ObjectId,0) END
                             , COALESCE (ContainerLO_Juridical.ObjectId,  COALESCE (ContainerLO_Member.ObjectId, 0 ))
                             , ContainerLinkObject_InfoMoney.ObjectId

                    ) AS tmpOperationGroup

          LEFT JOIN Object AS Object_Location ON Object_Location.Id = tmpOperationGroup.LocationId
          LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpOperationGroup.PartnerId
          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpOperationGroup.JuridicalId
          LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpOperationGroup.PaidKindId

          LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpOperationGroup.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpOperationGroup.GoodsKindId
          LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                               ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id 
                              AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
          LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

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

          LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpOperationGroup.InfoMoneyId
          
  ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.07.14                                        * all
 22.07.15         *                
 15.12.14                                        * all
 13.05.14                                        * all
 16.04.14         add inUnitId
 13.04.14                                        * add zc_MovementFloat_ChangePercent
 08.04.14                                        * all
 05.04.14         * add SummPartner_calc. AmountChangePercent
 04.02.14         * 
 01.02.14                                        * All
 22.01.14         *
*/

-- тест
-- SELECT * FROM gpReport_GoodsMI (inStartDate:= '01.01.2013', inEndDate:= '31.12.2013',  inDescId:= 5, inGoodsGroupId:= 0, inUnitGroupId:=0, inUnitId:= 0, inPaidKindId:=0, inJuridicalId:=0, inInfoMoneyId:=0, inSession:= zfCalc_UserAdmin());
