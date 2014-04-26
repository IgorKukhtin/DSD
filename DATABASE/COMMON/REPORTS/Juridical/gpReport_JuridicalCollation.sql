-- Function: gpReport_JuridicalCollation()

DROP FUNCTION IF EXISTS gpReport_JuridicalCollation (TDateTime, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_JuridicalCollation (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_JuridicalCollation(
    IN inStartDate        TDateTime , -- 
    IN inEndDate          TDateTime , --
    IN inJuridicalId      Integer,    -- Юридическое лицо  
    IN inContractId       Integer,    -- Договор
    IN inAccountId        Integer,    -- Счет 
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementSumm TFloat, 
               StartRemains TFloat, 
               EndRemains TFloat, 
               Debet TFloat, 
               Kredit TFloat, 
               OperDate TDateTime, 
               InvNumber TVarChar, 
               AccountCode Integer,
               AccountName TVarChar,
               ContractCode Integer, 
               ContractName TVarChar,
               ContractTagName TVarChar,
               ContractStateKindCode Integer,
               InfoMoneyGroupCode Integer,
               InfoMoneyGroupName TVarChar,
               InfoMoneyDestinationCode Integer,
               InfoMoneyDestinationName TVarChar,
               InfoMoneyCode Integer,
               InfoMoneyName TVarChar,
               MovementId Integer, 
               ItemName TVarChar,
               OperationSort Integer, 
               FromName TVarChar,
               ToName TVarChar)
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());

  -- Один запрос, который считает остаток и движение. 
  RETURN QUERY  
  WITH Object_Account_View AS (SELECT Object_Account_View.AccountCode, Object_Account_View.AccountName_all, Object_Account_View.AccountId FROM Object_Account_View)
     , tmpContract AS (SELECT COALESCE (View_Contract_ContractKey_find.ContractId, View_Contract_ContractKey.ContractId) AS ContractId
                       FROM Object_Contract_ContractKey_View AS View_Contract_ContractKey
                            LEFT JOIN Object_Contract_ContractKey_View AS View_Contract_ContractKey_find ON View_Contract_ContractKey_find.ContractKeyId = View_Contract_ContractKey.ContractKeyId
                       WHERE View_Contract_ContractKey.ContractId = inContractId)
  SELECT 
          CASE Operation.OperationSort 
               WHEN 0 THEN Operation.MovementSumm
               ELSE 0
          END::TFloat                   AS MovementSumm,
          CASE Operation.OperationSort 
               WHEN -1 THEN Operation.MovementSumm
               ELSE 0 
          END::TFloat                  AS StartRemains,     
          CASE Operation.OperationSort 
               WHEN  1 THEN Operation.MovementSumm
               ELSE 0
          END::TFloat                   AS EndRemains,     
          CASE Operation.OperationSort 
               WHEN 0 THEN (CASE WHEN Operation.MovementSumm > 0 THEN Operation.MovementSumm ELSE 0 END)
               ELSE 0
          END::TFloat AS Debet,
          CASE Operation.OperationSort 
               WHEN 0 THEN (CASE WHEN Operation.MovementSumm > 0 THEN 0 ELSE - Operation.MovementSumm END)
               ELSE 0
          END::TFloat AS Kredit,
          Movement.OperDate,
          Movement.InvNumber, 
          Object_Account_View.AccountCode,
          Object_Account_View.AccountName_all AS AccountName,
          View_Contract_InvNumber.ContractCode,
          View_Contract_InvNumber.InvNumber AS ContractName,
          View_Contract_InvNumber.ContractTagName,
          View_Contract_InvNumber.ContractStateKindCode,
          Object_InfoMoney_View.InfoMoneyGroupCode,
          Object_InfoMoney_View.InfoMoneyGroupName,
          Object_InfoMoney_View.InfoMoneyDestinationCode,
          Object_InfoMoney_View.InfoMoneyDestinationName,
          Object_InfoMoney_View.InfoMoneyCode,
          Object_InfoMoney_View.InfoMoneyName,
          Movement.Id               AS MovementId, 
          CASE Operation.OperationSort 
               WHEN -1 THEN 'Начальный остаток'
               WHEN 0  THEN MovementDesc.ItemName
               WHEN 1 THEN  'Конечный остаток'
          END::TVarChar  AS ItemName,     
          Operation.OperationSort, 
          Object_From.ValueData AS FromName,
          Object_To.ValueData AS ToName
          
    FROM (SELECT CLO_Contract.ObjectId AS ContractId, 
                 CLO_InfoMoney.ObjectId AS InfoMoneyId, 
                 MIContainer.MovementId, 
                 Container.ObjectId AS AccountId, 
                 SUM (MIContainer.Amount) AS MovementSumm,
                 0 AS OperationSort
          FROM ContainerLinkObject AS CLO_Juridical 
               INNER JOIN Container ON Container.Id = CLO_Juridical.ContainerId
               INNER JOIN MovementItemContainer AS MIContainer
                                                ON MIContainer.ContainerId = Container.Id
                                               AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
               LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                             ON CLO_InfoMoney.ContainerId = Container.Id
                                            AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()  
               LEFT JOIN ContainerLinkObject AS CLO_Contract
                                             ON CLO_Contract.ContainerId = Container.Id
                                            AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()  
               LEFT JOIN tmpContract ON tmpContract.ContractId = CLO_Contract.ObjectId
          WHERE CLO_Juridical.ObjectId = inJuridicalId AND inJuridicalId <> 0
            AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical() 
            AND (Container.ObjectId = inAccountId OR inAccountId = 0)
            AND (tmpContract.ContractId > 0 OR inContractId = 0)
          GROUP BY CLO_Contract.ObjectId, Container.ObjectId, MIContainer.MovementId, InfoMoneyId
          HAVING SUM (MIContainer.Amount) <> 0

         UNION 
          SELECT CLO_Contract.ObjectId AS ContractId, 
                 CLO_InfoMoney.ObjectId AS InfoMoneyId, 
                 0, 
                  Container.ObjectId AS AccountId, 
                  Container.Amount - SUM(MIContainer.Amount) AS Amount,
                  -1 AS OperationSort
          FROM ContainerLinkObject AS CLO_Juridical 
               INNER JOIN Container ON Container.Id = CLO_Juridical.ContainerId
               LEFT JOIN ContainerLinkObject AS CLO_Contract
                                             ON CLO_Contract.ContainerId = Container.Id
                                            AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()
               INNER JOIN MovementItemContainer AS MIContainer 
                                                ON MIContainer.ContainerId = Container.Id
                                               AND MIContainer.OperDate >= inStartDate
               LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                             ON CLO_InfoMoney.ContainerId = Container.Id
                                            AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()  
               LEFT JOIN tmpContract ON tmpContract.ContractId = CLO_Contract.ObjectId
          WHERE CLO_Juridical.ObjectId = inJuridicalId AND inJuridicalId <> 0 
            AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical() 
            AND (Container.ObjectId = inAccountId OR inAccountId = 0)
            AND (tmpContract.ContractId > 0 OR inContractId = 0)
          GROUP BY Container.Amount, Container.Id, CLO_Contract.ObjectId, CLO_InfoMoney.ObjectId, Container.ObjectId 

         UNION 
          SELECT CLO_Contract.ObjectId AS ContractId, 
                 CLO_InfoMoney.ObjectId AS InfoMoneyId, 
                 0, 
                 Container.ObjectId AS AccountId, 
                 Container.Amount - SUM(MIContainer.Amount) AS Amount,
                 1 AS OperationSort
          FROM ContainerLinkObject AS CLO_Juridical 
               INNER JOIN Container ON Container.Id = CLO_Juridical.ContainerId
               LEFT JOIN ContainerLinkObject AS CLO_Contract ON CLO_Contract.ContainerId = Container.Id
                                                            AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()
               INNER JOIN MovementItemContainer AS MIContainer 
                                                ON MIContainer.ContainerId = Container.Id
                                               AND MIContainer.OperDate >= inEndDate
               LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                             ON CLO_InfoMoney.ContainerId = Container.Id
                                            AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()  
               LEFT JOIN tmpContract ON tmpContract.ContractId = CLO_Contract.ObjectId
          WHERE CLO_Juridical.ObjectId = inJuridicalId AND inJuridicalId <> 0 
            AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical() 
            AND (Container.ObjectId = inAccountId OR inAccountId = 0)
            AND (tmpContract.ContractId > 0 OR inContractId = 0)
          GROUP BY Container.Amount, Container.Id, CLO_Contract.ObjectId, CLO_InfoMoney.ObjectId, Container.ObjectId 
        ) AS Operation

      LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = Operation.ContractId

      LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = Operation.AccountId
      LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Operation.InfoMoneyId
      LEFT JOIN Movement ON Movement.Id = Operation.MovementId
      LEFT JOIN MovementDesc ON Movement.DescId = MovementDesc.Id

      LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
      LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

      LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                   ON MovementLinkObject_To.MovementId = Movement.Id
                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
      LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
      
  ORDER BY Operation.OperationSort;
                                  
    -- Конец. Добавили строковые данные. 
    -- КОНЕЦ ЗАПРОСА

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_JuridicalCollation (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.04.14                                        * add Object_Contract_ContractKey_View
 17.04.14                        * 
 26.03.14                        * 
 18.02.14                        * add WITH для ускорения запроса. 
 25.01.14                        * 
 15.01.14                        * 
*/

-- тест
-- SELECT * FROM gpReport_Fuel (inStartDate:= '01.01.2013', inEndDate:= '01.02.2013', inFuelId:= null, inCarId:= null, inBranchId:= null,inSession:= '2'); 
