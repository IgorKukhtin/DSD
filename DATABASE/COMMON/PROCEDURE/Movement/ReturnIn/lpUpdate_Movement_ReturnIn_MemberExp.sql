-- Function: lpUpdate_Movement_ReturnIn_Auto()

DROP FUNCTION IF EXISTS lpUpdate_Movement_ReturnIn_MemberExp (Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Movement_ReturnIn_MemberExp(
    IN inMovementId          Integer   , -- ���� ���������
    IN inUserId              Integer     -- ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbMovementId_Sale  Integer;
   DECLARE vbMemberExpId      Integer;
BEGIN
     -- ������� 1 �� ������ ��������� (���. �������) �� �������
     vbMovementId_Sale := (SELECT MIFloat_MovementId.ValueData :: Integer AS MovementId_Sale
                           FROM MovementItem
                                INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                                             ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                            AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
                                                            AND MIFloat_MovementId.ValueData > 0
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = FALSE
                           ORDER BY MovementItem.Id DESC
                           LIMIT 1
                          );

     -- ���� ������ ������� �� ������
     IF COALESCE (vbMovementId_Sale, 0) = 0 
     THEN
         vbMovementId_Sale := (SELECT MIFloat_MovementId.ValueData      :: Integer AS MovementId_Sale
                               FROM MovementItem  
                                    INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                                                 ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                                AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()   
                                                                AND MIFloat_MovementId.ValueData > 0                      
                               WHERE MovementItem.MovementId = inMovementId
                                 AND MovementItem.DescId     = zc_MI_Child()
                                 AND MovementItem.isErased   = FALSE
                               LIMIT 1
                               );
     END IF;
     
     -- ��� ������� �������� ����������� �� "������ ��������� �� ����������"
     vbMemberExpId := (SELECT MovementLinkObject_Personal.ObjectId AS MemberExpId
                       FROM MovementLinkMovement AS MovementLinkMovement_Order
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                                         ON MovementLinkObject_Personal.MovementId = MovementLinkMovement_Order.MovementChildId
                                                        AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
                       WHERE MovementLinkMovement_Order.MovementId = vbMovementId_Sale
                         AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                       );
                       
     -- ��������� �������� <���������� ���� (����������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_MemberExp(), inMovementId, vbMemberExpId);

     -- ��������� ��������
     -- PERFORM lpInsert_MovementProtocol (inMovementId, inUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.05.18         *
*/

-- ����
-- SELECT * FROM lpUpdate_Movement_ReturnIn_MemberExp (5605163, 5)
