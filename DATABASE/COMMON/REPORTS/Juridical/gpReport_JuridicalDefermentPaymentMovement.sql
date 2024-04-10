-- Function: gpReport_JuridicalSold()

DROP FUNCTION IF EXISTS gpReport_JuridicalDefermentPaymentMovement (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_JuridicalDefermentPaymentMovement(
    IN inOperDate         TDateTime , --
    IN inEmptyParam       TDateTime , --
    IN inAccountId        Integer   , --
    IN inPaidKindId       Integer   , --
    IN inBranchId         Integer   , --
    IN inJuridicalGroupId Integer   , --
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (AccountId Integer, AccountName TVarChar, JuridicalId Integer, JuridicalName TVarChar, RetailName TVarChar, RetailName_main TVarChar, OKPO TVarChar, JuridicalGroupName TVarChar
             , SectionId Integer, SectionName TVarChar
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
             , SaleSumm TFloat, DefermentPaymentRemains TFloat
             , SaleSumm1 TFloat, SaleSumm2 TFloat, SaleSumm3 TFloat, SaleSumm4 TFloat, SaleSumm5 TFloat
             , Condition TVarChar, StartContractDate TDateTime, Remains TFloat
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , AreaName TVarChar, AreaName_Partner TVarChar
             , BranchName_personal       TVarChar
             , BranchName_personal_trade TVarChar
             , PaymentDate TDateTime, PaymentAmount TFloat
             , PaymentDate_jur TDateTime, PaymentAmount_jur TFloat
             , MovementId      Integer
             , OperDate        TDateTime
             , OperDate_pay    TDateTime
             , MovementDescName TVarChar
             , InvNumber       TVarChar
             , ToId Integer, ToName TVarChar , PartnerTagName TVarChar
               -- нет просрочки на эту сумму
             , Summa_doc       TFloat
               -- просрочки на эту сумму - 1 неделя
             , Summa_doc1      TFloat
               -- просрочки на эту сумму - 2 неделя
             , Summa_doc2      TFloat
               -- просрочки на эту сумму - 3 неделя
             , Summa_doc3      TFloat
               -- просрочки на эту сумму - 4 неделя
             , Summa_doc4      TFloat
               -- просрочки на эту сумму > 4 недель
             , Summa_doc5      TFloat
               -- вся сумма накладной
             , TotalSumm       TFloat
               --  долг по накладной
             , TotalSumm_diff           TFloat
             , TotalSumm_diff_Deferment TFloat
               --
             , DayCount_condition Integer
             , DelayDay_calc   Integer
             , ContainerId     Integer
               --
             , a1 TFloat
             , a2 TFloat
             , a3 TFloat
             , a4 TFloat
             , a5 TFloat
             , a6 TFloat
             , a7 TFloat
             , a8 TFloat
             , a9 TFloat
             , a10 TFloat
             , a11 TFloat
             , a12 TFloat
             , a13 TFloat
             , Summa_doc_0 TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inOperDate, inOperDate, NULL, NULL, NULL, vbUserId);

     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE '_tmpReport')
     THEN
         DELETE FROM _tmpReport;
     ELSE
         -- таблица - элементы продаж для распределения Затрат по накладным
         CREATE TEMP TABLE _tmpReport ON COMMIT DROP AS
                      (SELECT tmpReport.*
                       FROM lpReport_JuridicalDefermentPayment (inOperDate         := inOperDate
                                                              , inEmptyParam       := inEmptyParam
                                                              , inStartDate_sale   := CASE WHEN DATE_TRUNC ('MONTH', inOperDate + INTERVAL '1 DAY') <> DATE_TRUNC ('MONTH', inOperDate)
                                                                                                     -- тогда здесь последний день мес, берем тек. месяц
                                                                                                     THEN DATE_TRUNC ('MONTH', inOperDate)
                                                                                                     -- берем прошлый месяц
                                                                                                     ELSE DATE_TRUNC ('MONTH', inOperDate) - INTERVAL '1 MONTH'
                                                                                                END
                                                              , inEndDate_sale     := CASE WHEN DATE_TRUNC ('MONTH', inOperDate + INTERVAL '1 DAY') <> DATE_TRUNC ('MONTH', inOperDate)
                                                                                                     -- тогда здесь последний день мес, берем тек. месяц
                                                                                                     THEN inOperDate
                                                                                                     -- берем прошлый месяц
                                                                                                     ELSE DATE_TRUNC ('MONTH', inOperDate) - INTERVAL '1 DAY'
                                                                                                END
                                                              , inAccountId        := inAccountId
                                                              , inPaidKindId       := inPaidKindId
                                                              , inBranchId         := inBranchId
                                                              , inJuridicalGroupId := inJuridicalGroupId
                                                              , inUserId           := -1 * vbUserId
                                                               ) AS tmpReport
                      )

     ;

     END IF;

     -- Результат
     RETURN QUERY
     WITH
     tmpReport AS (SELECT COALESCE (tmpReport.AccountId, tmpReport_minus.AccountId, 0) AS AccountId, COALESCE (tmpReport.AccountName, tmpReport_minus.AccountName) AS AccountName
                        , COALESCE (tmpReport.JuridicalId, tmpReport_minus.JuridicalId, 0) AS JuridicalId, COALESCE (tmpReport.JuridicalName, tmpReport_minus.JuridicalName) AS JuridicalName, tmpReport.RetailName, tmpReport.RetailName_main, tmpReport.OKPO, tmpReport.JuridicalGroupName
                        , tmpReport.SectionId, tmpReport.SectionName
                        , COALESCE (tmpReport.PartnerId, tmpReport_minus.PartnerId, 0) AS PartnerId, tmpReport.PartnerCode, tmpReport.PartnerName
                        , COALESCE (tmpReport.BranchId, tmpReport_minus.BranchId, 0) AS BranchId, tmpReport.BranchCode, tmpReport.BranchName
                        , COALESCE (tmpReport.PaidKindId, tmpReport_minus.PaidKindId, 0) AS PaidKindId, tmpReport.PaidKindName
                        , COALESCE (tmpReport.ContractId, tmpReport_minus.ContractId, 0) AS ContractId, tmpReport.ContractCode, tmpReport.ContractNumber
                        , tmpReport.ContractTagGroupName, tmpReport.ContractTagName, tmpReport.ContractStateKindCode
                        , tmpReport.ContractJuridicalDocId, tmpReport.ContractJuridicalDocCode, tmpReport.ContractJuridicalDocName
                        , tmpReport.PersonalName
                        , tmpReport.PersonalTradeName
                        , tmpReport.PersonalCollationName
                        , tmpReport.PersonalTradeName_Partner
                        , tmpReport.StartDate, tmpReport.EndDate
                          --
                        , CASE WHEN tmpReport.DebetRemains - tmpReport.KreditRemains > 0 THEN tmpReport.DebetRemains - tmpReport.KreditRemains ELSE 0 END AS DebetRemains
                        , CASE WHEN tmpReport.DebetRemains - tmpReport.KreditRemains < 0 THEN tmpReport.KreditRemains - tmpReport.DebetRemains ELSE 0 END AS KreditRemains

                        , COALESCE (tmpReport.SaleSumm, 0) - COALESCE (tmpReport_minus.SaleSumm, 0) AS SaleSumm
                        , tmpReport.DefermentPaymentRemains
                          --
                        , CASE WHEN tmpReport.DebetRemains - tmpReport.KreditRemains - tmpReport.DelayCreditLimit
                                  - tmpReport.SaleSumm > 0 AND tmpReport.SaleSumm1 > 0
                                    THEN CASE WHEN tmpReport.DebetRemains - tmpReport.KreditRemains - tmpReport.DelayCreditLimit
                                                 - tmpReport.SaleSumm > tmpReport.SaleSumm1
                                                   -- вся сумма из этого периода
                                                   THEN tmpReport.SaleSumm1
                                                   -- остаток от суммы
                                                   ELSE tmpReport.DebetRemains - tmpReport.KreditRemains - tmpReport.DelayCreditLimit
                                                      - tmpReport.SaleSumm
                                         END
                                    ELSE 0
                          END AS SaleSumm1
                          --
                        , CASE WHEN tmpReport.DebetRemains - tmpReport.KreditRemains - tmpReport.DelayCreditLimit
                                  - tmpReport.SaleSumm - tmpReport.SaleSumm1 > 0 AND tmpReport.SaleSumm2 > 0
                                    THEN CASE WHEN tmpReport.DebetRemains - tmpReport.KreditRemains - tmpReport.DelayCreditLimit
                                                 - tmpReport.SaleSumm - tmpReport.SaleSumm1 > tmpReport.SaleSumm2
                                                   -- вся сумма из этого периода
                                                   THEN tmpReport.SaleSumm2
                                                   -- остаток от суммы
                                                   ELSE tmpReport.DebetRemains - tmpReport.KreditRemains - tmpReport.DelayCreditLimit
                                                      - tmpReport.SaleSumm - tmpReport.SaleSumm1
                                         END
                                    ELSE 0
                          END AS SaleSumm2
                          --
                        , CASE WHEN tmpReport.DebetRemains - tmpReport.KreditRemains - tmpReport.DelayCreditLimit
                                  - tmpReport.SaleSumm - tmpReport.SaleSumm1 - tmpReport.SaleSumm2 > 0 AND tmpReport.SaleSumm3 > 0
                                    THEN CASE WHEN tmpReport.DebetRemains - tmpReport.KreditRemains - tmpReport.DelayCreditLimit
                                                 - tmpReport.SaleSumm - tmpReport.SaleSumm1 - tmpReport.SaleSumm2 > tmpReport.SaleSumm3
                                                   -- вся сумма из этого периода
                                                   THEN tmpReport.SaleSumm3
                                                   -- остаток от суммы
                                                   ELSE tmpReport.DebetRemains - tmpReport.KreditRemains - tmpReport.DelayCreditLimit
                                                      - tmpReport.SaleSumm - tmpReport.SaleSumm1 - tmpReport.SaleSumm2
                                         END
                                    ELSE 0
                          END AS SaleSumm3
                          --
                        , CASE WHEN tmpReport.DebetRemains - tmpReport.KreditRemains - tmpReport.DelayCreditLimit
                                  - tmpReport.SaleSumm - tmpReport.SaleSumm1 - tmpReport.SaleSumm2 - tmpReport.SaleSumm3 > 0 AND tmpReport.SaleSumm4 > 0
                                    THEN CASE WHEN tmpReport.DebetRemains - tmpReport.KreditRemains - tmpReport.DelayCreditLimit
                                                 - tmpReport.SaleSumm - tmpReport.SaleSumm1 - tmpReport.SaleSumm2 - tmpReport.SaleSumm3 > tmpReport.SaleSumm4
                                                   -- вся сумма из этого периода
                                                   THEN tmpReport.SaleSumm4
                                                   -- остаток от суммы
                                                   ELSE tmpReport.DebetRemains - tmpReport.KreditRemains - tmpReport.DelayCreditLimit
                                                      - tmpReport.SaleSumm - tmpReport.SaleSumm1 - tmpReport.SaleSumm2 - tmpReport.SaleSumm3
                                         END
                                    ELSE 0
                          END AS SaleSumm4
                          --
                        --, tmpReport.SaleSumm5
                        , CASE WHEN (tmpReport.DebetRemains - tmpReport.KreditRemains - tmpReport.DelayCreditLimit
                                   - tmpReport.SaleSumm - tmpReport.SaleSumm1 - tmpReport.SaleSumm2 - tmpReport.SaleSumm3 - tmpReport.SaleSumm4) > 0
                                     THEN tmpReport.DebetRemains - tmpReport.KreditRemains - tmpReport.DelayCreditLimit
                                        - tmpReport.SaleSumm - tmpReport.SaleSumm1 - tmpReport.SaleSumm2 - tmpReport.SaleSumm3 - tmpReport.SaleSumm4
                                     ELSE 0
                          END AS SaleSumm5
                          --
                        , tmpReport.Condition, tmpReport.StartContractDate, tmpReport.Remains
                        , tmpReport.InfoMoneyGroupName, tmpReport.InfoMoneyDestinationName, tmpReport.InfoMoneyId, tmpReport.InfoMoneyCode, tmpReport.InfoMoneyName
                        , tmpReport.AreaName, tmpReport.AreaName_Partner

                        , tmpReport.BranchName_personal
                        , tmpReport.BranchName_personal_trade
                        , tmpReport.ContainerId

                        , tmpReport.DayCount
                        , tmpReport.ContractConditionKindId
                   FROM (SELECT COALESCE (_tmpReport.AccountId, 0) AS AccountId, _tmpReport.AccountName
                              , COALESCE (_tmpReport.JuridicalId, 0) AS JuridicalId, _tmpReport.JuridicalName, _tmpReport.RetailName, _tmpReport.RetailName_main, _tmpReport.OKPO, _tmpReport.JuridicalGroupName
                              , _tmpReport.SectionId, _tmpReport.SectionName
                              , COALESCE (_tmpReport.PartnerId, 0) AS PartnerId, _tmpReport.PartnerCode, _tmpReport.PartnerName
                              , COALESCE (_tmpReport.BranchId, 0) AS BranchId, _tmpReport.BranchCode, _tmpReport.BranchName
                              , COALESCE (_tmpReport.PaidKindId, 0) AS PaidKindId, _tmpReport.PaidKindName
                              , COALESCE (_tmpReport.ContractId, 0) AS ContractId, _tmpReport.ContractCode, _tmpReport.ContractNumber
                              , _tmpReport.ContractTagGroupName, _tmpReport.ContractTagName, _tmpReport.ContractStateKindCode
                              , _tmpReport.ContractJuridicalDocId, _tmpReport.ContractJuridicalDocCode, _tmpReport.ContractJuridicalDocName
                              , _tmpReport.PersonalName
                              , _tmpReport.PersonalTradeName
                              , _tmpReport.PersonalCollationName
                              , _tmpReport.PersonalTradeName_Partner
                              , _tmpReport.StartDate, _tmpReport.EndDate
                              , SUM (_tmpReport.DebetRemains) :: TFloat AS DebetRemains, SUM (_tmpReport.KreditRemains) :: TFloat AS KreditRemains
                              , SUM (_tmpReport.SaleSumm) :: TFloat AS SaleSumm, SUM (_tmpReport.DefermentPaymentRemains) :: TFloat AS DefermentPaymentRemains
                              , SUM (_tmpReport.SaleSumm1) :: TFloat AS SaleSumm1, SUM (_tmpReport.SaleSumm2) :: TFloat AS SaleSumm2, SUM (_tmpReport.SaleSumm3) :: TFloat AS SaleSumm3
                              , SUM (_tmpReport.SaleSumm4) :: TFloat AS SaleSumm4, SUM (_tmpReport.SaleSumm5) :: TFloat AS SaleSumm5
                              , _tmpReport.DelayCreditLimit
                              , _tmpReport.Condition, _tmpReport.StartContractDate, SUM (_tmpReport.Remains) :: TFloat AS Remains
                              , _tmpReport.InfoMoneyGroupName, _tmpReport.InfoMoneyDestinationName, _tmpReport.InfoMoneyId, _tmpReport.InfoMoneyCode, _tmpReport.InfoMoneyName
                              , _tmpReport.AreaName, _tmpReport.AreaName_Partner

                              , _tmpReport.BranchName_personal
                              , _tmpReport.BranchName_personal_trade
                              , MAX (_tmpReport.ContainerId) AS ContainerId

                              , _tmpReport.DayCount
                              , _tmpReport.ContractConditionKindId
                         FROM _tmpReport
                         GROUP BY _tmpReport.AccountId, _tmpReport.AccountName
                                , _tmpReport.JuridicalId, _tmpReport.JuridicalName, _tmpReport.RetailName, _tmpReport.RetailName_main, _tmpReport.OKPO, _tmpReport.JuridicalGroupName
                                , _tmpReport.SectionId, _tmpReport.SectionName
                                , _tmpReport.PartnerId, _tmpReport.PartnerCode, _tmpReport.PartnerName
                                , _tmpReport.BranchId, _tmpReport.BranchCode, _tmpReport.BranchName
                                , _tmpReport.PaidKindId, _tmpReport.PaidKindName
                                , _tmpReport.ContractId, _tmpReport.ContractCode, _tmpReport.ContractNumber
                                , _tmpReport.ContractTagGroupName, _tmpReport.ContractTagName, _tmpReport.ContractStateKindCode
                                , _tmpReport.ContractJuridicalDocId, _tmpReport.ContractJuridicalDocCode, _tmpReport.ContractJuridicalDocName
                                , _tmpReport.PersonalName
                                , _tmpReport.PersonalTradeName
                                , _tmpReport.PersonalCollationName
                                , _tmpReport.PersonalTradeName_Partner
                                , _tmpReport.StartDate, _tmpReport.EndDate
                                , _tmpReport.DelayCreditLimit
                                , _tmpReport.Condition, _tmpReport.StartContractDate
                                , _tmpReport.InfoMoneyGroupName, _tmpReport.InfoMoneyDestinationName, _tmpReport.InfoMoneyId, _tmpReport.InfoMoneyCode, _tmpReport.InfoMoneyName
                                , _tmpReport.AreaName, _tmpReport.AreaName_Partner

                                , _tmpReport.BranchName_personal
                                , _tmpReport.BranchName_personal_trade

                                , _tmpReport.DayCount
                                , _tmpReport.ContractConditionKindId
                         HAVING SUM (_tmpReport.DebetRemains) <> 0
                             OR SUM (_tmpReport.KreditRemains) <> 0
                           --OR SUM (_tmpReport.SaleSumm) > 0
                             OR SUM (_tmpReport.DefermentPaymentRemains) > 0
                             OR SUM (_tmpReport.SaleSumm1) > 0
                             OR SUM (_tmpReport.SaleSumm2) > 0
                             OR SUM (_tmpReport.SaleSumm3) > 0
                             OR SUM (_tmpReport.SaleSumm4) > 0
                             OR SUM (_tmpReport.SaleSumm5) > 0
                        ) AS tmpReport
                        LEFT JOIN (SELECT COALESCE (_tmpReport.AccountId, 0)   AS AccountId, _tmpReport.AccountName
                                        , COALESCE (_tmpReport.JuridicalId, 0) AS JuridicalId, _tmpReport.JuridicalName
                                        , COALESCE (_tmpReport.PartnerId, 0)   AS PartnerId
                                        , COALESCE (_tmpReport.BranchId, 0)    AS BranchId
                                        , COALESCE (_tmpReport.PaidKindId, 0)  AS PaidKindId
                                        , COALESCE (_tmpReport.ContractId, 0)  AS ContractId
                                        , SUM (_tmpReport.SaleSumm) :: TFloat  AS SaleSumm
                                   FROM _tmpReport
                                   --where 1=0
                                   GROUP BY COALESCE (_tmpReport.AccountId, 0), _tmpReport.AccountName
                                          , COALESCE (_tmpReport.JuridicalId, 0), _tmpReport.JuridicalName
                                          , COALESCE (_tmpReport.PartnerId, 0)
                                          , COALESCE (_tmpReport.BranchId, 0)
                                          , COALESCE (_tmpReport.PaidKindId, 0)
                                          , COALESCE (_tmpReport.ContractId, 0)
                                   HAVING SUM (_tmpReport.DebetRemains) <= 0
                                    --AND SUM (_tmpReport.SaleSumm) <= 0
                                      AND SUM (_tmpReport.DefermentPaymentRemains) <= 0
                                      AND SUM (_tmpReport.SaleSumm1) <= 0
                                      AND SUM (_tmpReport.SaleSumm2) <= 0
                                      AND SUM (_tmpReport.SaleSumm3) <= 0
                                      AND SUM (_tmpReport.SaleSumm4) <= 0
                                      AND SUM (_tmpReport.SaleSumm5) <= 0
                                  ) AS tmpReport_minus ON tmpReport_minus.AccountId   = tmpReport.AccountId
                                                      AND tmpReport_minus.JuridicalId = tmpReport.JuridicalId
                                                      AND tmpReport_minus.PartnerId   = tmpReport.PartnerId
                                                      AND tmpReport_minus.BranchId    = tmpReport.BranchId
                                                      AND tmpReport_minus.PaidKindId  = tmpReport.PaidKindId
                                                      AND tmpReport_minus.ContractId  = tmpReport.ContractId
                  )
     -- выбираем последнии оплаты
   , tmpLastPayment_all AS (SELECT tt.JuridicalId
                                 , tt.ContractId
                                 , tt.PaidKindId
                                 , COALESCE (tt.PartnerId, 0) AS PartnerId
                                 , tt.OperDate
                                 , ObjectLink_Contract_InfoMoney.ChildObjectId AS InfoMoneyId
                                 , tt.Amount
                            FROM gpSelect_Object_JuridicalDefermentPayment (inSession) AS tt
                                 JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                                 ON ObjectLink_Contract_InfoMoney.ObjectId = tt.ContractId
                                                AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                            WHERE 1=0
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
     -- Список для Продажи за "период" + просрочка только 4 недели
   , tmpContainer AS (SELECT DISTINCT
                             _tmpReport.ContainerId
                           , COALESCE (_tmpReport.JuridicalId, 0) AS JuridicalId
                           , COALESCE (_tmpReport.PartnerId,   0) AS PartnerId
                           , COALESCE (_tmpReport.ContractId,  0) AS ContractId
                           , COALESCE (_tmpReport.PaidKindId,  0) AS PaidKindId
                           , COALESCE (_tmpReport.BranchId,    0) AS BranchId
                           , _tmpReport.StartContractDate
                             -- какой период нужен, может так будет быстрее
                           , CASE WHEN _tmpReport.SaleSumm4 > 0 THEN 4
                                  WHEN _tmpReport.SaleSumm3 > 0 THEN 3
                                  WHEN _tmpReport.SaleSumm2 > 0 THEN 2
                                  WHEN _tmpReport.SaleSumm1 > 0 THEN 1
                                  ELSE 0
                             END AS Period_add
                      FROM _tmpReport
                      WHERE COALESCE (_tmpReport.SaleSumm,  0) <> 0
                         OR COALESCE (_tmpReport.SaleSumm1, 0) <> 0
                         OR COALESCE (_tmpReport.SaleSumm2, 0) <> 0
                         OR COALESCE (_tmpReport.SaleSumm3, 0) <> 0
                         OR COALESCE (_tmpReport.SaleSumm4, 0) <> 0
                     )
   -- Продажи за "период" + просрочка только 4 недели
 , tmpContainerData_all AS (SELECT tmpContainer.JuridicalId
                                 , tmpContainer.PartnerId
                                 , tmpContainer.ContractId
                                 , tmpContainer.PaidKindId
                                 , tmpContainer.BranchId
                                 , MIContainer.MovementId
                                 , MAX (COALESCE (MovementDate_OperDatePartner.ValueData, MIContainer.OperDate)) AS OperDate
                                 , SUM (CASE WHEN MIContainer.OperDate < inOperDate                                    AND MIContainer.OperDate >= tmpContainer.StartContractDate                THEN CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() THEN MIContainer.Amount WHEN MIContainer.MovementDescId IN (zc_Movement_TransferDebtOut(), zc_Movement_Income()) AND MIContainer.isActive = TRUE THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS Amount
                                 , SUM (CASE WHEN MIContainer.OperDate < tmpContainer.StartContractDate:: Date - 0 * 7 AND MIContainer.OperDate >= tmpContainer.StartContractDate:: Date - 1 * 7 THEN CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() THEN MIContainer.Amount WHEN MIContainer.MovementDescId IN (zc_Movement_TransferDebtOut(), zc_Movement_Income()) AND MIContainer.isActive = TRUE THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS Amount1
                                 , SUM (CASE WHEN MIContainer.OperDate < tmpContainer.StartContractDate:: Date - 1 * 7 AND MIContainer.OperDate >= tmpContainer.StartContractDate:: Date - 2 * 7 THEN CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() THEN MIContainer.Amount WHEN MIContainer.MovementDescId IN (zc_Movement_TransferDebtOut(), zc_Movement_Income()) AND MIContainer.isActive = TRUE THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS Amount2
                                 , SUM (CASE WHEN MIContainer.OperDate < tmpContainer.StartContractDate:: Date - 2 * 7 AND MIContainer.OperDate >= tmpContainer.StartContractDate:: Date - 3 * 7 THEN CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() THEN MIContainer.Amount WHEN MIContainer.MovementDescId IN (zc_Movement_TransferDebtOut(), zc_Movement_Income()) AND MIContainer.isActive = TRUE THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS Amount3
                                 , SUM (CASE WHEN MIContainer.OperDate < tmpContainer.StartContractDate:: Date - 3 * 7 AND MIContainer.OperDate >= tmpContainer.StartContractDate:: Date - 4 * 7 THEN CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() THEN MIContainer.Amount WHEN MIContainer.MovementDescId IN (zc_Movement_TransferDebtOut(), zc_Movement_Income()) AND MIContainer.isActive = TRUE THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS Amount4
                            FROM tmpContainer
                                 INNER JOIN MovementItemContainer AS MIContainer
                                                                  ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                                 AND MIContainer.DescId      = zc_MIContainer_Summ()
                                                                 AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_TransferDebtOut(), zc_Movement_Income())
                                                                 AND MIContainer.OperDate >= tmpContainer.StartContractDate :: Date - tmpContainer.Period_add * 7
                                                                 AND MIContainer.OperDate < inOperDate
                                 LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                        ON MovementDate_OperDatePartner.MovementId = MIContainer.MovementId
                                                       AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
-- where tmpContainer.JuridicalId = 8578350
                            GROUP BY tmpContainer.JuridicalId
                                   , tmpContainer.PartnerId
                                   , tmpContainer.ContractId
                                   , tmpContainer.PaidKindId
                                   , tmpContainer.BranchId
                                   , MIContainer.MovementId
                            HAVING
                                0 <> SUM (CASE WHEN MIContainer.OperDate < inOperDate                                    AND MIContainer.OperDate >= tmpContainer.StartContractDate                THEN CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() THEN MIContainer.Amount WHEN MIContainer.MovementDescId IN (zc_Movement_TransferDebtOut(), zc_Movement_Income()) AND MIContainer.isActive = TRUE THEN MIContainer.Amount ELSE 0 END ELSE 0 END)
                             OR 0 <> SUM (CASE WHEN MIContainer.OperDate < tmpContainer.StartContractDate:: Date - 0 * 7 AND MIContainer.OperDate >= tmpContainer.StartContractDate:: Date - 1 * 7 THEN CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() THEN MIContainer.Amount WHEN MIContainer.MovementDescId IN (zc_Movement_TransferDebtOut(), zc_Movement_Income()) AND MIContainer.isActive = TRUE THEN MIContainer.Amount ELSE 0 END ELSE 0 END)
                             OR 0 <> SUM (CASE WHEN MIContainer.OperDate < tmpContainer.StartContractDate:: Date - 1 * 7 AND MIContainer.OperDate >= tmpContainer.StartContractDate:: Date - 2 * 7 THEN CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() THEN MIContainer.Amount WHEN MIContainer.MovementDescId IN (zc_Movement_TransferDebtOut(), zc_Movement_Income()) AND MIContainer.isActive = TRUE THEN MIContainer.Amount ELSE 0 END ELSE 0 END)
                             OR 0 <> SUM (CASE WHEN MIContainer.OperDate < tmpContainer.StartContractDate:: Date - 2 * 7 AND MIContainer.OperDate >= tmpContainer.StartContractDate:: Date - 3 * 7 THEN CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() THEN MIContainer.Amount WHEN MIContainer.MovementDescId IN (zc_Movement_TransferDebtOut(), zc_Movement_Income()) AND MIContainer.isActive = TRUE THEN MIContainer.Amount ELSE 0 END ELSE 0 END)
                             OR 0 <> SUM (CASE WHEN MIContainer.OperDate < tmpContainer.StartContractDate:: Date - 3 * 7 AND MIContainer.OperDate >= tmpContainer.StartContractDate:: Date - 4 * 7 THEN CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() THEN MIContainer.Amount WHEN MIContainer.MovementDescId IN (zc_Movement_TransferDebtOut(), zc_Movement_Income()) AND MIContainer.isActive = TRUE THEN MIContainer.Amount ELSE 0 END ELSE 0 END)

                          /* UNION ALL

                            SELECT tmpContainer.JuridicalId
                                 , tmpContainer.PartnerId
                                 , tmpContainer.ContractId
                                 , tmpContainer.PaidKindId
                                 , tmpContainer.BranchId
                                 , MIContainer.MovementId
                                 , MAX (COALESCE (MovementDate_OperDatePartner.ValueData, MIContainer.OperDate)) AS OperDate
                                 , SUM (CASE WHEN MIContainer.OperDate < inOperDate                                    AND MIContainer.OperDate >= tmpContainer.StartContractDate                THEN CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() THEN MIContainer.Amount WHEN MIContainer.MovementDescId IN (zc_Movement_TransferDebtOut(), zc_Movement_Income()) AND MIContainer.isActive = TRUE THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS Amount
                                 , SUM (CASE WHEN MIContainer.OperDate < tmpContainer.StartContractDate:: Date - 0 * 7 AND MIContainer.OperDate >= tmpContainer.StartContractDate:: Date - 1 * 7 THEN CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() THEN MIContainer.Amount WHEN MIContainer.MovementDescId IN (zc_Movement_TransferDebtOut(), zc_Movement_Income()) AND MIContainer.isActive = TRUE THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS Amount1
                                 , SUM (CASE WHEN MIContainer.OperDate < tmpContainer.StartContractDate:: Date - 1 * 7 AND MIContainer.OperDate >= tmpContainer.StartContractDate:: Date - 2 * 7 THEN CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() THEN MIContainer.Amount WHEN MIContainer.MovementDescId IN (zc_Movement_TransferDebtOut(), zc_Movement_Income()) AND MIContainer.isActive = TRUE THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS Amount2
                                 , SUM (CASE WHEN MIContainer.OperDate < tmpContainer.StartContractDate:: Date - 2 * 7 AND MIContainer.OperDate >= tmpContainer.StartContractDate:: Date - 3 * 7 THEN CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() THEN MIContainer.Amount WHEN MIContainer.MovementDescId IN (zc_Movement_TransferDebtOut(), zc_Movement_Income()) AND MIContainer.isActive = TRUE THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS Amount3
                                 , SUM (CASE WHEN MIContainer.OperDate < tmpContainer.StartContractDate:: Date - 3 * 7 AND MIContainer.OperDate >= tmpContainer.StartContractDate:: Date - 4 * 7 THEN CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() THEN MIContainer.Amount WHEN MIContainer.MovementDescId IN (zc_Movement_TransferDebtOut(), zc_Movement_Income()) AND MIContainer.isActive = TRUE THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS Amount4
                            FROM tmpContainer
                                 INNER JOIN MovementItemContainer AS MIContainer
                                                                  ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                                 AND MIContainer.DescId      = zc_MIContainer_Summ()
                                                                 AND MIContainer.MovementDescId IN (zc_Movement_SendDebt())
                                                                 AND MIContainer.Amount   > 0
                                                                 AND MIContainer.OperDate >= tmpContainer.StartContractDate :: Date - tmpContainer.Period_add * 7
                                                                 AND MIContainer.OperDate < inOperDate
                                 LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                        ON MovementDate_OperDatePartner.MovementId = MIContainer.MovementId
                                                       AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
                            GROUP BY tmpContainer.JuridicalId
                                   , tmpContainer.PartnerId
                                   , tmpContainer.ContractId
                                   , tmpContainer.PaidKindId
                                   , tmpContainer.BranchId
                                   , MIContainer.MovementId
                            HAVING
                                0 <> SUM (CASE WHEN MIContainer.OperDate < inOperDate                                    AND MIContainer.OperDate >= tmpContainer.StartContractDate                THEN CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() THEN MIContainer.Amount WHEN MIContainer.MovementDescId IN (zc_Movement_TransferDebtOut(), zc_Movement_Income()) AND MIContainer.isActive = TRUE THEN MIContainer.Amount ELSE 0 END ELSE 0 END)
                             OR 0 <> SUM (CASE WHEN MIContainer.OperDate < tmpContainer.StartContractDate:: Date - 0 * 7 AND MIContainer.OperDate >= tmpContainer.StartContractDate:: Date - 1 * 7 THEN CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() THEN MIContainer.Amount WHEN MIContainer.MovementDescId IN (zc_Movement_TransferDebtOut(), zc_Movement_Income()) AND MIContainer.isActive = TRUE THEN MIContainer.Amount ELSE 0 END ELSE 0 END)
                             OR 0 <> SUM (CASE WHEN MIContainer.OperDate < tmpContainer.StartContractDate:: Date - 1 * 7 AND MIContainer.OperDate >= tmpContainer.StartContractDate:: Date - 2 * 7 THEN CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() THEN MIContainer.Amount WHEN MIContainer.MovementDescId IN (zc_Movement_TransferDebtOut(), zc_Movement_Income()) AND MIContainer.isActive = TRUE THEN MIContainer.Amount ELSE 0 END ELSE 0 END)
                             OR 0 <> SUM (CASE WHEN MIContainer.OperDate < tmpContainer.StartContractDate:: Date - 2 * 7 AND MIContainer.OperDate >= tmpContainer.StartContractDate:: Date - 3 * 7 THEN CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() THEN MIContainer.Amount WHEN MIContainer.MovementDescId IN (zc_Movement_TransferDebtOut(), zc_Movement_Income()) AND MIContainer.isActive = TRUE THEN MIContainer.Amount ELSE 0 END ELSE 0 END)
                             OR 0 <> SUM (CASE WHEN MIContainer.OperDate < tmpContainer.StartContractDate:: Date - 3 * 7 AND MIContainer.OperDate >= tmpContainer.StartContractDate:: Date - 4 * 7 THEN CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() THEN MIContainer.Amount WHEN MIContainer.MovementDescId IN (zc_Movement_TransferDebtOut(), zc_Movement_Income()) AND MIContainer.isActive = TRUE THEN MIContainer.Amount ELSE 0 END ELSE 0 END)

*/
                           )
   -- Продажи за "период" + просрочка только 4 недели + накопительно
  , tmpContainerData_gr AS (SELECT tmpData.JuridicalId
                                 , tmpData.PartnerId
                                 , tmpData.ContractId
                                 , tmpData.PaidKindId
                                 , tmpData.BranchId
                                 , tmpData.MovementId
                                 , tmpData.OperDate
                                 , tmpData.Amount
                                 , tmpData.Amount1
                                 , tmpData.Amount2
                                 , tmpData.Amount3
                                 , tmpData.Amount4
                                 , SUM (tmpData.Amount)  OVER (PARTITION BY tmpData.JuridicalId, tmpData.PartnerId, tmpData.ContractId, tmpData.PaidKindId, tmpData.BranchId ORDER BY tmpData.OperDate DESC, tmpData.MovementId DESC) AS Amount_summ
                                 , SUM (tmpData.Amount1) OVER (PARTITION BY tmpData.JuridicalId, tmpData.PartnerId, tmpData.ContractId, tmpData.PaidKindId, tmpData.BranchId ORDER BY tmpData.OperDate DESC, tmpData.MovementId DESC) AS Amount1_summ
                                 , SUM (tmpData.Amount2) OVER (PARTITION BY tmpData.JuridicalId, tmpData.PartnerId, tmpData.ContractId, tmpData.PaidKindId, tmpData.BranchId ORDER BY tmpData.OperDate DESC, tmpData.MovementId DESC) AS Amount2_summ
                                 , SUM (tmpData.Amount3) OVER (PARTITION BY tmpData.JuridicalId, tmpData.PartnerId, tmpData.ContractId, tmpData.PaidKindId, tmpData.BranchId ORDER BY tmpData.OperDate DESC, tmpData.MovementId DESC) AS Amount3_summ
                                 , SUM (tmpData.Amount4) OVER (PARTITION BY tmpData.JuridicalId, tmpData.PartnerId, tmpData.ContractId, tmpData.PaidKindId, tmpData.BranchId ORDER BY tmpData.OperDate DESC, tmpData.MovementId DESC) AS Amount4_summ
                            FROM tmpContainerData_all AS tmpData
                           )
     -- 3.1.Список для просрочка только с 5 недели + 2 месяца
   , tmpContainer_next5_1 AS (SELECT DISTINCT
                                     _tmpReport.ContainerId
                                   , _tmpReport.StartContractDate
                                   , COALESCE (_tmpReport.JuridicalId, 0) AS JuridicalId
                                   , COALESCE (_tmpReport.PartnerId,   0) AS PartnerId
                                   , COALESCE (_tmpReport.ContractId,  0) AS ContractId
                                   , COALESCE (_tmpReport.PaidKindId,  0) AS PaidKindId
                                   , COALESCE (_tmpReport.BranchId,    0) AS BranchId
                              FROM _tmpReport
                              WHERE _tmpReport.SaleSumm5 > 0
                             )
   -- 3.2.Просрочка только с 5 недели + 2 месяца
 , tmpContainerData_all_next5_1 AS (SELECT tmpContainer.JuridicalId
                                         , tmpContainer.PartnerId
                                         , tmpContainer.ContractId
                                         , tmpContainer.PaidKindId
                                         , tmpContainer.BranchId
                                         , MIContainer.MovementId
                                         , MAX (COALESCE (MovementDate_OperDatePartner.ValueData, MIContainer.OperDate)) AS OperDate
                                         , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() THEN MIContainer.Amount WHEN MIContainer.MovementDescId = zc_Movement_TransferDebtOut() AND MIContainer.isActive = TRUE THEN MIContainer.Amount ELSE 0 END) AS Amount

                                    FROM tmpContainer_next5_1 AS tmpContainer
                                         INNER JOIN MovementItemContainer AS MIContainer
                                                                          ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                                         AND MIContainer.DescId      = zc_MIContainer_Summ()
                                                                         AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_TransferDebtOut())
                                                                         AND MIContainer.OperDate >= tmpContainer.StartContractDate :: Date - 4 * 7 - INTERVAL '3 MONTH'
                                                                         AND MIContainer.OperDate < tmpContainer.StartContractDate :: Date - 4 * 7
                                         LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                                ON MovementDate_OperDatePartner.MovementId = MIContainer.MovementId
                                                               AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
-- where tmpContainer.JuridicalId = 8578350
                                    GROUP BY tmpContainer.JuridicalId
                                           , tmpContainer.PartnerId
                                           , tmpContainer.ContractId
                                           , tmpContainer.PaidKindId
                                           , tmpContainer.BranchId
                                           , MIContainer.MovementId
                                    HAVING
                                        0 <> SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() THEN MIContainer.Amount WHEN MIContainer.MovementDescId = zc_Movement_TransferDebtOut() AND MIContainer.isActive = TRUE THEN MIContainer.Amount ELSE 0 END)
                                   )
     -- 4.1.Список для просрочка только + 6 месяцев - по ком еще надо найти
   , tmpContainer_next5_2 AS (SELECT DISTINCT
                                     _tmpReport.ContainerId
                                   , _tmpReport.StartContractDate
                                   , COALESCE (_tmpReport.JuridicalId, 0) AS JuridicalId
                                   , COALESCE (_tmpReport.PartnerId,   0) AS PartnerId
                                   , COALESCE (_tmpReport.ContractId,  0) AS ContractId
                                   , COALESCE (_tmpReport.PaidKindId,  0) AS PaidKindId
                                   , COALESCE (_tmpReport.BranchId,    0) AS BranchId

                              FROM _tmpReport
                                   -- итого по отчету
                                   JOIN tmpReport ON tmpReport.JuridicalId = _tmpReport.JuridicalId
                                                 AND tmpReport.PartnerId   = COALESCE (_tmpReport.PartnerId, 0)
                                                 AND tmpReport.ContractId  = _tmpReport.ContractId
                                                 AND tmpReport.PaidKindId  = _tmpReport.PaidKindId
                                                 AND tmpReport.BranchId    = COALESCE (_tmpReport.BranchId, 0)
                                   -- минус предыдущий период
                                   LEFT JOIN (SELECT tmpData.JuridicalId
                                                   , tmpData.PartnerId
                                                   , tmpData.ContractId
                                                   , tmpData.PaidKindId
                                                   , tmpData.BranchId
                                                   , SUM (tmpData.Amount) AS Amount
                                              FROM tmpContainerData_all_next5_1 AS tmpData
                                              GROUP BY tmpData.JuridicalId
                                                     , tmpData.PartnerId
                                                     , tmpData.ContractId
                                                     , tmpData.PaidKindId
                                                     , tmpData.BranchId
                                             ) AS tmp_old_1 ON tmp_old_1.JuridicalId = _tmpReport.JuridicalId
                                                           AND tmp_old_1.PartnerId   = _tmpReport.PartnerId
                                                           AND tmp_old_1.ContractId  = _tmpReport.ContractId
                                                           AND tmp_old_1.PaidKindId  = _tmpReport.PaidKindId
                                                           AND tmp_old_1.BranchId    = _tmpReport.BranchId
                              WHERE _tmpReport.SaleSumm5 > 0
                                -- если в предыдущем поиске не закрыли всю сумму
                                AND tmpReport.SaleSumm5 - COALESCE (tmp_old_1.Amount, 0) > 0
                             )
   -- 4.2.Просрочка только + 6 месяцев
 , tmpContainerData_all_next5_2 AS (SELECT tmpContainer.JuridicalId
                                         , tmpContainer.PartnerId
                                         , tmpContainer.ContractId
                                         , tmpContainer.PaidKindId
                                         , tmpContainer.BranchId
                                         , MIContainer.MovementId
                                         , MAX (COALESCE (MovementDate_OperDatePartner.ValueData, MIContainer.OperDate)) AS OperDate
                                         , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() THEN MIContainer.Amount WHEN MIContainer.MovementDescId = zc_Movement_TransferDebtOut() AND MIContainer.isActive = TRUE THEN MIContainer.Amount ELSE 0 END) AS Amount

                                    FROM tmpContainer_next5_2 AS tmpContainer
                                         INNER JOIN MovementItemcontainer AS MIContainer
                                                                          ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                                         AND MIContainer.DescId      = zc_MIContainer_Summ()
                                                                         AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_TransferDebtOut())
                                                                         AND MIContainer.OperDate >= tmpContainer.StartContractDate :: Date - 4 * 7 - INTERVAL '9 MONTH'
                                                                         AND MIContainer.OperDate < tmpContainer.StartContractDate :: Date - 4 * 7 - INTERVAL '3 MONTH'
                                         LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                                ON MovementDate_OperDatePartner.MovementId = MIContainer.MovementId
                                                               AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
-- where tmpContainer.JuridicalId = 8578350
                                    GROUP BY tmpContainer.JuridicalId
                                           , tmpContainer.PartnerId
                                           , tmpContainer.ContractId
                                           , tmpContainer.PaidKindId
                                           , tmpContainer.BranchId
                                           , MIContainer.MovementId
                                    HAVING
                                        0 <> SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() THEN MIContainer.Amount WHEN MIContainer.MovementDescId = zc_Movement_TransferDebtOut() AND MIContainer.isActive = TRUE THEN MIContainer.Amount ELSE 0 END)
                                   )
     -- 5.1.Список для просрочка только + 12 месяцев - по ком еще надо найти
   , tmpContainer_next5_3 AS (SELECT DISTINCT
                                     _tmpReport.ContainerId
                                   , _tmpReport.StartContractDate
                                   , COALESCE (_tmpReport.JuridicalId, 0) AS JuridicalId
                                   , COALESCE (_tmpReport.PartnerId,   0) AS PartnerId
                                   , COALESCE (_tmpReport.ContractId,  0) AS ContractId
                                   , COALESCE (_tmpReport.PaidKindId,  0) AS PaidKindId
                                   , COALESCE (_tmpReport.BranchId,    0) AS BranchId
                              FROM _tmpReport
                                   -- итого по отчету
                                   JOIN tmpReport ON tmpReport.JuridicalId = _tmpReport.JuridicalId
                                                 AND tmpReport.PartnerId   = COALESCE (_tmpReport.PartnerId, 0)
                                                 AND tmpReport.ContractId  = _tmpReport.ContractId
                                                 AND tmpReport.PaidKindId  = _tmpReport.PaidKindId
                                                 AND tmpReport.BranchId    = COALESCE (_tmpReport.BranchId, 0)
                                   -- минус предыдущий период-1
                                   LEFT JOIN (SELECT tmpData.JuridicalId
                                                   , tmpData.PartnerId
                                                   , tmpData.ContractId
                                                   , tmpData.PaidKindId
                                                   , tmpData.BranchId
                                                   , SUM (tmpData.Amount) AS Amount
                                              FROM tmpContainerData_all_next5_1 AS tmpData
                                              GROUP BY tmpData.JuridicalId
                                                     , tmpData.PartnerId
                                                     , tmpData.ContractId
                                                     , tmpData.PaidKindId
                                                     , tmpData.BranchId
                                             ) AS tmp_old_1 ON tmp_old_1.JuridicalId = _tmpReport.JuridicalId
                                                           AND tmp_old_1.PartnerId   = COALESCE (_tmpReport.PartnerId, 0)
                                                           AND tmp_old_1.ContractId  = _tmpReport.ContractId
                                                           AND tmp_old_1.PaidKindId  = _tmpReport.PaidKindId
                                                           AND tmp_old_1.BranchId    = COALESCE (_tmpReport.BranchId, 0)
                                   -- минус предыдущий период-2
                                   LEFT JOIN (SELECT tmpData.JuridicalId
                                                   , tmpData.PartnerId
                                                   , tmpData.ContractId
                                                   , tmpData.PaidKindId
                                                   , tmpData.BranchId
                                                   , SUM (tmpData.Amount) AS Amount
                                              FROM tmpContainerData_all_next5_2 AS tmpData
                                              GROUP BY tmpData.JuridicalId
                                                     , tmpData.PartnerId
                                                     , tmpData.ContractId
                                                     , tmpData.PaidKindId
                                                     , tmpData.BranchId
                                             ) AS tmp_old_2 ON tmp_old_2.JuridicalId = _tmpReport.JuridicalId
                                                           AND tmp_old_2.PartnerId   = COALESCE (_tmpReport.PartnerId, 0)
                                                           AND tmp_old_2.ContractId  = _tmpReport.ContractId
                                                           AND tmp_old_2.PaidKindId  = _tmpReport.PaidKindId
                                                           AND tmp_old_2.BranchId    = COALESCE (_tmpReport.BranchId, 0)
                              WHERE _tmpReport.SaleSumm5 > 0
                                -- если в предыдущем поиске не закрыли всю сумму
                                AND tmpReport.SaleSumm5 - COALESCE (tmp_old_1.Amount, 0) - COALESCE (tmp_old_2.Amount, 0) > 0
                             )
   -- 5.2.Просрочка только + 12 месяцев
 , tmpContainerData_all_next5_3 AS (SELECT tmpContainer.JuridicalId
                                         , tmpContainer.PartnerId
                                         , tmpContainer.ContractId
                                         , tmpContainer.PaidKindId
                                         , tmpContainer.BranchId
                                         , MIContainer.MovementId
                                         , MAX (COALESCE (MovementDate_OperDatePartner.ValueData, MIContainer.OperDate)) AS OperDate
                                         , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() THEN MIContainer.Amount WHEN MIContainer.MovementDescId = zc_Movement_TransferDebtOut() AND MIContainer.isActive = TRUE THEN MIContainer.Amount ELSE 0 END) AS Amount

                                    FROM tmpContainer_next5_3 AS tmpContainer
                                         INNER JOIN MovementItemContainer AS MIContainer
                                                                          ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                                         AND MIContainer.DescId      = zc_MIContainer_Summ()
                                                                         AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_TransferDebtOut())
                                                                         AND MIContainer.OperDate >= tmpContainer.StartContractDate :: Date - 4 * 7 - INTERVAL '21 MONTH'
                                                                         AND MIContainer.OperDate < tmpContainer.StartContractDate :: Date - 4 * 7 - INTERVAL '9 MONTH'
                                         LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                                ON MovementDate_OperDatePartner.MovementId = MIContainer.MovementId
                                                               AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
