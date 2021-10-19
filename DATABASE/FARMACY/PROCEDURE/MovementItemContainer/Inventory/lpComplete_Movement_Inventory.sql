-- Function: lpComplete_Movement_Inventory (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_Inventory (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Inventory(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbTmp Integer;
   DECLARE vbAccountId Integer;
   DECLARE vbOperSumm_Partner TFloat;
   DECLARE vbOperSumm_Partner_byItem TFloat;
   DECLARE vbUnitId Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbInventoryDate TDateTime;
   DECLARE vbFullInvent Boolean;
BEGIN

    -- пересчитали Итоговые суммы по накладной
    PERFORM lpInsertUpdate_MovementFloat_TotalSummInventory (inMovementId);


     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
  --   DELETE FROM _tmpMIReport_insert;
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;

   vbAccountId := lpInsertFind_Object_Account (inAccountGroupId := zc_Enum_AccountGroup_20000()         -- Запасы
                                     , inAccountDirectionId     := zc_Enum_AccountDirection_20100()     -- Cклад
                                     , inInfoMoneyDestinationId := zc_Enum_InfoMoneyDestination_10200() -- Медикаменты
                                     , inInfoMoneyId            := NULL
                                     , inUserId                 := inUserId);

    SELECT MovementLinkObject.ObjectId, ObjectLink_Unit_Juridical.ChildObjectId INTO vbUnitId, vbJuridicalId
    FROM MovementLinkObject
        LEFT OUTER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                   ON MovementLinkObject.ObjectId = ObjectLink_Unit_Juridical.ObjectId
                                  AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
    WHERE MovementLinkObject.MovementId = inMovementId
      AND MovementLinkObject.DescId = zc_MovementLinkObject_Unit();

    SELECT date_trunc ('day', Movement.OperDate),COALESCE(MovementBoolean_FullInvent.ValueData,False)
    INTO vbInventoryDate, vbFullInvent
    FROM Movement
        LEFT OUTER JOIN MovementBoolean AS MovementBoolean_FullInvent
                                        ON MovementBoolean_FullInvent.MovementId = Movement.Id
                                       AND MovementBoolean_FullInvent.DescId = zc_MovementBoolean_FullInvent()
    WHERE Movement.Id = inMovementId;

   -- Проводки по суммам документа. Деньги в кассу

/*   INSERT INTO _tmpItem(ObjectId, OperSumm, AccountId, JuridicalId_Basis, OperDate)
   SELECT Movement_Income_View.FromId
        , Movement_Income_View.TotalSumm
        , lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_70000()
                                     , inAccountDirectionId     := zc_Enum_AccountDirection_70100()
                                     , inInfoMoneyDestinationId := zc_Enum_InfoMoneyDestination_10200()
                                     , inInfoMoneyId            := NULL
                                     , inUserId                 := inUserId)
        , Movement_Income_View.JuridicalId
        , Movement_Income_View.OperDate
     FROM Movement_Income_View
    WHERE Movement_Income_View.Id =  inMovementId;

    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, ContainerId, AccountId, Amount, OperDate)
         SELECT
                zc_Container_Summ()
              , zc_Movement_Income()
              , inMovementId
              , lpInsertFind_Container(
                          inContainerDescId := zc_Container_Summ(), -- DescId Остатка
                          inParentId        := NULL               , -- Главный Container
                          inObjectId := _tmpItem.AccountId, -- Объект (Счет или Товар или ...)
                          inJuridicalId_basis := _tmpItem.JuridicalId_Basis, -- Главное юридическое лицо
                          inBusinessId := NULL, -- Бизнесы
                          inObjectCostDescId  := NULL, -- DescId для <элемент с/с>
                          inObjectCostId       := NULL, -- <элемент с/с> - необычная аналитика счета
                          inDescId_1          := zc_ContainerLinkObject_Juridical(), -- DescId для 1-ой Аналитики
                          inObjectId_1        := _tmpItem.ObjectId)
              , AccountId
              , - OperSumm
              , OperDate
           FROM _tmpItem;

           SELECT SUM(OperSumm) INTO vbOperSumm_Partner
             FROM _tmpItem;

    -- Сумма платежа
    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, ContainerId, AccountId, Amount, OperDate)
         SELECT
                zc_Container_SummIncomeMovementPayment()
              , zc_Movement_Income()
              , inMovementId
              , lpInsertFind_Container(
                          inContainerDescId := zc_Container_SummIncomeMovementPayment(), -- DescId Остатка
                          inParentId        := NULL               , -- Главный Container
                          inObjectId := lpInsertFind_Object_PartionMovement(inMovementId), -- Объект (Счет или Товар или ...)
                          inJuridicalId_basis := _tmpItem.JuridicalId_Basis, -- Главное юридическое лицо
                          inBusinessId := NULL, -- Бизнесы
                          inObjectCostDescId  := NULL, -- DescId для <элемент с/с>
                          inObjectCostId       := NULL) -- <элемент с/с> - необычная аналитика счета)
              , null
              , OperSumm
              , OperDate
           FROM _tmpItem;

  */
 /*    CREATE TEMP TABLE _tmpItem (MovementDescId Integer, OperDate TDateTime, ObjectId Integer, ObjectDescId Integer, OperSumm TFloat, OperSumm_Currency TFloat, OperSumm_Diff TFloat
                               , MovementItemId Integer, ContainerId Integer, ContainerId_Currency Integer, ContainerId_Diff Integer, ProfitLossId_Diff Integer
                               , AccountGroupId Integer, AccountDirectionId Integer, AccountId Integer
                               , ProfitLossGroupId Integer, ProfitLossDirectionId Integer
                               , InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId_Balance Integer, BusinessId_ProfitLoss Integer, JuridicalId_Basis Integer
                               , UnitId Integer, PositionId Integer, BranchId_Balance Integer, BranchId_ProfitLoss Integer, ServiceDateId Integer, ContractId Integer, PaidKindId Integer
                               , AnalyzerId Integer
                               , CurrencyId Integer
                               , IsActive Boolean, IsMaster Boolean
                                ) ON COMMIT DROP;
*/
/*
   DELETE FROM _tmpItem;
   INSERT INTO _tmpItem(MovementDescId, MovementItemId, ObjectId, OperSumm, AccountId, JuridicalId_Basis, OperDate, UnitId)
   SELECT
          zc_Movement_Income()
        , MovementItem_Income_View.Id
        , MovementItem_Income_View.GoodsId
        , MovementItem_Income_View.Amount
        , lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- Запасы
                                     , inAccountDirectionId     := zc_Enum_AccountDirection_20100() -- Cклад
                                     , inInfoMoneyDestinationId := zc_Enum_InfoMoneyDestination_10200() -- Медикаменты
                                     , inInfoMoneyId            := NULL
                                     , inUserId                 := inUserId)
        , Movement_Income_View.JuridicalId
        , Movement_Income_View.OperDate
        , Movement_Income_View.ToId
     FROM MovementItem_Income_View, Movement_Income_View
    WHERE MovementItem_Income_View.MovementId = Movement_Income_View.Id AND Movement_Income_View.Id =  inMovementId;
 */

    -- А сюда товары

    --Добавить в переучет строки, которые есть на остатке, но нет в переучете
    IF vbFullInvent = TRUE
    THEN
        PERFORM
          lpInsertUpdate_MovementItemBoolean(zc_MIBoolean_isAuto(),
                                             lpInsertUpdate_MovementItem_Inventory(ioId := 0
                                                                                 , inMovementId := inMovementId
                                                                                 , inGoodsId := Saldo.ObjectId
                                                                                 , inAmount := 0
                                                                                 , inPrice := COALESCE (Object_Price.Price, 0)
                                                                                 , inSumm := 0
                                                                                 , inComment := ''
                                                                                 , inUserId := inUserId
                                                                                 ),
                                             True
                                            )
        FROM (SELECT T0.ObjectId     AS ObjectId
                   , SUM (T0.Amount) AS Amount

              FROM (SELECT Container.Id
                         , Container.ObjectId --Товар
                         , Container.Amount - COALESCE(SUM(MovementItemContainer.amount),0.0) as Amount  --Тек. остаток - Движение после даты переучета
                    FROM Container
                         JOIN containerlinkObject AS CLI_Unit ON CLI_Unit.containerid = Container.Id
                                                             AND CLI_Unit.descid = zc_ContainerLinkObject_Unit()
                                                             AND CLI_Unit.ObjectId = vbUnitId
                         LEFT OUTER JOIN MovementItemContainer ON Container.Id = MovementItemContainer.ContainerId
                                                               -- AND date_trunc('day', MovementItemContainer.Operdate) > vbInventoryDate
                                                               AND MovementItemContainer.Operdate >= vbInventoryDate + INTERVAL '1 DAY'
                    WHERE Container.DescID = zc_Container_Count()
                    GROUP BY Container.Id
                           , Container.ObjectId
                    HAVING Container.Amount - COALESCE(SUM(MovementItemContainer.amount),0.0) <> 0
                   ) AS T0
              GROUP By T0.ObjectId
             ) AS Saldo
             LEFT OUTER JOIN MovementItem AS MovementItem_Inventory
                                          ON MovementItem_Inventory.ObjectId   = Saldo.ObjectId
                                         AND MovementItem_Inventory.MovementId = inMovementId
                                         AND MovementItem_Inventory.DescId     = zc_MI_Master()
                                         AND MovementItem_Inventory.isErased   = FALSE
             LEFT OUTER JOIN (SELECT Price_Goods.ChildObjectId               AS GoodsId
                                   , ROUND(Price_Value.ValueData,2)::TFloat  AS Price
                              FROM ObjectLink AS ObjectLink_Price_Unit
                                   LEFT JOIN ObjectLink AS Price_Goods
                                                        ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                       AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                   LEFT JOIN ObjectFloat AS Price_Value
                                                         ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                        AND Price_Value.DescId   = zc_ObjectFloat_Price_Value()
                              WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                             ) AS Object_Price ON Object_Price.GoodsId = Saldo.ObjectId

        WHERE Saldo.Amount <> 0 -- !!!26.02.2018 - добавил еще если есть с МИНУСОМ!!!
          AND MovementItem_Inventory.Id IS NULL
       ;
    END IF;


    WITH -- расч. Остаток на конец vbInventoryDate (т.е. после даты переучета)
         tmpRemains AS (SELECT Container.Id
                             , Container.ObjectId -- Товар
                             , (Container.Amount - COALESCE (SUM (MovementItemContainer.amount), 0.0)) :: TFloat AS Amount
                        FROM Container
                             INNER JOIN containerlinkObject AS CLI_Unit ON CLI_Unit.containerid = Container.Id
                                                                       AND CLI_Unit.descid = zc_ContainerLinkObject_Unit()
                                                                       AND CLI_Unit.ObjectId = vbUnitId
                             LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id
                                                                  AND MovementItemContainer.Operdate >= vbInventoryDate + INTERVAL '1 DAY'
                        WHERE Container.DescId = zc_Container_Count()
                        GROUP BY Container.Id
                               , Container.Amount
                               , Container.ObjectId
                       )
      -- содержимое документа + сохранение остатка
    , tmpDiffRemains AS (SELECT MovementItem.Id       AS Id
                              , MovementItem.ObjectId AS ObjectId
                              , COALESCE (MovementItem.Amount, 0.0) - COALESCE (Saldo.Amount, 0.0) AS Amount
                              , lpInsertUpdate_MovementItemFloat (zc_MIFloat_Remains(), MovementItem.Id, COALESCE (Saldo.Amount, 0.0))
                         FROM MovementItem
                              LEFT OUTER JOIN (SELECT T0.ObjectId, SUM (T0.Amount) as Amount FROM tmpRemains AS T0 GROUP BY ObjectId
                                              ) AS Saldo ON Saldo.ObjectId = MovementItem.ObjectId
                         WHERE MovementItem.MovementId = inMovementId
                           AND MovementItem.DescId = zc_MI_Master()
                           AND MovementItem.IsErased = FALSE
                        )
      -- разница в остатке = переучет(факт) - расчет : (-)недостача, (+)Излишек
    , DiffRemains AS (SELECT MovementItem.Id       AS MovementItemId
                           , MovementItem.ObjectId AS ObjectId
                           , MovementItem.Amount
                      FROM tmpDiffRemains AS MovementItem
                      WHERE MovementItem.Amount <> 0
                     )
     , DD AS (-- для "недостачи" - поиск партий
         SELECT
            DiffRemains.MovementItemId
          , DiffRemains.Amount
          , Container.Amount AS ContainerAmount
          , vbInventoryDate  AS OperDate
          , Container.Id     AS ContainerId
          , SUM (Container.Amount) OVER (PARTITION BY Container.ObjectId ORDER BY Movement.OperDate, Container.Id)
          FROM tmpRemains AS Container
               JOIN DiffRemains ON DiffRemains.ObjectId = Container.ObjectId
               JOIN containerlinkObject AS CLI_MI
                                        ON CLI_MI.containerid = Container.Id
                                       AND CLI_MI.descid     = zc_ContainerLinkObject_PartionMovementItem()
               JOIN containerlinkObject AS CLI_Unit
		                        ON CLI_Unit.containerid = Container.Id
                                       AND CLI_Unit.descid      = zc_ContainerLinkObject_Unit()
                                       AND CLI_Unit.ObjectId    = vbUnitId
               JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
               -- Партия Прихода
               JOIN MovementItem ON MovementItem.Id = Object_PartionMovementItem.ObjectCode
               JOIN Movement ON Movement.Id = MovementItem.MovementId

          WHERE Container.Amount > 0.0
            AND DiffRemains.Amount < 0.0
         )

       , tmpItem AS (--
		     SELECT ContainerId     AS Id
		          , MovementItemId  AS MovementItemId
			  , OperDate
			  , CASE WHEN -Amount - SUM > 0.0 THEN ContainerAmount
                                 ELSE -Amount - SUM + ContainerAmount
                            END AS Amount
                     FROM DD
                     WHERE (Amount < 0 AND -Amount - (SUM - ContainerAmount) >= 0)
                    UNION ALL
                     -- для "излишков" - создание партий
                     SELECT lpInsertFind_Container (inContainerDescId   := zc_Container_Count(), -- DescId Остатка
                                                    inParentId          := NULL               , -- Главный Container
                                                    inObjectId          := DiffRemains.ObjectId, -- Объект (Счет или Товар или ...)
                                                    inJuridicalId_basis := vbJuridicalId, -- Главное юридическое лицо
                                                    inBusinessId        := NULL, -- Бизнесы
                                                    inObjectCostDescId  := NULL, -- DescId для <элемент с/с>
                                                    inObjectCostId      := NULL,
                                                    inDescId_1          := zc_ContainerLinkObject_Unit(), -- DescId для 1-ой Аналитики
                                                    inObjectId_1        := vbUnitId,
                                                    inDescId_2          := zc_ContainerLinkObject_PartionMovementItem(), -- DescId для 2-ой Аналитики
                                                    inObjectId_2        := lpInsertFind_Object_PartionMovementItem (DiffRemains.MovementItemId)
                                                   ) AS Id
                          , DiffRemains.MovementItemId AS MovementItemId
                          , vbInventoryDate            AS OperDate
                          , -1 * DiffRemains.Amount
                     FROM DiffRemains
                     WHERE Amount > 0)


    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate)
         SELECT
                zc_Container_Count()
              , zc_Movement_Inventory()
              , inMovementId
              , tmpItem.MovementItemId
              , tmpItem.Id
              , vbAccountId
              , -Amount
              , OperDate
           FROM tmpItem;

      -- Проводки если затронуты контейнера сроков
    IF EXISTS(SELECT 1 FROM Container WHERE Container.WhereObjectId = vbUnitId
                                        AND Container.DescId = zc_Container_CountPartionDate()
                                        AND Container.ParentId in (SELECT _tmpMIContainer_insert.ContainerId FROM _tmpMIContainer_insert))
    THEN

      WITH DD AS (
         SELECT
            _tmpMIContainer_insert.MovementItemId
          , _tmpMIContainer_insert.Amount
          , Container.Amount AS ContainerAmount
          , vbInventoryDate  AS OperDate
          , Container.Id     AS ContainerId
          , SUM (Container.Amount) OVER (PARTITION BY Container.ParentId ORDER BY Container.Id)
          FROM Container
               JOIN _tmpMIContainer_insert ON _tmpMIContainer_insert.ContainerId = Container.ParentId
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
                 zc_Container_CountPartionDate()
               , zc_Movement_Inventory()
               , inMovementId
               , tmpItem.MovementItemId
               , tmpItem.Id
               , Null
               , -Amount
               , OperDate
            FROM tmpItem;

    END IF;

--     CREATE TEMP TABLE _tmpMIContainer_insert (Id Integer, DescId Integer, MovementDescId Integer, MovementId Integer, MovementItemId Integer, ContainerId Integer, ParentId Integer
  --                                           , AccountId Integer, AnalyzerId Integer, ObjectId_Analyzer Integer, WhereObjectId_Analyzer Integer, ContainerId_Analyzer Integer
    --                                         , Amount TFloat, OperDate TDateTime, IsActive Boolean) ON COMMIT DROP;

    -- ну и наконец-то суммы
 /*   INSERT INTO _tmpMIContainer_insert(AnalyzerId, DescId, MovementDescId, MovementId, MovementItemId, ContainerId, ParentId, AccountId, Amount, OperDate)
         SELECT
                0
              , zc_Container_Summ()
              , zc_Movement_Income()
              , inMovementId
              , _tmpItem.MovementItemId
              , lpInsertFind_Container(
                          inContainerDescId := zc_Container_Summ(), -- DescId Остатка
                          inParentId        := _tmpMIContainer_insert.ContainerId , -- Главный Container
                          inObjectId := _tmpItem.AccountId, -- Объект (Счет или Товар или ...)
                          inJuridicalId_basis := _tmpItem.JuridicalId_Basis, -- Главное юридическое лицо
                          inBusinessId := NULL, -- Бизнесы
                          inObjectCostDescId  := NULL, -- DescId для <элемент с/с>
                          inObjectCostId       := NULL,
                          inDescId_1          := zc_ContainerLinkObject_Goods(), -- DescId для 1-ой Аналитики
                          inObjectId_1        := _tmpItem.ObjectId,
                          inDescId_2          := zc_ContainerLinkObject_Unit(), -- DescId для 1-ой Аналитики
                          inObjectId_2        := _tmpItem.UnitId)
              , nULL
              , _tmpItem.AccountId
              ,  CASE WHEN Movement_Income_View.PriceWithVAT THEN MovementItem_Income_View.AmountSumm
                      ELSE MovementItem_Income_View.AmountSumm * (1 + Movement_Income_View.NDS/100)
                 END::NUMERIC(16, 2)
              , _tmpItem.OperDate
           FROM _tmpItem
                JOIN _tmpMIContainer_insert ON _tmpMIContainer_insert.MovementItemId = _tmpItem.MovementItemId
                LEFT JOIN MovementItem_Income_View ON MovementItem_Income_View.Id = _tmpItem.MovementItemId
                LEFT JOIN Movement_Income_View ON Movement_Income_View.Id = MovementItem_Income_View.MovementId;


     SELECT SUM(Amount) INTO vbOperSumm_Partner_byItem FROM _tmpMIContainer_insert WHERE AnalyzerId = 0;

     IF (vbOperSumm_Partner <> vbOperSumm_Partner_byItem) THEN
        UPDATE _tmpMIContainer_insert SET Amount = Amount - (vbOperSumm_Partner_byItem - vbOperSumm_Partner)
         WHERE MovementItemId IN (SELECT MAX (MovementItemId) FROM _tmpMIContainer_insert WHERE AnalyzerId = 0
                      AND Amount IN (SELECT MAX (Amount) FROM _tmpMIContainer_insert WHERE AnalyzerId = 0)
                                 );
      END IF;
   */

     -- 5.1. ФИНИШ - Обязательно сохраняем Проводки
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();

     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Inventory()
                                , inUserId     := inUserId
                                 );

     -- !!!5.3. формируется свойство <MovementItemId - для созданных партий этой инвентаризацией - ближайший документ прихода, из которого для ВСЕХ отчетов будем считать с/с> !!!
     vbTmp:= (WITH tmpMIContainer AS
                     (SELECT MIContainer.MovementItemId
                           , MIContainer.ContainerId
                           , Container.ObjectId AS GoodsId
                      FROM MovementItemContainer AS MIContainer
                           LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                         ON ContainerLinkObject_MovementItem.Containerid = MIContainer.ContainerId
                                                        AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                           INNER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                                                                          AND Object_PartionMovementItem.ObjectCode = MIContainer.MovementItemId
                           INNER JOIN Container ON Container.Id = MIContainer.ContainerId
                      WHERE MIContainer.MovementId = inMovementId
                        AND MIContainer.DescId = zc_MIContainer_Count()
                     )
                 , tmpContainer AS (SELECT tmpMIContainer.MovementItemId
                                            , Container.ObjectId   AS GoodsId
                                            , Container.ID
                                       FROM tmpMIContainer
                                           
                                            INNER JOIN Container ON Container.ObjectId = tmpMIContainer.GoodsId
                                                                AND Container.DescId = zc_Container_Count()
                                                                AND Container.WhereObjectId = vbUnitId
                                                                AND Container.ID NOT IN (SELECT DISTINCT tmpMIContainer.ContainerID FROM tmpMIContainer)

                                        )
                 , tmpContainerAll AS (SELECT Container.MovementItemId
                                            , Container.GoodsId
                                            , vbJuridicalId                                                     AS JuridicalId
                                            , COALESCE (MI_Income_find.Id, MI_Income.Id)                        AS MovementItemId_find
                                            , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId)        AS IncomeId
                                            , Movement.OperDate
                                       FROM tmpContainer AS Container
                                            LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                                          ON ContainerLinkObject_MovementItem.Containerid = Container.Id
                                                                         AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                            LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                                            -- элемент прихода
                                            LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                            -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                            LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                                        ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                                       AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                            -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                            LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)

                                            LEFT JOIN Movement ON Movement.Id = COALESCE (MI_Income_find.MovementId, MI_Income.MovementId)
                                        )
                 , tmpContainerNotFind AS (SELECT tmpMIContainer.*
                                           FROM tmpMIContainer
                                               
                                                LEFT JOIN tmpContainerAll ON tmpContainerAll.MovementItemId = tmpMIContainer.MovementItemId
                                                
                                           WHERE COALESCE(tmpContainerAll.MovementItemId, 0) = 0
                                            )
                 , tmpIncomeNotFind AS (SELECT MI.Id AS MovementItemId_find
                                             , tmpMIContainer.MovementItemId
                                             , tmpMIContainer.GoodsId
                                             , ObjectLink_Unit_Juridical.ChildObjectId      AS JuridicalId
                                             , Movement.Id                                  AS IncomeId
                                             , Movement.OperDate
                                        FROM tmpContainerNotFind AS tmpMIContainer
                                             INNER JOIN Movement ON Movement.DescId = zc_Movement_Income() AND Movement.StatusId = zc_Enum_Status_Complete()
                                             INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                           ON MovementLinkObject_To.MovementId = Movement.Id
                                                                          AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                             INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                                   ON ObjectLink_Unit_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                                                  AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                                                  -- AND ObjectLink_Unit_Juridical.ChildObjectId = vbJuridicalId - !!!убрал!!!
                                             INNER JOIN MovementItem AS MI
                                                                     ON MI.MovementId = Movement.Id
                                                                    AND MI.DescId = zc_MI_Master()
                                                                    AND MI.isErased = FALSE
                                                                    AND MI.ObjectId = tmpMIContainer.GoodsId
                                                                    AND MI.Amount <> 0
                                       )
                 , tmpIncomeAll AS (SELECT tmpContainerAll.MovementItemId_find
                                         , tmpContainerAll.MovementItemId
                                         , tmpContainerAll.GoodsId
                                         , tmpContainerAll.JuridicalId
                                         , tmpContainerAll.IncomeId
                                         , tmpContainerAll.OperDate
                                    FROM tmpContainerAll
                                    UNION ALL
                                    SELECT tmpIncomeNotFind.MovementItemId_find
                                         , tmpIncomeNotFind.MovementItemId
                                         , tmpIncomeNotFind.GoodsId
                                         , tmpIncomeNotFind.JuridicalId
                                         , tmpIncomeNotFind.IncomeId
                                         , tmpIncomeNotFind.OperDate
                                    FROM tmpIncomeNotFind
                                   )

                 , tmpIncome AS
                     (SELECT *
                      FROM
                        (SELECT tmpIncomeAll.MovementItemId_find
                              , tmpIncomeAll.MovementItemId
                              , tmpIncomeAll.GoodsId
                              , ROW_NUMBER() OVER (PARTITION BY tmpIncomeAll.MovementItemId, tmpIncomeAll.GoodsId
                                                   ORDER BY CASE WHEN tmpIncomeAll.JuridicalId = vbJuridicalId THEN 0 ELSE 1 END
                                                          , CASE WHEN tmpIncomeAll.OperDate >= vbInventoryDate 
                                                                 THEN tmpIncomeAll.OperDate - vbInventoryDate ELSE vbInventoryDate - tmpIncomeAll.OperDate END
                                                          , tmpIncomeAll.OperDate
                                                  ) AS myRow
                         FROM tmpIncomeAll

                        ) AS tmp
                      WHERE tmp.myRow = 1
                     )
              SELECT MAX (CASE WHEN TRUE = lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementItemId(), tmpIncome.MovementItemId, tmpIncome.MovementItemId_find) THEN 1 ELSE 0 END)
              FROM tmpIncome
             );

    IF inUserId = zfCalc_UserAdmin()::Integer
    THEN
        RAISE EXCEPTION 'Тест прошел успешно для <%>', inUserId;
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.  Воробкало А.А.  Шаблий О.В.
 03.06.20                                                                                  * Поиск прихода только по сети
 12.06.17         * ушли от Object_Price_View
 14.03.16                                        * !!!5.3. формируется свойство <MovementItemId - для созданных партий этой инвентаризацией - ближайший документ прихода, из которого для ВСЕХ отчетов будем считать с/с> !!!
 03.08.15                                                                  *Добавить в переучет строки, которые есть на остатке, но нет в переучете
 11.02.14                        *
 05.02.14                        *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
--    IN inMovementId        Integer  , -- ключ Документа
--    IN inUserId            Integer    -- Пользователь
-- SELECT * FROM lpComplete_Movement_Inventory (inMovementId:= 12671, inUserId:= zfCalc_UserAdmin()::Integer)
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM MovementItemContainer WHERE MovementId = 12671