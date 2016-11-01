-- Function: lpComplete_Movement_Sale_Recalc (Integer, Boolean)

DROP FUNCTION IF EXISTS lpComplete_Movement_Sale_Recalc (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Sale_Recalc(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUnitId            Integer  , -- 
    IN inUserId            Integer    -- ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbMovementId_Peresort Integer;
BEGIN
     -- �������� ����������� - !!!������ ��� ����� ������!!!
     IF inUnitId = 8459 -- ����� ����������
        AND inUserId = 5
     THEN

     -- ����� "�����������" ��� "�������"
     vbMovementId_Peresort:= (SELECT MLM.MovementId FROM MovementLinkMovement AS MLM WHERE MLM.MovementChildId = inMovementId AND MLM.DescId = zc_MovementLinkMovement_Production());

     -- ������� - ��������
     CREATE TEMP TABLE _tmpItemPeresort_new (MovementItemId_to Integer, MovementItemId_from Integer, GoodsId_to Integer, GoodsKindId_to Integer, GoodsId_from Integer, GoodsKindId_from Integer, ReceipId_to Integer, Amount_to TFloat) ON COMMIT DROP;

     -- ��������
     INSERT INTO _tmpItemPeresort_new (MovementItemId_to, MovementItemId_from, GoodsId_to, GoodsKindId_to, GoodsId_from, GoodsKindId_from, ReceipId_to, Amount_to)
        SELECT 0                                                      AS MovementItemId_to
             , 0                                                      AS MovementItemId_from
             , _tmpItem.GoodsId                                       AS GoodsId_to
             , _tmpItem.GoodsKindId                                   AS GoodsKindId_to
             , ObjectLink_GoodsByGoodsKind_GoodsSub.ChildObjectId     AS GoodsId_from
             , ObjectLink_GoodsByGoodsKind_GoodsKindSub.ChildObjectId AS GoodsKindId_from
             , ObjectLink_GoodsByGoodsKind_Receipt.ChildObjectId      AS ReceipId_to
             , SUM (_tmpItem.OperCount)                               AS Amount_to
        FROM _tmpItem
             INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                   ON ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = _tmpItem.GoodsId
                                  AND ObjectLink_GoodsByGoodsKind_Goods.DescId        = zc_ObjectLink_GoodsByGoodsKind_Goods()
             INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                   ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId      = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                  AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId        = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                  AND ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId = _tmpItem.GoodsKindId
             INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsSub
                                   ON ObjectLink_GoodsByGoodsKind_GoodsSub.ObjectId      = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                  AND ObjectLink_GoodsByGoodsKind_GoodsSub.DescId        = zc_ObjectLink_GoodsByGoodsKind_GoodsSub()
                                  AND ObjectLink_GoodsByGoodsKind_GoodsSub.ChildObjectId > 0
             INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKindSub
                                   ON ObjectLink_GoodsByGoodsKind_GoodsKindSub.ObjectId      = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                  AND ObjectLink_GoodsByGoodsKind_GoodsKindSub.DescId        = zc_ObjectLink_GoodsByGoodsKind_GoodsKindSub()
                                  AND ObjectLink_GoodsByGoodsKind_GoodsKindSub.ChildObjectId > 0
             LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Receipt
                                  ON ObjectLink_GoodsByGoodsKind_Receipt.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                 AND ObjectLink_GoodsByGoodsKind_Receipt.DescId   = zc_ObjectLink_GoodsByGoodsKind_Receipt()

        WHERE _tmpItem.GoodsId      <> ObjectLink_GoodsByGoodsKind_GoodsSub.ChildObjectId
           OR _tmpItem.GoodsKindId  <> ObjectLink_GoodsByGoodsKind_GoodsKindSub.ChildObjectId
        GROUP BY _tmpItem.GoodsId
               , _tmpItem.GoodsKindId
               , ObjectLink_GoodsByGoodsKind_GoodsSub.ChildObjectId
               , ObjectLink_GoodsByGoodsKind_GoodsKindSub.ChildObjectId
               , ObjectLink_GoodsByGoodsKind_Receipt.ChildObjectId
                ;

     -- �������� - �������� ��� �� ��� �� ���������
     INSERT INTO _tmpItemPeresort_new (MovementItemId_to, MovementItemId_from, GoodsId_to, GoodsKindId_to, GoodsId_from, GoodsKindId_from, ReceipId_to, Amount_to)
        SELECT 0                                                      AS MovementItemId_to
             , 0                                                      AS MovementItemId_from
             , _tmpItemPeresort_new.GoodsId_to                        AS GoodsId_to
             , _tmpItemPeresort_new.GoodsKindId_to                    AS GoodsKindId_to
             , ObjectLink_ReceiptChild_Goods.ChildObjectId            AS GoodsId_from
             , COALESCE (ObjectLink_ReceiptChild_GoodsKind.ChildObjectId, 0) AS GoodsKindId_from
             , -- �.�. ���� ����� �������� ���-�� ��� �� �� ������ ������������
               -1 * _tmpItemPeresort_new.ReceipId_to                  AS ReceipId_to
             , _tmpItemPeresort_new.Amount_to * ObjectFloat_Value.ValueData / ObjectFloat_Value_master.ValueData AS Amount_to
        FROM _tmpItemPeresort_new
                              INNER JOIN ObjectFloat AS ObjectFloat_Value_master
                                                     ON ObjectFloat_Value_master.ObjectId = _tmpItemPeresort_new.ReceipId_to
                                                    AND ObjectFloat_Value_master.DescId = zc_ObjectFloat_Receipt_Value()
                                                    AND ObjectFloat_Value_master.ValueData <> 0
                              INNER JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                                                   ON ObjectLink_ReceiptChild_Receipt.ChildObjectId = _tmpItemPeresort_new.ReceipId_to
                                                  AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()
                              INNER JOIN Object AS Object_ReceiptChild ON Object_ReceiptChild.Id = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                                      AND Object_ReceiptChild.isErased = FALSE
                              LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                                   ON ObjectLink_ReceiptChild_Goods.ObjectId = Object_ReceiptChild.Id
                                                  AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
                              LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_GoodsKind
                                                   ON ObjectLink_ReceiptChild_GoodsKind.ObjectId = Object_ReceiptChild.Id
                                                  AND ObjectLink_ReceiptChild_GoodsKind.DescId = zc_ObjectLink_ReceiptChild_GoodsKind()
                              INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                     ON ObjectFloat_Value.ObjectId = Object_ReceiptChild.Id
                                                    AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()
                                                    AND ObjectFloat_Value.ValueData <> 0
                              LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                   ON ObjectLink_Goods_InfoMoney.ObjectId = ObjectLink_ReceiptChild_Goods.ChildObjectId
                                                  AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                              INNER JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                              AND Object_InfoMoney_View.InfoMoneyGroupId <> zc_Enum_InfoMoneyGroup_30000()             -- ������
                                                              AND Object_InfoMoney_View.InfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_20900() -- ������������� + ����

        WHERE _tmpItemPeresort_new.ReceipId_to <> 0


     IF EXISTS (SELECT 1 FROM _tmpItemPeresort_new) AND '01.10.2016' <= (SELECT OperDate FROM Movement WHERE Id = inMovementId)
     THEN
         -- ����������
         IF vbMovementId_Peresort <> 0
         THEN
             PERFORM lpUnComplete_Movement (inMovementId := vbMovementId_Peresort
                                          , inUserId     := inUserId
                                           );
         END IF;

         -- ����� MovementItemId - Master + Child
         UPDATE _tmpItemPeresort_new SET MovementItemId_to   = tmpMI.MovementItemId_to
                                       , MovementItemId_from = CASE WHEN _tmpItemPeresort_new.GoodsId_from = tmpMI.GoodsId_from AND _tmpItemPeresort_new.GoodsKindId_from = tmpMI.GoodsKindId_from
                                                                         THEN tmpMI.MovementItemId_from
                                                                    ELSE 0
                                                               END
         FROM (SELECT MovementItem.Id                                     AS MovementItemId_to
                    , MovementItem.ObjectId                               AS GoodsId_to
                    , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)       AS GoodsKindId_to
                    , MI_Child.Id                                         AS MovementItemId_from
                    , MI_Child.ObjectId                                   AS GoodsId_from
                    , COALESCE (MILinkObject_GoodsKind_Child.ObjectId, 0) AS GoodsKindId_from
                    , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId, COALESCE (MILinkObject_GoodsKind.ObjectId, 0)) AS Ord
               FROM MovementItem
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                     ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                    LEFT JOIN MovementItem AS MI_Child
                                           ON MI_Child.MovementId = vbMovementId_Peresort
                                          AND MI_Child.DescId     = zc_MI_Child()
                                          AND MI_Child.isErased   = FALSE
                                          AND MI_Child.ParentId   = MovementItem.Id
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind_Child
                                                     ON MILinkObject_GoodsKind_Child.MovementItemId = MI_Child.Id
                                                    AND MILinkObject_GoodsKind_Child.DescId = zc_MILinkObject_GoodsKind()
               WHERE MovementItem.MovementId = vbMovementId_Peresort
                 AND MovementItem.DescId     = zc_MI_Master()
                 AND MovementItem.isErased   = FALSE
              ) AS tmpMI
         WHERE _tmpItemPeresort_new.GoodsId_to     = tmpMI.GoodsId_to
           AND _tmpItemPeresort_new.GoodsKindId_to = tmpMI.GoodsKindId_to
           AND tmpMI.Ord                           = 1
        ;

         -- ��������� �������� - <������������ ����������> - �����������
         vbMovementId_Peresort:= lpInsertUpdate_Movement_ProductionUnion (ioId             := vbMovementId_Peresort
                                                                        , inInvNumber      := CASE WHEN vbMovementId_Peresort <> 0 THEN (SELECT InvNumber FROM Movement WHERE Id = vbMovementId_Peresort) ELSE CAST (NEXTVAL ('movement_ProductionUnion_seq') AS TVarChar) END
                                                                        , inOperDate       := (SELECT OperDate FROM Movement WHERE Id = inMovementId)
                                                                        , inFromId         := (SELECT ObjectId FROM MovementLinkObject AS MLO WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_From())
                                                                        , inToId           := (SELECT ObjectId FROM MovementLinkObject AS MLO WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_From())
                                                                        , inDocumentKindId := 0
                                                                        , inIsPeresort     := CASE WHEN EXISTS (SELECT 1 FROM _tmpItemPeresort_new AS tmp WHERE tmp.ReceipId_to <> 0) THEN FALSE ELSE TRUE END
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
                    , -- ��� ��-�� ����� � <���������>
                      lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Receipt(), tmp.MovementItemId_new, tmp.ReceipId_to)
               FROM
              (SELECT tmp.GoodsId_to, tmp.GoodsKindId_to, tmp.ReceipId_to
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
                                                 , inGoodsKindId            := tmp.GoodsKindId_to
                                                 , inUserId                 := inUserId
                                                  ) AS MovementItemId_new
               FROM (-- ����������� ����� ������ ��� ��� ��� ������������
                     SELECT DISTINCT _tmpItemPeresort_new.MovementItemId_to, _tmpItemPeresort_new.GoodsId_to, _tmpItemPeresort_new.GoodsKindId_to, _tmpItemPeresort_new.ReceipId_to, _tmpItemPeresort_new.Amount_to
                     FROM _tmpItemPeresort_new
                     WHERE _tmpItemPeresort_new.ReceipId_to >= 0
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
                                                 , inAmount                 := CASE -- ���� ��� ������������
                                                                                    WHEN _tmpItemPeresort_new.ReceipId_to < 0
                                                                                         THEN _tmpItemPeresort_new.Amount_to
                                                                                    -- ���� ��� �� ������������ � ���� ��������� � ���
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
                                                 , inGoodsKindId            := _tmpItemPeresort_new.GoodsKindId_from
                                                 , inGoodsKindCompleteId    := NULL
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

         -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
         PERFORM lpComplete_Movement_ProductionUnion_CreateTemp();
         -- ��������
         PERFORM lpComplete_Movement_ProductionUnion (inMovementId     := vbMovementId_Peresort
                                                    , inIsHistoryCost  := TRUE
                                                    , inUserId         := inUserId)
        ;
         -- !!!�����������!!! �������� ������� ��������
         DELETE FROM _tmpMIContainer_insert;
         DELETE FROM _tmpMIReport_insert;
         -- !!!�����������!!! ������� �������
         DROP TABLE _tmpItem_pr;
         DROP TABLE _tmpItemSumm_pr;
         DROP TABLE _tmpItemChild;
         DROP TABLE _tmpItemSummChild;
         DROP TABLE _tmpItem_Partion;
         DROP TABLE _tmpItem_Partion_child;


     ELSE
         IF vbMovementId_Peresort <> 0 AND zc_Enum_Status_Erased() <> (SELECT StatusId FROM Movement WHERE Id = vbMovementId_Peresort)
         THEN
             PERFORM lpSetErased_Movement (inMovementId := vbMovementId_Peresort
                                         , inUserId     := inUserId
                                          );
         END IF;

     END IF;
     END IF; -- if ... �������� ����������� - !!!������ ��� ����� ������!!!
     

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.08.16                                        *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_Sale_Recalc (inMovementId:= 4164174, inUnitId:= 8459, inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM gpReComplete_Movement_Sale (inMovementId:= 4164174, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
