-- Function: lpComplete_Movement_SendDebtMember (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_SendDebtMember (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_SendDebtMember(
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

 
     --RAISE EXCEPTION 'Ошибка.<%>', (select ObjectDesc.ItemName from _tmpItem join ObjectDesc where ObjectDesc.Id = _tmpItem.DescId limit 1);


     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementDescId, OperDate, ObjectId, ObjectDescId, OperSumm
                         , MovementItemId, ContainerId
                         , AccountGroupId, AccountDirectionId, AccountId
                         , ProfitLossGroupId, ProfitLossDirectionId
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_Balance, BusinessId_ProfitLoss, JuridicalId_Basis
                         , UnitId, CarId, BranchId_Balance, BranchId_ProfitLoss, ServiceDateId, ContractId, PaidKindId
                         , IsActive, IsMaster
                          )
        SELECT Movement.DescId
             , Movement.OperDate
             , COALESCE (MovementItem.ObjectId, 0) AS ObjectId
             , COALESCE (Object.DescId, 0) AS ObjectDescId
             , CASE WHEN MovementItem.DescId = zc_MI_Master() THEN -1 * MovementItem.Amount ELSE 1 * MovementItem.Amount END AS OperSumm
             , MovementItem.Id AS MovementItemId

               -- сформируем позже или...
             , 0 AS ContainerId
               -- сформируем позже или...
             , 0 AS AccountGroupId, 0 AS AccountDirectionId
             , 0 AS AccountId
               -- здесь не используется
             , 0 AS ProfitLossGroupId, 0 AS ProfitLossDirectionId                   -- 

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

               -- Главное Юр.лицо:
             , MILinkObject_JuridicalBasis.ObjectId AS JuridicalId_Basis

             , 0 AS UnitId     -- не используется
               -- используется
             , COALESCE (MILinkObject_Car.ObjectId, 0) AS CarId

               -- Филиал Баланс: !!!определяется Филиал по Пользователю!!!, иначе всегда на Главном филиале
             , MILinkObject_Branch.ObjectId AS BranchId_Balance

               -- Филиал ОПиУ: не используется
             , 0 AS BranchId_ProfitLoss

               -- Месяц начислений: не используется
             , 0 AS ServiceDateId

             , 0 AS ContractId -- не используется
             , 0 AS PaidKindId -- не используется

             , CASE WHEN MovementItem.DescId = zc_MI_Child() THEN TRUE ELSE FALSE END AS IsActive
             , TRUE AS IsMaster
        FROM Movement
             JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                              AND MovementItem.DescId     IN (zc_MI_Master(), zc_MI_Child())
                              AND MovementItem.isErased   = FALSE
             LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                              ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                             AND MILinkObject_InfoMoney.DescId         = zc_MILinkObject_InfoMoney()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                              ON MILinkObject_Branch.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Branch.DescId         = zc_MILinkObject_Branch()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Car
                                              ON MILinkObject_Car.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Car.DescId         = zc_MILinkObject_Car()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_JuridicalBasis
                                              ON MILinkObject_JuridicalBasis.MovementItemId = MovementItem.Id
                                             AND MILinkObject_JuridicalBasis.DescId         = zc_MILinkObject_JuridicalBasis()

             LEFT JOIN Object ON Object.Id = MovementItem.ObjectId

             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId

        WHERE Movement.Id = inMovementId
          AND Movement.DescId = zc_Movement_SendDebtMember()
          AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
       ;


     -- 5.1. ФИНИШ - формируем/сохраняем Проводки
     PERFORM lpComplete_Movement_Finance (inMovementId := inMovementId
                                        , inUserId     := inUserId);

     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_SendDebtMember()
                                , inUserId     := inUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.10.22         * 
*/

-- тест
--