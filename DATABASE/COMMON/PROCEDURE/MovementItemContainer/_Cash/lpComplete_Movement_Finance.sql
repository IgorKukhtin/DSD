-- Function: lpComplete_Movement_Finance (Integer, Boolean)

DROP FUNCTION IF EXISTS lpComplete_Movement_Finance (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Finance(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)                              
RETURNS void
AS
$BODY$
BEGIN

     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! Ну а теперь - ПРОВОДКИ !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

     -- 1.1.1 определяется AccountDirectionId для проводок суммового учета
     UPDATE _tmpItem SET AccountDirectionId =    CASE WHEN _tmpItem.ObjectDescId = zc_Object_BankAccount()
                                                           THEN zc_Enum_AccountDirection_40300() -- рассчетный счет
                                                      WHEN _tmpItem.ObjectDescId = zc_Object_Cash() AND ObjectLink_Cash_Branch.ChildObjectId IS NOT NULL
                                                           THEN zc_Enum_AccountDirection_40200() -- касса филиалов
                                                      WHEN _tmpItem.ObjectDescId = zc_Object_Cash() AND ObjectLink_Cash_Branch.ChildObjectId IS NULL
                                                           THEN zc_Enum_AccountDirection_40100() -- касса

                                                      WHEN _tmpItem.ObjectDescId = zc_Object_Member() AND _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_40000() -- Финансовая деятельность
                                                           THEN zc_Enum_AccountDirection_30400() -- Прочие дебиторы
                                                      WHEN _tmpItem.ObjectDescId = zc_Object_Member() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_80300() -- Расчеты с участниками
                                                           THEN zc_Enum_AccountDirection_100400() -- Расчеты с участниками
                                                      WHEN _tmpItem.ObjectDescId = zc_Object_Member()
                                                           THEN zc_Enum_AccountDirection_30500() -- сотрудники (подотчетные лица)
                                                      WHEN _tmpItem.ObjectDescId = zc_Object_Personal()
                                                           THEN zc_Enum_AccountDirection_70500() -- Заработная плата

                                                      WHEN COALESCE (ObjectBoolean_isCorporate.ValueData, FALSE) = TRUE
                                                           THEN zc_Enum_AccountDirection_30200() -- наши компании
                                                      WHEN _tmpItem.ObjectDescId = zc_Object_Juridical() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30400() -- услуги предоставленные
                                                           THEN zc_Enum_AccountDirection_30300() -- услуги предоставленные
                                                      WHEN _tmpItem.ObjectDescId = zc_Object_Juridical() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30500() -- Прочие доходы
                                                           THEN zc_Enum_AccountDirection_30400() -- Прочие дебиторы
                                                      WHEN _tmpItem.ObjectDescId = zc_Object_Juridical() AND _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_30000() -- Доходы
                                                           THEN zc_Enum_AccountDirection_30100() -- покупатели

                                                      WHEN _tmpItem.ObjectDescId = zc_Object_Juridical() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21400() -- услуги полученные
                                                           THEN zc_Enum_AccountDirection_70200() -- услуги полученные
                                                      WHEN _tmpItem.ObjectDescId = zc_Object_Juridical() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21500() -- Маркетинг
                                                           THEN zc_Enum_AccountDirection_70300() -- Маркетинг
                                                      WHEN _tmpItem.ObjectDescId = zc_Object_Juridical() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21600() -- Коммунальные услуги
                                                           THEN zc_Enum_AccountDirection_70400() -- Коммунальные услуги
                                                      WHEN _tmpItem.ObjectDescId = zc_Object_Juridical() AND _tmpItem.InfoMoneyGroupId IN (zc_Enum_InfoMoneyGroup_10000(), zc_Enum_InfoMoneyGroup_20000()) -- Основное сырье; Общефирменные
                                                           THEN zc_Enum_AccountDirection_70100() -- поставщики

                                                      WHEN _tmpItem.ObjectDescId = zc_Object_Juridical() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70500() -- НМА
                                                           THEN zc_Enum_AccountDirection_70900() -- НМА
                                                      WHEN _tmpItem.ObjectDescId = zc_Object_Juridical() AND _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() -- Инвестиции
                                                           THEN zc_Enum_AccountDirection_70800() -- Производственные ОС

                                                      WHEN _tmpItem.ObjectDescId = zc_Object_Juridical() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_40100() -- Кредиты банков
                                                           THEN zc_Enum_AccountDirection_80100() -- Кредиты банков
                                                      WHEN _tmpItem.ObjectDescId = zc_Object_Juridical() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_40200() -- Прочие кредиты
                                                           THEN zc_Enum_AccountDirection_80200() -- Прочие кредиты
                                                      WHEN _tmpItem.ObjectDescId = zc_Object_Juridical() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_40400() -- проценты по кредитам
                                                           THEN zc_Enum_AccountDirection_80400() -- проценты по кредитам
                                                      WHEN _tmpItem.ObjectDescId = zc_Object_Juridical() AND _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_40000() -- Финансовая деятельность
                                                           THEN zc_Enum_AccountDirection_30400() -- Прочие дебиторы

                                                      WHEN _tmpItem.ObjectDescId = zc_Object_Juridical() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_50200() -- Налоговые платежи
                                                           THEN zc_Enum_AccountDirection_90100() -- Налоговые платежи
                                                      WHEN _tmpItem.ObjectDescId = zc_Object_Juridical() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_50300() -- Налоговые платежи (прочие)
                                                           THEN zc_Enum_AccountDirection_90200() -- Налоговые платежи (прочие)
                                                      WHEN _tmpItem.ObjectDescId = zc_Object_Juridical() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_50100() -- Налоговые платежи по ЗП
                                                           THEN zc_Enum_AccountDirection_90300() -- Налоговые платежи по ЗП
                                                      WHEN _tmpItem.ObjectDescId = zc_Object_Juridical() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_50400() -- штрафы в бюджет*
                                                          THEN zc_Enum_AccountDirection_90400() -- штрафы в бюджет*
                                                 END
     FROM Object
          LEFT JOIN ObjectLink AS ObjectLink_Cash_Branch
                               ON ObjectLink_Cash_Branch.ObjectId = Object.Id
                              AND ObjectLink_Cash_Branch.DescId = zc_ObjectLink_Cash_Branch()
                              AND ObjectLink_Cash_Branch.ChildObjectId <> zc_Branch_Basis()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporate
                                  ON ObjectBoolean_isCorporate.ObjectId = Object.Id
                                 AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()
     WHERE Object.Id = _tmpItem.ObjectId;

     -- 1.1.2. определяется AccountGroupId для проводок суммового учета
     UPDATE _tmpItem SET AccountGroupId = View_AccountDirection.AccountGroupId
     FROM Object_AccountDirection_View AS View_AccountDirection
     WHERE View_AccountDirection.AccountDirectionId = _tmpItem.AccountDirectionId;


     -- 1.1.3. определяется Счет для проводок суммового учета
     UPDATE _tmpItem SET AccountId = CASE WHEN _tmpItem.ObjectDescId = 0
                                               THEN zc_Enum_Account_100301() -- прибыль текущего периода
                                          WHEN _tmpItem.ObjectDescId IN (zc_Object_BankAccount(), zc_Object_Cash()) AND IsMaster = FALSE
                                               THEN zc_Enum_Account_110101() -- Транзит
                                          WHEN _tmpItem.AccountDirectionId = zc_Enum_AccountDirection_40300() -- рассчетный счет
                                               THEN zc_Enum_Account_40301() -- рассчетный счет
                                          WHEN _tmpItem.AccountDirectionId = zc_Enum_AccountDirection_40200() -- касса филиалов
                                               THEN zc_Enum_Account_40201() -- касса филиалов
                                          WHEN _tmpItem.AccountDirectionId = zc_Enum_AccountDirection_40100() -- касса
                                               THEN zc_Enum_Account_40101() -- касса
                                          ELSE lpInsertFind_Object_Account (inAccountGroupId         := _tmpItem.AccountGroupId
                                                                          , inAccountDirectionId     := _tmpItem.AccountDirectionId
                                                                          , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                          , inInfoMoneyId            := NULL
                                                                          , inInsert                 := CASE WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_40700() -- Лиол
                                                                                                              AND _tmpItem.AccountDirectionId = zc_Enum_AccountDirection_30400() -- Прочие дебиторы
                                                                                                                 THEN TRUE
                                                                                                             ELSE FALSE
                                                                                                        END
                                                                          , inUserId                 := inUserId
                                                                           )
                                     END;

     -- 1.2.1. определяется ProfitLossDirectionId для проводок суммового учета по счету Прибыль
     UPDATE _tmpItem SET ProfitLossDirectionId = CASE WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21500() -- Маркетинг
                                                       AND _tmpItem.UnitId = 0
                                                           THEN zc_Enum_ProfitLossDirection_11100() -- Результат основной деятельности + Маркетинг

                                                      WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30400() -- услуги предоставленные
                                                        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_40500() -- Ссуды
                                                        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_40600() -- Депозиты
                                                           THEN zc_Enum_ProfitLossDirection_70200() -- Дополнительная прибыль + Прочее

                                                      WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_40400() -- проценты по кредитам
                                                        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_40700() -- Лиол
                                                           THEN zc_Enum_ProfitLossDirection_80100() -- Расходы с прибыли + Финансовая деятельность

                                                      WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_50100() -- Налоговые платежи по ЗП
                                                           THEN zc_Enum_ProfitLossDirection_50400() -- Налоговые платежи по ЗП
                                                      WHEN _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_50201() -- Налог на прибыль
                                                           THEN zc_Enum_ProfitLossDirection_50100() -- Налог на прибыль
                                                      WHEN _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_50202() -- НДС
                                                           THEN zc_Enum_ProfitLossDirection_50200() -- НДС
                                                      WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_50300() -- Налоговые платежи (прочие)
                                                           THEN zc_Enum_ProfitLossDirection_50300() -- Налоговые платежи (прочие)
                                                      WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_50400() -- штрафы в бюджет
                                                           THEN zc_Enum_ProfitLossDirection_50500() -- штрафы в бюджет

                                                      ELSE _tmpItem.ProfitLossDirectionId
                                                 END
                       , ObjectId = CASE WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21500() -- Маркетинг
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
     UPDATE _tmpItem SET ObjectId = lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem.ProfitLossGroupId
                                                                  , inProfitLossDirectionId  := _tmpItem.ProfitLossDirectionId
                                                                  , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                  , inInfoMoneyId            := NULL
                                                                  , inInsert                 := FALSE
                                                                  , inUserId                 := inUserId
                                                                   )
     WHERE _tmpItem.AccountId = zc_Enum_Account_100301() -- прибыль текущего периода
       AND _tmpItem.ObjectId = 0
    ;

     -- 2. определяется ContainerId для проводок суммового учета
     UPDATE _tmpItem SET ContainerId = CASE WHEN _tmpItem.AccountId = zc_Enum_Account_110101() -- Транзит
                                                 THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                            , inParentId          := NULL
                                                                            , inObjectId          := _tmpItem.AccountId
                                                                            , inJuridicalId_basis := _tmpItem.JuridicalId_Basis
                                                                            , inBusinessId        := _tmpItem.BusinessId
                                                                            , inObjectCostDescId  := NULL
                                                                            , inObjectCostId      := NULL
                                                                            , inDescId_1          := CASE WHEN _tmpItem.ObjectDescId = zc_Object_BankAccount() THEN zc_ContainerLinkObject_BankAccount() WHEN _tmpItem.ObjectDescId = zc_Object_Cash() THEN zc_ContainerLinkObject_Cash() ELSE -1 END
                                                                            , inObjectId_1        := _tmpItem.ObjectId
                                                                             )
                                            WHEN _tmpItem.AccountGroupId = zc_Enum_AccountGroup_40000() -- Денежные средства
                                                 THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                            , inParentId          := NULL
                                                                            , inObjectId          := _tmpItem.AccountId
                                                                            , inJuridicalId_basis := _tmpItem.JuridicalId_Basis
                                                                            , inBusinessId        := _tmpItem.BusinessId
                                                                            , inObjectCostDescId  := NULL
                                                                            , inObjectCostId      := NULL
                                                                            , inDescId_1          := CASE WHEN _tmpItem.AccountId = zc_Enum_AccountDirection_40300() THEN zc_ContainerLinkObject_BankAccount() ELSE zc_ContainerLinkObject_Cash() END
                                                                            , inObjectId_1        := _tmpItem.ObjectId
                                                                             )
                                            WHEN _tmpItem.AccountId = zc_Enum_Account_100301() -- прибыль текущего периода
                                                 THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                            , inParentId          := NULL
                                                                            , inObjectId          := _tmpItem.AccountId
                                                                            , inJuridicalId_basis := _tmpItem.JuridicalId_Basis
                                                                            , inBusinessId        := _tmpItem.BusinessId
                                                                            , inObjectCostDescId  := NULL
                                                                            , inObjectCostId      := NULL
                                                                            , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                                                            , inObjectId_1        := _tmpItem.ObjectId
                                                                             )
                                            WHEN _tmpItem.ObjectDescId = zc_Object_Member()
                                                 THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                            , inParentId          := NULL
                                                                            , inObjectId          := _tmpItem.AccountId
                                                                            , inJuridicalId_basis := _tmpItem.JuridicalId_Basis
                                                                            , inBusinessId        := _tmpItem.BusinessId
                                                                            , inObjectCostDescId  := NULL
                                                                            , inObjectCostId      := NULL
                                                                            , inDescId_1          := zc_ContainerLinkObject_Member()
                                                                            , inObjectId_1        := _tmpItem.ObjectId
                                                                            , inDescId_2          := zc_ContainerLinkObject_InfoMoney()
                                                                            , inObjectId_2        := _tmpItem.InfoMoneyId
                                                                            , inDescId_3          := zc_ContainerLinkObject_Car()
                                                                            , inObjectId_3        := 0 -- для Сотрудники(подотчетные лица) !!!имеено здесь последняя аналитика всегда значение = 0!!!
                                                                             )
                                            WHEN _tmpItem.ObjectDescId = zc_Object_Juridical()
                                             AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Мясное сырье
                                                      -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Юридические лица 2)Виды форм оплаты 3)Договора 4)Статьи назначения 5)Партии накладной
                                                 THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                            , inParentId          := NULL
                                                                            , inObjectId          := _tmpItem.AccountId
                                                                            , inJuridicalId_basis := _tmpItem.JuridicalId_Basis
                                                                            , inBusinessId        := _tmpItem.BusinessId
                                                                            , inObjectCostDescId  := NULL
                                                                            , inObjectCostId      := NULL
                                                                            , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                                            , inObjectId_1        := _tmpItem.ObjectId
                                                                            , inDescId_2          := zc_ContainerLinkObject_PaidKind()
                                                                            , inObjectId_2        := _tmpItem.PaidKindId
                                                                            , inDescId_3          := zc_ContainerLinkObject_Contract()
                                                                            , inObjectId_3        := _tmpItem.ContractId
                                                                            , inDescId_4          := zc_ContainerLinkObject_InfoMoney()
                                                                            , inObjectId_4        := _tmpItem.InfoMoneyId
                                                                            , inDescId_5          := zc_ContainerLinkObject_PartionMovement()
                                                                            , inObjectId_5        := 0 -- !!!по этой аналитике учет пока не ведем!!!
                                                                             )
                                            WHEN _tmpItem.ObjectDescId = zc_Object_Juridical()
                                                      -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Юридические лица 2)Виды форм оплаты 3)Договора 4)Статьи назначения
                                                 THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                            , inParentId          := NULL
                                                                            , inObjectId          := _tmpItem.AccountId
                                                                            , inJuridicalId_basis := _tmpItem.JuridicalId_Basis
                                                                            , inBusinessId        := _tmpItem.BusinessId
                                                                            , inObjectCostDescId  := NULL
                                                                            , inObjectCostId      := NULL
                                                                            , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                                            , inObjectId_1        := _tmpItem.ObjectId
                                                                            , inDescId_2          := zc_ContainerLinkObject_PaidKind()
                                                                            , inObjectId_2        := _tmpItem.PaidKindId
                                                                            , inDescId_3          := zc_ContainerLinkObject_Contract()
                                                                            , inObjectId_3        := _tmpItem.ContractId
                                                                            , inDescId_4          := zc_ContainerLinkObject_InfoMoney()
                                                                            , inObjectId_4        := _tmpItem.InfoMoneyId
                                                                             )
                                       END;


     -- 3. формируются Проводки 
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementId, MovementItemId, ContainerId, ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, inMovementId, _tmpItem.MovementItemId, _tmpItem.ContainerId, 0 AS ParentId
            , _tmpItem.OperSumm
            , _tmpItem.OperDate
            , _tmpItem.IsActive
       FROM _tmpItem;


     -- 4. формируются Проводки для отчета
     PERFORM lpInsertUpdate_MovementItemReport (inMovementId         := inMovementId
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
     FROM (SELECT _tmpItem_Active.MovementItemId
                , _tmpItem_Active.OperSumm, _tmpItem_Active.OperDate
                , _tmpItem_Active.ContainerId AS ActiveContainerId, _tmpItem_Active.AccountId AS ActiveAccountId
                , _tmpItem_Passive.ContainerId AS PassiveContainerId, _tmpItem_Passive.AccountId AS PassiveAccountId
           FROM _tmpItem AS _tmpItem_Active
                LEFT JOIN _tmpItem AS _tmpItem_Passive ON _tmpItem_Passive.OperSumm < 0 AND _tmpItem_Passive.MovementItemId = _tmpItem_Active.MovementItemId
           WHERE _tmpItem_Active.OperSumm > 0
          ) AS _tmpItem
    ;


     -- !!!5. формируются свойства в элементах документа из данных для проводок!!!
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Branch(), tmp.MovementItemId, tmp.BranchId)
     FROM (SELECT _tmpItem.MovementItemId, _tmpItem.BranchId
           FROM _tmpItem
           WHERE AccountId = zc_Enum_Account_100301() -- 100301; "прибыль текущего периода"
          ) AS tmp;


     -- 6. ФИНИШ - Обязательно сохраняем Проводки
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();


END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.01.14                                        * add IsMaster
 29.12.13                                        *
 26.12.13                                        *
*/

-- тест
-- SELECT * FROM lpUnComplete_Movement (inMovementId:= 3581, inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM gpComplete_Movement_Cash (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
