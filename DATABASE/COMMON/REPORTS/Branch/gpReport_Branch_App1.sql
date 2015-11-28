-- Function: gpReport_Branch_App1()

DROP FUNCTION IF EXISTS gpReport_Branch_App1 (TDateTime, TDateTime,  Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Branch_App1(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inBranchId           Integer,    -- Филиал
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (BranchName TVarChar
             , SummStart TFloat, WeightStart TFloat, SummEnd TFloat, WeightEnd TFloat
             , SendOnPriceInSumm TFloat, SendOnPriceInWeight TFloat
             , ReturnInSumm TFloat, ReturnInWeight TFloat
             , PeresortInSumm TFloat, PeresortInWeight TFloat
             , PeresortOutSumm TFloat, PeresortOutWeight TFloat
             , SaleSumm TFloat, SaleWeight TFloat, SaleRealSumm TFloat
             , SendOnPriceOutSumm TFloat, SendOnPriceOutWeight TFloat
             , Sale_40208_Summ TFloat, Sale_40208_Weight TFloat
             , Sale_10500_Summ TFloat, Sale_10500_Weight TFloat
             , Sale_10200_Summ TFloat
             , Sale_10300_Summ TFloat
             , LossSumm TFloat, LossWeight TFloat
             , InventorySumm TFloat, InventoryWeight TFloat   
             , SummInventory_RePrice TFloat          
              )
AS
$BODY$
   DECLARE vbUserId Integer;

BEGIN
     vbUserId:= lpGetUserBySession (inSession);


    CREATE TEMP TABLE _tmpBranch (BranchId Integer) ON COMMIT DROP; 
   

    -- Филиал
    IF COALESCE (inBranchId, 0) = 0 AND 0 < (SELECT BranchId FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND BranchId <> 0 GROUP BY BranchId)
    THEN
       RAISE EXCEPTION 'Ошибка. Не выбран Филиал.';
    ELSE
    IF COALESCE (inBranchId,0) = 0
    THEN
       INSERT INTO _tmpBranch (BranchId)
           SELECT Object.Id AS BranchId FROM Object WHERE Object.DescId = zc_Object_Branch() and Object.Id <> zc_Branch_Basis() and Object.isErased = False AND Object.ObjectCode not in (6,8,10);
    ELSE
       INSERT INTO _tmpBranch (BranchId)
           SELECT inBranchId;
    END IF;
    END IF;


    -- Результат
     RETURN QUERY
   WITH tmpUnitList AS (SELECT Object_Unit_View.* 
                        From _tmpBranch
                            INNER JOIN Object_Unit_View ON Object_Unit_View.BranchId = _tmpBranch.BranchId
                        )

  , tmpContainerList AS (SELECT tmpUnitList.BranchId,  Container.Id AS ContainerId, Object_Account_View.AccountDirectionId, Container.*
                         FROM tmpUnitList 
                             INNER JOIN ContainerLinkObject AS CLO_Unit
                                                ON CLO_Unit.ObjectId = tmpUnitList.Id
                                               AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit() 
                             INNER JOIN Container ON Container.Id = CLO_Unit.ContainerId
                                               ---  AND Container.DescId = zc_Container_Summ()    
                             LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = Container.ObjectId
                        -- WHERE Object_Account_View.AccountDirectionId = zc_Enum_AccountDirection_20700() 
                        )

      , tmpGoodsSumm AS (SELECT tmpContainerList.BranchId
                          , tmpContainerList.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) AS SummStart 
                          , tmpContainerList.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS SummEnd
                          , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = TRUE THEN MIContainer.Amount 
                                    ELSE 0 END) AS SummIn
                          , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = FALSE THEN -1 * MIContainer.Amount
                                    ELSE 0 END) AS SummOut

                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate  THEN -1 * MIContainer.Amount                                        --Sale
                                    ELSE 0 END) AS SummSale
                                                                             
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() 
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate  
                                       AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_40200() 
                                      THEN -1 * MIContainer.Amount                                        ---- Сумма с/с, реализация, Разница в весе
                                      ELSE 0 END) AS SummSale_40208
   
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() 
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate  
                                       AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10500()  -- Сумма с/с, реализация, Скидка за вес
                                      THEN -1 * MIContainer.Amount                                        
                                      ELSE 0 END) AS SummSale_10500
                          , 0 AS SummSale_10200
                          , 0 AS SummSale_10300
                          , 0 AS SummSaleReal                                                                                       
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ReturnIn() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount                                         ---ReturnIn
                                    ELSE 0 END) AS SummReturnIn
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_SendOnPrice() AND MIContainer.isActive = TRUE AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount                              ---перемещение по цене
                                    ELSE 0 END) AS SummSendOnPriceIn
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_SendOnPrice() AND MIContainer.isActive = FALSE AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN -1 * MIContainer.Amount                              ---перемещение по цене
                                    ELSE 0 END) AS SummSendOnPriceOut                                        
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Loss() AND MIContainer.isActive = FALSE AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN -1 * MIContainer.Amount                                     ---Списание
                                    ELSE 0 END) AS SummLoss 
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ProductionUnion() AND MIContainer.isActive = True AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN  MIContainer.Amount                                     ---Списание
                                    ELSE 0 END) AS SummPeresortIn                                                                    -- приход пересортица  
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ProductionUnion() AND MIContainer.isActive = False AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN  MIContainer.Amount                                     ---Списание
                                    ELSE 0 END) AS SummPeresortOut                                                                    -- расход пересортица  
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Inventory() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN  MIContainer.Amount                                     ---Списание
                                    ELSE 0 END) AS SummInventory 
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Inventory() 
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                       AND MIContainer.AnalyzerId = zc_Enum_AccountGroup_60000()
                                      THEN  MIContainer.Amount                                     ---Списание
                                      ELSE 0 END) AS SummInventory_RePrice
                     FROM tmpContainerList
                          LEFT JOIN MovementItemContainer AS MIContainer 
                                                          ON MIContainer.ContainerId = tmpContainerList.ContainerId 
                                                          AND MIContainer.OperDate >= inStartDate 
                     WHERE tmpContainerList.DescId = zc_Container_Summ() 
                       AND tmpContainerList.AccountDirectionId = zc_Enum_AccountDirection_20700() 
                     GROUP BY tmpContainerList.ContainerId, tmpContainerList.Amount, tmpContainerList.BranchId

                     UNION ALL

                        SELECT tmpUnitList.BranchId 
                          , 0 AS SummStart 
                          , 0 AS SummEnd
                          , 0 AS SummIn
                          , 0 AS SummOut
                          , 0 AS SummSale
                          , 0 AS SummSale_40208
                          , 0 AS SummSale_10500
                          , SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10200()  -- Сумма, реализация, Разница с оптовыми ценами т.е. это сумма акции
                                      THEN -1 * MIContainer.Amount                                        
                                      ELSE 0 END) AS SummSale_10200
                          , SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10300()  -- скидка по накладной,
                                      THEN -1 * MIContainer.Amount                                        
                                      ELSE 0 END) AS SummSale_10300
                          , SUM (MIContainer.Amount) AS SummSaleReal
                          , 0 AS SummReturnIn
                          , 0 AS SummSendOnPriceIn
                          , 0 AS SummSendOnPriceOut                                        
                          , 0 AS SummLoss 
                          , 0 AS SummPeresortIn                                                                     -- приход пересортица  
                          , 0 AS SummPeresortOut                                                                    -- расход пересортица  
                          , 0 AS SummInventory 
                          , 0 AS SummInventory_RePrice   
                       FROM tmpUnitList
                              INNER JOIN ContainerLinkObject AS CLO_Branch
                                                             ON CLO_Branch.ObjectId = tmpUnitList.BranchId 
                                                            AND CLO_Branch.DescId = zc_ContainerLinkObject_Branch() 
                          
                              INNER JOIN ContainerLinkObject AS CLO_Juridical
                                                             ON CLO_Juridical.ContainerId = CLO_Branch.ContainerId
                                                            AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                                            AND CLO_Juridical.ObjectId <> 0
                              INNER JOIN Container ON Container.Id = CLO_Juridical.ContainerId
                                                            AND Container.DescId = zc_Container_Summ() 
                              LEFT JOIN MovementItemContainer AS MIContainer
                                                       ON MIContainer.Containerid = Container.Id
                                                      AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate 
                                                      AND MIContainer.MovementDescId = zc_Movement_Sale()
                        GROUP BY CLO_Juridical.ContainerId, tmpUnitList.BranchId 


                    )

