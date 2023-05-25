-- Function: lpComplete_Movement_Send_Recalc (Integer, Boolean)

DROP FUNCTION IF EXISTS lpComplete_Movement_Send_Recalc (Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Send_Recalc(
    IN inMovementId        Integer  , -- ���� ���������
    IN inFromId            Integer  , -- ������� �������
    IN inToId              Integer  , -- ��� ...
    IN inUserId            Integer    -- ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbMovementId_Send_out Integer;
   DECLARE vbOperDate            TDateTime;
BEGIN
     -- ����� ����
     vbOperDate:= (SELECT OperDate FROM Movement WHERE Id = inMovementId);


     -- �������� ����������� - !!!������ ��� ����� ������!!!
     IF inFromId IN (635388 -- ������� �������
                    )
      AND inToId IN (8447 -- ��� ���������
                   , 8448 -- ��� �����������
                   , 8449 -- ��� �/�
                    )
        -- AND inUserId = 5
        AND NOT EXISTS (SELECT 1 FROM MovementLinkMovement AS MLM WHERE MLM.MovementId = inMovementId AND MLM.DescId = zc_MovementLinkMovement_Send() AND MLM.MovementChildId > 0)
        -- ����� "������� ����"
        AND     EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_DocumentKind() AND MLO.ObjectId = 635281)

     THEN

         -- ����� "������� �� ������� �������"
         vbMovementId_Send_out:= (SELECT MLM.MovementId FROM MovementLinkMovement AS MLM WHERE MLM.MovementChildId = inMovementId AND MLM.DescId = zc_MovementLinkMovement_Send());

         -- ������� - ��������
         CREATE TEMP TABLE _tmpItem_new (MovementItemId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;

         -- ��������
         INSERT INTO _tmpItem_new (MovementItemId, GoodsId, Amount)
            SELECT 0                                                      AS MovementItemId
                 , _tmpItem.GoodsId                                       AS GoodsId
                 , SUM (_tmpItem.OperCount)                               AS Amount
            FROM _tmpItem
            GROUP BY _tmpItem.GoodsId;


         IF EXISTS (SELECT 1 FROM _tmpItem_new)
         THEN
             -- ����� MovementItemId - Master
             UPDATE _tmpItem_new SET MovementItemId   = tmpMI.MovementItemId
             FROM (SELECT MovementItem.Id       AS MovementItemId
                        , MovementItem.ObjectId AS GoodsId
                        , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId) AS Ord
                   FROM MovementItem
                   WHERE MovementItem.MovementId = vbMovementId_Send_out
                     AND MovementItem.DescId     = zc_MI_Master()
                     AND MovementItem.isErased   = FALSE
                  ) AS tmpMI
             WHERE _tmpItem_new.GoodsId = tmpMI.GoodsId
               AND tmpMI.Ord            = 1
            ;


             -- �������� - ��� � ������ �� ������
             IF vbMovementId_Send_out <> 0
             THEN
                IF -- ���� ��� ��������� ������� ���� ��������
                   NOT EXISTS (SELECT 1 FROM _tmpItem_new WHERE MovementItemId = 0)
                   -- ���� ��� ��������� Master
               AND NOT EXISTS (SELECT 1 FROM MovementItem LEFT JOIN _tmpItem_new ON _tmpItem_new.MovementItemId = MovementItem.Id
                               WHERE MovementItem.MovementId = vbMovementId_Send_out AND MovementItem.isErased   = FALSE AND _tmpItem_new.MovementItemId IS NULL)
                   -- ���� �� ��������� Master ��� ��������� � ���-��
               AND NOT EXISTS (SELECT 1 FROM MovementItem INNER JOIN _tmpItem_new ON _tmpItem_new.MovementItemId = MovementItem.Id
                               WHERE MovementItem.MovementId = vbMovementId_Send_out AND MovementItem.Amount <> _tmpItem_new.Amount)
                   -- ToId + FromId
               AND inToId   = COALESCE ((SELECT ObjectId FROM MovementLinkObject AS MLO WHERE MovementId = vbMovementId_Send_out AND DescId = zc_MovementLinkObject_From()), 0)
               AND inFromId = COALESCE ((SELECT ObjectId FROM MovementLinkObject AS MLO WHERE MovementId = vbMovementId_Send_out AND DescId = zc_MovementLinkObject_To()), 0)
                   -- StatusId
               AND zc_Enum_Status_Complete() = (SELECT StatusId FROM Movement WHERE Movement.Id = vbMovementId_Send_out)

                THEN
                    -- ������ ������ �������
                    -- if inUserId = 5 then RAISE EXCEPTION 'OK - �������� - ��� � ������ �� ������'; end if;
                    -- !!!�����!!!
                    RETURN;
                END IF;

                -- ������ ������ �������
                -- if inUserId = 5 then RAISE EXCEPTION '������ - ��� �������� - ��� � ������ �� ������  <%>', (SELECT COUNT(*) FROM _tmpItem_new); end if;

             END IF;


             -- ����������
             IF vbMovementId_Send_out <> 0
             THEN
                 PERFORM lpUnComplete_Movement (inMovementId := vbMovementId_Send_out
                                              , inUserId     := inUserId
                                               );
             END IF;


             -- ��������� �������� - <Send>
             vbMovementId_Send_out:= lpInsertUpdate_Movement_Send
                                          (ioId               := vbMovementId_Send_out
                                         , inInvNumber        := CASE WHEN vbMovementId_Send_out <> 0 THEN (SELECT InvNumber FROM Movement WHERE Id = vbMovementId_Send_out) ELSE CAST (NEXTVAL ('movement_Send_seq') AS TVarChar) END
                                         , inOperDate         := vbOperDate
                                         , inFromId           := inToId
                                         , inToId             := inFromId
                                         , inDocumentKindId   := (SELECT ObjectId  FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_DocumentKind())
                                         , inSubjectDocId     := (SELECT ObjectId  FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_SubjectDoc())
                                         , inComment          := (SELECT ValueData FROM MovementString     WHERE MovementId = inMovementId AND DescId = zc_MovementString_Comment())
                                         , inUserId           := inUserId
                                          );
             -- ��������� �������� <������������� �����������>
             PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), vbMovementId_Send_out, TRUE);

             -- ��������� �������� - Master
             PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id
                                             , inUserId        := inUserId
                                              )
             FROM MovementItem
                  LEFT JOIN (SELECT MovementItemId FROM _tmpItem_new) AS tmp ON tmp.MovementItemId = MovementItem.Id
             WHERE MovementItem.MovementId = vbMovementId_Send_out
               AND MovementItem.isErased   = FALSE
               AND tmp.MovementItemId IS NULL
            ;

             -- ��������� � ����. �������� - Master
             PERFORM lpInsertUpdate_MovementItem_Send
                                           (ioId                  := _tmpItem_new.MovementItemId
                                          , inMovementId          := vbMovementId_Send_out
                                          , inGoodsId             := _tmpItem_new.GoodsId
                                          , inAmount              := _tmpItem_new.Amount
                                          , inPartionGoodsDate    := NULL
                                          , inCount               := 0
                                          , inHeadCount           := 0
                                          , ioPartionGoods        := ''
                                          , ioPartNumber          := ''
                                          , inGoodsKindId         := NULL
                                          , inGoodsKindCompleteId := NULL
                                          , inAssetId             := NULL
                                          , inAssetId_two         := NULL
                                          , inUnitId              := NULL
                                          , inStorageId           := NULL
                                          , inPartionModelId      := NULL
                                          , inPartionGoodsId      := NULL
                                          , inUserId              := inUserId
                                            )
             FROM _tmpItem_new
            ;

             -- ��������� ����� ����������
             PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Send(), vbMovementId_Send_out, inMovementId);

             -- ��������
             PERFORM gpComplete_Movement_Send (inMovementId     := vbMovementId_Send_out
                                             , inIsLastComplete := TRUE
                                             , inSession        := lfGet_User_Session (inUserId)
                                              )
            ;

         ELSE
             IF vbMovementId_Send_out <> 0 AND zc_Enum_Status_Erased() <> (SELECT StatusId FROM Movement WHERE Id = vbMovementId_Send_out)
             THEN
                 PERFORM lpSetErased_Movement (inMovementId := vbMovementId_Send_out
                                             , inUserId     := inUserId
                                              );
             END IF;

         END IF;

     END IF; -- if ... �������� ����������� - !!!������ ��� ����� ������!!!

     -- ������ ������ �������
     -- if inUserId = 5 then RAISE EXCEPTION '��� ���� � ��� �������� - ��� � ������ �� ������'; end if;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.03.19                                        *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_Send_Recalc (inMovementId:= 4691383, inUnitId:= 8459, inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM gpReComplete_Movement_Send (inMovementId:= 4691383, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
