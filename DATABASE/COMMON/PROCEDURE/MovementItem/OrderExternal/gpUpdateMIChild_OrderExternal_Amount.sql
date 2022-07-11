-- Function: gpUpdateMIChild_OrderExternal_Amount()

DROP FUNCTION IF EXISTS gpUpdateMIChild_OrderExternal_Amount (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdateMIChild_OrderExternal_Amount(
    IN inMovementId      Integer      , -- ���� ���������
    IN inSession         TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbUnitId   Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderExternal());

      -- ������ �� ���������
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

      -- ������ �� ������� + ������� � ������ �� ������� ��. ���.
      IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE '_tmpMIMaster')
      THEN
          DELETE FROM _tmpMIMaster;
      ELSE
          CREATE TEMP TABLE _tmpMIMaster (Id Integer, GoodsId Integer, GoodsKindId Integer, GoodsId_sub Integer, GoodsKindId_sub Integer, Amount TFloat, Remains TFloat, Amount_diff TFloat) ON COMMIT DROP;
      END IF;

      --
      WITH 
           tmpGoodsByGoodsKind AS (SELECT Object_GoodsByGoodsKind_View.GoodsId
                                        , Object_GoodsByGoodsKind_View.GoodsKindId
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
            -- ������
          , tmpMI AS (SELECT MovementItem.Id
                             --
                           , MovementItem.ObjectId                         AS GoodsId
                             --
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                             --
                           , ObjectLink_Goods_Measure.ChildObjectId        AS MeasureId
                           , ObjectFloat_Weight.ValueData                  AS Weight
                             --
                           , ObjectLink_Goods_Measure_sub.ChildObjectId    AS MeasureId_sub
                           , ObjectFloat_Weight_sub.ValueData              AS Weight_sub
                             --
                           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (MovementItem.Amount, 0) + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END AS Amount_sh
                           , (COALESCE (MovementItem.Amount, 0) + COALESCE (MIFloat_AmountSecond.ValueData, 0))
                           * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                             AS Amount_Weight

                             -- ������ - ��������� � ��.���. - MeasureId_sub
                           , CASE -- ������ �� ������
                                  WHEN ObjectLink_Goods_Measure.ChildObjectId = ObjectLink_Goods_Measure_sub.ChildObjectId
                                       THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                                  -- ��������� � ���
                                  WHEN ObjectLink_Goods_Measure.ChildObjectId  = zc_Measure_Sh() AND ObjectLink_Goods_Measure_sub.ChildObjectId <> zc_Measure_Sh()
                                       THEN (MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)) * COALESCE (ObjectFloat_Weight.ValueData, 0)
                                  -- ��������� � ��
                                  WHEN ObjectLink_Goods_Measure.ChildObjectId <> zc_Measure_Sh() AND ObjectLink_Goods_Measure_sub.ChildObjectId   = zc_Measure_Sh()
                                       THEN CASE WHEN ObjectFloat_Weight.ValueData > 0
                                                      THEN (MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)) / ObjectFloat_Weight.ValueData
                                                 ELSE 0
                                            END
                                  -- ???������ �� ������
                                  ELSE MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                             END AS Amount

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
      -- ������ - �������������
    , tmpMI_group AS (SELECT SUM (tmpMI.Amount) AS Amount
                             --
                           , tmpMI.GoodsId_sub
                           , tmpMI.GoodsKindId_sub
                      FROM tmpMI
                      GROUP BY tmpMI.GoodsId_sub
                             , tmpMI.GoodsKindId_sub
                     )
        -- ��� ������, � ������� ���� ������ !!!��� �������!!! �� ��� "�����" ��� �����
      , tmpMIChild_All AS (SELECT MovementItem.Id                               AS MovementItemId
                                , MovementItem.ObjectId                         AS GoodsId_sub
                                , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId_sub
                                , COALESCE (MovementItem.Amount,0)              AS Amount
                           FROM Movement
                                INNER JOIN MovementDate AS MovementDate_CarInfo
                                                        ON MovementDate_CarInfo.MovementId = Movement.Id
                                                       AND MovementDate_CarInfo.DescId     = zc_MovementDate_CarInfo()
                                                       -- �� ��� "�����" ��� �����
                                                       AND MovementDate_CarInfo.ValueData  >= vbOperDate + INTERVAL '8 HOUR'
                                -- �� ���� �����
                                INNER JOIN MovementLinkObject AS MLO_To
                                                              ON MLO_To.MovementId = Movement.Id
                                                             AND MLO_To.DescId     = zc_MovementLinkObject_To()
                                                             AND MLO_To.ObjectId   = vbUnitId
                                -- ������� ������
                                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId     = zc_MI_Child()
                                                       AND MovementItem.isErased   = FALSE
                                                       AND MovementItem.Amount     > 0
                                -- ������� ������ �� ������
                                INNER JOIN MovementItem AS MovementItem_parent
                                                        ON MovementItem_parent.MovementId = Movement.Id
                                                       AND MovementItem_parent.DescId     = zc_MI_Master()
                                                       AND MovementItem_parent.Id         = MovementItem.ParentId
                                                       AND MovementItem_parent.isErased   = FALSE
                                                    --AND MovementItem_parent.Amount + COALESCE (MIFloat_AmountSecond_parent.ValueData, 0) > 0
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                 ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                -- ������ ��� "�������" �� ������� ������
                                INNER JOIN (SELECT DISTINCT tmpMI.GoodsId_sub, tmpMI.GoodsKindId_sub FROM tmpMI
                                           ) AS tmpGoods
                                             ON tmpGoods.GoodsId_sub      = MovementItem.ObjectId
                                            AND tmpGoods.GoodsKindId_sub = MILinkObject_GoodsKind.ObjectId
                           WHERE Movement.DescId   = zc_Movement_OrderExternal()
                             AND Movement.StatusId = zc_Enum_Status_Complete()
                             AND Movement.Id      <> inMovementId
                          )
        , tmpMI_Float AS (SELECT MIF.MovementItemId, MIF.DescId, MIF.ValueData :: Integer AS MovementId
                          FROM MovementItemFloat AS MIF
                          WHERE MIF.MovementItemId IN (SELECT DISTINCT tmpMIChild_All.MovementItemId FROM tmpMIChild_All)
                            AND MIF.DescId         = zc_MIFloat_MovementId()
                            AND MIF.ValueData      > 0
                         )
            -- ������, � ������� ���� ������ �� ��� "�����" ��� �����
          , tmpMIChild AS (SELECT tmpMIChild_All.GoodsId_sub
                                , tmpMIChild_All.GoodsKindId_sub
                                , SUM (tmpMIChild_All.Amount) AS Amount
                           FROM tmpMIChild_All
                                LEFT JOIN tmpMI_Float AS MIFloat_Movement
                                                      ON MIFloat_Movement.MovementItemId = tmpMIChild_All.MovementItemId
                                                     AND MIFloat_Movement.DescId         = zc_MIFloat_MovementId()
                                LEFT JOIN Movement ON Movement.Id = MIFloat_Movement.MovementId
                                                  AND Movement.OperDate < vbOperDate
                           -- ���� ��� ������� �� � ����������� ����������� !!!�� �������!!!, ������� ����������� - �����
                           WHERE Movement.Id IS NULL
                           GROUP BY tmpMIChild_All.GoodsId_sub
                                  , tmpMIChild_All.GoodsKindId_sub
                          )
    -- �������
  , tmpContainer_all AS (SELECT Container.Id       AS ContainerId
                              , Container.ObjectId AS GoodsId_sub
                              , Container.Amount
                         FROM Container
                              INNER JOIN ContainerLinkObject AS CLO_Unit
                                                             ON CLO_Unit.ContainerId = Container.Id
                                                            AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                            AND CLO_Unit.ObjectId    = vbUnitId
                              -- ������ ��� "�������" �� ������� ������
                              INNER JOIN (SELECT DISTINCT tmpMI.GoodsId_sub FROM tmpMI) AS tmpGoods ON tmpGoods.GoodsId_sub = Container.ObjectId

                              LEFT JOIN ContainerLinkObject AS CLO_Account
                                                            ON CLO_Account.ContainerId = CLO_Unit.ContainerId
                                                           AND CLO_Account.DescId = zc_ContainerLinkObject_Account()

                         WHERE Container.DescId = zc_Container_Count()
                           AND CLO_Account.ContainerId IS NULL -- !!!�.�. ��� ����� �������!!!
                         )
      , tmpCLO_GoodsKind_rem AS (SELECT CLO_GoodsKind.*
                                 FROM ContainerLinkObject AS CLO_GoodsKind
                                 WHERE CLO_GoodsKind.ContainerId IN (SELECT DISTINCT tmpContainer_all.ContainerId FROM tmpContainer_all)
                                   AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                )
        -- �������
      , tmpContainer AS (SELECT tmpContainer_all.ContainerId      AS ContainerId
                              , tmpContainer_all.GoodsId_sub      AS GoodsId_sub
                              , tmpCLO_GoodsKind_rem.ObjectId     AS GoodsKindId_sub
                              , tmpContainer_all.Amount
                         FROM tmpContainer_all
                              INNER JOIN tmpCLO_GoodsKind_rem ON tmpCLO_GoodsKind_rem.ContainerId = tmpContainer_all.ContainerId
                                                             AND tmpCLO_GoodsKind_rem.DescId      = zc_ContainerLinkObject_GoodsKind()
                              -- ������ ��� "�������" �� ������� ������
                              INNER JOIN (SELECT DISTINCT tmpMI.GoodsId_sub, tmpMI.GoodsKindId_sub FROM tmpMI
                                         ) AS tmpGoods
                                           ON tmpGoods.GoodsId_sub      = tmpContainer_all.GoodsId_sub
                                          AND tmpGoods.GoodsKindId_sub = tmpCLO_GoodsKind_rem.ObjectId
                         )
        -- ������� �� ����
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
         -- ���������
          INSERT INTO _tmpMIMaster (Id, GoodsId, GoodsKindId, GoodsId_sub, GoodsKindId_sub, Amount, Remains, Amount_diff)
            SELECT tmpMI.Id
                 , tmpMI.GoodsId
                 , tmpMI.GoodsKindId
                 , tmpMI.GoodsId_sub
                 , tmpMI.GoodsKindId_sub

                   -- ������ - � ��.���. MeasureId_sub
                 , tmpMI.Amount

                   -- ������� ��������� - ���������������
                 , COALESCE (tmpRemains.Amount, 0) * CASE WHEN tmpMI_group.Amount > tmpMI.Amount THEN tmpMI.Amount / tmpMI_group.Amount ELSE 1 END
                   AS Remains
                   -- "���������" ������� ��� ������ - ���������������
                 , (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMIChild.Amount, 0)) 
                 * CASE WHEN tmpMI_group.Amount > tmpMI.Amount THEN tmpMI.Amount / tmpMI_group.Amount ELSE 1 END
                   AS Amount_diff

            FROM tmpMI
                 LEFT JOIN tmpMI_group ON tmpMI_group.GoodsId_sub     = tmpMI.GoodsId_sub
                                      AND tmpMI_group.GoodsKindId_sub = tmpMI.GoodsKindId_sub
                 LEFT JOIN tmpRemains ON tmpRemains.GoodsId_sub     = tmpMI.GoodsId_sub
                                     AND tmpRemains.GoodsKindId_sub = tmpMI.GoodsKindId_sub
                 LEFT JOIN tmpMIChild ON tmpMIChild.GoodsId_sub     = tmpMI.GoodsId_sub
                                     AND tmpMIChild.GoodsKindId_sub = tmpMI.GoodsKindId_sub
            -- ���� ���� "���������" �������
            WHERE COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMIChild.Amount, 0) > 0
           ;


     -- ���������
     PERFORM lpInsertUpdate_MI_OrderExternal_Child (ioId                 := tmpMI.MovementItemId
                                                  , inParentId           := tmpMI.ParentId
                                                  , inMovementId         := inMovementId
                                                  , inGoodsId            := tmpMI.GoodsId_sub
                                                  , inAmount             := CASE -- ���� "����������" ������� �������, ����� ������ ���� �������
                                                                                 WHEN COALESCE (tmpMI.Amount_diff, 0) >= COALESCE (tmpMI.Amount,0)
                                                                                      THEN COALESCE (tmpMI.Amount,0)
                                                                                 -- ����� ������ "���������" �������
                                                                                 WHEN tmpMI.Amount_diff > 0 THEN tmpMI.Amount_diff
                                                                                 -- ����� 0
                                                                                 ELSE 0
                                                                            END
                                                  , inAmountRemains      := tmpMI.Remains
                                                  , inGoodsKindId        := tmpMI.GoodsKindId_sub
                                                  , inMovementId_Send    := NULL
                                                  , inUserId             := vbUserId
                                                   )
     FROM (WITH -- ����� �������� - �������
                tmpMI_all AS (SELECT MovementItem.Id
                                   , MovementItem.ParentId
                                   , MovementItem.ObjectId                         AS GoodsId_sub
                                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId_sub
                                     -- � �/�
                                   , ROW_NUMBER() OVER (PARTITION BY MovementItem.ParentId, MovementItem.ObjectId, COALESCE (MILinkObject_GoodsKind.ObjectId, 0) ORDER BY MovementItem.Id ASC) AS Ord
                              FROM MovementItem
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                              WHERE MovementItem.MovementId = inMovementId
                                AND MovementItem.DescId     = zc_MI_Child()
                                AND MovementItem.isErased   = FALSE
                             )
          -- ������ ���������� �����������
        , tmpMI_Float AS (SELECT MIF.*
                          FROM MovementItemFloat AS MIF
                          WHERE MIF.MovementItemId IN (SELECT DISTINCT tmpMI_all.Id FROM tmpMI_all)
                            AND MIF.DescId         = zc_MIFloat_MovementId()
                            AND MIF.ValueData      > 0
                         )
              , tmpMI AS (SELECT MovementItem.Id
                               , MovementItem.ParentId
                               , MovementItem.GoodsId_sub
                               , MovementItem.GoodsKindId_sub
                                 -- � �/�
                               , ROW_NUMBER() OVER (PARTITION BY MovementItem.ParentId, MovementItem.GoodsId_sub, MovementItem.GoodsKindId_sub ORDER BY MovementItem.Id ASC) AS Ord
                          FROM tmpMI_all AS MovementItem
                               LEFT JOIN tmpMI_Float AS MIFloat_Movement
                                                     ON MIFloat_Movement.MovementItemId = MovementItem.Id
                                                    AND MIFloat_Movement.DescId         = zc_MIFloat_MovementId()
                          -- ���� ��� ������� �� � ����������� �����������
                          WHERE MIFloat_Movement.ValueData IS NULL
                         )
           -- ���������
           SELECT COALESCE (_tmpMIMaster.Id, tmpMI.ParentId)                     AS ParentId
                , tmpMI.Id                                                       AS MovementItemId
                , COALESCE (_tmpMIMaster.GoodsId_sub,     tmpMI.GoodsId_sub)     AS GoodsId_sub
                , COALESCE (_tmpMIMaster.GoodsKindId_sub, tmpMI.GoodsKindId_sub) AS GoodsKindId_sub
                , CASE WHEN COALESCE (tmpMI.Ord, 1) = 1 THEN _tmpMIMaster.Amount_diff ELSE 0 END AS Amount_diff
                , COALESCE (_tmpMIMaster.Remains, 0) AS Remains
                , COALESCE (_tmpMIMaster.Amount, 0)  AS Amount
           FROM _tmpMIMaster
                FULL JOIN tmpMI ON tmpMI.ParentId        = _tmpMIMaster.Id
                               AND tmpMI.GoodsId_sub     = _tmpMIMaster.GoodsId_sub
                               AND tmpMI.GoodsKindId_sub = _tmpMIMaster.GoodsKindId_sub
          ) AS tmpMI
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�..
 18.06.22         *
*/

-- ����
