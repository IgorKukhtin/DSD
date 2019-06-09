 -- Function: lpComplete_Movement_Income (Integer, Integer)

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
   DECLARE vbAmount TFloat;
   DECLARE vbAmount_remains TFloat;

   DECLARE curRemains refcursor;
   DECLARE curSale refcursor;
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
    vbOperDate:= (SELECT OperDate FROM Movement WHERE Id = inMovementId);

    -- Определить
    vbAccountId:= lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000()         -- Запасы
                                             , inAccountDirectionId     := zc_Enum_AccountDirection_20100()     -- Cклад 
                                             , inInfoMoneyDestinationId := zc_Enum_InfoMoneyDestination_10200() -- Медикаменты
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId);
    -- Определить
    vbUnitId:= (SELECT MovementLinkObject.ObjectId
                FROM MovementLinkObject 
                WHERE MovementLinkObject.MovementId = inMovementId 
                  AND MovementLinkObject.DescId = zc_MovementLinkObject_Unit());


    -- данные почти все
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpItem_remains'))
    THEN
        -- DELETE FROM _tmpItem_remains;
        DROP TABLE _tmpItem_remains;
        -- таблица - данные почти все
        CREATE TEMP TABLE _tmpItem_remains (MovementItemId_partion Integer, GoodsId Integer, ContainerId Integer, Amount TFloat, OperDate TDateTime) ON COMMIT DROP;
    ELSE
        -- таблица - данные почти все
        CREATE TEMP TABLE _tmpItem_remains (MovementItemId_partion Integer, GoodsId Integer, ContainerId Integer, Amount TFloat, OperDate TDateTime) ON COMMIT DROP;
    END IF;

    -- предварительно сохранили продажи
    INSERT INTO _tmpItem (MovementItemId, ObjectId, OperSumm, Price)
       SELECT MI.Id, MI.ObjectId, MI.Amount, COALESCE (MIFloat_Price.ValueData, 0)
       FROM MovementItem AS MI
            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MI.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
       WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.Amount > 0 AND MI.isErased = FALSE;

    -- предварительно сохранили остаток
    INSERT INTO _tmpItem_remains (MovementItemId_partion, GoodsId, ContainerId, Amount, OperDate)
       SELECT CASE WHEN Movement.DescId = zc_Movement_Inventory() AND MIFloat_MovementItem.ValueData > 0 THEN MIFloat_MovementItem.ValueData :: Integer ELSE MovementItem.Id END AS MovementItemId_partion
            , Container.ObjectId AS GoodsId
            , Container.Id       AS ContainerId
            , Container.Amount
            , Movement.OperDate
       FROM (SELECT DISTINCT ObjectId FROM _tmpItem) AS tmp
            INNER JOIN Container ON Container.DescId = zc_Container_Count()
                                AND Container.WhereObjectId = vbUnitId
                                AND Container.ObjectId = tmp.ObjectId
                                AND Container.Amount > 0
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
           ;


    -- Проверим что б БЫЛ остаток
    IF EXISTS (SELECT 1 FROM (SELECT ObjectId AS GoodsId, SUM (OperSumm) AS Amount FROM _tmpItem GROUP BY ObjectId) AS tmpFrom LEFT JOIN (SELECT _tmpItem_remains.GoodsId, SUM (Amount) AS Amount FROM _tmpItem_remains GROUP BY _tmpItem_remains.GoodsId) AS tmpTo ON tmpTo.GoodsId = tmpFrom.GoodsId WHERE tmpFrom.Amount > COALESCE (tmpTo.Amount, 0))
    THEN
           -- Ошибка расч/факт остаток :
           outMessageText:= '' || (SELECT STRING_AGG (tmp.Value, ' (***) ')
                                    FROM (SELECT '(' || COALESCE (Object.ObjectCode, 0) :: TVarChar || ')' || COALESCE (Object.ValueData, '') || ' в чеке: ' || zfConvert_FloatToString (AmountFrom) || COALESCE (Object_Measure.ValueData, '') || '; остаток: ' || zfConvert_FloatToString (AmountTo) || COALESCE (Object_Measure.ValueData, '') AS Value
                                          FROM (SELECT tmpFrom.GoodsId, tmpFrom.Amount AS AmountFrom, COALESCE (tmpTo.Amount, 0) AS AmountTo FROM (SELECT ObjectId AS GoodsId, SUM (OperSumm) AS Amount FROM _tmpItem GROUP BY ObjectId) AS tmpFrom LEFT JOIN (SELECT _tmpItem_remains.GoodsId, SUM (Amount) AS Amount FROM _tmpItem_remains GROUP BY _tmpItem_remains.GoodsId) AS tmpTo ON tmpTo.GoodsId = tmpFrom.GoodsId WHERE tmpFrom.Amount > COALESCE (tmpTo.Amount, 0)) AS tmp
                                               LEFT JOIN Object ON Object.Id = tmp.GoodsId
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
           IF 1 = 0 OR inUserId <> 3
           THEN
               -- больше ничего не делаем
               RETURN;
           END IF;

     END IF;


    -- !!!Только если товар дублируется - Распределим по старинке!!!
    IF EXISTS (SELECT 1 FROM _tmpItem GROUP BY ObjectId HAVING COUNT (*) > 1)
    THEN
        -- курсор1 - элементы продажи
        OPEN curSale FOR SELECT MovementItemId, ObjectId, OperSumm AS Amount FROM _tmpItem;
        -- начало цикла по курсору1 - возвраты
        LOOP
                -- данные по продажам
                FETCH curSale INTO vbMovementItemId, vbGoodsId, vbAmount;
                -- если данные закончились, тогда выход
                IF NOT FOUND THEN EXIT; END IF;

                -- курсор2. - остатки МИНУС сколько уже распределили для vbGoodsId
                OPEN curRemains FOR
                   SELECT _tmpItem_remains.ContainerId, _tmpItem_remains.MovementItemId_partion, _tmpItem_remains.GoodsId, _tmpItem_remains.Amount - COALESCE (tmp.Amount, 0)
                   FROM _tmpItem_remains
                        LEFT JOIN (SELECT ContainerId, -1 * SUM (_tmpMIContainer_insert.Amount) AS Amount FROM _tmpMIContainer_insert GROUP BY ContainerId
                                  ) AS tmp ON tmp.ContainerId = _tmpItem_remains.ContainerId
                   WHERE _tmpItem_remains.GoodsId = vbGoodsId
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
                                , (SELECT MIContainer.ObjectIntId_analyzer FROM MovementItemContainer AS MIContainer WHERE MIContainer.MovementItemId = vbMovementItemId_partion AND MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.ObjectIntId_analyzer <> 0) AS ObjectIntId_analyzer
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
                                , (SELECT MIContainer.ObjectIntId_analyzer FROM MovementItemContainer AS MIContainer WHERE MIContainer.MovementItemId = vbMovementItemId_partion AND MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.ObjectIntId_analyzer <> 0) AS ObjectIntId_analyzer
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
                                      , SUM (Container.Amount) OVER (PARTITION BY Container.GoodsId ORDER BY Container.OperDate, Container.ContainerId, MI_Sale.MovementItemId) AS ContainerAmountSUM
                                      , ROW_NUMBER() OVER (PARTITION BY /*MI_Sale.ObjectId*/ MI_Sale.MovementItemId ORDER BY Container.OperDate DESC, Container.ContainerId DESC, MI_Sale.MovementItemId DESC) AS DOrd
                                 FROM _tmpItem AS MI_Sale
                                      INNER JOIN _tmpItem_remains AS Container ON Container.GoodsId = MI_Sale.ObjectId
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
                , (SELECT MIContainer.ObjectIntId_analyzer FROM MovementItemContainer AS MIContainer WHERE MIContainer.MovementItemId = tmpItem.MovementItemId_partion AND MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.ObjectIntId_analyzer <> 0) AS ObjectIntId_analyzer
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
    

     -- 5.1. ФИНИШ - Обязательно сохраняем Проводки
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();
    
     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Check()
                                , inUserId     := inUserId
                                 );
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
-- SELECT * FROM MovementItemContainer WHERE MovementId = 12671
