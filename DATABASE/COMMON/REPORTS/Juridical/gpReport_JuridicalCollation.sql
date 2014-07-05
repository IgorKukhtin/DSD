-- Function: gpReport_JuridicalCollation()

DROP FUNCTION IF EXISTS gpReport_JuridicalCollation (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_JuridicalCollation (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_JuridicalCollation(
    IN inStartDate        TDateTime , -- 
    IN inEndDate          TDateTime , --
    IN inJuridicalId      Integer,    -- Юридическое лицо  
    IN inContractId       Integer,    -- Договор
    IN inAccountId        Integer,    -- Счет 
    IN inPaidKindId       Integer   , --
    IN inInfoMoneyId      Integer,    -- Управленческая статья  
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementSumm TFloat, 
               StartRemains TFloat, 
               EndRemains TFloat, 
               Debet TFloat, 
               Kredit TFloat, 
               OperDate TDateTime, 
               InvNumber TVarChar, InvNumberPartner TVarChar,
               AccountCode Integer,
               AccountName TVarChar,
               ContractCode Integer, 
               ContractName TVarChar,
               ContractTagName TVarChar,
               ContractStateKindCode Integer,
               PaidKindId Integer, PaidKindName TVarChar,
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
          CASE WHEN Operation.OperationSort = 0
                     THEN Operation.MovementSumm
               ELSE 0
          END::TFloat AS MovementSumm,

          Operation.StartSumm :: TFloat AS StartRemains,
          Operation.EndSumm :: TFloat AS EndRemains,     

          CASE WHEN Operation.OperationSort = 0 AND Operation.MovementSumm > 0
                    THEN Operation.MovementSumm
               ELSE 0
          END::TFloat AS Debet,

          CASE WHEN Operation.OperationSort = 0 AND Operation.MovementSumm < 0
                    THEN -1 * Operation.MovementSumm
               ELSE 0
          END::TFloat AS Kredit,

          Operation.OperDate,
          Movement.InvNumber,
          MovementString_InvNumberPartner.ValueData AS InvNumberPartner,
          Object_Account_View.AccountCode,
          Object_Account_View.AccountName_all AS AccountName,
          View_Contract_InvNumber.ContractCode,
          View_Contract_InvNumber.InvNumber AS ContractName,
          View_Contract_InvNumber.ContractTagName,
          View_Contract_InvNumber.ContractStateKindCode,
          Object_PaidKind.Id AS PaidKindId,
          Object_PaidKind.ValueData AS PaidKindName,
          Object_InfoMoney_View.InfoMoneyGroupCode,
          Object_InfoMoney_View.InfoMoneyGroupName,
          Object_InfoMoney_View.InfoMoneyDestinationCode,
          Object_InfoMoney_View.InfoMoneyDestinationName,
          Object_InfoMoney_View.InfoMoneyCode,
          Object_InfoMoney_View.InfoMoneyName,
          Movement.Id               AS MovementId, 
          CASE WHEN Operation.OperationSort = -1
                    THEN ' Долг:'
               ELSE MovementDesc.ItemName
          END::TVarChar  AS ItemName,     
          Operation.OperationSort, 
          Object_From.ValueData AS FromName, 
          Object_To.ValueData AS ToName
          --, Operation.MovementItemId :: Integer AS MovementItemId
          
    FROM (SELECT Container.ObjectId     AS AccountId, 
                 CLO_InfoMoney.ObjectId AS InfoMoneyId, 
                 CLO_Contract.ObjectId  AS ContractId, 
                 CLO_PaidKind.ObjectId  AS PaidKindId, 
                 MIContainer.MovementId,
                 MIContainer.OperDate,
                 MAX (MIContainer.MovementItemId) AS MovementItemId,
                 SUM (MIContainer.Amount) AS MovementSumm,
                 0 AS StartSumm,
                 0 AS EndSumm,
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
               LEFT JOIN ContainerLinkObject AS CLO_PaidKind
                                             ON CLO_PaidKind.ContainerId = Container.Id
                                            AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
               LEFT JOIN tmpContract ON tmpContract.ContractId = CLO_Contract.ObjectId

          WHERE CLO_Juridical.ObjectId = inJuridicalId AND inJuridicalId <> 0
            AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical() 
            AND (Container.ObjectId = inAccountId OR COALESCE (inAccountId, 0) = 0)
            AND (CLO_InfoMoney.ObjectId = inInfoMoneyId OR COALESCE (inInfoMoneyId, 0) = 0)
            AND (CLO_PaidKind.ObjectId = inPaidKindId OR COALESCE (inPaidKindId, 0) = 0)
            AND (tmpContract.ContractId > 0 OR COALESCE (inContractId, 0) = 0)
          GROUP BY Container.ObjectId, CLO_InfoMoney.ObjectId, CLO_Contract.ObjectId, CLO_PaidKind.ObjectId, MIContainer.MovementId, MIContainer.OperDate
          HAVING SUM (MIContainer.Amount) <> 0

         UNION ALL
          SELECT tmpRemains.AccountId, 
                 tmpRemains.InfoMoneyId, 
                 tmpRemains.ContractId, 
                 tmpRemains.PaidKindId, 
                 0 AS MovementId,
                 NULL :: TDateTime AS OperDate,
                 0 AS MovementItemId,
                 0 AS MovementSumm,
                 SUM (tmpRemains.StartSumm) AS StartSumm,
                 SUM (tmpRemains.EndSumm) AS EndSumm,
                 -1 AS OperationSort
          FROM
         (SELECT -- Container.Id           AS ContainerId, 
                 Container.ObjectId     AS AccountId, 
                 CLO_InfoMoney.ObjectId AS InfoMoneyId, 
                 View_Contract_ContractKey.ContractId_Key AS ContractId, -- CLO_Contract.ObjectId 
                 CLO_PaidKind.ObjectId  AS PaidKindId, 
                 Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS StartSumm,
                 0 AS EndSumm
          FROM ContainerLinkObject AS CLO_Juridical
               INNER JOIN Container ON Container.Id = CLO_Juridical.ContainerId
               LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                             ON CLO_InfoMoney.ContainerId = Container.Id
                                            AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()  
               LEFT JOIN ContainerLinkObject AS CLO_Contract
                                             ON CLO_Contract.ContainerId = Container.Id
                                            AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()
               LEFT JOIN Object_Contract_ContractKey_View AS View_Contract_ContractKey ON View_Contract_ContractKey.ContractId = CLO_Contract.ObjectId

               LEFT JOIN ContainerLinkObject AS CLO_PaidKind
                                             ON CLO_PaidKind.ContainerId = Container.Id
                                            AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
               LEFT JOIN tmpContract ON tmpContract.ContractId = CLO_Contract.ObjectId

               LEFT JOIN MovementItemContainer AS MIContainer 
                                               ON MIContainer.ContainerId = Container.Id
                                              AND MIContainer.OperDate >= inStartDate
          WHERE CLO_Juridical.ObjectId = inJuridicalId AND inJuridicalId <> 0
            AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical() 
            AND (Container.ObjectId = inAccountId OR COALESCE (inAccountId, 0) = 0)
            AND (CLO_InfoMoney.ObjectId = inInfoMoneyId OR COALESCE (inInfoMoneyId, 0) = 0)
            AND (CLO_PaidKind.ObjectId = inPaidKindId OR COALESCE (inPaidKindId, 0) = 0)
            AND (tmpContract.ContractId > 0 OR COALESCE (inContractId, 0) = 0)
          GROUP BY Container.Amount, Container.ObjectId, CLO_InfoMoney.ObjectId, View_Contract_ContractKey.ContractId_Key, CLO_PaidKind.ObjectId -- Container.Id, 

         UNION ALL
          SELECT -- Container.Id           AS ContainerId, 
                 Container.ObjectId     AS AccountId, 
                 CLO_InfoMoney.ObjectId AS InfoMoneyId, 
                 View_Contract_ContractKey.ContractId_Key AS ContractId, -- CLO_Contract.ObjectId 
                 CLO_PaidKind.ObjectId  AS PaidKindId, 
                 0 AS StartSumm,
                 Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS EndSumm
          FROM ContainerLinkObject AS CLO_Juridical 
               INNER JOIN Container ON Container.Id = CLO_Juridical.ContainerId
               LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                             ON CLO_InfoMoney.ContainerId = Container.Id
                                            AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()  
               LEFT JOIN ContainerLinkObject AS CLO_Contract
                                             ON CLO_Contract.ContainerId = Container.Id
                                            AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()
               LEFT JOIN Object_Contract_ContractKey_View AS View_Contract_ContractKey ON View_Contract_ContractKey.ContractId = CLO_Contract.ObjectId

               LEFT JOIN ContainerLinkObject AS CLO_PaidKind
                                             ON CLO_PaidKind.ContainerId = Container.Id
                                            AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
               LEFT JOIN tmpContract ON tmpContract.ContractId = CLO_Contract.ObjectId

               LEFT JOIN MovementItemContainer AS MIContainer 
                                               ON MIContainer.ContainerId = Container.Id
                                              AND MIContainer.OperDate > inEndDate
          WHERE CLO_Juridical.ObjectId = inJuridicalId AND inJuridicalId <> 0 
            AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
            AND (Container.ObjectId = inAccountId OR COALESCE (inAccountId, 0) = 0)
            AND (CLO_InfoMoney.ObjectId = inInfoMoneyId OR COALESCE (inInfoMoneyId, 0) = 0)
            AND (CLO_PaidKind.ObjectId = inPaidKindId OR COALESCE (inPaidKindId, 0) = 0)
            AND (tmpContract.ContractId > 0 OR COALESCE (inContractId, 0) = 0)
          GROUP BY Container.Amount, Container.ObjectId , CLO_InfoMoney.ObjectId, View_Contract_ContractKey.ContractId_Key, CLO_PaidKind.ObjectId -- Container.Id, 
        ) AS tmpRemains
        GROUP BY tmpRemains.AccountId, tmpRemains.InfoMoneyId, tmpRemains.ContractId, tmpRemains.PaidKindId -- tmpRemains.ContainerId, 
        HAVING SUM (tmpRemains.StartSumm) <> 0 OR SUM (tmpRemains.EndSumm) <> 0
        ) AS Operation

      LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = Operation.ContractId

      LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = Operation.AccountId
      LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Operation.InfoMoneyId
      LEFT JOIN Movement ON Movement.Id = Operation.MovementId
      LEFT JOIN MovementDesc ON Movement.DescId = MovementDesc.Id
      LEFT JOIN MovementString AS MovementString_InvNumberPartner
                               ON MovementString_InvNumberPartner.MovementId =  Operation.MovementId
                              AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

      LEFT JOIN MovementItem AS MovementItem_by ON MovementItem_by.Id = Operation.MovementItemId
                                               AND MovementItem_by.DescId IN (zc_MI_Master())
                                               AND Movement.DescId IN (zc_Movement_BankAccount(), zc_Movement_Cash())
      LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                       ON MILinkObject_Unit.MovementItemId = Operation.MovementItemId
                                      AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

      LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                   ON MovementLinkObject_From.MovementId = Movement.Id 
                                  AND MovementLinkObject_From.DescId = CASE WHEN Movement.DescId IN (zc_Movement_TransportService())
                                                                               THEN zc_MovementLinkObject_UnitForwarding()
                                                                            WHEN Movement.DescId IN (zc_Movement_PersonalAccount())
                                                                                 THEN zc_MovementLinkObject_Personal()
                                                                            WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnOut(), zc_Movement_TransferDebtOut())
                                                                                 THEN zc_MovementLinkObject_From()
                                                                            WHEN Movement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_Income(), zc_Movement_TransferDebtIn())
                                                                                 THEN zc_MovementLinkObject_From()
                                                                       END
      LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                   ON MovementLinkObject_To.MovementId = Movement.Id 
                                  AND MovementLinkObject_To.DescId = CASE WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnOut(), zc_Movement_TransferDebtOut())
                                                                               THEN zc_MovementLinkObject_To()
                                                                          WHEN Movement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_Income(), zc_Movement_TransferDebtIn())
                                                                               THEN zc_MovementLinkObject_To()
                                                                     END
      LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Bank
                           ON ObjectLink_BankAccount_Bank.ObjectId = MovementItem_by.ObjectId
                          AND ObjectLink_BankAccount_Bank.DescId = zc_ObjectLink_BankAccount_Bank()

      LEFT JOIN Object AS Object_From ON Object_From.Id = COALESCE (MovementLinkObject_From.ObjectId, 0) -- COALESCE (ObjectLink_BankAccount_Bank.ChildObjectId, COALESCE (MILinkObject_Unit.ObjectId, MovementItem_by.ObjectId)))
      LEFT JOIN Object AS Object_To ON Object_To.Id = COALESCE (MovementLinkObject_To.ObjectId, 0) -- COALESCE (ObjectLink_BankAccount_Bank.ChildObjectId, COALESCE (MILinkObject_Unit.ObjectId, MovementItem_by.ObjectId)))

      LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = Operation.PaidKindId
      
  ORDER BY Operation.OperationSort;
                                  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_JuridicalCollation (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
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
-- SELECT * FROM gpReport_JuridicalCollation (inStartDate:= '01.01.2014', inEndDate:= '01.01.2014', inJuridicalId:= 0, inContractId:= 0, inAccountId:= 0, inPaidKindId:= 0, inInfoMoneyId:= 0, inSession:= zfCalc_UserAdmin());
