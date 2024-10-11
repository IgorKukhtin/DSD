-- Function: lpComplete_Movement_Cash (Integer, Boolean)

DROP FUNCTION IF EXISTS lpComplete_Movement_Cash (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Cash(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbServiceDate           TDateTime;
   DECLARE vbOperDate_currency     TDateTime;
   DECLARE vbPersonalServiceListId Integer;
   DECLARE vbMovementId_parent     Integer;
   DECLARE vbPositionId            Integer;

   DECLARE vbMovementItemId        Integer;
   DECLARE vbCashId                Integer;
   DECLARE vbCurrencyId            Integer;
   DECLARE vbCashId_to             Integer;
   DECLARE vbFounderId_to          Integer;
   DECLARE vbCurrencyId_to         Integer;
   DECLARE vbCurrencyValue         TFloat;
   DECLARE vbParValue              TFloat;
   DECLARE vbAmountCurrency        TFloat;

   DECLARE vbSumm_diff             TFloat;
   DECLARE vbSumm_diff_balance     TFloat;
   DECLARE vbIsCurrency_balance    Boolean;
BEGIN
     --
     vbMovementId_parent:= (SELECT Movement.ParentId FROM Movement WHERE Movement.Id = inMovementId);
     --
     IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = vbMovementId_parent AND Movement.DescId = zc_Movement_PersonalService())
     THEN
         -- определили
         vbPersonalServiceListId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = vbMovementId_parent AND MLO.DescId = zc_MovementLinkObject_PersonalServiceList());
         -- определили <Месяц начислений:
         vbServiceDate:= (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = vbMovementId_parent AND MD.DescId = zc_MovementDate_ServiceDate());

         --
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalServiceList(), inMovementId, vbPersonalServiceListId);

         --
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_MoneyPlace(), MovementItem.Id, vbPersonalServiceListId)
               , lpInsertUpdate_MovementItemDate (zc_MIDate_ServiceDate(), MovementItem.Id, vbServiceDate)
         FROM MovementItem
         WHERE MovementItem.MovementId = inMovementId
           AND MovementItem.DescId = zc_MI_Master();
         

     END IF;


     -- определили <Месяц начислений:
     vbServiceDate:= (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = vbMovementId_parent AND MD.DescId = zc_MovementDate_ServiceDate());
     
     -- определили 
   --vbOperDate_currency:= DATE_TRUNC ('MONTH', (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId)); -- + INTERVAL '1 MONTH';
     vbOperDate_currency:= (SELECT Movement.OperDate - INTERVAL '1 DAY' FROM Movement WHERE Movement.Id = inMovementId);

     -- !!!определили
     vbIsCurrency_balance:= vbOperDate_currency >= '31.07.2024';


         -- пока определяется "из справочника", доработать - вывести на форму
         SELECT ObjectLink_Personal_PersonalServiceList.ChildObjectId
              , ObjectLink_Personal_Position.ChildObjectId
                INTO vbPersonalServiceListId, vbPositionId
         FROM ObjectLink AS ObjectLink_Personal_PersonalServiceList
              LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                   ON ObjectLink_Personal_Position.ObjectId = ObjectLink_Personal_PersonalServiceList.ObjectId
                                  AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
         WHERE ObjectLink_Personal_PersonalServiceList.ObjectId = (SELECT MovementItemLinkObject.ObjectId
                                                                   FROM MovementItem
                                                                        LEFT JOIN MovementItemLinkObject
                                                                               ON MovementItemLinkObject.MovementItemId = MovementItem.Id
                                                                              AND MovementItemLinkObject.DescId = zc_MILinkObject_MoneyPlace()
                                                                   WHERE MovementItem.MovementId = inMovementId
                                                                     AND MovementItem.DescId = zc_MI_Master()
                                                                  )
                                      AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
        ;
         -- !!!ВРЕМЕННО!!! - сохранили связь с <Ведомости начисления> + <Должность>
         IF vbPersonalServiceListId <> 0
            AND (EXISTS (SELECT 1
                        FROM MovementItem
                             INNER JOIN MovementItemLinkObject AS MILO
                                                               ON MILO.MovementItemId = MovementItem.Id
                                                              AND MILO.DescId         = zc_MILinkObject_InfoMoney()
                                                              AND MILO.ObjectId       = zc_Enum_InfoMoney_60101() -- Заработная плата
                        WHERE MovementItem.MovementId = inMovementId
                          AND MovementItem.DescId     = zc_MI_Master()
                       )
              OR vbServiceDate >= '01.01.2019'
                )
         THEN
             --
             PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalServiceList(), inMovementId, vbPersonalServiceListId);
             --
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Position(), MovementItem.Id, vbPositionId)
             FROM MovementItem
             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.DescId = zc_MI_Master();
        END IF;



     -- !!!формируются свойство <Месяц начислений> в элементах документа!!!
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ServiceDate(), MovementItem.Id, vbServiceDate)
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Child();



     -- определили для Валютного учета
     SELECT MovementItem.Id                     AS MovementItemId
            -- по какой касссе
          , COALESCE (Object_Cash.Id, 0)        AS CashId
            -- Cумма в валюте, по кассе
          , COALESCE (MovementFloat_AmountCurrency.ValueData, 0) AS AmountCurrency
            -- Валюта
          , COALESCE (MILinkObject_Currency.ObjectId, zc_Enum_Currency_Basis()) AS CurrencyId
            -- в какую касссу
          , COALESCE (Object_Cash_to.Id, 0)      AS CashId_to
            --
          , COALESCE (Object_Founder_to.Id, 0)   AS FounderId_to
          , COALESCE (MILinkObject_CurrencyPartner.ObjectId, zc_Enum_Currency_Basis()) 

            INTO vbMovementItemId
               , vbCashId
               , vbAmountCurrency
               , vbCurrencyId
               , vbCashId_to
               , vbFounderId_to
               , vbCurrencyId_to

     FROM Movement
          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()

          LEFT JOIN MovementFloat AS MovementFloat_AmountCurrency
                                  ON MovementFloat_AmountCurrency.MovementId = Movement.Id
                                 AND MovementFloat_AmountCurrency.DescId = zc_MovementFloat_AmountCurrency()
          LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                           ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                          AND MILinkObject_Currency.DescId         = zc_MILinkObject_Currency()
          LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                           ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                          AND MILinkObject_MoneyPlace.DescId         = zc_MILinkObject_MoneyPlace()
          -- по какой касссе
          LEFT JOIN Object AS Object_Cash ON Object_Cash.Id     = MovementItem.ObjectId
                                         AND Object_Cash.DescId = zc_Object_Cash()
          -- в какую касссу
          LEFT JOIN Object AS Object_Cash_to ON Object_Cash_to.Id     = MILinkObject_MoneyPlace.ObjectId
                                            AND Object_Cash_to.DescId = zc_Object_Cash()
          --
          LEFT JOIN Object AS Object_Founder_to ON Object_Founder_to.Id     = MILinkObject_MoneyPlace.ObjectId
                                               AND Object_Founder_to.DescId = zc_Object_Founder()
          LEFT JOIN MovementItemLinkObject AS MILinkObject_CurrencyPartner
                                           ON MILinkObject_CurrencyPartner.MovementItemId = MovementItem.Id
                                          AND MILinkObject_CurrencyPartner.DescId         = zc_MILinkObject_CurrencyPartner()

     WHERE Movement.Id = inMovementId
       AND Movement.DescId = zc_Movement_Cash()
    ;

     -- Если надо переписать курс
     IF vbIsCurrency_balance = TRUE
        AND (vbAmountCurrency < 0 OR (vbAmountCurrency > 0 AND vbCashId_to > 0 AND vbCashId <> vbCashId_to AND vbCurrencyId_to <> zc_Enum_Currency_Basis()))
        AND vbCurrencyId <> zc_Enum_Currency_Basis()
        AND (vbCashId_to = 0 OR vbCurrencyId_to <> zc_Enum_Currency_Basis())
        AND vbFounderId_to = 0
     THEN

