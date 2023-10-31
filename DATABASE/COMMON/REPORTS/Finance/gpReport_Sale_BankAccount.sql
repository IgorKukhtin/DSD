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
             , TotalSumm_debt    TFloat
               -- итого ReturnIn
             , TotalSumm_ReturnIn TFloat
             
             , Ord          Integer
             , Ord_ReturnIn Integer
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


     -- !!!Группируем Договора!!!
     vbContractId_key:= (SELECT View_Contract_ContractKey.ContractId_Key FROM Object_Contract_ContractKey_View AS View_Contract_ContractKey WHERE View_Contract_ContractKey.ContractId = inContractId);


     -- 1.0. ФО
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


     -- 1.0. ФО
     CREATE TEMP TABLE _tmpPaidKind ON COMMIT DROP
       AS (SELECT inPaidKindId AS Id WHERE inPaidKindId > 0
        --UNION
        -- SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_PaidKind() AND COALESCE (inPaidKindId, 0) = 0
          );


     -- 1.1. Продажи
     CREATE TEMP TABLE _tmpSale ON COMMIT DROP
       AS (SELECT Movement.Id AS MovementId
                , Movement.StatusId
                , Movement.InvNumber
                , Movement.OperDate AS OperDate_unit
                , MovementDate_OperDatePartner.ValueData AS OperDate
                , EXTRACT (YEAR FROM MovementDate_OperDatePartner.ValueData)  AS OperDate_y
                , EXTRACT (MONTH FROM MovementDate_OperDatePartner.ValueData) AS OperDate_m
                , MovementLinkObject_PaidKind.ObjectId       AS PaidKindId
                  -- замена - Группируем Договора
                , View_Contract_ContractKey.ContractId_key   AS ContractId
                  --
                , MovementLinkObject_To.ObjectId             AS PartnerId
                , ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                , MovementFloat_TotalSumm.ValueData          AS SummSale
                  -- сортировка от последней накладной к первой
                , ROW_NUMBER() OVER (PARTITION BY ObjectLink_Partner_Juridical.ChildObjectId
                                                , View_Contract_ContractKey.ContractId_key
                                                , MovementLinkObject_PaidKind.ObjectId
                                     ORDER BY MovementDate_OperDatePartner.ValueData DESC, Movement.Id DESC
                                    ) AS Ord
                  -- сортировка от первой к последней накладной
                , ROW_NUMBER() OVER (PARTITION BY ObjectLink_Partner_Juridical.ChildObjectId
                                                , View_Contract_ContractKey.ContractId_key
                                                , MovementLinkObject_PaidKind.ObjectId
                                                , DATE_TRUNC ('MONTH',  MovementDate_OperDatePartner.ValueData)
                                     ORDER BY MovementDate_OperDatePartner.ValueData ASC, Movement.Id ASC
                                    ) AS Ord_ReturnIn
           FROM Movement
                INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                        ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                       AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                       AND MovementDate_OperDatePartner.ValueData BETWEEN CASE WHEN vbUserId = 5 THEN inStartDate - INTERVAL '12 MONTH' ELSE inStartDate - INTERVAL '12 MONTH' END AND inEndDate
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
                                     -- !!!Доходы + Продукция
                                     AND ObjectLink_InfoMoney_InfoMoneyDestination.ChildObjectId = zc_Enum_InfoMoneyDestination_30100()

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
          );


     -- 1.2. ReturnIn
     CREATE TEMP TABLE _tmpReturnIn ON COMMIT DROP
       AS (SELECT DATE_TRUNC ('MONTH', MovementDate_OperDatePartner.ValueData) AS OperDate_m
                , MovementLinkObject_PaidKind.ObjectId       AS PaidKindId
                  -- замена - Группируем Договора
                , View_Contract_ContractKey.ContractId_key   AS ContractId
                  --
                , MovementLinkObject_From.ObjectId           AS PartnerId
                , ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                , SUM (MovementFloat_TotalSumm.ValueData)    AS Summ_ReturnIn
           FROM Movement
                INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                        ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                       AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
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
                                     -- !!!Доходы + Продукция
                                     AND ObjectLink_InfoMoney_InfoMoneyDestination.ChildObjectId = zc_Enum_InfoMoneyDestination_30100()

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

           GROUP BY DATE_TRUNC ('MONTH', MovementDate_OperDatePartner.ValueData)
                  , MovementLinkObject_PaidKind.ObjectId
                  , View_Contract_ContractKey.ContractId_key
                  , MovementLinkObject_From.ObjectId
                  , ObjectLink_Partner_Juridical.ChildObjectId
          );



     -- Долги
     CREATE TEMP TABLE _tmpDebt (JuridicalId Integer, ContractId Integer, PaidKindId Integer, MovementId_sale Integer, Summ_debt TFloat) ON COMMIT DROP;
     --
     INSERT INTO _tmpDebt (JuridicalId, ContractId, PaidKindId, MovementId_sale, Summ_debt)
        WITH -- Дебиторы
             tmpAccount AS (SELECT Object_Account_View.AccountId FROM Object_Account_View WHERE AccountGroupId = zc_Enum_AccountGroup_30000())
             -- ВСЕ долги на конец inEndDate
           , tmpContainer AS (SELECT CLO_Juridical.ContainerId                AS ContainerId
                                   , CLO_Juridical.ObjectId                   AS JuridicalId
                                   , View_Contract_ContractKey.ContractId_key AS ContractId
                                   , CLO_PaidKind.ObjectId                    AS PaidKindId
                                   , Container.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) AS Summ_debt

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
                                                        -- !!!Доходы + Продукция
                                                        AND ObjectLink_InfoMoney_InfoMoneyDestination.ChildObjectId = zc_Enum_InfoMoneyDestination_30100()

                                   INNER JOIN ContainerLinkObject AS CLO_PaidKind
                                                                  ON CLO_PaidKind.ContainerId = Container.Id
                                                                 AND CLO_PaidKind.DescId      = zc_ContainerLinkObject_PaidKind()
                                   INNER JOIN _tmpPaidKind ON _tmpPaidKind.Id = CLO_PaidKind.ObjectId

                                   LEFT JOIN MovementItemContainer AS MIContainer
                                                                   ON MIContainer.Containerid = Container.Id
                                                                  AND MIContainer.OperDate    > inEndDate

                              WHERE CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                 -- !!!Группируем Договора!!!
                                AND (View_Contract_ContractKey.ContractId_key = vbContractId_key OR COALESCE (vbContractId_key, 0) = 0)

                              GROUP BY CLO_Juridical.ContainerId
                                     , CLO_Juridical.ObjectId
                                     , View_Contract_ContractKey.ContractId_key
                                     , CLO_PaidKind.ObjectId
                                     , Container.Amount
                              HAVING Container.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) <> 0
                             )
                 -- Список по накладным
               , tmpList AS (SELECT _tmpSale.MovementId
                                  , _tmpSale.JuridicalId
                                  , _tmpSale.ContractId
                                  , _tmpSale.PaidKindId
                                    -- сумма Долг - для нее подбор в продажах
                                  , tmpContainer.Summ_debt
                                    -- сумма в документе продажа
                                  , _tmpSale.SummSale
                                    -- накопительная сумма продаж
                                  , SUM (_tmpSale.SummSale)
                                        OVER (PARTITION BY _tmpSale.JuridicalId, _tmpSale.ContractId, _tmpSale.PaidKindId
                                              -- сортировка от последней накладной к первой
                                              ORDER BY _tmpSale.Ord
                                             )
                                        AS SummSale_SUM
                             FROM _tmpSale
                                  -- Итог долги
                                  INNER JOIN (SELECT tmpContainer.JuridicalId
                                                   , tmpContainer.ContractId
                                                   , tmpContainer.PaidKindId
                                                   , SUM (tmpContainer.Summ_debt) AS Summ_debt
                                              FROM tmpContainer
                                              GROUP BY tmpContainer.JuridicalId
                                                     , tmpContainer.ContractId
                                                     , tmpContainer.PaidKindId
                                             ) AS tmpContainer
                                               ON tmpContainer.JuridicalId = _tmpSale.JuridicalId
                                              AND tmpContainer.ContractId  = _tmpSale.ContractId
                                              AND tmpContainer.PaidKindId  = _tmpSale.PaidKindId

                            )

               , tmpRes AS (SELECT DD.JuridicalId
                                 , DD.ContractId
                                 , DD.PaidKindId

                                 , DD.MovementId AS MovementId_sale
                                 , CASE WHEN DD.Summ_debt - DD.SummSale_SUM > 0
                                             THEN DD.SummSale
                                        ELSE DD.Summ_debt - DD.SummSale_SUM + DD.SummSale
                                   END AS Summ_debt
                            FROM (SELECT * FROM tmpList) AS DD
                            WHERE DD.Summ_debt - (DD.SummSale_SUM - DD.SummSale) > 0
                           )

            -- долги - нашли накладные
            SELECT tmpRes.JuridicalId
                 , tmpRes.ContractId
                 , tmpRes.PaidKindId

                 , tmpRes.MovementId_sale
                 , tmpRes.Summ_debt
            FROM tmpRes

           UNION
            -- долги - НЕ нашли накладные
            SELECT tmpContainer.JuridicalId
                 , tmpContainer.ContractId
                 , tmpContainer.PaidKindId

                 , 0 AS MovementId_sale
                   -- разница
                 , tmpContainer.Summ_debt - COALESCE (tmpRes.Summ_debt, 0) AS Summ_debt

            FROM -- Итого долги
                 (SELECT tmpContainer.JuridicalId
                       , tmpContainer.ContractId
                       , tmpContainer.PaidKindId
                       , SUM (tmpContainer.Summ_debt) AS Summ_debt
                  FROM tmpContainer
                  GROUP BY tmpContainer.JuridicalId
                         , tmpContainer.ContractId
                         , tmpContainer.PaidKindId
                 ) AS tmpContainer

                 -- Итого по накладным - нашли
                 LEFT JOIN (SELECT tmpRes.JuridicalId
                                 , tmpRes.ContractId
                                 , tmpRes.PaidKindId
                                 , SUM (tmpRes.Summ_debt) AS Summ_debt
                            FROM tmpRes
                            GROUP BY tmpRes.JuridicalId
                                   , tmpRes.ContractId
                                   , tmpRes.PaidKindId
                           ) AS tmpRes
                             ON tmpRes.JuridicalId = tmpContainer.JuridicalId
                            AND tmpRes.ContractId  = tmpContainer.ContractId
                            AND tmpRes.PaidKindId  = tmpContainer.PaidKindId
            WHERE tmpContainer.Summ_debt <> COALESCE (tmpRes.Summ_debt, 0)
           ;

     -- добавили если не нашли - Долги
     INSERT INTO _tmpSale (MovementId, StatusId, InvNumber, OperDate, PaidKindId,  ContractId, PartnerId, JuridicalId, SummSale, Ord, Ord_ReturnIn)
        SELECT 0 AS MovementId
             , 0 AS StatusId
             , 0 AS InvNumber
             , inEndDate AS OperDate
             , _tmpDebt.PaidKindId
             , _tmpDebt.ContractId
             , 0 AS PartnerId
             , _tmpDebt.JuridicalId
             , 0 AS SummSale
             , 1 AS Ord
             , 1 AS Ord_ReturnIn
        FROM _tmpDebt
             LEFT JOIN _tmpSale ON _tmpSale.Ord         = 1
                               AND _tmpSale.JuridicalId = _tmpDebt.JuridicalId
                               AND _tmpSale.ContractId  = _tmpDebt.ContractId
                               AND _tmpSale.PaidKindId  = _tmpDebt.PaidKindId
        WHERE _tmpSale.JuridicalId IS NULL
       ;


     -- возвраты привязаны к продажам
     CREATE TEMP TABLE _tmpReturnIn_res (JuridicalId Integer, ContractId Integer, PaidKindId Integer, MovementId_sale Integer, OperDate_m TDateTime, Summ_ReturnIn TFloat) ON COMMIT DROP;


     -- курсор1 - период
     OPEN curMonth FOR SELECT DISTINCT _tmpReturnIn.OperDate_m FROM _tmpReturnIn ORDER BY 1 DESC;
     -- начало цикла по курсору1 - период
     LOOP
         -- данные по период
         FETCH curMonth INTO vbOperDate_m;
         -- если данные закончились, тогда выход
         IF NOT FOUND THEN EXIT; END IF;

         --
         INSERT INTO _tmpReturnIn_res (JuridicalId, ContractId, PaidKindId, MovementId_sale, OperDate_m, Summ_ReturnIn)
            WITH tmpList AS (SELECT _tmpSale.JuridicalId, _tmpSale.ContractId, _tmpSale.PaidKindId
                                  , _tmpSale.MovementId
                                    -- сумма Возврат - для нее подбор в продажах
                                  , tmpReturnIn.Summ_ReturnIn
                                    -- сумма в документе продажа
                                  , CASE WHEN _tmpSale.SummSale > 0
                                              THEN _tmpSale.SummSale - COALESCE (_tmpReturnIn_res.Summ_ReturnIn, 0) - COALESCE (_tmpDebt.Summ_debt, 0)
                                         ELSE 0
                                    END AS SummSale
                                    -- накопительная сумма продаж
                                  , SUM (CASE WHEN _tmpSale.SummSale > 0
                                              THEN _tmpSale.SummSale - COALESCE (_tmpReturnIn_res.Summ_ReturnIn, 0) - COALESCE (_tmpDebt.Summ_debt, 0)
                                              ELSE 0
                                         END)
                                        OVER (PARTITION BY _tmpSale.JuridicalId, _tmpSale.ContractId, _tmpSale.PaidKindId
                                              -- !!!сортировка от первой накладной к последней!!!
                                              ORDER BY DATE_TRUNC ('MONTH',  _tmpSale.OperDate) DESC, _tmpSale.Ord_ReturnIn ASC
                                             )
                                        AS SummSale_SUM
                             FROM _tmpSale
                                  -- вычитаем долги
                                  LEFT JOIN _tmpDebt ON _tmpDebt.MovementId_sale = _tmpSale.MovementId
                                  -- вычитаем возврат, распределенный ранее
                                  LEFT JOIN _tmpReturnIn_res ON _tmpReturnIn_res.MovementId_sale = _tmpSale.MovementId
                                  -- Итог по возвратам за месяц
                                  INNER JOIN (SELECT _tmpReturnIn.JuridicalId
                                                   , _tmpReturnIn.ContractId
                                                   , _tmpReturnIn.PaidKindId
                                                   , SUM (_tmpReturnIn.Summ_ReturnIn) AS Summ_ReturnIn
                                              FROM _tmpReturnIn
                                              -- !!!за один месяц!!!
                                              WHERE _tmpReturnIn.OperDate_m = vbOperDate_m
                                              GROUP BY _tmpReturnIn.JuridicalId
                                                     , _tmpReturnIn.ContractId
                                                     , _tmpReturnIn.PaidKindId
                                             ) AS tmpReturnIn
                                               ON tmpReturnIn.JuridicalId = _tmpSale.JuridicalId
                                              AND tmpReturnIn.ContractId  = _tmpSale.ContractId
                                              AND tmpReturnIn.PaidKindId  = _tmpSale.PaidKindId

                             -- все месяца до текущего
                             WHERE DATE_TRUNC ('MONTH', _tmpSale.OperDate) <= vbOperDate_m
                               -- если есть еще сумма
                               AND CASE WHEN _tmpSale.SummSale > 0
                                             THEN _tmpSale.SummSale - COALESCE (_tmpReturnIn_res.Summ_ReturnIn, 0) - COALESCE (_tmpDebt.Summ_debt, 0)
                                        ELSE 0
                                   END > 0
                            )

            --
            SELECT DD.JuridicalId, DD.ContractId, DD.PaidKindId
                 , DD.MovementId AS MovementId_sale
                 , vbOperDate_m AS OperDate_m
                 , CASE WHEN DD.Summ_ReturnIn - DD.SummSale_SUM > 0
                             THEN DD.SummSale
                        ELSE DD.Summ_ReturnIn - DD.SummSale_SUM + DD.SummSale
                   END AS Summ_ReturnIn
            FROM (SELECT * FROM tmpList) AS DD
            WHERE DD.Summ_ReturnIn - (DD.SummSale_SUM - DD.SummSale) > 0
           ;

     END LOOP; -- финиш цикла по курсору1 - период
     CLOSE curMonth; -- закрыли курсор1 - период


     -- добавили если не нашли - возвраты
     INSERT INTO _tmpSale (MovementId, StatusId, InvNumber, OperDate, PaidKindId,  ContractId, PartnerId, JuridicalId, SummSale, Ord, Ord_ReturnIn)
        SELECT 0 AS MovementId
             , 0 AS StatusId
             , 0 AS InvNumber
             , tmpReturnIn.OperDate_m AS OperDate
             , tmpReturnIn.PaidKindId
             , tmpReturnIn.ContractId
             , 0 AS PartnerId
             , tmpReturnIn.JuridicalId
             , 0 AS SummSale
             , 0 AS Ord
             , 1 AS Ord_ReturnIn
        FROM -- Итог по возвратам за месяц
             (SELECT _tmpReturnIn.OperDate_m
                   , _tmpReturnIn.JuridicalId
                   , _tmpReturnIn.ContractId
                   , _tmpReturnIn.PaidKindId
                   , SUM (_tmpReturnIn.Summ_ReturnIn) AS Summ_ReturnIn
              FROM _tmpReturnIn
              GROUP BY _tmpReturnIn.OperDate_m
                     , _tmpReturnIn.JuridicalId
                     , _tmpReturnIn.ContractId
                     , _tmpReturnIn.PaidKindId
             ) AS tmpReturnIn
             LEFT JOIN _tmpSale ON _tmpSale.Ord_ReturnIn = 1
                               AND _tmpSale.JuridicalId  = tmpReturnIn.JuridicalId
                               AND _tmpSale.ContractId   = tmpReturnIn.ContractId
                               AND _tmpSale.PaidKindId   = tmpReturnIn.PaidKindId
                               AND DATE_TRUNC ('MONTH', _tmpSale.OperDate)  = tmpReturnIn.OperDate_m
        WHERE _tmpSale.JuridicalId IS NULL
       ;

     -- добавили если матем по возвратам не соответствует
     INSERT INTO _tmpReturnIn_res (JuridicalId, ContractId, PaidKindId, MovementId_sale, OperDate_m, Summ_ReturnIn)
        SELECT tmpReturnIn.JuridicalId, tmpReturnIn.ContractId, tmpReturnIn.PaidKindId
             , 0
             , tmpReturnIn.OperDate_m
             , tmpReturnIn.Summ_ReturnIn - COALESCE (tmpReturnIn_res.Summ_ReturnIn, 0)
        FROM -- Итог по возвратам за месяц
             (SELECT _tmpReturnIn.OperDate_m
                   , _tmpReturnIn.JuridicalId
                   , _tmpReturnIn.ContractId
                   , _tmpReturnIn.PaidKindId
                   , SUM (_tmpReturnIn.Summ_ReturnIn) AS Summ_ReturnIn
              FROM _tmpReturnIn
              GROUP BY _tmpReturnIn.OperDate_m
                     , _tmpReturnIn.JuridicalId
                     , _tmpReturnIn.ContractId
                     , _tmpReturnIn.PaidKindId
             ) AS tmpReturnIn
             LEFT JOIN (SELECT _tmpReturnIn_res.OperDate_m
                             , _tmpReturnIn_res.JuridicalId
                             , _tmpReturnIn_res.ContractId
                             , _tmpReturnIn_res.PaidKindId
                             , SUM (_tmpReturnIn_res.Summ_ReturnIn) AS Summ_ReturnIn
                        FROM _tmpReturnIn_res
                        GROUP BY _tmpReturnIn_res.OperDate_m
                               , _tmpReturnIn_res.JuridicalId
                               , _tmpReturnIn_res.ContractId
                               , _tmpReturnIn_res.PaidKindId
                       ) AS tmpReturnIn_res ON tmpReturnIn_res.JuridicalId  = tmpReturnIn.JuridicalId
                                           AND tmpReturnIn_res.ContractId   = tmpReturnIn.ContractId
                                           AND tmpReturnIn_res.PaidKindId   = tmpReturnIn.PaidKindId
                                           AND tmpReturnIn_res.OperDate_m   = tmpReturnIn.OperDate_m
                                          ;


    -- Результат
    RETURN QUERY
    WITH -- Продажи за период
         tmpMovement_Sale AS (SELECT _tmpSale.MovementId, _tmpSale.StatusId, _tmpSale.InvNumber, _tmpSale.OperDate
                                   , _tmpSale.PaidKindId
                                   , _tmpSale.ContractId
                                   , _tmpSale.PartnerId
                                   , _tmpSale.JuridicalId
                                     -- Сумма по накладным
                                   , _tmpSale.SummSale
                                     -- сколько осталось
                                   , CASE WHEN _tmpSale.SummSale > 0
                                               THEN _tmpSale.SummSale - COALESCE (_tmpDebt.Summ_debt, 0) - COALESCE (_tmpReturnIn_res.Summ_ReturnIn, 0)
                                          ELSE 0 
                                     END AS TotalSumm
                                     -- долги по накладным
                                   , COALESCE (_tmpDebt.Summ_debt, 0)            AS Summ_debt
                                     -- возвраты по накладным
                                   , COALESCE (_tmpReturnIn_res.Summ_ReturnIn, 0) AS Summ_ReturnIn
                                     -- накопительная сумма продаж
                                   , SUM (CASE WHEN _tmpSale.SummSale > 0
                                               THEN _tmpSale.SummSale - COALESCE (_tmpDebt.Summ_debt, 0) - COALESCE (_tmpReturnIn_res.Summ_ReturnIn, 0)
                                               ELSE 0
                                          END)
                                         OVER (PARTITION BY _tmpSale.JuridicalId, _tmpSale.ContractId, _tmpSale.PaidKindId
                                               -- сортировка от последней накладной к первой
                                               ORDER BY _tmpSale.Ord
                                              )
                                         AS TotalSumm_calc

                                   , _tmpSale.Ord
                                   , _tmpSale.Ord_ReturnIn

                              FROM _tmpSale
                                   -- долги по накладным
                                   LEFT JOIN _tmpDebt         ON (_tmpDebt.MovementId_sale  = _tmpSale.MovementId OR (_tmpDebt.Summ_debt < 0 AND _tmpSale.Ord = 1))
                                                             AND _tmpDebt.JuridicalId      = _tmpSale.JuridicalId
                                                             AND _tmpDebt.ContractId       = _tmpSale.ContractId
                                                             AND _tmpDebt.PaidKindId       = _tmpSale.PaidKindId
                                                             AND (_tmpSale.MovementId > 0 OR _tmpSale.Ord = 1)
                                   -- возвраты по накладным
                                   LEFT JOIN _tmpReturnIn_res ON _tmpReturnIn_res.MovementId_sale = _tmpSale.MovementId
                                                             AND _tmpReturnIn_res.JuridicalId     = _tmpSale.JuridicalId
                                                             AND _tmpReturnIn_res.ContractId      = _tmpSale.ContractId
                                                             AND _tmpReturnIn_res.PaidKindId      = _tmpSale.PaidKindId
                                                             AND (_tmpSale.MovementId > 0 OR _tmpSale.Ord_ReturnIn = 1)
                                                             AND (_tmpSale.MovementId > 0 OR _tmpReturnIn_res.OperDate_m = DATE_TRUNC ('MONTH', _tmpSale.OperDate))
                             )
    -- BankAccount
  , tmpMovement_BankAccount AS(WITH
                               tmpMovement AS (SELECT Movement.*
                                               FROM Movement
                                               WHERE Movement.DescId IN (zc_Movement_BankAccount()) -- , zc_Movement_SendDebt()
                                                 AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                                 AND Movement.StatusId = zc_Enum_Status_Complete()
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
                                                                              -- !!!Доходы + Продукция
                                                                              AND ObjectLink_InfoMoney_InfoMoneyDestination.ChildObjectId = zc_Enum_InfoMoneyDestination_30100()
                                                         -- !!!Группируем Договора!!!
                                                         LEFT JOIN Object_Contract_ContractKey_View AS View_Contract_ContractKey ON View_Contract_ContractKey.ContractId = MovementItemLinkObject.ObjectId
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
    -- Взаимозачет
  , tmpMovement_SendDebt AS(WITH
                               tmpMovement AS (SELECT Movement.*
                                               FROM Movement
                                               WHERE Movement.DescId IN ( zc_Movement_SendDebt())
                                                 AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                                              )

                             , tmpMI AS (SELECT MovementItem.*
                                         FROM MovementItem
                                         WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                           AND MovementItem.isErased = FALSE
                                         )
                             , tmpMILO AS (SELECT * FROM MovementItemLinkObject WHERE MovementItemLinkObject.MovementItemId IN (SELECT tmpMI.Id FROM tmpMI))
                             , tmpMIFloat AS (SELECT * FROM MovementItemFloat WHERE MovementItemFloat.MovementItemId IN (SELECT tmpMI.Id FROM tmpMI))

                             , tmpTotalSumm_Child AS (SELECT View_Contract_ContractKey.ContractId_key AS ContractId
                                                           , COALESCE (ObjectLink_Partner_JuridicalTo.ChildObjectId, Object_Juridical_To.Id) AS JuridicalId
                                                           , MILinkObject_PaidKind_To.ObjectId        AS PaidKindId
                                                           , SUM (-1 * MI_Child.Amount)               AS Amount
                                                      FROM tmpMovement AS Movement
                                                          LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                                                  ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                                                                 AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

                                                          LEFT JOIN tmpMI AS MI_Child
                                                                          ON MI_Child.MovementId = Movement.Id
                                                                         AND MI_Child.DescId     = zc_MI_Child()

                                                          LEFT JOIN Object AS Object_Juridical_To ON Object_Juridical_To.Id = MI_Child.ObjectId
                                                          LEFT JOIN ObjectDesc AS ObjectToDesc ON ObjectToDesc.Id = Object_Juridical_To.DescId

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

                                                          -- !!!Ограничили!!!
                                                          INNER JOIN _tmpJur ON _tmpJur.JuridicalId = COALESCE (ObjectLink_Partner_JuridicalTo.ChildObjectId, Object_Juridical_To.Id)

                                                      WHERE -- !!!Группируем Договора!!!
                                                            (View_Contract_ContractKey.ContractId_key = vbContractId_key OR COALESCE (vbContractId_key, 0) = 0)

                                                      GROUP BY View_Contract_ContractKey.ContractId_key
                                                             , COALESCE (ObjectLink_Partner_JuridicalTo.ChildObjectId, Object_Juridical_To.Id)
                                                             , MILinkObject_PaidKind_To.ObjectId
                                                      )

                             , tmpTotalSumm_Master AS (SELECT View_Contract_ContractKey.ContractId_key AS ContractId
                                                            , COALESCE (ObjectLink_Partner_JuridicalFrom.ChildObjectId, Object_Juridical_From.Id) AS JuridicalId
                                                            , MILinkObject_PaidKind_From.ObjectId      AS PaidKindId
                                                            , SUM (-1 * MI_Master.Amount)     ::TFloat AS Amount
                                                       FROM tmpMovement AS Movement
                                                           LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                                                   ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                                                                  AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

                                                           LEFT JOIN tmpMI AS MI_Master
                                                                           ON MI_Master.MovementId = Movement.Id
                                                                          AND MI_Master.DescId     = zc_MI_Master()

                                                           LEFT JOIN Object AS Object_Juridical_From ON Object_Juridical_From.Id = MI_Master.ObjectId
                                                           LEFT JOIN ObjectDesc AS ObjectFromDesc ON ObjectFromDesc.Id = Object_Juridical_From.DescId

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

                                                          -- !!!Ограничили!!!
                                                          INNER JOIN _tmpJur ON _tmpJur.JuridicalId = COALESCE (ObjectLink_Partner_JuridicalFrom.ChildObjectId, Object_Juridical_From.Id)

                                                       WHERE -- !!!Группируем Договора!!!
                                                             (View_Contract_ContractKey.ContractId_key = vbContractId_key OR COALESCE (vbContractId_key, 0) = 0)

                                                       GROUP BY View_Contract_ContractKey.ContractId_key
                                                              , COALESCE (ObjectLink_Partner_JuridicalFrom.ChildObjectId, Object_Juridical_From.Id)
                                                              , MILinkObject_PaidKind_From.ObjectId
                                                      )
                             -- Взаимозачет
                             SELECT tmp.JuridicalId
                                  , tmp.ContractId
                                  , tmp.PaidKindId
                                  , SUM (tmp.Amount) AS Amount
                             FROM (SELECT tmp.JuridicalId
                                        , tmp.ContractId
                                        , tmp.PaidKindId
                                        , tmp.Amount
                                   FROM tmpTotalSumm_Master AS tmp
                                UNION
                                   SELECT tmp.JuridicalId
                                        , tmp.ContractId
                                        , tmp.PaidKindId
                                        , tmp.Amount
                                   FROM tmpTotalSumm_Child AS tmp
                                  ) AS tmp
                             GROUP BY tmp.JuridicalId
                                    , tmp.ContractId
                                    , tmp.PaidKindId
                           )

   -- BankAccount + SendDebt
 , tmpSumm_pay AS (SELECT tmp.JuridicalId
                        , tmp.ContractId
                        , tmp.PaidKindId
                        , SUM (tmp.TotalAmount)     AS TotalAmount
                        , SUM (tmp.Amount_Bank)     AS Amount_Bank
                        , SUM (tmp.Amount_SendDebt) AS Amount_SendDebt
                   FROM (SELECT tmp.JuridicalId
                              , tmp.ContractId
                              , tmp.PaidKindId
                              , tmp.Amount_Bank AS TotalAmount
                              , tmp.Amount_Bank AS Amount_Bank
                              , 0               AS Amount_SendDebt
                         FROM tmpMovement_BankAccount AS tmp
                      UNION
                         SELECT tmp.JuridicalId
                              , tmp.ContractId
                              , tmp.PaidKindId
                              , tmp.Amount AS TotalAmount
                              , 0          AS Amount_Bank
                              , tmp.Amount AS Amount_SendDebt
                         FROM tmpMovement_SendDebt AS tmp
                        ) AS tmp
                   GROUP BY tmp.JuridicalId
                          , tmp.ContractId
                          , tmp.PaidKindId
                  )
    -- распределение оплат по накладным
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
                     , tmpMovement_Sale.TotalSumm_calc

                     , tmpMovement_Sale.Summ_debt
                     , tmpMovement_Sale.Summ_ReturnIn

                     , tmpMovement_Sale.Ord
                     , tmpMovement_Sale.Ord_ReturnIn

                       -- итого Сумма - в одну строчку
                     , CASE WHEN tmpMovement_Sale.Ord = 1 THEN COALESCE (tmpSumm_pay.TotalAmount, 0)     ELSE 0 END AS TotalAmount_Pay
                       -- итого Сумма оплаты - в одну строчку
                     , CASE WHEN tmpMovement_Sale.Ord = 1 THEN COALESCE (tmpSumm_pay.Amount_Bank, 0)     ELSE 0 END AS TotalAmount_Bank
                       -- итого Сумма Взаимозачет - в одну строчку
                     , CASE WHEN tmpMovement_Sale.Ord = 1 THEN COALESCE (tmpSumm_pay.Amount_SendDebt, 0) ELSE 0 END AS TotalAmount_SendDebt

                       -- итого долги - в одну строчку
                     , COALESCE (tmpDebt.Summ_debt, 0) AS TotalSumm_debt
                       -- итого ReturnIn - в одну строчку
                     , COALESCE (tmpReturnIn.Summ_ReturnIn, 0) AS TotalSumm_ReturnIn

                       -- какие накладные оплачены
                     , CASE WHEN tmpSumm_pay.TotalAmount >= tmpMovement_Sale.TotalSumm_calc
                                 -- оплачена вся накладная
                                 THEN  tmpMovement_Sale.TotalSumm
                            WHEN tmpSumm_pay.TotalAmount >= tmpMovement_Sale.TotalSumm_calc - tmpMovement_Sale.TotalSumm
                                 -- оплачена частично
                                 THEN tmpSumm_pay.TotalAmount - (tmpMovement_Sale.TotalSumm_calc - tmpMovement_Sale.TotalSumm)

                            ELSE 0
                       END AS Summ_Pay

                FROM tmpMovement_Sale
                     -- вся Сумма оплаты - в одну строчку
                     LEFT JOIN tmpSumm_pay ON tmpSumm_pay.JuridicalId = tmpMovement_Sale.JuridicalId
                                          AND tmpSumm_pay.ContractId  = tmpMovement_Sale.ContractId
                                          AND tmpSumm_pay.PaidKindId  = tmpMovement_Sale.PaidKindId
                     -- Итого долги
                     LEFT JOIN (SELECT _tmpDebt.JuridicalId
                                     , _tmpDebt.ContractId
                                     , _tmpDebt.PaidKindId
                                     , SUM (_tmpDebt.Summ_debt) AS Summ_debt
                                FROM _tmpDebt
                                GROUP BY _tmpDebt.JuridicalId
                                       , _tmpDebt.ContractId
                                       , _tmpDebt.PaidKindId
                               ) AS tmpDebt
                                 ON tmpDebt.JuridicalId = tmpMovement_Sale.JuridicalId
                                AND tmpDebt.ContractId  = tmpMovement_Sale.ContractId
                                AND tmpDebt.PaidKindId  = tmpMovement_Sale.PaidKindId
                                -- в одну строчку
                                AND tmpMovement_Sale.Ord = 1
                     -- Итого ReturnIn
                     LEFT JOIN (SELECT _tmpReturnIn.OperDate_m
                                     , _tmpReturnIn.JuridicalId
                                     , _tmpReturnIn.ContractId
                                     , _tmpReturnIn.PaidKindId
                                     , SUM (_tmpReturnIn.Summ_ReturnIn) AS Summ_ReturnIn
                                FROM _tmpReturnIn
                                GROUP BY _tmpReturnIn.OperDate_m
                                       , _tmpReturnIn.JuridicalId
                                       , _tmpReturnIn.ContractId
                                       , _tmpReturnIn.PaidKindId
                               ) AS tmpReturnIn
                                 ON tmpReturnIn.JuridicalId = tmpMovement_Sale.JuridicalId
                                AND tmpReturnIn.ContractId  = tmpMovement_Sale.ContractId
                                AND tmpReturnIn.PaidKindId  = tmpMovement_Sale.PaidKindId
                                AND tmpReturnIn.OperDate_m  = DATE_TRUNC ('MONTH', tmpMovement_Sale.OperDate)
                                -- в одну строчку
                                AND tmpMovement_Sale.Ord_ReturnIn = 1

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
       , tmpData.TotalSumm_calc ::TFloat

         -- Сумма по накладным с НДС
       , tmpData.SummSale       ::TFloat AS TotalSumm
         -- Остаток по накладным - для распределения оплат
       , tmpData.TotalSumm      ::TFloat AS TotalSumm_rem

         -- Итого оплата + взаимозачет
       , tmpData.TotalAmount_Pay :: TFloat

         -- Итого оплата
       , tmpData.TotalAmount_Bank     :: TFloat
         -- Итого взаимозачет
       , tmpData.TotalAmount_SendDebt :: TFloat

         -- Распределено - оплата
       , tmpData.Summ_Pay    :: TFloat
         -- Распределено - долги
       , tmpData.Summ_debt   :: TFloat
         -- Распределено - возвраты
       , tmpData.Summ_ReturnIn:: TFloat

         -- Распределено - долги
       , (tmpData.Summ_Pay + tmpData.Summ_debt + tmpData.Summ_ReturnIn) :: TFloat AS Summ_calc

         -- итого долги
       , tmpData.TotalSumm_debt:: TFloat
         -- итого ReturnIn
       , tmpData.TotalSumm_ReturnIn:: TFloat

       , tmpData.Ord          :: Integer
       , tmpData.Ord_ReturnIn :: Integer

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
-- SELECT * FROM gpReport_Sale_BankAccount (inStartDate:= '01.10.2023', inEndDate:= '10.10.2023', inPaidKindId:= 3, inJuridicalId:= 15088 , inContractId:= 0, inSession:= '5');
