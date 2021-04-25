-- Function: lpComplete_Movement_Check (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_Check (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Check(
    IN inMovementId        Integer  , -- ключ Документа
   OUT outMessageText      Text     ,
    IN inUserId            Integer    -- Пользователь
)
RETURNS Text
AS
$BODY$
   DECLARE vbAccountId Integer;
   DECLARE vbOperSumm_Partner TFloat;
   DECLARE vbOperSumm_Partner_byItem TFloat;
   DECLARE vbUnitId Integer;
   DECLARE vbOperDate TDateTime;

   DECLARE vbMovementItemId Integer;
   DECLARE vbMovementItemId_partion Integer;
   DECLARE vbContainerId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbNDSKindId Integer;
   DECLARE vbDivisionPartiesId Integer;
   DECLARE vbAmount TFloat;
   DECLARE vbAmount_remains TFloat;
   DECLARE vbDiscountExternalId Integer;
   DECLARE vbisOneSupplier Boolean;

   DECLARE curRemains refcursor;
   DECLARE curSale refcursor;
   DECLARE vbDayCompensDiscount Integer;
   DECLARE vbSummChangePercent TFloat;
BEGIN

     -- Проверим чтоб сроковый товар был прикреплен к партиям и был остаток
     IF EXISTS(SELECT 1
               FROM MovementItem AS MI
                    INNER JOIN MovementItemLinkObject AS MILinkObject_PartionDateKind
                                                      ON MILinkObject_PartionDateKind.MovementItemId        = MI.Id
                                                     AND MILinkObject_PartionDateKind.DescId                = zc_MILinkObject_PartionDateKind()
                                                     AND COALESCE(MILinkObject_PartionDateKind.ObjectId, 0) <> 0
                    LEFT JOIN MovementItem AS MIChild
                                           ON MIChild.MovementId = MI.MovementId
                                          AND MIChild.ParentId   = MI.Id
                                          AND MIChild.DescId     = zc_MI_Child()
                                          AND MIChild.Amount     > 0
                                          AND MIChild.isErased   = FALSE
                    LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                ON MIFloat_ContainerId.MovementItemId = MIChild.Id
                                               AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
                    LEFT JOIN Container ON Container.ID = MIFloat_ContainerId.ValueData::Integer
               WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.Amount > 0 AND MI.isErased = FALSE
               GROUP BY MI.Id, MI.Amount
               HAVING MI.Amount <> COALESCE(SUM(MIChild.Amount), 0)
                   OR MI.Amount <> COALESCE(SUM(CASE WHEN COALESCE(Container.Amount, 0) < COALESCE(MIChild.Amount, 0) THEN COALESCE(Container.Amount, 0) ELSE COALESCE(MIChild.Amount, 0) END), 0))
     THEN
           -- Ошибка расч/факт остаток :
           outMessageText:= '' || (SELECT STRING_AGG (tmp.Value, ' (***) ')
                                     FROM (SELECT '(' || COALESCE (Object.ObjectCode, 0) :: TVarChar || ')' || COALESCE (Object.ValueData, '') ||
                                                  ' в чеке: ' || zfConvert_FloatToString (MI.Amount) || COALESCE (Object_Measure.ValueData, '') ||
                                                  '; распределено: ' || zfConvert_FloatToString (COALESCE(SUM(MIChild.Amount), 0)) || COALESCE (Object_Measure.ValueData, '') ||
                                                  '; остаток: ' || zfConvert_FloatToString (COALESCE(SUM(CASE WHEN COALESCE(Container.Amount, 0) < COALESCE(MIChild.Amount, 0) THEN COALESCE(Container.Amount, 0) ELSE COALESCE(MIChild.Amount, 0) END), 0)) || COALESCE (Object_Measure.ValueData, '') AS Value
                                           FROM MovementItem AS MI
                                                INNER JOIN MovementItemLinkObject AS MILinkObject_PartionDateKind
                                                                                  ON MILinkObject_PartionDateKind.MovementItemId   =    MI.Id
                                                                                 AND MILinkObject_PartionDateKind.DescId                = zc_MILinkObject_PartionDateKind()
                                                                                 AND COALESCE(MILinkObject_PartionDateKind.ObjectId, 0) <> 0
                                                LEFT JOIN MovementItem AS MIChild
                                                                        ON MIChild.MovementId = MI.MovementId
                                                                       AND MIChild.ParentId   = MI.Id
                                                                       AND MIChild.DescId     = zc_MI_Child()
                                                                       AND MIChild.Amount     > 0
                                                                       AND MIChild.isErased   = FALSE
                                                LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                                            ON MIFloat_ContainerId.MovementItemId = MIChild.Id
                                                                           AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
                                                LEFT JOIN Container ON Container.ID = MIFloat_ContainerId.ValueData::Integer
                                                LEFT JOIN Object ON Object.Id = MI.ObjectId
                                                LEFT JOIN ObjectLink ON ObjectLink.ObjectId = MI.ObjectId
                                                                    AND ObjectLink.DescId = zc_ObjectLink_Goods_Measure()
                                                LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink.ChildObjectId
                                           WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.Amount > 0 AND MI.isErased = FALSE
                                           GROUP BY MI.Id, MI.Amount, Object.ObjectCode, Object.ValueData, Object_Measure.ValueData
                                           HAVING MI.Amount <> COALESCE(SUM(MIChild.Amount), 0)
                                               OR MI.Amount <> COALESCE(SUM(CASE WHEN COALESCE(Container.Amount, 0) < COALESCE(MIChild.Amount, 0) THEN COALESCE(Container.Amount, 0) ELSE COALESCE(MIChild.Amount, 0) END), 0)
                                         ) AS tmp
                                    )
                         || '';

           -- Сохранили ошибку
           PERFORM lpInsertUpdate_MovementString (zc_MovementString_CommentError(), inMovementId, outMessageText :: TVarChar);

           -- Ошибка расч/факт остаток :
           outMessageText:= 'Ошибка.Партионного товара: ' || outMessageText;

           -- кроме Админа
           IF 0 = 0/* OR inUserId <> 3*/
           THEN
               -- больше ничего не делаем
               RETURN;
           END IF;

     END IF;

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
    SELECT Movement.OperDate
         , MovementLinkObject_Unit.ObjectId
         , COALESCE(ObjectLink_DiscountExternal.ChildObjectId, 0)
         , COALESCE(ObjectBoolean_TwoPackages.ValueData, False) 
         , COALESCE(MovementFloat_TotalSummChangePercent.ValueData, 0)
    INTO vbOperDate, vbUnitId, vbDiscountExternalId, vbisOneSupplier, vbSummChangePercent
    FROM Movement

         LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

         LEFT JOIN MovementLinkObject AS MovementLinkObject_DiscountCard
                                      ON MovementLinkObject_DiscountCard.MovementId = Movement.Id
                                     AND MovementLinkObject_DiscountCard.DescId = zc_MovementLinkObject_DiscountCard()

         LEFT JOIN ObjectLink AS ObjectLink_DiscountExternal
                              ON ObjectLink_DiscountExternal.ObjectId = MovementLinkObject_DiscountCard.ObjectId
                             AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountCard_Object()

         LEFT JOIN ObjectBoolean AS ObjectBoolean_TwoPackages
                                 ON ObjectBoolean_TwoPackages.ObjectId = ObjectLink_DiscountExternal.ChildObjectId
                                AND ObjectBoolean_TwoPackages.DescId = zc_ObjectBoolean_DiscountExternal_TwoPackages()

         LEFT JOIN MovementFloat AS MovementFloat_TotalSummChangePercent
                                 ON MovementFloat_TotalSummChangePercent.MovementId =  Movement.Id
                                AND MovementFloat_TotalSummChangePercent.DescId = zc_MovementFloat_TotalSummChangePercent()
    WHERE Movement.Id = inMovementId;

    -- Определить
    vbAccountId:= lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000()         -- Запасы
                                             , inAccountDirectionId     := zc_Enum_AccountDirection_20100()     -- Cклад
                                             , inInfoMoneyDestinationId := zc_Enum_InfoMoneyDestination_10200() -- Медикаменты
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId);

    -- данные почти все
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpItem_remains'))
    THEN
        -- DELETE FROM _tmpItem_remains;
        DROP TABLE _tmpItem_remains;
        -- таблица - данные почти все
        CREATE TEMP TABLE _tmpItem_remains (MovementItemId_partion Integer, GoodsId Integer, ContainerId Integer, NDSKindId Integer, DivisionPartiesId Integer, Amount TFloat, OperDate TDateTime, JuridicalId Integer) ON COMMIT DROP;
    ELSE
        -- таблица - данные почти все
        CREATE TEMP TABLE _tmpItem_remains (MovementItemId_partion Integer, GoodsId Integer, ContainerId Integer, NDSKindId Integer, DivisionPartiesId Integer, Amount TFloat, OperDate TDateTime, JuridicalId Integer) ON COMMIT DROP;
    END IF;

    -- предварительно сохранили продажи
    INSERT INTO _tmpItem (MovementItemId, ObjectId, NDSKindId, DivisionPartiesId, OperSumm, Price)
       SELECT MI.Id, MI.ObjectId, COALESCE (MILinkObject_NDSKind.ObjectId, Object_Goods_Main.NDSKindId), COALESCE (MILinkObject_DivisionParties.ObjectId, 0),  MI.Amount, COALESCE (MIFloat_Price.ValueData, 0)
       FROM MovementItem AS MI
            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MI.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItem AS MIChild
                                   ON MIChild.MovementId = MI.MovementId
                                  AND MIChild.ParentId   = MI.Id
                                  AND MIChild.DescId     = zc_MI_Child()
                                  AND MIChild.Amount     > 0
                                  AND MIChild.isErased   = FALSE
            LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                        ON MIFloat_ContainerId.MovementItemId = MIChild.Id
                                       AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

            LEFT JOIN Object_Goods_Retail AS Object_Goods ON Object_Goods.Id = MI.ObjectId
            LEFT JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods.GoodsMainId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_NDSKind
                                             ON MILinkObject_NDSKind.MovementItemId = MI.Id
                                            AND MILinkObject_NDSKind.DescId = zc_MILinkObject_NDSKind()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_DivisionParties
                                             ON MILinkObject_DivisionParties.MovementItemId = MI.Id
                                            AND MILinkObject_DivisionParties.DescId = zc_MILinkObject_DivisionParties()

       WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.Amount > 0 AND MI.isErased = FALSE
         AND COALESCE (MIChild.Id, 0) = 0;

    -- предварительно сохранили остаток
    WITH
         tmpSupplier AS (SELECT ObjectLink_Juridical.ChildObjectId     AS JuridicalId
                              , ObjectFloat_SupplierID.ValueData::Integer   AS SupplierID
                         FROM Object AS Object_DiscountExternalSupplier
                              LEFT JOIN ObjectLink AS ObjectLink_DiscountExternal
                                                   ON ObjectLink_DiscountExternal.ObjectId = Object_DiscountExternalSupplier.Id
                                                  AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountExternalSupplier_DiscountExternal()

                              LEFT JOIN ObjectLink AS ObjectLink_Juridical
                                                   ON ObjectLink_Juridical.ObjectId = Object_DiscountExternalSupplier.Id
                                                  AND ObjectLink_Juridical.DescId = zc_ObjectLink_DiscountExternalSupplier_Juridical()

                              LEFT JOIN ObjectFloat AS ObjectFloat_SupplierID
                                                    ON ObjectFloat_SupplierID.ObjectId = Object_DiscountExternalSupplier.Id
                                                   AND ObjectFloat_SupplierID.DescId = zc_ObjectFloat_DiscountExternalSupplier_SupplierID()

                         WHERE Object_DiscountExternalSupplier.DescId = zc_Object_DiscountExternalSupplier()
                           AND Object_DiscountExternalSupplier.isErased = False
                           AND ObjectLink_DiscountExternal.ChildObjectId = vbDiscountExternalId
                         )

    INSERT INTO _tmpItem_remains (MovementItemId_partion, GoodsId, ContainerId, NDSKindId, DivisionPartiesId, Amount, OperDate, JuridicalId)
       SELECT CASE WHEN Movement.DescId = zc_Movement_Inventory() AND MIFloat_MovementItem.ValueData > 0 THEN MIFloat_MovementItem.ValueData :: Integer ELSE MovementItem.Id END AS MovementItemId_partion
            , Container.ObjectId AS GoodsId
            , Container.Id       AS ContainerId
            , CASE WHEN COALESCE (MovementBoolean_UseNDSKind.ValueData, FALSE) = FALSE
                     OR COALESCE(MovementLinkObject_NDSKind.ObjectId, 0) = 0
                   THEN Object_Goods.NDSKindId ELSE MovementLinkObject_NDSKind.ObjectId END  AS NDSKindId
            , COALESCE(ContainerLinkObject_DivisionParties.ObjectId, 0)                      AS DivisionPartiesId
            , Container.Amount                                                               AS Amount
            , Movement.OperDate
            , tmpSupplier.JuridicalId
       FROM (SELECT DISTINCT ObjectId FROM _tmpItem) AS tmp
            INNER JOIN Container ON Container.DescId = zc_Container_Count()
                                AND Container.WhereObjectId = vbUnitId
                                AND Container.ObjectId = tmp.ObjectId
                                AND Container.Amount > 0
            LEFT JOIN Container AS PDContainer
                                ON PDContainer.DescId = zc_Container_CountPartionDate()
                               AND PDContainer.ParentId = Container.Id
                               AND PDContainer.WhereObjectId = vbUnitId
                               AND PDContainer.ObjectId = tmp.ObjectId
                               AND PDContainer.Amount > 0
            LEFT OUTER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = Container.ObjectId
            LEFT OUTER JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = Object_Goods_Retail.GoodsMainId

            -- деление по партиям
            LEFT JOIN ContainerlinkObject AS ContainerLinkObject_DivisionParties
                                          ON ContainerLinkObject_DivisionParties.Containerid = COALESCE(Container.ParentId, Container.Id)
                                         AND ContainerLinkObject_DivisionParties.DescId = zc_ContainerLinkObject_DivisionParties()

            -- партия
            INNER JOIN ContainerLinkObject AS CLI_MI
                                           ON CLI_MI.ContainerId = Container.Id
                                          AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()
            INNER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
            -- элемент прихода
            INNER JOIN MovementItem ON MovementItem.Id = Object_PartionMovementItem.ObjectCode
            INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
            -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
            LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                        ON MIFloat_MovementItem.MovementItemId = MovementItem.Id
                                       AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
            -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
            LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)

            LEFT OUTER JOIN MovementBoolean AS MovementBoolean_UseNDSKind
                                            ON MovementBoolean_UseNDSKind.MovementId = COALESCE (MI_Income_find.MovementId,MovementItem.MovementId)
                                           AND MovementBoolean_UseNDSKind.DescId = zc_MovementBoolean_UseNDSKind()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                         ON MovementLinkObject_NDSKind.MovementId = COALESCE (MI_Income_find.MovementId,MovementItem.MovementId)
                                        AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = COALESCE (MI_Income_find.MovementId,MovementItem.MovementId)
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

            LEFT JOIN tmpSupplier ON tmpSupplier.JuridicalId = MovementLinkObject_From.ObjectId

       WHERE COALESCE (PDContainer.id, 0) = 0
         AND (vbDiscountExternalId = 0 OR COALESCE(tmpSupplier.SupplierID, 0) <> 0)
       ;
         
    IF COALESCE (vbDiscountExternalId, 0) <> 0
    THEN

      IF NOT EXISTS (WITH
                    tmpItem AS (SELECT _tmpItem.ObjectId
                                     , SUM(_tmpItem.OperSumm) AS Amount 
                                FROM _tmpItem
                                GROUP BY _tmpItem.ObjectId), 
                    tmpItemRemains AS (SELECT _tmpItem_remains.GoodsId
                                            , _tmpItem_remains.JuridicalId
                                            , SUM(_tmpItem_remains.Amount) AS Amount
                                            , MIN(_tmpItem_remains.OperDate) AS OperDate  

                                       FROM _tmpItem_remains
                                            LEFT JOIN tmpItem ON tmpItem.ObjectId = _tmpItem_remains.GoodsId
                                       GROUP BY _tmpItem_remains.GoodsId, _tmpItem_remains.JuridicalId
                                       HAVING SUM(_tmpItem_remains.Amount) >= MAX(tmpItem.Amount)),
                    tmpItemRemainsOrd AS (SELECT tmpItemRemains.GoodsId
                                               , tmpItemRemains.JuridicalId   
                                               , tmpItemRemains.Amount
                                               , ROW_NUMBER() OVER (PARTITION BY tmpItemRemains.GoodsId ORDER BY tmpItemRemains.OperDate) AS Ord
                                          FROM tmpItemRemains)
                    
                    SELECT 1
                    FROM tmpItem
                         LEFT JOIN tmpItemRemainsOrd ON tmpItemRemainsOrd.GoodsId = tmpItem.ObjectId
                                                    AND tmpItemRemainsOrd.Ord = 1
                    WHERE COALESCE (tmpItemRemainsOrd.GoodsId, 0)  = 0
                )
      THEN
        UPDATE _tmpItem_remains SET Amount = 0
        FROM (WITH
                    tmpItem AS (SELECT _tmpItem.ObjectId
                                     , SUM(_tmpItem.OperSumm) AS Amount 
                                FROM _tmpItem
                                GROUP BY _tmpItem.ObjectId), 
                    tmpItemRemains AS (SELECT _tmpItem_remains.GoodsId
                                            , _tmpItem_remains.JuridicalId
                                            , SUM(_tmpItem_remains.Amount) AS Amount
                                            , MIN(_tmpItem_remains.OperDate) AS OperDate  

                                       FROM _tmpItem_remains
                                            LEFT JOIN tmpItem ON tmpItem.ObjectId = _tmpItem_remains.GoodsId
                                       GROUP BY _tmpItem_remains.GoodsId, _tmpItem_remains.JuridicalId
                                       HAVING SUM(_tmpItem_remains.Amount) >= MAX(tmpItem.Amount)),
                    tmpItemRemainsOrd AS (SELECT tmpItemRemains.GoodsId
                                               , tmpItemRemains.JuridicalId   
                                               , tmpItemRemains.Amount
                                               , ROW_NUMBER() OVER (PARTITION BY tmpItemRemains.GoodsId ORDER BY tmpItemRemains.OperDate) AS Ord
                                          FROM tmpItemRemains)
                    
                    SELECT tmpItemRemainsOrd.GoodsId
                         , tmpItemRemainsOrd.JuridicalId 
                    FROM tmpItemRemainsOrd
                    WHERE tmpItemRemainsOrd.Ord = 1) AS T1
        WHERE _tmpItem_remains.GoodsId = T1.GoodsId
          AND _tmpItem_remains.JuridicalId <> T1.JuridicalId;
      END IF;

      DELETE FROM _tmpItem_remains WHERE Amount = 0;
    END IF;

    -- Проверим что б БЫЛ остаток в целом
    IF EXISTS (SELECT 1
               FROM (SELECT ObjectId AS GoodsId, NDSKindId, DivisionPartiesId, SUM (OperSumm) AS Amount FROM _tmpItem GROUP BY ObjectId, NDSKindId, DivisionPartiesId) AS tmpFrom
                     LEFT JOIN (SELECT _tmpItem_remains.GoodsId, _tmpItem_remains.NDSKindId, _tmpItem_remains.DivisionPartiesId, SUM (Amount) AS Amount
                                FROM _tmpItem_remains
                                GROUP BY _tmpItem_remains.GoodsId
                                       , _tmpItem_remains.NDSKindId
                                       , _tmpItem_remains.DivisionPartiesId) AS tmpTo
                                                                             ON tmpTo.GoodsId = tmpFrom.GoodsId
                                                                            AND tmpTo.NDSKindId = tmpFrom.NDSKindId
                                                                            AND tmpTo.DivisionPartiesId = tmpFrom.DivisionPartiesId
               WHERE tmpFrom.Amount > COALESCE (tmpTo.Amount, 0))
    THEN
           -- Ошибка расч/факт остаток :
           outMessageText:= '' || (SELECT STRING_AGG (tmp.Value, ' (***) ')
                                    FROM (SELECT '(' || COALESCE (Object.ObjectCode, 0) :: TVarChar || ')' || COALESCE (Object.ValueData, '') ||
                                                 CASE WHEN COALESCE(Object_DivisionParties.Id, 0) <> 0 THEN '; Разделение партий: '||Object_DivisionParties.ValueData ELSE '' END||
                                                 ' в чеке: ' || zfConvert_FloatToString (AmountFrom) || COALESCE (Object_Measure.ValueData, '') ||
                                                 '; остаток: ' || zfConvert_FloatToString (AmountTo) || COALESCE (Object_Measure.ValueData, '') AS Value
                                          FROM (SELECT tmpFrom.GoodsId, tmpFrom.NDSKindId, tmpFrom.DivisionPartiesId, tmpFrom.Amount AS AmountFrom, COALESCE (tmpTo.Amount, 0) AS AmountTo
                                                FROM (SELECT ObjectId AS GoodsId, NDSKindId, DivisionPartiesId, SUM (OperSumm) AS Amount
                                                      FROM _tmpItem GROUP BY ObjectId, NDSKindId, DivisionPartiesId) AS tmpFrom
                                                      LEFT JOIN (SELECT _tmpItem_remains.GoodsId, _tmpItem_remains.NDSKindId, _tmpItem_remains.DivisionPartiesId, SUM (Amount) AS Amount
                                                                 FROM _tmpItem_remains
                                                                 GROUP BY _tmpItem_remains.GoodsId, _tmpItem_remains.NDSKindId, _tmpItem_remains.DivisionPartiesId) AS tmpTo
                                                                 ON tmpTo.GoodsId = tmpFrom.GoodsId AND tmpTo.NDSKindId = tmpFrom.NDSKindId AND tmpTo.DivisionPartiesId = tmpFrom.DivisionPartiesId
                                                WHERE tmpFrom.Amount > COALESCE (tmpTo.Amount, 0)) AS tmp
                                               LEFT JOIN Object ON Object.Id = tmp.GoodsId
                                               LEFT JOIN Object AS Object_DivisionParties ON Object_DivisionParties.Id = tmp.DivisionPartiesId
                                               LEFT JOIN ObjectLink ON ObjectLink.ObjectId = tmp.GoodsId
                                                                   AND ObjectLink.DescId = zc_ObjectLink_Goods_Measure()
                                               LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink.ChildObjectId
                                         ) AS tmp
                                    )
                         || '';

           -- Сохранили ошибку
           PERFORM lpInsertUpdate_MovementString (zc_MovementString_CommentError(), inMovementId, outMessageText :: TVarChar);

           -- Ошибка расч/факт остаток :
           outMessageText:= 'Ошибка.Товара нет в наличии: ' || outMessageText;

           -- кроме Админа
           IF 1 = 1 /*OR inUserId <> 3*/
           THEN
               -- больше ничего не делаем
               RETURN;
           END IF;

     END IF;

    -- !!!Только если товар дублируется - Распределим по старинке!!!
    IF EXISTS (SELECT 1 FROM _tmpItem GROUP BY ObjectId, NDSKindId, DivisionPartiesId HAVING COUNT (*) > 1)
    THEN
        -- курсор1 - элементы продажи
        OPEN curSale FOR SELECT MovementItemId, ObjectId, NDSKindId, DivisionPartiesId, OperSumm AS Amount FROM _tmpItem;
        -- начало цикла по курсору1 - возвраты
        LOOP
                -- данные по продажам
                FETCH curSale INTO vbMovementItemId, vbGoodsId, vbNDSKindId, vbDivisionPartiesId, vbAmount;
                -- если данные закончились, тогда выход
                IF NOT FOUND THEN EXIT; END IF;

                -- курсор2. - остатки МИНУС сколько уже распределили для vbGoodsId
                OPEN curRemains FOR
                   SELECT _tmpItem_remains.ContainerId, _tmpItem_remains.MovementItemId_partion, _tmpItem_remains.GoodsId, _tmpItem_remains.Amount - COALESCE (tmp.Amount, 0)
                   FROM _tmpItem_remains
                        LEFT JOIN (SELECT ContainerId, -1 * SUM (_tmpMIContainer_insert.Amount) AS Amount FROM _tmpMIContainer_insert GROUP BY ContainerId
                                  ) AS tmp ON tmp.ContainerId = _tmpItem_remains.ContainerId
                   WHERE _tmpItem_remains.GoodsId = vbGoodsId
                     AND _tmpItem_remains.NDSKindId = vbNDSKindId
                     AND _tmpItem_remains.DivisionPartiesId = vbDivisionPartiesId
                     AND _tmpItem_remains.Amount - COALESCE (tmp.Amount, 0) > 0
                   ORDER BY _tmpItem_remains.OperDate DESC, _tmpItem_remains.ContainerId DESC
                  ;
                -- начало цикла по курсору2. - остатки
                LOOP
                    -- данные по остаткам
                    FETCH curRemains INTO vbContainerId, vbMovementItemId_partion, vbGoodsId, vbAmount_remains;
                    -- если данные закончились, или все кол-во найдено тогда выход
                    IF NOT FOUND OR vbAmount = 0 THEN EXIT; END IF;

                    --
                    IF vbAmount_remains > vbAmount
                    THEN
                        -- получилось в остатках больше чем искали, !!!сохраняем в табл-результат - проводки кол-во!!!
                        INSERT INTO _tmpMIContainer_insert (DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate
                                                          , ObjectId_analyzer, WhereObjectId_analyzer, AnalyzerId, ObjectIntId_analyzer, Price
                                                           )
                           SELECT zc_MIContainer_Count()
                                , zc_Movement_Check()
                                , inMovementId
                                , vbMovementItemId
                                , vbContainerId
                                , vbAccountId
                                , -1 * vbAmount
                                , vbOperDate
                                , vbGoodsId                AS ObjectId_analyzer
                                , vbUnitId                 AS WhereObjectId_analyzer
                                , vbMovementItemId_partion AS AnalyzerId
                                , (SELECT MIContainer.ObjectIntId_analyzer FROM MovementItemContainer AS MIContainer WHERE MIContainer.MovementItemId = vbMovementItemId_partion AND MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.ObjectIntId_analyzer <> 0 LIMIT 1) AS ObjectIntId_analyzer
                                , (SELECT _tmpItem.Price FROM _tmpItem WHERE _tmpItem.MovementItemId = vbMovementItemId) AS Price
                                 ;
                        -- обнуляем кол-во что бы больше не искать
                        vbAmount:= 0;
                    ELSE
                        -- получилось в остатках меньше чем искали, !!!сохраняем в табл-результат - проводки кол-во!!!
                        INSERT INTO _tmpMIContainer_insert (DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate
                                                          , ObjectId_analyzer, WhereObjectId_analyzer, AnalyzerId, ObjectIntId_analyzer, Price
                                                           )
                           SELECT zc_MIContainer_Count()
                                , zc_Movement_Check()
                                , inMovementId
                                , vbMovementItemId
                                , vbContainerId
                                , vbAccountId
                                , -1 * vbAmount_remains
                                , vbOperDate
                                , vbGoodsId                AS ObjectId_analyzer
                                , vbUnitId                 AS WhereObjectId_analyzer
                                , vbMovementItemId_partion AS AnalyzerId
                                , (SELECT MIContainer.ObjectIntId_analyzer FROM MovementItemContainer AS MIContainer WHERE MIContainer.MovementItemId = vbMovementItemId_partion AND MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.ObjectIntId_analyzer <> 0 LIMIT 1) AS ObjectIntId_analyzer
                                , (SELECT _tmpItem.Price FROM _tmpItem WHERE _tmpItem.MovementItemId = vbMovementItemId) AS Price
                                 ;
                        -- уменьшаем на кол-во которое нашли и продолжаем поиск
                        vbAmount:= vbAmount - vbAmount_remains;
                    END IF;

                END LOOP; -- финиш цикла по курсору2. - остатки
                CLOSE curRemains; -- закрыли курсор2. - остатки

            END LOOP; -- финиш цикла по курсору1 - продажи
            CLOSE curSale; -- закрыли курсор1 - продажи

    ELSE
        -- !!!Сразу!!! - Результат - проводки кол-во
        INSERT INTO _tmpMIContainer_insert (DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate
                                          , ObjectId_analyzer, WhereObjectId_analyzer, AnalyzerId, ObjectIntId_analyzer, Price
                                           )
           WITH tmpContainer AS (SELECT MI_Sale.MovementItemId
                                      , MI_Sale.ObjectId        AS GoodsId
                                      , MI_Sale.OperSumm        AS SaleAmount
                                      , MI_Sale.Price
                                      , Container.Amount        AS ContainerAmount
                                      , Container.ContainerId
                                      , Container.MovementItemId_partion
                                      , SUM (Container.Amount) OVER (PARTITION BY Container.GoodsId, Container.NDSKindId, Container.DivisionPartiesId
                                                               ORDER BY Container.OperDate, Container.ContainerId, MI_Sale.MovementItemId) AS ContainerAmountSUM
                                      , ROW_NUMBER() OVER (PARTITION BY /*MI_Sale.ObjectId*/ MI_Sale.MovementItemId ORDER BY Container.OperDate DESC, Container.ContainerId DESC, MI_Sale.MovementItemId DESC) AS DOrd
                                 FROM _tmpItem AS MI_Sale
                                      INNER JOIN _tmpItem_remains AS Container
                                                                  ON Container.GoodsId = MI_Sale.ObjectId
                                                                 AND Container.NDSKindId = MI_Sale.NDSKindId
                                                                 AND Container.DivisionPartiesId = MI_Sale.DivisionPartiesId
                                )
           -- Результат
           SELECT zc_MIContainer_Count()
                , zc_Movement_Check()
                , inMovementId
                , tmpItem.MovementItemId
                , tmpItem.ContainerId
                , vbAccountId
                , -1 * Amount
                , vbOperDate
                , tmpItem.GoodsId                AS ObjectId_analyzer
                , vbUnitId                       AS WhereObjectId_analyzer
                , tmpItem.MovementItemId_partion AS AnalyzerId
                , (SELECT MIContainer.ObjectIntId_analyzer FROM MovementItemContainer AS MIContainer WHERE MIContainer.MovementItemId = tmpItem.MovementItemId_partion AND MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.ObjectIntId_analyzer <> 0 LIMIT 1) AS ObjectIntId_analyzer
                , tmpItem.Price
              FROM (SELECT DD.ContainerId
                         , DD.GoodsId
                         , DD.MovementItemId
                         , DD.MovementItemId_partion
                         , DD.Price
                         , CASE WHEN DD.SaleAmount - DD.ContainerAmountSUM > 0 AND DD.DOrd <> 1
                                     THEN DD.ContainerAmount
                                ELSE DD.SaleAmount - DD.ContainerAmountSUM + DD.ContainerAmount
                           END AS Amount
                    FROM (SELECT * FROM tmpContainer) AS DD
                    WHERE DD.SaleAmount - (DD.ContainerAmountSUM - DD.ContainerAmount) > 0
                   ) AS tmpItem;

    END IF;

        -- !!!Сразу!!! - Результат - проводки кол-во по сроковым документам
    IF EXISTS(SELECT 1 FROM MovementItem AS MIChild
              WHERE MIChild.MovementId = inMovementId
                AND MIChild.DescId     = zc_MI_Child()
                AND MIChild.Amount     > 0
                AND MIChild.isErased   = FALSE)
    THEN
        INSERT INTO _tmpMIContainer_insert (DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate
                                          , ObjectId_analyzer, WhereObjectId_analyzer, AnalyzerId, ObjectIntId_analyzer, Price
                                           )
           -- Результат
           SELECT zc_MIContainer_Count()
                , zc_Movement_Check()
                , inMovementId
                , MI.ParentId
                , COALESCE(Container.ParentId, Container.Id)
                , vbAccountId
                , -1 * MI.Amount
                , vbOperDate
                , MI.ObjectId                    AS ObjectId_analyzer
                , vbUnitId                       AS WhereObjectId_analyzer
                , CASE WHEN Movement.DescId = zc_Movement_Inventory() AND MIFloat_MovementItem.ValueData > 0
                      THEN MIFloat_MovementItem.ValueData :: Integer ELSE MovementItem.Id END AS AnalyzerId
                , (SELECT MIContainer.ObjectIntId_analyzer FROM MovementItemContainer AS MIContainer
                   WHERE MIContainer.MovementItemId =  CASE WHEN Movement.DescId = zc_Movement_Inventory() AND MIFloat_MovementItem.ValueData > 0
                      THEN MIFloat_MovementItem.ValueData :: Integer ELSE MovementItem.Id END
                      AND MIContainer.DescId = zc_MIContainer_Count()
                      AND MIContainer.ObjectIntId_analyzer <> 0 LIMIT 1) AS ObjectIntId_analyzer
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
           WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Child() AND MI.Amount > 0 AND MI.isErased = FALSE;


        INSERT INTO _tmpMIContainer_insert (DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate
                                          , ObjectId_analyzer, WhereObjectId_analyzer, AnalyzerId, ObjectIntId_analyzer, Price
                                           )
           -- Результат
           SELECT zc_MIContainer_CountPartionDate()
                , zc_Movement_Check()
                , inMovementId
                , MI.Id
                , Container.ID
                , NULL
                , -1 * MI.Amount
                , vbOperDate
                , MI.ObjectId                    AS ObjectId_analyzer
                , vbUnitId                       AS WhereObjectId_analyzer
                , CASE WHEN Movement.DescId = zc_Movement_Inventory() AND MIFloat_MovementItem.ValueData > 0
                      THEN MIFloat_MovementItem.ValueData :: Integer ELSE MovementItem.Id END AS AnalyzerId
                , (SELECT MIContainer.ObjectIntId_analyzer FROM MovementItemContainer AS MIContainer
                   WHERE MIContainer.MovementItemId =  CASE WHEN Movement.DescId = zc_Movement_Inventory() AND MIFloat_MovementItem.ValueData > 0
                      THEN MIFloat_MovementItem.ValueData :: Integer ELSE MovementItem.Id END
                      AND MIContainer.DescId = zc_MIContainer_Count()
                      AND MIContainer.ObjectIntId_analyzer <> 0 LIMIT 1) AS ObjectIntId_analyzer
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
                                               ON CLI_MI.ContainerId = Container.ParentId
                                              AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()
                INNER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                -- элемент прихода
                INNER JOIN MovementItem ON MovementItem.Id = Object_PartionMovementItem.ObjectCode
                INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                            ON MIFloat_MovementItem.MovementItemId = MovementItem.Id
                                           AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
           WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Child() AND MI.Amount > 0 AND MI.isErased = FALSE;
    END IF;

     -- 5.1. ФИНИШ - Обязательно сохраняем Проводки
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();

      -- Программа лояльности накопительная накапливаем сумму
     IF COALESCE((SELECT MovementFloat.ValueData
                  FROM MovementFloat
                  WHERE MovementFloat.DescID = zc_MovementFloat_LoyaltySMID()
                    AND MovementFloat.MovementId = inMovementId), 0) <> 0
     THEN
       PERFORM gpUpdate_LoyaltySaveMoney_Summa (inMovementId, MovementFloat_LoyaltySMID.ValueData::INTEGER, inUserId::TVarChar)
       FROM MovementFloat AS MovementFloat_LoyaltySMID
       WHERE MovementFloat_LoyaltySMID.DescID = zc_MovementFloat_LoyaltySMID()
         AND MovementFloat_LoyaltySMID. MovementId = inMovementId;
     END IF;
     
     IF EXISTS(SELECT 1 FROM MovementLinkObject AS MLO_ConfirmedKind
               WHERE MLO_ConfirmedKind.MovementId = inMovementId
                 AND MLO_ConfirmedKind.DescId     = zc_MovementLinkObject_ConfirmedKind()
                 AND MLO_ConfirmedKind.ObjectId   = zc_Enum_ConfirmedKind_Complete())
     THEN
     
       IF NOT EXISTS(SELECT 1 FROM MovementLinkObject 
                     WHERE MovementLinkObject.MovementId            = inMovementId
                       AND MovementLinkObject.DescId                IN (zc_MovementLinkObject_Insert(), zc_MovementLinkObject_UserConfirmedKind())
                       AND COALESCE(MovementLinkObject.ObjectId, 0) <> 0)
       THEN
          -- сохранили свойство <Пользователь (подтверждения) для того чтоб попало в ЗП>
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_UserConfirmedKind(), inMovementId, inUserId);
       END IF;
     END IF;
          
     IF COALESCE (vbDiscountExternalId, 0) <> 0 AND vbSummChangePercent > 0
     THEN
       vbDayCompensDiscount := COALESCE (
           (SELECT ObjectFloat_DayCompensDiscount.ValueData                  AS DayCompensDiscount
            FROM Object AS Object_CashSettings
                 LEFT JOIN ObjectFloat AS ObjectFloat_DayCompensDiscount
                                       ON ObjectFloat_DayCompensDiscount.ObjectId = Object_CashSettings.Id
                                      AND ObjectFloat_DayCompensDiscount.DescId = zc_ObjectFloat_CashSettings_DayCompensDiscount()
            WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
            LIMIT 1), 60);
            
       -- Установим признак Дата компенсации
       PERFORM lpInsertUpdate_MovementDate(zc_MovementDate_Compensation(), inMovementId, DATE_TRUNC ('DAY', vbOperDate)  + (vbDayCompensDiscount||' DAY')::INTERVAL);

     END IF;

     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Check()
                                , inUserId     := inUserId
                                 );
                                 
    IF EXISTS(SELECT * FROM MovementBoolean AS MovementBoolean_CorrectMarketing
              WHERE MovementBoolean_CorrectMarketing.ValueData = True
                AND MovementBoolean_CorrectMarketing.MovementId = inMovementId
                AND MovementBoolean_CorrectMarketing.DescId = zc_MovementBoolean_CorrectMarketing()) 
    THEN
      PERFORM gpInsertUpdate_MovementItem_WagesMarketingRepayment (inMovementID := inMovementId, inSession:= zfCalc_UserAdmin());
    END IF;
    
    IF EXISTS(SELECT * FROM MovementBoolean AS MovementBoolean_CorrectIlliquidMarketing
              WHERE MovementBoolean_CorrectIlliquidMarketing.ValueData = True
                AND MovementBoolean_CorrectIlliquidMarketing.MovementId = inMovementId
                AND MovementBoolean_CorrectIlliquidMarketing.DescId = zc_MovementBoolean_CorrectIlliquidMarketing()) 
    THEN
      PERFORM gpInsertUpdate_MovementItem_WagesIlliquidAssetsRepayment (inMovementID := inMovementId, inSession:= zfCalc_UserAdmin());
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Шаблий О.В.
 06.06.19                                                                   *
 11.02.14                        *
 05.02.14                        *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
--    IN inMovementId        Integer  , -- ключ Документа
--    IN inUserId            Integer    -- Пользователь
-- SELECT * FROM lpComplete_Movement_Check (inMovementId:= 12671, inUserId:= zfCalc_UserAdmin()::Integer)
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM MovementItemContainer WHERE MovementId = 12671`
-- select * from gpUpdate_Status_Check(inMovementId := 19907613 , ioStatusCode := 2 ,  inSession := '3');

--  select * from gpUpdate_Status_Check(inMovementId := 22802944 , ioStatusCode := 2 ,  inSession := '3');