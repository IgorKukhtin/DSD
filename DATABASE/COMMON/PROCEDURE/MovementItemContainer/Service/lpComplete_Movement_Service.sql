-- Function: lpComplete_Movement_Service (Integer, Boolean)

DROP FUNCTION IF EXISTS lpComplete_Movement_Service (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Service(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)
RETURNS void
AS
$BODY$
  DECLARE vbMovementDescId Integer;
  DECLARE vbIsChild         Boolean;
  DECLARE vbIsAccount_50401 Boolean;
  DECLARE vbIsAccount_60301 Boolean;
BEGIN
     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;

     --
     vbIsChild:= EXISTS (SELECT 1 FROM Movement
                                      JOIN MovementItem AS MI_Child ON MI_Child.MovementId = Movement.Id
                                                                   AND MI_Child.DescId     = zc_MI_Child()
                                                                   AND MI_Child.isErased   = FALSE
                         WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_ProfitLossService()
                           AND inUserId = 5
                        );


     -- нужен тип документа, т.к. проведение для двух разных видов документов
     SELECT Movement.DescId
          , CASE WHEN Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_21500()) -- Маркетинг
                  AND MILinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm()
                 THEN TRUE
                 ELSE FALSE
            END
          , CASE WHEN Object_InfoMoney_View.InfoMoneyId IN (zc_Enum_InfoMoney_30503()) -- Бонусы от поставщиков
                  AND (Movement.DescId = zc_Movement_ProfitIncomeService() OR Movement.OperDate >= '01.03.2021')
                 THEN TRUE
                 ELSE FALSE
            END
            INTO vbMovementDescId
               , vbIsAccount_50401 -- Расходы будущих периодов + Услуги по маркетингу
               , vbIsAccount_60301 -- Прибыль будущих периодов + Услуги по маркетингу
     FROM Movement
          JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
          LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                           ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                          AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
          LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                           ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                          AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
          LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = MILinkObject_InfoMoney.ObjectId
     WHERE Movement.Id = inMovementId;


     -- Только для этого документа
     IF vbMovementDescId = zc_Movement_Service()
     THEN
         -- св-во пишется теперь ЗДЕСЬ
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Branch(), MovementItem.Id, ObjectLink_Unit_Branch.ChildObjectId)
         FROM Movement
              JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
              LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                               ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                              AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
              LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch ON ObjectLink_Unit_Branch.ObjectId = MILinkObject_Unit.ObjectId
                                                            AND ObjectLink_Unit_Branch.DescId   = zc_ObjectLink_Unit_Branch()
         WHERE Movement.Id = inMovementId
        ;
     END IF;


     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementDescId, OperDate, ObjectId, ObjectDescId, OperSumm, OperSumm_Currency, OperSumm_Asset
                         , MovementItemId, ContainerId
                         , AccountGroupId, AccountDirectionId, AccountId
                         , ProfitLossGroupId, ProfitLossDirectionId
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_Balance, BusinessId_ProfitLoss, JuridicalId_Basis
                         , UnitId, PositionId, BranchId_Balance, BranchId_ProfitLoss, ServiceDateId, ContractId, PaidKindId
                         , PartionMovementId, PartionGoodsId, AssetId
                         , AnalyzerId
                         , CurrencyId
                         , IsActive, IsMaster
                          )
        -- 1.1. долг Юр Лицу
        SELECT Movement.DescId
             , Movement.OperDate
             , COALESCE (MovementItem.ObjectId, 0) AS ObjectId
             , COALESCE (Object.DescId, 0) AS ObjectDescId

             , CASE WHEN Movement.OperDate >= zc_DateStart_Asset() AND View_InfoMoney.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() AND vbMovementDescId = zc_Movement_Service()
                         THEN 0
                    WHEN vbMovementDescId = zc_Movement_ProfitIncomeService()
                         THEN 1
                    ELSE 1
               END * MovementItem.Amount                                                                              AS OperSumm

             , COALESCE (MovementFloat_AmountCurrency.ValueData, 0)                                                   AS OperSumm_Currency

             , CASE WHEN Movement.OperDate >= zc_DateStart_Asset() AND View_InfoMoney.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() AND vbMovementDescId = zc_Movement_Service()
                         THEN 1
                    ELSE 0
               END * MovementItem.Amount                                                                              AS OperSumm_Asset

             , MovementItem.Id AS MovementItemId

             , 0 AS ContainerId                                                     -- сформируем позже
             , 0 AS AccountGroupId, 0 AS AccountDirectionId                         -- сформируем позже, или ...
             , CASE WHEN vbMovementDescId = zc_Movement_ProfitLossService() AND vbIsAccount_50401 = TRUE
                         THEN zc_Enum_Account_50401() -- Расходы будущих периодов + Маркетинг
                    WHEN vbMovementDescId = zc_Movement_ProfitIncomeService() AND vbIsAccount_60301 = TRUE
                         THEN zc_Enum_Account_60301() -- Прибыль будущих периодов + Бонусы от поставщиков

                    ELSE 0
               END AS AccountId

             , 0 AS ProfitLossGroupId, 0 AS ProfitLossDirectionId                   -- не используется

               -- Управленческие группы назначения
             , COALESCE (View_InfoMoney.InfoMoneyGroupId, 0) AS InfoMoneyGroupId
               -- Управленческие назначения
             , COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
               -- Управленческие статьи назначения
             , COALESCE (View_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId

               -- Бизнес Баланс: не используется
             , 0  AS BusinessId_Balance
               -- Бизнес ОПиУ: не используется
             , 0 AS BusinessId_ProfitLoss

               -- Главное Юр.лицо всегда из договора
             , COALESCE (MILinkObject_JuridicalBasis.ObjectId, ObjectLink_Contract_JuridicalBasis.ChildObjectId, 0) AS JuridicalId_Basis

             , COALESCE (MILinkObject_Unit.ObjectId, 0) AS UnitId -- здесь используется (нужен для следующей проводки)
             , 0 AS PositionId -- не используется

               -- Филиал Баланс:
             , CASE WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_40900() AND Movement.OperDate = '31.12.2014'
                         THEN -- Финансовая помощь
                              0
                    ELSE -- всегда по подразделению или "Главный филиал" (нужен для НАЛ долгов)
                         COALESCE (MILinkObject_Branch.ObjectId, ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis())
               END AS BranchId_Balance
               -- Филиал ОПиУ: всегда по подразделению или "Главный филиал" (здесь не используется, нужен для следующей проводки)
             , COALESCE (MILinkObject_Branch.ObjectId, ObjectLink_Unit_Branch.ChildObjectId, 0 /*zc_Branch_Basis()*/) AS BranchId_ProfitLoss

               -- Месяц начислений: не используется
             , 0 AS ServiceDateId

             , COALESCE (MILinkObject_Contract.ObjectId, 0) AS ContractId
             , COALESCE (MILinkObject_PaidKind.ObjectId, 0) AS PaidKindId

             , 0 AS PartionMovementId -- не используется
             , 0 AS PartionGoodsId    -- будет заполнено !!!только!!! для следующей
             , 0 AS AssetId           -- будет заполнено !!!только!!! для следующей

             , CASE WHEN View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_30100(), zc_Enum_InfoMoneyDestination_30200()) -- Доходы + Продукция OR Доходы + Мясное сырье
                         THEN zc_Enum_AnalyzerId_SaleSumm_10300() -- !!!Сумма, реализация, Скидка дополнительная!!!
                    ELSE 0
               END AS AnalyzerId -- заполняется !!!только!!! для текущей

               -- Валюта
             , COALESCE (MLO_Currency.ObjectId, zc_Enum_Currency_Basis()) AS CurrencyId

             , CASE WHEN MovementItem.Amount >= 0 THEN TRUE ELSE FALSE END AS IsActive
             , TRUE AS IsMaster
        FROM Movement
             JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()

             LEFT JOIN MovementFloat AS MovementFloat_AmountCurrency
                                     ON MovementFloat_AmountCurrency.MovementId = Movement.Id
                                    AND MovementFloat_AmountCurrency.DescId     = zc_MovementFloat_AmountCurrency()
             LEFT JOIN MovementLinkObject AS MLO_Currency
                                          ON MLO_Currency.MovementId = Movement.Id
                                         AND MLO_Currency.DescId     = zc_MovementLinkObject_CurrencyPartner()

             LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                              ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch ON ObjectLink_Unit_Branch.ObjectId = MILinkObject_Unit.ObjectId
                                                           AND ObjectLink_Unit_Branch.DescId   = zc_ObjectLink_Unit_Branch()

             LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                              ON MILinkObject_Branch.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()
                                             AND Movement.DescId IN (zc_Movement_ProfitLossService(), zc_Movement_ProfitIncomeService())

             LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                              ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                             AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                              ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                              ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_JuridicalBasis
                                              ON MILinkObject_JuridicalBasis.MovementItemId = MovementItem.Id
                                             AND MILinkObject_JuridicalBasis.DescId         = zc_MILinkObject_JuridicalBasis()

             LEFT JOIN Object ON Object.Id = MovementItem.ObjectId
             LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis ON ObjectLink_Contract_JuridicalBasis.ObjectId = MILinkObject_Contract.ObjectId
                                                                       AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId
        WHERE Movement.Id = inMovementId
          AND Movement.DescId IN (zc_Movement_Service(), zc_Movement_ProfitLossService(), zc_Movement_ProfitIncomeService())
          AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
       ;

     IF vbIsChild = FALSE AND EXISTS (SELECT 1 FROM _tmpItem WHERE _tmpItem.OperSumm = 0 AND _tmpItem.OperSumm_Currency = 0 AND _tmpItem.MovementDescId = zc_Movement_ProfitLossService())
     THEN
         RAISE EXCEPTION 'Введите сумму.';
     END IF;

     -- проверка
     IF EXISTS (SELECT _tmpItem.ObjectId FROM _tmpItem WHERE _tmpItem.ObjectId = 0 OR _tmpItem.ObjectDescId NOT IN (zc_Object_Juridical(), zc_Object_Partner()))
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определено <Юридическое лицо>.Проведение невозможно.';
     END IF;
     -- проверка
     IF EXISTS (SELECT _tmpItem.ContractId FROM _tmpItem WHERE _tmpItem.ContractId = 0)
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определен <Договор>.Проведение невозможно.';
     END IF;
     -- проверка
     IF EXISTS (SELECT _tmpItem.InfoMoneyId FROM _tmpItem WHERE _tmpItem.InfoMoneyId = 0)
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определена <УП статья назначения>.Проведение невозможно.';
     END IF;
     -- проверка
     IF EXISTS (SELECT _tmpItem.PaidKindId FROM _tmpItem WHERE _tmpItem.PaidKindId = 0)
     THEN
         RAISE EXCEPTION 'Ошибка.У документе не определена <Форма оплаты>. Проведение невозможно.';
     END IF;
     -- проверка
     IF EXISTS (SELECT _tmpItem.JuridicalId_Basis FROM _tmpItem WHERE _tmpItem.JuridicalId_Basis = 0)
     THEN
         RAISE EXCEPTION 'Ошибка.У <Договора> не установлено <Главное юридическое лицо>.Проведение невозможно.';
     END IF;


     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementDescId, OperDate, ObjectId, ObjectDescId, OperSumm, OperSumm_Asset
                         , MovementItemId, ContainerId
                         , AccountGroupId, AccountDirectionId, AccountId
                         , ProfitLossGroupId, ProfitLossDirectionId
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_Balance, BusinessId_ProfitLoss, JuridicalId_Basis
                         , UnitId, PositionId, BranchId_Balance, BranchId_ProfitLoss, ServiceDateId, ContractId, PaidKindId
                         , PartionMovementId, PartionGoodsId, AssetId
                         , AnalyzerId, ObjectIntId_Analyzer
                         , IsActive, IsMaster
                          )
        -- 1.2.1. ОПиУ OR Новая Схема (еще переброска на счет для zc_Movement_ProfitLossService)
        WITH tmpMI_Child AS (SELECT MI_Child.ParentId, MI_Child.Id AS MovementItemId, MIF_MovementId.ValueData :: Integer AS MovementId_begin, MI_Child.Amount
                             FROM MovementItem AS MI_Child
                                  INNER JOIN MovementItemFloat AS MIF_MovementId ON MIF_MovementId.MovementItemId = MI_Child.Id
                                                                                AND MIF_MovementId.DescId         = zc_MIFloat_MovementId()
                             WHERE MI_Child.MovementId = inMovementId
                               AND MI_Child.DescId = zc_MI_Child()
                               AND MI_Child.isErased = FALSE
                             --AND inUserId = 5
                               AND vbIsChild = TRUE
                            )

        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate

             , CASE WHEN vbMovementDescId = zc_Movement_Service() AND vbIsAccount_50401 = TRUE -- Расходы будущих периодов + Услуги по маркетингу
                         THEN _tmpItem.ObjectId -- из предыдущей проводки
                    WHEN vbMovementDescId = zc_Movement_Service() AND vbIsAccount_60301 = TRUE -- Прибыль будущих периодов + Бонусы от поставщиков
                         THEN _tmpItem.ObjectId -- из предыдущей проводки

                    WHEN MILinkObject_Asset.ObjectId > 0 AND _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() -- Инвестиции
                         THEN _tmpItem.ObjectId -- дублируем УП, попадет в ОС

                    WHEN vbIsChild = TRUE
                         THEN _tmpItem.ObjectId -- дублируем для zc_Movement_ProfitLossService

                    -- если это Расчеты с участниками
                    WHEN ObjectLink_Unit_Founder.ChildObjectId >  0
                         THEN ObjectLink_Unit_Founder.ChildObjectId

                    ELSE 0 -- значит попадет в ОПиУ или в ОС

               END AS ObjectId

             , CASE WHEN vbMovementDescId = zc_Movement_Service() AND vbIsAccount_50401 = TRUE -- Расходы будущих периодов + Услуги по маркетингу
                         THEN _tmpItem.ObjectDescId -- из предыдущей проводки

                    WHEN vbMovementDescId = zc_Movement_Service() AND vbIsAccount_60301 = TRUE -- Прибыль будущих периодов + Бонусы от поставщиков
                         THEN _tmpItem.ObjectDescId -- из предыдущей проводки

                    WHEN MILinkObject_Asset.ObjectId > 0 AND _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() -- Инвестиции
                         THEN zc_Object_InfoMoney() -- дублируем УП, попадет в ОС

                    WHEN vbIsChild = TRUE
                         THEN _tmpItem.ObjectDescId -- из предыдущей проводки - дублируем для zc_Movement_ProfitLossService

                    -- если это Расчеты с участниками
                    WHEN ObjectLink_Unit_Founder.ChildObjectId >  0
                         THEN zc_Object_Founder()

                    ELSE 0 -- значит попадет в ОПиУ

               END AS ObjectDescId

             , CASE WHEN _tmpItem.OperDate >= zc_DateStart_Asset() AND _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() AND vbMovementDescId = zc_Movement_Service()
                         THEN 0
                    ELSE -1 * _tmpItem.OperSumm + (-1) * COALESCE (MI_Child.Amount, 0)
               END AS OperSumm

             , CASE WHEN _tmpItem.OperDate >= zc_DateStart_Asset() AND _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() AND vbMovementDescId = zc_Movement_Service()
                         THEN -1 * _tmpItem.OperSumm_Asset
                    ELSE 0
               END AS OperSumm_Asset

             , _tmpItem.MovementItemId

             , 0 AS ContainerId    -- сформируем позже
             , 0 AS AccountGroupId -- сформируем позже, или ...
             , CASE WHEN MILinkObject_Asset.ObjectId > 0 AND _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() -- Инвестиции
                         THEN -- определяется сразу здесь
                              COALESCE ((SELECT tmp.AccountDirectionId FROM lfGet_Object_Unit_byAccountDirection_Asset (_tmpItem.UnitId) AS tmp), 0)
                    ELSE 0 -- сформируем позже, или ...
               END AS AccountDirectionId

             , CASE WHEN vbMovementDescId = zc_Movement_Service() AND vbIsAccount_50401 = TRUE
                         THEN zc_Enum_Account_50401() -- Расходы будущих периодов - Маркетинг
                    WHEN vbMovementDescId = zc_Movement_Service() AND vbIsAccount_60301 = TRUE
                         THEN zc_Enum_Account_60301() -- Прибыль будущих периодов + Бонусы от поставщиков
                    WHEN vbIsChild = TRUE
                         THEN zc_Enum_Account_51101() -- Распределение маркетинг + Услуги по маркетингу + Маркетинг
                    ELSE 0
               END AS AccountId

               -- Группы ОПиУ (для затрат)
             , COALESCE (lfObject_Unit_byProfitLossDirection.ProfitLossGroupId, 0) AS ProfitLossGroupId
               -- Аналитики ОПиУ - направления (для затрат)
             , COALESCE (lfObject_Unit_byProfitLossDirection.ProfitLossDirectionId, 0) AS ProfitLossDirectionId

               -- Управленческие группы назначения
             , _tmpItem.InfoMoneyGroupId
               -- Управленческие назначения
             , _tmpItem.InfoMoneyDestinationId
               -- Управленческие статьи назначения
             , _tmpItem.InfoMoneyId

               -- Бизнес Баланс: всегда из предыдущей проводки (а значение кстати=0)
             , _tmpItem.BusinessId_Balance
               -- Бизнес ОПиУ: ObjectLink_Unit_Business
             , COALESCE (ObjectLink_Unit_Business.ChildObjectId, 0) AS BusinessId_ProfitLoss

               -- Главное Юр.лицо всегда из договора
             , _tmpItem.JuridicalId_Basis

             , _tmpItem.UnitId -- из предыдущей проводки
             , 0 AS PositionId -- не используется

               -- Филиал Баланс: всегда из предыдущей проводки
             , _tmpItem.BranchId_Balance
               -- Филиал ОПиУ: всегда из предыдущей проводки
             , COALESCE (MILinkObject_Branch.ObjectId, _tmpItem.BranchId_ProfitLoss)

               -- Месяц начислений: не используется
             , 0 AS ServiceDateId

             , _tmpItem.ContractId -- из предыдущей проводки
             , _tmpItem.PaidKindId -- из предыдущей проводки

             , 0 AS PartionMovementId                               -- не используется
             , 0 AS PartionGoodsId                                  -- сформируем позже, надо для Партии услуг (т.е. НЕ списываем в ОПиУ)

             , CASE WHEN _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() -- Инвестиции
                         THEN COALESCE (MILinkObject_Asset.ObjectId, 0) -- надо для Партии услуг (т.е. НЕ списываем в ОПиУ)
                    ELSE 0
               END AS AssetId

             , 0 AS AnalyzerId -- заполнено !!!только!!! для первой
             , 0 AS ObjectIntId_Analyzer

             , NOT _tmpItem.IsActive
             , NOT _tmpItem.IsMaster
        FROM _tmpItem
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Founder
                                  ON ObjectLink_Unit_Founder.ObjectId = _tmpItem.UnitId
                                 AND ObjectLink_Unit_Founder.DescId   = zc_ObjectLink_Unit_Founder()

             LEFT JOIN ObjectLink AS ObjectLink_Unit_Business ON ObjectLink_Unit_Business.ObjectId = _tmpItem.UnitId
                                                             AND ObjectLink_Unit_Business.DescId = zc_ObjectLink_Unit_Business()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Contract ON ObjectLink_Unit_Contract.ObjectId = _tmpItem.UnitId
                                                             AND ObjectLink_Unit_Contract.DescId = zc_ObjectLink_Unit_Contract()
             LEFT JOIN lfSelect_Object_Unit_byProfitLossDirection() AS lfObject_Unit_byProfitLossDirection ON lfObject_Unit_byProfitLossDirection.UnitId = _tmpItem.UnitId
                                                                                                          AND NOT (vbMovementDescId = zc_Movement_Service() AND vbIsAccount_50401 = TRUE) -- !!!нужен только для затрат!!!
                                                                                                          AND vbIsChild = FALSE
                                                                                                          -- игнорируем Подразделение для Собственный капитал + Представительские, пакеты, подарки
                                                                                                          AND _tmpItem.InfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_80600()
                                                                                                          
             LEFT JOIN (SELECT tmpMI_Child.ParentId, SUM (tmpMI_Child.Amount) AS Amount FROM tmpMI_Child GROUP BY tmpMI_Child.ParentId) AS MI_Child ON MI_Child.ParentId = _tmpItem.MovementItemId
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                              ON MILinkObject_Branch.MovementItemId = NULL -- MI_Child.MovementItemId
                                             AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()

             LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                              ON MILinkObject_Asset.MovementItemId = _tmpItem.MovementItemId
                                             AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
                                             AND _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() -- Инвестиции
        WHERE (ObjectLink_Unit_Contract.ChildObjectId IS NULL -- !!!если НЕ перевыставление!!!
           AND (_tmpItem.OperDate < zc_DateStart_Asset() OR _tmpItem.InfoMoneyGroupId <> zc_Enum_InfoMoneyGroup_70000() OR vbMovementDescId <> zc_Movement_Service())
              )
           OR MILinkObject_Asset.ObjectId IS NOT NULL        -- !!!если ОС!!!

       UNION ALL
         -- 1.2.2. Перевыставление затрат на Юр Лицо
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate
             , COALESCE (ObjectLink_Contract_Juridical.ChildObjectId, 0) AS ObjectId
             , COALESCE (Object.DescId, 0) AS ObjectDescId
             , -1 * _tmpItem.OperSumm AS OperSumm
             , 0                      AS OperSumm_Asset
             , _tmpItem.MovementItemId

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

               -- Филиал Баланс: всегда "Главный филиал" (нужен для НАЛ долгов)
             , zc_Branch_Basis() AS BranchId_Balance
               -- Филиал ОПиУ: здесь не используется
             , 0 AS BranchId_ProfitLoss

               -- Месяц начислений: не используется
             , 0 AS ServiceDateId

             , ObjectLink_Unit_Contract.ChildObjectId     AS ContractId
             , ObjectLink_Contract_PaidKind.ChildObjectId AS PaidKindId

             , 0 AS PartionMovementId -- не используется
             , 0 AS PartionGoodsId    -- заполнено !!!только!!! для предыдущей
             , 0 AS AssetId           -- заполнено !!!только!!! для предыдущей

             , 0 AS AnalyzerId -- заполнено !!!только!!! для первой
             , 0 AS ObjectIntId_Analyzer

             , NOT _tmpItem.IsActive
             , NOT _tmpItem.IsMaster
        FROM _tmpItem
             INNER JOIN ObjectLink AS ObjectLink_Unit_Contract ON ObjectLink_Unit_Contract.ObjectId = _tmpItem.UnitId
                                                              AND ObjectLink_Unit_Contract.DescId = zc_ObjectLink_Unit_Contract()
             LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical ON ObjectLink_Contract_Juridical.ObjectId = ObjectLink_Unit_Contract.ChildObjectId
                                                                  AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
             LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind ON ObjectLink_Contract_PaidKind.ObjectId = ObjectLink_Unit_Contract.ChildObjectId
                                                                 AND ObjectLink_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()
             LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis ON ObjectLink_Contract_JuridicalBasis.ObjectId = ObjectLink_Unit_Contract.ChildObjectId
                                                                       AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
             LEFT JOIN Object ON Object.Id = ObjectLink_Contract_Juridical.ChildObjectId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                              ON MILinkObject_Asset.MovementItemId = _tmpItem.MovementItemId
                                             AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
                                             AND _tmpItem.InfoMoneyGroupId <> zc_Enum_InfoMoneyGroup_70000()

        WHERE ObjectLink_Unit_Contract.ChildObjectId > 0 -- !!!если перевыставление!!!
          AND MILinkObject_Asset.ObjectId IS NULL        -- !!!если НЕ ОС!!!
          AND (_tmpItem.OperDate < zc_DateStart_Asset() OR _tmpItem.InfoMoneyGroupId <> zc_Enum_InfoMoneyGroup_70000() OR vbMovementDescId <> zc_Movement_Service())

       UNION ALL
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate

             , MI_Child.MovementId_begin AS ObjectId

             , -1 * zc_Movement_Sale() AS ObjectDescId

             , 1 * MI_Child.Amount  AS OperSumm

             , 0                    AS OperSumm_Asset

             , _tmpItem.MovementItemId

             , 0 AS ContainerId    -- сформируем позже
             , 0 AS AccountGroupId -- сформируем позже, или ...

             , 0 AS AccountDirectionId -- сформируем позже, или ...

             , zc_Enum_Account_51201()  AS AccountId -- Распределение маркетинг + Маркетинг в накладных + Маркетинг

               -- Группы ОПиУ (для затрат)
             , 0 AS ProfitLossGroupId
               -- Аналитики ОПиУ - направления (для затрат)
             , 0 AS ProfitLossDirectionId

               -- Управленческие группы назначения
             , _tmpItem.InfoMoneyGroupId
               -- Управленческие назначения
             , _tmpItem.InfoMoneyDestinationId
               -- Управленческие статьи назначения
             , _tmpItem.InfoMoneyId

               -- Бизнес Баланс: всегда из предыдущей проводки (а значение кстати=0)
             , _tmpItem.BusinessId_Balance
               -- Бизнес ОПиУ: ObjectLink_Unit_Business
             , 0 AS BusinessId_ProfitLoss

               -- Главное Юр.лицо всегда из договора
             , _tmpItem.JuridicalId_Basis

             , 0 AS UnitId     -- не используется
             , 0 AS PositionId -- не используется

               -- Филиал Баланс: всегда из предыдущей проводки
             , _tmpItem.BranchId_Balance
               -- Филиал ОПиУ: всегда из предыдущей проводки
             , _tmpItem.BranchId_ProfitLoss

               -- Месяц начислений: не используется
             , 0 AS ServiceDateId

             , _tmpItem.ContractId -- из предыдущей проводки
             , _tmpItem.PaidKindId -- из предыдущей проводки

             , CASE WHEN ObjectFloat.ObjectId > 0 THEN ObjectFloat.ObjectId
                    ELSE lpInsertFind_Object_PartionMovement (inMovementId := MI_Child.MovementId_begin
                                                            , inPaymentDate:= _tmpItem.OperDate
                                                             )
               END AS PartionMovementId                             -- !!! используется !!!
             , 0 AS PartionGoodsId                                  -- сформируем позже, надо для Партии услуг (т.е. НЕ списываем в ОПиУ)
             , 0 AS AssetId                                         -- надо для Партии услуг (т.е. НЕ списываем в ОПиУ)

             , 0 AS AnalyzerId -- заполнено !!!только!!! для первой
             , MILinkObject_BonusKind.ObjectId AS ObjectIntId_Analyzer

             , _tmpItem.IsActive
             , NOT _tmpItem.IsMaster
        FROM _tmpItem
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Business ON ObjectLink_Unit_Business.ObjectId = _tmpItem.UnitId
                                                             AND ObjectLink_Unit_Business.DescId = zc_ObjectLink_Unit_Business()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Contract ON ObjectLink_Unit_Contract.ObjectId = _tmpItem.UnitId
                                                             AND ObjectLink_Unit_Contract.DescId = zc_ObjectLink_Unit_Contract()
             INNER JOIN tmpMI_Child AS MI_Child ON MI_Child.ParentId = _tmpItem.MovementItemId
             LEFT JOIN MovementItemLinkObject AS MILinkObject_BonusKind
                                              ON MILinkObject_BonusKind.MovementItemId = _tmpItem.MovementItemId
                                             AND MILinkObject_BonusKind.DescId         = zc_MILinkObject_BonusKind()

             LEFT JOIN ObjectFloat ON ObjectFloat.ValueData = MI_Child.MovementId_begin AND ObjectFloat.DescId = zc_ObjectFloat_PartionMovement_MovementId()
           --LEFT JOIN ObjectDate  ON ObjectDate.ObjectId = ObjectFloat.ObjectId AND ObjectDate.DescId = zc_ObjectDate_PartionMovement_Payment()
       ;


     -- проверка 1.1. - для ОС
     IF EXISTS (SELECT 1 FROM _tmpItem WHERE _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_70100() -- Капитальные инвестиции
                                                                               , zc_Enum_InfoMoneyDestination_70200() -- Капитальный ремонт
                                                                               , zc_Enum_InfoMoneyDestination_70400() -- Капитальное строительство
                                                                                )
               )
     AND NOT EXISTS (SELECT _tmpItem.AssetId FROM _tmpItem WHERE _tmpItem.AssetId > 0)
     THEN
         RAISE EXCEPTION 'Ошибка.Для УП статьи <%> необходимо заполнить значение <для Основного средства>.Проведение невозможно.<%>'
                       , lfGet_Object_ValueData ((SELECT _tmpItem.InfoMoneyId FROM _tmpItem LIMIT 1))
                       , (SELECT COUNT(*) FROM _tmpItem WHERE _tmpItem.AssetId > 0)
                        ;
     END IF;

     -- проверка 1.2. - для ОС
     IF EXISTS (SELECT 1 FROM _tmpItem WHERE _tmpItem.InfoMoneyId IN (8945    -- Общефирменные + Услуги полученные + Аренда оборудования
                                                                    , 7900450 -- Общефирменные + Услуги полученные + Ремонт оборудования
                                                                     )
               )
        AND NOT EXISTS (SELECT 1
                        FROM _tmpItem
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                              ON MILinkObject_Asset.MovementItemId = _tmpItem.MovementItemId
                                                             AND MILinkObject_Asset.DescId         = zc_MILinkObject_Asset()
                        WHERE MILinkObject_Asset.ObjectId > 0
                       )
     THEN
         RAISE EXCEPTION 'Ошибка.Для УП статьи <%> необходимо заполнить значение <для Основного средства>.Проведение невозможно.<%>'
                       , lfGet_Object_ValueData ((SELECT _tmpItem.InfoMoneyId FROM _tmpItem LIMIT 1))
                       , (SELECT COUNT(*) FROM _tmpItem WHERE _tmpItem.AssetId > 0)
                        ;
     END IF;

     -- проверка2 - для ОС
     IF EXISTS (SELECT _tmpItem.UnitId FROM _tmpItem WHERE _tmpItem.AssetId > 0 AND _tmpItem.AccountDirectionId = 0)
     THEN
         RAISE EXCEPTION 'Ошибка.Неверно установлено подразделение <%> т.к. нельзя определить направление для счета <%>.Проведение невозможно.', lfGet_Object_ValueData ((SELECT _tmpItem.UnitId FROM _tmpItem WHERE _tmpItem.AssetId > 0 AND _tmpItem.AccountDirectionId = 0 LIMIT 1)), lfGet_Object_ValueData (zc_Enum_AccountGroup_10000()); -- Необоротные активы
     END IF;


     -- 5.1. ФИНИШ - формируем/сохраняем Проводки
     PERFORM lpComplete_Movement_Finance (inMovementId := inMovementId
                                        , inUserId     := inUserId);

     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := vbMovementDescId
                                , inUserId     := inUserId
                                 );

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.09.14                                        * add PositionId and ServiceDateId and BusinessId_... and BranchId_...
 17.08.14                                        * add MovementDescId
 25.05.14                                        * add lpComplete_Movement
 10.05.14                                        * add lpInsert_MovementProtocol
 21.03.14                                        * add zc_Enum_InfoMoneyDestination_21500
 10.03.14                                        * add zc_Movement_ProfitLossService
 22.01.14                                        * add IsMaster
 28.12.13                                        *
*/

-- тест
/*
     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();
 SELECT * FROM lpComplete_Movement_Service (inMovementId:= 4139, inUserId:= zfCalc_UserAdmin() :: Integer)
*/
-- SELECT * FROM lpUnComplete_Movement (inMovementId:= 4139, inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 4139, inSession:= zfCalc_UserAdmin())
