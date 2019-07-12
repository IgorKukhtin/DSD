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
   DECLARE vbPartionDateID   Integer;
BEGIN
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
  --   DELETE FROM _tmpMIReport_insert;
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;

   vbAccountId := lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- Запасы
                                     , inAccountDirectionId     := zc_Enum_AccountDirection_20100() -- Cклад
                                     , inInfoMoneyDestinationId := zc_Enum_InfoMoneyDestination_10200() -- Медикаменты
                                     , inInfoMoneyId            := NULL
                                     , inUserId                 := inUserId);

    SELECT
        MovementLinkObject_From.ObjectId
       ,ObjectLink_Unit_Juridical_From.ChildObjectId
       ,MovementLinkObject_To.ObjectId
       ,ObjectLink_Unit_Juridical_To.ChildObjectId
       ,Movement.OperDate
       , ObjectLink_Juridical_Retail_From.ChildObjectId
       , ObjectLink_Juridical_Retail_To.ChildObjectId
       , COALESCE (MovementLinkObject_PartionDateKind.ObjectId, 0)
    INTO
        vbUnitFromId
       ,vbJuridicalFromId
       ,vbUnitToId
       ,vbJuridicalToId
       ,vbSendDate
       , vbRetailId_from
       , vbRetailId_to
       , vbPartionDateID
    FROM
        Movement
        Inner Join MovementLinkObject AS MovementLinkObject_From
                                      ON MovementLinkObject_From.MovementId = Movement.Id
                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
        LEFT OUTER JOIN ObjectLink AS ObjectLink_Unit_Juridical_From
                                   ON ObjectLink_Unit_Juridical_From.ObjectId = MovementLinkObject_From.ObjectId
                                  AND ObjectLink_Unit_Juridical_From.DescId   = zc_ObjectLink_Unit_Juridical()
        LEFT OUTER JOIN ObjectLink AS ObjectLink_Juridical_Retail_From
                                   ON ObjectLink_Juridical_Retail_From.ObjectId = ObjectLink_Unit_Juridical_From.ChildObjectId
                                  AND ObjectLink_Juridical_Retail_From.DescId = zc_ObjectLink_Juridical_Retail()

        Inner Join MovementLinkObject AS MovementLinkObject_To
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

    IF vbPartionDateID <> 0
    THEN
      IF EXISTS(SELECT
                       COALESCE(MovementItemMaster.Id, 0)
                FROM MovementItem AS MovementItemMaster
                     FULL JOIN MovementItem AS MovementItemChild
                                            ON MovementItemChild.MovementId = inMovementId
                                           AND MovementItemChild.ParentId = MovementItemMaster.Id
                                           AND MovementItemChild.IsErased = FALSE
                                           AND MovementItemChild.DescId = zc_MI_Child()
                                           AND COALESCE(MovementItemChild.Amount,0) > 0

                WHERE MovementItemMaster.MovementId = inMovementId
                  AND MovementItemMaster.IsErased = FALSE
                  AND MovementItemMaster.DescId = zc_MI_Master()
                  AND COALESCE(MovementItemMaster.Amount,0) > 0
                GROUP BY COALESCE(MovementItemMaster.Id, 0), COALESCE(MovementItemMaster.Amount, 0)
                HAVING COALESCE(SUM(MovementItemChild.Amount), 0) <> COALESCE(MovementItemMaster.Amount, 0))
      THEN
         RAISE EXCEPTION 'Ошибка.Надо перераспределить товар по партиям..';
      END IF;
    ELSE
      IF EXISTS(SELECT 1 FROM MovementItem
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId = zc_MI_Child())
      THEN
         RAISE EXCEPTION 'Ошибка.В документе есть сроковые позиции. Провести невозможно';
      END IF;
    END IF;


    -- А сюда товары
    WITH
        Send AS( -- строки документа перемещения
                    SELECT
                        MovementItem.Id       as MovementItemId
                       ,MovementItem.ObjectId as ObjectId
                       ,MovementItem.Amount   as Amount
                    FROM MovementItem
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.IsErased = FALSE
                      AND MovementItem.DescId = zc_MI_Master()
                      AND COALESCE(MovementItem.Amount,0) > 0
                )
        -- находим товары из другой сети
      , GoodsRetial_to AS (SELECT tmp.ObjectId
                                , ObjectLink_Child_to.ChildObjectId AS ObjectId_to
                           FROM (SELECT DISTINCT Send.ObjectId FROM Send WHERE vbRetailId_from <> vbRetailId_to) AS tmp
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
      , DD AS  (
                    SELECT
                        Send.MovementItemId
                      , Send.Amount
                      , Container.Amount AS ContainerAmount
                      , Container.ObjectId
                      , OperDate
                      , Container.Id
                      , SUM(Container.Amount) OVER (PARTITION BY Container.objectid ORDER BY OPERDATE,Container.Id)
                      , movementitem.Id AS PartionMovementItemId
                    FROM Container
                        JOIN Send ON Send.objectid = Container.objectid
                        JOIN containerlinkobject AS CLI_MI
                                                 ON CLI_MI.containerid = Container.Id
                                                AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()
                        JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                        JOIN movementitem ON movementitem.Id = Object_PartionMovementItem.ObjectCode
                        JOIN Movement ON Movement.Id = movementitem.movementid
                    WHERE Container.Amount > 0
                      AND Container.DescId = zc_Container_Count()
                      AND Container.WhereObjectId = vbUnitFromId
                )
        -- строки документа перемещения по контейнерам для сроковых перемещений
      , DDChild AS  (
                        SELECT
                            Container.ParentId             AS ContainerId
                          , Container.ObjectId
                          , MovementItem.ID                AS MovementItemId
                          , SUM(MovementItem.Amount)       AS Amount
                        FROM MovementItem

                            INNER JOIN MovementItem AS MovementItemMaster
                                                    ON MovementItemMaster.ID = MovementItem.ParentId
                                                   AND MovementItemMaster.MovementId = inMovementId 
                                                   AND MovementItemMaster.IsErased = FALSE
                                                   
                            LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                        ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                       AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
                            LEFT JOIN Container ON Container.Id = MIFloat_ContainerId.ValueData::Integer
                         WHERE MovementItem.MovementId = inMovementId
                           AND MovementItem.IsErased = FALSE
                           AND MovementItem.DescId = zc_MI_Child()
                           AND COALESCE(MovementItem.Amount,0) > 0
                           AND vbPartionDateID <> 0
                         GROUP BY Container.ParentId, Container.ObjectId, MovementItem.ID
                )

      , tmpItem AS ( -- контейнеры и кол-во(Сумма), которое с них будет списано (с подразделения "From") для простых перемещений
                        SELECT
                            DD.Id             AS Container_AmountId
                          , Container_Summ.Id AS Container_SummId
                          , DD.PartionMovementItemId
                          , DD.MovementItemId
                          , DD.ObjectId
                          , CASE WHEN vbRetailId_from <> vbRetailId_to THEN GoodsRetial_to.ObjectId_to ELSE DD.ObjectId END AS ObjectId_to
                          , DD.OperDate
                          , CASE WHEN DD.Amount - DD.SUM > 0
                                      THEN DD.ContainerAmount
                                 ELSE DD.Amount - DD.SUM + DD.ContainerAmount
                            END AS Amount
                          , CASE WHEN DD.Amount - DD.SUM > 0
                                      THEN Container_Summ.Amount
                                 ELSE (DD.Amount - DD.SUM + DD.ContainerAmount) * (Container_Summ.Amount / DD.ContainerAmount)
                            END AS Summ
                        FROM DD
                            LEFT JOIN GoodsRetial_to ON GoodsRetial_to.ObjectId = DD.ObjectId
                            -- !!! вообще убрал эту табл!!!
                            LEFT JOIN Container AS Container_Summ
                                                ON Container_Summ.ParentId = DD.Id
                                               AND Container_Summ.DescId = zc_Container_Summ()
                                               AND 1=0 -- !!!убрал!!!
                        WHERE vbPartionDateID = 0
                          AND (DD.Amount - (DD.SUM - DD.ContainerAmount) > 0)
                        UNION ALL
                     -- контейнеры и кол-во(Сумма), которое с них будет списано (с подразделения "From") для сроковых перемещений   
                        SELECT
                            DDChild.ContainerId                AS Container_AmountId
                          , Null                               AS Container_SummId
                          , PartionMovementItem.Id             AS PartionMovementItemId
                          , DDChild.MovementItemID             AS MovementItemId
                          , DDChild.ObjectId
                          , CASE WHEN vbRetailId_from <> vbRetailId_to THEN GoodsRetial_to.ObjectId_to ELSE DDChild.ObjectId END AS ObjectId_to
                          , PartionMovement.OperDate
                          , DDChild.Amount                     AS Amount
                          , 0 AS Summ
                        FROM DDChild
                            LEFT JOIN GoodsRetial_to ON GoodsRetial_to.ObjectId = DDChild.ObjectId
                            LEFT JOIN containerlinkobject AS CLI_MI
                                                          ON CLI_MI.containerid = DDChild.ContainerId
                                                         AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()
                            LEFT JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                            LEFT JOIN movementitem AS Partionmovementitem ON Partionmovementitem.Id = Object_PartionMovementItem.ObjectCode
                            LEFT JOIN Movement AS PartionMovement ON PartionMovement.Id = Partionmovementitem.movementid
                        WHERE vbPartionDateID <> 0
                    )
      , tmpAll AS  ( --Контейнеры и количество которое будет списано с подразделения "From"
                        SELECT
                            Container_AmountId
                           ,MovementItemId
                           ,ObjectId
                           ,vbSendDate AS OperDate
                           ,1 * Amount AS Amount
                           ,True       AS IsActive
                        FROM tmpItem
                        UNION ALL --    + Контейнеры и количество которое будет приходовано на подразделение "To"
                        SELECT
                            lpInsertFind_Container (inContainerDescId   := zc_Container_Count(), -- DescId Остатка
                                                    inParentId          := NULL  , -- Главный Container
                                                    inObjectId          := tmpItem.ObjectId_to, -- Объект (Счет или Товар или ...)
                                                    inJuridicalId_basis := vbJuridicalToId, -- Главное юридическое лицо
                                                    inBusinessId        := NULL, -- Бизнесы
                                                    inObjectCostDescId  := NULL, -- DescId для <элемент с/с>
                                                    inObjectCostId      := NULL,
                                                    inDescId_1          := zc_ContainerLinkObject_Unit(), -- DescId для 1-ой Аналитики
                                                    inObjectId_1        := vbUnitToId,
                                                    inDescId_2          := zc_ContainerLinkObject_PartionMovementItem(), -- DescId для 2-ой Аналитики
                                                    inObjectId_2        := lpInsertFind_Object_PartionMovementItem(tmpItem.PartionMovementItemId)
                                                   ) as Container_AmountId
                           ,tmpItem.MovementItemId  AS MovementItemId
                           ,tmpItem.ObjectId_to     AS ObjectId
                           ,vbSendDate              AS OperDate
                           ,-1 * TmpItem.Amount     AS Amount
                           ,False                   AS IsActive
                        FROM tmpItem
                        WHERE vbIsDeferred = FALSE
                    )
      , tmpSumm AS (    -- Контейнеры и Сумма которое будет списано с подразделения "From"
                        SELECT
                            Container_SummId
                           ,MovementItemId
                           ,ObjectId
                           ,vbSendDate AS OperDate
                           ,Summ
                           ,True       AS isActive
                        FROM tmpItem

                       UNION ALL
                        --  + Контейнеры и сумма которая будет приходовано на подразделение "To"
                        SELECT
                            lpInsertFind_Container (inContainerDescId   := zc_Container_Summ(), -- DescId Остатка
                                                    inParentId          := lpInsertFind_Container(
                                                                                                    inContainerDescId   := zc_Container_Count(), -- DescId Остатка
                                                                                                    inParentId          := NULL    , -- Главный Container
                                                                                                    inObjectId          := tmpItem.ObjectId_to, -- Объект (Счет или Товар или ...)
                                                                                                    inJuridicalId_basis := vbJuridicalToId, -- Главное юридическое лицо
                                                                                                    inBusinessId        := NULL, -- Бизнесы
                                                                                                    inObjectCostDescId  := NULL, -- DescId для <элемент с/с>
                                                                                                    inObjectCostId      := NULL,
                                                                                                    inDescId_1          := zc_ContainerLinkObject_Unit(), -- DescId для 1-ой Аналитики
                                                                                                    inObjectId_1        := vbUnitToId,
                                                                                                    inDescId_2          := zc_ContainerLinkObject_PartionMovementItem(), -- DescId для 2-ой Аналитики
                                                                                                    inObjectId_2        := lpInsertFind_Object_PartionMovementItem(tmpItem.PartionMovementItemId))               , -- Главный Container
                                                    inObjectId          := tmpItem.ObjectId, -- Объект (Счет или Товар или ...)
                                                    inJuridicalId_basis := vbJuridicalToId, -- Главное юридическое лицо
                                                    inBusinessId        := NULL, -- Бизнесы
                                                    inObjectCostDescId  := NULL, -- DescId для <элемент с/с>
                                                    inObjectCostId      := NULL,
                                                    inDescId_1          := zc_ContainerLinkObject_Unit(), -- DescId для 1-ой Аналитики
                                                    inObjectId_1        := vbUnitToId,
                                                    inDescId_2          := zc_ContainerLinkObject_PartionMovementItem(), -- DescId для 2-ой Аналитики
                                                    inObjectId_2        := lpInsertFind_Object_PartionMovementItem(tmpItem.PartionMovementItemId)
                                                   ) AS Container_SummId
                           ,tmpItem.MovementItemId  AS MovementItemId
                           ,tmpItem.ObjectId_to     AS ObjectId
                           ,vbSendDate              AS OperDate
                           ,-1 * TmpItem.Summ
                           ,False                   AS isActive
                        FROM tmpItem
                        WHERE vbIsDeferred = FALSE
                    )


    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate,IsActive)
    SELECT --контейнеры по количество
        zc_Container_Count()
      , zc_Movement_Send()
      , inMovementId
      , tmpAll.MovementItemId
      , tmpAll.Container_AmountId
      , vbAccountId
      , -Amount
      , OperDate
      ,IsActive
    FROM tmpAll
    UNION ALL
    SELECT --Контейнеры по сумме
        zc_Container_Summ()
      , zc_Movement_Send()
      , inMovementId
      , tmpSumm.MovementItemId
      , tmpSumm.Container_SummId
      , vbAccountId
      , -Summ
      , OperDate
      ,IsActive
    FROM tmpSumm;

