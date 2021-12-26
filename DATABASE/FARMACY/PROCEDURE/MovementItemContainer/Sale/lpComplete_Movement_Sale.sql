DROP FUNCTION IF EXISTS lpComplete_Movement_Sale (Integer, Integer);
DROP FUNCTION IF EXISTS lpComplete_Movement_Sale (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Sale(
    IN inMovementId        Integer  , -- ключ Документа
    IN inMovementItemId    Integer  , -- ключ строка Документа
    IN inUserId            Integer    -- Пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbAccountId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbSaleDate TDateTime;
   DECLARE vbIsDeferred Boolean;
   DECLARE vbError TVarChar;
BEGIN

    -- Отложен
    vbIsDeferred := COALESCE ((SELECT MB.ValueData FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_Deferred()), FALSE);

    IF vbIsDeferred = FALSE AND COALESCE (inMovementItemId, 0) <> 0
    THEN
       RAISE EXCEPTION 'Ошибка. Частичное проведение разрешено только для отобранных продаж.';
    END IF;

    -- создаются временные таблицы - для формирование данных для проводок
    PERFORM lpComplete_Movement_Finance_CreateTemp();

    -- !!!обязательно!!! очистили таблицу проводок
    DELETE FROM _tmpMIContainer_insert;

    -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
    DELETE FROM _tmpItem;

    vbAccountId := lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- Запасы
                                              , inAccountDirectionId     := zc_Enum_AccountDirection_20100() -- Cклад
                                              , inInfoMoneyDestinationId := zc_Enum_InfoMoneyDestination_10200() -- Медикаменты
                                              , inInfoMoneyId            := NULL
                                              , inUserId                 := inUserId);

    SELECT
        Movement_Sale.UnitId
       ,ObjectLink_Unit_Juridical.ChildObjectId
       ,Movement_Sale.OperDate
    INTO
        vbUnitId
       ,vbJuridicalId
       ,vbSaleDate
    FROM
        Movement_Sale_View AS Movement_Sale
        LEFT OUTER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                   ON Movement_Sale.UnitId = ObjectLink_Unit_Juridical.ObjectId
                                  AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
    WHERE
        Movement_Sale.Id = inMovementId;

    -- Проверяем VIP чек для продажи         
    IF EXISTS(SELECT * FROM gpSelect_Goods_AutoVIPforSalesCash (inUnitId := vbUnitId , inSession:= inUserId::TVarChar) 
              WHERE GoodsId IN (SELECT DISTINCT MovementItem.ObjectId
                                FROM MovementItem
                                WHERE MovementItem.MovementId = inMovementId
                                  AND MovementItem.IsErased = FALSE
                                  AND COALESCE(MovementItem.Amount,0) > 0
                                  AND (MovementItem.Id = inMovementItemId OR COALESCE (inMovementItemId, 0) = 0)))
    THEN
      PERFORM gpInsertUpdate_MovementItem_Check_VIPforSales (inUnitId   := vbUnitId
                                                           , inGoodsId  := T1.GoodsId
                                                           , inAmount   := - T1.Amount
                                                           , inSession  := inUserId::TVarChar
                                                            )
      FROM (WITH HeldBy AS(-- уже проведено
                           SELECT MovementItemContainer.MovementItemId   AS MovementItemId
                                , SUM(- MovementItemContainer.Amount)      AS Amount
                           FROM MovementItemContainer
                           WHERE MovementItemContainer.MovementId = inMovementId
                           GROUP BY MovementItemContainer.MovementItemId
                          ),
                 Sale AS( -- строки документа продажи
                            SELECT
                                 MovementItem.ObjectId                                AS ObjectId
                               , SUM(MovementItem.Amount - COALESCE(HeldBy.Amount,0)) AS Amount
                            FROM MovementItem
                                 LEFT OUTER JOIN HeldBy AS HeldBy
                                                        ON MovementItem.Id = HeldBy.MovementItemId
                            WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.IsErased = FALSE
                              AND (COALESCE(MovementItem.Amount,0) - COALESCE(HeldBy.Amount,0)) > 0
                              AND (MovementItem.Id = inMovementItemId OR COALESCE (inMovementItemId, 0) = 0)
                            GROUP BY MovementItem.ObjectId 
                        ),
                 VIPforSalesCash AS (SELECT * FROM gpSelect_Goods_AutoVIPforSalesCash (inUnitId := vbUnitId , inSession:= inUserId::TVarChar))
                         
            SELECT Sale.ObjectId  AS GoodsId
                 , Sale.Amount
            FROM Sale 
                         
                 INNER JOIN VIPforSalesCash ON VIPforSalesCash.GoodsId = Sale.ObjectId) AS T1;          
        
    END IF;
    
    -- А сюда товары
    WITH
        HeldBy AS(-- уже проведено
                   SELECT MovementItemContainer.MovementItemId   AS MovementItemId
                        , SUM(- MovementItemContainer.Amount)      AS Amount
                   FROM MovementItemContainer
                   WHERE MovementItemContainer.MovementId = inMovementId
                   GROUP BY MovementItemContainer.MovementItemId
                  ),
        Sale AS( -- строки документа продажи
                    SELECT
                        MovementItem.Id                                                  as MovementItemId
                       ,MovementItem.ObjectId                                            as ObjectId
                       ,COALESCE (MILinkObject_NDSKind.ObjectId, Object_Goods.NDSKindId) as NDSKindId
                       ,MovementItem.Amount - COALESCE(HeldBy.Amount,0)as Amount
                    FROM MovementItem
                         LEFT OUTER JOIN HeldBy AS HeldBy
                                                ON MovementItem.Id = HeldBy.MovementItemId
                         LEFT JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = MovementItem.ObjectId
                         LEFT JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = Object_Goods_Retail.GoodsMainId
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_NDSKind
                                                          ON MILinkObject_NDSKind.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_NDSKind.DescId = zc_MILinkObject_NDSKind()
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.IsErased = FALSE
                      AND (COALESCE(MovementItem.Amount,0) - COALESCE(HeldBy.Amount,0)) > 0
                      AND (MovementItem.Id = inMovementItemId OR COALESCE (inMovementItemId, 0) = 0)
                ),
        PartionDate AS (SELECT REMAINS.Id
                             , Min(ObjectDate_ExpirationDate.ValueData)               AS ExpirationDate
                        FROM Container AS REMAINS

                             JOIN (SELECT DISTINCT Sale.ObjectId FROM Sale) AS Sale ON Sale.objectid = REMAINS.objectid

                             INNER JOIN Container ON Container.ParentId = REMAINS.Id
                                                 AND Container.DescID = zc_Container_CountPartionDate()
                                                 AND Container.Amount > 0

                             INNER JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                           AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                             INNER JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                   ON ObjectDate_ExpirationDate.ObjectId =  ContainerLinkObject.ObjectId
                                                  AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                        WHERE
                              REMAINS.Amount > 0
                              AND
                              REMAINS.DescId = zc_Container_Count()
                              AND
                              REMAINS.WhereObjectId = vbUnitId
                        GROUP BY REMAINS.Id
               ),
        tmpContainer AS  (  -- остатки
                    SELECT
                        Container.Id
                      , Container.ObjectId
                      , Container.Amount 
                      , CASE WHEN COALESCE (MovementBoolean_UseNDSKind.ValueData, FALSE) = FALSE
                               OR COALESCE(MovementLinkObject_NDSKind.ObjectId, 0) = 0
                             THEN Object_Goods.NDSKindId ELSE MovementLinkObject_NDSKind.ObjectId END  AS NDSKindId
                      , MIDate_ExpirationDate.ValueData                                                AS ExpirationDate 
                    FROM Container
                        JOIN (SELECT DISTINCT Sale.ObjectId FROM Sale) AS Sale ON Sale.ObjectId = Container.ObjectId
                        LEFT JOIN PartionDate ON PartionDate.ID = Container.ID

                        LEFT OUTER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = Container.ObjectId
                        LEFT OUTER JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = Object_Goods_Retail.GoodsMainId

                        JOIN containerlinkobject AS CLI_MI
                                                 ON CLI_MI.containerid = Container.Id
                                                AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()
                        LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                        -- элемент прихода
                        LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                        -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                        LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                    ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                   AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                        -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                        LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)
                                                             -- AND 1=0
                        LEFT OUTER JOIN MovementItemDate AS MIDate_ExpirationDate
                                                         ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                                        AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()

                        LEFT OUTER JOIN MovementBoolean AS MovementBoolean_UseNDSKind
                                                        ON MovementBoolean_UseNDSKind.MovementId = COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)
                                                       AND MovementBoolean_UseNDSKind.DescId = zc_MovementBoolean_UseNDSKind()
                        LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                     ON MovementLinkObject_NDSKind.MovementId = COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)
                                                    AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                    WHERE
                        Container.Amount > 0
                        AND
                        Container.DescId = zc_Container_Count()
                        AND
                        Container.WhereObjectId = vbUnitId
                ),
        DD AS  (  -- строки документа продажи размазанные по текущему остатку(Контейнерам) на подразделении
                    SELECT
                        Sale.MovementItemId
                      , Sale.Amount
                      , Container.Amount AS ContainerAmount
                      , Container.ObjectId
                      , Container.Id
                      , Container.NDSKindId
                      , SUM(Container.Amount) OVER (PARTITION BY Container.objectid ORDER BY Container.NDSKindId, COALESCE(PartionDate.ExpirationDate, Container.ExpirationDate) DESC,Container.Id)
                    FROM tmpContainer AS Container
                        JOIN Sale ON Sale.ObjectId = Container.ObjectId
                                 AND Sale.NDSKindId = Container.NDSKindId
                        LEFT JOIN PartionDate ON PartionDate.ID = Container.ID
                ),

        tmpItem AS ( -- контейнеры и кол-во(Сумма), которое с них будет списано (с подразделения)
                        SELECT
                            DD.Id             AS Container_AmountId
                          -- , Container_Summ.Id AS Container_SummId
                          , DD.MovementItemId
                          , DD.ObjectId
			              , CASE
                              WHEN DD.Amount - DD.SUM > 0 THEN DD.ContainerAmount
                              ELSE DD.Amount - DD.SUM + DD.ContainerAmount
                            END AS Amount
                          , /*CASE
                              WHEN DD.Amount - DD.SUM > 0 THEN Container_Summ.Amount
                              ELSE (DD.Amount - DD.SUM + DD.ContainerAmount) * (Container_Summ.Amount / DD.ContainerAmount)
                            END*/ 0 AS Summ
                          , TRUE AS IsActive
                        FROM DD
                            -- !!!отключил т.к. ошибка с задвоением!!!
                            /*LEFT OUTER JOIN Container AS Container_Summ
                                                      ON Container_Summ.ParentId = DD.Id
                                                     AND Container_Summ.DescId = zc_Container_Summ()*/
                        WHERE (DD.Amount - (DD.SUM - DD.ContainerAmount) > 0)
                    )

    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate,IsActive)
    SELECT --контейнеры по количество
        zc_Container_Count()
      , zc_Movement_Sale()
      , inMovementId
      , tmpItem.MovementItemId
      , tmpItem.Container_AmountId
      , vbAccountId
      , -tmpItem.Amount
      , vbSaleDate
      , tmpItem.IsActive
    FROM tmpItem
    /*UNION ALL
    SELECT --Контейнеры по сумме
        zc_Container_Summ()
      , zc_Movement_Sale()
      , inMovementId
      , tmpItem.MovementItemId
      , tmpItem.Container_SummId
      , vbAccountId
      , -tmpItem.Summ
      , vbSaleDate
      , tmpItem.IsActive
    FROM tmpItem*/
    ;

      -- Проводки если затронуты контейнера сроков в подразделении получателя "To"
    IF EXISTS(SELECT 1 FROM Container WHERE Container.WhereObjectId = vbUnitId
                                        AND Container.Amount > 0
                                        AND Container.ParentId in (SELECT _tmpMIContainer_insert.ContainerId FROM _tmpMIContainer_insert
                                                                       WHERE _tmpMIContainer_insert.DescId = zc_MIContainer_Count()
                                                                         AND _tmpMIContainer_insert.Amount < 0.0))
    THEN

      WITH DD AS (
         SELECT
            ROW_NUMBER()OVER(PARTITION BY Container.ParentId ORDER BY Container.Id DESC) as ORD
          , _tmpMIContainer_insert.MovementItemId
          , -1 * _tmpMIContainer_insert.Amount                                           as Amount
          , Container.Amount AS ContainerAmount
          , vbSaleDate       AS OperDate
          , Container.Id     AS ContainerId
          , SUM (Container.Amount) OVER (PARTITION BY Container.ParentId ORDER BY Container.Id)
          FROM Container
               JOIN _tmpMIContainer_insert ON _tmpMIContainer_insert.ContainerId = Container.ParentId
                                          AND _tmpMIContainer_insert.DescId      = zc_MIContainer_Count()
          WHERE Container.DescId         = zc_Container_CountPartionDate()
            AND Container.WhereObjectId  = vbUnitId
            AND Container.Amount > 0
            AND _tmpMIContainer_insert.Amount < 0.0
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
               , zc_Movement_Sale()
               , inMovementId
               , tmpItem.MovementItemId
               , tmpItem.Id
               , Null
               , -1 * Amount
               , OperDate
            FROM tmpItem;
    END IF;

    PERFORM lpInsertUpdate_MovementItemContainer_byTable();

    IF vbIsDeferred = FALSE
    THEN
      -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
      PERFORM lpComplete_Movement (inMovementId := inMovementId
                                 , inDescId     := zc_Movement_Sale()
                                 , inUserId     := inUserId
                                  );
    END IF;

    --пересчитали суммы по документу (для суммы закупки, которая считается после проведения документа)
    PERFORM lpInsertUpdate_MovementFloat_TotalSummSaleExactly (inMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.  Шаблий О.В.
 23.12.21                                                                                   *
 11.05.20                                                                                   *               
 01.08.19                                                                                   *
 13.10.15                                                                     *
*/