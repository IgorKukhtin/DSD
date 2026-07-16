-- Function: lpUpdate_MI_Send_byWeighingProduction_all()

DROP FUNCTION IF EXISTS lpUpdate_MI_Send_byWeighingProduction_all (Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpUpdate_MI_Send_byWeighingProduction_all (TDateTime, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_MI_Send_byWeighingProduction_all(
    IN inOperDate              TDateTime, --
    IN inMovementId_from       Integer  , --
    IN inMovementId_To         Integer  , --
    IN inUserId                Integer
)
RETURNS VOID
AS
$BODY$
   DECLARE vbId_tmp Integer;
BEGIN
       -- табл - результат
       CREATE TEMP TABLE _tmpRes_PartionCell (MovementItemId_to Integer, MovementItemId_from Integer, DescId_MILO Integer, PartionCellId Integer, MovementItemId_ChoiceCell Integer, PartionGoodsDate TDateTime, GoodsId Integer, GoodsKindId Integer) ON COMMIT DROP;

       -- сохранили протокол
       WITH --
        tmpMI_from_all AS (SELECT MovementItem.Id                              AS MovementItemId
                                , MovementItem.ObjectId                        AS GoodsId
                                , COALESCE (MILO_GoodsKind.ObjectId, 0)        AS GoodsKindId
                                  -- текущее значение
                                , MILO_PartionCell.DescId                      AS DescId_MILO
                                , MILO_PartionCell.ObjectId                    AS PartionCellId
                                , COALESCE (MIF_PartionCell_real.ValueData, 0) AS PartionCellId_real

                                , COALESCE (MID_PartionGoods.ValueData, inOperDate) AS PartionGoodsDate

                           FROM MovementItem
                                LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                                 ON MILO_GoodsKind.MovementItemId  = MovementItem.Id
                                                                AND MILO_GoodsKind.DescId          = zc_MILinkObject_GoodsKind()
                                LEFT JOIN MovementItemDate AS MID_PartionGoods
                                                           ON MID_PartionGoods.MovementItemId = MovementItem.Id
                                                          AND MID_PartionGoods.DescId         = zc_MIDate_PartionGoods()

                                INNER JOIN MovementItemLinkObject AS MILO_PartionCell
                                                                  ON MILO_PartionCell.MovementItemId = MovementItem.Id
                                                                 AND MILO_PartionCell.ObjectId       > 0
                                                                 AND MILO_PartionCell.DescId         IN (zc_MILinkObject_PartionCell_1()
                                                                                                       , zc_MILinkObject_PartionCell_2()
                                                                                                       , zc_MILinkObject_PartionCell_3()
                                                                                                       , zc_MILinkObject_PartionCell_4()
                                                                                                       , zc_MILinkObject_PartionCell_5()
                                                                                                       , zc_MILinkObject_PartionCell_6()
                                                                                                       , zc_MILinkObject_PartionCell_7()
                                                                                                       , zc_MILinkObject_PartionCell_8()
                                                                                                       , zc_MILinkObject_PartionCell_9()
                                                                                                       , zc_MILinkObject_PartionCell_10()
                                                                                                       , zc_MILinkObject_PartionCell_11()
                                                                                                       , zc_MILinkObject_PartionCell_12()
                                                                                                       , zc_MILinkObject_PartionCell_13()
                                                                                                       , zc_MILinkObject_PartionCell_14()
                                                                                                       , zc_MILinkObject_PartionCell_15()
                                                                                                       , zc_MILinkObject_PartionCell_16()
                                                                                                       , zc_MILinkObject_PartionCell_17()
                                                                                                       , zc_MILinkObject_PartionCell_18()
                                                                                                       , zc_MILinkObject_PartionCell_19()
                                                                                                       , zc_MILinkObject_PartionCell_20()
                                                                                                       , zc_MILinkObject_PartionCell_21()
                                                                                                       , zc_MILinkObject_PartionCell_22()
                                                                                                        )
                                LEFT JOIN MovementItemFloat AS MIF_PartionCell_real
                                                            ON MIF_PartionCell_real.MovementItemId = MovementItem.Id
                                                           AND MIF_PartionCell_real.DescId         = CASE WHEN MILO_PartionCell.DescId = zc_MILinkObject_PartionCell_1()
                                                                                                               THEN zc_MIFloat_PartionCell_real_1()
                                                                                                          WHEN MILO_PartionCell.DescId = zc_MILinkObject_PartionCell_2()
                                                                                                               THEN zc_MIFloat_PartionCell_real_2()
                                                                                                          WHEN MILO_PartionCell.DescId = zc_MILinkObject_PartionCell_3()
                                                                                                               THEN zc_MIFloat_PartionCell_real_3()
                                                                                                          WHEN MILO_PartionCell.DescId = zc_MILinkObject_PartionCell_4()
                                                                                                               THEN zc_MIFloat_PartionCell_real_4()
                                                                                                          WHEN MILO_PartionCell.DescId = zc_MILinkObject_PartionCell_5()
                                                                                                               THEN zc_MIFloat_PartionCell_real_5()
                                                                                                          WHEN MILO_PartionCell.DescId = zc_MILinkObject_PartionCell_6()
                                                                                                               THEN zc_MIFloat_PartionCell_real_6()
                                                                                                          WHEN MILO_PartionCell.DescId = zc_MILinkObject_PartionCell_7()
                                                                                                               THEN zc_MIFloat_PartionCell_real_7()
                                                                                                          WHEN MILO_PartionCell.DescId = zc_MILinkObject_PartionCell_8()
                                                                                                               THEN zc_MIFloat_PartionCell_real_8()
                                                                                                          WHEN MILO_PartionCell.DescId = zc_MILinkObject_PartionCell_9()
                                                                                                               THEN zc_MIFloat_PartionCell_real_9()
                                                                                                          WHEN MILO_PartionCell.DescId = zc_MILinkObject_PartionCell_10()
                                                                                                               THEN zc_MIFloat_PartionCell_real_10()
                                                                                                          WHEN MILO_PartionCell.DescId = zc_MILinkObject_PartionCell_11()
                                                                                                               THEN zc_MIFloat_PartionCell_real_11()
                                                                                                          WHEN MILO_PartionCell.DescId = zc_MILinkObject_PartionCell_12()
                                                                                                               THEN zc_MIFloat_PartionCell_real_12()
                                                                                                          WHEN MILO_PartionCell.DescId = zc_MILinkObject_PartionCell_13()
                                                                                                               THEN zc_MIFloat_PartionCell_real_13()
                                                                                                          WHEN MILO_PartionCell.DescId = zc_MILinkObject_PartionCell_14()
                                                                                                               THEN zc_MIFloat_PartionCell_real_14()
                                                                                                          WHEN MILO_PartionCell.DescId = zc_MILinkObject_PartionCell_15()
                                                                                                               THEN zc_MIFloat_PartionCell_real_15()
                                                                                                          WHEN MILO_PartionCell.DescId = zc_MILinkObject_PartionCell_16()
                                                                                                               THEN zc_MIFloat_PartionCell_real_16()
                                                                                                          WHEN MILO_PartionCell.DescId = zc_MILinkObject_PartionCell_17()
                                                                                                               THEN zc_MIFloat_PartionCell_real_17()
                                                                                                          WHEN MILO_PartionCell.DescId = zc_MILinkObject_PartionCell_18()
                                                                                                               THEN zc_MIFloat_PartionCell_real_18()
                                                                                                          WHEN MILO_PartionCell.DescId = zc_MILinkObject_PartionCell_19()
                                                                                                               THEN zc_MIFloat_PartionCell_real_19()
                                                                                                          WHEN MILO_PartionCell.DescId = zc_MILinkObject_PartionCell_20()
                                                                                                               THEN zc_MIFloat_PartionCell_real_20()
                                                                                                          WHEN MILO_PartionCell.DescId = zc_MILinkObject_PartionCell_21()
                                                                                                               THEN zc_MIFloat_PartionCell_real_21()
                                                                                                          WHEN MILO_PartionCell.DescId = zc_MILinkObject_PartionCell_22()
                                                                                                               THEN zc_MIFloat_PartionCell_real_22()

                                                                                                     END
                           WHERE MovementItem.MovementId = inMovementId_from
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = FALSE
                          )

            -- Здесь уже замена
          , tmpMI_from AS (SELECT tmpMI_from_all.MovementItemId
                                , tmpMI_from_all.GoodsId
                                , tmpMI_from_all.GoodsKindId
                                  -- Замена на новый Desc
                                , CASE tmpMI_list.Ord WHEN 1 THEN zc_MILinkObject_PartionCell_1()
                                                      WHEN 2 THEN zc_MILinkObject_PartionCell_2()
                                                      WHEN 3 THEN zc_MILinkObject_PartionCell_3()
                                                      WHEN 4 THEN zc_MILinkObject_PartionCell_4()
                                                      WHEN 5 THEN zc_MILinkObject_PartionCell_5()
                                                      WHEN 6 THEN zc_MILinkObject_PartionCell_6()
                                                      WHEN 7 THEN zc_MILinkObject_PartionCell_7()
                                                      WHEN 8 THEN zc_MILinkObject_PartionCell_8()
                                                      WHEN 9 THEN zc_MILinkObject_PartionCell_9()
                                                      WHEN 10 THEN zc_MILinkObject_PartionCell_10()
                                                      WHEN 11 THEN zc_MILinkObject_PartionCell_11()
                                                      WHEN 12 THEN zc_MILinkObject_PartionCell_12()
                                                      WHEN 13 THEN zc_MILinkObject_PartionCell_13()
                                                      WHEN 14 THEN zc_MILinkObject_PartionCell_14()
                                                      WHEN 15 THEN zc_MILinkObject_PartionCell_15()
                                                      WHEN 16 THEN zc_MILinkObject_PartionCell_16()
                                                      WHEN 17 THEN zc_MILinkObject_PartionCell_17()
                                                      WHEN 18 THEN zc_MILinkObject_PartionCell_18()
                                                      WHEN 19 THEN zc_MILinkObject_PartionCell_19()
                                                      WHEN 20 THEN zc_MILinkObject_PartionCell_20()
                                                      WHEN 21 THEN zc_MILinkObject_PartionCell_21()
                                                      WHEN 22 THEN zc_MILinkObject_PartionCell_22()
                                  END AS DescId_MILO
                                  -- текущее значение
                                , tmpMI_list.PartionCellId
                                , tmpMI_list.PartionCellId_real

                                , tmpMI_from_all.PartionGoodsDate

                           FROM -- берем только один
                                (SELECT MAX (tmpMI_from_all.MovementItemId) AS MovementItemId
                                      , tmpMI_from_all.GoodsId
                                      , tmpMI_from_all.GoodsKindId
                                      , tmpMI_from_all.PartionGoodsDate
                                 FROM tmpMI_from_all
                                 GROUP BY tmpMI_from_all.GoodsId
                                        , tmpMI_from_all.GoodsKindId
                                        , tmpMI_from_all.PartionGoodsDate
                                ) tmpMI_from_all
                                LEFT JOIN -- Построили вертикально
                                          (SELECT tmpMI_list.*
                                                  -- теперь будут такие дески
                                                , ROW_NUMBER() OVER (PARTITION BY tmpMI_list.GoodsId, tmpMI_list.GoodsKindId, tmpMI_list.PartionGoodsDate ORDER BY tmpMI_list.DescId_MILO, tmpMI_list.PartionCellId) AS Ord
                                           FROM -- Построили вертикально
                                                (SELECT DISTINCT
                                                        tmpMI_from_all.GoodsId
                                                      , tmpMI_from_all.GoodsKindId
                                                      , tmpMI_from_all.PartionGoodsDate
                                                        -- текущее значение
                                                      , tmpMI_from_all.DescId_MILO
                                                      , tmpMI_from_all.PartionCellId
                                                      , tmpMI_from_all.PartionCellId_real
                                                 FROM tmpMI_from_all
                                                ) AS tmpMI_list
                                          ) AS tmpMI_list
                                            ON tmpMI_list.GoodsId          = tmpMI_from_all.GoodsId
                                           AND tmpMI_list.GoodsKindId      = tmpMI_from_all.GoodsKindId
                                           AND tmpMI_list.PartionGoodsDate = tmpMI_from_all.PartionGoodsDate
                          )

            , tmpMI_to AS (SELECT MovementItem.Id                        AS MovementItemId
                                , MovementItem.ObjectId                  AS GoodsId
                                , COALESCE (MILO_GoodsKind.ObjectId, 0)  AS GoodsKindId
                                , COALESCE (MID_PartionGoods.ValueData, inOperDate) AS PartionGoodsDate
                                  -- № п/п - если несколько партий,
                                , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId, MILO_GoodsKind.ObjectId ORDER BY COALESCE (MID_PartionGoods.ValueData, inOperDate) ASC) AS Ord
                           FROM MovementItem
                                LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                                 ON MILO_GoodsKind.MovementItemId  = MovementItem.Id
                                                                AND MILO_GoodsKind.DescId          = zc_MILinkObject_GoodsKind()
                                LEFT JOIN MovementItemDate AS MID_PartionGoods
                                                           ON MID_PartionGoods.MovementItemId = MovementItem.Id
                                                          AND MID_PartionGoods.DescId         = zc_MIDate_PartionGoods()

                           WHERE MovementItem.MovementId = inMovementId_to
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = FALSE
                          )

              -- партии ждут в месте отбора
            , tmpMI_ChoiceCell_mi AS (SELECT *
                                      FROM lpSelect_Movement_ChoiceCell_mi (inUserId:= inUserId)
                                     )

            , tmpMI_to_res AS (-- 1.перемещение в место хранения
                               SELECT 0 AS MovementItemId_ChoiceCell
                                    , tmpMI_to.MovementItemId
                                    , tmpMI_to.GoodsId
                                    , tmpMI_to.GoodsKindId
                                    , tmpMI_to.PartionGoodsDate
                                    , tmpMI_from.DescId_MILO
                                    , tmpMI_from.PartionCellId
                                      --
                                    , lpInsertUpdate_MovementItemLinkObject (tmpMI_from.DescId_MILO, tmpMI_to.MovementItemId, tmpMI_from.PartionCellId)
                                      --
                                    , lpInsertUpdate_MovementItemFloat (CASE WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_1()
                                                                                  THEN zc_MIFloat_PartionCell_real_1()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_2()
                                                                                  THEN zc_MIFloat_PartionCell_real_2()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_3()
                                                                                  THEN zc_MIFloat_PartionCell_real_3()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_4()
                                                                                  THEN zc_MIFloat_PartionCell_real_4()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_5()
                                                                                  THEN zc_MIFloat_PartionCell_real_5()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_6()
                                                                                  THEN zc_MIFloat_PartionCell_real_6()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_7()
                                                                                  THEN zc_MIFloat_PartionCell_real_7()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_8()
                                                                                  THEN zc_MIFloat_PartionCell_real_8()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_9()
                                                                                  THEN zc_MIFloat_PartionCell_real_9()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_10()
                                                                                  THEN zc_MIFloat_PartionCell_real_10()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_11()
                                                                                  THEN zc_MIFloat_PartionCell_real_11()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_12()
                                                                                  THEN zc_MIFloat_PartionCell_real_12()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_13()
                                                                                  THEN zc_MIFloat_PartionCell_real_13()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_14()
                                                                                  THEN zc_MIFloat_PartionCell_real_14()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_15()
                                                                                  THEN zc_MIFloat_PartionCell_real_15()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_16()
                                                                                  THEN zc_MIFloat_PartionCell_real_16()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_17()
                                                                                  THEN zc_MIFloat_PartionCell_real_17()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_18()
                                                                                  THEN zc_MIFloat_PartionCell_real_18()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_19()
                                                                                  THEN zc_MIFloat_PartionCell_real_19()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_20()
                                                                                  THEN zc_MIFloat_PartionCell_real_20()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_21()
                                                                                  THEN zc_MIFloat_PartionCell_real_21()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_22()
                                                                                  THEN zc_MIFloat_PartionCell_real_22()

                                                                        END
                                                                      , tmpMI_to.MovementItemId
                                                                      , tmpMI_from.PartionCellId_real
                                                                       )
                                    -- 4.1.закрыли
                                  , lpInsertUpdate_MovementItemBoolean (CASE WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_1()
                                                                                  THEN zc_MIBoolean_PartionCell_Close_1()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_2()
                                                                                  THEN zc_MIBoolean_PartionCell_Close_2()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_3()
                                                                                  THEN zc_MIBoolean_PartionCell_Close_3()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_4()
                                                                                  THEN zc_MIBoolean_PartionCell_Close_4()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_5()
                                                                                  THEN zc_MIBoolean_PartionCell_Close_5()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_6()
                                                                                  THEN zc_MIBoolean_PartionCell_Close_6()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_7()
                                                                                  THEN zc_MIBoolean_PartionCell_Close_7()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_8()
                                                                                  THEN zc_MIBoolean_PartionCell_Close_8()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_9()
                                                                                  THEN zc_MIBoolean_PartionCell_Close_9()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_10()
                                                                                  THEN zc_MIBoolean_PartionCell_Close_10()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_11()
                                                                                  THEN zc_MIBoolean_PartionCell_Close_11()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_12()
                                                                                  THEN zc_MIBoolean_PartionCell_Close_12()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_13()
                                                                                  THEN zc_MIBoolean_PartionCell_Close_13()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_14()
                                                                                  THEN zc_MIBoolean_PartionCell_Close_14()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_15()
                                                                                  THEN zc_MIBoolean_PartionCell_Close_15()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_16()
                                                                                  THEN zc_MIBoolean_PartionCell_Close_16()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_17()
                                                                                  THEN zc_MIBoolean_PartionCell_Close_17()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_18()
                                                                                  THEN zc_MIBoolean_PartionCell_Close_18()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_19()
                                                                                  THEN zc_MIBoolean_PartionCell_Close_19()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_20()
                                                                                  THEN zc_MIBoolean_PartionCell_Close_20()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_21()
                                                                                  THEN zc_MIBoolean_PartionCell_Close_21()
                                                                             WHEN tmpMI_from.DescId_MILO = zc_MILinkObject_PartionCell_22()
                                                                                  THEN zc_MIBoolean_PartionCell_Close_22()

                                                                        END
                                                                      , tmpMI_to.MovementItemId
                                                                      , CASE WHEN tmpMI_from.PartionCellId IN (0, zc_PartionCell_RK())
                                                                                  THEN TRUE
                                                                             ELSE FALSE
                                                                        END
                                                                       )

                               FROM (SELECT tmpMI_from.GoodsId
                                          , tmpMI_from.GoodsKindId
                                          , tmpMI_from.DescId_MILO
                                          , tmpMI_from.PartionCellId
                                          , tmpMI_from.PartionGoodsDate
                                          , MAX (tmpMI_from.PartionCellId_real) AS PartionCellId_real
                                     FROM tmpMI_from
                                     GROUP BY tmpMI_from.GoodsId
                                            , tmpMI_from.GoodsKindId
                                            , tmpMI_from.DescId_MILO
                                            , tmpMI_from.PartionCellId
                                            , tmpMI_from.PartionGoodsDate
                                    ) AS tmpMI_from
                                    JOIN tmpMI_to ON tmpMI_to.GoodsId          = tmpMI_from.GoodsId
                                                 AND tmpMI_to.GoodsKindId      = tmpMI_from.GoodsKindId
                                                 AND tmpMI_to.PartionGoodsDate = tmpMI_from.PartionGoodsDate

                              UNION ALL
                               -- 2. Сразу сквозняком - в место отбора
                               SELECT tmpMI_ChoiceCell_mi.MovementItemId AS MovementItemId_ChoiceCell
                                    , tmpMI_to.MovementItemId
                                    , tmpMI_to.GoodsId
                                    , tmpMI_to.GoodsKindId
                                    , tmpMI_to.PartionGoodsDate
                                    , tmpMI_from.DescId_MILO
                                    , tmpMI_from.PartionCellId
                                      -- сразу в место отбора
                                    , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_1(), tmpMI_to.MovementItemId, zc_PartionCell_RK())
                                      --
                                    , lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_1(), tmpMI_to.MovementItemId, COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = tmpMI_to.MovementItemId AND MIF.DescId = zc_MIFloat_PartionCell_real_1()), 0))
                                      -- сразу закрыли
                                    , lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_1(), tmpMI_to.MovementItemId, TRUE)

                               FROM tmpMI_to
                                    LEFT JOIN (SELECT tmpMI_from.GoodsId
                                                    , tmpMI_from.GoodsKindId
                                                    , tmpMI_from.DescId_MILO
                                                    , tmpMI_from.PartionCellId
                                                    , tmpMI_from.PartionGoodsDate
                                                    , MAX (tmpMI_from.PartionCellId_real) AS PartionCellId_real
                                               FROM tmpMI_from
                                               GROUP BY tmpMI_from.GoodsId
                                                      , tmpMI_from.GoodsKindId
                                                      , tmpMI_from.DescId_MILO
                                                      , tmpMI_from.PartionCellId
                                                      , tmpMI_from.PartionGoodsDate
                                              ) AS tmpMI_from
                                                ON tmpMI_from.GoodsId          = tmpMI_to.GoodsId
                                               AND tmpMI_from.GoodsKindId      = tmpMI_to.GoodsKindId
                                               AND tmpMI_from.PartionGoodsDate = tmpMI_to.PartionGoodsDate

                                    -- нашли для какой партии место отбора обнулялось
                                    INNER JOIN tmpMI_ChoiceCell_mi ON tmpMI_ChoiceCell_mi.GoodsId     = tmpMI_to.GoodsId
                                                                  AND tmpMI_ChoiceCell_mi.GoodsKindId = tmpMI_to.GoodsKindId
                                                                  -- Ждет снятия с хранения
                                                                  AND tmpMI_ChoiceCell_mi.isChecked   = TRUE
                                                                  -- последняя партия
                                                                  AND tmpMI_ChoiceCell_mi.Ord         = 1

                                    -- только с этой датой отправляем в отбор
                                    INNER JOIN (SELECT DISTINCT
                                                       tmpMI_to.GoodsId
                                                     , tmpMI_to.GoodsKindId
                                                     , tmpMI_to.PartionGoodsDate
                                                FROM tmpMI_to
                                                WHERE tmpMI_to.Ord = 1
                                              ) AS tmpMI_to_ord
                                                ON tmpMI_to_ord.GoodsId          = tmpMI_to.GoodsId
                                               AND tmpMI_to_ord.GoodsKindId      = tmpMI_to.GoodsKindId
                                               AND tmpMI_to_ord.PartionGoodsDate = tmpMI_to.PartionGoodsDate

                               -- если партию не отправили в место хранения
                               WHERE tmpMI_from.GoodsId IS NULL

                          )
       INSERT INTO _tmpRes_PartionCell (MovementItemId_to, MovementItemId_from, DescId_MILO, PartionCellId, MovementItemId_ChoiceCell, PartionGoodsDate, GoodsId, GoodsKindId)
          SELECT tmpMI_to_res.MovementItemId
               , tmpMI_from.MovementItemId
               , tmpMI_to_res.DescId_MILO
               , tmpMI_to_res.PartionCellId
               , tmpMI_to_res.MovementItemId_ChoiceCell
               , tmpMI_to_res.PartionGoodsDate
               , tmpMI_to_res.GoodsId
               , tmpMI_to_res.GoodsKindId
          FROM tmpMI_to_res
               LEFT JOIN tmpMI_from ON tmpMI_from.GoodsId          = tmpMI_to_res.GoodsId
                                   AND tmpMI_from.GoodsKindId      = tmpMI_to_res.GoodsKindId
                                   AND tmpMI_from.PartionGoodsDate = tmpMI_to_res.PartionGoodsDate
         ;

     -- сохранили - table
     PERFORM lpInsertUpdate_MI_PartionCell_table (inMovementId    := inMovementId_To
                                                , inMovementItemId:= _tmpRes_PartionCell.MovementItemId_to
                                                , inDescId_MILO   := _tmpRes_PartionCell.DescId_MILO
                                                , inPartionCellId := _tmpRes_PartionCell.PartionCellId
                                                , inUserId        := inUserId
                                                 )
     FROM _tmpRes_PartionCell
    ;

