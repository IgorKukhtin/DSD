-- Function: gpReport_Branch_App1()

DROP FUNCTION IF EXISTS gpReport_Branch_App1_New (TDateTime, TDateTime,  Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Branch_App1_New(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inBranchId           Integer,    -- Филиал
    IN inIsUnit             Boolean,    -- развернуть по подразделениям
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (BranchName TVarChar, UnitName TVarChar
             , SummStart TFloat, WeightStart TFloat, SummEnd TFloat, WeightEnd TFloat
             , SendOnPriceInSumm TFloat, SendOnPriceInWeight TFloat
             , ReturnInSumm TFloat, ReturnInWeight TFloat
             , ReturnInRealSumm TFloat, ReturnInRealSumm_A TFloat, ReturnInRealSumm_P TFloat, ReturnIn_10200_Summ TFloat, ReturnIn_10300_Summ TFloat
             , PeresortInSumm TFloat, PeresortInWeight TFloat
             , PeresortOutSumm TFloat, PeresortOutWeight TFloat
             , SaleSumm TFloat, SaleSumm_Vz TFloat, SaleWeight TFloat, SaleWeight_Vz TFloat
             , SaleRealSumm TFloat, SaleRealSumm_A TFloat, SaleRealSumm_P TFloat
             , SaleRealSumm_Vz TFloat, SaleRealSumm_A_Vz TFloat, SaleRealSumm_P_Vz TFloat
             , SendOnPriceOutSumm TFloat, SendOnPriceOutWeight TFloat
             , Sale_40208_Summ TFloat, Sale_40208_Summ_Vz TFloat, Sale_40208_Weight TFloat, Sale_40208_Weight_Vz TFloat
             , Sale_10500_Summ TFloat, Sale_10500_Summ_Vz TFloat, Sale_10500_Weight TFloat, Sale_10500_Weight_Vz TFloat
             , Sale_10200_Summ TFloat, Sale_10250_Summ TFloat, Sale_10300_Summ TFloat
             , Sale_10200_Summ_Vz TFloat, Sale_10250_Summ_Vz TFloat, Sale_10300_Summ_Vz TFloat
             , LossSumm TFloat, LossWeight TFloat
             , InventorySumm TFloat, InventoryWeight TFloat   
             , SummInventory_RePrice TFloat 

             , SummStart_Vz TFloat, WeightStart_Vz TFloat, SummEnd_Vz TFloat, WeightEnd_Vz TFloat
             , ReturnInSumm_Vz TFloat, PeresortInSumm_Vz TFloat, PeresortOutSumm_Vz TFloat, SendOnPriceOutSumm_Vz TFloat, LossSumm_Vz TFloat, InventorySumm_Vz TFloat, SummInventory_RePrice_Vz TFloat
             , ReturnInWeight_Vz TFloat, PeresortInWeight_Vz TFloat, PeresortOutWeight_Vz TFloat, SendOnPriceOutWeight_Vz TFloat, LossWeight_Vz TFloat, InventoryWeight_Vz TFloat, WeightInventory_RePrice_Vz TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;

BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    -- !!!Только просмотр Аудитор!!!
    PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    
    -- CREATE TEMP TABLE _tmpBranch (BranchId Integer) ON COMMIT DROP; 
   

    -- Филиал
    IF COALESCE (inBranchId, 0) = 0 AND 0 < (SELECT BranchId FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND BranchId <> 0 GROUP BY BranchId)
    THEN
       RAISE EXCEPTION 'Ошибка. Не выбран Филиал.';
    /*ELSE
    IF COALESCE (inBranchId,0) = 0
    THEN
       INSERT INTO _tmpBranch (BranchId)
           SELECT Object.Id AS BranchId FROM Object WHERE Object.DescId = zc_Object_Branch() and Object.Id <> zc_Branch_Basis() and Object.isErased = False AND Object.ObjectCode not in (6,8,10);
    ELSE
       INSERT INTO _tmpBranch (BranchId)
           SELECT inBranchId;
    END IF;*/
    END IF;


    -- Результат
     RETURN QUERY
   WITH 
         _tmpBranch AS (SELECT Object.Id AS BranchId FROM Object WHERE Object.DescId = zc_Object_Branch() and Object.Id <> zc_Branch_Basis() and Object.isErased = False AND Object.ObjectCode not in (6,8,10)
                                                                   AND COALESCE (inBranchId,0) = 0
                  UNION SELECT inBranchId WHERE inBranchId <> 0
                       )
         -- выбираем склады возвратов (пока так), чтобы выделить движение                   
       , tmpUnitVz AS (SELECT Object_Unit_View.Id AS UnitVzId
                        FROM Object_Unit_View 
                        WHERE Object_Unit_View.Name like '%возврат%'   --.Code in (22022, 22122, 22032, 22052, 22082, 22092, 22042)
                        )
    ,   tmpUnitList AS (SELECT Object_Unit_View.* 
                             , CASE WHEN Object_Unit_View.Id in (SELECT tmpUnitVz.UnitVzId FROM tmpUnitVz) THEN TRUE ELSE FALSE END AS isUnit_Vz
                        FROM _tmpBranch
                            INNER JOIN Object_Unit_View ON Object_Unit_View.BranchId = _tmpBranch.BranchId
                     -- where Object_Unit_View.id <> 8425
                        )
     
  , tmpContainerListSum AS (SELECT tmpUnitList.BranchId, tmpUnitList.Id AS UnitId, tmpUnitList.isUnit_Vz, Container.Id AS ContainerId
                                 , Container.*
                         FROM tmpUnitList 
                             INNER JOIN ContainerLinkObject AS CLO_Unit
                                                ON CLO_Unit.ObjectId = tmpUnitList.Id
                                               AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit() 
                             INNER JOIN Container ON Container.Id = CLO_Unit.ContainerId
                                                 AND Container.DescId = zc_Container_Summ()    
                             INNER JOIN Object_Account_View ON Object_Account_View.AccountId = Container.ObjectId
                                                           AND Object_Account_View.AccountDirectionId = zc_Enum_AccountDirection_20700() 
                        )
, tmpContainerList AS (SELECT tmpUnitList.BranchId, tmpUnitList.Id AS UnitId, tmpUnitList.isUnit_Vz, Container.Id AS ContainerId
                            , Container.*
                         FROM tmpUnitList 
                              INNER JOIN ContainerLinkObject AS CLO_Unit
                                                             ON CLO_Unit.ObjectId = tmpUnitList.Id
                                                            AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit() 
                              INNER JOIN Container ON Container.Id     = CLO_Unit.ContainerId
                                                  AND Container.DescId = zc_Container_Count()    
                              INNER JOIN Object ON Object.Id     = Container.ObjectId
                                               AND Object.DescId = zc_Object_Goods()    
                              LEFT JOIN ContainerLinkObject AS CLO_Member
                                                            ON CLO_Member.ContainerId = Container.Id
                                                           AND CLO_Member.DescId      = zc_ContainerLinkObject_Member() 
                              LEFT JOIN ContainerLinkObject AS CLO_Car
                                                            ON CLO_Car.ContainerId = Container.Id
                                                           AND CLO_Car.DescId      = zc_ContainerLinkObject_Car() 
                         WHERE CLO_Member.ContainerId IS NULL AND CLO_Car.ContainerId IS NULL
                        )
  , tmpGoodsSumm AS (SELECT tmpContainerListSum.BranchId
                          , CASE WHEN inIsUnit = TRUE THEN tmpContainerListSum.UnitId ELSE 0 END AS UnitId
                          , CASE WHEN tmpContainerListSum.isUnit_Vz = FALSE
                                 THEN tmpContainerListSum.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) 
                                 ELSE 0 END AS SummStart 
                          , CASE WHEN tmpContainerListSum.isUnit_Vz = FALSE
                                 THEN tmpContainerListSum.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) 
                                 ELSE 0 END AS SummEnd
                                 
                          , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = TRUE THEN MIContainer.Amount 
                                    ELSE 0 END) AS SummIn
                          , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = FALSE THEN -1 * MIContainer.Amount
                                    ELSE 0 END) AS SummOut

                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() 
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                       AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10400()       ---Сумма с/с, реализация, у покупателя
                                       AND tmpContainerListSum.isUnit_Vz = FALSE
                                      THEN -1 * MIContainer.Amount                                        
                                    ELSE 0 END) AS SummSale
                            -- !!!
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() 
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                       AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10400() 
                                                                   /*IN (zc_Enum_AnalyzerId_SaleSumm_10400()
                                                                       , zc_Enum_AnalyzerId_SaleSumm_40200()
                                                                       , zc_Enum_AnalyzerId_SaleSumm_10500())*/
                                       AND tmpContainerListSum.isUnit_Vz = TRUE
                                      THEN -1 * MIContainer.Amount                                        
                                    ELSE 0 END) AS SummSale_VZ
                                                                             
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() 
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate  
                                       AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_40200() 
                                       AND tmpContainerListSum.isUnit_Vz = FALSE
                                      THEN -1 * MIContainer.Amount                                        ---- Сумма с/с, реализация, Разница в весе
                                      ELSE 0 END) AS SummSale_40208

                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() 
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate  
                                       AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_40200() 
                                       AND tmpContainerListSum.isUnit_Vz = TRUE
                                      THEN -1 * MIContainer.Amount                                        ---- Сумма с/с, реализация, Разница в весе
                                      ELSE 0 END) AS SummSale_40208_Vz

                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale()
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate  
                                       AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10500()  -- Сумма с/с, реализация, Скидка за вес
                                       AND tmpContainerListSum.isUnit_Vz = FALSE
                                      THEN -1 * MIContainer.Amount                                        
                                      ELSE 0 END) AS SummSale_10500
                                      
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale()
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate  
                                       AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10500()  -- Сумма с/с, реализация, Скидка за вес
                                       AND tmpContainerListSum.isUnit_Vz = TRUE
                                      THEN -1 * MIContainer.Amount                                        
                                      ELSE 0 END) AS SummSale_10500_Vz

                          , 0 AS SummSale_10200
                          , 0 AS SummSale_10250
                          , 0 AS SummSale_10300
                          , 0 AS SummSaleReal  
                          , 0 AS SummSaleReal_A
                          , 0 AS SummSaleReal_P
                          , 0 AS SummSale_10200_Vz
                          , 0 AS SummSale_10250_Vz
                          , 0 AS SummSale_10300_Vz
                          , 0 AS SummSaleReal_Vz  
                          , 0 AS SummSaleReal_A_Vz
                          , 0 AS SummSaleReal_P_Vz
                          , 0 AS SummReturnIn_10200
                          , 0 AS SummReturnIn_10300
                          , 0 AS SummReturnInReal
                          , 0 AS SummReturnInReal_A
                          , 0 AS SummReturnInReal_P
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ReturnIn() 
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate 
                                       AND tmpContainerListSum.isUnit_Vz = FALSE
                                       THEN MIContainer.Amount                                         ---ReturnIn
                                    ELSE 0 END) AS SummReturnIn
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                       AND MIContainer.isActive = TRUE
                                       AND tmpContainerListSum.isUnit_Vz = FALSE 
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount                              ---перемещение по цене
                                    ELSE 0 END) AS SummSendOnPriceIn
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_SendOnPrice() 
                                       AND MIContainer.isActive = FALSE 
                                       AND tmpContainerListSum.isUnit_Vz = FALSE
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate 
                                      THEN -1 * MIContainer.Amount                        ---перемещение по цене
                                    ELSE 0 END) AS SummSendOnPriceOut                                        
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Loss() 
                                       AND MIContainer.isActive = FALSE 
                                       AND tmpContainerListSum.isUnit_Vz = FALSE
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                      THEN -1 * MIContainer.Amount                               ---Списание
                                    ELSE 0 END) AS SummLoss 
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ProductionUnion() 
                                       AND MIContainer.isActive = True 
                                       AND tmpContainerListSum.isUnit_Vz = FALSE
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate 
                                     THEN  MIContainer.Amount                                     ---Списание
                                    ELSE 0 END) AS SummPeresortIn                                                                    -- приход пересортица  
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                                       AND MIContainer.isActive = False 
                                       AND tmpContainerListSum.isUnit_Vz = FALSE
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate 
                                     THEN  MIContainer.Amount                                     
                                    ELSE 0 END) AS SummPeresortOut                                                                   -- расход пересортица  
                                    
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Inventory() 
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate 
                                       AND tmpContainerListSum.isUnit_Vz = FALSE
                                       AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AccountGroup_60000() -- Прибыль будущих периодов
                                     THEN  -1 * MIContainer.Amount                                     
                                    ELSE 0 END) AS SummInventory 
                                    
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Inventory() 
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                       AND tmpContainerListSum.isUnit_Vz = FALSE
                                       AND MIContainer.AnalyzerId = zc_Enum_AccountGroup_60000()
                                      THEN -1 * MIContainer.Amount                                               ---Списание
                                      ELSE 0 END) AS SummInventory_RePrice
                                      
                          , CASE WHEN tmpContainerListSum.isUnit_Vz = TRUE
                                 THEN tmpContainerListSum.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) 
                                 ELSE 0 END AS SummStart_Vz 
                          , CASE WHEN tmpContainerListSum.isUnit_Vz = TRUE
                                 THEN tmpContainerListSum.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) 
                                 ELSE 0 END AS SummEnd_Vz

                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ReturnIn() 
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate 
                                       AND tmpContainerListSum.isUnit_Vz = TRUE
                                      THEN MIContainer.Amount                                        
                                      ELSE 0 END) AS SummReturnIn_Vz
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                                       AND MIContainer.isActive = True 
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate 
                                       AND tmpContainerListSum.isUnit_Vz = TRUE
                                      THEN MIContainer.Amount                                    
                                    ELSE 0 END) AS SummPeresortIn_Vz                                                                    -- приход пересортица  
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ProductionUnion() 
                                       AND MIContainer.isActive = False 
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate 
                                       AND tmpContainerListSum.isUnit_Vz = TRUE
                                      THEN MIContainer.Amount                                    
                                    ELSE 0 END) AS SummPeresortOut_Vz                                                                   -- расход пересортица  
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                       AND MIContainer.isActive = FALSE 
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate 
                                       AND tmpContainerListSum.isUnit_Vz = TRUE
                                      THEN -1 * MIContainer.Amount                                                                       ---перемещение по цене расход 
                                    ELSE 0 END) AS SummSendOnPriceOut_Vz 
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Loss() 
                                       AND MIContainer.isActive = FALSE 
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate 
                                       AND tmpContainerListSum.isUnit_Vz = TRUE
                                      THEN -1 * MIContainer.Amount                               
                                    ELSE 0 END) AS SummLoss_Vz
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Inventory() 
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate 
                                       AND tmpContainerListSum.isUnit_Vz = TRUE
                                       AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AccountGroup_60000() -- Прибыль будущих периодов
                                      THEN -1 * MIContainer.Amount                                    
                                    ELSE 0 END) AS SummInventory_Vz
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Inventory() 
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                       AND MIContainer.AnalyzerId = zc_Enum_AccountGroup_60000()
                                       AND tmpContainerListSum.isUnit_Vz = TRUE
                                      THEN  -1 * MIContainer.Amount                                              
                                      ELSE 0 END) AS SummInventory_RePrice_Vz
                                    
                     FROM tmpContainerListSum
                          LEFT JOIN MovementItemContainer AS MIContainer 
                                                          ON MIContainer.ContainerId = tmpContainerListSum.ContainerId 
                                                          AND MIContainer.OperDate >= inStartDate 
                     GROUP BY tmpContainerListSum.ContainerId, tmpContainerListSum.Amount, tmpContainerListSum.BranchId,tmpContainerListSum.isUnit_Vz
                            , CASE WHEN inIsUnit = TRUE THEN tmpContainerListSum.UnitId ELSE 0 END
                     
                     UNION ALL

                     SELECT tmpUnitList.BranchId 
                          , CASE WHEN inIsUnit = TRUE THEN tmpUnitList.Id ELSE 0 END AS UnitId
                          , 0 AS SummStart 
                          , 0 AS SummEnd
                          , 0 AS SummIn
                          , 0 AS SummOut
                          , 0 AS SummSale
                          , 0 AS SummSale_Vz
                          , 0 AS SummSale_40208
                          , 0 AS SummSale_40208_Vz
                          , 0 AS SummSale_10500
                          , 0 AS SummSale_10500_Vz

                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() 
                                       AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10200()  -- Сумма, реализация, Разница с оптовыми ценами
                                       AND tmpUnitList.isUnit_Vz = FALSE
                                      THEN -1 * MIContainer.Amount                                        
                                      ELSE 0 END) AS SummSale_10200
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale()
                                       AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10250()  -- Сумма, реализация, Скидка Акция
                                       AND tmpUnitList.isUnit_Vz = FALSE
                                      THEN -1 * MIContainer.Amount                                        
                                      ELSE 0 END) AS SummSale_10250
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() 
                                       AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10300()  -- Сумма, реализация, Скидка дополнительная
                                       AND tmpUnitList.isUnit_Vz = FALSE
                                      THEN -1 * MIContainer.Amount                                        
                                      ELSE 0 END) AS SummSale_10300
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() 
                                       AND tmpUnitList.isUnit_Vz = FALSE
                                      THEN 1 * MIContainer.Amount
                                      ELSE 0 END) AS SummSaleReal
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() 
                                       AND MIContainer.AccountId = zc_Enum_AnalyzerId_SummIn_110101()
                                       AND MIContainer.isActive = TRUE
                                       AND tmpUnitList.isUnit_Vz = FALSE
                                       THEN  1 * MIContainer.Amount 
                                       ELSE 0 END) AS SummSaleReal_A
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() 
                                       AND MIContainer.AccountId = zc_Enum_AnalyzerId_SummOut_110101()
                                       AND MIContainer.isActive = FALSE 
                                       AND tmpUnitList.isUnit_Vz = FALSE
                                      THEN -1 * MIContainer.Amount
                                      ELSE 0 END) AS SummSaleReal_P

                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() 
                                       AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10200()  -- Сумма, реализация, Разница с оптовыми ценами
                                       AND tmpUnitList.isUnit_Vz = TRUE
                                      THEN -1 * MIContainer.Amount                                        
                                      ELSE 0 END) AS SummSale_10200_Vz
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale()
                                       AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10250()  -- Сумма, реализация, Скидка Акция
                                       AND tmpUnitList.isUnit_Vz = TRUE
                                      THEN -1 * MIContainer.Amount                                        
                                      ELSE 0 END) AS SummSale_10250_Vz
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() 
                                       AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10300()  -- Сумма, реализация, Скидка дополнительная
                                       AND tmpUnitList.isUnit_Vz = TRUE
                                      THEN -1 * MIContainer.Amount                                        
                                      ELSE 0 END) AS SummSale_10300_Vz
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() 
                                       AND tmpUnitList.isUnit_Vz = TRUE
                                      THEN 1 * MIContainer.Amount
                                      ELSE 0 END) AS SummSaleReal_Vz
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() 
                                       AND MIContainer.AccountId = zc_Enum_AnalyzerId_SummIn_110101()
                                       AND MIContainer.isActive = TRUE
                                       AND tmpUnitList.isUnit_Vz = TRUE
                                       THEN  1 * MIContainer.Amount 
                                       ELSE 0 END) AS SummSaleReal_A_Vz
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() 
                                       AND MIContainer.AccountId = zc_Enum_AnalyzerId_SummOut_110101()
                                       AND MIContainer.isActive = FALSE 
                                       AND tmpUnitList.isUnit_Vz = TRUE
                                      THEN -1 * MIContainer.Amount
                                      ELSE 0 END) AS SummSaleReal_P_Vz

                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ReturnIn() 
                                       AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10200()  -- Сумма, реализация, Разница с оптовыми ценами
                                      THEN MIContainer.Amount                                        
                                      ELSE 0 END) AS SummReturnIn_10200
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ReturnIn() 
                                       AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10300()  -- Сумма, реализация, Скидка дополнительная
                                      THEN MIContainer.Amount                                        
                                      ELSE 0 END) AS SummReturnIn_10300

                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ReturnIn() THEN -1 * MIContainer.Amount ELSE 0 END) AS SummReturnInReal
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ReturnIn() AND MIContainer.AccountId = zc_Enum_AnalyzerId_SummIn_110101()  AND MIContainer.isActive = TRUE  THEN -1 * MIContainer.Amount ELSE 0 END) AS SummReturnInReal_A
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ReturnIn() AND MIContainer.AccountId = zc_Enum_AnalyzerId_SummOut_110101() AND MIContainer.isActive = FALSE THEN  1 * MIContainer.Amount ELSE 0 END) AS SummReturnInReal_P
                                                    
                          , 0 AS SummReturnIn
                          , 0 AS SummSendOnPriceIn
                          , 0 AS SummSendOnPriceOut                                        
                          , 0 AS SummLoss 
                          , 0 AS SummPeresortIn                                                                     -- приход пересортица  
                          , 0 AS SummPeresortOut                                                                    -- расход пересортица  
                          , 0 AS SummInventory 
                          , 0 AS SummInventory_RePrice   
                          
                          , 0 AS SummStart_Vz 
                          , 0 AS SummEnd_Vz
                          , 0 AS SummReturnIn_Vz
                          , 0 AS SummPeresortIn_Vz                                                                    -- приход пересортица  
                          , 0 AS SummPeresortOut_Vz                                                                   -- расход пересортица  
                          , 0 AS SummSendOnPriceOut_Vz 
                          , 0 AS SummLoss_Vz
                          , 0 AS SummInventory_Vz
                          , 0 AS SummInventory_RePrice_Vz
                     FROM tmpUnitList 
                           INNER JOIN MovementItemContainer AS MIContainer 
                                                           ON MIContainer.whereObjectId_analyzer = tmpUnitList.Id
                                                          AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate 
                                                          AND MIContainer.MovementDescId IN (zc_Movement_Sale(),zc_Movement_ReturnIn())
                           INNER JOIN  Container ON Container.Id = MIContainer.Containerid 
                                                AND Container.DescId = zc_Container_Summ()
                           INNER JOIN ContainerLinkObject AS CLO_Juridical
                                                          ON CLO_Juridical.ContainerId =Container.Id
                                                         AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                                         AND CLO_Juridical.ObjectId <> 0
                        GROUP BY CLO_Juridical.ContainerId, tmpUnitList.BranchId
                               , CASE WHEN inIsUnit = TRUE THEN tmpUnitList.Id ELSE 0 END
                    )