-- where tmpContainer.JuridicalId = 8578350
                                    --WHERE vbUserId <> 5
                                    GROUP BY tmpContainer.JuridicalId
                                           , tmpContainer.PartnerId
                                           , tmpContainer.ContractId
                                           , tmpContainer.PaidKindId
                                           , tmpContainer.BranchId
                                           , MIContainer.MovementId
                                    HAVING
                                        0 <> SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() THEN MIContainer.Amount WHEN MIContainer.MovementDescId = zc_Movement_TransferDebtOut() AND MIContainer.isActive = TRUE THEN MIContainer.Amount ELSE 0 END)
                                   )
     -- 6.1.Список для просрочка только + 14 * 12 месяцев - по ком еще надо найти
   , tmpContainer_next5_4 AS (SELECT DISTINCT
                                     _tmpReport.ContainerId
                                   , _tmpReport.StartContractDate
                                   , COALESCE (_tmpReport.JuridicalId, 0) AS JuridicalId
                                   , COALESCE (_tmpReport.PartnerId,   0) AS PartnerId
                                   , COALESCE (_tmpReport.ContractId,  0) AS ContractId
                                   , COALESCE (_tmpReport.PaidKindId,  0) AS PaidKindId
                                   , COALESCE (_tmpReport.BranchId,    0) AS BranchId
                              FROM _tmpReport
                                   -- итого по отчету
                                   JOIN tmpReport ON tmpReport.JuridicalId = _tmpReport.JuridicalId
                                                 AND tmpReport.PartnerId   = COALESCE (_tmpReport.PartnerId, 0)
                                                 AND tmpReport.ContractId  = _tmpReport.ContractId
                                                 AND tmpReport.PaidKindId  = _tmpReport.PaidKindId
                                                 AND tmpReport.BranchId    = COALESCE (_tmpReport.BranchId, 0)
                                   -- минус предыдущий период-1
                                   LEFT JOIN (SELECT tmpData.JuridicalId
                                                   , tmpData.PartnerId
                                                   , tmpData.ContractId
                                                   , tmpData.PaidKindId
                                                   , tmpData.BranchId
                                                   , SUM (tmpData.Amount) AS Amount
                                              FROM tmpContainerData_all_next5_1 AS tmpData
                                              GROUP BY tmpData.JuridicalId
                                                     , tmpData.PartnerId
                                                     , tmpData.ContractId
                                                     , tmpData.PaidKindId
                                                     , tmpData.BranchId
                                             ) AS tmp_old_1 ON tmp_old_1.JuridicalId = _tmpReport.JuridicalId
                                                           AND tmp_old_1.PartnerId   = COALESCE (_tmpReport.PartnerId, 0)
                                                           AND tmp_old_1.ContractId  = _tmpReport.ContractId
                                                           AND tmp_old_1.PaidKindId  = _tmpReport.PaidKindId
                                                           AND tmp_old_1.BranchId    = COALESCE (_tmpReport.BranchId, 0)
                                   -- минус предыдущий период-2
                                   LEFT JOIN (SELECT tmpData.JuridicalId
                                                   , tmpData.PartnerId
                                                   , tmpData.ContractId
                                                   , tmpData.PaidKindId
                                                   , tmpData.BranchId
                                                   , SUM (tmpData.Amount) AS Amount
                                              FROM tmpContainerData_all_next5_2 AS tmpData
                                              GROUP BY tmpData.JuridicalId
                                                     , tmpData.PartnerId
                                                     , tmpData.ContractId
                                                     , tmpData.PaidKindId
                                                     , tmpData.BranchId
                                             ) AS tmp_old_2 ON tmp_old_2.JuridicalId = _tmpReport.JuridicalId
                                                           AND tmp_old_2.PartnerId   = COALESCE (_tmpReport.PartnerId, 0)
                                                           AND tmp_old_2.ContractId  = _tmpReport.ContractId
                                                           AND tmp_old_2.PaidKindId  = _tmpReport.PaidKindId
                                                           AND tmp_old_2.BranchId    = COALESCE (_tmpReport.BranchId, 0)

                                   -- минус предыдущий период-3
                                   LEFT JOIN (SELECT tmpData.JuridicalId
                                                   , tmpData.PartnerId
                                                   , tmpData.ContractId
                                                   , tmpData.PaidKindId
                                                   , tmpData.BranchId
                                                   , SUM (tmpData.Amount) AS Amount
                                              FROM tmpContainerData_all_next5_3 AS tmpData
                                              GROUP BY tmpData.JuridicalId
                                                     , tmpData.PartnerId
                                                     , tmpData.ContractId
                                                     , tmpData.PaidKindId
                                                     , tmpData.BranchId
                                             ) AS tmp_old_3 ON tmp_old_3.JuridicalId = _tmpReport.JuridicalId
                                                           AND tmp_old_3.PartnerId   = COALESCE (_tmpReport.PartnerId, 0)
                                                           AND tmp_old_3.ContractId  = _tmpReport.ContractId
                                                           AND tmp_old_3.PaidKindId  = _tmpReport.PaidKindId
                                                           AND tmp_old_3.BranchId    = COALESCE (_tmpReport.BranchId, 0)

                              WHERE _tmpReport.SaleSumm5 > 0
                                -- если в предыдущем поиске не закрыли всю сумму
                                AND tmpReport.SaleSumm5 - COALESCE (tmp_old_1.Amount, 0) - COALESCE (tmp_old_2.Amount, 0) - COALESCE (tmp_old_3.Amount, 0) > 0
                             )
   -- 6.2.Просрочка только + 14 * 12 месяцев
 , tmpContainerData_all_next5_4 AS (SELECT tmpContainer.JuridicalId
                                         , tmpContainer.PartnerId
                                         , tmpContainer.ContractId
                                         , tmpContainer.PaidKindId
                                         , tmpContainer.BranchId
                                         , MIContainer.MovementId
                                         , MAX (COALESCE (MovementDate_OperDatePartner.ValueData, MIContainer.OperDate)) AS OperDate
                                         , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() THEN MIContainer.Amount WHEN MIContainer.MovementDescId = zc_Movement_TransferDebtOut() AND MIContainer.isActive = TRUE THEN MIContainer.Amount ELSE 0 END) AS Amount

                                    FROM tmpContainer_next5_4 AS tmpContainer
                                         INNER JOIN MovementItemContainer AS MIContainer
                                                                          ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                                         AND MIContainer.DescId      = zc_MIContainer_Summ()
                                                                         AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_TransferDebtOut())
                                                                         AND MIContainer.OperDate >= tmpContainer.StartContractDate :: Date - 4 * 7 - INTERVAL '14 YEAR'
                                                                         AND MIContainer.OperDate < tmpContainer.StartContractDate :: Date - 4 * 7 - INTERVAL '21 MONTH'
                                         LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                                ON MovementDate_OperDatePartner.MovementId = MIContainer.MovementId
                                                               AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