-- if inUserId = 5 then
--     RAISE EXCEPTION 'Ошибка.<%>  <%>  <%> <%> <%> <%>', vbCashId, vbCashId_to , vbCurrencyId_to , vbCurrencyId, zc_Enum_Currency_Basis(), vbIsCurrency_balance;
-- end if;

          -- нашли курс
          SELECT -- курсовая разница - будет для ОПиУ
                 CASE WHEN tmpSumm.OperSumm_Currency <> 0 
                           THEN CAST (ABS (tmpSumm.OperSumm / tmpSumm.OperSumm_Currency) AS NUMERIC (16, 4))
                      ELSE 0
                 END AS CurrencyValue
                 --
               , 1 AS ParValue

                 -- Сумма для счета Курс Разн
               , vbAmountCurrency
               * CASE WHEN tmpSumm.OperSumm_Currency <> 0 
                           THEN CAST (ABS (tmpSumm.OperSumm / tmpSumm.OperSumm_Currency) AS NUMERIC (16, 4))
                      ELSE 0
                 END AS Summ_diff_balance
                 
                 INTO vbCurrencyValue, vbParValue, vbSumm_diff_balance
     
          FROM (WITH tmpItem AS (SELECT vbCashId AS CashId, vbCurrencyId AS CurrencyId
                                )
             , tmpContainer_grn AS (SELECT Container.Id       AS ContainerId
                                         , Container.ObjectId AS AccountId
                                         , Container.Amount
                                           -- Счет баланса - Курсовая разница
                                         , CASE WHEN View_Account.AccountDirectionId = zc_Enum_AccountDirection_40800()
                                                THEN TRUE
                                                ELSE FALSE
                                           END AS isSumm_diff_balance
                                    FROM tmpItem
                                         INNER JOIN ContainerLinkObject AS CLO_Currency
                                                                        -- по этой валюте
                                                                        ON CLO_Currency.ObjectId = tmpItem.CurrencyId
                                                                       AND CLO_Currency.DescId   = zc_ContainerLinkObject_Currency()
                                         INNER JOIN Container ON Container.Id     = CLO_Currency.ContainerId
                                                             -- учет в ГРН
                                                             AND Container.DescId = zc_Container_Summ()
                                         INNER JOIN Object_Account_View AS View_Account
                                                                        ON View_Account.AccountId      = Container.ObjectId
                                                                       AND View_Account.AccountGroupId = zc_Enum_AccountGroup_40000() -- Денежные средства 
                                         INNER JOIN ContainerLinkObject AS CLO_Cash
                                                                        ON CLO_Cash.ContainerId = CLO_Currency.ContainerId
                                                                       AND CLO_Cash.DescId      = zc_ContainerLinkObject_Cash()
                                                                       -- по этой кассе
                                                                       AND CLO_Cash.ObjectId    = CASE WHEN vbAmountCurrency > 0 AND vbCashId_to > 0 AND tmpItem.CashId <> vbCashId_to AND vbCurrencyId_to <> zc_Enum_Currency_Basis()
                                                                                                            -- не ошибка, касса с которой приход
                                                                                                            THEN vbCashId_to
                                                                                                       ELSE tmpItem.CashId
                                                                                                  END
                                   )
           , tmpMIContainer_grn AS (SELECT tmpContainer_grn.ContainerId, MIContainer.OperDate, MIContainer.MovementItemId, MIContainer.MovementId, SUM (MIContainer.Amount) AS Amount
                                    FROM tmpContainer_grn
                                         LEFT JOIN MovementItemContainer AS MIContainer
                                                                         ON MIContainer.Containerid = tmpContainer_grn.ContainerId
                                                                        -- на конец дня + за сегодня
                                                                        AND MIContainer.OperDate    >= vbOperDate_currency + INTERVAL '1 DAY'
                                    GROUP BY tmpContainer_grn.ContainerId, MIContainer.OperDate, MIContainer.MovementItemId, MIContainer.MovementId
                                   )
                -- итоговые суммы, по ним - курс
                SELECT SUM (tmp.OperSumm_Currency) AS OperSumm_Currency
                     , SUM (tmp.OperSumm)          AS OperSumm
                     , SUM (tmp.OperSumm_balance)  AS OperSumm_balance
                FROM (-- остаток суммы на дату в Валюте
                      SELECT tmpContainer.ContainerId
                           , tmpContainer.AccountId
                           , tmpContainer.Amount - COALESCE (SUM (CASE -- для остатка на конец дня
                                                                       WHEN MIContainer.OperDate    > vbOperDate_currency + INTERVAL '1 DAY'
                                                                            THEN MIContainer.Amount
                                                                       -- так получим остаток + приход
                                                                       WHEN MIContainer.OperDate    = vbOperDate_currency + INTERVAL '1 DAY'
                                                                        -- и НЕ учредители
                                                                        AND COALESCE (Object_MoneyPlace.DescId, 0) <> zc_Object_Founder()
                                                                            -- расход за этот день "вычитается"
                                                                        AND (MIContainer.Amount < 0
                                                                          -- или Обмен
                                                                          -- OR (Object_MoneyPlace.DescId = zc_Object_Cash() AND COALESCE (MILinkObject_Currency.ObjectId, 0) IN (0, zc_Enum_Currency_Basis()))
                                                                            )
                                                                        -- и НЕ Обмен
                                                                        --AND (Object_MoneyPlace.DescId <> zc_Object_Cash() OR COALESCE (MILinkObject_Currency.ObjectId, 0) NOT IN (0, zc_Enum_Currency_Basis()))
                                                                            THEN MIContainer.Amount
                                                                       ELSE 0
                                                                  END), 0) AS OperSumm_Currency
                           , 0 AS OperSumm
                           , 0 AS OperSumm_balance
                      FROM (SELECT Container.ParentId AS ContainerId
                                 , Container.Id       AS ContainerId_Currency
                                 , Container.ObjectId AS AccountId
                                 , Container.Amount
                            FROM tmpItem
                                 INNER JOIN ContainerLinkObject AS CLO_Currency
                                                                -- по этой валюте
                                                                ON CLO_Currency.ObjectId = tmpItem.CurrencyId
                                                               AND CLO_Currency.DescId   = zc_ContainerLinkObject_Currency()
                                 INNER JOIN Container ON Container.Id     = CLO_Currency.ContainerId
                                                     -- валютный учет
                                                     AND Container.DescId = zc_Container_SummCurrency()
                                 INNER JOIN Object_Account_View AS View_Account
                                                                ON View_Account.AccountId      = Container.ObjectId
                                                               AND View_Account.AccountGroupId = zc_Enum_AccountGroup_40000() -- Денежные средства 
                                 INNER JOIN ContainerLinkObject AS CLO_Cash
                                                                ON CLO_Cash.ContainerId = CLO_Currency.ContainerId
                                                               AND CLO_Cash.DescId      = zc_ContainerLinkObject_Cash()
                                                               -- по этой кассе
                                                               AND CLO_Cash.ObjectId    = CASE WHEN vbAmountCurrency > 0 AND vbCashId_to > 0 AND tmpItem.CashId <> vbCashId_to AND vbCurrencyId_to <> zc_Enum_Currency_Basis()
                                                                                                    -- не ошибка, касса с которой приход
                                                                                                    THEN vbCashId_to
                                                                                               ELSE tmpItem.CashId
                                                                                          END
                           ) AS tmpContainer
                           LEFT JOIN MovementItemContainer AS MIContainer
                                                           ON MIContainer.Containerid = tmpContainer.ContainerId_Currency
                                                          -- на конец дня + за сегодня
                                                          AND MIContainer.OperDate    >= vbOperDate_currency + INTERVAL '1 DAY'

                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                            ON MILinkObject_Currency.MovementItemId = MIContainer.MovementItemId
                                                           AND MILinkObject_Currency.DescId         = zc_MILinkObject_CurrencyPartner()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                                            ON MILinkObject_MoneyPlace.MovementItemId = MIContainer.MovementItemId
                                                           AND MILinkObject_MoneyPlace.DescId         = zc_MILinkObject_MoneyPlace()
                           LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = MILinkObject_MoneyPlace.ObjectId

                      GROUP BY tmpContainer.ContainerId
                             , tmpContainer.ContainerId_Currency
                             , tmpContainer.AccountId
                             , tmpContainer.Amount
                     UNION ALL
                      -- остаток суммы на дату в ГРН
                      SELECT tmpContainer.ContainerId
                           , tmpContainer.AccountId
                           , 0 AS OperSumm_Currency
                           , tmpContainer.Amount - COALESCE (SUM (CASE -- для остатка на конец дня
                                                                       WHEN MIContainer.OperDate    > vbOperDate_currency + INTERVAL '1 DAY'
                                                                            THEN MIContainer.Amount
                                                                       -- так получим остаток + приход
                                                                       WHEN MIContainer.OperDate    = vbOperDate_currency + INTERVAL '1 DAY'
                                                                        -- и НЕ учредители
                                                                        AND COALESCE (Object_MoneyPlace.DescId, 0) <> zc_Object_Founder()
                                                                        -- расход за этот день "вычитается"
                                                                        AND (MIContainer.Amount < 0
                                                                          -- или Курсовая разница
                                                                          OR tmpContainer.isSumm_diff_balance = TRUE
                                                                          -- или Обмен
                                                                          -- OR (Object_MoneyPlace.DescId = zc_Object_Cash() AND COALESCE (MILinkObject_Currency.ObjectId, 0) IN (0, zc_Enum_Currency_Basis()))
                                                                            )
                                                                          -- и НЕ Обмен
                                                                          -- AND (Object_MoneyPlace.DescId <> zc_Object_Cash() OR COALESCE (MILinkObject_Currency.ObjectId, 0) NOT IN (0, zc_Enum_Currency_Basis()))
                                                                            THEN MIContainer.Amount
                                                                       ELSE 0
                                                                  END), 0) AS OperSumm
                           , CASE WHEN tmpContainer.isSumm_diff_balance = TRUE
                                       THEN tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0)
                                  ELSE 0
                             END AS OperSumm_balance
     
                      FROM tmpContainer_grn AS tmpContainer
                           LEFT JOIN tmpMIContainer_grn AS MIContainer
                                                        ON MIContainer.Containerid = tmpContainer.ContainerId
                                                       -- на конец дня + за сегодня
                                                       AND MIContainer.OperDate    >= vbOperDate_currency + INTERVAL '1 DAY'

                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                            ON MILinkObject_Currency.MovementItemId = MIContainer.MovementItemId
                                                           AND MILinkObject_Currency.DescId         = zc_MILinkObject_CurrencyPartner()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                                            ON MILinkObject_MoneyPlace.MovementItemId = MIContainer.MovementItemId
                                                           AND MILinkObject_MoneyPlace.DescId         = zc_MILinkObject_MoneyPlace()
                           LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = MILinkObject_MoneyPlace.ObjectId

                      GROUP BY tmpContainer.ContainerId
                             , tmpContainer.AccountId
                             , tmpContainer.Amount
                             , tmpContainer.isSumm_diff_balance
                     ) AS tmp

               ) AS tmpSumm;
     
          -- Сумма в ГРН
          PERFORM lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), vbCashId, inMovementId, vbAmountCurrency * vbCurrencyValue / vbParValue, NULL);
     
          -- Курс для перевода в валюту баланса
          PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyValue(), inMovementId, vbCurrencyValue);
          -- Номинал для перевода в валюту баланса
          PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParValue(), inMovementId, vbParValue);
          -- Курс для расчета суммы операции
          PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyPartnerValue(), inMovementId, vbCurrencyValue);
          -- Номинал для расчета суммы операции
          PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParPartnerValue(), inMovementId, vbParValue);
          
     ELSEIF vbFounderId_to > 0 AND inMovementId IN (28893009, 28929200)
            AND 1=0
     THEN
         vbCurrencyValue:= 41.45;
         vbParValue:= 1;

          -- Сумма в ГРН
          PERFORM lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), vbCashId, inMovementId, vbAmountCurrency * vbCurrencyValue / vbParValue, NULL);
     
          -- Курс для перевода в валюту баланса
          PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyValue(), inMovementId, vbCurrencyValue);
          -- Номинал для перевода в валюту баланса
          PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParValue(), inMovementId, vbParValue);
          -- Курс для расчета суммы операции
          PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyPartnerValue(), inMovementId, vbCurrencyValue);
          -- Номинал для расчета суммы операции
          PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParPartnerValue(), inMovementId, vbParValue);
     
     END IF;



     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;

     -- 1.1. заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementDescId, OperDate, ObjectId, ObjectDescId, OperSumm, OperSumm_Currency
                         , MovementItemId, ContainerId
                         , AccountGroupId, AccountDirectionId, AccountId
                         , ProfitLossGroupId, ProfitLossDirectionId
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_Balance, BusinessId_ProfitLoss, JuridicalId_Basis
                         , UnitId, PositionId, PersonalServiceListId, BranchId_Balance, BranchId_ProfitLoss, ServiceDateId, ContractId, PaidKindId
                         , PartionMovementId
                         , AnalyzerId
                         , CurrencyId
                         , CarId
                         , IsActive, IsMaster
                          )
        SELECT Movement.DescId
             , Movement.OperDate
             , COALESCE (MovementItem.ObjectId, 0) AS ObjectId
             , COALESCE (Object.DescId, 0) AS ObjectDescId
               -- Cумма грн, по кассе
             , MovementItem.Amount AS OperSumm
               -- Cумма в валюте, по кассе
             , COALESCE (MovementFloat_AmountCurrency.ValueData, 0) AS OperSumm_Currency
               -- 
             , MovementItem.Id AS MovementItemId

             , 0 AS ContainerId                                                     -- сформируем позже
             , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId         -- сформируем позже
             , 0 AS ProfitLossGroupId, 0 AS ProfitLossDirectionId                   -- не используется

               -- Управленческие группы назначения
             , COALESCE (View_InfoMoney.InfoMoneyGroupId, 0) AS InfoMoneyGroupId
               -- Управленческие назначения
             , COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
               -- Управленческие статьи назначения
             , COALESCE (View_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId

               -- Бизнес Баланс: всегда из кассы
             , COALESCE (ObjectLink_Cash_Business.ChildObjectId, 0) AS BusinessId_Balance
               -- Бизнес ОПиУ: не используется
             , 0 AS BusinessId_ProfitLoss

               -- Главное Юр.лицо всегда из кассы
             , COALESCE (ObjectLink_Cash_JuridicalBasis.ChildObjectId, 0) AS JuridicalId_Basis

             , 0 AS UnitId                -- не используется
             , 0 AS PositionId            -- не используется
             , 0 AS PersonalServiceListId -- не используется

               -- Филиал Баланс: не используется
             , 0 AS BranchId_Balance
               -- Филиал ОПиУ: не используется
             , 0 AS BranchId_ProfitLoss

               -- Месяц начислений: не используется
             , 0 AS ServiceDateId

             , 0 AS ContractId -- не используется
             , COALESCE (ObjectLink_Cash_PaidKind.ChildObjectId, zc_Enum_PaidKind_SecondForm()) AS PaidKindId -- !!!НЕ Всегда НАЛ!!!, но для этой проводки пока не используется

             , 0 PartionMovementId -- не используется

             , 0 AS AnalyzerId

               -- Валюта
             , COALESCE (MILinkObject_Currency.ObjectId, zc_Enum_Currency_Basis()) AS CurrencyId
             
             , 0 AS CarId

             , CASE WHEN MovementItem.Amount >= 0 THEN TRUE ELSE FALSE END AS IsActive
             , TRUE AS IsMaster

        FROM Movement
             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()

             LEFT JOIN MovementFloat AS MovementFloat_AmountCurrency
                                     ON MovementFloat_AmountCurrency.MovementId = Movement.Id
                                    AND MovementFloat_AmountCurrency.DescId = zc_MovementFloat_AmountCurrency()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                              ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                             AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                              ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Currency.DescId = zc_MILinkObject_Currency()

             LEFT JOIN Object ON Object.Id = MovementItem.ObjectId
             LEFT JOIN ObjectLink AS ObjectLink_Cash_JuridicalBasis ON ObjectLink_Cash_JuridicalBasis.ObjectId = MovementItem.ObjectId
                                                                   AND ObjectLink_Cash_JuridicalBasis.DescId = zc_ObjectLink_Cash_JuridicalBasis()
             LEFT JOIN ObjectLink AS ObjectLink_Cash_Business ON ObjectLink_Cash_Business.ObjectId = MovementItem.ObjectId
                                                             AND ObjectLink_Cash_Business.DescId = zc_ObjectLink_Cash_Business()
             LEFT JOIN ObjectLink AS ObjectLink_Cash_PaidKind
                                  ON ObjectLink_Cash_PaidKind.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Cash_PaidKind.DescId = zc_ObjectLink_Cash_PaidKind()
             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId
        WHERE Movement.Id = inMovementId
          AND Movement.DescId = zc_Movement_Cash()
          AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
       ;


     -- проверка
     IF EXISTS (SELECT _tmpItem.ObjectId FROM _tmpItem WHERE _tmpItem.ObjectId = 0)
     THEN
         RAISE EXCEPTION 'В документе не определена касса. Проведение невозможно.';
     END IF;
   
     -- проверка
     IF EXISTS (SELECT _tmpItem.JuridicalId_Basis FROM _tmpItem WHERE _tmpItem.JuridicalId_Basis = 0)
     THEN
         RAISE EXCEPTION 'У кассы не установлено главное юр лицо. Проведение невозможно.';
     END IF;

     -- проверка
     IF EXISTS (SELECT 1 FROM _tmpItem WHERE _tmpItem.OperSumm = 0)
     THEN
         RAISE EXCEPTION 'Ошибка.Введите сумму.';
     END IF;

     -- проверка
     IF EXISTS (SELECT 1
                FROM _tmpItem
                     JOIN ObjectLink AS Contract_InfoMoney
                                     ON Contract_InfoMoney.ObjectId = _tmpItem.ContractId
                                    AND Contract_InfoMoney.DescId   = zc_ObjectLink_Contract_InfoMoney()
                WHERE _tmpItem.InfoMoneyId <> Contract_InfoMoney.ChildObjectId
               )
     THEN
         RAISE EXCEPTION 'Ошибка.В документе статья <%> не соответствует статьи <%> в договоре № <%>.Проведение невозможно.'
                       , lfGet_Object_ValueData_sh ((SELECT _tmpItem.InfoMoneyId
                                                     FROM _tmpItem
                                                          JOIN ObjectLink AS Contract_InfoMoney
                                                                          ON Contract_InfoMoney.ObjectId = _tmpItem.ContractId
                                                                         AND Contract_InfoMoney.DescId   = zc_ObjectLink_Contract_InfoMoney()
                                                     WHERE _tmpItem.InfoMoneyId <> Contract_InfoMoney.ChildObjectId
                                                     LIMIT 1
                                                   ))
                       , lfGet_Object_ValueData_sh ((SELECT Contract_InfoMoney.ChildObjectId
                                                     FROM _tmpItem
                                                          JOIN ObjectLink AS Contract_InfoMoney
                                                                          ON Contract_InfoMoney.ObjectId = _tmpItem.ContractId
                                                                         AND Contract_InfoMoney.DescId   = zc_ObjectLink_Contract_InfoMoney()
                                                     WHERE _tmpItem.InfoMoneyId <> Contract_InfoMoney.ChildObjectId
                                                     LIMIT 1
                                                   ))
                       , lfGet_Object_ValueData ((SELECT _tmpItem.ContractId
                                                  FROM _tmpItem
                                                       JOIN ObjectLink AS Contract_InfoMoney
                                                                       ON Contract_InfoMoney.ObjectId = _tmpItem.ContractId
                                                                      AND Contract_InfoMoney.DescId   = zc_ObjectLink_Contract_InfoMoney()
                                                  WHERE _tmpItem.InfoMoneyId <> Contract_InfoMoney.ChildObjectId
                                                  LIMIT 1
                                                ))
                         ;
     END IF;

     -- 1.2. заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementDescId, OperDate, ObjectId, ObjectDescId, OperSumm, OperSumm_Currency, OperSumm_Asset
                         , MovementItemId, ContainerId
                         , AccountGroupId, AccountDirectionId, AccountId
                         , ProfitLossGroupId, ProfitLossDirectionId
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_Balance, BusinessId_ProfitLoss, JuridicalId_Basis
                         , UnitId, PositionId, PersonalServiceListId, BranchId_Balance, BranchId_ProfitLoss, ServiceDateId, ContractId, PaidKindId
                         , PartionMovementId
                         , AnalyzerId
                         , CurrencyId
                         , CarId
                         , IsActive, IsMaster
                          )
        WITH tmpMI_Child AS (SELECT MI.*, COALESCE (MIB.ValueData, FALSE) AS isCalculated
                             FROM MovementItem AS MI
                                   LEFT JOIN MovementItemBoolean AS MIB ON MIB.MovementItemId = MI.Id AND MIB.DescId = zc_MIBoolean_Calculated()
                             WHERE MI.MovementId = inMovementId
                               AND MI.DescId     = zc_MI_Child()
                               AND MI.isErased   = FALSE
                            )
        -- 1.1. в балансе - НЕ перевыставление
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate

             , CASE -- сразу в ОПиУ - Инвестиции
                    WHEN _tmpItem.OperDate >= zc_DateStart_Asset() AND _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000()
                         THEN 0

                    ELSE COALESCE (MI_Child.ObjectId, COALESCE (ObjectLink_Founder_InfoMoney.ObjectId, COALESCE (MILinkObject_MoneyPlace.ObjectId, 0)))
               END AS ObjectId

             , CASE -- сразу в ОПиУ - Инвестиции
                    WHEN _tmpItem.OperDate >= zc_DateStart_Asset() AND _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000()
                         THEN 0

                    ELSE COALESCE (Object.DescId, 0)
               END AS ObjectDescId

               -- Cумма грн, по ...
             , COALESCE (MI_Child.Amount, -1 * _tmpItem.OperSumm) AS OperSumm
               -- Cумма в валюте, по ...
             , CASE -- когда в ОПиУ - Инвестиции, сумму в валюте попробуем провести в "другой" проводке
                    WHEN _tmpItem.OperDate >= zc_DateStart_Asset() AND _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000()
                         THEN 0
                    WHEN Object.DescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND COALESCE (MILinkObject_CurrencyPartner.ObjectId, zc_Enum_Currency_Basis()) <> zc_Enum_Currency_Basis()
                         THEN -1 * _tmpItem.OperSumm_Currency
                    ELSE 0
               END AS OperSumm_Currency
               --
             , 0 AS OperSumm_Asset

             , COALESCE (MI_Child.Id, _tmpItem.MovementItemId)    AS MovementItemId

             , 0 AS ContainerId                                               -- сформируем позже
             , 0 AS AccountGroupId, 0 AS AccountDirectionId                   -- сформируем позже
             , CASE WHEN Object.DescId IN (zc_Object_Cash()) AND _tmpItem.ObjectId <> COALESCE (MILinkObject_MoneyPlace.ObjectId, 0)
                     -- AND _tmpItem.CurrencyId <> COALESCE (MILinkObject_CurrencyPartner.ObjectId, zc_Enum_Currency_Basis())
                         THEN zc_Enum_Account_110201() -- Транзит + деньги в пути
                    WHEN Object.DescId IN (zc_Object_BankAccount())
                         THEN zc_Enum_Account_110301() -- Транзит + расчетный счет
                    ELSE 0
               END AS AccountId -- ... или сформируем позже

               -- Группы ОПиУ
             , COALESCE (lfObject_Unit_byProfitLossDirection.ProfitLossGroupId, 0) AS ProfitLossGroupId
               -- Аналитики ОПиУ - направления
             , COALESCE (lfObject_Unit_byProfitLossDirection.ProfitLossDirectionId, 0) AS ProfitLossDirectionId

               -- Управленческие группы назначения
             , _tmpItem.InfoMoneyGroupId
               -- Управленческие назначения
             , _tmpItem.InfoMoneyDestinationId
               -- Управленческие статьи назначения
             , _tmpItem.InfoMoneyId

               -- Бизнес Баланс: всегда из кассы
             , _tmpItem.BusinessId_Balance
               -- Бизнес ОПиУ: ObjectLink_Unit_Business
             , CASE WHEN _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_21502() -- Общефирменные + Маркетинг + Бонусы за мясное сырье
                              -- криво захардкодил
                         THEN (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Business() AND Object.ObjectCode = 2) -- Мясо
                    ELSE COALESCE (ObjectLink_Unit_Business.ChildObjectId, 0)
               END AS BusinessId_ProfitLoss

               -- Главное Юр.лицо всегда из кассы
             , _tmpItem.JuridicalId_Basis

             , COALESCE (MILinkObject_Unit.ObjectId, 0)     AS UnitId
             , COALESCE (MILinkObject_Position.ObjectId, 0) AS PositionId
             , CASE /*WHEN inMovementId = 27161581 
                         THEN MILinkObject_MoneyPlace.ObjectId*/

                    -- замена - Премии производство (добавочная)
                    WHEN MI_Child.Id > 0 AND MILinkObject_MoneyPlace.ObjectId = 445325 
                        THEN MILinkObject_MoneyPlace.ObjectId

                    WHEN MI_Child.Id > 0
                         THEN COALESCE (ObjectLink_Personal_PersonalServiceList.ChildObjectId, ObjectLink_PersonalServiceList_two.ChildObjectId, MILinkObject_MoneyPlace.ObjectId, 0)
                    ELSE COALESCE (MLO_PersonalServiceList.ObjectId, 0)
               END AS PersonalServiceListId

                -- Филиал Баланс: всегда из кассы (нужен для НАЛ долгов или долгов подотчета) !!!но для ЗП - как в начислениях!!!
             , CASE WHEN MI_Child.Id > 0
                         THEN COALESCE (ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis())

                    -- по кассе
                  --WHEN ObjectLink_Cash_Branch.ChildObjectId > 0
                  --     THEN ObjectLink_Cash_Branch.ChildObjectId

                    -- если есть - тогда как в договоре
                    WHEN ObjectLink_Contract_Branch.ChildObjectId > 0
                         THEN ObjectLink_Contract_Branch.ChildObjectId

                    -- по подразделению
                    WHEN MILinkObject_Unit.ObjectId > 0
                         THEN COALESCE (ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis())

                    -- опять по кассе
                    ELSE COALESCE (ObjectLink_Cash_Branch.ChildObjectId, zc_Branch_Basis())

                    -- ELSE COALESCE (ObjectLink_Partner_Branch.ChildObjectId, COALESCE (ObjectLink_MoneyPlace_Branch.ChildObjectId, COALESCE (ObjectLink_Cash_Branch.ChildObjectId, zc_Branch_Basis())))

               END AS BranchId_Balance
               -- Филиал ОПиУ: всегда по подразделению !!!но для выплаты ЗП - не используется!!!
             , CASE WHEN MI_Child.Id > 0
                         THEN 0
                    -- если есть - тогда как в договоре
                    WHEN ObjectLink_Contract_Branch.ChildObjectId > 0
                         THEN ObjectLink_Contract_Branch.ChildObjectId

                    ELSE COALESCE (ObjectLink_Unit_Branch.ChildObjectId, 0)

               END AS BranchId_ProfitLoss

               -- Месяц начислений: есть
             , CASE WHEN _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_60000() -- Заработная плата
                         THEN lpInsertFind_Object_ServiceDate (inOperDate:= MIDate_ServiceDate.ValueData)
                    WHEN COALESCE (ObjectLink_Personal_PersonalServiceList.ChildObjectId, ObjectLink_PersonalServiceList_two.ChildObjectId, MILinkObject_MoneyPlace.ObjectId, 0) > 0
                     AND _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_21421()
                     AND MI_Child.Id > 0
                         THEN lpInsertFind_Object_ServiceDate (inOperDate:= MIDate_ServiceDate.ValueData)
                    ELSE 0
               END AS ServiceDateId
 
             , COALESCE (MILinkObject_Contract.ObjectId, 0) AS ContractId

             , CASE WHEN -- если Контрагент - "Павильоны" + это Бизнес у кассы - "Павильоны"
                         ObjectLink_Partner_Unit.ChildObjectId > 0
                     AND ObjectLink_Cash_Business.ChildObjectId > 0
                         -- !!!меняется на НАЛ!!!
                         THEN zc_Enum_PaidKind_SecondForm()

                  --WHEN  _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() -- Инвестиции
                  --  AND ObjectLink_Contract_PaidKind.ChildObjectId > 0
                         -- !!!меняется на БН!!!
                  --     THEN ObjectLink_Contract_PaidKind.ChildObjectId

                    ELSE _tmpItem.PaidKindId -- !!!НЕ Всегда НАЛ!!!

               END AS PaidKindId

             , CASE WHEN ObjectBoolean_PartionDoc.ValueData = TRUE
                         THEN lpInsertFind_Object_PartionMovement (MIFloat_MovementId.ValueData :: Integer, NULL)
                    ELSE 0
               END AS PartionMovementId

             , CASE WHEN inUserId = 5 AND 1=0
                         THEN zc_Enum_AnalyzerId_Cash_PersonalAvance() -- Выплата сотруднику - аванс

                    WHEN MI_Child.Id > 0 AND MI_Child.isCalculated = TRUE
                         THEN zc_Enum_AnalyzerId_Cash_PersonalCardSecond() -- Выплата сотруднику - по ведомости Карта БН 2ф.

                    WHEN MI_Child.Id > 0
                         THEN zc_Enum_AnalyzerId_Cash_PersonalService() -- Выплата сотруднику - по ведомости

                    WHEN Object.DescId = zc_Object_Personal()
                         THEN zc_Enum_AnalyzerId_Cash_PersonalAvance() -- Выплата сотруднику - аванс

                    WHEN ObjectLink_PersonalServiceList_PaidKind.ChildObjectId = zc_Enum_PaidKind_FirstForm() -- !!!вот он БН!!!
                         THEN zc_Enum_AnalyzerId_Cash_PersonalAvance() -- Выплата сотруднику - аванс

                    ELSE 0
               END AS AnalyzerId

               -- Валюта
             , COALESCE (MILinkObject_CurrencyPartner.ObjectId, zc_Enum_Currency_Basis()) AS CurrencyId

             , MILinkObject_Car.ObjectId AS CarId

             , NOT _tmpItem.IsActive
             , NOT _tmpItem.IsMaster
        FROM _tmpItem
             LEFT JOIN tmpMI_Child AS MI_Child ON MI_Child.MovementId = inMovementId
                                               -- AND MI_Child.DescId = zc_MI_Child()
                                               -- AND MI_Child.isErased = FALSE

             LEFT JOIN MovementLinkObject AS MLO_PersonalServiceList
                                          ON MLO_PersonalServiceList.MovementId = inMovementId
                                         AND MLO_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()

             LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                         ON MIFloat_MovementId.MovementItemId = _tmpItem.MovementItemId
                                        AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()

             LEFT JOIN MovementItemDate AS MIDate_ServiceDate
                                        ON MIDate_ServiceDate.MovementItemId = COALESCE (MI_Child.Id, _tmpItem.MovementItemId)
                                       AND MIDate_ServiceDate.DescId = zc_MIDate_ServiceDate()

             LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                              ON MILinkObject_MoneyPlace.MovementItemId = _tmpItem.MovementItemId
                                             AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                              ON MILinkObject_Unit.MovementItemId = COALESCE (MI_Child.Id, _tmpItem.MovementItemId)
                                             AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                              ON MILinkObject_Contract.MovementItemId = _tmpItem.MovementItemId
                                             AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                              ON MILinkObject_Position.MovementItemId = COALESCE (MI_Child.Id, _tmpItem.MovementItemId)
                                             AND MILinkObject_Position.DescId = zc_MILinkObject_Position()

             LEFT JOIN MovementItemLinkObject AS MILinkObject_Car
                                              ON MILinkObject_Car.MovementItemId = _tmpItem.MovementItemId
                                             AND MILinkObject_Car.DescId = zc_MILinkObject_Car()

             LEFT JOIN MovementItemLinkObject AS MILinkObject_CurrencyPartner
                                              ON MILinkObject_CurrencyPartner.MovementItemId = _tmpItem.MovementItemId
                                             AND MILinkObject_CurrencyPartner.DescId = zc_MILinkObject_CurrencyPartner()

             /*LEFT JOIN ObjectLink AS ObjectLink_MoneyPlace_Branch ON ObjectLink_MoneyPlace_Branch.ObjectId = MILinkObject_MoneyPlace.ObjectId
                                                                 AND ObjectLink_MoneyPlace_Branch.DescId = zc_ObjectLink_Unit_Branch() -- !!!не ошибка!!!*/

             LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                                  ON ObjectLink_Contract_PaidKind.ObjectId = MILinkObject_Contract.ObjectId
                                 AND ObjectLink_Contract_PaidKind.DescId   = zc_ObjectLink_Contract_PaidKind()
             LEFT JOIN ObjectLink AS ObjectLink_Contract_Branch
                                  ON ObjectLink_Contract_Branch.ObjectId = MILinkObject_Contract.ObjectId
                                 AND ObjectLink_Contract_Branch.DescId = zc_ObjectLink_Contract_Branch()
             LEFT JOIN ObjectLink AS ObjectLink_Founder_InfoMoney
                                  ON ObjectLink_Founder_InfoMoney.ChildObjectId = _tmpItem.InfoMoneyId
                                 AND ObjectLink_Founder_InfoMoney.DescId = zc_ObjectLink_Founder_InfoMoney()

             LEFT JOIN Object ON Object.Id = COALESCE (MI_Child.ObjectId, COALESCE (ObjectLink_Founder_InfoMoney.ObjectId, MILinkObject_MoneyPlace.ObjectId))

             LEFT JOIN ObjectLink AS ObjectLink_Unit_Business ON ObjectLink_Unit_Business.ObjectId = MILinkObject_Unit.ObjectId
                                                             AND ObjectLink_Unit_Business.DescId = zc_ObjectLink_Unit_Business()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch ON ObjectLink_Unit_Branch.ObjectId = MILinkObject_Unit.ObjectId
                                                           AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
             LEFT JOIN ObjectLink AS ObjectLink_Cash_Branch ON ObjectLink_Cash_Branch.ObjectId = _tmpItem.ObjectId
                                                           AND ObjectLink_Cash_Branch.DescId = zc_ObjectLink_Cash_Branch()
             LEFT JOIN ObjectLink AS ObjectLink_Cash_Business ON ObjectLink_Cash_Business.ObjectId = _tmpItem.ObjectId
                                                             AND ObjectLink_Cash_Business.DescId   = zc_ObjectLink_Cash_Business()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionDoc
                                     ON ObjectBoolean_PartionDoc.ObjectId = ObjectLink_Cash_Branch.ChildObjectId
                                    AND ObjectBoolean_PartionDoc.DescId = zc_ObjectBoolean_Branch_PartionDoc()

             /*LEFT JOIN ObjectLink AS ObjectLink_Partner_Branch ON ObjectLink_Partner_Branch.ObjectId = MILinkObject_MoneyPlace.ObjectId
                                                              AND ObjectLink_Partner_Branch.DescId = zc_ObjectLink_Unit_Branch() -- !!!не ошибка!!!*/
             LEFT JOIN lfSelect_Object_Unit_byProfitLossDirection() AS lfObject_Unit_byProfitLossDirection ON lfObject_Unit_byProfitLossDirection.UnitId = MILinkObject_Unit.ObjectId
                                                                                                          AND (Object.Id IS NULL -- !!!нужен только для затрат!!!
                                                                                                            OR (_tmpItem.OperDate >= zc_DateStart_Asset() AND _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000())
                                                                                                              )
             LEFT JOIN ObjectLink AS ObjectLink_Partner_Unit ON ObjectLink_Partner_Unit.ObjectId = MILinkObject_MoneyPlace.ObjectId
                                                            AND ObjectLink_Partner_Unit.DescId = zc_ObjectLink_Partner_Unit()
             -- Замена
             LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceListCardSecond
                                  ON ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId      = MI_Child.ObjectId
                                 AND ObjectLink_Personal_PersonalServiceListCardSecond.ChildObjectId = MILinkObject_MoneyPlace.ObjectId
                                 AND ObjectLink_Personal_PersonalServiceListCardSecond.DescId        = zc_ObjectLink_Personal_PersonalServiceListCardSecond()
             LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                  ON ObjectLink_Personal_PersonalServiceList.ObjectId = ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId
                                 AND ObjectLink_Personal_PersonalServiceList.DescId   = zc_ObjectLink_Personal_PersonalServiceList()

             LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_PaidKind
                                  ON ObjectLink_PersonalServiceList_PaidKind.ObjectId      = MILinkObject_MoneyPlace.ObjectId
                                 AND ObjectLink_PersonalServiceList_PaidKind.DescId        = zc_ObjectLink_PersonalServiceList_PaidKind()
             LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_two
                                  ON ObjectLink_PersonalServiceList_two.ObjectId = MI_Child.ObjectId
                                 AND ObjectLink_PersonalServiceList_two.DescId   = zc_ObjectLink_Personal_PersonalServiceList()
                                  -- !!!исключить Ведомость Больничные соц страх БН!!!
                                 AND MILinkObject_MoneyPlace.ObjectId <> 1064330 
                                  -- !!!вот он БН!!!
                                 AND ObjectLink_PersonalServiceList_PaidKind.ChildObjectId = zc_Enum_PaidKind_FirstForm()

             -- перевыставление
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Contract
                                  ON ObjectLink_Unit_Contract.ObjectId = MILinkObject_Unit.ObjectId
                                 AND ObjectLink_Unit_Contract.DescId   = zc_ObjectLink_Unit_Contract()

        -- !!!если НЕ перевыставление!!!
        WHERE ObjectLink_Unit_Contract.ChildObjectId IS NULL


       UNION ALL
        -- 1.2. в балансе - Перевыставление затрат на Юр Лицо
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate

             , COALESCE (ObjectLink_Contract_Juridical.ChildObjectId, 0) AS ObjectId
             , COALESCE (Object.DescId, 0) AS ObjectDescId

             , COALESCE (MI_Child.Amount, -1 * _tmpItem.OperSumm) AS OperSumm
             , CASE -- когда в ОПиУ - Инвестиции, сумму в валюте попробуем провести в "другой" проводке
                    WHEN _tmpItem.OperDate >= zc_DateStart_Asset() AND _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000()
                         THEN 0
                    WHEN Object.DescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND COALESCE (MILinkObject_CurrencyPartner.ObjectId, zc_Enum_Currency_Basis()) <> zc_Enum_Currency_Basis()
                         THEN -1 * _tmpItem.OperSumm_Currency
                    ELSE 0
               END AS OperSumm_Currency
             , 0 AS OperSumm_Asset

             , COALESCE (MI_Child.Id, _tmpItem.MovementItemId)    AS MovementItemId

             , 0 AS ContainerId                                               -- сформируем позже
             , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId   -- сформируем позже

             , 0 AS ProfitLossGroupId, 0 AS ProfitLossDirectionId             -- не используется

               -- Управленческие группы назначения
             , _tmpItem.InfoMoneyGroupId
               -- Управленческие назначения
             , _tmpItem.InfoMoneyDestinationId
               -- Управленческие статьи назначения
             , _tmpItem.InfoMoneyId

               -- Бизнес Баланс: не используется
             , 0 AS BusinessId_Balance
               -- Бизнес ОПиУ: не используется
             , 0 AS BusinessId_ProfitLoss

               -- Главное Юр.лицо всегда из договора
             , COALESCE (ObjectLink_Contract_JuridicalBasis.ChildObjectId, 0) AS JuridicalId_Basis

             , 0 AS UnitId     -- не используется
             , 0 AS PositionId -- не используется

             , 0 AS PersonalServiceListId

               -- Филиал Баланс: всегда "Главный филиал" (нужен для НАЛ долгов)
             , zc_Branch_Basis() AS BranchId_Balance
               -- Филиал ОПиУ: здесь не используется
             , 0 AS BranchId_ProfitLoss

               -- Месяц начислений: не используется
             , 0 AS ServiceDateId
 
             , COALESCE (ObjectLink_Unit_Contract.ChildObjectId, 0) AS ContractId

             , COALESCE (ObjectLink_Contract_PaidKind.ChildObjectId, 0) AS PaidKindId

             , 0 AS PartionMovementId

             , 0 AS AnalyzerId -- не используется

               -- Валюта
             , COALESCE (MILinkObject_CurrencyPartner.ObjectId, zc_Enum_Currency_Basis()) AS CurrencyId

             , MILinkObject_Car.ObjectId AS CarId

             , NOT _tmpItem.IsActive
             , NOT _tmpItem.IsMaster

        FROM _tmpItem
             LEFT JOIN tmpMI_Child AS MI_Child ON MI_Child.MovementId = inMovementId
                                               -- AND MI_Child.DescId = zc_MI_Child()
                                               -- AND MI_Child.isErased = FALSE

             LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                              ON MILinkObject_Unit.MovementItemId = COALESCE (MI_Child.Id, _tmpItem.MovementItemId)
                                             AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Car
                                              ON MILinkObject_Car.MovementItemId = _tmpItem.MovementItemId
                                             AND MILinkObject_Car.DescId = zc_MILinkObject_Car()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_CurrencyPartner
                                              ON MILinkObject_CurrencyPartner.MovementItemId = _tmpItem.MovementItemId
                                             AND MILinkObject_CurrencyPartner.DescId = zc_MILinkObject_CurrencyPartner()

             -- перевыставление
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Contract
                                  ON ObjectLink_Unit_Contract.ObjectId = MILinkObject_Unit.ObjectId
                                 AND ObjectLink_Unit_Contract.DescId   = zc_ObjectLink_Unit_Contract()

             LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical ON ObjectLink_Contract_Juridical.ObjectId = ObjectLink_Unit_Contract.ChildObjectId
                                                                  AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
             LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind ON ObjectLink_Contract_PaidKind.ObjectId = ObjectLink_Unit_Contract.ChildObjectId
                                                                 AND ObjectLink_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()
             LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis ON ObjectLink_Contract_JuridicalBasis.ObjectId = ObjectLink_Unit_Contract.ChildObjectId
                                                                       AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
             LEFT JOIN Object ON Object.Id = ObjectLink_Contract_Juridical.ChildObjectId

        -- !!!если перевыставление!!!
        WHERE ObjectLink_Unit_Contract.ChildObjectId > 0

       UNION ALL
        -- 2. забаланс
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate

             , COALESCE (MI_Child.ObjectId, COALESCE (ObjectLink_Founder_InfoMoney.ObjectId, COALESCE (MILinkObject_MoneyPlace.ObjectId, 0))) AS ObjectId

             , COALESCE (Object.DescId, 0) ObjectDescId

             , 0 AS OperSumm
               -- когда в ОПиУ - Инвестиции, сумму в валюте попробуем провести в "этой" проводке
             , CASE WHEN Object.DescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND COALESCE (MILinkObject_CurrencyPartner.ObjectId, zc_Enum_Currency_Basis()) <> zc_Enum_Currency_Basis()
                         THEN -1 * _tmpItem.OperSumm_Currency
                    ELSE 0
               END AS OperSumm_Currency

             , COALESCE (MI_Child.Amount, -1 * _tmpItem.OperSumm) AS OperSumm_Asset

             , COALESCE (MI_Child.Id, _tmpItem.MovementItemId)    AS MovementItemId

             , 0 AS ContainerId                                               -- сформируем позже
             , 0 AS AccountGroupId, 0 AS AccountDirectionId                   -- сформируем позже
             , CASE WHEN Object.DescId IN (zc_Object_Cash()) AND _tmpItem.ObjectId <> COALESCE (MILinkObject_MoneyPlace.ObjectId, 0)
                     -- AND _tmpItem.CurrencyId <> COALESCE (MILinkObject_CurrencyPartner.ObjectId, zc_Enum_Currency_Basis())
                         THEN zc_Enum_Account_110201() -- Транзит + деньги в пути
                    WHEN Object.DescId IN (zc_Object_BankAccount())
                         THEN zc_Enum_Account_110301() -- Транзит + расчетный счет
                    ELSE 0
               END AS AccountId -- ... или сформируем позже

               -- Группы ОПиУ
             , COALESCE (lfObject_Unit_byProfitLossDirection.ProfitLossGroupId, 0) AS ProfitLossGroupId
               -- Аналитики ОПиУ - направления
             , COALESCE (lfObject_Unit_byProfitLossDirection.ProfitLossDirectionId, 0) AS ProfitLossDirectionId

               -- Управленческие группы назначения
             , _tmpItem.InfoMoneyGroupId
               -- Управленческие назначения
             , _tmpItem.InfoMoneyDestinationId
               -- Управленческие статьи назначения
             , _tmpItem.InfoMoneyId

               -- Бизнес Баланс: всегда из кассы
             , _tmpItem.BusinessId_Balance
               -- Бизнес ОПиУ: ObjectLink_Unit_Business
             , CASE WHEN _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_21502() -- Общефирменные + Маркетинг + Бонусы за мясное сырье
                              -- криво захардкодил
                         THEN (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Business() AND Object.ObjectCode = 2) -- Мясо
                    ELSE COALESCE (ObjectLink_Unit_Business.ChildObjectId, 0)
               END AS BusinessId_ProfitLoss

               -- Главное Юр.лицо всегда из кассы
             , _tmpItem.JuridicalId_Basis

             , COALESCE (MILinkObject_Unit.ObjectId, 0)     AS UnitId
             , COALESCE (MILinkObject_Position.ObjectId, 0) AS PositionId
             , CASE WHEN MI_Child.Id > 0
                         THEN COALESCE (ObjectLink_Personal_PersonalServiceList.ChildObjectId, ObjectLink_PersonalServiceList_two.ChildObjectId, MILinkObject_MoneyPlace.ObjectId, 0)
                    ELSE COALESCE (MLO_PersonalServiceList.ObjectId, 0)
               END AS PersonalServiceListId

               -- Филиал Баланс: всегда из кассы (нужен для НАЛ долгов или долгов подотчета) !!!но для ЗП - как в начислениях!!!
             , CASE WHEN MI_Child.Id > 0
                         THEN COALESCE (ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis())
                    -- если есть - тогда как в договоре
                    WHEN ObjectLink_Contract_Branch.ChildObjectId > 0
                         THEN ObjectLink_Contract_Branch.ChildObjectId
                    WHEN MILinkObject_Unit.ObjectId > 0
                         THEN COALESCE (ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis())
                    -- ELSE COALESCE (ObjectLink_Partner_Branch.ChildObjectId, COALESCE (ObjectLink_MoneyPlace_Branch.ChildObjectId, COALESCE (ObjectLink_Cash_Branch.ChildObjectId, zc_Branch_Basis())))
                    ELSE COALESCE (ObjectLink_Cash_Branch.ChildObjectId, zc_Branch_Basis())
               END AS BranchId_Balance
               -- Филиал ОПиУ: всегда по подразделению !!!но для выплаты ЗП - не используется!!!
             , CASE WHEN MI_Child.Id > 0
                         THEN 0
                    -- если есть - тогда как в договоре
                    WHEN ObjectLink_Contract_Branch.ChildObjectId > 0
                         THEN ObjectLink_Contract_Branch.ChildObjectId

                    ELSE COALESCE (ObjectLink_Unit_Branch.ChildObjectId, 0)

               END AS BranchId_ProfitLoss

               -- Месяц начислений: есть
             , CASE WHEN _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_60000() -- Заработная плата
                         THEN lpInsertFind_Object_ServiceDate (inOperDate:= MIDate_ServiceDate.ValueData)
                    ELSE 0
               END AS ServiceDateId
 
             , COALESCE (MILinkObject_Contract.ObjectId, 0) AS ContractId

             , CASE WHEN -- если Контрагент - "Павильоны" + это Бизнес у кассы - "Павильоны"
                         ObjectLink_Partner_Unit.ChildObjectId > 0
                     AND ObjectLink_Cash_Business.ChildObjectId > 0
                         -- !!!меняется на НАЛ!!!
                         THEN zc_Enum_PaidKind_SecondForm()

                  --WHEN  _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() -- Инвестиции
                  --  AND ObjectLink_Contract_PaidKind.ChildObjectId > 0
                         -- !!!меняется на БН!!!
                  --     THEN ObjectLink_Contract_PaidKind.ChildObjectId

                    ELSE _tmpItem.PaidKindId -- !!!НЕ Всегда НАЛ!!!

               END AS PaidKindId

             , CASE WHEN ObjectBoolean_PartionDoc.ValueData = TRUE
                         THEN lpInsertFind_Object_PartionMovement (MIFloat_MovementId.ValueData :: Integer, NULL)
                    ELSE 0
               END AS PartionMovementId

             , CASE WHEN MI_Child.Id > 0 AND MI_Child.isCalculated = TRUE
                         THEN zc_Enum_AnalyzerId_Cash_PersonalCardSecond() -- Выплата сотруднику - по ведомости Карта БН 2ф.
                    WHEN MI_Child.Id > 0
                         THEN zc_Enum_AnalyzerId_Cash_PersonalService() -- Выплата сотруднику - по ведомости
                    WHEN Object.DescId = zc_Object_Personal()
                         THEN zc_Enum_AnalyzerId_Cash_PersonalAvance() -- Выплата сотруднику - аванс
                    ELSE 0
               END AS AnalyzerId

               -- Валюта
             , COALESCE (MILinkObject_CurrencyPartner.ObjectId, zc_Enum_Currency_Basis()) AS CurrencyId

             , MILinkObject_Car.ObjectId AS CarId

             , NOT _tmpItem.IsActive
             , NOT _tmpItem.IsMaster
        FROM _tmpItem
             LEFT JOIN tmpMI_Child AS MI_Child ON MI_Child.MovementId = inMovementId
                                               -- AND MI_Child.DescId = zc_MI_Child()
                                               -- AND MI_Child.isErased = FALSE

             LEFT JOIN MovementLinkObject AS MLO_PersonalServiceList
                                          ON MLO_PersonalServiceList.MovementId = inMovementId
                                         AND MLO_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()

             LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                         ON MIFloat_MovementId.MovementItemId = _tmpItem.MovementItemId
                                        AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()

             LEFT JOIN MovementItemDate AS MIDate_ServiceDate
                                        ON MIDate_ServiceDate.MovementItemId = COALESCE (MI_Child.Id, _tmpItem.MovementItemId)
                                       AND MIDate_ServiceDate.DescId = zc_MIDate_ServiceDate()

             LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                              ON MILinkObject_MoneyPlace.MovementItemId = _tmpItem.MovementItemId
                                             AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                              ON MILinkObject_Unit.MovementItemId = COALESCE (MI_Child.Id, _tmpItem.MovementItemId)
                                             AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                              ON MILinkObject_Contract.MovementItemId = _tmpItem.MovementItemId
                                             AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                              ON MILinkObject_Position.MovementItemId = COALESCE (MI_Child.Id, _tmpItem.MovementItemId)
                                             AND MILinkObject_Position.DescId = zc_MILinkObject_Position()

             LEFT JOIN MovementItemLinkObject AS MILinkObject_Car
                                              ON MILinkObject_Car.MovementItemId = _tmpItem.MovementItemId
                                             AND MILinkObject_Car.DescId = zc_MILinkObject_Car()

             LEFT JOIN MovementItemLinkObject AS MILinkObject_CurrencyPartner
                                              ON MILinkObject_CurrencyPartner.MovementItemId = _tmpItem.MovementItemId
                                             AND MILinkObject_CurrencyPartner.DescId = zc_MILinkObject_CurrencyPartner()

             /*LEFT JOIN ObjectLink AS ObjectLink_MoneyPlace_Branch ON ObjectLink_MoneyPlace_Branch.ObjectId = MILinkObject_MoneyPlace.ObjectId
                                                                 AND ObjectLink_MoneyPlace_Branch.DescId = zc_ObjectLink_Unit_Branch() -- !!!не ошибка!!!*/

             LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                                  ON ObjectLink_Contract_PaidKind.ObjectId = MILinkObject_Contract.ObjectId
                                 AND ObjectLink_Contract_PaidKind.DescId   = zc_ObjectLink_Contract_PaidKind()
             LEFT JOIN ObjectLink AS ObjectLink_Contract_Branch
                                  ON ObjectLink_Contract_Branch.ObjectId = MILinkObject_Contract.ObjectId
                                 AND ObjectLink_Contract_Branch.DescId = zc_ObjectLink_Contract_Branch()
             LEFT JOIN ObjectLink AS ObjectLink_Founder_InfoMoney
                                  ON ObjectLink_Founder_InfoMoney.ChildObjectId = _tmpItem.InfoMoneyId
                                 AND ObjectLink_Founder_InfoMoney.DescId = zc_ObjectLink_Founder_InfoMoney()

             LEFT JOIN Object ON Object.Id = COALESCE (MI_Child.ObjectId, COALESCE (ObjectLink_Founder_InfoMoney.ObjectId, MILinkObject_MoneyPlace.ObjectId))

             LEFT JOIN ObjectLink AS ObjectLink_Unit_Business ON ObjectLink_Unit_Business.ObjectId = MILinkObject_Unit.ObjectId
                                                             AND ObjectLink_Unit_Business.DescId = zc_ObjectLink_Unit_Business()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch ON ObjectLink_Unit_Branch.ObjectId = MILinkObject_Unit.ObjectId
                                                           AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
             LEFT JOIN ObjectLink AS ObjectLink_Cash_Branch ON ObjectLink_Cash_Branch.ObjectId = _tmpItem.ObjectId
                                                           AND ObjectLink_Cash_Branch.DescId = zc_ObjectLink_Cash_Branch()
             LEFT JOIN ObjectLink AS ObjectLink_Cash_Business ON ObjectLink_Cash_Business.ObjectId = _tmpItem.ObjectId
                                                             AND ObjectLink_Cash_Business.DescId   = zc_ObjectLink_Cash_Business()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionDoc
                                     ON ObjectBoolean_PartionDoc.ObjectId = ObjectLink_Cash_Branch.ChildObjectId
                                    AND ObjectBoolean_PartionDoc.DescId = zc_ObjectBoolean_Branch_PartionDoc()


             /*LEFT JOIN ObjectLink AS ObjectLink_Partner_Branch ON ObjectLink_Partner_Branch.ObjectId = MILinkObject_MoneyPlace.ObjectId
                                                              AND ObjectLink_Partner_Branch.DescId = zc_ObjectLink_Unit_Branch() -- !!!не ошибка!!!*/
             LEFT JOIN lfSelect_Object_Unit_byProfitLossDirection() AS lfObject_Unit_byProfitLossDirection ON lfObject_Unit_byProfitLossDirection.UnitId = MILinkObject_Unit.ObjectId
                                                                                                          AND (Object.Id IS NULL -- !!!нужен только для затрат!!!
                                                                                                            OR (_tmpItem.OperDate >= zc_DateStart_Asset() AND _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000())
                                                                                                              )
             LEFT JOIN ObjectLink AS ObjectLink_Partner_Unit ON ObjectLink_Partner_Unit.ObjectId = MILinkObject_MoneyPlace.ObjectId
                                                            AND ObjectLink_Partner_Unit.DescId = zc_ObjectLink_Partner_Unit()
             -- Замена
             LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceListCardSecond
                                  ON ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId      = MI_Child.ObjectId
                                 AND ObjectLink_Personal_PersonalServiceListCardSecond.ChildObjectId = MILinkObject_MoneyPlace.ObjectId
                                 AND ObjectLink_Personal_PersonalServiceListCardSecond.DescId        = zc_ObjectLink_Personal_PersonalServiceListCardSecond()
             LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                  ON ObjectLink_Personal_PersonalServiceList.ObjectId = ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId
                                 AND ObjectLink_Personal_PersonalServiceList.DescId   = zc_ObjectLink_Personal_PersonalServiceList()

             -- Замена
             LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_PaidKind
                                  ON ObjectLink_PersonalServiceList_PaidKind.ObjectId      = MILinkObject_MoneyPlace.ObjectId
                                 AND ObjectLink_PersonalServiceList_PaidKind.DescId        = zc_ObjectLink_PersonalServiceList_PaidKind()
             LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_two
                                  ON ObjectLink_PersonalServiceList_two.ObjectId           = MI_Child.ObjectId
                                 AND ObjectLink_PersonalServiceList_two.DescId             = zc_ObjectLink_Personal_PersonalServiceList()
                                  -- !!!вот он БН!!!
                                 AND ObjectLink_PersonalServiceList_PaidKind.ChildObjectId = zc_Enum_PaidKind_FirstForm()

        WHERE _tmpItem.OperDate >= zc_DateStart_Asset() AND _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000()
          AND COALESCE (MI_Child.ObjectId, COALESCE (ObjectLink_Founder_InfoMoney.ObjectId, COALESCE (MILinkObject_MoneyPlace.ObjectId, 0))) > 0
       ;

     -- Проверка
     IF EXISTS (SELECT 1 FROM _tmpItem WHERE _tmpItem.IsMaster = FALSE AND _tmpItem.ObjectDescId = 0 AND _tmpItem.InfoMoneyGroupId <> zc_Enum_InfoMoneyGroup_70000())
        AND EXISTS (SELECT 1 FROM ObjectBoolean
                    WHERE ObjectBoolean.DescId = zc_ObjectBoolean_InfoMoney_ProfitLoss()
                      AND ObjectBoolean.ValueData = FALSE
                      AND ObjectBoolean.ObjectId  = (SELECT _tmpItem.InfoMoneyId FROM _tmpItem WHERE _tmpItem.IsMaster = FALSE AND _tmpItem.ObjectDescId = 0 AND _tmpItem.InfoMoneyId > 0 LIMIT 1)
                    )
        AND vbOperDate_currency >= '01.01.2020'
     THEN
         RAISE EXCEPTION 'Ошибка.Для статьи <%> нельзя проводить затраты по оплате.Необходимо заполнить <От кого, кому>.%№ <%> от <%>.'
                        , lfGet_Object_ValueData_sh ((SELECT _tmpItem.InfoMoneyId FROM _tmpItem WHERE _tmpItem.IsMaster = FALSE AND _tmpItem.ObjectDescId = 0 AND _tmpItem.InfoMoneyId > 0 LIMIT 1))
                        , CHR (13)
                        , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                        , (SELECT zfConvert_DateToString (Movement.OperDate) FROM Movement WHERE Movement.Id = inMovementId)
                         ;
     END IF;
     -- Проверка
     IF EXISTS (SELECT 1 FROM _tmpItem WHERE _tmpItem.IsMaster = FALSE AND _tmpItem.ObjectDescId = 0 AND _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() AND _tmpItem.ProfitLossGroupId = 0)
     THEN
         RAISE EXCEPTION 'Ошибка.Для статьи <%> нельзя определить <Административные ОС> или <Производственные ОС>.Необходимо корректно заполнить <Подразделение>.'
                        , lfGet_Object_ValueData_sh ((SELECT _tmpItem.InfoMoneyId FROM _tmpItem WHERE _tmpItem.IsMaster = FALSE AND _tmpItem.ObjectDescId = 0 AND _tmpItem.InfoMoneyId > 0 LIMIT 1))
                         ;
     END IF;


     -- !!!Курсовая разница!!!
     IF (NOT EXISTS (SELECT 1
                    FROM _tmpItem
                         -- если это касса ГРН, тогда надо брать параметры из Master
                         INNER JOIN _tmpItem AS _tmpItem_find ON _tmpItem_find.MovementItemId = _tmpItem.MovementItemId
                                                             AND _tmpItem_find.IsMaster       = FALSE
                                                             AND _tmpItem_find.ObjectDescId   = zc_Object_Cash()
                                                             AND _tmpItem_find.CurrencyId     <> zc_Enum_Currency_Basis()
                    WHERE _tmpItem.IsMaster = TRUE AND _tmpItem.CurrencyId <> zc_Enum_Currency_Basis()
                    --AND _tmpItem.OperSumm > 0
                   )
    AND NOT EXISTS (SELECT 1
                    FROM _tmpItem
                    WHERE _tmpItem.IsMaster = TRUE AND _tmpItem.CurrencyId <> zc_Enum_Currency_Basis()
                      AND _tmpItem.OperSumm > 0
                   )
    AND vbIsCurrency_balance = FALSE
        )
        -- !!!!
        -- OR inMovementId = 28760153
        -- Новая схема - 01.08.2024
        OR (vbIsCurrency_balance = TRUE
        AND vbCashId_to <> 0 AND vbCurrencyId_to = zc_Enum_Currency_Basis() AND vbCurrencyId <> zc_Enum_Currency_Basis() AND vbAmountCurrency < 0
           )


        -- Новая схема - 01.08.2024
        OR (vbIsCurrency_balance = TRUE
        AND EXISTS (SELECT 1
                    FROM _tmpItem
                    WHERE _tmpItem.IsMaster = TRUE AND _tmpItem.CurrencyId <> zc_Enum_Currency_Basis()
                      AND _tmpItem.OperSumm < 0
                   )
           )
   /*OR EXISTS (SELECT 1 FROM _tmpItem WHERE _tmpItem.IsMaster = TRUE AND _tmpItem.OperSumm < 0)
     OR EXISTS (SELECT 1 FROM _tmpItem INNER JOIN Object ON Object.Id = _tmpItem.ObjectId AND Object.DescId = zc_Object_Cash() WHERE _tmpItem.IsMaster = FALSE)
     */ 
        
     THEN
         -- vbSumm_diff + vbSumm_diff_balance
                        WITH tmpItem AS (SELECT _tmpItem.ObjectId AS CashId, _tmpItem.CurrencyId, _tmpItem.OperSumm, _tmpItem.OperSumm_Currency, _tmpItem.OperDate
                                         FROM _tmpItem
                                         WHERE _tmpItem.IsMaster          = TRUE
                                           AND _tmpItem.OperSumm_Currency <> 0
                                         --AND (_tmpItem.OperDate < zc_DateStart_Asset() OR _tmpItem.InfoMoneyGroupId <> zc_Enum_InfoMoneyGroup_70000())
                                        )
             , tmpContainer_grn AS (SELECT Container.Id       AS ContainerId
                                         , Container.ObjectId AS AccountId
                                         , Container.Amount
                                           -- Счет баланса - Курсовая разница
                                         , CASE WHEN View_Account.AccountDirectionId = zc_Enum_AccountDirection_40800()
                                                THEN TRUE
                                                ELSE FALSE
                                           END AS isSumm_diff_balance
                                    FROM tmpItem
                                         INNER JOIN ContainerLinkObject AS CLO_Currency
                                                                        -- по этой валюте
                                                                        ON CLO_Currency.ObjectId = tmpItem.CurrencyId
                                                                       AND CLO_Currency.DescId   = zc_ContainerLinkObject_Currency()
                                         INNER JOIN Container ON Container.Id     = CLO_Currency.ContainerId
                                                             -- учет в ГРН
                                                             AND Container.DescId = zc_Container_Summ()
                                         INNER JOIN Object_Account_View AS View_Account
                                                                        ON View_Account.AccountId      = Container.ObjectId
                                                                       AND View_Account.AccountGroupId = zc_Enum_AccountGroup_40000() -- Денежные средства 
                                         INNER JOIN ContainerLinkObject AS CLO_Cash
                                                                        ON CLO_Cash.ContainerId = CLO_Currency.ContainerId
                                                                       AND CLO_Cash.DescId      = zc_ContainerLinkObject_Cash()
                                                                       -- по этой кассе
                                                                       AND CLO_Cash.ObjectId    = tmpItem.CashId
                                   )
           , tmpMIContainer_grn AS (SELECT tmpContainer_grn.ContainerId, MIContainer.OperDate, MIContainer.MovementItemId, MIContainer.MovementId, SUM (MIContainer.Amount) AS Amount
                                    FROM tmpContainer_grn
                                         LEFT JOIN MovementItemContainer AS MIContainer
                                                                         ON MIContainer.Containerid = tmpContainer_grn.ContainerId
                                                                        -- на конец дня + за сегодня
                                                                        AND MIContainer.OperDate    >= vbOperDate_currency + INTERVAL '1 DAY'
                                    GROUP BY tmpContainer_grn.ContainerId, MIContainer.OperDate, MIContainer.MovementItemId, MIContainer.MovementId
                                   )
                          -- итоговые суммы, по ним - курс
                        , tmpSumm AS (SELECT SUM (tmp.OperSumm_Currency) AS OperSumm_Currency
                                           , SUM (tmp.OperSumm)          AS OperSumm
                                           , SUM (tmp.OperSumm_balance)  AS OperSumm_balance
                                      FROM (-- остаток суммы на дату в Валюте
                                            SELECT tmpContainer.ContainerId
                                                 , tmpContainer.AccountId
                                                 , tmpContainer.Amount - COALESCE (SUM (CASE -- для остатка на конец дня
                                                                                             WHEN MIContainer.OperDate    > vbOperDate_currency + INTERVAL '1 DAY'
                                                                                                  THEN MIContainer.Amount
                                                                                             -- так получим остаток + приход
                                                                                             WHEN MIContainer.OperDate    = vbOperDate_currency + INTERVAL '1 DAY'
                                                                                              AND MIContainer.Amount < 0
                                                                                              AND vbIsCurrency_balance = TRUE
                                                                                              -- и НЕ учредители
                                                                                              AND COALESCE (Object_MoneyPlace.DescId, 0) <> zc_Object_Founder()
                                                                                                  THEN MIContainer.Amount
                                                                                             ELSE 0
                                                                                        END), 0) AS OperSumm_Currency
                                                 , 0 AS OperSumm
                                                 , 0 AS OperSumm_balance
                                            FROM (SELECT Container.ParentId AS ContainerId
                                                       , Container.Id       AS ContainerId_Currency
                                                       , Container.ObjectId AS AccountId
                                                       , Container.Amount
                                                       , tmpItem.OperDate
                                                  FROM tmpItem
                                                       INNER JOIN ContainerLinkObject AS CLO_Currency
                                                                                      -- по этой валюте
                                                                                      ON CLO_Currency.ObjectId = tmpItem.CurrencyId
                                                                                     AND CLO_Currency.DescId   = zc_ContainerLinkObject_Currency()
                                                       INNER JOIN Container ON Container.Id     = CLO_Currency.ContainerId
                                                                           -- валютный учет
                                                                           AND Container.DescId = zc_Container_SummCurrency()
                                                       INNER JOIN Object_Account_View AS View_Account
                                                                                      ON View_Account.AccountId      = Container.ObjectId
                                                                                     AND View_Account.AccountGroupId = zc_Enum_AccountGroup_40000() -- Денежные средства 
                                                       INNER JOIN ContainerLinkObject AS CLO_Cash
                                                                                      ON CLO_Cash.ContainerId = CLO_Currency.ContainerId
                                                                                     AND CLO_Cash.DescId      = zc_ContainerLinkObject_Cash()
                                                                                     -- по этой кассе
                                                                                     AND CLO_Cash.ObjectId    = tmpItem.CashId
                                                 ) AS tmpContainer
                                                 LEFT JOIN MovementItemContainer AS MIContainer
                                                                                 ON MIContainer.Containerid = tmpContainer.ContainerId_Currency
                                                                                -- на начало дня + за сегодня
                                                                                AND MIContainer.OperDate    >= vbOperDate_currency + INTERVAL '1 DAY'
                                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                                                                  ON MILinkObject_MoneyPlace.MovementItemId = MIContainer.MovementItemId
                                                                                 AND MILinkObject_MoneyPlace.DescId         = zc_MILinkObject_MoneyPlace()
                                                 LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = MILinkObject_MoneyPlace.ObjectId

                                            GROUP BY tmpContainer.ContainerId
                                                   , tmpContainer.ContainerId_Currency
                                                   , tmpContainer.AccountId
                                                   , tmpContainer.Amount
                                           UNION ALL
                                            -- остаток суммы на дату в ГРН
                                            SELECT tmpContainer.ContainerId
                                                 , tmpContainer.AccountId
                                                 , 0 AS OperSumm_Currency

                                                 , tmpContainer.Amount - COALESCE (SUM (CASE -- для остатка на конец дня
                                                                                             WHEN MIContainer.OperDate    > vbOperDate_currency + INTERVAL '1 DAY'
                                                                                                  THEN MIContainer.Amount
                                                                                             -- так получим остаток + приход
                                                                                             WHEN MIContainer.OperDate    = vbOperDate_currency + INTERVAL '1 DAY'
                                                                                              -- расход за этот день "вычитается"
                                                                                              AND (MIContainer.Amount < 0
                                                                                                -- или Курсовая разница
                                                                                                OR tmpContainer.isSumm_diff_balance = TRUE
                                                                                                  )
                                                                                              AND vbIsCurrency_balance = TRUE
                                                                                              -- и НЕ учредители
                                                                                              AND COALESCE (Object_MoneyPlace.DescId, 0) <> zc_Object_Founder()
                                                                                                  THEN MIContainer.Amount
                                                                                             ELSE 0
                                                                                        END), 0) AS OperSumm
                                                 , CASE WHEN tmpContainer.isSumm_diff_balance = TRUE
                                                             THEN tmpContainer.Amount - COALESCE (SUM (CASE -- для остатка на конец дня
                                                                                                            WHEN MIContainer.OperDate    > vbOperDate_currency + INTERVAL '1 DAY'
                                                                                                                 THEN MIContainer.Amount
                                                                                                            -- так получим остаток + приход
                                                                                                            WHEN MIContainer.OperDate    = vbOperDate_currency + INTERVAL '1 DAY'
                                                                                                             -- расход за этот день "вычитается"
                                                                                                             AND (MIContainer.Amount < 0
                                                                                                               -- или Курсовая разница
                                                                                                               OR tmpContainer.isSumm_diff_balance = TRUE
                                                                                                                 )
                                                                                                             AND vbIsCurrency_balance = TRUE
                                                                                                             -- и НЕ учредители
                                                                                                             AND COALESCE (Object_MoneyPlace.DescId, 0) <> zc_Object_Founder()
                                                                                                                 THEN MIContainer.Amount
                                                                                                            ELSE 0
                                                                                                       END), 0)
                                                        ELSE 0
                                                   END AS OperSumm_balance

                                            FROM tmpContainer_grn AS tmpContainer
                                                 LEFT JOIN tmpMIContainer_grn AS MIContainer
                                                                              ON MIContainer.Containerid = tmpContainer.ContainerId
                                                                             -- на начало дня + за сегодня
                                                                             AND MIContainer.OperDate    >= vbOperDate_currency + INTERVAL '1 DAY'
                                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                                                                  ON MILinkObject_MoneyPlace.MovementItemId = MIContainer.MovementItemId
                                                                                 AND MILinkObject_MoneyPlace.DescId         = zc_MILinkObject_MoneyPlace()
                                                 LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = MILinkObject_MoneyPlace.ObjectId
                                            GROUP BY tmpContainer.ContainerId
                                                   , tmpContainer.AccountId
                                                   , tmpContainer.Amount
                                                   , tmpContainer.isSumm_diff_balance
                                           ) AS tmp
                                     )
                        -- результат
                        SELECT -- курсовая разница - будет для ОПиУ
                               CASE WHEN tmpSumm.OperSumm_Currency <> 0 AND tmpItem.OperSumm_Currency <> 0 
                                         THEN tmpItem.OperSumm_Currency
                                            * (-- курс клиента
                                               CAST (tmpItem.OperSumm / tmpItem.OperSumm_Currency AS NUMERIC (16,4))
                                               -- МИНУС курс факт в кассе
                                             - CAST (tmpSumm.OperSumm / tmpSumm.OperSumm_Currency AS NUMERIC (16,4))
                                              )
                                    ELSE 0
                               END
                               -- Счет баланса - Курсовая разница
                             , CASE WHEN tmpItem.OperSumm_Currency < 0 AND vbIsCurrency_balance = TRUE AND tmpSumm.OperSumm_Currency <> 0
                                         -- Счет баланса - Курсовая разница
                                         THEN COALESCE (tmpSumm.OperSumm_balance * (tmpItem.OperSumm_Currency / tmpSumm.OperSumm_Currency), 0)
                                    ELSE 0
                               END
                               
                               INTO vbSumm_diff, vbSumm_diff_balance

                        FROM tmpItem
                             CROSS JOIN tmpSumm
                       ;
    
