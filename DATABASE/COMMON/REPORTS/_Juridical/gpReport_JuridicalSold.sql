-- Function: gpReport_JuridicalSold()

DROP FUNCTION IF EXISTS gpReport_JuridicalSold (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_JuridicalSold(
    IN inStartDate        TDateTime , -- 
    IN inEndDate          TDateTime , --
    IN inAccountId        Integer,    -- Счет  
    IN inInfoMoneyId      Integer,    -- Управленческая статья  
    IN inInfoMoneyGroupId Integer,    -- Группа управленческих статей
    IN inInfoMoneyDestinationId   Integer,    -- филиал
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (JuridicalName TVarChar, ContractNumber TVarChar, PaidKindName TVarChar, AccountName TVarChar,
               InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , StartAmount_A TFloat, StartAmount_P TFloat, StartAmountD TFloat, StartAmountK TFloat
             , DebetSumm TFloat, KreditSumm TFloat
             , IncomeSumm TFloat, ReturnOutSumm TFloat, SaleSumm TFloat, ReturnInSumm TFloat, MoneySumm TFloat, ServiceSumm TFloat, SendDebtSumm TFloat, OtherSumm TFloat
             , EndAmount_A TFloat, EndAmount_P TFloat, EndAmount_D TFloat, EndAmount_K TFloat
              )
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());

     -- Один запрос, который считает остаток и движение. 
     -- Главная задача - выбор контейнера. Выбираем контейнеры по группе счетов 20400 для топлива и 30500 для денежных средств
  RETURN QUERY  
     SELECT 
        Object_Juridical.ValueData AS JuridicalName,   
        View_Contract_InvNumber.InvNumber AS ContractNumber,
        Object_PaidKind.ValueData AS PaidKindName,
        Object_Account_View.AccountName_all AS AccountName,
        Object_InfoMoney_View.InfoMoneyGroupName,
        Object_InfoMoney_View.InfoMoneyDestinationName,
        Object_InfoMoney_View.InfoMoneyCode,
        Object_InfoMoney_View.InfoMoneyName,

        Operation.StartAmount ::TFloat AS StartAmount_A,
        (-1 * Operation.StartAmount) ::TFloat AS StartAmount_P,
        CASE WHEN Operation.StartAmount > 0 THEN Operation.StartAmount ELSE 0 END ::TFloat AS StartAmount_D,
        CASE WHEN Operation.StartAmount < 0 THEN -1 * Operation.StartAmount ELSE 0 END :: TFloat AS StartAmount_K,

        Operation.DebetSumm::TFloat,
        Operation.KreditSumm::TFloat,

        Operation.IncomeSumm::TFloat,
        Operation.ReturnOutSumm::TFloat,
        Operation.SaleSumm::TFloat,
        Operation.ReturnInSumm::TFloat,
        Operation.MoneySumm::TFloat,
        Operation.ServiceSumm::TFloat,
        Operation.SendDebtSumm::TFloat,
        Operation.OtherSumm::TFloat,

        Operation.EndAmount ::TFloat AS EndAmount_A,
        (-1 * Operation.EndAmount) ::TFloat AS EndAmount_P,
        CASE WHEN Operation.EndAmount > 0 THEN Operation.EndAmount ELSE 0 END :: TFloat AS EndAmount_D,
        CASE WHEN Operation.EndAmount < 0 THEN -1 * Operation.EndAmount ELSE 0 END :: TFloat AS EndAmount_K

     FROM
          (SELECT Container.Id AS ContainerId, Container.ObjectId, CLO_Juridical.ObjectId AS JuridicalId, CLO_InfoMoney.ObjectId AS InfoMoneyId,
                     Container.Amount - COALESCE(SUM (MIContainer.Amount), 0) AS StartAmount,
                     SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS DebetSumm,
                     SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.Amount < 0 THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END) AS KreditSumm,

                     SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN Movement.DescId = zc_Movement_Income() THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END) AS IncomeSumm,
                     SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN Movement.DescId = zc_Movement_ReturnOut() THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS ReturnOutSumm,
                     SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN Movement.DescId = zc_Movement_Sale() THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS SaleSumm,
                     SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END) AS ReturnInSumm,
                     SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN Movement.DescId in (zc_Movement_Cash(), zc_Movement_BankAccount(), zc_Movement_PersonalAccount()) THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END) AS MoneySumm,
                     SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN Movement.DescId in (zc_Movement_Service(), zc_Movement_TransportService()) THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END) AS ServiceSumm,
                     SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN Movement.DescId in (zc_Movement_SendDebt()) THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END) AS SendDebtSumm,
                     SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN Movement.DescId not in (zc_Movement_Income(), zc_Movement_ReturnOut()
                                                                                                           , zc_Movement_Sale(), zc_Movement_ReturnIn()
                                                                                                           , zc_Movement_Cash(), zc_Movement_BankAccount(), zc_Movement_PersonalAccount()
                                                                                                           , zc_Movement_Service(), zc_Movement_TransportService()
                                                                                                           , zc_Movement_SendDebt()
                                                                                                            )
                                                                                     THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS OtherSumm,
                     Container.Amount - COALESCE(SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS EndAmount
                FROM ContainerLinkObject AS CLO_Juridical 
                JOIN Container ON Container.Id = CLO_Juridical.ContainerId AND Container.DescId = zc_Container_Summ()
           LEFT JOIN ContainerLinkObject AS CLO_InfoMoney 
                  ON CLO_InfoMoney.ContainerId = Container.Id AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
           LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = CLO_InfoMoney.ObjectId
                                  
           LEFT JOIN MovementItemContainer AS MIContainer 
                  ON MIContainer.Containerid = Container.Id
                 AND MIContainer.OperDate >= inStartDate
           LEFT JOIN Movement ON Movement.Id = MIContainer.MovementId
               WHERE CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                 AND (Object_InfoMoney_View.InfoMoneyDestinationId = inInfoMoneyDestinationId OR inInfoMoneyDestinationId = 0)
                 AND (Object_InfoMoney_View.InfoMoneyId = inInfoMoneyId OR inInfoMoneyId = 0)
                 AND (Object_InfoMoney_View.InfoMoneyGroupId = inInfoMoneyGroupId OR inInfoMoneyGroupId = 0)
                 AND (Container.ObjectId = inAccountId OR inAccountId = 0)
            GROUP BY Container.Id, MIContainer.Containerid, Container.ObjectId, JuridicalId, CLO_InfoMoney.ObjectId) AS Operation

           LEFT JOIN ContainerLinkObject AS CLO_Contract
                  ON CLO_Contract.ContainerId = Operation.ContainerId AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()
           LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = CLO_Contract.ObjectId

           LEFT JOIN ContainerLinkObject AS CLO_PaidKind 
                  ON CLO_PaidKind.ContainerId = Operation.ContainerId AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
           LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = CLO_PaidKind.ObjectId         

           LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = Operation.ObjectId
           LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Operation.JuridicalId   
           LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Operation.InfoMoneyId         
           
           WHERE (Operation.StartAmount <> 0 OR Operation.EndAmount <> 0 OR Operation.SaleSumm <> 0 OR Operation.MoneySumm <> 0 OR Operation.ServiceSumm <> 0 OR Operation.OtherSumm <> 0);
    -- Конец. Добавили строковые данные. 
    -- КОНЕЦ ЗАПРОСА

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_JuridicalSold (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.01.14                                        * 
 15.01.14                        * 
*/

-- тест
-- SELECT * FROM gpReport_JuridicalSold (inStartDate:= '01.01.2013', inEndDate:= '01.02.2013', inAccountId:= null, inInfoMoneyId:= null, inInfoMoneyGroupId:= null, inInfoMoneyDestinationId:= null, inSession:= '2'); 
