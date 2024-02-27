-- Function: gpUpdateMIChild_OrderExternal_AmountSecond()

DROP FUNCTION IF EXISTS gpUpdateMIChild_OrderExternal_AmountSecond (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdateMIChild_OrderExternal_AmountSecond(
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
      --PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Remains(), inMovementId, TRUE);


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
          CREATE TEMP TABLE _tmpMIMaster (Id Integer, GoodsId Integer, GoodsKindId Integer, GoodsId_sub Integer, GoodsKindId_sub Integer, MovementId_send Integer, Amount_orig TFloat, Amount_res_orig TFloat, Amount TFloat, Amount_res TFloat) ON COMMIT DROP;
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
      , tmpMI_all AS (SELECT MovementItem.Id
                           , MovementItem.ObjectId                         AS GoodsId
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                             --
                           , ObjectLink_Goods_Measure.ChildObjectId        AS MeasureId
                           , ObjectFloat_Weight.ValueData                  AS Weight
                             --
                           , ObjectLink_Goods_Measure_sub.ChildObjectId    AS MeasureId_sub
                           , ObjectFloat_Weight_sub.ValueData              AS Weight_sub

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
       -- Резервы остатка - текущая заявка
     , tmpChild AS (SELECT MovementItem.ParentId
                           -- если нет документа, значит распределялся остаток
                         , SUM (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) = 0
                                     -- переводим в ед изм - оригинал
                                     THEN CASE -- ничего не делать
                                               WHEN ObjectLink_Goods_Measure.ChildObjectId = ObjectLink_Goods_Measure_parent.ChildObjectId
                                                    THEN MovementItem.Amount
                                               -- Переводим из ШТ в Вес
                                               WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND ObjectLink_Goods_Measure_parent.ChildObjectId <> zc_Measure_Sh()
                                                    AND ObjectFloat_Weight.ValueData > 0
                                                    THEN MovementItem.Amount * ObjectFloat_Weight.ValueData
                                               -- Переводим из Вес в ШТ
                                               WHEN ObjectLink_Goods_Measure.ChildObjectId <> zc_Measure_Sh() AND ObjectLink_Goods_Measure_parent.ChildObjectId = zc_Measure_Sh()
                                                    THEN CASE WHEN ObjectFloat_Weight_parent.ValueData > 0
                                                                   THEN MovementItem.Amount / ObjectFloat_Weight_parent.ValueData
                                                              ELSE 0
                                                         END
                                               -- ???ничего не делать
                                               ELSE MovementItem.Amount
                                          END
                                     ELSE 0
                                END) AS Amount
                    FROM MovementItem
                         LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                     ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                    AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                         LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                              ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                             AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
                         LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                               ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                              AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
                         -- Элемент заявки не удален
                         INNER JOIN MovementItem AS MovementItem_parent
                                                 ON MovementItem_parent.MovementId = inMovementId
                                                AND MovementItem_parent.DescId     = zc_MI_Master()
                                                AND MovementItem_parent.Id         = MovementItem.ParentId
                                                AND MovementItem_parent.isErased   = FALSE
                         LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure_parent
                                              ON ObjectLink_Goods_Measure_parent.ObjectId = MovementItem_parent.ObjectId
                                             AND ObjectLink_Goods_Measure_parent.DescId   = zc_ObjectLink_Goods_Measure()
                         LEFT JOIN ObjectFloat AS ObjectFloat_Weight_parent
                                               ON ObjectFloat_Weight_parent.ObjectId = MovementItem_parent.ObjectId
                                              AND ObjectFloat_Weight_parent.DescId   = zc_ObjectFloat_Goods_Weight()

                    WHERE MovementItem.MovementId      = inMovementId
                      AND MovementItem.DescId          = zc_MI_Child()
                      AND MovementItem.isErased        = FALSE
                    GROUP BY MovementItem.ParentId
                   )
       -- Заявка - сколько осталось зарезервировать для перемещения
     , tmpMI_orig AS (SELECT tmpMI_all.Id
                           , tmpMI_all.GoodsId
                           , tmpMI_all.GoodsKindId
                             --
                           , tmpMI_all.MeasureId
                           , tmpMI_all.Weight
                             --
                           , tmpMI_all.MeasureId_sub
                           , tmpMI_all.Weight_sub

                             -- Заявка - НЕ в ед.изм. - MeasureId_sub
                           , tmpMI_all.Amount - COALESCE (tmpChild.Amount, 0) AS Amount
                             --
                           , tmpMI_all.GoodsId_sub
                           , tmpMI_all.GoodsKindId_sub
                      FROM tmpMI_all
                           -- минус Резерв с остатка для Текущая заявка
                           LEFT JOIN tmpChild ON tmpChild.ParentId = tmpMI_all.Id
                      -- Если есть что резервировать
                      WHERE tmpMI_all.Amount - COALESCE (tmpChild.Amount, 0) > 0
                     )
      -- Заявка - сгруппировали
    , tmpMI_group_orig AS (SELECT SUM (tmpMI_orig.Amount) AS Amount
                                  --
                                , tmpMI_orig.GoodsId
                                , tmpMI_orig.GoodsKindId
                           FROM tmpMI_orig
                           GROUP BY tmpMI_orig.GoodsId
                                  , tmpMI_orig.GoodsKindId
                          )

        -- ВСЕ заявки, в которых есть Резерв !!!для перемещения!!! за эту "смену" или позже
      , tmpMIChild_All AS (SELECT MovementItem.ObjectId                         AS GoodsId_sub
                                , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId_sub
                                , MIF_MovementId.ValueData          :: Integer  AS MovementId_Send
                                , SUM (COALESCE (MovementItem.Amount,0))        AS Amount
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
                                INNER JOIN (SELECT DISTINCT tmpMI_orig.GoodsId_sub, tmpMI_orig.GoodsKindId_sub FROM tmpMI_orig
                                           UNION
                                            SELECT DISTINCT tmpMI_orig.GoodsId AS GoodsId_sub, tmpMI_orig.GoodsKindId AS GoodsKindId_sub FROM tmpMI_orig
                                           ) AS tmpGoods
                                             ON tmpGoods.GoodsId_sub     = MovementItem.ObjectId
                                            AND tmpGoods.GoodsKindId_sub = MILinkObject_GoodsKind.ObjectId

                                -- !!!вот документ перемещения!!!
                                LEFT JOIN MovementItemFloat AS MIF_MovementId
                                                            ON MIF_MovementId.MovementItemId = MovementItem.Id
                                                           AND MIF_MovementId.DescId         = zc_MIFloat_MovementId()

                           WHERE Movement.DescId   = zc_Movement_OrderExternal()
                             AND Movement.StatusId = zc_Enum_Status_Complete()
                             -- !!!Не текущий документ!!!
                             AND Movement.Id      <> inMovementId
                             -- если такой документ есть
                             AND MIF_MovementId.ValueData > 0

                           GROUP BY MovementItem.ObjectId
                                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                  , MIF_MovementId.ValueData
                           )
        -- приход перемещение на склад
      , tmpSendIn_all AS (SELECT Movement.Id                                   AS MovementId_Send
                               , MovementItem.ObjectId                         AS GoodsId_sub
                               , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId_sub
                               , SUM (MovementItem.Amount)                     AS Amount
                          FROM Movement
                               -- на этот склад
                               INNER JOIN MovementLinkObject AS MLO_To
                                                             ON MLO_To.MovementId = Movement.Id
                                                            AND MLO_To.DescId     = zc_MovementLinkObject_To()
                                                            AND MLO_To.ObjectId   = vbUnitId
                               -- Элемент перемещения
                               INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                      AND MovementItem.DescId     = zc_MI_Master()
                                                      AND MovementItem.isErased   = FALSE
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                               -- Только для "товаров" из текущей заявки
                               INNER JOIN (SELECT DISTINCT tmpMI_orig.GoodsId_sub, tmpMI_orig.GoodsKindId_sub FROM tmpMI_orig
                                           UNION
                                            SELECT DISTINCT tmpMI_orig.GoodsId AS GoodsId_sub, tmpMI_orig.GoodsKindId AS GoodsKindId_sub FROM tmpMI_orig
                                          ) AS tmpGoods
                                            ON tmpGoods.GoodsId_sub     = MovementItem.ObjectId
                                           AND tmpGoods.GoodsKindId_sub = MILinkObject_GoodsKind.ObjectId
                          WHERE Movement.OperDate = vbOperDate
                            AND Movement.DescId   = zc_Movement_Send()
                            AND Movement.StatusId = zc_Enum_Status_Complete()
                          GROUP BY Movement.Id
                                 , MovementItem.ObjectId
                                 , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                         )
            -- Сколько еще можно резервировать с перемещений на склад
          , tmpSendIn AS (SELECT tmpSendIn_all.MovementId_Send
                               , tmpSendIn_all.GoodsId_sub
                               , tmpSendIn_all.GoodsKindId_sub
                                 -- осталось для резервирования
                               , tmpSendIn_all.Amount - COALESCE (tmpMIChild_All.Amount, 0) AS Amount
                                 -- накопительно
                               , SUM (tmpSendIn_all.Amount - COALESCE (tmpMIChild_All.Amount, 0))
                                 OVER (PARTITION BY tmpSendIn_all.GoodsId_sub, tmpSendIn_all.GoodsKindId_sub ORDER BY tmpSendIn_all.MovementId_Send ASC                                      )
                                 AS Amount_SUM
                          FROM tmpSendIn_all
                               -- вычитаем перемещения которые в резерве
                               LEFT JOIN tmpMIChild_All ON tmpMIChild_All.GoodsId_sub     = tmpSendIn_all.GoodsId_sub
                                                       AND tmpMIChild_All.GoodsKindId_sub = tmpSendIn_all.GoodsKindId_sub
                                                       AND tmpMIChild_All.MovementId_Send = tmpSendIn_all.MovementId_Send
                          -- Если с перемещения осталось что резервировать
                          WHERE tmpSendIn_all.Amount - COALESCE (tmpMIChild_All.Amount, 0) > 0
                         )

       -- первый Результат - без учета пересорта
     , tmpRes_one_all AS (SELECT tmpMI.GoodsId, tmpMI.GoodsKindId
                               , tmpSendIn.MovementId_Send
                               , CASE WHEN tmpMI.Amount > tmpSendIn.Amount_SUM
                                           THEN tmpSendIn.Amount
                                      ELSE tmpMI.Amount - tmpSendIn.Amount_SUM + tmpSendIn.Amount
                                 END AS Amount
                          FROM (SELECT tmpMI_orig.GoodsId, tmpMI_orig.GoodsKindId, SUM (tmpMI_orig.Amount) AS Amount
                                FROM tmpMI_orig
                                GROUP BY tmpMI_orig.GoodsId, tmpMI_orig.GoodsKindId
                               ) AS tmpMI
                               JOIN tmpSendIn ON tmpSendIn.GoodsId_sub     = tmpMI.GoodsId
                                             AND tmpSendIn.GoodsKindId_sub = tmpMI.GoodsKindId
                          WHERE tmpMI.Amount - (tmpSendIn.Amount_SUM - tmpSendIn.Amount) > 0
                         )
           -- первый Результат - без учета пересорта
         , tmpRes_one AS (SELECT tmpMI_orig.Id
                               , tmpMI_orig.GoodsId
                               , tmpMI_orig.GoodsKindId
                               , tmpMI_orig.GoodsId_sub
                               , tmpMI_orig.GoodsKindId_sub
              
                               , tmpRes_one_all.MovementId_send
              
                                 -- Заявка - НЕ в ед.изм. MeasureId_sub
                               , tmpMI_orig.Amount
              
                                 -- Резерв - пропорционально
                               , tmpRes_one_all.Amount
                               * CASE WHEN tmpMI_group_orig.Amount > tmpMI_orig.Amount THEN tmpMI_orig.Amount / tmpMI_group_orig.Amount ELSE 1 END
                                 AS Amount_res
              
                          FROM tmpMI_orig
                               LEFT JOIN tmpMI_group_orig ON tmpMI_group_orig.GoodsId     = tmpMI_orig.GoodsId
                                                         AND tmpMI_group_orig.GoodsKindId = tmpMI_orig.GoodsKindId
                               LEFT JOIN tmpRes_one_all ON tmpRes_one_all.GoodsId     = tmpMI_orig.GoodsId
                                                       AND tmpRes_one_all.GoodsKindId = tmpMI_orig.GoodsKindId
                          WHERE tmpRes_one_all.Amount > 0
                         )
            -- Заявка - сколько осталось зарезервировать для перемещения
          , tmpMI AS (SELECT tmpMI_all.Id
                           , tmpMI_all.GoodsId
                           , tmpMI_all.GoodsKindId
                             --
                           , tmpMI_all.MeasureId
                           , tmpMI_all.Weight
                             --
                           , tmpMI_all.MeasureId_sub
                           , tmpMI_all.Weight_sub

                             -- остаток от Заявки - НЕ переводим в ед.изм. - MeasureId_sub
                           , tmpMI_all.Amount - COALESCE (tmpRes_one.Amount_res, 0) AS Amount_sub

                             -- остаток от Заявки - переводим в ед.изм. - MeasureId_sub
                           , CASE -- ничего не делать
                                  WHEN tmpMI_all.MeasureId = tmpMI_all.MeasureId_sub
                                       THEN tmpMI_all.Amount - COALESCE (tmpRes_one.Amount_res, 0)
                                  -- Переводим из ШТ в Вес
                                  WHEN tmpMI_all.MeasureId  = zc_Measure_Sh() AND tmpMI_all.MeasureId_sub <> zc_Measure_Sh()
                                       THEN (tmpMI_all.Amount - COALESCE (tmpRes_one.Amount_res, 0)) * tmpMI_all.Weight
                                  -- Переводим из Вес в ШТ
                                  WHEN tmpMI_all.MeasureId <> zc_Measure_Sh() AND tmpMI_all.MeasureId_sub = zc_Measure_Sh()
                                       THEN CASE WHEN tmpMI_all.Weight_sub > 0
                                                      THEN (tmpMI_all.Amount - COALESCE (tmpRes_one.Amount_res, 0)) / tmpMI_all.Weight_sub
                                                 ELSE 0
                                            END
                                  -- ???ничего не делать
                                  ELSE tmpMI_all.Amount - COALESCE (tmpRes_one.Amount_res, 0)

                             END AS Amount

                             --
                           , tmpMI_all.GoodsId_sub
                           , tmpMI_all.GoodsKindId_sub
                      FROM tmpMI_all
                           -- минус первый Результат - без учета пересорта
                           LEFT JOIN (SELECT tmpRes_one.Id, SUM (tmpRes_one.Amount_res) AS Amount_res
                                      FROM tmpRes_one
                                      GROUP BY tmpRes_one.Id
                                     ) AS tmpRes_one ON tmpRes_one.Id = tmpMI_all.Id
                           
                      -- Если есть что резервировать
                      WHERE tmpMI_all.Amount - COALESCE (tmpRes_one.Amount_res, 0) > 0
                     )

          -- Заявка - сгруппировали
        , tmpMI_group AS (SELECT SUM (tmpMI.Amount) AS Amount
                                  --
                                , tmpMI.GoodsId_sub
                                , tmpMI.GoodsKindId_sub
                           FROM tmpMI
                           GROUP BY tmpMI.GoodsId_sub
                                  , tmpMI.GoodsKindId_sub
                          )
    -- второй Результат - с учетом пересорта
  , tmpMI_res_two_all AS (SELECT tmpMI.GoodsId_sub, tmpMI.GoodsKindId_sub
                               , tmpSendIn.MovementId_Send
                               , CASE WHEN tmpMI.Amount > tmpSendIn.Amount_SUM - COALESCE (tmpRes_one.Amount_res, 0)
                                           THEN tmpSendIn.Amount - COALESCE (tmpRes_one.Amount_res, 0)
                                      ELSE tmpMI.Amount - tmpSendIn.Amount_SUM + tmpSendIn.Amount - COALESCE (tmpRes_one.Amount_res, 0)
                                 END AS Amount
                          FROM (SELECT tmpMI.GoodsId_sub, tmpMI.GoodsKindId_sub, SUM (tmpMI.Amount) AS Amount
                                FROM tmpMI
                                GROUP BY tmpMI.GoodsId_sub, tmpMI.GoodsKindId_sub
                               ) AS tmpMI

                               JOIN tmpSendIn ON tmpSendIn.GoodsId_sub     = tmpMI.GoodsId_sub
                                             AND tmpSendIn.GoodsKindId_sub = tmpMI.GoodsKindId_sub
                               -- минус первый Результат - без учета пересорта
                               LEFT JOIN (SELECT tmpRes_one.MovementId_Send, tmpRes_one.GoodsId, tmpRes_one.GoodsKindId, SUM (tmpRes_one.Amount_res) AS Amount_res
                                          FROM tmpRes_one
                                          GROUP BY tmpRes_one.MovementId_Send, tmpRes_one.GoodsId, tmpRes_one.GoodsKindId
                                         ) AS tmpRes_one
                                           ON tmpRes_one.MovementId_Send = tmpSendIn.MovementId_Send
                                          AND tmpRes_one.GoodsId         = tmpSendIn.GoodsId_sub
                                          AND tmpRes_one.GoodsKindId     = tmpSendIn.GoodsKindId_sub
                          WHERE tmpMI.Amount - (tmpSendIn.Amount_SUM - tmpSendIn.Amount + COALESCE (tmpRes_one.Amount_res, 0)) > 0
                         )
           -- второй Результат - с учетом пересорта
         , tmpRes_two AS (SELECT tmpMI.Id
                               , tmpMI.GoodsId
                               , tmpMI.GoodsKindId
                               , tmpMI.GoodsId_sub
                               , tmpMI.GoodsKindId_sub
              
                               , tmpMI_res_two_all.MovementId_send
              
                                 -- остаток от Заявки - в MeasureId_sub
                               , tmpMI.Amount
              
                                 -- Резерв - пропорционально
                               , tmpMI_res_two_all.Amount
                               * CASE WHEN tmpMI_group.Amount > tmpMI.Amount THEN tmpMI.Amount / tmpMI_group.Amount ELSE 1 END
                                 AS Amount_res
              
                          FROM tmpMI
                               LEFT JOIN tmpMI_group ON tmpMI_group.GoodsId_sub     = tmpMI.GoodsId_sub
                                                    AND tmpMI_group.GoodsKindId_sub = tmpMI.GoodsKindId_sub
                               LEFT JOIN tmpMI_res_two_all ON tmpMI_res_two_all.GoodsId_sub     = tmpMI.GoodsId_sub
                                                          AND tmpMI_res_two_all.GoodsKindId_sub = tmpMI.GoodsKindId_sub
                          WHERE tmpMI_res_two_all.Amount > 0
                         )


         -- Результат
         INSERT INTO _tmpMIMaster (Id, GoodsId, GoodsKindId, GoodsId_sub, GoodsKindId_sub, MovementId_send, Amount, Amount_res)
            SELECT tmpRes_one.Id
                 , tmpRes_one.GoodsId
                 , tmpRes_one.GoodsKindId
                 , tmpRes_one.GoodsId     AS GoodsId_sub
                 , tmpRes_one.GoodsKindId AS GoodsKindId_sub

                 , tmpRes_one.MovementId_send

                   -- Заявка - НЕ в ед.изм. MeasureId_sub
                 , tmpRes_one.Amount

                   -- Резерв - пропорционально
                 , tmpRes_one.Amount_res

            FROM tmpRes_one
            WHERE tmpRes_one.Amount_res > 0

           UNION ALL
            SELECT tmpRes_two.Id
                 , tmpRes_two.GoodsId
                 , tmpRes_two.GoodsKindId
                 , tmpRes_two.GoodsId_sub
                 , tmpRes_two.GoodsKindId_sub

                 , tmpRes_two.MovementId_send

                   -- остаток от Заявки - в MeasureId_sub
                 , tmpRes_two.Amount

                   -- Резерв - пропорционально
                 , tmpRes_two.Amount_res

            FROM tmpRes_two
            WHERE tmpRes_two.Amount_res > 0

           ;


     -- сохранили
     PERFORM lpInsertUpdate_MI_OrderExternal_Child (ioId                 := tmpMI.MovementItemId
                                                  , inParentId           := tmpMI.ParentId
                                                  , inMovementId         := inMovementId
                                                  , inGoodsId            := tmpMI.GoodsId_sub
                                                  , inAmount             := COALESCE (tmpMI.Amount_res, 0)
                                                  , inAmountRemains      := 0
                                                  , inGoodsKindId        := tmpMI.GoodsKindId_sub
                                                  , inMovementId_Send    := tmpMI.MovementId_Send
                                                  , inUserId             := vbUserId
                                                   )
     FROM (WITH -- нашли элементы - резерев внутреннее перемещение
                tmpMI AS (SELECT MovementItem.Id
                                , MovementItem.ParentId
                                , MovementItem.ObjectId                         AS GoodsId_sub
                                , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId_sub
                                , MIFloat_MovementId.ValueData       :: Integer AS MovementId_send
                                 -- № п/п
                               , ROW_NUMBER() OVER (PARTITION BY MovementItem.ParentId, MIFloat_MovementId.ValueData, MovementItem.ObjectId, MILinkObject_GoodsKind.ObjectId ORDER BY MovementItem.Id ASC) AS Ord
                           FROM MovementItem
                                INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                                             ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                            AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                                                            -- значит внутреннее перемещение
                                                            AND MIFloat_MovementId.ValueData      > 0

                                LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                 ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Child()
                             AND MovementItem.isErased   = FALSE
                          )
           -- Результат
           SELECT COALESCE (_tmpMIMaster.Id, tmpMI.ParentId)                     AS ParentId
                , tmpMI.Id                                                       AS MovementItemId
                , COALESCE (_tmpMIMaster.GoodsId_sub,     tmpMI.GoodsId_sub)     AS GoodsId_sub
                , COALESCE (_tmpMIMaster.GoodsKindId_sub, tmpMI.GoodsKindId_sub) AS GoodsKindId_sub
                , COALESCE (_tmpMIMaster.MovementId_send, tmpMI.MovementId_send) AS MovementId_send
                , CASE WHEN COALESCE (tmpMI.Ord, 1) = 1 THEN _tmpMIMaster.Amount_res ELSE 0 END AS Amount_res
                , COALESCE (_tmpMIMaster.Amount, 0)  AS Amount
           FROM _tmpMIMaster
                FULL JOIN tmpMI ON tmpMI.ParentId        = _tmpMIMaster.Id
                               AND tmpMI.MovementId_send = _tmpMIMaster.MovementId_send
                               AND tmpMI.GoodsId_sub     = _tmpMIMaster.GoodsId_sub
                               AND tmpMI.GoodsKindId_sub = _tmpMIMaster.GoodsKindId_sub
          ) AS tmpMI
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.06.22         *
*/

-- тест
-- SELECT * FROM gpUpdateMIChild_OrderExternal_AmountSecond(inMovementId := 27442087 ,  inSession := '5');
