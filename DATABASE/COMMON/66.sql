-- currency!!!
                        WITH tmpItem AS (SELECT MovementItem.ObjectId AS CashId, MILinkObject_Currency.ObjectId as CurrencyId, MovementItem.Amount as OperSumm
                                              , MovementFloat_AmountCurrency.ValueData as OperSumm_Currency -- , _tmpItem.OperDate
, '06.9.2024' as OperDate
                                         FROM  MovementItem
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                            ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Currency.DescId         = zc_MILinkObject_Currency()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                                            ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_MoneyPlace.DescId         = zc_MILinkObject_MoneyPlace()
             LEFT JOIN MovementFloat AS MovementFloat_AmountCurrency
                                     ON MovementFloat_AmountCurrency.MovementId = MovementItem.MovementId
                                    AND MovementFloat_AmountCurrency.DescId = zc_MovementFloat_AmountCurrency()

                                         WHERE MovementItem.MovementId = 29192188   -- 28927870 
                                           AND MovementItem.DescId = zc_MI_Master()
                                        )
, tmpContainer22 as (SELECT Container.Id       AS ContainerId
                                                       , Container.ObjectId AS AccountId
                                                       , Container.Amount
                                                       , tmpItem.OperDate
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
-- where View_Account.AccountDirectionId <> zc_Enum_AccountDirection_40800() 
                                                 ) 

                          -- итоговые суммы, по ним - курс
                        , tmpSumm AS (SELECT SUM (tmp.OperSumm_Currency) AS OperSumm_Currency
                                           , SUM (tmp.OperSumm)          AS OperSumm
                                           , SUM (tmp.OperSumm_Currency2) AS OperSumm_Currency2
                                           , SUM (tmp.OperSumm2)          AS OperSumm2
                                           , SUM (tmp.OperSumm_balance)  AS OperSumm_balance
                                      FROM (-- остаток суммы на дату в Валюте
                                            SELECT tmpContainer.ContainerId
                                                 , tmpContainer.AccountId
                                                 , tmpContainer.Amount - COALESCE (SUM (CASE -- для остатка на конец дня
                                                                                             WHEN MIContainer.OperDate    > '06.9.2024'
                                                                                                  THEN MIContainer.Amount
                                                                                             -- так получим остаток + приход
                                                                                             WHEN MIContainer.OperDate    = '06.9.2024'
                                                                                              AND MIContainer.Amount < 0
                                                                        -- и НЕ учредители
                                                                        AND COALESCE (Object_MoneyPlace.DescId, 0) <> zc_Object_Founder()
                                                                                                  THEN MIContainer.Amount
                                                                                             ELSE 0
                                                                                        END), 0) AS OperSumm_Currency

                                                 , tmpContainer.Amount - COALESCE (SUM (CASE -- для остатка на конец дня
                                                                                             WHEN MIContainer.OperDate    > '06.9.2024'
                                                                                                  THEN MIContainer.Amount
                                                                                             ELSE 0
                                                                                        END), 0) AS OperSumm_Currency2

                                                 , 0 AS OperSumm
                                                 , 0 AS OperSumm2
                                                 , 0 AS OperSumm_balance
                                            FROM (SELECT Container.ParentId AS ContainerId
                                                       , Container.Id       AS ContainerId_Currency
                                                       , Container.ObjectId AS AccountId
                                                       , Container.Amount
                                                       , tmpItem.OperDate
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
                                                                                AND MIContainer.OperDate    >= '06.9.2024'
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
                                                 , 0                                                            AS OperSumm_Currency
                                                 , 0                                                            AS OperSumm_Currency2
                                                 , tmpContainer.Amount - COALESCE (SUM (CASE -- для остатка на конец дня
                                                                                             WHEN MIContainer.OperDate    > '06.9.2024'
                                                                                                  THEN MIContainer.Amount
                                                                                             -- так получим остаток + приход
                                                                                             WHEN MIContainer.OperDate    = '06.9.2024'
                                                                        -- и НЕ учредители
                                                                        AND COALESCE (Object_MoneyPlace.DescId, 0) <> zc_Object_Founder()
                                                                                              AND (MIContainer.Amount < 0
                                                                          -- или Курсовая разница
                                                                          OR tmpContainer.isSumm_diff_balance = TRUE)

                                                                                                  THEN MIContainer.Amount
                                                                                             ELSE 0
                                                                                        END), 0) AS OperSumm

                                                 , tmpContainer.Amount - COALESCE (SUM (CASE -- для остатка на конец дня
                                                                                             WHEN MIContainer.OperDate    > '06.9.2024'
                                                                                                  THEN MIContainer.Amount
                                                                                             ELSE 0
                                                                                        END), 0) AS OperSumm2

                                                 , CASE WHEN tmpContainer.isSumm_diff_balance = TRUE
                                                             THEN tmpContainer.Amount - COALESCE (SUM (CASE -- для остатка на конец дня
                                                                                                            WHEN MIContainer.OperDate    > '06.9.2024'
                                                                                                                 THEN MIContainer.Amount
                                                                                                            -- так получим остаток + приход
                                                                                                            WHEN MIContainer.OperDate    = '06.9.2024'
                                                                                                             AND (MIContainer.Amount < 0
                                                                          -- или Курсовая разница
                                                                          OR tmpContainer.isSumm_diff_balance = TRUE
)

                                                                        -- и НЕ учредители
                                                                        AND COALESCE (Object_MoneyPlace.DescId, 0) <> zc_Object_Founder()
                                                                                                             AND TRUE = TRUE
                                                                                                                 THEN MIContainer.Amount
                                                                                                            ELSE 0
                                                                                                       END), 0)
                                                        ELSE 0
                                                   END AS OperSumm_balance
-- select 3320738.4450 - 3320352
-- 3430446.5590
                                            FROM (SELECT Container.Id       AS ContainerId
                                                       , Container.ObjectId AS AccountId
                                                       , Container.Amount
                                                       , tmpItem.OperDate
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
 -- vwhere View_Account.AccountDirectionId = zc_Enum_AccountDirection_40800() 
                                                 ) AS tmpContainer
                                                 LEFT JOIN (select MIContainer.OperDate, MIContainer.MovementItemId, MIContainer.MovementId, sum (MIContainer.Amount) as Amount, tmpContainer.ContainerId from tmpContainer22 as tmpContainer join MovementItemContainer AS MIContainer
                                                                                 ON MIContainer.Containerid = tmpContainer.ContainerId
                                                                                -- на начало дня + за сегодня
                                                                                AND MIContainer.OperDate    >= '06.9.2024'
group by MIContainer.MovementItemId, MIContainer.OperDate, MIContainer.MovementId, tmpContainer.ContainerId
) as MIContainer
                                                                                 ON MIContainer.Containerid = tmpContainer.ContainerId
                                                                                -- на начало дня + за сегодня
                                                                                AND MIContainer.OperDate    >= '06.9.2024'

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



-- select * from MovementItemContainer  where Id = 35095988412
-- select * from MovementItemContainer  where MovementId = 29192188 and ContainerId = 1466830

     -- результат
     SELECT 
             tmpSumm.OperSumm  / tmpSumm.OperSumm_Currency
           , tmpSumm.OperSumm2  / tmpSumm.OperSumm_Currency2
           , tmpSumm.OperSumm  , tmpSumm.OperSumm_Currency
           , tmpSumm.OperSumm2  , tmpSumm.OperSumm_Currency2

           , tmpSumm.OperSumm2   - tmpSumm.OperSumm  , tmpSumm.OperSumm_Currency2 - tmpSumm.OperSumm_Currency
           
      FROM tmpItem
          CROSS JOIN tmpSumm
