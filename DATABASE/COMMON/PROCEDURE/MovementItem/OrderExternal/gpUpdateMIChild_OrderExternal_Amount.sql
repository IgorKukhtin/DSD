-- Function: gpUpdateMIChild_OrderExternal_Amount()

DROP FUNCTION IF EXISTS gpUpdateMIChild_OrderExternal_Amount (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdateMIChild_OrderExternal_Amount(
    IN inMovementId      Integer      , -- ключ Документа
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbUnitId   Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderExternal_child());


      -- сохранили свойство <Был сформирован резерв> - да
      PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Remains(), inMovementId, TRUE);


      -- данные из документа
      SELECT CASE WHEN EXTRACT (HOUR FROM MovementDate_CarInfo.ValueData) < 8
                       THEN DATE_TRUNC ('DAY', MovementDate_CarInfo.ValueData) - INTERVAL '1 DAY'
                  ELSE DATE_TRUNC ('DAY', COALESCE (MovementDate_CarInfo.ValueData, MovementDate_OperDatePartner.ValueData))
             END              AS OperDate
           , MLO_To.ObjectId  AS UnitId
             INTO vbOperDate, vbUnitId
      FROM Movement
           LEFT JOIN MovementLinkObject AS MLO_To
                                        ON MLO_To.MovementId = Movement.Id
                                       AND MLO_To.DescId     = zc_MovementLinkObject_To()
           LEFT JOIN MovementDate AS MovementDate_CarInfo
                                  ON MovementDate_CarInfo.MovementId = Movement.Id
                                 AND MovementDate_CarInfo.DescId     = zc_MovementDate_CarInfo()
           LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                  ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                 AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
      WHERE Movement.Id = inMovementId;

      -- данные из мастера + остатки и данные из чайлдов др. док.
      IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE '_tmpMIMaster')
      THEN
          DELETE FROM _tmpMIMaster;
      ELSE
          CREATE TEMP TABLE _tmpMIMaster (Id Integer, GoodsId Integer, GoodsKindId Integer, GoodsId_sub Integer, GoodsKindId_sub Integer, Amount_res_orig TFloat, Amount_orig TFloat, Remains_orig TFloat, Amount_diff_orig TFloat, Amount_sub TFloat, Remains TFloat, Amount_diff TFloat) ON COMMIT DROP;
      END IF;

      --
      WITH 
           tmpGoodsByGoodsKind AS (SELECT Object_GoodsByGoodsKind_View.GoodsId
                                        , Object_GoodsByGoodsKind_View.GoodsKindId
                                          -- из чего будем подставлять
                                        , ObjectLink_GoodsByGoodsKind_GoodsSub.ChildObjectId      AS GoodsId_sub
                                        , ObjectLink_GoodsByGoodsKind_GoodsKindSub.ChildObjectId  AS GoodsKindId_sub
                                   FROM Object_GoodsByGoodsKind_View
                                        LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsSub
                                                             ON ObjectLink_GoodsByGoodsKind_GoodsSub.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                            AND ObjectLink_GoodsByGoodsKind_GoodsSub.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsSub()
                                        LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKindSub
                                                             ON ObjectLink_GoodsByGoodsKind_GoodsKindSub.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                            AND ObjectLink_GoodsByGoodsKind_GoodsKindSub.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKindSub()
                                   WHERE ObjectLink_GoodsByGoodsKind_GoodsSub.ChildObjectId     > 0
                                     AND ObjectLink_GoodsByGoodsKind_GoodsKindSub.ChildObjectId > 0
                                  )
            -- Заявка - текущая
          , tmpMI AS (SELECT MovementItem.Id
                             --
                           , MovementItem.ObjectId                         AS GoodsId
                             --
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                             --
                           , ObjectLink_Goods_Measure.ChildObjectId        AS MeasureId
                           , COALESCE (ObjectFloat_Weight.ValueData, 0)    AS Weight
                             --
                           , ObjectLink_Goods_Measure_sub.ChildObjectId    AS MeasureId_sub
                           , COALESCE (ObjectFloat_Weight_sub.ValueData, 0)AS Weight_sub
                             -- шт
                           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (MovementItem.Amount, 0) + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END AS Amount_sh
                             -- вес
                           , (COALESCE (MovementItem.Amount, 0) + COALESCE (MIFloat_AmountSecond.ValueData, 0))
                           * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                             AS Amount_Weight

                             -- Заявка - НЕ переводим в ед.изм. - MeasureId_sub
                           , MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) AS Amount

                             --
                           , COALESCE (tmpGoodsByGoodsKind.GoodsId_sub, MovementItem.ObjectId)                  AS GoodsId_sub
                           , COALESCE (tmpGoodsByGoodsKind.GoodsKindId_sub, MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId_sub

                      FROM MovementItem
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                           LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                       ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountSecond.DescId         = zc_MIFloat_AmountSecond()
                           LEFT JOIN tmpGoodsByGoodsKind ON tmpGoodsByGoodsKind.GoodsId     = MovementItem.ObjectId
                                                        AND tmpGoodsByGoodsKind.GoodsKindId = MILinkObject_GoodsKind.ObjectId
                           LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                               AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
                           LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                 ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                                AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure_sub
                                                ON ObjectLink_Goods_Measure_sub.ObjectId = COALESCE (tmpGoodsByGoodsKind.GoodsId_sub, MovementItem.ObjectId)
                                               AND ObjectLink_Goods_Measure_sub.DescId   = zc_ObjectLink_Goods_Measure()
                           LEFT JOIN ObjectFloat AS ObjectFloat_Weight_sub
                                                 ON ObjectFloat_Weight_sub.ObjectId = COALESCE (tmpGoodsByGoodsKind.GoodsId_sub, MovementItem.ObjectId)
                                                AND ObjectFloat_Weight_sub.DescId   = zc_ObjectFloat_Goods_Weight()

                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                        AND COALESCE (MovementItem.Amount, 0) + COALESCE (MIFloat_AmountSecond.ValueData, 0) > 0
                     )
        -- ВСЕ заявки, в которых есть Резерв !!!для остатка!!! за эту "смену" или позже + !!!"прошлый" день!!!
      , tmpMIChild_All AS (SELECT MovementItem.Id                               AS MovementItemId
                                , MovementItem.ObjectId                         AS GoodsId_sub
                                , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId_sub
                                  -- весь резерв: с остатка+перемещение
                                , COALESCE (MovementItem.Amount,0)              AS Amount
                           FROM Movement
                                INNER JOIN MovementDate AS MovementDate_CarInfo
                                                        ON MovementDate_CarInfo.MovementId = Movement.Id
                                                       AND MovementDate_CarInfo.DescId     = zc_MovementDate_CarInfo()
                                                       -- за эту "смену" или позже
                                                       AND MovementDate_CarInfo.ValueData  >= vbOperDate + INTERVAL '8 HOUR'
                                -- на этот склад
                                INNER JOIN MovementLinkObject AS MLO_To
                                                              ON MLO_To.MovementId = Movement.Id
                                                             AND MLO_To.DescId     = zc_MovementLinkObject_To()
                                                             AND MLO_To.ObjectId   = vbUnitId
                                -- Элемент Резерв
                                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId     = zc_MI_Child()
                                                       AND MovementItem.isErased   = FALSE
                                                       AND MovementItem.Amount     > 0
                                -- Элемент заявки не удален
                                INNER JOIN MovementItem AS MovementItem_parent
                                                        ON MovementItem_parent.MovementId = Movement.Id
                                                       AND MovementItem_parent.DescId     = zc_MI_Master()
                                                       AND MovementItem_parent.Id         = MovementItem.ParentId
                                                       AND MovementItem_parent.isErased   = FALSE
                                                    --AND MovementItem_parent.Amount + COALESCE (MIFloat_AmountSecond_parent.ValueData, 0) > 0
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                 ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                -- Только для "товаров" из текущей заявки
                                INNER JOIN (SELECT DISTINCT tmpMI.GoodsId_sub, tmpMI.GoodsKindId_sub FROM tmpMI
                                           UNION
                                            -- плюс в случае пересорта, исходный товар
                                            SELECT DISTINCT tmpMI.GoodsId AS GoodsId_sub, tmpMI.GoodsKindId AS GoodsKindId_sub FROM tmpMI
                                           ) AS tmpGoods
                                             ON tmpGoods.GoodsId_sub     = MovementItem.ObjectId
                                            AND tmpGoods.GoodsKindId_sub = MILinkObject_GoodsKind.ObjectId
                           WHERE Movement.DescId   = zc_Movement_OrderExternal()
                             AND Movement.StatusId = zc_Enum_Status_Complete()
                             -- !!!Не текущий документ!!!
                             AND Movement.Id      <> inMovementId

                          UNION ALL
                          -- Предыдущие заявки - "прошлый" день
                           SELECT MovementItem.Id                               AS MovementItemId
                                , MovementItem.ObjectId                         AS GoodsId_sub
                                , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId_sub
                                  -- весь резерв: с остатка+перемещение
                                , COALESCE (MovementItem.Amount,0)              AS Amount
                           FROM Movement
                                INNER JOIN MovementDate AS MovementDate_CarInfo
                                                        ON MovementDate_CarInfo.MovementId = Movement.Id
                                                       AND MovementDate_CarInfo.DescId     = zc_MovementDate_CarInfo()
                                                       -- за !!!Предыдущую!!! "смену"
                                                       AND MovementDate_CarInfo.ValueData  >= CURRENT_DATE + INTERVAL '8 HOUR'
                                                       AND MovementDate_CarInfo.ValueData  < vbOperDate + INTERVAL '8 HOUR'
                                                       -- если ???точно??? не отгружена
                                                       AND MovementDate_CarInfo.ValueData  < CURRENT_TIMESTAMP
                                -- на этот склад
                                INNER JOIN MovementLinkObject AS MLO_To
                                                              ON MLO_To.MovementId = Movement.Id
                                                             AND MLO_To.DescId     = zc_MovementLinkObject_To()
                                                             AND MLO_To.ObjectId   = vbUnitId
                                -- Элемент Резерв
                                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId     = zc_MI_Child()
                                                       AND MovementItem.isErased   = FALSE
                                                       AND MovementItem.Amount     > 0
                                -- Элемент заявки не удален
                                INNER JOIN MovementItem AS MovementItem_parent
                                                        ON MovementItem_parent.MovementId = Movement.Id
                                                       AND MovementItem_parent.DescId     = zc_MI_Master()
                                                       AND MovementItem_parent.Id         = MovementItem.ParentId
                                                       AND MovementItem_parent.isErased   = FALSE
                                                    --AND MovementItem_parent.Amount + COALESCE (MIFloat_AmountSecond_parent.ValueData, 0) > 0
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                 ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                -- Только для "товаров" из текущей заявки
                                INNER JOIN (SELECT DISTINCT tmpMI.GoodsId_sub, tmpMI.GoodsKindId_sub FROM tmpMI
                                           UNION
                                            -- плюс в случае пересорта, исходный товар
                                            SELECT DISTINCT tmpMI.GoodsId AS GoodsId_sub, tmpMI.GoodsKindId AS GoodsKindId_sub FROM tmpMI
                                           ) AS tmpGoods
                                             ON tmpGoods.GoodsId_sub      = MovementItem.ObjectId
                                            AND tmpGoods.GoodsKindId_sub = MILinkObject_GoodsKind.ObjectId
                           WHERE Movement.DescId   = zc_Movement_OrderExternal()
                             AND Movement.StatusId = zc_Enum_Status_Complete()
                             -- !!!Не текущий документ!!!
                             AND Movement.Id      <> inMovementId
                          )
        , tmpMI_Float AS (SELECT MIF.MovementItemId, MIF.DescId, MIF.ValueData :: Integer AS MovementId
                          FROM MovementItemFloat AS MIF
                          WHERE MIF.MovementItemId IN (SELECT DISTINCT tmpMIChild_All.MovementItemId FROM tmpMIChild_All)
                            AND MIF.DescId         = zc_MIFloat_MovementId()
                            AND MIF.ValueData      > 0
                         )
            -- заявки, в которых есть Резерв за эту "смену" или позже
          , tmpMIChild AS (SELECT tmpMIChild_All.GoodsId_sub
                                , tmpMIChild_All.GoodsKindId_sub
                                , SUM (tmpMIChild_All.Amount) AS Amount
                           FROM tmpMIChild_All
                                LEFT JOIN tmpMI_Float AS MIFloat_Movement
                                                      ON MIFloat_Movement.MovementItemId = tmpMIChild_All.MovementItemId
                                                     AND MIFloat_Movement.DescId         = zc_MIFloat_MovementId()
                                LEFT JOIN Movement ON Movement.Id = MIFloat_Movement.MovementId
                                                  AND Movement.OperDate < vbOperDate
                           -- если это резерев НЕ с внутреннего перемещения !!!за сегодня!!!, прошлые перемещения - можно
                           WHERE Movement.Id IS NULL
                           GROUP BY tmpMIChild_All.GoodsId_sub
                                  , tmpMIChild_All.GoodsKindId_sub
                          )
    -- Остатки
  , tmpContainer_all AS (SELECT Container.Id       AS ContainerId
                              , Container.ObjectId AS GoodsId_sub
                              , Container.Amount
                         FROM Container
                              INNER JOIN ContainerLinkObject AS CLO_Unit
                                                             ON CLO_Unit.ContainerId = Container.Id
                                                            AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                            AND CLO_Unit.ObjectId    = vbUnitId
                              -- Только для "товаров" из текущей заявки
                              INNER JOIN (SELECT DISTINCT tmpMI.GoodsId_sub FROM tmpMI
                                         UNION
                                          -- плюс в случае пересорта, исходный товар
                                          SELECT DISTINCT tmpMI.GoodsId AS GoodsId_sub FROM tmpMI
                                         ) AS tmpGoods ON tmpGoods.GoodsId_sub = Container.ObjectId

                              LEFT JOIN ContainerLinkObject AS CLO_Account
                                                            ON CLO_Account.ContainerId = CLO_Unit.ContainerId
                                                           AND CLO_Account.DescId = zc_ContainerLinkObject_Account()

                         WHERE Container.DescId = zc_Container_Count()
                           AND CLO_Account.ContainerId IS NULL -- !!!т.е. без счета Транзит!!!
                        )
      , tmpCLO_GoodsKind_rem AS (SELECT CLO_GoodsKind.*
                                 FROM ContainerLinkObject AS CLO_GoodsKind
                                 WHERE CLO_GoodsKind.ContainerId IN (SELECT DISTINCT tmpContainer_all.ContainerId FROM tmpContainer_all)
                                   AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                )
        -- Остатки
      , tmpContainer AS (SELECT tmpContainer_all.ContainerId      AS ContainerId
                              , tmpContainer_all.GoodsId_sub      AS GoodsId_sub
                              , tmpCLO_GoodsKind_rem.ObjectId     AS GoodsKindId_sub
                              , tmpContainer_all.Amount
                         FROM tmpContainer_all
                              INNER JOIN tmpCLO_GoodsKind_rem ON tmpCLO_GoodsKind_rem.ContainerId = tmpContainer_all.ContainerId
                                                             AND tmpCLO_GoodsKind_rem.DescId      = zc_ContainerLinkObject_GoodsKind()
                              -- Только для "товаров" из текущей заявки
                              INNER JOIN (SELECT DISTINCT tmpMI.GoodsId_sub, tmpMI.GoodsKindId_sub FROM tmpMI
                                         UNION
                                          -- плюс в случае пересорта, исходный товар
                                          SELECT DISTINCT tmpMI.GoodsId AS GoodsId_sub, tmpMI.GoodsKindId AS GoodsKindId_sub FROM tmpMI
                                         ) AS tmpGoods
                                           ON tmpGoods.GoodsId_sub      = tmpContainer_all.GoodsId_sub
                                          AND tmpGoods.GoodsKindId_sub = tmpCLO_GoodsKind_rem.ObjectId
                         )
        -- Остаток на дату
      , tmpRemains AS (SELECT tmpContainer.GoodsId_sub
                            , tmpContainer.GoodsKindId_sub
                            , tmpContainer.Amount - SUM (COALESCE (MIContainer.Amount, 0)) AS Amount
                       FROM tmpContainer
                            LEFT JOIN tmpCLO_GoodsKind_rem AS CLO_GoodsKind
                                                           ON CLO_GoodsKind.ContainerId = tmpContainer.ContainerId
                                                          AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                            LEFT JOIN MovementItemContainer AS MIContainer
                                                            ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                           AND MIContainer.OperDate >= vbOperDate
                       GROUP BY tmpContainer.GoodsId_sub
                              , tmpContainer.GoodsKindId_sub
                              , tmpContainer.Amount
                       HAVING tmpContainer.Amount - SUM (COALESCE (MIContainer.Amount, 0)) > 0
                      )
     -- Заявка - сгруппировали - без учета пересорта
   , tmpMI_group_orig AS (SELECT SUM (tmpMI.Amount) AS Amount
                                 --
                               , tmpMI.GoodsId
                               , tmpMI.GoodsKindId
                          FROM tmpMI
                          GROUP BY tmpMI.GoodsId
                                 , tmpMI.GoodsKindId
                         )
    -- первый Результат - без учета пересорта
  , tmpRes_one_all AS (SELECT tmpMI.Id
                            , tmpMI.GoodsId
                            , tmpMI.GoodsKindId
                            , tmpMI.GoodsId_sub
                            , tmpMI.GoodsKindId_sub
           
                            , tmpMI.MeasureId  AS MeasureId_orig
                            , tmpMI.Weight     AS Weight_orig
                             --
                            , tmpMI.MeasureId_sub
                            , tmpMI.Weight_sub

                              -- Заявка - НЕ в ед.изм. MeasureId_sub
                            , tmpMI.Amount AS Amount_orig
           
                              -- Весь Остаток начальный - НЕ пропорционально - ИНФОРМАТИВНО ВСЕ
                            , COALESCE (tmpRemains.Amount, 0) /** CASE WHEN tmpMI_group.Amount > tmpMI.Amount THEN tmpMI.Amount / tmpMI_group.Amount ELSE 1 END*/
                              AS Remains_orig

                              -- "свободный" Остаток для Резерв - распределяется пропорционально
                            , (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMIChild.Amount, 0)) 
                            * CASE WHEN tmpMI_group.Amount > tmpMI.Amount THEN tmpMI.Amount / tmpMI_group.Amount ELSE 1 END
                              AS Amount_diff_orig
           
                              -- Заказ - Резерв с остатка
                            , CASE -- если "свободного" остатка хватает, тогда резерв ВЕСЬ заказ
                                   WHEN (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMIChild.Amount, 0)) 
                                      * CASE WHEN tmpMI_group.Amount > tmpMI.Amount THEN tmpMI.Amount / tmpMI_group.Amount ELSE 1 END
                                      >= COALESCE (tmpMI.Amount,0)

                                        THEN COALESCE (tmpMI.Amount,0)

                                   -- здесь только "свободный" остаток
                                   WHEN (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMIChild.Amount, 0)) 
                                      * CASE WHEN tmpMI_group.Amount > tmpMI.Amount THEN tmpMI.Amount / tmpMI_group.Amount ELSE 1 END
                                      > 0 
                                        THEN (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMIChild.Amount, 0)) 
                                           * CASE WHEN tmpMI_group.Amount > tmpMI.Amount THEN tmpMI.Amount / tmpMI_group.Amount ELSE 1 END

                                   -- иначе 0
                                   ELSE 0
                              END AS Amount_res_orig
                                                                            
                       FROM tmpMI
                            -- итого по текущим товарам, для пропорции
                            LEFT JOIN tmpMI_group_orig AS tmpMI_group
                                                       ON tmpMI_group.GoodsId     = tmpMI.GoodsId
                                                      AND tmpMI_group.GoodsKindId = tmpMI.GoodsKindId
                            -- здесь остатки GoodsId + из чего он может делаться - GoodsId_sub
                            LEFT JOIN tmpRemains ON tmpRemains.GoodsId_sub     = tmpMI.GoodsId
                                                AND tmpRemains.GoodsKindId_sub = tmpMI.GoodsKindId
                            -- то что зарезервировано в других документах
                            LEFT JOIN tmpMIChild ON tmpMIChild.GoodsId_sub     = tmpMI.GoodsId
                                                AND tmpMIChild.GoodsKindId_sub = tmpMI.GoodsKindId
                       -- если есть "свободный" Остаток
                       -- WHERE COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMIChild.Amount, 0) > 0
                      )

        -- первый Результат - без учета пересорта
      , tmpRes_one AS (SELECT tmpRes_one_all.Id
                            , tmpRes_one_all.GoodsId
                            , tmpRes_one_all.GoodsKindId
                            , tmpRes_one_all.GoodsId_sub
                            , tmpRes_one_all.GoodsKindId_sub
           
                            , tmpRes_one_all.MeasureId_orig
                            , tmpRes_one_all.Weight_orig
                             --
                            , tmpRes_one_all.MeasureId_sub
                            , tmpRes_one_all.Weight_sub

                              -- Заявка - НЕ в ед.изм. MeasureId_sub
                            , tmpRes_one_all.Amount_orig
           
                              -- Весь Остаток начальный - НЕ пропорционально - ИНФОРМАТИВНО ВСЕ
                            , tmpRes_one_all.Remains_orig

                              -- "свободный" Остаток для Резерв - распределен пропорционально
                            , tmpRes_one_all.Amount_diff_orig
           
                              -- результат 1 - Заказ - Резерв с остатка
                            , tmpRes_one_all.Amount_res_orig
                                                                            
                             -- остаток от Заявки - переводим в ед.изм. - MeasureId_sub
                           , CASE -- ничего не делать
                                  WHEN tmpRes_one_all.MeasureId_orig = tmpRes_one_all.MeasureId_sub
                                       THEN tmpRes_one_all.Amount_orig - COALESCE (tmpRes_one_all.Amount_res_orig, 0)
                                  -- Переводим из ШТ в Вес
                                  WHEN tmpRes_one_all.MeasureId_orig  = zc_Measure_Sh() AND tmpRes_one_all.MeasureId_sub <> zc_Measure_Sh()
                                       THEN (tmpRes_one_all.Amount_orig - COALESCE (tmpRes_one_all.Amount_res_orig, 0)) * tmpRes_one_all.Weight_orig
                                  -- Переводим из Вес в ШТ
                                  WHEN tmpRes_one_all.MeasureId_orig <> zc_Measure_Sh() AND tmpRes_one_all.MeasureId_sub = zc_Measure_Sh()
                                       THEN CASE WHEN tmpRes_one_all.Weight_sub > 0
                                                      THEN (tmpRes_one_all.Amount_orig - COALESCE (tmpRes_one_all.Amount_res_orig, 0)) / tmpRes_one_all.Weight_sub
                                                 ELSE 0
                                            END
                                  -- ???ничего не делать
                                  ELSE tmpRes_one_all.Amount_orig - COALESCE (tmpRes_one_all.Amount_res_orig, 0)
                             END AS Amount_sub

                       FROM tmpRes_one_all
                      )

      -- Остаток Заявки - сгруппировали
    , tmpMI_group AS (SELECT SUM (tmpRes_one.Amount_sub) AS Amount_sub
                             --
                           , tmpRes_one.GoodsId_sub
                           , tmpRes_one.GoodsKindId_sub
                      FROM tmpRes_one
                      GROUP BY tmpRes_one.GoodsId_sub
                             , tmpRes_one.GoodsKindId_sub
                     )
         -- Результат
          INSERT INTO _tmpMIMaster (Id, GoodsId, GoodsKindId, GoodsId_sub, GoodsKindId_sub, Amount_res_orig, Amount_orig, Remains_orig, Amount_diff_orig, Amount_sub, Remains, Amount_diff)
            SELECT tmpMI.Id
                 , tmpMI.GoodsId
                 , tmpMI.GoodsKindId
                 , tmpMI.GoodsId_sub
                 , tmpMI.GoodsKindId_sub

           
                   -- результат 1 - Заказ - Резерв с остатка
                 , tmpMI.Amount_res_orig
                   -- Заявка - НЕ в ед.изм. MeasureId_sub
                 , tmpMI.Amount_orig
                   -- Весь Остаток начальный - НЕ пропорционально - ИНФОРМАТИВНО ВСЕ
                 , tmpMI.Remains_orig
                   -- "свободный" Остаток для Резерв - распределен пропорционально
                 , tmpMI.Amount_diff_orig

                   -- остаток Заявки - в ед.изм. MeasureId_sub
                 , tmpMI.Amount_sub

                   -- Весь Остаток начальный - НЕ пропорционально - ИНФОРМАТИВНО ВСЕ
                 , COALESCE (tmpRemains.Amount, 0) /** CASE WHEN tmpMI_group.Amount > tmpMI.Amount THEN tmpMI.Amount / tmpMI_group.Amount ELSE 1 END*/
                   AS Remains

                   -- "свободный" Остаток за минусом предыдущего распределения - для Резерв - пропорционально
                 , (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMIChild.Amount, 0) - COALESCE (tmpMI.Amount_res_orig, 0)) 
                 * CASE WHEN tmpMI_group.Amount_sub > tmpMI.Amount_sub THEN tmpMI.Amount_sub / tmpMI_group.Amount_sub ELSE 1 END
                   AS Amount_diff

            FROM tmpRes_one AS tmpMI
                 -- итого по текущим товарам, для пропорции
                 LEFT JOIN tmpMI_group ON tmpMI_group.GoodsId_sub     = tmpMI.GoodsId_sub
                                      AND tmpMI_group.GoodsKindId_sub = tmpMI.GoodsKindId_sub
                 -- здесь остатки GoodsId + из чего он может делаться - GoodsId_sub
                 LEFT JOIN tmpRemains ON tmpRemains.GoodsId_sub     = tmpMI.GoodsId_sub
                                     AND tmpRemains.GoodsKindId_sub = tmpMI.GoodsKindId_sub
                 -- то что зарезервировано в других документах
                 LEFT JOIN tmpMIChild ON tmpMIChild.GoodsId_sub     = tmpMI.GoodsId_sub
                                     AND tmpMIChild.GoodsKindId_sub = tmpMI.GoodsKindId_sub
            -- если есть "свободный" Остаток
            WHERE COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMIChild.Amount, 0) - COALESCE (tmpMI.Amount_res_orig, 0) > 0
               -- или предыдущее распределение
               OR tmpMI.Amount_res_orig > 0
           ;