--
-- RAISE EXCEPTION 'Ошибка.<%>  <%>'
-- , (select COUNT(*) from _tmpRes_PartionCell where _tmpRes_PartionCell.MovementItemId_from = 361284455 )
-- , (select COUNT(*) from _tmpRes_PartionCell where _tmpRes_PartionCell.MovementItemId_from = 361275472  )
-- ;

       -- перенесли протокол по ячейкам Хранения из Взвешиваний
       INSERT INTO MovementItemProtocol (MovementItemId, OperDate, UserId, ProtocolData, isInsert)
          WITH tmpMI_from_all AS (SELECT MovementItem.Id                              AS MovementItemId
                                       , MovementItem.ObjectId                        AS GoodsId
                                       , COALESCE (MILO_GoodsKind.ObjectId, 0)        AS GoodsKindId
                                       , COALESCE (MID_PartionGoods.ValueData, inOperDate) AS PartionGoodsDate
       
                                  FROM MovementItem
                                       LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                                        ON MILO_GoodsKind.MovementItemId  = MovementItem.Id
                                                                       AND MILO_GoodsKind.DescId          = zc_MILinkObject_GoodsKind()
                                       LEFT JOIN MovementItemDate AS MID_PartionGoods
                                                                  ON MID_PartionGoods.MovementItemId = MovementItem.Id
                                                                 AND MID_PartionGoods.DescId         = zc_MIDate_PartionGoods()
                                  WHERE MovementItem.MovementId = inMovementId_from
                                    AND MovementItem.DescId     = zc_MI_Master()
                                    AND MovementItem.isErased   = FALSE
                                 )
          -- Результат
          SELECT _tmpRes_PartionCell.MovementItemId_to
               , MovementItemProtocol.OperDate
               , MovementItemProtocol.UserId
               , MovementItemProtocol.ProtocolData
               , MovementItemProtocol.isInsert
          FROM _tmpRes_PartionCell
               JOIN tmpMI_from_all ON tmpMI_from_all.GoodsId          = _tmpRes_PartionCell.GoodsId
                                  AND tmpMI_from_all.GoodsKindId      = _tmpRes_PartionCell.GoodsKindId
                                  AND tmpMI_from_all.PartionGoodsDate = _tmpRes_PartionCell.PartionGoodsDate
               JOIN MovementItemProtocol ON MovementItemProtocol.MovementItemId = tmpMI_from_all.MovementItemId
                                        AND MovementItemProtocol.ProtocolData ILIKE '%Ячейка%'
          -- нет перемещения в место хранения
          WHERE _tmpRes_PartionCell.MovementItemId_ChoiceCell = 0
         ;

        -- отметили место отбора - теперь заполнено
        PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Checked(), _tmpRes_PartionCell.MovementItemId_ChoiceCell, FALSE)
              , lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), _tmpRes_PartionCell.MovementItemId_ChoiceCell, _tmpRes_PartionCell.PartionGoodsDate)
                 -- сохранили связь с <>
              , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), _tmpRes_PartionCell.MovementItemId_ChoiceCell, inUserId)
                -- сохранили свойство <>
              , lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), _tmpRes_PartionCell.MovementItemId_ChoiceCell, CURRENT_TIMESTAMP)
        FROM _tmpRes_PartionCell
        -- перемещения в место хранения
        WHERE _tmpRes_PartionCell.MovementItemId_ChoiceCell > 0
       ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.04.24                                        *
*/

-- тест
-- SELECT * FROM lpUpdate_MI_Send_byWeighingProduction_all (inOperDate:= NULL, inMovementId_from := 0, inMovementId_to := 0 , inUserId:= zfCalc_UserAdmin() :: Integer);