--    RAISE EXCEPTION 'Проводок %', (select Count(*) from _tmpMIContainer_insert);

      -- Проводки по подразделению "From" если затронуты контейнера сроков и простое перемещение
    IF vbPartionDateID = 0
       AND EXISTS(SELECT 1 FROM Container WHERE Container.ParentId in (SELECT _tmpMIContainer_insert.ContainerId FROM _tmpMIContainer_insert
                                                                       WHERE _tmpMIContainer_insert.DescId = zc_Container_Count()
                                                                         AND _tmpMIContainer_insert.Amount < 0.0))
    THEN

      WITH DD AS (
         SELECT
            _tmpMIContainer_insert.MovementItemId
          , _tmpMIContainer_insert.Amount
          , Container.Amount AS ContainerAmount
          , vbSendDate       AS OperDate
          , Container.Id     AS ContainerId
          , SUM (Container.Amount) OVER (PARTITION BY Container.ParentId ORDER BY Container.Id)
          FROM Container
               JOIN _tmpMIContainer_insert ON _tmpMIContainer_insert.ContainerId = Container.ParentId
                                          AND _tmpMIContainer_insert.DescId = zc_Container_Count()
          WHERE Container.DescId = zc_Container_CountPartionDate()
            AND Container.Amount > 0.0
            AND _tmpMIContainer_insert.Amount < 0.0
         )

       , tmpItem AS (SELECT ContainerId     AS Id
		                    , MovementItemId  AS MovementItemId
                            , OperDate
			                , CASE WHEN -Amount - SUM > 0.0 THEN ContainerAmount
                                 ELSE -Amount - SUM + ContainerAmount
                                 END AS Amount
                       FROM DD
                       WHERE (Amount < 0 AND -Amount - (SUM - ContainerAmount) >= 0))

        INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate)
          SELECT
                 zc_MIContainer_CountPartionDate()
               , zc_Movement_Send()
               , inMovementId
               , tmpItem.MovementItemId
               , tmpItem.Id
               , Null
               , -Amount
               , OperDate
            FROM tmpItem;
    ELSEIF vbPartionDateID <> 0
    THEN
      -- Проводки по контейнерам "From" сроков для сроковых перемещений

      INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate)
        SELECT
               zc_MIContainer_CountPartionDate()
             , zc_Movement_Send()
             , inMovementId
             , MovementItem.Id
             , MIFloat_ContainerId.ValueData::Integer
             , Null
             , - MovementItem.Amount
             , vbSendDate
          FROM MovementItem

              INNER JOIN MovementItem AS MovementItemMaster
                                      ON MovementItemMaster.ID = MovementItem.ParentId
                                     AND MovementItemMaster.MovementId = inMovementId 
                                     AND MovementItemMaster.IsErased = FALSE
                  
              LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                          ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                         AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
           WHERE MovementItem.MovementId = inMovementId
             AND MovementItem.IsErased = FALSE
             AND MovementItem.DescId = zc_MI_Child()
             AND COALESCE(MovementItem.Amount,0) > 0
             AND vbPartionDateID <> 0;
    END IF;

      -- Проводки если затронуты контейнера сроков в подразделении получателя "To" 
    IF EXISTS(SELECT 1 FROM Container WHERE Container.ParentId in (SELECT _tmpMIContainer_insert.ContainerId FROM _tmpMIContainer_insert
                                                                       WHERE _tmpMIContainer_insert.DescId = zc_Container_Count()
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
                                          AND _tmpMIContainer_insert.DescId = zc_Container_Count()
          WHERE Container.DescId = zc_Container_CountPartionDate()
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

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.   Шаблий О.В.
 08.07.19                                                                                    *
 29.07.15                                                                     *
*/