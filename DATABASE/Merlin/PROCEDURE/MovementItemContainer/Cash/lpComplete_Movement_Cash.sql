DROP FUNCTION IF EXISTS lpComplete_Movement_Cash (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Cash(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)
RETURNS VOID
AS
$BODY$
  DECLARE vbAccountId Integer;
  DECLARE vbAccountDebtsId Integer;
  DECLARE vbAccountProfitId Integer;
BEGIN

 
    -- Определить
    vbAccountId       := zc_Enum_Account_30101();
    vbAccountDebtsId  := zc_Enum_Account_30105();
    vbAccountProfitId := zc_Enum_Account_30106(); 

    -- Создаем временнве таблицы
    PERFORM lpComplete_Movement_Cash_CreateTemp();

    -- !!!обязательно!!! очистили таблицу проводок
    DELETE FROM _tmpMIContainer_insert;
    -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
    DELETE FROM _tmpItem;
    
    -- предварительно сохранили данные
    INSERT INTO _tmpItem (MovementDescId, OperDate, ServiceDate, OperSumm, MovementItemId,
                          ObjectId, ObjectDescId, UnitId, InfoMoneyId)
    SELECT
           Movement.DescId                    AS Id
         , Movement.OperDate                  AS OperDate
         , MIDate_ServiceDate.ValueData       AS ServiceDate
         , MovementItem.Amount                AS Amount
         , MovementItem.Id                    AS MI_Id
         , Object_Cash.Id                     AS CashId
         , Object_Cash.DescId                 AS CashDescId
         , Object_Unit.Id                     AS UnitId
         , MILinkObject_InfoMoney.ObjectId    AS InfoMoneyId
     FROM Movement
          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                 AND MovementItem.DescId = zc_MI_Master()

          LEFT JOIN Object AS Object_Cash ON Object_Cash.Id = MovementItem.ObjectId

          LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                           ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                          AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

          LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                           ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                          AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()

          LEFT JOIN MovementItemDate AS MIDate_ServiceDate
                                     ON MIDate_ServiceDate.MovementItemId = MovementItem.Id
                                    AND MIDate_ServiceDate.DescId = zc_MIDate_ServiceDate()

     WHERE Movement.Id = inMovementId;    
     
     
     -- 4.3. формируются Проводки - Остатки по кассе
    INSERT INTO _tmpMIContainer_insert (DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate
                                       , ObjectId_analyzer, WhereObjectId_analyzer, IsActive)
     SELECT zc_MIContainer_Summ()
          , _tmpItem.MovementDescId
          , inMovementId
          , _tmpItem.MovementItemId
          , lpInsertFind_Container(inContainerDescId   := zc_Container_Summ(),     -- DescId Остатка
                                   inParentId          := NULL               ,     -- Главный Container
                                   inObjectId          := vbAccountId,             -- Объект (Счет или Товар или ...)
                                   inJuridicalId_basis := NULL, -- Главное юридическое лицо
                                   inBusinessId        := NULL, -- Бизнесы
                                   inDescId_1          := zc_ContainerLinkObject_Cash(), -- DescId для 1-ой Аналитики
                                   inObjectId_1        := _tmpItem.ObjectId) 
          , vbAccountId
          , _tmpItem.OperSumm
          , _tmpItem.OperDate
          , _tmpItem.ObjectId               AS ObjectId_analyzer
          , _tmpItem.UnitId                 AS WhereObjectId_analyzer
          , True
         /* , vbMovementItemId_partion AS AnalyzerId
          , (SELECT MIContainer.ObjectIntId_analyzer FROM MovementItemContainer AS MIContainer WHERE MIContainer.MovementItemId = vbMovementItemId_partion AND MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.ObjectIntId_analyzer <> 0 LIMIT 1) AS ObjectIntId_analyzer
          , (SELECT _tmpItem.Price FROM _tmpItem WHERE _tmpItem.MovementItemId = vbMovementItemId) AS Price*/
     FROM _tmpItem;     

     -- 4.3. формируются Проводки - долг      
     INSERT INTO _tmpMIContainer_insert (DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate
                                       , ObjectId_analyzer, WhereObjectId_analyzer, IsActive)
     SELECT zc_MIContainer_Summ()
          , _tmpItem.MovementDescId
          , inMovementId
          , _tmpItem.MovementItemId
          , lpInsertFind_Container(inContainerDescId   := zc_Container_Summ(),     -- DescId Остатка
                                   inParentId          := NULL               ,     -- Главный Container
                                   inObjectId          := vbAccountDebtsId,        -- Объект (Счет или Товар или ...)
                                   inJuridicalId_basis := NULL, -- Главное юридическое лицо
                                   inBusinessId        := NULL, -- Бизнесы
                                   inDescId_1          := zc_ContainerLinkObject_Unit(), -- DescId для 1-ой Аналитики
                                   inObjectId_1        := _tmpItem.UnitId,
                                   inDescId_2          := zc_ContainerLinkObject_ServiceDate(), -- DescId для 2-ой Аналитики
                                   inObjectId_2        := lpInsertFind_Object_ServiceDate(_tmpItem.ServiceDate),
                                   inDescId_3          := zc_ContainerLinkObject_InfoMoney(), -- DescId для 3-ой Аналитики
                                   inObjectId_3        := _tmpItem.InfoMoneyId) 
          , vbAccountDebtsId
          , - _tmpItem.OperSumm
          , _tmpItem.OperDate
          , _tmpItem.ObjectId               AS ObjectId_analyzer
          , _tmpItem.UnitId                 AS WhereObjectId_analyzer
          , True
         /* , vbMovementItemId_partion AS AnalyzerId
          , (SELECT MIContainer.ObjectIntId_analyzer FROM MovementItemContainer AS MIContainer WHERE MIContainer.MovementItemId = vbMovementItemId_partion AND MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.ObjectIntId_analyzer <> 0 LIMIT 1) AS ObjectIntId_analyzer
          , (SELECT _tmpItem.Price FROM _tmpItem WHERE _tmpItem.MovementItemId = vbMovementItemId) AS Price*/
     FROM _tmpItem;     
     
    -- 5.1. ФИНИШ - Обязательно сохраняем Проводки
    PERFORM lpInsertUpdate_MovementItemContainer_byTable();

    -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_Cash()
                               , inUserId     := inUserId
                                );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 09.02.22                                                       *
 15.01.22         *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_Cash (inMovementId:= 40980, inUserId := zfCalc_UserAdmin() :: Integer);
