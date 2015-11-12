-- Function: gpReport_Branch_App7()

DROP FUNCTION IF EXISTS gpReport_Branch_App7 (TDateTime, TDateTime,  Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Branch_App7(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inBranchId           Integer,    -- Филиал
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (BranchName TVarChar
             , SummStart TFloat, SummEnd TFloat, SummIn TFloat, SummOut TFloat
             , CashSummStart TFloat, CashSummEnd TFloat
             , JuridicalSummStart TFloat, JuridicalSummEnd TFloat, JuridicalSummKredit TFloat, JuridicalSummDebet TFloat             
              )
AS
$BODY$
   DECLARE vbUserId Integer;

BEGIN
          vbUserId:= lpGetUserBySession (inSession);

    
    -- Результат
     RETURN QUERY
   WITH tmpUnit AS (SELECT * From Object_Unit_View WHERE Object_Unit_View.BranchId = inBranchId )       --зап  301310,, одесса
       ,tmpCash AS (SELECT Object.Id  AS CashId 
                    FROM Object
                     INNER JOIN ObjectLink AS Cash_Branch
                                           ON Cash_Branch.ObjectId = Object.Id
                                          AND Cash_Branch.DescId = zc_ObjectLink_Cash_Branch()
                                          AND Cash_Branch.ChildObjectId = inBranchId                              --зап  301310, , одесса
                    ) 
                
  , tmpContainer AS (SELECT ListContainer.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) AS AmountStart 
                          , ListContainer.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS AmountEnd
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Income()    THEN MIContainer.Amount
                                      WHEN MIContainer.MovementDescId = zc_Movement_Send() AND MIContainer.isActive = TRUE THEN MIContainer.Amount             --SummSendIn
                                      WHEN MIContainer.MovementDescId = zc_Movement_SendOnPrice() AND MIContainer.isActive = TRUE THEN MIContainer.Amount      ---SummSendOnPriceIn
                                      WHEN MIContainer.MovementDescId = zc_Movement_ReturnIn() THEN MIContainer.Amount                                         ---ReturnIn
                                      WHEN MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND MIContainer.isActive = TRUE THEN MIContainer.Amount    --SummProductionIn
                                    ELSE 0 END) AS SummIn
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ReturnOut() THEN MIContainer.Amount
                                      WHEN MIContainer.MovementDescId = zc_Movement_Send() AND MIContainer.isActive = FALSE THEN -1 * MIContainer.Amount  --SummSendout
                                      WHEN MIContainer.MovementDescId = zc_Movement_SendOnPrice() AND MIContainer.isActive = FALSE THEN -1 * MIContainer.Amount               ---SummSendOnPriceout
                                      WHEN MIContainer.MovementDescId = zc_Movement_Sale() THEN -1 * MIContainer.Amount                                     --Sale
                                      WHEN MIContainer.MovementDescId = zc_Movement_Loss() THEN -1 * MIContainer.Amount                                     --Loss
                                      WHEN MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND MIContainer.isActive = FALSE THEN -1 * MIContainer.Amount    --SummProductionOut
                                    ELSE 0 END) AS SummOut
                     FROM 
                        (SELECT * 
                         FROM tmpUnit 
                             INNER JOIN ContainerLinkObject AS CLO_Unit
                                                ON CLO_Unit.ObjectId = tmpUnit.Id
                                               AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit() 
                             INNER JOIN Container ON Container.Id = CLO_Unit.ContainerId
                                           AND Container.DescId = zc_Container_Summ()
                             LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = Container.ObjectId
                        
                         WHERE Object_Account_View.AccountDirectionId = zc_Enum_AccountDirection_20700() 
                        ) AS ListContainer 
                             INNER JOIN MovementItemContainer AS MIContainer 
                                                              ON MIContainer.ContainerId = ListContainer.ContainerId 
                                                             AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate 
                     GROUP BY ListContainer.ContainerId, ListContainer.Amount
                    )
                       
/*select sum(AmountStart)
,sum(AmountEnd)
,sum(SummIn)
,sum(SummOut)

 From tmpContainer*/  --итого 

