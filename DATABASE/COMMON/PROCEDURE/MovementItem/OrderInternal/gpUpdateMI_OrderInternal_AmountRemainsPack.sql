-- Function: gpUpdateMI_OrderInternal_AmountRemainsPack()

DROP FUNCTION IF EXISTS gpUpdateMI_OrderInternal_AmountRemainsPack (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMI_OrderInternal_AmountRemainsPack(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inOperDate            TDateTime , -- Дата документа
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId  Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderInternal());

-- if vbUserId <> 5 THEN RAISE EXCEPTION 'Ошибка.Повторите действие через 15 мин';end if;

    -- проверка уникальности
    IF COALESCE(inOperDate, zc_DateStart()) <> COALESCE((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId), zc_DateEnd())
    THEN
        RAISE EXCEPTION 'Ошибка.Дата документа <%> не сохранена.<%>', inOperDate, (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);
    END IF;

if vbUserId = 5 AND 1=1
then
    inOperDate:= CURRENT_DATE;
end if;

    -- !!!пересчет Рецептур, временно захардкодил!!!
    PERFORM lpUpdate_Object_Receipt_Parent (0, 0, 0);

    -- таблица
    CREATE TEMP TABLE tmpContainer (ContainerId Integer, GoodsId Integer, GoodsKindId Integer, Amount_start TFloat, AmountRK_start TFloat, AmountPrIn TFloat) ON COMMIT DROP;
    CREATE TEMP TABLE tmpAll (MovementItemId Integer, ContainerId Integer, GoodsId Integer, GoodsKindId Integer, Amount_start TFloat, AmountRK_start TFloat, AmountPrIn TFloat) ON COMMIT DROP;


    -- Остатки кол-во для всех подразделений
    INSERT INTO tmpContainer (ContainerId, GoodsId, GoodsKindId, Amount_start, AmountRK_start, AmountPrIn)
       WITH -- хардкодим - ЦЕХ колбаса+дел-сы (производство)
            tmpUnit_CEH AS (SELECT UnitId, TRUE AS isContainer FROM lfSelect_Object_Unit_byGroup (8446) AS lfSelect_Object_Unit_byGroup)
            -- хардкодим - Склады База + Склад Поклейки этикетки
          , tmpUnit_SKLAD   AS (SELECT lfSelect.UnitId, FALSE AS isContainer FROM lfSelect_Object_Unit_byGroup (8457) AS lfSelect
                                WHERE lfSelect.UnitId <> 9558031 -- Склад Неликвид
                               UNION
                                -- Склад Поклейки этикетки
                                SELECT 9073781 AS UnitId, FALSE AS isContainer
                               )
            -- Склад Реализации
          , tmpUnit_RK AS (SELECT 8459 AS UnitId)

            -- хардкодим - ВСЕ
          , tmpUnit_all   AS (SELECT UnitId, isContainer FROM tmpUnit_CEH UNION SELECT UnitId, isContainer FROM tmpUnit_SKLAD)
            -- хардкодим - товары ГП
          , tmpGoods AS (SELECT ObjectLink_Goods_InfoMoney.ObjectId AS GoodsId
                              , Object_InfoMoney_View.InfoMoneyDestinationId
                              , Object_InfoMoney_View.InfoMoneyId
                         FROM Object_InfoMoney_View
                              LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                   ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                                  AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                         WHERE (Object_InfoMoney_View.InfoMoneyId            = zc_Enum_InfoMoney_30101()            -- Доходы + Продукция + Готовая продукция
                             OR Object_InfoMoney_View.InfoMoneyId            = zc_Enum_InfoMoney_30201()            -- Доходы + Мясное сырье + Мясное сырье
                             OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
                               )
                        )
       -- Результат - остатки товары ГП
       SELECT tmp.ContainerId
            , tmp.GoodsId
            , tmp.GoodsKindId
            , SUM (tmp.Amount_start + CASE WHEN tmp.ContainerId > 0 THEN tmp.Amount_next ELSE 0 END) AS Amount_start
            , SUM (tmp.AmountRK_start) AS AmountRK_start
            , SUM (tmp.AmountPrIn) AS AmountPrIn
       FROM (SELECT CASE WHEN tmpUnit_all.isContainer = TRUE THEN Container.Id ELSE 0 END AS ContainerId
                  , Container.ObjectId                   AS GoodsId
                  , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
                    --
                  , Container.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) AS Amount_start
                    --
                  , CASE WHEN tmpUnit_RK.UnitId > 0 THEN Container.Amount ELSE 0 END - SUM (CASE WHEN tmpUnit_RK.UnitId > 0 THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS AmountRK_start
                    --
                  , SUM (CASE WHEN MIContainer.OperDate = inOperDate AND MIContainer.isActive = TRUE THEN MIContainer.Amount ELSE 0 END) AS Amount_next
                  , SUM (CASE WHEN MIContainer.OperDate = inOperDate AND MIContainer.isActive = TRUE
                               AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                               AND tmpUnit_CEH.UnitId > 0 AND tmpUnit_SKLAD.UnitId > 0
                                   THEN MIContainer.Amount
                              ELSE 0
                         END) AS AmountPrIn
             FROM tmpGoods
                  INNER JOIN Container ON Container.ObjectId = tmpGoods.GoodsId
                                      AND Container.DescId   = zc_Container_Count()
                  INNER JOIN ContainerLinkObject AS CLO_Unit
                                                 ON CLO_Unit.ContainerId = Container.Id
                                                AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                  INNER JOIN tmpUnit_all ON tmpUnit_all.UnitId = CLO_Unit.ObjectId

                  LEFT JOIN ContainerLinkObject AS CLO_Account
                                                ON CLO_Account.ContainerId = Container.Id
                                               AND CLO_Account.DescId      = zc_ContainerLinkObject_Account()
                  LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                ON CLO_GoodsKind.ContainerId = Container.Id
                                               AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()

                  LEFT JOIN MovementItemContainer AS MIContainer
                                                  ON MIContainer.ContainerId = Container.Id
                                                 AND MIContainer.OperDate    >= inOperDate

                  -- ЦЕХ колбаса+дел-сы
                  LEFT JOIN tmpUnit_CEH   ON tmpUnit_CEH.UnitId   = CLO_Unit.ObjectId
                  -- Склады База + Реализации
                  LEFT JOIN tmpUnit_SKLAD ON tmpUnit_SKLAD.UnitId = CLO_Unit.ObjectId
                  -- Склад Реализации
                  LEFT JOIN tmpUnit_RK ON tmpUnit_RK.UnitId = CLO_Unit.ObjectId


             WHERE CLO_Account.ContainerId IS NULL -- !!!т.е. без счета Транзит!!!
             GROUP BY CASE WHEN tmpUnit_all.isContainer = TRUE THEN Container.Id ELSE 0 END
                    , Container.ObjectId
                    , COALESCE (CLO_GoodsKind.ObjectId, 0)
                    , Container.Amount
                    , tmpUnit_RK.UnitId
             HAVING Container.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) <> 0
                 OR SUM (CASE WHEN MIContainer.OperDate = inOperDate AND MIContainer.isActive = TRUE THEN MIContainer.Amount ELSE 0 END) <> 0
            ) AS tmp
       GROUP BY tmp.ContainerId
              , tmp.GoodsId
              , tmp.GoodsKindId
      ;

    --
    -- объединение существующих элементов документа + остатки
    INSERT INTO tmpAll (MovementItemId, ContainerId, GoodsId, GoodsKindId, Amount_start, AmountRK_start, AmountPrIn)
       WITH -- существующие элементы документа
            tmpMI AS (SELECT MovementItem.Id                               AS MovementItemId
                           , MovementItem.ObjectId                         AS GoodsId
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                           , MovementItem.Amount                           AS Amount
                           , COALESCE (MIFloat_ContainerId.ValueData, 0) :: Integer AS ContainerId
                      FROM MovementItem
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                           LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                       ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                      AND MIFloat_ContainerId.DescId         = zc_MIFloat_ContainerId()
                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                     )
    -- Не упаковывать
  , tmpGoodsByGoodsKind_not AS (SELECT ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId          AS GoodsId
                                     , ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId      AS GoodsKindId
                                FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                     JOIN Object AS Object_GoodsByGoodsKind
                                                 ON Object_GoodsByGoodsKind.Id       = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                AND Object_GoodsByGoodsKind.isErased = FALSE
                                     JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                     ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                    AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                     JOIN ObjectBoolean AS ObjectBoolean_NotPack
                                                        ON ObjectBoolean_NotPack.ObjectId  = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                       AND ObjectBoolean_NotPack.DescId    = zc_ObjectBoolean_GoodsByGoodsKind_NotPack()
                                                       AND ObjectBoolean_NotPack.ValueData = TRUE
                                WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId   = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                  AND ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId <> zc_GoodsKind_Basis()
                                --AND 1=0
                               )
       -- результат - для SKLAD
       SELECT tmp.MovementItemId
            , tmp.ContainerId
            , tmp.GoodsId
            , tmp.GoodsKindId
            , SUM (tmp.Amount_start)   AS Amount_start
            , SUM (tmp.AmountRK_start) AS AmountRK_start
            , SUM (tmp.AmountPrIn)     AS AmountPrIn
       FROM (SELECT COALESCE (tmpMI.MovementItemId, 0)                      AS MovementItemId
                  , 0                                                       AS ContainerId
                  , COALESCE (tmpContainer.GoodsId,      tmpMI.GoodsId)     AS GoodsId
                  , COALESCE (tmpContainer.GoodsKindId,  tmpMI.GoodsKindId) AS GoodsKindId
                  , COALESCE (tmpContainer.Amount_start, 0)                 AS Amount_start
                  , COALESCE (tmpContainer.AmountRK_start, 0)               AS AmountRK_start
                  , COALESCE (tmpContainer.AmountPrIn, 0)                   AS AmountPrIn
             FROM (SELECT * FROM tmpContainer WHERE tmpContainer.ContainerId = 0
                  ) AS tmpContainer
                  FULL JOIN (SELECT * FROM tmpMI WHERE tmpMI.ContainerId = 0
                            ) AS tmpMI ON tmpMI.GoodsId     = tmpContainer.GoodsId
                                      AND tmpMI.GoodsKindId = tmpContainer.GoodsKindId
            ) AS tmp
            LEFT JOIN tmpGoodsByGoodsKind_not ON tmpGoodsByGoodsKind_not.GoodsId     = tmp.GoodsId
                                             AND tmpGoodsByGoodsKind_not.GoodsKindId = tmp.GoodsKindId
       WHERE tmpGoodsByGoodsKind_not.GoodsId IS NULL
       GROUP BY tmp.MovementItemId
              , tmp.ContainerId
              , tmp.GoodsId
              , tmp.GoodsKindId

      UNION ALL
        -- Обнулили
       SELECT tmpMI.MovementItemId
            , tmpMI.ContainerId
            , tmpMI.GoodsId
            , tmpMI.GoodsKindId
            , 0 AS Amount_start
            , 0 AS AmountRK_start
            , 0 AS AmountPrIn
       FROM tmpMI
            INNER JOIN tmpGoodsByGoodsKind_not ON tmpGoodsByGoodsKind_not.GoodsId     = tmpMI.GoodsId
                                              AND tmpGoodsByGoodsKind_not.GoodsKindId = tmpMI.GoodsKindId

      UNION ALL
       -- результат - для CEH
       SELECT tmp.MovementItemId
            , tmp.ContainerId
            , tmp.GoodsId
            , tmp.GoodsKindId
            ,  (tmp.Amount_start)   AS Amount_start
            ,  (tmp.AmountRK_start) AS AmountRK_start
            ,  (tmp.AmountPrIn)     AS AmountPrIn
       FROM (SELECT tmpMI.MovementItemId
                  , COALESCE (tmpContainer.ContainerId,  tmpMI.ContainerId) AS ContainerId
                  , COALESCE (tmpContainer.GoodsId,      tmpMI.GoodsId)     AS GoodsId
                  , COALESCE (tmpContainer.GoodsKindId,  tmpMI.GoodsKindId) AS GoodsKindId
                  , COALESCE (tmpContainer.Amount_start, 0)                 AS Amount_start
                  , 0                                                       AS AmountRK_start
                  , 0                                                       AS AmountPrIn
             FROM (SELECT * FROM tmpContainer WHERE tmpContainer.ContainerId > 0
                  ) AS tmpContainer
                  FULL JOIN (SELECT * FROM tmpMI WHERE tmpMI.ContainerId > 0
                            ) AS tmpMI ON tmpMI.ContainerId = tmpContainer.ContainerId
            ) AS tmp
            LEFT JOIN tmpGoodsByGoodsKind_not ON tmpGoodsByGoodsKind_not.GoodsId     = tmp.GoodsId
                                             AND tmpGoodsByGoodsKind_not.GoodsKindId = tmp.GoodsKindId
       WHERE tmpGoodsByGoodsKind_not.GoodsId IS NULL
      ;

