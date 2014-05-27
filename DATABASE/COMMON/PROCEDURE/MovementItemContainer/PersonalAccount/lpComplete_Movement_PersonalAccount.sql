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
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;


     -- Эти параметры нужны для формирования Аналитик в проводках
     SELECT _tmp.MemberId_From
            INTO vbMemberId_From
     FROM (SELECT COALESCE (ObjectLink_Personal_Member.ChildObjectId, 0) AS MemberId_From
                , COALESCE (ObjectLink_Unit_Juridical.ChildObjectId, zc_Juridical_Basis())  AS JuridicalId_Basis
                , COALESCE (ObjectLink_Unit_Business.ChildObjectId, 0)   AS BusinessId_PersonalFrom
           FROM Movement
                LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                             ON MovementLinkObject_Personal.MovementId = Movement.Id
                                            AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
                LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                     ON ObjectLink_Personal_Unit.ObjectId = MovementLinkObject_Personal.ObjectId
                                    AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Car_Unit()
                LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                     ON ObjectLink_Personal_Member.ObjectId = MovementLinkObject_Personal.ObjectId
                                    AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()

                LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                     ON ObjectLink_Unit_Juridical.ObjectId = ObjectLink_Personal_Unit.ChildObjectId
                                    AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                LEFT JOIN ObjectLink AS ObjectLink_Unit_Business
                                     ON ObjectLink_Unit_Business.ObjectId = ObjectLink_Personal_Unit.ChildObjectId
                                    AND ObjectLink_Unit_Business.DescId = zc_ObjectLink_Unit_Business()

           WHERE Movement.Id = inMovementId
             AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             AND Movement.DescId = zc_Movement_PersonalAccount()
          ) AS _tmp;


     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (OperDate, ObjectId, ObjectDescId, OperSumm
                         , MovementItemId, ContainerId
                         , AccountGroupId, AccountDirectionId, AccountId
                         , ProfitLossGroupId, ProfitLossDirectionId
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId, JuridicalId_Basis
                         , UnitId, BranchId, ContractId, PaidKindId
                         , IsActive, IsMaster
                          )
        SELECT Movement.OperDate
             , COALESCE (MovementItem.ObjectId, 0) AS ObjectId
             , COALESCE (Object.DescId, 0) AS ObjectDescId
             , MovementItem.Amount AS OperSumm
             , MovementItem.Id AS MovementItemId
             , 0 AS ContainerId                                               -- сформируем позже
             , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId   -- сформируем позже
               -- Группы ОПиУ
             , 0 AS ProfitLossGroupId
               -- Аналитики ОПиУ - направления
             , 0 AS ProfitLossDirectionId
               -- Управленческие группы назначения
             , COALESCE (View_InfoMoney.InfoMoneyGroupId, 0) AS InfoMoneyGroupId
               -- Управленческие назначения
             , COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
               -- Управленческие статьи назначения
             , COALESCE (View_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId
               -- Бизнес: всегда по принадлежности маршрута к подразделению, а не по подразделению за которым числится сотрудник (кто выдавал деньги)
             , COALESCE (ObjectLink_UnitRoute_Business.ChildObjectId, 0) AS BusinessId
               -- Главное Юр.лицо: всегда по договору, а не по подразделению за которым числится сотрудник (кто выдавал деньги)
             , COALESCE (ObjectLink_Contract_JuridicalBasis.ChildObjectId, 0) AS JuridicalId_Basis
             , 0 AS UnitId
             , 0 AS BranchId
             , COALESCE (MILinkObject_Contract.ObjectId, 0) AS ContractId
             , zc_Enum_PaidKind_SecondForm() AS PaidKindId
             , TRUE
             , TRUE AS IsMaster
        FROM Movement
             JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
                              AND MovementItem.isErased   = FALSE
             LEFT JOIN Object ON Object.Id = MovementItem.ObjectId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_Route
                                              ON MILinkObject_Route.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Route.DescId = zc_MILinkObject_Route()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                              ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                             AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                              ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()

             LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis ON ObjectLink_Contract_JuridicalBasis.ObjectId = MILinkObject_Contract.ObjectId
                                                                       AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()

             LEFT JOIN ObjectLink AS ObjectLink_Route_Unit
                                  ON ObjectLink_Route_Unit.ObjectId = MILinkObject_Route.ObjectId
                                 AND ObjectLink_Route_Unit.DescId = zc_ObjectLink_Route_Unit()
             LEFT JOIN ObjectLink AS ObjectLink_UnitRoute_Business
                                  ON ObjectLink_UnitRoute_Business.ObjectId = ObjectLink_Route_Unit.ChildObjectId
                                 AND ObjectLink_UnitRoute_Business.DescId = zc_ObjectLink_Unit_Business()

             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId
        WHERE Movement.Id = inMovementId
          AND Movement.DescId = zc_Movement_PersonalAccount()
          AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
       ;


     -- проверка
     IF EXISTS (SELECT _tmpItem.JuridicalId_Basis FROM _tmpItem WHERE _tmpItem.JuridicalId_Basis = 0)
     THEN
         RAISE EXCEPTION 'Ошибка.У <Договора> не установлено главное юр лицо. Проведение невозможно.';
     END IF;
     -- проверка
     IF EXISTS (SELECT _tmpItem.ObjectId FROM _tmpItem WHERE _tmpItem.ObjectId = 0)
     THEN
         RAISE EXCEPTION 'В документе не определено <Юридическое лицо> для расчетов. Проведение невозможно.';
     END IF;
   

     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (OperDate, ObjectId, ObjectDescId, OperSumm
                         , MovementItemId, ContainerId
                         , AccountGroupId, AccountDirectionId, AccountId
                         , ProfitLossGroupId, ProfitLossDirectionId
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId, JuridicalId_Basis
                         , UnitId, BranchId, ContractId, PaidKindId
                         , IsActive, IsMaster
                          )
        SELECT _tmpItem.OperDate
             , vbMemberId_From AS ObjectId
             , zc_Object_Member() AS ObjectDescId
             , -1 * _tmpItem.OperSumm
             , _tmpItem.MovementItemId
             , 0 AS ContainerId                                               -- сформируем позже
             , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId   -- сформируем позже
             , _tmpItem.ProfitLossGroupId, _tmpItem.ProfitLossDirectionId
             , _tmpItem.InfoMoneyGroupId, _tmpItem.InfoMoneyDestinationId, _tmpItem.InfoMoneyId
               -- Бизнес
             , _tmpItem.BusinessId
               -- Главное Юр.лицо
             , _tmpItem.JuridicalId_Basis
             , _tmpItem.UnitId
             , _tmpItem.BranchId
             , _tmpItem.ContractId, _tmpItem.PaidKindId
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
 25.05.14                                        * add lpComplete_Movement
 10.05.14                                        * add lpInsert_MovementProtocol
 25.01.14                                        * all
 27.12.13         * 
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM lpComplete_Movement_PersonalAccount (inMovementId:= 103, inUserId:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
