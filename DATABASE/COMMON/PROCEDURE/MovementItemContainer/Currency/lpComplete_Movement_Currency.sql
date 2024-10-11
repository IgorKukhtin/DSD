-- Function: lpComplete_Movement_Currency()

DROP FUNCTION IF EXISTS lpComplete_Movement_Currency (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Currency(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)
 RETURNS VOID
AS
$BODY$
  DECLARE vbOperDate TDateTime;
  DECLARE vbStatusId Integer;
  DECLARE vbCurrencyId Integer;
  DECLARE vbPaidKindId Integer;
  DECLARE vbCurrencyValue TFloat;
  DECLARE vbParValue TFloat;
BEGIN
     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;


     -- Эти параметры нужны для расчета Remains
     SELECT -- считаем на дату позже - для НАЛ, что б получить остаток на конец дня
            CASE WHEN MILinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm() THEN Movement.OperDate + INTERVAL '1 DAY'  ELSE Movement.OperDate END AS OperDate
          , Movement.StatusId                AS StatusId
          , MILinkObject_CurrencyTo.ObjectId AS CurrencyId
          , MILinkObject_PaidKind.ObjectId   AS PaidKindId
          , MovementItem.Amount              AS CurrencyValue
          , MIFloat_ParValue.ValueData       AS ParValue
            INTO vbOperDate, vbStatusId, vbCurrencyId, vbPaidKindId
               , vbCurrencyValue, vbParValue
     FROM Movement
          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                 AND MovementItem.ObjectId = zc_Enum_Currency_Basis()
          LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                      ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                     AND MIFloat_ParValue.DescId = zc_MIFloat_ParValue()
          LEFT JOIN MovementItemLinkObject AS MILinkObject_CurrencyTo
                                           ON MILinkObject_CurrencyTo.MovementItemId = MovementItem.Id
                                          AND MILinkObject_CurrencyTo.DescId = zc_MILinkObject_Currency()
          LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                       ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                      AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
     WHERE Movement.Id = inMovementId
       AND Movement.DescId = zc_Movement_Currency()
       AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());


     -- проверка - один документ в день
     IF EXISTS (SELECT 1
                FROM Movement
                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                            -- с такой же валютой
                                            AND MovementItem.ObjectId = zc_Enum_Currency_Basis()
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_CurrencyTo
                                                      ON MILinkObject_CurrencyTo.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_CurrencyTo.DescId = zc_MILinkObject_Currency()
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                                      ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()

                WHERE Movement.OperDate = CASE WHEN MILinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm() THEN vbOperDate - INTERVAL '1 DAY'  ELSE vbOperDate END
                  AND Movement.DescId = zc_Movement_Currency()
                  AND Movement.StatusId IN (zc_Enum_Status_Complete())
                  -- !!!другой док!!!
                  AND Movement.Id <> inMovementId
                  --
                  AND MILinkObject_CurrencyTo.ObjectId = vbCurrencyId
                  AND MILinkObject_PaidKind.ObjectId   = vbPaidKindId
               )
     THEN
         RAISE EXCEPTION 'Ошибка.Найден документ "Курсовая разница" % № <%> от <%> для <%> + <%>.%Дублирование запрещено.'
                       , CHR (13)
                       , (SELECT Movement.InvNumber
                          FROM Movement
                               INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                      -- с такой же валютой
                                                      AND MovementItem.ObjectId = zc_Enum_Currency_Basis()
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_CurrencyTo
                                                                ON MILinkObject_CurrencyTo.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_CurrencyTo.DescId = zc_MILinkObject_Currency()
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                                                ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
          
                          WHERE Movement.OperDate = CASE WHEN MILinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm() THEN vbOperDate - INTERVAL '1 DAY'  ELSE vbOperDate END
                            AND Movement.DescId = zc_Movement_Currency()
                            AND Movement.StatusId IN (zc_Enum_Status_Complete())
                            -- !!!другой док!!!
                            AND Movement.Id <> inMovementId
                            --
                            AND MILinkObject_CurrencyTo.ObjectId = vbCurrencyId
                            AND MILinkObject_PaidKind.ObjectId   = vbPaidKindId
                          LIMIT 1
                         )
                       , zfConvert_DateToString (vbOperDate)
                       , lfGet_Object_ValueData_sh (vbPaidKindId)
                       , lfGet_Object_ValueData_sh (vbCurrencyId)
                       , CHR (13)
                        ;
     END IF;


     IF vbStatusId <> zc_Enum_Status_Complete()
     THEN
        -- Расчет Remains и запись его в zc_MI_Child
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ContainerId(), tmp.MovementItemId, tmp.ContainerId)
                -- Курсовая разница в ГРН
              , lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), tmp.MovementItemId, tmp.OperSumm_40801)
        FROM
       (SELECT lpInsertUpdate_MovementItem (COALESCE (MovementItem.Id, 0), zc_MI_Child(), COALESCE (tmpSumm.ObjectId, MovementItem.ObjectId), inMovementId
                                          , COALESCE (tmpSumm.OperSumm, 0)
                                          , NULL
                                           ) AS MovementItemId
             , COALESCE (tmpSumm.ContainerId, MovementItem.ContainerId) AS ContainerId
             , COALESCE (tmpSumm.OperSumm_40801, 0) AS OperSumm_40801
        FROM -- существующие элементы
             (SELECT MovementItem.Id, MovementItem.ObjectId, MIFloat_ContainerId.ValueData AS ContainerId
              FROM MovementItem
                   LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                               ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                              AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.DescId     = zc_MI_Child()
             ) AS MovementItem
             -- сумма курсовой разницы в грн
             FULL JOIN (SELECT tmpSumm.ContainerId
                             , tmpSumm.ObjectId
                               -- НЕ Курсовая разница
                             , SUM (CASE WHEN tmpSumm.AccountId <> zc_Enum_Account_40801() THEN tmpSumm.OperSumm ELSE 0 END) AS OperSumm
                               -- Курсовая разница
                             , SUM (CASE WHEN tmpSumm.AccountId = zc_Enum_Account_40801() AND vbOperDate >= '01.09.2024' THEN tmpSumm.OperSumm ELSE 0 END) AS OperSumm_40801

                         FROM -- это остаток суммы на дату в Валюте (их надо перевести в валюту баланса и прибавить)
                              (SELECT tmpContainer.ContainerId
                                    , tmpContainer.AccountId
                                    , tmpContainer.ObjectId
                                    , CAST ((tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0))
                                             -- так переводится в валюту баланса - ГРН
                                           * CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END
                                      AS NUMERIC (16, 2)) AS OperSumm
                               FROM (SELECT Container.ParentId                       AS ContainerId
                                          , ContainerLinkObject_Currency.ContainerId AS ContainerId_Currency
                                          , Container.ObjectId                       AS AccountId
                                          , COALESCE (ContainerLinkObject_Cash.ObjectId, COALESCE (ContainerLinkObject_BankAccount.ObjectId, COALESCE (ContainerLinkObject_Partner.ObjectId, COALESCE (ContainerLinkObject_Juridical.ObjectId, 0)))) AS ObjectId
                                          , ContainerLinkObject_Cash.ObjectId        AS CashId
                                          , Container.Amount
                                     FROM ContainerLinkObject AS ContainerLinkObject_Currency
                                          INNER JOIN Container ON Container.Id      = ContainerLinkObject_Currency.ContainerId
                                                              AND Container.DescId  = zc_Container_SummCurrency()
                                          LEFT JOIN ContainerLinkObject AS ContainerLinkObject_PaidKind
                                                                        ON ContainerLinkObject_PaidKind.ContainerId  = ContainerLinkObject_Currency.ContainerId
                                                                       AND ContainerLinkObject_PaidKind.DescId       = zc_ContainerLinkObject_PaidKind()
                                          LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Cash
                                                                        ON ContainerLinkObject_Cash.ContainerId  = ContainerLinkObject_Currency.ContainerId
                                                                       AND ContainerLinkObject_Cash.DescId       = zc_ContainerLinkObject_Cash()
                                                                       AND vbPaidKindId                          = zc_Enum_PaidKind_SecondForm()
                                          LEFT JOIN ContainerLinkObject AS ContainerLinkObject_BankAccount
                                                                        ON ContainerLinkObject_BankAccount.ContainerId  = ContainerLinkObject_Currency.ContainerId
                                                                       AND ContainerLinkObject_BankAccount.DescId       = zc_ContainerLinkObject_BankAccount()
                                                                       AND vbPaidKindId                                 = zc_Enum_PaidKind_FirstForm()
                                          LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Partner
                                                                        ON ContainerLinkObject_Partner.ContainerId  = ContainerLinkObject_Currency.ContainerId
                                                                       AND ContainerLinkObject_Partner.DescId       = zc_ContainerLinkObject_Partner()
                                                                       AND vbPaidKindId                             = zc_Enum_PaidKind_SecondForm()
                                          LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Juridical
                                                                        ON ContainerLinkObject_Juridical.ContainerId  = ContainerLinkObject_Currency.ContainerId
                                                                       AND ContainerLinkObject_Juridical.DescId       = zc_ContainerLinkObject_Juridical()
                                                                       AND vbPaidKindId                               = zc_Enum_PaidKind_FirstForm()
                                          LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                                                        ON ContainerLinkObject_InfoMoney.ContainerId  = ContainerLinkObject_Currency.ContainerId
                                                                       AND ContainerLinkObject_InfoMoney.DescId       = zc_ContainerLinkObject_InfoMoney()
                                                                       AND vbPaidKindId                               = zc_Enum_PaidKind_SecondForm()
                                          LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ContainerLinkObject_InfoMoney.ObjectId

                                          LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney_two
                                                                        ON ContainerLinkObject_InfoMoney_two.ContainerId  = ContainerLinkObject_Currency.ContainerId
                                                                       AND ContainerLinkObject_InfoMoney_two.DescId       = zc_ContainerLinkObject_InfoMoney()
                                          LEFT JOIN Object_InfoMoney_View AS View_InfoMoney_two ON View_InfoMoney_two.InfoMoneyId = ContainerLinkObject_InfoMoney_two.ObjectId

                                     WHERE ContainerLinkObject_Currency.ObjectId = vbCurrencyId
                                       AND ContainerLinkObject_Currency.DescId   = zc_ContainerLinkObject_Currency()
                                       AND 0 <> COALESCE (ContainerLinkObject_Cash.ObjectId, COALESCE (ContainerLinkObject_BankAccount.ObjectId, COALESCE (ContainerLinkObject_Partner.ObjectId, COALESCE (ContainerLinkObject_Juridical.ObjectId, 0))))
                                       --
                                       AND (((ContainerLinkObject_Juridical.ObjectId <> 0 OR ContainerLinkObject_Partner.ObjectId <> 0)
                                         AND ContainerLinkObject_PaidKind.ObjectId = vbPaidKindId
                                            )
                                        OR (COALESCE (ContainerLinkObject_Juridical.ObjectId, 0) = 0
                                        AND COALESCE (ContainerLinkObject_Partner.ObjectId, 0)   = 0
                                           ))
                                           
                                       -- последний день месяца для Кассы
                                       AND ((ContainerLinkObject_Cash.ObjectId > 0 AND vbOperDate = DATE_TRUNC ('MONTH', vbOperDate))
                                         OR ContainerLinkObject_Cash.ContainerId IS NULL
                                           )
                                       AND ((ContainerLinkObject_Partner.ObjectId > 0 AND vbOperDate = DATE_TRUNC ('MONTH', vbOperDate))
                                         OR ContainerLinkObject_Partner.ContainerId IS NULL
                                         OR vbOperDate < '01.08.2024'
                                           )

                                       AND COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) <> zc_Enum_InfoMoneyDestination_21500() -- Маркетинг
                                       AND COALESCE (View_InfoMoney_two.InfoMoneyGroupId, 0)   <> zc_Enum_InfoMoneyGroup_70000()       -- Инвестиции
                                    ) AS tmpContainer
                                    LEFT JOIN MovementItemContainer AS MIContainer
                                                                    ON MIContainer.Containerid = tmpContainer.ContainerId_Currency
                                                                   AND MIContainer.OperDate    >= vbOperDate
                               GROUP BY tmpContainer.ContainerId
                                      , tmpContainer.ContainerId_Currency
                                      , tmpContainer.AccountId
                                      , tmpContainer.ObjectId
                                      , tmpContainer.Amount

                              UNION ALL
                               -- это остаток суммы на дату в ГРН (их надо вычесть)
                               SELECT tmpContainer.ContainerId
                                    , tmpContainer.AccountId
                                    , tmpContainer.ObjectId
                                    , -1 * (tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0)) AS OperSumm
                               FROM (SELECT ContainerLinkObject_Currency.ContainerId
                                          , Container.ObjectId AS AccountId
                                          , COALESCE (ContainerLinkObject_Cash.ObjectId, COALESCE (ContainerLinkObject_BankAccount.ObjectId, COALESCE (ContainerLinkObject_Partner.ObjectId, COALESCE (ContainerLinkObject_Juridical.ObjectId, 0)))) AS ObjectId
                                          , ContainerLinkObject_Cash.ObjectId AS CashId
                                          , Container.Amount
                                     FROM ContainerLinkObject AS ContainerLinkObject_Currency
                                          INNER JOIN Container ON Container.Id      = ContainerLinkObject_Currency.ContainerId
                                                              AND Container.DescId  = zc_Container_Summ()
                                                              -- !!!без виртуальной курсовой разницы!!!
                                                              -- AND Container.ObjectId <> zc_Enum_Account_40801() -- Курсовая разница
                                          LEFT JOIN ContainerLinkObject AS ContainerLinkObject_PaidKind
                                                                        ON ContainerLinkObject_PaidKind.ContainerId  = ContainerLinkObject_Currency.ContainerId
                                                                       AND ContainerLinkObject_PaidKind.DescId       = zc_ContainerLinkObject_PaidKind()
                                          LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Cash
                                                                        ON ContainerLinkObject_Cash.ContainerId  = ContainerLinkObject_Currency.ContainerId
                                                                       AND ContainerLinkObject_Cash.DescId       = zc_ContainerLinkObject_Cash()
                                                                       AND vbPaidKindId                          = zc_Enum_PaidKind_SecondForm()
                                          LEFT JOIN ContainerLinkObject AS ContainerLinkObject_BankAccount
                                                                        ON ContainerLinkObject_BankAccount.ContainerId = ContainerLinkObject_Currency.ContainerId
                                                                       AND ContainerLinkObject_BankAccount.DescId      = zc_ContainerLinkObject_BankAccount()
                                                                       AND vbPaidKindId                                = zc_Enum_PaidKind_FirstForm()
                                          LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Partner
                                                                        ON ContainerLinkObject_Partner.ContainerId  = ContainerLinkObject_Currency.ContainerId
                                                                       AND ContainerLinkObject_Partner.DescId       = zc_ContainerLinkObject_Partner()
                                                                       AND vbPaidKindId                             = zc_Enum_PaidKind_SecondForm()
                                          LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Juridical
                                                                        ON ContainerLinkObject_Juridical.ContainerId  = ContainerLinkObject_Currency.ContainerId
                                                                       AND ContainerLinkObject_Juridical.DescId       = zc_ContainerLinkObject_Juridical()
                                                                       AND vbPaidKindId                               = zc_Enum_PaidKind_FirstForm()
                                          LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                                                        ON ContainerLinkObject_InfoMoney.ContainerId  = ContainerLinkObject_Currency.ContainerId
                                                                       AND ContainerLinkObject_InfoMoney.DescId       = zc_ContainerLinkObject_InfoMoney()
                                                                       AND vbPaidKindId                               = zc_Enum_PaidKind_SecondForm()
                                          LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ContainerLinkObject_InfoMoney.ObjectId

                                          LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney_two
                                                                        ON ContainerLinkObject_InfoMoney_two.ContainerId  = ContainerLinkObject_Currency.ContainerId
                                                                       AND ContainerLinkObject_InfoMoney_two.DescId       = zc_ContainerLinkObject_InfoMoney()
                                          LEFT JOIN Object_InfoMoney_View AS View_InfoMoney_two ON View_InfoMoney_two.InfoMoneyId = ContainerLinkObject_InfoMoney_two.ObjectId

                                     WHERE ContainerLinkObject_Currency.ObjectId = vbCurrencyId
                                       AND ContainerLinkObject_Currency.DescId  = zc_ContainerLinkObject_Currency()
                                       AND 0 <> COALESCE (ContainerLinkObject_Cash.ObjectId, COALESCE (ContainerLinkObject_BankAccount.ObjectId, COALESCE (ContainerLinkObject_Partner.ObjectId, COALESCE (ContainerLinkObject_Juridical.ObjectId, 0))))
                                       --
                                       AND (((ContainerLinkObject_Juridical.ObjectId <> 0 OR ContainerLinkObject_Partner.ObjectId <> 0)
                                         AND ContainerLinkObject_PaidKind.ObjectId = vbPaidKindId
                                            )
                                        OR (COALESCE (ContainerLinkObject_Juridical.ObjectId, 0) = 0
                                        AND COALESCE (ContainerLinkObject_Partner.ObjectId, 0)   = 0
                                           ))
                                       -- последний день месяца для Кассы
                                       AND ((ContainerLinkObject_Cash.ObjectId > 0 AND vbOperDate = DATE_TRUNC ('MONTH', vbOperDate))
                                         OR ContainerLinkObject_Cash.ContainerId IS NULL
                                           )

                                       AND ((ContainerLinkObject_Partner.ObjectId > 0 AND vbOperDate = DATE_TRUNC ('MONTH', vbOperDate))
                                         OR ContainerLinkObject_Partner.ContainerId IS NULL
                                         OR vbOperDate < '01.08.2024'
                                           )

                                       AND COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) <> zc_Enum_InfoMoneyDestination_21500() -- Маркетинг
                                       AND COALESCE (View_InfoMoney_two.InfoMoneyGroupId, 0)   <> zc_Enum_InfoMoneyGroup_70000()       -- Инвестиции
                                    ) AS tmpContainer
                                    LEFT JOIN MovementItemContainer AS MIContainer
                                                                    ON MIContainer.Containerid = tmpContainer.ContainerId
                                                                   AND MIContainer.OperDate    >= vbOperDate
                               GROUP BY tmpContainer.ContainerId
                                      , tmpContainer.AccountId
                                      , tmpContainer.ObjectId
                                      , tmpContainer.Amount
                              ) AS tmpSumm
                         GROUP BY tmpSumm.ContainerId
                                , tmpSumm.ObjectId
                        ) AS tmpSumm ON tmpSumm.ContainerId = MovementItem.ContainerId
       ) AS tmp;

     END IF; -- if vbStatusId <> zc_Enum_Status_Complete()


     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementDescId, OperDate, ObjectId, ObjectDescId, OperSumm
                         , MovementItemId, ContainerId
                         , AccountGroupId, AccountDirectionId, AccountId
                         , ProfitLossGroupId, ProfitLossDirectionId
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_Balance, BusinessId_ProfitLoss, JuridicalId_Basis
                         , UnitId, PositionId, BranchId_Balance, BranchId_ProfitLoss, ServiceDateId, ContractId, PaidKindId
                         , CurrencyId
                         , IsActive, IsMaster
                          )
        SELECT Movement.DescId
             , Movement.OperDate
             , COALESCE (MovementItem.ObjectId, 0) AS ObjectId
             , COALESCE (Object.DescId, 0)         AS ObjectDescId
             , MovementItem.Amount AS OperSumm
             , MovementItem.Id     AS MovementItemId

             , COALESCE (MIFloat_ContainerId.ValueData, 0) AS ContainerId           -- есть значение
             , 0 AS AccountGroupId, 0 AS AccountDirectionId                         -- не используется
             , COALESCE (Container.ObjectId, 0) AS AccountId                        -- есть значение
             , 0 AS ProfitLossGroupId, 0 AS ProfitLossDirectionId                   -- не используется

               -- Управленческие группы назначения: не используется
             , 0 AS InfoMoneyGroupId
               -- Управленческие назначения: не используется
             , 0 AS InfoMoneyDestinationId
               -- Управленческие статьи назначения: не используется
             , 0 AS InfoMoneyId

               -- Бизнес Баланс: не используется
             , 0 AS BusinessId_Balance
               -- Бизнес ОПиУ: не используется
             , 0 AS BusinessId_ProfitLoss

               -- Главное Юр.лицо: всегда из ...
             , ContainerLinkObject_JuridicalBasis.ObjectId AS JuridicalId_Basis

             , 0 AS UnitId     -- не используется
             , 0 AS PositionId -- не используется

               -- Филиал Баланс: не используется
             , 0 AS BranchId_Balance
               -- Филиал ОПиУ: не используется
             , 0 AS BranchId_ProfitLoss

               -- Месяц начислений: не используется
             , 0 AS ServiceDateId

             , 0 AS ContractId -- не используется
             , 0 AS PaidKindId -- не используется

             , vbCurrencyId AS CurrencyId

             , CASE WHEN MovementItem.Amount >= 0 THEN TRUE ELSE FALSE END AS IsActive
             , TRUE AS IsMaster

        FROM Movement
             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                    AND MovementItem.DescId = zc_MI_Child()
                                    AND MovementItem.Amount <> 0
             LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                         ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                        AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

             --LEFT JOIN Container ON Container.Id      = ContainerLinkObject_Currency.ContainerId
             --                   AND Container.DescId  = zc_Container_Summ()
             --                   -- !!!без виртуальной курсовой разницы!!!
             --                   AND Container.ObjectId <> zc_Enum_Account_40801() -- Курсовая разница

             LEFT JOIN Object ON Object.Id = MovementItem.ObjectId
             LEFT JOIN Container ON Container.Id = MIFloat_ContainerId.ValueData :: Integer
             LEFT JOIN ContainerLinkObject AS ContainerLinkObject_JuridicalBasis
                                           ON ContainerLinkObject_JuridicalBasis.ContainerId = Container.Id
                                          AND ContainerLinkObject_JuridicalBasis.DescId  = zc_ContainerLinkObject_JuridicalBasis()
        WHERE Movement.Id = inMovementId
          AND Movement.DescId = zc_Movement_Currency()
          AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())

       UNION ALL
        -- Счет Курсовая разница
        SELECT Movement.DescId
             , Movement.OperDate
             , COALESCE (MovementItem.ObjectId, 0) AS ObjectId
             , COALESCE (Object.DescId, 0)         AS ObjectDescId
               -- обнуляется Счет
             , 1 * MIFloat_Summ.ValueData AS OperSumm
               --
             , MovementItem.Id     AS MovementItemId

             , COALESCE (MIFloat_ContainerId.ValueData, 0) AS ContainerId           -- есть значение
             , 0 AS AccountGroupId, 0 AS AccountDirectionId                         -- не используется
             , COALESCE (Container.ObjectId, 0) AS AccountId                        -- есть значение
             , 0 AS ProfitLossGroupId, 0 AS ProfitLossDirectionId                   -- не используется

               -- Управленческие группы назначения: не используется
             , 0 AS InfoMoneyGroupId
               -- Управленческие назначения: не используется
             , 0 AS InfoMoneyDestinationId
               -- Управленческие статьи назначения: не используется
             , 0 AS InfoMoneyId

               -- Бизнес Баланс: не используется
             , 0 AS BusinessId_Balance
               -- Бизнес ОПиУ: не используется
             , 0 AS BusinessId_ProfitLoss

               -- Главное Юр.лицо: всегда из ...
             , ContainerLinkObject_JuridicalBasis.ObjectId AS JuridicalId_Basis

             , 0 AS UnitId     -- не используется
             , 0 AS PositionId -- не используется

               -- Филиал Баланс: не используется
             , 0 AS BranchId_Balance
               -- Филиал ОПиУ: не используется
             , 0 AS BranchId_ProfitLoss

               -- Месяц начислений: не используется
             , 0 AS ServiceDateId

             , 0 AS ContractId -- не используется
             , 0 AS PaidKindId -- не используется

             , vbCurrencyId AS CurrencyId

             , TRUE AS IsActive
             , TRUE AS IsMaster

        FROM Movement
             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                    AND MovementItem.DescId     = zc_MI_Child()
             LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                         ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                        AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
             INNER JOIN MovementItemFloat AS MIFloat_Summ
                                          ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                         AND MIFloat_Summ.DescId         = zc_MIFloat_Summ()
                                         AND MIFloat_Summ.ValueData      <> 0

             LEFT JOIN Object ON Object.Id = MovementItem.ObjectId
             INNER JOIN Container ON Container.Id       = MIFloat_ContainerId.ValueData :: Integer
                                 AND Container.ObjectId = zc_Enum_Account_40801() -- Счет Курсовая разница
             LEFT JOIN ContainerLinkObject AS ContainerLinkObject_JuridicalBasis
                                           ON ContainerLinkObject_JuridicalBasis.ContainerId = Container.Id
                                          AND ContainerLinkObject_JuridicalBasis.DescId  = zc_ContainerLinkObject_JuridicalBasis()
        WHERE Movement.Id = inMovementId
          AND Movement.DescId = zc_Movement_Currency()
          AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
       ;


     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementDescId, OperDate, ObjectId, ObjectDescId, OperSumm
                         , MovementItemId, ContainerId, ObjectIntId_Analyzer
                         , AccountGroupId, AccountDirectionId, AccountId
                         , ProfitLossGroupId, ProfitLossDirectionId
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_Balance, BusinessId_ProfitLoss, JuridicalId_Basis
                         , UnitId, PositionId, BranchId_Balance, BranchId_ProfitLoss, ServiceDateId, ContractId, PaidKindId
                         , CurrencyId
                         , IsActive, IsMaster
                          )
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate
             , CASE -- Касса Киев + 
                    WHEN Object.Id =  14686 AND OperDate = '31.07.2024' THEN 0
                    -- новая схема
                    WHEN Object.DescId = zc_Object_Cash() AND OperDate >= '01.09.2024' THEN 0
                    -- новая схема - Счет Курсовая разница
                    WHEN _tmpItem.AccountId = zc_Enum_Account_40801() THEN 0
                    -- 
                    WHEN Object.DescId = zc_Object_Cash() AND OperDate >= '01.08.2019' THEN Object.Id
                    ELSE 0
               END AS ObjectId

             , CASE -- Касса Киев + 
                    WHEN Object.Id =  14686 AND OperDate = '31.07.2024' THEN 0
                    -- новая схема
                    WHEN Object.DescId = zc_Object_Cash() AND OperDate >= '01.09.2024' THEN 0
                    -- новая схема - Счет Курсовая разница
                    WHEN _tmpItem.AccountId = zc_Enum_Account_40801() THEN 0
                    --
                    WHEN Object.DescId = zc_Object_Cash() AND OperDate >= '01.08.2019' THEN Object.DescId
                    ELSE 0
               END AS ObjectDescId

             , -1 * _tmpItem.OperSumm
             , _tmpItem.MovementItemId

              -- сформируем позже
             , 0 AS ContainerId
             , CASE WHEN Object.DescId = zc_Object_Cash() AND OperDate >= '01.08.2019' THEN 0 ELSE _tmpItem.ObjectId END AS ObjectIntId_Analyzer
             , 0 AS AccountGroupId
               -- сформируем позже
             , CASE -- Касса Киев
                    WHEN Object.Id =  14686 AND OperDate = '31.07.2024' THEN 0
                    -- новая схема
                    WHEN Object.DescId = zc_Object_Cash() AND OperDate >= '01.09.2024' THEN 0
                    -- новая схема - Счет Курсовая разница
                    WHEN _tmpItem.AccountId = zc_Enum_Account_40801() THEN 0
                    --
                    WHEN Object.DescId = zc_Object_Cash() AND OperDate >= '01.08.2019' THEN zc_Enum_AccountDirection_40800()  -- Курсовая разница
                    ELSE 0
               END AS AccountDirectionId

             , CASE -- Касса Киев
                    WHEN Object.Id =  14686 AND OperDate = '31.07.2024' THEN 0
                    -- новая схема
                    WHEN Object.DescId = zc_Object_Cash() AND OperDate >= '01.09.2024' THEN 0
                    -- новая схема - Счет Курсовая разница
                    WHEN _tmpItem.AccountId = zc_Enum_Account_40801() THEN 0
                    --
                    WHEN Object.DescId = zc_Object_Cash() AND OperDate >= '01.08.2019' THEN zc_Enum_Account_40801()           -- Курсовая разница
                    ELSE 0
               END AS AccountId

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
             , CASE WHEN Object.DescId = zc_Object_Cash()
                         THEN 0 -- т.е. НЕ ОПиУ
                    WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner())
                     AND View_InfoMoney.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_30000() -- Доходы
                         THEN COALESCE (ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis())
                    ELSE COALESCE (ObjectLink_Unit_Branch.ChildObjectId, 0)
               END AS BranchId_ProfitLoss

               -- Месяц начислений: не используется
             , 0 AS ServiceDateId

             , 0 AS ContractId -- не используется
             , 0 AS PaidKindId -- не используется

             , vbCurrencyId AS CurrencyId

             , NOT _tmpItem.IsActive
             , NOT _tmpItem.IsMaster
        FROM _tmpItem
             LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                           ON CLO_InfoMoney.ContainerId = _tmpItem.ContainerId
                                          AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = CLO_InfoMoney.ObjectId
             -- !!!не ошибка, это действительно св-во юр.лица!!!
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch ON ObjectLink_Unit_Branch.ObjectId = _tmpItem.ObjectId AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
             --
             LEFT JOIN Object ON Object.Id = _tmpItem.ObjectId
       ;


     -- 5.1. ФИНИШ - формируем/сохраняем Проводки
     PERFORM lpComplete_Movement_Finance (inMovementId := inMovementId
                                        , inUserId     := inUserId);

