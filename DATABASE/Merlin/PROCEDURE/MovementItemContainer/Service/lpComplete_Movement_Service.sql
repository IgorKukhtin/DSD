DROP FUNCTION IF EXISTS lpComplete_Movement_Service (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Service(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)
RETURNS VOID
AS
$BODY$
  DECLARE vbAccountId_Cash   Integer;
  DECLARE vbAccountId_Debts  Integer;
  DECLARE vbAccountId_Profit Integer;
  DECLARE vbProfitLossId     Integer;
BEGIN

    -- Определить
    vbAccountId_Cash   := zc_Enum_Account_30101();
    vbAccountId_Debts  := zc_Enum_Account_30105();
    vbAccountId_Profit := zc_Enum_Account_30106(); 
    -- временно
    vbProfitLossId     := zc_Enum_Account_30106(); 

    -- Создаем временнве таблицы
    PERFORM lpComplete_Movement_Cash_CreateTemp();

    -- !!!обязательно!!! очистили таблицу проводок
    DELETE FROM _tmpMIContainer_insert;
    -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
    DELETE FROM _tmpItem;
    
    -- 4.1. предварительно сохранили данные
    INSERT INTO _tmpItem (MovementDescId, OperDate, ServiceDate, OperSumm, MovementItemId,
                          UnitId, InfoMoneyId)
    SELECT
           Movement.DescId                    AS Id
         , Movement.OperDate                  AS OperDate
         , MIDate_ServiceDate.ValueData       AS ServiceDate
         , MovementItem.Amount                AS Amount
         , MovementItem.Id                    AS MovementItemId
         , MovementItem.ObjectId              AS UnitId
         , MILinkObject_InfoMoney.ObjectId    AS InfoMoneyId
     FROM Movement
          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                 AND MovementItem.DescId = zc_MI_Master()

          LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                           ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                          AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()

          LEFT JOIN MovementItemDate AS MIDate_ServiceDate
                                     ON MIDate_ServiceDate.MovementItemId = MovementItem.Id
                                    AND MIDate_ServiceDate.DescId = zc_MIDate_ServiceDate()

     WHERE Movement.Id = inMovementId;    
     
    -- 4.2. Прописали данные
    
    UPDATe _tmpItem SET -- 
                        ServiceDateId = CASE WHEN _tmpItem.UnitId > 0 THEN lpInsertFind_Object_ServiceDate (_tmpItem.ServiceDate) ELSE NULL END
    ;
     
    -- 4.3. Создаем контейнера
    
    UPDATE _tmpItem SET -- Контейнер Долг
                         ContainerId = 
                              lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()      -- DescId Суммовой учет
                                                     , inParentId          := NULL                    -- Главный Container
                                                     , inObjectId          := vbAccountId_Debts       -- Объект всегда Счет для Суммовой учет
                                                     , inJuridicalId_basis := NULL                    -- Главное юридическое лицо
                                                     , inBusinessId        := NULL                    -- Бизнесы
                                                     , inDescId_1          := zc_ContainerLinkObject_Unit() -- DescId для 1-ой Аналитики
                                                     , inObjectId_1        := _tmpItem.UnitId
                                                     , inDescId_2          := zc_ContainerLinkObject_ServiceDate() -- DescId для 2-ой Аналитики
                                                     , inObjectId_2        := _tmpItem.ServiceDateId
                                                     , inDescId_3          := zc_ContainerLinkObject_InfoMoney() -- DescId для 3-ой Аналитики
                                                     , inObjectId_3        := _tmpItem.InfoMoneyId
                                                      )
                         -- Контейнер Прибыль
                       , ContainerId_Second  = 
                              lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()      -- DescId Суммовой учет
                                                    , inParentId          := NULL                     -- Главный Container
                                                    , inObjectId          := vbAccountId_Profit       -- Объект всегда Счет для Суммовой учет
                                                    , inJuridicalId_basis := NULL                     -- Главное юридическое лицо
                                                    , inBusinessId        := NULL                     -- Бизнесы
                                                    , inDescId_1          := zc_ContainerLinkObject_ProfitLoss() -- DescId для 1-ой Аналитики
                                                    , inObjectId_1        := vbProfitLossId           -- временно, надо будет потом использовать lpInsertFind_Object_ProfitLoss
                                                     ) 
    ;  

    -- 4.4. формируются Проводки - Долг
    INSERT INTO _tmpMIContainer_insert (DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate
                                       , ObjectId_analyzer, WhereObjectId_analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, IsActive)
     SELECT zc_MIContainer_Summ()
          , _tmpItem.MovementDescId
          , inMovementId
          , _tmpItem.MovementItemId
          , _tmpItem.ContainerId

            -- Счет для этой проводки
          , vbAccountId_Debts  AS AccountId

          , _tmpItem.OperSumm
          , _tmpItem.OperDate

            -- Аналитика, дублируем основное св-во
          , _tmpItem.UnitId                                              AS ObjectId_analyzer 
            -- Аналитика, дублируем основное св-во
          , _tmpItem.ServiceDateId                                       AS WhereObjectId_analyzer

            -- Аналитика из проводки-корреспондент
          , vbProfitLossId                                               AS ObjectIntId_Analyzer
            -- Аналитика из проводки-корреспондент
          , 0                                                            AS ObjectExtId_Analyzer

          , CASE WHEN _tmpItem.OperSumm > 0 THEN FALSE ELSE TRUE END     AS  IsActive

     FROM _tmpItem;     
     
     -- 4.3. формируются Проводки - Долг или Прибыль
     INSERT INTO _tmpMIContainer_insert (DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate
                                       , ObjectId_analyzer, WhereObjectId_analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, IsActive)
     SELECT zc_MIContainer_Summ()
          , _tmpItem.MovementDescId
          , inMovementId
          , _tmpItem.MovementItemId
          , _tmpItem.ContainerId_Second

            -- Счет для этой проводки
          , vbAccountId_Profit               AS AccountId

          , -1 * _tmpItem.OperSumm
          , _tmpItem.OperDate

            -- Аналитика, дублируем основное св-во
          , vbProfitLossId                                               AS ObjectId_analyzer 
            -- Аналитика, дублируем основное св-во
          , NULL                                                         AS WhereObjectId_analyzer

            -- Аналитика из проводки-корреспондент
          , _tmpItem.UnitId                                              AS ObjectIntId_Analyzer
            -- Аналитика из проводки-корреспондент
          , _tmpItem.ServiceDateId                                       AS ObjectExtId_Analyzer

            -- для прибыли всегда так 
          ,  FALSE                                                       AS IsActive

     FROM _tmpItem;   

    -- 5.1. ФИНИШ - Обязательно сохраняем Проводки
    PERFORM lpInsertUpdate_MovementItemContainer_byTable();
 

    -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_Service()
                               , inUserId     := inUserId
                                );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 10.02.22                                                       *
 15.01.22         *
*/

-- тест
-- 
select * from gpComplete_Movement_Service(inMovementId := 30545 ,  inSession := '5');