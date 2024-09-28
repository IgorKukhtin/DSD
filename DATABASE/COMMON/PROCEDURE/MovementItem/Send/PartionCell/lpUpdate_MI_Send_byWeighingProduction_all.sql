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
       -- ���� - ���������
       CREATE TEMP TABLE _tmpRes_PartionCell (MovementItemId_to Integer, MovementItemId_from Integer, MovementItemId_ChoiceCell Integer) ON COMMIT DROP;

       -- ��������� ��������
       WITH --
            tmpMI_from AS (SELECT MovementItem.Id                              AS MovementItemId
                                , MovementItem.ObjectId                        AS GoodsId
                                , COALESCE (MILO_GoodsKind.ObjectId, 0)        AS GoodsKindId
                                  -- ������� ��������
                                , MILO_PartionCell.DescId                      AS DescId_MILO
                                , MILO_PartionCell.ObjectId                    AS PartionCellId
                                , COALESCE (MIF_PartionCell_real.ValueData, 0) AS PartionCellId_real

                           FROM MovementItem
                                LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                                 ON MILO_GoodsKind.MovementItemId  = MovementItem.Id
                                                                AND MILO_GoodsKind.DescId          = zc_MILinkObject_GoodsKind()

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
            , tmpMI_to AS (SELECT MovementItem.Id                        AS MovementItemId
                                , MovementItem.ObjectId                  AS GoodsId
                                , COALESCE (MILO_GoodsKind.ObjectId, 0)  AS GoodsKindId
                           FROM MovementItem
                                LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                                 ON MILO_GoodsKind.MovementItemId  = MovementItem.Id
                                                                AND MILO_GoodsKind.DescId          = zc_MILinkObject_GoodsKind()

                           WHERE MovementItem.MovementId = inMovementId_to
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = FALSE
                          )

              -- ������ ���� � ����� ������
            , tmpMI_ChoiceCell_mi AS (SELECT *
                                      FROM lpSelect_Movement_ChoiceCell_mi (inUserId:= inUserId)
                                     )

            , tmpMI_to_res AS (-- 1.����������� � ����� ��������
                               SELECT 0 AS MovementItemId_ChoiceCell
                                    , tmpMI_to.MovementItemId
                                    , tmpMI_to.GoodsId
                                    , tmpMI_to.GoodsKindId
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
                                    -- 4.1.�������
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
                                          , MAX (tmpMI_from.PartionCellId_real) AS PartionCellId_real
                                     FROM tmpMI_from
                                     GROUP BY tmpMI_from.GoodsId
                                            , tmpMI_from.GoodsKindId
                                            , tmpMI_from.DescId_MILO
                                            , tmpMI_from.PartionCellId
                                    ) AS tmpMI_from
                                    JOIN tmpMI_to ON tmpMI_to.GoodsId     = tmpMI_from.GoodsId
                                                 AND tmpMI_to.GoodsKindId = tmpMI_from.GoodsKindId

                              UNION ALL
                               -- 2. ����� ���������� - � ����� ������
                               SELECT tmpMI_ChoiceCell_mi.MovementItemId AS MovementItemId_ChoiceCell
                                    , tmpMI_to.MovementItemId
                                    , tmpMI_to.GoodsId
                                    , tmpMI_to.GoodsKindId
                                      -- ����� � ����� ������
                                    , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_1(), tmpMI_to.MovementItemId, zc_PartionCell_RK())
                                      --
                                    , lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_1(), tmpMI_to.MovementItemId, COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = tmpMI_to.MovementItemId AND MIF.DescId = zc_MIFloat_PartionCell_real_1()), 0))
                                      -- ����� �������
                                    , lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_1(), tmpMI_to.MovementItemId, TRUE)

                               FROM tmpMI_to
                                    LEFT JOIN (SELECT tmpMI_from.GoodsId
                                                    , tmpMI_from.GoodsKindId
                                                    , tmpMI_from.DescId_MILO
                                                    , tmpMI_from.PartionCellId
                                                    , MAX (tmpMI_from.PartionCellId_real) AS PartionCellId_real
                                               FROM tmpMI_from
                                               GROUP BY tmpMI_from.GoodsId
                                                      , tmpMI_from.GoodsKindId
                                                      , tmpMI_from.DescId_MILO
                                                      , tmpMI_from.PartionCellId
                                              ) AS tmpMI_from
                                                ON tmpMI_from.GoodsId     = tmpMI_to.GoodsId
                                               AND tmpMI_from.GoodsKindId = tmpMI_to.GoodsKindId

                                    -- ����� ��� ����� ������ ����� ������ ����������
                                    INNER JOIN tmpMI_ChoiceCell_mi ON tmpMI_ChoiceCell_mi.GoodsId     = tmpMI_to.GoodsId
                                                                  AND tmpMI_ChoiceCell_mi.GoodsKindId = tmpMI_to.GoodsKindId
                                                                  -- ���� ������ � ��������
                                                                  AND tmpMI_ChoiceCell_mi.isChecked   = TRUE
                                                                  -- ��������� ������
                                                                  AND tmpMI_ChoiceCell_mi.Ord         = 1

                               -- ���� ������ �� ��������� � ����� ��������
                               WHERE tmpMI_from.GoodsId IS NULL
                                    
                          )
       INSERT INTO _tmpRes_PartionCell (MovementItemId_to, MovementItemId_from, MovementItemId_ChoiceCell)
          SELECT tmpMI_to_res.MovementItemId
               , tmpMI_from.MovementItemId
               , tmpMI_to_res.MovementItemId_ChoiceCell
          FROM tmpMI_to_res
               LEFT  JOIN tmpMI_from ON tmpMI_from.GoodsId     = tmpMI_to_res.GoodsId
                                    AND tmpMI_from.GoodsKindId = tmpMI_to_res.GoodsKindId
         ;

       -- ��������� �������� �� ������� �������� �� �����������
       INSERT INTO MovementItemProtocol (MovementItemId, OperDate, UserId, ProtocolData, isInsert)
          SELECT _tmpRes_PartionCell.MovementItemId_to
               , MovementItemProtocol.OperDate
               , MovementItemProtocol.UserId
               , MovementItemProtocol.ProtocolData
               , MovementItemProtocol.isInsert
          FROM _tmpRes_PartionCell
               JOIN MovementItemProtocol ON MovementItemProtocol.MovementItemId = _tmpRes_PartionCell.MovementItemId_from
                                        AND MovementItemProtocol.ProtocolData ILIKE '%������%'
          -- ��� ����������� � ����� ��������
          WHERE _tmpRes_PartionCell.MovementItemId_ChoiceCell = 0
         ;

       -- �������� ����� ������ - ������ ���������
        PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Checked(), _tmpRes_PartionCell.MovementItemId_ChoiceCell, FALSE)
              , lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), _tmpRes_PartionCell.MovementItemId_ChoiceCell, inOperDate)
                 -- ��������� ����� � <>
              , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), _tmpRes_PartionCell.MovementItemId_ChoiceCell, inUserId)
                -- ��������� �������� <>
              , lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), _tmpRes_PartionCell.MovementItemId_ChoiceCell, CURRENT_TIMESTAMP)
        FROM _tmpRes_PartionCell
        -- ����������� � ����� ��������
        WHERE _tmpRes_PartionCell.MovementItemId_ChoiceCell > 0
       ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.04.24                                        *
*/

-- ����
-- SELECT * FROM lpUpdate_MI_Send_byWeighingProduction_all (inOperDate:= NULL, inMovementId_from := 0, inMovementId_to := 0 , inUserId:= zfCalc_UserAdmin() :: Integer);
