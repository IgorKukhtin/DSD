-- Function: lpReport_JuridicalSold()

DROP FUNCTION IF EXISTS lpReport_JuridicalSold (TDateTime, TDateTime, TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS lpReport_JuridicalSold (TDateTime, TDateTime, TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpReport_JuridicalSold(
    IN inStartDate                TDateTime , --
    IN inEndDate                  TDateTime , --
    IN inStartDate_sale           TDateTime , --
    IN inEndDate_sale             TDateTime , --
    IN inAccountId                Integer,    -- Счет
    IN inInfoMoneyId              Integer,    -- Управленческая статья
    IN inInfoMoneyGroupId         Integer,    -- Группа управленческих статей
    IN inInfoMoneyDestinationId   Integer,    --
    IN inPaidKindId               Integer   , --
    IN inBranchId                 Integer   , --
    IN inJuridicalGroupId         Integer   , --
    IN inCurrencyId               Integer   , -- Валюта
    IN inIsPartionMovement        Boolean   ,
    IN inUserId                  Integer    -- сессия пользователя
)
RETURNS TABLE (ContainerId Integer, JuridicalCode Integer, JuridicalName TVarChar, OKPO TVarChar, INN TVarChar, JuridicalGroupName TVarChar
             , RetailName TVarChar, RetailReportName TVarChar
             , PartnerCode Integer, PartnerName TVarChar
             , JuridicalPartnerlName TVarChar
             , BranchCode Integer, BranchName TVarChar, BranchName_personal TVarChar, BranchName_personal_trade TVarChar
             , ContractCode Integer, ContractNumber TVarChar
             , ContractTagGroupName TVarChar, ContractTagName TVarChar, ContractStateKindCode Integer
             , ContractJuridicalDocId Integer, ContractJuridicalDocCode Integer, ContractJuridicalDocName TVarChar
             , PersonalName TVarChar, PersonalTradeName TVarChar, PersonalCollationName TVarChar, PersonalTradeName_Partner TVarChar, PersonalSigningName TVarChar
             , StartDate TDateTime, EndDate TDateTime
             , PaidKindName TVarChar, AccountName TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , AreaName TVarChar, AreaName_Partner TVarChar
             , CurrencyName TVarChar
             , ContractConditionKindName TVarChar, ContractConditionValue TFloat
             , PartionMovementName TVarChar
             , PaymentDate TDateTime
             , AccountId Integer, JuridicalId Integer, PartnerId Integer, InfoMoneyId Integer, ContractId Integer, PaidKindId Integer, BranchId Integer
             , StartAmount_A TFloat, StartAmount_P TFloat, StartAmountD TFloat, StartAmountK TFloat
             , DebetSumm TFloat, KreditSumm TFloat
             , IncomeSumm TFloat, ReturnOutSumm TFloat, SaleSumm TFloat, SaleRealSumm TFloat, SaleSumm_10300 TFloat, SaleRealSumm_total TFloat, ReturnInSumm TFloat, ReturnInRealSumm TFloat, ReturnInSumm_10300 TFloat, ReturnInRealSumm_total TFloat
             , PriceCorrectiveSumm TFloat, ChangePercentSumm TFloat
             , MoneySumm TFloat, ServiceSumm TFloat, ServiceRealSumm TFloat, TransferDebtSumm TFloat, SendDebtSumm TFloat, ChangeCurrencySumm TFloat, OtherSumm TFloat
             , EndAmount_A TFloat, EndAmount_P TFloat, EndAmount_D TFloat, EndAmount_K TFloat

             , StartAmount_Currency_A TFloat, StartAmount_Currency_P TFloat, StartAmount_Currency_D TFloat, StartAmount_Currency_K TFloat
             , DebetSumm_Currency TFloat, KreditSumm_Currency TFloat
             , IncomeSumm_Currency TFloat, ReturnOutSumm_Currency TFloat
             , SaleSumm_Currency TFloat, SaleRealSumm_Currency TFloat, SaleSumm_10300_Currency TFloat, SaleRealSumm_Currency_total TFloat
             , ReturnInSumm_Currency TFloat, ReturnInRealSumm_Currency TFloat, ReturnInSumm_10300_Currency TFloat, ReturnInRealSumm_Currency_total TFloat
             , PriceCorrectiveSumm_Currency TFloat, ChangePercentSumm_Currency TFloat
             , MoneySumm_Currency TFloat, ServiceSumm_Currency TFloat, ServiceRealSumm_Currency TFloat
             , TransferDebtSumm_Currency TFloat, SendDebtSumm_Currency TFloat, ChangeCurrencySumm_Currency TFloat, OtherSumm_Currency TFloat
             , EndAmount_Currency_A TFloat, EndAmount_Currency_P TFloat, EndAmount_Currency_D TFloat, EndAmount_Currency_K TFloat
             , PartnerTagName TVarChar
              )
AS
$BODY$
   --DECLARE vbUserId Integer;

   DECLARE vbIsBranch Boolean;
   DECLARE vbIsJuridicalGroup Boolean;
   DECLARE vbObjectId_Constraint_Branch Integer;
   DECLARE vbObjectId_Constraint_JuridicalGroup Integer;

   DECLARE vbIsInfoMoneyDestination_21500 Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_...());
     -- vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, inUserId);


     -- Разрешен просмотр долги Маркетинг - НАЛ
     vbIsInfoMoneyDestination_21500:= EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS tmp WHERE tmp.UserId = inUserId AND tmp.RoleId = 8852398);

     -- определяется ...
     vbIsBranch:= COALESCE (inBranchId, 0) > 0;
     vbIsJuridicalGroup:= COALESCE (inJuridicalGroupId, 0) > 0;

     -- определяется уровень доступа
     vbObjectId_Constraint_Branch:= (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = inUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId)
                               ;
     vbObjectId_Constraint_JuridicalGroup:= (SELECT Object_RoleAccessKeyGuide_View.JuridicalGroupId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = inUserId AND Object_RoleAccessKeyGuide_View.JuridicalGroupId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.JuridicalGroupId)
                               ;
     -- !!!меняется параметр!!!
     IF vbObjectId_Constraint_Branch > 0 AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = 8918836) -- Разрешен просмотр обороты НАЛ - все Филиалы
     THEN inBranchId:= vbObjectId_Constraint_Branch; END IF;
     --
     IF vbObjectId_Constraint_JuridicalGroup > 0 AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = 8918836) -- Разрешен просмотр обороты НАЛ - все Филиалы
     THEN inJuridicalGroupId:= vbObjectId_Constraint_JuridicalGroup; END IF;


     -- Результат
     RETURN QUERY
     WITH tmpReport AS (SELECT tmpReport.BranchId, tmpReport.InfoMoneyId, SUM (tmpReport.Sale_Summ) AS Sale_Summ
                        FROM gpReport_GoodsMI_SaleReturnIn (inStartDate    := inStartDate_sale --CASE WHEN inStartDate = inEndDate OR EXTRACT (MONTH FROM CURRENT_DATE) = EXTRACT (MONTH FROM inEndDate) THEN DATE_TRUNC ('MONTH', inStartDate) - INTERVAL '1 MONTH' ELSE inStartDate END
                                                          , inEndDate      := inEndDate_sale   --CASE WHEN inStartDate = inEndDate OR EXTRACT (MONTH FROM CURRENT_DATE) = EXTRACT (MONTH FROM inEndDate) THEN DATE_TRUNC ('MONTH', inStartDate) - INTERVAL '1 DAY'   ELSE inEndDate   END
                                                          , inBranchId     := 0
                                                          , inAreaId       := 0
                                                          , inRetailId     := 0
                                                          , inJuridicalId  := 0
                                                          , inPaidKindId   := zc_Enum_PaidKind_FirstForm()
                                                          , inTradeMarkId  := 0
                                                          , inGoodsGroupId := 0
                                                          , inInfoMoneyId  := 0
                                                          , inIsPartner    := FALSE
                                                          , inIsTradeMark  := FALSE
                                                          , inIsGoods      := FALSE
                                                          , inIsGoodsKind  := FALSE
                                                          , inIsContract   := FALSE
                                                          , inIsOLAP       := TRUE
                                                          , inSession      := inUserId :: TVarChar
                                                           ) AS tmpReport
                      --WHERE EXTRACT (MONTH FROM CURRENT_DATE) > EXTRACT (MONTH FROM inEndDate)
                        WHERE 1=0
                        GROUP BY tmpReport.BranchId, tmpReport.InfoMoneyId
                       )
        , tmpReport_sum AS (SELECT tmpReport.InfoMoneyId, SUM (tmpReport.Sale_Summ) AS Sale_Summ
                            FROM tmpReport
                            GROUP BY tmpReport.InfoMoneyId
                           )
        , tmpReport_res AS (SELECT tmpReport.BranchId, tmpReport.InfoMoneyId
                                 , CASE WHEN tmpReport_sum.Sale_Summ > 0 THEN tmpReport.Sale_Summ / tmpReport_sum.Sale_Summ ELSE 1 END AS Koeff
                            FROM tmpReport
                                 LEFT JOIN tmpReport_sum ON tmpReport_sum.InfoMoneyId = tmpReport.InfoMoneyId
                           )
        , tmpContractCondition AS
                      (SELECT ObjectLink_Contract.ChildObjectId AS ContractId
                            , MAX (ObjectLink_ContractConditionKind.ChildObjectId) AS ContractConditionKindId
                            , SUM (COALESCE (ObjectFloat_Value.ValueData, 0)) AS Value
                       FROM ObjectLink AS ObjectLink_ContractConditionKind
                            INNER JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id = ObjectLink_ContractConditionKind.ObjectId
                                                                         AND Object_ContractCondition.isErased = FALSE
                            LEFT JOIN ObjectLink AS ObjectLink_Contract
                                                 ON ObjectLink_Contract.ObjectId = ObjectLink_ContractConditionKind.ObjectId
                                                AND ObjectLink_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                            LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                  ON ObjectFloat_Value.ObjectId = ObjectLink_ContractConditionKind.ObjectId
                                                 AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                       WHERE ObjectLink_ContractConditionKind.ChildObjectId = zc_Enum_ContractConditionKind_BonusPercentAccount() -- % бонуса за оплату
                         AND ObjectLink_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                       GROUP BY ObjectLink_Contract.ChildObjectId
                      )
        , tmpContract AS
                      (SELECT View_Contract.JuridicalId
                            , MAX (tmpContractCondition.ContractConditionKindId) AS ContractConditionKindId
                            , MAX (tmpContractCondition.Value) AS Value
                       FROM tmpContractCondition
                            INNER JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = tmpContractCondition.ContractId
                                                                            AND View_Contract.isErased = FALSE
                                                                            AND View_Contract.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                                                            AND inEndDate BETWEEN View_Contract.StartDate_condition AND View_Contract.EndDate_condition
                       GROUP BY View_Contract.JuridicalId
                      )
        , tmpListBranch_Constraint AS (SELECT ObjectLink_Contract_Personal.ObjectId AS ContractId
                                       FROM ObjectLink AS ObjectLink_Unit_Branch
                                            INNER JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                                  ON ObjectLink_Personal_Unit.ChildObjectId = ObjectLink_Unit_Branch.ObjectId
                                                                 AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                            INNER JOIN ObjectLink AS ObjectLink_Contract_Personal
                                                                 ON ObjectLink_Contract_Personal.ChildObjectId = ObjectLink_Personal_Unit.ObjectId
                                                                 AND ObjectLink_Contract_Personal.DescId = zc_ObjectLink_Contract_Personal()
                                       WHERE ObjectLink_Unit_Branch.ChildObjectId = vbObjectId_Constraint_Branch
                                         AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                                       GROUP BY ObjectLink_Contract_Personal.ObjectId
                                      )
        , View_InfoMoney AS (SELECT * FROM Object_InfoMoney_View)

          -- НЕ Разрешен просмотр долги Маркетинг - НАЛ
        , tmpInfoMoney_not AS (SELECT Object_InfoMoney_View.*
                               FROM View_InfoMoney AS Object_InfoMoney_View
                               WHERE Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21500() -- Маркетинг
                                 AND vbIsInfoMoneyDestination_21500 = FALSE
                              )

        , tmpContainer AS (SELECT Container.Id AS ContainerId
                                , Container_Currency.Id  AS ContainerId_Currency
                                , Container.ObjectId
                                , Container.Amount
                                , COALESCE (Container_Currency.Amount, 0) AS Amount_Currency
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
                                LEFT JOIN View_InfoMoney AS Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = CLO_InfoMoney.ObjectId
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
                                LEFT JOIN tmpListBranch_Constraint ON tmpListBranch_Constraint.ContractId = CLO_Contract.ObjectId

                                LEFT JOIN ContainerLinkObject AS CLO_Currency
                                                              ON CLO_Currency.ContainerId = CLO_Juridical.ContainerId
                                                             AND CLO_Currency.DescId = zc_ContainerLinkObject_Currency()
                                LEFT JOIN Container AS Container_Currency
                                                    ON Container_Currency.ParentId = CLO_Juridical.ContainerId
                                                   AND Container_Currency.DescId = zc_Container_SummCurrency()

                                LEFT JOIN tmpInfoMoney_not ON tmpInfoMoney_not.InfoMoneyId = CLO_InfoMoney.ObjectId

                           WHERE CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                             AND (CLO_PaidKind.ObjectId = inPaidKindId OR COALESCE (inPaidKindId, 0) = 0)
                             AND (CLO_Branch.ObjectId = inBranchId OR COALESCE (inBranchId, 0) = 0
                                  OR ((ObjectLink_Juridical_JuridicalGroup.ChildObjectId = inJuridicalGroupId OR tmpListBranch_Constraint.ContractId > 0) AND vbIsBranch = FALSE) -- !!!пересорт!!
                                  OR CLO_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm()
                                 )
                             AND (ObjectLink_Juridical_JuridicalGroup.ChildObjectId = inJuridicalGroupId OR COALESCE (inJuridicalGroupId, 0) = 0
                                  OR tmpListBranch_Constraint.ContractId > 0
                                  OR (CLO_Branch.ObjectId = inBranchId AND vbIsJuridicalGroup = FALSE) -- !!!пересорт!!
                                  OR CLO_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm()
                                 )
                             AND (Object_InfoMoney_View.InfoMoneyDestinationId = inInfoMoneyDestinationId OR COALESCE (inInfoMoneyDestinationId, 0) = 0)
                             AND (Object_InfoMoney_View.InfoMoneyId = inInfoMoneyId OR COALESCE (inInfoMoneyId, 0) = 0)
                             AND (Object_InfoMoney_View.InfoMoneyGroupId = inInfoMoneyGroupId OR COALESCE (inInfoMoneyGroupId, 0) = 0)
                             AND (Container.ObjectId = inAccountId OR COALESCE (inAccountId, 0) = 0)
                             AND (CLO_Currency.ObjectId = inCurrencyId OR COALESCE (inCurrencyId, 0) = 0 OR COALESCE (inCurrencyId, 0) = zc_Enum_Currency_Basis())
                             -- НЕ Разрешен просмотр долги Маркетинг - НАЛ
                             AND (tmpInfoMoney_not.InfoMoneyId IS NULL OR COALESCE (CLO_PaidKind.ObjectId, 0) <> zc_Enum_PaidKind_SecondForm())

                           )

        , Operation_all AS (-- 1.1. сумма даижения в валюте баланса
                            SELECT tmpContainer.ContainerId, tmpContainer.ObjectId, tmpContainer.JuridicalId, tmpContainer.InfoMoneyId, tmpContainer.PaidKindId
                                 , tmpContainer.ContractId, tmpContainer.BranchId, tmpContainer.PartionMovementId
                                 , tmpContainer.CurrencyId
                                 , tmpContainer.Amount - COALESCE(SUM (MIContainer.Amount), 0) AS StartAmount
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS DebetSumm
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.Amount < 0 THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END) AS KreditSumm

                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_IncomeAsset()) AND MIContainer.Amount < 0 THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END) AS IncomeSumm
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId = zc_Movement_ReturnOut() THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS ReturnOutSumm

                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate
                                             THEN CASE
                                                     --WHEN inUserId = 5 AND MIContainer.MovementDescId IN (zc_Movement_TransferDebtOut())
                                                     --     THEN MIContainer.Amount
                                                     --WHEN inUserId = 5 THEN 0
                                                       WHEN MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_TransferDebtOut())
                                                       THEN MIContainer.Amount
                                                       ELSE 0
                                                  END
                                             ELSE 0
                                        END) AS SaleSumm

                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_PriceCorrective()) THEN MIContainer.Amount ELSE 0 END ELSE 0 END)
                                 + SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Service()) AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10300() THEN MIContainer.Amount ELSE 0 END ELSE 0 END)
                                   AS SaleRealSumm
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate
                                             THEN CASE
                                                     --WHEN inUserId = 5 and MIContainer.MovementDescId IN (zc_Movement_Sale()/*, zc_Movement_Service(), zc_Movement_PriceCorrective()*/) AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10300() THEN -1 * MIContainer.Amount
                                                     --WHEN inUserId = 5 then 0
                                                       WHEN MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_Service(), zc_Movement_PriceCorrective()) AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10300()
                                                       THEN -1 * MIContainer.Amount
                                                       ELSE 0
                                                 END
                                             ELSE 0
                                        END) AS SaleSumm_10300

                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_TransferDebtOut(), zc_Movement_TransferDebtIn()) THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS TransferDebtSumm

                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_ReturnIn(), zc_Movement_TransferDebtIn()) THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END) AS ReturnInSumm
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_ReturnIn()) THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END) AS ReturnInRealSumm
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_ReturnIn()) AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10300() THEN 1 * MIContainer.Amount ELSE 0 END ELSE 0 END) AS ReturnInSumm_10300

                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_PriceCorrective()) THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS PriceCorrectiveSumm
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_ChangePercent()) THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END)   AS ChangePercentSumm
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Cash(), zc_Movement_BankAccount(), zc_Movement_PersonalAccount()) THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END
                  --                    + CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_IncomeAsset()) AND MIContainer.Amount > 0   THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END
                                       ) AS MoneySumm
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Service(), zc_Movement_ProfitLossService(), zc_Movement_ProfitIncomeService(), zc_Movement_TransportService()) THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END) AS ServiceSumm
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_ProfitLossService(), zc_Movement_ProfitIncomeService(), zc_Movement_TransportService()) THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END)
                                 + SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Service()) AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_SaleSumm_10300() THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END)
                                   AS ServiceRealSumm

                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_SendDebt()) THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END) AS SendDebtSumm
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Currency()) THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS ChangeCurrencySumm
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId NOT IN (zc_Movement_Income(), zc_Movement_IncomeAsset(), zc_Movement_ReturnOut()
                                                                                                                                    , zc_Movement_Sale(), zc_Movement_ReturnIn()
                                                                                                                                    , zc_Movement_PriceCorrective()
                                                                                                                                    , zc_Movement_TransferDebtOut(), zc_Movement_TransferDebtIn()
                                                                                                                                    , zc_Movement_Cash(), zc_Movement_BankAccount(), zc_Movement_PersonalAccount()
                                                                                                                                    , zc_Movement_Service(), zc_Movement_ProfitLossService(), zc_Movement_ProfitIncomeService(), zc_Movement_TransportService()
                                                                                                                                    , zc_Movement_SendDebt()
                                                                                                                                    , zc_Movement_Currency()
                                                                                                                                    , zc_Movement_ChangePercent()
                                                                                                                                     )
                                                                                                   THEN MIContainer.Amount
                                                                                              ELSE 0
                                                                                         END
                                             ELSE 0
                                        END
                                      + CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_IncomeAsset()) AND MIContainer.Amount > 0   THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END
                                       ) AS OtherSumm
                                 , tmpContainer.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS EndAmount
                                 ---
                                 , 0 AS StartAmount_Currency
                                 , 0 AS DebetSumm_Currency
                                 , 0 AS KreditSumm_Currency
                                 , 0 AS IncomeSumm_Currency
                                 , 0 AS ReturnOutSumm_Currency
                                 , 0 AS SaleSumm_Currency
                                 , 0 AS SaleRealSumm_Currency
                                 , 0 AS SaleSumm_10300_Currency
                                 , 0 AS TransferDebtSumm_Currency
                                 , 0 AS ReturnInSumm_Currency
                                 , 0 AS ReturnInRealSumm_Currency
                                 , 0 AS ReturnInSumm_10300_Currency
                                 , 0 AS PriceCorrectiveSumm_Currency
                                 , 0 AS ChangePercentSumm_Currency
                                 , 0 AS MoneySumm_Currency
                                 , 0 AS ServiceSumm_Currency
                                 , 0 AS ServiceRealSumm_Currency
                                 , 0 AS SendDebtSumm_Currency
                                 , 0 AS ChangeCurrencySumm_Currency
                                 , 0 AS OtherSumm_Currency
                                 , 0 AS EndAmount_Currency
                            FROM tmpContainer
                                  LEFT JOIN MovementItemContainer AS MIContainer
                                                                  ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                                 AND MIContainer.OperDate >= inStartDate
                             GROUP BY tmpContainer.ContainerId, tmpContainer.ObjectId, tmpContainer.Amount, tmpContainer.JuridicalId, tmpContainer.InfoMoneyId, tmpContainer.PaidKindId
                                    , tmpContainer.ContractId, tmpContainer.BranchId, tmpContainer.PartionMovementId
                                    , tmpContainer.CurrencyId
                          UNION ALL
                            -- 1.2. сумма даижения в валюте операции - Currency
                            SELECT tmpContainer.ContainerId, tmpContainer.ObjectId, tmpContainer.JuridicalId, tmpContainer.InfoMoneyId, tmpContainer.PaidKindId
                                 , tmpContainer.ContractId, tmpContainer.BranchId, tmpContainer.PartionMovementId
                                 , tmpContainer.CurrencyId
                                 , 0 AS StartAmount
                                 , 0 AS DebetSumm
                                 , 0 AS KreditSumm
                                 , 0 AS IncomeSumm
                                 , 0 AS ReturnOutSumm
                                 , 0 AS SaleSumm
                                 , 0 AS SaleRealSumm
                                 , 0 AS SaleSumm_10300
                                 , 0 AS TransferDebtSumm
                                 , 0 AS ReturnInSumm
                                 , 0 AS ReturnInRealSumm
                                 , 0 AS ReturnInSumm_10300
                                 , 0 AS PriceCorrectiveSumm
                                 , 0 AS ChangePercentSumm
                                 , 0 AS MoneySumm
                                 , 0 AS ServiceSumm
                                 , 0 AS ServiceRealSumm
                                 , 0 AS SendDebtSumm
                                 , 0 AS ChangeCurrencySumm
                                 , 0 AS OtherSumm
                                 , 0 AS EndAmount
                                 --------
                                 , tmpContainer.Amount_Currency - COALESCE(SUM (MIContainer.Amount), 0) AS StartAmount_Currency
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS DebetSumm_Currency
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.Amount < 0 THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END) AS KreditSumm_Currency

                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_IncomeAsset()) AND MIContainer.Amount < 0 THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END) AS IncomeSumm_Currency
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId = zc_Movement_ReturnOut() THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS ReturnOutSumm_Currency

                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_TransferDebtOut()) THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS SaleSumm_Currency
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_PriceCorrective()) THEN MIContainer.Amount ELSE 0 END ELSE 0 END)
                                 + SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Service()) AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10300() THEN MIContainer.Amount ELSE 0 END ELSE 0 END)
                                   AS SaleRealSumm_Currency
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_Service(), zc_Movement_PriceCorrective()) AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10300() THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END) AS SaleSumm_10300_Currency
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_TransferDebtOut(), zc_Movement_TransferDebtIn()) THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS TransferDebtSumm_Currency

                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_ReturnIn(), zc_Movement_TransferDebtIn()) THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END) AS ReturnInSumm_Currency
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_ReturnIn()) THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END) AS ReturnInRealSumm_Currency
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_ReturnIn()) AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10300() THEN 1 * MIContainer.Amount ELSE 0 END ELSE 0 END) AS ReturnInSumm_10300_Currency

                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_PriceCorrective()) THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS PriceCorrectiveSumm_Currency
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_ChangePercent()) THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END)   AS ChangePercentSumm_Currency
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Cash(), zc_Movement_BankAccount(), zc_Movement_PersonalAccount()) THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END
                                       ) AS MoneySumm_Currency
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Service(), zc_Movement_ProfitLossService(), zc_Movement_ProfitIncomeService(), zc_Movement_TransportService()) THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END) AS ServiceSumm_Currency
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_ProfitLossService(), zc_Movement_ProfitIncomeService(), zc_Movement_TransportService()) THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END)
                                 + SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Service()) AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_SaleSumm_10300() THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END)
                                   AS ServiceRealSumm_Currency

                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_SendDebt()) THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END) AS SendDebtSumm_Currency
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Currency()) THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS ChangeCurrencySumm_Currency
                                 , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId NOT IN (zc_Movement_Income(), zc_Movement_IncomeAsset(), zc_Movement_ReturnOut()
                                                                                                                                    , zc_Movement_Sale(), zc_Movement_ReturnIn()
                                                                                                                                    , zc_Movement_PriceCorrective()
                                                                                                                                    , zc_Movement_TransferDebtOut(), zc_Movement_TransferDebtIn()
                                                                                                                                    , zc_Movement_Cash(), zc_Movement_BankAccount(), zc_Movement_PersonalAccount()
                                                                                                                                    , zc_Movement_Service(), zc_Movement_ProfitLossService(), zc_Movement_ProfitIncomeService(), zc_Movement_TransportService()
                                                                                                                                    , zc_Movement_SendDebt()
                                                                                                                                    , zc_Movement_Currency()
                                                                                                                                    , zc_Movement_ChangePercent()
                                                                                                                                     )
                                                                                                   THEN MIContainer.Amount
                                                                                              ELSE 0
                                                                                         END
                                             ELSE 0
                                        END
                                      + CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_IncomeAsset()) AND MIContainer.Amount > 0   THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END
                                       ) AS OtherSumm_Currency
                                 , tmpContainer.Amount_Currency - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS EndAmount_Currency
                            FROM tmpContainer
                                 LEFT JOIN MovementItemContainer AS MIContainer
                                                                 ON MIContainer.ContainerId = tmpContainer.ContainerId_Currency
                                                                AND MIContainer.OperDate >= inStartDate
                            WHERE tmpContainer.ContainerId_Currency > 0
                            GROUP BY tmpContainer.ContainerId, tmpContainer.ObjectId, tmpContainer.Amount_Currency, tmpContainer.JuridicalId, tmpContainer.InfoMoneyId, tmpContainer.PaidKindId
                                   , tmpContainer.ContractId, tmpContainer.BranchId, tmpContainer.PartionMovementId
                                   , tmpContainer.CurrencyId

                           )

        -- данные для юр.лица / контрагента - Признак ТТ
        , tmpPartnerTag AS (SELECT tmp.JuridicalId
                                 , ObjectLink_Partner_Juridical.ObjectId AS PartnerId
                                 , Object_PartnerTag.ValueData           AS PartnerTagName
                            FROM (SELECT DISTINCT Operation_all.JuridicalId FROM Operation_all) AS tmp
                                 LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                      ON ObjectLink_Partner_Juridical.ChildObjectId = tmp.JuridicalId
                                                     AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                 LEFT JOIN ObjectLink AS ObjectLink_Partner_PartnerTag
                                                      ON ObjectLink_Partner_PartnerTag.ObjectId = ObjectLink_Partner_Juridical.ObjectId
                                                     AND ObjectLink_Partner_PartnerTag.DescId = zc_ObjectLink_Partner_PartnerTag()
                                 LEFT JOIN Object AS Object_PartnerTag ON Object_PartnerTag.Id = ObjectLink_Partner_PartnerTag.ChildObjectId
                            )
         -- данные для юр.лица - Признак ТТ
        , tmpJuridical_PartnerTag AS (SELECT tmpPartnerTag.JuridicalId
                                           , STRING_AGG (DISTINCT tmpPartnerTag.PartnerTagName, '; ') AS PartnerTagName
                                      FROM tmpPartnerTag
                                      GROUP BY tmpPartnerTag.JuridicalId
                                      )

     -- Результат
     SELECT
        Operation.ContainerId,
        Object_Juridical.ObjectCode AS JuridicalCode,
        Object_Juridical.ValueData AS JuridicalName,
        ObjectHistory_JuridicalDetails_View.OKPO,
        ObjectHistory_JuridicalDetails_View.INN,
        Object_JuridicalGroup.ValueData  AS JuridicalGroupName,
        Object_Retail.ValueData       AS RetailName,
        Object_RetailReport.ValueData AS RetailReportName,
        Object_Partner.ObjectCode AS PartnerCode,
        Object_Partner.ValueData  AS PartnerName,
        CASE WHEN Object_Partner.ValueData <> '' THEN Object_Partner.ValueData ELSE Object_Juridical.ValueData END :: TVarChar AS JuridicalPartnerlName,

        Object_Branch.ObjectCode  AS BranchCode,
        Object_Branch.ValueData   AS BranchName,
        Object_Branch_personal.ValueData       AS BranchName_personal,
        Object_Branch_personal_trade.ValueData AS BranchName_personal_trade,

        View_Contract.ContractCode,
        View_Contract.InvNumber AS ContractNumber,
        View_Contract.ContractTagGroupName,
        View_Contract.ContractTagName,
        View_Contract.ContractStateKindCode
      , Object_JuridicalDocument.Id            AS ContractJuridicalDocId
      , Object_JuridicalDocument.ObjectCode    AS ContractJuridicalDocCode
      , Object_JuridicalDocument.ValueData     AS ContractJuridicalDocName
      , Object_Personal.ValueData              AS PersonalName,
        Object_PersonalTrade.ValueData         AS PersonalTradeName,
        Object_PersonalCollation.ValueData     AS PersonalCollationName,
        Object_PersonalTrade_Partner.ValueData AS PersonalTradeName_Partner,
        Object_PersonalSigning.PersonalName    AS PersonalSigningName,
        View_Contract.StartDate,
        View_Contract.EndDate,
        Object_PaidKind.ValueData AS PaidKindName,
        Object_Account_View.AccountName_all AS AccountName,
        Object_InfoMoney_View.InfoMoneyGroupName,
        Object_InfoMoney_View.InfoMoneyDestinationName,
        Object_InfoMoney_View.InfoMoneyCode,
        Object_InfoMoney_View.InfoMoneyName,
        Object_InfoMoney_View.InfoMoneyName_all,
        Object_Area.ValueData AS AreaName,
        Object_Area_Partner.ValueData AS AreaName_Partner,
        Object_Currency.ValueData AS CurrencyName,

        Object_ContractConditionKind.ValueData AS ContractConditionKindName,
        tmpContract.Value :: TFloat AS ContractConditionValue,

        Object_PartionMovement.ValueData             AS PartionMovementName,
        ObjectDate_PartionMovement_Payment.ValueData AS PaymentDate,

        Operation.ObjectId  AS AccountId,
        Object_Juridical.Id AS JuridicalId,
        Object_Partner.Id   AS PartnerId,
        Object_InfoMoney_View.InfoMoneyId,
        View_Contract.ContractId,
        Object_PaidKind.Id  AS PaidKindId,
        Object_Branch.Id    AS BranchId,

        (Operation.StartAmount * COALESCE (tmpReport_res.Koeff, 1.0)) ::TFloat AS StartAmount_A,
        (-1 * Operation.StartAmount * COALESCE (tmpReport_res.Koeff, 1.0)) ::TFloat AS StartAmount_P,
        CASE WHEN Operation.StartAmount > 0 THEN Operation.StartAmount * COALESCE (tmpReport_res.Koeff, 1.0) ELSE 0 END ::TFloat AS StartAmount_D,
        CASE WHEN Operation.StartAmount < 0 THEN -1 * Operation.StartAmount * COALESCE (tmpReport_res.Koeff, 1.0) ELSE 0 END :: TFloat AS StartAmount_K,

        (Operation.DebetSumm * COALESCE (tmpReport_res.Koeff, 1.0))::TFloat,
        (Operation.KreditSumm * COALESCE (tmpReport_res.Koeff, 1.0))::TFloat,

        (Operation.IncomeSumm * COALESCE (tmpReport_res.Koeff, 1.0))::TFloat,
        (Operation.ReturnOutSumm * COALESCE (tmpReport_res.Koeff, 1.0))::TFloat,
        (Operation.SaleSumm * COALESCE (tmpReport_res.Koeff, 1.0))::TFloat,
        (Operation.SaleRealSumm * COALESCE (tmpReport_res.Koeff, 1.0))::TFloat,
        (Operation.SaleSumm_10300 * COALESCE (tmpReport_res.Koeff, 1.0))::TFloat,

        ((Operation.SaleRealSumm + Operation.SaleSumm_10300) * COALESCE (tmpReport_res.Koeff, 1.0)) ::TFloat AS SaleRealSumm_total,

        (Operation.ReturnInSumm * COALESCE (tmpReport_res.Koeff, 1.0))::TFloat,
        (Operation.ReturnInRealSumm * COALESCE (tmpReport_res.Koeff, 1.0))::TFloat,
        (Operation.ReturnInSumm_10300 * COALESCE (tmpReport_res.Koeff, 1.0))::TFloat,
        ((Operation.ReturnInRealSumm + Operation.ReturnInSumm_10300) * COALESCE (tmpReport_res.Koeff, 1.0)) ::TFloat AS ReturnInRealSumm_total,
        (Operation.PriceCorrectiveSumm * COALESCE (tmpReport_res.Koeff, 1.0))::TFloat,
        (Operation.ChangePercentSumm * COALESCE (tmpReport_res.Koeff, 1.0))::TFloat AS ChangePercentSumm,
        (Operation.MoneySumm * COALESCE (tmpReport_res.Koeff, 1.0))::TFloat,
        (Operation.ServiceSumm * COALESCE (tmpReport_res.Koeff, 1.0))::TFloat,
        (Operation.ServiceRealSumm * COALESCE (tmpReport_res.Koeff, 1.0))::TFloat,
        (Operation.TransferDebtSumm * COALESCE (tmpReport_res.Koeff, 1.0))::TFloat,
        (Operation.SendDebtSumm * COALESCE (tmpReport_res.Koeff, 1.0))::TFloat,
        (Operation.ChangeCurrencySumm * COALESCE (tmpReport_res.Koeff, 1.0)) :: TFloat,
        (Operation.OtherSumm * COALESCE (tmpReport_res.Koeff, 1.0))::TFloat,

        (Operation.EndAmount * COALESCE (tmpReport_res.Koeff, 1.0)) ::TFloat AS EndAmount_A,
        (-1 * Operation.EndAmount * COALESCE (tmpReport_res.Koeff, 1.0)) ::TFloat AS EndAmount_P,
        CASE WHEN Operation.EndAmount > 0 THEN Operation.EndAmount * COALESCE (tmpReport_res.Koeff, 1.0) ELSE 0 END :: TFloat AS EndAmount_D,
        CASE WHEN Operation.EndAmount < 0 THEN -1 * Operation.EndAmount * COALESCE (tmpReport_res.Koeff, 1.0) ELSE 0 END :: TFloat AS EndAmount_K,