IF inUserId = 5 AND 1=0
THEN
    RAISE EXCEPTION 'Ошибка. vbSumm_diff = <%> <%>', vbSumm_diff, vbSumm_diff_balance;
END IF;

         -- 2.1. курсовая разница - баланс
         INSERT INTO _tmpItem (MovementDescId, OperDate, ObjectId, ObjectDescId, OperSumm, OperSumm_Diff, OperSumm_Asset, OperSumm_Diff_Asset
                             , MovementItemId, ContainerId
                             , AccountGroupId, AccountDirectionId, AccountId
                             , ProfitLossGroupId, ProfitLossDirectionId
                             , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                             , BusinessId_Balance, BusinessId_ProfitLoss, JuridicalId_Basis
                             , UnitId, PositionId, BranchId_Balance, BranchId_ProfitLoss, ServiceDateId, ContractId, PaidKindId
                             , CurrencyId
                             , IsActive, IsMaster
                              )
            -- счет д.средства или д.средства: курсовая разница
            SELECT _tmpItem.MovementDescId
                 , _tmpItem.OperDate
                 , _tmpItem.ObjectId
                 , _tmpItem.ObjectDescId

                 , -1 * COALESCE (vbSumm_diff, 0) - CASE WHEN vbIsCurrency_balance = TRUE THEN COALESCE (vbSumm_diff_balance, 0) ELSE 0 END AS OperSumm
                 , 0                AS OperSumm_Diff

                 , 0 AS OperSumm_Asset
                 , 0 AS OperSumm_Diff_Asset

                 , _tmpItem.MovementItemId
    
                  -- сформируем позже
                 , 0 AS ContainerId                                               
                 , 0 AS AccountGroupId
                   -- сформируем позже
                 , CASE WHEN inMovementId = 28760153 OR vbIsCurrency_balance = TRUE THEN _tmpItem.AccountDirectionId ELSE zc_Enum_AccountDirection_40800() END AS AccountDirectionId -- Курсовая разница
                 , CASE WHEN inMovementId = 28760153 OR vbIsCurrency_balance = TRUE THEN _tmpItem.AccountId          ELSE zc_Enum_Account_40801()          END AS AccountId          -- Курсовая разница
    
                   -- Группы ОПиУ: не используется
                 , 0 AS ProfitLossGroupId
                   -- Аналитики ОПиУ - направления: не используется
                 , 0 AS ProfitLossDirectionId
    
                   -- Управленческие группы назначения: не используется
                 , 0 AS InfoMoneyGroupId
                   -- Управленческие назначения: не используется
                 , 0 AS InfoMoneyDestinationId
                   -- Управленческие статьи назначения: не используется
                 , 0 AS InfoMoneyId
    
                   -- Бизнес Баланс: не используется
                 , 0 AS BusinessId_Balance
                   -- Бизнес ОПиУ: всегда 0
                 , 0 AS BusinessId_ProfitLoss
    
                   -- Главное Юр.лицо: всегда из ...
                 , _tmpItem.JuridicalId_Basis
    
                 , 0 AS UnitId     -- не используется
                 , 0 AS PositionId -- не используется
    
                   -- Филиал Баланс: не используется
                 , 0 AS BranchId_Balance
                 , 0 AS BranchId_ProfitLoss
    
                   -- Месяц начислений: не используется
                 , 0 AS ServiceDateId
    
                 , 0 AS ContractId -- не используется
                 , 0 AS PaidKindId -- не используется
    
