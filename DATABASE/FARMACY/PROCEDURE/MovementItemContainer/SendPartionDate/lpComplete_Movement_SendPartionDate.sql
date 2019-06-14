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
   DECLARE vbMonth_6  Integer;
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


     -- Проверка
     IF COALESCE (vbUnitId, 0) = 0
     THEN 
         RAISE EXCEPTION 'Ошибка.Подразделение не установлено.';
     END IF;


     --
     vbMonth_6 := (SELECT ObjectFloat_Month.ValueData
                   FROM Object  AS Object_PartionDateKind
                        LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                              ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                             AND ObjectFloat_Month.DescId   = zc_ObjectFloat_PartionDateKind_Month()
                   WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_6()
                  );
 
     -- !!!Пересчитали MI_Master.Amount - остаток со сроком на начало дня Movement.OperDate!!!
     PERFORM lpInsertUpdate_MovementItem (tmp.MovementItemId, zc_MI_Master(), tmp.GoodsId, inMovementId, tmp.Amount, NULL)
     FROM (SELECT MI_Master.Id AS MovementItemId, MI_Master.ObjectId AS GoodsId
                , SUM (CASE WHEN MIDate_ExpirationDate.ValueData <= vbOperDate + (vbMonth_6||' MONTH' ) :: INTERVAL THEN COALESCE (MovementItem.Amount, 0) ELSE 0 END) AS Amount
           FROM MovementItem AS MI_Master
                LEFT JOIN MovementItem ON MI_Master.MovementId  = inMovementId
                                      AND MovementItem.ParentId = MI_Master.Id
                                      AND MovementItem.DescId   = zc_MI_Child()
                                      AND MovementItem.isErased = FALSE
                LEFT JOIN MovementItemDate AS MIDate_ExpirationDate
                                           ON MIDate_ExpirationDate.MovementItemId = MovementItem.Id
                                          AND MIDate_ExpirationDate.DescId         = zc_MIDate_ExpirationDate()
           WHERE MI_Master.MovementId = inMovementId
             AND MI_Master.DescId     = zc_MI_Master()
             AND MI_Master.isErased   = FALSE
           GROUP BY MI_Master.Id, MI_Master.ObjectId
          ) AS tmp;


     -- таблица - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem_PartionDate (MovementItemId Integer, GoodsId Integer, Amount TFloat
                                           , ContainerId_in Integer, ContainerId Integer
                                           , MovementId_in Integer, PartionId_in Integer
                                           , PartionGoodsId Integer
                                           , ExpirationDate TDateTime
                                           , ChangePercentMin TFloat, ChangePercent TFloat
                                            ) ON COMMIT DROP;
     -- таблица - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem_PartionDate (MovementItemId, GoodsId, Amount, ContainerId_in, ContainerId, MovementId_in, PartionId_in, PartionGoodsId, ExpirationDate, ChangePercentMin, ChangePercent)
        SELECT MovementItem.Id                    AS MovementItemId
             , MovementItem.ObjectId              AS GoodsId
             , CASE WHEN MIDate_ExpirationDate.ValueData <= vbOperDate + (vbMonth_6||' MONTH' ) :: INTERVAL THEN MovementItem.Amount ELSE 0 END AS Amount
             , MIFloat_ContainerId.ValueData      AS ContainerId_in
             , 0                                  AS ContainerId
             , MIFloat_MovementId.ValueData       AS MovementId_in
             , CLO_MI.ObjectId                    AS PartionId_in
             , 0                                  AS PartionGoodsId
               -- Дата "срок годности"
             , MIDate_ExpirationDate.ValueData    AS ExpirationDate
               -- % скидки(срок меньше месяца)
             , CASE WHEN MIFloat_ChangePercentMin.ValueData <> 0 THEN MIFloat_ChangePercentMin.ValueData
                    WHEN MF_ChangePercentMin.ValueData      <> 0 THEN MF_ChangePercentMin.ValueData
                    ELSE 0
               END AS ChangePercentMin
               -- % скидки(срок от 1 мес до 6 мес) 
             , CASE WHEN MIFloat_ChangePercent.ValueData <> 0 THEN MIFloat_ChangePercent.ValueData
                    WHEN MF_ChangePercent.ValueData      <> 0 THEN MF_ChangePercent.ValueData
                    ELSE 0
               END AS ChangePercent
        FROM MovementItem
            INNER JOIN MovementItem AS MI_Master ON MI_Master.MovementId = inMovementId
                                                AND MI_Master.DescId     = zc_MI_Master()
                                                AND MI_Master.Id         = MovementItem.ParentId
                                                AND MI_Master.isErased   = FALSE
            LEFT JOIN MovementFloat AS MF_ChangePercent
                                    ON MF_ChangePercent.MovementId = MovementItem.MovementId
                                   AND MF_ChangePercent.DescId     = zc_MovementFloat_ChangePercent()
            LEFT JOIN MovementFloat AS MF_ChangePercentMin
                                    ON MF_ChangePercentMin.MovementId = MovementItem.MovementId
                                   AND MF_ChangePercentMin.DescId     = zc_MovementFloat_ChangePercentMin()

            LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                        ON MIFloat_ChangePercent.MovementItemId = MovementItem.ParentId
                                       AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
            LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentMin
                                        ON MIFloat_ChangePercentMin.MovementItemId = MovementItem.ParentId
                                       AND MIFloat_ChangePercentMin.DescId         = zc_MIFloat_ChangePercentMin()

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
          AND CASE WHEN MIDate_ExpirationDate.ValueData <= vbOperDate + (vbMonth_6||' MONTH' ) :: INTERVAL THEN MovementItem.Amount ELSE 0 END > 0
       ;

     -- элементы
     UPDATE _tmpItem_PartionDate SET PartionGoodsId = lpInsertFind_Object_PartionGoods (-- Документ "Приход от поставщика"
                                                                                        inMovementId      := _tmpItem_PartionDate.MovementId_in
                                                                                        -- Документ zc_Movement_SendPartionDate
                                                                                      , inMovementId_send := inMovementId
                                                                                        -- срок годности - по нему учет
                                                                                      , inOperDate        := _tmpItem_PartionDate.ExpirationDate
                                                                                        -- Подразделение
                                                                                      , inUnitId          := vbUnitId
                                                                                        -- товар
                                                                                      , inGoodsId         := _tmpItem_PartionDate.GoodsId
                                                                                        -- % скидки на срок от 0 мес. до 1 мес.
                                                                                      , inChangePercentMin:= _tmpItem_PartionDate.ChangePercentMin
                                                                                        -- % скидки на срок от 1 мес. до 6 мес.
                                                                                      , inChangePercent   := _tmpItem_PartionDate.ChangePercent
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
