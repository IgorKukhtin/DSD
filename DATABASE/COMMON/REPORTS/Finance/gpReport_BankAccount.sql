-- Function: gpReport_BankAccount

DROP FUNCTION IF EXISTS gpReport_BankAccount (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_BankAccount(
    IN inStartDate        TDateTime , --
    IN inEndDate          TDateTime , --
    IN inAccountId        Integer,    -- Счет
    IN inBankAccountId    Integer,    -- Счет банк
    IN inCurrencyId       Integer   , -- Валюта
    IN inIsDetail         Boolean   , -- 
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (ContainerId Integer, BankName TVarChar, BankAccountName TVarChar, CurrencyName_BankAccount TVarChar, CurrencyName TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , AccountName TVarChar
             , MoneyPlaceName TVarChar, ItemName TVarChar
             , ContractCode Integer, ContractInvNumber TVarChar, ContractTagName TVarChar
             , UnitCode Integer, UnitName TVarChar
             , ProfitLossGroupCode Integer, ProfitLossGroupName TVarChar
             , ProfitLossDirectionCode Integer, ProfitLossDirectionName TVarChar
             , StartAmount TFloat, StartAmountD TFloat, StartAmountK TFloat
             , DebetSumm TFloat, KreditSumm TFloat
             , EndAmount TFloat, EndAmountD TFloat, EndAmountK TFloat
             , StartAmount_Currency TFloat, StartAmountD_Currency TFloat, StartAmountK_Currency TFloat
             , DebetSumm_Currency TFloat, KreditSumm_Currency TFloat
             , EndAmount_Currency TFloat, EndAmountD_Currency TFloat, EndAmountK_Currency TFloat
             , Summ_Currency TFloat
             , MovementId Integer
             , CashName TVarChar
             , GroupId Integer, GroupName TVarChar
             , Comment TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_...());

     -- Результат
  RETURN QUERY
     WITH tmpAccount AS (SELECT Object_Account_View.AccountId FROM Object_Account_View WHERE AccountGroupId = zc_Enum_AccountGroup_40000()) -- Денежные средства
        , tmpContainer AS (SELECT Container.Id                            AS ContainerId
                                , Container_Currency.Id                   AS ContainerId_Currency
                                , Container.ObjectId                      AS AccountId
                                , COALESCE (CLO_BankAccount.ObjectId, CLO_Juridical.ObjectId) AS BankAccountId
                                , COALESCE (CLO_Currency.ObjectId, 0)     AS CurrencyId
                                , Container.Amount                        AS Amount
                                , COALESCE (Container_Currency.Amount, 0) AS Amount_Currency
                           FROM tmpAccount
                                INNER JOIN Container ON Container.ObjectId = tmpAccount.AccountId AND Container.DescId = zc_Container_Summ()
                                LEFT JOIN ContainerLinkObject AS CLO_BankAccount ON CLO_BankAccount.ContainerId = Container.Id AND CLO_BankAccount.DescId = zc_ContainerLinkObject_BankAccount()
                                LEFT JOIN ContainerLinkObject AS CLO_Juridical ON CLO_Juridical.ContainerId = Container.Id AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                LEFT JOIN ContainerLinkObject AS CLO_Currency ON CLO_Currency.ContainerId = Container.Id AND CLO_Currency.DescId = zc_ContainerLinkObject_Currency()
                                LEFT JOIN Container AS Container_Currency ON Container_Currency.ParentId = Container.Id AND Container_Currency.DescId = zc_Container_SummCurrency()
                           WHERE (CLO_BankAccount.ContainerId IS NOT NULL OR CLO_Juridical.ContainerId IS NOT NULL)
                            AND (Container.ObjectId = inAccountId OR inAccountId = 0)
                            AND (CLO_BankAccount.ObjectId = inBankAccountId OR inBankAccountId = 0)
                            AND (CLO_Currency.ObjectId = inCurrencyId OR inCurrencyId = 0)
                          )
        , tmpUnit_byProfitLoss AS (SELECT * FROM lfSelect_Object_Unit_byProfitLossDirection ())
     SELECT
        Operation.ContainerId,
        Object_BankAccount_View.BankName                                                            AS BankName,
        COALESCE (Object_BankAccount_View.Name, Object_Juridical.ValueData) :: TVarChar             AS BankAccountName,
        Object_BankAccount_View.CurrencyName                                                        AS CurrencyName_BankAccount,
        Object_Currency.ValueData                                                                   AS CurrencyName,
        Object_InfoMoney_View.InfoMoneyGroupName                                                    AS InfoMoneyGroupName,
        Object_InfoMoney_View.InfoMoneyDestinationName                                              AS InfoMoneyDestinationName,
        Object_InfoMoney_View.InfoMoneyCode                                                         AS InfoMoneyCode,
        Object_InfoMoney_View.InfoMoneyName                                                         AS InfoMoneyName,
        Object_InfoMoney_View.InfoMoneyName_all                                                     AS InfoMoneyName_all,
        Object_Account_View.AccountName_all                                                         AS AccountName,
        (Object_MoneyPlace.ValueData || COALESCE (' * '|| Object_Bank_MoneyPlace.ValueData, '')) :: TVarChar AS MoneyPlaceName,
        ObjectDesc_MoneyPlace.ItemName                                                              AS ItemName,
        Object_Contract_InvNumber_View.ContractCode                                                 AS ContractCode,
        Object_Contract_InvNumber_View.InvNumber                                                    AS ContractInvNumber,
        Object_Contract_InvNumber_View.ContractTagName                                              AS ContractTagName,
        Object_Unit.ObjectCode                                                                      AS UnitCode,
        Object_Unit.ValueData                                                                       AS UnitName,
        tmpUnit_byProfitLoss.ProfitLossGroupCode,
        tmpUnit_byProfitLoss.ProfitLossGroupName,
        tmpUnit_byProfitLoss.ProfitLossDirectionCode,
        tmpUnit_byProfitLoss.ProfitLossDirectionName,

        Operation.StartAmount ::TFloat                                                              AS StartAmount,
        CASE WHEN Operation.StartAmount > 0 THEN Operation.StartAmount ELSE 0 END ::TFloat          AS StartAmountD,
        CASE WHEN Operation.StartAmount < 0 THEN -1 * Operation.StartAmount ELSE 0 END :: TFloat    AS StartAmountK,
        Operation.DebetSumm::TFloat                                                                 AS DebetSumm,
        Operation.KreditSumm::TFloat                                                                AS KreditSumm,
        Operation.EndAmount ::TFloat                                                                AS EndAmount,
        CASE WHEN Operation.EndAmount > 0 THEN Operation.EndAmount ELSE 0 END :: TFloat             AS EndAmountD,
        CASE WHEN Operation.EndAmount < 0 THEN -1 * Operation.EndAmount ELSE 0 END :: TFloat        AS EndAmountK,

        Operation.StartAmount_Currency ::TFloat                                                                       AS StartAmount_Currency,
        CASE WHEN Operation.StartAmount_Currency > 0 THEN Operation.StartAmount_Currency ELSE 0 END ::TFloat          AS StartAmountD_Currency,
        CASE WHEN Operation.StartAmount_Currency < 0 THEN -1 * Operation.StartAmount_Currency ELSE 0 END :: TFloat    AS StartAmountK_Currency,
        Operation.DebetSumm_Currency::TFloat                                                                          AS DebetSumm_Currency,
        Operation.KreditSumm_Currency::TFloat                                                                         AS KreditSumm_Currency,
        Operation.EndAmount_Currency ::TFloat                                                                         AS EndAmount_Currency,
        CASE WHEN Operation.EndAmount_Currency > 0 THEN Operation.EndAmount_Currency ELSE 0 END :: TFloat             AS EndAmountD_Currency,
        CASE WHEN Operation.EndAmount_Currency < 0 THEN -1 * Operation.EndAmount_Currency ELSE 0 END :: TFloat        AS EndAmountK_Currency,

        Operation.Summ_Currency :: TFloat                                                                             AS Summ_Currency,
        Operation.MovementId :: Integer                                                                               AS MovementId,
        
        (Object_BankAccount_View.BankName ||'  '||COALESCE (Object_BankAccount_View.Name, Object_Juridical.ValueData)) :: TVarChar  AS CashName,
        CASE WHEN Operation.ContainerId > 0 THEN 1          WHEN Operation.DebetSumm > 0 THEN 2               WHEN Operation.KreditSumm > 0 THEN 3           ELSE -1 END :: Integer AS GroupId,
        CASE WHEN Operation.ContainerId > 0 THEN '1.Сальдо' WHEN Operation.DebetSumm > 0 THEN '2.Поступления' WHEN Operation.KreditSumm > 0 THEN '3.Платежи' ELSE '' END :: TVarChar AS GroupName,
        Operation.Comment :: TVarChar                                                               AS Comment
 
     FROM
         (SELECT Operation_all.ContainerId, Operation_all.AccountId, Operation_all.BankAccountId, Operation_all.CurrencyId
               , Operation_all.InfoMoneyId, Operation_all.MoneyPlaceId, Operation_all.ContractId, Operation_all.UnitId
               , Operation_all.MovementId
               , Operation_all.Comment
               , SUM (Operation_all.StartAmount) AS StartAmount
               , SUM (Operation_all.DebetSumm)   AS DebetSumm
               , SUM (Operation_all.KreditSumm)  AS KreditSumm
               , SUM (Operation_all.EndAmount)   AS EndAmount
               , SUM (Operation_all.StartAmount_Currency) AS StartAmount_Currency
               , SUM (Operation_all.DebetSumm_Currency)   AS DebetSumm_Currency
               , SUM (Operation_all.KreditSumm_Currency)  AS KreditSumm_Currency
               , SUM (Operation_all.EndAmount_Currency)   AS EndAmount_Currency
               , SUM (Operation_all.Summ_Currency)        AS Summ_Currency
          FROM
           -- 1.1. остаток в валюте баланса
          (SELECT tmpContainer.ContainerId
                , tmpContainer.AccountId
                , tmpContainer.BankAccountId
                , tmpContainer.CurrencyId
                , 0                         AS InfoMoneyId
                , 0                         AS MoneyPlaceId
                , 0                         AS ContractId
                , 0                         AS UnitId
                , tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0)                                                            AS StartAmount
                , tmpContainer.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS EndAmount
                , 0                         AS DebetSumm
                , 0                         AS KreditSumm
                , 0                         AS StartAmount_Currency
                , 0                         AS EndAmount_Currency
                , 0                         AS DebetSumm_Currency
                , 0                         AS KreditSumm_Currency
                , 0                         AS Summ_Currency
                , 0                         AS MovementId
                , ''                        AS Comment
           FROM tmpContainer
                LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                              AND MIContainer.OperDate >= inStartDate
           GROUP BY tmpContainer.ContainerId , tmpContainer.AccountId, tmpContainer.BankAccountId, tmpContainer.CurrencyId, tmpContainer.Amount
          UNION ALL
           -- 1.2. остаток в валюте операции
           SELECT tmpContainer.ContainerId
                , tmpContainer.AccountId
                , tmpContainer.BankAccountId
                , tmpContainer.CurrencyId
                , 0                         AS InfoMoneyId
                , 0                         AS MoneyPlaceId
                , 0                         AS ContractId
                , 0                         AS UnitId
                , 0                         AS StartAmount
                , 0                         AS EndAmount
                , 0                         AS DebetSumm
                , 0                         AS KreditSumm
                , tmpContainer.Amount_Currency - COALESCE (SUM (MIContainer.Amount), 0)                                                            AS StartAmount_Currency
                , tmpContainer.Amount_Currency - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS EndAmount_Currency
                , 0                         AS DebetSumm_Currency
                , 0                         AS KreditSumm_Currency
                , 0                         AS Summ_Currency
                , 0                         AS MovementId
                , ''                        AS Comment
           FROM tmpContainer
                LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = tmpContainer.ContainerId_Currency
                                                              AND MIContainer.OperDate >= inStartDate
           WHERE tmpContainer.ContainerId_Currency > 0
           GROUP BY tmpContainer.ContainerId, tmpContainer.AccountId, tmpContainer.BankAccountId, tmpContainer.CurrencyId, tmpContainer.Amount_Currency, tmpContainer.ContainerId_Currency
          UNION ALL
           -- 2.1. движение в валюте баланса
           SELECT tmpContainer.ContainerId
                , tmpContainer.AccountId
                , tmpContainer.BankAccountId
                , tmpContainer.CurrencyId
                , COALESCE (MILO_InfoMoney.ObjectId, 0)   AS InfoMoneyId
                , COALESCE (MILO_MoneyPlace.ObjectId, CASE WHEN MIContainer.MovementDescId = zc_Movement_Currency() AND inIsDetail = TRUE THEN zc_Enum_ProfitLoss_80103() ELSE 0 END)  AS MoneyPlaceId
                , COALESCE (MILO_Contract.ObjectId, 0)    AS ContractId
                , COALESCE (MILO_Unit.ObjectId, 0)        AS UnitId
                , 0                         AS StartAmount
                , 0                         AS EndAmount
                , SUM (CASE WHEN MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END)      AS DebetSumm
                , SUM (CASE WHEN MIContainer.Amount < 0 THEN -1 * MIContainer.Amount ELSE 0 END) AS KreditSumm
                , 0                         AS StartAmount_Currency
                , 0                         AS EndAmount_Currency
                , 0                         AS DebetSumm_Currency
                , 0                         AS KreditSumm_Currency
                , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Currency() THEN MIContainer.Amount ELSE 0 END) AS Summ_Currency
                , CASE WHEN MIContainer.MovementDescId = zc_Movement_Currency() /*OR 1=1*/ AND inIsDetail = TRUE THEN MIContainer.MovementId ELSE 0 END AS MovementId
                , COALESCE (MIString_Comment.ValueData, '') AS Comment
           FROM tmpContainer
                INNER JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                              AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                LEFT JOIN MovementItemLinkObject AS MILO_MoneyPlace
                                                 ON MILO_MoneyPlace.MovementItemId = MIContainer.MovementItemId
                                                AND MILO_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
                                                AND inIsDetail = TRUE
                LEFT JOIN MovementItemLinkObject AS MILO_Contract
                                                 ON MILO_Contract.MovementItemId = MIContainer.MovementItemId
                                                AND MILO_Contract.DescId = zc_MILinkObject_Contract()
                                                AND inIsDetail = TRUE
                LEFT JOIN MovementItemLinkObject AS MILO_Unit
                                                 ON MILO_Unit.MovementItemId = MIContainer.MovementItemId
                                                AND MILO_Unit.DescId = zc_MILinkObject_Unit()
                                                AND inIsDetail = TRUE
                LEFT JOIN MovementItemLinkObject AS MILO_InfoMoney
                                                 ON MILO_InfoMoney.MovementItemId = MIContainer.MovementItemId
                                                AND MILO_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                                                AND inIsDetail = TRUE
                LEFT JOIN MovementItemString AS MIString_Comment
                                             ON MIString_Comment.MovementItemId = MIContainer.MovementItemId
                                            AND MIString_Comment.DescId = zc_MIString_Comment()

           GROUP BY tmpContainer.ContainerId, tmpContainer.AccountId, tmpContainer.BankAccountId, tmpContainer.CurrencyId
                  , MILO_InfoMoney.ObjectId, MILO_MoneyPlace.ObjectId, MILO_Contract.ObjectId, MILO_Unit.ObjectId
                  , MIContainer.MovementDescId
                  , CASE WHEN MIContainer.MovementDescId = zc_Movement_Currency() /*OR 1=1*/ AND inIsDetail = TRUE THEN MIContainer.MovementId ELSE 0 END
                  , COALESCE (MIString_Comment.ValueData, '')
          UNION ALL
           -- 2.2. движение в валюте операции
           SELECT tmpContainer.ContainerId
                , tmpContainer.AccountId
                , tmpContainer.BankAccountId
                , tmpContainer.CurrencyId
                , COALESCE (MILO_InfoMoney.ObjectId, 0)   AS InfoMoneyId
                , COALESCE (MILO_MoneyPlace.ObjectId, 0)  AS MoneyPlaceId
                , COALESCE (MILO_Contract.ObjectId, 0)    AS ContractId
                , COALESCE (MILO_Unit.ObjectId, 0)        AS UnitId
                , 0                         AS StartAmount
                , 0                         AS EndAmount
                , 0                         AS DebetSumm
                , 0                         AS KreditSumm
                , 0                         AS StartAmount_Currency
                , 0                         AS EndAmount_Currency
                , SUM (CASE WHEN MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END)      AS DebetSumm_Currency
                , SUM (CASE WHEN MIContainer.Amount < 0 THEN -1 * MIContainer.Amount ELSE 0 END) AS KreditSumm_Currency
                , 0                         AS Summ_Currency
                , CASE WHEN MIContainer.MovementDescId = zc_Movement_Currency() /*OR 1=1*/ AND inIsDetail = TRUE THEN MIContainer.MovementId ELSE 0 END AS MovementId
                , COALESCE (MIString_Comment.ValueData, '') AS Comment
           FROM tmpContainer
                INNER JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = tmpContainer.ContainerId_Currency
                                                               AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                LEFT JOIN MovementItemLinkObject AS MILO_MoneyPlace
                                                 ON MILO_MoneyPlace.MovementItemId = MIContainer.MovementItemId
                                                AND MILO_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
                                                AND inIsDetail = TRUE
                LEFT JOIN MovementItemLinkObject AS MILO_Contract
                                                 ON MILO_Contract.MovementItemId = MIContainer.MovementItemId
                                                AND MILO_Contract.DescId = zc_MILinkObject_Contract()
                                                AND inIsDetail = TRUE
                LEFT JOIN MovementItemLinkObject AS MILO_Unit
                                                 ON MILO_Unit.MovementItemId = MIContainer.MovementItemId
                                                AND MILO_Unit.DescId = zc_MILinkObject_Unit()
                                                AND inIsDetail = TRUE
                LEFT JOIN MovementItemLinkObject AS MILO_InfoMoney
                                                 ON MILO_InfoMoney.MovementItemId = MIContainer.MovementItemId
                                                AND MILO_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                                                AND inIsDetail = TRUE
                LEFT JOIN MovementItemString AS MIString_Comment
                                             ON MIString_Comment.MovementItemId = MIContainer.MovementItemId
                                            AND MIString_Comment.DescId = zc_MIString_Comment()

           WHERE tmpContainer.ContainerId_Currency > 0
           GROUP BY tmpContainer.ContainerId , tmpContainer.AccountId, tmpContainer.BankAccountId, tmpContainer.CurrencyId
                  , MILO_InfoMoney.ObjectId, MILO_MoneyPlace.ObjectId, MILO_Contract.ObjectId, MILO_Unit.ObjectId
                  , CASE WHEN MIContainer.MovementDescId = zc_Movement_Currency() /*OR 1=1*/ AND inIsDetail = TRUE THEN MIContainer.MovementId ELSE 0 END
                  , COALESCE (MIString_Comment.ValueData, '')
          UNION ALL
           -- 2.2. курсовая разница (!!!только не для ввода курса!!!)
           SELECT tmpContainer.ContainerId
                , tmpContainer.AccountId
                , tmpContainer.BankAccountId
                , tmpContainer.CurrencyId
                , COALESCE (MILO_InfoMoney.ObjectId, 0)   AS InfoMoneyId
                , COALESCE (MILO_MoneyPlace.ObjectId, 0)  AS MoneyPlaceId
                , COALESCE (MILO_Contract.ObjectId, 0)    AS ContractId
                , COALESCE (MILO_Unit.ObjectId, 0)        AS UnitId
                , 0                         AS StartAmount
                , 0                         AS EndAmount
                , 0                         AS DebetSumm
                , 0                         AS KreditSumm
                , 0                         AS StartAmount_Currency
                , 0                         AS EndAmount_Currency
                , 0                         AS DebetSumm_Currency
                , 0                         AS KreditSumm_Currency
                , SUM (CASE WHEN MIReport.ActiveContainerId = tmpContainer.ContainerId THEN 1 ELSE -1 END * MIReport.Amount ) AS Summ_Currency
                , CASE WHEN 1 = 1 AND inIsDetail = TRUE THEN MIReport.MovementId ELSE 0 END AS MovementId
                , COALESCE (MIString_Comment.ValueData, '') AS Comment
           FROM (SELECT tmpContainer.*
                      , CASE WHEN ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Active() THEN zc_Enum_AccountKind_Passive() ELSE zc_Enum_AccountKind_Active() END AccountKindId_find
                      , ReportContainerLink.ReportContainerId
                 FROM tmpContainer
                      INNER JOIN ReportContainerLink ON ReportContainerLink.ContainerId = tmpContainer.ContainerId
                ) AS tmpContainer
                INNER JOIN ReportContainerLink ON ReportContainerLink.ReportContainerId = tmpContainer.ReportContainerId
                                              AND ReportContainerLink.AccountKindId = tmpContainer.AccountKindId_find
                                              AND ReportContainerLink.AccountId = zc_Enum_Account_100301()
                INNER JOIN MovementItemReport AS MIReport ON MIReport.ReportContainerId = tmpContainer.ReportContainerId
                                                         AND MIReport.OperDate BETWEEN inStartDate AND inEndDate
                                                         AND MIReport.MovementDescId <> zc_Movement_Currency()
                LEFT JOIN MovementItemLinkObject AS MILO_MoneyPlace
                                                 ON MILO_MoneyPlace.MovementItemId = MIReport.MovementItemId
                                                AND MILO_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
                                                AND inIsDetail = TRUE
                LEFT JOIN MovementItemLinkObject AS MILO_Contract
                                                 ON MILO_Contract.MovementItemId = MIReport.MovementItemId
                                                AND MILO_Contract.DescId = zc_MILinkObject_Contract()
                                                AND inIsDetail = TRUE
                LEFT JOIN MovementItemLinkObject AS MILO_Unit
                                                 ON MILO_Unit.MovementItemId = MIReport.MovementItemId
                                                AND MILO_Unit.DescId = zc_MILinkObject_Unit()
                                                AND inIsDetail = TRUE
                LEFT JOIN MovementItemLinkObject AS MILO_InfoMoney
                                                 ON MILO_InfoMoney.MovementItemId = MIReport.MovementItemId
                                                AND MILO_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                                                AND inIsDetail = TRUE
                LEFT JOIN MovementItemString AS MIString_Comment
                                             ON MIString_Comment.MovementItemId = MIReport.MovementItemId
                                            AND MIString_Comment.DescId = zc_MIString_Comment()

           GROUP BY tmpContainer.ContainerId, tmpContainer.AccountId, tmpContainer.BankAccountId, tmpContainer.CurrencyId
                  , MILO_InfoMoney.ObjectId, MILO_MoneyPlace.ObjectId, MILO_Contract.ObjectId, MILO_Unit.ObjectId
                  , CASE WHEN 1 = 1 AND inIsDetail = TRUE THEN MIReport.MovementId ELSE 0 END
                  , COALESCE (MIString_Comment.ValueData, '')
          ) AS Operation_all

          GROUP BY Operation_all.ContainerId, Operation_all.AccountId, Operation_all.BankAccountId, Operation_all.CurrencyId
                 , Operation_all.InfoMoneyId, Operation_all.MoneyPlaceId, Operation_all.ContractId, Operation_all.UnitId
                 , Operation_all.MovementId , Operation_all.Comment
         ) AS Operation

     LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = Operation.AccountId
     LEFT JOIN Object_BankAccount_View ON Object_BankAccount_View.Id = Operation.BankAccountId
     LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Operation.BankAccountId -- !!!не ошибка!!!
     LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Operation.InfoMoneyId
     LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Operation.UnitId
     LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = Operation.MoneyPlaceId
     LEFT JOIN ObjectDesc AS ObjectDesc_MoneyPlace ON ObjectDesc_MoneyPlace.Id = Object_MoneyPlace.DescId

     LEFT JOIN tmpUnit_byProfitLoss ON tmpUnit_byProfitLoss.UnitId = Operation.UnitId

     LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = Operation.CurrencyId

     LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Bank_MoneyPlace
                          ON ObjectLink_BankAccount_Bank_MoneyPlace.ObjectId = Operation.MoneyPlaceId
                         AND ObjectLink_BankAccount_Bank_MoneyPlace.DescId = zc_ObjectLink_BankAccount_Bank()
     LEFT JOIN Object AS Object_Bank_MoneyPlace ON Object_Bank_MoneyPlace.Id = ObjectLink_BankAccount_Bank_MoneyPlace.ChildObjectId

     LEFT JOIN Object_Contract_InvNumber_View ON Object_Contract_InvNumber_View.ContractId = Operation.ContractId

     WHERE (Operation.StartAmount <> 0 OR Operation.EndAmount <> 0 OR Operation.DebetSumm <> 0 OR Operation.KreditSumm <> 0
         OR Operation.StartAmount_Currency <> 0 OR Operation.EndAmount_Currency <> 0 OR Operation.DebetSumm_Currency <> 0 OR Operation.KreditSumm_Currency <> 0
         OR Operation.Summ_Currency <> 0
           );


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_BankAccount (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 15.11.14                                        * add ..._Currency
 14.11.14         * add inCurrencyId
 27.09.14                                        *
 10.09.14                                                        *
*/

-- тест
-- SELECT * FROM gpReport_BankAccount (inStartDate:= '01.01.2015', inEndDate:= '31.01.2015', inAccountId:= 0, inBankAccountId:=0, inCurrencyId:= 0, inIsDetail:= TRUE, inSession:= zfCalc_UserAdmin());