, tmpGoodsCount AS  (SELECT tmpContainerList.BranchId, tmpContainerList.ObjectId AS GoodsId
                          , tmpContainerList.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) AS CountStart 
                          , tmpContainerList.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS CountEnd
                          , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = TRUE THEN MIContainer.Amount 
                                    ELSE 0 END) AS CountIn
                          , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = FALSE THEN -1 * MIContainer.Amount
                                    ELSE 0 END) AS CountOut

                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate  THEN -1 * MIContainer.Amount                                        --Sale
                                    ELSE 0 END) AS CountSale
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() 
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                       AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400() -- Сумма с/с, реализация, у покупателя
                                       AND MIContainer.ContainerId_Analyzer <> 0
                                      THEN -1 * MIContainer.Amount                                        --Sale
                                      ELSE 0 END) AS CountSaleReal
                                                   
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() 
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate  
                                       AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_40200() 
                                      THEN -1 * MIContainer.Amount                                        ---- Сумма с/с, реализация, Разница в весе
                                      ELSE 0 END) AS CountSale_40208
   
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() 
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate  
                                       AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10500()  -- Сумма с/с, реализация, Скидка за вес
                                      THEN -1 * MIContainer.Amount                                        
                                      ELSE 0 END) AS CountSale_10500
                                                                                                                  
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ReturnIn() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount                                         ---ReturnIn
                                    ELSE 0 END) AS CountReturnIn
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_SendOnPrice() AND MIContainer.isActive = TRUE AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount                              ---перемещение по цене
                                    ELSE 0 END) AS CountSendOnPriceIn
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_SendOnPrice() AND MIContainer.isActive = FALSE AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN -1 * MIContainer.Amount                              ---перемещение по цене
                                    ELSE 0 END) AS CountSendOnPriceOut                                        
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Loss() AND MIContainer.isActive = FALSE AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN -1 * MIContainer.Amount                                     ---Списание
                                    ELSE 0 END) AS CountLoss 
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ProductionUnion() AND MIContainer.isActive = True AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN  MIContainer.Amount                                     ---Списание
                                    ELSE 0 END) AS CountPeresortIn                                               --приход      
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ProductionUnion() AND MIContainer.isActive = False AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN  MIContainer.Amount                                     ---Списание
                                    ELSE 0 END) AS CountPeresortOut                                              --расход                                  
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Inventory() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN  MIContainer.Amount                                     ---Списание
                                    ELSE 0 END) AS CountInventory 
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Inventory() 
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                       AND MIContainer.AnalyzerId = zc_Enum_AccountGroup_60000()
                                      THEN  MIContainer.Amount                                     
                                      ELSE 0 END) AS CountInventory_RePrice
                     FROM tmpContainerList
                          LEFT JOIN MovementItemContainer AS MIContainer 
                                                          ON MIContainer.ContainerId = tmpContainerList.ContainerId 
                                                          AND MIContainer.OperDate >= inStartDate 
                     WHERE tmpContainerList.DescId = zc_Container_Count() 
                     GROUP BY tmpContainerList.ContainerId, tmpContainerList.Amount, tmpContainerList.BranchId, tmpContainerList.ObjectId
                    )
    , tmpGoodsWeight AS (
                   SELECT tmpGoodsCount.BranchId 
                        , CAST (tmpGoodsCount.CountStart * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END                   AS TFloat) AS CountStart
                        , CAST (tmpGoodsCount.CountEnd * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END                     AS TFloat) AS CountEnd
                        , CAST (tmpGoodsCount.CountIn * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END                      AS TFloat) AS CountIn
                        , CAST (tmpGoodsCount.CountOut * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END                     AS TFloat) AS CountOut
                        , CAST (tmpGoodsCount.CountSale * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END                    AS TFloat) AS CountSale
                        , CAST (tmpGoodsCount.CountSaleReal * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END                AS TFloat) AS CountSaleReal
                        , CAST (tmpGoodsCount.CountReturnIn * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END                AS TFloat) AS CountReturnIn
                        , CAST (tmpGoodsCount.CountSendOnPriceIn * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END           AS TFloat) AS CountSendOnPriceIn
                        , CAST (tmpGoodsCount.CountLoss * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END           AS TFloat) AS CountLoss    
                        , CAST (tmpGoodsCount.CountSendOnPriceOut * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END          AS TFloat) AS CountSendOnPriceOut  
                        , CAST (tmpGoodsCount.CountPeresortIn * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END                AS TFloat) AS CountPeresortIn  
                        , CAST (tmpGoodsCount.CountPeresortOut * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END                AS TFloat) AS CountPeresortOut    
                        , CAST (tmpGoodsCount.CountInventory * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END               AS TFloat) AS CountInventory
                        , CAST (tmpGoodsCount.CountSale_40208 * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END              AS TFloat) AS CountSale_40208
                        , CAST (tmpGoodsCount.CountSale_10500 * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END              AS TFloat) AS CountSale_10500
                        , CAST (tmpGoodsCount.CountInventory_RePrice * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END       AS TFloat) AS CountInventory_RePrice
                   FROM tmpGoodsCount
                      LEFT JOIN ObjectLink AS OL_Goods_Measure 
                                          ON OL_Goods_Measure.ObjectId = tmpGoodsCount.GoodsId
                                         AND OL_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                      LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                            ON ObjectFloat_Weight.ObjectId = tmpGoodsCount.GoodsId
                                           AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                     )

 
  SELECT  Object_Branch.ValueData  ::TVarChar   AS BranchName

       
        , CAST (SUM (tmpAll.SummStart)         AS TFloat) AS SummStart
        , CAST (SUM (tmpAll.CountStart)        AS TFloat) AS WeightStart
        , CAST (SUM (tmpAll.SummEnd)           AS TFloat) AS SummEnd
        , CAST (SUM (tmpAll.CountEnd)          AS TFloat) AS WeightEnd

        , CAST (SUM (tmpAll.SummSendOnPriceIn)            AS TFloat) AS SummSendOnPriceInSumm
        , CAST (SUM (tmpAll.CountSendOnPriceIn)           AS TFloat) AS IncomeWeight
        
        , CAST (SUM (tmpAll.SummReturnIn)                 AS TFloat) AS ReturnInSumm
        , CAST (SUM (tmpAll.CountReturnIn)                AS TFloat) AS ReturnInWeight

        , CAST (SUM (tmpAll.SummPeresortIn)               AS TFloat) AS PeresortInSumm
        , CAST (SUM (tmpAll.CountPeresortOut)             AS TFloat) AS PeresortInWeight
        , CAST (SUM (tmpAll.SummPeresortIn)               AS TFloat) AS PeresortOutSumm
        , CAST (SUM (tmpAll.CountPeresortOut)             AS TFloat) AS PeresortOutWeight
                
        , CAST (SUM (tmpAll.SummSale)                     AS TFloat) AS SaleSumm
        , CAST (SUM (tmpAll.CountSale)                    AS TFloat) AS SaleWeight
        
        , CAST (SUM (tmpAll.SummSaleReal)                 AS TFloat) AS SaleRealSumm
        
        , CAST (SUM (tmpAll.SummSendOnPriceOut)           AS TFloat) AS SendOnPriceOutSumm
        , CAST (SUM (tmpAll.CountSendOnPriceOut)          AS TFloat) AS SendWeight
        
        , CAST (SUM (tmpAll.SummSale_40208)               AS TFloat) AS Sale_40208_Summ
        , CAST (SUM (tmpAll.CountSale_40208)              AS TFloat) AS Sale_40208_Weight

        , CAST (SUM (tmpAll.SummSale_10500)               AS TFloat) AS Sale_10500_Summ
        , CAST (SUM (tmpAll.CountSale_10500)              AS TFloat) AS Sale_10500_Weight

        , CAST (SUM (tmpAll.SummSale_10200)               AS TFloat) AS Sale_10200_Summ
        , CAST (SUM (tmpAll.SummSale_10300)               AS TFloat) AS Sale_10300_Summ
        
        , CAST (SUM (tmpAll.SummLoss)                     AS TFloat) AS LossSumm
        , CAST (SUM (tmpAll.CountLoss)                    AS TFloat) AS LossWeight
        , CAST (SUM (tmpAll.SummInventory)                AS TFloat) AS InventorySumm
        , CAST (SUM (tmpAll.CountInventory)               AS TFloat) AS InventoryWeight
        , CAST (SUM (tmpAll.SummInventory_RePrice)        AS TFloat) AS SummInventory_RePrice
  
      FROM 
                  (SELECT tmpGoodsSumm.BranchId 
                        , CAST (SUM (tmpGoodsSumm.SummStart) AS NUMERIC (16, 2))   AS SummStart
                        , CAST (SUM (tmpGoodsSumm.SummEnd) AS NUMERIC (16, 2))     AS SummEnd
                        , CAST (SUM (tmpGoodsSumm.SummIn) AS NUMERIC (16, 2))      AS SummIn
                        , CAST (SUM (tmpGoodsSumm.SummOut) AS NUMERIC (16, 2))     AS SummOut
                        , CAST (SUM (tmpGoodsSumm.SummSale) AS NUMERIC (16, 2))           AS SummSale
                        , CAST (SUM (tmpGoodsSumm.SummSaleReal) AS NUMERIC (16, 2))       AS SummSaleReal
                        , CAST (SUM (tmpGoodsSumm.SummReturnIn) AS NUMERIC (16, 2))       AS SummReturnIn
                        , CAST (SUM (tmpGoodsSumm.SummSendOnPriceIn) AS NUMERIC (16, 2))  AS SummSendOnPriceIn
                        , CAST (SUM (tmpGoodsSumm.SummLoss) AS NUMERIC (16, 2))           AS SummLoss    
                        , CAST (SUM (tmpGoodsSumm.SummSendOnPriceOut) AS NUMERIC (16, 2)) AS SummSendOnPriceOut  
                        , CAST (SUM (tmpGoodsSumm.SummPeresortIn) AS NUMERIC (16, 2))     AS SummPeresortIn    
                        , CAST (SUM (tmpGoodsSumm.SummPeresortOut) AS NUMERIC (16, 2))    AS SummPeresortOut    
                        , CAST (SUM (tmpGoodsSumm.SummInventory) AS NUMERIC (16, 2))  AS SummInventory
                        , CAST (SUM (tmpGoodsSumm.SummSale_40208) AS NUMERIC (16, 2)) AS SummSale_40208
                        , CAST (SUM (tmpGoodsSumm.SummSale_10500) AS NUMERIC (16, 2)) AS SummSale_10500
                        , CAST (SUM (tmpGoodsSumm.SummSale_10200) AS NUMERIC (16, 2)) AS SummSale_10200
                        , CAST (SUM (tmpGoodsSumm.SummSale_10300) AS NUMERIC (16, 2)) AS SummSale_10300
                        , CAST (SUM (tmpGoodsSumm.SummInventory_RePrice) AS NUMERIC (16, 2)) AS SummInventory_RePrice
                        , 0 AS CountStart
                        , 0 AS CountEnd
                        , 0 AS CountIn
                        , 0 AS CountOut
                        , 0 AS CountSale
                        , 0 AS CountSaleReal
                        , 0 AS CountReturnIn
                        , 0 AS CountSendOnPriceIn
                        , 0 AS CountLoss    
                        , 0 AS CountSendOnPriceOut  
                        , 0 AS CountPeresortIn    
                        , 0 AS CountPeresortOut    
                        , 0 AS CountInventory
                        , 0 AS CountSale_40208
                        , 0 AS CountSale_10500
                        , 0 AS CountInventory_RePrice

                   FROM tmpGoodsSumm
                   GROUP BY tmpGoodsSumm.BranchId
               UNION ALL
                   SELECT tmpGoodsWeight.BranchId 
                        , 0 AS SummStart
                        , 0 AS SummEnd
                        , 0 AS SummIn
                        , 0 AS SummOut
                        , 0 AS SummSale
                        , 0 AS SummSaleReal
                        , 0 AS SummReturnIn
                        , 0 AS SummSendOnPriceIn
                        , 0 AS SummLoss    
                        , 0 AS SummSendOnPriceOut  
                        , 0 AS SummPeresortIn    
                        , 0 AS SummPeresortOut    
                        , 0 AS SummInventory
                        , 0 AS SummSale_40208
                        , 0 AS SummSale_10500
                        , 0 AS SummSale_10200
                        , 0 AS SummSale_10300
                        , 0 AS SummInventory_RePrice
                        , CAST (SUM (tmpGoodsWeight.CountStart) AS NUMERIC (16, 2))   AS CountStart
                        , CAST (SUM (tmpGoodsWeight.CountEnd) AS NUMERIC (16, 2))     AS CountEnd
                        , CAST (SUM (tmpGoodsWeight.CountIn) AS NUMERIC (16, 2))      AS CountIn
                        , CAST (SUM (tmpGoodsWeight.CountOut) AS NUMERIC (16, 2))     AS CountOut
                        , CAST (SUM (tmpGoodsWeight.CountSale) AS NUMERIC (16, 2))           AS CountSale
                        , CAST (SUM (tmpGoodsWeight.CountSaleReal) AS NUMERIC (16, 2))       AS CountSaleReal
                        , CAST (SUM (tmpGoodsWeight.CountReturnIn) AS NUMERIC (16, 2))       AS CountReturnIn
                        , CAST (SUM (tmpGoodsWeight.CountSendOnPriceIn) AS NUMERIC (16, 2))  AS CountSendOnPriceIn
                        , CAST (SUM (tmpGoodsWeight.CountLoss) AS NUMERIC (16, 2))           AS CountLoss    
                        , CAST (SUM (tmpGoodsWeight.CountSendOnPriceOut) AS NUMERIC (16, 2)) AS CountSendOnPriceOut  
                        , CAST (SUM (tmpGoodsWeight.CountPeresortIn) AS NUMERIC (16, 2))     AS CountPeresortIn 
                        , CAST (SUM (tmpGoodsWeight.CountPeresortOut) AS NUMERIC (16, 2))    AS CountPeresortOut    
                        , CAST (SUM (tmpGoodsWeight.CountInventory) AS NUMERIC (16, 2))      AS CountInventory
                        , CAST (SUM (tmpGoodsWeight.CountSale_40208) AS NUMERIC (16, 2))     AS CountSale_40208
                        , CAST (SUM (tmpGoodsWeight.CountSale_10500) AS NUMERIC (16, 2))     AS CountSale_10500
                        , CAST (SUM (tmpGoodsWeight.CountInventory_RePrice) AS NUMERIC (16, 2)) AS CountInventory_RePrice
                   FROM tmpGoodsWeight
                   GROUP BY tmpGoodsWeight.BranchId
                ) AS tmpAll

          LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpAll.BranchId   --CASE WHEN COALESCE(inBranchId,0) <> 0 THEN inBranchId END
      GROUP BY  Object_Branch.ValueData  
      ORDER BY Object_Branch.ValueData 

      ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 22.11.15         * 

*/

-- тест
--SELECT * FROM gpReport_Branch_App1 (inStartDate:= '01.11.2015'::TDateTime, inEndDate:= '03.11.2015'::TDateTime, inBranchId:= 8374, inSession:= zfCalc_UserAdmin())  --8374
--
--select * from gpReport_Branch_App1(inStartDate := ('03.08.2015')::TDateTime , inEndDate := ('03.08.2015')::TDateTime , inBranchId := 0 ,  inSession := '5');