-- Function: gpReport_Cash

DROP FUNCTION IF EXISTS gpReport_Cash_Olap (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Cash_Olap(
    IN inStartDate        TDateTime , --
    IN inEndDate          TDateTime , --
    IN inAccountId        Integer,    -- Счет
    IN inCashId           Integer,    --
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
             , OperDate TDateTime
             , MonthName TVarChar
             , Year      TVarChar
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
     WITH tmpUnit_byProfitLoss AS (SELECT * FROM lfSelect_Object_Unit_byProfitLossDirection ())
        , tmpContainer AS (SELECT Container.Id                            AS ContainerId
                                , Container_Currency.Id                   AS ContainerId_Currency
                                , Container.ObjectId                      AS ObjectId
                                , CLO_Cash.ObjectId                       AS CashId
                                , COALESCE (CLO_Currency.ObjectId, 0)     AS CurrencyId
                                , COALESCE (Container.Amount,0)           AS Amount
                                , COALESCE (Container_Currency.Amount, 0) AS Amount_Currency
                           FROM ContainerLinkObject AS CLO_Cash
                               INNER JOIN Container ON Container.Id = CLO_Cash.ContainerId AND Container.DescId = zc_Container_Summ()
                               LEFT JOIN ContainerLinkObject AS CLO_Currency ON CLO_Currency.ContainerId = Container.Id AND CLO_Currency.DescId = zc_ContainerLinkObject_Currency()
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
                                , '(' || CAST (Object_CashFlow_in.ObjectCode AS TVarChar) || ') '|| Object_CashFlow_in.ValueData AS CashFlowName_in

                                , Object_CashFlow_out.Id                     AS CashFlowId_out
                                , Object_CashFlow_out.ObjectCode             AS CashFlowCode_out
                                , '(' || CAST (Object_CashFlow_out.ObjectCode AS TVarChar) || ') '|| Object_CashFlow_out.ValueData AS CashFlowName_out
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
                                         , MIContainer.isActive
                                         , MIContainer.MovementItemId
                                         , MIContainer.ContainerId
                                         , MIContainer.OperDate
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
                                   
        , Operation_all AS (
                            -- движение в валюте баланса
                            SELECT tmpContainer.ContainerId                  AS ContainerId,
                                   tmpContainer.ObjectId                     AS ObjectId,
                                   tmpContainer.CashId                       AS CashId,
                                   tmpContainer.CurrencyId                   AS CurrencyId,
                                   MILO_InfoMoney.ObjectId                   AS InfoMoneyId,
                                   MILO_Unit.ObjectId                        AS UnitId,
                                   MILO_MoneyPlace.ObjectId                  AS MoneyPlaceId,
                                   MILO_Contract.ObjectId                    AS ContractId,
                                   SUM (tmpContainer.DebetSumm)              AS DebetSumm,
                                   SUM (tmpContainer.KreditSumm)             AS KreditSumm,
                                   0                                         AS DebetSumm_Currency,
                                   0                                         AS KreditSumm_Currency,
                                   SUM (tmpContainer.Summ_Currency)          AS Summ_Currency,
                                   SUM (tmpContainer.Summ_Currency_pl)       AS Summ_Currency_pl,
                                   tmpContainer.isActive                     AS isActive,
                                   tmpContainer.OperDate                     AS OperDate
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
                                     tmpContainer.OperDate
                            UNION ALL
                            -- движение  в валюте операции
                            SELECT 0                                         AS ContainerId,
                                   tmpContainer.ObjectId                     AS ObjectId,
                                   tmpContainer.CashId                       AS CashId,
                                   tmpContainer.CurrencyId                   AS CurrencyId,
                                   MILO_InfoMoney.ObjectId                   AS InfoMoneyId,
                                   MILO_Unit.ObjectId                        AS UnitId,
                                   MILO_MoneyPlace.ObjectId                  AS MoneyPlaceId,
                                   MILO_Contract.ObjectId                    AS ContractId,
                                   0                                         AS DebetSumm,
                                   0                                         AS KreditSumm,
                                   SUM (tmpContainer.DebetSumm_Currency)     AS DebetSumm_Currency,
                                   SUM (tmpContainer.KreditSumm_Currency)    AS KreditSumm_Currency,
                                   0                                         AS Summ_Currency,
                                   0                                         AS Summ_Currency_pl,
                                   tmpContainer.isActive                     AS isActive,
                                   tmpContainer.OperDate                     AS OperDate
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
                                     tmpContainer.OperDate
                            )

      , tmpOperation AS (SELECT Operation_all.ContainerId, Operation_all.ObjectId, Operation_all.CashId, Operation_all.InfoMoneyId, Operation_all.CurrencyId,
                                Operation_all.UnitId, Operation_all.MoneyPlaceId, Operation_all.ContractId,
                                Operation_all.OperDate,
                                SUM (Operation_all.DebetSumm)   AS DebetSumm,
                                SUM (Operation_all.KreditSumm)  AS KreditSumm,
                                SUM (Operation_all.DebetSumm_Currency)   AS DebetSumm_Currency,
                                SUM (Operation_all.KreditSumm_Currency)  AS KreditSumm_Currency,
                                SUM (Operation_all.Summ_Currency)        AS Summ_Currency,
                                SUM (Operation_all.Summ_Currency_pl)     AS Summ_Currency_pl
                         FROM Operation_all
                         GROUP BY Operation_all.ContainerId, Operation_all.ObjectId, Operation_all.CashId, Operation_all.CurrencyId,
                                  Operation_all.InfoMoneyId, Operation_all.UnitId, Operation_all.MoneyPlaceId, Operation_all.ContractId,
                                  Operation_all.isActive, Operation_all.OperDate
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
        tmpInfoMoney.CashFlowCode_in                 :: Integer                                     AS CashFlowCode_in,
        tmpInfoMoney.CashFlowName_in                 :: TVarChar                                    AS CashFlowName_in,
        tmpInfoMoney.CashFlowCode_out                :: Integer                                     AS CashFlowCode_out,
        tmpInfoMoney.CashFlowName_out                :: TVarChar                                    AS CashFlowName_out,
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

        Operation.OperDate         :: TDateTime,
        
        (EXTRACT (MONTH FROM Operation.OperDate)||'. ' ||zfCalc_MonthName (Operation.OperDate))  ::TVarChar AS MonthName,
        EXTRACT (YEAR FROM Operation.OperDate) ::TVarChar AS Year
     FROM tmpOperation AS Operation

         LEFT JOIN tmpAccount ON tmpAccount.AccountId = Operation.ObjectId
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
         LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Cash_Branch.ChildObjectId
    
         LEFT JOIN tmpContract ON tmpContract.ContractId = Operation.ContractId
    
     WHERE (Operation.DebetSumm <> 0
         OR Operation.KreditSumm <> 0
         OR Operation.DebetSumm_Currency <> 0
         OR Operation.KreditSumm_Currency <> 0);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.06.20         * CashFlowName
 20.04.20         * olap
 10.01.20         * add inisDate
 31.07.17         * шустрее работает
 27.09.14                                        *
 09.09.14                                                        *
*/

-- тест
-- select * from gpReport_Cash_Olap(inStartDate := ('01.12.2019')::TDateTime , inEndDate := ('31.12.2019')::TDateTime , inAccountId := 0 , inCashId := 296540 , inCurrencyId := 0 , inSession := '5');
