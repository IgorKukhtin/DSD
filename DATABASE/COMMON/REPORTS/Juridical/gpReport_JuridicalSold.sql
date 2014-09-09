-- Function: gpReport_JuridicalSold()

DROP FUNCTION IF EXISTS gpReport_JuridicalSold (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_JuridicalSold (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_JuridicalSold(
    IN inStartDate        TDateTime , -- 
    IN inEndDate          TDateTime , --
    IN inAccountId        Integer,    -- Счет  
    IN inInfoMoneyId      Integer,    -- Управленческая статья  
    IN inInfoMoneyGroupId Integer,    -- Группа управленческих статей
    IN inInfoMoneyDestinationId   Integer,    --
    IN inPaidKindId       Integer   , --
    IN inBranchId         Integer   , --
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (JuridicalCode Integer, JuridicalName TVarChar, OKPO TVarChar, JuridicalGroupName TVarChar
             , PartnerCode Integer, PartnerName TVarChar
             , BranchCode Integer, BranchName TVarChar
             , ContractCode Integer, ContractNumber TVarChar
             , ContractTagName TVarChar, ContractStateKindCode Integer
             , PersonalName TVarChar
             , PersonalCollationName TVarChar
             , StartDate TDateTime, EndDate TDateTime
             , PaidKindName TVarChar, AccountName TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , AreaName TVarChar
             , AccountId Integer, JuridicalId Integer, PartnerId Integer, InfoMoneyId Integer, ContractId Integer, PaidKindId Integer, BranchId Integer
             , StartAmount_A TFloat, StartAmount_P TFloat, StartAmountD TFloat, StartAmountK TFloat
             , DebetSumm TFloat, KreditSumm TFloat
             , IncomeSumm TFloat, ReturnOutSumm TFloat, SaleSumm TFloat, SaleRealSumm TFloat, ReturnInSumm TFloat, ReturnInRealSumm TFloat, MoneySumm TFloat, ServiceSumm TFloat, TransferDebtSumm TFloat, SendDebtSumm TFloat, OtherSumm TFloat
             , EndAmount_A TFloat, EndAmount_P TFloat, EndAmount_D TFloat, EndAmount_K TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_...());

     -- Результат
  RETURN QUERY  
     SELECT 
        Object_Juridical.ObjectCode AS JuridicalCode,   
        Object_Juridical.ValueData AS JuridicalName,
        ObjectHistory_JuridicalDetails_View.OKPO,
        Object_JuridicalGroup.ValueData  AS JuridicalGroupName,
        Object_Partner.ObjectCode AS PartnerCode,
        Object_Partner.ValueData  AS PartnerName,
        Object_Branch.ObjectCode  AS BranchCode,
        Object_Branch.ValueData   AS BranchName,
        View_Contract.ContractCode,
        View_Contract.InvNumber AS ContractNumber,
        View_Contract.ContractTagName,
        View_Contract.ContractStateKindCode,
        Object_Personal_View.PersonalName      AS PersonalName,
        Object_PersonalCollation.PersonalName  AS PersonalCollationName,
        View_Contract.StartDate,
        View_Contract.EndDate,
        Object_PaidKind.ValueData AS PaidKindName,
        Object_Account_View.AccountName_all AS AccountName,
        Object_InfoMoney_View.InfoMoneyGroupName,
        Object_InfoMoney_View.InfoMoneyDestinationName,
        Object_InfoMoney_View.InfoMoneyCode,
        Object_InfoMoney_View.InfoMoneyName,
        Object_Area.ValueData AS AreaName,

        Operation.ObjectId  AS AccountId,
        Object_Juridical.Id AS JuridicalId,
        Object_Partner.Id   AS PartnerId,
        Object_InfoMoney_View.InfoMoneyId,
        View_Contract.ContractId,
        Object_PaidKind.Id  AS PaidKindId,
        Object_Branch.Id    AS BranchId,

        Operation.StartAmount ::TFloat AS StartAmount_A,
        (-1 * Operation.StartAmount) ::TFloat AS StartAmount_P,
        CASE WHEN Operation.StartAmount > 0 THEN Operation.StartAmount ELSE 0 END ::TFloat AS StartAmount_D,
        CASE WHEN Operation.StartAmount < 0 THEN -1 * Operation.StartAmount ELSE 0 END :: TFloat AS StartAmount_K,

        Operation.DebetSumm::TFloat,
        Operation.KreditSumm::TFloat,

        Operation.IncomeSumm::TFloat,
        Operation.ReturnOutSumm::TFloat,
        Operation.SaleSumm::TFloat,
        Operation.SaleRealSumm::TFloat,
        Operation.ReturnInSumm::TFloat,
        Operation.ReturnInRealSumm::TFloat,
        Operation.MoneySumm::TFloat,
        Operation.ServiceSumm::TFloat,
        Operation.TransferDebtSumm::TFloat,
        Operation.SendDebtSumm::TFloat,
        Operation.OtherSumm::TFloat,

        Operation.EndAmount ::TFloat AS EndAmount_A,
        (-1 * Operation.EndAmount) ::TFloat AS EndAmount_P,
        CASE WHEN Operation.EndAmount > 0 THEN Operation.EndAmount ELSE 0 END :: TFloat AS EndAmount_D,
        CASE WHEN Operation.EndAmount < 0 THEN -1 * Operation.EndAmount ELSE 0 END :: TFloat AS EndAmount_K

     FROM
         (SELECT Operation_all.ObjectId, Operation_all.JuridicalId, Operation_all.InfoMoneyId
               , Operation_all.PaidKindId, Operation_all.BranchId
               , CLO_Partner.ObjectId AS PartnerId
               , View_Contract_ContractKey.ContractId_Key AS ContractId,
                     SUM (Operation_all.StartAmount) AS StartAmount,
                     SUM (Operation_all.DebetSumm)   AS DebetSumm,
                     SUM (Operation_all.KreditSumm)  AS KreditSumm,

                     SUM (Operation_all.IncomeSumm)    AS IncomeSumm,
                     SUM (Operation_all.ReturnOutSumm) AS ReturnOutSumm,
                     SUM (Operation_all.SaleSumm)      AS SaleSumm,
                     SUM (Operation_all.SaleRealSumm)  AS SaleRealSumm,
                     SUM (Operation_all.ReturnInSumm)  AS ReturnInSumm,
                     SUM (Operation_all.ReturnInRealSumm)  AS ReturnInRealSumm,
                     SUM (Operation_all.MoneySumm)     AS MoneySumm,
                     SUM (Operation_all.ServiceSumm)   AS ServiceSumm,
                     SUM (Operation_all.TransferDebtSumm)  AS TransferDebtSumm,
                     SUM (Operation_all.SendDebtSumm)  AS SendDebtSumm,
                     SUM (Operation_all.OtherSumm)     AS OtherSumm,
                     SUM (Operation_all.EndAmount)     AS EndAmount
          FROM
         (SELECT tmpContainer.ContainerId, tmpContainer.ObjectId, tmpContainer.JuridicalId, tmpContainer.InfoMoneyId, tmpContainer.PaidKindId, tmpContainer.BranchId
               , tmpContainer.Amount - COALESCE(SUM (MIContainer.Amount), 0) AS StartAmount
               , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS DebetSumm
               , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.Amount < 0 THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END) AS KreditSumm

               , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN Movement.DescId = zc_Movement_Income() THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END) AS IncomeSumm
               , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN Movement.DescId = zc_Movement_ReturnOut() THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS ReturnOutSumm

               , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_TransferDebtOut()) THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS SaleSumm
               , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN Movement.DescId IN (zc_Movement_Sale()) THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS SaleRealSumm
               , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN Movement.DescId IN (zc_Movement_TransferDebtOut(), zc_Movement_TransferDebtIn()) THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS TransferDebtSumm

               , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN Movement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_TransferDebtIn()) THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END) AS ReturnInSumm
               , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN Movement.DescId IN (zc_Movement_ReturnIn()) THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END) AS ReturnInRealSumm

               , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN Movement.DescId IN (zc_Movement_Cash(), zc_Movement_BankAccount(), zc_Movement_PersonalAccount()) THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END) AS MoneySumm
               , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN Movement.DescId IN (zc_Movement_Service(), zc_Movement_ProfitLossService(), zc_Movement_TransportService()) THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END) AS ServiceSumm
               , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN Movement.DescId IN (zc_Movement_SendDebt()) THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END) AS SendDebtSumm
               , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN Movement.DescId NOT IN (zc_Movement_Income(), zc_Movement_ReturnOut()
                                                                                                       , zc_Movement_Sale(), zc_Movement_ReturnIn()
                                                                                                       , zc_Movement_TransferDebtOut(), zc_Movement_TransferDebtIn()
                                                                                                       , zc_Movement_Cash(), zc_Movement_BankAccount(), zc_Movement_PersonalAccount()
                                                                                                       , zc_Movement_Service(), zc_Movement_ProfitLossService(), zc_Movement_TransportService()
                                                                                                       , zc_Movement_SendDebt()
                                                                                                        )
                                                                                 THEN MIContainer.Amount
                                                                            ELSE 0
                                                                       END
                           ELSE 0
                 END) AS OtherSumm
               , tmpContainer.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS EndAmount
          FROM (SELECT Container.Id AS ContainerId, Container.ObjectId, Container.Amount
                     , CLO_Juridical.ObjectId AS JuridicalId, CLO_InfoMoney.ObjectId AS InfoMoneyId, CLO_PaidKind.ObjectId AS PaidKindId, CLO_Branch.ObjectId AS BranchId
                FROM ContainerLinkObject AS CLO_Juridical
                     INNER JOIN Container ON Container.Id = CLO_Juridical.ContainerId AND Container.DescId = zc_Container_Summ()
                     LEFT JOIN ContainerLinkObject AS CLO_InfoMoney 
                                                   ON CLO_InfoMoney.ContainerId = Container.Id AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                     LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = CLO_InfoMoney.ObjectId
                     LEFT JOIN ContainerLinkObject AS CLO_Branch
                                                   ON CLO_Branch.ContainerId = Container.Id
                                                  AND CLO_Branch.DescId = zc_ContainerLinkObject_Branch()
                     LEFT JOIN ContainerLinkObject AS CLO_PaidKind
                                                   ON CLO_PaidKind.ContainerId = Container.Id
                                                  AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                WHERE CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                  AND (CLO_PaidKind.ObjectId = inPaidKindId OR COALESCE (inPaidKindId, 0) = 0)
                  AND (CLO_Branch.ObjectId = inBranchId OR COALESCE (inBranchId, 0) = 0)
                  AND (Object_InfoMoney_View.InfoMoneyDestinationId = inInfoMoneyDestinationId OR COALESCE (inInfoMoneyDestinationId, 0) = 0)
                  AND (Object_InfoMoney_View.InfoMoneyId = inInfoMoneyId OR COALESCE (inInfoMoneyId, 0) = 0)
                  AND (Object_InfoMoney_View.InfoMoneyGroupId = inInfoMoneyGroupId OR COALESCE (inInfoMoneyGroupId, 0) = 0)
                  AND (Container.ObjectId = inAccountId OR COALESCE (inAccountId, 0) = 0)
                ) AS tmpContainer
                LEFT JOIN MovementItemContainer AS MIContainer 
                                                ON MIContainer.Containerid = tmpContainer.ContainerId
                                               AND MIContainer.OperDate >= inStartDate
                LEFT JOIN Movement ON Movement.Id = MIContainer.MovementId
           GROUP BY tmpContainer.ContainerId, tmpContainer.ObjectId, tmpContainer.Amount, tmpContainer.JuridicalId, tmpContainer.InfoMoneyId, tmpContainer.PaidKindId, tmpContainer.BranchId
         ) AS Operation_all

           LEFT JOIN ContainerLinkObject AS CLO_Partner
                                         ON CLO_Partner.ContainerId = Operation_all.ContainerId
                                        AND CLO_Partner.DescId = zc_ContainerLinkObject_Partner()
           LEFT JOIN ContainerLinkObject AS CLO_Contract
                                         ON CLO_Contract.ContainerId = Operation_all.ContainerId
                                        AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()
           LEFT JOIN Object_Contract_ContractKey_View AS View_Contract_ContractKey ON View_Contract_ContractKey.ContractId = CLO_Contract.ObjectId

          GROUP BY Operation_all.ObjectId, Operation_all.JuridicalId, Operation_all.InfoMoneyId, Operation_all.PaidKindId, Operation_all.BranchId
                 , View_Contract_ContractKey.ContractId_Key
                 , CLO_Partner.ObjectId

         ) AS Operation

           LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = Operation.ContractId
           LEFT JOIN ObjectLink AS ObjectLink_Contract_Area
                                ON ObjectLink_Contract_Area.ObjectId = Operation.ContractId
                               AND ObjectLink_Contract_Area.DescId = zc_ObjectLink_Contract_Area()
           LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Contract_Area.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Contract_Personal
                               ON ObjectLink_Contract_Personal.ObjectId = Operation.ContractId
                              AND ObjectLink_Contract_Personal.DescId = zc_ObjectLink_Contract_Personal()
           LEFT JOIN Object_Personal_View ON Object_Personal_View.PersonalId = ObjectLink_Contract_Personal.ChildObjectId               

           LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalCollation
                                ON ObjectLink_Contract_PersonalCollation.ObjectId = Operation.ContractId
                               AND ObjectLink_Contract_PersonalCollation.DescId = zc_ObjectLink_Contract_PersonalCollation()
           LEFT JOIN Object_Personal_View AS Object_PersonalCollation ON Object_PersonalCollation.PersonalId = ObjectLink_Contract_PersonalCollation.ChildObjectId        

           LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = Operation.ObjectId
           LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Operation.JuridicalId   
           LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Operation.InfoMoneyId         
           
           LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id

           LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                                ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id 
                               AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
           LEFT JOIN Object AS Object_JuridicalGroup ON Object_JuridicalGroup.Id = ObjectLink_Juridical_JuridicalGroup.ChildObjectId

           LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = Operation.BranchId
           LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = Operation.PartnerId
           LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = Operation.PaidKindId

           WHERE (Operation.StartAmount <> 0 OR Operation.EndAmount <> 0 OR Operation.SaleSumm <> 0 OR Operation.MoneySumm <> 0 OR Operation.ServiceSumm <> 0 OR Operation.OtherSumm <> 0);
    -- Конец. Добавили строковые данные. 
    -- КОНЕЦ ЗАПРОСА

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_JuridicalSold (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.09.14                                        * add Branch...
 07.09.14                                        * ??? как без GROUP BY Container.Amount ???
 24.08.14                                        * add Partner...
 20.05.14                                        * add Object_Contract_View
 05.05.14                                        * add inPaidKindId
 26.04.14                                        * add Object_Contract_ContractKey_View
 15.04.14                                        * add StartDate and EndDate
 10.04.14                                        * add AreaName
 10.03.14                                        * add zc_Movement_ProfitLossService
 13.02.14                                        * add OKPO and ContractCode
 30.01.14                                        * 
 15.01.14                        * 
*/

-- тест
-- SELECT * FROM gpReport_JuridicalSold (inStartDate:= '01.06.2014', inEndDate:= '30.06.2014', inAccountId:= null, inInfoMoneyId:= null, inInfoMoneyGroupId:= null, inInfoMoneyDestinationId:= null, inPaidKindId:= null, inBranchId:= null, inSession:= zfCalc_UserAdmin()); 