--               , zc_Enum_Currency_Basis() AS CurrencyId
                 , _tmpItem.CurrencyId
    
                 , FALSE AS IsActive
                 , FALSE AS IsMaster
            FROM _tmpItem
            WHERE _tmpItem.IsMaster = TRUE
              AND (vbSumm_diff <> 0 OR vbSumm_diff_balance <> 0)

           UNION ALL
            -- счет д.средства - курсовая разница
            SELECT _tmpItem.MovementDescId
                 , _tmpItem.OperDate
                 , _tmpItem.ObjectId
                 , _tmpItem.ObjectDescId

                 ,  1 * vbSumm_diff_balance AS OperSumm
                 , 0                        AS OperSumm_Diff

                 , 0 AS OperSumm_Asset
                 , 0 AS OperSumm_Diff_Asset

                 , _tmpItem.MovementItemId
    
                  -- сформируем позже
                 , 0 AS ContainerId                                               
                 , 0 AS AccountGroupId
                   -- сформируем позже
                 , zc_Enum_AccountDirection_40800() AS AccountDirectionId -- Курсовая разница
                 , zc_Enum_Account_40801()          AS AccountId          -- Курсовая разница
    
                   -- Группы ОПиУ: не используется
                 , 0 AS ProfitLossGroupId
                   -- Аналитики ОПиУ - направления: не используется
                 , 0 AS ProfitLossDirectionId
    
                   -- Управленческие группы назначения: не используется
                 , 0 AS InfoMoneyGroupId
                   -- Управленческие назначения: не используется
                 , 0 AS InfoMoneyDestinationId
                   -- Управленческие статьи назначения: не используется
                 , 0 AS InfoMoneyId
    
                   -- Бизнес Баланс: не используется
                 , 0 AS BusinessId_Balance
                   -- Бизнес ОПиУ: всегда 0
                 , 0 AS BusinessId_ProfitLoss
    
                   -- Главное Юр.лицо: всегда из ...
                 , _tmpItem.JuridicalId_Basis
    
                 , 0 AS UnitId     -- не используется
                 , 0 AS PositionId -- не используется
    
                   -- Филиал Баланс: не используется
                 , 0 AS BranchId_Balance
                 , 0 AS BranchId_ProfitLoss
    
                   -- Месяц начислений: не используется
                 , 0 AS ServiceDateId
    
                 , 0 AS ContractId -- не используется
                 , 0 AS PaidKindId -- не используется
    
