-- Function: gpReport_BankAccount

DROP FUNCTION IF EXISTS gpReport_BankAccount (TDateTime, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_BankAccount (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpReport_BankAccount(
    IN inStartDate        TDateTime , --
    IN inEndDate          TDateTime , --
    IN inAccountId        Integer,    -- Счет
    IN inBankAccountId    Integer,    -- Счет банк
    IN inCurrencyId       Integer   , -- Валюта
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (ContainerId Integer, BankName TVarChar, BankAccountName TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , AccountName TVarChar
             , MoneyPlaceName TVarChar
             , ContractCode Integer, ContractInvNumber TVarChar, ContractTagName TVarChar
             , StartAmount TFloat, StartAmountD TFloat, StartAmountK TFloat
             , DebetSumm TFloat, KreditSumm TFloat
             , EndAmount TFloat, EndAmountD TFloat, EndAmountK TFloat
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
        Operation.ContainerId,
        Object_Bank.ValueData                                                                       AS BankName,
        Object_BankAccount.ValueData                                                                AS BankAccountName,
        Object_InfoMoney_View.InfoMoneyGroupName                                                    AS InfoMoneyGroupName,
        Object_InfoMoney_View.InfoMoneyDestinationName                                              AS InfoMoneyDestinationName,
        Object_InfoMoney_View.InfoMoneyCode                                                         AS InfoMoneyCode,
        Object_InfoMoney_View.InfoMoneyName                                                         AS InfoMoneyName,
        Object_InfoMoney_View.InfoMoneyName_all                                                     AS InfoMoneyName_all,
        Object_Account_View.AccountName_all                                                         AS AccountName,
        Object_MoneyPlace.ValueData                                                                 AS MoneyPlaceName,
        Object_Contract_InvNumber_View.ContractCode                                                 AS ContractCode,
        Object_Contract_InvNumber_View.InvNumber                                                    AS ContractInvNumber,
        Object_Contract_InvNumber_View.ContractTagName                                              AS ContractTagName,
        Operation.StartAmount ::TFloat                                                              AS StartAmount,
        CASE WHEN Operation.StartAmount > 0 THEN Operation.StartAmount ELSE 0 END ::TFloat          AS StartAmountD,
        CASE WHEN Operation.StartAmount < 0 THEN -1 * Operation.StartAmount ELSE 0 END :: TFloat    AS StartAmountK,
        Operation.DebetSumm::TFloat                                                                 AS DebetSumm,
        Operation.KreditSumm::TFloat                                                                AS KreditSumm,
        Operation.EndAmount ::TFloat                                                                AS EndAmount,
        CASE WHEN Operation.EndAmount > 0 THEN Operation.EndAmount ELSE 0 END :: TFloat             AS EndAmountD,
        CASE WHEN Operation.EndAmount < 0 THEN -1 * Operation.EndAmount ELSE 0 END :: TFloat        AS EndAmountK

     FROM
         (SELECT Operation_all.ContainerId, Operation_all.ObjectId, Operation_all.BankAccountId, Operation_all.InfoMoneyId,
                 Operation_all.MoneyPlaceId, Operation_all.ContractId,
                     SUM (Operation_all.StartAmount) AS StartAmount,
                     SUM (Operation_all.DebetSumm)   AS DebetSumm,
                     SUM (Operation_all.KreditSumm)  AS KreditSumm,
                     SUM (Operation_all.EndAmount)   AS EndAmount
          FROM
           -- остаток
          (SELECT CLO_BankAccount.ContainerId      AS ContainerId,
                  Container.ObjectId               AS ObjectId,
                  CLO_BankAccount.ObjectId         AS BankAccountId,
                  0                         AS InfoMoneyId,
                  0                         AS MoneyPlaceId,
                  0                         AS ContractId,
                  Container.Amount - COALESCE(SUM (MIContainer.Amount), 0)                                                             AS StartAmount,
                  0                         AS DebetSumm,
                  0                         AS KreditSumm,
                  Container.Amount - COALESCE(SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0)  AS EndAmount

           FROM ContainerLinkObject AS CLO_BankAccount
                  INNER JOIN Container ON Container.Id = CLO_BankAccount.ContainerId AND Container.DescId = zc_Container_Summ()

                  LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.Containerid = Container.Id
                                                                AND MIContainer.OperDate >= inStartDate

           WHERE CLO_BankAccount.DescId = zc_ContainerLinkObject_BankAccount()
             AND (Container.ObjectId = inAccountId OR inAccountId = 0)
             AND (CLO_BankAccount.ObjectId = inBankAccountId OR inBankAccountId = 0)
           GROUP BY CLO_BankAccount.ContainerId , Container.ObjectId, CLO_BankAccount.ObjectId, Container.Amount

           UNION ALL
           -- движение
           SELECT CLO_BankAccount.ContainerId              AS ContainerId,
                  Container.ObjectId                AS ObjectId,
                  CLO_BankAccount.ObjectId                 AS BankAccountId,
                  MILO_InfoMoney.ObjectId           AS InfoMoneyId,
                  MILO_MoneyPlace.ObjectId          AS MoneyPlaceId,
                  MILO_Contract.ObjectId            AS ContractId,
                  0                                 AS StartAmount,
                  SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END ELSE 0 END)         AS DebetSumm,
                  SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.Amount < 0 THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END)    AS KreditSumm,
                  0                                 AS EndAmount

           FROM ContainerLinkObject AS CLO_BankAccount
                  INNER JOIN Container ON Container.Id = CLO_BankAccount.ContainerId AND Container.DescId = zc_Container_Summ()

                  LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.Containerid = Container.Id
                                                                AND MIContainer.OperDate >= inStartDate

                  LEFT JOIN MovementItemLinkObject AS MILO_MoneyPlace
                                                   ON MILO_MoneyPlace.MovementItemId = MIContainer.MovementItemId
                                                  AND MILO_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()

                  LEFT JOIN MovementItemLinkObject AS MILO_Contract
                                                   ON MILO_Contract.MovementItemId = MIContainer.MovementItemId
                                                  AND MILO_Contract.DescId = zc_MILinkObject_Contract()

                  LEFT JOIN MovementItemLinkObject AS MILO_InfoMoney
                                                   ON MILO_InfoMoney.MovementItemId = MIContainer.MovementItemId
                                                  AND MILO_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                  LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = MILO_InfoMoney.ObjectId

           WHERE CLO_BankAccount.DescId = zc_ContainerLinkObject_BankAccount()
             AND (Container.ObjectId = inAccountId OR inAccountId = 0)
             AND (CLO_BankAccount.ObjectId = inBankAccountId OR inBankAccountId = 0)
           GROUP BY CLO_BankAccount.ContainerId , Container.ObjectId, CLO_BankAccount.ObjectId, MILO_InfoMoney.ObjectId,
                    MILO_MoneyPlace.ObjectId, MILO_Contract.ObjectId

           ) AS Operation_all



          GROUP BY Operation_all.ContainerId, Operation_all.ObjectId, Operation_all.BankAccountId, Operation_all.InfoMoneyId, Operation_all.MoneyPlaceId, Operation_all.ContractId
         ) AS Operation


     LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = Operation.ObjectId
     LEFT JOIN Object AS Object_BankAccount ON Object_BankAccount.Id = Operation.BankAccountId
     LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Operation.InfoMoneyId
     LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = Operation.MoneyPlaceId

     LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Bank
                          ON ObjectLink_BankAccount_Bank.ObjectId = Operation.BankAccountId
                         AND ObjectLink_BankAccount_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
     LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_BankAccount_Bank.ChildObjectId

     LEFT JOIN Object_Contract_InvNumber_View ON Object_Contract_InvNumber_View.ContractId = Operation.ContractId

     WHERE (Operation.StartAmount <> 0 OR Operation.EndAmount <> 0 OR Operation.DebetSumm <> 0 OR Operation.KreditSumm <> 0);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_BankAccount (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 14.11.14         * add inCurrencyId
 27.09.14                                        *
 10.09.14                                                        *
*/

-- тест
-- SELECT * FROM gpReport_BankAccount (inStartDate:= '01.08.2014', inEndDate:= '31.08.2014', inAccountId:= 0, inBankAccountId:=0, inSession:= '2');