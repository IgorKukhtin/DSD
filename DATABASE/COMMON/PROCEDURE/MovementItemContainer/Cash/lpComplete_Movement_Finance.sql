-- Function: lpComplete_Movement_Finance (Integer, Boolean)

DROP FUNCTION IF EXISTS lpComplete_Movement_Finance (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Finance(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)                              
RETURNS VOID
AS
$BODY$
BEGIN
     -- Проверка
     IF EXISTS (SELECT SUM (OperSumm + COALESCE (OperSumm_Diff, 0)) FROM _tmpItem /*WHERE MovementDescId = zc_Movement_ProfitLossService()*/ HAVING SUM (OperSumm + COALESCE (OperSumm_Diff, 0)) <> 0)
     THEN
         RAISE EXCEPTION 'Ошибка.В проводке отличаются сумма <Дебет> и сумма <Кредит> : (%) (%)', (SELECT SUM (OperSumm) FROM _tmpItem WHERE IsMaster = TRUE), (SELECT SUM (OperSumm) FROM _tmpItem WHERE IsMaster = FALSE);
     END IF;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! Ну а теперь - ПРОВОДКИ !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

     -- 1.1.1 определяется AccountDirectionId для проводок суммового учета
     UPDATE _tmpItem SET AccountDirectionId =    CASE WHEN _tmpItem.AccountId <> 0
                                                           THEN _tmpItem.AccountDirectionId

                                                      WHEN _tmpItem.ObjectDescId = zc_Object_Founder()
                                                           THEN zc_Enum_AccountDirection_100400() -- Расчеты с участниками
                                                      WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_80300() -- Расчеты с участниками
                                                           THEN zc_Enum_AccountDirection_100400() -- Расчеты с участниками

                                                      WHEN _tmpItem.ObjectDescId = zc_Object_BankAccount()
                                                           THEN zc_Enum_AccountDirection_40300() -- рассчетный счет
                                                      WHEN _tmpItem.ObjectDescId = zc_Object_Cash() AND _tmpItem.PaidKindId = zc_Enum_PaidKind_FirstForm()
                                                           THEN zc_Enum_AccountDirection_40500() -- касса БН

                                                      WHEN _tmpItem.ObjectDescId = zc_Object_Cash() AND _tmpItem.BusinessId_Balance <> 0
                                                           THEN zc_Enum_AccountDirection_40600() -- касса Павильонов

                                                      WHEN _tmpItem.ObjectDescId = zc_Object_Cash() AND ObjectLink_Cash_Branch.ChildObjectId IS NOT NULL
                                                           THEN zc_Enum_AccountDirection_40200() -- касса филиалов
                                                      WHEN _tmpItem.ObjectDescId = zc_Object_Cash() AND ObjectLink_Cash_Branch.ChildObjectId IS NULL
                                                           THEN zc_Enum_AccountDirection_40100() -- касса

                                                      WHEN _tmpItem.ObjectDescId = zc_Object_Member()
                                                           THEN zc_Enum_AccountDirection_30500() -- сотрудники (подотчетные лица)
                                                      WHEN _tmpItem.ObjectDescId = zc_Object_Personal()
                                                           THEN zc_Enum_AccountDirection_70500() -- Заработная плата

                                                      WHEN COALESCE (ObjectBoolean_isCorporate.ValueData, FALSE) = TRUE
                                                           THEN zc_Enum_AccountDirection_30200() -- наши компании
                                                      WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND Constant_InfoMoney_isCorporate_View.InfoMoneyId IS NOT NULL
                                                           THEN zc_Enum_AccountDirection_30200() -- наши компании

                                                      WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30400() -- услуги предоставленные
                                                           THEN zc_Enum_AccountDirection_30300() -- Дебиторы по услугам
                                                      WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_40700() -- Лиол
                                                           THEN zc_Enum_AccountDirection_30400() -- Прочие дебиторы

                                                      WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_30000() -- Доходы
                                                       AND COALESCE (_tmpItem.CurrencyId, zc_Enum_Currency_Basis()) <> zc_Enum_Currency_Basis()
                                                           THEN zc_Enum_AccountDirection_30150() -- покупатели ВЭД
                                                      WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_30000() -- Доходы
                                                           THEN zc_Enum_AccountDirection_30100() -- покупатели

                                                      WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner())
                                                       AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_21400() -- Общефирменные + услуги полученные
                                                                                             , zc_Enum_InfoMoneyDestination_80500() -- Собственный капитал + Прочие
                                                                                              )
                                                           THEN zc_Enum_AccountDirection_70200() -- Кредиторы по услугам
                                                      WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21500() -- Маркетинг
                                                           THEN zc_Enum_AccountDirection_70300() -- Маркетинг
                                                      WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21600() -- Коммунальные услуги
                                                           THEN zc_Enum_AccountDirection_70400() -- Коммунальные услуги
                                                      WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND _tmpItem.InfoMoneyGroupId IN (zc_Enum_InfoMoneyGroup_10000(), zc_Enum_InfoMoneyGroup_20000()) -- Основное сырье; Общефирменные
                                                           THEN zc_Enum_AccountDirection_70100() -- поставщики

                                                      WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70500() -- НМА
                                                           THEN zc_Enum_AccountDirection_70900() -- НМА
                                                      WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() -- Инвестиции
                                                           THEN zc_Enum_AccountDirection_70800() -- Производственные ОС - !!!захардкодил-все сюда, надо будет сделать с подразделением или...!!!

                                                      WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_40100() -- Кредиты банков
                                                           THEN zc_Enum_AccountDirection_80100() -- Кредиты банков
                                                      WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_40200() -- Прочие кредиты
                                                           THEN zc_Enum_AccountDirection_80200() -- Прочие кредиты
                                                      WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_40400() -- проценты по кредитам
                                                           THEN zc_Enum_AccountDirection_80400() -- проценты по кредитам

                                                      WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_41000() -- Покупка/продажа валюты
                                                           THEN zc_Enum_AccountDirection_40700() -- Покупка/продажа валюты

                                                      WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_40000() -- Финансовая деятельность
                                                           THEN zc_Enum_AccountDirection_30400() -- Прочие дебиторы

                                                      WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_50200() -- Налоговые платежи
                                                           THEN zc_Enum_AccountDirection_90100() -- Налоговые платежи
                                                      WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_50300() -- Налоговые платежи (прочие)
                                                           THEN zc_Enum_AccountDirection_90200() -- Налоговые платежи (прочие)
                                                      WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_50100() -- Налоговые платежи по ЗП
                                                           THEN zc_Enum_AccountDirection_90300() -- Налоговые платежи по ЗП
                                                      WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_50400() -- штрафы в бюджет*
                                                          THEN zc_Enum_AccountDirection_90400() -- штрафы в бюджет*

                                                 END
     FROM Object
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = Object.Id
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                              AND Object.DescId = zc_Object_Partner()
          LEFT JOIN ObjectLink AS ObjectLink_Cash_Branch
                               ON ObjectLink_Cash_Branch.ObjectId = Object.Id
                              AND ObjectLink_Cash_Branch.DescId = zc_ObjectLink_Cash_Branch()
                              AND ObjectLink_Cash_Branch.ChildObjectId <> zc_Branch_Basis()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporate
                                  ON ObjectBoolean_isCorporate.ObjectId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, Object.Id)
                                 AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()
          LEFT JOIN ObjectLink AS ObjectLink_Juridical_InfoMoney
                               ON ObjectLink_Juridical_InfoMoney.ObjectId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, Object.Id)
                              AND ObjectLink_Juridical_InfoMoney.DescId = zc_ObjectLink_Juridical_InfoMoney()
          LEFT JOIN Constant_InfoMoney_isCorporate_View ON Constant_InfoMoney_isCorporate_View.InfoMoneyId = ObjectLink_Juridical_InfoMoney.ChildObjectId
          -- LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Juridical_InfoMoney.ChildObjectId
     WHERE Object.Id = _tmpItem.ObjectId;

     -- 1.1.2. определяется AccountGroupId для проводок суммового учета
     UPDATE _tmpItem SET AccountGroupId = View_AccountDirection.AccountGroupId
     FROM Object_AccountDirection_View AS View_AccountDirection
     WHERE View_AccountDirection.AccountDirectionId = _tmpItem.AccountDirectionId;


     -- 1.1.3. определяется Счет для проводок суммового учета
     UPDATE _tmpItem SET AccountId = CASE WHEN _tmpItem.AccountId <> 0
                                               THEN _tmpItem.AccountId
                                          WHEN _tmpItem.ObjectDescId = 0
                                               THEN zc_Enum_Account_100301() -- прибыль текущего периода
                                          -- WHEN _tmpItem.ObjectDescId IN (zc_Object_BankAccount(), zc_Object_Cash()) AND IsMaster = FALSE
                                          --      THEN zc_Enum_Account_110301() -- Транзит + расчетный счет + касса

                                          WHEN _tmpItem.AccountDirectionId = zc_Enum_AccountDirection_100400() -- Расчеты с участниками
                                               THEN zc_Enum_Account_100401() -- Расчеты с участниками

                                          WHEN _tmpItem.AccountDirectionId = zc_Enum_AccountDirection_30200() -- наши компании
                                               THEN CASE (SELECT ObjectLink.ChildObjectId AS InfoMoneyId
                                                          FROM ObjectLink
                                                          WHERE ObjectLink.ObjectId = (SELECT ObjectLink.ChildObjectId AS JuridicalId FROM ObjectLink WHERE ObjectLink.ObjectId = (SELECT Object.Id FROM Object WHERE Object.Id = _tmpItem.ObjectId AND Object.DescId = zc_Object_Partner())
                                                                                                                                                        AND ObjectLink.DescId = zc_ObjectLink_Partner_Juridical()
                                                                                      UNION
                                                                                       SELECT Object.Id AS JuridicalId FROM Object WHERE Object.Id = _tmpItem.ObjectId AND Object.DescId = zc_Object_Juridical()
                                                                                      )
                                                            AND ObjectLink.DescId = zc_ObjectLink_Juridical_InfoMoney()
                                                         )
                                                         WHEN zc_Enum_InfoMoney_20801()
                                                              THEN zc_Enum_Account_30201() -- Алан
                                                         WHEN zc_Enum_InfoMoney_20901()
                                                              THEN zc_Enum_Account_30202() -- Ирна
                                                         WHEN zc_Enum_InfoMoney_21001()
                                                              THEN zc_Enum_Account_30203() -- Чапли
                                                         WHEN zc_Enum_InfoMoney_21101()
                                                              THEN zc_Enum_Account_30204() -- Дворкин
                                                         WHEN zc_Enum_InfoMoney_21151()
                                                              THEN zc_Enum_Account_30205() -- ЕКСПЕРТ-АГРОТРЕЙД
                                                    END
                                          WHEN _tmpItem.AccountDirectionId = zc_Enum_AccountDirection_40300() AND _tmpItem.ObjectId IN (76977 -- рассчетный счет AND 26009000250571 ПУАТ "ФІДОБАНК"
                                                                                                                                      , 76969 -- рассчетный счет AND 26007010192834 ПАТ "БАНК ВОСТОК"
                                                                                                                                       )
                                               THEN zc_Enum_Account_40302() -- рассчетный овердрафт
                                          WHEN _tmpItem.AccountDirectionId = zc_Enum_AccountDirection_40300() AND _tmpItem.CurrencyId <> zc_Enum_Currency_Basis()
                                               THEN zc_Enum_Account_40303() -- расчетный счет валютный
                                          WHEN _tmpItem.AccountDirectionId = zc_Enum_AccountDirection_40300() -- рассчетный счет
                                               THEN zc_Enum_Account_40301() -- рассчетный счет
                                          WHEN _tmpItem.AccountDirectionId = zc_Enum_AccountDirection_40200() -- касса филиалов
                                               THEN zc_Enum_Account_40201() -- касса филиалов + касса
                                          WHEN _tmpItem.AccountDirectionId = zc_Enum_AccountDirection_40100() -- касса
                                               THEN zc_Enum_Account_40101() -- касса + касса
                                          WHEN _tmpItem.AccountDirectionId = zc_Enum_AccountDirection_40500() -- касса БН
                                               THEN zc_Enum_Account_40501() -- касса БН + касса
                                          WHEN _tmpItem.AccountDirectionId = zc_Enum_AccountDirection_40600() -- касса Павильонов
                                               THEN zc_Enum_Account_40601() -- касса Павильонов + касса Павильонов БН

                                          ELSE lpInsertFind_Object_Account (inAccountGroupId         := _tmpItem.AccountGroupId
                                                                          , inAccountDirectionId     := _tmpItem.AccountDirectionId
                                                                          , inInfoMoneyDestinationId := CASE WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_80500() -- Собственный капитал + Прочие
                                                                                                                  -- !!!замена!!!
                                                                                                                  THEN zc_Enum_InfoMoneyDestination_21400() -- Общефирменные + услуги полученные
                                                                                                              ELSE _tmpItem.InfoMoneyDestinationId
                                                                                                        END
                                                                          , inInfoMoneyId            := NULL
                                                                          , inInsert                 := CASE WHEN 1=0
                                                                                                              AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_40700() -- Лиол
                                                                                                              AND _tmpItem.AccountDirectionId = zc_Enum_AccountDirection_30400() -- Прочие дебиторы
                                                                                                                 THEN TRUE
                                                                                                             ELSE FALSE
                                                                                                        END
                                                                          , inUserId                 := inUserId
                                                                           )
                                     END;

     IF EXISTS (SELECT AccountId FROM _tmpItem WHERE COALESCE (AccountId, 0) = 0)
     THEN
         RAISE EXCEPTION 'Ошибка.Счет не определен.Документ № <%> (%)', (SELECT InvNumber FROM Movement WHERE Id = inMovementId), inMovementId;
     END IF;

     -- 1.2.1. определяется ProfitLossDirectionId для проводок суммового учета по счету Прибыль
     UPDATE _tmpItem SET ProfitLossDirectionId = CASE WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_50100() -- Налоговые платежи по ЗП
                                                           THEN zc_Enum_ProfitLossDirection_50400() -- Налоговые платежи по ЗП
                                                      WHEN _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_50201() -- Налог на прибыль
                                                           THEN zc_Enum_ProfitLossDirection_50100() -- Налог на прибыль
                                                      WHEN _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_50202() -- НДС
                                                           THEN zc_Enum_ProfitLossDirection_50200() -- НДС
                                                      WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_50300() -- Налоговые платежи (прочие)
                                                           THEN zc_Enum_ProfitLossDirection_50300() -- Налоговые платежи (прочие)
                                                      WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_50400() -- штрафы в бюджет
                                                           THEN zc_Enum_ProfitLossDirection_50500() -- штрафы в бюджет

                                                      /*WHEN _tmpItem.ProfitLossDirectionId <> 0
                                                           THEN _tmpItem.ProfitLossDirectionId -- если уже был определен
                                                      */

                                                      WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21500() -- Общефирменные + Маркетинг
                                                       AND _tmpItem.UnitId = 0
                                                           THEN zc_Enum_ProfitLossDirection_11100() -- Результат основной деятельности + Маркетинг

                                                      WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30400() -- Доходы + услуги предоставленные
                                                        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30500() -- Доходы + Прочие доходы
                                                        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_40500() -- Финансовая деятельность + Ссуды
                                                        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_40600() -- Финансовая деятельность + Депозиты
                                                           THEN zc_Enum_ProfitLossDirection_70200() -- Дополнительная прибыль + Прочее

                                                      WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_40400() -- Финансовая деятельность + проценты по кредитам
                                                        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_40700() -- Финансовая деятельность + Лиол
                                                        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_40900() -- Финансовая деятельность + Финансовая помощь
                                                           THEN zc_Enum_ProfitLossDirection_80100() -- Расходы с прибыли + Финансовая деятельность

                                                      WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
                                                           THEN zc_Enum_ProfitLossDirection_70400() -- Дополнительная прибыль + Списание кредиторской задолженности

                                                      WHEN _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_30000() -- Доходы
                                                       AND _tmpItem.MovementDescId = zc_Movement_LossDebt()
                                                           THEN zc_Enum_ProfitLossDirection_80300() -- Расходы с прибыли + Списание дебиторской задолженности

                                                      WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_80500() -- Собственный капиталл + Прочие
                                                           THEN zc_Enum_ProfitLossDirection_80400() -- Расходы с прибыли + Прочие


                                                      ELSE _tmpItem.ProfitLossDirectionId
                                                 END
                       , ObjectId = CASE WHEN _tmpItem.ObjectId <> 0 
                                              THEN _tmpItem.ObjectId -- если уже был определен

                                         WHEN _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20700()) -- Общефирменные + Товары
                                              THEN zc_Enum_ProfitLoss_70201() -- Дополнительная прибыль + Прочее + Товары

                                         -- WHEN _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_30000() -- Доходы
                                         WHEN _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_30100(), zc_Enum_InfoMoneyDestination_30200()) -- Доходы + Продукция OR Доходы + Мясное сырье
                                          AND _tmpItem.MovementDescId <> zc_Movement_LossDebt()
                                              THEN zc_Enum_ProfitLoss_10301() -- Результат основной деятельности + Скидка дополнительная + Продукция

                                         WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21500() -- Маркетинг
                                          AND _tmpItem.UnitId = 0
                                              THEN zc_Enum_ProfitLoss_11101() -- Результат основной деятельности + Маркетинг + Продукция

                                         WHEN _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_50201() -- Налог на прибыль
                                              THEN zc_Enum_ProfitLoss_50101() -- Налоги + Налог на прибыль + Налог на прибыль

                                         WHEN _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_50202() -- НДС
                                              THEN zc_Enum_ProfitLoss_50201() -- Налоги + НДС + НДС

                                         ELSE _tmpItem.ObjectId
                                    END
                      , IsActive = FALSE -- !!!всегда по Кредиту!!!
     WHERE _tmpItem.AccountId = zc_Enum_Account_100301(); -- прибыль текущего периода

     -- 1.2.2. определяется ProfitLossGroupId для проводок суммового учета по счету Прибыль
     UPDATE _tmpItem SET ProfitLossGroupId = View_ProfitLossDirection.ProfitLossGroupId
     FROM Object_ProfitLossDirection_View AS View_ProfitLossDirection
     WHERE View_ProfitLossDirection.ProfitLossDirectionId = _tmpItem.ProfitLossDirectionId;

     -- для теста
     -- return;

     -- 1.2.3. определяется ObjectId для проводок суммового учета по счету Прибыль
     UPDATE _tmpItem SET ObjectId = CASE WHEN _tmpItem.MovementDescId = zc_Movement_Currency()
                                              THEN zc_Enum_ProfitLoss_80103() -- Курсовая разница

                                         WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- Инвестиции + Капитальные инвестиции
                                          AND _tmpItem.ProfitLossGroupId IN (zc_Enum_ProfitLossGroup_20000(), zc_Enum_ProfitLossGroup_30000()) -- Общепроизводственные расходы

                                              THEN CASE WHEN _tmpItem.ProfitLossGroupId = zc_Enum_ProfitLossGroup_20000() -- Общепроизводственные расходы
                                                             THEN zc_Enum_ProfitLoss_60201() -- Амортизация + Производственные ОС + Основные средства

                                                        WHEN _tmpItem.ProfitLossGroupId = zc_Enum_ProfitLossGroup_30000() -- Административные расходы
                                                             THEN zc_Enum_ProfitLoss_60101() -- Амортизация + Административные ОС + Основные средства

                                                        ELSE NULL -- !!!Ошибка!!!
                                                   END
                                         ELSE 
                                    lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := CASE WHEN _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() -- Инвестиции
                                                                                                          THEN zc_Enum_ProfitLossGroup_60000() -- Амортизация
                                                                                                     ELSE _tmpItem.ProfitLossGroupId
                                                                                                END
                                                                  , inProfitLossDirectionId  := CASE WHEN _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() -- Инвестиции

                                                                                                          THEN CASE WHEN _tmpItem.ProfitLossGroupId = zc_Enum_ProfitLossGroup_20000() -- Общепроизводственные расходы
                                                                                                                         THEN zc_Enum_ProfitLossDirection_60200() -- Амортизация + Производственные ОС

                                                                                                                    WHEN _tmpItem.ProfitLossGroupId = zc_Enum_ProfitLossGroup_30000() -- Административные расходы
                                                                                                                         THEN zc_Enum_ProfitLossDirection_60100() -- Амортизация + Административные ОС

                                                                                                                    WHEN _tmpItem.ProfitLossGroupId = zc_Enum_ProfitLossGroup_40000() -- Расходы на сбыт
                                                                                                                         THEN zc_Enum_ProfitLossDirection_60100() -- Амортизация + Административные ОС

                                                                                                                    ELSE _tmpItem.ProfitLossDirectionId
                                                                                                              END
                                                                                                     WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21600() -- Общефирменные + Коммунальные услуги
                                                                                                          THEN CASE WHEN _tmpItem.ProfitLossGroupId = zc_Enum_ProfitLossGroup_20000() -- Общепроизводственные расходы
                                                                                                                         THEN zc_Enum_ProfitLossDirection_20700() -- Общепроизводственные расходы + Коммунальные услуги

                                                                                                                    WHEN _tmpItem.ProfitLossGroupId = zc_Enum_ProfitLossGroup_30000() -- Административные расходы
                                                                                                                         THEN zc_Enum_ProfitLossDirection_30400() -- Административные расходы + Коммунальные услуги

                                                                                                                    ELSE _tmpItem.ProfitLossDirectionId
                                                                                                              END
                                                                                                     ELSE _tmpItem.ProfitLossDirectionId
                                                                                                END
                                                                  , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                  , inInfoMoneyId            := NULL
                                                                  , inInsert                 := FALSE
                                                                  , inUserId                 := inUserId
                                                                   )
                                    END
     WHERE _tmpItem.AccountId = zc_Enum_Account_100301() -- прибыль текущего периода
       AND _tmpItem.ObjectId = 0
    ;

     -- 2.1. определяется ContainerId для проводок суммового учета - Суммовой учет
     UPDATE _tmpItem SET ContainerId = CASE WHEN _tmpItem.ContainerId <> 0
                                                 THEN _tmpItem.ContainerId
                                            WHEN _tmpItem.AccountId IN (zc_Enum_Account_110201()  -- Транзит + деньги в пути
                                                                      , zc_Enum_Account_110301()) -- Транзит + расчетный счет + расчетный счет
                                                 THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                            , inParentId          := NULL
                                                                            , inObjectId          := _tmpItem.AccountId
                                                                            , inJuridicalId_basis := _tmpItem.JuridicalId_Basis
                                                                            , inBusinessId        := _tmpItem.BusinessId_Balance
                                                                            , inObjectCostDescId  := NULL
                                                                            , inObjectCostId      := NULL
                                                                            , inDescId_1          := zc_ContainerLinkObject_InfoMoney() -- CASE WHEN _tmpItem.ObjectDescId = zc_Object_BankAccount() THEN zc_ContainerLinkObject_BankAccount() WHEN _tmpItem.ObjectDescId = zc_Object_Cash() THEN zc_ContainerLinkObject_Cash() ELSE -1 END
                                                                            , inObjectId_1        := _tmpItem.InfoMoneyId -- _tmpItem.ObjectId
                                                                             )
                                            WHEN _tmpItem.AccountId IN (zc_Enum_Account_110302()) -- Транзит + расчетный счет + валютный
                                                 THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                            , inParentId          := NULL
                                                                            , inObjectId          := _tmpItem.AccountId
                                                                            , inJuridicalId_basis := _tmpItem.JuridicalId_Basis
                                                                            , inBusinessId        := _tmpItem.BusinessId_Balance
                                                                            , inObjectCostDescId  := NULL
                                                                            , inObjectCostId      := NULL
                                                                            , inDescId_1          := CASE WHEN _tmpItem.AccountDirectionId IN (zc_Enum_AccountDirection_40100()
                                                                                                                                             , zc_Enum_AccountDirection_40200()
                                                                                                                                             , zc_Enum_AccountDirection_40500()
                                                                                                                                             , zc_Enum_AccountDirection_40600()
                                                                                                                                              )
                                                                                                               THEN zc_ContainerLinkObject_Cash()
                                                                                                          ELSE zc_ContainerLinkObject_BankAccount()
                                                                                                     END
                                                                            , inObjectId_1        := CASE WHEN _tmpItem.IsActive = FALSE THEN _tmpItem.ObjectId ELSE (SELECT ObjectId FROM _tmpItem WHERE IsActive = FALSE) END
                                                                            , inDescId_2          := zc_ContainerLinkObject_Currency()
                                                                            , inObjectId_2        := _tmpItem.CurrencyId
                                                                             )
                                            WHEN _tmpItem.AccountGroupId = zc_Enum_AccountGroup_40000() -- Денежные средства
                                                 THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                            , inParentId          := NULL
                                                                            , inObjectId          := _tmpItem.AccountId
                                                                            , inJuridicalId_basis := _tmpItem.JuridicalId_Basis
                                                                            , inBusinessId        := _tmpItem.BusinessId_Balance
                                                                            , inObjectCostDescId  := NULL
                                                                            , inObjectCostId      := NULL
                                                                            , inDescId_1          := CASE WHEN _tmpItem.AccountDirectionId IN (zc_Enum_AccountDirection_40100()
                                                                                                                                             , zc_Enum_AccountDirection_40200()
                                                                                                                                             , zc_Enum_AccountDirection_40500()
                                                                                                                                             , zc_Enum_AccountDirection_40600()
                                                                                                                                              )
                                                                                                               THEN zc_ContainerLinkObject_Cash()
                                                                                                          ELSE zc_ContainerLinkObject_BankAccount()
                                                                                                     END
                                                                            , inObjectId_1        := _tmpItem.ObjectId
                                                                            , inDescId_2          := CASE WHEN COALESCE (_tmpItem.CurrencyId, zc_Enum_Currency_Basis()) = zc_Enum_Currency_Basis() THEN NULL ELSE zc_ContainerLinkObject_Currency() END
                                                                            , inObjectId_2        := CASE WHEN COALESCE (_tmpItem.CurrencyId, zc_Enum_Currency_Basis()) = zc_Enum_Currency_Basis() THEN NULL ELSE _tmpItem.CurrencyId END
                                                                             )
                                            WHEN _tmpItem.AccountId = zc_Enum_Account_100301() -- прибыль текущего периода
                                                 THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                            , inParentId          := NULL
                                                                            , inObjectId          := _tmpItem.AccountId
                                                                            , inJuridicalId_basis := _tmpItem.JuridicalId_Basis
                                                                            , inBusinessId        := _tmpItem.BusinessId_ProfitLoss
                                                                            , inObjectCostDescId  := NULL
                                                                            , inObjectCostId      := NULL
                                                                            , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                                                            , inObjectId_1        := _tmpItem.ObjectId
                                                                            , inDescId_2          := zc_ContainerLinkObject_Branch()
                                                                            , inObjectId_2        := _tmpItem.BranchId_ProfitLoss
                                                                             )
                                            WHEN _tmpItem.AccountDirectionId = zc_Enum_AccountDirection_100400() -- Расчеты с участниками
                                                 -- _tmpItem.ObjectDescId = zc_Object_Founder() -- Учредители
                                                 THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                            , inParentId          := NULL
                                                                            , inObjectId          := _tmpItem.AccountId
                                                                            , inJuridicalId_basis := _tmpItem.JuridicalId_Basis
                                                                            , inBusinessId        := _tmpItem.BusinessId_Balance
                                                                            , inObjectCostDescId  := NULL
                                                                            , inObjectCostId      := NULL
                                                                            , inDescId_1          := zc_ContainerLinkObject_Founder()
                                                                            , inObjectId_1        := _tmpItem.ObjectId -- (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = _tmpItem.InfoMoneyId AND DescId = zc_ObjectLink_Founder_InfoMoney())
                                                                             )
                                            WHEN _tmpItem.ObjectDescId = zc_Object_Member() -- Подотчет
                                                 THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                            , inParentId          := NULL
                                                                            , inObjectId          := _tmpItem.AccountId
                                                                            , inJuridicalId_basis := _tmpItem.JuridicalId_Basis
                                                                            , inBusinessId        := _tmpItem.BusinessId_Balance
                                                                            , inObjectCostDescId  := NULL
                                                                            , inObjectCostId      := NULL
                                                                            , inDescId_1          := zc_ContainerLinkObject_Member()
                                                                            , inObjectId_1        := _tmpItem.ObjectId
                                                                            , inDescId_2          := zc_ContainerLinkObject_InfoMoney()
                                                                            , inObjectId_2        := _tmpItem.InfoMoneyId
                                                                            , inDescId_3          := zc_ContainerLinkObject_Branch()
                                                                            , inObjectId_3        := _tmpItem.BranchId_Balance
                                                                            , inDescId_4          := zc_ContainerLinkObject_Car()
                                                                            , inObjectId_4        := 0 -- для Физ.лица (подотчетные лица) !!!именно здесь последняя аналитика всегда значение = 0!!!
                                                                             )
                                            WHEN _tmpItem.ObjectDescId = zc_Object_Personal() -- ЗП
                                                 THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                            , inParentId          := NULL
                                                                            , inObjectId          := _tmpItem.AccountId
                                                                            , inJuridicalId_basis := _tmpItem.JuridicalId_Basis
                                                                            , inBusinessId        := _tmpItem.BusinessId_Balance
                                                                            , inObjectCostDescId  := NULL
                                                                            , inObjectCostId      := NULL
                                                                            , inDescId_1          := zc_ContainerLinkObject_Personal()
                                                                            , inObjectId_1        := _tmpItem.ObjectId
                                                                            , inDescId_2          := zc_ContainerLinkObject_InfoMoney()
                                                                            , inObjectId_2        := _tmpItem.InfoMoneyId
                                                                            , inDescId_3          := zc_ContainerLinkObject_Branch()
                                                                            , inObjectId_3        := _tmpItem.BranchId_Balance
                                                                            , inDescId_4          := zc_ContainerLinkObject_Unit()
                                                                            , inObjectId_4        := _tmpItem.UnitId
                                                                            , inDescId_5          := zc_ContainerLinkObject_Position()
                                                                            , inObjectId_5        := _tmpItem.PositionId
                                                                            , inDescId_6          := zc_ContainerLinkObject_ServiceDate()
                                                                            , inObjectId_6        := _tmpItem.ServiceDateId
                                                                            , inDescId_7          := zc_ContainerLinkObject_PersonalServiceList()
                                                                            , inObjectId_7        := _tmpItem.PersonalServiceListId
                                                                             )
                                            WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner())
                                                      -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Юридические лица 2)Виды форм оплаты 3)Договора 4)Статьи назначения 5)Партии накладной
                                                 THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                            , inParentId          := NULL
                                                                            , inObjectId          := _tmpItem.AccountId
                                                                            , inJuridicalId_basis := _tmpItem.JuridicalId_Basis
                                                                            , inBusinessId        := _tmpItem.BusinessId_Balance
                                                                            , inObjectCostDescId  := NULL
                                                                            , inObjectCostId      := NULL
                                                                            , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                                            , inObjectId_1        := CASE WHEN _tmpItem.ObjectDescId = zc_Object_Juridical() THEN _tmpItem.ObjectId ELSE (SELECT ObjectLink.ChildObjectId FROM ObjectLink WHERE ObjectLink.ObjectId = _tmpItem.ObjectId AND ObjectLink.DescId = zc_ObjectLink_Partner_Juridical()) END
                                                                            , inDescId_2          := zc_ContainerLinkObject_Contract()
                                                                            , inObjectId_2        := _tmpItem.ContractId
                                                                            , inDescId_3          := zc_ContainerLinkObject_InfoMoney()
                                                                            , inObjectId_3        := _tmpItem.InfoMoneyId
                                                                            , inDescId_4          := zc_ContainerLinkObject_PaidKind()
                                                                            , inObjectId_4        := _tmpItem.PaidKindId
                                                                            , inDescId_5          := zc_ContainerLinkObject_PartionMovement()
                                                                            , inObjectId_5        := _tmpItem.PartionMovementId
                                                                            , inDescId_6          := CASE WHEN COALESCE (_tmpItem.CurrencyId, zc_Enum_Currency_Basis()) = zc_Enum_Currency_Basis() THEN NULL ELSE zc_ContainerLinkObject_Currency() END
                                                                            , inObjectId_6        := CASE WHEN COALESCE (_tmpItem.CurrencyId, zc_Enum_Currency_Basis()) = zc_Enum_Currency_Basis() THEN NULL ELSE _tmpItem.CurrencyId END
                                                                            , inDescId_7          := CASE WHEN _tmpItem.PaidKindId = zc_Enum_PaidKind_SecondForm() AND _tmpItem.AccountDirectionId <> zc_Enum_AccountDirection_30200() THEN zc_ContainerLinkObject_Partner() ELSE NULL END -- and <> наши компании
                                                                            , inObjectId_7        := CASE WHEN _tmpItem.PaidKindId = zc_Enum_PaidKind_SecondForm() AND _tmpItem.AccountDirectionId <> zc_Enum_AccountDirection_30200() THEN CASE WHEN _tmpItem.ObjectDescId = zc_Object_Juridical() THEN (SELECT (ObjectLink.ObjectId) FROM ObjectLink WHERE ObjectLink.ChildObjectId = _tmpItem.ObjectId AND ObjectLink.DescId = zc_ObjectLink_Partner_Juridical()) ELSE _tmpItem.ObjectId END ELSE NULL END -- and <> наши компании
                                                                            , inDescId_8          := CASE WHEN _tmpItem.PaidKindId = zc_Enum_PaidKind_SecondForm() AND _tmpItem.AccountDirectionId <> zc_Enum_AccountDirection_30200() THEN zc_ContainerLinkObject_Branch() ELSE NULL END -- and <> наши компании
                                                                            , inObjectId_8        := CASE WHEN _tmpItem.PaidKindId = zc_Enum_PaidKind_SecondForm() AND _tmpItem.AccountDirectionId <> zc_Enum_AccountDirection_30200() THEN _tmpItem.BranchId_Balance ELSE NULL END -- and <> наши компании
                                                                             )
                                       END;
     -- 2.2. определяется ContainerId для проводок суммового учета - Суммовой учет в валюте
     UPDATE _tmpItem SET 
                ContainerId_Currency = CASE WHEN COALESCE (_tmpItem.CurrencyId, zc_Enum_Currency_Basis()) = zc_Enum_Currency_Basis()
                                              OR _tmpItem.AccountId = zc_Enum_Account_100301() -- прибыль текущего периода
                                                 THEN 0
                                            WHEN _tmpItem.AccountId IN (zc_Enum_Account_110302()) -- Транзит + расчетный счет + валютный
                                                 THEN lpInsertFind_Container (inContainerDescId   := zc_Container_SummCurrency()
                                                                            , inParentId          := _tmpItem.ContainerId
                                                                            , inObjectId          := _tmpItem.AccountId
                                                                            , inJuridicalId_basis := _tmpItem.JuridicalId_Basis
                                                                            , inBusinessId        := _tmpItem.BusinessId_Balance
                                                                            , inObjectCostDescId  := NULL
                                                                            , inObjectCostId      := NULL
                                                                            , inDescId_1          := CASE WHEN _tmpItem.AccountDirectionId IN (zc_Enum_AccountDirection_40100()
                                                                                                                                             , zc_Enum_AccountDirection_40200()
                                                                                                                                             , zc_Enum_AccountDirection_40500()
                                                                                                                                             , zc_Enum_AccountDirection_40600()
                                                                                                                                              )
                                                                                                               THEN zc_ContainerLinkObject_Cash()
                                                                                                          ELSE zc_ContainerLinkObject_BankAccount()
                                                                                                     END
                                                                            , inObjectId_1        := CASE WHEN _tmpItem.IsActive = FALSE THEN _tmpItem.ObjectId ELSE (SELECT ObjectId FROM _tmpItem WHERE IsActive = FALSE) END
                                                                            , inDescId_2          := zc_ContainerLinkObject_Currency()
                                                                            , inObjectId_2        := _tmpItem.CurrencyId
                                                                             )
                                            WHEN _tmpItem.AccountGroupId = zc_Enum_AccountGroup_40000() -- Денежные средства
                                                 THEN lpInsertFind_Container (inContainerDescId   := zc_Container_SummCurrency()
                                                                            , inParentId          := _tmpItem.ContainerId
                                                                            , inObjectId          := _tmpItem.AccountId
                                                                            , inJuridicalId_basis := _tmpItem.JuridicalId_Basis
                                                                            , inBusinessId        := _tmpItem.BusinessId_Balance
                                                                            , inObjectCostDescId  := NULL
                                                                            , inObjectCostId      := NULL
                                                                            , inDescId_1          := CASE WHEN _tmpItem.AccountDirectionId IN (zc_Enum_AccountDirection_40100()
                                                                                                                                             , zc_Enum_AccountDirection_40200()
                                                                                                                                             , zc_Enum_AccountDirection_40500()
                                                                                                                                             , zc_Enum_AccountDirection_40600()
                                                                                                                                              )
                                                                                                               THEN zc_ContainerLinkObject_Cash()
                                                                                                          ELSE zc_ContainerLinkObject_BankAccount()
                                                                                                     END
                                                                            , inObjectId_1        := _tmpItem.ObjectId
                                                                            , inDescId_2          := zc_ContainerLinkObject_Currency()
                                                                            , inObjectId_2        := _tmpItem.CurrencyId
                                                                             )
                                            WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner())
                                                      -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Юридические лица 2)Виды форм оплаты 3)Договора 4)Статьи назначения 5)Партии накладной
                                                 THEN lpInsertFind_Container (inContainerDescId   := zc_Container_SummCurrency()
                                                                            , inParentId          := _tmpItem.ContainerId
                                                                            , inObjectId          := _tmpItem.AccountId
                                                                            , inJuridicalId_basis := _tmpItem.JuridicalId_Basis
                                                                            , inBusinessId        := _tmpItem.BusinessId_Balance
                                                                            , inObjectCostDescId  := NULL
                                                                            , inObjectCostId      := NULL
                                                                            , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                                            , inObjectId_1        := CASE WHEN _tmpItem.ObjectDescId = zc_Object_Juridical() THEN _tmpItem.ObjectId ELSE (SELECT ObjectLink.ChildObjectId FROM ObjectLink WHERE ObjectLink.ObjectId = _tmpItem.ObjectId AND ObjectLink.DescId = zc_ObjectLink_Partner_Juridical()) END
                                                                            , inDescId_2          := zc_ContainerLinkObject_Contract()
                                                                            , inObjectId_2        := _tmpItem.ContractId
                                                                            , inDescId_3          := zc_ContainerLinkObject_InfoMoney()
                                                                            , inObjectId_3        := _tmpItem.InfoMoneyId
                                                                            , inDescId_4          := zc_ContainerLinkObject_PaidKind()
                                                                            , inObjectId_4        := _tmpItem.PaidKindId
                                                                            , inDescId_5          := zc_ContainerLinkObject_PartionMovement()
                                                                            , inObjectId_5        := _tmpItem.PartionMovementId
                                                                            , inDescId_6          := zc_ContainerLinkObject_Currency()
                                                                            , inObjectId_6        := _tmpItem.CurrencyId
                                                                            , inDescId_7          := CASE WHEN _tmpItem.PaidKindId = zc_Enum_PaidKind_SecondForm() AND _tmpItem.AccountDirectionId <> zc_Enum_AccountDirection_30200() THEN zc_ContainerLinkObject_Partner() ELSE NULL END -- and <> наши компании
                                                                            , inObjectId_7        := CASE WHEN _tmpItem.PaidKindId = zc_Enum_PaidKind_SecondForm() AND _tmpItem.AccountDirectionId <> zc_Enum_AccountDirection_30200() THEN CASE WHEN _tmpItem.ObjectDescId = zc_Object_Juridical() THEN (SELECT (ObjectLink.ObjectId) FROM ObjectLink WHERE ObjectLink.ChildObjectId = _tmpItem.ObjectId AND ObjectLink.DescId = zc_ObjectLink_Partner_Juridical()) ELSE _tmpItem.ObjectId END ELSE NULL END -- and <> наши компании
                                                                            , inDescId_8          := CASE WHEN _tmpItem.PaidKindId = zc_Enum_PaidKind_SecondForm() AND _tmpItem.AccountDirectionId <> zc_Enum_AccountDirection_30200() THEN zc_ContainerLinkObject_Branch() ELSE NULL END -- and <> наши компании
                                                                            , inObjectId_8        := CASE WHEN _tmpItem.PaidKindId = zc_Enum_PaidKind_SecondForm() AND _tmpItem.AccountDirectionId <> zc_Enum_AccountDirection_30200() THEN _tmpItem.BranchId_Balance ELSE NULL END -- and <> наши компании
                                                                             )
                                            ELSE 0
                                       END
                  , ContainerId_Diff = CASE WHEN _tmpItem.OperSumm_Diff <> 0
                                                 THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                            , inParentId          := NULL
                                                                            , inObjectId          := zc_Enum_Account_100301() -- прибыль текущего периода
                                                                            , inJuridicalId_basis := _tmpItem.JuridicalId_Basis
                                                                            , inBusinessId        := _tmpItem.BusinessId_ProfitLoss
                                                                            , inObjectCostDescId  := NULL
                                                                            , inObjectCostId      := NULL
                                                                            , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                                                            , inObjectId_1        := _tmpItem.ProfitLossId_Diff
                                                                            , inDescId_2          := zc_ContainerLinkObject_Branch()
                                                                            , inObjectId_2        := _tmpItem.BranchId_ProfitLoss
                                                                             )
                                            ELSE 0
                                       END
     WHERE _tmpItem.CurrencyId <> zc_Enum_Currency_Basis()
       OR _tmpItem.OperSumm_Diff <> 0
    ;


     -- 3. формируются Проводки + !!!есть MovementItemId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive)
       -- это "обычные" проводки
       SELECT 0, zc_MIContainer_Summ() AS DescId, _tmpItem.MovementDescId, inMovementId, _tmpItem.MovementItemId
            , _tmpItem.ContainerId
            , _tmpItem.AccountId                  AS AccountId
            , _tmpItem.AnalyzerId                 AS AnalyzerId
            , _tmpItem.ObjectId                   AS ObjectId_Analyzer
            , _tmpItem.UnitId                     AS WhereObjectId_Analyzer
            , _tmpItem.ContainerId                AS ContainerId_Analyzer
            , 0 AS ParentId
            , _tmpItem.OperSumm
            , _tmpItem.OperDate
            , _tmpItem.IsActive
       FROM _tmpItem
      UNION ALL
       -- это !!!одна!!! проводка для "курсовой разницы"
       SELECT 0, zc_MIContainer_Summ() AS DescId, _tmpItem.MovementDescId, inMovementId, _tmpItem.MovementItemId
            , _tmpItem.ContainerId_Diff
            , zc_Enum_Account_100301()            AS AccountId -- прибыль текущего периода
            , 0                                   AS AnalyzerId
            , _tmpItem.ObjectId                   AS ObjectId_Analyzer
            , _tmpItem.UnitId                     AS WhereObjectId_Analyzer
            , _tmpItem.ContainerId_Diff           AS ContainerId_Analyzer
            , 0 AS ParentId
            , _tmpItem.OperSumm_Diff
            , _tmpItem.OperDate
            , FALSE AS IsActive -- !!!всегда по Кредиту!!!
       FROM _tmpItem
       WHERE _tmpItem.ContainerId_Diff <> 0
      UNION ALL
       -- это !!!одна!!! проводка для "забалансового" Валютного счета 
       SELECT 0, zc_MIContainer_SummCurrency() AS DescId, _tmpItem.MovementDescId, inMovementId, _tmpItem.MovementItemId
            , _tmpItem.ContainerId_Currency
            , 0                                   AS AccountId
            , 0                                   AS AnalyzerId
            , 0                                   AS ObjectId_Analyzer
            , 0                                   AS WhereObjectId_Analyzer
            , _tmpItem.ContainerId_Currency       AS ContainerId_Analyzer
            , 0 AS ParentId
            , _tmpItem.OperSumm_Currency
            , _tmpItem.OperDate
            , _tmpItem.IsActive
       FROM _tmpItem
       WHERE _tmpItem.ContainerId_Currency <> 0
    ;


     -- 4. формируются Проводки для отчета
     PERFORM lpInsertUpdate_MovementItemReport (inMovementDescId     := _tmpItem.MovementDescId
                                              , inMovementId         := inMovementId
                                              , inMovementItemId     := _tmpItem.MovementItemId
                                              , inActiveContainerId  := _tmpItem.ActiveContainerId
                                              , inPassiveContainerId := _tmpItem.PassiveContainerId
                                              , inActiveAccountId    := _tmpItem.ActiveAccountId
                                              , inPassiveAccountId   := _tmpItem.PassiveAccountId
                                              , inReportContainerId  := lpInsertFind_ReportContainer (inActiveContainerId  := _tmpItem.ActiveContainerId
                                                                                                    , inPassiveContainerId := _tmpItem.PassiveContainerId
                                                                                                    , inActiveAccountId    := _tmpItem.ActiveAccountId
                                                                                                    , inPassiveAccountId   := _tmpItem.PassiveAccountId
                                                                                                     )
                                              , inChildReportContainerId := lpInsertFind_ChildReportContainer (inActiveContainerId  := _tmpItem.ActiveContainerId
                                                                                                             , inPassiveContainerId := _tmpItem.PassiveContainerId
                                                                                                             , inActiveAccountId    := _tmpItem.ActiveAccountId
                                                                                                             , inPassiveAccountId   := _tmpItem.PassiveAccountId
                                                                                                             , inAccountKindId_1    := NULL
                                                                                                             , inContainerId_1      := NULL
                                                                                                             , inAccountId_1        := NULL
                                                                                                              )
                                              , inAmount   := _tmpItem.OperSumm
                                              , inOperDate := _tmpItem.OperDate
                                               )
     FROM  -- для всех,  т.к.может быть 1:N, !!!сумма берется из _tmpItem_Child!!!
          (SELECT _tmpItem.MovementDescId
                , _tmpItem.MovementItemId
                , _tmpItem.OperSumm
                , _tmpItem.OperDate
                , _tmpItem.ActiveContainerId
                , _tmpItem.ActiveAccountId
                , _tmpItem.PassiveContainerId
                , _tmpItem.PassiveAccountId
           FROM (SELECT _tmpItem_Child.MovementDescId
                      , _tmpItem_Child.MovementItemId
                      , ABS (_tmpItem_Child.OperSumm
                            -- - CASE WHEN _tmpItem_Master.ObjectDescId = zc_Object_BankAccount() AND _tmpItem_Master.isActive = TRUE THEN COALESCE (_tmpItem_Child.OperSumm_Diff, 0) ELSE 0 END
                            -- - CASE WHEN _tmpItem_Child.ObjectDescId = zc_Object_BankAccount() AND _tmpItem_Child.isActive = TRUE THEN COALESCE (_tmpItem_Master.OperSumm_Diff, 0) ELSE 0 END
                            ) AS OperSumm
                      , _tmpItem_Child.OperDate
                      , CASE WHEN _tmpItem_Child.OperSumm >=0 THEN _tmpItem_Child.ContainerId  ELSE _tmpItem_Master.ContainerId END AS ActiveContainerId
                      , CASE WHEN _tmpItem_Child.OperSumm >=0 THEN _tmpItem_Child.AccountId    ELSE _tmpItem_Master.AccountId   END AS ActiveAccountId
                      , CASE WHEN _tmpItem_Child.OperSumm >=0 THEN _tmpItem_Master.ContainerId ELSE _tmpItem_Child.ContainerId  END AS PassiveContainerId
                      , CASE WHEN _tmpItem_Child.OperSumm >=0 THEN _tmpItem_Master.AccountId   ELSE _tmpItem_Child.AccountId    END AS PassiveAccountId
                 FROM _tmpItem AS _tmpItem_Master
                      LEFT JOIN _tmpItem AS _tmpItem_Child ON _tmpItem_Child.IsMaster = FALSE
                 WHERE _tmpItem_Master.IsMaster = TRUE
                   -- AND (_tmpItem_Master.MovementDescId = zc_Movement_ProfitLossService())
                   --      OR _tmpItem_Child.ObjectDescId = zc_Object_Personal())
                   AND _tmpItem_Master.MovementDescId NOT IN (zc_Movement_SendDebt(), zc_Movement_PersonalAccount(), zc_Movement_Currency(), zc_Movement_PersonalService())
                ) AS _tmpItem
          UNION ALL
           -- для zc_Movement_SendDebt, т.к. всегда 1:1 но используется _tmpItem_Passive_SendDebt
           SELECT _tmpItem_Active.MovementDescId
                , _tmpItem_Active.MovementItemId
                , _tmpItem_Active.OperSumm + CASE WHEN _tmpItem_Active.ObjectDescId = zc_Object_BankAccount() THEN COALESCE (_tmpItem_Passive.OperSumm_Diff, 0) ELSE 0 END AS OperSumm
                , _tmpItem_Active.OperDate
                , _tmpItem_Active.ContainerId AS ActiveContainerId
                , _tmpItem_Active.AccountId AS ActiveAccountId
                , COALESCE (_tmpItem_Passive_SendDebt.ContainerId, _tmpItem_Passive.ContainerId) AS PassiveContainerId
                , COALESCE (_tmpItem_Passive_SendDebt.AccountId, _tmpItem_Passive.AccountId) AS PassiveAccountId
           FROM _tmpItem AS _tmpItem_Active
                LEFT JOIN _tmpItem AS _tmpItem_Passive ON _tmpItem_Passive.OperSumm < 0 AND _tmpItem_Passive.MovementItemId = _tmpItem_Active.MovementItemId
                LEFT JOIN _tmpItem AS _tmpItem_Passive_SendDebt ON _tmpItem_Passive_SendDebt.OperSumm < 0 AND _tmpItem_Passive_SendDebt.MovementDescId = zc_Movement_SendDebt()
           WHERE _tmpItem_Active.OperSumm > 0
             -- AND _tmpItem_Active.MovementDescId <> zc_Movement_ProfitLossService()
             AND _tmpItem_Active.MovementDescId IN (zc_Movement_SendDebt(), zc_Movement_PersonalAccount(), zc_Movement_Currency(), zc_Movement_PersonalService())
          UNION ALL
           -- для zc_Object_BankAccount, только курсовая разница
           SELECT _tmpItem_BankAccount.MovementDescId
                , _tmpItem_BankAccount.MovementItemId
                , ABS (_tmpItem_Diff.OperSumm_Diff) AS OperSumm
                , _tmpItem_BankAccount.OperDate
                , CASE WHEN _tmpItem_Diff.OperSumm_Diff < 0 THEN _tmpItem_BankAccount.ContainerId ELSE _tmpItem_Diff.ContainerId_Diff END AS ActiveContainerId
                , CASE WHEN _tmpItem_Diff.OperSumm_Diff < 0 THEN _tmpItem_BankAccount.AccountId ELSE zc_Enum_Account_100301() END AS ActiveAccountId
                , CASE WHEN _tmpItem_Diff.OperSumm_Diff < 0 THEN _tmpItem_Diff.ContainerId_Diff ELSE _tmpItem_BankAccount.ContainerId END AS PassiveContainerId
                , CASE WHEN _tmpItem_Diff.OperSumm_Diff < 0 THEN zc_Enum_Account_100301() ELSE _tmpItem_BankAccount.AccountId END AS PassiveAccountId
           FROM _tmpItem AS _tmpItem_BankAccount
                INNER JOIN _tmpItem AS _tmpItem_Diff ON _tmpItem_Diff.ContainerId_Diff <> 0 AND _tmpItem_Diff.MovementItemId = _tmpItem_BankAccount.MovementItemId
           WHERE _tmpItem_BankAccount.ObjectDescId = zc_Object_BankAccount() AND _tmpItem_BankAccount.ContainerId_Diff = 0
          ) AS _tmpItem
    ;
     
     -- убрал, т.к. св-во пишется теперь в ОПиУ, !!!но это свойство надо для zc_Movement_LossDebt() а может и других!!!
     -- DELETE FROM MovementItemLinkObject WHERE DescId = zc_MILinkObject_Branch() AND MovementItemId IN (SELECT MovementItemId FROM _tmpItem);
     /* убрал, т.к. св-во пишется теперь в ОПиУ
     -- !!!5.1. формируются свойства в элементах документа из данных для проводок!!!
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Branch(), tmp.MovementItemId, tmp.BranchId_ProfitLoss)
     FROM (SELECT _tmpItem.MovementItemId, _tmpItem.BranchId_ProfitLoss
           FROM _tmpItem
           WHERE _tmpItem.AccountId = zc_Enum_Account_100301() -- 100301; "прибыль текущего периода"
             AND _tmpItem.MovementDescId <> zc_Movement_LossDebt()
          ) AS tmp;*/


     -- 6. ФИНИШ - Обязательно сохраняем Проводки
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();