--    RAISE EXCEPTION '<%>', (select count(*) from tmpAll where tmpAll.ContainerId = 0 and tmpAll.GoodsId = 593238 and tmpAll.GoodsKindId = 8335);

     IF EXISTS (SELECT 1 FROM tmpAll WHERE tmpAll.ContainerId > 0 AND tmpAll.GoodsKindId = zc_GoodsKind_Basis()) --  AND tmpAll.Amount_start <> 0
        AND 1=0
     THEN
         RAISE EXCEPTION 'Ошибка. Найден остаток = <%> для <%> <%> для подразделения = <%>.(%)'
         , (SELECT zfConvert_FloatToString (tmpAll.Amount_start) FROM tmpAll WHERE tmpAll.ContainerId > 0 AND tmpAll.GoodsKindId = zc_GoodsKind_Basis() ORDER BY tmpAll.ContainerId LIMIT 1)
         , (SELECT lfGet_Object_ValueData (tmpAll.GoodsId) FROM tmpAll WHERE tmpAll.ContainerId > 0 AND tmpAll.GoodsKindId = zc_GoodsKind_Basis() ORDER BY tmpAll.ContainerId LIMIT 1)
         , (SELECT lfGet_Object_ValueData_sh (tmpAll.GoodsKindId) FROM tmpAll WHERE tmpAll.ContainerId > 0 AND tmpAll.GoodsKindId = zc_GoodsKind_Basis() ORDER BY tmpAll.ContainerId LIMIT 1)
         , (SELECT lfGet_Object_ValueData_sh (CLO_Unit.ObjectId)
            FROM tmpAll
                 JOIN  ContainerLinkObject AS CLO_Unit
                                           ON CLO_Unit.ContainerId = tmpAll.ContainerId
                                          AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
            WHERE tmpAll.ContainerId > 0 AND tmpAll.GoodsKindId = zc_GoodsKind_Basis()
            ORDER BY tmpAll.ContainerId
            LIMIT 1
           )
         , (SELECT tmpAll.ContainerId FROM tmpAll WHERE tmpAll.ContainerId > 0 AND tmpAll.GoodsKindId = zc_GoodsKind_Basis() ORDER BY tmpAll.ContainerId LIMIT 1)
          ;
     END IF;


