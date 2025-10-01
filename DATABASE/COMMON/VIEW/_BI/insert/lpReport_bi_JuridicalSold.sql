-- Function: lpReport_bi_JuridicalSold()

DROP FUNCTION IF EXISTS lpReport_bi_JuridicalSold (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpReport_bi_JuridicalSold(
    IN inStartDate                TDateTime , --
    IN inEndDate                  TDateTime , --
    IN inAccountId                Integer,    -- Счет
    IN inInfoMoneyId              Integer,    -- Управленческая статья
    IN inInfoMoneyGroupId         Integer,    -- Группа управленческих статей
    IN inInfoMoneyDestinationId   Integer,    --
    IN inPaidKindId               Integer   , --
    IN inIsPartionMovement        Boolean   ,
    IN inUserId                  Integer    -- сессия пользователя
)
RETURNS TABLE (ContainerId Integer, OperDate TDateTime
             , JuridicalCode Integer, JuridicalName TVarChar, JuridicalGroupName TVarChar
             , RetailName TVarChar, RetailReportName TVarChar
             , PartnerCode Integer, PartnerName TVarChar
             , JuridicalPartnerlName TVarChar

             , BranchCode Integer, BranchName TVarChar, BranchName_personal TVarChar, BranchName_personal_trade TVarChar

             , ContractCode Integer, ContractNumber TVarChar

             , PaidKindName TVarChar, AccountName TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar

             , CurrencyName TVarChar

             --, ContractConditionKindName TVarChar, ContractConditionValue TFloat

             , PartionMovementId Integer, PartionMovementName TVarChar
             -- , PaymentDate TDateTime

             , AccountId Integer, JuridicalId Integer, PartnerId Integer, InfoMoneyId Integer, ContractId Integer, PaidKindId Integer, BranchId Integer

             , StartSumm TFloat, EndSumm TFloat
             , DebetSumm TFloat, KreditSumm TFloat

             , IncomeSumm TFloat, ReturnOutSumm TFloat

             , SaleSumm TFloat, SaleRealSumm TFloat, SaleSumm_10300 TFloat, SaleRealSumm_total TFloat
             , ReturnInSumm TFloat, ReturnInRealSumm TFloat, ReturnInSumm_10300 TFloat, ReturnInRealSumm_total TFloat

             , PriceCorrectiveSumm TFloat, ChangePercentSumm TFloat
             , MoneySumm TFloat, ServiceSumm TFloat, ServiceRealSumm TFloat, ServiceSumm_pls TFloat
             , TransferDebtSumm TFloat, SendDebtSumm TFloat, ChangeCurrencySumm TFloat, OtherSumm TFloat
              )
AS
$BODY$
   DECLARE vbIsInfoMoneyDestination_21500 Boolean;
BEGIN
     -- Разрешен просмотр долги Маркетинг - НАЛ
     vbIsInfoMoneyDestination_21500:= EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS tmp WHERE tmp.UserId = inUserId AND tmp.RoleId = 8852398);


     -- Результат
     RETURN QUERY
     WITH -- НЕ Разрешен просмотр долги Маркетинг - НАЛ
          tmpInfoMoney_not AS (SELECT Object_InfoMoney_View.*
                               FROM Object_InfoMoney_View
                               WHERE Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21500() -- Маркетинг
                                 AND vbIsInfoMoneyDestination_21500 = FALSE
                              )

        , tmpContainer AS (SELECT Container.Id           AS ContainerId
                                , Container.ObjectId     AS AccountId
                                , Container.Amount       AS Amount
                                , CLO_Juridical.ObjectId AS JuridicalId
                                , CLO_InfoMoney.ObjectId AS InfoMoneyId
                                , CLO_PaidKind.ObjectId  AS PaidKindId
                                , CLO_Contract.ObjectId  AS ContractId
                                , CLO_Branch.ObjectId    AS BranchId
                                , CASE WHEN inIsPartionMovement = FALSE THEN CLO_PartionMovement.ObjectId ELSE 0 END AS PartionMovementId
                                , COALESCE (CLO_Currency.ObjectId, 0)     AS CurrencyId

                           FROM ContainerLinkObject AS CLO_Juridical
                                INNER JOIN Container ON Container.Id = CLO_Juridical.ContainerId AND Container.DescId = zc_Container_Summ()
                                LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                                              ON CLO_InfoMoney.ContainerId = Container.Id AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId             = CLO_InfoMoney.ObjectId
                                LEFT JOIN ContainerLinkObject AS CLO_Branch
                                                              ON CLO_Branch.ContainerId = Container.Id
                                                             AND CLO_Branch.DescId = zc_ContainerLinkObject_Branch()
                                LEFT JOIN ContainerLinkObject AS CLO_PaidKind
                                                              ON CLO_PaidKind.ContainerId = Container.Id
                                                             AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                                LEFT JOIN ContainerLinkObject AS CLO_Contract
                                                              ON CLO_Contract.ContainerId = Container.Id
                                                             AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()
                                LEFT JOIN ContainerLinkObject AS CLO_PartionMovement
                                                              ON CLO_PartionMovement.ContainerId = Container.Id
                                                             AND CLO_PartionMovement.DescId = zc_ContainerLinkObject_PartionMovement()

                                LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                                                     ON ObjectLink_Juridical_JuridicalGroup.ObjectId = CLO_Juridical.ObjectId
                                                    AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()

                                LEFT JOIN ContainerLinkObject AS CLO_Currency
                                                              ON CLO_Currency.ContainerId = CLO_Juridical.ContainerId
                                                             AND CLO_Currency.DescId = zc_ContainerLinkObject_Currency()

                                LEFT JOIN tmpInfoMoney_not ON tmpInfoMoney_not.InfoMoneyId = CLO_InfoMoney.ObjectId

                           WHERE CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                             AND (Container.ObjectId                           = inAccountId              OR COALESCE (inAccountId, 0)              = 0)
                             AND (CLO_PaidKind.ObjectId                        = inPaidKindId             OR COALESCE (inPaidKindId, 0)             = 0)
                             AND (Object_InfoMoney_View.InfoMoneyGroupId       = inInfoMoneyGroupId       OR COALESCE (inInfoMoneyGroupId, 0)       = 0)
                             AND (Object_InfoMoney_View.InfoMoneyDestinationId = inInfoMoneyDestinationId OR COALESCE (inInfoMoneyDestinationId, 0) = 0)
                             AND (Object_InfoMoney_View.InfoMoneyId            = inInfoMoneyId            OR COALESCE (inInfoMoneyId, 0)            = 0)
                             -- НЕ Разрешен просмотр долги Маркетинг - НАЛ
                             AND (tmpInfoMoney_not.InfoMoneyId IS NULL OR COALESCE (CLO_PaidKind.ObjectId, 0) <> zc_Enum_PaidKind_SecondForm())
-- and Container.Id = 1230685
                          )

          -- сумма движения в валюте баланса
        , Operation_all AS (SELECT tmpContainer.ContainerId

                                   -- OperDate
                                 , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.OperDate ELSE inEndDate + INTERVAL '1 DAY' END AS OperDate

                                   -- Summ_add - все остальные обороты после ...
                                 , SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END) AS Summ_add

                                   -- DebetSumm
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END ELSE 0 END)      AS DebetSumm
                                   -- KreditSumm
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.Amount < 0 THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END) AS KreditSumm

                                   -- IncomeSumm
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_IncomeAsset()) AND MIContainer.Amount < 0 THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END) AS IncomeSumm
                                   -- ReturnOutSumm
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId = zc_Movement_ReturnOut() THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS ReturnOutSumm

                                   -- Продажа (бухг.)
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate
                                             THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_TransferDebtOut())
                                                       THEN MIContainer.Amount
                                                       ELSE 0
                                                  END
                                             ELSE 0
                                        END) AS SaleSumm

                                   -- Продажа (факт с уч. скидки)
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_PriceCorrective()) THEN MIContainer.Amount ELSE 0 END ELSE 0 END)
                                 + SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Service()) AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10300() THEN MIContainer.Amount ELSE 0 END ELSE 0 END)
                                   AS SaleRealSumm

                                   -- Cкидка (продажа)
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate
                                             THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_Service(), zc_Movement_PriceCorrective()) AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10300()
                                                       THEN -1 * MIContainer.Amount
                                                       ELSE 0
                                                 END
                                             ELSE 0
                                        END) AS SaleSumm_10300

                                   -- Перевод долга
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_TransferDebtOut(), zc_Movement_TransferDebtIn()) THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS TransferDebtSumm
                                   -- Вз-зачет
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_SendDebt()) THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END) AS SendDebtSumm

                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_ReturnIn(), zc_Movement_TransferDebtIn()) THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END) AS ReturnInSumm
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_ReturnIn()) THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END) AS ReturnInRealSumm
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_ReturnIn()) AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10300() THEN 1 * MIContainer.Amount ELSE 0 END ELSE 0 END) AS ReturnInSumm_10300

                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_PriceCorrective()) THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS PriceCorrectiveSumm
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_ChangePercent()) THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END)   AS ChangePercentSumm
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Cash(), zc_Movement_BankAccount(), zc_Movement_PersonalAccount()) THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END
                  --                    + CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_IncomeAsset()) AND MIContainer.Amount > 0   THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END
                                       ) AS MoneySumm

                                   -- Услуги бухг. (+)получ. (-)оказан.
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Service(), zc_Movement_TransportService()) THEN -1 * MIContainer.Amount ELSE 0 END
                                                                                       + CASE WHEN MIContainer.MovementDescId IN (zc_Movement_ProfitLossService(), zc_Movement_ProfitIncomeService()) AND tmpContainer.PaidKindId <> zc_Enum_PaidKind_FirstForm() THEN -1 * MIContainer.Amount ELSE 0 END
                                             ELSE 0
                                        END) AS ServiceSumm

                                   -- Услуги факт (+)получ. (-)оказан.
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_TransportService()) THEN -1 * MIContainer.Amount ELSE 0 END
                                                                                       + CASE WHEN MIContainer.MovementDescId IN (zc_Movement_ProfitLossService(), zc_Movement_ProfitIncomeService()) AND tmpContainer.PaidKindId <> zc_Enum_PaidKind_FirstForm() THEN -1 * MIContainer.Amount ELSE 0 END
                                                                                       + CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Service()) AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_SaleSumm_10300() THEN -1 * MIContainer.Amount ELSE 0 END
                                                                                       
                                             ELSE 0
                                        END) AS ServiceRealSumm

                                   -- Услуги ProfitLossService + zc_Enum_PaidKind_FirstForm
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_ProfitLossService(), zc_Movement_ProfitIncomeService())
                                                                                               AND tmpContainer.PaidKindId = zc_Enum_PaidKind_FirstForm()
                                                                                                   THEN -1 * MIContainer.Amount
                                                                                              ELSE 0
                                                                                         END
                                                                                       
                                             ELSE 0
                                        END) AS ServiceSumm_pls

                                   -- ChangeCurrencySumm
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Currency()) THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS ChangeCurrencySumm

                                   -- OtherSumm
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId NOT IN (zc_Movement_Income(), zc_Movement_IncomeAsset(), zc_Movement_ReturnOut()
                                                                                                                                    , zc_Movement_Sale(), zc_Movement_ReturnIn()
                                                                                                                                    , zc_Movement_PriceCorrective()
                                                                                                                                    , zc_Movement_TransferDebtOut(), zc_Movement_TransferDebtIn()
                                                                                                                                    , zc_Movement_Cash(), zc_Movement_BankAccount(), zc_Movement_PersonalAccount()
                                                                                                                                    , zc_Movement_Service(), zc_Movement_TransportService()
                                                                                                                                    , zc_Movement_ProfitLossService(), zc_Movement_ProfitIncomeService()
                                                                                                                                    , zc_Movement_SendDebt()
                                                                                                                                    , zc_Movement_Currency()
                                                                                                                                    , zc_Movement_ChangePercent()
                                                                                                                                     )
                                                                                                   THEN MIContainer.Amount
                                                                                              ELSE 0
                                                                                         END
                                                                                       + CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_IncomeAsset()) AND MIContainer.Amount > 0 THEN 1 * MIContainer.Amount ELSE 0 END
                                             ELSE 0
                                        END
                                       ) AS OtherSumm

                            FROM tmpContainer
                                  INNER JOIN MovementItemContainer AS MIContainer
                                                                   ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                                  AND MIContainer.OperDate    >= inStartDate
                            GROUP BY tmpContainer.ContainerId
                                   , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.OperDate ELSE inEndDate + INTERVAL '1 DAY' END
                           )

          -- Только начальные долги - Первый день
        , tmpDebt_start AS (SELECT tmpContainer.ContainerId
                                 , inStartDate AS OperDate
                                   -- Начальный Долг
                                 , tmpContainer.Amount - COALESCE (SUM (COALESCE (MIContainer.DebetSumm, 0) - COALESCE(MIContainer.KreditSumm, 0) + COALESCE(MIContainer.Summ_add, 0)), 0) AS StartSumm

                            FROM tmpContainer
                                 LEFT JOIN Operation_all AS MIContainer
                                                         ON MIContainer.ContainerId = tmpContainer.ContainerId
                             GROUP BY tmpContainer.ContainerId
                                    , tmpContainer.Amount
                            -- без нулей
                            HAVING tmpContainer.Amount - COALESCE (SUM (COALESCE (MIContainer.DebetSumm, 0) - COALESCE(MIContainer.KreditSumm, 0) + COALESCE(MIContainer.Summ_add, 0)), 0)
                                   <> 0
                           )

        , Operation_sum AS (-- 1.1. Только долги начальные - Первый день
                            SELECT tmpDebt_start.ContainerId, tmpContainer.AccountId, tmpContainer.JuridicalId, tmpContainer.InfoMoneyId, tmpContainer.PaidKindId
                                 , tmpContainer.ContractId, tmpContainer.BranchId, tmpContainer.PartionMovementId
                                 , tmpContainer.CurrencyId

                                 , inStartDate AS OperDate

                                   -- Начальный Долг
                                 , tmpDebt_start.StartSumm

                                 , 0 AS DebetSumm
                                 , 0 AS KreditSumm

                                 , 0 AS IncomeSumm
                                 , 0 AS ReturnOutSumm

                                   -- Продажа (бухг.)
                                 , 0 AS SaleSumm

                                   -- Продажа (факт с уч. скидки)
                                 , 0 SaleRealSumm

                                   -- Cкидка (продажа)
                                 , 0 AS SaleSumm_10300

                                 , 0 AS TransferDebtSumm
                                 , 0 AS SendDebtSumm

                                 , 0 AS ReturnInSumm
                                 , 0 AS ReturnInRealSumm
                                 , 0 AS ReturnInSumm_10300

                                 , 0 AS PriceCorrectiveSumm
                                 , 0 AS ChangePercentSumm
                                 , 0 AS MoneySumm

                                    -- Услуги бухг. (+)получ. (-)оказан.
                                 , 0 AS ServiceSumm
                                    -- Услуги факт (+)получ. (-)оказан.
                                 , 0 AS ServiceRealSumm
                                   -- Услуги ProfitLossService + zc_Enum_PaidKind_FirstForm
                                 , 0 AS ServiceSumm_pls

                                 , 0 AS ChangeCurrencySumm
                                 , 0 AS OtherSumm

                            FROM tmpDebt_start
                                 -- все св-ва
                                 LEFT JOIN tmpContainer ON tmpContainer.ContainerId = tmpDebt_start.ContainerId

                           UNION ALL
                            -- 1.2. Только долги начальные - второй и т.д. день
                            SELECT Operation_all.ContainerId, tmpContainer.AccountId, tmpContainer.JuridicalId, tmpContainer.InfoMoneyId, tmpContainer.PaidKindId
                                 , tmpContainer.ContractId, tmpContainer.BranchId, tmpContainer.PartionMovementId
                                 , tmpContainer.CurrencyId

                                   -- следующий день
                                 , Operation_all.OperDate + INTERVAL '1 DAY' AS OperDate

                                   -- Начальный Долг
                                 , COALESCE (tmpDebt_start.StartSumm, 0) + COALESCE (Operation_all.OperSumm_sum, 0) AS StartAmount

                                 , 0 AS DebetSumm
                                 , 0 AS KreditSumm

                                 , 0 AS IncomeSumm
                                 , 0 AS ReturnOutSumm

                                   -- Продажа (бухг.)
                                 , 0 AS SaleSumm

                                   -- Продажа (факт с уч. скидки)
                                 , 0 SaleRealSumm

                                   -- Cкидка (продажа)
                                 , 0 AS SaleSumm_10300

                                 , 0 AS TransferDebtSumm
                                 , 0 AS SendDebtSumm

                                 , 0 AS ReturnInSumm
                                 , 0 AS ReturnInRealSumm
                                 , 0 AS ReturnInSumm_10300

                                 , 0 AS PriceCorrectiveSumm
                                 , 0 AS ChangePercentSumm
                                 , 0 AS MoneySumm

                                    -- Услуги бухг. (+)получ. (-)оказан.
                                 , 0 AS ServiceSumm
                                    -- Услуги факт (+)получ. (-)оказан.
                                 , 0 AS ServiceRealSumm
                                   -- Услуги ProfitLossService + zc_Enum_PaidKind_FirstForm
                                 , 0 AS ServiceSumm_pls

                                 , 0 AS ChangeCurrencySumm
                                 , 0 AS OtherSumm

                            FROM -- накопительно Движение по КАЖДОМУ дню
                                 (SELECT tmpList.ContainerId
                                       , tmpList.OperDate
                                       , SUM (COALESCE (Operation_all.DebetSumm, 0) - COALESCE (Operation_all.KreditSumm, 0))
                                         OVER (PARTITION BY tmpList.ContainerId ORDER BY tmpList.OperDate ASC) AS OperSumm_sum
                                         -- № п/п
                                       , ROW_NUMBER() OVER (PARTITION BY tmpList.ContainerId ORDER BY tmpList.OperDate ASC) AS Ord
                                  FROM -- Весь список
                                       (SELECT tmpList_Container.ContainerId
                                             , tmpList_day.OperDate
                                        FROM -- список ContainerId - было движение
                                             (SELECT DISTINCT Operation_all.ContainerId FROM Operation_all
                                             UNION
                                              -- список ContainerId - начальные Долги
                                              SELECT DISTINCT tmpDebt_start.ContainerId FROM tmpDebt_start
                                             ) AS tmpList_Container
                                             CROSS JOIN
                                             -- + список OperDate
                                             (SELECT GENERATE_SERIES (inStartDate, inEndDate, '1 DAY' :: INTERVAL) AS OperDate
                                             ) AS tmpList_day
                                       ) AS tmpList
                                       -- Движение
                                       LEFT JOIN Operation_all ON Operation_all.ContainerId = tmpList.ContainerId
                                                              AND Operation_all.OperDate    = tmpList.OperDate
                                 ) AS Operation_all

                                 -- Долги на начало
                                 LEFT JOIN tmpDebt_start ON tmpDebt_start.ContainerId = Operation_all.ContainerId
                                 -- все св-ва
                                 LEFT JOIN tmpContainer ON tmpContainer.ContainerId = Operation_all.ContainerId

                           UNION ALL
                            -- Движение по дням
                            SELECT Operation_all.ContainerId, tmpContainer.AccountId, tmpContainer.JuridicalId, tmpContainer.InfoMoneyId, tmpContainer.PaidKindId
                                 , tmpContainer.ContractId, tmpContainer.BranchId, tmpContainer.PartionMovementId
                                 , tmpContainer.CurrencyId

                                   -- OperDate
                                 , Operation_all.OperDate

                                   -- Начальный Долг
                                 , 0 AS StartSumm

                                   -- DebetSumm
                                 , Operation_all.DebetSumm
                                   -- KreditSumm
                                 , Operation_all.KreditSumm

                                   -- IncomeSumm
                                 , Operation_all.IncomeSumm
                                   -- ReturnOutSumm
                                 , Operation_all.ReturnOutSumm

                                   -- Продажа (бухг.)
                                 , Operation_all.SaleSumm

                                   -- Продажа (факт с уч. скидки)
                                 , Operation_all.SaleRealSumm

                                   -- Cкидка (продажа)
                                 , Operation_all.SaleSumm_10300

                                   -- Перевод долга
                                 , Operation_all.TransferDebtSumm
                                   -- Вз-зачет
                                 , Operation_all.SendDebtSumm

                                 , Operation_all.ReturnInSumm
                                 , Operation_all.ReturnInRealSumm
                                 , Operation_all.ReturnInSumm_10300

                                 , Operation_all.PriceCorrectiveSumm
                                 , Operation_all.ChangePercentSumm
                                 , Operation_all.MoneySumm

                                   -- Услуги бухг. (+)получ. (-)оказан.
                                 , Operation_all.ServiceSumm
                                   -- Услуги факт (+)получ. (-)оказан.
                                 , Operation_all.ServiceRealSumm
                                   -- Услуги ProfitLossService + zc_Enum_PaidKind_FirstForm
                                 , Operation_all.ServiceSumm_pls

                                   -- ChangeCurrencySumm
                                 , Operation_all.ChangeCurrencySumm

                                   -- OtherSumm
                                 , Operation_all.OtherSumm

                            FROM Operation_all
                                 -- все св-ва
                                 LEFT JOIN tmpContainer ON tmpContainer.ContainerId = Operation_all.ContainerId
                            -- только за период
                            WHERE Operation_all.OperDate <= inEndDate
                           )
     -- Результат
     SELECT
        Operation.ContainerId,
        Operation.OperDate :: TDateTime,

        Object_Juridical.ObjectCode      AS JuridicalCode,
        Object_Juridical.ValueData       AS JuridicalName,
        Object_JuridicalGroup.ValueData  AS JuridicalGroupName,
        Object_Retail.ValueData          AS RetailName,
        Object_RetailReport.ValueData    AS RetailReportName,
        Object_Partner.ObjectCode        AS PartnerCode,
        Object_Partner.ValueData         AS PartnerName,
        CASE WHEN Object_Partner.ValueData <> '' THEN Object_Partner.ValueData ELSE Object_Juridical.ValueData END :: TVarChar AS JuridicalPartnerlName,

        Object_Branch.ObjectCode               AS BranchCode,
        Object_Branch.ValueData                AS BranchName,
        Object_Branch_personal.ValueData       AS BranchName_personal,
        Object_Branch_personal_trade.ValueData AS BranchName_personal_trade,

        Object_Contract.ObjectCode AS ContractCode,
        Object_Contract.ValueData  AS ContractNumber,

        Object_PaidKind.ValueData           AS PaidKindName,
        Object_Account_View.AccountName_all AS AccountName,

        Object_InfoMoney_View.InfoMoneyGroupName,
        Object_InfoMoney_View.InfoMoneyDestinationName,
        Object_InfoMoney_View.InfoMoneyCode,
        Object_InfoMoney_View.InfoMoneyName,
        Object_InfoMoney_View.InfoMoneyName_all,

        Object_Currency.ValueData AS CurrencyName,

        -- Object_ContractConditionKind.ValueData AS ContractConditionKindName,
        -- tmpContract.Value :: TFloat AS ContractConditionValue,

        Object_PartionMovement.Id                    AS PartionMovementId,
        Object_PartionMovement.ValueData             AS PartionMovementName,
        -- ObjectDate_PartionMovement_Payment.ValueData AS PaymentDate,

        Operation.AccountId                AS AccountId,
        Object_Juridical.Id                AS JuridicalId,
        Object_Partner.Id                  AS PartnerId,
        Object_InfoMoney_View.InfoMoneyId  AS InfoMoneyId,
        Object_Contract.Id                 AS ContractId,
        Object_PaidKind.Id                 AS PaidKindId,
        Object_Branch.Id                   AS BranchId,

        Operation.StartSumm  :: TFloat,
        Operation.EndSumm    :: TFloat,

        Operation.DebetSumm  :: TFloat,
        Operation.KreditSumm :: TFloat,

        Operation.IncomeSumm    :: TFloat,
        Operation.ReturnOutSumm :: TFloat,

        -- Продажа (бухг.)
        Operation.SaleSumm :: TFloat,
        -- Продажа (факт с уч. скидки)
        Operation.SaleRealSumm :: TFloat,
        -- Cкидка (продажа)
        Operation.SaleSumm_10300 :: TFloat,
        -- Продажа (факт без уч. скидки)
        (Operation.SaleRealSumm + Operation.SaleSumm_10300) :: TFloat,

        -- Возврат от пок. (бухг.)
        Operation.ReturnInSumm :: TFloat,
        -- Возврат от пок. (факт с уч. скидки)
        Operation.ReturnInRealSumm :: TFloat,
        -- Cкидка (возврат от пок.)
        Operation.ReturnInSumm_10300 :: TFloat,
        -- Возврат от пок. (факт без уч. скидки)
        (Operation.ReturnInRealSumm + Operation.ReturnInSumm_10300) :: TFloat,

        Operation.PriceCorrectiveSumm :: TFloat,
        Operation.ChangePercentSumm :: TFloat,
        Operation.MoneySumm :: TFloat,

        -- Услуги бухг. (+)получ. (-)оказан.
        Operation.ServiceSumm :: TFloat,
        -- Услуги факт (+)получ. (-)оказан.
        Operation.ServiceRealSumm :: TFloat,
        -- Услуги ProfitLossService + zc_Enum_PaidKind_FirstForm
        Operation.ServiceSumm_pls :: TFloat,

        -- Перевод долга
        Operation.TransferDebtSumm :: TFloat,
        -- Вз-зачет
        Operation.SendDebtSumm :: TFloat,
        --
        Operation.ChangeCurrencySumm :: TFloat,
        Operation.OtherSumm :: TFloat

     FROM
         (SELECT MAX (Operation_all.ContainerId) AS ContainerId
                 -- по дням
               , Operation_all.OperDate
                 --
               , Operation_all.AccountId, Operation_all.JuridicalId, Operation_all.InfoMoneyId
               , Operation_all.PaidKindId, Operation_all.BranchId, Operation_all.PartionMovementId
               , CLO_Partner.ObjectId AS PartnerId
               , View_Contract_ContractKey.ContractId_Key AS ContractId
               , Operation_all.CurrencyId

               , SUM (Operation_all.StartSumm)                     AS StartSumm
               , SUM (COALESCE (Operation_sum_next.StartSumm, 0))  AS EndSumm

               , SUM (Operation_all.DebetSumm)           AS DebetSumm
               , SUM (Operation_all.KreditSumm)          AS KreditSumm

               , SUM (Operation_all.IncomeSumm)          AS IncomeSumm
               , SUM (Operation_all.ReturnOutSumm)       AS ReturnOutSumm

               , SUM (Operation_all.SaleSumm)            AS SaleSumm
               , SUM (Operation_all.SaleRealSumm)        AS SaleRealSumm
               , SUM (Operation_all.SaleSumm_10300)      AS SaleSumm_10300

               , SUM (Operation_all.ReturnInSumm)        AS ReturnInSumm
               , SUM (Operation_all.ReturnInRealSumm)    AS ReturnInRealSumm
               , SUM (Operation_all.ReturnInSumm_10300)  AS ReturnInSumm_10300

               , SUM (Operation_all.PriceCorrectiveSumm) AS PriceCorrectiveSumm
               , SUM (Operation_all.ChangePercentSumm)   AS ChangePercentSumm

               , SUM (Operation_all.MoneySumm)           AS MoneySumm
               , SUM (Operation_all.ServiceSumm)         AS ServiceSumm

               , SUM (Operation_all.ServiceRealSumm)     AS ServiceRealSumm
               , SUM (Operation_all.ServiceSumm_pls)     AS ServiceSumm_pls

               , SUM (Operation_all.TransferDebtSumm)    AS TransferDebtSumm
               , SUM (Operation_all.SendDebtSumm)        AS SendDebtSumm
               , SUM (Operation_all.ChangeCurrencySumm)  AS ChangeCurrencySumm
               , SUM (Operation_all.OtherSumm)           AS OtherSumm

          FROM Operation_sum AS Operation_all
               -- конечный долг - в следующем дне
               LEFT JOIN Operation_sum AS Operation_sum_next
                                       ON Operation_sum_next.ContainerId = Operation_all.ContainerId
                                      AND Operation_sum_next.OperDate    = Operation_all.OperDate + INTERVAL '1 DAY'
                                      -- !!!только долги!!!
                                      AND Operation_sum_next.StartSumm  <> 0
               
               LEFT JOIN ContainerLinkObject AS CLO_Partner
                                             ON CLO_Partner.ContainerId = Operation_all.ContainerId
                                            AND CLO_Partner.DescId = zc_ContainerLinkObject_Partner()
               LEFT JOIN Object_Contract_ContractKey_View AS View_Contract_ContractKey ON View_Contract_ContractKey.ContractId = Operation_all.ContractId

          -- только за период
          WHERE Operation_all.OperDate <= inEndDate
          GROUP BY Operation_all.OperDate
                 , Operation_all.AccountId, Operation_all.JuridicalId, Operation_all.InfoMoneyId, Operation_all.PaidKindId, Operation_all.BranchId, Operation_all.PartionMovementId
                 , View_Contract_ContractKey.ContractId_Key
                 , CLO_Partner.ObjectId
                 , Operation_all.CurrencyId

         ) AS Operation

           -- св-ва
           LEFT JOIN Object_Account_View   AS Object_Account_View    ON Object_Account_View.AccountId     = Operation.AccountId
           LEFT JOIN Object_InfoMoney_View AS Object_InfoMoney_View  ON Object_InfoMoney_View.InfoMoneyId = Operation.InfoMoneyId
           LEFT JOIN Object                AS Object_Branch          ON Object_Branch.Id                  = Operation.BranchId
           LEFT JOIN Object                AS Object_Contract        ON Object_Contract.Id                = Operation.ContractId
           LEFT JOIN Object                AS Object_Juridical       ON Object_Juridical.Id               = Operation.JuridicalId
           LEFT JOIN Object                AS Object_Partner         ON Object_Partner.Id                 = Operation.PartnerId
           LEFT JOIN Object                AS Object_PaidKind        ON Object_PaidKind.Id                = Operation.PaidKindId
           LEFT JOIN Object                AS Object_PartionMovement ON Object_PartionMovement.Id         = Operation.PartionMovementId
           LEFT JOIN Object                AS Object_Currency        ON Object_Currency.Id                = Operation.CurrencyId

           LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                                ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id
                               AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
           LEFT JOIN Object AS Object_JuridicalGroup ON Object_JuridicalGroup.Id = ObjectLink_Juridical_JuridicalGroup.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                               AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
           LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId
           LEFT JOIN ObjectLink AS ObjectLink_Juridical_RetailReport
                                ON ObjectLink_Juridical_RetailReport.ObjectId = Object_Juridical.Id
                               AND ObjectLink_Juridical_RetailReport.DescId = zc_ObjectLink_Juridical_RetailReport()
           LEFT JOIN Object AS Object_RetailReport ON Object_RetailReport.Id = ObjectLink_Juridical_RetailReport.ChildObjectId

           -- LEFT JOIN tmpContract ON tmpContract.JuridicalId = Operation.JuridicalId
           -- LEFT JOIN Object AS Object_ContractConditionKind ON Object_ContractConditionKind.Id = tmpContract.ContractConditionKindId


           LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                ON ObjectLink_Partner_PersonalTrade.ObjectId = Operation.PartnerId
                               AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
           LEFT JOIN Object AS Object_PersonalTrade_Partner ON Object_PersonalTrade_Partner.Id = ObjectLink_Partner_PersonalTrade.ChildObjectId

           -- Отв за договор - сотрудник
           LEFT JOIN ObjectLink AS ObjectLink_Contract_Personal
                                ON ObjectLink_Contract_Personal.ObjectId = Operation.ContractId
                               AND ObjectLink_Contract_Personal.DescId = zc_ObjectLink_Contract_Personal()
           LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_Contract_Personal.ChildObjectId

           -- Отв за договор - сотрудник ТП
           LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalTrade
                                ON ObjectLink_Contract_PersonalTrade.ObjectId = Operation.ContractId
                               AND ObjectLink_Contract_PersonalTrade.DescId = zc_ObjectLink_Contract_PersonalTrade()
           LEFT JOIN Object AS Object_PersonalTrade ON Object_PersonalTrade.Id = ObjectLink_Contract_PersonalTrade.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalCollation
                                ON ObjectLink_Contract_PersonalCollation.ObjectId = Operation.ContractId
                               AND ObjectLink_Contract_PersonalCollation.DescId = zc_ObjectLink_Contract_PersonalCollation()
           LEFT JOIN Object AS Object_PersonalCollation ON Object_PersonalCollation.Id = ObjectLink_Contract_PersonalCollation.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalSigning
                                ON ObjectLink_Contract_PersonalSigning.ObjectId = Operation.ContractId
                               AND ObjectLink_Contract_PersonalSigning.DescId = zc_ObjectLink_Contract_PersonalSigning()
           LEFT JOIN Object_Personal_View AS Object_PersonalSigning ON Object_PersonalSigning.PersonalId = ObjectLink_Contract_PersonalSigning.ChildObjectId



           -- Отв за договор - сотрудник
           LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                ON ObjectLink_Personal_PersonalServiceList.ObjectId = ObjectLink_Contract_Personal.ChildObjectId
                               AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
           -- Филиал - ведомость
           LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Branch
                                ON ObjectLink_PersonalServiceList_Branch.ObjectId = ObjectLink_Personal_PersonalServiceList.ChildObjectId
                               AND ObjectLink_PersonalServiceList_Branch.DescId = zc_ObjectLink_PersonalServiceList_Branch()

           -- Отв за договор - сотрудник ТП
           LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList_trade
                                ON ObjectLink_Personal_PersonalServiceList_trade.ObjectId = ObjectLink_Contract_PersonalTrade.ChildObjectId
                               AND ObjectLink_Personal_PersonalServiceList_trade.DescId = zc_ObjectLink_Personal_PersonalServiceList()
           -- Филиал - ведомость
           LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Branch_trade
                                ON ObjectLink_PersonalServiceList_Branch_trade.ObjectId = ObjectLink_Personal_PersonalServiceList_trade.ChildObjectId
                               AND ObjectLink_PersonalServiceList_Branch_trade.DescId = zc_ObjectLink_PersonalServiceList_Branch()

           LEFT JOIN Object AS Object_Branch_personal       ON Object_Branch_personal.Id = ObjectLink_PersonalServiceList_Branch.ChildObjectId
           LEFT JOIN Object AS Object_Branch_personal_trade ON Object_Branch_personal_trade.Id = ObjectLink_PersonalServiceList_Branch_trade.ChildObjectId

     -- WHERE (Operation.StartAmount <> 0 OR Operation.EndAmount <> 0
        --  OR Operation.DebetSumm <> 0 OR Operation.KreditSumm <> 0)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.09.25                                        *
*/

-- тест
-- SELECT OperDate, ContractCode, sum (StartSumm) as StartSumm, sum (EndSumm)as EndSumm, sum (DebetSumm) as DebetSumm, sum (KreditSumm) as KreditSumm, ContainerId, PaidKindName, PartnerName, JuridicalName FROM lpReport_bi_JuridicalSold (inStartDate:= '01.09.2025', inEndDate:= '30.09.2025', inAccountId:= zc_Enum_Account_30101(), inInfoMoneyId:= 0, inInfoMoneyGroupId:= 0, inInfoMoneyDestinationId:= 0, inPaidKindId:= 0, inIsPartionMovement:= FALSE, inUserId:= zfCalc_UserAdmin() :: Integer) where JuridicalName ilike '%сільпо%' group by  OperDate, ContractCode, ContainerId, PartnerName, PaidKindName, JuridicalName order by ContainerId, OperDate, JuridicalName, PaidKindName, ContractCode
