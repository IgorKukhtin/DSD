-- Function: gpComplete_Movement_Cash()

DROP FUNCTION IF EXISTS gpComplete_Movement_Cash (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Cash(
    IN inMovementId        Integer              , -- ключ Документа
    IN inSession           TVarChar               -- сессия пользователя
)                              
--  RETURNS void
  RETURNS TABLE (OperDate TDateTime, ObjectId Integer, ObjectDescId Integer, OperSumm TFloat, ContainerId Integer, AccountGroupId Integer, AccountDirectionId Integer, AccountId Integer, ProfitLossGroupId Integer, ProfitLossDirectionId Integer, InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, BusinessId Integer, JuridicalId_Basis Integer, UnitId Integer, ContractId Integer, PaidKindId Integer, IsActive Boolean)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_Measure());
     vbUserId := 2; -- CAST (inSession AS Integer);


     -- таблица - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem (OperDate TDateTime, ObjectId Integer, ObjectDescId Integer, OperSumm TFloat
                               , ContainerId Integer
                               , AccountGroupId Integer, AccountDirectionId Integer, AccountId Integer
                               , ProfitLossGroupId Integer, ProfitLossDirectionId Integer
                               , InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId Integer, JuridicalId_Basis Integer
                               , UnitId Integer, ContractId Integer, PaidKindId Integer
                               , IsActive Boolean
                                ) ON COMMIT DROP;


     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (OperDate, ObjectId, ObjectDescId, OperSumm
                         , ContainerId
                         , AccountGroupId, AccountDirectionId, AccountId
                         , ProfitLossGroupId, ProfitLossDirectionId
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId, JuridicalId_Basis
                         , UnitId, ContractId, PaidKindId
                         , IsActive
                          )
        SELECT Movement.OperDate
             , COALESCE (MovementLinkObject_From.ObjectId, 0) AS ObjectId
             , COALESCE (Object.DescId, 0) AS ObjectDescId
             , COALESCE (MovementFloat_Amount.ValueData, 0) AS OperSumm
             , 0 AS ContainerId                                               -- сформируем позже
             , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId   -- сформируем позже
               -- Группы ОПиУ
             , COALESCE (lfObject_Unit_byProfitLossDirection.ProfitLossGroupId, 0) AS ProfitLossGroupId
               -- Аналитики ОПиУ - направления
             , COALESCE (lfObject_Unit_byProfitLossDirection.ProfitLossDirectionId, 0) AS ProfitLossDirectionId
               -- Управленческие группы назначения
             , COALESCE (View_InfoMoney.InfoMoneyGroupId, 0) AS InfoMoneyGroupId
               -- Управленческие назначения
             , COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
               -- Управленческие статьи назначения
             , COALESCE (View_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId
               -- Бизнес: если это касса, тогда из кассы или по св-ву документа, иначе по св-ву документа
             , COALESCE (CASE WHEN Object.DescId = zc_Object_Cash()
                                   THEN COALESCE (ObjectLink_Cash_Business.ChildObjectId, MovementLinkObject_Business.ObjectId)
                              ELSE MovementLinkObject_Business.ObjectId
                         END, 0) AS BusinessId
               -- Главное Юр.лицо всегда из кассы
             , COALESCE (ObjectLink_Cash_MainJuridical.ChildObjectId, 0) AS JuridicalId_Basis
             , COALESCE (MovementLinkObject_Unit.ObjectId, 0) AS UnitId
             , COALESCE (MovementLinkObject_Contract.ObjectId, 0) AS ContractId
             , zc_Enum_PaidKind_SecondForm() AS PaidKindId
             , FALSE
        FROM Movement
             LEFT JOIN MovementFloat AS MovementFloat_Amount 
                                     ON MovementFloat_Amount.MovementId = Movement.Id
                                    AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()
             LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                          ON MovementLinkObject_From.MovementId = Movement.Id
                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
             LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
             LEFT JOIN MovementLinkObject AS MovementLinkObject_InfoMoney
                                          ON MovementLinkObject_InfoMoney.MovementId = Movement.Id
                                         AND MovementLinkObject_InfoMoney.DescId = zc_MovementLinkObject_InfoMoney()
             LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                          ON MovementLinkObject_Unit.MovementId = Movement.Id
                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
             LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                          ON MovementLinkObject_Contract.MovementId = Movement.Id
                                         AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
             LEFT JOIN MovementLinkObject AS MovementLinkObject_Business
                                          ON MovementLinkObject_Business.MovementId = Movement.Id
                                         AND MovementLinkObject_Business.DescId = zc_MovementLinkObject_Business()

             LEFT JOIN Object ON Object.Id = MovementLinkObject_From.ObjectId
             LEFT JOIN ObjectLink AS ObjectLink_Cash_Business ON ObjectLink_Cash_Business.ObjectId = CASE WHEN Object.DescId = zc_Object_Cash() THEN Object.Id ELSE MovementLinkObject_To.ObjectId END
                                                             AND ObjectLink_Cash_Business.DescId = zc_ObjectLink_Cash_Business()
             LEFT JOIN ObjectLink AS ObjectLink_Cash_MainJuridical ON ObjectLink_Cash_MainJuridical.ObjectId = CASE WHEN Object.DescId = zc_Object_Cash() THEN Object.Id ELSE MovementLinkObject_To.ObjectId END
                                                                  AND ObjectLink_Cash_MainJuridical.DescId = zc_ObjectLink_Cash_MainJuridical()

             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MovementLinkObject_InfoMoney.ObjectId
             LEFT JOIN lfSelect_Object_Unit_byProfitLossDirection() AS lfObject_Unit_byProfitLossDirection ON lfObject_Unit_byProfitLossDirection.UnitId = MovementLinkObject_Unit.ObjectId
        WHERE Movement.Id = inMovementId
          AND Movement.DescId = zc_Movement_Cash()
          AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
       ;

     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (OperDate, ObjectId, ObjectDescId, OperSumm
                         , ContainerId
                         , AccountGroupId, AccountDirectionId, AccountId
                         , ProfitLossGroupId, ProfitLossDirectionId
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId, JuridicalId_Basis
                         , UnitId, ContractId, PaidKindId
                         , IsActive
                          )
        SELECT _tmpItem.OperDate
             , COALESCE (MovementLinkObject_To.ObjectId, 0) AS ObjectId
             , Object.DescId AS ObjectDescId
             , _tmpItem.OperSumm
             , _tmpItem.ContainerId
             , _tmpItem.AccountGroupId, _tmpItem.AccountDirectionId, _tmpItem.AccountId
             , _tmpItem.ProfitLossGroupId, _tmpItem.ProfitLossDirectionId
             , _tmpItem.InfoMoneyGroupId, _tmpItem.InfoMoneyDestinationId, _tmpItem.InfoMoneyId
               -- Бизнес: если это касса, тогда из кассы, иначе по св-ву документа
             , COALESCE (ObjectLink_Cash_Business.ChildObjectId, MovementLinkObject_Business.ObjectId) AS BusinessId
               -- Главное Юр.лицо всегда из кассы
             , COALESCE (ObjectLink_Cash_MainJuridical.ChildObjectId, _tmpItem.JuridicalId_Basis) AS JuridicalId_Basis
             , _tmpItem.UnitId, _tmpItem.ContractId, _tmpItem.PaidKindId
             , TRUE AS IsActive
        FROM _tmpItem
             LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                          ON MovementLinkObject_To.MovementId = inMovementId
                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
             LEFT JOIN MovementLinkObject AS MovementLinkObject_Business
                                          ON MovementLinkObject_Business.MovementId = inMovementId
                                         AND MovementLinkObject_Business.DescId = zc_MovementLinkObject_Business()
             LEFT JOIN Object ON Object.Id = MovementLinkObject_To.ObjectId
             LEFT JOIN ObjectLink AS ObjectLink_Cash_Business ON ObjectLink_Cash_Business.ObjectId = Object.Id
                                                             AND ObjectLink_Cash_Business.DescId = zc_ObjectLink_Cash_Business()
             LEFT JOIN ObjectLink AS ObjectLink_Cash_MainJuridical ON ObjectLink_Cash_MainJuridical.ObjectId = Object.Id
                                                                  AND ObjectLink_Cash_MainJuridical.DescId = zc_ObjectLink_Cash_MainJuridical()
       ;

/*
     -- проверка
     IF COALESCE (vbFromDescId, 0) = zc_Object_Cash()  
         RAISE EXCEPTION 'В документе не определена касса. Проведение невозможно';
     END IF;
   
     -- проверка
     IF COALESCE (vbMainJuridicalId, 0) = 0 
     THEN
         RAISE EXCEPTION 'У кассы не установлено главное юр лицо. Проведение невозможно';
     END IF;
*/


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

     -- 1.1.2. определяется Счет для проводок суммового учета
     UPDATE _tmpItem SET AccountId = CASE WHEN _tmpItem.ObjectDescId = 0
                                               THEN zc_Enum_Account_100301() -- прибыль текущего периода
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
                                                                          , inInsert                 := FALSE
                                                                          , inUserId                 := vbUserId
                                                                           )
                                     END;

     -- 1.2. определяется ObjectId для проводок суммового учета по счету Прибыль
     UPDATE _tmpItem SET ObjectId = lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem.ProfitLossGroupId
                                                                  , inProfitLossDirectionId  := _tmpItem.ProfitLossDirectionId
                                                                  , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                  , inInfoMoneyId            := NULL
                                                                  , inInsert                 := FALSE
                                                                  , inUserId                 := vbUserId
                                                                   )
     WHERE _tmpItem.AccountId = zc_Enum_Account_100301(); -- прибыль текущего периода


     -- 2. определяется ContainerId для проводок суммового учета
     UPDATE _tmpItem SET ContainerId = CASE WHEN _tmpItem.AccountGroupId = zc_Enum_AccountGroup_40000() -- Денежные средства
                                                 THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                            , inParentId          := NULL
                                                                            , inObjectId          := _tmpItem.AccountId
                                                                            , inJuridicalId_basis := _tmpItem.JuridicalId_Basis
                                                                            , inBusinessId        := _tmpItem.BusinessId
                                                                            , inObjectCostDescId  := NULL
                                                                            , inObjectCostId      := NULL
                                                                            , inDescId_1          := CASE WHEN _tmpItem.AccountId = zc_Enum_AccountDirection_40300() THEN zc_ContainerLinkObject_BankAccount () ELSE zc_ContainerLinkObject_Cash() END
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
                                       END;

     -- для теста
     RETURN QUERY SELECT _tmpItem.OperDate, _tmpItem.ObjectId, _tmpItem.ObjectDescId, _tmpItem.OperSumm, _tmpItem.ContainerId, _tmpItem.AccountGroupId, _tmpItem.AccountDirectionId, _tmpItem.AccountId, _tmpItem.ProfitLossGroupId, _tmpItem.ProfitLossDirectionId, _tmpItem.InfoMoneyGroupId, _tmpItem.InfoMoneyDestinationId, _tmpItem.InfoMoneyId, _tmpItem.BusinessId, _tmpItem.JuridicalId_Basis, _tmpItem.UnitId, _tmpItem.ContractId, _tmpItem.PaidKindId, _tmpItem.IsActive FROM _tmpItem;




END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.12.13                                        * all
 24.11.13                                        * add View_InfoMoney
 13.08.13                        *                
*/

-- тест
-- SELECT * FROM gpComplete_Movement_Cash (inMovementId:= 3538, inSession:= zfCalc_UserAdmin())

