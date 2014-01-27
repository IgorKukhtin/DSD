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

  DECLARE vbJuridicalId_Basis Integer;
  DECLARE vbBusinessId_PersonalFrom Integer;
BEGIN

     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;


     -- Эти параметры нужны для формирования Аналитик в проводках
     SELECT _tmp.MemberId_From
          , _tmp.JuridicalId_Basis, _tmp.BusinessId_PersonalFrom
            INTO vbMemberId_From
               , vbJuridicalId_Basis, vbBusinessId_PersonalFrom -- эти аналитики берутся у подразделения за которым числится сотрудник (кто выдавал деньги)
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


     -- проверка
     IF COALESCE (vbJuridicalId_Basis, 0) = 0
     THEN
         RAISE EXCEPTION 'У сотрудника <%> не установлено главное юр лицо. Проведение невозможно.', lfGet_Object_ValueData (vbMemberId_From);
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
               -- Бизнес: по подразделению за которым числится сотрудник (кто выдавал деньги)
             , vbBusinessId_PersonalFrom AS BusinessId
               -- Главное Юр.лицо: по подразделению за которым числится сотрудник (кто выдавал деньги)
             , vbJuridicalId_Basis AS JuridicalId_Basis
             , 0 AS UnitId
             , 0 AS BranchId
             , COALESCE (MILinkObject_Contract.ObjectId, 0) AS ContractId
             , zc_Enum_PaidKind_SecondForm() AS PaidKindId
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
             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId
        WHERE Movement.Id = inMovementId
          AND Movement.DescId = zc_Movement_PersonalAccount()
          AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
       ;


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

     -- проводим Документ
     PERFORM lpComplete_Movement_Finance (inMovementId := inMovementId
                                        , inUserId     := inUserId);

     -- 5.2. ФИНИШ - Обязательно меняем статус документа
     UPDATE Movement SET StatusId = zc_Enum_Status_Complete() WHERE Id = inMovementId AND DescId = zc_Movement_PersonalAccount() AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 25.01.14                                        * all
 27.12.13         * 
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM lpComplete_Movement_PersonalAccount (inMovementId:= 103, inUserId:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
