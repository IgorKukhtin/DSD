DROP FUNCTION IF EXISTS lpComplete_Movement_Send (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Send(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbAccountId       Integer;
   DECLARE vbUnitFromId      Integer;
   DECLARE vbUnitToId        Integer;
   DECLARE vbJuridicalFromId Integer;
   DECLARE vbJuridicalToId   Integer;
   DECLARE vbSendDate        TDateTime;
   DECLARE vbRetailId_from   Integer;
   DECLARE vbRetailId_to     Integer;
   DECLARE vbIsDeferred      Boolean;
   DECLARE vbPartionDateId   Integer;
   DECLARE vbGoodsName       TVarChar;
   DECLARE vbAmountM         TFloat;
   DECLARE vbAmountC         TFloat;
BEGIN

/*!!!test
if inMovementId = 14931454 AND inUserId = 3 then
perform gpUnComplete_Movement_Send (inMovementId, inUserId :: TVarChar);
end if;*/

     -- удаление табл.
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpMIContainer_insert'))
     THEN
         DROP TABLE _tmpMIContainer_insert;
         DROP TABLE _tmpMIReport_insert;
         DROP TABLE _tmpItem;
     END IF;

     -- Отложен
     vbIsDeferred := COALESCE ((SELECT MB.ValueData FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_Deferred()), FALSE);


     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;
     -- DELETE FROM _tmpMIReport_insert;

    -- нашли счет
    vbAccountId := lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- Запасы
                                              , inAccountDirectionId     := zc_Enum_AccountDirection_20100() -- Cклад
                                              , inInfoMoneyDestinationId := zc_Enum_InfoMoneyDestination_10200() -- Медикаменты
                                              , inInfoMoneyId            := NULL
                                              , inUserId                 := inUserId
                                               );

    -- параметры документа
    SELECT MovementLinkObject_From.ObjectId
         , ObjectLink_Unit_Juridical_From.ChildObjectId
         , MovementLinkObject_To.ObjectId
         , ObjectLink_Unit_Juridical_To.ChildObjectId
         , Movement.OperDate
         , ObjectLink_Juridical_Retail_From.ChildObjectId
         , ObjectLink_Juridical_Retail_To.ChildObjectId
         , COALESCE (MovementLinkObject_PartionDateKind.ObjectId, 0)
           INTO
                vbUnitFromId
              , vbJuridicalFromId
              , vbUnitToId
              , vbJuridicalToId
              , vbSendDate
              , vbRetailId_from
              , vbRetailId_to
              , vbPartionDateId
    FROM
        Movement
        INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                      ON MovementLinkObject_From.MovementId = Movement.Id
                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
        LEFT OUTER JOIN ObjectLink AS ObjectLink_Unit_Juridical_From
                                   ON ObjectLink_Unit_Juridical_From.ObjectId = MovementLinkObject_From.ObjectId
                                  AND ObjectLink_Unit_Juridical_From.DescId   = zc_ObjectLink_Unit_Juridical()
        LEFT OUTER JOIN ObjectLink AS ObjectLink_Juridical_Retail_From
                                   ON ObjectLink_Juridical_Retail_From.ObjectId = ObjectLink_Unit_Juridical_From.ChildObjectId
                                  AND ObjectLink_Juridical_Retail_From.DescId = zc_ObjectLink_Juridical_Retail()

        INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                      ON MovementLinkObject_To.MovementId = Movement.Id
                                     AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
        LEFT OUTER JOIN ObjectLink AS ObjectLink_Unit_Juridical_To
                                   ON ObjectLink_Unit_Juridical_To.ObjectId = MovementLinkObject_To.ObjectId
                                  AND ObjectLink_Unit_Juridical_To.DescId   = zc_ObjectLink_Unit_Juridical()
        LEFT OUTER JOIN ObjectLink AS ObjectLink_Juridical_Retail_To
                                   ON ObjectLink_Juridical_Retail_To.ObjectId = ObjectLink_Unit_Juridical_To.ChildObjectId
                                  AND ObjectLink_Juridical_Retail_To.DescId = zc_ObjectLink_Juridical_Retail()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                     ON MovementLinkObject_PartionDateKind.MovementId = Movement.Id
                                    AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
    WHERE Movement.Id = inMovementId;


    -- если это сроковый документ
    IF vbPartionDateId <> 0
    THEN
        -- кол-во Master должно быть равно Child
        IF EXISTS (SELECT 1
                   FROM MovementItem AS MI_Master
                        LEFT JOIN MovementItem AS MI_Child
                                               ON MI_Child.MovementId = inMovementId
                                              AND MI_Child.DescId     = zc_MI_Child()
                                              AND MI_Child.ParentId   = MI_Master.Id
                                              AND MI_Child.IsErased   = FALSE
                                              AND MI_Child.Amount     > 0
                   WHERE MI_Master.MovementId = inMovementId
                     AND MI_Master.DescId     = zc_MI_Master()
                     AND MI_Master.IsErased   = FALSE
                   GROUP BY MI_Master.Id
                   HAVING MI_Master.Amount <> COALESCE (SUM (MI_Child.Amount), 0)
                  )
        THEN
           SELECT Object_Goods.ValueData, MI_Master.Amount, COALESCE (SUM (MI_Child.Amount), 0)
           INTO vbGoodsName, vbAmountM, vbAmountC
           FROM MovementItem AS MI_Master
                LEFT JOIN MovementItem AS MI_Child
                                       ON MI_Child.MovementId = inMovementId
                                      AND MI_Child.DescId     = zc_MI_Child()
                                      AND MI_Child.ParentId   = MI_Master.Id
                                      AND MI_Child.IsErased   = FALSE
                                      AND MI_Child.Amount     > 0
                LEFT JOIN Object AS Object_Goods
                                 ON Object_Goods.ID = MI_Master.ObjectId
           WHERE MI_Master.MovementId = inMovementId
             AND MI_Master.DescId     = zc_MI_Master()
             AND MI_Master.IsErased   = FALSE
           GROUP BY MI_Master.Id, Object_Goods.ValueData, MI_Master.Amount
           HAVING MI_Master.Amount <> COALESCE (SUM (MI_Child.Amount), 0) LIMIT 1;

           RAISE EXCEPTION 'Ошибка.Как минимум у одного товара <%> количество <%> распределено <%>.Надо перераспределить товар по партиям.', vbGoodsName, vbAmountM, vbAmountC;
        END IF;

    ELSE
        --
        IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Child() AND MovementItem.IsErased = FALSE)
        THEN
           RAISE EXCEPTION 'Ошибка.В документе есть сроковые позиции. Провести невозможно.';
        END IF;
    END IF;


    -- А сюда товары
    WITH
        -- строки документа перемещения
        tmpMI_Send AS (SELECT MovementItem.Id       AS MovementItemId
                            , MovementItem.ObjectId AS ObjectId
                            , MovementItem.Amount   AS Amount
                       FROM MovementItem
                       WHERE MovementItem.MovementId = inMovementId
                         AND MovementItem.IsErased   = FALSE
                         AND MovementItem.DescId     = zc_MI_Master()
                         AND MovementItem.Amount     > 0
                      )
        -- находим товары для сети куда идет перемещение, если они разные
      , GoodsRetial_to AS (SELECT tmp.ObjectId
                                , ObjectLink_Child_to.ChildObjectId AS ObjectId_to
                           FROM (SELECT DISTINCT tmpMI_Send.ObjectId FROM tmpMI_Send WHERE vbRetailId_from <> vbRetailId_to) AS tmp
                                INNER JOIN  ObjectLink AS ObjectLink_Child ON ObjectLink_Child.ChildObjectId = tmp.ObjectId
                                                                          AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                                INNER JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                         AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()

                                INNER JOIN ObjectLink AS ObjectLink_Main_to ON ObjectLink_Main_to.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                           AND ObjectLink_Main_to.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                INNER JOIN ObjectLink AS ObjectLink_Child_to ON ObjectLink_Child_to.ObjectId = ObjectLink_Main_to.ObjectId
                                                                            AND ObjectLink_Child_to.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                INNER JOIN ObjectLink AS ObjectLink_Goods_Object_to
                                                      ON ObjectLink_Goods_Object_to.ObjectId = ObjectLink_Child_to.ChildObjectId
                                                     AND ObjectLink_Goods_Object_to.DescId = zc_ObjectLink_Goods_Object()
                                                     AND ObjectLink_Goods_Object_to.ChildObjectId = vbRetailId_to
                          )
        -- строки документа перемещения размазанные по текущему остатку(Контейнерам) на подразделении "From"
      , DD AS (SELECT
                   tmpMI_Send.MovementItemId
                   -- сколько надо получить
                 , tmpMI_Send.Amount
                   -- остаток
                 , Container.Amount AS AmountRemains
                 , Container.ObjectId
                 , Movement.OperDate   -- дата прихода от пост.
                 , MovementItem.Id AS PartionMovementItemId
                 , Container.Id    AS ContainerId
                   -- итого "накопительный" остаток
                 , SUM (Container.Amount) OVER (PARTITION BY Container.ObjectId ORDER BY Movement.OperDate, Container.Id, tmpMI_Send.MovementItemId) AS AmountRemains_sum
                   -- для последнего элемента - не смотрим на остаток
                 , ROW_NUMBER() OVER (PARTITION BY tmpMI_Send.MovementItemId ORDER BY Movement.OperDate DESC, Container.Id DESC, tmpMI_Send.MovementItemId DESC) AS DOrd
               FROM Container
                    JOIN tmpMI_Send ON tmpMI_Send.ObjectId = Container.ObjectId
                    JOIN containerlinkObject AS CLI_MI
                                             ON CLI_MI.ContainerId = Container.Id
                                            AND CLI_MI.DescId      = zc_ContainerLinkObject_PartionMovementItem()
                    JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                    JOIN MovementItem ON MovementItem.Id = Object_PartionMovementItem.ObjectCode
                    JOIN Movement ON Movement.Id = MovementItem.MovementId
               WHERE Container.WhereObjectId = vbUnitFromId
                 AND Container.DescId        = zc_Container_Count()
                 AND Container.Amount        > 0
              )
        -- итого для сроковых перемещений по zc_Container_Count
      , DDChild AS (SELECT
                        Container.ParentId             AS ContainerId
                      , Container.ObjectId             AS ObjectId
                      , MovementItem.Id                AS MovementItemId
                      , SUM (MovementItem.Amount)      AS Amount
                    FROM MovementItem
                         INNER JOIN MovementItem AS MI_Master
                                                 ON MI_Master.MovementId = inMovementId
                                                AND MI_Master.DescId     = zc_MI_Master()
                                                AND MI_Master.Id         = MovementItem.ParentId
                                                AND MI_Master.IsErased   = FALSE
                        -- это zc_Container_CountPartionDate
                        LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                    ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                   AND MIFloat_ContainerId.DescId         = zc_MIFloat_ContainerId()
                        LEFT JOIN Container ON Container.Id = MIFloat_ContainerId.ValueData :: Integer
                     WHERE MovementItem.MovementId = inMovementId
                       AND MovementItem.DescId     = zc_MI_Child()
                       AND MovementItem.IsErased   = FALSE
                       AND MovementItem.Amount     > 0
                       -- если это сроковый документ
                       AND vbPartionDateId <> 0
                     GROUP BY Container.ParentId, Container.ObjectId, MovementItem.Id
                   )
        -- контейнеры и zc_Container_Count, которые будут списаны (с подразделения "From")
      , tmpItem AS (
                    -- для простых перемещений - распределение
                    SELECT
                        DD.ContainerId            AS ContainerId_count
                      , NULL           :: Integer AS ContainerId_summ
                      , DD.PartionMovementItemId  AS PartionMovementItemId
                      , DD.MovementItemId         AS MovementItemId
                      , DD.ObjectId               AS ObjectId
                      , CASE WHEN vbRetailId_from <> vbRetailId_to THEN GoodsRetial_to.ObjectId_to ELSE DD.ObjectId END AS ObjectId_to
                      , CASE WHEN DD.Amount - DD.AmountRemains_sum > 0.0 AND DD.DOrd <> 1
                                  THEN DD.AmountRemains
                             ELSE DD.Amount - DD.AmountRemains_sum + DD.AmountRemains
                        END AS Amount
                      , 0 AS Summ
                    FROM DD
                         LEFT JOIN GoodsRetial_to ON GoodsRetial_to.ObjectId = DD.ObjectId
                         -- !!! вообще убрал эту табл!!!
                         /*LEFT JOIN Container AS Container_Summ
                                             ON Container_Summ.ParentId = DD.Id
                                            AND Container_Summ.DescId   = zc_Container_Summ()
                                            AND 1=0 -- !!!убрал!!!
                                            */
                    WHERE vbPartionDateId = 0
                      AND (DD.Amount - (DD.AmountRemains_sum - DD.AmountRemains) > 0)

                   UNION ALL
                    -- для сроковых перемещений - сразу ContainerId
                    SELECT
                        DDChild.ContainerId                AS ContainerId_count
                      , NULL                    :: Integer AS ContainerId_summ
                      , PartionMovementItem.Id             AS PartionMovementItemId
                      , DDChild.MovementItemID             AS MovementItemId
                      , DDChild.ObjectId
                      , CASE WHEN vbRetailId_from <> vbRetailId_to THEN GoodsRetial_to.ObjectId_to ELSE DDChild.ObjectId END AS ObjectId_to
                      , DDChild.Amount                     AS Amount
                      , 0 AS Summ
                    FROM DDChild
                         LEFT JOIN GoodsRetial_to ON GoodsRetial_to.ObjectId = DDChild.ObjectId
                         LEFT JOIN containerlinkObject AS CLI_MI
                                                       ON CLI_MI.ContainerId = DDChild.ContainerId
                                                      AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
                         LEFT JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                         LEFT JOIN MovementItem AS PartionMovementItem ON PartionMovementItem.Id = Object_PartionMovementItem.ObjectCode
                         LEFT JOIN Movement AS PartionMovement ON PartionMovement.Id = PartionMovementItem.MovementId
                    WHERE vbPartionDateId <> 0
                   )
        -- проводки кол-во
      , tmpAll AS  (-- расход с подразделения "From"
                    SELECT
                         ContainerId_count
                       , MovementItemId
                       , ObjectId
                       , vbSendDate  AS OperDate
                       , -1 * Amount AS Amount
                       , FALSE       AS IsActive
                    FROM tmpItem

                   UNION ALL
                    -- приход на подразделение "To"
                    SELECT
                        -- определяется ContainerId
                        lpInsertFind_Container (inContainerDescId   := zc_Container_Count()
                                              , inParentId          := NULL
                                              , inObjectId          := tmpItem.ObjectId_to
                                              , inJuridicalId_basis := vbJuridicalToId
                                              , inBusinessId        := NULL
                                              , inObjectCostDescId  := NULL
                                              , inObjectCostId      := NULL
                                              , inDescId_1          := zc_ContainerLinkObject_Unit()                -- DescId для 1-ой Аналитики
                                              , inObjectId_1        := vbUnitToId
                                              , inDescId_2          := zc_ContainerLinkObject_PartionMovementItem() -- DescId для 2-ой Аналитики
                                              , inObjectId_2        := lpInsertFind_Object_PartionMovementItem (tmpItem.PartionMovementItemId)
                                               ) AS ContainerId_count
                       , tmpItem.MovementItemId  AS MovementItemId
                       , tmpItem.ObjectId_to     AS ObjectId
                       , vbSendDate              AS OperDate
                       , 1 * tmpItem.Amount      AS Amount
                       , TRUE                    AS IsActive
                    FROM tmpItem
                    WHERE vbIsDeferred = FALSE -- !!! если НЕ Отложен, тогда приходуем!!!
                   )
        -- проводки суммы
      , tmpSumm AS (-- расход с подразделения "From"
                    SELECT
                         ContainerId_summ
                       , MovementItemId
                       , ObjectId
                       , vbSendDate  AS OperDate
                       , -1 * Summ   AS Summ
                       , FALSE       AS isActive
                    FROM tmpItem

                   UNION ALL
                    --  приход на подразделение "To"
                    SELECT
                         -- определяется ContainerId
                         lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                               , inParentId          := -- определяется ContainerId - кол-во
                                                                        lpInsertFind_Container(inContainerDescId   := zc_Container_Count()
                                                                                             , inParentId          := NULL
                                                                                             , inObjectId          := tmpItem.ObjectId_to
                                                                                             , inJuridicalId_basis := vbJuridicalToId
                                                                                             , inBusinessId        := NULL
                                                                                             , inObjectCostDescId  := NULL
                                                                                             , inObjectCostId      := NULL
                                                                                             , inDescId_1          := zc_ContainerLinkObject_Unit()                -- DescId для 1-ой Аналитики
                                                                                             , inObjectId_1        := vbUnitToId
                                                                                             , inDescId_2          := zc_ContainerLinkObject_PartionMovementItem() -- DescId для 2-ой Аналитики
                                                                                             , inObjectId_2        := lpInsertFind_Object_PartionMovementItem (tmpItem.PartionMovementItemId)
                                                                                              )
                                               , inObjectId          := tmpItem.ObjectId
                                               , inJuridicalId_basis := vbJuridicalToId
                                               , inBusinessId        := NULL
                                               , inObjectCostDescId  := NULL
                                               , inObjectCostId      := NULL
                                               , inDescId_1          := zc_ContainerLinkObject_Unit()                -- DescId для 1-ой Аналитики
                                               , inObjectId_1        := vbUnitToId
                                               , inDescId_2          := zc_ContainerLinkObject_PartionMovementItem() -- DescId для 2-ой Аналитики
                                               , inObjectId_2        := lpInsertFind_Object_PartionMovementItem  (tmpItem.PartionMovementItemId)
                                                ) AS ContainerId_summ
                       , tmpItem.MovementItemId  AS MovementItemId
                       , tmpItem.ObjectId_to     AS ObjectId
                       , vbSendDate              AS OperDate
                       , 1 * tmpItem.Summ        AS Summ
                       , TRUE                    AS isActive
                    FROM tmpItem
                    WHERE vbIsDeferred = FALSE -- !!! если НЕ Отложен, тогда приходуем!!!
                   )
    -- Результат
    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate,IsActive)
       -- обычные проводки по количеству
       SELECT
           zc_MIContainer_Count()
         , zc_Movement_Send()
         , inMovementId
         , tmpAll.MovementItemId
         , tmpAll.ContainerId_count
         , vbAccountId
         , tmpAll.Amount
         , tmpAll.OperDate
         , tmpAll.isActive
       FROM tmpAll

      UNION ALL
       -- обычные проводки по суммам
       SELECT
           zc_MIContainer_Summ()
         , zc_Movement_Send()
         , inMovementId
         , tmpSumm.MovementItemId
         , tmpSumm.ContainerId_summ
         , vbAccountId
         , tmpSumm.Summ
         , tmpSumm.OperDate
         , tmpSumm.isActive
       FROM tmpSumm
      ;

