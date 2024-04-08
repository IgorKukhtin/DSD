 -- Function: gpReport_JuridicalDefermentDebet()

DROP FUNCTION IF EXISTS gpReport_JuridicalDefermentDebet (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_JuridicalDefermentDebet(
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
             , ContractJuridicalDocId Integer, ContractJuridicalDocCode Integer, ContractJuridicalDocName TVarChar
             , PersonalName TVarChar
             , PersonalTradeName TVarChar
             , PersonalCollationName TVarChar
             , PersonalTradeName_Partner TVarChar
             , StartDate TDateTime, EndDate TDateTime
             , DebetRemains TFloat, KreditRemains TFloat
             , SaleSumm TFloat--, DefermentPaymentRemains TFloat
             , SaleSumm1 TFloat, SaleSumm2 TFloat, SaleSumm3 TFloat, SaleSumm4 TFloat, SaleSumm5 TFloat, SaleSumm6 TFloat
             , Condition TVarChar, StartContractDate TDateTime, Remains TFloat
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , AreaName TVarChar, AreaName_Partner TVarChar
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
     IF NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId
                                                                  AND RoleId IN (447972 -- Просмотр СБ
                                                                               , 279795 -- Бухгалтер Киев
                                                                                )
                   )
        -- Отчет продажа/возврат - все филиалы
        AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = vbUserId AND ObjectLink_UserRole_View.RoleId = 7376335)
     THEN
         vbObjectId_Constraint_Branch:= (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 AND (COALESCE (Object_RoleAccessKeyGuide_View.AccessKeyId_PersonalService, 0) = 0  OR Object_RoleAccessKeyGuide_View.BranchId <> zc_Branch_Basis()) GROUP BY Object_RoleAccessKeyGuide_View.BranchId);
         vbObjectId_Constraint_JuridicalGroup:= (SELECT Object_RoleAccessKeyGuide_View.JuridicalGroupId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.JuridicalGroupId <> 0 AND (COALESCE (Object_RoleAccessKeyGuide_View.AccessKeyId_PersonalService, 0) = 0 OR Object_RoleAccessKeyGuide_View.BranchId <> zc_Branch_Basis()) GROUP BY Object_RoleAccessKeyGuide_View.JuridicalGroupId);
     END IF;

     -- !!!меняется параметр!!!
     IF vbObjectId_Constraint_Branch > 0 THEN inBranchId:= vbObjectId_Constraint_Branch; END IF;
     IF vbObjectId_Constraint_JuridicalGroup > 0 THEN inJuridicalGroupId:= vbObjectId_Constraint_JuridicalGroup; END IF;


     -- Выбираем остаток на дату по юр. лицам в разрезе договоров.
     -- Так же выбираем продажи и возвраты за период
      vbLenght := 7;


     -- Результат
     RETURN QUERY

     WITH tmpAccount AS (SELECT 9128 AS AccountId UNION SELECT zc_Enum_Account_30151() AS AccountId WHERE 9128 = zc_Enum_Account_30101()
                   UNION SELECT Object_Account_View.AccountId FROM Object_Account_View WHERE COALESCE (9128, 0) = 0 AND AccountGroupId = zc_Enum_AccountGroup_30000() -- Дебиторы
                        )
        , tmpListBranch_Constraint AS (SELECT ObjectLink_Contract_Personal.ObjectId AS ContractId
                                       FROM ObjectLink AS ObjectLink_Unit_Branch
                                            INNER JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                                  ON ObjectLink_Personal_Unit.ChildObjectId = ObjectLink_Unit_Branch.ObjectId
                                                                 AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                            INNER JOIN ObjectLink AS ObjectLink_Contract_Personal
                                                                  ON ObjectLink_Contract_Personal.ChildObjectId = ObjectLink_Personal_Unit.ObjectId
                                                                 AND ObjectLink_Contract_Personal.DescId = zc_ObjectLink_Contract_Personal()
                                       WHERE ObjectLink_Unit_Branch.ChildObjectId = 0
                                         AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                                       GROUP BY ObjectLink_Contract_Personal.ObjectId
                                      )
        , tmpJuridical AS (SELECT lfSelect_Object_Juridical_byGroup.JuridicalId FROM lfSelect_Object_Juridical_byGroup (257171) AS lfSelect_Object_Juridical_byGroup WHERE 257171 <> 0)

        , tmpObject_Contract_ContractKey_View AS (SELECT Object_Contract_ContractKey_View.* FROM Object_Contract_ContractKey_View)
          -- Условия договора на Дату
        , tmpContractCondition AS (SELECT Object_ContractCondition_View.ContractId
                                        , zfCalc_DetermentPaymentDate (COALESCE (ContractConditionKindId, 0), Value :: Integer, inOperDate) :: Date AS ContractDate
                                        , ContractConditionKindId
                                        , Value :: Integer AS DayCount
                                   FROM Object_ContractCondition_View
                                        INNER JOIN Object_ContractCondition_DefermentPaymentView
                                                ON Object_ContractCondition_DefermentPaymentView.ConditionKindId = Object_ContractCondition_View.ContractConditionKindId
                                   WHERE Object_ContractCondition_View.ContractConditionKindId IN (zc_Enum_ContractConditionKind_DelayDayCalendar(), zc_Enum_ContractConditionKind_DelayDayBank())
                                     AND Value <> 0
                                     AND inOperDate BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate
                                )

        , tmpContainer AS (SELECT Container.*
                                , Container.ObjectId     AS AccountId
                                , CLO_Juridical.ObjectId AS JuridicalId

                           FROM ContainerLinkObject AS CLO_Juridical
                                INNER JOIN Container ON Container.Id = CLO_Juridical.ContainerId AND Container.DescId = zc_Container_Summ()
                                INNER JOIN tmpAccount ON tmpAccount.AccountId = Container.ObjectId
                           WHERE CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                             AND (tmpAccount.AccountId > 0 OR 9128 = 0)
                           )

        , tmpMIContainer AS (SELECT MIContainer. *
                             FROM MovementItemContainer AS MIContainer
                             WHERE MIContainer.ContainerId IN (SELECT DISTINCT tmpContainer.Id FROM tmpContainer)
                               AND MIContainer.OperDate >= inOperDate - INTERVAL '1 YEAR'
                             )
          -- выбираем всех клиентов с долгами на начало дня inOperDate
        , tmpRemains AS (SELECT Container.Id
                              , Container.ObjectId     AS AccountId
                              , Container.JuridicalId
                              , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS Remains
                         FROM tmpContainer AS Container
                              LEFT JOIN tmpMIContainer AS MIContainer
                                                       ON MIContainer.ContainerId = Container.Id
                                                      AND MIContainer.OperDate >= inOperDate
                         GROUP BY Container.Id
                                , Container.ObjectId
                                , Container.Amount
                                , Container.JuridicalId
                         HAVING (Container.Amount - COALESCE (SUM (MIContainer.Amount), 0)) <> 0
                        )

        , tmpCLO AS (SELECT *
                     FROM ContainerLinkObject
                     WHERE ContainerLinkObject.ContainerId IN (SELECT DISTINCT tmpRemains.Id FROM tmpRemains)
                       AND ContainerLinkObject.DescId IN (zc_ContainerLinkObject_PaidKind()
                                                        , zc_ContainerLinkObject_Branch()
                                                        , zc_ContainerLinkObject_Contract()
                                                        , zc_ContainerLinkObject_Partner()
                                                        , zc_ContainerLinkObject_InfoMoney()
                                                        )
                    )

        , tmpContractCondition_CreditLimit AS (SELECT Object_ContractCondition_View.ContractId
                                                    , Object_ContractCondition_View.PaidKindId
                                                    , Value AS DelayCreditLimit
                                               FROM Object_ContractCondition_View
                                               WHERE Object_ContractCondition_View.ContractConditionKindId = zc_Enum_ContractConditionKind_DelayCreditLimit()
                                              )

          , tmpRemains_1 AS (SELECT tmpRemains.Id
                                  , tmpRemains.AccountId
                                  , tmpRemains.JuridicalId
                                  , tmpRemains.Remains

                                  , CASE WHEN Object_Contract.IsErased = FALSE AND COALESCE (ObjectLink_Contract_ContractStateKind.ChildObjectId, 0) <> zc_Enum_ContractStateKind_Close() THEN COALESCE (ContractCondition_CreditLimit.DelayCreditLimit, 0) ELSE 0 END AS DelayCreditLimit

                                  , COALESCE (View_Contract_ContractKey.ContractId_Key, CLO_Contract.ObjectId) AS ContractId
                                  , ContractCondition_DefermentPayment.ContractConditionKindId
                                  , CLO_InfoMoney.ObjectId AS InfoMoneyId
                                  , CLO_PaidKind.ObjectId  AS PaidKindId
                                  , CLO_Partner.ObjectId   AS PartnerId
                                  , CLO_Branch.ObjectId    AS BranchId
                                  , ObjectLink_Juridical_JuridicalGroup.ChildObjectId AS JuridicalGroupId

                                  , COALESCE (ContractCondition_DefermentPayment.DayCount, 0) AS DayCount
                                  , COALESCE (ContractCondition_DefermentPayment.ContractDate, inOperDate) AS ContractDate
                             FROM tmpRemains
                                 LEFT JOIN tmpCLO AS CLO_PaidKind
                                                  ON CLO_PaidKind.ContainerId = tmpRemains.Id
                                                 AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                                 LEFT JOIN tmpCLO AS CLO_Branch
                                                  ON CLO_Branch.ContainerId = tmpRemains.Id
                                                 AND CLO_Branch.DescId = zc_ContainerLinkObject_Branch()
                                 LEFT JOIN tmpCLO AS CLO_Contract
                                                  ON CLO_Contract.ContainerId = tmpRemains.Id
                                                 AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()
                                 LEFT JOIN tmpCLO AS CLO_Partner
                                                  ON CLO_Partner.ContainerId = tmpRemains.Id
                                                 AND CLO_Partner.DescId = zc_ContainerLinkObject_Partner()
                                 LEFT JOIN tmpCLO AS CLO_InfoMoney
                                                  ON CLO_InfoMoney.ContainerId = tmpRemains.Id
                                                 AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()

                                 LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                                                      ON ObjectLink_Juridical_JuridicalGroup.ObjectId = tmpRemains.JuridicalId
                                                     AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()

                                 -- !!!Группируем Договора!!!
                                 LEFT JOIN tmpObject_Contract_ContractKey_View AS View_Contract_ContractKey ON View_Contract_ContractKey.ContractId = CLO_Contract.ObjectId
                                                                                                           AND inSession <> '5'

                                 LEFT JOIN tmpContractCondition AS ContractCondition_DefermentPayment
                                                                ON ContractCondition_DefermentPayment.ContractId = COALESCE (View_Contract_ContractKey.ContractId_Key, CLO_Contract.ObjectId)

                                 LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = CLO_Contract.ObjectId
                                 LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractStateKind
                                                      ON ObjectLink_Contract_ContractStateKind.ObjectId = CLO_Contract.ObjectId
                                                     AND ObjectLink_Contract_ContractStateKind.DescId = zc_ObjectLink_Contract_ContractStateKind()

                                 LEFT JOIN tmpContractCondition_CreditLimit AS ContractCondition_CreditLimit
                                                                            ON ContractCondition_CreditLimit.ContractId = CLO_Contract.ObjectId
                                                                           AND ContractCondition_CreditLimit.PaidKindId = CLO_PaidKind.ObjectId


                            )

        , tmpRemains_All AS (SELECT tmpRemains.Id
                                  , tmpRemains.AccountId
                                  , tmpRemains.JuridicalId
                                  , tmpRemains.Remains

                                  , tmpRemains.DelayCreditLimit

                                  , tmpRemains.ContractId
                                  , tmpRemains.ContractConditionKindId
                                  , tmpRemains.InfoMoneyId
                                  , tmpRemains.PaidKindId
                                  , tmpRemains.PartnerId
                                  , tmpRemains.BranchId
                                  , tmpRemains.JuridicalGroupId

                                  , tmpRemains.DayCount
                                  , tmpRemains.ContractDate
                             FROM tmpRemains_1 AS tmpRemains
                             --почему-то когда добавляю условия тогда отчет работает 30 минут (( без условий до 40 секунд , не понимаю. поставила в самом конце - чуть больше минуты отчет отрабатывает
      --                       WHERE (tmpRemains.PaidKindId = inPaidKindId OR inPaidKindId = 0)
      --                         AND (tmpRemains.BranchId = inBranchId OR COALESCE (inBranchId, 0) = 0)
                             )

/*
1-30 день
31-60 день
61-90 день
91-180 день
181-366 день
Больше 366 дней
*/
         -- продажи по клиентам у которых есть долг
       , tmpSale_all AS (SELECT Container.Id
                              , Container.Remains
                                -- за 30 дней
                              , SUM (CASE WHEN MIContainer.OperDate BETWEEN inOperDate - INTERVAL '30 DAY' AND inOperDate - INTERVAL '1 DAY' AND MIContainer.MovementDescId = zc_Movement_Sale() THEN MIContainer.Amount
                                          WHEN MIContainer.OperDate BETWEEN inOperDate - INTERVAL '30 DAY' AND inOperDate - INTERVAL '1 DAY' AND MIContainer.MovementDescId IN (zc_Movement_TransferDebtOut(), zc_Movement_Income()) AND MIContainer.isActive = TRUE THEN MIContainer.Amount
                                          WHEN MIContainer.OperDate BETWEEN inOperDate - INTERVAL '30 DAY' AND inOperDate - INTERVAL '1 DAY' AND MIContainer.MovementDescId IN (zc_Movement_SendDebt()) AND MIContainer.isActive = TRUE THEN MIContainer.Amount
                                          ELSE 0
                                     END) AS SaleSumm_30
                                -- за 31 -60 дней
                              , SUM (CASE WHEN MIContainer.OperDate BETWEEN inOperDate - INTERVAL '60 DAY' AND inOperDate - INTERVAL '31 DAY' AND MIContainer.MovementDescId = zc_Movement_Sale() THEN MIContainer.Amount
                                          WHEN MIContainer.OperDate BETWEEN inOperDate - INTERVAL '60 DAY' AND inOperDate - INTERVAL '31 DAY' AND MIContainer.MovementDescId IN (zc_Movement_TransferDebtOut(), zc_Movement_Income()) AND MIContainer.isActive = TRUE THEN MIContainer.Amount
                                          WHEN MIContainer.OperDate BETWEEN inOperDate - INTERVAL '60 DAY' AND inOperDate - INTERVAL '31 DAY' AND MIContainer.MovementDescId IN (zc_Movement_SendDebt()) AND MIContainer.isActive = TRUE THEN MIContainer.Amount
                                          ELSE 0
                                     END) AS SaleSumm_60
                                -- за 61-90 дней
                              , SUM (CASE WHEN MIContainer.OperDate BETWEEN inOperDate - INTERVAL '90 DAY' AND inOperDate - INTERVAL '61 DAY' AND MIContainer.MovementDescId = zc_Movement_Sale() THEN MIContainer.Amount
                                          WHEN MIContainer.OperDate BETWEEN inOperDate - INTERVAL '90 DAY' AND inOperDate - INTERVAL '61 DAY' AND MIContainer.MovementDescId IN (zc_Movement_TransferDebtOut(), zc_Movement_Income()) AND MIContainer.isActive = TRUE THEN MIContainer.Amount
                                          WHEN MIContainer.OperDate BETWEEN inOperDate - INTERVAL '90 DAY' AND inOperDate - INTERVAL '61 DAY' AND MIContainer.MovementDescId IN (zc_Movement_SendDebt()) AND MIContainer.isActive = TRUE THEN MIContainer.Amount
                                          ELSE 0
                                     END) AS SaleSumm_90
                                -- за 91-180 дней
                              , SUM (CASE WHEN MIContainer.OperDate BETWEEN inOperDate - INTERVAL '180 DAY' AND inOperDate - INTERVAL '91 DAY' AND MIContainer.MovementDescId = zc_Movement_Sale() THEN MIContainer.Amount
                                          WHEN MIContainer.OperDate BETWEEN inOperDate - INTERVAL '180 DAY' AND inOperDate - INTERVAL '91 DAY' AND MIContainer.MovementDescId IN (zc_Movement_TransferDebtOut(), zc_Movement_Income()) AND MIContainer.isActive = TRUE THEN MIContainer.Amount
                                          WHEN MIContainer.OperDate BETWEEN inOperDate - INTERVAL '180 DAY' AND inOperDate - INTERVAL '91 DAY' AND MIContainer.MovementDescId IN (zc_Movement_SendDebt()) AND MIContainer.isActive = TRUE THEN MIContainer.Amount
                                          ELSE 0
                                     END) AS SaleSumm_180
                                -- за 181-366 дней
                              , SUM (CASE WHEN MIContainer.OperDate BETWEEN inOperDate - INTERVAL '366 DAY' AND inOperDate - INTERVAL '181 DAY' AND MIContainer.MovementDescId = zc_Movement_Sale() THEN MIContainer.Amount
                                          WHEN MIContainer.OperDate BETWEEN inOperDate - INTERVAL '366 DAY' AND inOperDate - INTERVAL '181 DAY' AND MIContainer.MovementDescId IN (zc_Movement_TransferDebtOut(), zc_Movement_Income()) AND MIContainer.isActive = TRUE THEN MIContainer.Amount
                                          WHEN MIContainer.OperDate BETWEEN inOperDate - INTERVAL '366 DAY' AND inOperDate - INTERVAL '181 DAY' AND MIContainer.MovementDescId IN (zc_Movement_SendDebt()) AND MIContainer.isActive = TRUE THEN MIContainer.Amount
                                          ELSE 0
                                     END) AS SaleSumm_366   
                                -- более 366 дней
                             /* , SUM (CASE WHEN MIContainer.OperDate < inOperDate - INTERVAL '366 DAY' AND MIContainer.MovementDescId = zc_Movement_Sale() THEN MIContainer.Amount
                                          WHEN MIContainer.OperDate < inOperDate - INTERVAL '366 DAY' AND MIContainer.MovementDescId IN (zc_Movement_TransferDebtOut(), zc_Movement_Income()) AND MIContainer.isActive = TRUE THEN MIContainer.Amount
                                          WHEN MIContainer.OperDate < inOperDate - INTERVAL '366 DAY' AND MIContainer.MovementDescId IN (zc_Movement_SendDebt()) AND MIContainer.isActive = TRUE THEN MIContainer.Amount
                                          ELSE 0
                                     END) AS SaleSumm_367
                             */
                         FROM tmpRemains_all AS Container
                              INNER JOIN tmpMIContainer AS MIContainer
                                                        ON MIContainer.ContainerId = Container.Id
                                                     --AND MIContainer.OperDate BETWEEN inOperDate - INTERVAL '60 DAY' AND inOperDate
                         GROUP BY Container.Id
                                , Container.Remains
                        )
   , tmpData_All_All AS (SELECT tmpRemains_all.AccountId
                              , tmpRemains_all.JuridicalId
                              , tmpRemains_all.DelayCreditLimit
                              , tmpRemains_all.ContractId
                              , tmpRemains_all.ContractConditionKindId
                              , tmpRemains_all.InfoMoneyId
                              , tmpRemains_all.PaidKindId
                              , tmpRemains_all.PartnerId
                              , tmpRemains_all.BranchId
                              , tmpRemains_all.JuridicalGroupId

                              , tmpRemains_all.DayCount
                              , tmpRemains_all.ContractDate

                              , SUM (COALESCE (tmpRemains_all.Remains,   0))                        AS Remains
                              , SUM (COALESCE (tmpSale_all.SaleSumm_30,  0))                        AS SaleSumm_30
                              , SUM (COALESCE (tmpSale_all.SaleSumm_60,  0))                        AS SaleSumm_60
                              , SUM (COALESCE (tmpSale_all.SaleSumm_90,  0))                        AS SaleSumm_90
                              , SUM (COALESCE (tmpSale_all.SaleSumm_180, 0))                        AS SaleSumm_180
                              , SUM (COALESCE (tmpSale_all.SaleSumm_366, 0))                        AS SaleSumm_366
                         FROM tmpRemains_all
                              LEFT JOIN tmpSale_all ON tmpSale_all.Id = tmpRemains_all.Id
                         GROUP BY tmpRemains_all.AccountId
                                , tmpRemains_all.JuridicalId
                                , tmpRemains_all.DelayCreditLimit
                                , tmpRemains_all.ContractId
                                , tmpRemains_all.ContractConditionKindId
                                , tmpRemains_all.InfoMoneyId
                                , tmpRemains_all.PaidKindId
                                , tmpRemains_all.PartnerId
                                , tmpRemains_all.BranchId
                                , tmpRemains_all.JuridicalGroupId
                                , tmpRemains_all.DayCount
                                , tmpRemains_all.ContractDate
                         )
       , tmpData_All AS (SELECT tmpRemains_all.AccountId
                              , tmpRemains_all.JuridicalId
                              , tmpRemains_all.DelayCreditLimit
                              , tmpRemains_all.ContractId
                              , tmpRemains_all.ContractConditionKindId
                              , tmpRemains_all.InfoMoneyId
                              , tmpRemains_all.PaidKindId
                              , tmpRemains_all.PartnerId
                              , tmpRemains_all.BranchId
                              , tmpRemains_all.JuridicalGroupId

                              , tmpRemains_all.DayCount
                              , tmpRemains_all.ContractDate

                              , tmpRemains_all.Remains

                              , CASE WHEN tmpRemains_all.Remains >= tmpRemains_all.SaleSumm_30
                                          THEN tmpRemains_all.SaleSumm_30
                                     WHEN tmpRemains_all.Remains > 0
                                          THEN tmpRemains_all.Remains
                                     ELSE 0
                                END AS SaleSumm_30

                              , CASE WHEN tmpRemains_all.Remains >= tmpRemains_all.SaleSumm_30 + tmpRemains_all.SaleSumm_60
                                          THEN tmpRemains_all.SaleSumm_60
                                     WHEN tmpRemains_all.Remains > tmpRemains_all.SaleSumm_30
                                          THEN tmpRemains_all.Remains - tmpRemains_all.SaleSumm_30
                                     ELSE 0
                                END AS SaleSumm_60

                              , CASE WHEN tmpRemains_all.Remains >= tmpRemains_all.SaleSumm_30 + tmpRemains_all.SaleSumm_60 + tmpRemains_all.SaleSumm_90
                                          THEN tmpRemains_all.SaleSumm_90
                                     WHEN tmpRemains_all.Remains > tmpRemains_all.SaleSumm_60
                                          THEN tmpRemains_all.Remains - tmpRemains_all.SaleSumm_30 - tmpRemains_all.SaleSumm_60
                                      ELSE 0
                                END AS SaleSumm_90

                              , CASE WHEN tmpRemains_all.Remains >= tmpRemains_all.SaleSumm_30 + tmpRemains_all.SaleSumm_60 + tmpRemains_all.SaleSumm_90 + tmpRemains_all.SaleSumm_180
                                          THEN tmpRemains_all.SaleSumm_180
                                     WHEN tmpRemains_all.Remains > tmpRemains_all.SaleSumm_30 + tmpRemains_all.SaleSumm_60 + tmpRemains_all.SaleSumm_90
                                          THEN tmpRemains_all.Remains - tmpRemains_all.SaleSumm_30 - tmpRemains_all.SaleSumm_60 - tmpRemains_all.SaleSumm_90
                                      ELSE 0
                                END AS SaleSumm_180

                              , CASE WHEN tmpRemains_all.Remains >= tmpRemains_all.SaleSumm_30 + tmpRemains_all.SaleSumm_60 + tmpRemains_all.SaleSumm_90 + tmpRemains_all.SaleSumm_180 + tmpRemains_all.SaleSumm_366
                                          THEN tmpRemains_all.SaleSumm_366
                                     WHEN tmpRemains_all.Remains > tmpRemains_all.SaleSumm_30 + tmpRemains_all.SaleSumm_60 + tmpRemains_all.SaleSumm_90 + tmpRemains_all.SaleSumm_180
                                          THEN tmpRemains_all.Remains - tmpRemains_all.SaleSumm_30 - tmpRemains_all.SaleSumm_60 - tmpRemains_all.SaleSumm_90 - tmpRemains_all.SaleSumm_180
                                      ELSE 0
                                END AS SaleSumm_366

                              , CASE WHEN tmpRemains_all.Remains >= tmpRemains_all.SaleSumm_30 + tmpRemains_all.SaleSumm_60 + tmpRemains_all.SaleSumm_90 + tmpRemains_all.SaleSumm_180 + tmpRemains_all.SaleSumm_366
                                          THEN tmpRemains_all.Remains - tmpRemains_all.SaleSumm_30 -tmpRemains_all.SaleSumm_60 - tmpRemains_all.SaleSumm_90 - tmpRemains_all.SaleSumm_180 - tmpRemains_all.SaleSumm_366
                                     ELSE 0
                                END AS SaleSumm

                         FROM tmpData_All_All AS tmpRemains_all
                        )

        , tmpObject_Account_View AS (SELECT Object_Account_View.* FROM Object_Account_View)
        , tmpObject_Contract_View AS (SELECT Object_Contract_View.* FROM Object_Contract_View)
        , tmpObject_InfoMoney_View AS (SELECT Object_InfoMoney_View.* FROM Object_InfoMoney_View)

        , tmpData AS (SELECT
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
                           , Object_JuridicalDocument.Id            AS ContractJuridicalDocId
                           , Object_JuridicalDocument.ObjectCode    AS ContractJuridicalDocCode
                           , Object_JuridicalDocument.ValueData     AS ContractJuridicalDocName
                           , Object_Personal.ValueData              AS PersonalName
                           , Object_PersonalTrade.ValueData         AS PersonalTradeName
                           , Object_PersonalCollation.ValueData     AS PersonalCollationName
                           , Object_PersonalTrade_Partner.ValueData AS PersonalTradeName_Partner
                           , View_Contract.StartDate
                           , View_Contract.EndDate

                           , (CASE WHEN 1 * tmpData_All.Remains > 0 THEN 1 * tmpData_All.Remains ELSE 0 END) ::TFloat AS DebetRemains
                           , (CASE WHEN 1 * tmpData_All.Remains > 0 THEN 0 ELSE -1 * tmpData_All.Remains END)::TFloat AS KreditRemains

                           , (COALESCE (tmpData_All.SaleSumm_30,  0)
                            + COALESCE (tmpData_All.SaleSumm_60,  0)
                            + COALESCE (tmpData_All.SaleSumm_90,  0)
                            + COALESCE (tmpData_All.SaleSumm_180, 0)
                            + COALESCE (tmpData_All.SaleSumm_366, 0)
                            + COALESCE (tmpData_All.SaleSumm,     0)
                             ) :: TFloat AS SaleSumm

                           , tmpData_All.SaleSumm_30  ::TFloat AS SaleSumm1
                           
                           , tmpData_All.SaleSumm_60  ::TFloat AS SaleSumm2

                           , tmpData_All.SaleSumm_90  ::TFloat AS SaleSumm3

                           , tmpData_All.SaleSumm_180 ::TFloat AS SaleSumm4

                           , tmpData_All.SaleSumm_366 ::TFloat AS SaleSumm5

                           , tmpData_All.SaleSumm     ::TFloat AS SaleSumm6

                           , (tmpData_All.DayCount||' '|| CASE WHEN tmpData_All.ContractConditionKindId = zc_Enum_ContractConditionKind_DelayDayCalendar()
                                                               THEN 'К.дн.'

                                                          WHEN tmpData_All.ContractConditionKindId = zc_Enum_ContractConditionKind_DelayDayBank()
                                                               THEN 'Б.дн.'

                                                          ELSE ''
                                                     END
                                             ||' '|| CASE WHEN tmpData_All.DelayCreditLimit <> 0
                                                               THEN '+ ' || TRIM (to_char (tmpData_All.DelayCreditLimit, '999 999 999 999 999D99')) || 'грн.'
                                                          ELSE ''
                                                     END
                              )::TVarChar AS Condition -- Object_ContractConditionKind.ValueData
                           , tmpData_All.ContractDate :: TDateTime AS StartContractDate
                           , (-1 * tmpData_All.Remains) :: TFloat AS Remains

                              , Object_InfoMoney_View.InfoMoneyGroupName
                              , Object_InfoMoney_View.InfoMoneyDestinationName
                              , Object_InfoMoney_View.InfoMoneyCode
                              , Object_InfoMoney_View.InfoMoneyName

                              , Object_Area.ValueData AS AreaName
                              , Object_Area_Partner.ValueData AS AreaName_Partner

                          FROM tmpData_All

                               LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpData_All.JuridicalId
                               LEFT JOIN tmpObject_Account_View AS Object_Account_View ON Object_Account_View.AccountId = tmpData_All.AccountId
                               LEFT JOIN tmpObject_Contract_View AS View_Contract ON View_Contract.ContractId = tmpData_All.ContractId

                               LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                                    ON ObjectLink_Partner_PersonalTrade.ObjectId = tmpData_All.PartnerId
                                                   AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                               LEFT JOIN Object AS Object_PersonalTrade_Partner ON Object_PersonalTrade_Partner.Id = ObjectLink_Partner_PersonalTrade.ChildObjectId

                               LEFT JOIN ObjectLink AS ObjectLink_Partner_Area
                                                    ON ObjectLink_Partner_Area.ObjectId = tmpData_All.PartnerId
                                                   AND ObjectLink_Partner_Area.DescId = zc_ObjectLink_Partner_Area()
                               LEFT JOIN Object AS Object_Area_Partner ON Object_Area_Partner.Id = ObjectLink_Partner_Area.ChildObjectId

                               LEFT JOIN ObjectLink AS ObjectLink_Contract_Personal
                                                   ON ObjectLink_Contract_Personal.ObjectId = tmpData_All.ContractId
                                                  AND ObjectLink_Contract_Personal.DescId = zc_ObjectLink_Contract_Personal()
                               LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_Contract_Personal.ChildObjectId

                               LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalTrade
                                                    ON ObjectLink_Contract_PersonalTrade.ObjectId = tmpData_All.ContractId
                                                   AND ObjectLink_Contract_PersonalTrade.DescId = zc_ObjectLink_Contract_PersonalTrade()
                               LEFT JOIN Object AS Object_PersonalTrade ON Object_PersonalTrade.Id = ObjectLink_Contract_PersonalTrade.ChildObjectId

                               LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalCollation
                                                    ON ObjectLink_Contract_PersonalCollation.ObjectId = tmpData_All.ContractId
                                                   AND ObjectLink_Contract_PersonalCollation.DescId = zc_ObjectLink_Contract_PersonalCollation()
                               LEFT JOIN Object AS Object_PersonalCollation ON Object_PersonalCollation.Id = ObjectLink_Contract_PersonalCollation.ChildObjectId

                               LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalDocument
                                                    ON ObjectLink_Contract_JuridicalDocument.ObjectId = tmpData_All.ContractId
                                                   AND ObjectLink_Contract_JuridicalDocument.DescId = zc_ObjectLink_Contract_JuridicalDocument()
                               LEFT JOIN Object AS Object_JuridicalDocument ON Object_JuridicalDocument.Id = ObjectLink_Contract_JuridicalDocument.ChildObjectId

                               LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id

                               LEFT JOIN tmpObject_InfoMoney_View AS Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = tmpData_All.InfoMoneyId

                               LEFT JOIN ObjectLink AS ObjectLink_Contract_Area
                                                    ON ObjectLink_Contract_Area.ObjectId = tmpData_All.ContractId
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

                               LEFT JOIN Object AS Object_JuridicalGroup ON Object_JuridicalGroup.Id = tmpData_All.JuridicalGroupId

                               LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpData_All.BranchId
                               LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpData_All.PaidKindId
                               LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpData_All.PartnerId
                          )


           -- Результат
           SELECT tmpData.AccountId, tmpData.AccountName, tmpData.JuridicalId, tmpData.JuridicalName, tmpData.RetailName, tmpData.RetailName_main, tmpData.OKPO, tmpData.JuridicalGroupName
                   , tmpData.PartnerId, tmpData.PartnerCode, tmpData.PartnerName TVarChar
                   , tmpData.BranchId, tmpData.BranchCode, tmpData.BranchName
                   , tmpData.PaidKindId, tmpData.PaidKindName
                   , tmpData.ContractId, tmpData.ContractCode, tmpData.ContractNumber
                   , tmpData.ContractTagGroupName, tmpData.ContractTagName, tmpData.ContractStateKindCode
                   , tmpData.ContractJuridicalDocId, tmpData.ContractJuridicalDocCode, tmpData.ContractJuridicalDocName
                   , tmpData.PersonalName
                   , tmpData.PersonalTradeName
                   , tmpData.PersonalCollationName
                   , tmpData.PersonalTradeName_Partner
                   , tmpData.StartDate, tmpData.EndDate
                   , tmpData.DebetRemains, tmpData.KreditRemains
                   , tmpData.SaleSumm--, tmpData.DefermentPaymentRemains
                   , tmpData.SaleSumm1, tmpData.SaleSumm2, tmpData.SaleSumm3, tmpData.SaleSumm4, tmpData.SaleSumm5, tmpData.SaleSumm6
                   , tmpData.Condition, tmpData.StartContractDate, tmpData.Remains
                   , tmpData.InfoMoneyGroupName, tmpData.InfoMoneyDestinationName, tmpData.InfoMoneyCode, tmpData.InfoMoneyName
                   , tmpData.AreaName, tmpData.AreaName_Partner
           FROM tmpData
           WHERE (tmpData.DebetRemains <> 0 OR tmpData.KreditRemains <> 0
               OR tmpData.SaleSumm <> 0 --or tmpData.DefermentPaymentRemains <> 0
               OR tmpData.SaleSumm1 <> 0 OR tmpData.SaleSumm2 <> 0 OR tmpData.SaleSumm3 <> 0 OR tmpData.SaleSumm4 <> 0 OR tmpData.SaleSumm5 <> 0 OR tmpData.SaleSumm6 <> 0
               OR tmpData.Remains <> 0
                 )
             AND (tmpData.PaidKindId = inPaidKindId OR inPaidKindId = 0)
             AND (tmpData.BranchId = inBranchId OR inBranchId = 0)
            ;

    -- Конец. Добавили строковые данные.
    -- КОНЕЦ ЗАПРОСА

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И. 
 27.08.22         *
 10.07.20         * gpReport_JuridicalDefermentDebet
*/

-- тест zc_Enum_PaidKind_SecondForm
-- SELECT * FROM gpReport_JuridicalDefermentDebet (inOperDate:= CURRENT_DATE, inEmptyParam:= NULL :: TDateTime, inAccountId:= 0, inPaidKindId:= zc_Enum_PaidKind_FirstForm(),  inBranchId:= 0, inJuridicalGroupId:= null, inSession:= zfCalc_UserAdmin());
-- SELECT * FROM gpReport_JuridicalDefermentDebet (inOperDate:= CURRENT_DATE, inEmptyParam:= NULL :: TDateTime, inAccountId:= 9128 , inPaidKindId:= zc_Enum_PaidKind_FirstForm(), inBranchId:= 0, inJuridicalGroupId:= 0, inSession:= zfCalc_UserAdmin());