/*
    RAISE EXCEPTION 'Ошибка.<%>   %'
, (select _tmpMIMaster.Amount from _tmpMIMaster where _tmpMIMaster.Id = 281700170)
, (select _tmpMIMaster.Remains from _tmpMIMaster where _tmpMIMaster.Id = 281700170)
 ;
*/
     -- сохранили
     PERFORM lpInsertUpdate_MI_OrderExternal_Child (ioId                 := tmpMI.MovementItemId
                                                  , inParentId           := tmpMI.ParentId
                                                  , inMovementId         := inMovementId
                                                  , inGoodsId            := tmpMI.GoodsId_sub
                                                  , inAmount             := tmpMI.Amount_res
                                                  , inAmountRemains      := tmpMI.Remains
                                                  , inGoodsKindId        := tmpMI.GoodsKindId_sub
                                                  , inMovementId_Send    := NULL
                                                  , inUserId             := vbUserId
                                                   )
     FROM (WITH -- нашли существуюшие элементы - резерев
                tmpMI_all AS (SELECT MovementItem.Id
                                   , MovementItem.ParentId
                                   , MovementItem.ObjectId                         AS GoodsId
                                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                     -- № п/п
                                   , ROW_NUMBER() OVER (PARTITION BY MovementItem.ParentId, MovementItem.ObjectId, COALESCE (MILinkObject_GoodsKind.ObjectId, 0) ORDER BY MovementItem.Id ASC) AS Ord
                              FROM MovementItem
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                              WHERE MovementItem.MovementId = inMovementId
                                AND MovementItem.DescId     = zc_MI_Child()
                                AND MovementItem.isErased   = FALSE
                             )
          -- значит внутреннее перемещение
        , tmpMI_Float AS (SELECT MIF.*
                          FROM MovementItemFloat AS MIF
                          WHERE MIF.MovementItemId IN (SELECT DISTINCT tmpMI_all.Id FROM tmpMI_all)
                            AND MIF.DescId         = zc_MIFloat_MovementId()
                            AND MIF.ValueData      > 0
                         )
                -- существуюшие элементы - резерев + № п/п
              , tmpMI AS (SELECT MovementItem.Id
                               , MovementItem.ParentId
                               , MovementItem.GoodsId
                               , MovementItem.GoodsKindId
                                 -- № п/п
                               , ROW_NUMBER() OVER (PARTITION BY MovementItem.ParentId, MovementItem.GoodsId, MovementItem.GoodsKindId ORDER BY MovementItem.Id ASC) AS Ord
                          FROM tmpMI_all AS MovementItem
                               LEFT JOIN tmpMI_Float AS MIFloat_Movement
                                                     ON MIFloat_Movement.MovementItemId = MovementItem.Id
                                                    AND MIFloat_Movement.DescId         = zc_MIFloat_MovementId()
                          -- если это резерев НЕ с внутреннего перемещения
                          WHERE MIFloat_Movement.ValueData IS NULL
                         )
                -- результат
              , tmpMIMaster AS (SELECT tmpMI.Id
                                     , tmpMI.GoodsId
                                     , tmpMI.GoodsKindId
                                     , tmpMI.GoodsId           AS GoodsId_sub
                                     , tmpMI.GoodsKindId       AS GoodsKindId_sub
                               
                                       -- результат 1 - Заказ - Резерв с остатка
                                     , tmpMI.Amount_res_orig   AS Amount_res
                                       -- Заявка - НЕ в ед.изм. MeasureId_sub
                                     , tmpMI.Amount_orig       AS Amount
                                       -- Весь Остаток начальный - НЕ пропорционально - ИНФОРМАТИВНО ВСЕ
                                     , tmpMI.Remains_orig      AS Remains
                                       -- "свободный" Остаток для Резерв - распределен пропорционально
                                     , tmpMI.Amount_diff_orig  AS Amount_diff
                    
                                FROM _tmpMIMaster AS tmpMI
                                -- если есть распределение - 1
                                WHERE tmpMI.Amount_res_orig > 0

                               UNION ALL
                                SELECT tmpMI.Id
                                     , tmpMI.GoodsId
                                     , tmpMI.GoodsKindId
                                     , tmpMI.GoodsId_sub
                                     , tmpMI.GoodsKindId_sub
                    
                                       -- результат 2 - Заказ - Резерв с остатка
                                     , CASE -- если "свободного" остатка хватает, тогда резерв ВЕСЬ заказ
                                            WHEN COALESCE (tmpMI.Amount_diff, 0) >= COALESCE (tmpMI.Amount_sub,0)
                                                 THEN COALESCE (tmpMI.Amount_sub,0)
                                            -- здесь только "свободный" остаток
                                            WHEN tmpMI.Amount_diff > 0 THEN tmpMI.Amount_diff
                                            -- иначе 0
                                            ELSE 0
                                       END AS Amount_res

                                       -- остаток Заявки - в ед.изм. MeasureId_sub
                                     , tmpMI.Amount_sub AS Amount

                                       -- Весь Остаток начальный - НЕ пропорционально - ИНФОРМАТИВНО ВСЕ
                                     , tmpMI.Remains
                                       -- "свободный" Остаток за минусом предыдущего распределения - для Резерв - пропорционально
                                     , tmpMI.Amount_diff
                    
                                FROM _tmpMIMaster AS tmpMI
                                -- если есть "свободный" Остаток
                                WHERE tmpMI.Amount_diff > 0
                                       -- есть остаток Заявки
                                  AND tmpMI.Amount_sub > 0
                               )
           -- Результат
           SELECT COALESCE (_tmpMIMaster.Id, tmpMI.ParentId)                 AS ParentId
                , tmpMI.Id                                                   AS MovementItemId
                , COALESCE (_tmpMIMaster.GoodsId_sub,     tmpMI.GoodsId)     AS GoodsId_sub
                , COALESCE (_tmpMIMaster.GoodsKindId_sub, tmpMI.GoodsKindId) AS GoodsKindId_sub

                , COALESCE (_tmpMIMaster.GoodsId,     tmpMI.GoodsId)         AS GoodsId
                , COALESCE (_tmpMIMaster.GoodsKindId, tmpMI.GoodsKindId)     AS GoodsKindId

                  -- результат Заказ - Резерв с остатка
                , CASE WHEN COALESCE (tmpMI.Ord, 1) = 1 THEN COALESCE (_tmpMIMaster.Amount_res, 0) ELSE 0 END AS Amount_res

                  -- "свободный" Остаток - его и резервировали
                , CASE WHEN COALESCE (tmpMI.Ord, 1) = 1 THEN COALESCE (_tmpMIMaster.Amount_diff, 0) ELSE 0 END AS Amount_diff
                  -- Весь Остаток начальный - НЕ пропорционально - ИНФОРМАТИВНО ВСЕ
                , COALESCE (_tmpMIMaster.Remains, 0) AS Remains
                  -- Заявка или остаток от заявки - в ед.изм. MeasureId или в MeasureId_sub
                , CASE WHEN COALESCE (tmpMI.Ord, 1) = 1 THEN COALESCE (_tmpMIMaster.Amount, 0) ELSE 0 END AS Amount

           FROM tmpMIMaster AS _tmpMIMaster
                FULL JOIN tmpMI ON tmpMI.ParentId    = _tmpMIMaster.Id
                               AND tmpMI.GoodsId     = _tmpMIMaster.GoodsId_sub
                               AND tmpMI.GoodsKindId = _tmpMIMaster.GoodsKindId_sub
          ) AS tmpMI
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И..
 18.06.22         *
*/

-- тест
-- select * from Movement where Id =  27442087
-- select * from MovementDesc where Id =  

-- select * from MovementItem where Id =  281700170 
-- select * from MovementItem where ParentId =  281700170 
-- select * from object where Id in ( 426184, 2357)
-- select * from movementItemFloat where MovementItemId = 281762725 AND DescId = zc_MIFloat_Remains()

-- SELECT * FROM gpUpdateMIChild_OrderExternal_Amount (27442087, '5')
