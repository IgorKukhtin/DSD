-- Function: gpReport_BankAccount_Cash_Olap

DROP FUNCTION IF EXISTS gpReport_BankAccount_Cash_Olap (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_BankAccount_Cash_Olap(
    IN inStartDate        TDateTime , --
    IN inEndDate          TDateTime , --
    IN inAccountId        Integer,    -- Счет
    IN inCashId           Integer,    -- касса
    IN inBankAccountId    Integer,    -- р.счет или касса
    IN inCurrencyId       Integer,    -- Валюта
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (ContainerId Integer, CashCode Integer, CashName TVarChar, CurrencyName TVarChar
             , GroupId Integer, GroupName TVarChar
             , BranchName TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , CashFlowCode_in Integer, CashFlowName_in TVarChar
             , CashFlowCode_out Integer, CashFlowName_out TVarChar
             , AccountName TVarChar
             , UnitCode Integer, UnitName TVarChar
             , ProfitLossGroupCode Integer, ProfitLossGroupName TVarChar
             , ProfitLossDirectionCode Integer, ProfitLossDirectionName TVarChar
             , MoneyPlaceCode Integer, MoneyPlaceName TVarChar, ItemName TVarChar
             , ContractCode Integer, ContractInvNumber TVarChar, ContractTagName TVarChar
             , DebetSumm TFloat, KreditSumm TFloat
             , DebetSumm_Currency TFloat, KreditSumm_Currency TFloat
             , Summ_Currency TFloat, Summ_Currency_pl TFloat
             , StartAmount TFloat
             , StartAmount_Month TFloat
             , EndAmount TFloat
             , EndAmount_Month TFloat
             , OperDate TDateTime
             , MonthName TVarChar
             , MonthNum  Integer
             , OrdByPrint Integer
             , Year      TVarChar
             , Type_info TVarChar
             , NomStr Integer
             , InfoText TVarChar

             , MonthName1 TVarChar
             , MonthName2 TVarChar
             , CashFlowCode Integer
             , CashFlowName TVarChar
             , Sum1_CashFlow TFloat
             , Sum2_CashFlow TFloat
             , PrintGroup Integer
             , CashFlowGroupCode Integer
             , CashFlowGroupName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     -- Меняется значение параметра - криво
     IF inCurrencyId = zc_Enum_Currency_Basis() THEN
        inCurrencyId:= 0;
     END IF;


     -- Блокируем ему просмотр
     IF vbUserId = 9457 -- Климентьев К.И.
     THEN
         vbUserId:= NULL;
         RETURN;

     -- Блокируем ему просмотр за ДРУГОЙ период
     ELSEIF EXISTS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_CashReplace() AND UserId = vbUserId)
        -- AND inCashId    <> 296540 -- Касса Днепр БН
        AND (inStartDate < zc_DateStart_Role_CashReplace() OR inStartDate > zc_DateEnd_Role_CashReplace()
          OR inEndDate   < zc_DateStart_Role_CashReplace() OR inEndDate   > zc_DateEnd_Role_CashReplace()
          OR inCashId    <> 14462 -- Касса Днепр
            )
     THEN
         IF inStartDate < zc_DateStart_Role_CashReplace() OR inStartDate > zc_DateEnd_Role_CashReplace() THEN inStartDate:= zc_DateStart_Role_CashReplace(); END IF;
         IF inEndDate   < zc_DateStart_Role_CashReplace() OR inEndDate   > zc_DateEnd_Role_CashReplace() THEN inEndDate  := zc_DateEnd_Role_CashReplace();   END IF;

     END IF;


     -- Из-за прав меняем значение параметра
     IF COALESCE (inCashId, 0) = 0 AND (EXISTS (SELECT AccessKeyId_Guide FROM Object_RoleAccessKeyGuide_View WHERE AccessKeyId_Guide <> 0 AND UserId = vbUserId)
                                     OR EXISTS (SELECT AccessKeyId 
                                                FROM Object_RoleAccessKey_View 
                                                WHERE UserId = vbUserId
                                                  AND AccessKeyId IN (SELECT AccessKeyId FROM Object_RoleAccessKeyDocument_View WHERE ProcessId = zc_Enum_Process_InsertUpdate_Movement_Cash())
                                               )
                                       )
     THEN inCashId:= -1;
     END IF;


  -- Результат
  RETURN QUERY
     WITH 
        --- данные по Кассе
          tmpUnit_byProfitLoss AS (SELECT * FROM lfSelect_Object_Unit_byProfitLossDirection ())

        , tmpContainer AS (SELECT Container.Id                            AS ContainerId
                                , Container_Currency.Id                   AS ContainerId_Currency
                                , Container.ObjectId                      AS ObjectId
                                , CLO_Cash.ObjectId                       AS CashId
                                , COALESCE (CLO_Currency.ObjectId, 0)     AS CurrencyId
                                , COALESCE (CLO_Branch.ObjectId, 0)       AS BranchId
                                , COALESCE (Container.Amount,0)           AS Amount
                                , COALESCE (Container_Currency.Amount, 0) AS Amount_Currency
                           FROM ContainerLinkObject AS CLO_Cash
                               INNER JOIN Container ON Container.Id = CLO_Cash.ContainerId AND Container.DescId = zc_Container_Summ()
                               LEFT JOIN ContainerLinkObject AS CLO_Currency ON CLO_Currency.ContainerId = Container.Id AND CLO_Currency.DescId = zc_ContainerLinkObject_Currency()
                               LEFT JOIN ContainerLinkObject AS CLO_Branch   ON CLO_Branch.ContainerId   = Container.Id AND CLO_Branch.DescId = zc_ContainerLinkObject_Branch()
                               
                               LEFT JOIN Container AS Container_Currency ON Container_Currency.ParentId = Container.Id AND Container_Currency.DescId = zc_Container_SummCurrency()
                           WHERE CLO_Cash.DescId = zc_ContainerLinkObject_Cash()
                             AND (Container.ObjectId = inAccountId OR inAccountId = 0)
                             AND (CLO_Cash.ObjectId = inCashId OR inCashId = 0)
                             AND (CLO_Currency.ObjectId = inCurrencyId OR inCurrencyId = 0)
                           )
         , tmpAccount AS (SELECT Object_Account.Id           AS AccountId
                               , Object_Account.ObjectCode   AS AccountCode
                               , CAST (CASE WHEN Object_Account.ObjectCode < 100000
                                                 THEN '0'
                                            ELSE ''
                                       END
                                    || Object_Account.ObjectCode || ' '
                                    || Object_AccountGroup.ValueData
                                    || CASE WHEN Object_AccountDirection.ValueData <> Object_AccountGroup.ValueData
                                                 THEN ' ' || Object_AccountDirection.ValueData
                                            ELSE ''
                                       END
                                    || CASE WHEN Object_Account.ValueData <> Object_AccountDirection.ValueData
                                                 THEN ' ' || Object_Account.ValueData
                                            ELSE ''
                                       END                   AS TVarChar) AS AccountName_all 
                               
                          FROM Object AS Object_Account
                               LEFT JOIN ObjectLink AS ObjectLink_Account_AccountGroup
                                                    ON ObjectLink_Account_AccountGroup.ObjectId = Object_Account.Id 
                                                   AND ObjectLink_Account_AccountGroup.DescId = zc_ObjectLink_Account_AccountGroup()
                               LEFT JOIN Object AS Object_AccountGroup ON Object_AccountGroup.Id = ObjectLink_Account_AccountGroup.ChildObjectId
                   
                               LEFT JOIN ObjectLink AS ObjectLink_Account_AccountDirection
                                                    ON ObjectLink_Account_AccountDirection.ObjectId = Object_Account.Id 
                                                   AND ObjectLink_Account_AccountDirection.DescId = zc_ObjectLink_Account_AccountDirection()
                               LEFT JOIN Object AS Object_AccountDirection ON Object_AccountDirection.Id = ObjectLink_Account_AccountDirection.ChildObjectId
                    
                          WHERE Object_Account.DescId = zc_Object_Account()
                         )  
             
        , tmpInfoMoney AS (SELECT '(' || CAST (Object_InfoMoneyGroup.ObjectCode AS TVarChar) || ') '|| Object_InfoMoneyGroup.ValueData              AS InfoMoneyGroupName
                                , '(' || CAST (Object_InfoMoneyDestination.ObjectCode AS TVarChar) || ') '|| Object_InfoMoneyDestination.ValueData  AS InfoMoneyDestinationName
                                , Object_InfoMoney.Id                                      AS InfoMoneyId
                                , Object_InfoMoney.ObjectCode                              AS InfoMoneyCode
                                , '(' || CAST (Object_InfoMoney.ObjectCode AS TVarChar) || ') '|| Object_InfoMoney.ValueData AS InfoMoneyName
                         
                                , CAST ('(' || CAST (Object_InfoMoney.ObjectCode AS TVarChar)
                                    || ') '|| Object_InfoMoneyGroup.ValueData
                                    || ' ' || Object_InfoMoneyDestination.ValueData
                                    || CASE WHEN Object_InfoMoneyDestination.ValueData <> Object_InfoMoney.ValueData THEN ' ' || Object_InfoMoney.ValueData ELSE '' END
                                       AS TVarChar)                                        AS InfoMoneyName_all
                                       
                                , Object_CashFlow_in.Id                     AS CashFlowId_in
                                , Object_CashFlow_in.ObjectCode             AS CashFlowCode_in
                                , Object_CashFlow_in.ValueData              AS CashFlowName_in
                                --, '(' || CAST (Object_CashFlow_in.ObjectCode AS TVarChar) || ') '|| Object_CashFlow_in.ValueData AS CashFlowName_in

                                , Object_CashFlow_out.Id                     AS CashFlowId_out
                                , Object_CashFlow_out.ObjectCode             AS CashFlowCode_out
                                , Object_CashFlow_out.ValueData              AS CashFlowName_out
                                --, '(' || CAST (Object_CashFlow_out.ObjectCode AS TVarChar) || ') '|| Object_CashFlow_out.ValueData AS CashFlowName_out
                           FROM Object AS Object_InfoMoney
                                LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyDestination
                                                     ON ObjectLink_InfoMoney_InfoMoneyDestination.ObjectId = Object_InfoMoney.Id
                                                    AND ObjectLink_InfoMoney_InfoMoneyDestination.DescId = zc_ObjectLink_InfoMoney_InfoMoneyDestination()
                                LEFT JOIN Object AS Object_InfoMoneyDestination ON Object_InfoMoneyDestination.Id = ObjectLink_InfoMoney_InfoMoneyDestination.ChildObjectId
                          
                                LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyGroup
                                                     ON ObjectLink_InfoMoney_InfoMoneyGroup.ObjectId = Object_InfoMoney.Id
                                                    AND ObjectLink_InfoMoney_InfoMoneyGroup.DescId = zc_ObjectLink_InfoMoney_InfoMoneyGroup()
                                LEFT JOIN Object AS Object_InfoMoneyGroup ON Object_InfoMoneyGroup.Id = ObjectLink_InfoMoney_InfoMoneyGroup.ChildObjectId

                                LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_CashFlow_in
                                                     ON ObjectLink_InfoMoney_CashFlow_in.ObjectId = Object_InfoMoney.Id
                                                    AND ObjectLink_InfoMoney_CashFlow_in.DescId = zc_ObjectLink_InfoMoney_CashFlow_in()
                                LEFT JOIN Object AS Object_CashFlow_in ON Object_CashFlow_in.Id = ObjectLink_InfoMoney_CashFlow_in.ChildObjectId

                                LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_CashFlow_out
                                                     ON ObjectLink_InfoMoney_CashFlow_out.ObjectId = Object_InfoMoney.Id
                                                    AND ObjectLink_InfoMoney_CashFlow_out.DescId = zc_ObjectLink_InfoMoney_CashFlow_out()
                                LEFT JOIN Object AS Object_CashFlow_out ON Object_CashFlow_out.Id = ObjectLink_InfoMoney_CashFlow_out.ChildObjectId
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
                         
        -- ДЛЯ движение в валюте баланса   
        , tmpContainerBalance AS (SELECT MIContainer.MovementItemId
                                       , MIContainer.ContainerId
                                       , tmpContainer.ObjectId
                                       , tmpContainer.CashId
                                       , tmpContainer.CurrencyId
                                       , tmpContainer.BranchId
                                       , CASE WHEN MIContainer.MovementDescId = zc_Movement_Currency() THEN MIContainer.MovementDescId ELSE 0 END AS MovementDescId
                                       , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END ELSE 0 END)         AS DebetSumm
                                       , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.Amount < 0 THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END)    AS KreditSumm
                                       , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Currency() THEN MIContainer.Amount ELSE 0 END)                                        AS Summ_Currency
                                       , SUM (CASE WHEN MIContainer.AccountId          = zc_Enum_Account_40801()  -- Курсовая разница
                                                    AND MIContainer.AccountId_Analyzer = zc_Enum_Account_100301() -- прибыль текущего периода
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS Summ_Currency_pl
                                       , MIContainer.isActive
                                       , MIContainer.OperDate :: TDatetime AS OperDate
                                  FROM tmpContainer
                                         LEFT JOIN MovementItemContainer AS MIContainer
                                                                         ON MIContainer.Containerid = tmpContainer.ContainerId
                                                                        AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                  GROUP BY tmpContainer.ObjectId
                                         , tmpContainer.CashId
                                         , tmpContainer.CurrencyId
                                         , tmpContainer.BranchId
                                         , MIContainer.isActive
                                         , MIContainer.MovementItemId
                                         , MIContainer.ContainerId
                                         , MIContainer.OperDate
                                         , CASE WHEN MIContainer.MovementDescId = zc_Movement_Currency() THEN MIContainer.MovementDescId ELSE 0 END
                                  )
          -- ВСЕ св-ва
        , tmpMovementItemLinkObject AS (SELECT MovementItemLinkObject.*
                                        FROM MovementItemLinkObject
                                        WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpContainerBalance.MovementItemId FROM tmpContainerBalance)
                                       )
        , tmpMoneyPlace_Balance AS (SELECT MILO_MoneyPlace.MovementItemId
                                         , MILO_MoneyPlace.ObjectId 
                                    FROM tmpMovementItemLinkObject AS MILO_MoneyPlace
                                    WHERE MILO_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
                                   )
        , tmpInfoMoney_Balance AS (SELECT MILO_InfoMoney.MovementItemId
                                        , MILO_InfoMoney.ObjectId 
                                   FROM tmpMovementItemLinkObject AS MILO_InfoMoney
                                   WHERE MILO_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                                   )
        , tmpUnit_Balance AS (SELECT MILO_Unit.MovementItemId
                                   , MILO_Unit.ObjectId 
                              FROM tmpMovementItemLinkObject AS MILO_Unit
                              WHERE MILO_Unit.DescId = zc_MILinkObject_Unit()
                              )
        , tmpContract_Balance AS (SELECT MILO_Contract.MovementItemId
                                       , MILO_Contract.ObjectId 
                                  FROM tmpMovementItemLinkObject AS MILO_Contract
                                  WHERE MILO_Contract.DescId = zc_MILinkObject_Contract()
                                  )
        , tmpComment_Balance AS (SELECT MIString_Comment.MovementItemId
                                      , COALESCE (MIString_Comment.ValueData, '') AS ValueData
                                 FROM MovementItemString AS MIString_Comment
                                 WHERE MIString_Comment.DescId = zc_MIString_Comment()
                                   AND MIString_Comment.MovementItemId IN (SELECT DISTINCT tmpContainerBalance.MovementItemId FROM tmpContainerBalance)
                              ) 
 
            -- ДЛЯ движение  в валюте операции
        , tmpContainerCurrency AS (SELECT MIContainer.MovementItemId
                                        , tmpContainer.ObjectId
                                        , tmpContainer.CashId
                                        , tmpContainer.CurrencyId
                                        , tmpContainer.BranchId
                                        , SUM (CASE WHEN MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END)      AS DebetSumm_Currency
                                        , SUM (CASE WHEN MIContainer.Amount < 0 THEN -1 * MIContainer.Amount ELSE 0 END) AS KreditSumm_Currency
                                        , MIContainer.isActive
                                        , MIContainer.OperDate :: TDatetime AS OperDate
                                   FROM tmpContainer
                                          LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.Containerid = tmpContainer.ContainerId_Currency
                                                                                        AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                   WHERE tmpContainer.ContainerId_Currency > 0
                                   GROUP BY MIContainer.MovementItemId
                                          , tmpContainer.ObjectId
                                          , tmpContainer.CashId
                                          , tmpContainer.CurrencyId
                                          , MIContainer.isActive
                                          , MIContainer.OperDate
                                          , tmpContainer.BranchId
                                  )
          -- ВСЕ св-ва
        , tmpMovementItemLinkObject_сurr AS (SELECT MovementItemLinkObject.*
                                             FROM MovementItemLinkObject
                                             WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpContainerCurrency.MovementItemId FROM tmpContainerCurrency)
                                            )
        , tmpMoneyPlace_Currency AS (SELECT MILO_MoneyPlace.MovementItemId
                                          , MILO_MoneyPlace.ObjectId 
                                     FROM tmpMovementItemLinkObject_сurr AS MILO_MoneyPlace
                                     WHERE MILO_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
                                    )
        , tmpInfoMoney_Currency AS (SELECT MILO_InfoMoney.MovementItemId
                                         , MILO_InfoMoney.ObjectId 
                                    FROM tmpMovementItemLinkObject_сurr AS MILO_InfoMoney
                                    WHERE MILO_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                                   )
        , tmpUnit_Currency AS (SELECT MILO_Unit.MovementItemId
                                    , MILO_Unit.ObjectId 
                               FROM tmpMovementItemLinkObject_сurr AS MILO_Unit
                               WHERE MILO_Unit.DescId = zc_MILinkObject_Unit()
                              )
        , tmpContract_Currency AS (SELECT MILO_Contract.MovementItemId
                                        , MILO_Contract.ObjectId 
                                   FROM tmpMovementItemLinkObject_сurr AS MILO_Contract
                                   WHERE MILO_Contract.DescId = zc_MILinkObject_Contract()
                                  )
        , tmpComment_Currency AS (SELECT MIString_Comment.MovementItemId
                                       , COALESCE (MIString_Comment.ValueData, '') AS ValueData
                                  FROM MovementItemString AS MIString_Comment
                                  WHERE MIString_Comment.DescId = zc_MIString_Comment()
                                    AND MIString_Comment.MovementItemId IN (SELECT DISTINCT tmpContainerCurrency.MovementItemId FROM tmpContainerCurrency)
                                 ) 

        , tmpMIContainer AS (SELECT *
                             FROM MovementItemContainer
                             WHERE MovementItemContainer.Containerid IN (SELECT DISTINCT tmpContainer.ContainerId FROM tmpContainer)
                               AND MovementItemContainer.OperDate >= inStartDate
                             )

        , Operation_all AS (-- нач. остаток  в валюте баланса
                            SELECT tmpContainer.ContainerId
                                 , tmpContainer.ObjectId
                                 , tmpContainer.CashId
                                 , tmpContainer.CurrencyId
                                 , tmpContainer.BranchId
                                 , 0                         AS InfoMoneyId
                                 , 0                         AS UnitId
                                 , 0                         AS MoneyPlaceId
                                 , 0                         AS ContractId
                                 , tmpContainer.Amount - COALESCE(SUM (MIContainer.Amount), 0) AS StartAmount
                                 , 0                         AS EndAmount
                                 , 0                         AS DebetSumm
                                 , 0                         AS KreditSumm
                                 , 0                         AS DebetSumm_Currency
                                 , 0                         AS KreditSumm_Currency
                                 , 0                         AS Summ_Currency
                                 , 0                         AS Summ_Currency_pl
                                 , NULL :: Boolean           AS isActive
                                 , inStartDate :: TDatetime AS OperDate
                                 , 1                         AS NomStr
                                 , '1. Нач. сальдо'          AS InfoText
                                 , 0                         AS MovementDescId
                            FROM tmpContainer
                                 LEFT JOIN tmpMIContainer AS MIContainer 
                                                          ON MIContainer.Containerid = tmpContainer.ContainerId
                                                         AND MIContainer.OperDate >= inStartDate
                            GROUP BY tmpContainer.ContainerId, tmpContainer.ObjectId, tmpContainer.CashId, tmpContainer.Amount, tmpContainer.CurrencyId, tmpContainer.BranchId
                 
                            UNION ALL
                           -- конечн. остаток  в валюте баланса
                            SELECT tmpContainer.ContainerId
                                 , tmpContainer.ObjectId
                                 , tmpContainer.CashId
                                 , tmpContainer.CurrencyId
                                 , tmpContainer.BranchId
                                 , 0                         AS InfoMoneyId
                                 , 0                         AS UnitId
                                 , 0                         AS MoneyPlaceId
                                 , 0                         AS ContractId
                                 , 0                         AS StartAmount
                                 , tmpContainer.Amount - SUM (COALESCE (MIContainer.Amount, 0))  AS EndAmount
                                 , 0                         AS DebetSumm
                                 , 0                         AS KreditSumm

                                 , 0                         AS DebetSumm_Currency
                                 , 0                         AS KreditSumm_Currency
                                 , 0                         AS Summ_Currency
                                 , 0                         AS Summ_Currency_pl
                                 , NULL :: Boolean           AS isActive
                                 , inEndDate :: TDatetime AS OperDate
                                 , 3                         AS NomStr
                                 , '3. Конечн. сальдо'       AS InfoText
                                 , 0                         AS MovementDescId
                            FROM tmpContainer
                                 LEFT JOIN tmpMIContainer AS MIContainer
                                                          ON MIContainer.Containerid = tmpContainer.ContainerId
                                                         AND MIContainer.OperDate > inEndDate
                            GROUP BY tmpContainer.ContainerId, tmpContainer.ObjectId, tmpContainer.CashId, tmpContainer.Amount, tmpContainer.CurrencyId, tmpContainer.BranchId
                 
                            UNION ALL
                            -- движение в валюте баланса
                            SELECT tmpContainer.ContainerId                  AS ContainerId
                                 , tmpContainer.ObjectId                     AS ObjectId
                                 , tmpContainer.CashId                       AS CashId
                                 , tmpContainer.CurrencyId                   AS CurrencyId
                                 , tmpContainer.BranchId
                                 , MILO_InfoMoney.ObjectId                   AS InfoMoneyId
                                 , MILO_Unit.ObjectId                        AS UnitId
                                 , MILO_MoneyPlace.ObjectId                  AS MoneyPlaceId
                                 , MILO_Contract.ObjectId                    AS ContractId
                                 , 0 :: TFloat                               AS StartAmount
                                 , 0 :: TFloat                               AS EndAmount
                                 , SUM (tmpContainer.DebetSumm)              AS DebetSumm
                                 , SUM (tmpContainer.KreditSumm)             AS KreditSumm
                                 , 0                                         AS DebetSumm_Currency
                                 , 0                                         AS KreditSumm_Currency
                                 , SUM (tmpContainer.Summ_Currency)          AS Summ_Currency
                                 , SUM (tmpContainer.Summ_Currency_pl)       AS Summ_Currency_pl
                                 , tmpContainer.isActive                     AS isActive
                                 , tmpContainer.OperDate                     AS OperDate

                                 , 2 AS NomStr
                                 , '2. Обороты' AS InfoText
                                 , tmpContainer.MovementDescId
                            FROM tmpContainerBalance AS tmpContainer
                                   LEFT JOIN tmpMoneyPlace_Balance AS MILO_MoneyPlace  ON MILO_MoneyPlace.MovementItemId  = tmpContainer.MovementItemId
                                   LEFT JOIN tmpContract_Balance   AS MILO_Contract    ON MILO_Contract.MovementItemId    = tmpContainer.MovementItemId
                                   LEFT JOIN tmpUnit_Balance       AS MILO_Unit        ON MILO_Unit.MovementItemId        = tmpContainer.MovementItemId
                                   LEFT JOIN tmpInfoMoney_Balance  AS MILO_InfoMoney   ON MILO_InfoMoney.MovementItemId   = tmpContainer.MovementItemId
                            GROUP BY tmpContainer.ContainerId,
                                     tmpContainer.ObjectId, tmpContainer.CashId, tmpContainer.CurrencyId, tmpContainer.isActive,
                                     MILO_InfoMoney.ObjectId, 
                                     MILO_Unit.ObjectId,
                                     MILO_MoneyPlace.ObjectId, 
                                     MILO_Contract.ObjectId,
                                     tmpContainer.OperDate,
                                     tmpContainer.BranchId,
                                     tmpContainer.MovementDescId
                            UNION ALL
                            -- движение  в валюте операции
                            SELECT 0                                         AS ContainerId
                                 , tmpContainer.ObjectId                     AS ObjectId
                                 , tmpContainer.CashId                       AS CashId
                                 , tmpContainer.CurrencyId                   AS CurrencyId
                                 , tmpContainer.BranchId
                                 , MILO_InfoMoney.ObjectId                   AS InfoMoneyId
                                 , MILO_Unit.ObjectId                        AS UnitId
                                 , MILO_MoneyPlace.ObjectId                  AS MoneyPlaceId
                                 , MILO_Contract.ObjectId                    AS ContractId
                                 , 0 :: TFloat                               AS StartAmount
                                 , 0 :: TFloat                               AS EndAmount
                                 , 0                                         AS DebetSumm
                                 , 0                                         AS KreditSumm
                                 , SUM (tmpContainer.DebetSumm_Currency)     AS DebetSumm_Currency
                                 , SUM (tmpContainer.KreditSumm_Currency)    AS KreditSumm_Currency
                                 , 0                                         AS Summ_Currency
                                 , 0                                         AS Summ_Currency_pl
                                 , tmpContainer.isActive                     AS isActive
                                 , tmpContainer.OperDate                     AS OperDate

                                 , 2                         AS NomStr
                                 , '2. Обороты'              AS InfoText
                                 , 0                         AS MovementDescId
                            FROM tmpContainerCurrency AS tmpContainer
                                   LEFT JOIN tmpMoneyPlace_Currency AS MILO_MoneyPlace  ON MILO_MoneyPlace.MovementItemId  = tmpContainer.MovementItemId
                                   LEFT JOIN tmpContract_Currency   AS MILO_Contract    ON MILO_Contract.MovementItemId    = tmpContainer.MovementItemId
                                   LEFT JOIN tmpUnit_Currency       AS MILO_Unit        ON MILO_Unit.MovementItemId        = tmpContainer.MovementItemId
                                   LEFT JOIN tmpInfoMoney_Currency  AS MILO_InfoMoney   ON MILO_InfoMoney.MovementItemId   = tmpContainer.MovementItemId
                            GROUP BY tmpContainer.ObjectId, tmpContainer.CashId, tmpContainer.CurrencyId, tmpContainer.isActive,
                                     MILO_InfoMoney.ObjectId,
                                     MILO_Unit.ObjectId, 
                                     MILO_MoneyPlace.ObjectId, 
                                     MILO_Contract.ObjectId,
                                     tmpContainer.OperDate,
                                     tmpContainer.BranchId
                            )

      , tmpOperation_11 AS (SELECT Operation_all.ContainerId, Operation_all.ObjectId, Operation_all.CashId, Operation_all.InfoMoneyId, Operation_all.CurrencyId, Operation_all.BranchId
                                    , Operation_all.UnitId, Operation_all.MoneyPlaceId, Operation_all.ContractId
                                    , Operation_all.OperDate
                                    , Operation_all.NomStr
                                    , Operation_all.InfoText
                                    , Operation_all.MovementDescId
                                    , SUM (Operation_all.DebetSumm)   AS DebetSumm
                                    , SUM (Operation_all.KreditSumm)  AS KreditSumm
                                    , SUM (Operation_all.DebetSumm_Currency)   AS DebetSumm_Currency
                                    , SUM (Operation_all.KreditSumm_Currency)  AS KreditSumm_Currency
                                    , SUM (Operation_all.Summ_Currency)        AS Summ_Currency
                                    , SUM (Operation_all.Summ_Currency_pl)     AS Summ_Currency_pl
                                    , SUM (Operation_all.StartAmount)          AS StartAmount
                                    , SUM (Operation_all.EndAmount)            AS EndAmount
                              FROM Operation_all
                              GROUP BY Operation_all.ContainerId, Operation_all.ObjectId, Operation_all.CashId, Operation_all.CurrencyId, Operation_all.BranchId
                                     , Operation_all.InfoMoneyId, Operation_all.UnitId, Operation_all.MoneyPlaceId, Operation_all.ContractId
                                     , Operation_all.isActive, Operation_all.OperDate
                                     , Operation_all.NomStr
                                     , Operation_all.InfoText
                                     , Operation_all.MovementDescId
                              HAVING SUM (Operation_all.DebetSumm) <> 0
                                  OR SUM (Operation_all.KreditSumm) <> 0
                                  OR SUM (Operation_all.DebetSumm_Currency) <> 0
                                  OR SUM (Operation_all.KreditSumm_Currency) <> 0
                                  OR SUM (Operation_all.StartAmount)          <> 0
                                  OR SUM (Operation_all.EndAmount)            <> 0
                             )
        -- считаем нач.сальдо для всех дат
      , tmpOperation_Group AS (SELECT Operation_all.ContainerId, Operation_all.ObjectId, Operation_all.CashId, Operation_all.CurrencyId, Operation_all.BranchId
                                    , Operation_all.OperDate
                                    , SUM (Operation_all.DebetSumm)   AS DebetSumm
                                    , SUM (Operation_all.KreditSumm)  AS KreditSumm
               
                                    , SUM (Operation_all.StartAmount) AS StartAmount
                                    , SUM (Operation_all.EndAmount)   AS EndAmount
                              FROM tmpOperation_11 AS Operation_all
                              GROUP BY Operation_all.ContainerId, Operation_all.ObjectId, Operation_all.CashId, Operation_all.CurrencyId, Operation_all.OperDate, Operation_all.BranchId
                             )
      --
      , tmpCalc AS (--расчет накоп. нач. остатка
                    SELECT tmp.ContainerId, tmp.ObjectId, tmp.CashId, tmp.CurrencyId, tmp.OperDate, tmp.BranchId
                         , SUM (StartAmount_calc) AS Amount_calc
                         , 1                      AS NomStr
                         , '1. Нач. сальдо'  ::tvarchar AS InfoText
                    FROM (
                         SELECT ttt1.StartAmount + ttt1.DebetSumm - ttt1.KreditSumm AS StartAmount_calc
                              , ttt.*
                         FROM tmpOperation_Group AS ttt
                         LEFT JOIN tmpOperation_Group AS ttt1 ON ttt1.ContainerId = ttt.ContainerId
                         and ttt1.OperDate < ttt.OperDate
                         ) AS tmp
                    GROUP BY tmp.ContainerId, tmp.ObjectId, tmp.CashId, tmp.CurrencyId, tmp.OperDate, tmp.BranchId
                    HAVING SUM (StartAmount_calc) <> 0
                   UNION
                   --расчет накоп. конечн. остатка
                    SELECT tmp.ContainerId, tmp.ObjectId, tmp.CashId, tmp.CurrencyId, tmp.OperDate, tmp.BranchId
                         , SUM (EndAmount_calc) AS Amount_calc
                         , 3                    AS NomStr
                         , '3. Конечн. сальдо'  ::tvarchar AS InfoText
                    FROM (
                         SELECT ttt1.EndAmount - ttt1.DebetSumm + ttt1.KreditSumm AS EndAmount_calc
                              , ttt.*
                         FROM tmpOperation_Group AS ttt
                         LEFT JOIN tmpOperation_Group AS ttt1 ON ttt1.ContainerId = ttt.ContainerId
                         and ttt1.OperDate > ttt.OperDate
                         ) AS tmp
                    GROUP BY tmp.ContainerId, tmp.ObjectId, tmp.CashId, tmp.CurrencyId, tmp.OperDate, tmp.BranchId
                    HAVING SUM (EndAmount_calc) <> 0 
                    )

      , tmpOperation_1 AS (SELECT Operation_all.ContainerId, Operation_all.ObjectId, Operation_all.CashId, Operation_all.InfoMoneyId, Operation_all.CurrencyId, Operation_all.BranchId
                                    , Operation_all.UnitId, Operation_all.MoneyPlaceId, Operation_all.ContractId
                                    , Operation_all.OperDate
                                    , Operation_all.NomStr
                                    , Operation_all.InfoText
                                    , Operation_all.MovementDescId
                                    , Operation_all.DebetSumm   AS DebetSumm
                                    , Operation_all.KreditSumm  AS KreditSumm
                                    , Operation_all.DebetSumm_Currency   AS DebetSumm_Currency
                                    , Operation_all.KreditSumm_Currency  AS KreditSumm_Currency
                                    , Operation_all.Summ_Currency        AS Summ_Currency
                                    , Operation_all.Summ_Currency_pl     AS Summ_Currency_pl
                                    , Operation_all.StartAmount          AS StartAmount
                                    , Operation_all.EndAmount            AS EndAmount
                           FROM tmpOperation_11 AS Operation_all
                          UNION 
                           SELECT tmpCalc.ContainerId, tmpCalc.ObjectId, tmpCalc.CashId, tmpCalc.BranchId
                                , 0 AS InfoMoneyId
                                , tmpCalc.CurrencyId
                                , 0 as UnitId, 0 AS MoneyPlaceId, 0 AS ContractId
                                , tmpCalc.OperDate
                                , tmpCalc.NomStr
                                , tmpCalc.InfoText
                                , 0  AS MovementDescId
                                , 0  AS DebetSumm
                                , 0  AS KreditSumm
                                , 0  AS DebetSumm_Currency
                                , 0  AS KreditSumm_Currency
                                , 0  AS Summ_Currency
                                , 0  AS Summ_Currency_pl
                                , CASE WHEN tmpCalc.NomStr = 1 THEN tmpCalc.Amount_calc ELSE 0 END AS StartAmount
                                , CASE WHEN tmpCalc.NomStr = 3 THEN tmpCalc.Amount_calc ELSE 0 END AS EndAmount
                           FROM tmpCalc
                           )
         
          -- --- данные по р.счету 
        , tmpAccount_2 AS (SELECT Object_Account_View.AccountId 
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
                            )

        , tmpContainer_2 AS (SELECT Container.Id                            AS ContainerId
                                  , Container_Currency.Id                   AS ContainerId_Currency
                                  , Container.ObjectId                      AS AccountId
                                  , COALESCE (CLO_BankAccount.ObjectId, CLO_Juridical.ObjectId) AS BankAccountId
                                  , COALESCE (CLO_Currency.ObjectId, 0)     AS CurrencyId
                                  , COALESCE (CLO_Branch.ObjectId, 0)       AS BranchId
                                  , Container.Amount                        AS Amount
                                  , COALESCE (Container_Currency.Amount, 0) AS Amount_Currency
                             FROM tmpAccount_2 AS tmpAccount
                                  INNER JOIN Container ON Container.ObjectId = tmpAccount.AccountId AND Container.DescId = zc_Container_Summ()
                                  
                                  LEFT JOIN ContainerLinkObject AS CLO_BankAccount ON CLO_BankAccount.ContainerId = Container.Id AND CLO_BankAccount.DescId = zc_ContainerLinkObject_BankAccount()
                                  LEFT JOIN ContainerLinkObject AS CLO_Juridical ON CLO_Juridical.ContainerId = Container.Id AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                  
                                  INNER JOIN tmpBankAccount ON tmpBankAccount.Id = COALESCE (CLO_BankAccount.ObjectId, CLO_Juridical.ObjectId) -- ограничиваем по гл. юр.лицу
                                  
                                  LEFT JOIN ContainerLinkObject AS CLO_Currency ON CLO_Currency.ContainerId = Container.Id AND CLO_Currency.DescId = zc_ContainerLinkObject_Currency()
                                  LEFT JOIN ContainerLinkObject AS CLO_Branch ON CLO_Branch.ContainerId = Container.Id AND CLO_Branch.DescId = zc_ContainerLinkObject_Branch()
                                  LEFT JOIN Container AS Container_Currency ON Container_Currency.ParentId = Container.Id AND Container_Currency.DescId = zc_Container_SummCurrency()
  
                             WHERE (CLO_BankAccount.ContainerId IS NOT NULL OR CLO_Juridical.ContainerId IS NOT NULL)
                              AND (Container.ObjectId = inAccountId OR inAccountId = 0)
                              AND (CLO_BankAccount.ObjectId = inBankAccountId OR inBankAccountId = 0)
                              AND (CLO_Currency.ObjectId = inCurrencyId OR inCurrencyId = 0 OR inCurrencyId = zc_Enum_Currency_Basis())
                              AND (COALESCE (CLO_BankAccount.ObjectId, CLO_Juridical.ObjectId) IN (SELECT DISTINCT tmpBankAccount.Id FROM tmpBankAccount)) -- ограничиваем по гл. юр.лицу)
                            )

        , tmpMIContainer_2 AS (SELECT *
                               FROM MovementItemContainer
                               WHERE MovementItemContainer.Containerid IN (SELECT DISTINCT tmpContainer_2.ContainerId FROM tmpContainer_2)
                                 AND MovementItemContainer.OperDate >= inStartDate
                               )

        , Operation_all_2 AS (
                           -- 1.1. нач. остаток в валюте баланса
                            SELECT tmpContainer.ContainerId
                                 , tmpContainer.AccountId
                                 , tmpContainer.BankAccountId
                                 , tmpContainer.CurrencyId
                                 , tmpContainer.BranchId
                                 , 0                         AS InfoMoneyId
                                 , 0                         AS MoneyPlaceId
                                 , 0                         AS ContractId
                                 , 0                         AS UnitId
                                 , tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS StartAmount
                                 , 0                         AS EndAmount
                                 , 0                         AS DebetSumm
                                 , 0                         AS KreditSumm
                                 , 0                         AS DebetSumm_Currency
                                 , 0                         AS KreditSumm_Currency
                                 , 0                         AS Summ_Currency
                                 , 0                         AS Summ_pl
                                 , inStartDate :: TDatetime AS OperDate
                                 , 1                         AS NomStr
                                 , '1. Нач. сальдо'          AS InfoText
                                 , 0                         AS MovementDescId
                            FROM tmpContainer_2 AS tmpContainer
                                 LEFT JOIN tmpMIContainer_2 AS MIContainer
                                                            ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                           AND MIContainer.OperDate >= inStartDate
                            GROUP BY tmpContainer.ContainerId , tmpContainer.AccountId, tmpContainer.BankAccountId, tmpContainer.CurrencyId, tmpContainer.Amount, tmpContainer.BranchId
                           UNION ALL
                           -- 1.1. конечн. остаток в валюте баланса
                            SELECT tmpContainer.ContainerId
                                 , tmpContainer.AccountId
                                 , tmpContainer.BankAccountId
                                 , tmpContainer.CurrencyId
                                 , tmpContainer.BranchId
                                 , 0                         AS InfoMoneyId
                                 , 0                         AS MoneyPlaceId
                                 , 0                         AS ContractId
                                 , 0                         AS UnitId
                                 , 0                         AS StartAmount
                                 , tmpContainer.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS EndAmount
                                 , 0                         AS DebetSumm
                                 , 0                         AS KreditSumm
                                 , 0                         AS DebetSumm_Currency
                                 , 0                         AS KreditSumm_Currency
                                 , 0                         AS Summ_Currency
                                 , 0                         AS Summ_pl
                                 , inEndDate :: TDatetime AS OperDate
                                 , 3                         AS NomStr
                                 , '3. Конечн. сальдо'       AS InfoText
                                 , 0                         AS MovementDescId
                            FROM tmpContainer_2 AS tmpContainer
                                 LEFT JOIN tmpMIContainer_2 AS MIContainer
                                                            ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                           AND MIContainer.OperDate >= inStartDate
                            GROUP BY tmpContainer.ContainerId , tmpContainer.AccountId, tmpContainer.BankAccountId, tmpContainer.CurrencyId, tmpContainer.Amount, tmpContainer.BranchId
                           UNION ALL
                             -- 2.1. движение в валюте баланса
                            SELECT tmpContainer.ContainerId
                                 , tmpContainer.AccountId
                                 , tmpContainer.BankAccountId
                                 , tmpContainer.CurrencyId
                                 , tmpContainer.BranchId
                                 , COALESCE (MILO_InfoMoney.ObjectId, 0)   AS InfoMoneyId
                               --, COALESCE (MILO_MoneyPlace.ObjectId, CASE WHEN MIContainer.MovementDescId = zc_Movement_Currency() THEN zc_Enum_ProfitLoss_80103() ELSE 0 END)  AS MoneyPlaceId
                                 , COALESCE (MILO_MoneyPlace.ObjectId, CASE WHEN MIContainer.MovementDescId = zc_Movement_Currency() THEN zc_Enum_ProfitLoss_75103() ELSE 0 END)  AS MoneyPlaceId
                                 , COALESCE (MILO_Contract.ObjectId, 0)    AS ContractId
                                 , COALESCE (MILO_Unit.ObjectId, 0)        AS UnitId
                                 , 0                                       AS StartAmount
                                 , 0                                       AS EndAmount
                                   -- нужен OR ... т.к. для ОПиУ надо проводки разделить, и там будет другой знак
                                 , SUM (CASE WHEN (MIContainer.Amount > 0 OR (MIContainer.isActive = TRUE  AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ProfitLoss())) AND NOT (MIContainer.isActive = FALSE AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ProfitLoss()) THEN MIContainer.Amount ELSE 0 END)      AS DebetSumm
                                   -- нужен AND ... т.к. для ОПиУ надо проводки разделить, и там будет другой знак
                                 , SUM (CASE WHEN (MIContainer.Amount < 0 OR (MIContainer.isActive = FALSE AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ProfitLoss())) AND NOT (MIContainer.isActive = TRUE  AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ProfitLoss()) THEN -1 * MIContainer.Amount ELSE 0 END) AS KreditSumm
                                 , 0                         AS DebetSumm_Currency
                                 , 0                         AS KreditSumm_Currency
                                 , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Currency() THEN MIContainer.Amount ELSE 0 END) AS Summ_Currency
                                 , 0                         AS Summ_pl
                                 , MIContainer.OperDate :: TDatetime AS OperDate

                                 , 2 AS NomStr
                                 , '2. Обороты' AS InfoText
                                 , CASE WHEN MIContainer.MovementDescId = zc_Movement_Currency() THEN MIContainer.MovementDescId ELSE 0 END AS MovementDescId
                            FROM tmpContainer_2 AS tmpContainer
                                 INNER JOIN tmpMIContainer_2 AS MIContainer
                                                             ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                            AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                 LEFT JOIN MovementItemLinkObject AS MILO_MoneyPlace
                                                                  ON MILO_MoneyPlace.MovementItemId = MIContainer.MovementItemId
                                                                 AND MILO_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
                                 LEFT JOIN MovementItemLinkObject AS MILO_Contract
                                                                  ON MILO_Contract.MovementItemId = MIContainer.MovementItemId
                                                                 AND MILO_Contract.DescId = zc_MILinkObject_Contract()
                                 LEFT JOIN MovementItemLinkObject AS MILO_Unit
                                                                  ON MILO_Unit.MovementItemId = MIContainer.MovementItemId
                                                                 AND MILO_Unit.DescId = zc_MILinkObject_Unit()
                                 LEFT JOIN MovementItemLinkObject AS MILO_InfoMoney
                                                                  ON MILO_InfoMoney.MovementItemId = MIContainer.MovementItemId
                                                                 AND MILO_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                            GROUP BY tmpContainer.ContainerId, tmpContainer.AccountId, tmpContainer.BankAccountId, tmpContainer.CurrencyId
                                   , MILO_InfoMoney.ObjectId, MILO_MoneyPlace.ObjectId, MILO_Contract.ObjectId, MILO_Unit.ObjectId
                                   , MIContainer.MovementDescId
                                   , MIContainer.OperDate :: TDatetime
                                   , tmpContainer.BranchId
                                   , CASE WHEN MIContainer.MovementDescId = zc_Movement_Currency() THEN MIContainer.MovementDescId ELSE 0 END
                           UNION ALL
                            -- 2.2. движение в валюте операции
                            SELECT tmpContainer.ContainerId
                                 , tmpContainer.AccountId
                                 , tmpContainer.BankAccountId
                                 , tmpContainer.CurrencyId
                                 , tmpContainer.BranchId
                                 , COALESCE (MILO_InfoMoney.ObjectId, 0)   AS InfoMoneyId
                                 , COALESCE (MILO_MoneyPlace.ObjectId, 0)  AS MoneyPlaceId
                                 , COALESCE (MILO_Contract.ObjectId, 0)    AS ContractId
                                 , COALESCE (MILO_Unit.ObjectId, 0)        AS UnitId
                                 , 0                         AS StartAmount
                                 , 0                         AS EndAmount
                                 , 0                         AS DebetSumm
                                 , 0                         AS KreditSumm
                                 , SUM (CASE WHEN MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END)      AS DebetSumm_Currency
                                 , SUM (CASE WHEN MIContainer.Amount < 0 THEN -1 * MIContainer.Amount ELSE 0 END) AS KreditSumm_Currency
                                 , 0                         AS Summ_Currency
                                 , 0                         AS Summ_pl
                                 , MIContainer.OperDate :: TDatetime AS OperDate

                                 , 2            AS NomStr
                                 , '2. Обороты' AS InfoText
                                 , 0            AS MovementDescId
                            FROM tmpContainer_2 AS tmpContainer
                                 INNER JOIN tmpMIContainer_2 AS MIContainer
                                                             ON MIContainer.ContainerId = tmpContainer.ContainerId_Currency
                                                            AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                 LEFT JOIN MovementItemLinkObject AS MILO_MoneyPlace
                                                                  ON MILO_MoneyPlace.MovementItemId = MIContainer.MovementItemId
                                                                 AND MILO_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
                                 LEFT JOIN MovementItemLinkObject AS MILO_Contract
                                                                  ON MILO_Contract.MovementItemId = MIContainer.MovementItemId
                                                                 AND MILO_Contract.DescId = zc_MILinkObject_Contract()
                                 LEFT JOIN MovementItemLinkObject AS MILO_Unit
                                                                  ON MILO_Unit.MovementItemId = MIContainer.MovementItemId
                                                                 AND MILO_Unit.DescId = zc_MILinkObject_Unit()
                                 LEFT JOIN MovementItemLinkObject AS MILO_InfoMoney
                                                                  ON MILO_InfoMoney.MovementItemId = MIContainer.MovementItemId
                                                                 AND MILO_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                            WHERE tmpContainer.ContainerId_Currency > 0
                            GROUP BY tmpContainer.ContainerId , tmpContainer.AccountId, tmpContainer.BankAccountId, tmpContainer.CurrencyId
                                   , MILO_InfoMoney.ObjectId, MILO_MoneyPlace.ObjectId, MILO_Contract.ObjectId, MILO_Unit.ObjectId
                                   , MIContainer.OperDate
                                   , tmpContainer.BranchId
                           UNION ALL
                            -- 2.2. курсовая разница (!!!только не для ввода курса!!!)
                            SELECT tmpContainer.ContainerId
                                 , tmpContainer.AccountId
                                 , tmpContainer.BankAccountId
                                 , tmpContainer.CurrencyId
                                 , tmpContainer.BranchId
                                 , COALESCE (MILO_InfoMoney.ObjectId, 0)   AS InfoMoneyId
                                 , COALESCE (MILO_MoneyPlace.ObjectId, 0)  AS MoneyPlaceId
                                 , COALESCE (MILO_Contract.ObjectId, 0)    AS ContractId
                                 , COALESCE (MILO_Unit.ObjectId, 0)        AS UnitId
                                 , 0                         AS StartAmount
                                 , 0                         AS EndAmount
                                 , 0                         AS DebetSumm
                                 , 0                         AS KreditSumm
                                 , 0                         AS DebetSumm_Currency
                                 , 0                         AS KreditSumm_Currency
                                 , 0                         AS Summ_Currency
                                 , SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ProfitLoss() THEN MIContainer.Amount ELSE 0 END) AS Summ_pl
                                 , MIContainer.OperDate :: TDatetime AS OperDate

                                 , 2            AS NomStr
                                 , '2. Обороты' AS InfoText
                                 , 0            AS MovementDescId
                            FROM tmpContainer_2 AS tmpContainer
                                 INNER JOIN tmpMIContainer_2 AS MIContainer 
                                                             ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                            AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                            AND MIContainer.MovementDescId <> zc_Movement_Currency()
                                                            AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ProfitLoss() -- то что относится к ОПиУ, кроме проводок с товарами
                                 LEFT JOIN MovementItemLinkObject AS MILO_MoneyPlace
                                                                  ON MILO_MoneyPlace.MovementItemId = MIContainer.MovementItemId
                                                                 AND MILO_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
                                 LEFT JOIN MovementItemLinkObject AS MILO_Contract
                                                                  ON MILO_Contract.MovementItemId = MIContainer.MovementItemId
                                                                 AND MILO_Contract.DescId = zc_MILinkObject_Contract()
                                 LEFT JOIN MovementItemLinkObject AS MILO_Unit
                                                                  ON MILO_Unit.MovementItemId = MIContainer.MovementItemId
                                                                 AND MILO_Unit.DescId = zc_MILinkObject_Unit()
                                 LEFT JOIN MovementItemLinkObject AS MILO_InfoMoney
                                                                  ON MILO_InfoMoney.MovementItemId = MIContainer.MovementItemId
                                                                 AND MILO_InfoMoney.DescId = zc_MILinkObject_InfoMoney()

                            GROUP BY tmpContainer.ContainerId, tmpContainer.AccountId, tmpContainer.BankAccountId, tmpContainer.CurrencyId
                                   , MILO_InfoMoney.ObjectId, MILO_MoneyPlace.ObjectId, MILO_Contract.ObjectId, MILO_Unit.ObjectId
                                   , MIContainer.OperDate
                                   , tmpContainer.BranchId
                           )

        , tmpOperation_22 AS  (SELECT Operation_all.ContainerId, Operation_all.AccountId, Operation_all.BankAccountId, Operation_all.CurrencyId, Operation_all.BranchId
                                , Operation_all.InfoMoneyId, Operation_all.MoneyPlaceId, Operation_all.ContractId, Operation_all.UnitId
                                , Operation_all.OperDate
                                , Operation_all.NomStr
                                , Operation_all.InfoText
                                , Operation_all.MovementDescId
                                , SUM (Operation_all.DebetSumm)            AS DebetSumm
                                , SUM (Operation_all.KreditSumm)           AS KreditSumm
                                , SUM (Operation_all.DebetSumm_Currency)   AS DebetSumm_Currency
                                , SUM (Operation_all.KreditSumm_Currency)  AS KreditSumm_Currency
                                , SUM (Operation_all.Summ_Currency)        AS Summ_Currency
                                , SUM (Operation_all.Summ_pl)              AS Summ_Currency_pl
                                , SUM (Operation_all.StartAmount)          AS StartAmount
                                , SUM (Operation_all.EndAmount)            AS EndAmount
                           FROM Operation_all_2 AS Operation_all
                           GROUP BY Operation_all.ContainerId, Operation_all.AccountId, Operation_all.BankAccountId, Operation_all.CurrencyId, Operation_all.BranchId
                                  , Operation_all.InfoMoneyId, Operation_all.MoneyPlaceId, Operation_all.ContractId, Operation_all.UnitId
                                  , Operation_all.OperDate
                                  , Operation_all.NomStr
                                  , Operation_all.InfoText
                                  , Operation_all.MovementDescId
                           HAVING SUM (Operation_all.DebetSumm)   <> 0
                               OR SUM (Operation_all.KreditSumm)  <> 0
                               OR SUM (Operation_all.DebetSumm_Currency)   <> 0
                               OR SUM (Operation_all.KreditSumm_Currency)  <> 0
                               OR SUM (Operation_all.Summ_Currency)        <> 0
                               OR SUM (Operation_all.Summ_pl)              <> 0
                               OR SUM (Operation_all.StartAmount)          <> 0
                               OR SUM (Operation_all.EndAmount)            <> 0
                          ) 

      -- считаем нач.сальдо для всех дат
      , tmpOperation_Group2 AS (SELECT Operation_all.ContainerId, Operation_all.AccountId, Operation_all.BankAccountId, Operation_all.CurrencyId, Operation_all.BranchId
                                    , Operation_all.OperDate
                                    , SUM (Operation_all.DebetSumm)   AS DebetSumm
                                    , SUM (Operation_all.KreditSumm)  AS KreditSumm
               
                                    , SUM (Operation_all.StartAmount) AS StartAmount
                                    , SUM (Operation_all.EndAmount)   AS EndAmount
                              FROM tmpOperation_22 AS Operation_all
                              GROUP BY Operation_all.ContainerId, Operation_all.AccountId, Operation_all.BankAccountId, Operation_all.CurrencyId, Operation_all.OperDate, Operation_all.BranchId
                             )
      --
      , tmpCalc2 AS (SELECT tmp.ContainerId, tmp.AccountId, tmp.BankAccountId, tmp.CurrencyId, tmp.OperDate, tmp.BranchId
                          , SUM (StartAmount_calc) AS Amount_calc
                          , 1                      AS NomStr
                          , '1. Нач. сальдо'  ::tvarchar AS InfoText
                    FROM (
                         SELECT ttt1.StartAmount + ttt1.DebetSumm - ttt1.KreditSumm AS StartAmount_calc
                              , ttt.*
                         FROM tmpOperation_Group2 AS ttt
                         LEFT JOIN tmpOperation_Group2 AS ttt1 
                                                       ON ttt1.ContainerId = ttt.ContainerId
                                                      AND ttt1.OperDate < ttt.OperDate
                         ) AS tmp
                    GROUP BY tmp.ContainerId, tmp.AccountId, tmp.BankAccountId, tmp.CurrencyId, tmp.OperDate, tmp.BranchId
                    HAVING SUM (StartAmount_calc) <> 0
                   UNION
                   --расчет накоп. конечн. остатка
                    SELECT tmp.ContainerId, tmp.AccountId, tmp.BankAccountId, tmp.CurrencyId, tmp.OperDate, tmp.BranchId
                         , SUM (EndAmount_calc) AS Amount_calc
                         , 3                    AS NomStr
                         , '3. Конечн. сальдо'  ::tvarchar AS InfoText
                    FROM (
                         SELECT ttt1.EndAmount - ttt1.DebetSumm + ttt1.KreditSumm AS EndAmount_calc
                              , ttt.*
                         FROM tmpOperation_Group2 AS ttt
                         LEFT JOIN tmpOperation_Group2 AS ttt1 
                                                      ON ttt1.ContainerId = ttt.ContainerId
                                                     AND ttt1.OperDate > ttt.OperDate
                         ) AS tmp
                    GROUP BY tmp.ContainerId, tmp.AccountId, tmp.BankAccountId, tmp.CurrencyId, tmp.OperDate, tmp.BranchId
                    HAVING SUM (EndAmount_calc) <> 0 
                    )

      , tmpOperation_2 AS (SELECT Operation_all.ContainerId, Operation_all.AccountId, Operation_all.BankAccountId, Operation_all.InfoMoneyId, Operation_all.CurrencyId, Operation_all.BranchId
                                    , Operation_all.UnitId, Operation_all.MoneyPlaceId, Operation_all.ContractId
                                    , Operation_all.OperDate
                                    , Operation_all.NomStr
                                    , Operation_all.InfoText
                                    , Operation_all.MovementDescId
                                    , Operation_all.DebetSumm   AS DebetSumm
                                    , Operation_all.KreditSumm  AS KreditSumm
                                    , Operation_all.DebetSumm_Currency   AS DebetSumm_Currency
                                    , Operation_all.KreditSumm_Currency  AS KreditSumm_Currency
                                    , Operation_all.Summ_Currency        AS Summ_Currency
                                    , Operation_all.Summ_Currency_pl     AS Summ_Currency_pl
                                    , Operation_all.StartAmount          AS StartAmount
                                    , Operation_all.EndAmount            AS EndAmount
                           FROM tmpOperation_22 AS Operation_all
                          UNION 
                           SELECT tmpCalc.ContainerId, tmpCalc.AccountId, tmpCalc.BankAccountId
                                , 0 AS InfoMoneyId
                                , tmpCalc.CurrencyId
                                , tmpCalc.BranchId
                                , 0 as UnitId, 0 AS MoneyPlaceId, 0 AS ContractId
                                , tmpCalc.OperDate
                                , tmpCalc.NomStr
                                , tmpCalc.InfoText
                                , 0  AS MovementDescId
                                , 0  AS DebetSumm
                                , 0  AS KreditSumm
                                , 0  AS DebetSumm_Currency
                                , 0  AS KreditSumm_Currency
                                , 0  AS Summ_Currency
                                , 0  AS Summ_Currency_pl
                                , CASE WHEN tmpCalc.NomStr = 1 THEN tmpCalc.Amount_calc ELSE 0 END AS StartAmount
                                , CASE WHEN tmpCalc.NomStr = 3 THEN tmpCalc.Amount_calc ELSE 0 END AS EndAmount
                           FROM tmpCalc2 AS tmpCalc
                           )

   ---
         , tmpOperation AS (--результат касса
                            SELECT Operation.ContainerId, Operation.ObjectId AS AccountId, Operation.CashId, Operation.InfoMoneyId, Operation.CurrencyId, Operation.BranchId
                                  , Operation.UnitId, Operation.MoneyPlaceId, Operation.ContractId
                                  , Operation.OperDate
                                  , EXTRACT (MONTH FROM Operation.OperDate)  ::Integer AS MonthNum
                                  , Operation.DebetSumm
                                  , Operation.KreditSumm
                                  , Operation.DebetSumm_Currency
                                  , Operation.KreditSumm_Currency
                                  , Operation.Summ_Currency
                                  , Operation.Summ_Currency_pl
                                  , Operation.StartAmount
                                  , Operation.EndAmount
                                  , CASE WHEN (Operation.NomStr=1) AND (Operation.OperDate = DATE_TRUNC ('MONTH', Operation.OperDate)) 
                                         THEN Operation.StartAmount 
                                         ELSE 0 
                                    END AS StartAmount_Month

                                  , CASE WHEN (Operation.NomStr=3) AND (Operation.OperDate = DATE_TRUNC ('MONTH', Operation.OperDate)+ interval '1 Month' - interval '1 Day') 
                                         THEN Operation.EndAmount 
                                         ELSE 0 
                                    END AS EndAmount_Month
                                  , 'касса' :: TVarChar AS Type_info
                                  , Operation.NomStr
                                  , Operation.InfoText
                                  , Operation.MovementDescId
                            FROM tmpOperation_1 AS Operation
                           UNION
                            -- результат р.счет
                            SELECT Operation.ContainerId, Operation.AccountId, Operation.BankAccountId AS CashId, Operation.InfoMoneyId, Operation.CurrencyId, Operation.BranchId
                                  , Operation.UnitId, Operation.MoneyPlaceId, Operation.ContractId
                                  , Operation.OperDate
                                  , EXTRACT (MONTH FROM Operation.OperDate)  ::Integer AS MonthNum
                                  , Operation.DebetSumm
                                  , Operation.KreditSumm
                                  , Operation.DebetSumm_Currency
                                  , Operation.KreditSumm_Currency
                                  , Operation.Summ_Currency
                                  , Operation.Summ_Currency_pl
                                  , Operation.StartAmount
                                  , Operation.EndAmount
                                  , CASE WHEN (Operation.NomStr=1) AND (Operation.OperDate = DATE_TRUNC ('MONTH', Operation.OperDate)) 
                                         THEN Operation.StartAmount 
                                         ELSE 0 
                                    END AS StartAmount_Month
                                  , CASE WHEN (Operation.NomStr=3) AND (Operation.OperDate = DATE_TRUNC ('MONTH', Operation.OperDate) + interval '1 Month' - interval '1 Day') 
                                         THEN Operation.EndAmount 
                                         ELSE 0 
                                    END AS EndAmount_Month
                                  , 'р.счет' :: TVarChar AS Type_info
                                  , Operation.NomStr
                                  , Operation.InfoText
                                  , Operation.MovementDescId
                            FROM tmpOperation_2 AS Operation
                            )

    -- пронумеруем месяца, для печати берем первые 2 месяца
    , tmpMonth AS (SELECT DISTINCT tmp.MonthNum, tmp.MonthName
                        , ROW_NUMBER() OVER (ORDER BY tmp.MonthNum)  ::Integer AS Ord
                   FROM (SELECT DISTINCT tmpOperation.MonthNum, zfCalc_MonthName (tmpOperation.OperDate) AS MonthName FROM tmpOperation) AS tmp
                   )
    -- все статьи ДДС
    , tmpCashFlow AS (SELECT Object.Id         AS Id 
                           , Object.ObjectCode AS Code
                           , Object.ValueData  AS Name
                          FROM Object
                          WHERE Object.DescId = zc_Object_CashFlow()
                            AND Object.isErased = FALSE
                       )
 
    -- связываем со статьями ДДС

    , tmp_DDC AS (SELECT Operation.ContainerId, Operation.AccountId, Operation.CashId, Operation.InfoMoneyId, Operation.CurrencyId, Operation.BranchId
                                , Operation.UnitId, Operation.MoneyPlaceId, Operation.ContractId
                                , Operation.OperDate
                                , Operation.MonthNum
                                , Operation.DebetSumm
                                , Operation.KreditSumm
                                , Operation.DebetSumm_Currency
                                , Operation.KreditSumm_Currency
                                , Operation.Summ_Currency
                                , Operation.Summ_Currency_pl
                                , Operation.StartAmount
                                , Operation.EndAmount
                                , Operation.StartAmount_Month
                                , Operation.EndAmount_Month
                                , Operation.Type_info
                                , Operation.NomStr
                                , Operation.InfoText
                                  -- для печати
                                , (SELECT tmpMonth.MonthName FROM tmpMonth WHERE tmpMonth.Ord = 1) :: TVarChar AS MonthName1
                                , (SELECT tmpMonth.MonthName FROM tmpMonth WHERE tmpMonth.Ord = 2) :: TVarChar AS MonthName2
                                  
                                , CASE WHEN Operation.MovementDescId = zc_Movement_Currency() THEN (SELECT Object.ObjectCode FROM Object WHERE Object.DescId = zc_Object_CashFlow() AND Object.ValueData ILIKE '%продажа вал%' LIMIT 1)
                                       WHEN COALESCE (Operation.DebetSumm,0) <> 0 THEN tmpInfoMoney.CashFlowCode_in
                                       WHEN COALESCE (Operation.KreditSumm,0) <> 0 THEN tmpInfoMoney.CashFlowCode_out
                                       WHEN COALESCE (Operation.StartAmount,0) <> 0 THEN 34050
                                       WHEN COALESCE (Operation.EndAmount,0) <> 0 THEN 34150
                                       ELSE NULL
                                  END  ::Integer   AS CashFlowCode
                          
                                , CASE WHEN Operation.MovementDescId = zc_Movement_Currency() THEN (SELECT Object.ValueData FROM Object WHERE Object.DescId = zc_Object_CashFlow() AND Object.ValueData ILIKE '%продажа вал%' LIMIT 1)
                                       WHEN COALESCE (Operation.DebetSumm,0) <> 0 THEN tmpInfoMoney.CashFlowName_in
                                       WHEN COALESCE (Operation.KreditSumm,0) <> 0 THEN tmpInfoMoney.CashFlowName_out
                                       WHEN COALESCE (Operation.StartAmount,0) <> 0 THEN 'Остаток денежных средств на начало периода' --'(34050) Остаток денежных средств на начало периода '
                                       WHEN COALESCE (Operation.EndAmount,0) <> 0 THEN 'Остаток денежных средств на конец периода'    --'(34150) Остаток денежных средств на конец периода'
                                       ELSE ''
                                  END  :: TVarChar AS CashFlowName
                          
                                , CASE WHEN tmpMonth.Ord = 1 THEN (COALESCE (Operation.DebetSumm,0)
                                                                 - COALESCE (Operation.KreditSumm,0)
                                                                 + COALESCE (Operation.StartAmount_Month,0)
                                                                 + COALESCE (Operation.EndAmount_Month,0))
                                       ELSE 0
                                  END  ::TFloat    AS Sum1_CashFlow
                          
                                , CASE WHEN tmpMonth.Ord = 2 THEN (COALESCE (Operation.DebetSumm,0)
                                                                 - COALESCE (Operation.KreditSumm,0)
                                                                 + COALESCE (Operation.StartAmount_Month,0)
                                                                 + COALESCE (Operation.EndAmount_Month,0))
                                       ELSE 0
                                  END  ::TFloat    AS Sum2_CashFlow
                          
                                  -- для итогов по группам
                                , CASE WHEN Operation.MovementDescId = zc_Movement_Currency()                                               THEN 3
                                       WHEN COALESCE (Operation.DebetSumm,0) <> 0  AND tmpInfoMoney.CashFlowCode_in  BETWEEN 3000 AND 3195  THEN 1
                                       WHEN COALESCE (Operation.KreditSumm,0) <> 0 AND tmpInfoMoney.CashFlowCode_out BETWEEN 3000 AND 3195  THEN 1
                                       WHEN COALESCE (Operation.DebetSumm,0) <> 0  AND tmpInfoMoney.CashFlowCode_in  BETWEEN 3200 AND 3295  THEN 2
                                       WHEN COALESCE (Operation.KreditSumm,0) <> 0 AND tmpInfoMoney.CashFlowCode_out BETWEEN 3200 AND 3295  THEN 2
                                       WHEN COALESCE (Operation.DebetSumm,0) <> 0  AND tmpInfoMoney.CashFlowCode_in  BETWEEN 3300 AND 33950 THEN 3
                                       WHEN COALESCE (Operation.KreditSumm,0) <> 0 AND tmpInfoMoney.CashFlowCode_out BETWEEN 3300 AND 33950 THEN 3
                                       WHEN COALESCE (Operation.StartAmount,0) <> 0 THEN 4
                                       WHEN COALESCE (Operation.EndAmount,0) <> 0 THEN 5
                                       ELSE 0
                                  END  ::Integer   AS PrintGroup
   
                           FROM tmpOperation AS Operation
                                LEFT JOIN tmpInfoMoney ON tmpInfoMoney.InfoMoneyId = Operation.InfoMoneyId
                                LEFT JOIN tmpMonth ON tmpMonth.MonthNum = Operation.MonthNum
                           )
    
        , tmpOperation_DDC AS (/*SELECT 0 AS ContainerId, 0 AS AccountId, 0 AS CashId, 0 AS InfoMoneyId, 0 AS CurrencyId, 0 AS BranchId
                                , 0 AS UnitId, 0 AS MoneyPlaceId, 0 AS ContractId
                                , inStartDate AS OperDate
                                , EXTRACT (MONTH FROM inStartDate)  ::Integer AS MonthNum
                                , 0 AS DebetSumm
                                , 0 AS KreditSumm
                                , 0 AS DebetSumm_Currency
                                , 0 AS KreditSumm_Currency
                                , 0 AS Summ_Currency
                                , 0 AS Summ_Currency_pl
                                , 0 AS StartAmount
                                , 0 AS EndAmount
                                , 0 AS StartAmount_Month
                                , 0 AS EndAmount_Month
                                , '' :: TVarChar AS Type_info
                                , 1 AS NomStr
                                , '1. Нач. сальдо'  ::tvarchar  AS InfoText
                                
                                , (SELECT tmpMonth.MonthName FROM tmpMonth WHERE tmpMonth.Ord = 1) :: TVarChar AS MonthName1
                                , (SELECT tmpMonth.MonthName FROM tmpMonth WHERE tmpMonth.Ord = 2) :: TVarChar AS MonthName2
                                , tmpCashFlow.Code AS CashFlowCode
                                , tmpCashFlow.Name AS CashFlowName
                                , 0 AS Sum1_CashFlow
                                , 0 AS Sum2_CashFlow
                                
                                  -- для итогов по группам
                                , CASE WHEN tmpCashFlow.Code BETWEEN 3000 AND 3195  THEN 3195
                                       WHEN tmpCashFlow.Code BETWEEN 3200 AND 3295  THEN 3295
                                       WHEN tmpCashFlow.Code BETWEEN 3300 AND 33950 THEN 3395
                                       WHEN tmpCashFlow.Code = 34050 THEN tmpCashFlow.Code
                                       WHEN tmpCashFlow.Code = 34150 THEN tmpCashFlow.Code
                                       ELSE NULL
                                  END  ::Integer   AS CashFlowGroupCode

                                , CASE WHEN tmpCashFlow.Code BETWEEN 3000 AND 3195  THEN 'Чистое движение денежных средств от операционной деятельности'
                                       WHEN tmpCashFlow.Code BETWEEN 3200 AND 3295  THEN 'Чистое движение денежных средств от инвестиционной деятельности'
                                       WHEN tmpCashFlow.Code BETWEEN 3300 AND 33950 THEN 'Чистое движение денежных средств от финансовой деятельности'
                                       WHEN tmpCashFlow.Code = 34050 THEN tmpCashFlow.Code
                                       WHEN tmpCashFlow.Code = 34150 THEN tmpCashFlow.Code
                                       ELSE ''
                                  END  ::TVarChar   AS CashFlowGroupName
                                  
                                , CASE WHEN tmpCashFlow.Code BETWEEN 3000 AND 3195  THEN 1
                                       WHEN tmpCashFlow.Code BETWEEN 3200 AND 3295  THEN 2
                                       WHEN tmpCashFlow.Code BETWEEN 3300 AND 33950 THEN 3
                                       ELSE 0
                                  END  ::Integer   AS PrintGroup
                           FROM tmpCashFlow
                          UNION*/
                          -- все данные
                           SELECT Operation.ContainerId, Operation.AccountId, Operation.CashId, Operation.InfoMoneyId, Operation.CurrencyId, Operation.BranchId
                                , Operation.UnitId, Operation.MoneyPlaceId, Operation.ContractId
                                , Operation.OperDate
                                , Operation.MonthNum
                                , Operation.DebetSumm
                                , Operation.KreditSumm
                                , Operation.DebetSumm_Currency
                                , Operation.KreditSumm_Currency
                                , Operation.Summ_Currency
                                , Operation.Summ_Currency_pl
                                , Operation.StartAmount
                                , Operation.EndAmount
                                , Operation.StartAmount_Month
                                , Operation.EndAmount_Month
                                , Operation.Type_info
                                , Operation.NomStr
                                , Operation.InfoText

                                , Operation.MonthName1
                                , Operation.MonthName2
                                , Operation.CashFlowCode
                                , Operation.CashFlowName
                                , Operation.Sum1_CashFlow
                                , Operation.Sum2_CashFlow

                                , CASE WHEN Operation.CashFlowCode BETWEEN 3000 AND 3195  THEN 3195
                                       WHEN Operation.CashFlowCode BETWEEN 3200 AND 3295  THEN 3295
                                       WHEN Operation.CashFlowCode BETWEEN 3300 AND 33950 THEN 3395
                                       WHEN Operation.CashFlowCode = 34050 THEN Operation.CashFlowCode
                                       WHEN Operation.CashFlowCode = 34150 THEN Operation.CashFlowCode
                                       ELSE NULL
                                  END  ::Integer   AS CashFlowGroupCode

                                , CASE WHEN Operation.CashFlowCode BETWEEN 3000 AND 3195  THEN 'Чистое движение денежных средств от операционной деятельности'
                                       WHEN Operation.CashFlowCode BETWEEN 3200 AND 3295  THEN 'Чистое движение денежных средств от инвестиционной деятельности'
                                       WHEN Operation.CashFlowCode BETWEEN 3300 AND 33950 THEN 'Чистое движение денежных средств от финансовой деятельности'
                                       WHEN Operation.CashFlowCode = 34050 THEN 'Начальный остаток'
                                       WHEN Operation.CashFlowCode = 34150 THEN 'Конечный остаток'
                                       ELSE ''
                                  END  ::TVarChar  AS CashFlowGroupName

                                , Operation.PrintGroup
                           FROM tmp_DDC AS Operation
                           )

     -- Результат
     SELECT
        Operation.ContainerId,
        Object_Cash.ObjectCode                                                                      AS CashCode,
        Object_Cash.ValueData                                                                       AS CashName,
        Object_Currency.ValueData                                                                   AS CurrencyName,
        CASE WHEN Operation.ContainerId > 0 THEN 1          WHEN Operation.DebetSumm > 0 THEN 2               WHEN Operation.KreditSumm > 0 THEN 3           ELSE -1 END :: Integer  AS GroupId,
        CASE WHEN Operation.ContainerId > 0 THEN '1.Сальдо' WHEN Operation.DebetSumm > 0 THEN '2.Поступления' WHEN Operation.KreditSumm > 0 THEN '3.Платежи' ELSE '' END :: TVarChar AS GroupName,
        Object_Branch.ValueData                                                                     AS BranchName,
        tmpInfoMoney.InfoMoneyGroupName           :: TVarChar                                       AS InfoMoneyGroupName,
        tmpInfoMoney.InfoMoneyDestinationName     :: TVarChar                                       AS InfoMoneyDestinationName,
        tmpInfoMoney.InfoMoneyCode                                                                  AS InfoMoneyCode,
        CASE WHEN COALESCE (Operation.InfoMoneyId, 0) = 0 AND (Operation.DebetSumm <> 0 OR Operation.KreditSumm <> 0 OR Operation.DebetSumm_Currency <> 0 OR Operation.KreditSumm_Currency <> 0) THEN 'Курсовая разница' ELSE tmpInfoMoney.InfoMoneyName     END :: TVarChar AS InfoMoneyName,
        CASE WHEN COALESCE (Operation.InfoMoneyId, 0) = 0 AND (Operation.DebetSumm <> 0 OR Operation.KreditSumm <> 0 OR Operation.DebetSumm_Currency <> 0 OR Operation.KreditSumm_Currency <> 0) THEN 'Курсовая разница' ELSE tmpInfoMoney.InfoMoneyName_all END :: TVarChar AS InfoMoneyName_all,
        tmpInfoMoney.CashFlowCode_in   :: Integer   AS CashFlowCode_in,
        ('(' || CAST (tmpInfoMoney.CashFlowCode_in AS TVarChar) || ') '|| tmpInfoMoney.CashFlowName_in)     :: TVarChar  AS CashFlowName_in,
        tmpInfoMoney.CashFlowCode_out  :: Integer   AS CashFlowCode_out,
        ('(' || CAST (tmpInfoMoney.CashFlowCode_out AS TVarChar) || ') '|| tmpInfoMoney.CashFlowName_out)   :: TVarChar  AS CashFlowName_out,
        tmpAccount.AccountName_all                                                                  AS AccountName,
        Object_Unit.ObjectCode                                                                      AS UnitCode,
        Object_Unit.ValueData                                                                       AS UnitName,
        tmpUnit_byProfitLoss.ProfitLossGroupCode,
        tmpUnit_byProfitLoss.ProfitLossGroupName,
        tmpUnit_byProfitLoss.ProfitLossDirectionCode,
        tmpUnit_byProfitLoss.ProfitLossDirectionName,
        Object_MoneyPlace.ObjectCode                                                                AS MoneyPlaceCode,
        Object_MoneyPlace.ValueData                                                                 AS MoneyPlaceName,
        ObjectDesc.ItemName                                                                         AS ItemName,
        tmpContract.ContractCode                                                                    AS ContractCode,
        tmpContract.InvNumber                                                                       AS ContractInvNumber,
        tmpContract.ContractTagName                                                                 AS ContractTagName,
        Operation.DebetSumm::TFloat                                                                 AS DebetSumm,
        Operation.KreditSumm::TFloat                                                                AS KreditSumm,

        Operation.DebetSumm_Currency                                                      ::TFloat  AS DebetSumm_Currency,
        Operation.KreditSumm_Currency                                                     ::TFloat  AS KreditSumm_Currency,

        Operation.Summ_Currency    :: TFloat,  
        Operation.Summ_Currency_pl :: TFloat,  

        Operation.StartAmount       ::TFloat                                                        AS StartAmount,
        Operation.StartAmount_Month ::TFloat                                                        AS StartAmount_Month,
        Operation.EndAmount         ::TFloat                                                        AS EndAmount,
        Operation.EndAmount_Month   ::TFloat                                                        AS EndAmount_Month,

        Operation.OperDate         :: TDateTime,
        
        (Operation.MonthNum||'. ' ||zfCalc_MonthName (Operation.OperDate))  ::TVarChar AS MonthName,
        Operation.MonthNum  ::Integer AS MonthNum,
        tmpMonth.ord        ::Integer AS OrdByPrint,
        EXTRACT (YEAR FROM Operation.OperDate) ::TVarChar AS Year,
        
        Operation.Type_info :: TVarChar,
        
        Operation.NomStr    :: Integer,
        Operation.InfoText  :: TVarChar,
        
        -- для печати
        Operation.MonthName1     :: TVarChar AS MonthName1,
        Operation.MonthName2     :: TVarChar AS MonthName2,
        Operation.CashFlowCode   ::Integer   AS CashFlowCode,
        --если статья ДДС пустая - подставляем Статью назначения
        Operation.CashFlowName   ::TVarChar  AS CashFlowName,
        
        Operation.Sum1_CashFlow  ::TFloat    AS Sum1_CashFlow,
        Operation.Sum2_CashFlow  ::TFloat    AS Sum2_CashFlow,
        -- для итогов по группам
        Operation.PrintGroup     ::Integer   AS PrintGroup,
        Operation.CashFlowGroupCode ::Integer,
        Operation.CashFlowGroupName ::TVarChar
     FROM tmpOperation_DDC AS Operation

         LEFT JOIN tmpAccount ON tmpAccount.AccountId = Operation.AccountId
         LEFT JOIN Object AS Object_Cash ON Object_Cash.Id = Operation.CashId
         LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = Operation.CurrencyId
         LEFT JOIN tmpInfoMoney ON tmpInfoMoney.InfoMoneyId = Operation.InfoMoneyId
         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Operation.UnitId
         LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = Operation.MoneyPlaceId
         LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_MoneyPlace.DescId
    
         LEFT JOIN tmpUnit_byProfitLoss ON tmpUnit_byProfitLoss.UnitId = Operation.UnitId
    
         LEFT JOIN ObjectLink AS ObjectLink_Cash_Branch
                              ON ObjectLink_Cash_Branch.ObjectId = Operation.CashId
                             AND ObjectLink_Cash_Branch.DescId = zc_ObjectLink_Cash_Branch()
         LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = COALESCE (ObjectLink_Cash_Branch.ChildObjectId, Operation.BranchId)
    
         LEFT JOIN tmpContract ON tmpContract.ContractId = Operation.ContractId
         LEFT JOIN tmpMonth ON tmpMonth.MonthNum = Operation.MonthNum
     ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.05.20         *
*/

-- тест
-- select * from gpReport_BankAccount_Cash_Olap(inStartDate := ('01.12.2021')::TDateTime , inEndDate := ('02.12.2021')::TDateTime , inAccountId := 0 , inCashId := 0 , inBankAccountId:=0, inCurrencyId := 0 , inSession := '5');