--    RAISE EXCEPTION 'Проводок %', (select Count(*) from _tmpMIContainer_insert);


    -- если это обычное Перемещение, но все равно надо списать сроковые партии
    IF vbPartionDateId = 0
       AND EXISTS (SELECT 1 FROM Container WHERE Container.DescId   = zc_Container_CountPartionDate()
                                             AND Container.Amount   > 0
                                             AND Container.ParentId IN (-- только расход
                                                                        SELECT _tmpMIContainer_insert.ContainerId FROM _tmpMIContainer_insert
                                                                        WHERE _tmpMIContainer_insert.DescId   = zc_MIContainer_Count()
                                                                          AND _tmpMIContainer_insert.isActive = FALSE
                                                                       ))
    THEN
      WITH -- Остатки сроковых партий - zc_Container_CountPartionDate
           DD AS (SELECT _tmpMIContainer_insert.MovementItemId
                         -- сколько надо получить
                       , -1 * _tmpMIContainer_insert.Amount AS Amount
                         -- остаток
                       , Container.Amount AS AmountRemains
                       , vbSendDate       AS OperDate
                       , Container.Id     AS ContainerId
                         -- итого "накопительный" остаток
                       , SUM (Container.Amount) OVER (PARTITION BY Container.ParentId ORDER BY Container.Id) AS AmountRemains_sum
                         -- для последнего элемента - не смотрим на остаток
                       , ROW_NUMBER() OVER (PARTITION BY _tmpMIContainer_insert.MovementItemId ORDER BY Container.Id DESC) AS DOrd
                   FROM _tmpMIContainer_insert
                        JOIN Container ON Container.ParentId = _tmpMIContainer_insert.ContainerId
                                      AND Container.DescId   = zc_Container_CountPartionDate()
                                      AND Container.Amount   > 0.0
                   WHERE _tmpMIContainer_insert.DescId      = zc_MIContainer_Count()
                     AND _tmpMIContainer_insert.isActive    = FALSE -- только расход
                  )

           -- распределение
         , tmpItem AS (SELECT ContainerId
                            , MovementItemId
                            , OperDate
                            , CASE WHEN DD.Amount - DD.AmountRemains_sum > 0.0 AND DD.DOrd <> 1
                                        THEN DD.AmountRemains
                                   ELSE DD.Amount - DD.AmountRemains_sum + DD.AmountRemains
                              END AS Amount
                         FROM DD
                         WHERE (DD.Amount > 0 AND DD.Amount - (DD.AmountRemains_sum - DD.AmountRemains) > 0))
        -- Результат - проводки по срокам - расход
        INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate)
          SELECT zc_MIContainer_CountPartionDate()
               , zc_Movement_Send()
               , inMovementId
               , tmpItem.MovementItemId
               , tmpItem.ContainerId
               , NULL
               , -1 * Amount
               , OperDate
          FROM tmpItem
         ;

    ELSEIF vbPartionDateId <> 0
    THEN
        -- проводки по срокам - сразу по ContainerId
        INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate)
          SELECT
                 zc_MIContainer_CountPartionDate()
               , zc_Movement_Send()
               , inMovementId
               , MovementItem.Id
               , MIFloat_ContainerId.ValueData :: Integer
               , Null
               , - MovementItem.Amount
               , vbSendDate
            FROM MovementItem
                INNER JOIN MovementItem AS MI_Master
                                        ON MI_Master.Id         = MovementItem.ParentId
                                       AND MI_Master.MovementId = inMovementId
                                       AND MI_Master.DescId     = zc_MI_Master()
                                       AND MI_Master.isErased   = FALSE

                LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                            ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                           AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.isErased   = FALSE
               AND MovementItem.DescId     = zc_MI_Child()
               AND MovementItem.Amount     > 0
            ;

    END IF;

      -- Проводки если затронуты контейнера сроков в подразделении получателя "To"
    IF EXISTS(SELECT 1 FROM Container WHERE Container.ParentId in (SELECT _tmpMIContainer_insert.ContainerId FROM _tmpMIContainer_insert
                                                                       WHERE _tmpMIContainer_insert.DescId = zc_MIContainer_Count()
                                                                         AND _tmpMIContainer_insert.Amount > 0.0))
    THEN

      WITH DD AS (
         SELECT
            ROW_NUMBER()OVER(PARTITION BY Container.ParentId ORDER BY Container.Id DESC) as ORD
          , _tmpMIContainer_insert.MovementItemId
          , _tmpMIContainer_insert.Amount
          , Container.Amount AS ContainerAmount
          , vbSendDate       AS OperDate
          , Container.Id     AS ContainerId
          , SUM (Container.Amount) OVER (PARTITION BY Container.ParentId ORDER BY Container.Id)
          FROM Container
               JOIN _tmpMIContainer_insert ON _tmpMIContainer_insert.ContainerId = Container.ParentId
                                          AND _tmpMIContainer_insert.DescId      = zc_MIContainer_Count()
          WHERE Container.DescId              = zc_Container_CountPartionDate()
            AND _tmpMIContainer_insert.Amount > 0.0
         )

       , tmpItem AS (SELECT ContainerId     AS Id
                          , MovementItemId  AS MovementItemId
                          , OperDate
                          , Amount
                       FROM DD
                       WHERE ORD = 1)

        INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate)
          SELECT
                 zc_MIContainer_CountPartionDate()
               , zc_Movement_Send()
               , inMovementId
               , tmpItem.MovementItemId
               , tmpItem.Id
               , Null
               , Amount
               , OperDate
            FROM tmpItem;
    END IF;

     -- ФИНИШ - Обязательно сохранили
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();


     IF vbIsDeferred = FALSE
     THEN
         -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
         PERFORM lpComplete_Movement (inMovementId := inMovementId
                                    , inDescId     := zc_Movement_Send()
                                    , inUserId     := inUserId
                                     );
     END IF;

/*
!!!test
if inMovementId = 14931454 AND inUserId = 3 then
RAISE EXCEPTION '<%>  %'
, (SELECT Amount from MovementItemContainer where ContainerId in (18286796) and MovementId = 14931454)
, (SELECT Amount from MovementItemContainer where ContainerId in (17815530) and MovementId = 14931454)
;
end if;*/


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.   Шаблий О.В.
 08.07.19                                                                                    *
 29.07.15                                                                     *
*/

-- SELECT * FROM lpComplete_Movement_Send (inMovementId:= 14931454, inUserId:= 3)