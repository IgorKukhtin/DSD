-- Function: lpComplete_Movement_ProductionUnion_Recalc (Integer, Boolean)

DROP FUNCTION IF EXISTS lpComplete_Movement_ProductionUnion_Recalc (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_ProductionUnion_Recalc(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUnitId            Integer  , --
    IN inUserId            Integer    -- ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbMovementId_Peresort Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
     -- ����� ����
     vbOperDate:= (SELECT OperDate FROM Movement WHERE Id = inMovementId);


     -- �������� ����������� - !!!������ ��� ����� ������!!!
     IF inUnitId IN (8447 -- ��� ���������
                   , 8448 -- ��� �����������
                   , 8449 -- ��� �/�
                    )
        -- AND inUserId = 5
        AND NOT EXISTS (SELECT MLM.MovementId FROM MovementLinkMovement AS MLM WHERE MLM.MovementId = inMovementId AND MLM.DescId = zc_MovementLinkMovement_Production() AND MLM.MovementChildId > 0)
        AND NOT EXISTS (SELECT MB.MovementId FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_Peresort() AND MB.ValueData = TRUE)
     THEN

     -- ����� "�����������"
     vbMovementId_Peresort:= (SELECT MLM.MovementId FROM MovementLinkMovement AS MLM WHERE MLM.MovementChildId = inMovementId AND MLM.DescId = zc_MovementLinkMovement_Production());

     -- ������� - ��������
     CREATE TEMP TABLE _tmpItemPeresort_new (MovementItemId_to Integer, MovementItemId_from Integer, GoodsId_to Integer, GoodsKindId_to Integer, GoodsId_from Integer, GoodsKindId_from Integer, Amount_to TFloat) ON COMMIT DROP;

     -- ��������
     INSERT INTO _tmpItemPeresort_new (MovementItemId_to, MovementItemId_from, GoodsId_to, GoodsKindId_to, GoodsId_from, GoodsKindId_from, Amount_to)
        WITH tmpGoodsByGoodsKind_one AS
             -- ������� - ������ �����
            (SELECT -- ����� �������
                    _tmpItem.GoodsId
                    -- ����� ��������
                  , ObjectLink_GoodsByGoodsKind_GoodsSub.ChildObjectId AS GoodsId_find
                    -- � �/� - �� ������ ������
                  , ROW_NUMBER() OVER (PARTITION BY _tmpItem.GoodsId
                                       ORDER BY ObjectLink_GoodsByGoodsKind_Goods.ObjectId DESC
                                      ) AS Ord

             FROM (SELECT DISTINCT _tmpItemChild.GoodsId FROM _tmpItemChild
                  ) AS _tmpItem
                  -- ����� �������
                  INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                        ON ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = _tmpItem.GoodsId
                                       AND ObjectLink_GoodsByGoodsKind_Goods.DescId        = zc_ObjectLink_GoodsByGoodsKind_Goods()
                  -- �� ������
                  INNER JOIN Object AS Object_GoodsByGoodsKind ON Object_GoodsByGoodsKind.Id       = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                              AND Object_GoodsByGoodsKind.isErased = FALSE
                  -- ����� �������� - GoodsSub
                  INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsSub
                                        ON ObjectLink_GoodsByGoodsKind_GoodsSub.ObjectId      = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                       AND ObjectLink_GoodsByGoodsKind_GoodsSub.DescId        = zc_ObjectLink_GoodsByGoodsKind_GoodsSub()
                                       -- ���� �� ����
                                       AND ObjectLink_GoodsByGoodsKind_GoodsSub.ChildObjectId > 0
            )
          -- ������� � �������
        , tmpGoodsByGoodsKind AS
            (SELECT -- ����� �������
                    _tmpItem.GoodsId
                    -- ������
                  , COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, zc_GoodsKind_Basis())        AS GoodsKindId
                    -- ����� ��������
                  , ObjectLink_GoodsByGoodsKind_GoodsSub_CEH.ChildObjectId                                      AS GoodsId_find
                    -- ������
                  , COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKindSub_CEH.ChildObjectId, zc_GoodsKind_Basis()) AS GoodsKindId_find

                    -- � �/� - �� ������ ������
                  , ROW_NUMBER() OVER (PARTITION BY _tmpItem.GoodsId, COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, zc_GoodsKind_Basis())
                                       ORDER BY ObjectLink_GoodsByGoodsKind_Goods.ObjectId DESC
                                      ) AS Ord
             FROM (SELECT DISTINCT _tmpItemChild.GoodsId FROM _tmpItemChild
                  ) AS _tmpItem
                  -- ����� �������
                  INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                        ON ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = _tmpItem.GoodsId
                                       AND ObjectLink_GoodsByGoodsKind_Goods.DescId        = zc_ObjectLink_GoodsByGoodsKind_Goods()
                  LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                       ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                      AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                  -- �� ������
                  INNER JOIN Object AS Object_GoodsByGoodsKind ON Object_GoodsByGoodsKind.Id       = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                              AND Object_GoodsByGoodsKind.isErased = FALSE

                  -- ����� �������� - GoodsSub_CEH
                  INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsSub_CEH
                                        ON ObjectLink_GoodsByGoodsKind_GoodsSub_CEH.ObjectId      = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                       AND ObjectLink_GoodsByGoodsKind_GoodsSub_CEH.DescId        = zc_ObjectLink_GoodsByGoodsKind_GoodsSub_CEH()
                                       -- ���� �� ����
                                       AND ObjectLink_GoodsByGoodsKind_GoodsSub_CEH.ChildObjectId > 0
                  LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKindSub_CEH
                                       ON ObjectLink_GoodsByGoodsKind_GoodsKindSub_CEH.ObjectId      = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                      AND ObjectLink_GoodsByGoodsKind_GoodsKindSub_CEH.DescId        = zc_ObjectLink_GoodsByGoodsKind_GoodsKindSub_CEH()
                  -- �� ����
                  INNER JOIN ObjectDate AS ObjectDate_GoodsByGoodsKind_GoodsKindSub_CEH_start
                                        ON ObjectDate_GoodsByGoodsKind_GoodsKindSub_CEH_start.ObjectId  = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                       AND ObjectDate_GoodsByGoodsKind_GoodsKindSub_CEH_start.DescId    = zc_ObjectDate_GoodsByGoodsKind_GoodsKindSub_CEH_start()
                                       AND ObjectDate_GoodsByGoodsKind_GoodsKindSub_CEH_start.ValueData <= vbOperDate
            )
        -- ���������
        SELECT 0                                                      AS MovementItemId_to
             , 0                                                      AS MovementItemId_from
               -- ���� ����� ����� � �������
             , _tmpItem.GoodsId                                       AS GoodsId_to
             , 0                                                      AS GoodsKindId_to
               -- ����� �������� - ������
             , tmpGoodsByGoodsKind_one.GoodsId_find                   AS GoodsId_from
             , 0                                                      AS GoodsKindId_from
             , SUM (_tmpItem.OperCount)                               AS Amount_to

        FROM -- �������� ������ - ����
             (SELECT _tmpItemChild.GoodsId, SUM (_tmpItemChild.OperCount) AS OperCount
              FROM _tmpItemChild
              WHERE _tmpItemChild.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10200() -- �������� ����� ������ �����
                                                            )
                 OR _tmpItemChild.InfoMoneyId IN (zc_Enum_InfoMoney_10106() -- �������� ����� + ������ ����� + ���
                                                 )
              GROUP BY _tmpItemChild.GoodsId
             ) AS _tmpItem
             -- ����� - ����� ����� � ������� - GoodsSub
             INNER JOIN tmpGoodsByGoodsKind_one ON tmpGoodsByGoodsKind_one.GoodsId = _tmpItem.GoodsId
                                               -- � �/� - �� ������ ������
                                               AND tmpGoodsByGoodsKind_one.Ord      = 1
        -- !!!���� ��������� ������!!!
        WHERE _tmpItem.GoodsId <> tmpGoodsByGoodsKind_one.GoodsId_find
        GROUP BY _tmpItem.GoodsId
               , tmpGoodsByGoodsKind_one.GoodsId_find

       UNION ALL
        SELECT 0                                                      AS MovementItemId_to
             , 0                                                      AS MovementItemId_from
               -- ���� ����� ����� � �������
             , _tmpItem.GoodsId                                       AS GoodsId_to
             , _tmpItem.GoodsKindId                                   AS GoodsKindId_to
               -- ����� �������� - ������
             , tmpGoodsByGoodsKind.GoodsId_find                       AS GoodsId_from
             , tmpGoodsByGoodsKind.GoodsKindId_find                   AS GoodsKindId_from
             , SUM (_tmpItem.OperCount)                               AS Amount_to

        FROM -- �������� ������ - ����
             (SELECT _tmpItemChild.GoodsId
                   , CASE WHEN _tmpItemChild.GoodsKindId > 0 THEN _tmpItemChild.GoodsKindId ELSE zc_GoodsKind_Basis() END AS GoodsKindId
                   , SUM (_tmpItemChild.OperCount) AS OperCount
              FROM _tmpItemChild
              WHERE _tmpItemChild.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- �������� ����� ������ �����
              GROUP BY _tmpItemChild.GoodsId, _tmpItemChild.GoodsKindId
             ) AS _tmpItem
             -- ����� - ����� ����� � ������� - GoodsSub_CEH
             INNER JOIN tmpGoodsByGoodsKind ON tmpGoodsByGoodsKind.GoodsId     = _tmpItem.GoodsId
                                           -- ��� ��������
                                           AND tmpGoodsByGoodsKind.GoodsKindId = _tmpItem.GoodsKindId
                                           -- � �/� - �� ������ ������
                                           AND tmpGoodsByGoodsKind.Ord         = 1
        GROUP BY _tmpItem.GoodsId
               , _tmpItem.GoodsKindId
               , tmpGoodsByGoodsKind.GoodsId_find
               , tmpGoodsByGoodsKind.GoodsKindId_find
                ;