, tmpGoodsCount AS  (SELECT tmpContainerList.BranchId
                          , CASE WHEN inIsUnit = TRUE THEN tmpContainerList.UnitId ELSE 0 END AS UnitId
                          , tmpContainerList.ObjectId AS GoodsId
                          , CASE WHEN tmpContainerList.isUnit_Vz = FALSE
                                 THEN tmpContainerList.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0)
                                 ELSE 0 END AS CountStart 
                          , CASE WHEN tmpContainerList.isUnit_Vz = FALSE
                                 THEN tmpContainerList.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) 
                                 ELSE 0 END AS CountEnd
                          , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = TRUE THEN MIContainer.Amount 
                                    ELSE 0 END) AS CountIn
                          , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = FALSE THEN -1 * MIContainer.Amount
                                    ELSE 0 END) AS CountOut

                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate  THEN -1 * MIContainer.Amount                                        --Sale
                                    ELSE 0 END) AS CountSale

                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() 
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                       AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400() -- Сумма с/с, реализация, у покупателя
                                       -- AND MIContainer.ContainerId_Analyzer <> 0
                                       AND tmpContainerList.isUnit_Vz = FALSE
                                      THEN -1 * MIContainer.Amount                                        --Sale
                                      ELSE 0 END) AS CountSaleReal
                            -- !!!
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() 
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                       AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400()
                                                                  /*IN(zc_Enum_AnalyzerId_SaleCount_10400() -- Сумма с/с, реализация, у покупателя
                                                                   , zc_Enum_AnalyzerId_SaleCount_40200() 
                                                                   , zc_Enum_AnalyzerId_SaleCount_10500() )*/
                                       -- AND MIContainer.ContainerId_Analyzer <> 0
                                       AND tmpContainerList.isUnit_Vz = TRUE
                                      THEN -1 * MIContainer.Amount                                        --Sale
                                      ELSE 0 END) AS CountSaleReal_Vz


                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() 
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate  
                                       AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_40200() 
                                       AND tmpContainerList.isUnit_Vz = FALSE
                                      THEN -1 * MIContainer.Amount                                        ---- Сумма с/с, реализация, Разница в весе
                                      ELSE 0 END) AS CountSale_40208

                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() 
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate  
                                       AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_40200() 
                                       AND tmpContainerList.isUnit_Vz = TRUE
                                      THEN -1 * MIContainer.Amount                                        ---- Сумма с/с, реализация, Разница в весе
                                      ELSE 0 END) AS CountSale_40208_Vz
   
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() 
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate  
                                       AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10500()  -- Сумма с/с, реализация, Скидка за вес
                                       AND tmpContainerList.isUnit_Vz = FALSE
                                      THEN -1 * MIContainer.Amount                                        
                                      ELSE 0 END) AS CountSale_10500

                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() 
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate  
                                       AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10500()  -- Сумма с/с, реализация, Скидка за вес
                                       AND tmpContainerList.isUnit_Vz = TRUE
                                      THEN -1 * MIContainer.Amount                                        
                                      ELSE 0 END) AS CountSale_10500_vz
                                                                                                                  
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate 
                                       AND tmpContainerList.isUnit_Vz = FALSE
                                      THEN MIContainer.Amount                                         ---ReturnIn
                                    ELSE 0 END) AS CountReturnIn
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_SendOnPrice() AND MIContainer.isActive = TRUE AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount                              ---перемещение по цене
                                    ELSE 0 END) AS CountSendOnPriceIn
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_SendOnPrice() 
                                       AND MIContainer.isActive = FALSE 
                                       AND tmpContainerList.isUnit_Vz = FALSE
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate 
                                      THEN -1 * MIContainer.Amount                              ---перемещение по цене
                                    ELSE 0 END) AS CountSendOnPriceOut                                        
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Loss() 
                                       AND MIContainer.isActive = FALSE 
                                       AND tmpContainerList.isUnit_Vz = FALSE
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                      THEN -1 * MIContainer.Amount                                     ---Списание
                                    ELSE 0 END) AS CountLoss 
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ProductionUnion() 
                                       AND MIContainer.isActive = True 
                                       AND tmpContainerList.isUnit_Vz = FALSE
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate 
                                     THEN  -1 * MIContainer.Amount                                     
                                    ELSE 0 END) AS CountPeresortIn                                               --приход      
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ProductionUnion() 
                                       AND MIContainer.isActive = False 
                                       AND tmpContainerList.isUnit_Vz = FALSE
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate 
                                     THEN  -1 * MIContainer.Amount                                     
                                    ELSE 0 END) AS CountPeresortOut                                              --расход                                  
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Inventory()
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate 
                                       AND tmpContainerList.isUnit_Vz = FALSE
                                     THEN  MIContainer.Amount                                     ---Списание
                                    ELSE 0 END) AS CountInventory 
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Inventory() 
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                       AND tmpContainerList.isUnit_Vz = FALSE
                                       AND MIContainer.AnalyzerId = zc_Enum_AccountGroup_60000()
                                      THEN  MIContainer.Amount                                     
                                      ELSE 0 END) AS CountInventory_RePrice

                          , CASE WHEN tmpContainerList.isUnit_Vz = TRUE
                                 THEN tmpContainerList.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0)
                                 ELSE 0 END AS CountStart_Vz 
                          , CASE WHEN tmpContainerList.isUnit_Vz = TRUE
                                 THEN tmpContainerList.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) 
                                 ELSE 0 END AS CountEnd_Vz
                          
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ReturnIn() 
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                       AND tmpContainerList.isUnit_Vz = TRUE
                                      THEN MIContainer.Amount                                         ---ReturnIn
                                    ELSE 0 END) AS CountReturnIn_Vz
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                       AND MIContainer.isActive = FALSE 
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate 
                                       AND tmpContainerList.isUnit_Vz = TRUE
                                      THEN -1 * MIContainer.Amount                                   ---перемещение по цене
                                    ELSE 0 END) AS CountSendOnPriceOut_Vz                                        
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Loss() 
                                       AND MIContainer.isActive = FALSE 
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate 
                                       AND tmpContainerList.isUnit_Vz = TRUE
                                      THEN -1 * MIContainer.Amount                                     ---Списание
                                    ELSE 0 END) AS CountLoss_Vz 
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ProductionUnion() 
                                       AND MIContainer.isActive = True 
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                      AND tmpContainerList.isUnit_Vz = TRUE
                                     THEN  MIContainer.Amount                                        
                                    ELSE 0 END) AS CountPeresortIn_Vz                                   --приход      
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ProductionUnion() 
                                       AND MIContainer.isActive = False 
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate 
                                       AND tmpContainerList.isUnit_Vz = TRUE
                                     THEN  MIContainer.Amount          
                                    ELSE 0 END) AS CountPeresortOut_Vz                                   --расход                                  
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Inventory() 
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate 
                                       AND tmpContainerList.isUnit_Vz = TRUE
                                     THEN  MIContainer.Amount
                                    ELSE 0 END) AS CountInventory_Vz
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Inventory() 
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                       AND MIContainer.AnalyzerId = zc_Enum_AccountGroup_60000()
                                       AND tmpContainerList.isUnit_Vz = TRUE
                                      THEN  MIContainer.Amount                                     
                                      ELSE 0 END) AS CountInventory_RePrice_Vz
                     FROM tmpContainerList
                          LEFT JOIN ContainerLinkObject AS CLO_Account ON CLO_Account.ContainerId = tmpContainerList.ContainerId
                                                                      AND CLO_Account.DescId      = zc_ContainerLinkObject_Account()
                          LEFT JOIN MovementItemContainer AS MIContainer 
                                                          ON MIContainer.ContainerId = tmpContainerList.ContainerId 
                                                         AND MIContainer.OperDate >= inStartDate 
                     WHERE CLO_Account.ContainerId IS NULL
                     GROUP BY tmpContainerList.Amount, tmpContainerList.BranchId, tmpContainerList.ObjectId,tmpContainerList.UnitId ,tmpContainerList.ContainerId, tmpContainerList.isUnit_Vz
                            , CASE WHEN inIsUnit = TRUE THEN tmpContainerList.UnitId ELSE 0 END
                    
                    )
                    
    , tmpGoodsWeight AS (
                   SELECT tmpGoodsCount.BranchId 
                        , tmpGoodsCount.UnitId
                          -- CASE WHEN vbUserId = 5 THEN tmpGoodsCount.GoodsId ELSE tmpGoodsCount.BranchId END AS BranchId
                          -- CASE WHEN vbUserId = 5 THEN tmpGoodsCount.UnitId ELSE tmpGoodsCount.BranchId END AS BranchId
                        , CAST (tmpGoodsCount.CountStart * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END                   AS TFloat) AS CountStart
                        , CAST (tmpGoodsCount.CountEnd * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END                     AS TFloat) AS CountEnd
                        , CAST (tmpGoodsCount.CountIn * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END                      AS TFloat) AS CountIn
                        , CAST (tmpGoodsCount.CountOut * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END                     AS TFloat) AS CountOut
                        , CAST (tmpGoodsCount.CountSale * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END                    AS TFloat) AS CountSale
                        , CAST (tmpGoodsCount.CountSaleReal * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END                AS TFloat) AS CountSaleReal
                        , CAST (tmpGoodsCount.CountSaleReal_Vz * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END             AS TFloat) AS CountSaleReal_Vz
                        , CAST (tmpGoodsCount.CountReturnIn * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END                AS TFloat) AS CountReturnIn
                        , CAST (tmpGoodsCount.CountSendOnPriceIn * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END           AS TFloat) AS CountSendOnPriceIn
                        , CAST (tmpGoodsCount.CountLoss * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END                    AS TFloat) AS CountLoss    
                        , CAST (tmpGoodsCount.CountSendOnPriceOut * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END          AS TFloat) AS CountSendOnPriceOut  
                        , CAST (tmpGoodsCount.CountPeresortIn * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END              AS TFloat) AS CountPeresortIn  
                        , CAST (tmpGoodsCount.CountPeresortOut * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END             AS TFloat) AS CountPeresortOut    
                        , CAST (tmpGoodsCount.CountInventory * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END               AS TFloat) AS CountInventory
                        , CAST (tmpGoodsCount.CountSale_40208 * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END              AS TFloat) AS CountSale_40208
                        , CAST (tmpGoodsCount.CountSale_40208_Vz * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END           AS TFloat) AS CountSale_40208_Vz
                        , CAST (tmpGoodsCount.CountSale_10500 * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END              AS TFloat) AS CountSale_10500
                        , CAST (tmpGoodsCount.CountSale_10500_vz * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END           AS TFloat) AS CountSale_10500_vz
                        , CAST (tmpGoodsCount.CountInventory_RePrice * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END       AS TFloat) AS CountInventory_RePrice

                        , CAST (tmpGoodsCount.CountStart_Vz * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END                   AS TFloat) AS CountStart_Vz
                        , CAST (tmpGoodsCount.CountEnd_Vz * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END                     AS TFloat) AS CountEnd_Vz
                        , CAST (tmpGoodsCount.CountReturnIn_Vz * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END                AS TFloat) AS CountReturnIn_Vz
                        , CAST (tmpGoodsCount.CountLoss_Vz * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END                    AS TFloat) AS CountLoss_Vz    
                        , CAST (tmpGoodsCount.CountSendOnPriceOut_Vz * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END          AS TFloat) AS CountSendOnPriceOut_Vz
                        , CAST (tmpGoodsCount.CountPeresortIn_Vz * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END              AS TFloat) AS CountPeresortIn_Vz
                        , CAST (tmpGoodsCount.CountPeresortOut_Vz * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END             AS TFloat) AS CountPeresortOut_Vz  
                        , CAST (tmpGoodsCount.CountInventory_Vz * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END               AS TFloat) AS CountInventory_Vz
                        , CAST (tmpGoodsCount.CountInventory_RePrice_Vz * CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END       AS TFloat) AS CountInventory_RePrice_Vz
                        
                   FROM tmpGoodsCount
                      LEFT JOIN ObjectLink AS OL_Goods_Measure 
                                          ON OL_Goods_Measure.ObjectId = tmpGoodsCount.GoodsId
                                         AND OL_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                      LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                            ON ObjectFloat_Weight.ObjectId = tmpGoodsCount.GoodsId
                                           AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                     )

 
  SELECT  Object_Branch.ValueData  ::TVarChar   AS BranchName
        , Object_Unit.ValueData    ::TVarChar   AS UnitName
       -- Object_Branch.Id         ::TVarChar   AS BranchName

        , CAST (SUM (tmpAll.SummStart)         AS TFloat) AS SummStart
        , CAST (SUM (tmpAll.CountStart)        AS TFloat) AS WeightStart
        , CAST (SUM (tmpAll.SummEnd)           AS TFloat) AS SummEnd
        , CAST (SUM (tmpAll.CountEnd)          AS TFloat) AS WeightEnd

        , CAST (SUM (tmpAll.SummSendOnPriceIn)            AS TFloat) AS SendOnPriceInSumm
        , CAST (SUM (tmpAll.CountSendOnPriceIn)           AS TFloat) AS SendOnPriceInWeight
        
        , CAST (SUM (tmpAll.SummReturnIn)                 AS TFloat) AS ReturnInSumm
        , CAST (SUM (tmpAll.CountReturnIn)                AS TFloat) AS ReturnInWeight

        -- , CAST (SUM (tmpAll.SummReturnInReal)             AS TFloat) AS ReturnInRealSumm
        , CAST (SUM (tmpAll.SummReturnInReal + tmpAll.SummReturnInReal_A - tmpAll.SummReturnInReal_P) AS TFloat) AS ReturnInRealSumm
        , CAST (SUM (tmpAll.SummReturnInReal_A) AS TFloat) AS ReturnInRealSumm_A
        , CAST (SUM (tmpAll.SummReturnInReal_P) AS TFloat) AS ReturnInRealSumm_P

        , CAST (SUM (tmpAll.SummReturnIn_10200)           AS TFloat) AS ReturnIn_10200_Summ
        , CAST (SUM (tmpAll.SummReturnIn_10300)           AS TFloat) AS ReturnIn_10300_Summ
        
        , CAST (SUM (tmpAll.SummPeresortIn)               AS TFloat) AS PeresortInSumm
        , CAST (SUM (tmpAll.CountPeresortOut)             AS TFloat) AS PeresortInWeight
        , CAST (SUM (tmpAll.SummPeresortIn)               AS TFloat) AS PeresortOutSumm
        , CAST (SUM (tmpAll.CountPeresortOut)             AS TFloat) AS PeresortOutWeight
                
        , CAST (SUM (tmpAll.SummSale)                     AS TFloat) AS SaleSumm
        , CAST (SUM (tmpAll.SummSale_VZ)                  AS TFloat) AS SaleSumm_VZ

        -- , CAST (SUM (tmpAll.CountSale)                    AS TFloat) AS SaleWeight
        , CAST (SUM (tmpAll.CountSaleReal)                AS TFloat) AS SaleWeight
        , CAST (SUM (tmpAll.CountSaleReal_VZ)             AS TFloat) AS SaleWeight_VZ
        
        -- , CAST (SUM (tmpAll.SummSaleReal) AS TFloat) AS SaleRealSumm
        , CAST (SUM (tmpAll.SummSaleReal + tmpAll.SummSaleReal_A - tmpAll.SummSaleReal_P) AS TFloat) AS SaleRealSumm
        , CAST (SUM (tmpAll.SummSaleReal_A) AS TFloat) AS SaleRealSumm_A
        , CAST (SUM (tmpAll.SummSaleReal_P) AS TFloat) AS SaleRealSumm_P

        , CAST (SUM (tmpAll.SummSaleReal_Vz + tmpAll.SummSaleReal_A_Vz - tmpAll.SummSaleReal_P_Vz) AS TFloat) AS SaleRealSumm_Vz
        , CAST (SUM (tmpAll.SummSaleReal_A_Vz) AS TFloat) AS SaleRealSumm_A_Vz
        , CAST (SUM (tmpAll.SummSaleReal_P_Vz) AS TFloat) AS SaleRealSumm_P_Vz

        , CAST (SUM (tmpAll.SummSendOnPriceOut)           AS TFloat) AS SendOnPriceOutSumm
        , CAST (SUM (tmpAll.CountSendOnPriceOut)          AS TFloat) AS SendWeight
        
        , CAST (SUM (tmpAll.SummSale_40208)               AS TFloat) AS Sale_40208_Summ
        , CAST (SUM (tmpAll.SummSale_40208_Vz)            AS TFloat) AS Sale_40208_Summ_Vz
        , CAST (SUM (tmpAll.CountSale_40208)              AS TFloat) AS Sale_40208_Weight
        , CAST (SUM (tmpAll.CountSale_40208_Vz)           AS TFloat) AS Sale_40208_Weight_Vz

        , CAST (SUM (tmpAll.SummSale_10500)               AS TFloat) AS Sale_10500_Summ
        , CAST (SUM (tmpAll.SummSale_10500_Vz)            AS TFloat) AS Sale_10500_Summ_Vz
        , CAST (SUM (tmpAll.CountSale_10500)              AS TFloat) AS Sale_10500_Weight
        , CAST (SUM (tmpAll.CountSale_10500_Vz)           AS TFloat) AS Sale_10500_Weight_Vz

        , CAST (SUM (tmpAll.SummSale_10200 + tmpAll.SummSale_10250) AS TFloat) AS Sale_10200_Summ
        , CAST (SUM (tmpAll.SummSale_10250)               AS TFloat) AS Sale_10250_Summ
        , CAST (SUM (tmpAll.SummSale_10300)               AS TFloat) AS Sale_10300_Summ

        , CAST (SUM (tmpAll.SummSale_10200_Vz + tmpAll.SummSale_10250_Vz) AS TFloat) AS Sale_10200_Summ_Vz
        , CAST (SUM (tmpAll.SummSale_10250_Vz)               AS TFloat) AS Sale_10250_Summ_Vz
        , CAST (SUM (tmpAll.SummSale_10300_Vz)               AS TFloat) AS Sale_10300_Summ_Vz
        
        , CAST (SUM (tmpAll.SummLoss)                     AS TFloat) AS LossSumm
        , CAST (SUM (tmpAll.CountLoss)                    AS TFloat) AS LossWeight
        , CAST (SUM (tmpAll.SummInventory)                AS TFloat) AS InventorySumm
        , CAST (SUM (tmpAll.CountInventory)               AS TFloat) AS InventoryWeight
        , CAST (SUM (tmpAll.SummInventory_RePrice)        AS TFloat) AS SummInventory_RePrice

        , CAST (SUM (tmpAll.SummStart_Vz)                    AS TFloat) AS SummStart_Vz
        , CAST (SUM (tmpAll.CountStart_Vz)                   AS TFloat) AS WeightStart_Vz

        , CAST (SUM (tmpAll.SummEnd_Vz)                      AS TFloat) AS SummEnd_Vz
        , CAST (SUM (tmpAll.CountEnd_Vz)                     AS TFloat) AS WeightEnd_Vz
        
        , CAST (SUM (tmpAll.SummReturnIn_Vz)                 AS TFloat) AS ReturnInSumm_Vz
        , CAST (SUM (tmpAll.SummPeresortIn_Vz)               AS TFloat) AS PeresortInSumm_Vz
        , CAST (SUM (tmpAll.SummPeresortIn_Vz)               AS TFloat) AS PeresortOutSumm_Vz
        , CAST (SUM (tmpAll.SummSendOnPriceOut_Vz)           AS TFloat) AS SendOnPriceOutSumm_Vz
        , CAST (SUM (tmpAll.SummLoss_Vz)                     AS TFloat) AS LossSumm_Vz
        , CAST (SUM (tmpAll.SummInventory_Vz)                AS TFloat) AS InventorySumm_Vz
        , CAST (SUM (tmpAll.SummInventory_RePrice_Vz)        AS TFloat) AS SummInventory_RePrice_Vz

        , CAST (SUM (tmpAll.CountReturnIn_Vz)                 AS TFloat) AS ReturnInWeight_Vz
        , CAST (SUM (tmpAll.CountPeresortIn_Vz)               AS TFloat) AS PeresortInWeight_Vz
        , CAST (SUM (tmpAll.CountPeresortIn_Vz)               AS TFloat) AS PeresortOutWeight_Vz
        , CAST (SUM (tmpAll.CountSendOnPriceOut_Vz)           AS TFloat) AS SendOnPriceOutWeight_Vz
        , CAST (SUM (tmpAll.CountLoss_Vz)                     AS TFloat) AS LossWeight_Vz
        , CAST (SUM (tmpAll.CountInventory_Vz)                AS TFloat) AS InventoryWeight_Vz
        , CAST (SUM (tmpAll.CountInventory_RePrice_Vz)        AS TFloat) AS WeightInventory_RePrice_Vz        
  
      FROM 
                  (SELECT tmpGoodsSumm.BranchId
                        , tmpGoodsSumm.UnitId 
                        , CAST (SUM (tmpGoodsSumm.SummStart) AS NUMERIC (16, 2))   AS SummStart
                        , CAST (SUM (tmpGoodsSumm.SummEnd) AS NUMERIC (16, 2))     AS SummEnd
                        , CAST (SUM (tmpGoodsSumm.SummIn) AS NUMERIC (16, 2))      AS SummIn
                        , CAST (SUM (tmpGoodsSumm.SummOut) AS NUMERIC (16, 2))     AS SummOut
                        , CAST (SUM (tmpGoodsSumm.SummSale) AS NUMERIC (16, 2))           AS SummSale
                        , CAST (SUM (tmpGoodsSumm.SummSale_Vz) AS NUMERIC (16, 2))        AS SummSale_Vz
                        , CAST (SUM (tmpGoodsSumm.SummSaleReal)   AS NUMERIC (16, 2))     AS SummSaleReal
                        , CAST (SUM (tmpGoodsSumm.SummSaleReal_A) AS NUMERIC (16, 2))     AS SummSaleReal_A
                        , CAST (SUM (tmpGoodsSumm.SummSaleReal_P) AS NUMERIC (16, 2))     AS SummSaleReal_P
                        , CAST (SUM (tmpGoodsSumm.SummSaleReal_Vz)   AS NUMERIC (16, 2))  AS SummSaleReal_Vz
                        , CAST (SUM (tmpGoodsSumm.SummSaleReal_A_Vz) AS NUMERIC (16, 2))  AS SummSaleReal_A_Vz
                        , CAST (SUM (tmpGoodsSumm.SummSaleReal_P_Vz) AS NUMERIC (16, 2))  AS SummSaleReal_P_Vz
                        , CAST (SUM (tmpGoodsSumm.SummReturnIn) AS NUMERIC (16, 2))       AS SummReturnIn
                        
                        , CAST (SUM (tmpGoodsSumm.SummReturnIn_10200) AS NUMERIC (16, 2)) AS SummReturnIn_10200
                        , CAST (SUM (tmpGoodsSumm.SummReturnIn_10300) AS NUMERIC (16, 2)) AS SummReturnIn_10300
                        , CAST (SUM (tmpGoodsSumm.SummReturnInReal)   AS NUMERIC (16, 2)) AS SummReturnInReal
                        , CAST (SUM (tmpGoodsSumm.SummReturnInReal_A) AS NUMERIC (16, 2)) AS SummReturnInReal_A
                        , CAST (SUM (tmpGoodsSumm.SummReturnInReal_P) AS NUMERIC (16, 2)) AS SummReturnInReal_P
                                                
                        , CAST (SUM (tmpGoodsSumm.SummSendOnPriceIn) AS NUMERIC (16, 2))  AS SummSendOnPriceIn
                        , CAST (SUM (tmpGoodsSumm.SummLoss) AS NUMERIC (16, 2))           AS SummLoss    
                        , CAST (SUM (tmpGoodsSumm.SummSendOnPriceOut) AS NUMERIC (16, 2)) AS SummSendOnPriceOut  
                        , CAST (SUM (tmpGoodsSumm.SummPeresortIn) AS NUMERIC (16, 2))     AS SummPeresortIn    
                        , CAST (SUM (tmpGoodsSumm.SummPeresortOut) AS NUMERIC (16, 2))    AS SummPeresortOut    
                        , CAST (-1 * SUM (tmpGoodsSumm.SummInventory) AS NUMERIC (16, 2)) AS SummInventory
                        , CAST (SUM (tmpGoodsSumm.SummSale_40208)     AS NUMERIC (16, 2)) AS SummSale_40208
                        , CAST (SUM (tmpGoodsSumm.SummSale_40208_Vz)  AS NUMERIC (16, 2)) AS SummSale_40208_Vz
                        , CAST (SUM (tmpGoodsSumm.SummSale_10500)     AS NUMERIC (16, 2)) AS SummSale_10500
                        , CAST (SUM (tmpGoodsSumm.SummSale_10500_Vz)  AS NUMERIC (16, 2)) AS SummSale_10500_Vz
                        , CAST (SUM (tmpGoodsSumm.SummSale_10200)     AS NUMERIC (16, 2)) AS SummSale_10200
                        , CAST (SUM (tmpGoodsSumm.SummSale_10250)     AS NUMERIC (16, 2)) AS SummSale_10250
                        , CAST (SUM (tmpGoodsSumm.SummSale_10300)     AS NUMERIC (16, 2)) AS SummSale_10300
                        , CAST (SUM (tmpGoodsSumm.SummSale_10200_Vz)     AS NUMERIC (16, 2)) AS SummSale_10200_Vz
                        , CAST (SUM (tmpGoodsSumm.SummSale_10250_Vz)     AS NUMERIC (16, 2)) AS SummSale_10250_Vz
                        , CAST (SUM (tmpGoodsSumm.SummSale_10300_Vz)     AS NUMERIC (16, 2)) AS SummSale_10300_Vz
                        , CAST (SUM (tmpGoodsSumm.SummInventory_RePrice) AS NUMERIC (16, 2)) AS SummInventory_RePrice

                        , CAST (SUM (tmpGoodsSumm.SummStart_Vz) AS NUMERIC (16, 2))          AS SummStart_Vz
                        , CAST (SUM (tmpGoodsSumm.SummEnd_Vz) AS NUMERIC (16, 2))            AS SummEnd_Vz
                        , CAST (SUM (tmpGoodsSumm.SummReturnIn_Vz) AS NUMERIC (16, 2))       AS SummReturnIn_Vz
                        , CAST (SUM (tmpGoodsSumm.SummPeresortIn_Vz) AS NUMERIC (16, 2))     AS SummPeresortIn_Vz    
                        , CAST (SUM (tmpGoodsSumm.SummPeresortOut_Vz) AS NUMERIC (16, 2))    AS SummPeresortOut_Vz  
                        , CAST (SUM (tmpGoodsSumm.SummSendOnPriceOut_Vz) AS NUMERIC (16, 2)) AS SummSendOnPriceOut_Vz  
                        , CAST (SUM (tmpGoodsSumm.SummLoss_Vz) AS NUMERIC (16, 2))           AS SummLoss_Vz
                        , CAST (-1 * SUM (tmpGoodsSumm.SummInventory_Vz) AS NUMERIC (16, 2))    AS SummInventory_Vz
                        , CAST (SUM (tmpGoodsSumm.SummInventory_RePrice_Vz) AS NUMERIC (16, 2)) AS SummInventory_RePrice_Vz
                        , 0 AS CountStart
                        , 0 AS CountEnd
                        , 0 AS CountIn
                        , 0 AS CountOut
                        , 0 AS CountSale
                        , 0 AS CountSaleReal
                        , 0 AS CountSaleReal_Vz
                        , 0 AS CountReturnIn
                        , 0 AS CountSendOnPriceIn
                        , 0 AS CountLoss    
                        , 0 AS CountSendOnPriceOut  
                        , 0 AS CountPeresortIn    
                        , 0 AS CountPeresortOut    
                        , 0 AS CountInventory
                        , 0 AS CountSale_40208
                        , 0 AS CountSale_40208_Vz
                        , 0 AS CountSale_10500
                        , 0 AS CountSale_10500_Vz
                        , 0 AS CountInventory_RePrice
                        , 0 AS CountStart_Vz
                        , 0 AS CountEnd_Vz
                        , 0 AS CountReturnIn_Vz
                        , 0 AS CountPeresortIn_Vz    
                        , 0 AS CountPeresortOut_Vz  
                        , 0 AS CountSendOnPriceOut_Vz  
                        , 0 AS CountLoss_Vz
                        , 0 AS CountInventory_Vz
                        , 0 AS CountInventory_RePrice_Vz

                   FROM tmpGoodsSumm
                   GROUP BY tmpGoodsSumm.BranchId
                          , tmpGoodsSumm.UnitId
               UNION ALL
                   SELECT tmpGoodsWeight.BranchId 
                        , tmpGoodsWeight.UnitId
                        , 0 AS SummStart
                        , 0 AS SummEnd
                        , 0 AS SummIn
                        , 0 AS SummOut
                        , 0 AS SummSale
                        , 0 AS SummSale_Vz
                        , 0 AS SummSaleReal
                        , 0 AS SummSaleReal_A
                        , 0 AS SummSaleReal_P

                        , 0 AS SummSaleReal_Vz
                        , 0 AS SummSaleReal_A_Vz
                        , 0 AS SummSaleReal_P_Vz

                        , 0 AS SummReturnIn
                        , 0 AS SummReturnIn_10200
                        , 0 AS SummReturnIn_10300
                        , 0 AS SummReturnInReal
                        , 0 AS SummReturnInReal_A
                        , 0 AS SummReturnInReal_P

                        , 0 AS SummSendOnPriceIn
                        , 0 AS SummLoss    
                        , 0 AS SummSendOnPriceOut  
                        , 0 AS SummPeresortIn    
                        , 0 AS SummPeresortOut    
                        , 0 AS SummInventory
                        , 0 AS SummSale_40208
                        , 0 AS SummSale_40208_Vz
                        , 0 AS SummSale_10500
                        , 0 AS SummSale_10500_Vz
                        , 0 AS SummSale_10200
                        , 0 AS SummSale_10250
                        , 0 AS SummSale_10300
                        , 0 AS SummSale_10200_Vz
                        , 0 AS SummSale_10250_Vz
                        , 0 AS SummSale_10300_Vz
                        , 0 AS SummInventory_RePrice
                        , 0 AS SummStart_Vz
                        , 0 AS SummEnd_Vz
                        , 0 AS SummReturnIn_Vz
                        , 0 AS SummPeresortIn_Vz    
                        , 0 AS SummPeresortOut_Vz  
                        , 0 AS SummSendOnPriceOut_Vz  
                        , 0 AS SummLoss_Vz
                        , 0 AS SummInventory_Vz
                        , 0 AS SummInventory_RePrice_Vz

                        , CAST (SUM (tmpGoodsWeight.CountStart) AS NUMERIC (16, 4))   AS CountStart
                        , CAST (SUM (tmpGoodsWeight.CountEnd) AS NUMERIC (16, 4))     AS CountEnd
                        , CAST (SUM (tmpGoodsWeight.CountIn) AS NUMERIC (16, 4))      AS CountIn
                        , CAST (SUM (tmpGoodsWeight.CountOut) AS NUMERIC (16, 4))     AS CountOut
                        , CAST (SUM (tmpGoodsWeight.CountSale) AS NUMERIC (16, 4))           AS CountSale
                        , CAST (SUM (tmpGoodsWeight.CountSaleReal) AS NUMERIC (16, 4))       AS CountSaleReal
                        , CAST (SUM (tmpGoodsWeight.CountSaleReal_Vz) AS NUMERIC (16, 4))    AS CountSaleReal_Vz
                        , CAST (SUM (tmpGoodsWeight.CountReturnIn) AS NUMERIC (16, 4))       AS CountReturnIn
                        , CAST (SUM (tmpGoodsWeight.CountSendOnPriceIn) AS NUMERIC (16, 4))  AS CountSendOnPriceIn
                        , CAST (SUM (tmpGoodsWeight.CountLoss) AS NUMERIC (16, 4))           AS CountLoss    
                        , CAST (SUM (tmpGoodsWeight.CountSendOnPriceOut) AS NUMERIC (16, 4)) AS CountSendOnPriceOut  
                        , CAST (SUM (tmpGoodsWeight.CountPeresortIn) AS NUMERIC (16, 4))     AS CountPeresortIn 
                        , CAST (SUM (tmpGoodsWeight.CountPeresortOut) AS NUMERIC (16, 4))    AS CountPeresortOut    
                        , CAST (SUM (tmpGoodsWeight.CountInventory)   AS NUMERIC (16, 4))    AS CountInventory
                        , CAST (SUM (tmpGoodsWeight.CountSale_40208)  AS NUMERIC (16, 4))    AS CountSale_40208
                        , CAST (SUM (tmpGoodsWeight.CountSale_40208_Vz) AS NUMERIC (16, 4))     AS CountSale_40208_Vz
                        , CAST (SUM (tmpGoodsWeight.CountSale_10500)    AS NUMERIC (16, 4))     AS CountSale_10500
                        , CAST (SUM (tmpGoodsWeight.CountSale_10500_Vz) AS NUMERIC (16, 4))     AS CountSale_10500_Vz
                        , CAST (SUM (tmpGoodsWeight.CountInventory_RePrice) AS NUMERIC (16, 4)) AS CountInventory_RePrice

                        , CAST (SUM (tmpGoodsWeight.CountStart_Vz) AS NUMERIC (16, 4))          AS CountStart_Vz
                        , CAST (SUM (tmpGoodsWeight.CountEnd_Vz) AS NUMERIC (16, 4))            AS CountEnd_Vz
                        , CAST (SUM (tmpGoodsWeight.CountReturnIn_Vz) AS NUMERIC (16, 4))       AS CountReturnIn_Vz
                        , CAST (SUM (tmpGoodsWeight.CountPeresortIn_Vz) AS NUMERIC (16, 4))     AS CountPeresortIn_Vz    
                        , CAST (SUM (tmpGoodsWeight.CountPeresortOut_Vz) AS NUMERIC (16, 4))    AS CountPeresortOut_Vz  
                        , CAST (SUM (tmpGoodsWeight.CountSendOnPriceOut_Vz) AS NUMERIC (16, 4)) AS CountSendOnPriceOut_Vz  
                        , CAST (SUM (tmpGoodsWeight.CountLoss_Vz) AS NUMERIC (16, 4))           AS CountLoss_Vz
                        , CAST (SUM (tmpGoodsWeight.CountInventory_Vz) AS NUMERIC (16, 4))      AS CountInventory_Vz
                        , CAST (SUM (tmpGoodsWeight.CountInventory_RePrice_Vz) AS NUMERIC (16, 4)) AS CountInventory_RePrice_Vz
                   FROM tmpGoodsWeight
                   GROUP BY tmpGoodsWeight.BranchId
                          , tmpGoodsWeight.UnitId
                ) AS tmpAll

          LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpAll.BranchId   --CASE WHEN COALESCE(inBranchId,0) <> 0 THEN inBranchId END
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpAll.UnitId
      GROUP BY Object_Branch.ValueData
             , Object_Branch.Id
             , Object_Unit.ValueData
      ORDER BY Object_Branch.ValueData 
             , Object_Unit.ValueData

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
--  SELECT * FROM gpReport_Branch_App1_New (inStartDate:= '01.02.2018'::TDateTime, inEndDate:= '28.02.2018'::TDateTime, inBranchId:= 8374, inIsUnit := FALSE, inSession:= zfCalc_UserAdmin()) -- филиал Одесса
--  SELECT * FROM gpReport_Branch_App1_New (inStartDate:= '01.02.2018'::TDateTime, inEndDate:= '28.02.2018'::TDateTime, inBranchId:= 8374, inIsUnit := TRUE, inSession:= zfCalc_UserAdmin())  -- филиал Одесса
