-- Function: lpComplete_Movement_SendDebt (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_SendDebt (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_SendDebt(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)
RETURNS VOID
--  RETURNS TABLE (MovementItemId Integer, MovementId Integer, OperDate TDateTime, JuridicalId_From Integer, isCorporate Boolean, PersonalId_From Integer, UnitId Integer, BranchId_Unit Integer, PersonalId_Packer Integer, PaidKindId Integer, ContractId Integer, ContainerId_Goods Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, OperCount TFloat, tmpOperSumm_Partner TFloat, OperSumm_Partner TFloat, tmpOperSumm_Packer TFloat, OperSumm_Packer TFloat, AccountDirectionId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, InfoMoneyDestinationId_isCorporate Integer, InfoMoneyId_isCorporate Integer, JuridicalId_basis Integer, BusinessId Integer, isPartionCount Boolean, isPartionSumm Boolean, PartionMovementId Integer, PartionGoodsId Integer)
AS
$BODY$
BEGIN

     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;

     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     WITH tmpMovement AS (SELECT Movement.DescId, Movement.Id AS MovementId, Movement.OperDate
                          FROM Movement
                          WHERE Movement.Id = inMovementId
                            AND Movement.DescId = zc_Movement_SendDebt()
                            AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
                          )
        , tmpMI_Master AS (SELECT tmpMovement.DescId
                                , tmpMovement.OperDate

                                , COALESCE (MovementItem.ObjectId, 0) AS ObjectId
                                , COALESCE (Object.DescId, 0)         AS ObjectDescId

                                , MovementItem.Amount AS OperSumm
                                , CASE WHEN COALESCE (MILinkObject_Currency.ObjectId, zc_Enum_Currency_Basis()) <> zc_Enum_Currency_Basis() AND MIFloat_CurrencyValue.ValueData <> 0
                                            THEN CAST (MovementItem.Amount / MIFloat_CurrencyValue.ValueData * MIFloat_ParValue.ValueData AS NUMERIC (16, 2))
                                       ELSE 0
                                  END AS OperSumm_Currency

                                , MovementItem.Id AS MovementItemId

                                , CASE WHEN MovementItem.MovementId = 15558281 THEN 2470073 ELSE 0 END AS ContainerId -- сформируем позже
                                , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId                        -- сформируем позже
                                , 0 AS ProfitLossGroupId, 0 AS ProfitLossDirectionId                                  -- сформируем позже

                                  -- Управленческие группы назначения
                                , COALESCE (View_InfoMoney.InfoMoneyGroupId, 0) AS InfoMoneyGroupId
                                  -- Управленческие назначения
                                , COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
                                  -- Управленческие статьи назначения
                                , COALESCE (View_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId

                                  -- Бизнес Баланс: не используется
                                , 0 AS BusinessId_Balance
                                  -- Бизнес ОПиУ: не используется
                                , 0 AS BusinessId_ProfitLoss

                                  -- Главное Юр.лицо: всегда из договора
                                , COALESCE (ObjectLink_Contract_JuridicalBasis.ChildObjectId, 0) AS JuridicalId_Basis

                                , 0 AS UnitId     -- не используется
                                , 0 AS PositionId -- не используется

                                  -- Филиал Баланс: нужен для НАЛ долгов
                                , MILinkObject_Branch.ObjectId AS BranchId_Balance
                                  -- Филиал ОПиУ: не используется
                                , 0 AS BranchId_ProfitLoss

                                  -- Месяц начислений: не используется
                                , 0 AS ServiceDateId

                                , COALESCE (MILinkObject_Contract.ObjectId, 0) AS ContractId
                                , COALESCE (MILinkObject_PaidKind.ObjectId, 0) AS PaidKindId

                                , CASE WHEN inMovementId = 16296541 THEN 0 ELSE 0 END AS PartionMovementId

                                  -- Валюта
                                , COALESCE (MILinkObject_Currency.ObjectId, zc_Enum_Currency_Basis()) AS CurrencyId

                                , TRUE AS IsActive
                                , TRUE AS IsMaster
                           FROM tmpMovement
                                JOIN MovementItem ON MovementItem.MovementId = tmpMovement.MovementId AND MovementItem.DescId = zc_MI_Master()

                                LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                                 ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                                 ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                                                 ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                                                 ON MILinkObject_Branch.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()

                                LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                                 ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_Currency.DescId         = zc_MILinkObject_Currency()
                                LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                                            ON MIFloat_CurrencyValue.MovementItemId = MovementItem.Id
                                                           AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()
                                LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                            ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                                           AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()

                                LEFT JOIN Object ON Object.Id = MovementItem.ObjectId
                                LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis ON ObjectLink_Contract_JuridicalBasis.ObjectId = MILinkObject_Contract.ObjectId
                                                                                          AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
                                LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId
                          )
         , tmpMI_Child AS (SELECT tmpMovement.DescId
                                , tmpMovement.OperDate

                                , COALESCE (MovementItem.ObjectId, 0) AS ObjectId
                                , COALESCE (Object.DescId, 0)         AS ObjectDescId

                                , -1 * MovementItem.Amount AS OperSumm
                                , -1 * CASE WHEN COALESCE (MILinkObject_Currency.ObjectId, zc_Enum_Currency_Basis()) <> zc_Enum_Currency_Basis() AND MIFloat_CurrencyValue.ValueData <> 0
                                                 THEN CAST (MovementItem.Amount / MIFloat_CurrencyValue.ValueData * MIFloat_ParValue.ValueData AS NUMERIC (16, 2))
                                                 ELSE 0
                                       END AS OperSumm_Currency

                                , MovementItem.Id AS MovementItemId

                                , 0 AS ContainerId                                                     -- сформируем позже
                                , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId         -- сформируем позже
                                , 0 AS ProfitLossGroupId, 0 AS ProfitLossDirectionId                   -- сформируем позже

                                  -- Управленческие группы назначения
                                , COALESCE (View_InfoMoney.InfoMoneyGroupId, 0) AS InfoMoneyGroupId
                                  -- Управленческие назначения
                                , COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
                                  -- Управленческие статьи назначения
                                , COALESCE (View_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId

                                  -- Бизнес Баланс: не используется
                                , 0 AS BusinessId_Balance
                                  -- Бизнес ОПиУ: не используется
                                , 0 AS BusinessId_ProfitLoss

                                  -- Главное Юр.лицо: всегда из договора
                                , COALESCE (ObjectLink_Contract_JuridicalBasis.ChildObjectId, 0) AS JuridicalId_Basis

                                , 0 AS UnitId     -- не используется
                                , 0 AS PositionId -- не используется

                                  -- Филиал Баланс: нужен для НАЛ долгов
                                , MILinkObject_Branch.ObjectId AS BranchId_Balance
                                  -- Филиал ОПиУ: не используется
                                , 0 AS BranchId_ProfitLoss

                                  -- Месяц начислений: не используется
                                , 0 AS ServiceDateId

                                , COALESCE (MILinkObject_Contract.ObjectId, 0) AS ContractId
                                , COALESCE (MILinkObject_PaidKind.ObjectId, 0) AS PaidKindId

                                , CASE WHEN inMovementId = 16296541 THEN 5081033 ELSE 0 END AS PartionMovementId

                                  -- Валюта
                                , COALESCE (MILinkObject_Currency.ObjectId, zc_Enum_Currency_Basis()) AS CurrencyId

                                , FALSE AS IsActive
                                , FALSE AS IsMaster
                           FROM tmpMovement
                                JOIN MovementItem ON MovementItem.MovementId = tmpMovement.MovementId AND MovementItem.DescId = zc_MI_Child()

                                LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                                 ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                                 ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                                                 ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                                                 ON MILinkObject_Branch.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()

                                LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                                 ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_Currency.DescId         = zc_MILinkObject_Currency()
                                LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                                            ON MIFloat_CurrencyValue.MovementItemId = MovementItem.Id
                                                           AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()
                                LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                            ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                                           AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()

                                LEFT JOIN Object ON Object.Id = MovementItem.ObjectId
                                LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis ON ObjectLink_Contract_JuridicalBasis.ObjectId = MILinkObject_Contract.ObjectId
                                                                                          AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()

                                LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId
                          )

     -- Расчет
     INSERT INTO _tmpItem (MovementDescId, OperDate, ObjectId, ObjectDescId
                         , OperSumm, OperSumm_Currency, OperSumm_Asset, OperSumm_Diff_Asset
                         , MovementItemId, ContainerId
                         , AccountGroupId, AccountDirectionId, AccountId
                         , ProfitLossGroupId, ProfitLossDirectionId
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_Balance, BusinessId_ProfitLoss, JuridicalId_Basis
                         , UnitId, PositionId, BranchId_Balance, BranchId_ProfitLoss, ServiceDateId, ContractId, PaidKindId
                         , PartionMovementId
                         , CurrencyId
                         , IsActive, IsMaster
                          )
        -- Результат
        -- 1.1.
        SELECT tmpMI_Master.DescId
             , tmpMI_Master.OperDate

             , CASE -- сразу в ОПиУ - Инвестиции
                    WHEN tmpMI_Master.OperDate >= zc_DateStart_Asset() AND tmpMI_Master.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000()
                         -- AND 1=0
                         THEN 0
                    ELSE tmpMI_Master.ObjectId
               END AS ObjectId

             , CASE -- сразу в ОПиУ - Инвестиции
                    WHEN tmpMI_Master.OperDate >= zc_DateStart_Asset() AND tmpMI_Master.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000()
                         -- AND 1=0
                         THEN 0
                    ELSE tmpMI_Master.ObjectDescId
               END AS ObjectDescId

               -- Сумма
             , tmpMI_Master.OperSumm
               -- Сумма в Валюте
             , CASE -- сразу в ОПиУ - Инвестиции
                    WHEN tmpMI_Master.OperDate >= zc_DateStart_Asset() AND tmpMI_Master.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000()
                         -- AND 1=0
                         THEN 0
                    ELSE tmpMI_Master.OperSumm_Currency
               END AS OperSumm_Currency

             , 0 AS OperSumm_Asset
             , 0 AS OperSumm_Diff_Asset

             , tmpMI_Master.MovementItemId

             , tmpMI_Master.ContainerId                                                               -- сформируем позже
             , tmpMI_Master.AccountGroupId, tmpMI_Master.AccountDirectionId, tmpMI_Master.AccountId   -- сформируем позже
             , tmpMI_Master.ProfitLossGroupId, tmpMI_Master.ProfitLossDirectionId                     -- сформируем позже

               -- Управленческие группы назначения
             , tmpMI_Master.InfoMoneyGroupId
               -- Управленческие назначения
             , tmpMI_Master.InfoMoneyDestinationId
               -- Управленческие статьи назначения
             , tmpMI_Master.InfoMoneyId

               -- Бизнес Баланс: не используется
             , tmpMI_Master.BusinessId_Balance
               -- Бизнес ОПиУ: не используется
             , tmpMI_Master.BusinessId_ProfitLoss

               -- Главное Юр.лицо: всегда из договора
             , tmpMI_Master.JuridicalId_Basis

             , tmpMI_Master.UnitId     -- не используется
             , tmpMI_Master.PositionId -- не используется

               -- Филиал Баланс: нужен для НАЛ долгов
             , tmpMI_Master.BranchId_Balance
               -- Филиал ОПиУ: не используется
             , tmpMI_Master.BranchId_ProfitLoss

               -- Месяц начислений: не используется
             , tmpMI_Master.ServiceDateId

             , tmpMI_Master.ContractId
             , tmpMI_Master.PaidKindId

             , tmpMI_Master.PartionMovementId

               -- Валюта
             , tmpMI_Master.CurrencyId

             , tmpMI_Master.isActive
             , tmpMI_Master.isMaster

        FROM tmpMI_Master

       UNION ALL
        -- 1.2.
        SELECT tmpMI_Child.DescId
             , tmpMI_Child.OperDate

             , CASE -- сразу в ОПиУ - Инвестиции
                    WHEN tmpMI_Child.OperDate >= zc_DateStart_Asset() AND tmpMI_Child.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000()
                         THEN 0
                    ELSE tmpMI_Child.ObjectId
               END AS ObjectId
             , CASE -- сразу в ОПиУ - Инвестиции
                    WHEN tmpMI_Child.OperDate >= zc_DateStart_Asset() AND tmpMI_Child.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000()
                         THEN 0
                    ELSE tmpMI_Child.ObjectDescId
               END AS ObjectDescId

               -- Сумма
             , tmpMI_Child.OperSumm
               -- Сумма в Валюте
             , CASE -- сразу в ОПиУ - Инвестиции
                    WHEN tmpMI_Child.OperDate >= zc_DateStart_Asset() AND tmpMI_Child.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000()
                         THEN 0
                    ELSE tmpMI_Child.OperSumm_Currency
               END AS OperSumm_Currency

             , 0 AS OperSumm_Asset
             , 0 AS OperSumm_Diff_Asset

             , tmpMI_Child.MovementItemId

             , tmpMI_Child.ContainerId                                                             -- сформируем позже
             , tmpMI_Child.AccountGroupId, tmpMI_Child.AccountDirectionId, tmpMI_Child.AccountId   -- сформируем позже
             , tmpMI_Child.ProfitLossGroupId, tmpMI_Child.ProfitLossDirectionId                    -- сформируем позже

               -- Управленческие группы назначения
             , tmpMI_Child.InfoMoneyGroupId
               -- Управленческие назначения
             , tmpMI_Child.InfoMoneyDestinationId
               -- Управленческие статьи назначения
             , tmpMI_Child.InfoMoneyId

               -- Бизнес Баланс: не используется
             , tmpMI_Child.BusinessId_Balance
               -- Бизнес ОПиУ: не используется
             , tmpMI_Child.BusinessId_ProfitLoss

               -- Главное Юр.лицо: всегда из договора
             , tmpMI_Child.JuridicalId_Basis

             , tmpMI_Child.UnitId     -- не используется
             , tmpMI_Child.PositionId -- не используется

               -- Филиал Баланс: нужен для НАЛ долгов
             , tmpMI_Child.BranchId_Balance
               -- Филиал ОПиУ: не используется
             , tmpMI_Child.BranchId_ProfitLoss

               -- Месяц начислений: не используется
             , tmpMI_Child.ServiceDateId

             , tmpMI_Child.ContractId
             , tmpMI_Child.PaidKindId

             , tmpMI_Child.PartionMovementId

               -- Валюта
             , tmpMI_Child.CurrencyId

             , tmpMI_Child.isActive
             , tmpMI_Child.isMaster

        FROM tmpMI_Child

       UNION ALL
        -- 2.1. забаланс
        SELECT tmpMI_Master.DescId
             , tmpMI_Master.OperDate

             , tmpMI_Master.ObjectId

             , tmpMI_Master.ObjectDescId

               -- Сумма
             , 0 AS OperSumm
               -- Сумма в Валюте
             , tmpMI_Master.OperSumm_Currency

             , tmpMI_Master.OperSumm AS OperSumm_Asset
             , 0 AS OperSumm_Diff_Asset

             , tmpMI_Master.MovementItemId

             , tmpMI_Master.ContainerId                                                               -- сформируем позже
             , tmpMI_Master.AccountGroupId, tmpMI_Master.AccountDirectionId, tmpMI_Master.AccountId   -- сформируем позже
             , tmpMI_Master.ProfitLossGroupId, tmpMI_Master.ProfitLossDirectionId                     -- сформируем позже

               -- Управленческие группы назначения
             , tmpMI_Master.InfoMoneyGroupId
               -- Управленческие назначения
             , tmpMI_Master.InfoMoneyDestinationId
               -- Управленческие статьи назначения
             , tmpMI_Master.InfoMoneyId

               -- Бизнес Баланс: не используется
             , tmpMI_Master.BusinessId_Balance
               -- Бизнес ОПиУ: не используется
             , tmpMI_Master.BusinessId_ProfitLoss

               -- Главное Юр.лицо: всегда из договора
             , tmpMI_Master.JuridicalId_Basis

             , tmpMI_Master.UnitId     -- не используется
             , tmpMI_Master.PositionId -- не используется

               -- Филиал Баланс: нужен для НАЛ долгов
             , tmpMI_Master.BranchId_Balance
               -- Филиал ОПиУ: не используется
             , tmpMI_Master.BranchId_ProfitLoss

               -- Месяц начислений: не используется
             , tmpMI_Master.ServiceDateId

             , tmpMI_Master.ContractId
             , tmpMI_Master.PaidKindId

             , tmpMI_Master.PartionMovementId

               -- Валюта
             , tmpMI_Master.CurrencyId

             , tmpMI_Master.isActive
             , tmpMI_Master.isMaster

        FROM tmpMI_Master
        WHERE tmpMI_Master.OperDate >= zc_DateStart_Asset() AND tmpMI_Master.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000()

       UNION ALL
        -- 2.2. забаланс
        SELECT tmpMI_Child.DescId
             , tmpMI_Child.OperDate

             , tmpMI_Child.ObjectId
             , tmpMI_Child.ObjectDescId

               -- Сумма
             , 0 AS OperSumm
               -- Сумма в Валюте
             , tmpMI_Child.OperSumm_Currency

             , tmpMI_Child.OperSumm AS OperSumm_Asset
             , 0 AS OperSumm_Diff_Asset

             , tmpMI_Child.MovementItemId

             , tmpMI_Child.ContainerId                                                             -- сформируем позже
             , tmpMI_Child.AccountGroupId, tmpMI_Child.AccountDirectionId, tmpMI_Child.AccountId   -- сформируем позже
             , tmpMI_Child.ProfitLossGroupId, tmpMI_Child.ProfitLossDirectionId                    -- сформируем позже

               -- Управленческие группы назначения
             , tmpMI_Child.InfoMoneyGroupId
               -- Управленческие назначения
             , tmpMI_Child.InfoMoneyDestinationId
               -- Управленческие статьи назначения
             , tmpMI_Child.InfoMoneyId

               -- Бизнес Баланс: не используется
             , tmpMI_Child.BusinessId_Balance
               -- Бизнес ОПиУ: не используется
             , tmpMI_Child.BusinessId_ProfitLoss

               -- Главное Юр.лицо: всегда из договора
             , tmpMI_Child.JuridicalId_Basis

             , tmpMI_Child.UnitId     -- не используется
             , tmpMI_Child.PositionId -- не используется

               -- Филиал Баланс: нужен для НАЛ долгов
             , tmpMI_Child.BranchId_Balance
               -- Филиал ОПиУ: не используется
             , tmpMI_Child.BranchId_ProfitLoss

               -- Месяц начислений: не используется
             , tmpMI_Child.ServiceDateId

             , tmpMI_Child.ContractId
             , tmpMI_Child.PaidKindId

             , tmpMI_Child.PartionMovementId

               -- Валюта
             , tmpMI_Child.CurrencyId

             , tmpMI_Child.isActive
             , tmpMI_Child.isMaster

        FROM tmpMI_Child
        WHERE tmpMI_Child.OperDate >= zc_DateStart_Asset() AND tmpMI_Child.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000()
       ;


     -- проверка
     IF EXISTS (SELECT _tmpItem.ObjectId FROM _tmpItem WHERE _tmpItem.ObjectId = 0 AND _tmpItem.IsMaster = TRUE)
        AND NOT EXISTS (SELECT _tmpItem.ObjectId FROM _tmpItem WHERE _tmpItem.ObjectId <> 0 AND _tmpItem.IsMaster = TRUE)
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определено <Юридическое лицо (Дебет)>.Проведение невозможно.';
     END IF;
     IF EXISTS (SELECT _tmpItem.JuridicalId_Basis FROM _tmpItem WHERE _tmpItem.JuridicalId_Basis = 0 AND _tmpItem.IsMaster = TRUE)
     THEN
         RAISE EXCEPTION 'Ошибка.У <Договора (Дебет)> не установлено главное юр лицо.Проведение невозможно.';
     END IF;
     -- проверка
     IF EXISTS (SELECT _tmpItem.ObjectId FROM _tmpItem WHERE _tmpItem.ObjectId = 0 AND _tmpItem.IsMaster = FALSE)
        AND NOT EXISTS (SELECT _tmpItem.ObjectId FROM _tmpItem WHERE _tmpItem.ObjectId <> 0 AND _tmpItem.IsMaster = FALSE)
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определено <Юридическое лицо (Кредит)>.Проведение невозможно.';
     END IF;
     IF EXISTS (SELECT _tmpItem.JuridicalId_Basis FROM _tmpItem WHERE _tmpItem.JuridicalId_Basis = 0 AND _tmpItem.IsMaster = FALSE)
     THEN
         RAISE EXCEPTION 'Ошибка.У <Договора (Кредит)> не установлено главное юр лицо.Проведение невозможно.';
     END IF;

     -- 5.1. ФИНИШ - формируем/сохраняем Проводки
     PERFORM lpComplete_Movement_Finance (inMovementId := inMovementId
                                        , inUserId     := inUserId);

     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_SendDebt()
                                , inUserId     := inUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 12.09.14                                        * add PositionId and ServiceDateId and BusinessId_... and BranchId_...
 17.08.14                                        * add MovementDescId
 25.05.14                                        * add lpComplete_Movement
 10.05.14                                        * add lpInsert_MovementProtocol
 28.01.14                                        * all
 27.01.14         *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM lpComplete_Movement_SendDebt (inMovementId:= 103, inUserId:= zfCalc_UserAdmin())