END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.02.15                                        * del zc_MILinkObject_Branch, т.к. св-во пишется теперь в ОПиУ
 07.09.14                                        * add zc_ContainerLinkObject_Branch to PartnerId
 05.09.14                                        * add zc_ContainerLinkObject_Branch to Физ.лица (подотчетные лица)
 03.09.14                                        * add zc_Object_Founder
 30.08.14                                        * add zc_ContainerLinkObject_Partner
 17.08.14                                        * add MovementDescId
 19.07.14                                        * modify zc_Enum_Account_40302
 11.05.14                                        * set zc_ContainerLinkObject_PaidKind is last
 04.05.14                                        * add zc_Enum_Account_40302
 04.05.14                                        * change zc_Enum_AccountDirection_30100
 19.04.14                                        * del zc_Enum_InfoMoneyDestination_40900
 04.04.14                                        * add ЕКСПЕРТ-АГРОТРЕЙД
 10.03.14                                        * add no calc AccountId
 28.01.14                                        * add zc_Movement_SendDebt
 24.01.14                                        * add zc_Enum_InfoMoneyDestination_40900
 22.01.14                                        * add IsMaster
 29.12.13                                        *
 26.12.13                                        *
*/

-- тест
-- SELECT * FROM lpUnComplete_Movement (inMovementId:= 3581, inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM gpComplete_Movement_Cash (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
