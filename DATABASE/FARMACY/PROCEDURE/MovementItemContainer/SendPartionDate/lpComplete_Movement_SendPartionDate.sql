 -- Function: lpComplete_Movement_Income (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_SendPartionDate (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_SendPartionDate(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUnitId   Integer;
   DECLARE vbOperDate TDateTime;
BEGIN

     -- создаются временные таблицы - для формирование данных для проводок
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpMIContainer_insert'))
     THEN
         -- !!!обязательно!!! очистили таблицу проводок
         DELETE FROM _tmpMIContainer_insert;
         DELETE FROM _tmpMIReport_insert;
     ELSE
         PERFORM lpComplete_Movement_Finance_CreateTemp();
     END IF;


     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;


     -- Определить
     vbUnitId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Unit());
     -- Определить
     vbOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);


     -- таблица - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem_PartionDate (MovementItemId Integer, GoodsId Integer, Amount TFloat
                                           , ContainerId_in Integer, ContainerId Integer
                                           , MovementId_in Integer, PartionId_in Integer
                                           , PartionGoodsId Integer
                                           , ExpirationDate TDateTime
                                            ) ON COMMIT DROP;
     -- таблица - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem_PartionDate (MovementItemId, GoodsId, Amount, ContainerId_in, ContainerId, MovementId_in, PartionId_in, PartionGoodsId, ExpirationDate)
        SELECT MovementItem.Id                    AS MovementItemId
             , MovementItem.ObjectId              AS GoodsId
             , MovementItem.Amount                AS Amount
             , MIFloat_ContainerId.ValueData      AS ContainerId_in
             , 0                                  AS ContainerId
             , MIFloat_MovementId.ValueData       AS MovementId_in
             , CLO_MI.ObjectId                    AS PartionId_in
             , 0                                  AS PartionGoodsId
             , MIDate_ExpirationDate.ValueData    AS ExpirationDate
        FROM MovementItem
            INNER JOIN MovementItem AS MI_Master ON MI_Master.MovementId = inMovementId
                                                AND MI_Master.DescId     = zc_MI_Master()
                                                AND MI_Master.Id         = MovementItem.ParentId
                                                AND MI_Master.isErased   = FALSE
            LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                        ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                       AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
            LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                        ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                       AND MIFloat_ContainerId.DescId         = zc_MIFloat_ContainerId()
            LEFT JOIN MovementItemDate AS MIDate_ExpirationDate
                                       ON MIDate_ExpirationDate.MovementItemId = MovementItem.Id
                                      AND MIDate_ExpirationDate.DescId         = zc_MIDate_ExpirationDate()
            INNER JOIN ContainerLinkObject AS CLO_MI
                                           ON CLO_MI.ContainerId = MIFloat_ContainerId.ValueData :: Integer
                                          AND CLO_MI.DescId      = zc_ContainerLinkObject_PartionMovementItem()

        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId     = zc_MI_Child()
          AND MovementItem.isErased   = FALSE
       ;

     -- элементы
     UPDATE _tmpItem_PartionDate SET PartionGoodsId = lpInsertFind_Object_PartionGoods (inMovementId:= _tmpItem_PartionDate.MovementId_in
                                                                                      , inOperDate  := _tmpItem_PartionDate.ExpirationDate
                                                                                       );
     -- элементы - zc_Container_CountPartionDate
     UPDATE _tmpItem_PartionDate SET ContainerId = lpInsertFind_Container (inContainerDescId   := zc_Container_CountPartionDate()
                                                                         , inParentId          := _tmpItem_PartionDate.ContainerId_in
                                                                         , inObjectId          := _tmpItem_PartionDate.GoodsId
                                                                         , inJuridicalId_basis := 0
                                                                         , inBusinessId        := NULL
                                                                         , inObjectCostDescId  := NULL
                                                                         , inObjectCostId      := NULL
                                                                         , inDescId_1          := zc_ContainerLinkObject_Unit()
                                                                         , inObjectId_1        := vbUnitId
                                                                         , inDescId_2          := zc_ContainerLinkObject_PartionMovementItem()
                                                                         , inObjectId_2        := _tmpItem_PartionDate.PartionId_in
                                                                         , inDescId_3          := zc_ContainerLinkObject_PartionGoods()
                                                                         , inObjectId_3        := _tmpItem_PartionDate.PartionGoodsId
                                                                          );

    -- Результат - ЗАБАЛАНСОВЫЕ проводки по сумме "Остатки количественного учета (по дате партии)"
    INSERT INTO _tmpMIContainer_insert (DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate
                                      , ObjectId_analyzer, WhereObjectId_analyzer, ObjectIntId_analyzer
                                       )
         SELECT zc_MIContainer_CountPartionDate()   AS DescId
              , zc_Movement_Income()                AS MovementDescId
              , inMovementId                        AS MovementId
              , _tmpItem_PartionDate.MovementItemId AS MovementItemId
              , _tmpItem_PartionDate.ContainerId    AS ContainerId
              , NULL                                AS AccountId
              , _tmpItem_PartionDate.Amount         AS OperSumm
              , vbOperDate                          AS OperDate
              , _tmpItem_PartionDate.GoodsId        AS ObjectId_analyzer
              , vbUnitId                            AS WhereObjectId_analyzer
              , _tmpItem_PartionDate.PartionId_in   AS ObjectIntId_analyzer
         FROM _tmpItem_PartionDate;


     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_SendPartionDate()
                                , inUserId     := inUserId
                                 );

     -- пересчитываем сумму документа по приходным ценам
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm(inMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.08.18         *
*/

-- тест
--