-- Function: lpComplete_Movement_PersonalAccount (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_PersonalAccount (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_PersonalAccount(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)                              
RETURNS void
--  RETURNS TABLE (MovementItemId Integer, MovementId Integer, OperDate TDateTime, JuridicalId_From Integer, isCorporate Boolean, PersonalId_From Integer, UnitId Integer, BranchId_Unit Integer, PersonalId_Packer Integer, PaidKindId Integer, ContractId Integer, ContainerId_Goods Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, OperCount TFloat, tmpOperSumm_Partner TFloat, OperSumm_Partner TFloat, tmpOperSumm_Packer TFloat, OperSumm_Packer TFloat, AccountDirectionId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, InfoMoneyDestinationId_isCorporate Integer, InfoMoneyId_isCorporate Integer, JuridicalId_basis Integer, BusinessId Integer, isPartionCount Boolean, isPartionSumm Boolean, PartionMovementId Integer, PartionGoodsId Integer)
AS
$BODY$
  DECLARE vbMemberId_From Integer;
BEGIN

     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;


     -- Эти параметры нужны для формирования Аналитик в проводках
     SELECT _tmp.MemberId_From
            INTO vbMemberId_From
     FROM (SELECT COALESCE (ObjectLink_Personal_Member.ChildObjectId, 0) AS MemberId_From
           FROM Movement
                LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                             ON MovementLinkObject_Personal.MovementId = Movement.Id
                                            AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
                LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                     ON ObjectLink_Personal_Member.ObjectId = MovementLinkObject_Personal.ObjectId
                                    AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
           WHERE Movement.Id = inMovementId
             AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             AND Movement.DescId = zc_Movement_PersonalAccount()
          ) AS _tmp;


     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementDescId, OperDate, ObjectId, ObjectDescId, OperSumm
                         , MovementItemId, ContainerId
                         , AccountGroupId, AccountDirectionId, AccountId
                         , ProfitLossGroupId, ProfitLossDirectionId
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_Balance, BusinessId_ProfitLoss, JuridicalId_Basis
                         , UnitId, PositionId, BranchId_Balance, BranchId_ProfitLoss, ServiceDateId, ContractId, PaidKindId
                         , IsActive, IsMaster
                          )
        SELECT Movement.DescId
             , Movement.OperDate
             , COALESCE (MovementItem.ObjectId, 0) AS ObjectId
             , COALESCE (Object.DescId, 0) AS ObjectDescId
             , MovementItem.Amount AS OperSumm
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

               -- Бизнес Баланс: не используется (хотя было - всегда по принадлежности маршрута к подразделению, а не по подразделению за которым числится сотрудник производивший расчеты)
             , 0 AS BusinessId_Balance
               -- Бизнес ОПиУ: не используется
             , 0 AS BusinessId_ProfitLoss

               -- Главное Юр.лицо: всегда из договора (а не по подразделению за которым числится сотрудник производивший расчеты)
             , COALESCE (ObjectLink_Contract_JuridicalBasis.ChildObjectId, 0) AS JuridicalId_Basis

             , 0 AS UnitId     -- не используется
             , 0 AS PositionId -- не используется

               -- Филиал Баланс: пока "Главный филиал" (нужен для НАЛ долгов)
             , zc_Branch_Basis() AS BranchId_Balance
               -- Филиал ОПиУ: не используется
             , 0 AS BranchId_ProfitLoss

               -- Месяц начислений: не используется
             , 0 AS ServiceDateId

             , COALESCE (MILinkObject_Contract.ObjectId, 0) AS ContractId
             , zc_Enum_PaidKind_SecondForm()                AS PaidKindId -- Всегда НАЛ

             , TRUE
             , TRUE AS IsMaster
        FROM Movement
             JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
                              AND MovementItem.isErased   = FALSE
             LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                              ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                             AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                              ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()

             LEFT JOIN Object ON Object.Id = MovementItem.ObjectId
             LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis ON ObjectLink_Contract_JuridicalBasis.ObjectId = MILinkObject_Contract.ObjectId
                                                                       AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId
        WHERE Movement.Id = inMovementId
          AND Movement.DescId = zc_Movement_PersonalAccount()
          AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
       ;


     -- проверка
     IF EXISTS (SELECT _tmpItem.ObjectId FROM _tmpItem WHERE _tmpItem.ObjectId = 0 OR _tmpItem.ObjectDescId <> zc_Object_Juridical())
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
     INSERT INTO _tmpItem (MovementDescId, OperDate, ObjectId, ObjectDescId, OperSumm
                         , MovementItemId, ContainerId
                         , AccountGroupId, AccountDirectionId, AccountId
                         , ProfitLossGroupId, ProfitLossDirectionId
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_Balance, BusinessId_ProfitLoss, JuridicalId_Basis
                         , UnitId, PositionId, BranchId_Balance, BranchId_ProfitLoss, ServiceDateId, ContractId, PaidKindId
                         , IsActive, IsMaster
                          )
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate
             , vbMemberId_From    AS ObjectId
             , zc_Object_Member() AS ObjectDescId
             , -1 * _tmpItem.OperSumm
             , _tmpItem.MovementItemId

             , 0 AS ContainerId                                                     -- сформируем позже
             , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId         -- сформируем позже
             , 0 AS ProfitLossGroupId, 0 AS ProfitLossDirectionId                   -- не используется

               -- Управленческие группы назначения
             , _tmpItem.InfoMoneyGroupId
               -- Управленческие назначения
             , _tmpItem.InfoMoneyDestinationId
               -- Управленческие статьи назначения
             , _tmpItem.InfoMoneyId

               -- Бизнес Баланс: всегда из предыдущей проводки (а значение кстати=0)
             , _tmpItem.BusinessId_Balance
               -- Бизнес ОПиУ: не используется
             , 0 AS BusinessId_ProfitLoss

               -- Главное Юр.лицо всегда из договора
             , _tmpItem.JuridicalId_Basis

             , 0 AS UnitId     -- не используется
             , 0 AS PositionId -- не используется

               -- Филиал Баланс: всегда из предыдущей проводки (нужен для долгов подотчета)
             , _tmpItem.BranchId_Balance
               -- Филиал ОПиУ: не используется
             , 0 AS BranchId_ProfitLoss 

               -- Месяц начислений: не используется
             , 0 AS ServiceDateId

             , 0 AS ContractId -- не используется
             , 0 AS PaidKindId -- не используется

             , NOT _tmpItem.IsActive
             , NOT _tmpItem.IsMaster
        FROM _tmpItem
       ;

     -- 5.1. ФИНИШ - формируем/сохраняем Проводки
     PERFORM lpComplete_Movement_Finance (inMovementId := inMovementId
                                        , inUserId     := inUserId);

     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_PersonalAccount()
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
 25.01.14                                        * all
 27.12.13         * 
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM lpComplete_Movement_PersonalAccount (inMovementId:= 103, inUserId:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