---
        (Operation.StartAmount_Currency * COALESCE (tmpReport_res.Koeff, 1.0))        ::TFloat AS StartAmount_Currency_A,
        (-1 * Operation.StartAmount_Currency * COALESCE (tmpReport_res.Koeff, 1.0)) ::TFloat AS StartAmount_Currency_P,
        CASE WHEN Operation.StartAmount_Currency > 0 THEN Operation.StartAmount_Currency * COALESCE (tmpReport_res.Koeff, 1.0) ELSE 0 END      ::TFloat AS StartAmount_Currency_D,
        CASE WHEN Operation.StartAmount_Currency < 0 THEN -1 * Operation.StartAmount_Currency * COALESCE (tmpReport_res.Koeff, 1.0) ELSE 0 END ::TFloat AS StartAmount_Currency_K,

        (Operation.DebetSumm_Currency * COALESCE (tmpReport_res.Koeff, 1.0))      ::TFloat,
        (Operation.KreditSumm_Currency * COALESCE (tmpReport_res.Koeff, 1.0))     ::TFloat,

        (Operation.IncomeSumm_Currency * COALESCE (tmpReport_res.Koeff, 1.0))     ::TFloat,
        (Operation.ReturnOutSumm_Currency * COALESCE (tmpReport_res.Koeff, 1.0))  ::TFloat,
        (Operation.SaleSumm_Currency * COALESCE (tmpReport_res.Koeff, 1.0))       ::TFloat,
        (Operation.SaleRealSumm_Currency * COALESCE (tmpReport_res.Koeff, 1.0))   ::TFloat,
        (Operation.SaleSumm_10300_Currency * COALESCE (tmpReport_res.Koeff, 1.0)) ::TFloat,

        ((Operation.SaleRealSumm_Currency + Operation.SaleSumm_10300_Currency) * COALESCE (tmpReport_res.Koeff, 1.0)) ::TFloat AS SaleRealSumm_total_Currency,

        (Operation.ReturnInSumm_Currency * COALESCE (tmpReport_res.Koeff, 1.0))       ::TFloat,
        (Operation.ReturnInRealSumm_Currency * COALESCE (tmpReport_res.Koeff, 1.0))   ::TFloat,
        (Operation.ReturnInSumm_10300_Currency * COALESCE (tmpReport_res.Koeff, 1.0)) ::TFloat,
        ((Operation.ReturnInRealSumm_Currency + Operation.ReturnInSumm_10300_Currency) * COALESCE (tmpReport_res.Koeff, 1.0)) ::TFloat AS ReturnInRealSumm_total_Currency,
        (Operation.PriceCorrectiveSumm_Currency * COALESCE (tmpReport_res.Koeff, 1.0))::TFloat,
        (Operation.ChangePercentSumm_Currency * COALESCE (tmpReport_res.Koeff, 1.0))  ::TFloat,
        (Operation.MoneySumm_Currency * COALESCE (tmpReport_res.Koeff, 1.0))          ::TFloat,
        (Operation.ServiceSumm_Currency * COALESCE (tmpReport_res.Koeff, 1.0))        ::TFloat,
        (Operation.ServiceRealSumm_Currency * COALESCE (tmpReport_res.Koeff, 1.0))    ::TFloat,
        (Operation.TransferDebtSumm_Currency * COALESCE (tmpReport_res.Koeff, 1.0))   ::TFloat,
        (Operation.SendDebtSumm_Currency * COALESCE (tmpReport_res.Koeff, 1.0))       ::TFloat,
        (Operation.ChangeCurrencySumm_Currency * COALESCE (tmpReport_res.Koeff, 1.0)) ::TFloat,
        (Operation.OtherSumm_Currency * COALESCE (tmpReport_res.Koeff, 1.0))          ::TFloat,

        (Operation.EndAmount_Currency * COALESCE (tmpReport_res.Koeff, 1.0))        ::TFloat AS EndAmount_Currency_A,
        (-1 * Operation.EndAmount_Currency * COALESCE (tmpReport_res.Koeff, 1.0))   ::TFloat AS EndAmount_Currency_P,
        CASE WHEN Operation.EndAmount_Currency > 0 THEN Operation.EndAmount_Currency * COALESCE (tmpReport_res.Koeff, 1.0) ELSE 0 END      ::TFloat AS EndAmount_Currency_D,
        CASE WHEN Operation.EndAmount_Currency < 0 THEN -1 * Operation.EndAmount_Currency * COALESCE (tmpReport_res.Koeff, 1.0) ELSE 0 END ::TFloat AS EndAmount_Currency_K,
        --
        COALESCE (tmpPartnerTag.PartnerTagName, tmpJuridical_PartnerTag.PartnerTagName,'') :: TVarChar AS PartnerTagName
     FROM
         (SELECT MAX (Operation_all.ContainerId) AS ContainerId
               , Operation_all.ObjectId, Operation_all.JuridicalId, Operation_all.InfoMoneyId
               , Operation_all.PaidKindId, Operation_all.BranchId, Operation_all.PartionMovementId
               , CLO_Partner.ObjectId AS PartnerId
               , View_Contract_ContractKey.ContractId_Key AS ContractId
               , Operation_all.CurrencyId

               , SUM (Operation_all.StartAmount)         AS StartAmount
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
               , SUM (Operation_all.TransferDebtSumm)    AS TransferDebtSumm
               , SUM (Operation_all.SendDebtSumm)        AS SendDebtSumm
               , SUM (Operation_all.ChangeCurrencySumm)  AS ChangeCurrencySumm
               , SUM (Operation_all.OtherSumm)           AS OtherSumm
               , SUM (Operation_all.EndAmount)           AS EndAmount
               --
               , SUM (Operation_all.StartAmount_Currency)         AS StartAmount_Currency
               , SUM (Operation_all.DebetSumm_Currency)           AS DebetSumm_Currency
               , SUM (Operation_all.KreditSumm_Currency)          AS KreditSumm_Currency
               , SUM (Operation_all.IncomeSumm_Currency)          AS IncomeSumm_Currency
               , SUM (Operation_all.ReturnOutSumm_Currency)       AS ReturnOutSumm_Currency
               , SUM (Operation_all.SaleSumm_Currency)            AS SaleSumm_Currency
               , SUM (Operation_all.SaleRealSumm_Currency)        AS SaleRealSumm_Currency
               , SUM (Operation_all.SaleSumm_10300_Currency)      AS SaleSumm_10300_Currency
               , SUM (Operation_all.ReturnInSumm_Currency)        AS ReturnInSumm_Currency
               , SUM (Operation_all.ReturnInRealSumm_Currency)    AS ReturnInRealSumm_Currency
               , SUM (Operation_all.ReturnInSumm_10300_Currency)  AS ReturnInSumm_10300_Currency
               , SUM (Operation_all.PriceCorrectiveSumm_Currency) AS PriceCorrectiveSumm_Currency
               , SUM (Operation_all.ChangePercentSumm_Currency)   AS ChangePercentSumm_Currency
               , SUM (Operation_all.MoneySumm_Currency)           AS MoneySumm_Currency
               , SUM (Operation_all.ServiceSumm_Currency)         AS ServiceSumm_Currency
               , SUM (Operation_all.ServiceRealSumm_Currency)     AS ServiceRealSumm_Currency
               , SUM (Operation_all.TransferDebtSumm_Currency)    AS TransferDebtSumm_Currency
               , SUM (Operation_all.SendDebtSumm_Currency)        AS SendDebtSumm_Currency
               , SUM (Operation_all.ChangeCurrencySumm_Currency)  AS ChangeCurrencySumm_Currency
               , SUM (Operation_all.OtherSumm_Currency)           AS OtherSumm_Currency
               , SUM (Operation_all.EndAmount_Currency)           AS EndAmount_Currency
          FROM Operation_all

           LEFT JOIN ContainerLinkObject AS CLO_Partner
                                         ON CLO_Partner.ContainerId = Operation_all.ContainerId
                                        AND CLO_Partner.DescId = zc_ContainerLinkObject_Partner()
           LEFT JOIN Object_Contract_ContractKey_View AS View_Contract_ContractKey ON View_Contract_ContractKey.ContractId = Operation_all.ContractId

          GROUP BY Operation_all.ObjectId, Operation_all.JuridicalId, Operation_all.InfoMoneyId, Operation_all.PaidKindId, Operation_all.BranchId, Operation_all.PartionMovementId
                 , View_Contract_ContractKey.ContractId_Key
                 , CLO_Partner.ObjectId
                 , Operation_all.CurrencyId

         ) AS Operation

           LEFT JOIN Object_Contract_View AS View_Contract
                                          ON View_Contract.ContractId = Operation.ContractId
                                         AND inEndDate BETWEEN View_Contract.StartDate_condition AND View_Contract.EndDate_condition

           LEFT JOIN ObjectLink AS ObjectLink_Contract_Area
                                ON ObjectLink_Contract_Area.ObjectId = Operation.ContractId
                               AND ObjectLink_Contract_Area.DescId = zc_ObjectLink_Contract_AreaContract()
           LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Contract_Area.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                ON ObjectLink_Partner_PersonalTrade.ObjectId = Operation.PartnerId
                               AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
           LEFT JOIN Object AS Object_PersonalTrade_Partner ON Object_PersonalTrade_Partner.Id = ObjectLink_Partner_PersonalTrade.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Partner_Area
                                ON ObjectLink_Partner_Area.ObjectId = Operation.PartnerId
                               AND ObjectLink_Partner_Area.DescId = zc_ObjectLink_Partner_Area()
           LEFT JOIN Object AS Object_Area_Partner ON Object_Area_Partner.Id = ObjectLink_Partner_Area.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Contract_Personal
                               ON ObjectLink_Contract_Personal.ObjectId = Operation.ContractId
                              AND ObjectLink_Contract_Personal.DescId = zc_ObjectLink_Contract_Personal()
           LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_Contract_Personal.ChildObjectId

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

           LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalDocument
                                ON ObjectLink_Contract_JuridicalDocument.ObjectId = Operation.ContractId
                               AND ObjectLink_Contract_JuridicalDocument.DescId = zc_ObjectLink_Contract_JuridicalDocument()
           LEFT JOIN Object AS Object_JuridicalDocument ON Object_JuridicalDocument.Id = ObjectLink_Contract_JuridicalDocument.ChildObjectId

           LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = Operation.ObjectId
           LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Operation.JuridicalId
           LEFT JOIN View_InfoMoney AS Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Operation.InfoMoneyId

           LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id

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

           -- Отв за договор - сотрудник
           LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                ON ObjectLink_Personal_PersonalServiceList.ObjectId = ObjectLink_Contract_Personal.ChildObjectId
                               AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
           LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Branch
                                ON ObjectLink_PersonalServiceList_Branch.ObjectId = ObjectLink_Personal_PersonalServiceList.ChildObjectId
                               AND ObjectLink_PersonalServiceList_Branch.DescId = zc_ObjectLink_PersonalServiceList_Branch()
           -- Отв за договор - сотрудник ТП
           LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList_trade
                                ON ObjectLink_Personal_PersonalServiceList_trade.ObjectId = ObjectLink_Contract_PersonalTrade.ChildObjectId
                               AND ObjectLink_Personal_PersonalServiceList_trade.DescId = zc_ObjectLink_Personal_PersonalServiceList()
           LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Branch_trade
                                ON ObjectLink_PersonalServiceList_Branch_trade.ObjectId = ObjectLink_Personal_PersonalServiceList_trade.ChildObjectId
                               AND ObjectLink_PersonalServiceList_Branch_trade.DescId = zc_ObjectLink_PersonalServiceList_Branch()

           LEFT JOIN Object AS Object_Branch_personal       ON Object_Branch_personal.Id = ObjectLink_PersonalServiceList_Branch.ChildObjectId
           LEFT JOIN Object AS Object_Branch_personal_trade ON Object_Branch_personal_trade.Id = ObjectLink_PersonalServiceList_Branch_trade.ChildObjectId

         --LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = COALESCE (Operation.BranchId, ObjectLink_PersonalServiceList_Branch_trade.ChildObjectId, ObjectLink_PersonalServiceList_Branch.ChildObjectId)
         --LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = COALESCE (Operation.BranchId, ObjectLink_PersonalServiceList_Branch.ChildObjectId)
           LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = Operation.BranchId

           LEFT JOIN tmpReport_res ON tmpReport_res.InfoMoneyId = Operation.InfoMoneyId
                                  AND tmpReport_res.Koeff > 0
                                  AND Operation.PaidKindId      = zc_Enum_PaidKind_FirstForm()
         --LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = COALESCE (Operation.BranchId, tmpReport_res.BranchId)

           LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = Operation.PartnerId
           LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = Operation.PaidKindId

           LEFT JOIN tmpContract ON tmpContract.JuridicalId = Operation.JuridicalId
           LEFT JOIN Object AS Object_ContractConditionKind ON Object_ContractConditionKind.Id = tmpContract.ContractConditionKindId

          LEFT JOIN Object AS Object_PartionMovement ON Object_PartionMovement.Id = Operation.PartionMovementId
          LEFT JOIN ObjectDate AS ObjectDate_PartionMovement_Payment
                               ON ObjectDate_PartionMovement_Payment.ObjectId = Operation.PartionMovementId
                              AND ObjectDate_PartionMovement_Payment.DescId = zc_ObjectDate_PartionMovement_Payment()

          LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = Operation.CurrencyId

          LEFT JOIN tmpPartnerTag ON tmpPartnerTag.PartnerId = Operation.PartnerId
          LEFT JOIN tmpJuridical_PartnerTag ON tmpJuridical_PartnerTag.JuridicalId = Operation.JuridicalId

     WHERE (Operation.StartAmount <> 0 OR Operation.EndAmount <> 0
         OR Operation.DebetSumm <> 0 OR Operation.KreditSumm <> 0);
    -- Конец. Добавили строковые данные.
    -- КОНЕЦ ЗАПРОСА

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.04.23         * add ChangePercentSumm
 13.01.20         * add Currency
 29.08.15         * add inIsPartionMovement
 14.11.14         * add inCurrencyId
 10.10.14                                        * add tmpContractCondition
 13.09.14                                        * add inJuridicalGroupId
 13.09.14                                        * add PersonalTradeName
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
-- SELECT * FROM lpReport_JuridicalSold (inStartDate:= '13.12.2022', inEndDate:= '13.12.2022', inStartDate_sale:= NULL, inEndDate_sale:= NULL, inAccountId:= 0, inInfoMoneyId:= 0, inInfoMoneyGroupId:= 0, inInfoMoneyDestinationId:= 0, inPaidKindId:= 0, inBranchId:= 0, inJuridicalGroupId:= 257169, inCurrencyId:= 76965, inIsPartionMovement:= FALSE, inUserId:= zfCalc_UserAdmin() :: Integer);
