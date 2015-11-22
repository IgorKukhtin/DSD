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
             , IncomeSumm TFloat, IncomeWeight TFloat
             , ReturnInSumm TFloat, ReturnInWeight TFloat
             , ChangeSumm TFloat, ChangeWeight TFloat
             
             , SaleSumm TFloat, SaleWeight TFloat
             , SendSumm TFloat, SendWeight TFloat
             , ChangeAmountSumm TFloat, ChangeAmountWeight TFloat
             , LossSumm TFloat, LossWeight TFloat
             , InventorySumm TFloat, InventoryWeight TFloat   
             , PriceSumm TFloat          
              )
AS
$BODY$
   DECLARE vbUserId Integer;

BEGIN
          vbUserId:= lpGetUserBySession (inSession);

    CREATE TEMP TABLE _tmpBranch (BranchId Integer) ON COMMIT DROP; 
    
    -- Филиал
    IF COALESCE(inBranchId,0) = 0
    THEN
     --RAISE EXCEPTION 'Ошибка. Не выбран Филиал.';
       INSERT INTO _tmpBranch (BranchId)
           SELECT Object.Id AS BranchId FROM Object WHERE Object.DescId = zc_Object_Branch() and Object.Id <> zc_Branch_Basis();
    ELSE
       INSERT INTO _tmpBranch (BranchId)
           SELECT inBranchId;
    END IF;


    -- Результат
     RETURN QUERY
   WITH tmpUnitList AS (SELECT Object_Unit_View.* 
                        From _tmpBranch
                            INNER JOIN Object_Unit_View ON Object_Unit_View.BranchId = _tmpBranch.BranchId
                        )
                                        
       ,tmpCashList AS (SELECT Cash_Branch.ObjectId AS CashId 
                             , _tmpBranch.BranchId
                       FROM _tmpBranch
                            INNER JOIN ObjectLink AS Cash_Branch
                                                  ON Cash_Branch.ChildObjectId = _tmpBranch.BranchId
                                                 AND Cash_Branch.DescId = zc_ObjectLink_Cash_Branch()
                       ) 

  , tmpContainerList AS (SELECT * 
                         FROM tmpUnitList 
                             INNER JOIN ContainerLinkObject AS CLO_Unit
                                                ON CLO_Unit.ObjectId = tmpUnitList.Id
                                               AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit() 
                             INNER JOIN Container ON Container.Id = CLO_Unit.ContainerId
                                           AND Container.DescId = zc_Container_Summ()
                             LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = Container.ObjectId
                         WHERE Object_Account_View.AccountDirectionId = zc_Enum_AccountDirection_20700() 
                        )

      , tmpGoods AS (SELECT tmpContainerList.BranchId
                          , tmpContainerList.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) AS AmountStart 
                          , tmpContainerList.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS AmountEnd
                          , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = TRUE THEN MIContainer.Amount 
                                    ELSE 0 END) AS SummIn
                          , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = FALSE THEN -1 * MIContainer.Amount
                                    ELSE 0 END) AS SummOut
                     FROM tmpContainerList
                          LEFT JOIN MovementItemContainer AS MIContainer 
                                                          ON MIContainer.ContainerId = tmpContainerList.ContainerId 
                                                          AND MIContainer.OperDate >= inStartDate 
                     GROUP BY tmpContainerList.ContainerId, tmpContainerList.Amount, tmpContainerList.BranchId
                    )