--               , zc_Enum_Currency_Basis() AS CurrencyId
                 , _tmpItem.CurrencyId
    
                 , FALSE AS IsActive
                 , FALSE AS IsMaster
            FROM _tmpItem
            WHERE _tmpItem.IsMaster = TRUE
              AND vbSumm_diff_balance <> 0
              AND vbIsCurrency_balance = TRUE

           UNION ALL
            -- 1.2. ОПиУ или счет д.средства - касса
            SELECT _tmpItem.MovementDescId
                 , _tmpItem.OperDate

                 , CASE WHEN inMovementId = 28760153 OR vbIsCurrency_balance = TRUE THEN 0
                        WHEN _tmpItem.ObjectDescId = zc_Object_Cash() AND _tmpItem.CurrencyId <> zc_Enum_Currency_Basis() THEN _tmpItem.ObjectId
                        WHEN _tmpItem.ObjectDescId = zc_Object_Cash() THEN _tmpItem_find.ObjectId
                        ELSE 0     END AS ObjectId

                 , CASE WHEN inMovementId = 28760153 OR vbIsCurrency_balance = TRUE THEN 0
                        WHEN _tmpItem.ObjectDescId = zc_Object_Cash() AND _tmpItem.CurrencyId <> zc_Enum_Currency_Basis() THEN _tmpItem.ObjectDescId
                        WHEN _tmpItem.ObjectDescId = zc_Object_Cash() THEN _tmpItem_find.ObjectDescId
                        ELSE 0 END AS ObjectDescId

                 , CASE WHEN inMovementId = 28760153 OR vbIsCurrency_balance = TRUE THEN  vbSumm_diff else vbSumm_diff END AS OperSumm

                 , CASE when inMovementId = 28760153 OR vbIsCurrency_balance = TRUE THEN 1 * vbSumm_diff
                        WHEN _tmpItem.ObjectDescId = zc_Object_Cash() THEN 0 ELSE 1 * vbSumm_diff
                   END AS OperSumm_Diff

                 , 0 AS OperSumm_Asset
                 , 0 AS OperSumm_Diff_Asset

                 , _tmpItem.MovementItemId
    
                  -- сформируем позже
                 , 0 AS ContainerId                                               
                 , 0 AS AccountGroupId
                   -- сформируем позже
                 , 0 AS AccountDirectionId
                 , 0 AS AccountId
    
                   -- Группы ОПиУ: не используется
                 , 0 AS ProfitLossGroupId
                   -- Аналитики ОПиУ - направления: не используется
                 , 0 AS ProfitLossDirectionId
    
                   -- Управленческие группы назначения: не используется
                 , 0 AS InfoMoneyGroupId
                   -- Управленческие назначения: не используется
                 , 0 AS InfoMoneyDestinationId
                   -- Управленческие статьи назначения: не используется
                 , 0 AS InfoMoneyId
    
                   -- Бизнес Баланс: не используется
                 , 0 AS BusinessId_Balance
                   -- Бизнес ОПиУ: всегда 0
                 , 0 AS BusinessId_ProfitLoss
    
                   -- Главное Юр.лицо: всегда из ...
                 , _tmpItem.JuridicalId_Basis
    
                 , 0 AS UnitId     -- не используется
                 , 0 AS PositionId -- не используется
    
                   -- Филиал Баланс: не используется
                 , 0 AS BranchId_Balance
                 , 0 AS BranchId_ProfitLoss
    
                   -- Месяц начислений: не используется
                 , 0 AS ServiceDateId
    
                 , 0 AS ContractId -- не используется
                 , 0 AS PaidKindId -- не используется
    
