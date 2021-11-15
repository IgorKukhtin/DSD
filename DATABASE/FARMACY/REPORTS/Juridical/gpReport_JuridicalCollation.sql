-- Function: gpReport_JuridicalCollation()

DROP FUNCTION IF EXISTS gpReport_JuridicalCollation (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_JuridicalCollation (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_JuridicalCollation (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_JuridicalCollation (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_JuridicalCollation (TDateTime, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_JuridicalCollation (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_JuridicalCollation(
    IN inStartDate TDateTime,
    IN inEndDate TDateTime,
    IN inJuridicalId Integer,
    IN inJuridical_BasisId Integer,
    IN insession TVarChar)
RETURNS TABLE(
    MovementSumm TFloat
  , StartRemains TFloat
  , EndRemains TFloat
  , Debet TFloat
  , Kredit TFloat
  , Informative TFloat
  , OperDate TDateTime
  , InvNumber TVarChar
  , InvNumberPartner TVarChar
  , movementid Integer
  , ItemName TVarChar
  , Operationsort Integer
  , FromName TVarChar
  , ToName TVarChar
  , PaymentDate TDateTime, BranchDate TDateTime, DateLastPay TDateTime
  )
AS
$BODY$
   DECLARE vbJuridicalId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());
    
    vbJuridicalId := gpGet_User_JuridicalId(inSession);
    
    IF (vbJuridicalId <> 0) AND (inJuridical_BasisId <> vbJuridicalId) 
    THEN
       inJuridical_BasisId := vbJuridicalId;
    END IF;

    -- Один запрос, который считает остаток и движение. 
    RETURN QUERY  
        WITH 
        tmpContainer 
        AS 
        (
            SELECT 
                CLO_Juridical.ContainerId               AS ContainerId
              , Container.Amount                        AS Amount
            FROM ContainerLinkObject AS CLO_Juridical
                INNER JOIN Container ON Container.Id = CLO_Juridical.ContainerId
                                    AND Container.DescId = zc_Container_Summ()
                LEFT OUTER JOIN ContainerLinkObject AS CLO_JuridicalBasis
                                                    ON CLO_JuridicalBasis.ContainerId = Container.ID
                                                   AND CLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
            WHERE 
                CLO_Juridical.ObjectId = inJuridicalId AND inJuridicalId <> 0
                AND 
                CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical() 
                AND
                (
                    CLO_JuridicalBasis.ObjectId = inJuridical_BasisId
                    OR
                    inJuridical_BasisId = 0
                )
        )

 , tmpContainerDate AS (SELECT Object_Movement.ObjectCode           AS MovementId
                             , Container.Amount                     AS PaySumm 
                             , MAX(MIContainer.OperDate)::TDateTime AS LastDatePay
                        FROM Object AS Object_Movement
                         LEFT JOIN Container ON Container.DescId = zc_Container_SummIncomeMovementPayment()
                                            AND Container.ObjectId = Object_Movement.Id
                                            AND Container.KeyValue like '%,'||inJuridical_BasisId||';%'

                         LEFT OUTER JOIN MovementItemContainer AS MIContainer
                                                               ON MIContainer.ContainerId = Container.Id
                                                              AND MIContainer.MovementDescId in (zc_Movement_BankAccount(), zc_Movement_Payment())
                        WHERE Object_Movement.DescId = zc_Object_PartionMovement()
                        GROUP BY Object_Movement.ObjectCode, Container.Amount
                      )

 , tmpContainerInformative AS (SELECT Container.Id                         AS ContainerId
                                    , Container.Amount                     AS PaySumm 
                               FROM ContainerLinkObject AS CLO_JuridicalBasis
                                    INNER JOIN Container ON Container.Id =  CLO_JuridicalBasis.ContainerId
                                                        AND Container.DescId = zc_Container_SummIncomeMovementPayment() 
                                                        AND Container.ObjectId = zc_Enum_ChangeIncomePaymentKind_PartialSale()
                                    LEFT JOIN ContainerLinkObject AS CLO_Juridical
                                                                  ON CLO_Juridical.ContainerId = Container.Id
                                                                 AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                               WHERE CLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
                                 AND CLO_JuridicalBasis.ObjectId = inJuridical_BasisId
                                 AND CLO_Juridical.ObjectId = inJuridicalId
                              )

        SELECT 
            CASE 
                WHEN Operation.OperationSort = 0
                    THEN Operation.MovementSumm
            ELSE 0
            END :: TFloat                                  AS MovementSumm,

            Operation.StartSumm :: TFloat                  AS StartRemains,
            Operation.EndSumm :: TFloat                    AS EndRemains,     

            CASE 
                WHEN Operation.OperationSort = 0 
                     AND 
                     Operation.MovementSumm > 0
                     AND
                     Movement.DescId <> zc_Movement_ChangeIncomePayment()
                     
                     THEN Operation.MovementSumm
            ELSE 0
            END :: TFloat                                  AS Debet,

            CASE 
                WHEN Operation.OperationSort = 0 
                     AND 
                     (
                         Operation.MovementSumm < 0
                         OR
                         Movement.DescId = zc_Movement_ChangeIncomePayment()
                     )
                    THEN -1 * Operation.MovementSumm
            ELSE 0
            END :: TFloat                                  AS Kredit,

            Operation.Informative :: TFloat                AS Informative,

            Operation.OperDate,
            Movement.InvNumber,
            MovementString_InvNumberPartner.ValueData      AS InvNumberPartner,
            
            Movement.Id                                    AS MovementId, 
            CASE 
                WHEN Operation.OperationSort = -1
                    THEN ' Долг:'
            ELSE COALESCE(Object_ChangeIncomePaymentKind.ValueData,MovementDesc.ItemName)
            END::TVarChar  AS ItemName,     
            Operation.OperationSort,
            Object_From.ValueData as FromName,
            Object_To.ValueData as ToName

          , CASE WHEN tmpContainerDate.PaySumm > 0.01
                   OR Movement.StatusId <> zc_Enum_Status_Complete()
                 THEN MovementDate_Payment.ValueData
            END::TDateTime        AS PaymentDate 
          
          , MovementDate_Branch.ValueData      AS BranchDate
          , tmpContainerDate.LastDatePay       AS DateLastPay

        FROM(
            SELECT 
                tmpContainer.MovementId,
                tmpContainer.OperDate,
                
                SUM (tmpContainer.MovementSumm) AS MovementSumm,
                0 AS Informative,
                0 AS StartSumm,
                0 AS EndSumm,
                0 AS OperationSort
            FROM -- 1.1. движение в валюте баланса
               (SELECT MIContainer.MovementId,
                       MIContainer.OperDate,
                       SUM (MIContainer.Amount) AS MovementSumm
                FROM tmpContainer
                    INNER JOIN MovementItemContainer AS MIContainer
                                                     ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                GROUP BY MIContainer.MovementId, MIContainer.OperDate
                HAVING SUM (MIContainer.Amount) <> 0
               ) AS tmpContainer
           GROUP BY tmpContainer.MovementId,
                    tmpContainer.OperDate

          UNION ALL
            SELECT 
                tmpContainer.MovementId,
                tmpContainer.OperDate,
                
                0 AS MovementSumm,
                SUM (tmpContainer.MovementSumm) AS Informative,
                0 AS StartSumm,
                0 AS EndSumm,
                0 AS OperationSort
            FROM -- 1.1. движение в валюте баланса
               (SELECT MIContainer.MovementId,
                       MIContainer.OperDate,
                       SUM (MIContainer.Amount) AS MovementSumm
                FROM tmpContainerInformative
                    INNER JOIN MovementItemContainer AS MIContainer
                                                     ON MIContainer.ContainerId = tmpContainerInformative.ContainerId
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                GROUP BY MIContainer.MovementId, MIContainer.OperDate
                HAVING SUM (MIContainer.Amount) <> 0
               ) AS tmpContainer
           GROUP BY tmpContainer.MovementId,
                    tmpContainer.OperDate

          UNION ALL
           SELECT 0 AS MovementId,
                  NULL :: TDateTime AS OperDate,
                  0 AS MovementSumm,
                  0 AS Informative,
                  SUM (tmpRemains.StartSumm) AS StartSumm,
                  SUM (tmpRemains.EndSumm) AS EndSumm,
                  -1 AS OperationSort
           FROM  -- 2.1. остаток в валюте баланса
                (SELECT tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS StartSumm,
                        tmpContainer.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS EndSumm
                 FROM tmpContainer
                      LEFT JOIN MovementItemContainer AS MIContainer 
                                                      ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                     AND MIContainer.OperDate >= inStartDate
                 GROUP BY tmpContainer.ContainerId, tmpContainer.Amount
                ) AS tmpRemains
           HAVING SUM (tmpRemains.StartSumm) <> 0 OR SUM (tmpRemains.EndSumm) <> 0
          ) AS Operation

      LEFT JOIN Movement ON Movement.Id = Operation.MovementId
      LEFT JOIN MovementDesc ON Movement.DescId = MovementDesc.Id
      LEFT OUTER JOIN MovementLinkObject AS MLO_ChangeIncomePaymentKind
                                         ON MLO_ChangeIncomePaymentKind.MovementId = Movement.ID
                                        AND MLO_ChangeIncomePaymentKind.DescId = zc_MovementLinkObject_ChangeIncomePaymentKind()
      LEFT OUTER JOIN Object AS Object_ChangeIncomePaymentKind
                             ON Object_ChangeIncomePaymentKind.Id = MLO_ChangeIncomePaymentKind.ObjectId
      LEFT JOIN MovementString AS MovementString_InvNumberPartner
                               ON MovementString_InvNumberPartner.MovementId =  Operation.MovementId
                              AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

      
      LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                   ON MovementLinkObject_From.MovementId = Movement.Id 
                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
      LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                   ON MovementLinkObject_To.MovementId = Movement.Id 
                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                  
      LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Child
                                     ON MovementLinkMovement_Child.MovementId = Movement.Id
                                    AND MovementLinkMovement_Child.DescId = zc_MovementLinkMovement_Child()

      LEFT JOIN Movement AS Movement_Income 
                         ON Movement_Income.Id = MovementLinkMovement_Child.MovementChildId

      LEFT JOIN MovementLinkObject AS MovementLinkObject_IncomeFrom
                                   ON MovementLinkObject_IncomeFrom.MovementId = Movement_Income.Id
                                  AND MovementLinkObject_IncomeFrom.DescId = zc_MovementLinkObject_From()
      LEFT JOIN MovementLinkObject AS MovementLinkObject_IncomeTo
                                   ON MovementLinkObject_IncomeTo.MovementId = Movement_Income.Id
                                  AND MovementLinkObject_IncomeTo.DescId = zc_MovementLinkObject_To()
                                        
      LEFT JOIN Object AS Object_From ON Object_From.Id in (MovementLinkObject_From.ObjectId, MovementLinkObject_IncomeTo.ObjectId)
      LEFT JOIN Object AS Object_To ON Object_To.Id in (MovementLinkObject_To.ObjectId, MovementLinkObject_IncomeFrom.ObjectId)
      
      LEFT JOIN MovementDate AS MovementDate_Payment
                             ON MovementDate_Payment.MovementId =  Movement.Id
                            AND MovementDate_Payment.DescId = zc_MovementDate_Payment()

      LEFT JOIN MovementDate AS MovementDate_Branch
                             ON MovementDate_Branch.MovementId = Movement.Id
                            AND MovementDate_Branch.DescId = zc_MovementDate_Branch()

    
      LEFT JOIN tmpContainerDate ON tmpContainerDate.MovementId = Movement.Id

  ORDER BY Operation.OperationSort;
                                  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION gpreport_juridicalcollation(TDateTime, TDateTime, Integer, Integer, TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.  Шаблий О.В. 
 04.11.20                                                                      * Informative
 12.02.16         * add PaymentDate, BranchDate, DateLastPay
 12.01.16                                                       * Clear
 14.11.14         * add inCurrencyId
 21.08.14                                        * add ContractComment
 03.07.14                                        * add InvNumberPartner
 16.05.14                                        * add Operation.OperDate
 10.05.14                                        * add inInfoMoneyId
 05.05.14                                        * add inPaidKindId
 04.05.14                                        * add PaidKindName
 26.04.14                                        * add Object_Contract_ContractKey_View
 17.04.14                        * 
 26.03.14                        * 
 18.02.14                        * add WITH для ускорения запроса. 
 25.01.14                        * 
 15.01.14                        * 
*/

-- тест
--select * from gpReport_JuridicalCollation(inStartDate := ('07.09.2015')::TDateTime , inEndDate := ('26.11.2015')::TDateTime , inJuridicalId := 183317 , inJuridical_BasisId := 393052 ,  inSession := '3');

select * from gpReport_JuridicalCollation(inStartDate := ('01.11.2021')::TDateTime , inEndDate := ('12.11.2021')::TDateTime , inJuridicalId := 16413271 , inJuridical_BasisId := 0 ,  inSession := '3');