--     RAISE EXCEPTION '��� %', (select count(*) from _tmpItemPeresort_new);

     IF EXISTS (SELECT 1 FROM _tmpItemPeresort_new)
     THEN
         -- ����� MovementItemId - Master
         UPDATE _tmpItemPeresort_new SET MovementItemId_to = tmpMI.MovementItemId_to
         FROM (SELECT MovementItem.Id                                                                         AS MovementItemId_to
                    , MovementItem.ObjectId                                                                   AS GoodsId_to
                    , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)                                           AS GoodsKindId_to
                    , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId, MILinkObject_GoodsKind.ObjectId) AS Ord
               FROM MovementItem
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                     ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
               WHERE MovementItem.MovementId = vbMovementId_Peresort
                 AND MovementItem.DescId     = zc_MI_Master()
                 AND MovementItem.isErased   = FALSE
              ) AS tmpMI
         WHERE _tmpItemPeresort_new.GoodsId_to     = tmpMI.GoodsId_to
           AND _tmpItemPeresort_new.GoodsKindId_to = tmpMI.GoodsKindId_to
           AND tmpMI.Ord                           = 1
        ;

         -- ����� MovementItemId - Child
         UPDATE _tmpItemPeresort_new SET MovementItemId_from   = tmpMI.MovementItemId_from
         FROM (SELECT MI_Child.ParentId                                                                                      AS MovementItemId_to
                    , MI_Child.Id                                                                                            AS MovementItemId_from
                    , MI_Child.ObjectId                                                                                      AS GoodsId_from
                    , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)                                                          AS GoodsKindId_from
                    , ROW_NUMBER() OVER (PARTITION BY MI_Child.ParentId, MI_Child.ObjectId, MILinkObject_GoodsKind.ObjectId) AS Ord
               FROM MovementItem AS MI_Child
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                     ON MILinkObject_GoodsKind.MovementItemId = MI_Child.Id
                                                    AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
               WHERE MI_Child.MovementId = vbMovementId_Peresort
                 AND MI_Child.DescId     = zc_MI_Child()
                 AND MI_Child.isErased   = FALSE
              ) AS tmpMI
         WHERE _tmpItemPeresort_new.MovementItemId_to = tmpMI.MovementItemId_to
           AND _tmpItemPeresort_new.GoodsId_from      = tmpMI.GoodsId_from
           AND _tmpItemPeresort_new.GoodsKindId_from  = tmpMI.GoodsKindId_from
           AND tmpMI.Ord                              = 1
        ;


         -- �������� - ��� � ������ �� ������
         IF vbMovementId_Peresort <> 0
         THEN
            IF -- ���� ��� ��������� ������� ���� ��������
               NOT EXISTS (SELECT 1 FROM _tmpItemPeresort_new WHERE MovementItemId_to = 0 OR MovementItemId_from = 0)
               -- ���� ��� ��������� Master + Child ������� ��������� �������
           AND NOT EXISTS (SELECT 1 FROM MovementItem LEFT JOIN (SELECT MovementItemId_to AS MovementItemId FROM _tmpItemPeresort_new UNION ALL SELECT MovementItemId_from AS MovementItemId FROM _tmpItemPeresort_new) AS tmp ON tmp.MovementItemId = MovementItem.Id
                           WHERE MovementItem.MovementId = vbMovementId_Peresort AND MovementItem.isErased   = FALSE AND tmp.MovementItemId IS NULL)
               -- ���� �� ��������� Master ��� ��������� � ���-�� - ����������� ����� ������ ��� ��� ��� ������������
           AND NOT EXISTS (SELECT 1 FROM MovementItem INNER JOIN (SELECT DISTINCT _tmpItemPeresort_new.MovementItemId_to, _tmpItemPeresort_new.Amount_to FROM _tmpItemPeresort_new) AS tmp ON tmp.MovementItemId_to = MovementItem.Id
                           WHERE MovementItem.MovementId = vbMovementId_Peresort AND MovementItem.Amount <> tmp.Amount_to)
            THEN
                -- ������ ������ �������
                if inUserId = 5 then RAISE EXCEPTION 'OK - �������� - ��� � ������ �� ������'; end if;
                -- !!!�����!!!
                RETURN;
            END IF;

            -- ������ ������ �������
            if inUserId = 5 then RAISE EXCEPTION '������ - ��� �������� - ��� � ������ �� ������  <%>', (SELECT COUNT(*) FROM _tmpItemPeresort_new); end if;

         END IF;


         -- ����������
         IF vbMovementId_Peresort <> 0
         THEN
             PERFORM lpUnComplete_Movement (inMovementId := vbMovementId_Peresort
                                          , inUserId     := inUserId
                                           );
         END IF;


         -- ��������� �������� - <������������ ����������> - �����������
         vbMovementId_Peresort:= lpInsertUpdate_Movement_ProductionUnion (ioId             := vbMovementId_Peresort
                                                                        , inInvNumber      := CASE WHEN vbMovementId_Peresort <> 0 THEN (SELECT InvNumber FROM Movement WHERE Id = vbMovementId_Peresort) ELSE CAST (NEXTVAL ('movement_ProductionUnion_seq') AS TVarChar) END
                                                                        , inOperDate       := vbOperDate
                                                                        , inFromId         := (SELECT ObjectId FROM MovementLinkObject AS MLO WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_From())
                                                                        , inToId           := (SELECT ObjectId FROM MovementLinkObject AS MLO WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_From())
                                                                        , inDocumentKindId := 0
                                                                        , inIsPeresort     := TRUE
                                                                        , inUserId         := inUserId
                                                                         );
         -- ��������� �������� <������������� �����������>
         PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), vbMovementId_Peresort, TRUE);

         -- ��������� �������� - Master + Child
         PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id
                                         , inUserId        := inUserId
                                          )
         FROM MovementItem
              LEFT JOIN (SELECT MovementItemId_to   AS MovementItemId FROM _tmpItemPeresort_new
                        UNION ALL
                         SELECT MovementItemId_from AS MovementItemId FROM _tmpItemPeresort_new
                       ) AS tmp ON tmp.MovementItemId = MovementItem.Id
         WHERE MovementItem.MovementId = vbMovementId_Peresort
           AND MovementItem.isErased   = FALSE
           AND tmp.MovementItemId IS NULL
        ;

         -- ��������� � ����. �������� - Master
         UPDATE _tmpItemPeresort_new SET MovementItemId_to = tmpMI.MovementItemId_new
         FROM (SELECT tmp.MovementItemId_new, tmp.GoodsId_to, tmp.GoodsKindId_to

               FROM (SELECT tmp.GoodsId_to, tmp.GoodsKindId_to
                          , -- ��������� �������� - Master
                            lpInsertUpdate_MI_ProductionUnion_Master
                                                        (ioId                     := tmp.MovementItemId_to
                                                       , inMovementId             := vbMovementId_Peresort
                                                       , inGoodsId                := tmp.GoodsId_to
                                                       , inAmount                 := tmp.Amount_to
                                                       , inCount                  := 0
                                                       , inCuterWeight            := 0
                                                       , inPartionGoodsDate       := NULL
                                                       , inPartionGoods           := NULL
                                                       , inPartNumber             := NULL
                                                       , inModel                  := NULL
                                                       , inGoodsKindId            := tmp.GoodsKindId_to
                                                       , inGoodsKindId_Complete   := NULL
                                                       , inStorageId              := NULL
                                                       , inUserId                 := inUserId
                                                        ) AS MovementItemId_new
                     FROM (-- ����������� ����� ������ ��� ��� ��� ������������
                           SELECT DISTINCT _tmpItemPeresort_new.MovementItemId_to, _tmpItemPeresort_new.GoodsId_to, _tmpItemPeresort_new.GoodsKindId_to, _tmpItemPeresort_new.Amount_to
                           FROM _tmpItemPeresort_new
                          ) AS tmp
                    ) AS tmp
              ) AS tmpMI
         WHERE _tmpItemPeresort_new.GoodsId_to     = tmpMI.GoodsId_to
           AND _tmpItemPeresort_new.GoodsKindId_to = tmpMI.GoodsKindId_to
        ;

         -- ��������� �������� - Child
         PERFORM lpInsertUpdate_MI_ProductionUnion_Child
                                                  (ioId                     := _tmpItemPeresort_new.MovementItemId_from
                                                 , inMovementId             := vbMovementId_Peresort
                                                 , inGoodsId                := _tmpItemPeresort_new.GoodsId_from
                                                 , inAmount                 := CASE -- ���� ��� �� ������������ � ���� ��������� � ���
                                                                                    WHEN ObjectFloat_Weight.ValueData <> 0 AND ObjectLink_Goods_Measure_to.ChildObjectId = zc_Measure_Sh()
                                                                                         THEN _tmpItemPeresort_new.Amount_to * ObjectFloat_Weight.ValueData
                                                                                    -- ���� ��� �� ������������ � ���� ��������� � ��
                                                                                    WHEN ObjectFloat_Weight.ValueData <> 0 AND ObjectLink_Goods_Measure_from.ChildObjectId = zc_Measure_Sh()
                                                                                         THEN _tmpItemPeresort_new.Amount_to / ObjectFloat_Weight.ValueData
                                                                                    -- ����� ... ?
                                                                                    ELSE _tmpItemPeresort_new.Amount_to
                                                                               END
                                                 , inParentId               := _tmpItemPeresort_new.MovementItemId_to
                                                 , inPartionGoodsDate       := NULL
                                                 , inPartionGoods           := NULL
                                                 , inPartNumber             := NULL
                                                 , inModel                  := NULL
                                                 , inGoodsKindId            := _tmpItemPeresort_new.GoodsKindId_from
                                                 , inGoodsKindCompleteId    := NULL
                                                 , inStorageId              := NULL
                                                 , inCount_onCount          := 0
                                                 , inUserId                 := inUserId
                                                  )
         FROM _tmpItemPeresort_new
              LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure_to ON ObjectLink_Goods_Measure_to.ObjectId = _tmpItemPeresort_new.GoodsId_to
                                                                 AND ObjectLink_Goods_Measure_to.DescId = zc_ObjectLink_Goods_Measure()
              LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure_from ON ObjectLink_Goods_Measure_from.ObjectId = _tmpItemPeresort_new.GoodsId_from
                                                                   AND ObjectLink_Goods_Measure_from.DescId = zc_ObjectLink_Goods_Measure()
              LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                    ON ObjectFloat_Weight.ObjectId = CASE WHEN ObjectLink_Goods_Measure_to.ChildObjectId = zc_Measure_Sh() AND COALESCE (ObjectLink_Goods_Measure_from.ChildObjectId, 0) <> zc_Measure_Sh()
                                                                               THEN ObjectLink_Goods_Measure_to.ObjectId
                                                                          WHEN ObjectLink_Goods_Measure_from.ChildObjectId = zc_Measure_Sh() AND COALESCE (ObjectLink_Goods_Measure_to.ChildObjectId, 0) <> zc_Measure_Sh()
                                                                               THEN ObjectLink_Goods_Measure_from.ObjectId
                                                                     END
                                   AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight();

         -- ��������� ����� ����������
         PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Production(), vbMovementId_Peresort, inMovementId);

         -- ��������
         PERFORM lpComplete_Movement_ProductionUnion (inMovementId     := vbMovementId_Peresort
                                                    , inIsHistoryCost  := TRUE
                                                    , inUserId         := inUserId)
        ;
     ELSE
         IF vbMovementId_Peresort <> 0 AND zc_Enum_Status_Erased() <> (SELECT StatusId FROM Movement WHERE Id = vbMovementId_Peresort)
         THEN
             PERFORM lpSetErased_Movement (inMovementId := vbMovementId_Peresort
                                         , inUserId     := inUserId
                                          );
         END IF;

     END IF;
     END IF; -- if ... �������� ����������� - !!!������ ��� ����� ������!!!

     -- ������ ������ �������
     if inUserId = 5 then RAISE EXCEPTION '��� ���� � ��� �������� - ��� � ������ �� ������'; end if;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.05.23         *
 30.01.19                                        *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_ProductionUnion_Recalc (inMovementId:= 4691383, inUnitId:= 8459, inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM gpReComplete_Movement_SendOnPrice (inMovementId:= 4691383, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpReComplete_Movement_ProductionUnion (inMovementId:= 4691383, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
