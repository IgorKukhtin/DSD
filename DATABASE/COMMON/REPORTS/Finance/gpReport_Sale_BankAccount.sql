 -- Function: gpReport_Sale_BankAccount

DROP FUNCTION IF EXISTS gpReport_Sale_BankAccount (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Sale_BankAccount(
    IN inStartDate        TDateTime , --
    IN inEndDate          TDateTime , --
    IN inPaidKindId       Integer,    -- ФО
    IN inJuridicalId      Integer,    -- Юр лицо
    IN inContractId       Integer,    --  договор (для оплаты и продажи - должны совпадать)
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, OperDate TDatetime, InvNumber Integer, StatusCode Integer
             , ContractId Integer, ContractCode Integer, ContractName TVarChar, ContractTagName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
             , PaidKindName TVarChar

               -- накопительная - продажа
             , TotalSumm_calc TFloat
               -- Сумма с НДС (док.)
             , TotalSumm      TFloat
               -- Остаток по накладным - для распределения оплат
             , TotalSumm_rem  TFloat

               -- Итого оплата + взаимозачет
             , TotalAmount_Pay TFloat
               -- Итого оплата
             , TotalAmount_Bank TFloat
               -- Итого взаимозачет
             , TotalAmount_SendDebt TFloat

               -- Распределено - оплата
             , Summ_Pay       TFloat
               -- Распределено - долги
             , Summ_debt      TFloat
               -- Распределено - возвраты
             , Summ_ReturnIn   TFloat

               -- Распределено
             , Summ_calc   TFloat

               -- итого долги
             , TotalSumm_debt     TFloat
             , TotalSumm_debt_end TFloat
               -- итого ReturnIn
             , TotalSumm_ReturnIn TFloat

             , Ord          Integer
             , Ord_ReturnIn Integer   
             
             , SumPay1      TFloat
             , SumPay2      TFloat
             , SumReturn_1  TFloat
             , SumReturn_2  TFloat   
             , DatePay_1    TDateTime
             , DatePay_2    TDateTime
             , DateReturn_1 TDateTime
             , DateReturn_2 TDateTime
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbContractId_key Integer;
   DECLARE vbOperDate_m     TDateTime;
   DECLARE curMonth         refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     -- !!!Группируем Договора!!!
     vbContractId_key:= (SELECT View_Contract_ContractKey.ContractId_Key FROM Object_Contract_ContractKey_View AS View_Contract_ContractKey WHERE View_Contract_ContractKey.ContractId = inContractId);


     -- 0.1. Jur
     CREATE TEMP TABLE _tmpJur ON COMMIT DROP
       AS (SELECT inJuridicalId AS JuridicalId WHERE inJuridicalId > 0 -- AND vbUserId <> 5
          UNION
           SELECT DISTINCT ObjectLink_Contract_Juridical.ChildObjectId AS JuridicalId
           FROM Object_ContractCondition_View
                LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = Object_ContractCondition_View.InfoMoneyId

                LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                     ON ObjectLink_Contract_Juridical.ObjectId = Object_ContractCondition_View.ContractId
                                    AND ObjectLink_Contract_Juridical.DescId   = zc_ObjectLink_Contract_Juridical()

           WHERE (View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_21501() -- Маркетинг + Бонусы за продукцию
               OR View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_21502() -- Маркетинг + Бонусы за мясное сырье
               OR View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_21512() -- Маркетинг + Маркетинговый бюджет
                 )
             AND Object_ContractCondition_View.PaidKindId           = zc_Enum_PaidKind_SecondForm()
             AND Object_ContractCondition_View.PaidKindId_Condition = zc_Enum_PaidKind_FirstForm()
             AND Object_ContractCondition_View.isErased = FALSE
             AND COALESCE (inJuridicalId, 0) = 0
             -- AND ObjectLink_Contract_Juridical.ChildObjectId = 709540
          );


     -- 0.2. ФО
     CREATE TEMP TABLE _tmpPaidKind ON COMMIT DROP
       AS (SELECT inPaidKindId AS Id WHERE inPaidKindId > 0
        --UNION
        -- SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_PaidKind() AND COALESCE (inPaidKindId, 0) = 0
          );


     -- 1.1. Продажи
     CREATE TEMP TABLE _tmpSale ON COMMIT DROP
       AS (WITH tmpSale_period_1 AS (SELECT Movement.Id AS MovementId
                                          , Movement.StatusId
                                          , Movement.InvNumber
                                          , Movement.OperDate AS OperDate_unit
                                          , MovementDate_OperDatePartner.ValueData AS OperDate
                                          , EXTRACT (YEAR FROM MovementDate_OperDatePartner.ValueData)  AS OperDate_y
                                          , EXTRACT (MONTH FROM MovementDate_OperDatePartner.ValueData) AS OperDate_m
                                          , MovementLinkObject_PaidKind.ObjectId       AS PaidKindId
                                            -- замена - Группируем Договора
                                          , View_Contract_ContractKey.ContractId_key   AS ContractId
                                            -- только для НАЛ
                                          , CASE WHEN MovementLinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm() THEN MovementLinkObject_To.ObjectId ELSE 0 END AS PartnerId
                                            --
                                          , ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                                          , MovementFloat_TotalSumm.ValueData          AS SummSale
                                            -- сортировка от последней накладной к первой
                                          , ROW_NUMBER() OVER (PARTITION BY ObjectLink_Partner_Juridical.ChildObjectId
                                                                          , CASE WHEN MovementLinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm() THEN MovementLinkObject_To.ObjectId ELSE 0 END
                                                                          , View_Contract_ContractKey.ContractId_key
                                                                          , MovementLinkObject_PaidKind.ObjectId
                                                               ORDER BY MovementDate_OperDatePartner.ValueData DESC, Movement.Id DESC
                                                              ) AS Ord
                                            -- сортировка от первой к последней накладной
                                          , ROW_NUMBER() OVER (PARTITION BY ObjectLink_Partner_Juridical.ChildObjectId
                                                                          , CASE WHEN MovementLinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm() THEN MovementLinkObject_To.ObjectId ELSE 0 END
                                                                          , View_Contract_ContractKey.ContractId_key
                                                                          , MovementLinkObject_PaidKind.ObjectId
                                                               ORDER BY Movement.Id ASC
                                                              ) AS Ord_all_asc
                                     FROM Movement
                                          INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                                                  ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                                                 AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                                                 AND MovementDate_OperDatePartner.ValueData BETWEEN DATE_TRUNC ('YEAR', inStartDate - INTERVAL '12 MONTH') AND inEndDate
                                          INNER JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                                        ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                                                       AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                                                                       AND MovementLinkObject_PaidKind.ObjectId IN (SELECT _tmpPaidKind.Id FROM _tmpPaidKind)
                          
                                          INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                        ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                                       AND MovementLinkObject_Contract.DescId     = zc_MovementLinkObject_Contract()
                                          -- !!!Группируем Договора!!!
                                          LEFT JOIN Object_Contract_ContractKey_View AS View_Contract_ContractKey ON View_Contract_ContractKey.ContractId = MovementLinkObject_Contract.ObjectId
                          
                                          INNER JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                                                ON ObjectLink_Contract_InfoMoney.ObjectId = MovementLinkObject_Contract.ObjectId
                                                               AND ObjectLink_Contract_InfoMoney.DescId   = zc_ObjectLink_Contract_InfoMoney()
                                          -- !!!Ограничили!!!
                                          INNER JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyDestination
                                                                ON ObjectLink_InfoMoney_InfoMoneyDestination.ObjectId      = ObjectLink_Contract_InfoMoney.ChildObjectId
                                                               AND ObjectLink_InfoMoney_InfoMoneyDestination.DescId        = zc_ObjectLink_InfoMoney_InfoMoneyDestination()
                                                               -- !!!Доходы + Продукция + Мясное сырье
                                                               AND ObjectLink_InfoMoney_InfoMoneyDestination.ChildObjectId IN (zc_Enum_InfoMoneyDestination_30100()
                                                                                                                             , zc_Enum_InfoMoneyDestination_30200()
                                                                                                                              )
                          
                                          INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                        ON MovementLinkObject_To.MovementId = Movement.Id
                                                                       AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                               ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                                              AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                                          -- !!!Ограничили!!!
                                          INNER JOIN _tmpJur ON _tmpJur.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                          
                                          INNER JOIN MovementFloat AS MovementFloat_TotalSumm
                                                                   ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                                                  AND MovementFloat_TotalSumm.DescId     = zc_MovementFloat_TotalSumm()
                                                                  AND MovementFloat_TotalSumm.ValueData  > 0
                          
                                     WHERE Movement.DescId   = zc_Movement_Sale()
                                       AND Movement.StatusId = zc_Enum_Status_Complete()
                                          -- !!!Группируем Договора!!!
                                       AND (View_Contract_ContractKey.ContractId_key = vbContractId_key OR COALESCE (vbContractId_key, 0) = 0)
                                    )
              , tmpSale_period_2 AS (SELECT Movement.Id AS MovementId
                                          , Movement.StatusId
                                          , Movement.InvNumber
                                          , Movement.OperDate AS OperDate_unit
                                          , MovementDate_OperDatePartner.ValueData AS OperDate
                                          , EXTRACT (YEAR FROM MovementDate_OperDatePartner.ValueData)  AS OperDate_y
                                          , EXTRACT (MONTH FROM MovementDate_OperDatePartner.ValueData) AS OperDate_m
                                          , MovementLinkObject_PaidKind.ObjectId       AS PaidKindId
                                            -- замена - Группируем Договора
                                          , View_Contract_ContractKey.ContractId_key   AS ContractId
                                            -- только для НАЛ
                                          , CASE WHEN MovementLinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm() THEN MovementLinkObject_To.ObjectId ELSE 0 END AS PartnerId
                                            --
                                          , ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                                          , MovementFloat_TotalSumm.ValueData          AS SummSale
                                            -- сортировка от последней накладной к первой
                                          , ROW_NUMBER() OVER (PARTITION BY ObjectLink_Partner_Juridical.ChildObjectId
                                                                          , CASE WHEN MovementLinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm() THEN MovementLinkObject_To.ObjectId ELSE 0 END
                                                                          , View_Contract_ContractKey.ContractId_key
                                                                          , MovementLinkObject_PaidKind.ObjectId
                                                               ORDER BY MovementDate_OperDatePartner.ValueData DESC, Movement.Id DESC
                                                              ) AS Ord
                                            -- сортировка от первой к последней накладной
                                          , ROW_NUMBER() OVER (PARTITION BY ObjectLink_Partner_Juridical.ChildObjectId
                                                                          , CASE WHEN MovementLinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm() THEN MovementLinkObject_To.ObjectId ELSE 0 END
                                                                          , View_Contract_ContractKey.ContractId_key
                                                                          , MovementLinkObject_PaidKind.ObjectId
                                                               ORDER BY Movement.Id ASC
                                                              ) AS Ord_all_asc
                                     FROM Movement
                                          INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                                                  ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                                                 AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                                                 AND MovementDate_OperDatePartner.ValueData BETWEEN DATE_TRUNC ('YEAR', inStartDate - INTERVAL '36 MONTH') AND (DATE_TRUNC ('YEAR', inStartDate - INTERVAL '12 MONTH') - INTERVAL '1 DAY')
                                          INNER JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                                        ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                                                       AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                                                                       AND MovementLinkObject_PaidKind.ObjectId IN (SELECT _tmpPaidKind.Id FROM _tmpPaidKind)
                          
                                          INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                        ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                                       AND MovementLinkObject_Contract.DescId     = zc_MovementLinkObject_Contract()
                                          -- !!!Группируем Договора!!!
                                          LEFT JOIN Object_Contract_ContractKey_View AS View_Contract_ContractKey ON View_Contract_ContractKey.ContractId = MovementLinkObject_Contract.ObjectId
                          
                                          INNER JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                                                ON ObjectLink_Contract_InfoMoney.ObjectId = MovementLinkObject_Contract.ObjectId
                                                               AND ObjectLink_Contract_InfoMoney.DescId   = zc_ObjectLink_Contract_InfoMoney()
                                          -- !!!Ограничили!!!
                                          INNER JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyDestination
                                                                ON ObjectLink_InfoMoney_InfoMoneyDestination.ObjectId      = ObjectLink_Contract_InfoMoney.ChildObjectId
                                                               AND ObjectLink_InfoMoney_InfoMoneyDestination.DescId        = zc_ObjectLink_InfoMoney_InfoMoneyDestination()
                                                               -- !!!Доходы + Продукция + Мясное сырье
                                                               AND ObjectLink_InfoMoney_InfoMoneyDestination.ChildObjectId IN (zc_Enum_InfoMoneyDestination_30100()
                                                                                                                             , zc_Enum_InfoMoneyDestination_30200()
                                                                                                                              )
                          
                                          INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                        ON MovementLinkObject_To.MovementId = Movement.Id
                                                                       AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                               ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                                              AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                                          -- !!!Ограничили!!!
                                          INNER JOIN _tmpJur ON _tmpJur.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                          
                                          INNER JOIN MovementFloat AS MovementFloat_TotalSumm
                                                                   ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                                                  AND MovementFloat_TotalSumm.DescId     = zc_MovementFloat_TotalSumm()
                                                                  AND MovementFloat_TotalSumm.ValueData  > 0
                          
                                     WHERE Movement.DescId   = zc_Movement_Sale()
                                       AND Movement.StatusId = zc_Enum_Status_Complete()
                                          -- !!!Группируем Договора!!!
                                       AND (View_Contract_ContractKey.ContractId_key = vbContractId_key OR COALESCE (vbContractId_key, 0) = 0)
                                       AND NOT EXISTS (SELECT 1 FROM tmpSale_period_1)
                                    )
             -- Результат
             SELECT tmpSale_period.MovementId
                  , tmpSale_period.StatusId
                  , tmpSale_period.InvNumber
                  , tmpSale_period.OperDate_unit
                  , tmpSale_period.OperDate
                  , tmpSale_period.OperDate_y
                  , tmpSale_period.OperDate_m
                  , tmpSale_period.PaidKindId
                    -- замена - Группируем Договора
                  , tmpSale_period.ContractId
                    --
                  , tmpSale_period.PartnerId
                  , tmpSale_period.JuridicalId
                  , tmpSale_period.SummSale
                    -- сортировка от последней накладной к первой
                  , tmpSale_period.Ord
                    -- сортировка от первой к последней накладной
                  , tmpSale_period.Ord_all_asc
             FROM tmpSale_period_1 AS tmpSale_period

            UNION ALL
             SELECT tmpSale_period.MovementId
                  , tmpSale_period.StatusId
                  , tmpSale_period.InvNumber
                  , tmpSale_period.OperDate_unit
                  , tmpSale_period.OperDate
                  , tmpSale_period.OperDate_y
                  , tmpSale_period.OperDate_m
                  , tmpSale_period.PaidKindId
                    -- замена - Группируем Договора
                  , tmpSale_period.ContractId
                    --
                  , tmpSale_period.PartnerId
                  , tmpSale_period.JuridicalId
                  , tmpSale_period.SummSale
                    -- сортировка от последней накладной к первой
                  , tmpSale_period.Ord
                    -- сортировка от первой к последней накладной
                  , tmpSale_period.Ord_all_asc
             FROM tmpSale_period_2 AS tmpSale_period
            )
          ;


     -- 1.2. ReturnIn
     CREATE TEMP TABLE _tmpReturnIn ON COMMIT DROP
       AS (SELECT ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                  --
                , CASE WHEN MovementLinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm() THEN MovementLinkObject_From.ObjectId ELSE 0 END AS PartnerId
                  -- замена - Группируем Договора
                , View_Contract_ContractKey.ContractId_key   AS ContractId
                  --
                , MovementLinkObject_PaidKind.ObjectId       AS PaidKindId
                  --
                , SUM (MovementFloat_TotalSumm.ValueData)    AS Summ_ReturnIn

           FROM Movement
                INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                        ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                       AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                       -- за период
                                       AND MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate

                INNER JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                              ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                             AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                                             AND MovementLinkObject_PaidKind.ObjectId IN (SELECT _tmpPaidKind.Id FROM _tmpPaidKind)

                INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                              ON MovementLinkObject_Contract.MovementId = Movement.Id
                                             AND MovementLinkObject_Contract.DescId     = zc_MovementLinkObject_Contract()
                -- !!!Группируем Договора!!!
                LEFT JOIN Object_Contract_ContractKey_View AS View_Contract_ContractKey ON View_Contract_ContractKey.ContractId = MovementLinkObject_Contract.ObjectId

                INNER JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                      ON ObjectLink_Contract_InfoMoney.ObjectId = MovementLinkObject_Contract.ObjectId
                                     AND ObjectLink_Contract_InfoMoney.DescId   = zc_ObjectLink_Contract_InfoMoney()
                -- !!!Ограничили!!!
                INNER JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyDestination
                                      ON ObjectLink_InfoMoney_InfoMoneyDestination.ObjectId      = ObjectLink_Contract_InfoMoney.ChildObjectId
                                     AND ObjectLink_InfoMoney_InfoMoneyDestination.DescId        = zc_ObjectLink_InfoMoney_InfoMoneyDestination()
                                     -- !!!Доходы + Продукция + Мясное сырье
                                     AND ObjectLink_InfoMoney_InfoMoneyDestination.ChildObjectId IN (zc_Enum_InfoMoneyDestination_30100()
                                                                                                   , zc_Enum_InfoMoneyDestination_30200()
                                                                                                    )

                INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                              ON MovementLinkObject_From.MovementId = Movement.Id
                                             AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                     ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                    AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                -- !!!Ограничили!!!
                INNER JOIN _tmpJur ON _tmpJur.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId

                INNER JOIN MovementFloat AS MovementFloat_TotalSumm
                                         ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                        AND MovementFloat_TotalSumm.DescId     = zc_MovementFloat_TotalSumm()
                                        AND MovementFloat_TotalSumm.ValueData  > 0

           WHERE Movement.DescId   = zc_Movement_ReturnIn()
             AND Movement.StatusId = zc_Enum_Status_Complete()
                -- !!!Группируем Договора!!!
             AND (View_Contract_ContractKey.ContractId_key = vbContractId_key OR COALESCE (vbContractId_key, 0) = 0)

           GROUP BY MovementLinkObject_PaidKind.ObjectId
                  , View_Contract_ContractKey.ContractId_key
                  , CASE WHEN MovementLinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm() THEN MovementLinkObject_From.ObjectId ELSE 0 END
                  , ObjectLink_Partner_Juridical.ChildObjectId
          );



     -- Долги
     CREATE TEMP TABLE _tmpDebt (JuridicalId Integer, PartnerId Integer, ContractId Integer, PaidKindId Integer, MovementId_sale Integer, OperDate_sale TDateTime, Summ_debt TFloat, Summ_debt_end TFloat, Summ_sale TFloat) ON COMMIT DROP;
     --
     INSERT INTO _tmpDebt (JuridicalId, PartnerId, ContractId, PaidKindId, MovementId_sale, OperDate_sale, Summ_debt, Summ_debt_end, Summ_sale)
        WITH -- Дебиторы
             tmpAccount AS (SELECT Object_Account_View.AccountId FROM Object_Account_View WHERE AccountGroupId = zc_Enum_AccountGroup_30000())
             -- ВСЕ долги на начало inStartDate + на конец inEndDate
           , tmpContainer AS (SELECT CLO_Juridical.ContainerId                   AS ContainerId
                                   , CLO_Juridical.ObjectId                      AS JuridicalId
                                   , CASE WHEN CLO_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm() THEN COALESCE (CLO_Partner.ObjectId, 0) ELSE 0 END AS PartnerId
                                   , View_Contract_ContractKey.ContractId_key    AS ContractId
                                   , CLO_PaidKind.ObjectId                       AS PaidKindId
                                     -- долг на начало
                                   , Container.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) AS Summ_debt
                                     -- долг на конец
                                   , Container.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS Summ_debt_end

                              FROM ContainerLinkObject AS CLO_Juridical
                                   INNER JOIN Container ON Container.Id = CLO_Juridical.ContainerId AND Container.DescId = zc_Container_Summ()
                                   -- !!!Ограничили!!!
                                   INNER JOIN tmpAccount ON tmpAccount.AccountId = Container.ObjectId

                                   -- !!!Ограничили!!!
                                   INNER JOIN _tmpJur ON _tmpJur.JuridicalId = CLO_Juridical.ObjectId

                                   LEFT JOIN ContainerLinkObject AS CLO_Contract
                                                                 ON CLO_Contract.ContainerId = Container.Id
                                                                AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()
                                   -- !!!Группируем Договора!!!
                                   LEFT JOIN Object_Contract_ContractKey_View AS View_Contract_ContractKey ON View_Contract_ContractKey.ContractId = CLO_Contract.ObjectId

                                   LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                                                 ON CLO_InfoMoney.ContainerId = Container.Id
                                                                AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                   -- !!!Ограничили!!!
                                   INNER JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyDestination
                                                         ON ObjectLink_InfoMoney_InfoMoneyDestination.ObjectId      = CLO_InfoMoney.ObjectId
                                                        AND ObjectLink_InfoMoney_InfoMoneyDestination.DescId        = zc_ObjectLink_InfoMoney_InfoMoneyDestination()
                                                        -- !!!Доходы + Продукция + Мясное сырье
                                                        AND ObjectLink_InfoMoney_InfoMoneyDestination.ChildObjectId IN (zc_Enum_InfoMoneyDestination_30100()
                                                                                                                      , zc_Enum_InfoMoneyDestination_30200()
                                                                                                                       )

                                   INNER JOIN ContainerLinkObject AS CLO_PaidKind
                                                                  ON CLO_PaidKind.ContainerId = Container.Id
                                                                 AND CLO_PaidKind.DescId      = zc_ContainerLinkObject_PaidKind()
                                   INNER JOIN _tmpPaidKind ON _tmpPaidKind.Id = CLO_PaidKind.ObjectId

                                   LEFT JOIN ContainerLinkObject AS CLO_Partner
                                                                 ON CLO_Partner.ContainerId = Container.Id
                                                                AND CLO_Partner.DescId      = zc_ContainerLinkObject_Partner()

                                   LEFT JOIN MovementItemContainer AS MIContainer
                                                                   ON MIContainer.Containerid = Container.Id
                                                                  -- ВСЕ долги на начало inStartDate
                                                                  AND MIContainer.OperDate    >= inStartDate
                                                                  --ВСЕ долги на конец inEndDate
                                                                  --AND MIContainer.OperDate    > inEndDate

                              WHERE CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                 -- !!!Группируем Договора!!!
                                AND (View_Contract_ContractKey.ContractId_key = vbContractId_key OR COALESCE (vbContractId_key, 0) = 0)

                              GROUP BY CLO_Juridical.ContainerId
                                     , CLO_Juridical.ObjectId
                                     , CASE WHEN CLO_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm() THEN COALESCE (CLO_Partner.ObjectId, 0) ELSE 0 END
                                     , View_Contract_ContractKey.ContractId_key
                                     , CLO_PaidKind.ObjectId
                                     , Container.Amount
                              HAVING Container.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) <> 0
                                  OR Container.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) <> 0
                             )
                 -- Список по накладным
               , tmpList AS (SELECT _tmpSale.MovementId
                                  , _tmpSale.OperDate AS OperDate_sale
                                  , _tmpSale.JuridicalId
                                  , _tmpSale.PartnerId
                                  , _tmpSale.ContractId
                                  , _tmpSale.PaidKindId
                                    -- сумма Итого Долг - для нее подбор в продажах
                                  , tmpContainer.Summ_debt
                                    -- сумма в документе продажа
                                  , _tmpSale.SummSale
                                    -- накопительная сумма продаж
                                  , SUM (_tmpSale.SummSale)
                                        OVER (PARTITION BY _tmpSale.JuridicalId, _tmpSale.PartnerId, _tmpSale.ContractId, _tmpSale.PaidKindId
                                              -- сортировка от последней накладной к первой
                                              ORDER BY _tmpSale.Ord
                                             )
                                        AS SummSale_SUM
                             FROM _tmpSale
                                  -- Итого долги
                                  INNER JOIN (SELECT tmpContainer.JuridicalId
                                                   , tmpContainer.PartnerId
                                                   , tmpContainer.ContractId
                                                   , tmpContainer.PaidKindId
                                                   , SUM (tmpContainer.Summ_debt) AS Summ_debt
                                              FROM tmpContainer
                                              GROUP BY tmpContainer.JuridicalId
                                                     , tmpContainer.PartnerId
                                                     , tmpContainer.ContractId
                                                     , tmpContainer.PaidKindId
                                             ) AS tmpContainer
                                               ON tmpContainer.JuridicalId = _tmpSale.JuridicalId
                                              AND tmpContainer.PartnerId   = _tmpSale.PartnerId
                                              AND tmpContainer.ContractId  = _tmpSale.ContractId
                                              AND tmpContainer.PaidKindId  = _tmpSale.PaidKindId
                             WHERE _tmpSale.OperDate < inStartDate

                            )
                 -- Результат по накладным
               , tmpRes AS (SELECT DD.JuridicalId
                                 , DD.PartnerId
                                 , DD.ContractId
                                 , DD.PaidKindId
                                   --
                                 , DD.MovementId AS MovementId_sale
                                 , DD.OperDate_sale
                                   --
                                 , CASE WHEN DD.Summ_debt - DD.SummSale_SUM > 0
                                             THEN DD.SummSale
                                        ELSE DD.Summ_debt - DD.SummSale_SUM + DD.SummSale
                                   END AS Summ_debt
                            FROM (SELECT * FROM tmpList) AS DD
                            WHERE DD.Summ_debt - (DD.SummSale_SUM - DD.SummSale) > 0
                           )

            -- долги - нашли накладные
            SELECT tmpRes.JuridicalId
                 , tmpRes.PartnerId
                 , tmpRes.ContractId
                 , tmpRes.PaidKindId

                 , tmpRes.MovementId_sale
                 , tmpRes.OperDate_sale
                 , tmpRes.Summ_debt
                 , 0 AS Summ_debt_end
                   -- Продажа за текущий период
                 , 0 AS Summ_sale
            FROM tmpRes

           UNION ALL
            -- долги - НЕ нашли накладные
            SELECT tmpContainer.JuridicalId
                 , tmpContainer.PartnerId
                 , tmpContainer.ContractId
                 , tmpContainer.PaidKindId

                 , 0 AS MovementId_sale
                 , inEndDate + INTERVAL '1 DAY' AS OperDate_sale
                   -- разница
                 , tmpContainer.Summ_debt - COALESCE (tmpRes.Summ_debt, 0) AS Summ_debt
                 , 0 AS Summ_debt_end
                   -- Продажа за текущий период
                 , 0 AS Summ_sale

            FROM -- Итого долги
                 (SELECT tmpContainer.JuridicalId
                       , tmpContainer.PartnerId
                       , tmpContainer.ContractId
                       , tmpContainer.PaidKindId
                       , SUM (tmpContainer.Summ_debt) AS Summ_debt
                  FROM tmpContainer
                  GROUP BY tmpContainer.JuridicalId
                         , tmpContainer.PartnerId
                         , tmpContainer.ContractId
                         , tmpContainer.PaidKindId
                 ) AS tmpContainer

                 -- Итого по накладным - нашли
                 LEFT JOIN (SELECT tmpRes.JuridicalId
                                 , tmpRes.PartnerId
                                 , tmpRes.ContractId
                                 , tmpRes.PaidKindId
                                 , SUM (tmpRes.Summ_debt) AS Summ_debt
                            FROM tmpRes
                            GROUP BY tmpRes.JuridicalId
                                   , tmpRes.PartnerId
                                   , tmpRes.ContractId
                                   , tmpRes.PaidKindId
                           ) AS tmpRes
                             ON tmpRes.JuridicalId = tmpContainer.JuridicalId
                            AND tmpRes.PartnerId   = tmpContainer.PartnerId
                            AND tmpRes.ContractId  = tmpContainer.ContractId
                            AND tmpRes.PaidKindId  = tmpContainer.PaidKindId
            WHERE tmpContainer.Summ_debt <> COALESCE (tmpRes.Summ_debt, 0)

           UNION ALL
            -- Продажа
            SELECT _tmpSale.JuridicalId
                 , _tmpSale.PartnerId
                 , _tmpSale.ContractId
                 , _tmpSale.PaidKindId

                 , _tmpSale.MovementId AS MovementId_sale
                 , _tmpSale.OperDate   AS OperDate_sale
                   -- разница
                 , 0 AS Summ_debt
                 , 0 AS Summ_debt_end
                   -- Продажа за текущий период
                 , _tmpSale.SummSale AS Summ_sale

            FROM _tmpSale
            WHERE _tmpSale.OperDate >= inStartDate

           UNION ALL
            -- Долги
            SELECT tmpContainer.JuridicalId
                 , tmpContainer.PartnerId
                 , tmpContainer.ContractId
                 , tmpContainer.PaidKindId

                 , 0 AS MovementId_sale
                 , inEndDate + INTERVAL '1 DAY' AS OperDate_sale
                   -- долг на начало
                 , 0 AS Summ_debt
                   -- долг на конец
                 , SUM (tmpContainer.Summ_debt_end) AS Summ_debt_end
                   -- Продажа за текущий период
                 , 0 AS Summ_sale

            FROM tmpContainer
            WHERE tmpContainer.Summ_debt_end <> 0
            GROUP BY tmpContainer.JuridicalId
                   , tmpContainer.PartnerId
                   , tmpContainer.ContractId
                   , tmpContainer.PaidKindId
           ;

     -- добавили если не нашли - Долги
     INSERT INTO _tmpSale (MovementId, StatusId, InvNumber, OperDate, PaidKindId, ContractId, PartnerId, JuridicalId, SummSale, Ord, Ord_all_asc)
        SELECT DISTINCT
               0 AS MovementId
             , 0 AS StatusId
             , 0 AS InvNumber
             , _tmpDebt.OperDate_sale AS OperDate
             , _tmpDebt.PaidKindId
             , _tmpDebt.ContractId
             , _tmpDebt.PartnerId
             , _tmpDebt.JuridicalId
             , 0 AS SummSale
             , 1 AS Ord
             , 0 AS Ord_all_asc
        FROM _tmpDebt
             LEFT JOIN _tmpSale ON _tmpSale.Ord         = 1
                             --AND _tmpSale.MovementId  = _tmpDebt.MovementId_sale
                               AND _tmpSale.JuridicalId = _tmpDebt.JuridicalId
                               AND _tmpSale.PartnerId   = _tmpDebt.PartnerId
                               AND _tmpSale.ContractId  = _tmpDebt.ContractId
                               AND _tmpSale.PaidKindId  = _tmpDebt.PaidKindId
        WHERE _tmpSale.Ord IS NULL -- _tmpSale.MovementId IS NULL
          -- без этих долгов
          AND _tmpDebt.Summ_debt_end = 0
       ;


     -- возвраты привязаны к долгам
     CREATE TEMP TABLE _tmpReturnIn_res (JuridicalId Integer, PartnerId Integer, ContractId Integer, PaidKindId Integer, MovementId_sale Integer, Summ_ReturnIn TFloat, Summ_ReturnIn_next TFloat) ON COMMIT DROP;

     -- возвраты привязаны по накладным к долгам
     INSERT INTO _tmpReturnIn_res (JuridicalId, PartnerId, ContractId, PaidKindId, MovementId_sale, Summ_ReturnIn, Summ_ReturnIn_next)
            WITH tmpList AS (SELECT _tmpDebt.JuridicalId, _tmpDebt.PartnerId, _tmpDebt.ContractId, _tmpDebt.PaidKindId
                                  , _tmpDebt.MovementId_sale
                                    -- сумма Итого Возврат - для нее подбор в долгах
                                  , _tmpReturnIn.Summ_ReturnIn
                                    -- сумма в документе
                                  , _tmpDebt.Summ_debt
                                    -- накопительная сумма
                                  , SUM (_tmpDebt.Summ_debt)
                                        OVER (PARTITION BY _tmpDebt.JuridicalId, _tmpDebt.PartnerId, _tmpDebt.ContractId, _tmpDebt.PaidKindId
                                              -- !!!сортировка от первой накладной к последней!!!
                                              ORDER BY CASE WHEN _tmpDebt.Summ_debt > 0 THEN 0 ELSE 1 END
                                                     , _tmpDebt.OperDate_sale ASC, _tmpDebt.MovementId_sale ASC
                                             )
                                        AS Summ_debt_SUM

                                    -- сумма в документе
                                  , _tmpDebt.Summ_sale
                                    -- накопительная сумма
                                  , SUM (_tmpDebt.Summ_sale)
                                        OVER (PARTITION BY _tmpDebt.JuridicalId, _tmpDebt.PartnerId, _tmpDebt.ContractId, _tmpDebt.PaidKindId
                                              -- !!!сортировка от первой накладной к последней!!!
                                              ORDER BY CASE WHEN _tmpDebt.Summ_sale > 0 THEN 0 ELSE 1 END
                                                     , _tmpDebt.OperDate_sale ASC, _tmpDebt.MovementId_sale ASC
                                             )
                                        AS Summ_sale_SUM

                             FROM _tmpDebt
                                  -- Итого по возвратам
                                  INNER JOIN _tmpReturnIn
                                          ON _tmpReturnIn.JuridicalId = _tmpDebt.JuridicalId
                                         AND _tmpReturnIn.PartnerId   = _tmpDebt.PartnerId
                                         AND _tmpReturnIn.ContractId  = _tmpDebt.ContractId
                                         AND _tmpReturnIn.PaidKindId  = _tmpDebt.PaidKindId

                             WHERE _tmpDebt.MovementId_sale > 0
                            )
               -- Результат по накладным
             , tmpRes_1 AS (SELECT DD.JuridicalId
                                 , DD.PartnerId
                                 , DD.ContractId
                                 , DD.PaidKindId
                                   --
                                 , DD.MovementId_sale
                                   --
                                 , CASE WHEN DD.Summ_ReturnIn - DD.Summ_debt_SUM > 0
                                             THEN DD.Summ_debt
                                        ELSE DD.Summ_ReturnIn - DD.Summ_debt_SUM + DD.Summ_debt
                                   END AS Summ_ReturnIn
                            FROM (SELECT * FROM tmpList
                                  -- если долги разбиты по накладным
                                  WHERE tmpList.Summ_debt_SUM > 0
                                 ) AS DD
                            WHERE DD.Summ_ReturnIn - (DD.Summ_debt_SUM - DD.Summ_debt) > 0
                           )

                 -- Результат по накладным
               , tmpRes AS (SELECT tmpRes_1.JuridicalId
                                 , tmpRes_1.PartnerId
                                 , tmpRes_1.ContractId
                                 , tmpRes_1.PaidKindId
                                   --
                                 , tmpRes_1.MovementId_sale
                                   --
                                 , tmpRes_1.Summ_ReturnIn
                                 , 0 AS Summ_ReturnIn_next
                            FROM tmpRes_1

                           UNION ALL
                            SELECT DD.JuridicalId
                                 , DD.PartnerId
                                 , DD.ContractId
                                 , DD.PaidKindId
                                   --
                                 , DD.MovementId_sale
                                   --
                                 , CASE WHEN DD.Summ_ReturnIn - DD.Summ_sale_SUM > 0
                                             THEN DD.Summ_sale
                                        ELSE DD.Summ_ReturnIn - DD.Summ_sale_SUM + DD.Summ_sale
                                   END AS Summ_ReturnIn
                                   -- тоже самое
                                 , CASE WHEN DD.Summ_ReturnIn - DD.Summ_sale_SUM > 0
                                             THEN DD.Summ_sale
                                        ELSE DD.Summ_ReturnIn - DD.Summ_sale_SUM + DD.Summ_sale
                                   END AS Summ_ReturnIn_next

                            FROM (SELECT tmpList.JuridicalId, tmpList.PartnerId, tmpList.ContractId, tmpList.PaidKindId
                                       , tmpList.MovementId_sale
                                         -- сумма Итого Возврат - для нее подбор в долгах - МИНУС распределение
                                       , tmpList.Summ_ReturnIn - COALESCE (tmpRes_1.Summ_ReturnIn, 0) AS Summ_ReturnIn
                                         -- сумма в документе
                                       , tmpList.Summ_sale
                                         -- накопительная сумма
                                       , tmpList.Summ_sale_SUM
                                  FROM tmpList
                                       -- минус сколько распределили с долгов
                                       LEFT JOIN (SELECT tmpRes_1.JuridicalId
                                                       , tmpRes_1.PartnerId
                                                       , tmpRes_1.ContractId
                                                       , tmpRes_1.PaidKindId
                                                         --
                                                       , SUM (tmpRes_1.Summ_ReturnIn) AS Summ_ReturnIn
                                                  FROM tmpRes_1
                                                  GROUP BY tmpRes_1.JuridicalId
                                                         , tmpRes_1.PartnerId
                                                         , tmpRes_1.ContractId
                                                         , tmpRes_1.PaidKindId
                                                 ) AS tmpRes_1
                                                   ON tmpRes_1.JuridicalId = tmpList.JuridicalId
                                                  AND tmpRes_1.PartnerId   = tmpList.PartnerId
                                                  AND tmpRes_1.ContractId  = tmpList.ContractId
                                                  AND tmpRes_1.PaidKindId  = tmpList.PaidKindId

                                  -- если для продаж
                                  WHERE tmpList.Summ_sale_SUM > 0
                                   -- если долгов не хватило, надо брать текущие продажи
                                   AND tmpList.Summ_ReturnIn - COALESCE (tmpRes_1.Summ_ReturnIn, 0) > 0
                                 ) AS DD
                            WHERE DD.Summ_ReturnIn - (DD.Summ_sale_SUM - DD.Summ_sale) > 0
                           )

            -- возвраты - нашли накладные
            SELECT tmpRes.JuridicalId
                 , tmpRes.PartnerId
                 , tmpRes.ContractId
                 , tmpRes.PaidKindId

                 , tmpRes.MovementId_sale
                 , SUM (tmpRes.Summ_ReturnIn)
                 , SUM (tmpRes.Summ_ReturnIn_next)
            FROM tmpRes
            GROUP BY tmpRes.JuridicalId
                   , tmpRes.PartnerId
                   , tmpRes.ContractId
                   , tmpRes.PaidKindId
                   , tmpRes.MovementId_sale

           UNION ALL
            -- возвраты - НЕ нашли накладные
            SELECT _tmpReturnIn.JuridicalId
                 , _tmpReturnIn.PartnerId
                 , _tmpReturnIn.ContractId
                 , _tmpReturnIn.PaidKindId

                 , 0 AS MovementId_sale
                   -- разница
                 , _tmpReturnIn.Summ_ReturnIn - COALESCE (tmpRes.Summ_ReturnIn, 0) AS Summ_ReturnIn
                 , 0 AS Summ_ReturnIn_next

            FROM -- Итого возвраты
                 _tmpReturnIn
                 -- Итого по накладным - нашли
                 LEFT JOIN (SELECT tmpRes.JuridicalId
                                 , tmpRes.PartnerId
                                 , tmpRes.ContractId
                                 , tmpRes.PaidKindId
                                 , SUM (tmpRes.Summ_ReturnIn) AS Summ_ReturnIn
                            FROM tmpRes
                            GROUP BY tmpRes.JuridicalId
                                   , tmpRes.PartnerId
                                   , tmpRes.ContractId
                                   , tmpRes.PaidKindId
                           ) AS tmpRes
                             ON tmpRes.JuridicalId = _tmpReturnIn.JuridicalId
                            AND tmpRes.PartnerId   = _tmpReturnIn.PartnerId
                            AND tmpRes.ContractId  = _tmpReturnIn.ContractId
                            AND tmpRes.PaidKindId  = _tmpReturnIn.PaidKindId
            WHERE _tmpReturnIn.Summ_ReturnIn <> COALESCE (tmpRes.Summ_ReturnIn, 0)
           ;

     -- добавили если не нашли - возвраты
     INSERT INTO _tmpSale (MovementId, StatusId, InvNumber, OperDate, PaidKindId, ContractId, PartnerId, JuridicalId, SummSale, Ord, Ord_all_asc)
        SELECT _tmpReturnIn_res.MovementId_sale AS MovementId
             , 0 AS StatusId
             , 0 AS InvNumber
             , inEndDate + INTERVAL '1 DAY' AS OperDate
             , _tmpReturnIn_res.PaidKindId
             , _tmpReturnIn_res.ContractId
             , _tmpReturnIn_res.PartnerId
             , _tmpReturnIn_res.JuridicalId
             , 0 AS SummSale
             , 1 AS Ord
             , 0 AS Ord_all_asc
        FROM _tmpReturnIn_res
             LEFT JOIN _tmpSale ON _tmpSale.Ord         = 1
                             --AND _tmpSale.MovementId  = _tmpReturnIn_res.MovementId_sale
                               AND _tmpSale.JuridicalId = _tmpReturnIn_res.JuridicalId
                               AND _tmpSale.PartnerId   = _tmpReturnIn_res.PartnerId
                               AND _tmpSale.ContractId  = _tmpReturnIn_res.ContractId
                               AND _tmpSale.PaidKindId  = _tmpReturnIn_res.PaidKindId
        WHERE _tmpSale.Ord IS NULL -- _tmpSale.MovementId IS NULL
       ;


     -- оплаты привязаны к долгам
     CREATE TEMP TABLE _tmpPay (JuridicalId Integer, PartnerId Integer, ContractId Integer, PaidKindId Integer, MovementId_sale Integer, TotalAmount TFloat, TotalAmount_next TFloat, Amount_Bank TFloat, Amount_SendDebt TFloat) ON COMMIT DROP;

     -- BankAccount
     WITH tmpMovement_BankAccount
                      AS (WITH tmpMovement AS (SELECT Movement.*
                                               FROM Movement
                                               WHERE Movement.DescId IN (zc_Movement_BankAccount()) -- , zc_Movement_SendDebt()
                                                 AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                                                 AND inPaidKindId = zc_Enum_PaidKind_FirstForm()
                                              )
                             , tmpMI AS (SELECT MovementItem.*
                                         FROM MovementItem
                                         WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                           AND MovementItem.DescId = zc_MI_Master()
                                           AND MovementItem.isErased = FALSE
                                        )
                             , tmpMILO_Contract AS (SELECT MovementItemLinkObject.MovementItemId
                                                         , View_Contract_ContractKey.ContractId_key AS ContractId
                                                    FROM MovementItemLinkObject
                                                         INNER JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                                                               ON ObjectLink_Contract_InfoMoney.ObjectId = MovementItemLinkObject.ObjectId
                                                                              AND ObjectLink_Contract_InfoMoney.DescId   = zc_ObjectLink_Contract_InfoMoney()
                                                         -- !!!Ограничили!!!
                                                         INNER JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyDestination
                                                                               ON ObjectLink_InfoMoney_InfoMoneyDestination.ObjectId      = ObjectLink_Contract_InfoMoney.ChildObjectId
                                                                              AND ObjectLink_InfoMoney_InfoMoneyDestination.DescId        = zc_ObjectLink_InfoMoney_InfoMoneyDestination()
                                                                              -- !!!Доходы + Продукция + Мясное сырье
                                                                              AND ObjectLink_InfoMoney_InfoMoneyDestination.ChildObjectId IN (zc_Enum_InfoMoneyDestination_30100()
                                                                                                                                            , zc_Enum_InfoMoneyDestination_30200()
                                                                                                                                             )
                                                         -- !!!Группируем Договора!!!
                                                         LEFT JOIN Object_Contract_ContractKey_View AS View_Contract_ContractKey ON View_Contract_ContractKey.ContractId = MovementItemLinkObject.ObjectId

                                                         INNER JOIN MovementItemLinkObject AS MILO_InfoMoney
                                                                                           ON MILO_InfoMoney.MovementItemId = MovementItemLinkObject.MovementItemId
                                                                                          AND MILO_InfoMoney.DescId         = zc_MILinkObject_InfoMoney()
                                                                                          AND MILO_InfoMoney.ObjectId       = ObjectLink_Contract_InfoMoney.ChildObjectId


                                                    WHERE MovementItemLinkObject.DescId = zc_MILinkObject_Contract()
                                                      AND MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                                       -- !!!Группируем Договора!!!
                                                      AND (View_Contract_ContractKey.ContractId_key = vbContractId_key OR COALESCE (vbContractId_key, 0) = 0)
                                                   )
                             , tmpMILO_MoneyPlace AS (SELECT MovementItemLinkObject.MovementItemId, MovementItemLinkObject.ObjectId
                                                      FROM MovementItemLinkObject
                                                            -- !!!Ограничили!!!
                                                            INNER JOIN _tmpJur ON _tmpJur.JuridicalId = MovementItemLinkObject.ObjectId

                                                      WHERE MovementItemLinkObject.DescId = zc_MILinkObject_MoneyPlace()
                                                        AND MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMILO_Contract.MovementItemId FROM tmpMILO_Contract)
                                                     )
                             -- BankAccount
                             SELECT MILinkObject_Contract.ContractId    AS ContractId
                                  , MILinkObject_MoneyPlace.ObjectId    AS JuridicalId
                                  , zc_Enum_PaidKind_FirstForm()        AS PaidKindId
                                  , SUM (CASE WHEN MovementItem.Amount > 0
                                              THEN MovementItem.Amount
                                              ELSE MovementItem.Amount
                                         END)                  ::TFloat AS Amount_Bank
                             FROM tmpMovement AS Movement
                                 INNER JOIN tmpMI AS MovementItem
                                                  ON MovementItem.MovementId = Movement.Id

                                 INNER JOIN tmpMILO_Contract AS MILinkObject_Contract
                                                             ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                 INNER JOIN tmpMILO_MoneyPlace AS MILinkObject_MoneyPlace
                                                               ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id

                             GROUP BY MILinkObject_Contract.ContractId
                                    , MILinkObject_MoneyPlace.ObjectId
                         )

    , tmpMovement_Cash
                      AS (WITH tmpMovement AS (SELECT Movement.*
                                               FROM Movement
                                               WHERE Movement.DescId IN (zc_Movement_Cash()) -- , zc_Movement_SendDebt()
                                                 AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                                                 AND inPaidKindId = zc_Enum_PaidKind_SecondForm()
                                              )
                             , tmpMI AS (SELECT MovementItem.*
                                         FROM MovementItem
                                         WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                           AND MovementItem.DescId = zc_MI_Master()
                                           AND MovementItem.isErased = FALSE
                                        )
                             , tmpMILO_Contract AS (SELECT MovementItemLinkObject.MovementItemId
                                                         , View_Contract_ContractKey.ContractId_key AS ContractId
                                                    FROM MovementItemLinkObject
                                                         INNER JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                                                               ON ObjectLink_Contract_InfoMoney.ObjectId = MovementItemLinkObject.ObjectId
                                                                              AND ObjectLink_Contract_InfoMoney.DescId   = zc_ObjectLink_Contract_InfoMoney()
                                                         -- !!!Ограничили!!!
                                                         INNER JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyDestination
                                                                               ON ObjectLink_InfoMoney_InfoMoneyDestination.ObjectId      = ObjectLink_Contract_InfoMoney.ChildObjectId
                                                                              AND ObjectLink_InfoMoney_InfoMoneyDestination.DescId        = zc_ObjectLink_InfoMoney_InfoMoneyDestination()
                                                                              -- !!!Доходы + Продукция + Мясное сырье
                                                                              AND ObjectLink_InfoMoney_InfoMoneyDestination.ChildObjectId IN (zc_Enum_InfoMoneyDestination_30100()
                                                                                                                                            , zc_Enum_InfoMoneyDestination_30200()
                                                                                                                                             )
                                                         -- !!!Группируем Договора!!!
                                                         LEFT JOIN Object_Contract_ContractKey_View AS View_Contract_ContractKey ON View_Contract_ContractKey.ContractId = MovementItemLinkObject.ObjectId

                                                         INNER JOIN MovementItemLinkObject AS MILO_InfoMoney
                                                                                           ON MILO_InfoMoney.MovementItemId = MovementItemLinkObject.MovementItemId
                                                                                          AND MILO_InfoMoney.DescId         = zc_MILinkObject_InfoMoney()
                                                                                          AND MILO_InfoMoney.ObjectId       = ObjectLink_Contract_InfoMoney.ChildObjectId


                                                    WHERE MovementItemLinkObject.DescId = zc_MILinkObject_Contract()
                                                      AND MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                                       -- !!!Группируем Договора!!!
                                                      AND (View_Contract_ContractKey.ContractId_key = vbContractId_key OR COALESCE (vbContractId_key, 0) = 0)
                                                   )
                             , tmpMILO_MoneyPlace AS (SELECT MovementItemLinkObject.MovementItemId, MovementItemLinkObject.ObjectId
                                                      FROM MovementItemLinkObject
                                                           LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                                                ON ObjectLink_Partner_Juridical.ObjectId = MovementItemLinkObject.ObjectId
                                                                               AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                                                            -- !!!Ограничили!!!
                                                            INNER JOIN _tmpJur ON _tmpJur.JuridicalId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementItemLinkObject.ObjectId)

                                                      WHERE MovementItemLinkObject.DescId = zc_MILinkObject_MoneyPlace()
                                                        AND MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMILO_Contract.MovementItemId FROM tmpMILO_Contract)
                                                     )
                             -- Cash
                             SELECT MILinkObject_Contract.ContractId    AS ContractId
                                  , CASE WHEN Object_Juridical.DescId = zc_Object_Juridical() THEN Object_Juridical.Id ELSE MILinkObject_MoneyPlace.ObjectId END AS JuridicalId
                                  , CASE WHEN Object_Juridical.DescId = zc_Object_Juridical() THEN MILinkObject_MoneyPlace.ObjectId ELSE 0 END AS PartnerId
                                  , zc_Enum_PaidKind_SecondForm()       AS PaidKindId
                                  , SUM (CASE WHEN MovementItem.Amount > 0
                                              THEN MovementItem.Amount
                                              ELSE MovementItem.Amount
                                         END)                  ::TFloat AS Amount_Cash
                             FROM tmpMovement AS Movement
                                 INNER JOIN tmpMI AS MovementItem
                                                  ON MovementItem.MovementId = Movement.Id

                                 INNER JOIN tmpMILO_Contract AS MILinkObject_Contract
                                                             ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                 INNER JOIN tmpMILO_MoneyPlace AS MILinkObject_MoneyPlace
                                                               ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                 LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                      ON ObjectLink_Partner_Juridical.ObjectId = MILinkObject_MoneyPlace.ObjectId
                                                     AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                                 LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Partner_Juridical.ChildObjectId

                             GROUP BY MILinkObject_Contract.ContractId
                                    , CASE WHEN Object_Juridical.DescId = zc_Object_Juridical() THEN Object_Juridical.Id ELSE MILinkObject_MoneyPlace.ObjectId END
                                    , CASE WHEN Object_Juridical.DescId = zc_Object_Juridical() THEN MILinkObject_MoneyPlace.ObjectId ELSE 0 END
                         )
    -- Взаимозачет
 , tmpMovement_SendDebt AS (WITH
                               tmpMovement AS (SELECT Movement.*
                                               FROM Movement
                                               WHERE Movement.DescId IN ( zc_Movement_SendDebt())
                                                 AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                                               --AND inPaidKindId = zc_Enum_PaidKind_FirstForm()
                                              )

                             , tmpMI AS (SELECT MovementItem.*
                                         FROM MovementItem
                                         WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                           AND MovementItem.isErased = FALSE
                                         )
                             , tmpMILO AS (SELECT * FROM MovementItemLinkObject WHERE MovementItemLinkObject.MovementItemId IN (SELECT tmpMI.Id FROM tmpMI))
                             , tmpMIFloat AS (SELECT * FROM MovementItemFloat WHERE MovementItemFloat.MovementItemId IN (SELECT tmpMI.Id FROM tmpMI))

                               -- Сумма кредит (уменьшение дебиторки, как оплата)
                             , tmpTotalSumm_Child AS (SELECT View_Contract_ContractKey.ContractId_key AS ContractId
                                                           , COALESCE (ObjectLink_Partner_JuridicalTo.ChildObjectId, Object_To.Id) AS JuridicalId
                                                           , CASE WHEN Object_To.DescId = zc_Object_Partner() THEN Object_To.Id ELSE 0 END AS PartnerId
                                                           , MILinkObject_PaidKind_To.ObjectId        AS PaidKindId
                                                           , SUM (1 * MI_Child.Amount)               AS Amount
                                                      FROM tmpMovement AS Movement
                                                          LEFT JOIN tmpMI AS MI_Child
                                                                          ON MI_Child.MovementId = Movement.Id
                                                                         AND MI_Child.DescId     = zc_MI_Child()

                                                          LEFT JOIN Object AS Object_To ON Object_To.Id = MI_Child.ObjectId

                                                          LEFT JOIN ObjectLink AS ObjectLink_Partner_JuridicalTo
                                                                               ON ObjectLink_Partner_JuridicalTo.ObjectId = MI_Child.ObjectId
                                                                              AND ObjectLink_Partner_JuridicalTo.DescId = zc_ObjectLink_Partner_Juridical()

                                                          INNER JOIN tmpMILO AS MILinkObject_Contract_To
                                                                             ON MILinkObject_Contract_To.MovementItemId = MI_Child.Id
                                                                            AND MILinkObject_Contract_To.DescId = zc_MILinkObject_Contract()
                                                          -- !!!Группируем Договора!!!
                                                          LEFT JOIN Object_Contract_ContractKey_View AS View_Contract_ContractKey ON View_Contract_ContractKey.ContractId = MILinkObject_Contract_To.ObjectId

                                                          INNER JOIN tmpMILO AS MILinkObject_PaidKind_To
                                                                             ON MILinkObject_PaidKind_To.MovementItemId = MI_Child.Id
                                                                            AND MILinkObject_PaidKind_To.DescId = zc_MILinkObject_PaidKind()
                                                                            AND (MILinkObject_PaidKind_To.ObjectId = inPaidKindId OR COALESCE (inPaidKindId,0) = 0)

                                                          INNER JOIN tmpMILO AS MILinkObject_InfoMoney_To
                                                                             ON MILinkObject_InfoMoney_To.MovementItemId = MI_Child.Id
                                                                            AND MILinkObject_InfoMoney_To.DescId = zc_MILinkObject_InfoMoney()
                                                          -- !!!Ограничили!!!
                                                          INNER JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyDestination
                                                                                ON ObjectLink_InfoMoney_InfoMoneyDestination.ObjectId      = MILinkObject_InfoMoney_To.ObjectId
                                                                               AND ObjectLink_InfoMoney_InfoMoneyDestination.DescId        = zc_ObjectLink_InfoMoney_InfoMoneyDestination()
                                                                               -- !!!Доходы + Продукция + Мясное сырье
                                                                               AND ObjectLink_InfoMoney_InfoMoneyDestination.ChildObjectId IN (zc_Enum_InfoMoneyDestination_30100()
                                                                                                                                             , zc_Enum_InfoMoneyDestination_30200()
                                                                                                                                              )
                                                          -- !!!Ограничили!!!
                                                          INNER JOIN _tmpJur ON _tmpJur.JuridicalId = COALESCE (ObjectLink_Partner_JuridicalTo.ChildObjectId, Object_To.Id)

                                                      WHERE -- !!!Группируем Договора!!!
                                                            (View_Contract_ContractKey.ContractId_key = vbContractId_key OR COALESCE (vbContractId_key, 0) = 0)

                                                      GROUP BY View_Contract_ContractKey.ContractId_key
                                                             , COALESCE (ObjectLink_Partner_JuridicalTo.ChildObjectId, Object_To.Id)
                                                             , CASE WHEN Object_To.DescId = zc_Object_Partner() THEN Object_To.Id ELSE 0 END
                                                             , MILinkObject_PaidKind_To.ObjectId
                                                      )

                               -- Сумма Дебет (увеличение дебиторки, как продажа)
                             , tmpTotalSumm_Master AS (SELECT View_Contract_ContractKey.ContractId_key AS ContractId
                                                            , COALESCE (ObjectLink_Partner_JuridicalFrom.ChildObjectId, Object_From.Id) AS JuridicalId
                                                            , CASE WHEN Object_From.DescId = zc_Object_Partner() THEN Object_From.Id ELSE 0 END AS PartnerId
                                                            , MILinkObject_PaidKind_From.ObjectId      AS PaidKindId
                                                            , SUM (-1 * MI_Master.Amount)     ::TFloat AS Amount
                                                       FROM tmpMovement AS Movement
                                                           LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                                                   ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                                                                  AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

                                                           LEFT JOIN tmpMI AS MI_Master
                                                                           ON MI_Master.MovementId = Movement.Id
                                                                          AND MI_Master.DescId     = zc_MI_Master()

                                                           LEFT JOIN Object AS Object_From ON Object_From.Id = MI_Master.ObjectId

                                                           LEFT JOIN ObjectLink AS ObjectLink_Partner_JuridicalFrom
                                                                                ON ObjectLink_Partner_JuridicalFrom.ObjectId = MI_Master.ObjectId
                                                                               AND ObjectLink_Partner_JuridicalFrom.DescId = zc_ObjectLink_Partner_Juridical()

                                                           INNER JOIN tmpMILO AS MILinkObject_Contract_From
                                                                              ON MILinkObject_Contract_From.MovementItemId = MI_Master.Id
                                                                             AND MILinkObject_Contract_From.DescId = zc_MILinkObject_Contract()
                                                           -- !!!Группируем Договора!!!
                                                           LEFT JOIN Object_Contract_ContractKey_View AS View_Contract_ContractKey ON View_Contract_ContractKey.ContractId = MILinkObject_Contract_From.ObjectId

                                                           INNER JOIN tmpMILO AS MILinkObject_PaidKind_From
                                                                              ON MILinkObject_PaidKind_From.MovementItemId = MI_Master.Id
                                                                             AND MILinkObject_PaidKind_From.DescId = zc_MILinkObject_PaidKind()
                                                                             AND (MILinkObject_PaidKind_From.ObjectId = inPaidKindId OR COALESCE (inPaidKindId,0) = 0)

                                                          INNER JOIN tmpMILO AS MILinkObject_InfoMoney_From
                                                                             ON MILinkObject_InfoMoney_From.MovementItemId = MI_Master.Id
                                                                            AND MILinkObject_InfoMoney_From.DescId = zc_MILinkObject_InfoMoney()
                                                          -- !!!Ограничили!!!
                                                          INNER JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyDestination
                                                                                ON ObjectLink_InfoMoney_InfoMoneyDestination.ObjectId      = MILinkObject_InfoMoney_From.ObjectId
                                                                               AND ObjectLink_InfoMoney_InfoMoneyDestination.DescId        = zc_ObjectLink_InfoMoney_InfoMoneyDestination()
                                                                               -- !!!Доходы + Продукция + Мясное сырье
                                                                               AND ObjectLink_InfoMoney_InfoMoneyDestination.ChildObjectId IN (zc_Enum_InfoMoneyDestination_30100()
                                                                                                                                             , zc_Enum_InfoMoneyDestination_30200()
                                                                                                                                              )

                                                          -- !!!Ограничили!!!
                                                          INNER JOIN _tmpJur ON _tmpJur.JuridicalId = COALESCE (ObjectLink_Partner_JuridicalFrom.ChildObjectId, Object_From.Id)

                                                       WHERE -- !!!Группируем Договора!!!
                                                             (View_Contract_ContractKey.ContractId_key = vbContractId_key OR COALESCE (vbContractId_key, 0) = 0)

                                                       GROUP BY View_Contract_ContractKey.ContractId_key
                                                              , COALESCE (ObjectLink_Partner_JuridicalFrom.ChildObjectId, Object_From.Id)
                                                              , CASE WHEN Object_From.DescId = zc_Object_Partner() THEN Object_From.Id ELSE 0 END
                                                              , MILinkObject_PaidKind_From.ObjectId
                                                      )
                             -- Взаимозачет
                             SELECT tmp.JuridicalId
                                  , tmp.PartnerId
                                  , tmp.ContractId
                                  , tmp.PaidKindId
                                  , SUM (tmp.Amount) AS Amount
                             FROM (SELECT tmp.JuridicalId
                                        , tmp.PartnerId
                                        , tmp.ContractId
                                        , tmp.PaidKindId
                                        , tmp.Amount
                                   FROM tmpTotalSumm_Master AS tmp
                                UNION
                                   SELECT tmp.JuridicalId
                                        , tmp.PartnerId
                                        , tmp.ContractId
                                        , tmp.PaidKindId
                                        , tmp.Amount
                                   FROM tmpTotalSumm_Child AS tmp
                                  ) AS tmp
                             GROUP BY tmp.JuridicalId
                                    , tmp.PartnerId
                                    , tmp.ContractId
                                    , tmp.PaidKindId
                           )

   -- BankAccount + SendDebt + Cash
 , tmpSumm_pay AS (SELECT tmp.JuridicalId
                        , tmp.PartnerId
                        , tmp.ContractId
                        , tmp.PaidKindId
                        , SUM (tmp.TotalAmount)     AS TotalAmount
                        , SUM (tmp.Amount_Bank)     AS Amount_Bank
                        , SUM (tmp.Amount_SendDebt) AS Amount_SendDebt
                   FROM (SELECT tmp.JuridicalId
                              , 0 AS PartnerId
                              , tmp.ContractId
                              , tmp.PaidKindId
                              , tmp.Amount_Bank AS TotalAmount
                              , tmp.Amount_Bank AS Amount_Bank
                              , 0               AS Amount_SendDebt
                         FROM tmpMovement_BankAccount AS tmp
                      UNION
                         SELECT tmp.JuridicalId
                              , tmp.PartnerId
                              , tmp.ContractId
                              , tmp.PaidKindId
                              , tmp.Amount_Cash AS TotalAmount
                              , tmp.Amount_Cash AS Amount_Bank
                              , 0               AS Amount_SendDebt
                         FROM tmpMovement_Cash AS tmp
                      UNION
                         SELECT tmp.JuridicalId
                              , tmp.PartnerId
                              , tmp.ContractId
                              , tmp.PaidKindId
                              , tmp.Amount AS TotalAmount
                              , 0          AS Amount_Bank
                              , tmp.Amount AS Amount_SendDebt
                         FROM tmpMovement_SendDebt AS tmp
                        ) AS tmp
                   GROUP BY tmp.JuridicalId
                          , tmp.PartnerId
                          , tmp.ContractId
                          , tmp.PaidKindId
                  )

                 -- Список по накладным
                , tmpList AS (SELECT _tmpDebt.JuridicalId, _tmpDebt.PartnerId, _tmpDebt.ContractId, _tmpDebt.PaidKindId
                                  , _tmpDebt.MovementId_sale
                                    -- сумма Итого BankAccount + SendDebt + Cash - для нее подбор в долгах
                                  , tmpSumm_pay.TotalAmount
                                    -- сумма в документе
                                  , _tmpDebt.Summ_debt - COALESCE (_tmpReturnIn_res.Summ_ReturnIn, 0) AS Summ_debt
                                    -- накопительная сумма
                                  , SUM (_tmpDebt.Summ_debt - COALESCE (_tmpReturnIn_res.Summ_ReturnIn, 0))
                                        OVER (PARTITION BY _tmpDebt.JuridicalId, _tmpDebt.PartnerId, _tmpDebt.ContractId, _tmpDebt.PaidKindId
                                              -- !!!сортировка от первой накладной к последней!!!
                                              ORDER BY CASE WHEN _tmpDebt.Summ_debt > 0 THEN 0 ELSE 1 END
                                                     , _tmpDebt.OperDate_sale ASC, _tmpDebt.MovementId_sale ASC
                                             )
                                        AS Summ_debt_SUM

                                    -- сумма в документе
                                  , _tmpDebt.Summ_sale - COALESCE (_tmpReturnIn_res.Summ_ReturnIn_next, 0) AS Summ_sale
                                    -- накопительная сумма
                                  , SUM (_tmpDebt.Summ_sale - COALESCE (_tmpReturnIn_res.Summ_ReturnIn_next, 0))
                                        OVER (PARTITION BY _tmpDebt.JuridicalId, _tmpDebt.PartnerId, _tmpDebt.ContractId, _tmpDebt.PaidKindId
                                              -- !!!сортировка от первой накладной к последней!!!
                                              ORDER BY CASE WHEN _tmpDebt.Summ_sale > 0 THEN 0 ELSE 1 END
                                                     , _tmpDebt.OperDate_sale ASC, _tmpDebt.MovementId_sale ASC
                                             )
                                        AS Summ_sale_SUM

                             FROM _tmpDebt
                                  LEFT JOIN _tmpReturnIn_res ON _tmpReturnIn_res.MovementId_sale = _tmpDebt.MovementId_sale
                                  -- Итого по BankAccount + SendDebt + Cash
                                  INNER JOIN tmpSumm_pay
                                          ON tmpSumm_pay.JuridicalId = _tmpDebt.JuridicalId
                                         AND tmpSumm_pay.PartnerId   = _tmpDebt.PartnerId
                                         AND tmpSumm_pay.ContractId  = _tmpDebt.ContractId
                                         AND tmpSumm_pay.PaidKindId  = _tmpDebt.PaidKindId

                             WHERE _tmpDebt.MovementId_sale > 0
                            )
               -- Результат по накладным
             , tmpRes_1 AS (SELECT DD.JuridicalId
                                 , DD.PartnerId
                                 , DD.ContractId
                                 , DD.PaidKindId
                                   --
                                 , DD.MovementId_sale
                                   --
                                 , CASE WHEN DD.TotalAmount - DD.Summ_debt_SUM > 0
                                             THEN DD.Summ_debt
                                        ELSE DD.TotalAmount - DD.Summ_debt_SUM + DD.Summ_debt
                                   END AS TotalAmount
                            FROM (SELECT * FROM tmpList
                                  -- если долги разбиты по накладным
                                  WHERE tmpList.Summ_debt_SUM > 0
                                 ) AS DD
                            WHERE DD.TotalAmount - (DD.Summ_debt_SUM - DD.Summ_debt) > 0
                           )
               , tmpRes AS (SELECT tmpRes_1.JuridicalId
                                 , tmpRes_1.PartnerId
                                 , tmpRes_1.ContractId
                                 , tmpRes_1.PaidKindId
                                   --
                                 , tmpRes_1.MovementId_sale
                                   --
                                 , tmpRes_1.TotalAmount
                                 , 0 AS TotalAmount_next
                            FROM tmpRes_1
                            WHERE tmpRes_1.TotalAmount > 0

                           UNION ALL
                            SELECT DD.JuridicalId
                                 , DD.PartnerId
                                 , DD.ContractId
                                 , DD.PaidKindId
                                   --
                                 , DD.MovementId_sale
                                   --
                                 , CASE WHEN DD.TotalAmount - DD.Summ_sale_SUM > 0
                                             THEN DD.Summ_sale
                                        ELSE DD.TotalAmount - DD.Summ_sale_SUM + DD.Summ_sale
                                   END AS TotalAmount
                                   -- тоже самое
                                 , CASE WHEN DD.TotalAmount - DD.Summ_sale_SUM > 0
                                             THEN DD.Summ_sale
                                        ELSE DD.TotalAmount - DD.Summ_sale_SUM + DD.Summ_sale
                                   END AS TotalAmount_next

                            FROM (SELECT tmpList.JuridicalId, tmpList.PartnerId, tmpList.ContractId, tmpList.PaidKindId
                                       , tmpList.MovementId_sale
                                         -- сумма Итого BankAccount + SendDebt + Cash - для нее подбор в долгах - МИНУС распределение
                                       , tmpList.TotalAmount - COALESCE (tmpRes_1.TotalAmount, 0) AS TotalAmount
                                         -- сумма в документе
                                       , tmpList.Summ_sale
                                         -- накопительная сумма
                                       , tmpList.Summ_sale_SUM
                                  FROM tmpList
                                       -- минус сколько распределили с долгов
                                       LEFT JOIN (SELECT tmpRes_1.JuridicalId
                                                       , tmpRes_1.PartnerId
                                                       , tmpRes_1.ContractId
                                                       , tmpRes_1.PaidKindId
                                                         --
                                                       , SUM (tmpRes_1.TotalAmount) AS TotalAmount
                                                  FROM tmpRes_1
                                                  GROUP BY tmpRes_1.JuridicalId
                                                         , tmpRes_1.PartnerId
                                                         , tmpRes_1.ContractId
                                                         , tmpRes_1.PaidKindId
                                                 ) AS tmpRes_1
                                                   ON tmpRes_1.JuridicalId = tmpList.JuridicalId
                                                  AND tmpRes_1.PartnerId   = tmpList.PartnerId
                                                  AND tmpRes_1.ContractId  = tmpList.ContractId
                                                  AND tmpRes_1.PaidKindId  = tmpList.PaidKindId

                                  -- если для продаж
                                  WHERE tmpList.Summ_sale_SUM > 0
                                   -- если долгов не хватило, надо брать текущие продажи
                                   AND tmpList.TotalAmount - COALESCE (tmpRes_1.TotalAmount, 0) > 0
                                 ) AS DD
                            WHERE DD.TotalAmount - (DD.Summ_sale_SUM - DD.Summ_sale) > 0
                           )
       -- Результат
       INSERT INTO _tmpPay (JuridicalId, PartnerId, ContractId, PaidKindId, MovementId_sale, TotalAmount, TotalAmount_next, Amount_Bank, Amount_SendDebt)
            -- распределение оплат по накладным
            SELECT tmpRes.JuridicalId
                 , tmpRes.PartnerId
                 , tmpRes.ContractId
                 , tmpRes.PaidKindId

                 , tmpRes.MovementId_sale
                 , SUM (tmpRes.TotalAmount)      AS TotalAmount
                 , SUM (tmpRes.TotalAmount_next) AS TotalAmount_next
                 , 0 AS Amount_Bank
                 , 0 AS Amount_SendDebt
            FROM tmpRes
            GROUP BY tmpRes.JuridicalId
                   , tmpRes.PartnerId
                   , tmpRes.ContractId
                   , tmpRes.PaidKindId
                   , tmpRes.MovementId_sale

           UNION ALL
            -- оплаты - НЕ нашли накладные + сохранили раздельно
            SELECT tmpSumm_pay.JuridicalId
                 , tmpSumm_pay.PartnerId
                 , tmpSumm_pay.ContractId
                 , tmpSumm_pay.PaidKindId

                 , 0 AS MovementId_sale
                   -- разница
                 , tmpSumm_pay.TotalAmount - COALESCE (tmpRes.TotalAmount, 0) AS TotalAmount
                 , 0 AS TotalAmount_next
                 , tmpSumm_pay.Amount_Bank
                 , tmpSumm_pay.Amount_SendDebt

            FROM -- Итого BankAccount + SendDebt + Cash
                 tmpSumm_pay
                 -- Итого по накладным - нашли
                 LEFT JOIN (SELECT tmpRes.JuridicalId
                                 , tmpRes.PartnerId
                                 , tmpRes.ContractId
                                 , tmpRes.PaidKindId
                                 , SUM (tmpRes.TotalAmount) AS TotalAmount
                            FROM tmpRes
                            GROUP BY tmpRes.JuridicalId
                                   , tmpRes.PartnerId
                                   , tmpRes.ContractId
                                   , tmpRes.PaidKindId
                           ) AS tmpRes
                             ON tmpRes.JuridicalId = tmpSumm_pay.JuridicalId
                            AND tmpRes.PartnerId   = tmpSumm_pay.PartnerId
                            AND tmpRes.ContractId  = tmpSumm_pay.ContractId
                            AND tmpRes.PaidKindId  = tmpSumm_pay.PaidKindId
           ;

     -- добавили если не нашли - оплаты
     INSERT INTO _tmpSale (MovementId, StatusId, InvNumber, OperDate, PaidKindId, ContractId, PartnerId, JuridicalId, SummSale, Ord, Ord_all_asc)
        SELECT DISTINCT
               0 AS MovementId
             , 0 AS StatusId
             , 0 AS InvNumber
             , inEndDate + INTERVAL '1 DAY' AS OperDate
             , _tmpPay.PaidKindId
             , _tmpPay.ContractId
             , _tmpPay.PartnerId
             , _tmpPay.JuridicalId
             , 0 AS SummSale
             , 1 AS Ord
             , 0 AS Ord_all_asc
        FROM _tmpPay
             LEFT JOIN _tmpSale ON _tmpSale.Ord         = 1
                               AND _tmpSale.JuridicalId = _tmpPay.JuridicalId
                               AND _tmpSale.PartnerId   = _tmpPay.PartnerId
                               AND _tmpSale.ContractId  = _tmpPay.ContractId
                               AND _tmpSale.PaidKindId  = _tmpPay.PaidKindId
        WHERE _tmpSale.Ord IS NULL -- _tmpSale.MovementId IS NULL
       ;

    -- Результат
    RETURN QUERY
    WITH
         -- Продажи за период
         tmpMovement_Sale AS (SELECT _tmpSale.MovementId, _tmpSale.StatusId, _tmpSale.InvNumber, _tmpSale.OperDate
                                   , _tmpSale.PaidKindId
                                   , _tmpSale.ContractId
                                   , _tmpSale.PartnerId
                                   , _tmpSale.JuridicalId

                                     -- Итого по накладной
                                   , _tmpSale.SummSale

                                     -- сколько осталось
                                   , CASE WHEN _tmpSale.MovementId > 0
                                               THEN COALESCE (_tmpDebt.Summ_debt, 0) - COALESCE (_tmpReturnIn_res.Summ_ReturnIn, 0) - COALESCE (_tmpReturnIn_res.Summ_ReturnIn, 0)
                                          ELSE 0
                                     END AS TotalSumm

                                     -- долги по накладным
                                   , COALESCE (_tmpDebt.Summ_debt, 0)            AS Summ_debt

                                     -- возвраты по накладным
                                   , COALESCE (_tmpReturnIn_res.Summ_ReturnIn, 0) AS Summ_ReturnIn

                                     -- Pay по накладным
                                   , COALESCE (_tmpPay.TotalAmount, 0) AS TotalAmount

                                   , _tmpSale.Ord
                                   , _tmpSale.Ord_all_asc

                              FROM _tmpSale
                                   -- долги по накладным
                                   LEFT JOIN _tmpDebt         ON _tmpDebt.MovementId_sale  = _tmpSale.MovementId
                                                             AND _tmpDebt.JuridicalId      = _tmpSale.JuridicalId
                                                             AND _tmpDebt.PartnerId        = _tmpSale.PartnerId
                                                             AND _tmpDebt.ContractId       = _tmpSale.ContractId
                                                             AND _tmpDebt.PaidKindId       = _tmpSale.PaidKindId
                                                             -- без этих долгов
                                                             AND _tmpDebt.Summ_debt_end    = 0
                                                             --
                                                             -- AND _tmpDebt.MovementId_sale  > 0
                                   -- возвраты по накладным
                                   LEFT JOIN _tmpReturnIn_res ON _tmpReturnIn_res.MovementId_sale = _tmpSale.MovementId
                                                             AND _tmpReturnIn_res.JuridicalId     = _tmpSale.JuridicalId
                                                             AND _tmpReturnIn_res.PartnerId       = _tmpSale.PartnerId
                                                             AND _tmpReturnIn_res.ContractId      = _tmpSale.ContractId
                                                             AND _tmpReturnIn_res.PaidKindId      = _tmpSale.PaidKindId
                                  --                           AND _tmpReturnIn_res.MovementId_sale > 0
                                   -- Pay по накладным
                                   LEFT JOIN _tmpPay ON _tmpPay.MovementId_sale = _tmpSale.MovementId
                                                    AND _tmpPay.JuridicalId     = _tmpSale.JuridicalId
                                                    AND _tmpPay.PartnerId       = _tmpSale.PartnerId
                                                    AND _tmpPay.ContractId      = _tmpSale.ContractId
                                                    AND _tmpPay.PaidKindId      = _tmpSale.PaidKindId
                                --                    AND _tmpPay.MovementId_sale > 0
                              --WHERE _tmpSale.MovementId > 0
                             )
  , tmpData AS (SELECT tmpMovement_Sale.MovementId
                     , tmpMovement_Sale.StatusId
                     , tmpMovement_Sale.OperDate
                     , tmpMovement_Sale.InvNumber
                     , tmpMovement_Sale.PaidKindId
                     , tmpMovement_Sale.ContractId
                     , tmpMovement_Sale.PartnerId
                     , tmpMovement_Sale.JuridicalId

                      -- Сумма по накладным
                     , tmpMovement_Sale.SummSale
                      -- Остаток по накладным - для распределения оплат
                     , tmpMovement_Sale.TotalSumm

                     , tmpMovement_Sale.Summ_debt
                     , tmpMovement_Sale.Summ_ReturnIn

                       -- какие накладные-долги оплачены
                     , tmpMovement_Sale.TotalAmount AS Summ_Pay

                     , tmpMovement_Sale.Ord
                     , tmpMovement_Sale.Ord_all_asc

                       -- итого Сумма - в одну строчку
                     , COALESCE (tmpSumm_pay.TotalAmount, 0)     AS TotalAmount_Pay
                       -- итого Сумма оплаты - в одну строчку
                     , COALESCE (tmpSumm_pay.Amount_Bank, 0)     AS TotalAmount_Bank
                       -- итого Сумма Взаимозачет - в одну строчку
                     , COALESCE (tmpSumm_pay.Amount_SendDebt, 0) AS TotalAmount_SendDebt

                       -- итого долги - в одну строчку
                     , COALESCE (tmpDebt.Summ_debt, 0)           AS TotalSumm_debt
                     , COALESCE (tmpDebt.Summ_debt_end, 0)       AS TotalSumm_debt_end
                     
                       -- итого ReturnIn - в одну строчку
                     , COALESCE (tmpReturnIn.Summ_ReturnIn, 0)   AS TotalSumm_ReturnIn

                FROM tmpMovement_Sale
                     -- Итого Сумма оплаты
                     LEFT JOIN (SELECT _tmpPay.JuridicalId
                                     , _tmpPay.PartnerId
                                     , _tmpPay.ContractId
                                     , _tmpPay.PaidKindId
                                     , SUM (_tmpPay.TotalAmount) AS TotalAmount
                                     , SUM (_tmpPay.Amount_Bank) AS Amount_Bank
                                     , SUM (_tmpPay.Amount_SendDebt) AS Amount_SendDebt
                                FROM _tmpPay
                                GROUP BY _tmpPay.JuridicalId
                                       , _tmpPay.PartnerId
                                       , _tmpPay.ContractId
                                       , _tmpPay.PaidKindId
                               ) AS tmpSumm_pay
                                           ON tmpSumm_pay.JuridicalId = tmpMovement_Sale.JuridicalId
                                          AND tmpSumm_pay.PartnerId   = tmpMovement_Sale.PartnerId
                                          AND tmpSumm_pay.ContractId  = tmpMovement_Sale.ContractId
                                          AND tmpSumm_pay.PaidKindId  = tmpMovement_Sale.PaidKindId
                                          -- в одну строчку
                                          AND tmpMovement_Sale.Ord = 1
                     -- Итого долги
                     LEFT JOIN (SELECT _tmpDebt.JuridicalId
                                     , _tmpDebt.PartnerId
                                     , _tmpDebt.ContractId
                                     , _tmpDebt.PaidKindId
                                     , SUM (_tmpDebt.Summ_debt)     AS Summ_debt
                                     , SUM (_tmpDebt.Summ_debt_end) AS Summ_debt_end
                                FROM _tmpDebt
                                GROUP BY _tmpDebt.JuridicalId
                                       , _tmpDebt.PartnerId
                                       , _tmpDebt.ContractId
                                       , _tmpDebt.PaidKindId
                               ) AS tmpDebt
                                 ON tmpDebt.JuridicalId = tmpMovement_Sale.JuridicalId
                                AND tmpDebt.PartnerId   = tmpMovement_Sale.PartnerId
                                AND tmpDebt.ContractId  = tmpMovement_Sale.ContractId
                                AND tmpDebt.PaidKindId  = tmpMovement_Sale.PaidKindId
                                -- в одну строчку
                                AND tmpMovement_Sale.Ord = 1
                     -- Итого ReturnIn
                     LEFT JOIN (SELECT _tmpReturnIn.JuridicalId
                                     , _tmpReturnIn.PartnerId
                                     , _tmpReturnIn.ContractId
                                     , _tmpReturnIn.PaidKindId
                                     , SUM (_tmpReturnIn.Summ_ReturnIn) AS Summ_ReturnIn
                                FROM _tmpReturnIn
                                GROUP BY _tmpReturnIn.JuridicalId
                                       , _tmpReturnIn.PartnerId
                                       , _tmpReturnIn.ContractId
                                       , _tmpReturnIn.PaidKindId
                               ) AS tmpReturnIn
                                 ON tmpReturnIn.JuridicalId = tmpMovement_Sale.JuridicalId
                                AND tmpReturnIn.PartnerId   = tmpMovement_Sale.PartnerId
                                AND tmpReturnIn.ContractId  = tmpMovement_Sale.ContractId
                                AND tmpReturnIn.PaidKindId  = tmpMovement_Sale.PaidKindId
                                -- в одну строчку
                                AND tmpMovement_Sale.Ord = 1

               )

         --для проверки заполнения
       , tmpMovementDate AS (SELECT MovementDate.*
                             FROM MovementDate
                             WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpData.MovementId FROM tmpData)
                               AND MovementDate.DescId IN (zc_MovementDate_Pay_1()
                                                         , zc_MovementDate_Pay_2()
                                                         , zc_MovementDate_Return_1()
                                                         , zc_MovementDate_Return_2()
                                                          )
                             )
       , tmpMovementFloat AS (SELECT MovementFloat.*
                              FROM MovementFloat
                              WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpData.MovementId FROM tmpData)
                                AND MovementFloat.DescId IN (zc_MovementFloat_Pay_1()
                                                           , zc_MovementFloat_Pay_2()
                                                           , zc_MovementFloat_Return_1()
                                                           , zc_MovementFloat_Return_2() 
                                                            )
                              )

     SELECT
         tmpData.MovementId
       , tmpData.OperDate
       , zfConvert_StringToNumber(tmpData.InvNumber) AS InvNumber
       , Object_Status.ObjectCode                    AS StatusCode
       , Object_Contract.Id                          AS ContractId
       , Object_Contract.ObjectCode                  AS ContractCode
       , Object_Contract.ValueData                   AS ContractName
       , Object_ContractTag.ValueData                AS ContractTagName
       , Object_Juridical.Id                         AS JuridicalId
       , Object_Juridical.ObjectCode                 AS JuridicalCode
       , Object_Juridical.ValueData                  AS JuridicalName
       , Object_Partner.Id                           AS PartnerId
       , Object_Partner.ObjectCode                   AS PartnerCode
       , Object_Partner.ValueData                    AS PartnerName
       , Object_PaidKind.ValueData                   AS PaidKindName

         -- накопительная - продажа
       , 0 ::TFloat AS TotalSumm_calc

         -- Сумма по накладным с НДС
       , tmpData.SummSale       ::TFloat AS TotalSumm
         -- Остаток по накладным - для распределения оплат
       , (tmpData.TotalSumm)  ::TFloat AS TotalSumm_rem

         -- Итого оплата + взаимозачет
       , tmpData.TotalAmount_Pay :: TFloat

         -- Итого оплата
       , tmpData.TotalAmount_Bank     :: TFloat
         -- Итого взаимозачет
       , tmpData.TotalAmount_SendDebt :: TFloat

         -- Распределено - оплата
       , tmpData.Summ_Pay    :: TFloat
         -- Распределено - долги
       , (tmpData.Summ_debt /*- tmpData.Summ_Pay*/)   :: TFloat
         -- Распределено - возвраты
       , tmpData.Summ_ReturnIn:: TFloat

         -- Распределено - долги
       , (tmpData.Summ_Pay /*+ tmpData.Summ_debt*/ + tmpData.Summ_ReturnIn) :: TFloat AS Summ_calc

         -- итого долги
       , tmpData.TotalSumm_debt     :: TFloat
       , tmpData.TotalSumm_debt_end :: TFloat
       
         -- итого ReturnIn
       , tmpData.TotalSumm_ReturnIn:: TFloat

       , tmpData.Ord          :: Integer
       , tmpData.Ord_all_asc  :: Integer
       --
       , MovementFloat_Pay_1.ValueData      ::TFloat    AS SumPay1
       , MovementFloat_Pay_2.ValueData      ::TFloat    AS SumPay2
       , MovementFloat_Return_1.ValueData   ::TFloat    AS SumReturn_1
       , MovementFloat_Return_2.ValueData   ::TFloat    AS SumReturn_2    
       , MovementDate_Pay_1.ValueData       ::TDateTime AS DatePay_1
       , MovementDate_Pay_2.ValueData       ::TDateTime AS DatePay_2
       , MovementDate_Return_1.ValueData    ::TDateTime AS DateReturn_1
       , MovementDate_Return_2.ValueData    ::TDateTime AS DateReturn_2
     FROM tmpData
         LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpData.JuridicalId
         LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = tmpData.ContractId
         LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpData.PartnerId
         LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpData.PaidKindId
         LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpData.StatusId
         LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractTag
                              ON ObjectLink_Contract_ContractTag.ObjectId = Object_Contract.Id
                             AND ObjectLink_Contract_ContractTag.DescId   = zc_ObjectLink_Contract_ContractTag()
         LEFT JOIN Object AS Object_ContractTag ON Object_ContractTag.Id = ObjectLink_Contract_ContractTag.ChildObjectId

         --
         LEFT JOIN tmpMovementDate AS MovementDate_Pay_1
                                   ON MovementDate_Pay_1.MovementId = tmpData.MovementId
                                  AND MovementDate_Pay_1.DescId = zc_MovementDate_Pay_1()
         LEFT JOIN tmpMovementDate AS MovementDate_Pay_2
                                   ON MovementDate_Pay_2.MovementId = tmpData.MovementId
                                  AND MovementDate_Pay_2.DescId = zc_MovementDate_Pay_2()
         LEFT JOIN tmpMovementDate AS MovementDate_Return_1
                                   ON MovementDate_Return_1.MovementId = tmpData.MovementId
                                  AND MovementDate_Return_1.DescId = zc_MovementDate_Return_1()
         LEFT JOIN tmpMovementDate AS MovementDate_Return_2
                                   ON MovementDate_Return_2.MovementId = tmpData.MovementId
                                  AND MovementDate_Return_2.DescId = zc_MovementDate_Return_2()

         LEFT JOIN tmpMovementFloat AS MovementFloat_Pay_1
                                    ON MovementFloat_Pay_1.MovementId = tmpData.MovementId
                                   AND MovementFloat_Pay_1.DescId = zc_MovementFloat_Pay_1()
         LEFT JOIN tmpMovementFloat AS MovementFloat_Pay_2
                                    ON MovementFloat_Pay_2.MovementId = tmpData.MovementId
                                   AND MovementFloat_Pay_2.DescId = zc_MovementFloat_Pay_2()
         LEFT JOIN tmpMovementFloat AS MovementFloat_Return_1
                                    ON MovementFloat_Return_1.MovementId = tmpData.MovementId
                                   AND MovementFloat_Return_1.DescId = zc_MovementFloat_Return_1()
         LEFT JOIN tmpMovementFloat AS MovementFloat_Return_2
                                    ON MovementFloat_Return_2.MovementId = tmpData.MovementId
                                   AND MovementFloat_Return_2.DescId = zc_MovementFloat_Return_2()
     ORDER BY Object_Juridical.ValueData
            , Object_Contract.ValueData
            , Object_PaidKind.ValueData
            , tmpData.Ord
    ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.10.23         *
*/

-- тест
-- SELECT * FROM gpReport_Sale_BankAccount (inStartDate:= '01.10.2024', inEndDate:= '10.10.2024', inPaidKindId:= 3, inJuridicalId:= 15088 , inContractId:= 0, inSession:= '5');
