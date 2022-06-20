-- Function: gpUpdateMIChild_OrderExternal_AmountSecond()

DROP FUNCTION IF EXISTS gpUpdateMIChild_OrderExternal_AmountSecond (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdateMIChild_OrderExternal_AmountSecond(
    IN inMovementId      Integer      , -- ���� ���������
    IN inSession         TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbToId Integer;
BEGIN
--return;
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderExternalUnit());


      -- �������� - ��� � �� ���������� ��� ����
      /*IF EXISTS (SELECT Id FROM MovementItem WHERE isErased = FALSE AND DescId = zc_MI_Master() AND MovementId = inMovementId AND Amount <> 0)
         THEN RAISE EXCEPTION '������.� ��������� ��� ���� ������.'; 
      END IF;
      */
      
      -- 8458 "����� ���� ��"
      
     -- ������ �� ��������� 
      SELECT Movement.OperDate                 AS OperDate
           , MLO_To.ObjectId                   AS ToId
         INTO  vbOperDate, vbToId
      FROM Movement 
            LEFT JOIN MovementLinkObject AS MLO_To
                                         ON MLO_To.MovementId = Movement.Id
                                        AND MLO_To.DescId = zc_MovementLinkObject_To()
      WHERE Movement.Id = inMovementId;
               
       -- ������ �� ������� +  ������ ����������� �� ����� ��   ����� �� ���� ���� ������ � ������� ���� zc_MI_Child.AmountSecond
       CREATE TEMP TABLE tmpMIMaster (GoodsId Integer, GoodsKindId Integer, MovementId_send Integer, Amount TFloat, Amount_diff TFloat, Amount_send TFloat, AmountSecond TFloat) ON COMMIT DROP;
       INSERT INTO tmpMIMaster (GoodsId, GoodsKindId, MovementId_send,  Amount, Amount_diff, Amount_send, AmountSecond)                    
  
        WITH
        tmpMI AS (SELECT MovementItem.Id
                       , MovementItem.ObjectId                         AS GoodsId
                       , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                       , MovementItem.Amount
                  FROM MovementItem   
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                        ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                  WHERE MovementItem.MovementId = inMovementId
                    AND MovementItem.DescId = zc_MI_Master()
                    AND MovementItem.isErased = FALSE
                  ) 
       
        -- ��� ������ � ������� ���� zc_MI_Child.AmountSecond �� ���� ���� 
      , tmpMIChild_All AS (SELECT MovementItem.ObjectId                         AS GoodsId
                                , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                , SUM (COALESCE (MovementItem.Amount,0))        AS Amount
                                , SUM (COALESCE (MIFloat_AmountSecond.ValueData,0)) AS AmountSecond
                           FROM Movement
                                INNER JOIN MovementLinkObject AS MLO_To
                                                              ON MLO_To.MovementId = Movement.Id
                                                             AND MLO_To.DescId = zc_MovementLinkObject_To()
                                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId = zc_MI_Child()
                                                       AND MovementItem.isErased = FALSE
                                INNER JOIN (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI) AS tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId 

                               LEFT JOIN tmpMI_Float AS MIFloat_AmountSecond
                                                     ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                    AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()

                                LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                 ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                           WHERE Movement.OperDate = vbOperDate
                             AND Movement.DescId = zc_Movement_OrderExternal()
                             AND Movement.StatusId = zc_Enum_Status_Complete()
                             AND MLO_To.ObjectId = vbToId
                             AND Movement.Id <> inMovementId
                           )                    
        --  ������ ����������� �� ����� ��
      , tmpSendIn AS (SELECT Movement.Id                                   AS MovementId
                           , MovementItem.ObjectId                         AS GoodsId
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                           , MovementItem.Amount
                      FROM Movement
                           INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                  AND MovementItem.DescId = zc_MI_Child()
                                                  AND MovementItem.isErased = FALSE
                           INNER JOIN (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI) AS tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId

                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                      WHERE Movement.OperDate = vbOperDate
                        AND Movement.DescId = zc_Movement_Send()
                        AND Movement.StatusId = zc_Enum_Status_Complete()
                        AND MLO_To.ObjectId = 8458    --"����� ���� ��"
                      )

         SELECT tmpMI.Id 
              , tmpMI.GoodsId
              , tmpMI.GoodsKindId
              , tmpSendIn.MovementId AS MovementId_send
              , tmpMI.Amount
              , (COALESCE (tmpSendIn.Amount,0) - COALESCE (tmpMIChild_All.AmountSecond,0)) AS Amount_diff 
              , COALESCE (tmpSendIn.Amount,0)                                        AS Amount_send
              , COALESCE (tmpMIChild_All.AmountSecond,0))                            AS AmountSecond
         FROM tmpMI
              LEFT JOIN tmpSendIn ON tmpSendIn.GoodsId = tmpMI.GoodsId
                                 AND tmpSendIn.GoodsKindId = tmpMI.GoodsKindId
              LEFT JOIN tmpMIChild_All ON tmpMIChild_All.GoodsId = tmpMI.GoodsId
                                      AND tmpMIChild_All.GoodsKindId = tmpMI.GoodsKindId

         ;


   -- ���������
   PERFORM lpInsertUpdate_MI_OrderExternal_Child (ioId                 := COALESCE (MovementItem.Id, 0) :: integer
                                                , inMovementId         := inMovementId
                                                , inGoodsId            := MovementItem.ObjectId
                                                , inAmount             :=  COALESCE (MovementItem.Amount,0) 
                                                                       -- ���� ������� > (����� � ������ - zc_MI_Child.Amount), ����� zc_MI_Child.AmountSecond =  (����� � ������ - zc_MI_Child.Amount) ����� ����������� + ��� ����  ��������� zc_MIFloat_MovementId
                                                , inAmountSecond       := CASE WHEN COALESCE (tmpMIMaster.Amount_send,0) > COALESCE (MovementItem.Amount,0) THEN COALESCE (tmpMIMaster.Amount,0) - COALESCE (MovementItem.Amount,0)
                                                                               ELSE COALESCE (tmpMIMaster.Amount_send,0) END :: TFloat  
                                                , inGoodsKindId        := tmpMI.GoodsKindId 
                                                , inMovementId_Send    := CASE WHEN COALESCE (tmpMIMaster.Amount_send,0) > COALESCE (MovementItem.Amount,0) THEN 0 ELSE tmpMIMaster.MovementId_send END
                                                , inUserId             := vbUserId
                                                )
     FROM MovementItem   
          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
          LEFT JOIN tmpMIMaster ON tmpMIMaster.GoodsId = MovementItem.ObjectId
                               AND tmpMIMaster.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId = zc_MI_Child()
       AND MovementItem.isErased = FALSE
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