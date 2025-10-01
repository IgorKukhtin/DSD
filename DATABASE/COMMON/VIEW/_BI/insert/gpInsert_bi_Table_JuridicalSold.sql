-- Function: gpInsert_bi_Table_JuridicalSold

DROP FUNCTION IF EXISTS gpInsert_bi_Table_JuridicalSold (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_bi_Table_JuridicalSold(
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
          DELETE FROM _bi_Table_JuridicalSold WHERE OperDate BETWEEN inStartDate AND inEndDate;
      END IF;


      -- РЕЗУЛЬТАТ
      INSERT INTO _bi_Table_JuridicalSold (--
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
                                           -- Партионный учет
                                         , PartionMovementId

                                           -- Начальный Долг Покупателя - Долг нам
                                         , StartSumm_a
                                           -- Конечный Долг Покупателя - Долг нам
                                         , EndSumm_a
                                           -- Начальный Долг Маркетинг - Долг мы
                                         , StartSumm_p
                                           -- Конечный Долг Маркетинг - Долг мы
                                         , EndSumm_p

                                           -- Debet
                                         , DebetSumm
                                           -- Kredit
                                         , KreditSumm

                                           -- Приход от поставщика - Долг мы
                                         , IncomeSumm_p
                                           -- Возврат поставщику - Долг мы
                                         , ReturnOutSumm_p

                                           -- Продажа (факт без уч. скидки) - Долг нам
                                         , SaleRealSumm_total_a
                                           -- Возврат от пок. (факт без уч. скидки) - Долг нам
                                         , ReturnInRealSumm_total_a
                                           -- Продажа (факт с уч. скидки) - Долг нам
                                         , SaleRealSumm_a
                                           -- Возврат от пок. (факт с уч. скидки) - Долг нам
                                         , ReturnInRealSumm_a

                                           -- Услуги факт оказан. - Долг нам
                                         , ServiceRealSumm_a
                                           -- Услуги факт получ. - Долг мы
                                         , ServiceRealSumm_p
                                           -- Оплата прих - Долг нам
                                         , MoneySumm_a
                                           -- Оплата расх - Долг мы
                                         , MoneySumm_p
                                           -- Корр. цены - Долг нам
                                         , PriceCorrectiveSumm_p
                                           -- Вз-зачет
                                         , SendDebtSumm_a
                                         , SendDebtSumm_p
                                           -- Прочее
                                         , OthSumm_a
                                         , OthSumm_p
                                          )
              -- 1.1. Результат - 30101 - Дебиторы + покупатели + Продукция
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
                   , SUM (tmpReport.StartSumm) AS StartSumm_a
                     -- Конечный Долг Покупателя - Долг нам
                   , SUM (tmpReport.EndSumm)   AS EndSumm_a

                    -- Начальный Долг Маркетинг - Долг мы
                   , 0 AS StartSumm_p
                     -- Конечный Долг Маркетинг - Долг мы
                   , 0 AS EndSumm_p

                     -- Debet
                   , SUM (tmpReport.DebetSumm)   AS DebetSumm
                     -- Kredit
                   , SUM (tmpReport.KreditSumm)  AS KreditSumm

                     -- Приход от поставщика - Долг мы * -1
                   , SUM (tmpReport.IncomeSumm)   AS IncomeSumm_p
                     -- Возврат поставщику - Долг мы
                   , SUM (tmpReport.ReturnOutSumm)   AS ReturnOutSumm_p

                     -- Продажа (факт без уч. скидки) - Долг нам
                   , SUM (tmpReport.SaleRealSumm_total)       AS SaleRealSumm_total_a
                     -- Возврат от пок. (факт без уч. скидки) - Долг нам * -1
                   , SUM (tmpReport.ReturnInRealSumm_total)   AS ReturnInRealSumm_total_a
                     -- Продажа (факт с уч. скидки) - Долг нам
                   , SUM (tmpReport.SaleRealSumm)             AS SaleRealSumm_a
                     -- Возврат от пок. (факт с уч. скидки) - Долг нам * -1
                   , SUM (tmpReport.ReturnInRealSumm)         AS ReturnInRealSumm_a

                     -- Услуги факт оказан. - Долг нам * -1
                   , SUM (CASE WHEN tmpReport.ServiceRealSumm < 0 THEN -1 * tmpReport.ServiceRealSumm ELSE 0 END) AS ServiceRealSumm_a
                     -- Услуги факт получ. - Долг мы
                   , SUM (CASE WHEN tmpReport.ServiceRealSumm > 0 THEN  1 * tmpReport.ServiceRealSumm ELSE 0 END) AS ServiceRealSumm_p

                     -- Оплата прих - Долг нам * -1
                   , SUM (tmpReport.MoneySumm)                AS MoneySumm_a
                     -- Оплата расх - Долг мы
                   , 0                                        AS MoneySumm_p

                     -- Корр. цены - Долг нам
                   , SUM (CASE WHEN tmpReport.PriceCorrectiveSumm > 0 THEN  1 * tmpReport.PriceCorrectiveSumm ELSE 0 END) AS PriceCorrectiveSumm_a
                     -- Корр. цены - Долг мы
                   , SUM (CASE WHEN tmpReport.PriceCorrectiveSumm < 0 THEN -1 * tmpReport.PriceCorrectiveSumm ELSE 0 END) AS PriceCorrectiveSumm_p

                     -- Вз-зачет - Долг нам -1
                   , SUM (CASE WHEN tmpReport.SendDebtSumm < 0 THEN -1 * tmpReport.ServiceRealSumm ELSE 0 END) AS SendDebtSumm_a
                     -- Вз-зачет - Долг мы
                   , SUM (CASE WHEN tmpReport.SendDebtSumm > 0 THEN  1 * tmpReport.ServiceRealSumm ELSE 0 END) AS SendDebtSumm_p

                     -- Прочее - Долг нам
                   , SUM (CASE WHEN tmpReport.ChangeCurrencySumm + tmpReport.OtherSumm + tmpReport.ServiceSumm_pls > 0 THEN  1 * (tmpReport.ChangeCurrencySumm + tmpReport.OtherSumm + tmpReport.ServiceSumm_pls) ELSE 0 END) AS OthSumm_a
                     -- Прочее - Долг мы
                   , SUM (CASE WHEN tmpReport.ChangeCurrencySumm + tmpReport.OtherSumm + tmpReport.ServiceSumm_pls < 0 THEN -1 * (tmpReport.ChangeCurrencySumm + tmpReport.OtherSumm + tmpReport.ServiceSumm_pls) ELSE 0 END) AS OthSumm_p

              FROM lpReport_bi_JuridicalSold (inStartDate              := inStartDate
                                            , inEndDate                := inEndDate
                                              -- 30101 - Дебиторы + покупатели + Продукция
                                            , inAccountId              := zc_Enum_Account_30101()
                                            , inInfoMoneyId            := 0
                                            , inInfoMoneyGroupId       := 0
                                            , inInfoMoneyDestinationId := 0
                                            , inPaidKindId             := 0
                                            , inIsPartionMovement      := FALSE
                                            , inUserId                 := zfCalc_UserAdmin() :: Integer
                                             ) AS tmpReport
              GROUP BY tmpReport.ContainerId
                     , tmpReport.AccountId
                     , tmpReport.OperDate
                     , tmpReport.JuridicalId
                     , tmpReport.PartnerId
                     , tmpReport.InfoMoneyId
                     , tmpReport.ContractId
                     , tmpReport.PaidKindId
                     , tmpReport.BranchId

             UNION ALL
              -- 1.2. Результат - 30102 - Дебиторы + покупатели + Мясное сырье
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
                   , SUM (tmpReport.StartSumm) AS StartSumm_a
                     -- Конечный Долг Покупателя - Долг нам
                   , SUM (tmpReport.EndSumm)   AS EndSumm_a

                    -- Начальный Долг Маркетинг - Долг мы
                   , 0 AS StartSumm_p
                     -- Конечный Долг Маркетинг - Долг мы
                   , 0 AS EndSumm_p

                     -- Debet
                   , SUM (tmpReport.DebetSumm)   AS DebetSumm
                     -- Kredit
                   , SUM (tmpReport.KreditSumm)  AS KreditSumm

                     -- Приход от поставщика - Долг мы * -1
                   , SUM (tmpReport.IncomeSumm)   AS IncomeSumm_p
                     -- Возврат поставщику - Долг мы
                   , SUM (tmpReport.ReturnOutSumm)   AS ReturnOutSumm_p

                     -- Продажа (факт без уч. скидки) - Долг нам
                   , SUM (tmpReport.SaleRealSumm_total)       AS SaleRealSumm_total_a
                     -- Возврат от пок. (факт без уч. скидки) - Долг нам * -1
                   , SUM (tmpReport.ReturnInRealSumm_total)   AS ReturnInRealSumm_total_a
                     -- Продажа (факт с уч. скидки) - Долг нам
                   , SUM (tmpReport.SaleRealSumm)             AS SaleRealSumm_a
                     -- Возврат от пок. (факт с уч. скидки) - Долг нам * -1
                   , SUM (tmpReport.ReturnInRealSumm)         AS ReturnInRealSumm_a

                     -- Услуги факт оказан. - Долг нам * -1
                   , SUM (CASE WHEN tmpReport.ServiceRealSumm < 0 THEN -1 * tmpReport.ServiceRealSumm ELSE 0 END) AS ServiceRealSumm_a
                     -- Услуги факт получ. - Долг мы
                   , SUM (CASE WHEN tmpReport.ServiceRealSumm > 0 THEN  1 * tmpReport.ServiceRealSumm ELSE 0 END) AS ServiceRealSumm_p

                     -- Оплата прих - Долг нам * -1
                   , SUM (tmpReport.MoneySumm)                AS MoneySumm_a
                     -- Оплата расх - Долг мы
                   , 0                                        AS MoneySumm_p

                     -- Корр. цены - Долг нам
                   , SUM (CASE WHEN tmpReport.PriceCorrectiveSumm > 0 THEN  1 * tmpReport.PriceCorrectiveSumm ELSE 0 END) AS PriceCorrectiveSumm_a
                     -- Корр. цены - Долг мы
                   , SUM (CASE WHEN tmpReport.PriceCorrectiveSumm < 0 THEN -1 * tmpReport.PriceCorrectiveSumm ELSE 0 END) AS PriceCorrectiveSumm_p

                     -- Вз-зачет - Долг нам -1
                   , SUM (CASE WHEN tmpReport.SendDebtSumm < 0 THEN -1 * tmpReport.ServiceRealSumm ELSE 0 END) AS SendDebtSumm_a
                     -- Вз-зачет - Долг мы
                   , SUM (CASE WHEN tmpReport.SendDebtSumm > 0 THEN  1 * tmpReport.ServiceRealSumm ELSE 0 END) AS SendDebtSumm_p

                     -- Прочее - Долг нам
                   , SUM (CASE WHEN tmpReport.ChangeCurrencySumm + tmpReport.OtherSumm + tmpReport.ServiceSumm_pls > 0 THEN  1 * (tmpReport.ChangeCurrencySumm + tmpReport.OtherSumm + tmpReport.ServiceSumm_pls) ELSE 0 END) AS OthSumm_a
                     -- Прочее - Долг мы
                   , SUM (CASE WHEN tmpReport.ChangeCurrencySumm + tmpReport.OtherSumm + tmpReport.ServiceSumm_pls < 0 THEN -1 * (tmpReport.ChangeCurrencySumm + tmpReport.OtherSumm + tmpReport.ServiceSumm_pls) ELSE 0 END) AS OthSumm_p

              FROM lpReport_bi_JuridicalSold (inStartDate              := inStartDate
                                            , inEndDate                := inEndDate
                                              -- 30102 - Дебиторы + покупатели + Мясное сырье
                                            , inAccountId              := zc_Enum_Account_30102()
                                            , inInfoMoneyId            := 0
                                            , inInfoMoneyGroupId       := 0
                                            , inInfoMoneyDestinationId := 0
                                            , inPaidKindId             := 0
                                            , inIsPartionMovement      := FALSE
                                            , inUserId                 := zfCalc_UserAdmin() :: Integer
                                             ) AS tmpReport
              GROUP BY tmpReport.ContainerId
                     , tmpReport.AccountId
                     , tmpReport.OperDate
                     , tmpReport.JuridicalId
                     , tmpReport.PartnerId
                     , tmpReport.InfoMoneyId
                     , tmpReport.ContractId
                     , tmpReport.PaidKindId
                     , tmpReport.BranchId

             UNION ALL
              -- 1.3. Результат - 30151 - Дебиторы + покупатели ВЭД + Продукция
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
                   , SUM (tmpReport.StartSumm) AS StartSumm_a
                     -- Конечный Долг Покупателя - Долг нам
                   , SUM (tmpReport.EndSumm)   AS EndSumm_a

                    -- Начальный Долг Маркетинг - Долг мы
                   , 0 AS StartSumm_p
                     -- Конечный Долг Маркетинг - Долг мы
                   , 0 AS EndSumm_p

                     -- Debet
                   , SUM (tmpReport.DebetSumm)   AS DebetSumm
                     -- Kredit
                   , SUM (tmpReport.KreditSumm)  AS KreditSumm

                     -- Приход от поставщика - Долг мы * -1
                   , SUM (tmpReport.IncomeSumm)   AS IncomeSumm_p
                     -- Возврат поставщику - Долг мы
                   , SUM (tmpReport.ReturnOutSumm)   AS ReturnOutSumm_p

                     -- Продажа (факт без уч. скидки) - Долг нам
                   , SUM (tmpReport.SaleRealSumm_total)       AS SaleRealSumm_total_a
                     -- Возврат от пок. (факт без уч. скидки) - Долг нам * -1
                   , SUM (tmpReport.ReturnInRealSumm_total)   AS ReturnInRealSumm_total_a
                     -- Продажа (факт с уч. скидки) - Долг нам
                   , SUM (tmpReport.SaleRealSumm)             AS SaleRealSumm_a
                     -- Возврат от пок. (факт с уч. скидки) - Долг нам * -1
                   , SUM (tmpReport.ReturnInRealSumm)         AS ReturnInRealSumm_a

                     -- Услуги факт оказан. - Долг нам * -1
                   , SUM (CASE WHEN tmpReport.ServiceRealSumm < 0 THEN -1 * tmpReport.ServiceRealSumm ELSE 0 END) AS ServiceRealSumm_a
                     -- Услуги факт получ. - Долг мы
                   , SUM (CASE WHEN tmpReport.ServiceRealSumm > 0 THEN  1 * tmpReport.ServiceRealSumm ELSE 0 END) AS ServiceRealSumm_p

                     -- Оплата прих - Долг нам * -1
                   , SUM (tmpReport.MoneySumm)                AS MoneySumm_a
                     -- Оплата расх - Долг мы
                   , 0                                        AS MoneySumm_p

                     -- Корр. цены - Долг нам
                   , SUM (CASE WHEN tmpReport.PriceCorrectiveSumm > 0 THEN  1 * tmpReport.PriceCorrectiveSumm ELSE 0 END) AS PriceCorrectiveSumm_a
                     -- Корр. цены - Долг мы
                   , SUM (CASE WHEN tmpReport.PriceCorrectiveSumm < 0 THEN -1 * tmpReport.PriceCorrectiveSumm ELSE 0 END) AS PriceCorrectiveSumm_p

                     -- Вз-зачет - Долг нам -1
                   , SUM (CASE WHEN tmpReport.SendDebtSumm < 0 THEN -1 * tmpReport.ServiceRealSumm ELSE 0 END) AS SendDebtSumm_a
                     -- Вз-зачет - Долг мы
                   , SUM (CASE WHEN tmpReport.SendDebtSumm > 0 THEN  1 * tmpReport.ServiceRealSumm ELSE 0 END) AS SendDebtSumm_p

                     -- Прочее - Долг нам
                   , SUM (CASE WHEN tmpReport.ChangeCurrencySumm + tmpReport.OtherSumm + tmpReport.ServiceSumm_pls > 0 THEN  1 * (tmpReport.ChangeCurrencySumm + tmpReport.OtherSumm + tmpReport.ServiceSumm_pls) ELSE 0 END) AS OthSumm_a
                     -- Прочее - Долг мы
                   , SUM (CASE WHEN tmpReport.ChangeCurrencySumm + tmpReport.OtherSumm + tmpReport.ServiceSumm_pls < 0 THEN -1 * (tmpReport.ChangeCurrencySumm + tmpReport.OtherSumm + tmpReport.ServiceSumm_pls) ELSE 0 END) AS OthSumm_p

              FROM lpReport_bi_JuridicalSold (inStartDate              := inStartDate
                                            , inEndDate                := inEndDate
                                              -- 30151 - Дебиторы + покупатели ВЭД + Продукция
                                            , inAccountId              := zc_Enum_Account_30151()
                                            , inInfoMoneyId            := 0
                                            , inInfoMoneyGroupId       := 0
                                            , inInfoMoneyDestinationId := 0
                                            , inPaidKindId             := 0
                                            , inIsPartionMovement      := FALSE
                                            , inUserId                 := zfCalc_UserAdmin() :: Integer
                                             ) AS tmpReport
              GROUP BY tmpReport.ContainerId
                     , tmpReport.AccountId
                     , tmpReport.OperDate
                     , tmpReport.JuridicalId
                     , tmpReport.PartnerId
                     , tmpReport.InfoMoneyId
                     , tmpReport.ContractId
                     , tmpReport.PaidKindId
                     , tmpReport.BranchId

             UNION ALL
              -- 2.1. Результат - БН - 50401 - Расходы будущих периодов + Услуги по маркетингу + Маркетинг
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
                   , 0 AS StartSumm_a
                     -- Конечный Долг Покупателя - Долг нам
                   , 0 AS EndSumm_a

                    -- Начальный Долг Маркетинг - Долг мы
                   , -1 * SUM (tmpReport.StartSumm) AS StartSumm_p
                     -- Конечный Долг Маркетинг - Долг мы
                   , -1 * SUM (tmpReport.EndSumm)   AS EndSumm_p

                     -- Debet
                   , SUM (tmpReport.DebetSumm)   AS DebetSumm
                     -- Kredit
                   , SUM (tmpReport.KreditSumm)  AS KreditSumm

                     -- Приход от поставщика - Долг мы * -1
                   , SUM (tmpReport.IncomeSumm)   AS IncomeSumm_p
                     -- Возврат поставщику - Долг мы
                   , SUM (tmpReport.ReturnOutSumm)   AS ReturnOutSumm_p

                     -- Продажа (факт без уч. скидки) - Долг нам
                   , SUM (tmpReport.SaleRealSumm_total)       AS SaleRealSumm_total_a
                     -- Возврат от пок. (факт без уч. скидки) - Долг нам * -1
                   , SUM (tmpReport.ReturnInRealSumm_total)   AS ReturnInRealSumm_total_a
                     -- Продажа (факт с уч. скидки) - Долг нам
                   , SUM (tmpReport.SaleRealSumm)             AS SaleRealSumm_a
                     -- Возврат от пок. (факт с уч. скидки) - Долг нам * -1
                   , SUM (tmpReport.ReturnInRealSumm)         AS ReturnInRealSumm_a

                     -- Услуги факт оказан. - Долг нам * -1
                   , 0 AS ServiceRealSumm_a
                     -- Услуги факт получ. - Долг мы
                   , SUM (tmpReport.ServiceSumm_pls) AS ServiceRealSumm_p

                     -- Оплата прих - Долг нам * -1
                   , 0                               AS MoneySumm_a
                     -- Оплата расх - Долг мы
                   , -1 * SUM (tmpReport.MoneySumm)  AS MoneySumm_p

                     -- Корр. цены - Долг нам
                   , SUM (CASE WHEN tmpReport.PriceCorrectiveSumm > 0 THEN  1 * tmpReport.PriceCorrectiveSumm ELSE 0 END) AS PriceCorrectiveSumm_a
                     -- Корр. цены - Долг мы
                   , SUM (CASE WHEN tmpReport.PriceCorrectiveSumm < 0 THEN -1 * tmpReport.PriceCorrectiveSumm ELSE 0 END) AS PriceCorrectiveSumm_p

                     -- Вз-зачет - Долг нам -1
                   , SUM (CASE WHEN tmpReport.SendDebtSumm < 0 THEN -1 * tmpReport.ServiceRealSumm ELSE 0 END) AS SendDebtSumm_a
                     -- Вз-зачет - Долг мы
                   , SUM (CASE WHEN tmpReport.SendDebtSumm > 0 THEN  1 * tmpReport.ServiceRealSumm ELSE 0 END) AS SendDebtSumm_p

                     -- Прочее - Долг нам
                   , SUM (CASE WHEN tmpReport.ChangeCurrencySumm + tmpReport.OtherSumm - tmpReport.ServiceRealSumm > 0 THEN  1 * (tmpReport.ChangeCurrencySumm + tmpReport.OtherSumm - tmpReport.ServiceRealSumm) ELSE 0 END) AS OthSumm_a
                     -- Прочее - Долг мы
                   , SUM (CASE WHEN tmpReport.ChangeCurrencySumm + tmpReport.OtherSumm - tmpReport.ServiceRealSumm < 0 THEN -1 * (tmpReport.ChangeCurrencySumm + tmpReport.OtherSumm - tmpReport.ServiceRealSumm) ELSE 0 END) AS OthSumm_p

              FROM lpReport_bi_JuridicalSold (inStartDate              := inStartDate
                                            , inEndDate                := inEndDate
                                              -- БН - 50401 - Расходы будущих периодов + Услуги по маркетингу + Маркетинг
                                            , inAccountId              := zc_Enum_Account_50401()
                                            , inInfoMoneyId            := 0
                                            , inInfoMoneyGroupId       := 0
                                            , inInfoMoneyDestinationId := 0
                                            , inPaidKindId             := 0
                                            , inIsPartionMovement      := FALSE
                                            , inUserId                 := zfCalc_UserAdmin() :: Integer
                                             ) AS tmpReport
              GROUP BY tmpReport.ContainerId
                     , tmpReport.AccountId
                     , tmpReport.OperDate
                     , tmpReport.JuridicalId
                     , tmpReport.PartnerId
                     , tmpReport.InfoMoneyId
                     , tmpReport.ContractId
                     , tmpReport.PaidKindId
                     , tmpReport.BranchId

-- 30101 - Дебиторы + покупатели + Продукция
-- 30102 - Дебиторы + покупатели + Мясное сырье
-- 30151 - Дебиторы + покупатели ВЭД + Продукция

-- БН - 50401 - Расходы будущих периодов + Услуги по маркетингу + Маркетинг
-- НАЛ - 70301 - Услуги по маркетингу	Маркетинг


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
-- DELETE FROM  _bi_Table_JuridicalSold WHERE OperDate between '20.07.2025 9:00' and '20.07.2025 9:10'
-- SELECT OperDate, AccountName_all, sum(StartSumm_a), sum(StartSumm_p)  FROM _bi_Table_JuridicalSold left join _bi_Guide_Account_View on _bi_Guide_Account_View.Id = _bi_Table_JuridicalSold.AccountId where OperDate between '01.09.2025' and '01.09.2025' GROUP BY OperDate, AccountName_all ORDER BY 1 DESC, 2
-- SELECT * FROM gpInsert_bi_Table_JuridicalSold (inStartDate:= '01.09.2025', inEndDate:= '30.09.2025', inSession:= zfCalc_UserAdmin())
