-- Function: lpComplete_Movement_LossDebt (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_LossDebt (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_LossDebt(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)                              
RETURNS VOID
--  RETURNS TABLE (MovementItemId Integer, MovementId Integer, OperDate TDateTime, JuridicalId_From Integer, isCorporate Boolean, PersonalId_From Integer, UnitId Integer, BranchId_Unit Integer, PersonalId_Packer Integer, PaidKindId Integer, ContractId Integer, ContainerId_Goods Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, OperCount TFloat, tmpOperSumm_Partner TFloat, OperSumm_Partner TFloat, tmpOperSumm_Packer TFloat, OperSumm_Packer TFloat, AccountDirectionId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, InfoMoneyDestinationId_isCorporate Integer, InfoMoneyId_isCorporate Integer, JuridicalId_basis Integer, BusinessId Integer, isPartionCount Boolean, isPartionSumm Boolean, PartionMovementId Integer, PartionGoodsId Integer)
AS
$BODY$
   DECLARE vbPartionMovementId Integer;
BEGIN

     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;

     -- !!!все равно без партий!!!
     vbPartionMovementId:= lpInsertFind_Object_PartionMovement (0);

     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     WITH tmpMovement AS (SELECT Movement.Id AS MovementId, Movement.OperDate
                          FROM Movement
                          WHERE Movement.Id = inMovementId
                            AND Movement.DescId = zc_Movement_LossDebt()
                            AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
                         )
        , tmpMovementItem AS (SELECT tmpMovement.OperDate
                                   , COALESCE (MovementItem.ObjectId, 0) AS ObjectId
                                   , COALESCE (Object.DescId, 0) AS ObjectDescId
                                   , CASE WHEN MIBoolean_Calculated.ValueData = TRUE THEN COALESCE (MIFloat_Summ.ValueData, 0) ELSE MovementItem.Amount END AS OperSumm
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
                                     -- Бизнес: нет
                                   , 0  AS BusinessId
                                     -- Главное Юр.лицо: всегда из договора
                                   , COALESCE (ObjectLink_Contract_JuridicalBasis.ChildObjectId, 0) AS JuridicalId_Basis
                                   , 0 AS UnitId
                                     -- Филиал: нет
                                   , 0 AS BranchId
                                   , COALESCE (MILinkObject_Contract.ObjectId, 0)  AS ContractId
                                   , COALESCE (MILinkObject_PaidKind.ObjectId, 0)  AS PaidKindId
                                   , MIBoolean_Calculated.ValueData AS isCalculated
                              FROM tmpMovement
                                   JOIN MovementItem ON MovementItem.MovementId = tmpMovement.MovementId
                                                    AND MovementItem.DescId = zc_MI_Master()
                                                    AND MovementItem.isErased = FALSE
                                   LEFT JOIN Object ON Object.Id = MovementItem.ObjectId
                                   LEFT JOIN MovementItemFloat AS MIFloat_Summ 
                                                               ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                                              AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                                    ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                                    ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                                                    ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
                                   LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated
                                                                 ON MIBoolean_Calculated.MovementItemId = MovementItem.Id
                                                                AND MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()
                                   LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis ON ObjectLink_Contract_JuridicalBasis.ObjectId = MILinkObject_Contract.ObjectId
                                                                                             AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
                                   LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId
                             )
        , tmpListContainer AS (SELECT tmpMovementItem.MovementItemId, Container.Id AS ContainerId, Container.Amount
                               FROM tmpMovementItem
                                    JOIN ContainerLinkObject AS ContainerLO_Juridical
                                                             ON ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                                            AND ContainerLO_Juridical.ObjectId = tmpMovementItem.ObjectId
                                    JOIN ContainerLinkObject AS ContainerLO_InfoMoney
                                                             ON ContainerLO_InfoMoney.ContainerId = ContainerLO_Juridical.ContainerId
                                                            AND ContainerLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                                            AND ContainerLO_InfoMoney.ObjectId = tmpMovementItem.InfoMoneyId
                                    JOIN ContainerLinkObject AS ContainerLO_Contract
                                                             ON ContainerLO_Contract.ContainerId = ContainerLO_Juridical.ContainerId
                                                            AND ContainerLO_Contract.DescId = zc_ContainerLinkObject_Contract()
                                                            AND ContainerLO_Contract.ObjectId = tmpMovementItem.ContractId
                                    JOIN ContainerLinkObject AS ContainerLO_PaidKind
                                                             ON ContainerLO_PaidKind.ContainerId = ContainerLO_Juridical.ContainerId
                                                            AND ContainerLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                                                            AND ContainerLO_PaidKind.ObjectId = tmpMovementItem.PaidKindId
                                    JOIN ContainerLinkObject AS ContainerLO_JuridicalBasis
                                                             ON ContainerLO_JuridicalBasis.ContainerId = ContainerLO_Juridical.ContainerId
                                                            AND ContainerLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
                                                            AND ContainerLO_JuridicalBasis.ObjectId = tmpMovementItem.JuridicalId_Basis
                                    JOIN ContainerLinkObject AS ContainerLO_Business
                                                             ON ContainerLO_Business.ContainerId = ContainerLO_Juridical.ContainerId
                                                            AND ContainerLO_Business.DescId = zc_ContainerLinkObject_Business()
                                                            AND ContainerLO_Business.ObjectId = tmpMovementItem.BusinessId
                                    JOIN ContainerLinkObject AS ContainerLO_PartionMovement
                                                             ON ContainerLO_PartionMovement.ContainerId = ContainerLO_Juridical.ContainerId
                                                            AND ContainerLO_PartionMovement.DescId = zc_ContainerLinkObject_PartionMovement()
                                                            AND ContainerLO_PartionMovement.ObjectId = vbPartionMovementId
                                    JOIN Container ON Container.Id = ContainerLO_Juridical.ContainerId
                                                  AND Container.DescId = zc_Container_Summ()
                               WHERE tmpMovementItem.isCalculated = TRUE
                                 AND tmpMovementItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Мясное сырье
                              UNION ALL
                               SELECT tmpMovementItem.MovementItemId, Container.Id AS ContainerId, Container.Amount
                               FROM tmpMovementItem
                                    JOIN ContainerLinkObject AS ContainerLO_Juridical
                                                             ON ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                                            AND ContainerLO_Juridical.ObjectId = tmpMovementItem.ObjectId
                                    JOIN ContainerLinkObject AS ContainerLO_InfoMoney
                                                             ON ContainerLO_InfoMoney.ContainerId = ContainerLO_Juridical.ContainerId
                                                            AND ContainerLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                                            AND ContainerLO_InfoMoney.ObjectId = tmpMovementItem.InfoMoneyId
                                    JOIN ContainerLinkObject AS ContainerLO_Contract
                                                             ON ContainerLO_Contract.ContainerId = ContainerLO_Juridical.ContainerId
                                                            AND ContainerLO_Contract.DescId = zc_ContainerLinkObject_Contract()
                                                            AND ContainerLO_Contract.ObjectId = tmpMovementItem.ContractId
                                    JOIN ContainerLinkObject AS ContainerLO_PaidKind
                                                             ON ContainerLO_PaidKind.ContainerId = ContainerLO_Juridical.ContainerId
                                                            AND ContainerLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                                                            AND ContainerLO_PaidKind.ObjectId = tmpMovementItem.PaidKindId
                                    JOIN ContainerLinkObject AS ContainerLO_JuridicalBasis
                                                             ON ContainerLO_JuridicalBasis.ContainerId = ContainerLO_Juridical.ContainerId
                                                            AND ContainerLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
                                                            AND ContainerLO_JuridicalBasis.ObjectId = tmpMovementItem.JuridicalId_Basis
                                    JOIN ContainerLinkObject AS ContainerLO_Business
                                                             ON ContainerLO_Business.ContainerId = ContainerLO_Juridical.ContainerId
                                                            AND ContainerLO_Business.DescId = zc_ContainerLinkObject_Business()
                                                            AND ContainerLO_Business.ObjectId = tmpMovementItem.BusinessId
                                    JOIN Container ON Container.Id = ContainerLO_Juridical.ContainerId
                                                  AND Container.DescId = zc_Container_Summ()
                               WHERE tmpMovementItem.isCalculated = TRUE
                                 AND tmpMovementItem.InfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_10100() -- Мясное сырье
                              )
        , tmpContainerSumm AS (SELECT tmpListContainer.MovementItemId
                                    , tmpListContainer.ContainerId
                                    , tmpListContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS SummRemainsEnd
                               FROM tmpListContainer
                                    LEFT JOIN tmpMovement ON 1 = 1
                                    LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.Containerid = tmpListContainer.ContainerId
                                                                                  AND MIContainer.OperDate > tmpMovement.OperDate
                               GROUP BY tmpListContainer.MovementItemId
                                      , tmpListContainer.ContainerId
                                      , tmpListContainer.Amount
                              )
        , tmpResult AS (SELECT tmpMovementItem.OperDate
                             , tmpMovementItem.ObjectId
                             , tmpMovementItem.ObjectDescId
                             , CASE WHEN tmpMovementItem.isCalculated = TRUE
                                         THEN tmpMovementItem.OperSumm - COALESCE (tmpContainerSumm.SummRemainsEnd, 0)
                                    ELSE tmpMovementItem.OperSumm
                               END AS OperSumm
                             , tmpMovementItem.MovementItemId
                             , tmpMovementItem.ContainerId
                             , tmpMovementItem.AccountGroupId, tmpMovementItem.AccountDirectionId, tmpMovementItem.AccountId

                             , tmpMovementItem.ProfitLossGroupId
                             , tmpMovementItem.ProfitLossDirectionId
                             , tmpMovementItem.InfoMoneyGroupId
                             , tmpMovementItem.InfoMoneyDestinationId
                             , tmpMovementItem.InfoMoneyId
                             , tmpMovementItem.BusinessId
                             , tmpMovementItem.JuridicalId_Basis
                             , tmpMovementItem.UnitId
                             , tmpMovementItem.BranchId
                             , tmpMovementItem.ContractId
                             , tmpMovementItem.PaidKindId
                        FROM tmpMovementItem
                             LEFT JOIN tmpContainerSumm ON tmpContainerSumm.MovementItemId = tmpMovementItem.MovementItemId
                       )
     -- Расчет
     INSERT INTO _tmpItem (OperDate, ObjectId, ObjectDescId, OperSumm
                         , MovementItemId, ContainerId
                         , AccountGroupId, AccountDirectionId, AccountId
                         , ProfitLossGroupId, ProfitLossDirectionId
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId, JuridicalId_Basis
                         , UnitId, BranchId, ContractId, PaidKindId
                         , IsActive, IsMaster
                          )
        SELECT tmpResult.OperDate
             , tmpResult.ObjectId
             , tmpResult.ObjectDescId
             , tmpResult.OperSumm
             , tmpResult.MovementItemId
             , tmpResult.ContainerId
             , tmpResult.AccountGroupId, tmpResult.AccountDirectionId, tmpResult.AccountId

             , tmpResult.ProfitLossGroupId
             , tmpResult.ProfitLossDirectionId
             , tmpResult.InfoMoneyGroupId
             , tmpResult.InfoMoneyDestinationId
             , tmpResult.InfoMoneyId
             , tmpResult.BusinessId
             , tmpResult.JuridicalId_Basis
             , tmpResult.UnitId
             , tmpResult.BranchId
             , tmpResult.ContractId
             , tmpResult.PaidKindId
             , CASE WHEN tmpResult.OperSumm >= 0 THEN TRUE ELSE FALSE END AS IsActive
             , TRUE AS IsMaster
        FROM tmpResult
       UNION ALL
        SELECT tmpResult.OperDate
             , CASE WHEN tmpResult.OperDate < '01.01.2014' THEN zc_Enum_ProfitLoss_80301() ELSE 0 END AS ObjectId -- Расходы с прибыли + Списание дебиторской задолженности + Продукция
             , 0 AS ObjectDescId
             , -1 * tmpResult.OperSumm
             , tmpResult.MovementItemId
             , tmpResult.ContainerId
             , tmpResult.AccountGroupId, tmpResult.AccountDirectionId, tmpResult.AccountId

             , tmpResult.ProfitLossGroupId
             , CASE WHEN tmpResult.OperDate < '01.01.2014' THEN tmpResult.ProfitLossDirectionId ELSE zc_Enum_ProfitLossDirection_80300() END AS ProfitLossDirectionId -- Списание дебиторской задолженности
             , tmpResult.InfoMoneyGroupId
             , tmpResult.InfoMoneyDestinationId
             , tmpResult.InfoMoneyId
             , tmpResult.BusinessId
             , tmpResult.JuridicalId_Basis
             , tmpResult.UnitId
             , tmpResult.BranchId
             , tmpResult.ContractId
             , tmpResult.PaidKindId
             , CASE WHEN tmpResult.OperSumm >= 0 THEN FALSE ELSE TRUE END AS IsActive
             , FALSE AS IsMaster
        FROM tmpResult
       ;

     -- проверка
     IF EXISTS (SELECT _tmpItem.ObjectId FROM _tmpItem WHERE _tmpItem.ObjectId = 0 AND _tmpItem.IsMaster = TRUE)
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определено <Юридическое лицо>.Проведение невозможно.';
     END IF;
     IF EXISTS (SELECT _tmpItem.ContractId FROM _tmpItem WHERE _tmpItem.ContractId = 0 AND _tmpItem.IsMaster = TRUE)
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определен <№ дог.>.Проведение невозможно.';
     END IF;
     IF EXISTS (SELECT _tmpItem.PaidKindId FROM _tmpItem WHERE _tmpItem.PaidKindId = 0 AND _tmpItem.IsMaster = TRUE)
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определена <Форма оплаты>.Проведение невозможно.';
     END IF;
     IF EXISTS (SELECT _tmpItem.InfoMoneyId FROM _tmpItem WHERE _tmpItem.InfoMoneyId = 0 AND _tmpItem.IsMaster = TRUE)
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определена <УП статья назначения>.Проведение невозможно.';
     END IF;
     IF EXISTS (SELECT _tmpItem.JuridicalId_Basis FROM _tmpItem WHERE _tmpItem.JuridicalId_Basis = 0 AND _tmpItem.IsMaster = TRUE)
     THEN
         RAISE EXCEPTION 'Ошибка.У <Договора> не установлено главное юр.лицо.Проведение невозможно.';
     END IF;

     -- проводим Документ
     PERFORM lpComplete_Movement_Finance (inMovementId := inMovementId
                                        , inUserId     := inUserId);

     -- !!!5.0. формируются свойства в элементах документа из данных для проводок!!!
     UPDATE MovementItem SET Amount =  _tmpItem.OperSumm
     FROM _tmpItem
          JOIN MovementItemBoolean AS MIBoolean_Calculated
                                   ON MIBoolean_Calculated.MovementItemId = _tmpItem.MovementItemId
                                   AND MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()
                                   AND MIBoolean_Calculated.ValueData = TRUE
     WHERE MovementItem.Id = _tmpItem.MovementItemId
       AND _tmpItem.IsMaster = TRUE
    ;


     -- 5.2. ФИНИШ - Обязательно меняем статус документа
     UPDATE Movement SET StatusId = zc_Enum_Status_Complete() WHERE Id = inMovementId AND DescId = zc_Movement_LossDebt() AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 30.01.14                                        * all
 27.01.14         * 
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM lpComplete_Movement_LossDebt (inMovementId:= 103, inUserId:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
