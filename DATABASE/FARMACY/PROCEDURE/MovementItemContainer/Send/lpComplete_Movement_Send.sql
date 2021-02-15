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
   DECLARE vbAmount          TFloat;
   DECLARE vbSaldo           TFloat;
   DECLARE vbSUN             Boolean;
   DECLARE vbAddress         TVarChar;
   DECLARE vbDivisionParties Boolean;
   DECLARE vbisBanFiscalSale Boolean;

   DECLARE vbDate_6 TDateTime;
   DECLARE vbDate_3 TDateTime;
   DECLARE vbDate_1 TDateTime;
   DECLARE vbDate_0 TDateTime;
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
         , COALESCE (MovementBoolean_SUN.ValueData, FALSE)
         , ObjectString_Unit_Address.ValueData
         , COALESCE (MovementBoolean_BanFiscalSale.ValueData, FALSE)
           INTO
                vbUnitFromId
              , vbJuridicalFromId
              , vbUnitToId
              , vbJuridicalToId
              , vbSendDate
              , vbRetailId_from
              , vbRetailId_to
              , vbPartionDateId
              , vbSUN
              , vbAddress
              , vbisBanFiscalSale
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
        LEFT JOIN ObjectString AS ObjectString_Unit_Address
                               ON ObjectString_Unit_Address.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectString_Unit_Address.DescId = zc_ObjectString_Unit_Address()


        LEFT JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                     ON MovementLinkObject_PartionDateKind.MovementId = Movement.Id
                                    AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()

        LEFT JOIN MovementBoolean AS MovementBoolean_SUN
                                  ON MovementBoolean_SUN.MovementId = Movement.Id
                                 AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                 
        LEFT JOIN MovementBoolean AS MovementBoolean_BanFiscalSale
                                  ON MovementBoolean_BanFiscalSale.MovementId = Movement.Id
                                 AND MovementBoolean_BanFiscalSale.DescId = zc_MovementBoolean_BanFiscalSale()

    WHERE Movement.Id = inMovementId;

    vbDivisionParties := (vbRetailId_to = 4) AND (vbJuridicalFromId <> vbJuridicalToId) AND COALESCE(vbAddress, '') <> '';

    -- если это перемещение просрочки
    IF vbPartionDateId = zc_Enum_PartionDateKind_0()
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

    -- если ecnm Child то не более чем в мастере
    ELSEIF EXISTS (SELECT 1
                   FROM MovementItem AS MI_Child
                   WHERE MI_Child.MovementId = inMovementId
                     AND MI_Child.DescId     = zc_MI_Child()
                     AND MI_Child.IsErased   = FALSE
                     AND MI_Child.Amount     <> 0
                  )
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
                      AND COALESCE (SUM (MI_Child.Amount), 0) <> 0
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
           HAVING MI_Master.Amount <> COALESCE (SUM (MI_Child.Amount), 0)
              AND COALESCE (SUM (MI_Child.Amount), 0) <> 0 LIMIT 1;

           RAISE EXCEPTION 'Ошибка.Как минимум у одного товара <%> количество <%> меньше распределено <%>. Испревте количество или распределение по срокам.', vbGoodsName, vbAmountM, vbAmountC;
        END IF;
    END IF;

    -- Проверка на то что бы не списали больше чем есть на остатке по распределенным позициям
    IF EXISTS (SELECT 1
               FROM MovementItem AS MI_Child
               WHERE MI_Child.MovementId = inMovementId
                 AND MI_Child.DescId     = zc_MI_Child()
                 AND MI_Child.IsErased   = FALSE
                 AND MI_Child.Amount     <> 0
              )
    THEN
      SELECT Object_Goods.ValueData, tmp.Amount, tmp.AmountRemains
             INTO vbGoodsName, vbAmount, vbSaldo
      FROM (WITH tmpMI AS (SELECT MI_Master.ObjectId     AS GoodsId
                                , MI_Child.Amount        AS Amount
                                , Container.Id           AS ContainerId
                                , Container.Amount       AS ContainerAmount
                           FROM MovementItem AS MI_Master
                                LEFT JOIN MovementItem AS MI_Child
                                               ON MI_Child.MovementId = inMovementId
                                              AND MI_Child.DescId     = zc_MI_Child()
                                              AND MI_Child.ParentId   = MI_Master.Id
                                              AND MI_Child.IsErased   = FALSE
                                              AND MI_Child.Amount     > 0
                                -- это zc_Container_CountPartionDate
                                LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                            ON MIFloat_ContainerId.MovementItemId = MI_Child.Id
                                                           AND MIFloat_ContainerId.DescId         = zc_MIFloat_ContainerId()
                                LEFT JOIN Container ON Container.Id = MIFloat_ContainerId.ValueData :: Integer
                                                       
                           WHERE MI_Master.MovementId = inMovementId
                             AND MI_Master.DescId     = zc_MI_Master()
                             AND MI_Master.IsErased   = FALSE
                          )

            SELECT tmpMI.GoodsId, SUM(tmpMI.Amount) AS Amount, tmpMI.ContainerAmount AS AmountRemains
            FROM tmpMI
            GROUP BY tmpMI.GoodsId, tmpMI.ContainerId, tmpMI.ContainerAmount
            HAVING SUM(tmpMI.Amount) > COALESCE (tmpMI.ContainerAmount, 0)
           ) AS tmp
           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmp.GoodsId
      LIMIT 1
     ;

      IF (COALESCE(vbGoodsName,'') <> '')
      THEN
          RAISE EXCEPTION 'Ошибка. По одному <%> или более товарам кол-во распределено <%> больше, чем есть на остатке <%> по партии.', vbGoodsName, vbAmount, vbSaldo;
      END IF;
    END IF;

    -- Переоценим товар без остатки
    IF vbIsDeferred = FALSE AND vbUnitToId <> 11299914 
    THEN

       PERFORM lpInsertUpdate_Object_Price(inGoodsId := T1.GoodsId,
                                           inUnitId  := T1.UnitId,
                                           inPrice   := T1.PriceNew,
                                           inDate    := CURRENT_DATE::TDateTime,
                                           inUserId  := inUserId)
       FROM (WITH
                  -- строки документа перемещения
                  tmpMI_SendAll AS (SELECT MI_Master.ObjectId AS ObjectId
                                    FROM MovementItem AS MI_Master
                                    WHERE MI_Master.MovementId = inMovementId
                                      AND MI_Master.IsErased   = FALSE
                                      AND MI_Master.DescId     = zc_MI_Master()
                                      AND MI_Master.Amount     > 0
                                    GROUP BY MI_Master.ObjectId
                                   )
                  -- находим товары для сети куда идет перемещение, если они разные
                , GoodsRetial_to AS (SELECT tmp.ObjectId
                                          , ObjectLink_Child_to.ChildObjectId AS ObjectId_to
                                     FROM (SELECT DISTINCT tmpMI_SendAll.ObjectId FROM tmpMI_SendAll WHERE vbRetailId_from <> vbRetailId_to) AS tmp
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
                  -- строки документа перемещения
                ,  tmpMI_Send AS (SELECT tmpMI_SendAll.ObjectId AS ObjectId
                                       , COALESCE(GoodsRetial_to.ObjectId_to, tmpMI_SendAll.ObjectId) AS ObjectId_to
                                  FROM tmpMI_SendAll
                                       LEFT JOIN GoodsRetial_to ON GoodsRetial_to.ObjectId = tmpMI_SendAll.ObjectId
                                 )
                , Container_to AS (SELECT tmpMI_Send.ObjectId_to
                                        , SUM(Container.Amount) AS Amount
                                   FROM tmpMI_Send
                                        INNER JOIN Container ON Container.ObjectId = tmpMI_Send.ObjectId_to
                                                            AND Container.DescId = zc_Container_Count()
                                                            AND Container.Amount > 0
                                                            AND Container.WhereObjectId = vbUnitFromId
                                   GROUP BY tmpMI_Send.ObjectId_to
                                   HAVING SUM(Container.Amount) > 0)
                  -- Товар без остатка на получателе
                ,  tmpGoods AS (SELECT tmpMI_Send.ObjectId
                                     , tmpMI_Send.ObjectId_to
                                FROM tmpMI_Send
                                     LEFT JOIN Container_to ON Container_to.ObjectId_to = tmpMI_Send.ObjectId_to
                                WHERE COALESCE (Container_to.Amount, 0) = 0
                                 )
                , tmpObject_Price AS (SELECT ROUND (Price_Value.ValueData, 2) :: TFloat AS Price
                                           , ObjectLink_Price_Unit.ChildObjectId        AS UnitId
                                           , Price_Goods.ChildObjectId                  AS GoodsId
                                      FROM ObjectLink AS ObjectLink_Price_Unit
                                         LEFT JOIN ObjectLink AS Price_Goods
                                                              ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                             AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                         INNER JOIN tmpGoods ON tmpGoods.ObjectId = Price_Goods.ChildObjectId OR tmpGoods.ObjectId_to = Price_Goods.ChildObjectId
                                         LEFT JOIN ObjectFloat AS Price_Value
                                                               ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                              AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                                      WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                                        AND ObjectLink_Price_Unit.ChildObjectId in (vbUnitFromId, vbUnitToId)
                                      )


        SELECT Price_To.UnitId
             , tmpGoods.ObjectId_to AS GoodsId
             , Price_From.Price     AS PriceNew
        FROM tmpGoods

             LEFT JOIN tmpObject_Price AS Price_From
                                       ON Price_From.GoodsId = tmpGoods.ObjectId
                                      AND Price_From.UnitId = vbUnitFromId

             LEFT JOIN tmpObject_Price AS Price_To
                                       ON Price_To.GoodsId = tmpGoods.ObjectId_to
                                      AND Price_To.UnitId = vbUnitToId

        WHERE COALESCE (Price_From.Price, 0) <> 0
          AND COALESCE (Price_From.Price, 0) <> COALESCE (Price_To.Price, 0)
        ) AS T1;
    END IF;

      -- Проводим распределенный по партиям товар
    IF EXISTS (SELECT 1
               FROM MovementItem AS MI_Child
               WHERE MI_Child.MovementId = inMovementId
                 AND MI_Child.DescId     = zc_MI_Child()
                 AND MI_Child.IsErased   = FALSE
                 AND MI_Child.Amount     <> 0
              )
    THEN
        -- А сюда товары
        WITH
            -- итого для сроковых перемещений по zc_Container_Count
          DDChild AS (SELECT
                            Container.ParentId             AS ContainerId
                          , Container.Id                   AS ContainerPartionId
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
                         GROUP BY Container.Id, Container.ParentId, Container.ObjectId, MovementItem.Id
                       )
           -- находим товары для сети куда идет перемещение, если они разные
        , GoodsRetial_to AS (SELECT tmp.ObjectId
                                , ObjectLink_Child_to.ChildObjectId AS ObjectId_to
                           FROM (SELECT DISTINCT DDChild.ObjectId FROM DDChild WHERE vbRetailId_from <> vbRetailId_to) AS tmp
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
            -- контейнеры и zc_Container_Count, которые будут списаны (с подразделения "From")
          , tmpItem AS (
                        -- для сроковых перемещений - сразу ContainerId
                        SELECT
                            DDChild.ContainerId                       AS ContainerId_count
                          , DDChild.ContainerPartionId                AS ContainerPartionId_count
                          , NULL                    :: Integer        AS ContainerId_summ
                          , COALESCE (MI_Income_find.Id,MI_Income.Id) AS PartionMovementItemId
                          , DDChild.MovementItemID                    AS MovementItemId
                          , DDChild.ObjectId
                          , CASE WHEN vbRetailId_from <> vbRetailId_to THEN GoodsRetial_to.ObjectId_to ELSE DDChild.ObjectId END AS ObjectId_to
                          , DDChild.Amount                            AS Amount
                          , 0 AS Summ
                          , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId) AS MovementId_Income
                        FROM DDChild
                             LEFT JOIN GoodsRetial_to ON GoodsRetial_to.ObjectId = DDChild.ObjectId

                             LEFT JOIN ContainerlinkObject AS CLO_MovementItem
                                                           ON CLO_MovementItem.Containerid = DDChild.ContainerId
                                                          AND CLO_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                             LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLO_MovementItem.ObjectId
                             -- элемент прихода
                             LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                             -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                             LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                         ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                        AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                             -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                             LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)
                       )
          , tmpContainerTo AS (SELECT Container.ObjectId                                          AS ObjectId
                                    , MovementLinkObject_From.ObjectId                            AS FromId
                               FROM (SELECT DISTINCT tmpItem.ObjectId_to FROM tmpItem) AS tmpMI
                                    INNER JOIN Container ON Container.DescId = zc_Container_Count()
                                                        AND Container.WhereObjectId in (SELECT OL_Unit_Juridical.ObjectId FROM ObjectLink AS OL_Unit_Juridical
                                                                                        WHERE OL_Unit_Juridical.ChildObjectId = vbJuridicalToId
                                                                                          AND OL_Unit_Juridical.DescId   = zc_ObjectLink_Unit_Juridical())
                                                        AND Container.ObjectId = tmpMI.ObjectId_to

                                    LEFT JOIN MovementItemContainer AS MIC
                                                                    ON MIC.Containerid = Container.Id
                                                                   AND MIC.MovementDescId = zc_Movement_Income()
                                                                   AND MIC.OperDate >= CURRENT_DATE - INTERVAL '30 MONTH'

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                 ON MovementLinkObject_From.MovementId = MIC.MovementId
                                                                AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                GROUP BY Container.ObjectId
                                       , MovementLinkObject_From.ObjectId
                                )
            -- проводки кол-во
          , tmpAll AS  (-- расход с подразделения "From"
                        SELECT
                             ContainerId_count
                           , ContainerPartionId_count
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
                                                  , inDescId_3          := CASE WHEN vbDivisionParties = TRUE AND COALESCE (tmpContainerTo.FromId, 0) = 0 THEN zc_ContainerLinkObject_DivisionParties() ELSE NULL END -- DescId для 3-ой Аналитики
                                                  , inObjectId_3        := CASE WHEN vbDivisionParties = TRUE AND COALESCE (tmpContainerTo.FromId, 0) = 0 THEN zc_Enum_DivisionParties_UKTVED() ELSE NULL END
                                                   ) AS ContainerId_count
                           , Null
                           , tmpItem.MovementItemId  AS MovementItemId
                           , tmpItem.ObjectId_to     AS ObjectId
                           , vbSendDate              AS OperDate
                           , 1 * tmpItem.Amount      AS Amount
                           , TRUE                    AS IsActive
                        FROM tmpItem

                             LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                          ON MovementLinkObject_From.MovementId = tmpItem.MovementId_Income
                                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                             LEFT JOIN tmpContainerTo ON tmpContainerTo.ObjectId = tmpItem.ObjectId_to
                                                     AND tmpContainerTo.FromId = MovementLinkObject_From.ObjectId

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
           -- проводки по партиям по количеству
           SELECT
               zc_MIContainer_CountPartionDate()
             , zc_Movement_Send()
             , inMovementId
             , tmpAll.MovementItemId
             , tmpAll.ContainerPartionId_count
             , Null
             , tmpAll.Amount
             , tmpAll.OperDate
             , Null
           FROM tmpAll
           WHERE COALESCE (tmpAll.ContainerPartionId_count, 0) <> 0

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

    END IF;

    IF vbSUN = FALSE
    THEN
      -- А сюда товары для обычных перемещений
      WITH
          -- строки документа перемещения
          tmpMI_Send AS (SELECT MI_Master.Id       AS MovementItemId
                              , MI_Master.ObjectId AS ObjectId
                              , MI_Master.Amount - COALESCE(SUM(MI_Child.Amount), 0)  AS Amount
                         FROM MovementItem AS MI_Master
                              LEFT JOIN MovementItem AS MI_Child
                                                     ON MI_Child.MovementId = inMovementId
                                                    AND MI_Child.DescId     = zc_MI_Child()
                                                    AND MI_Child.ParentId   = MI_Master.Id
                                                    AND MI_Child.IsErased   = FALSE
                                                    AND MI_Child.Amount     > 0

                         WHERE MI_Master.MovementId = inMovementId
                           AND MI_Master.IsErased   = FALSE
                           AND MI_Master.DescId     = zc_MI_Master()
                           AND MI_Master.Amount     > 0
                         GROUP BY MI_Master.Id , MI_Master.ObjectId
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
        , ContainerUsed AS (SELECT _tmpMIContainer_insert.ContainerId
                                 , SUM(_tmpMIContainer_insert.Amount) AS Amount
                            FROM _tmpMIContainer_insert
                            WHERE DescId = zc_MIContainer_Count()
                            GROUP BY _tmpMIContainer_insert.ContainerId)
          -- строки документа перемещения размазанные по текущему остатку(Контейнерам) на подразделении "From"
        , DD AS (SELECT
                     tmpMI_Send.MovementItemId
                     -- сколько надо получить
                   , tmpMI_Send.Amount
                     -- остаток
                   , Container.Amount + COALESCE (ContainerUsed.Amount, 0) AS AmountRemains
                   , Container.ObjectId
                   , Movement.OperDate   -- дата прихода от пост.
                   , COALESCE (MI_Income_find.Id,MI_Income.Id) AS PartionMovementItemId
                   , Container.Id    AS ContainerId
                   , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId) AS MovementId_Income
                     -- итого "накопительный" остаток
                   , SUM (Container.Amount + COALESCE (ContainerUsed.Amount, 0)) OVER (PARTITION BY Container.ObjectId ORDER BY Movement.OperDate, Container.Id, tmpMI_Send.MovementItemId) AS AmountRemains_sum
                     -- для последнего элемента - не смотрим на остаток
                   , ROW_NUMBER() OVER (PARTITION BY tmpMI_Send.MovementItemId ORDER BY Movement.OperDate DESC, Container.Id DESC, tmpMI_Send.MovementItemId DESC) AS DOrd
                 FROM Container
                      JOIN tmpMI_Send ON tmpMI_Send.ObjectId = Container.ObjectId
                      LEFT JOIN ContainerUsed ON ContainerUsed.ContainerId = Container.Id

                      LEFT JOIN ContainerlinkObject AS CLO_MovementItem
                                                    ON CLO_MovementItem.Containerid = Container.Id
                                                   AND CLO_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                      LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLO_MovementItem.ObjectId
                      -- элемент прихода
                      LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                      -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                      LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                  ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                 AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                      -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                      LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)
                      -- Приход
                      LEFT JOIN Movement ON Movement.ID = COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)
                      LEFT JOIN ContainerlinkObject AS ContainerLinkObject_DivisionParties
                                                    ON ContainerLinkObject_DivisionParties.Containerid = Container.Id
                                                   AND ContainerLinkObject_DivisionParties.DescId = zc_ContainerLinkObject_DivisionParties()
                                                      
                      LEFT JOIN ObjectBoolean AS ObjectBoolean_BanFiscalSale
                                              ON ObjectBoolean_BanFiscalSale.ObjectId = ContainerLinkObject_DivisionParties.ObjectId
                                             AND ObjectBoolean_BanFiscalSale.DescId = zc_ObjectBoolean_DivisionParties_BanFiscalSale()
                 WHERE Container.WhereObjectId = vbUnitFromId
                   AND Container.DescId        = zc_Container_Count()
                   AND Container.Amount + COALESCE (ContainerUsed.Amount, 0) > 0
                   AND (vbisBanFiscalSale = False OR vbisBanFiscalSale = True AND COALESCE (ObjectBoolean_BanFiscalSale.ValueData, False) = True)
                )
          -- контейнеры и zc_Container_Count, которые будут списаны (с подразделения "From")
        , tmpItem AS (
                      -- для простых перемещений - распределение
                      SELECT
                          DD.ContainerId            AS ContainerId_count
                        , NULL           :: Integer AS ContainerId_summ
                        , DD.PartionMovementItemId  AS PartionMovementItemId
                        , DD.MovementId_Income      AS MovementId_Income
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
                      WHERE  (DD.Amount - (DD.AmountRemains_sum - DD.AmountRemains) > 0)
                     )
          , tmpContainerTo AS (SELECT Container.ObjectId                                          AS ObjectId
                                    , MovementLinkObject_From.ObjectId                            AS FromId
                               FROM (SELECT DISTINCT tmpItem.ObjectId_to FROM tmpItem) AS tmpMI
                                    INNER JOIN Container ON Container.DescId = zc_Container_Count()
                                                        AND Container.WhereObjectId in (SELECT OL_Unit_Juridical.ObjectId FROM ObjectLink AS OL_Unit_Juridical
                                                                                        WHERE OL_Unit_Juridical.ChildObjectId = vbJuridicalToId
                                                                                          AND OL_Unit_Juridical.DescId   = zc_ObjectLink_Unit_Juridical())
                                                        AND Container.ObjectId = tmpMI.ObjectId_to

                                    LEFT JOIN MovementItemContainer AS MIC
                                                                    ON MIC.Containerid = Container.Id
                                                                   AND MIC.MovementDescId = zc_Movement_Income()
                                                                   AND MIC.OperDate >= CURRENT_DATE - INTERVAL '30 MONTH'

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                 ON MovementLinkObject_From.MovementId = MIC.MovementId
                                                                AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                GROUP BY Container.ObjectId
                                       , MovementLinkObject_From.ObjectId
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
                                                , inDescId_3          := CASE WHEN vbDivisionParties = TRUE AND COALESCE (tmpContainerTo.FromId, 0) = 0 THEN zc_ContainerLinkObject_DivisionParties() ELSE NULL END -- DescId для 3-ой Аналитики
                                                , inObjectId_3        := CASE WHEN vbDivisionParties = TRUE AND COALESCE (tmpContainerTo.FromId, 0) = 0 THEN zc_Enum_DivisionParties_UKTVED() ELSE NULL END
                                                 ) AS ContainerId_count
                         , tmpItem.MovementItemId  AS MovementItemId
                         , tmpItem.ObjectId_to     AS ObjectId
                         , vbSendDate              AS OperDate
                         , 1 * tmpItem.Amount      AS Amount
                         , TRUE                    AS IsActive
                      FROM tmpItem
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                        ON MovementLinkObject_From.MovementId = tmpItem.MovementId_Income
                                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                           LEFT JOIN tmpContainerTo ON tmpContainerTo.ObjectId = tmpItem.ObjectId_to
                                                   AND tmpContainerTo.FromId = MovementLinkObject_From.ObjectId

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
    ELSE
      -- значения для разделения по срокам
      SELECT Date_6, Date_3, Date_1, Date_0
      INTO vbDate_6, vbDate_3, vbDate_1, vbDate_0
      FROM lpSelect_PartionDateKind_SetDate ();

      -- А сюда товары для перемещений СУН
      WITH
          -- строки документа перемещения
          tmpMI_Send AS (SELECT MI_Master.Id       AS MovementItemId
                              , MI_Master.ObjectId AS ObjectId
                              , MI_Master.Amount - COALESCE(SUM(MI_Child.Amount), 0)  AS Amount
                         FROM MovementItem AS MI_Master
                              LEFT JOIN MovementItem AS MI_Child
                                                     ON MI_Child.MovementId = inMovementId
                                                    AND MI_Child.DescId     = zc_MI_Child()
                                                    AND MI_Child.ParentId   = MI_Master.Id
                                                    AND MI_Child.IsErased   = FALSE
                                                    AND MI_Child.Amount     > 0

                         WHERE MI_Master.MovementId = inMovementId
                           AND MI_Master.IsErased   = FALSE
                           AND MI_Master.DescId     = zc_MI_Master()
                           AND MI_Master.Amount     > 0
                         GROUP BY MI_Master.Id , MI_Master.ObjectId
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
        , ContainerUsed AS (SELECT _tmpMIContainer_insert.ContainerId
                                 , SUM(_tmpMIContainer_insert.Amount) AS Amount
                            FROM _tmpMIContainer_insert
                            WHERE DescId = zc_MIContainer_Count()
                            GROUP BY _tmpMIContainer_insert.ContainerId)
        , ContainerAll AS (SELECT
                               Container.ID
                             , Container.ObjectId
                             , Container.Amount + COALESCE (ContainerUsed.Amount, 0)     AS Amount
                             , COALESCE (MI_Income_find.Id,MI_Income.Id)                 AS PartionMovementItemId
                             , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId) AS MovementId_Income
                           FROM Container
                                JOIN tmpMI_Send ON tmpMI_Send.ObjectId = Container.ObjectId
                                LEFT JOIN ContainerUsed ON ContainerUsed.ContainerId = Container.Id

                                LEFT JOIN ContainerlinkObject AS CLO_MovementItem
                                                              ON CLO_MovementItem.Containerid = Container.Id
                                                             AND CLO_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLO_MovementItem.ObjectId
                                -- элемент прихода
                                LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                            ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                           AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)

                                LEFT JOIN ContainerlinkObject AS ContainerLinkObject_DivisionParties
                                                              ON ContainerLinkObject_DivisionParties.Containerid = Container.Id
                                                             AND ContainerLinkObject_DivisionParties.DescId = zc_ContainerLinkObject_DivisionParties()
                                                        
                                LEFT JOIN ObjectBoolean AS ObjectBoolean_BanFiscalSale
                                                        ON ObjectBoolean_BanFiscalSale.ObjectId = ContainerLinkObject_DivisionParties.ObjectId
                                                       AND ObjectBoolean_BanFiscalSale.DescId = zc_ObjectBoolean_DivisionParties_BanFiscalSale()

                           WHERE Container.WhereObjectId = vbUnitFromId
                             AND Container.DescId        = zc_Container_Count()
                             AND Container.Amount + COALESCE (ContainerUsed.Amount, 0) > 0
                             AND (vbisBanFiscalSale = False OR vbisBanFiscalSale = True AND COALESCE (ObjectBoolean_BanFiscalSale.ValueData, False) = True)
                           )
        , ContainerPD AS (SELECT ContainerAll.Id
                               , Min(ObjectDate_ExpirationDate.ValueData)               AS ExpirationDate
                               , CASE WHEN Min(ObjectDate_ExpirationDate.ValueData) <= vbDate_0  THEN 6      -- просрочено
                                      WHEN Min(ObjectDate_ExpirationDate.ValueData) <= vbDate_1  THEN 5      -- Меньше 1 месяца
                                      WHEN Min(ObjectDate_ExpirationDate.ValueData) <= vbDate_3  THEN 4      -- Меньше 3 месяца
                                      WHEN Min(ObjectDate_ExpirationDate.ValueData) <= vbDate_6  THEN 1      -- Меньше 6 месяца
                                      ELSE  2 END  AS PDOrd                                                  -- Востановлен с просрочки
                          FROM ContainerAll

                               INNER JOIN Container ON Container.ParentId = ContainerAll.Id
                                                   AND Container.DescID = zc_Container_CountPartionDate()
                                                   AND Container.Amount > 0

                               INNER JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                             AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                               INNER JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                     ON ObjectDate_ExpirationDate.ObjectId =  ContainerLinkObject.ObjectId
                                                    AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                          GROUP BY ContainerAll.Id
                          )
        , tmpContainer AS (SELECT
                               Container.ID
                             , Container.ObjectId
                             , Container.Amount
                             , COALESCE (ContainerPD.PDOrd, 3) AS PDOrd
                             , Container.PartionMovementItemId
                             , Container.MovementId_Income
                             , MovementLinkObject_From.ObjectId AS JuridicalID
                           FROM ContainerAll AS Container
                                LEFT JOIN ContainerPD ON ContainerPD.Id = Container.Id

                                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                             ON MovementLinkObject_From.MovementId = Container.MovementId_Income
                                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
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
                   , Container.PartionMovementItemId
                   , Container.Id    AS ContainerId
                   , Container.JuridicalID   AS JuridicalID
                     -- итого "накопительный" остаток
                   , SUM (Container.Amount) OVER (PARTITION BY Container.ObjectId ORDER BY Container.PDOrd, Movement.OperDate, Container.Id, tmpMI_Send.MovementItemId) AS AmountRemains_sum
                     -- для последнего элемента - не смотрим на остаток
                   , ROW_NUMBER() OVER (PARTITION BY tmpMI_Send.MovementItemId ORDER BY Container.PDOrd DESC, Movement.OperDate DESC, Container.Id DESC, tmpMI_Send.MovementItemId DESC) AS DOrd
                 FROM tmpContainer AS Container
                      JOIN tmpMI_Send ON tmpMI_Send.ObjectId = Container.ObjectId
                      JOIN Movement ON Movement.Id = Container.MovementId_Income
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
                        , DD.JuridicalID            AS JuridicalID
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
                      WHERE  (DD.Amount - (DD.AmountRemains_sum - DD.AmountRemains) > 0)
                     )
        , tmpContainerTo AS (SELECT Container.ObjectId                                          AS ObjectId
                                  , MovementLinkObject_From.ObjectId                            AS FromId
                             FROM (SELECT DISTINCT tmpItem.ObjectId_to FROM tmpItem) AS tmpMI
                                  INNER JOIN Container ON Container.DescId = zc_Container_Count()
                                                      AND Container.WhereObjectId in (SELECT OL_Unit_Juridical.ObjectId FROM ObjectLink AS OL_Unit_Juridical
                                                                                      WHERE OL_Unit_Juridical.ChildObjectId = vbJuridicalToId
                                                                                        AND OL_Unit_Juridical.DescId   = zc_ObjectLink_Unit_Juridical())
                                                      AND Container.ObjectId = tmpMI.ObjectId_to

                                  LEFT JOIN MovementItemContainer AS MIC
                                                                  ON MIC.Containerid = Container.Id
                                                                 AND MIC.MovementDescId = zc_Movement_Income()
                                                                 AND MIC.OperDate >= CURRENT_DATE - INTERVAL '30 MONTH'

                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                               ON MovementLinkObject_From.MovementId = MIC.MovementId
                                                              AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                              GROUP BY Container.ObjectId
                                     , MovementLinkObject_From.ObjectId
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
                                                , inDescId_3          := CASE WHEN vbDivisionParties = TRUE AND COALESCE (tmpContainerTo.FromId, 0) = 0 THEN zc_ContainerLinkObject_DivisionParties() ELSE NULL END -- DescId для 3-ой Аналитики
                                                , inObjectId_3        := CASE WHEN vbDivisionParties = TRUE AND COALESCE (tmpContainerTo.FromId, 0) = 0 THEN zc_Enum_DivisionParties_UKTVED() ELSE NULL END
                                                 ) AS ContainerId_count
                         , tmpItem.MovementItemId  AS MovementItemId
                         , tmpItem.ObjectId_to     AS ObjectId
                         , vbSendDate              AS OperDate
                         , 1 * tmpItem.Amount      AS Amount
                         , TRUE                    AS IsActive
                      FROM tmpItem
                           LEFT JOIN tmpContainerTo ON tmpContainerTo.ObjectId = tmpItem.ObjectId_to
                                                   AND tmpContainerTo.FromId = tmpItem.JuridicalID
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

    END IF;

    -- Списуем сроковые партии которые не попали в распределение
    IF EXISTS (SELECT 1 FROM Container
               WHERE Container.DescId   = zc_Container_CountPartionDate()
                 AND Container.Amount   > 0
                 AND Container.WhereObjectId = vbUnitFromId
                 AND Container.ParentId IN (-- только расход которые не распределены по партиям
                                            SELECT _tmpMIContainer_insert.ContainerId FROM _tmpMIContainer_insert
                                            WHERE _tmpMIContainer_insert.DescId   = zc_MIContainer_Count()
                                            AND _tmpMIContainer_insert.isActive = FALSE
                                            AND _tmpMIContainer_insert.MovementItemId NOT IN
                                                 (SELECT DISTINCT _tmpMIContainer_insert.MovementItemId
                                                  FROM _tmpMIContainer_insert
                                                  WHERE _tmpMIContainer_insert.DescId = zc_MIContainer_CountPartionDate()))
                                            )
    THEN
      WITH -- Что уже рпспределено по партиям
           ContainerPDUse AS (SELECT _tmpMIContainer_insert.ContainerId
                                     -- сколько списано с партионных
                                   , Sum(_tmpMIContainer_insert.Amount) AS Amount
                              FROM _tmpMIContainer_insert
                              WHERE _tmpMIContainer_insert.DescId      = zc_MIContainer_CountPartionDate()
                              GROUP BY _tmpMIContainer_insert.ContainerId
                              )
         , ContainerPD AS (SELECT Container.Id
                                , Container.ParentId
                                  -- сколько осталось
                                , Container.Amount + COALESCE (ContainerPDUse.Amount, 0) AS Amount
                           FROM _tmpMIContainer_insert
                                JOIN Container ON Container.ParentId = _tmpMIContainer_insert.ContainerId
                                              AND Container.DescId   = zc_Container_CountPartionDate()
                                              AND Container.Amount > 0.0
                                LEFT JOIN ContainerPDUse ON ContainerPDUse.ContainerId = Container.Id
                           WHERE _tmpMIContainer_insert.DescId      = zc_MIContainer_Count()
                             AND _tmpMIContainer_insert.isActive    = FALSE -- только расход
                             AND _tmpMIContainer_insert.MovementItemId NOT IN
                                 (SELECT DISTINCT _tmpMIContainer_insert.MovementItemId
                                  FROM _tmpMIContainer_insert
                                  WHERE _tmpMIContainer_insert.DescId = zc_MIContainer_CountPartionDate())
                           )
           -- Остатки сроковых партий - zc_Container_CountPartionDate
         , DD AS (SELECT _tmpMIContainer_insert.MovementItemId
                         -- сколько надо получить
                       , -1 * _tmpMIContainer_insert.Amount                  AS Amount
                         -- остаток
                       , Container.Amount                                    AS AmountRemains
                       , vbSendDate                                          AS OperDate
                       , Container.Id                                        AS ContainerId
                         -- итого "накопительный" остаток
                       , SUM (Container.Amount) OVER (PARTITION BY Container.ParentId ORDER BY Container.Id, _tmpMIContainer_insert.MovementItemId) AS AmountRemains_sum
                         -- для последнего элемента - не смотрим на остаток
                       , ROW_NUMBER() OVER (PARTITION BY _tmpMIContainer_insert.MovementItemId ORDER BY Container.Id DESC, _tmpMIContainer_insert.MovementItemId DESC) AS DOrd
                   FROM ContainerPD AS Container
                        JOIN _tmpMIContainer_insert ON _tmpMIContainer_insert.ContainerId = Container.ParentId
                                                   AND _tmpMIContainer_insert.DescId      = zc_MIContainer_Count()
                                                   AND _tmpMIContainer_insert.isActive    = FALSE -- только расход
                                                   AND _tmpMIContainer_insert.MovementItemId NOT IN
                                                       (SELECT DISTINCT _tmpMIContainer_insert.MovementItemId
                                                        FROM _tmpMIContainer_insert
                                                        WHERE _tmpMIContainer_insert.DescId = zc_MIContainer_CountPartionDate())
                   WHERE Container.Amount > 0.0
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
                         WHERE (DD.Amount - (DD.AmountRemains_sum - DD.AmountRemains) > 0)
                       )
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

    END IF;

      -- Проводки если затронуты контейнера сроков в подразделении получателя "To"
    IF EXISTS(SELECT 1 FROM Container
              WHERE Container.WhereObjectId = vbUnitToId
                AND Container.ParentId in (SELECT _tmpMIContainer_insert.ContainerId FROM _tmpMIContainer_insert
                                           WHERE _tmpMIContainer_insert.DescId = zc_MIContainer_Count()
                                             AND _tmpMIContainer_insert.isActive = TRUE
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

     -- Добавили в ТП
     IF vbSUN = TRUE
     THEN
        PERFORM  gpSelect_MovementSUN_TechnicalRediscount(inMovementId, inUserId::TVarChar);
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

-- select * from gpUpdate_Movement_Send_Deferred(inMovementId := 15529825 , inisDeferred := 'True' ,  inSession := '3');-- SELECT * FROM lpComplete_Movement_Send (inMovementId:= 14931454, inUserId:= 3)
-- select * from gpUpdate_Status_Send(inMovementId := 19877942  , inStatusCode := 2 ,  inSession := '3');