
-- Function: gpReport_BankAccount

--DROP FUNCTION IF EXISTS gpReport_BankAccount (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_BankAccount (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_BankAccount(
    IN inStartDate        TDateTime , --
    IN inEndDate          TDateTime , --
    IN inJuridicalBasisId Integer   , -- гл. юр.лицо
    IN inAccountId        Integer,    -- Счет
    IN inBankAccountId    Integer,    -- Счет банк
    IN inCurrencyId       Integer   , -- Валюта
    IN inIsDetail         Boolean   , -- 
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (ContainerId Integer, BankName TVarChar, BankAccountName TVarChar
             , JuridicalName TVarChar
             , CurrencyName_BankAccount TVarChar, CurrencyName TVarChar
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
             , Summ_Currency TFloat, Summ_pl TFloat
             , MovementId Integer
             , CashName TVarChar
             , GroupId Integer, GroupName TVarChar
             , Comment TVarChar 
             , JuridicalByPrint TVarChar
             , OperDate TDateTime
              )
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbMemberId Integer;
   DECLARE vbIsExists Boolean;
   DECLARE vbCount    Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);
     

     -- Банк выписки Павильоны
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = 10985745)
     THEN
         inAccountId:= 10895486; -- 040304 Денежные средства  Расчетный счет Расчетный счет (павильоны)
         inJuridicalBasisId:= 0;
     END IF;
     
     IF inAccountId = 10895486    --Расчетный счет Расчетный счет (павильоны)
     THEN
         inJuridicalBasisId:= 0;
     END IF;

     -- проверка доступа
     vbMemberId := (SELECT ObjectLink_User_Member.ChildObjectId AS MemberId
                    FROM ObjectLink AS ObjectLink_User_Member
                    WHERE ObjectLink_User_Member.ObjectId = vbUserId
                      AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                    );

     --
     vbIsExists:= EXISTS (SELECT BankAccount_Juridical.ChildObjectId AS JuridicalId
                          FROM ObjectLink AS ObjectLink_MemberBankAccount_Member
                              INNER JOIN Object AS Object_MemberBankAccount
                                                ON Object_MemberBankAccount.Id = ObjectLink_MemberBankAccount_Member.ObjectId
                                               AND Object_MemberBankAccount.DescId = zc_Object_MemberBankAccount()
                                               AND Object_MemberBankAccount.isErased = FALSE
            
                              INNER JOIN ObjectLink AS ObjectLink_MemberBankAccount_BankAccount
                                                    ON ObjectLink_MemberBankAccount_BankAccount.ObjectId = ObjectLink_MemberBankAccount_Member.ObjectId
                                                   AND ObjectLink_MemberBankAccount_BankAccount.DescId = zc_ObjectLink_MemberBankAccount_BankAccount()
                   
                              INNER JOIN ObjectLink AS BankAccount_Juridical
                                                    ON BankAccount_Juridical.ObjectId      = ObjectLink_MemberBankAccount_BankAccount.ChildObjectId
                                                   AND BankAccount_Juridical.DescId        = zc_ObjectLink_BankAccount_Juridical()
                                                   AND BankAccount_Juridical.ChildObjectId = inJuridicalBasisId
                              LEFT JOIN ObjectBoolean AS ObjectBoolean_All 
                                                      ON ObjectBoolean_All.ObjectId = ObjectLink_MemberBankAccount_Member.ObjectId
                                                     AND ObjectBoolean_All.DescId = zc_ObjectBoolean_MemberBankAccount_All()
                                                     AND COALESCE (ObjectBoolean_All.ValueData, FALSE) = FALSE
                          WHERE ObjectLink_MemberBankAccount_Member.DescId = zc_ObjectLink_MemberBankAccount_Member()
                            AND ObjectLink_MemberBankAccount_Member.ChildObjectId = vbMemberId
                         );
     --
     vbCount:=COALESCE ((SELECT COUNT(*)
                         FROM ObjectLink AS ObjectLink_MemberBankAccount_Member
                             INNER JOIN Object AS Object_MemberBankAccount
                                               ON Object_MemberBankAccount.Id = ObjectLink_MemberBankAccount_Member.ObjectId
                                              AND Object_MemberBankAccount.DescId = zc_Object_MemberBankAccount()
                                              AND Object_MemberBankAccount.isErased = FALSE
                      
                             INNER JOIN ObjectLink AS ObjectLink_MemberBankAccount_BankAccount
                                                   ON ObjectLink_MemberBankAccount_BankAccount.ObjectId = ObjectLink_MemberBankAccount_Member.ObjectId
                                                  AND ObjectLink_MemberBankAccount_BankAccount.DescId = zc_ObjectLink_MemberBankAccount_BankAccount()
                        
                             INNER JOIN ObjectLink AS BankAccount_Juridical
                                                   ON BankAccount_Juridical.ObjectId      = ObjectLink_MemberBankAccount_BankAccount.ChildObjectId
                                                  AND BankAccount_Juridical.DescId        = zc_ObjectLink_BankAccount_Juridical()
                             LEFT JOIN ObjectBoolean AS ObjectBoolean_All 
                                                     ON ObjectBoolean_All.ObjectId = ObjectLink_MemberBankAccount_Member.ObjectId
                                                    AND ObjectBoolean_All.DescId = zc_ObjectBoolean_MemberBankAccount_All()
                                                    AND COALESCE (ObjectBoolean_All.ValueData, FALSE) = FALSE
                         WHERE ObjectLink_MemberBankAccount_Member.DescId = zc_ObjectLink_MemberBankAccount_Member()
                           AND ObjectLink_MemberBankAccount_Member.ChildObjectId = vbMemberId
                        ), 0);

     --
     IF COALESCE (inJuridicalBasisId = 0) AND vbCount <> 0
     THEN
         RAISE EXCEPTION 'Ошибка.Нет прав на просмотрт документов по всем Главным юр.лицам.';
     END IF;
     --
     IF COALESCE (inJuridicalBasisId <> 0) AND vbIsExists = FALSE AND vbCount <> 0
     THEN
         RAISE EXCEPTION 'Ошибка.Нет прав на просмотрт документов по Главному юр.лицу <%>.', lfGet_Object_ValueData_sh (inJuridicalBasisId);
     END IF;


  -- Результат
  RETURN QUERY
     WITH tmpAccount AS (SELECT Object_Account_View.AccountId 
                              , Object_Account_View.AccountName_all
                         FROM Object_Account_View 
                         WHERE AccountGroupId = zc_Enum_AccountGroup_40000() 
                            OR AccountDirectionId = zc_Enum_AccountDirection_110300()
                        ) -- Денежные средства OR Транзит + расчетный счет

        --
        , tmpBankAccount AS (SELECT Object_BankAccount.Id          AS Id
                                  , Object_BankAccount.ValueData   AS Name
                                  , Object_Bank.ValueData          AS BankName
                                  , Object_Currency.Id             AS CurrencyId
                                  , Object_Currency.ValueData      AS CurrencyName
                                  , Object_Juridical.Id            AS JuridicalId
                                  , Object_Juridical.ValueData     AS JuridicalName
                      
                             FROM Object AS Object_BankAccount
                                   LEFT JOIN ObjectLink AS BankAccount_Juridical
                                                        ON BankAccount_Juridical.ObjectId = Object_BankAccount.Id
                                                       AND BankAccount_Juridical.DescId = zc_ObjectLink_BankAccount_Juridical()
                                   LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = BankAccount_Juridical.ChildObjectId

                                   LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Bank
                                                        ON ObjectLink_BankAccount_Bank.ObjectId = Object_BankAccount.Id
                                                       AND ObjectLink_BankAccount_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
                                   LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_BankAccount_Bank.ChildObjectId
                                  
                                   LEFT JOIN ObjectLink AS BankAccount_Currency
                                                        ON BankAccount_Currency.ObjectId = Object_BankAccount.Id
                                                       AND BankAccount_Currency.DescId = zc_ObjectLink_BankAccount_Currency()
                                   LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = BankAccount_Currency.ChildObjectId

                             WHERE Object_BankAccount.DescId = zc_Object_BankAccount()
                               AND (BankAccount_Juridical.ChildObjectId = inJuridicalBasisId OR inJuridicalBasisId = 0)
                            )

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
                                
                                INNER JOIN tmpBankAccount ON tmpBankAccount.Id = COALESCE (CLO_BankAccount.ObjectId, CLO_Juridical.ObjectId) -- ограничиваем по гл. юр.лицу
                                
                                LEFT JOIN ContainerLinkObject AS CLO_Currency ON CLO_Currency.ContainerId = Container.Id AND CLO_Currency.DescId = zc_ContainerLinkObject_Currency()
                                LEFT JOIN Container AS Container_Currency ON Container_Currency.ParentId = Container.Id AND Container_Currency.DescId = zc_Container_SummCurrency()

                           WHERE (CLO_BankAccount.ContainerId IS NOT NULL OR CLO_Juridical.ContainerId IS NOT NULL)
                            --AND (Container.ObjectId = inAccountId OR inAccountId = 0)
                            AND (CLO_BankAccount.ObjectId = inBankAccountId OR inBankAccountId = 0)
                            AND (CLO_Currency.ObjectId = inCurrencyId OR inCurrencyId = 0 OR inCurrencyId = zc_Enum_Currency_Basis())
                            AND (COALESCE (CLO_BankAccount.ObjectId, CLO_Juridical.ObjectId) IN (SELECT DISTINCT tmpBankAccount.Id FROM tmpBankAccount)) -- ограничиваем по гл. юр.лицу) 
                            AND (  (inAccountId > 0 AND Container.ObjectId = inAccountId)
                                OR (inAccountId < 0 AND COALESCE (Container.ObjectId,0) <> (-1) * inAccountId)
                                OR COALESCE (inAccountId,0) = 0
                                )
                            
                          )

        , tmpUnit_byProfitLoss AS (SELECT * FROM lfSelect_Object_Unit_byProfitLossDirection ())

        , tmpInfoMoney AS (SELECT Object_InfoMoneyGroup.ValueData                          AS InfoMoneyGroupName
                                , Object_InfoMoneyDestination.ValueData                    AS InfoMoneyDestinationName
                                , Object_InfoMoney.Id                                      AS InfoMoneyId
                                , Object_InfoMoney.ObjectCode                              AS InfoMoneyCode
                                , Object_InfoMoney.ValueData                               AS InfoMoneyName
                         
                                , CAST ('(' || CAST (Object_InfoMoney.ObjectCode AS TVarChar)
                                    || ') '|| Object_InfoMoneyGroup.ValueData
                                    || ' ' || Object_InfoMoneyDestination.ValueData
                                    || CASE WHEN Object_InfoMoneyDestination.ValueData <> Object_InfoMoney.ValueData THEN ' ' || Object_InfoMoney.ValueData ELSE '' END
                                       AS TVarChar)                                        AS InfoMoneyName_all
                           FROM Object AS Object_InfoMoney
                                LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyDestination
                                                     ON ObjectLink_InfoMoney_InfoMoneyDestination.ObjectId = Object_InfoMoney.Id
                                                    AND ObjectLink_InfoMoney_InfoMoneyDestination.DescId = zc_ObjectLink_InfoMoney_InfoMoneyDestination()
                                LEFT JOIN Object AS Object_InfoMoneyDestination ON Object_InfoMoneyDestination.Id = ObjectLink_InfoMoney_InfoMoneyDestination.ChildObjectId
                          
                                LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyGroup
                                                     ON ObjectLink_InfoMoney_InfoMoneyGroup.ObjectId = Object_InfoMoney.Id
                                                    AND ObjectLink_InfoMoney_InfoMoneyGroup.DescId = zc_ObjectLink_InfoMoney_InfoMoneyGroup()
                                LEFT JOIN Object AS Object_InfoMoneyGroup ON Object_InfoMoneyGroup.Id = ObjectLink_InfoMoney_InfoMoneyGroup.ChildObjectId
                         
                          WHERE Object_InfoMoney.DescId = zc_Object_InfoMoney()
                          )

        , tmpContract AS (SELECT Object_Contract.Id                            AS ContractId
                               , Object_Contract.ObjectCode                    AS ContractCode  
                               , Object_Contract.ValueData                     AS InvNumber
                               , Object_ContractTag.ValueData                  AS ContractTagName
                          FROM Object AS Object_Contract
                               LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractTag
                                                    ON ObjectLink_Contract_ContractTag.ObjectId = Object_Contract.Id
                                                   AND ObjectLink_Contract_ContractTag.DescId = zc_ObjectLink_Contract_ContractTag()
                               LEFT JOIN Object AS Object_ContractTag ON Object_ContractTag.Id = ObjectLink_Contract_ContractTag.ChildObjectId
                        
                          WHERE Object_Contract.DescId = zc_Object_Contract()
                         )

        , tmpMI AS (SELECT *
                    FROM MovementItemContainer
                    WHERE MovementItemContainer.ContainerId IN (SELECT DISTINCT tmpContainer.ContainerId FROM tmpContainer)
                      AND MovementItemContainer.OperDate >= inStartDate
                    )
        , tmpMI_Currency AS (SELECT *
                             FROM MovementItemContainer
                             WHERE MovementItemContainer.ContainerId IN (SELECT DISTINCT tmpContainer.ContainerId_Currency FROM tmpContainer)
                               AND MovementItemContainer.OperDate >= inStartDate
                             )

        , tmpOperation_all AS   -- 1.1. остаток в валюте баланса
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
                                     , 0                         AS Summ_pl
                                     , 0                         AS MovementId
                                     , ''                        AS Comment
                                     , zc_DateStart()            AS OperDate
                                FROM tmpContainer
                                     LEFT JOIN tmpMI AS MIContainer ON MIContainer.ContainerId = tmpContainer.ContainerId
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
                                     , 0                         AS Summ_pl
                                     , 0                         AS MovementId
                                     , ''                        AS Comment
                                     , zc_DateStart()            AS OperDate
                                FROM tmpContainer
                                     LEFT JOIN tmpMI_Currency AS MIContainer ON MIContainer.ContainerId = tmpContainer.ContainerId_Currency
                                                                            AND MIContainer.OperDate >= inStartDate
                                WHERE tmpContainer.ContainerId_Currency > 0
                                GROUP BY tmpContainer.ContainerId, tmpContainer.AccountId, tmpContainer.BankAccountId, tmpContainer.CurrencyId, tmpContainer.Amount_Currency, tmpContainer.ContainerId_Currency
                               UNION ALL
                                -- 2.1. движение в валюте баланса
                                SELECT CASE WHEN inIsDetail = TRUE THEN 0 ELSE tmpContainer.ContainerId END AS ContainerId
                                     , tmpContainer.AccountId
                                     , tmpContainer.BankAccountId
                                     , tmpContainer.CurrencyId
                                     , COALESCE (MILO_InfoMoney.ObjectId, 0)   AS InfoMoneyId
                                   --, COALESCE (MILO_MoneyPlace.ObjectId, CASE WHEN MIContainer.MovementDescId = zc_Movement_Currency() AND inIsDetail = TRUE THEN zc_Enum_ProfitLoss_80103() ELSE 0 END)  AS MoneyPlaceId
                                     , COALESCE (MILO_MoneyPlace.ObjectId, CASE WHEN MIContainer.MovementDescId = zc_Movement_Currency() AND inIsDetail = TRUE THEN zc_Enum_ProfitLoss_75103() ELSE 0 END)  AS MoneyPlaceId
                                     , COALESCE (MILO_Contract.ObjectId, 0)    AS ContractId
                                     , COALESCE (MILO_Unit.ObjectId, 0)        AS UnitId
                                     , 0                         AS StartAmount
                                     , 0                         AS EndAmount
                                       -- нужен OR ... т.к. для ОПиУ надо проводки разделить, и там будет другой знак
                                     , SUM (CASE WHEN (MIContainer.Amount > 0 OR (MIContainer.isActive = TRUE  AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ProfitLoss())) AND NOT (MIContainer.isActive = FALSE AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ProfitLoss()) THEN MIContainer.Amount ELSE 0 END)      AS DebetSumm
                                       -- нужен AND ... т.к. для ОПиУ надо проводки разделить, и там будет другой знак
                                     , SUM (CASE WHEN (MIContainer.Amount < 0 OR (MIContainer.isActive = FALSE AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ProfitLoss())) AND NOT (MIContainer.isActive = TRUE  AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ProfitLoss()) THEN -1 * MIContainer.Amount ELSE 0 END) AS KreditSumm
                                     , 0                         AS StartAmount_Currency
                                     , 0                         AS EndAmount_Currency
                                     , 0                         AS DebetSumm_Currency
                                     , 0                         AS KreditSumm_Currency
                                     , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Currency() THEN MIContainer.Amount ELSE 0 END) AS Summ_Currency
                                     , 0                         AS Summ_pl
                                     , CASE WHEN MIContainer.MovementDescId = zc_Movement_Currency() /*OR 1=1*/ AND inIsDetail = TRUE THEN MIContainer.MovementId ELSE 0 END AS MovementId
                                     , COALESCE (MIString_Comment.ValueData, '') AS Comment
                                     , CASE WHEN inIsDetail = TRUE THEN MIContainer.OperDate ELSE zc_DateStart() END AS OperDate
                                FROM tmpContainer
                                     INNER JOIN tmpMI AS MIContainer ON MIContainer.ContainerId = tmpContainer.ContainerId
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
                                                                 AND inIsDetail = TRUE
                     
                                GROUP BY tmpContainer.ContainerId, tmpContainer.AccountId, tmpContainer.BankAccountId, tmpContainer.CurrencyId
                                       , MILO_InfoMoney.ObjectId, MILO_MoneyPlace.ObjectId, MILO_Contract.ObjectId, MILO_Unit.ObjectId
                                       , MIContainer.MovementDescId
                                       , CASE WHEN MIContainer.MovementDescId = zc_Movement_Currency() /*OR 1=1*/ AND inIsDetail = TRUE THEN MIContainer.MovementId ELSE 0 END
                                       , COALESCE (MIString_Comment.ValueData, '')
                                       , CASE WHEN inIsDetail = TRUE THEN MIContainer.OperDate ELSE zc_DateStart() END
                               UNION ALL
                                -- 2.2. движение в валюте операции
                                SELECT CASE WHEN inIsDetail = TRUE THEN 0 ELSE tmpContainer.ContainerId END AS ContainerId
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
                                     , 0                         AS Summ_pl
                                     , CASE WHEN MIContainer.MovementDescId = zc_Movement_Currency() /*OR 1=1*/ AND inIsDetail = TRUE THEN MIContainer.MovementId ELSE 0 END AS MovementId
                                     , COALESCE (MIString_Comment.ValueData, '') AS Comment
                                     , CASE WHEN inIsDetail = TRUE THEN MIContainer.OperDate ELSE zc_DateStart() END AS OperDate
                                FROM tmpContainer
                                     INNER JOIN tmpMI_Currency AS MIContainer ON MIContainer.ContainerId = tmpContainer.ContainerId_Currency
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
                                                                 AND inIsDetail = TRUE
                     
                                WHERE tmpContainer.ContainerId_Currency > 0
                                GROUP BY tmpContainer.ContainerId , tmpContainer.AccountId, tmpContainer.BankAccountId, tmpContainer.CurrencyId
                                       , MILO_InfoMoney.ObjectId, MILO_MoneyPlace.ObjectId, MILO_Contract.ObjectId, MILO_Unit.ObjectId
                                       , CASE WHEN MIContainer.MovementDescId = zc_Movement_Currency() /*OR 1=1*/ AND inIsDetail = TRUE THEN MIContainer.MovementId ELSE 0 END
                                       , COALESCE (MIString_Comment.ValueData, '')
                                       , CASE WHEN inIsDetail = TRUE THEN MIContainer.OperDate ELSE zc_DateStart() END
                               UNION ALL
                                -- 2.3. курсовая разница (!!!только не для ввода курса!!!)
                                SELECT CASE WHEN inIsDetail = TRUE THEN 0 ELSE tmpContainer.ContainerId END AS ContainerId
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
                                     -- , SUM (CASE WHEN MIReport.ActiveContainerId = tmpContainer.ContainerId THEN 1 ELSE -1 END * MIReport.Amount ) AS Summ_Currency
                                     , 0                         AS Summ_Currency
                                     , SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ProfitLoss() THEN MIContainer.Amount ELSE 0 END) AS Summ_pl
                                     , CASE WHEN 1 = 1 AND inIsDetail = TRUE THEN MIContainer.MovementId /*MIReport.MovementId*/ ELSE 0 END AS MovementId
                                     , COALESCE (MIString_Comment.ValueData, '') :: TVarChar AS Comment
                                     , CASE WHEN inIsDetail = TRUE THEN MIContainer.OperDate ELSE zc_DateStart() END AS OperDate
                                FROM tmpContainer
                                                                              
                                     INNER JOIN tmpMI AS MIContainer ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                                    AND MIContainer.MovementDescId <> zc_Movement_Currency()
                                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ProfitLoss() -- то что относится к ОПиУ, кроме проводок с товарами
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
                                                                 AND inIsDetail = TRUE
                     
                                GROUP BY tmpContainer.ContainerId, tmpContainer.AccountId, tmpContainer.BankAccountId, tmpContainer.CurrencyId
                                       , MILO_InfoMoney.ObjectId, MILO_MoneyPlace.ObjectId, MILO_Contract.ObjectId, MILO_Unit.ObjectId
                                       , CASE WHEN 1 = 1 AND inIsDetail = TRUE THEN MIContainer.MovementId ELSE 0 END
                                       , COALESCE (MIString_Comment.ValueData, '')
                                       , CASE WHEN inIsDetail = TRUE THEN MIContainer.OperDate ELSE zc_DateStart() END
                               )
     , tmpOperation AS (SELECT Operation_all.ContainerId, Operation_all.AccountId, Operation_all.BankAccountId, Operation_all.CurrencyId
                             , Operation_all.InfoMoneyId, Operation_all.MoneyPlaceId, Operation_all.ContractId, Operation_all.UnitId
                             , Operation_all.MovementId
                             , Operation_all.Comment
                             , Operation_all.OperDate
                             , SUM (Operation_all.StartAmount) AS StartAmount
                             , SUM (Operation_all.DebetSumm)   AS DebetSumm
                             , SUM (Operation_all.KreditSumm)  AS KreditSumm
                             , SUM (Operation_all.EndAmount)   AS EndAmount
                             , SUM (Operation_all.StartAmount_Currency) AS StartAmount_Currency
                             , SUM (Operation_all.DebetSumm_Currency)   AS DebetSumm_Currency
                             , SUM (Operation_all.KreditSumm_Currency)  AS KreditSumm_Currency
                             , SUM (Operation_all.EndAmount_Currency)   AS EndAmount_Currency
                             , SUM (Operation_all.Summ_Currency)        AS Summ_Currency
                             , SUM (Operation_all.Summ_pl)              AS Summ_pl
                        FROM tmpOperation_all AS Operation_all
                        GROUP BY Operation_all.ContainerId, Operation_all.AccountId, Operation_all.BankAccountId, Operation_all.CurrencyId
                               , Operation_all.InfoMoneyId, Operation_all.MoneyPlaceId, Operation_all.ContractId, Operation_all.UnitId
                               , Operation_all.MovementId , Operation_all.Comment
                               , Operation_all.OperDate
                        HAVING SUM (Operation_all.StartAmount) <> 0 
                             OR SUM (Operation_all.EndAmount) <> 0 
                             OR SUM (Operation_all.DebetSumm) <> 0
                             OR SUM (Operation_all.KreditSumm) <> 0
                             OR SUM (Operation_all.StartAmount_Currency) <> 0
                             OR SUM (Operation_all.EndAmount_Currency) <> 0
                             OR SUM (Operation_all.DebetSumm_Currency) <> 0
                             OR SUM (Operation_all.KreditSumm_Currency) <> 0
                             OR SUM (Operation_all.Summ_Currency) <> 0
                             OR SUM (Operation_all.Summ_pl) <> 0
                       )


     --
     SELECT
        Operation.ContainerId,
        tmpBankAccount.BankName                                                                     AS BankName,
        COALESCE (tmpBankAccount.Name, Object_Juridical.ValueData) :: TVarChar                      AS BankAccountName,
        tmpBankAccount.JuridicalName                               :: TVarChar                      AS JuridicalName,
        tmpBankAccount.CurrencyName                                                                 AS CurrencyName_BankAccount,
        Object_Currency.ValueData                                                                   AS CurrencyName,
        tmpInfoMoney.InfoMoneyGroupName                                                             AS InfoMoneyGroupName,
        tmpInfoMoney.InfoMoneyDestinationName                                                       AS InfoMoneyDestinationName,
        tmpInfoMoney.InfoMoneyCode                                                                  AS InfoMoneyCode,
        tmpInfoMoney.InfoMoneyName                                                                  AS InfoMoneyName,
        tmpInfoMoney.InfoMoneyName_all                                                              AS InfoMoneyName_all,
        tmpAccount.AccountName_all                                                                  AS AccountName,
        (Object_MoneyPlace.ValueData || COALESCE (' * '|| Object_Bank_MoneyPlace.ValueData, '')) :: TVarChar AS MoneyPlaceName,
        ObjectDesc_MoneyPlace.ItemName                                                              AS ItemName,
        tmpContract.ContractCode                                                                    AS ContractCode,
        tmpContract.InvNumber                                                                       AS ContractInvNumber,
        tmpContract.ContractTagName                                                                 AS ContractTagName,
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
        Operation.Summ_pl       :: TFloat                                                                             AS Summ_pl,
        Operation.MovementId :: Integer                                                                               AS MovementId,
        
        TRIM (COALESCE (tmpBankAccount.BankName, '' ) || '  ' || COALESCE (tmpBankAccount.Name, Object_Juridical.ValueData)) :: TVarChar  AS CashName,
        CASE WHEN Operation.ContainerId > 0 THEN 1          WHEN Operation.DebetSumm > 0 THEN 2               WHEN Operation.KreditSumm > 0 THEN 3           ELSE -1 END :: Integer AS GroupId,
        CASE WHEN Operation.ContainerId > 0 THEN '1.Сальдо' WHEN Operation.DebetSumm > 0 THEN '2.Поступления' WHEN Operation.KreditSumm > 0 THEN '3.Платежи' ELSE '' END :: TVarChar AS GroupName,
        Operation.Comment :: TVarChar                                                               AS Comment,
        
        CASE WHEN tmpBankAccount.JuridicalId = zc_Juridical_Basis() THEN tmpBankAccount.JuridicalName ELSE '' END ::TVarChar AS JuridicalByPrint,

        CASE WHEN Operation.OperDate = zc_DateStart() THEN NULL ELSE Operation.OperDate END :: TDateTime AS OperDate
 
     FROM tmpOperation AS Operation

     LEFT JOIN tmpAccount ON tmpAccount.AccountId = Operation.AccountId
     LEFT JOIN tmpBankAccount ON tmpBankAccount.Id = Operation.BankAccountId
     LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Operation.BankAccountId -- !!!не ошибка!!!
     LEFT JOIN tmpInfoMoney ON tmpInfoMoney.InfoMoneyId = Operation.InfoMoneyId
     LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Operation.UnitId
     LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = Operation.MoneyPlaceId
     LEFT JOIN ObjectDesc AS ObjectDesc_MoneyPlace ON ObjectDesc_MoneyPlace.Id = Object_MoneyPlace.DescId

     LEFT JOIN tmpUnit_byProfitLoss ON tmpUnit_byProfitLoss.UnitId = Operation.UnitId

     LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = Operation.CurrencyId

     LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Bank_MoneyPlace
                          ON ObjectLink_BankAccount_Bank_MoneyPlace.ObjectId = Operation.MoneyPlaceId
                         AND ObjectLink_BankAccount_Bank_MoneyPlace.DescId = zc_ObjectLink_BankAccount_Bank()
     LEFT JOIN Object AS Object_Bank_MoneyPlace ON Object_Bank_MoneyPlace.Id = ObjectLink_BankAccount_Bank_MoneyPlace.ChildObjectId

     LEFT JOIN tmpContract ON tmpContract.ContractId = Operation.ContractId

     WHERE (Operation.StartAmount <> 0 OR Operation.EndAmount <> 0 OR Operation.DebetSumm <> 0 OR Operation.KreditSumm <> 0
         OR Operation.StartAmount_Currency <> 0 OR Operation.EndAmount_Currency <> 0 OR Operation.DebetSumm_Currency <> 0 OR Operation.KreditSumm_Currency <> 0
         OR Operation.Summ_Currency <> 0 OR Operation.Summ_pl <> 0
           )
       AND (tmpBankAccount.CurrencyId = inCurrencyId OR inCurrencyId <> zc_Enum_Currency_Basis());

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 01.06.20         * 
 15.11.14                                        * add ..._Currency
 14.11.14         * add inCurrencyId
 27.09.14                                        *
 10.09.14                                                        *
*/

-- тест
-- SELECT * FROM gpReport_BankAccount (inStartDate:= '01.09.2024', inEndDate:= '01.09.2024', inJuridicalBasisId:= zc_Juridical_Basis(), inAccountId:= 0, inBankAccountId:= 0, inCurrencyId:= 76965, inIsDetail:= 'True', inSession:= '5');