--select * From Object_Account_View where  Object_Account_View.AccountDirectionId = zc_Enum_AccountDirection_20700()               
-- нач. кон. сальдо касса 
, tmpCashContainer AS (SELECT CLO_Cash.ContainerId
                            , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS AmountStart      -- остаток денег на начало периода
                            , Container.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS AmountEnd
                       FROM ContainerLinkObject AS CLO_Cash
                           INNER JOIN Container ON Container.Id = CLO_Cash.ContainerId
                                               AND Container.DescId = zc_Container_Summ()
                           LEFT JOIN MovementItemContainer AS MIContainer
                                                           ON MIContainer.Containerid = Container.Id
                                                          AND MIContainer.OperDate >= inStartDate                    
                       WHERE CLO_Cash.ObjectId in (select CashId from tmpCash) 
                         AND CLO_Cash.DescId = zc_ContainerLinkObject_Cash()
                       GROUP BY CLO_Cash.ContainerId, Container.Amount  
                      )  --      select sum(AmountStart), sum(AmountEnd) From  tmpCashContainer               

, tmpCashJuridical AS (SELECT SUM (CASE WHEN (MIContainer.OperDate  BETWEEN  inStartDate AND inEndDate  AND MIContainer.Amount>0)THEN MIContainer.Amount ELSE 0 END) as AmountDebet
                             , SUM (CASE WHEN (MIContainer.OperDate  BETWEEN  inStartDate AND inEndDate  AND MIContainer.Amount<0)THEN MIContainer.Amount ELSE 0 END) as AmountKredit
                             , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS AmountStart      -- остаток денег на начало периода
                             , Container.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS AmountEnd
                        FROM ContainerLinkObject AS CLO_Branch
                              INNER JOIN ContainerLinkObject AS CLO_Juridical
                                                             ON CLO_Juridical.ContainerId = CLO_Branch.ContainerId
                                                            AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                                            AND CLO_Juridical.ObjectId <> 0
                              INNER JOIN Container ON Container.Id = CLO_Juridical.ContainerId
                                           AND Container.DescId = zc_Container_Summ() 
                              JOIN MovementItemContainer AS MIContainer
                                                       ON MIContainer.Containerid = Container.Id
                                                      AND MIContainer.OperDate >= inStartDate  
                              LEFT JOIN ContainerLinkObject AS CLO_PaidKind
                                                        ON CLO_PaidKind.ContainerId = CLO_Juridical.ContainerId
                                                       AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()                         
                        WHERE CLO_Branch.DescId = zc_ContainerLinkObject_Branch() 
                          AND CLO_Branch.ObjectId =inBranchId  
                        GROUP BY CLO_Juridical.ContainerId, Container.Amount   
                       )

   SELECT  Object_Branch.ValueData  ::TVarChar   AS BranchName
       
        , CAST (tmpContainer.AmountStart         AS TFloat) AS SummStart
        , CAST (tmpContainer.AmountEnd           AS TFloat) AS SummEnd
        , CAST (tmpContainer.SummIn              AS TFloat) AS SummIn
        , CAST (tmpContainer.SummOut             AS TFloat) AS SummOut

        , CAST (tmpCashContainer.AmountStart         AS TFloat) AS CashSummStart
        , CAST (tmpCashContainer.AmountEnd           AS TFloat) AS CashSummEnd

        , CAST (tmpCashJuridical.AmountStart         AS TFloat) AS JuridicalSummStart
        , CAST (tmpCashJuridical.AmountEnd           AS TFloat) AS JuridicalSummEnd
        , CAST (tmpCashJuridical.AmountKredit        AS TFloat) AS JuridicalSummKredit
        , CAST (tmpCashJuridical.AmountDebet         AS TFloat) AS JuridicalSummDebet      

   FROM (SELECT SUM (tmpContainer.AmountStart) AS AmountStart
              , SUM (tmpContainer.AmountEnd)   AS AmountEnd
              , SUM (tmpContainer.SummIn)      AS SummIn
              , SUM (tmpContainer.SummOut)     AS SummOut
          FROM tmpContainer
         ) AS tmpContainer
            LEFT JOIN (SELECT SUM (tmpCashContainer.AmountStart) AS AmountStart
                            , SUM (tmpCashContainer.AmountEnd)   AS AmountEnd
                       FROM tmpCashContainer) AS tmpCashContainer ON 1=1
            LEFT JOIN (SELECT SUM (tmpCashJuridical.AmountStart)   AS AmountStart
                            , SUM (tmpCashJuridical.AmountEnd)     AS AmountEnd
                            , SUM (tmpCashJuridical.AmountKredit)  AS AmountKredit
                            , SUM (tmpCashJuridical.AmountDebet)   AS AmountDebet
                       FROM tmpCashJuridical) AS tmpCashJuridical  ON 1=1
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = inBranchId    
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
--SELECT * FROM gpReport_Branch_App7 (inStartDate:= '01.08.2015'::TDateTime, inEndDate:= '03.08.2015'::TDateTime, inBranchId:= 8374, inSession:= zfCalc_UserAdmin())  --