-- where tmpContainer.JuridicalId = 8578350
                                    --WHERE vbUserId <> 5
                                    GROUP BY tmpContainer.JuridicalId
                                           , tmpContainer.PartnerId
                                           , tmpContainer.ContractId
                                           , tmpContainer.PaidKindId
                                           , tmpContainer.BranchId
                                           , MIContainer.MovementId
                                    HAVING
                                        0 <> SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() THEN MIContainer.Amount WHEN MIContainer.MovementDescId = zc_Movement_TransferDebtOut() AND MIContainer.isActive = TRUE THEN MIContainer.Amount ELSE 0 END)
                                   )

    -- Просрочка только + 21 месяц + накопительно
  , tmpContainerData_gr_next5 AS (SELECT tmpData.JuridicalId
                                       , tmpData.PartnerId
                                       , tmpData.ContractId
                                       , tmpData.PaidKindId
                                       , tmpData.BranchId
                                       , tmpData.MovementId
                                       , tmpData.OperDate
                                       , tmpData.Amount AS Amount5
                                       , SUM (tmpData.Amount) OVER (PARTITION BY tmpData.JuridicalId, tmpData.PartnerId, tmpData.ContractId, tmpData.PaidKindId, tmpData.BranchId ORDER BY tmpData.OperDate DESC, tmpData.MovementId DESC) AS Amount5_summ
                                  FROM
                                     (SELECT tmpData.JuridicalId
                                           , tmpData.PartnerId
                                           , tmpData.ContractId
                                           , tmpData.PaidKindId
                                           , tmpData.BranchId
                                           , tmpData.MovementId
                                           , tmpData.OperDate
                                           , tmpData.Amount
                                      FROM tmpContainerData_all_next5_1 AS tmpData
                                      --WHERE vbUserId <> 5

                                     UNION ALL
                                      SELECT tmpData.JuridicalId
                                           , tmpData.PartnerId
                                           , tmpData.ContractId
                                           , tmpData.PaidKindId
                                           , tmpData.BranchId
                                           , tmpData.MovementId
                                           , tmpData.OperDate
                                           , tmpData.Amount
                                      FROM tmpContainerData_all_next5_2 AS tmpData
                                      --WHERE vbUserId <> 5

                                     UNION ALL
                                      SELECT tmpData.JuridicalId
                                           , tmpData.PartnerId
                                           , tmpData.ContractId
                                           , tmpData.PaidKindId
                                           , tmpData.BranchId
                                           , tmpData.MovementId
                                           , tmpData.OperDate
                                           , tmpData.Amount
                                      FROM tmpContainerData_all_next5_3 AS tmpData
                                      --WHERE vbUserId <> 5

                                     UNION ALL
                                      SELECT tmpData.JuridicalId
                                           , tmpData.PartnerId
                                           , tmpData.ContractId
                                           , tmpData.PaidKindId
                                           , tmpData.BranchId
                                           , tmpData.MovementId
                                           , tmpData.OperDate
                                           , tmpData.Amount
                                      FROM tmpContainerData_all_next5_4 AS tmpData
                                      --WHERE vbUserId <> 5

                                     ) AS tmpData
                                 )
       -- Все
     , tmpContainerData AS (-- Продажи за "период"
                            /*SELECT tmpData.JuridicalId
                                 , tmpData.PartnerId
                                 , tmpData.ContractId
                                 , tmpData.PaidKindId
                                 , tmpData.BranchId
                                   --
                                 , tmpData.MovementId
                                 , tmpData.OperDate
                                   -- вся сумма накладной
                                 , tmpData.Amount
                                 , 0 AS Amount1
                                 , 0 AS Amount2
                                 , 0 AS Amount3
                                 , 0 AS Amount4
                                 , 0 AS Amount5
                                   -- просрочка по накладной
                                 , 0 AS Amount0_res
                                 , 0 AS Amount1_res
                                 , 0 AS Amount2_res
                                 , 0 AS Amount3_res
                                 , 0 AS Amount4_res
                                 , 0 AS Amount5_res
                            FROM tmpContainerData_gr AS tmpData
                                 LEFT JOIN tmpReport ON tmpReport.JuridicalId = tmpData.JuridicalId
                                                    AND tmpReport.PartnerId   = tmpData.PartnerId
                                                    AND tmpReport.ContractId  = tmpData.ContractId
                                                    AND tmpReport.PaidKindId  = tmpData.PaidKindId
                                                    AND tmpReport.BranchId    = tmpData.BranchId
                                                    AND tmpReport.DebetRemains > 0
                                                  --AND 1=0

                            WHERE tmpData.Amount > 0
                              AND tmpReport.JuridicalId IS NULL

                           UNION ALL*/
                            -- Долги по "накладным"
                            SELECT tmpData.JuridicalId
                                 , tmpData.PartnerId
                                 , tmpData.ContractId
                                 , tmpData.PaidKindId
                                 , tmpData.BranchId
                                   --
                                 , tmpContainerData_gr.MovementId
                                 , tmpContainerData_gr.OperDate
                                   -- вся сумма накладной
                                 , tmpContainerData_gr.Amount
                                 , 0 AS Amount1
                                 , 0 AS Amount2
                                 , 0 AS Amount3
                                 , 0 AS Amount4
                                 , 0 AS Amount5

                                   -- Долги по накладной
                                 , CASE -- если накопительный итог c этой суммой меньше DebetRemains
                                        WHEN tmpContainerData_gr.Amount_summ <= tmpData.DebetRemains
                                             THEN tmpContainerData_gr.Amount
                                        -- если итог без этой суммы больше DebetRemains
                                        WHEN tmpContainerData_gr.Amount_summ - tmpContainerData_gr.Amount > tmpData.DebetRemains
                                             THEN 0
                                        -- Долги не на всю сумму накладной, только часть, посчитаем ее
                                        ELSE tmpData.DebetRemains - (tmpContainerData_gr.Amount_summ - tmpContainerData_gr.Amount)
                                   END  AS Amount0_res
                                 , 0 AS Amount1_res
                                 , 0 AS Amount2_res
                                 , 0 AS Amount3_res
                                 , 0 AS Amount4_res
                                 , 0 AS Amount5_res
                            FROM (-- Итоговая просрочка - 1 неделя
                                    SELECT tmpReport.DebetRemains
                                         , COALESCE (tmpReport.JuridicalId, 0) AS JuridicalId
                                         , COALESCE (tmpReport.PartnerId,   0) AS PartnerId
                                         , COALESCE (tmpReport.ContractId,  0) AS ContractId
                                         , COALESCE (tmpReport.PaidKindId,  0) AS PaidKindId
                                         , COALESCE (tmpReport.BranchId,    0) AS BranchId
                                    FROM tmpReport
                                    --WHERE tmpReport.DebetRemains > 0
                                   ) AS tmpData
                                   -- по накладным
                                   INNER JOIN tmpContainerData_gr ON tmpContainerData_gr.JuridicalId = tmpData.JuridicalId
                                                                 AND tmpContainerData_gr.PartnerId   = tmpData.PartnerId
                                                                 AND tmpContainerData_gr.ContractId  = tmpData.ContractId
                                                                 AND tmpContainerData_gr.PaidKindId  = tmpData.PaidKindId
                                                                 AND tmpContainerData_gr.BranchId    = tmpData.BranchId
                                                                 -- берем все накладные, пока накопительная сумма меньше той на которую делаем подбор
                                                                 --AND tmpContainerData_gr.Amount_summ - tmpContainerData_gr.Amount <= tmpData.DebetRemains
                                                                 --AND tmpContainerData_gr.Amount     > 0

                           UNION ALL
                            -- просрочка - 1 неделя
                            SELECT
                                   tmpData.JuridicalId
                                 , tmpData.PartnerId
                                 , tmpData.ContractId
                                 , tmpData.PaidKindId
                                 , tmpData.BranchId
                                   --
                                 , tmpContainerData_gr.MovementId
                                 , tmpContainerData_gr.OperDate
                                   -- вся сумма накладной
                                 , 0 AS Amount
                                 , tmpContainerData_gr.Amount1
                                 , 0 AS Amount2
                                 , 0 AS Amount3
                                 , 0 AS Amount4
                                 , 0 AS Amount5

                                 , 0 AS Amount0_res
                                   -- просрочка по накладной
                                 , CASE -- если накопительный итог c этой суммой меньше SaleSumm1
                                        -- WHEN vbUserId = 5 then Amount1_summ
                                        WHEN tmpContainerData_gr.Amount1_summ <= tmpData.SaleSumm1
                                             THEN tmpContainerData_gr.Amount1
                                        -- если итог без этой суммы больше SaleSumm1
                                        WHEN tmpContainerData_gr.Amount1_summ - tmpContainerData_gr.Amount1 > tmpData.SaleSumm1
                                             THEN 0
                                        -- просрочка не на всю сумму накладной, только часть, посчитаем ее
                                        ELSE tmpData.SaleSumm1 - (tmpContainerData_gr.Amount1_summ - tmpContainerData_gr.Amount1)
                                   END  AS Amount1_res
                                 , 0 AS Amount2_res
                                 , 0 AS Amount3_res
                                 , 0 AS Amount4_res
                                 , 0 AS Amount5_res
                              FROM (-- Итоговая просрочка - 1 неделя
                                    SELECT tmpReport.SaleSumm1
                                         , COALESCE (tmpReport.JuridicalId, 0) AS JuridicalId
                                         , COALESCE (tmpReport.PartnerId,   0) AS PartnerId
                                         , COALESCE (tmpReport.ContractId,  0) AS ContractId
                                         , COALESCE (tmpReport.PaidKindId,  0) AS PaidKindId
                                         , COALESCE (tmpReport.BranchId,    0) AS BranchId
                                    FROM tmpReport
                                    WHERE tmpReport.SaleSumm1 > 0
                                   ) AS tmpData
                                   -- по накладным
                                   INNER JOIN tmpContainerData_gr ON tmpContainerData_gr.JuridicalId = tmpData.JuridicalId
                                                                 AND tmpContainerData_gr.PartnerId   = tmpData.PartnerId
                                                                 AND tmpContainerData_gr.ContractId  = tmpData.ContractId
                                                                 AND tmpContainerData_gr.PaidKindId  = tmpData.PaidKindId
                                                                 AND tmpContainerData_gr.BranchId    = tmpData.BranchId
                                                                 -- берем все накладный, пока накопительная сумма меньше той на которую делаем подбор
                                                                 AND tmpContainerData_gr.Amount1_summ - tmpContainerData_gr.Amount1 <= tmpData.SaleSumm1
                                                                 AND tmpContainerData_gr.Amount1     > 0

                           UNION ALL
                            -- просрочка - 2 неделя
                            SELECT
                                   tmpData.JuridicalId
                                 , tmpData.PartnerId
                                 , tmpData.ContractId
                                 , tmpData.PaidKindId
                                 , tmpData.BranchId
                                   --
                                 , tmpContainerData_gr.MovementId
                                 , tmpContainerData_gr.OperDate
                                   -- вся сумма накладной
                                 , 0 AS Amount
                                 , 0 AS Amount1
                                 , tmpContainerData_gr.Amount2
                                 , 0 AS Amount3
                                 , 0 AS Amount4
                                 , 0 AS Amount5

                                 , 0 AS Amount0_res
                                 , 0 AS Amount1_res
                                   -- просрочка по накладной
                                 , CASE -- если накопительный итог c этой суммой меньше SaleSumm2
                                        WHEN tmpContainerData_gr.Amount2_summ <= tmpData.SaleSumm2
                                             THEN tmpContainerData_gr.Amount2
                                        -- если итог без этой суммы больше SaleSumm2
                                        WHEN tmpContainerData_gr.Amount2_summ - tmpContainerData_gr.Amount2 > tmpData.SaleSumm2
                                             THEN 0
                                        -- просрочка не на всю сумму накладной, только часть, посчитаем ее
                                        ELSE tmpData.SaleSumm2 - (tmpContainerData_gr.Amount2_summ - tmpContainerData_gr.Amount2)
                                   END  AS Amount2_res
                                 , 0 AS Amount3_res
                                 , 0 AS Amount4_res
                                 , 0 AS Amount5_res
                              FROM (-- Итоговая просрочка - 2 неделя
                                    SELECT tmpReport.SaleSumm2
                                         , COALESCE (tmpReport.JuridicalId, 0) AS JuridicalId
                                         , COALESCE (tmpReport.PartnerId,   0) AS PartnerId
                                         , COALESCE (tmpReport.ContractId,  0) AS ContractId
                                         , COALESCE (tmpReport.PaidKindId,  0) AS PaidKindId
                                         , COALESCE (tmpReport.BranchId,    0) AS BranchId
                                    FROM tmpReport
                                    WHERE tmpReport.SaleSumm2 > 0
                                   ) AS tmpData
                                   -- по накладным
                                   INNER JOIN tmpContainerData_gr ON tmpContainerData_gr.JuridicalId = tmpData.JuridicalId
                                                                 AND tmpContainerData_gr.PartnerId   = tmpData.PartnerId
                                                                 AND tmpContainerData_gr.ContractId  = tmpData.ContractId
                                                                 AND tmpContainerData_gr.PaidKindId  = tmpData.PaidKindId
                                                                 AND tmpContainerData_gr.BranchId    = tmpData.BranchId
                                                                 -- берем все накладный, пока накопительная сумма меньше той на которую делаем подбор
                                                                 AND tmpContainerData_gr.Amount2_summ - tmpContainerData_gr.Amount2 <= tmpData.SaleSumm2
                                                                 AND tmpContainerData_gr.Amount2     > 0
                           UNION ALL
                            -- просрочка - 3 неделя
                            SELECT
                                   tmpData.JuridicalId
                                 , tmpData.PartnerId
                                 , tmpData.ContractId
                                 , tmpData.PaidKindId
                                 , tmpData.BranchId
                                   --
                                 , tmpContainerData_gr.MovementId
                                 , tmpContainerData_gr.OperDate
                                   -- вся сумма накладной
                                 , 0 AS Amount
                                 , 0 AS Amount1
                                 , 0 AS Amount2
                                 , tmpContainerData_gr.Amount3
                                 , 0 AS Amount4
                                 , 0 AS Amount5

                                 , 0 AS Amount0_res
                                 , 0 AS Amount1_res
                                 , 0 AS Amount2_res
                                   -- просрочка по накладной
                                 , CASE -- если накопительный итог c этой суммой меньше SaleSumm3
                                        WHEN tmpContainerData_gr.Amount3_summ <= tmpData.SaleSumm3
                                             THEN tmpContainerData_gr.Amount3
                                        -- если итог без этой суммы больше SaleSumm3
                                        WHEN tmpContainerData_gr.Amount3_summ - tmpContainerData_gr.Amount3 > tmpData.SaleSumm3
                                             THEN 0
                                        -- просрочка не на всю сумму накладной, только часть, посчитаем ее
                                        ELSE tmpData.SaleSumm3 - (tmpContainerData_gr.Amount3_summ - tmpContainerData_gr.Amount3)
                                   END  AS Amount3_res
                                 , 0 AS Amount4_res
                                 , 0 AS Amount5_res
                              FROM (-- Итоговая просрочка - 3 неделя
                                    SELECT tmpReport.SaleSumm3
                                         , COALESCE (tmpReport.JuridicalId, 0) AS JuridicalId
                                         , COALESCE (tmpReport.PartnerId,   0) AS PartnerId
                                         , COALESCE (tmpReport.ContractId,  0) AS ContractId
                                         , COALESCE (tmpReport.PaidKindId,  0) AS PaidKindId
                                         , COALESCE (tmpReport.BranchId,    0) AS BranchId
                                    FROM tmpReport
                                    WHERE tmpReport.SaleSumm3 > 0
                                   ) AS tmpData
                                   -- по накладным
                                   INNER JOIN tmpContainerData_gr ON tmpContainerData_gr.JuridicalId = tmpData.JuridicalId
                                                                 AND tmpContainerData_gr.PartnerId   = tmpData.PartnerId
                                                                 AND tmpContainerData_gr.ContractId  = tmpData.ContractId
                                                                 AND tmpContainerData_gr.PaidKindId  = tmpData.PaidKindId
                                                                 AND tmpContainerData_gr.BranchId    = tmpData.BranchId
                                                                 -- берем все накладный, пока накопительная сумма меньше той на которую делаем подбор
                                                                 AND tmpContainerData_gr.Amount3_summ - tmpContainerData_gr.Amount3 <= tmpData.SaleSumm3
                                                                 AND tmpContainerData_gr.Amount3     > 0
                           UNION ALL
                            -- просрочка - 4 неделя
                            SELECT
                                   tmpData.JuridicalId
                                 , tmpData.PartnerId
                                 , tmpData.ContractId
                                 , tmpData.PaidKindId
                                 , tmpData.BranchId
                                   --
                                 , tmpContainerData_gr.MovementId
                                 , tmpContainerData_gr.OperDate
                                   -- вся сумма накладной
                                 , 0 AS Amount
                                 , 0 AS Amount1
                                 , 0 AS Amount2
                                 , 0 AS Amount3
                                 , tmpContainerData_gr.Amount4
                                 , 0 AS Amount5

                                 , 0 AS Amount0_res
                                 , 0 AS Amount1_res
                                 , 0 AS Amount2_res
                                 , 0 AS Amount3_res
                                   -- просрочка по накладной
                                 , CASE -- если накопительный итог c этой суммой меньше SaleSumm4
                                        WHEN tmpContainerData_gr.Amount4_summ <= tmpData.SaleSumm4
                                             THEN tmpContainerData_gr.Amount4
                                        -- если итог без этой суммы больше SaleSumm4
                                        WHEN tmpContainerData_gr.Amount4_summ - tmpContainerData_gr.Amount4 > tmpData.SaleSumm4
                                             THEN 0
                                        -- просрочка не на всю сумму накладной, только часть, посчитаем ее
                                        ELSE tmpData.SaleSumm4 - (tmpContainerData_gr.Amount4_summ - tmpContainerData_gr.Amount4)
                                   END  AS Amount4_res
                                 , 0 AS Amount5_res
                              FROM (-- Итоговая просрочка - 4 неделя
                                    SELECT tmpReport.SaleSumm4
                                         , COALESCE (tmpReport.JuridicalId, 0) AS JuridicalId
                                         , COALESCE (tmpReport.PartnerId,   0) AS PartnerId
                                         , COALESCE (tmpReport.ContractId,  0) AS ContractId
                                         , COALESCE (tmpReport.PaidKindId,  0) AS PaidKindId
                                         , COALESCE (tmpReport.BranchId,    0) AS BranchId
                                    FROM tmpReport
                                    WHERE tmpReport.SaleSumm4 > 0
                                   ) AS tmpData
                                   -- по накладным
                                   INNER JOIN tmpContainerData_gr ON tmpContainerData_gr.JuridicalId = tmpData.JuridicalId
                                                                 AND tmpContainerData_gr.PartnerId   = tmpData.PartnerId
                                                                 AND tmpContainerData_gr.ContractId  = tmpData.ContractId
                                                                 AND tmpContainerData_gr.PaidKindId  = tmpData.PaidKindId
                                                                 AND tmpContainerData_gr.BranchId    = tmpData.BranchId
                                                                 -- берем все накладный, пока накопительная сумма меньше той на которую делаем подбор
                                                                 AND tmpContainerData_gr.Amount4_summ - tmpContainerData_gr.Amount4 <= tmpData.SaleSumm4
                                                                 AND tmpContainerData_gr.Amount4 > 0



                           UNION ALL
                            -- просрочка - 21 месяц
                            SELECT
                                   tmpData.JuridicalId
                                 , tmpData.PartnerId
                                 , tmpData.ContractId
                                 , tmpData.PaidKindId
                                 , tmpData.BranchId
                                   --
                                 , tmpContainerData_gr.MovementId
                                 , tmpContainerData_gr.OperDate
                                   -- вся сумма накладной
                                 , 0 AS Amount
                                 , 0 AS Amount1
                                 , 0 AS Amount2
                                 , 0 AS Amount3
                                 , 0 AS Amount4
                                 , tmpContainerData_gr.Amount5

                                 , 0 AS Amount0_res
                                 , 0 AS Amount1_res
                                 , 0 AS Amount2_res
                                 , 0 AS Amount3_res
                                 , 0 AS Amount4_res
                                   -- просрочка по накладной
                                 , CASE -- если накопительный итог c этой суммой меньше SaleSumm5
                                        WHEN tmpContainerData_gr.Amount5_summ <= tmpData.SaleSumm5
                                             THEN tmpContainerData_gr.Amount5
                                        -- если итог без этой суммы больше SaleSumm5
                                        WHEN tmpContainerData_gr.Amount5_summ - tmpContainerData_gr.Amount5 > tmpData.SaleSumm5
                                             THEN 0
                                        -- просрочка не на всю сумму накладной, только часть, посчитаем ее
                                        ELSE tmpData.SaleSumm5 - (tmpContainerData_gr.Amount5_summ - tmpContainerData_gr.Amount5)
                                   END  AS Amount5_res
                              FROM (-- Итоговая просрочка - 21 месяц
                                    SELECT tmpReport.SaleSumm5
                                         , COALESCE (tmpReport.JuridicalId, 0) AS JuridicalId
                                         , COALESCE (tmpReport.PartnerId,   0) AS PartnerId
                                         , COALESCE (tmpReport.ContractId,  0) AS ContractId
                                         , COALESCE (tmpReport.PaidKindId,  0) AS PaidKindId
                                         , COALESCE (tmpReport.BranchId,    0) AS BranchId
                                    FROM tmpReport
                                    WHERE tmpReport.SaleSumm5 > 0
                                   ) AS tmpData
                                   -- по накладным
                                   INNER JOIN tmpContainerData_gr_next5 AS tmpContainerData_gr
                                                                  ON tmpContainerData_gr.JuridicalId = tmpData.JuridicalId
                                                                 AND tmpContainerData_gr.PartnerId   = tmpData.PartnerId
                                                                 AND tmpContainerData_gr.ContractId  = tmpData.ContractId
                                                                 AND tmpContainerData_gr.PaidKindId  = tmpData.PaidKindId
                                                                 AND tmpContainerData_gr.BranchId    = tmpData.BranchId
                                                                 -- берем все накладный, пока накопительная сумма меньше той на которую делаем подбор
                                                                 AND tmpContainerData_gr.Amount5_summ - tmpContainerData_gr.Amount5 <= tmpData.SaleSumm5
                                                                 AND tmpContainerData_gr.Amount5 > 0


                           UNION ALL
                            -- все что НЕ нашли по накладным
                            SELECT
                                   tmpData.JuridicalId
                                 , tmpData.PartnerId
                                 , tmpData.ContractId
                                 , tmpData.PaidKindId
                                 , tmpData.BranchId
                                   --
                                 , -1 AS MovementId
                                 , '01.01.2001' AS OperDate
                                   -- вся сумма накладной
                                 , 0 AS Amount
                                 , 0 AS Amount1
                                 , 0 AS Amount2
                                 , 0 AS Amount3
                                 , 0 AS Amount4
                                 , 0 AS Amount5

                                 , 0 AS Amount0_res
                                 , 0 AS Amount1_res
                                 , 0 AS Amount2_res
                                 , 0 AS Amount3_res
                                 , 0 AS Amount4_res
                                   -- просрочка по накладной
                                 , tmpData.SaleSumm5 - COALESCE (tmpContainerData_gr.Amount5, 0) AS Amount5_res
                              FROM (-- на какую сумму надо было подобрать
                                    SELECT tmpReport.SaleSumm5
                                         , COALESCE (tmpReport.JuridicalId, 0) AS JuridicalId
                                         , COALESCE (tmpReport.PartnerId,   0) AS PartnerId
                                         , COALESCE (tmpReport.ContractId,  0) AS ContractId
                                         , COALESCE (tmpReport.PaidKindId,  0) AS PaidKindId
                                         , COALESCE (tmpReport.BranchId,    0) AS BranchId
                                    FROM tmpReport
                                    WHERE tmpReport.SaleSumm5 > 0
                                   ) AS tmpData
                                   -- ИТОГО по накладным - сколько подобрали
                                   LEFT JOIN (SELECT tmpContainerData_gr.JuridicalId
                                                   , tmpContainerData_gr.PartnerId
                                                   , tmpContainerData_gr.ContractId
                                                   , tmpContainerData_gr.PaidKindId
                                                   , tmpContainerData_gr.BranchId
                                                   , SUM (tmpContainerData_gr.Amount5) AS Amount5
                                              FROM tmpContainerData_gr_next5 AS tmpContainerData_gr
                                              GROUP BY tmpContainerData_gr.JuridicalId
                                                     , tmpContainerData_gr.PartnerId
                                                     , tmpContainerData_gr.ContractId
                                                     , tmpContainerData_gr.PaidKindId
                                                     , tmpContainerData_gr.BranchId
                                             ) AS tmpContainerData_gr
                                               ON tmpContainerData_gr.JuridicalId = tmpData.JuridicalId
                                              AND tmpContainerData_gr.PartnerId   = tmpData.PartnerId
                                              AND tmpContainerData_gr.ContractId  = tmpData.ContractId
                                              AND tmpContainerData_gr.PaidKindId  = tmpData.PaidKindId
                                              AND tmpContainerData_gr.BranchId    = tmpData.BranchId
                              -- если подобрали не все
                              WHERE tmpData.SaleSumm5 - COALESCE (tmpContainerData_gr.Amount5, 0) > 0
                           )
     --
   , tmpData AS (SELECT tmpReport.AccountId, tmpReport.AccountName, tmpReport.JuridicalId, tmpReport.JuridicalName, tmpReport.RetailName, tmpReport.RetailName_main, tmpReport.OKPO, tmpReport.JuridicalGroupName
                       , tmpReport.SectionId, tmpReport.SectionName
                       , tmpReport.PartnerId, tmpReport.PartnerCode, tmpReport.PartnerName
                       , tmpReport.BranchId, tmpReport.BranchCode, tmpReport.BranchName
                       , tmpReport.PaidKindId, tmpReport.PaidKindName
                       , tmpReport.ContractId, tmpReport.ContractCode, tmpReport.ContractNumber
                       , tmpReport.ContractTagGroupName, tmpReport.ContractTagName, tmpReport.ContractStateKindCode
                       , tmpReport.ContractJuridicalDocId, tmpReport.ContractJuridicalDocCode, tmpReport.ContractJuridicalDocName
                       , tmpReport.PersonalName
                       , tmpReport.PersonalTradeName
                       , tmpReport.PersonalCollationName
                       , tmpReport.PersonalTradeName_Partner
                       , tmpReport.StartDate, tmpReport.EndDate
                       , tmpReport.DebetRemains, tmpReport.KreditRemains
                       , tmpReport.SaleSumm, tmpReport.DefermentPaymentRemains
                       , tmpReport.SaleSumm1, tmpReport.SaleSumm2, tmpReport.SaleSumm3, tmpReport.SaleSumm4, tmpReport.SaleSumm5
                       , tmpReport.Condition, tmpReport.StartContractDate, tmpReport.Remains
                       , tmpReport.InfoMoneyGroupName, tmpReport.InfoMoneyDestinationName
                       , tmpReport.InfoMoneyId, tmpReport.InfoMoneyCode, tmpReport.InfoMoneyName
                       , tmpReport.AreaName, tmpReport.AreaName_Partner
                       , tmpReport.BranchName_personal
                       , tmpReport.BranchName_personal_trade

                       , tmpLastPayment.OperDate :: TDateTime AS PaymentDate
                       , tmpLastPayment.Amount   :: TFloat    AS PaymentAmount

                       , tmpLastPaymentJuridical.OperDate :: TDateTime AS PaymentDate_jur
                       , tmpLastPaymentJuridical.Amount   :: TFloat    AS PaymentAmount_jur

                       , ROW_NUMBER() OVER (PARTITION BY tmpReport.JuridicalId, tmpReport.PaidKindId, tmpReport.ContractId, tmpReport.PartnerId, tmpReport.BranchId
                                            ORDER BY tmpContainerData.Amount0_res + tmpContainerData.Amount1_res + tmpContainerData.Amount2_res
                                                   + tmpContainerData.Amount3_res + tmpContainerData.Amount4_res + tmpContainerData.Amount5_res
                                                     DESC
                                                   , tmpContainerData.Amount + tmpContainerData.Amount0_res + tmpContainerData.Amount1_res + tmpContainerData.Amount2_res
                                                   + tmpContainerData.Amount3_res + tmpContainerData.Amount4_res + tmpContainerData.Amount5_res
                                                     DESC
                                                   , tmpContainerData.OperDate
                                                     DESC
                                           ) AS Ord
                       , tmpContainerData.MovementId
                       , tmpContainerData.OperDate
                       , MovementDesc.ItemName AS MovementDescName
                       , Movement.InvNumber
                       , Object_To.Id         AS ToId
                       , Object_To.ValueData  AS ToName
                         -- нет просрочки на эту сумму
                       , tmpContainerData.Amount AS Summa_doc
                         --
                       , tmpContainerData.Amount0_res AS Summa_doc_0
                         -- просрочки на эту сумму - 1 неделя
                       , tmpContainerData.Amount1_res AS Summa_doc_1
                         -- просрочки на эту сумму - 2 неделя
                       , tmpContainerData.Amount2_res AS Summa_doc_2
                         -- просрочки на эту сумму - 3 неделя
                       , tmpContainerData.Amount3_res AS Summa_doc_3
                         -- просрочки на эту сумму - 4 неделя
                       , tmpContainerData.Amount4_res AS Summa_doc_4
                         -- просрочки на эту сумму > 4 недель
                       , tmpContainerData.Amount5_res AS Summa_doc_5
                         --
                       , tmpReport.ContainerId

                       , CASE WHEN tmpReport.ContractConditionKindId IN (zc_Enum_ContractConditionKind_DelayDayCalendar(), zc_Enum_ContractConditionKind_DelayDayBank())
                              THEN zfCalc_DetermentPaymentDate_ASC (inContractConditionId:= tmpReport.ContractConditionKindId, inDayCount:= tmpReport.DayCount::Integer, inDate:= tmpContainerData.OperDate ::TDateTime)
                              ELSE NULL
                         END  ::TDateTime AS OperDate_pay
                         -- вся сумма накладной
                        , (tmpContainerData.Amount + tmpContainerData.Amount1 + tmpContainerData.Amount2 + tmpContainerData.Amount3 + tmpContainerData.Amount4 + tmpContainerData.Amount5) ::TFloat AS TotalSumm
                        , tmpReport.DayCount
                 FROM tmpReport
                      LEFT JOIN tmpLastPayment_all AS tmpLastPayment
                                                   ON tmpLastPayment.JuridicalId = tmpReport.JuridicalId
                                                  AND tmpLastPayment.ContractId  = tmpReport.ContractId
                                                  AND tmpLastPayment.PaidKindId  = tmpReport.PaidKindId
                                                  AND tmpLastPayment.PartnerId   = COALESCE (tmpReport.PartnerId,0)

                      LEFT JOIN (SELECT tmpLastPayment.JuridicalId
                                      , tmpLastPayment.InfoMoneyId
                                      , tmpLastPayment.PaidKindId
                                      , tmpLastPayment.OperDate
                                      , tmpLastPayment.Amount
                                      , ROW_NUMBER() OVER(PARTITION BY tmpLastPayment.JuridicalId, tmpLastPayment.PaidKindId, tmpLastPayment.InfoMoneyId ORDER BY tmpLastPayment.OperDate DESC) AS Ord
                                 FROM tmpLastPayment
                                ) AS tmpLastPaymentJuridical
                                  ON tmpLastPaymentJuridical.JuridicalId = tmpReport.JuridicalId
                                 AND tmpLastPaymentJuridical.PaidKindId  = tmpReport.PaidKindId
                                 AND tmpLastPaymentJuridical.InfoMoneyId = tmpReport.InfoMoneyId
                                 AND tmpLastPaymentJuridical.Ord = 1

                      LEFT JOIN tmpContainerData ON tmpContainerData.JuridicalId = tmpReport.JuridicalId
                                                AND tmpContainerData.ContractId  = tmpReport.ContractId
                                                AND tmpContainerData.PaidKindId  = tmpReport.PaidKindId
                                                AND tmpContainerData.PartnerId   = tmpReport.PartnerId
                                                AND tmpContainerData.BranchId    = tmpReport.BranchId
                      LEFT JOIN Movement ON Movement.Id = tmpContainerData.MovementId
                      LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

                      LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                   ON MovementLinkObject_To.MovementId = tmpContainerData.MovementId
                                                  AND MovementLinkObject_To.DescId = CASE WHEN Movement.DescId = zc_Movement_Sale() THEN zc_MovementLinkObject_To() ELSE zc_MovementLinkObject_Partner() END
                      LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                   ON MovementLinkObject_Partner.MovementId = tmpContainerData.MovementId
                                                  AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_To()
                      LEFT JOIN Object AS Object_To ON Object_To.Id = COALESCE (MovementLinkObject_Partner.ObjectId, MovementLinkObject_To.ObjectId)

                )

   ---
   SELECT tmpReport.AccountId, tmpReport.AccountName, tmpReport.JuridicalId, tmpReport.JuridicalName, tmpReport.RetailName, tmpReport.RetailName_main, tmpReport.OKPO, tmpReport.JuridicalGroupName
        , tmpReport.SectionId, tmpReport.SectionName
        , tmpReport.PartnerId, tmpReport.PartnerCode, tmpReport.PartnerName
        , tmpReport.BranchId, tmpReport.BranchCode, tmpReport.BranchName
        , tmpReport.PaidKindId, tmpReport.PaidKindName
        , tmpReport.ContractId, tmpReport.ContractCode, tmpReport.ContractNumber
        , tmpReport.ContractTagGroupName, tmpReport.ContractTagName, tmpReport.ContractStateKindCode
        , tmpReport.ContractJuridicalDocId, tmpReport.ContractJuridicalDocCode, tmpReport.ContractJuridicalDocName
        , tmpReport.PersonalName
        , tmpReport.PersonalTradeName
        , tmpReport.PersonalCollationName
        , tmpReport.PersonalTradeName_Partner
        , tmpReport.StartDate, tmpReport.EndDate

        , CASE WHEN tmpReport.Ord = 1 THEN tmpReport.DebetRemains  ELSE 0 END ::TFloat AS DebetRemains
        , CASE WHEN tmpReport.Ord = 1 THEN tmpReport.KreditRemains ELSE 0 END ::TFloat AS KreditRemains
        , CASE WHEN tmpReport.Ord = 1 THEN tmpReport.SaleSumm - COALESCE (tmpData_minus.SaleSumm, 0) ELSE 0 END ::TFloat AS SaleSumm
        , CASE WHEN tmpReport.Ord = 1 THEN tmpReport.DefermentPaymentRemains ELSE 0 END ::TFloat AS DefermentPaymentRemains
        , CASE WHEN tmpReport.Ord = 1 THEN tmpReport.SaleSumm1     ELSE 0 END ::TFloat AS SaleSumm1
        , CASE WHEN tmpReport.Ord = 1 THEN tmpReport.SaleSumm2     ELSE 0 END ::TFloat AS SaleSumm2
        , CASE WHEN tmpReport.Ord = 1 THEN tmpReport.SaleSumm3     ELSE 0 END ::TFloat AS SaleSumm3
        , CASE WHEN tmpReport.Ord = 1 THEN tmpReport.SaleSumm4     ELSE 0 END ::TFloat AS SaleSumm4
        , CASE WHEN tmpReport.Ord = 1 THEN tmpReport.SaleSumm5     ELSE 0 END ::TFloat AS SaleSumm5

        , tmpReport.Condition, tmpReport.StartContractDate, tmpReport.Remains
        , tmpReport.InfoMoneyGroupName, tmpReport.InfoMoneyDestinationName
        , tmpReport.InfoMoneyId, tmpReport.InfoMoneyCode, tmpReport.InfoMoneyName
        , tmpReport.AreaName, tmpReport.AreaName_Partner
        , tmpReport.BranchName_personal
        , tmpReport.BranchName_personal_trade

        , tmpReport.PaymentDate        :: TDateTime
        , tmpReport.PaymentAmount      :: TFloat
        , tmpReport.PaymentDate_jur    :: TDateTime
        , tmpReport.PaymentAmount_jur  :: TFloat

        , tmpReport.MovementId      ::Integer
        , tmpReport.OperDate        ::TDateTime
        , tmpReport.OperDate_pay    ::TDateTime
        , tmpReport.MovementDescName ::TVarChar
        , CASE WHEN tmpReport.MovementId = -1 THEN 'Нет подбора' ELSE tmpReport.InvNumber END ::TVarChar


        , CASE WHEN tmpReport.ToId > 0 THEN tmpReport.ToId   ELSE tmpReport.PartnerId   END ::Integer  AS ToId
        , CASE WHEN tmpReport.ToId > 0 THEN tmpReport.ToName ELSE tmpReport.PartnerName END ::TVarChar AS ToName
        , Object_PartnerTag.ValueData AS PartnerTagName

          -- нет просрочки на эту сумму
        , tmpReport.Summa_doc ::TFloat
          -- просрочки на эту сумму - 1 неделя
        , tmpReport.Summa_doc_1 ::TFloat
          -- просрочки на эту сумму - 2 неделя
        , tmpReport.Summa_doc_2 ::TFloat
          -- просрочки на эту сумму - 3 неделя
        , tmpReport.Summa_doc_3 ::TFloat
          -- просрочки на эту сумму - 4 неделя
        , tmpReport.Summa_doc_4 ::TFloat
          -- просрочки на эту сумму > 4 недель
        , tmpReport.Summa_doc_5 ::TFloat

          -- вся сумма накладной
        , tmpReport.TotalSumm       ::TFloat  --

          --  долг по накладной
        , (COALESCE (tmpReport.Summa_doc_0, 0) + COALESCE (tmpReport.Summa_doc_1, 0) + COALESCE (tmpReport.Summa_doc_2, 0) + COALESCE (tmpReport.Summa_doc_3, 0) + COALESCE (tmpReport.Summa_doc_4, 0) + COALESCE (tmpReport.Summa_doc_5, 0)) ::TFloat AS TotalSumm_diff
          --  долг по накладной
        , (COALESCE (tmpReport.Summa_doc_1, 0) + COALESCE (tmpReport.Summa_doc_2, 0) + COALESCE (tmpReport.Summa_doc_3, 0) + COALESCE (tmpReport.Summa_doc_4, 0) + COALESCE (tmpReport.Summa_doc_5, 0)) ::TFloat AS TotalSumm_diff_Deferment

        , tmpReport.DayCount ::Integer AS DayCount_condition
        , DATE_PART ('DAY', inOperDate:: TIMESTAMP -  tmpReport.OperDate_pay :: TIMESTAMP) ::Integer AS DelayDay_calc

        , tmpReport.ContainerId :: Integer

        , tmpReport.DebetRemains :: TFloat
        , tmpReport.KreditRemains :: TFloat
        , tmpReport.SaleSumm :: TFloat
        , tmpReport.SaleSumm1 :: TFloat, tmpReport.SaleSumm2 :: TFloat, tmpReport.SaleSumm3 :: TFloat, tmpReport.SaleSumm4 :: TFloat, tmpReport.SaleSumm5 :: TFloat
      --  нет просрочки на эту сумму
      --OR tmpReport.Summa_doc <> 0
      --  просрочки на эту сумму - 1 неделя
        , tmpReport.Summa_doc_1 :: TFloat
      --  просрочки на эту сумму - 2 неделя
        , tmpReport.Summa_doc_2 :: TFloat
      --  просрочки на эту сумму - 3 неделя
        , tmpReport.Summa_doc_3 :: TFloat
      --  просрочки на эту сумму - 4 неделя
        , tmpReport.Summa_doc_4 :: TFloat
      --  просрочки на эту сумму > 4 недель
        , tmpReport.Summa_doc_5 :: TFloat
      --  вся сумма накладной
      --OR tmpReport.TotalSumm <> 0
      --  долг по накладной
        , tmpReport.Summa_doc_0 :: TFloat


   FROM tmpData AS tmpReport
        LEFT JOIN (SELECT tmpData.JuridicalId
                        , tmpData.PartnerId
                        , tmpData.ContractId
                        , tmpData.PaidKindId
                        , tmpData.BranchId
                        , SUM (tmpData.Summa_doc) AS SaleSumm
                   FROM tmpData
                   WHERE -- просрочка на эту сумму - 1 неделя
                         COALESCE (tmpData.Summa_doc_1, 0) <= 0
                      --  просрочка на эту сумму - 2 неделя
                     AND COALESCE (tmpData.Summa_doc_2, 0) <= 0
                      --  просрочка на эту сумму - 3 неделя
                     AND COALESCE (tmpData.Summa_doc_3, 0) <= 0
                      --  просрочка на эту сумму - 4 неделя
                     AND COALESCE (tmpData.Summa_doc_4, 0) <= 0
                      --  просрочка на эту сумму > 4 недель
                     AND COALESCE (tmpData.Summa_doc_5, 0) <= 0
                      --  долг по накладной
                     AND COALESCE (tmpData.Summa_doc_0, 0) <= 0
                     --
                     --AND vbUserId <> 5

                   GROUP BY tmpData.JuridicalId
                          , tmpData.PartnerId
                          , tmpData.ContractId
                          , tmpData.PaidKindId
                          , tmpData.BranchId
                  ) AS tmpData_minus
                    ON tmpData_minus.JuridicalId = tmpReport.JuridicalId
                   AND tmpData_minus.PartnerId   = tmpReport.PartnerId
                   AND tmpData_minus.ContractId  = tmpReport.ContractId
                   AND tmpData_minus.PaidKindId  = tmpReport.PaidKindId
                   AND tmpData_minus.BranchId    = tmpReport.BranchId
                   AND tmpReport.Ord             = 1

   /*WHERE ((tmpReport.DebetRemains <> 0 OR tmpReport.KreditRemains <> 0
        OR tmpReport.SaleSumm <> 0 -- OR tmpReport.DefermentPaymentRemains TFloat
        OR tmpReport.SaleSumm1 <> 0 OR tmpReport.SaleSumm2 <> 0 OR tmpReport.SaleSumm3 <> 0 OR tmpReport.SaleSumm4 <> 0 OR tmpReport.SaleSumm5 <> 0
          )
      AND tmpReport.Ord = 1
         ) OR*/

        LEFT JOIN ObjectLink AS ObjectLink_Partner_PartnerTag
                             ON ObjectLink_Partner_PartnerTag.ObjectId = CASE WHEN tmpReport.ToId > 0 THEN tmpReport.ToId ELSE tmpReport.PartnerId END
                            AND ObjectLink_Partner_PartnerTag.DescId   = zc_ObjectLink_Partner_PartnerTag()
        LEFT JOIN Object AS Object_PartnerTag ON Object_PartnerTag.Id = ObjectLink_Partner_PartnerTag.ChildObjectId

   WHERE -- просрочка на эту сумму - 1 неделя
        (tmpReport.Summa_doc_1 > 0
      --  просрочка на эту сумму - 2 неделя
      OR tmpReport.Summa_doc_2 > 0
      --  просрочка на эту сумму - 3 неделя
      OR tmpReport.Summa_doc_3 > 0
      --  просрочка на эту сумму - 4 неделя
      OR tmpReport.Summa_doc_4 > 0
      --  просрочка на эту сумму > 4 недель
      OR tmpReport.Summa_doc_5 > 0
      --  долг по накладной
      OR tmpReport.Summa_doc_0 > 0

      OR CASE WHEN tmpReport.Ord = 1 THEN tmpReport.DebetRemains  ELSE 0 END <> 0
      OR CASE WHEN tmpReport.Ord = 1 THEN tmpReport.KreditRemains ELSE 0 END <> 0
    )
-- and tmpReport.JuridicalId = 8578350

      --
      --OR vbUserId = 5
   ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.11.22         * add Section
 12.11.21         *
 05.07.21         * add lp + inStartDate_sale, inEndDate_sale
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

-- тест
-- SELECT * FROM gpReport_JuridicalDefermentPaymentMovement(inOperDate := ('04.07.2024')::TDateTime , inEmptyParam := ('01.01.2016')::TDateTime , inAccountId := 9128 , inPaidKindId := 3 , inBranchId := 0 , inJuridicalGroupId := 0 ,  inSession := '378f6845-ef70-4e5b-aeb9-45d91bd5e82e') --WHERE SaleSumm <> 0
