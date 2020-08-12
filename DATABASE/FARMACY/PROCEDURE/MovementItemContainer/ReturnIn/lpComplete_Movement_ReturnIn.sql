 -- Function: lpComplete_Movement_ (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_ReturnIn (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_ReturnIn(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbAccountId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN

     -- проверим наличие
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
  --   DELETE FROM _tmpMIReport_insert;
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;


    -- Определить
    SELECT OperDate, MovementLinkObject_Unit.ObjectId
    INTO vbOperDate, vbUnitId
    FROM Movement

         LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

         LEFT JOIN MovementLinkObject AS MovementLinkObject_DiscountCard
                                      ON MovementLinkObject_DiscountCard.MovementId = Movement.Id
                                     AND MovementLinkObject_DiscountCard.DescId = zc_MovementLinkObject_DiscountCard()

    WHERE Movement.Id = inMovementId;

    -- Определить
    vbAccountId:= lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000()         -- Запасы
                                             , inAccountDirectionId     := zc_Enum_AccountDirection_20100()     -- Cклад
                                             , inInfoMoneyDestinationId := zc_Enum_InfoMoneyDestination_10200() -- Медикаменты
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId);

    INSERT INTO _tmpMIContainer_insert (DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate
                                      , ObjectId_analyzer, WhereObjectId_analyzer, AnalyzerId, ObjectIntId_analyzer, Price
                                       )
       -- Результат
       SELECT zc_MIContainer_Count()
            , zc_Movement_ReturnIn()
            , inMovementId
            , MI.Id
            , Container.Id
            , vbAccountId
            , MI.Amount
            , vbOperDate
            , MI.ObjectId                    AS ObjectId_analyzer
            , vbUnitId                       AS WhereObjectId_analyzer
            , CASE WHEN Movement.DescId = zc_Movement_Inventory() AND MIFloat_MovementItem.ValueData > 0
                  THEN MIFloat_MovementItem.ValueData :: Integer ELSE MovementItem.Id END AS AnalyzerId
            , (SELECT MIContainer.ObjectIntId_analyzer FROM MovementItemContainer AS MIContainer
               WHERE MIContainer.MovementItemId =  CASE WHEN Movement.DescId = zc_Movement_Inventory() AND MIFloat_MovementItem.ValueData > 0
                  THEN MIFloat_MovementItem.ValueData :: Integer ELSE MovementItem.Id END
                  AND MIContainer.DescId = zc_MIContainer_Count()
                  AND MIContainer.ObjectIntId_analyzer <> 0) AS ObjectIntId_analyzer
            , COALESCE (MIFloat_Price.ValueData, 0)
       FROM MovementItem AS MI
            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MI.ParentId
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                    ON MIFloat_ContainerId.MovementItemId = MI.Id
                                   AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
            LEFT JOIN Container ON Container.ID = MIFloat_ContainerId.ValueData::Integer

            -- партия
            INNER JOIN ContainerLinkObject AS CLI_MI
                                           ON CLI_MI.ContainerId = COALESCE(Container.ParentId, Container.Id)
                                          AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()
            INNER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
            -- элемент прихода
            INNER JOIN MovementItem ON MovementItem.Id = Object_PartionMovementItem.ObjectCode
            INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
            -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
            LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                        ON MIFloat_MovementItem.MovementItemId = MovementItem.Id
                                       AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
       WHERE MI.MovementId = inMovementId
         AND MI.DescId = zc_MI_Master()
         AND MI.Amount > 0
         AND MI.isErased = FALSE;

       -- Проводки если затронуты контейнера сроков
     IF EXISTS(SELECT 1 FROM Container WHERE Container.WhereObjectId = vbUnitId
                                         AND Container.DescId = zc_Container_CountPartionDate()
                                         AND Container.ParentId in (SELECT _tmpMIContainer_insert.ContainerId FROM _tmpMIContainer_insert))
     THEN

       WITH DD AS (
          SELECT
             _tmpMIContainer_insert.MovementItemId
           , Sum(_tmpMIContainer_insert.Amount) AS Amount
           , vbOperDate                         AS OperDate
           , Max(Container.Id)                  AS ContainerId
           FROM _tmpMIContainer_insert
                JOIN Container ON _tmpMIContainer_insert.ContainerId = Container.ParentId
           WHERE Container.DescId = zc_Container_CountPartionDate()
             AND Container.WhereObjectId = vbUnitId
           GROUP BY _tmpMIContainer_insert.MovementItemId
          )

         INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate)
           SELECT
                  zc_Container_CountPartionDate()
                , zc_Movement_ReturnIn()
                , inMovementId
                , tmpItem.MovementItemId
                , tmpItem.ContainerId
                , Null
                , tmpItem.Amount
                , OperDate
             FROM DD AS tmpItem;

     END IF;


     -- 5.1. ФИНИШ - Обязательно сохраняем Проводки
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();

     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_ReturnIn()
                                , inUserId     := inUserId
                                 );
    --пересчитываем сумму документа по приходным ценам
     PERFORM lpInsertUpdate_MovementFloat_TotalSummReturnIn(inMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 12.08.20                                                       *
 22.01.19         *
*/

-- тест
-- 