-- RAISE EXCEPTION 'ok' ;
     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Currency()
                                , inUserId     := inUserId
                                 );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 13.11.14                                        *
*/

/*
-- Просмотр данные zc_MI_Child
SELECT MovementItem.Id, MovementItem.ObjectId, MovementItem.Amount,  MIFloat_ContainerId.ValueData AS ContainerId
    , Object.*, Object2.ValueData, Object3.ValueData, Object3.ObjectCode
              FROM MovementItem
                   LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                               ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                              AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
                   join Container on Container.Id = MIFloat_ContainerId.ValueData :: Integer

                                          JOIN ContainerLinkObject AS ContainerLinkObject_Cash
                                                                        ON ContainerLinkObject_Cash.ContainerId  = Container.Id 
                                                                       AND ContainerLinkObject_Cash.DescId       = zc_ContainerLinkObject_Cash()
                                                                       AND ContainerLinkObject_Cash.ObjectId     > 0

                   join Object on  Object.Id = ContainerLinkObject_Cash.ObjectId

                                         left  JOIN ContainerLinkObject AS CLO_Currency
                                                                        -- по этой валюте
                                                                        ON CLO_Currency.ContainerId = Container.Id 
                                                                       AND CLO_Currency.DescId   = zc_ContainerLinkObject_Currency()
                   left join Object as Object2 on  Object2.Id = CLO_Currency.ObjectId

                   left join Object as Object3 on  Object3.Id = Container.ObjectId

              WHERE MovementItem.MovementId = 29391820
                AND MovementItem.DescId     = zc_MI_Child()

order by Object3.ObjectCode
*/

-- тест
-- SELECT * FROM lpComplete_Movement_Currency (inMovementId:= 10154, inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM gpReComplete_Movement_Currency (28780605 , zc_Enum_Process_Auto_PrimeCost() :: TVarChar)