/*
if inSession = '5'
then
    RAISE EXCEPTION 'Ошибка.<%>  %   %', (select min (tmpAll.Amount_start) from tmpAll where tmpAll.GoodsId = 2062)
    , (select count (*) from tmpAll where tmpAll.GoodsId = 2062 and tmpAll.Amount_start<> 0)
    , (select max (tmpAll.ContainerId) from tmpAll where tmpAll.GoodsId = 2062)
    ;
end if;
*/
    -- сохранили св-ва для zc_MI_Master
    PERFORM lpUpdate_MI_OrderInternal_Property (ioId                 := tmpAll.MovementItemId
                                              , inMovementId         := inMovementId
                                              , inGoodsId            := tmpAll.GoodsId
                                              , inGoodsKindId        := tmpAll.GoodsKindId
                                              , inAmount_Param       := tmpAll.Amount_start
                                              , inDescId_Param       := zc_MIFloat_AmountRemains()
                                              , inAmount_ParamOrder  := tmpAll.ContainerId
                                              , inDescId_ParamOrder  := zc_MIFloat_ContainerId()
                                              , inAmount_ParamSecond := tmpAll.AmountPrIn
                                              , inDescId_ParamSecond := zc_MIFloat_AmountPrIn()
                                              , inAmount_ParamAdd          := 0
                                              , inDescId_ParamAdd          := 0
                                              , inAmount_ParamNext         := 0
                                              , inDescId_ParamNext         := 0
                                              , inAmount_ParamNextPromo    := 0
                                              , inDescId_ParamNextPromo    := 0
                                              , inAmountRK_start     := COALESCE (tmpAll.AmountRK_start, 0)
                                              , inIsPack             := NULL -- что б не формировать св-ва
                                              , inUserId             := vbUserId
                                               )
    FROM tmpAll;

if vbUserId = 5 AND 1=0
then
    RAISE EXCEPTION 'Ошибка. end <%>  %   %', (select sum (tmpAll.Amount_start) from tmpAll where tmpAll.GoodsId = 6749 and tmpAll.GoodsKindId = 8352)
    , (select sum (tmpAll.AmountRK_start) from tmpAll) -- where tmpAll.GoodsId = 6749 and tmpAll.GoodsKindId = 8352)
    , (select (tmpAll.AmountRK_start) from tmpAll where tmpAll.MovementItemId =  253571013 )
    ;
end if;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.10.17                                        *
*/

-- тест
-- SELECT * FROM gpUpdateMI_OrderInternal_AmountRemainsPack (inMovementId:= 7448208, inOperDate:= '31.10.2017', inSession:= zfCalc_UserAdmin());
