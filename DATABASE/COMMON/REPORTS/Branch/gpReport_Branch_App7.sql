-- Function: gpReport_Branch_App7()

DROP FUNCTION IF EXISTS gpReport_Branch_App7 (TDateTime, TDateTime,  Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Branch_App7(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inBranchId           Integer,    -- Филиал
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (BranchName TVarChar
             , GoodsSummStart TFloat, GoodsSummEnd TFloat, GoodsSummIn TFloat, GoodsSummOut TFloat
             , GoodsSummSale_SF TFloat, GoodsSummReturnIn_SF TFloat
             , CashSummStart TFloat, CashSummEnd TFloat, CashSummIn TFloat, CashSummOut TFloat, CashAmount TFloat
             , JuridicalSummStart TFloat, JuridicalSummEnd TFloat, JuridicalSummOut TFloat, JuridicalSummIn TFloat             
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
     RAISE EXCEPTION 'Ошибка. Не выбран Филиал.';
       -- INSERT INTO _tmpBranch (BranchId)
         --  SELECT Object.Id AS BranchId FROM Object WHERE Object.DescId = zc_Object_Branch();
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

      , tmpGoods AS (SELECT tmpContainerList.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) AS AmountStart 
                          , tmpContainerList.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS AmountEnd
                          , SUM (CASE WHEN MIContainer.isActive = TRUE THEN MIContainer.Amount 
                                    ELSE 0 END) AS SummIn
                          , SUM (CASE WHEN MIContainer.isActive = FALSE THEN -1 * MIContainer.Amount
                                    ELSE 0 END) AS SummOut
                     FROM tmpContainerList 
                          LEFT JOIN MovementItemContainer AS MIContainer 
                                                          ON MIContainer.ContainerId = tmpContainerList.ContainerId 
                                                          AND MIContainer.OperDate >= inStartDate 
                     GROUP BY tmpContainerList.ContainerId, tmpContainerList.Amount
                    )

, tmpGoodsSaleReturn AS (SELECT SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() THEN -1 * MIContainer.Amount                                        --Sale
                                        ELSE 0 END) AS SummSale
                              , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ReturnIn() THEN MIContainer.Amount                                         ---ReturnIn
                                        ELSE 0 END) AS SummReturnIn
                         FROM tmpContainerList 
                             LEFT JOIN MovementItemContainer AS MIContainer 
                                                             ON MIContainer.ContainerId = tmpContainerList.ContainerId 
                                                            AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                             INNER JOIN ContainerLinkObject AS CLO_PaidKind
                                                            ON CLO_PaidKind.ContainerId = tmpContainerList.ContainerId
                                                           AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()   
                                                           AND CLO_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm()
                         GROUP BY tmpContainerList.ContainerId, tmpContainerList.Amount
                    )

                       
         -- нач. кон. сальдо касса , движение
         , tmpCash AS (SELECT CLO_Cash.ContainerId
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
                       GROUP BY CLO_Cash.ContainerId, Container.Amount  
                      ) 

, tmpJuridical AS (SELECT SUM (CASE WHEN (MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.Amount>0)THEN MIContainer.Amount ELSE 0 END) as AmountDebet
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
                        GROUP BY CLO_Juridical.ContainerId, Container.Amount   
                       )

   SELECT  Object_Branch.ValueData  ::TVarChar   AS BranchName
       
        , CAST (tmpGoods.AmountStart         AS TFloat) AS GoodsSummStart
        , CAST (tmpGoods.AmountEnd           AS TFloat) AS GoodsSummEnd
        , CAST (tmpGoods.SummIn              AS TFloat) AS GoodsSummIn
        , CAST (tmpGoods.SummOut             AS TFloat) AS GoodsSummOut

        , CAST (tmpGoodsSaleReturn.SummSale      AS TFloat) AS GoodsSummSale_SF
        , CAST (tmpGoodsSaleReturn.SummReturnIn  AS TFloat) AS GoodsSummReturnIn_SF
        
        , CAST (tmpCash.AmountStart         AS TFloat) AS CashSummStart
        , CAST (tmpCash.AmountEnd           AS TFloat) AS CashSummEnd
        , CAST (tmpCash.SummIn              AS TFloat) AS CashSummIn
        , CAST (tmpCash.SummOut             AS TFloat) AS CashSummOut

        , CAST (tmpJuridical.CashAmount          AS TFloat) AS CashAmount

        , CAST (tmpJuridical.AmountStart         AS TFloat) AS JuridicalSummStart
        , CAST (tmpJuridical.AmountEnd           AS TFloat) AS JuridicalSummEnd
        , CAST (tmpJuridical.AmountKredit        AS TFloat) AS JuridicalSummOut
        , CAST (tmpJuridical.AmountDebet         AS TFloat) AS JuridicalSummIn

   FROM (SELECT 1) AS tmp
        LEFT JOIN (SELECT SUM (tmpGoods.AmountStart) AS AmountStart
                        , SUM (tmpGoods.AmountEnd)   AS AmountEnd
                        , SUM (tmpGoods.SummIn)      AS SummIn
                        , SUM (tmpGoods.SummOut)     AS SummOut
                   FROM tmpGoods) AS tmpGoods  ON 1=1

        LEFT JOIN (SELECT SUM (tmpGoodsSaleReturn.SummSale)       AS SummSale
                        , SUM (tmpGoodsSaleReturn.SummReturnIn)   AS SummReturnIn
                   FROM tmpGoodsSaleReturn) AS tmpGoodsSaleReturn ON 1=1

        LEFT JOIN (SELECT SUM (tmpCash.AmountStart) AS AmountStart
                        , SUM (tmpCash.AmountEnd)   AS AmountEnd
                        , SUM (tmpCash.SummIn)      AS SummIn
                        , SUM (tmpCash.SummOut)     AS SummOut
                   FROM tmpCash) AS tmpCash ON 1=1

        LEFT JOIN (SELECT SUM (tmpJuridical.AmountStart)   AS AmountStart
                        , SUM (tmpJuridical.AmountEnd)     AS AmountEnd
                        , -1* SUM (tmpJuridical.AmountKredit)  AS AmountKredit
                        , SUM (tmpJuridical.AmountDebet)   AS AmountDebet
                        , -1* SUM (tmpJuridical.AmountCash)    AS CashAmount
                   FROM tmpJuridical) AS tmpJuridical  ON 1=1

        LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = CASE WHEN COALESCE(inBranchId,0) <> 0 THEN inBranchId END
 
      ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 10.11.15         * 

*/

-- тест
--SELECT * FROM gpReport_Branch_App7 (inStartDate:= '01.08.2015'::TDateTime, inEndDate:= '12.08.2015'::TDateTime, inBranchId:= 8374, inSession:= zfCalc_UserAdmin())  --8374
--