--               , zc_Enum_Currency_Basis() AS CurrencyId
                 , CASE WHEN _tmpItem.ObjectDescId = zc_Object_Cash() AND _tmpItem.CurrencyId <> zc_Enum_Currency_Basis() THEN _tmpItem.CurrencyId
                        WHEN _tmpItem.ObjectDescId = zc_Object_Cash() THEN _tmpItem_find.CurrencyId
                        ELSE zc_Enum_Currency_Basis()
                   END AS CurrencyId
    
                 , FALSE AS IsActive
                 , FALSE AS IsMaster
            FROM _tmpItem
                 -- если это касса ГРН, тогда надо брать параметры из Master
                 LEFT JOIN _tmpItem AS _tmpItem_find ON _tmpItem_find.MovementItemId = _tmpItem.MovementItemId
                                                    AND _tmpItem_find.IsMaster       = TRUE
                                                    AND COALESCE (_tmpItem_find.OperSumm_Asset, 0) = 0
            WHERE _tmpItem.IsMaster = FALSE
              AND vbSumm_diff <> 0
              AND COALESCE (_tmpItem.OperSumm_Asset, 0) = 0
           ;

     END IF; -- !!!Курсовая разница!!!

     -- Проверка
     IF inUserId IN (5, zc_Enum_Process_Auto_PrimeCost()) AND 1=0
     -- IF inMovementId = 28760153 
     THEN
         RAISE EXCEPTION 'Ошибка.Admin vbSumm_diff = <%> <%> <%>'
                        , vbSumm_diff, vbSumm_diff_balance, vbCurrencyValue
                         ;
     END IF;

     -- 5.1. ФИНИШ - формируем/сохраняем Проводки
     PERFORM lpComplete_Movement_Finance (inMovementId := inMovementId
                                        , inUserId     := inUserId);

     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Cash()
                                , inUserId     := inUserId
                                 );

END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.09.14                                        * add zc_ObjectLink_Founder_InfoMoney
 09.09.14                                        * add PositionId and ServiceDateId and BusinessId_... and BranchId_...
 17.08.14                                        * add MovementDescId
 25.05.14                                        * add lpComplete_Movement
 10.05.14                                        * add lpInsert_MovementProtocol
 22.01.14                                        * add IsMaster
 28.12.13                                        * rename to zc_ObjectLink_Cash_JuridicalBasis
 26.12.13                                        *
*/

-- тест
-- SELECT * FROM lpUnComplete_Movement (inMovementId:= 3581, inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM gpComplete_Movement_Cash (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpReComplete_Movement_Cash (inMovementId:= 3581, inSession:= zc_Enum_Process_Auto_PrimeCost() :: TvarChar)
