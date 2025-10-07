-- Function: gpInsert_bi_Table_JuridicalDebt

DROP FUNCTION IF EXISTS gpInsert_bi_Table_JuridicalDebt (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_bi_Table_JuridicalDebt(
    IN inStartDate    TDateTime ,
    IN inEndDate      TDateTime ,
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
BEGIN
      -- inStartDate:='01.01.2025';
      --

      IF EXTRACT (HOUR FROM CURRENT_TIMESTAMP) NOT IN (11) OR 1=1
      THEN
          DELETE FROM _bi_Table_JuridicalDebt WHERE OperDate BETWEEN inStartDate AND inEndDate;
      END IF;


      -- РЕЗУЛЬТАТ
      INSERT INTO _bi_Table_JuridicalDebt (--
                                           OperDate
                                           -- Id партии
                                         , ContainerId
                                           -- Счет
                                         , AccountId
                                           -- Юр.л.
                                         , JuridicalId
                                           -- Контрагент
                                         , PartnerId
                                           -- Договор
                                         , ContractId
                                           -- ФО
                                         , PaidKindId
                                           -- УП статья
                                         , InfoMoneyId
                                           -- Филиал
                                         , BranchId

                                           -- Начальный Долг Покупателя
                                         , StartSumm
                                           -- Начальный Долг Покупателя с отсрочкой
                                         , StartSumm_debt
                                           -- Продажа
                                         , SaleSumm

                                           -- Просроченный долг за 1-7 дней
                                         , Summ_debt_7
                                           -- Просроченный долг за 8-14 дней
                                         , Summ_debt_14
                                           -- Просроченный долг за 15-21 дней
                                         , Summ_debt_21
                                           -- Просроченный долг за 22-28 дней
                                         , Summ_debt_28
                                           -- Просроченный долг за 29 и более дней
                                         , Summ_debt_28_add

                                           -- начальная дата просроченного долга
                                         , StartDate_debt
                                           -- Дней отсрочки
                                         , DayCount
                                           -- условие отсрочки
                                         , ConditionKindId
                                          )
              WITH tmpReport AS (SELECT _bi_Table.OperDate
                                      , _bi_Table.ContainerId
                                      , _bi_Table.AccountId
                                      , _bi_Table.JuridicalId
                                      , _bi_Table.PartnerId
                                      , _bi_Table.ContractId
                                      , _bi_Table.PaidKindId
                                      , _bi_Table.InfoMoneyId
                                      , _bi_Table.BranchId
                   
                                        -- Начальный Долг Покупателя
                                      , _bi_Table.StartSumm_a - _bi_Table.EndSumm_a AS StartSumm

                                 FROM _bi_Table_JuridicalSold AS _bi_Table
                                 WHERE _bi_Table.OperDate BETWEEN inStartDate AND inEndDate
                                   AND _bi_Table.AccountId IN (-- 30101 - Дебиторы + покупатели + Продукция
                                                               zc_Enum_Account_30101()
                                                               -- 30102 - Дебиторы + покупатели + Мясное сырье
                                                             , zc_Enum_Account_30102()
                                                               -- 30151 - Дебиторы + покупатели ВЭД + Продукция
                                                             , zc_Enum_Account_30151()
                                                              )
                                )
                           , tmpContract AS (SELECT Object_ContractCondition_View.ContractId
                                                  , Object_ContractCondition_View.ContractConditionKindId
                                                  , Object_ContractCondition_View.Value :: Integer AS DayCount
                                                    -- Первое число месяца
                                                  , tmpReport_list.OperDate
                                       
                                             FROM (SELECT DISTINCT tmpReport.ContractId, DATE_TRUNC ('MONTH', tmpReport.OperDate) AS OperDate FROM tmpReport
                                                  ) AS tmpReport_list
                                                  INNER JOIN Object_ContractCondition_View
                                                          ON Object_ContractCondition_View.ContractId = tmpReport_list.ContractId
                                                         AND Object_ContractCondition_View.ContractConditionKindId IN (zc_Enum_ContractConditionKind_DelayDayCalendar()
                                                                                                                     , zc_Enum_ContractConditionKind_DelayDayBank()
                                                                                                                      )
                                                         AND Object_ContractCondition_View.Value <> 0
                                                         AND tmpReport_list.OperDate BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate
                                            )
              -- Результат - 30101 - Дебиторы + покупатели + Продукция
              SELECT tmpReport.OperDate
                   , tmpReport.ContainerId
                   , tmpReport.AccountId
                   , tmpReport.JuridicalId
                   , tmpReport.PartnerId
                   , tmpReport.ContractId
                   , tmpReport.PaidKindId
                   , tmpReport.InfoMoneyId
                   , tmpReport.BranchId

                     -- Начальный Долг Покупателя - Долг нам
                   , tmpReport.StartSumm
                     -- Начальный Долг Покупателя с отсрочкой
                   , 0 AS StartSumm_debt

                     -- Продажа
                   , 0 AS SaleSumm

                     -- Просроченный долг за 1-7 дней
                   , 0 AS Summ_debt_7
                     -- Просроченный долг за 8-14 дней
                   , 0 AS Summ_debt_14
                     -- Просроченный долг за 15-21 дней
                   , 0 AS Summ_debt_21
                     -- Просроченный долг за 22-28 дней
                   , 0 AS Summ_debt_28
                     -- Просроченный долг за 29 и более дней
                   , 0 AS Summ_debt_28_add

                     -- начальная дата просроченного долга
                   , zfCalc_DetermentPaymentDate (COALESCE (tmpContract.ContractConditionKindId, 0), COALESCE (tmpContract.DayCount, 0), tmpReport.OperDate) :: Date AS StartDate_debt
                     -- Дней отсрочки
                   , COALESCE (tmpContract.DayCount, 0)
                     -- условие отсрочки
                   , COALESCE (tmpContract.ContractConditionKindId, 0)

              FROM tmpReport
                   LEFT JOIN tmpContract ON tmpContract.ContractId = tmpReport.ContractId
                                        AND tmpContract.OperDate   = DATE_TRUNC ('MONTH', tmpReport.OperDate) 
             ;

      -- Сначала обновим Продажи
      UPDATE _bi_Table_JuridicalDebt
       SET -- Продажа
           SaleSumm = (SELECT SUM (_bi_Table_JuridicalSold.SaleSumm_debt)
                       FROM _bi_Table_JuridicalSold
                       WHERE _bi_Table_JuridicalSold.OperDate BETWEEN _bi_Table_JuridicalDebt.StartDate_debt AND _bi_Table_JuridicalSold.OperDate - INTERVAL '1 DAY'
                         AND _bi_Table_JuridicalSold.AccountId   = _bi_Table_JuridicalDebt.AccountId
                         AND _bi_Table_JuridicalSold.JuridicalId = _bi_Table_JuridicalDebt.JuridicalId
                         AND _bi_Table_JuridicalSold.PartnerId   = _bi_Table_JuridicalDebt.PartnerId
                         AND _bi_Table_JuridicalSold.ContractId  = _bi_Table_JuridicalDebt.ContractId
                         AND _bi_Table_JuridicalSold.PaidKindId  = _bi_Table_JuridicalDebt.PaidKindId
                         AND _bi_Table_JuridicalSold.InfoMoneyId = _bi_Table_JuridicalDebt.InfoMoneyId
                         AND _bi_Table_JuridicalSold.BranchId    = _bi_Table_JuridicalDebt.BranchId
                      )

        -- Просроченный долг за 1-7 дней
      , Summ_debt_7 = (SELECT SUM (_bi_Table_JuridicalSold.SaleSumm_debt)
                       FROM _bi_Table_JuridicalSold
                       WHERE _bi_Table_JuridicalSold.OperDate BETWEEN _bi_Table_JuridicalDebt.StartDate_debt - INTERVAL '7 DAY' AND _bi_Table_JuridicalDebt.StartDate_debt - INTERVAL '1 DAY'
                         AND _bi_Table_JuridicalSold.AccountId   = _bi_Table_JuridicalDebt.AccountId
                         AND _bi_Table_JuridicalSold.JuridicalId = _bi_Table_JuridicalDebt.JuridicalId
                         AND _bi_Table_JuridicalSold.PartnerId   = _bi_Table_JuridicalDebt.PartnerId
                         AND _bi_Table_JuridicalSold.ContractId  = _bi_Table_JuridicalDebt.ContractId
                         AND _bi_Table_JuridicalSold.PaidKindId  = _bi_Table_JuridicalDebt.PaidKindId
                         AND _bi_Table_JuridicalSold.InfoMoneyId = _bi_Table_JuridicalDebt.InfoMoneyId
                         AND _bi_Table_JuridicalSold.BranchId    = _bi_Table_JuridicalDebt.BranchId
                      )
       -- Просроченный долг за 8-14 дней
     , Summ_debt_14 = (SELECT SUM (_bi_Table_JuridicalSold.SaleSumm_debt)
                       FROM _bi_Table_JuridicalSold
                       WHERE _bi_Table_JuridicalSold.OperDate BETWEEN _bi_Table_JuridicalDebt.StartDate_debt - INTERVAL '14 DAY' AND _bi_Table_JuridicalDebt.StartDate_debt - INTERVAL '8 DAY'
                         AND _bi_Table_JuridicalSold.AccountId   = _bi_Table_JuridicalDebt.AccountId
                         AND _bi_Table_JuridicalSold.JuridicalId = _bi_Table_JuridicalDebt.JuridicalId
                         AND _bi_Table_JuridicalSold.PartnerId   = _bi_Table_JuridicalDebt.PartnerId
                         AND _bi_Table_JuridicalSold.ContractId  = _bi_Table_JuridicalDebt.ContractId
                         AND _bi_Table_JuridicalSold.PaidKindId  = _bi_Table_JuridicalDebt.PaidKindId
                         AND _bi_Table_JuridicalSold.InfoMoneyId = _bi_Table_JuridicalDebt.InfoMoneyId
                         AND _bi_Table_JuridicalSold.BranchId    = _bi_Table_JuridicalDebt.BranchId
                      )
       -- Просроченный долг за 15-21 дней
     , Summ_debt_21 = (SELECT SUM (_bi_Table_JuridicalSold.SaleSumm_debt)
                       FROM _bi_Table_JuridicalSold
                       WHERE _bi_Table_JuridicalSold.OperDate BETWEEN _bi_Table_JuridicalDebt.StartDate_debt - INTERVAL '21 DAY' AND _bi_Table_JuridicalDebt.StartDate_debt - INTERVAL '15 DAY'
                         AND _bi_Table_JuridicalSold.AccountId   = _bi_Table_JuridicalDebt.AccountId
                         AND _bi_Table_JuridicalSold.JuridicalId = _bi_Table_JuridicalDebt.JuridicalId
                         AND _bi_Table_JuridicalSold.PartnerId   = _bi_Table_JuridicalDebt.PartnerId
                         AND _bi_Table_JuridicalSold.ContractId  = _bi_Table_JuridicalDebt.ContractId
                         AND _bi_Table_JuridicalSold.PaidKindId  = _bi_Table_JuridicalDebt.PaidKindId
                         AND _bi_Table_JuridicalSold.InfoMoneyId = _bi_Table_JuridicalDebt.InfoMoneyId
                         AND _bi_Table_JuridicalSold.BranchId    = _bi_Table_JuridicalDebt.BranchId
                      )
       -- Просроченный долг за 22-28 дней
     , Summ_debt_28 = (SELECT SUM (_bi_Table_JuridicalSold.SaleSumm_debt)
                       FROM _bi_Table_JuridicalSold
                       WHERE _bi_Table_JuridicalSold.OperDate BETWEEN _bi_Table_JuridicalDebt.StartDate_debt - INTERVAL '28 DAY' AND _bi_Table_JuridicalDebt.StartDate_debt - INTERVAL '22 DAY'
                         AND _bi_Table_JuridicalSold.AccountId   = _bi_Table_JuridicalDebt.AccountId
                         AND _bi_Table_JuridicalSold.JuridicalId = _bi_Table_JuridicalDebt.JuridicalId
                         AND _bi_Table_JuridicalSold.PartnerId   = _bi_Table_JuridicalDebt.PartnerId
                         AND _bi_Table_JuridicalSold.ContractId  = _bi_Table_JuridicalDebt.ContractId
                         AND _bi_Table_JuridicalSold.PaidKindId  = _bi_Table_JuridicalDebt.PaidKindId
                         AND _bi_Table_JuridicalSold.InfoMoneyId = _bi_Table_JuridicalDebt.InfoMoneyId
                         AND _bi_Table_JuridicalSold.BranchId    = _bi_Table_JuridicalDebt.BranchId
                      )
      WHERE _bi_Table_JuridicalDebt.OperDate BETWEEN inStartDate AND inEndDate
     ;



      -- Финал - обновим отсрочку
      UPDATE _bi_Table_JuridicalDebt
       SET -- Начальный Долг Покупателя с отсрочкой
           StartSumm_debt = StartSumm - SaleSumm

        -- Просроченный долг за 1-7 дней
      , Summ_debt_7 = CASE WHEN (StartSumm - SaleSumm) > Summ_debt_7 THEN Summ_debt_7 WHEN (StartSumm - SaleSumm) < 0 THEN 0 ELSE (StartSumm - SaleSumm) END

       -- Просроченный долг за 8-14 дней
     , Summ_debt_14 = CASE WHEN (StartSumm - SaleSumm - Summ_debt_7) > Summ_debt_14 THEN Summ_debt_14 WHEN (StartSumm - SaleSumm - Summ_debt_7) < 0 THEN 0 ELSE (StartSumm - SaleSumm - Summ_debt_7) END

       -- Просроченный долг за 15-21 дней
     , Summ_debt_21 = CASE WHEN (StartSumm - SaleSumm - Summ_debt_7 - Summ_debt_14) > Summ_debt_21 THEN Summ_debt_21 WHEN (StartSumm - SaleSumm - Summ_debt_7 - Summ_debt_14) < 0 THEN 0 ELSE (StartSumm - SaleSumm - Summ_debt_7 - Summ_debt_14) END

       -- Просроченный долг за 22-28 дней
     , Summ_debt_28 = CASE WHEN (StartSumm - SaleSumm - Summ_debt_7 - Summ_debt_14 - Summ_debt_21) > Summ_debt_28 THEN Summ_debt_28 WHEN (StartSumm - SaleSumm - Summ_debt_7 - Summ_debt_14 - Summ_debt_21) < 0 THEN 0 ELSE (StartSumm - SaleSumm - Summ_debt_7 - Summ_debt_14 - Summ_debt_28) END

       -- Просроченный долг за 29 и более дней
     , Summ_debt_28_add = CASE WHEN (StartSumm - SaleSumm - Summ_debt_7 - Summ_debt_14 - Summ_debt_21 - Summ_debt_28) > 0 THEN StartSumm - SaleSumm - Summ_debt_7 - Summ_debt_14 - Summ_debt_21 - Summ_debt_28 ELSE 0 END

      WHERE _bi_Table_JuridicalDebt.OperDate BETWEEN inStartDate AND inEndDate
     ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.07.25                                        * all
*/

-- тест
-- DELETE FROM  _bi_Table_JuridicalDebt WHERE OperDate between '20.07.2025 9:00' and '20.07.2025 9:10'
-- SELECT OperDate, AccountName_all, sum(StartSumm), sum(StartSumm_debt)  FROM _bi_Table_JuridicalDebt left join _bi_Guide_Account_View on _bi_Guide_Account_View.Id = _bi_Table_JuridicalDebt.AccountId where OperDate between '01.09.2025' and '01.09.2025' GROUP BY OperDate, AccountName_all ORDER BY 1 DESC, 2
-- SELECT OperDate, AccountName_all, StartDate_debt, DayCount, *  FROM _bi_Table_JuridicalDebt left join _bi_Guide_Account_View on _bi_Guide_Account_View.Id = _bi_Table_JuridicalDebt.AccountId LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = JuridicalId where OperDate between '01.09.2025' and '01.09.2025' AND Object_Juridical.ValueData ilike '%сільпо%' ORDER BY 1 DESC, 2
-- SELECT * FROM gpInsert_bi_Table_JuridicalDebt (inStartDate:= '01.09.2025', inEndDate:= '30.09.2025', inSession:= zfCalc_UserAdmin())
