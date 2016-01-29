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
  , OperDate TDateTime
  , InvNumber TVarChar
  , InvNumberPartner TVarChar
  , movementid Integer
  , ItemName TVarChar
  , Operationsort Integer
  , FromName TVarChar
  , ToName TVarChar
  )
AS
$BODY$
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());

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
        FROM(
            SELECT 
                tmpContainer.MovementId,
                tmpContainer.OperDate,
                
                SUM (tmpContainer.MovementSumm) AS MovementSumm,
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
           SELECT 0 AS MovementId,
                  NULL :: TDateTime AS OperDate,
                  0 AS MovementSumm,
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
      
      LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
      LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
      
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
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
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
-- SELECT * FROM gpReport_JuridicalCollation (inStartDate:= '01.12.2015', inEndDate:= '01.01.2016', inJuridicalId:= 59610, inJuridical_BasisId := 0, inSession:= zfCalc_UserAdmin());
