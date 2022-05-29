DROP FUNCTION IF EXISTS lpComplete_Movement_CashSend (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_CashSend(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)
RETURNS VOID
AS
$BODY$
  DECLARE vbAccountId_Cash   Integer;
  --DECLARE vbAccountId_Debts  Integer;
  --DECLARE vbAccountId_Profit Integer;
  --DECLARE vbProfitLossId     Integer;
BEGIN

    -- Определить
    vbAccountId_Cash   := zc_Enum_Account_30101();
    --vbAccountId_Debts  := zc_Enum_Account_30105();
    --vbAccountId_Profit := zc_Enum_Account_30106(); 
    -- временно
    --vbProfitLossId     := zc_Enum_Account_30106(); 
 
    -- Создаем временнве таблицы
    PERFORM lpComplete_Movement_Cash_CreateTemp();

    -- !!!обязательно!!! очистили таблицу проводок
    DELETE FROM _tmpMIContainer_insert;
    -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
    DELETE FROM _tmpItem;
    
    -- 4.1. предварительно сохранили данные
    INSERT INTO _tmpItem (MovementDescId, OperDate, ServiceDate, OperSumm, OperSumm_in, MovementItemId,
                          ObjectId, CashId)
    SELECT
           Movement.DescId                    AS Id
         , Movement.OperDate                  AS OperDate
         , MIDate_ServiceDate.ValueData       AS ServiceDate
           -- Сумма (расход)
         , MovementItem.Amount                AS Amount
           -- Сумма (приход)
         , MovementItemFloat_Amount.ValueData AS AmountIn
         , MovementItem.Id                    AS MovementItemId
         , MovementItem.ObjectId              AS CashToId
         , MILinkObject_Cash.ObjectId         AS CashFromId
     FROM Movement
          -- Сумма (расход)
          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                 AND MovementItem.DescId = zc_MI_Master()

          LEFT JOIN MovementItemLinkObject AS MILinkObject_Cash
                                           ON MILinkObject_Cash.MovementItemId = MovementItem.Id
                                          AND MILinkObject_Cash.DescId = zc_MILinkObject_Cash()

          LEFT JOIN MovementItemDate AS MIDate_ServiceDate
                                     ON MIDate_ServiceDate.MovementItemId = MovementItem.Id
                                    AND MIDate_ServiceDate.DescId = zc_MIDate_ServiceDate()

          -- Сумма (приход)
          LEFT JOIN MovementItemFloat AS MovementItemFloat_Amount
                                      ON MovementItemFloat_Amount.MovementItemId = MovementItem.Id
                                     AND MovementItemFloat_Amount.DescId         = zc_MIFloat_Amount()

     WHERE Movement.Id = inMovementId;    
     
    -- 4.2. Прописали данные
    
/*    UPDATe _tmpItem SET -- 
                        ServiceDateId = CASE WHEN _tmpItem.UnitId > 0 THEN lpInsertFind_Object_ServiceDate (_tmpItem.ServiceDate) ELSE NULL END
    ;*/
     
    -- 4.3. Создаем контейнера
    
    UPDATE _tmpItem SET -- Контейнер кассы
                         ContainerId = 
                              lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()           -- DescId Суммовой учет
                                                    , inParentId          := NULL                          -- Главный Container
                                                    , inObjectId          := vbAccountId_Cash              -- Объект всегда Счет для Суммовой учет
                                                    , inJuridicalId_basis := NULL                          -- Главное юридическое лицо
                                                    , inBusinessId        := NULL                          -- Бизнесы
                                                    , inDescId_1          := zc_ContainerLinkObject_Cash() -- DescId для 1-ой Аналитики
                                                    , inObjectId_1        := _tmpItem.ObjectId
                                                      )
                         -- Контейнер Долг или Прибыль
                       , ContainerId_Second  = 
                              lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()           -- DescId Суммовой учет
                                                    , inParentId          := NULL                          -- Главный Container
                                                    , inObjectId          := vbAccountId_Cash              -- Объект всегда Счет для Суммовой учет
                                                    , inJuridicalId_basis := NULL                          -- Главное юридическое лицо
                                                    , inBusinessId        := NULL                          -- Бизнесы
                                                    , inDescId_1          := zc_ContainerLinkObject_Cash() -- DescId для 1-ой Аналитики
                                                    , inObjectId_1        := _tmpItem.CashId
                                                      )
    ;

    -- 4.4. формируются Проводки - Остатки по кассе 1
    INSERT INTO _tmpMIContainer_insert (DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate
                                       , ObjectId_analyzer, WhereObjectId_analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, IsActive)
     SELECT zc_MIContainer_Summ()
          , _tmpItem.MovementDescId
          , inMovementId
          , _tmpItem.MovementItemId
          , _tmpItem.ContainerId 
            -- Счет для этой проводки
          , vbAccountId_Cash 

          , -1 * _tmpItem.OperSumm
          , _tmpItem.OperDate

            -- Аналитика, дублируем основное св-во
          , _tmpItem.ObjectId               AS ObjectId_analyzer
          , 0                               AS WhereObjectId_analyzer

            -- Аналитика из проводки-корреспондент
          , _tmpItem.CashId                 AS ObjectIntId_Analyzer
            -- Аналитика из проводки-корреспондент
          , NULL                            AS ObjectExtId_Analyzer

          , FALSE AS IsActive

     FROM _tmpItem;     

     -- 4.3. формируются Проводки - Остатки по кассе 2
     INSERT INTO _tmpMIContainer_insert (DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate
                                       , ObjectId_analyzer, WhereObjectId_analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, IsActive)
     SELECT zc_MIContainer_Summ()
          , _tmpItem.MovementDescId
          , inMovementId
          , _tmpItem.MovementItemId
          , _tmpItem.ContainerId_Second

            -- Счет для этой проводки
          , vbAccountId_Cash                                      AS AccountId

          , 1 * _tmpItem.OperSumm_in
          , _tmpItem.OperDate

            -- Аналитика, дублируем основное св-во
          , _tmpItem.CashId                                       AS ObjectId_analyzer 
            -- Аналитика, дублируем основное св-во
          , NULL                                                  AS WhereObjectId_analyzer

            -- Аналитика из проводки-корреспондент
          , _tmpItem.ObjectId     AS ObjectIntId_Analyzer
            -- Аналитика из проводки-корреспондент
          , 0                     AS ObjectExtId_Analyzer

          , TRUE AS IsActive

     FROM _tmpItem;     
     
    -- 5.1. ФИНИШ - Обязательно сохраняем Проводки
    PERFORM lpInsertUpdate_MovementItemContainer_byTable();

    -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_CashSend()
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
-- SELECT * FROM lpComplete_Movement_CashSend (inMovementId:= 224, inUserId := zfCalc_UserAdmin() :: Integer)  order by ObjectId_parent;