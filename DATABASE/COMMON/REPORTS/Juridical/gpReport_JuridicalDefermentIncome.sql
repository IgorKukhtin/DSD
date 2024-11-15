-- Function: gpReport_JuridicalSold()

DROP FUNCTION IF EXISTS gpReport_JuridicalDefermentIncome (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_JuridicalDefermentIncome(
    IN inOperDate         TDateTime , -- 
    IN inEmptyParam       TDateTime , -- 
    IN inAccountId        Integer   , --
    IN inPaidKindId       Integer   , --
    IN inBranchId         Integer   , --
    IN inJuridicalGroupId Integer   , --
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (AccountId Integer, AccountName TVarChar, JuridicalId Integer, JuridicalName TVarChar, RetailName TVarChar, RetailName_main TVarChar, OKPO TVarChar, JuridicalGroupName TVarChar
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
             , BranchId Integer, BranchCode Integer, BranchName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractId Integer, ContractCode Integer, ContractNumber TVarChar
             , ContractTagGroupName TVarChar, ContractTagName TVarChar, ContractStateKindCode Integer
             , PersonalName TVarChar
             , PersonalTradeName TVarChar
             , PersonalCollationName TVarChar
             , StartDate TDateTime, EndDate_real TDateTime, EndDate_term TDateTime, EndDate TVarChar
             , DebetRemains TFloat, KreditRemains TFloat
             , SaleSumm TFloat, DefermentPaymentRemains TFloat
             , SaleSumm1 TFloat, SaleSumm2 TFloat, SaleSumm3 TFloat, SaleSumm4 TFloat, SaleSumm5 TFloat
             , Condition TVarChar, StartContractDate TDateTime, Remains TFloat
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , AreaName TVarChar
             , PaymentDate TDateTime, PaymentAmount TFloat
             , PaymentDate_jur TDateTime, PaymentAmount_jur TFloat
             , IncomeDate TDateTime, IncomeAmount TFloat       
             , IncomeDate_jur TDateTime, IncomeAmount_jur TFloat    --последний приход
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbLenght Integer;

   DECLARE vbIsBranch Boolean;
   DECLARE vbIsJuridicalGroup Boolean;
   DECLARE vbObjectId_Constraint_Branch Integer;
   DECLARE vbObjectId_Constraint_JuridicalGroup Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inOperDate, inOperDate, NULL, NULL, NULL, vbUserId);

     -- определяется ...
     vbIsBranch:= COALESCE (inBranchId, 0) > 0;
     vbIsJuridicalGroup:= COALESCE (inJuridicalGroupId, 0) > 0;

     -- определяется уровень доступа
     vbObjectId_Constraint_Branch:= (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId);
     vbObjectId_Constraint_JuridicalGroup:= (SELECT Object_RoleAccessKeyGuide_View.JuridicalGroupId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.JuridicalGroupId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.JuridicalGroupId);
     -- !!!меняется параметр!!!
     IF vbObjectId_Constraint_Branch > 0 THEN inBranchId:= vbObjectId_Constraint_Branch; END IF;
     IF vbObjectId_Constraint_JuridicalGroup > 0 THEN inJuridicalGroupId:= vbObjectId_Constraint_JuridicalGroup; END IF;


     -- Выбираем остаток на дату по юр. лицам в разрезе договоров. 
     -- Так же выбираем продажи и возвраты за период 
      vbLenght := 7;


     -- Результат
     RETURN QUERY
     WITH tmpAccount AS (SELECT inAccountId AS AccountId, 0 AS AccountGroupId, 0 AS AccountDirectionId
                   -- UNION SELECT Object_Account_View.AccountId FROM Object_Account_View WHERE InfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_20700() AND AccountDirectionId = zc_Enum_AccountDirection_70100()
                   --                       AND EXISTS (SELECT 1 FROM Object_Account_View WHERE Object_Account_View.AccountId = inAccountId AND AccountDirectionId = zc_Enum_AccountDirection_70100() AND InfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_20700()) -- Кредиторы + поставщики AND <> Товары + Прочие товары
                   UNION
                     SELECT Object_Account_View.AccountId, Object_Account_View.AccountGroupId, Object_Account_View.AccountDirectionId
                     FROM Object_Account_View
                     WHERE COALESCE (inAccountId, 0) = 0
                       AND (AccountGroupId     = zc_Enum_AccountGroup_70000()     -- Кредиторы
                         OR AccountDirectionId = zc_Enum_AccountDirection_30200() -- наши компании
                           )
                        )
        , tmpListBranch_Constraint AS (SELECT ObjectLink_Contract_Personal.ObjectId AS ContractId
                                       FROM ObjectLink AS ObjectLink_Unit_Branch
                                            INNER JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                                  ON ObjectLink_Personal_Unit.ChildObjectId = ObjectLink_Unit_Branch.ObjectId
                                                                 AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                            INNER JOIN ObjectLink AS ObjectLink_Contract_Personal
                                                                  ON ObjectLink_Contract_Personal.ChildObjectId = ObjectLink_Personal_Unit.ObjectId
                                                                 AND ObjectLink_Contract_Personal.DescId = zc_ObjectLink_Contract_Personal()
                                       WHERE (ObjectLink_Unit_Branch.ChildObjectId = vbObjectId_Constraint_Branch   OR vbUserId = 9457)
                                         AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                                       GROUP BY ObjectLink_Contract_Personal.ObjectId
                                      )
        , tmpJuridical AS (SELECT lfSelect_Object_Juridical_byGroup.JuridicalId FROM lfSelect_Object_Juridical_byGroup (inJuridicalGroupId) AS lfSelect_Object_Juridical_byGroup WHERE inJuridicalGroupId <> 0)

        , RESULT AS (SELECT RESULT_all.AccountId
                      , RESULT_all.ContractId
                      , RESULT_all.JuridicalId 
                      , -1 * SUM (RESULT_all.Remains)   AS Remains
                      , SUM (RESULT_all.SaleSumm)  AS SaleSumm
                      , SUM (RESULT_all.SaleSumm1) AS SaleSumm1
                      , SUM (RESULT_all.SaleSumm2) AS SaleSumm2
                      , SUM (RESULT_all.SaleSumm3) AS SaleSumm3
                      , SUM (RESULT_all.SaleSumm4) AS SaleSumm4
                      , RESULT_all.ContractConditionKindId
                      , RESULT_all.DayCount
                      , RESULT_all.DelayCreditLimit
                      , RESULT_all.ContractDate
                      , CLO_InfoMoney.ObjectId AS InfoMoneyId
                      , CLO_PaidKind.ObjectId  AS PaidKindId
                      , CLO_Partner.ObjectId   AS PartnerId
                      , CLO_Branch.ObjectId    AS BranchId
                      , ObjectLink_Juridical_JuridicalGroup.ChildObjectId AS JuridicalGroupId
                 FROM (SELECT Container.Id
                            , Container.ObjectId     AS AccountId
                            , View_Contract_ContractKey.ContractId_Key AS ContractId -- CLO_Contract.ObjectId AS ContractId
                            , CLO_Juridical.ObjectId AS JuridicalId 
                            , Container.Amount - COALESCE(SUM (CASE WHEN MIContainer.OperDate >= inOperDate THEN MIContainer.Amount ELSE 0 END), 0) AS Remains
                            , SUM (CASE WHEN (MIContainer.OperDate < inOperDate)                 AND (MIContainer.OperDate >= ContractDate)               AND Movement.DescId IN (zc_Movement_Income()) THEN -1 * MIContainer.Amount ELSE 0 END) AS SaleSumm
                            , SUM (CASE WHEN (MIContainer.OperDate < ContractDate                AND MIContainer.OperDate >= ContractDate - vbLenght)     AND Movement.DescId IN (zc_Movement_Income()) THEN -1 * MIContainer.Amount ELSE 0 END) AS SaleSumm1
                            , SUM (CASE WHEN (MIContainer.OperDate < ContractDate - vbLenght     AND MIContainer.OperDate >= ContractDate - 2 * vbLenght) AND Movement.DescId IN (zc_Movement_Income()) THEN -1 * MIContainer.Amount ELSE 0 END) AS SaleSumm2
                            , SUM (CASE WHEN (MIContainer.OperDate < ContractDate - 2 * vbLenght AND MIContainer.OperDate >= ContractDate - 3 * vbLenght) AND Movement.DescId IN (zc_Movement_Income()) THEN -1 * MIContainer.Amount ELSE 0 END) AS SaleSumm3
                            , SUM (CASE WHEN (MIContainer.OperDate < ContractDate - 3 * vbLenght AND MIContainer.OperDate >= ContractDate - 4 * vbLenght) AND Movement.DescId IN (zc_Movement_Income()) THEN -1 * MIContainer.Amount ELSE 0 END) AS SaleSumm4
                            , COALESCE (ContractCondition_DefermentPayment.ContractConditionKindId, zc_Enum_ContractConditionKind_DelayDayCalendar()) AS ContractConditionKindId
                            , COALESCE (ContractCondition_DefermentPayment.DayCount, 0) AS DayCount
                            , COALESCE (ContractCondition_CreditLimit.DelayCreditLimit, 0) AS DelayCreditLimit
                            , COALESCE (ContractCondition_DefermentPayment.ContractDate, inOperDate) AS ContractDate
                        FROM ContainerLinkObject AS CLO_Juridical
                             INNER JOIN Container ON Container.Id = CLO_Juridical.ContainerId AND Container.DescId = zc_Container_Summ()
                             INNER JOIN tmpAccount ON tmpAccount.AccountId = Container.ObjectId
                             LEFT JOIN ContainerLinkObject AS CLO_Contract
                                                           ON CLO_Contract.ContainerId = Container.Id
                                                          AND CLO_Contract.DescId      = zc_ContainerLinkObject_Contract()
                             LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                                           ON CLO_InfoMoney.ContainerId = Container.Id
                                                          AND CLO_InfoMoney.DescId      = zc_ContainerLinkObject_InfoMoney()
                             LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyGroup
                                                  ON ObjectLink_InfoMoney_InfoMoneyGroup.ObjectId = CLO_InfoMoney.ObjectId
                                                 AND ObjectLink_InfoMoney_InfoMoneyGroup.DescId = zc_ObjectLink_InfoMoney_InfoMoneyGroup()

                             -- !!!Группируем Договора!!!
                             LEFT JOIN Object_Contract_ContractKey_View AS View_Contract_ContractKey ON View_Contract_ContractKey.ContractId = CLO_Contract.ObjectId

                             LEFT JOIN (SELECT Object_ContractCondition_View.ContractId
                                             , zfCalc_DetermentPaymentDate (COALESCE (Object_ContractCondition_View.ContractConditionKindId, 0), Object_ContractCondition_View.Value :: Integer, inOperDate) :: Date AS ContractDate
                                             , Object_ContractCondition_View.ContractConditionKindId
                                             , Object_ContractCondition_View.Value :: Integer AS DayCount
                                        FROM (SELECT Object_ContractCondition_View.ContractId
                                                   , Object_ContractCondition_View.ContractConditionKindId
                                                   , MAX (Object_ContractCondition_View.Value) AS Value
                                              FROM Object_ContractCondition_DefermentPaymentView
                                                   INNER JOIN Object_ContractCondition_View
                                                           ON Object_ContractCondition_View.ContractConditionKindId = Object_ContractCondition_DefermentPaymentView.ConditionKindId
                                              WHERE Object_ContractCondition_View.Value <> 0
                                                AND inOperDate BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate
                                              GROUP BY Object_ContractCondition_View.ContractId
                                                     , Object_ContractCondition_View.ContractConditionKindId
                                             ) AS Object_ContractCondition_View
                                       ) AS ContractCondition_DefermentPayment
                                         ON ContractCondition_DefermentPayment.ContractId = View_Contract_ContractKey.ContractId_Key -- CLO_Contract.ObjectId

                             LEFT JOIN (SELECT Object_ContractCondition_View.ContractId
                                             , Value AS DelayCreditLimit
                                        FROM Object_ContractCondition_View
                                        WHERE Object_ContractCondition_View.ContractConditionKindId = zc_Enum_ContractConditionKind_DelayCreditLimit()
                                       ) AS ContractCondition_CreditLimit
                                         ON ContractCondition_CreditLimit.ContractId = View_Contract_ContractKey.ContractId_Key -- CLO_Contract.ObjectId
                                             
                             LEFT JOIN MovementItemContainer AS MIContainer 
                                                             ON MIContainer.Containerid = Container.Id
                                                            AND MIContainer.OperDate >= COALESCE (ContractCondition_DefermentPayment.ContractDate :: Date - 4 * vbLenght, inOperDate)
                            LEFT JOIN Movement ON Movement.Id = MIContainer.MovementId
                        WHERE CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                           -- AND (Container.ObjectId = inAccountId OR inAccountId = 0)
                           AND (tmpAccount.AccountId > 0 OR inAccountId = 0
                               )
                           AND (tmpAccount.AccountDirectionId <> zc_Enum_AccountDirection_30200() -- наши компании
                             OR ObjectLink_InfoMoney_InfoMoneyGroup.ChildObjectId = zc_Enum_InfoMoneyGroup_10000() -- Основное сырье
                               )
                        GROUP BY Container.Id
                               , Container.ObjectId
                               , Container.Amount
                               , View_Contract_ContractKey.ContractId_Key
                               , CLO_Juridical.ObjectId  
                               , COALESCE (ContractCondition_DefermentPayment.ContractConditionKindId, zc_Enum_ContractConditionKind_DelayDayCalendar())
                               , DayCount
                               , DelayCreditLimit
                               , ContractDate
                        ) AS RESULT_all

                     LEFT JOIN ContainerLinkObject AS CLO_PaidKind
                                                   ON CLO_PaidKind.ContainerId = RESULT_all.Id
                                                  AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                     LEFT JOIN ContainerLinkObject AS CLO_Branch
                                                   ON CLO_Branch.ContainerId = RESULT_all.Id
                                                  AND CLO_Branch.DescId = zc_ContainerLinkObject_Branch()
                     LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                                   ON CLO_InfoMoney.ContainerId = RESULT_all.Id
                                                  AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                     LEFT JOIN ContainerLinkObject AS CLO_Partner
                                                   ON CLO_Partner.ContainerId = RESULT_all.Id
                                                  AND CLO_Partner.DescId = zc_ContainerLinkObject_Partner()
                     LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                                          ON ObjectLink_Juridical_JuridicalGroup.ObjectId = RESULT_all.JuridicalId
                                         AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
          
                     LEFT JOIN tmpJuridical ON tmpJuridical.JuridicalId = RESULT_all.JuridicalId
                     LEFT JOIN tmpListBranch_Constraint ON tmpListBranch_Constraint.ContractId = RESULT_all.ContractId
          
                 WHERE (CLO_PaidKind.ObjectId = inPaidKindId OR inPaidKindId = 0)
                   AND (CLO_Branch.ObjectId = inBranchId OR COALESCE (inBranchId, 0) = 0
                        -- OR ((ObjectLink_Juridical_JuridicalGroup.ChildObjectId = inJuridicalGroupId OR tmpListBranch_Constraint.ContractId > 0) AND vbIsBranch = FALSE)) -- !!!пересорт!!
                        OR ((tmpJuridical.JuridicalId > 0 OR tmpListBranch_Constraint.ContractId > 0) AND vbIsBranch = FALSE)) -- !!!пересорт!!
                   -- AND (ObjectLink_Juridical_JuridicalGroup.ChildObjectId = inJuridicalGroupId OR COALESCE (inJuridicalGroupId, 0) = 0
                   AND (tmpJuridical.JuridicalId > 0 OR COALESCE (inJuridicalGroupId, 0) = 0
                        OR tmpListBranch_Constraint.ContractId > 0
                        OR (CLO_Branch.ObjectId = inBranchId AND vbIsJuridicalGroup = FALSE)) -- !!!пересорт!!
                 GROUP BY RESULT_all.AccountId
                        , RESULT_all.ContractId
                        , RESULT_all.JuridicalId 
                        , RESULT_all.ContractConditionKindId
                        , RESULT_all.DayCount
                        , RESULT_all.DelayCreditLimit
                        , RESULT_all.ContractDate
                        , CLO_InfoMoney.ObjectId
                        , CLO_PaidKind.ObjectId
                        , CLO_Partner.ObjectId
                        , CLO_Branch.ObjectId
                        , ObjectLink_Juridical_JuridicalGroup.ChildObjectId
                 )

   --находим последнии оплаты    и последний приход
   , tmpLastPayment_all AS (SELECT *
                            FROM (SELECT tt.JuridicalId
                                       , tt.ContractId
                                       , tt.PaidKindId
                                       , COALESCE (tt.PartnerId, 0) AS PartnerId
                                       , tt.OperDate
                                       , ObjectLink_Contract_InfoMoney.ChildObjectId AS InfoMoneyId
                                       , tt.Amount 
                                       , ROW_NUMBER() OVER (PARTITION BY tt.JuridicalId, tt.ContractId, tt.PaidKindId, COALESCE (tt.PartnerId, 0), ObjectLink_Contract_InfoMoney.ChildObjectId ORDER BY tt.OperDate DESC) AS ord
                                  FROM gpSelect_Object_JuridicalDefermentPayment(inSession) AS tt
                                       JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                                       ON ObjectLink_Contract_InfoMoney.ObjectId = tt.ContractId
                                                      AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                                  WHERE COALESCE (tt.Amount,0) <> 0
                                  ) AS tmp
                            WHERE tmp.Ord = 1
                            )

   , tmpLastIncome_all AS (SELECT *
                           FROM (SELECT  tt.JuridicalId
                                       , tt.ContractId
                                       , tt.PaidKindId
                                       , COALESCE (tt.PartnerId, 0) AS PartnerId
                                       , ObjectLink_Contract_InfoMoney.ChildObjectId AS InfoMoneyId
                                       -- последний приход
                                       , tt.OperDateIn
                                       , tt.AmountIn
                                       , ROW_NUMBER() OVER (PARTITION BY tt.JuridicalId, tt.ContractId, tt.PaidKindId, COALESCE (tt.PartnerId, 0), ObjectLink_Contract_InfoMoney.ChildObjectId ORDER BY tt.OperDateIn DESC) AS ord
      
                                  FROM gpSelect_Object_JuridicalDefermentPayment('5') AS tt
                                       JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                                       ON ObjectLink_Contract_InfoMoney.ObjectId = tt.ContractId
                                                      AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                                  WHERE COALESCE (tt.AmountIn,0) <> 0
                                  --and  tt.JuridicalId = 301746
                                  ) AS tmp
                            WHERE tmp.Ord = 1
                           )
                           
     -- находим последнии оплаты
   , tmpLastPayment AS (SELECT tt.JuridicalId
                             , tt.PaidKindId
                             , tt.InfoMoneyId
                             , tt.OperDate
                             , SUM (tt.Amount) AS Amount
                        FROM tmpLastPayment_all AS tt
                        GROUP BY tt.JuridicalId
                               , tt.PaidKindId
                               , tt.InfoMoneyId
                               , tt.OperDate
                       )
      -- находим последниий приход
   , tmpLastIncome AS (SELECT tt.JuridicalId
                            , tt.PaidKindId
                            , tt.InfoMoneyId
                            , tt.OperDateIn
                            , SUM (tt.AmountIn) AS AmountIn
                       FROM tmpLastIncome_all AS tt
                       GROUP BY tt.JuridicalId
                              , tt.PaidKindId
                              , tt.InfoMoneyId
                              , tt.OperDateIn
                      )

     SELECT a.AccountId, a.AccountName, a.JuridicalId, a.JuridicalName, a.RetailName, a.RetailName_main, a.OKPO, a.JuridicalGroupName
          , a.PartnerId, a.PartnerCode, a.PartnerName TVarChar
          , a.BranchId, a.BranchCode, a.BranchName
          , a.PaidKindId, a.PaidKindName
          , a.ContractId, a.ContractCode, a.ContractNumber
          , a.ContractTagGroupName, a.ContractTagName, a.ContractStateKindCode
          , a.PersonalName
          , a.PersonalTradeName
          , a.PersonalCollationName
          , a.StartDate, a.EndDate_real, a.EndDate_term, a.EndDate
          , a.DebetRemains, a.KreditRemains
          , a.SaleSumm, a.DefermentPaymentRemains
          , a.SaleSumm1, a.SaleSumm2, a.SaleSumm3, a.SaleSumm4, a.SaleSumm5
          , a.Condition, a.StartContractDate, a.Remains
          , a.InfoMoneyGroupName, a.InfoMoneyDestinationName
          , a.InfoMoneyId, a.InfoMoneyCode, a.InfoMoneyName
          , a.AreaName

          , tmpLastPayment.OperDate :: TDateTime AS PaymentDate
          , tmpLastPayment.Amount   :: TFloat    AS PaymentAmount
          
          , tmpLastPaymentJuridical.OperDate :: TDateTime AS PaymentDate_jur
          , tmpLastPaymentJuridical.Amount   :: TFloat    AS PaymentAmount_jur

          , tmpLastIncome.OperDateIn :: TDateTime AS IncomeDate
          , tmpLastIncome.AmountIn   :: TFloat    AS IncomeAmount
          
          , tmpLastIncomeJuridical.OperDateIn :: TDateTime AS IncomeDate_jur
          , tmpLastIncomeJuridical.AmountIn   :: TFloat    AS IncomeAmount_jur

     FROM (
           SELECT 
                  Object_Account_View.AccountId
                , Object_Account_View.AccountName_all AS AccountName
                , Object_Juridical.Id        AS JuridicalId
                , Object_Juridical.Valuedata AS JuridicalName
                , COALESCE (Object_RetailReport.ValueData, 'прочие') :: TVarChar AS RetailName
                , COALESCE (Object_Retail.ValueData, 'прочие') :: TVarChar AS RetailName_main
                , ObjectHistory_JuridicalDetails_View.OKPO
                , Object_JuridicalGroup.ValueData AS JuridicalGroupName
                , Object_Partner.Id          AS PartnerId
                , Object_Partner.ObjectCode  AS PartnerCode
                , Object_Partner.ValueData   AS PartnerName
                , Object_Branch.Id           AS BranchId
                , Object_Branch.ObjectCode   AS BranchCode
                , Object_Branch.ValueData    AS BranchName
                , Object_PaidKind.Id         AS PaidKindId
                , Object_PaidKind.ValueData  AS PaidKindName
                , View_Contract.ContractId
                , View_Contract.ContractCode
                , View_Contract.InvNumber AS ContractNumber
                , View_Contract.ContractTagGroupName
                , View_Contract.ContractTagName
                , View_Contract.ContractStateKindCode
                , Object_Personal_View.PersonalName      AS PersonalName
                , Object_PersonalTrade.PersonalName      AS PersonalTradeName
                , Object_PersonalCollation.PersonalName  AS PersonalCollationName
                , View_Contract.StartDate
                , View_Contract.EndDate_real
                , View_Contract.EndDate_term
                , (''|| CASE WHEN View_Contract.ContractTermKindId = zc_Enum_ContractTermKind_Long() THEN '* ' ELSE '' END
                     || (LPAD (EXTRACT (Day FROM View_Contract.EndDate_term) :: TVarChar,2,'0') ||'.'||LPAD (EXTRACT (Month FROM View_Contract.EndDate_term) :: TVarChar,2,'0') ||'.'||EXTRACT (YEAR FROM View_Contract.EndDate_term) :: TVarChar)
                  ) ::TVarChar AS EndDate

                , (CASE WHEN -1 * RESULT.Remains > 0 THEN -1 * RESULT.Remains ELSE 0 END) :: TFloat AS DebetRemains
                , (CASE WHEN -1 * RESULT.Remains > 0 THEN 0 ELSE 1 * RESULT.Remains END) :: TFloat AS KreditRemains
                , RESULT.SaleSumm :: TFloat AS SaleSumm
             
                , (CASE WHEN COALESCE (RESULT.ContractConditionKindId, 0) NOT IN (zc_Enum_ContractConditionKind_DelayDayCalendar()
                                                                                , zc_Enum_ContractConditionKind_DelayDayBank()
                                                                                 )
                        AND RESULT.Remains < 0
                             THEN 0
                        WHEN (RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm) > 0
                             THEN RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm
                        ELSE RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm -- 0
                   END)::TFloat AS DefermentPaymentRemains
             
                , (CASE WHEN ((RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm) > 0 AND RESULT.SaleSumm1 > 0)
                             THEN CASE WHEN (RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm) > RESULT.SaleSumm1
                                       THEN RESULT.SaleSumm1
                                       ELSE (RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm)
                                  END
                        ELSE 0
                   END)::TFloat AS SaleSumm1
             
                , (CASE WHEN ((RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm - RESULT.SaleSumm1) > 0 AND RESULT.SaleSumm2 > 0)
                             THEN CASE WHEN (RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm - RESULT.SaleSumm1) > RESULT.SaleSumm2
                                       THEN RESULT.SaleSumm2
                                       ELSE (RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm - RESULT.SaleSumm1)
                                  END
                   ELSE 0 END)::TFloat AS SaleSumm2
             
                , (CASE WHEN ((RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm - RESULT.SaleSumm1 - RESULT.SaleSumm2) > 0 AND RESULT.SaleSumm3 > 0)
                             THEN CASE WHEN (RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm - RESULT.SaleSumm1 - RESULT.SaleSumm2) > RESULT.SaleSumm3
                                       THEN RESULT.SaleSumm3
                                       ELSE (RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm - RESULT.SaleSumm1 - RESULT.SaleSumm2)
                                  END
                        ELSE 0
                   END)::TFloat AS SaleSumm3
             
                , (CASE WHEN ((RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm - RESULT.SaleSumm1 - RESULT.SaleSumm2 - RESULT.SaleSumm3) > 0 AND RESULT.SaleSumm4 > 0)
                             THEN CASE WHEN (RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm - RESULT.SaleSumm1 - RESULT.SaleSumm2 - RESULT.SaleSumm3) > RESULT.SaleSumm4
                                       THEN RESULT.SaleSumm4
                                       ELSE (RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm - RESULT.SaleSumm1 - RESULT.SaleSumm2 - RESULT.SaleSumm3)
                                  END
                         ELSE 0
                   END)::TFloat AS SaleSumm4
             
                , (CASE WHEN (RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm - RESULT.SaleSumm1 - RESULT.SaleSumm2 - RESULT.SaleSumm3 - RESULT.SaleSumm4) > 0
                             THEN (RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm - RESULT.SaleSumm1 - RESULT.SaleSumm2 - RESULT.SaleSumm3 - RESULT.SaleSumm4)
                             ELSE 0
                   END )::TFloat AS SaleSumm5
             
                , (RESULT.DayCount||' '|| CASE WHEN RESULT.ContractConditionKindId = zc_Enum_ContractConditionKind_DelayDayCalendar()
                                                    THEN 'К.дн.'
                                               -- WHEN RESULT.ContractConditionKindId = zc_Enum_ContractConditionKind_DelayDayCalendarSale()
                                               --      THEN 'К.Р.дн.'
                                               WHEN RESULT.ContractConditionKindId = zc_Enum_ContractConditionKind_DelayDayBank()
                                                    THEN 'Б.дн.'
                                               -- WHEN RESULT.ContractConditionKindId = zc_Enum_ContractConditionKind_DelayDayBankSale()
                                               --     THEN 'Б.Р.дн.'
                                               ELSE ''
                                          END
                                  ||' '|| CASE WHEN RESULT.DelayCreditLimit <> 0
                                                    THEN '+ ' || TRIM (to_char (RESULT.DelayCreditLimit, '999 999 999 999 999D99')) || 'грн.'
                                               ELSE ''
                                          END
                   )::TVarChar AS Condition -- Object_ContractConditionKind.ValueData
                , RESULT.ContractDate :: TDateTime AS StartContractDate
                , (-1 * RESULT.Remains) :: TFloat AS Remains
             
                   , Object_InfoMoney_View.InfoMoneyGroupName
                   , Object_InfoMoney_View.InfoMoneyDestinationName
                   , Object_InfoMoney_View.InfoMoneyId
                   , Object_InfoMoney_View.InfoMoneyCode
                   , Object_InfoMoney_View.InfoMoneyName
             
                   , Object_Area.ValueData AS AreaName
             
           FROM (SELECT RESULT_all.AccountId
                      , RESULT_all.ContractId
                      , RESULT_all.JuridicalId 
                      , -1 * SUM (RESULT_all.Remains)   AS Remains
                      , SUM (RESULT_all.SaleSumm)  AS SaleSumm
                      , SUM (RESULT_all.SaleSumm1) AS SaleSumm1
                      , SUM (RESULT_all.SaleSumm2) AS SaleSumm2
                      , SUM (RESULT_all.SaleSumm3) AS SaleSumm3
                      , SUM (RESULT_all.SaleSumm4) AS SaleSumm4
                      , RESULT_all.ContractConditionKindId
                      , RESULT_all.DayCount
                      , RESULT_all.DelayCreditLimit
                      , RESULT_all.ContractDate
                      , CLO_InfoMoney.ObjectId AS InfoMoneyId
                      , CLO_PaidKind.ObjectId  AS PaidKindId
                      , CLO_Partner.ObjectId   AS PartnerId
                      , CLO_Branch.ObjectId    AS BranchId
                      , ObjectLink_Juridical_JuridicalGroup.ChildObjectId AS JuridicalGroupId
                 FROM (SELECT Container.Id
                            , Container.ObjectId     AS AccountId
                            , View_Contract_ContractKey.ContractId_Key AS ContractId -- CLO_Contract.ObjectId AS ContractId
                            , CLO_Juridical.ObjectId AS JuridicalId 
                            , Container.Amount - COALESCE(SUM (CASE WHEN MIContainer.OperDate >= inOperDate THEN MIContainer.Amount ELSE 0 END), 0) AS Remains
                            , SUM (CASE WHEN (MIContainer.OperDate < inOperDate)                 AND (MIContainer.OperDate >= ContractDate)               AND Movement.DescId IN (zc_Movement_Income()) THEN -1 * MIContainer.Amount ELSE 0 END) AS SaleSumm
                            , SUM (CASE WHEN (MIContainer.OperDate < ContractDate                AND MIContainer.OperDate >= ContractDate - vbLenght)     AND Movement.DescId IN (zc_Movement_Income()) THEN -1 * MIContainer.Amount ELSE 0 END) AS SaleSumm1
                            , SUM (CASE WHEN (MIContainer.OperDate < ContractDate - vbLenght     AND MIContainer.OperDate >= ContractDate - 2 * vbLenght) AND Movement.DescId IN (zc_Movement_Income()) THEN -1 * MIContainer.Amount ELSE 0 END) AS SaleSumm2
                            , SUM (CASE WHEN (MIContainer.OperDate < ContractDate - 2 * vbLenght AND MIContainer.OperDate >= ContractDate - 3 * vbLenght) AND Movement.DescId IN (zc_Movement_Income()) THEN -1 * MIContainer.Amount ELSE 0 END) AS SaleSumm3
                            , SUM (CASE WHEN (MIContainer.OperDate < ContractDate - 3 * vbLenght AND MIContainer.OperDate >= ContractDate - 4 * vbLenght) AND Movement.DescId IN (zc_Movement_Income()) THEN -1 * MIContainer.Amount ELSE 0 END) AS SaleSumm4
                            , COALESCE (ContractCondition_DefermentPayment.ContractConditionKindId, zc_Enum_ContractConditionKind_DelayDayCalendar()) AS ContractConditionKindId
                            , COALESCE (ContractCondition_DefermentPayment.DayCount, 0) AS DayCount
                            , COALESCE (ContractCondition_CreditLimit.DelayCreditLimit, 0) AS DelayCreditLimit
                            , COALESCE (ContractCondition_DefermentPayment.ContractDate, inOperDate) AS ContractDate
                        FROM ContainerLinkObject AS CLO_Juridical
                             INNER JOIN Container ON Container.Id = CLO_Juridical.ContainerId AND Container.DescId = zc_Container_Summ()
                             INNER JOIN tmpAccount ON tmpAccount.AccountId = Container.ObjectId
                             LEFT JOIN ContainerLinkObject AS CLO_Contract
                                                           ON CLO_Contract.ContainerId = Container.Id
                                                          AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()
                             LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                                           ON CLO_InfoMoney.ContainerId = Container.Id
                                                          AND CLO_InfoMoney.DescId      = zc_ContainerLinkObject_InfoMoney()
                             LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyGroup
                                                  ON ObjectLink_InfoMoney_InfoMoneyGroup.ObjectId = CLO_InfoMoney.ObjectId
                                                 AND ObjectLink_InfoMoney_InfoMoneyGroup.DescId = zc_ObjectLink_InfoMoney_InfoMoneyGroup()
                             -- !!!Группируем Договора!!!
                             LEFT JOIN Object_Contract_ContractKey_View AS View_Contract_ContractKey ON View_Contract_ContractKey.ContractId = CLO_Contract.ObjectId

                             LEFT JOIN (SELECT Object_ContractCondition_View.ContractId
                                             , zfCalc_DetermentPaymentDate (COALESCE (Object_ContractCondition_View.ContractConditionKindId, 0), Object_ContractCondition_View.Value :: Integer, inOperDate) :: Date AS ContractDate
                                             , Object_ContractCondition_View.ContractConditionKindId
                                             , Object_ContractCondition_View.Value :: Integer AS DayCount
                                        FROM (SELECT Object_ContractCondition_View.ContractId
                                                   , Object_ContractCondition_View.ContractConditionKindId
                                                   , MAX (Object_ContractCondition_View.Value) AS Value
                                              FROM Object_ContractCondition_DefermentPaymentView
                                                   INNER JOIN Object_ContractCondition_View
                                                           ON Object_ContractCondition_View.ContractConditionKindId = Object_ContractCondition_DefermentPaymentView.ConditionKindId
                                              WHERE Object_ContractCondition_View.Value <> 0
                                                AND inOperDate BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate
                                              GROUP BY Object_ContractCondition_View.ContractId
                                                     , Object_ContractCondition_View.ContractConditionKindId
                                             ) AS Object_ContractCondition_View
                                       ) AS ContractCondition_DefermentPayment
                                         ON ContractCondition_DefermentPayment.ContractId = View_Contract_ContractKey.ContractId_Key -- CLO_Contract.ObjectId

                             LEFT JOIN (SELECT Object_ContractCondition_View.ContractId
                                             , Value AS DelayCreditLimit
                                        FROM Object_ContractCondition_View
                                        WHERE Object_ContractCondition_View.ContractConditionKindId = zc_Enum_ContractConditionKind_DelayCreditLimit()
                                       ) AS ContractCondition_CreditLimit
                                         ON ContractCondition_CreditLimit.ContractId = View_Contract_ContractKey.ContractId_Key -- CLO_Contract.ObjectId
                                             
                             LEFT JOIN MovementItemContainer AS MIContainer 
                                                             ON MIContainer.Containerid = Container.Id
                                                            AND MIContainer.OperDate >= COALESCE (ContractCondition_DefermentPayment.ContractDate :: Date - 4 * vbLenght, inOperDate)
                            LEFT JOIN Movement ON Movement.Id = MIContainer.MovementId
                        WHERE CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                           -- AND (Container.ObjectId = inAccountId OR inAccountId = 0)
                           AND (tmpAccount.AccountId > 0 OR inAccountId = 0)
                           AND (tmpAccount.AccountDirectionId <> zc_Enum_AccountDirection_30200() -- наши компании
                             OR ObjectLink_InfoMoney_InfoMoneyGroup.ChildObjectId = zc_Enum_InfoMoneyGroup_10000() -- Основное сырье
                               )
                        GROUP BY Container.Id
                               , Container.ObjectId
                               , Container.Amount
                               , View_Contract_ContractKey.ContractId_Key
                               , CLO_Juridical.ObjectId  
                               , COALESCE (ContractCondition_DefermentPayment.ContractConditionKindId, zc_Enum_ContractConditionKind_DelayDayCalendar())
                               , DayCount
                               , DelayCreditLimit
                               , ContractDate
                        ) AS RESULT_all

                     LEFT JOIN ContainerLinkObject AS CLO_PaidKind
                                                   ON CLO_PaidKind.ContainerId = RESULT_all.Id
                                                  AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                     LEFT JOIN ContainerLinkObject AS CLO_Branch
                                                   ON CLO_Branch.ContainerId = RESULT_all.Id
                                                  AND CLO_Branch.DescId = zc_ContainerLinkObject_Branch()
                     LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                                   ON CLO_InfoMoney.ContainerId = RESULT_all.Id
                                                  AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                     LEFT JOIN ContainerLinkObject AS CLO_Partner
                                                   ON CLO_Partner.ContainerId = RESULT_all.Id
                                                  AND CLO_Partner.DescId = zc_ContainerLinkObject_Partner()
                     LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                                          ON ObjectLink_Juridical_JuridicalGroup.ObjectId = RESULT_all.JuridicalId
                                         AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
          
                     LEFT JOIN tmpJuridical ON tmpJuridical.JuridicalId = RESULT_all.JuridicalId
                     LEFT JOIN tmpListBranch_Constraint ON tmpListBranch_Constraint.ContractId = RESULT_all.ContractId
          
                 WHERE (CLO_PaidKind.ObjectId = inPaidKindId OR inPaidKindId = 0)
                   AND (CLO_Branch.ObjectId = inBranchId OR COALESCE (inBranchId, 0) = 0
                        -- OR ((ObjectLink_Juridical_JuridicalGroup.ChildObjectId = inJuridicalGroupId OR tmpListBranch_Constraint.ContractId > 0) AND vbIsBranch = FALSE)) -- !!!пересорт!!
                        OR ((tmpJuridical.JuridicalId > 0 OR tmpListBranch_Constraint.ContractId > 0) AND vbIsBranch = FALSE)) -- !!!пересорт!!
                   -- AND (ObjectLink_Juridical_JuridicalGroup.ChildObjectId = inJuridicalGroupId OR COALESCE (inJuridicalGroupId, 0) = 0
                   AND (tmpJuridical.JuridicalId > 0 OR COALESCE (inJuridicalGroupId, 0) = 0
                        OR tmpListBranch_Constraint.ContractId > 0
                        OR (CLO_Branch.ObjectId = inBranchId AND vbIsJuridicalGroup = FALSE)) -- !!!пересорт!!
                 GROUP BY RESULT_all.AccountId
                        , RESULT_all.ContractId
                        , RESULT_all.JuridicalId 
                        , RESULT_all.ContractConditionKindId
                        , RESULT_all.DayCount
                        , RESULT_all.DelayCreditLimit
                        , RESULT_all.ContractDate
                        , CLO_InfoMoney.ObjectId
                        , CLO_PaidKind.ObjectId
                        , CLO_Partner.ObjectId
                        , CLO_Branch.ObjectId
                        , ObjectLink_Juridical_JuridicalGroup.ChildObjectId
                 ) AS RESULT

           LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = RESULT.JuridicalId
           LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = RESULT.AccountId
           LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = RESULT.ContractId

           LEFT JOIN ObjectLink AS ObjectLink_Contract_Personal
                               ON ObjectLink_Contract_Personal.ObjectId = RESULT.ContractId
                              AND ObjectLink_Contract_Personal.DescId = zc_ObjectLink_Contract_Personal()
           LEFT JOIN Object_Personal_View ON Object_Personal_View.PersonalId = ObjectLink_Contract_Personal.ChildObjectId               

           LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalTrade
                                ON ObjectLink_Contract_PersonalTrade.ObjectId = RESULT.ContractId
                               AND ObjectLink_Contract_PersonalTrade.DescId = zc_ObjectLink_Contract_PersonalTrade()
           LEFT JOIN Object_Personal_View AS Object_PersonalTrade ON Object_PersonalTrade.PersonalId = ObjectLink_Contract_PersonalTrade.ChildObjectId
           LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalCollation
                                ON ObjectLink_Contract_PersonalCollation.ObjectId = RESULT.ContractId
                               AND ObjectLink_Contract_PersonalCollation.DescId = zc_ObjectLink_Contract_PersonalCollation()
           LEFT JOIN Object_Personal_View AS Object_PersonalCollation ON Object_PersonalCollation.PersonalId = ObjectLink_Contract_PersonalCollation.ChildObjectId        

           LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id

           LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = RESULT.InfoMoneyId

           LEFT JOIN ObjectLink AS ObjectLink_Contract_Area
                                ON ObjectLink_Contract_Area.ObjectId = RESULT.ContractId
                               AND ObjectLink_Contract_Area.DescId = zc_ObjectLink_Contract_AreaContract()
           LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Contract_Area.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Juridical_RetailReport
                                ON ObjectLink_Juridical_RetailReport.ObjectId = Object_Juridical.Id
                               AND ObjectLink_Juridical_RetailReport.DescId = zc_ObjectLink_Juridical_RetailReport()
           LEFT JOIN Object AS Object_RetailReport ON Object_RetailReport.Id = ObjectLink_Juridical_RetailReport.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                               AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
           LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

           LEFT JOIN Object AS Object_JuridicalGroup ON Object_JuridicalGroup.Id = RESULT.JuridicalGroupId

           LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = RESULT.BranchId
           LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = RESULT.PaidKindId
           LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = RESULT.PartnerId

           ) AS a
        -- последнии оплаты
        LEFT JOIN tmpLastPayment_all AS tmpLastPayment
                                     ON tmpLastPayment.JuridicalId = a.JuridicalId
                                    AND tmpLastPayment.ContractId  = a.ContractId
                                    AND tmpLastPayment.PaidKindId  = a.PaidKindId
                                    AND tmpLastPayment.PartnerId   = COALESCE (a.PartnerId,0)

        LEFT JOIN (SELECT tmpLastPayment.JuridicalId
                        , tmpLastPayment.InfoMoneyId
                        , tmpLastPayment.PaidKindId
                        , tmpLastPayment.OperDate
                        , tmpLastPayment.Amount
                        , ROW_NUMBER() OVER(PARTITION BY tmpLastPayment.JuridicalId, tmpLastPayment.PaidKindId, tmpLastPayment.InfoMoneyId ORDER BY tmpLastPayment.OperDate DESC) AS Ord
                   FROM tmpLastPayment
                  ) AS tmpLastPaymentJuridical
                    ON tmpLastPaymentJuridical.JuridicalId = a.JuridicalId
                   AND tmpLastPaymentJuridical.PaidKindId  = a.PaidKindId
                   AND tmpLastPaymentJuridical.InfoMoneyId = a.InfoMoneyId
                   AND tmpLastPaymentJuridical.Ord = 1
       -- последнии приходы
        LEFT JOIN tmpLastIncome_all AS tmpLastIncome
                                     ON tmpLastIncome.JuridicalId = a.JuridicalId
                                    AND tmpLastIncome.ContractId  = a.ContractId
                                    AND tmpLastIncome.PaidKindId  = a.PaidKindId
                                    AND (tmpLastIncome.PartnerId  = a.PartnerId AND COALESCE (a.PartnerId,0) <> 0)
        LEFT JOIN (SELECT tmpLastIncome.JuridicalId
                        , tmpLastIncome.InfoMoneyId
                        , tmpLastIncome.PaidKindId
                        , tmpLastIncome.OperDateIn
                        , tmpLastIncome.AmountIn
                        , ROW_NUMBER() OVER(PARTITION BY tmpLastIncome.JuridicalId, tmpLastIncome.PaidKindId, tmpLastIncome.InfoMoneyId ORDER BY tmpLastIncome.OperDateIn DESC) AS Ord
                   FROM tmpLastIncome
                  ) AS tmpLastIncomeJuridical
                    ON tmpLastIncomeJuridical.JuridicalId = a.JuridicalId
                   AND tmpLastIncomeJuridical.PaidKindId  = a.PaidKindId
                   AND tmpLastIncomeJuridical.InfoMoneyId = a.InfoMoneyId
                   AND tmpLastIncomeJuridical.Ord = 1

     WHERE a.DebetRemains <> 0 or a.KreditRemains <> 0
        or a.SaleSumm <> 0 or a.DefermentPaymentRemains <> 0
        or a.SaleSumm1 <> 0 or a.SaleSumm2 <> 0 or a.SaleSumm3 <> 0 or a.SaleSumm4 <> 0 or a.SaleSumm5 <> 0
        or a.Remains <> 0 
    ;
    -- Конец. Добавили строковые данные. 
    -- КОНЕЦ ЗАПРОСА

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_JuridicalDefermentIncome (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.01.21         *
 13.09.14                                        * add inJuridicalGroupId
 07.09.14                                        * add Branch...
 24.08.14                                        * add Partner...
 11.07.14                                        * add RetailName
 05.07.14                                        * add zc_Movement_TransferDebtOut
 02.06.14                                        * change DefermentPaymentRemains
 20.05.14                                        * add Object_Contract_View
 12.05.14                                        * add RESULT.DelayCreditLimit
 05.05.14                                        * add inPaidKindId
 26.04.14                                        * add Object_Contract_ContractKey_View
 15.04.14                                        * add StartDate and EndDate
 10.04.14                                        * add AreaName
 09.04.14                                        * add !!!
 31.03.14                                        * add Object_Contract_View and Object_InfoMoney_View and ObjectHistory_JuridicalDetails_View and Object_PaidKind
 30.03.14                          * 
 06.02.14                          * 
*/

/*
!!!err!!!
with Object_ContractCondition_View2 as (SELECT ObjectLink_ContractCondition_Contract.ChildObjectId AS ContractId
             , ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId AS ContractConditionKindId
             , ObjectFloat_Value.ValueData AS Value
             , ObjectLink_ContractCondition_Contract.ObjectId
         FROM ObjectLink AS ObjectLink_ContractCondition_Contract
              INNER JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                                    ON ObjectLink_ContractCondition_ContractConditionKind.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                   AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
              INNER JOIN ObjectFloat AS ObjectFloat_Value 
                                     ON ObjectFloat_Value.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                    AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                                    AND ObjectFloat_Value.ValueData <> 0
              LEFT JOIN Object AS ContractCondition ON  ContractCondition.Id = ObjectLink_ContractCondition_ContractConditionKind.objectid 
         WHERE ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
           AND ContractCondition.isErased = FALSE)

SELECT * from Object_Contract_View where Contractid in (

SELECT Object_ContractCondition_View.ContractId
                                   --  , Object_ContractCondition_View.ContractConditionKindId
                               FROM Object_ContractCondition_View2 as Object_ContractCondition_View
left join ObjectLink on ObjectLink.ObjectId = Object_ContractCondition_View.ObjectId
and ObjectLink.descId = zc_ObjectLink_ContractCondition_BonusKind()

                               WHERE Object_ContractCondition_View.Value <> 0
and ObjectLink.ChildObjectId  is null
 and coalesce (ContractConditionKindId, 0)  not in (zc_Enum_ContractConditionKind_BonusPercentSale(), zc_Enum_ContractConditionKind_BonusPercentSaleReturn())
                               GROUP BY Object_ContractCondition_View.ContractId
                                      , Object_ContractCondition_View.ContractConditionKindId
having count (*) >1)
*/
-- тест
-- SELECT * FROM gpReport_JuridicalDefermentIncome (inOperDate:= CURRENT_DATE, inEmptyParam:= NULL :: TDateTime, inAccountId:= 0, inPaidKindId:= zc_Enum_PaidKind_FirstForm(),  inBranchId:= 0, inJuridicalGroupId:= null, inSession:= zfCalc_UserAdmin());
-- SELECT * FROM gpReport_JuridicalDefermentIncome (inOperDate:= CURRENT_DATE, inEmptyParam:= NULL :: TDateTime, inAccountId:= 0, inPaidKindId:= zc_Enum_PaidKind_SecondForm(), inBranchId:= 0, inJuridicalGroupId:= null, inSession:= zfCalc_UserAdmin());