, tmpGoodsSaleReturn AS (SELECT _tmpBranch.BranchId
                              , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() THEN  MIContainer.Amount                                        --Sale
                                        ELSE 0 END) AS SummSale
                              , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ReturnIn() THEN -1* MIContainer.Amount                                         ---ReturnIn
                                        ELSE 0 END) AS SummReturnIn
                        FROM _tmpBranch
                              INNER JOIN ContainerLinkObject AS CLO_Branch
                                                             ON CLO_Branch.ObjectId = _tmpBranch.BranchId 
                                                            AND CLO_Branch.DescId = zc_ContainerLinkObject_Branch() 
                              INNER JOIN Container ON Container.Id = CLO_Branch.ContainerId
                                                  AND Container.DescId = zc_Container_Summ() 
                              LEFT JOIN MovementItemContainer AS MIContainer
                                                       ON MIContainer.Containerid = Container.Id
                                                      AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                              INNER JOIN ContainerLinkObject AS CLO_PaidKind
                                                        ON CLO_PaidKind.ContainerId = CLO_Branch.ContainerId
                                                       AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()   
                                                       AND CLO_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm()                  
                        GROUP BY CLO_Branch.ContainerId, Container.Amount, _tmpBranch.BranchId 
           )
                
       
         -- нач. кон. сальдо касса , движение
         , tmpCash AS (SELECT tmpCashList.BranchId
                            , CLO_Cash.ContainerId
                            , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS AmountStart      -- остаток денег на начало периода
                            , Container.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS AmountEnd
                            , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = TRUE THEN MIContainer.Amount 
                                      ELSE 0 END) AS SummIn
                            , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = FALSE THEN -1 * MIContainer.Amount
                                      ELSE 0 END) AS SummOut
                       FROM tmpCashList
                           INNER JOIN ContainerLinkObject AS CLO_Cash
                                                          ON CLO_Cash.ObjectId = tmpCashList.CashId
                                                         AND CLO_Cash.DescId = zc_ContainerLinkObject_Cash()
                           INNER JOIN Container ON Container.Id = CLO_Cash.ContainerId
                                               AND Container.DescId = zc_Container_Summ()
                           LEFT JOIN MovementItemContainer AS MIContainer
                                                           ON MIContainer.Containerid = Container.Id
                                                          AND MIContainer.OperDate >= inStartDate                    
                       GROUP BY CLO_Cash.ContainerId, Container.Amount, tmpCashList.BranchId 
                      ) 

    , tmpJuridical AS (SELECT _tmpBranch.BranchId 
                             , SUM (CASE WHEN (MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.Amount>0)THEN MIContainer.Amount ELSE 0 END) as AmountDebet
                             , SUM (CASE WHEN (MIContainer.OperDate  BETWEEN  inStartDate AND inEndDate  AND MIContainer.Amount<0)THEN MIContainer.Amount ELSE 0 END) as AmountKredit
                             , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS AmountStart      -- остаток денег на начало периода
                             , Container.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0)  AS AmountEnd
                             , SUM (CASE WHEN (MIContainer.MovementDescId = zc_Movement_Cash() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate ) THEN MIContainer.Amount
                                           ELSE 0 END)       AS AmountCash  -- оплаты
                        FROM _tmpBranch
                              INNER JOIN ContainerLinkObject AS CLO_Branch
                                                             ON CLO_Branch.ObjectId = _tmpBranch.BranchId 
                                                            AND CLO_Branch.DescId = zc_ContainerLinkObject_Branch() 
                          
                              INNER JOIN ContainerLinkObject AS CLO_Juridical
                                                             ON CLO_Juridical.ContainerId = CLO_Branch.ContainerId
                                                            AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                                            AND CLO_Juridical.ObjectId <> 0
                              INNER JOIN Container ON Container.Id = CLO_Juridical.ContainerId
                                           AND Container.DescId = zc_Container_Summ() 
                              LEFT JOIN MovementItemContainer AS MIContainer
                                                       ON MIContainer.Containerid = Container.Id
                                                      AND MIContainer.OperDate >= inStartDate  
                              INNER JOIN ContainerLinkObject AS CLO_PaidKind
                                                        ON CLO_PaidKind.ContainerId = CLO_Juridical.ContainerId
                                                       AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()   
                                                       AND CLO_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm()                  
                        GROUP BY CLO_Juridical.ContainerId, Container.Amount, _tmpBranch.BranchId    
                       )

   SELECT  'Филиал'  ::TVarChar   AS BranchName
       
        , CAST (0         AS TFloat) AS SummStart
        , CAST (0         AS TFloat) AS WeightStart
        , CAST (0         AS TFloat) AS SummEnd
        , CAST (0         AS TFloat) AS WeightEnd

        , CAST (0         AS TFloat) AS IncomeSumm
        , CAST (0         AS TFloat) AS IncomeWeight
        
        , CAST (0         AS TFloat) AS ReturnInSumm
        , CAST (0         AS TFloat) AS ReturnInWeight
        , CAST (0         AS TFloat) AS ChangeSumm
        , CAST (0         AS TFloat) AS ChangeWeight

        , CAST (0         AS TFloat) AS SaleSumm
        , CAST (0         AS TFloat) AS SaleWeight
        , CAST (0         AS TFloat) AS SendSumm
        , CAST (0         AS TFloat) AS SendWeight
        , CAST (0         AS TFloat) AS ChangeAmountSumm
        , CAST (0         AS TFloat) AS ChangeAmountWeight
        , CAST (0         AS TFloat) AS LossSumm
        , CAST (0         AS TFloat) AS LossWeight
        , CAST (0         AS TFloat) AS InventorySumm
        , CAST (0         AS TFloat) AS InventoryWeight
        , CAST (0         AS TFloat) AS PriceSumm
  
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