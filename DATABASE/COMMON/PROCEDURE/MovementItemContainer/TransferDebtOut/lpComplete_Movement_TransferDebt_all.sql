-- Function: lpComplete_Movement_TransferDebt_all (Integer, Integer, Boolean)

DROP FUNCTION IF EXISTS lpComplete_Movement_TransferDebt_all (Integer, Integer, Boolean);

CREATE OR REPLACE FUNCTION lpComplete_Movement_TransferDebt_all(
    IN inMovementId        Integer               , -- ключ Документа
    IN inUserId            Integer                 -- Пользователь
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbOperSumm_Partner TFloat;
  DECLARE vbOperSumm_Partner_ChangePercent TFloat;

  DECLARE vbMovementDescId Integer;
  DECLARE vbPriceWithVAT Boolean;
  DECLARE vbVATPercent TFloat;
  DECLARE vbDiscountPercent TFloat;
  DECLARE vbExtraChargesPercent TFloat;

  DECLARE vbMovementItemId Integer;

BEGIN
     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;


     -- Эти параметры нужны для расчета конечных сумм по Контрагенту
     SELECT Movement.DescId
          , COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE) AS PriceWithVAT
          , COALESCE (MovementFloat_VATPercent.ValueData, 0) AS VATPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -MovementFloat_ChangePercent.ValueData ELSE 0 END AS DiscountPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN MovementFloat_ChangePercent.ValueData ELSE 0 END AS ExtraChargesPercent
            INTO vbMovementDescId, vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent
     FROM Movement
          LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                    ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                   AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
          LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                  ON MovementFloat_VATPercent.MovementId = Movement.Id
                                 AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
          LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                  ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                 AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
     WHERE Movement.Id = inMovementId
       AND Movement.DescId IN (zc_Movement_TransferDebtOut(), zc_Movement_TransferDebtIn())
       AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());


     -- Расчеты сумм
     SELECT CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- если цены с НДС или %НДС=0, тогда ничего не делаем
                    THEN _tmpItem.tmpOperSumm_Partner
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда получаем сумму с НДС
                    THEN CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
            END
            -- Расчет Итоговой суммы по Контрагенту
         ,  CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                              ELSE _tmpItem.tmpOperSumm_Partner
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН)
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН)
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                         END
            END
          , _tmpItem.MovementItemId
            INTO vbOperSumm_Partner, vbOperSumm_Partner_ChangePercent, vbMovementItemId
     FROM (SELECT SUM (CASE WHEN COALESCE (MIFloat_CountForPrice.ValueData, 0) <> 0 THEN COALESCE (CAST (MovementItem.Amount * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2)), 0)
                                                                                    ELSE COALESCE (CAST (MovementItem.Amount * MIFloat_Price.ValueData AS NUMERIC (16, 2)), 0)
                       END) AS tmpOperSumm_Partner
                , MAX (MovementItem.Id) AS MovementItemId
           FROM Movement
                JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE
                LEFT JOIN MovementItemFloat AS MIFloat_Price
                                            ON MIFloat_Price.MovementItemId = MovementItem.Id
                                           AND MIFloat_Price.DescId = zc_MIFloat_Price()
                LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                            ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                           AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
           WHERE Movement.Id = inMovementId
             AND Movement.DescId IN (zc_Movement_TransferDebtOut(), zc_Movement_TransferDebtIn())
             AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
          ) AS _tmpItem
     ;


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
             , COALESCE (MovementLinkObject_To.ObjectId, 0) AS ObjectId
             , COALESCE (Object.DescId, 0) AS ObjectDescId
             , vbOperSumm_Partner_ChangePercent AS OperSumm
             , vbMovementItemId AS MovementItemId
             , 0 AS ContainerId                                               -- сформируем позже
             , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId   -- сформируем позже
               -- Группы ОПиУ: нет
             , 0 AS ProfitLossGroupId
               -- Аналитики ОПиУ - направления: нет
             , 0 AS ProfitLossDirectionId
               -- Управленческие группы назначения
             , COALESCE (View_InfoMoney.InfoMoneyGroupId, 0) AS InfoMoneyGroupId
               -- Управленческие назначения
             , COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
               -- Управленческие статьи назначения
             , COALESCE (View_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId
               -- Бизнес: нет
             , 0 AS BusinessId
               -- Главное Юр.лицо: всегда из договора
             , COALESCE (ObjectLink_Contract_JuridicalBasis.ChildObjectId, 0) AS JuridicalId_Basis
             , 0 AS UnitId
               -- Филиал: нет
             , 0 AS BranchId
             , COALESCE (MovementLinkObject_ContractTo.ObjectId, 0) AS ContractId
             , COALESCE (MovementLinkObject_PaidKindTo.ObjectId, 0) AS PaidKindId
             , TRUE AS IsActive
             , TRUE AS IsMaster
        FROM Movement
             LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
             LEFT JOIN Object ON Object.Id = MovementLinkObject_To.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_ContractTo
                                          ON MovementLinkObject_ContractTo.MovementId = Movement.Id
                                         AND MovementLinkObject_ContractTo.DescId = zc_MovementLinkObject_ContractTo()
             LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis ON ObjectLink_Contract_JuridicalBasis.ObjectId = MovementLinkObject_ContractTo.ObjectId
                                                                       AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
             LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                  ON ObjectLink_Contract_InfoMoney.ObjectId = MovementLinkObject_ContractTo.ObjectId
                                 AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Contract_InfoMoney.ChildObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKindTo
                                          ON MovementLinkObject_PaidKindTo.MovementId = Movement.Id
                                         AND MovementLinkObject_PaidKindTo.DescId = zc_MovementLinkObject_PaidKindTo()
        WHERE Movement.Id = inMovementId
          AND Movement.DescId IN (zc_Movement_TransferDebtOut(), zc_Movement_TransferDebtIn())
          AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
       ;

     -- проверка
     IF EXISTS (SELECT _tmpItem.ObjectId FROM _tmpItem WHERE _tmpItem.ObjectId = 0 OR _tmpItem.ObjectDescId <> zc_Object_Juridical())
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определено <Кому (юридическое лицо)>.Проведение невозможно.';
     END IF;
   
     -- проверка
     IF EXISTS (SELECT _tmpItem.ContractId FROM _tmpItem WHERE _tmpItem.ContractId = 0)
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определен <Договор (кому)>.Проведение невозможно.';
     END IF;

     -- проверка
     IF EXISTS (SELECT _tmpItem.InfoMoneyId FROM _tmpItem WHERE _tmpItem.InfoMoneyId = 0)
     THEN
         RAISE EXCEPTION 'Ошибка.У <Договора (кому)> не установлена <УП статья назначения>.Проведение невозможно.';
     END IF;

     -- проверка
     IF EXISTS (SELECT _tmpItem.PaidKindId FROM _tmpItem WHERE _tmpItem.PaidKindId = 0)
     THEN
         IF vbMovementDescId = zc_Movement_TransferDebtOut()
         THEN RAISE EXCEPTION 'Ошибка.У <Договора (кому)> не установлена <Форма оплаты>.Проведение невозможно.';
         ELSE RAISE EXCEPTION 'Ошибка.В документе не определена <Форма оплаты (кому)>.Проведение невозможно.';
         END IF;
     END IF;

     -- проверка
     IF EXISTS (SELECT _tmpItem.JuridicalId_Basis FROM _tmpItem WHERE _tmpItem.JuridicalId_Basis = 0)
     THEN
         RAISE EXCEPTION 'Ошибка.У <Договора (кому)> не установлено <Главное юридическое лицо>.Проведение невозможно.';
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
             , COALESCE (MovementLinkObject_From.ObjectId, 0) AS ObjectId
             , COALESCE (Object.DescId, 0) AS ObjectDescId
             , -1 * _tmpItem.OperSumm
             , _tmpItem.MovementItemId
             , 0 AS ContainerId                                               -- сформируем позже
             , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId   -- сформируем позже
               -- Группы ОПиУ: нет
             , 0 AS ProfitLossGroupId
               -- Аналитики ОПиУ - направления: нет
             , 0 AS ProfitLossDirectionId
               -- Управленческие группы назначения
             , COALESCE (View_InfoMoney.InfoMoneyGroupId, 0) AS InfoMoneyGroupId
               -- Управленческие назначения
             , COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
               -- Управленческие статьи назначения
             , COALESCE (View_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId
               -- Бизнес: нет
             , 0 AS BusinessId
               -- Главное Юр.лицо: всегда из договора
             , COALESCE (ObjectLink_Contract_JuridicalBasis.ChildObjectId, 0) AS JuridicalId_Basis
             , 0 AS UnitId
               -- Филиал: нет
             , 0 AS BranchId
             , COALESCE (MovementLinkObject_ContractFrom.ObjectId, 0) AS ContractId
             , COALESCE (MovementLinkObject_PaidKindFrom.ObjectId, 0) AS PaidKindId
             , NOT _tmpItem.IsActive
             , NOT _tmpItem.IsMaster
        FROM _tmpItem
             LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                          ON MovementLinkObject_From.MovementId = inMovementId
                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
             LEFT JOIN Object ON Object.Id = MovementLinkObject_From.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_ContractFrom
                                          ON MovementLinkObject_ContractFrom.MovementId = inMovementId
                                         AND MovementLinkObject_ContractFrom.DescId = zc_MovementLinkObject_ContractFrom()
             LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis ON ObjectLink_Contract_JuridicalBasis.ObjectId = MovementLinkObject_ContractFrom.ObjectId
                                                                       AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
             LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                  ON ObjectLink_Contract_InfoMoney.ObjectId = MovementLinkObject_ContractFrom.ObjectId
                                 AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Contract_InfoMoney.ChildObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKindFrom
                                          ON MovementLinkObject_PaidKindFrom.MovementId = inMovementId
                                         AND MovementLinkObject_PaidKindFrom.DescId = zc_MovementLinkObject_PaidKindFrom()
       ;

     -- проверка
     IF EXISTS (SELECT _tmpItem.ObjectId FROM _tmpItem WHERE _tmpItem.ObjectId = 0 OR _tmpItem.ObjectDescId <> zc_Object_Juridical())
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определено <От кого (юридическое лицо)>.Проведение невозможно.';
     END IF;
   
     -- проверка
     IF EXISTS (SELECT _tmpItem.ContractId FROM _tmpItem WHERE _tmpItem.ContractId = 0)
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определен <Договор (от кого)>.Проведение невозможно.';
     END IF;

     -- проверка
     IF EXISTS (SELECT _tmpItem.InfoMoneyId FROM _tmpItem WHERE _tmpItem.InfoMoneyId = 0)
     THEN
         RAISE EXCEPTION 'Ошибка.У <Договора (от кого)> не установлена <УП статья назначения>.Проведение невозможно.';
     END IF;

     -- проверка
     IF EXISTS (SELECT _tmpItem.PaidKindId FROM _tmpItem WHERE _tmpItem.PaidKindId = 0)
     THEN
         IF vbMovementDescId = zc_Movement_TransferDebtOut()
         THEN RAISE EXCEPTION 'Ошибка.В документе не определена <Форма оплаты (от кого)>.Проведение невозможно.';
         ELSE RAISE EXCEPTION 'Ошибка.У <Договора (от кого)> не установлена <Форма оплаты>.Проведение невозможно.';
         END IF;
     END IF;

     -- проверка
     IF EXISTS (SELECT _tmpItem.JuridicalId_Basis FROM _tmpItem WHERE _tmpItem.JuridicalId_Basis = 0)
     THEN
         RAISE EXCEPTION 'Ошибка.У <Договора (от кого)> не установлено <Главное юридическое лицо>.Проведение невозможно.';
     END IF;


     -- проводим Документ
     PERFORM lpComplete_Movement_Finance (inMovementId := inMovementId
                                        , inUserId     := inUserId);


     -- 5. ФИНИШ - Обязательно меняем статус документа
     UPDATE Movement SET StatusId = zc_Enum_Status_Complete() WHERE Id = inMovementId AND DescId IN (zc_Movement_TransferDebtOut(), zc_Movement_TransferDebtIn()) AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 04.05.14                                        *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 122175 , inSession:= '2')
-- SELECT * FROM lpComplete_Movement_TransferDebt_all (inMovementId:= 122175, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 122175 , inSession:= '2')
