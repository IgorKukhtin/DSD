DROP FUNCTION IF EXISTS lpComplete_Movement_Send (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Send(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbAccountId Integer;
   DECLARE vbUnitFromId Integer;
   DECLARE vbUnitToId Integer;
   DECLARE vbJuridicalFromId Integer;
   DECLARE vbJuridicalToId Integer;
   DECLARE vbSendDate TDateTime;
   DECLARE vbRetailId_from  Integer;
   DECLARE vbRetailId_to    Integer;
   DECLARE vbIsDeferred Boolean;
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
    INTO
        vbUnitFromId
       ,vbJuridicalFromId
       ,vbUnitToId
       ,vbJuridicalToId
       ,vbSendDate
       , vbRetailId_from
       , vbRetailId_to
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

    WHERE Movement.Id = inMovementId;


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

      , tmpItem AS ( -- контейнеры и кол-во(Сумма), которое с них будет списано (с подразделения "From")
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
                        WHERE (DD.Amount - (DD.SUM - DD.ContainerAmount) > 0)
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
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
 29.07.15                                                                     *
*/
